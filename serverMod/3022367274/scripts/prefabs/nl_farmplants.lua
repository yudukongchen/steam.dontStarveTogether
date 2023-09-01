local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS

local assets_resource = {
    Asset("ANIM", "anim/nl_plants.zip"),
}

local OVERSIZED_PHYSICS_RADIUS = 0.1
local OVERSIZED_MAXWORK = 1
local OVERSIZED_PERISHTIME_MULT = 4

local function can_plant_seed(inst, pt, mouseover, deployer)
    local x, z = pt.x, pt.z
    return TheWorld.Map:CanTillSoilAtPoint(x, 0, z, true)
end

local function OnDeploy(inst, pt, deployer) --, rot)
    local plant = SpawnPrefab(inst.components.farmplantable.plant)
    plant.Transform:SetPosition(pt.x, 0, pt.z)
    plant:PushEvent("on_planted", {in_soil = false, doer = deployer, seed = inst})
    TheWorld.Map:CollapseSoilAtPoint(pt.x, 0, pt.z)
    --plant.SoundEmitter:PlaySound("dontstarve/wilson/plant_seeds")
    inst:Remove()

    --[[
        local plant = SpawnPrefab("plant_normal_ground")
        plant.components.crop:StartGrowing(inst.components.plantable.product, inst.components.plantable.growtime)
        plant.Transform:SetPosition(pt.x, 0, pt.z)
        plant.SoundEmitter:PlaySound("dontstarve/wilson/plant_seeds")
        inst:Remove()
    ]]
end

local function oversized_calcweightcoefficient(name)
    if PLANT_DEFS[name].weight_data[3] ~= nil and math.random() < PLANT_DEFS[name].weight_data[3] then
        return (math.random() + math.random()) / 2
    else
        return math.random()
    end
end

local function oversized_onequip(inst, owner)
    if PLANT_DEFS[inst._base_name].build ~= nil then
        owner.AnimState:OverrideSymbol("swap_body", PLANT_DEFS[inst._base_name].build, "swap_body")
    else
        owner.AnimState:OverrideSymbol("swap_body", "farm_plant_" .. inst._base_name, "swap_body")
    end
end

local function oversized_onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
end

local function oversized_onfinishwork(inst, chopper)
    inst.components.lootdropper:DropLoot()
    inst:Remove()
end

local function oversized_onburnt(inst)
    inst.components.lootdropper:DropLoot()
    inst:Remove()
end

local function oversized_makeloots(inst, name)
    local product = name
    local seeds = name .. "_seeds"
    return { product, product, seeds, seeds, math.random() < 0.75 and product or seeds}
end

local function oversized_onperish(inst)
    if inst.components.inventoryitem:GetGrandOwner() ~= nil then
        local loots = {}
        for i = 1, #inst.components.lootdropper.loot do
            table.insert(loots, "spoiled_food")
        end
        inst.components.lootdropper:SetLoot(loots)
        inst.components.lootdropper:DropLoot()
    else
        SpawnPrefab(inst.prefab .. "_rotten").Transform:SetPosition(inst.Transform:GetWorldPosition())
    end

    inst:Remove()
end

local function Seed_GetDisplayName(inst)
    local registry_key = inst.plant_def.product

    local plantregistryinfo = inst.plant_def.plantregistryinfo
    return (ThePlantRegistry:KnowsSeed(registry_key, plantregistryinfo) and ThePlantRegistry:KnowsPlantName(registry_key, plantregistryinfo)) and STRINGS.NAMES["KNOWN_"..string.upper(inst.prefab)]
            or nil
end

local function Oversized_OnSave(inst, data)
    data.from_plant = inst.from_plant or false
    data.harvested_on_day = inst.harvested_on_day
end

local function Oversized_OnPreLoad(inst, data)
    inst.from_plant = (data and data.from_plant) ~= false
    if data ~= nil then
        inst.harvested_on_day = data.harvested_on_day
    end
end

local function displayadjectivefn(inst)
    return STRINGS.UI.HUD.WAXED
end

local function dowaxfn(inst, doer, waxitem)
    local waxedveggie = SpawnPrefab(inst.prefab .. "_waxed")
    if doer.components.inventory and doer.components.inventory:IsHeavyLifting() and doer.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) == inst then
        doer.components.inventory:Unequip(EQUIPSLOTS.BODY)
        doer.components.inventory:Equip(waxedveggie)
    else
        waxedveggie.Transform:SetPosition(inst.Transform:GetWorldPosition())
        waxedveggie.AnimState:PlayAnimation("wax_oversized", false)
        waxedveggie.AnimState:PushAnimation("idle_oversized")
    end
    inst:Remove()
    return true
end

local PlayWaxAnimation

local function CancelWaxTask(inst)
    if inst._waxtask ~= nil then
        inst._waxtask:Cancel()
        inst._waxtask = nil
    end
end

local function StartWaxTask(inst)
    if not inst.inlimbo and inst._waxtask == nil then
        inst._waxtask = inst:DoTaskInTime(GetRandomMinMax(20, 40), PlayWaxAnimation)
    end
end

PlayWaxAnimation = function(inst)
    inst.AnimState:PlayAnimation("wax_oversized", false)
    inst.AnimState:PushAnimation("idle_oversized")
end

local function MakeVeggie(name)
    local assets_oversized = {
        Asset("ANIM", "anim/" .. PLANT_DEFS[name].build .. ".zip"),
    }

    local function fn_seeds()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("nl_plants")
        inst.AnimState:SetBuild("nl_plants")
        inst.AnimState:PlayAnimation(name .. "_seeds")
        inst.AnimState:SetRayTestOnBB(true)

        --cookable (from cookable component) added to pristine state for optimization
        inst:AddTag("cookable")
        inst:AddTag("deployedplant")
        inst:AddTag("deployedfarmplant")

        inst.overridedeployplacername = "seeds_placer"

        inst.plant_def = PLANT_DEFS[name]
        inst.displaynamefn = Seed_GetDisplayName

        inst._custom_candeploy_fn = can_plant_seed -- for DEPLOYMODE.CUSTOM

        MakeInventoryFloatable(inst)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("edible")
        inst.components.edible.foodtype = FOODTYPE.SEEDS

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("tradable")
        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = "images/"..name.."_seeds"..".xml"

        inst.components.edible.healthvalue = TUNING.HEALING_TINY / 2
        inst.components.edible.hungervalue = TUNING.CALORIES_TINY

        inst:AddComponent("perishable")
        inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW)
        inst.components.perishable:StartPerishing()
        inst.components.perishable.onperishreplacement = "spoiled_food"

        inst:AddComponent("cookable")
        inst.components.cookable.product = "seeds_cooked"

        inst:AddComponent("bait")

        inst:AddComponent("farmplantable")
        inst.components.farmplantable.plant = "farm_plant_" .. name

        -- deprecated (used for crafted farm structures)
        inst:AddComponent("plantable")
        inst.components.plantable.growtime = TUNING.SEEDS_GROW_TIME
        inst.components.plantable.product = name

        -- deprecated (used for wormwood)
        inst:AddComponent("deployable")
        inst.components.deployable:SetDeployMode(DEPLOYMODE.CUSTOM) -- use inst._custom_candeploy_fn
        inst.components.deployable.restrictedtag = "plantkin"
        inst.components.deployable.ondeploy = OnDeploy

        MakeSmallBurnable(inst)
        MakeSmallPropagator(inst)

        MakeHauntableLaunchAndPerish(inst)

        return inst
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("nl_plants")
        inst.AnimState:SetBuild("nl_plants")
        inst.AnimState:PlayAnimation(name)

        --cookable (from cookable component) added to pristine state for optimization
        inst:AddTag("cookable")

        local float = NL_VEGGIES[name].float_settings
        if float ~= nil then
            MakeInventoryFloatable(inst, float[1], float[2], float[3])
        else
            MakeInventoryFloatable(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("edible")
        inst.components.edible.healthvalue = NL_VEGGIES[name].health
        inst.components.edible.hungervalue = NL_VEGGIES[name].hunger
        inst.components.edible.sanityvalue = NL_VEGGIES[name].sanity or 0
        inst.components.edible.foodtype = FOODTYPE.VEGGIE
        inst.components.edible.secondaryfoodtype = NL_VEGGIES[name].secondary_foodtype

        inst:AddComponent("perishable")
        inst.components.perishable:SetPerishTime(NL_VEGGIES[name].perishtime)
        inst.components.perishable:StartPerishing()
        inst.components.perishable.onperishreplacement = "spoiled_food"

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = "images/"..name..".xml"

        MakeSmallBurnable(inst)
        MakeSmallPropagator(inst)
        ---------------------

        inst:AddComponent("bait")

        ------------------------------------------------
        inst:AddComponent("tradable")

        ------------------------------------------------

        inst:AddComponent("cookable")
        inst.components.cookable.product = name .. "_cooked"

        MakeHauntableLaunchAndPerish(inst)

        return inst
    end

    local function fn_cooked()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("nl_plants")
        inst.AnimState:SetBuild("nl_plants")
        inst.AnimState:PlayAnimation(name .. "_cooked")

        local float = NL_VEGGIES[name].cooked_float_settings
        if float ~= nil then
            MakeInventoryFloatable(inst, float[1], float[2], float[3])
        else
            MakeInventoryFloatable(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("perishable")
        inst.components.perishable:SetPerishTime(NL_VEGGIES[name].cooked_perishtime)
        inst.components.perishable:StartPerishing()
        inst.components.perishable.onperishreplacement = "spoiled_food"

        inst:AddComponent("edible")
        inst.components.edible.healthvalue = NL_VEGGIES[name].cooked_health
        inst.components.edible.hungervalue = NL_VEGGIES[name].cooked_hunger
        inst.components.edible.sanityvalue = NL_VEGGIES[name].cooked_sanity or 0
        inst.components.edible.foodtype = FOODTYPE.VEGGIE
        inst.components.edible.secondaryfoodtype = NL_VEGGIES[name].secondary_foodtype

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = "images/"..name.."_cooked"..".xml"

        MakeSmallBurnable(inst)
        MakeSmallPropagator(inst)
        ---------------------

        inst:AddComponent("bait")

        ------------------------------------------------
        inst:AddComponent("tradable")

        MakeHauntableLaunchAndPerish(inst)

        return inst
    end

   
    local function fn_oversized()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        local plant_def = PLANT_DEFS[name]

        inst.AnimState:SetBank(plant_def.bank)
        inst.AnimState:SetBuild(plant_def.build)
        inst.AnimState:PlayAnimation("idle_oversized")

        inst:AddTag("heavy")
        inst:AddTag("waxable")
        inst:AddTag("show_spoilage")

        MakeHeavyObstaclePhysics(inst, OVERSIZED_PHYSICS_RADIUS)
        inst:SetPhysicsRadiusOverride(OVERSIZED_PHYSICS_RADIUS)

        inst._base_name = name

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.harvested_on_day = inst.harvested_on_day or (TheWorld.state.cycles + 1)

        inst:AddComponent("heavyobstaclephysics")
        inst.components.heavyobstaclephysics:SetRadius(OVERSIZED_PHYSICS_RADIUS)
        inst.components.heavyobstaclephysics:MakeSmallObstacle()

        inst:AddComponent("perishable")
        inst.components.perishable:SetPerishTime(NL_VEGGIES[name].perishtime * OVERSIZED_PERISHTIME_MULT)
        inst.components.perishable:StartPerishing()
        inst.components.perishable.onperishreplacement = nil
        inst.components.perishable:SetOnPerishFn(oversized_onperish)

        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.cangoincontainer = false
        inst.components.inventoryitem:SetSinks(true)

        inst:AddComponent("equippable")
        inst.components.equippable.equipslot = EQUIPSLOTS.BODY
        inst.components.equippable:SetOnEquip(oversized_onequip)
        inst.components.equippable:SetOnUnequip(oversized_onunequip)
        inst.components.equippable.walkspeedmult = TUNING.HEAVY_SPEED_MULT

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetOnFinishCallback(oversized_onfinishwork)
        inst.components.workable:SetWorkLeft(OVERSIZED_MAXWORK)

        inst:AddComponent("waxable")
        inst.components.waxable:SetWaxfn(dowaxfn)

        inst:AddComponent("submersible")
        inst:AddComponent("symbolswapdata")
        inst.components.symbolswapdata:SetData(plant_def.build, "swap_body")

        local weight_data = plant_def.weight_data
        inst:AddComponent("weighable")
        inst.components.weighable.type = TROPHYSCALE_TYPES.OVERSIZEDVEGGIES
        inst.components.weighable:Initialize(weight_data[1], weight_data[2])
        local coefficient = oversized_calcweightcoefficient(name)
        inst.components.weighable:SetWeight(Lerp(weight_data[1], weight_data[2], coefficient))

        inst:AddComponent("lootdropper")
        inst.components.lootdropper:SetLoot(oversized_makeloots(inst, name))

        MakeMediumBurnable(inst)
        inst.components.burnable:SetOnBurntFn(oversized_onburnt)
        MakeMediumPropagator(inst)

        MakeHauntableWork(inst)

        inst.from_plant = false

        inst.OnSave = Oversized_OnSave
        inst.OnPreLoad = Oversized_OnPreLoad

        return inst
    end

    local function fn_oversized_waxed()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        local plant_def = PLANT_DEFS[name]

        inst.AnimState:SetBank(plant_def.bank)
        inst.AnimState:SetBuild(plant_def.build)
        inst.AnimState:PlayAnimation("idle_oversized")

        inst:AddTag("heavy")

        inst.displayadjectivefn = displayadjectivefn
        inst:SetPrefabNameOverride(name .. "_oversized")

        MakeHeavyObstaclePhysics(inst, OVERSIZED_PHYSICS_RADIUS)
        inst:SetPhysicsRadiusOverride(OVERSIZED_PHYSICS_RADIUS)

        inst._base_name = name

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("heavyobstaclephysics")
        inst.components.heavyobstaclephysics:SetRadius(OVERSIZED_PHYSICS_RADIUS)
        inst.components.heavyobstaclephysics:MakeSmallObstacle()

        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.cangoincontainer = false
        inst.components.inventoryitem:SetSinks(true)

        inst:AddComponent("equippable")
        inst.components.equippable.equipslot = EQUIPSLOTS.BODY
        inst.components.equippable:SetOnEquip(oversized_onequip)
        inst.components.equippable:SetOnUnequip(oversized_onunequip)
        inst.components.equippable.walkspeedmult = TUNING.HEAVY_SPEED_MULT

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetOnFinishCallback(oversized_onfinishwork)
        inst.components.workable:SetWorkLeft(OVERSIZED_MAXWORK)

        inst:AddComponent("submersible")
        inst:AddComponent("symbolswapdata")
        inst.components.symbolswapdata:SetData(plant_def.build, "swap_body")

        inst:AddComponent("lootdropper")
        inst.components.lootdropper:SetLoot({"spoiled_food"})

        MakeMediumBurnable(inst)
        inst.components.burnable:SetOnBurntFn(oversized_onburnt)
        MakeMediumPropagator(inst)

        MakeHauntableWork(inst)

        inst:ListenForEvent("onputininventory", CancelWaxTask)
        inst:ListenForEvent("ondropped", StartWaxTask)

        inst.OnEntitySleep = CancelWaxTask
        inst.OnEntityWake = StartWaxTask

        StartWaxTask(inst)

        return inst
    end

    local function fn_oversized_rotten()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeObstaclePhysics(inst, OVERSIZED_PHYSICS_RADIUS)

        local plant_def = PLANT_DEFS[name]

        inst.AnimState:SetBank(plant_def.bank)
        inst.AnimState:SetBuild(plant_def.build)
        inst.AnimState:PlayAnimation("idle_rot_oversized")

        inst:AddTag("farm_plant_killjoy")
        inst:AddTag("pickable_harvest_str")
        inst:AddTag("pickable")

        inst._base_name = name

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")
        inst.components.inspectable.nameoverride = "VEGGIE_OVERSIZED_ROTTEN"

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetOnFinishCallback(oversized_onfinishwork)
        inst.components.workable:SetWorkLeft(OVERSIZED_MAXWORK)

        inst:AddComponent("pickable")
        inst.components.pickable.onpickedfn = inst.Remove
        inst.components.pickable:SetUp(nil)
        inst.components.pickable.use_lootdropper_for_product = true
        inst.components.pickable.picksound = "dontstarve/wilson/harvest_berries"

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.cangoincontainer = false
        inst.components.inventoryitem.canbepickedup = false
        inst.components.inventoryitem:SetSinks(true)

        inst:AddComponent("lootdropper")
        inst.components.lootdropper:SetLoot(plant_def.loot_oversized_rot)

        MakeMediumBurnable(inst)
        inst.components.burnable:SetOnBurntFn(oversized_onburnt)
        MakeMediumPropagator(inst)

        MakeHauntableWork(inst)

        return inst
    end

    local exported_prefabs = {}

    table.insert(exported_prefabs, Prefab(name .. "_seeds", fn_seeds, assets_resource))
    table.insert(exported_prefabs, Prefab(name .. "_oversized", fn_oversized, assets_oversized))
    table.insert(exported_prefabs, Prefab(name .. "_oversized_waxed", fn_oversized_waxed, assets_oversized))
    table.insert(exported_prefabs, Prefab(name .. "_oversized_rotten", fn_oversized_rotten, assets_oversized))

    table.insert(exported_prefabs, Prefab(name, fn, assets_resource))
    table.insert(exported_prefabs, Prefab(name .. "_cooked", fn_cooked, assets_resource))

    return exported_prefabs
end

local prefs = {}
for veggiename, veggiedata in pairs(NL_VEGGIES) do
    local veggies = MakeVeggie(veggiename)
    for _, v in ipairs(veggies) do
        table.insert(prefs, v)
    end
end

return unpack(prefs)
