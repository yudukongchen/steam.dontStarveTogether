----------------------
----updated by HWY----
----------------------
GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})
--add
local lan = GetModConfigData("language")
local mode = GetModConfigData("mode")
local stone = GetModConfigData("stone")
local plant = GetModConfigData("plant")

Assets = 
{
	Asset("IMAGE", "images/inventoryimages/superfarm.tex"),
	Asset("ATLAS", "images/inventoryimages/superfarm.xml"),
	Asset("IMAGE", "images/inventoryimages/superfarmmini.tex"),
	Asset("ATLAS", "images/inventoryimages/superfarmmini.xml"),
	Asset("ANIM", "anim/bg_5x5.zip"),	
}
AddMinimapAtlas("images/inventoryimages/superfarmmini.xml")
modimport("scripts/ui_alter.lua")

--Efficient agriculture support
local easing = require("easing")
local function setseedsmanchine(inst)
local FIRE_RANGE = 20
if TUNING.IS_NEW_AGRICULTURE then
    FIRE_RANGE = 15
end

local function OnHitSeed(inst, attacker, target)
    if (inst.target.prefab == "slow_farmplot" or inst.target.prefab == "fast_farmplot" or inst.target.prefab == "farmplot_spot") and inst.target.components.grower then      --旧农场
        inst.target.components.grower:PlantItem(inst, attacker.planter)
        inst:Remove()
    end
    if inst.target and (inst.target.prefab == "farm_soil" or inst.target.prefab == "superfarm_soil") and inst.components.farmplantable then   --新农场
        inst.components.farmplantable:Plant(inst.target, attacker.planter)
    else
        inst:RemoveComponent("complexprojectile")
        inst:RemoveComponent("locomotor")
        inst:RemoveTag("projectile")
        inst.Physics:SetActive(false)
    end
end

local function LaunchProjectile(inst, targetpos, target)
    local x, y, z = inst.Transform:GetWorldPosition()

    if target == nil then       --新农场在种植后会移除farm_soli
        --print("target为空，发射失败")   --print
        return
    end     

    if (target.prefab == "slow_farmplot" or target.prefab == "fast_farmplot" or target.prefab == "farmplot_spot") and not (target.components.grower:IsEmpty() and target.components.grower:IsFertile()) then
            return  --如果农场临时发生变化不能种植了，则不发射
    end

    local item = inst.components.container:GetItemInSlot(1)
    if item then
        local projectile = inst.components.container:RemoveItem(item)
        projectile.Transform:SetPosition(x, y, z)
        projectile.target = target

        if not projectile.Physics then
            projectile.entity:AddPhysics()
            projectile.Physics:SetMass(1)
            projectile.Physics:SetFriction(0)
            projectile.Physics:SetDamping(0)
            projectile.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
            projectile.Physics:ClearCollisionMask()
            projectile.Physics:CollidesWith(COLLISION.GROUND)
            projectile.Physics:SetCapsule(0.2, 0.2)
            projectile.Physics:SetDontRemoveOnSleep(true)
        end
        if not projectile:HasTag("projectile") then
            projectile:AddTag("projectile")
        end
        if not projectile.components.complexprojectile then
            projectile:AddComponent("locomotor")
            projectile:AddComponent("complexprojectile")
            projectile.components.complexprojectile:SetHorizontalSpeed(15)
            projectile.components.complexprojectile:SetGravity(-25)
            projectile.components.complexprojectile:SetLaunchOffset(Vector3(0, 3, 0))
            projectile.components.complexprojectile:SetOnHit(OnHitSeed)
        end

        local dx = targetpos.x - x
        local dz = targetpos.z - z
        local rangesq = dx * dx + dz * dz
        local maxrange = FIRE_RANGE
        local speed = easing.linear(rangesq, 25, 3, maxrange * maxrange)

        projectile.components.complexprojectile:SetHorizontalSpeed(speed)
        projectile.components.complexprojectile:SetGravity(-25)
        -- local remove_item = inst.components.container:RemoveItem(item, false)   --接收从容器移除的种子
        -- if remove_item then     --从世界中移除它
        --     remove_item:Remove()
        -- end
        inst.AnimState:PlayAnimation("seed")
        inst.AnimState:PushAnimation("idle")
        projectile.components.complexprojectile:Launch(targetpos, inst, inst)

        -- local item_now = inst.components.container:GetItemInSlot(1)
        -- if item_now and item_now.components.complexprojectile then
        --     item_now:RemoveComponent("complexprojectile")
        --     item_now:RemoveTag("projectile")
        --     item_now.entity:RemovePhysics()
        -- end
    end
end

local function CheckForFarm(inst, planter)
    if not inst:HasTag("burnt") then
        local x, y, z = inst.Transform:GetWorldPosition()
        local n=0
        local willfire = false

        local seed_num = inst.components.container:GetItemInSlot(1) and inst.components.container:GetItemInSlot(1).components.stackable:StackSize() or 0  --容器里种子的数量
        
        inst.planter = planter      --存储按下播种按钮的玩家
        for k, v in ipairs(TheSim:FindEntities(x, y, z, FIRE_RANGE*2)) do
            if ((v.prefab == "slow_farmplot" or v.prefab == "fast_farmplot" or v.prefab == "farmplot_spot") and v.components.grower:IsEmpty() and v.components.grower:IsFertile())
            or ((v.prefab == "farm_soil" or v.prefab == "superfarm_soil") and not v:HasTag("NOCLICK")) then       --新农场
                n=n+1
                if n <= seed_num then   --如果检测到的农场数量不多余种子数量，则发射
                    willfire = true
                    inst:DoTaskInTime(n/2, function()
                        if not inst:HasTag("burnt") then
                            local targetpos = v:GetPosition()
                            --print("检测到农场"..targetpos.x..", "..targetpos.z)     --print
                            LaunchProjectile(inst, targetpos, v)
                        end
                    end)
                end
            end
        end
        ---------在发射过程中不能打开容器
        if willfire then
            inst.components.container.canopen = false
            if inst.components.container:IsOpen() then
                inst.components.container:Close()
            end
        end
        inst:DoTaskInTime(math.min(n, seed_num)/2 + 1, function ()
            inst.components.container.canopen = true
        end)
    end
end
inst.checkforfarm = CheckForFarm
end

local function setharvestmachine(inst)
local WIDTH = 6
local LENGTH = 15

local function OnHitMachine(inst, attacker, target)
    if inst.target.components.container and 
    (inst.target.components.container:Has(inst.prefab, 1) or not inst.target.components.container:IsFull()) then
        -- local product = SpawnPrefab(inst.prefab)
        -- if inst.components.stackable and product.components.stackable then
        --     product.components.stackable.stacksize = inst.components.stackable.stacksize
        -- end
        -- inst.target.components.container:GiveItem(product)
        -- inst:Remove()
        inst.target.components.container:GiveItem(inst)
        inst:RemoveComponent("complexprojectile")
        inst:RemoveComponent("locomotor")
        inst:RemoveTag("projectile")
        inst.Physics:SetActive(false)
    end
end

local function TransCrop(inst, product)
    --print(product.prefab)     --print---------------------------

    local targetpos = inst:GetPosition()
    local propos = product:GetPosition()
    
    product.target = inst
        
    if not product.Physics then
        product.entity:AddPhysics()
        product.Physics:SetMass(1)
        product.Physics:SetFriction(0)
        product.Physics:SetDamping(0)
        product.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
        product.Physics:ClearCollisionMask()
        product.Physics:CollidesWith(COLLISION.GROUND)
        product.Physics:SetCapsule(0.2, 0.2)
        product.Physics:SetDontRemoveOnSleep(true)
    end
    if not product:HasTag("projectile") then
        product:AddTag("projectile")
    end
    if not product.components.complexprojectile then
        product:AddComponent("locomotor")
        product:AddComponent("complexprojectile")
        product.components.complexprojectile:SetHorizontalSpeed(15)
        product.components.complexprojectile:SetGravity(-9)
        product.components.complexprojectile:SetLaunchOffset(Vector3(0, 1, 0))
        product.components.complexprojectile:SetOnHit(OnHitMachine)
    end
    
    local dx = targetpos.x - propos.x
    local dz = targetpos.z - propos.z
    local rangesq = dx * dx + dz * dz
    local maxrange = LENGTH+1
    local B = 9
    local G = -9    --重力
    -- print((targetpos.x-x)^2+(targetpos.z-z)^2)   --print-----------------------
    local speed = easing.linear(rangesq, B, 3, maxrange * maxrange)

    product.components.complexprojectile:SetHorizontalSpeed(speed)
    product.components.complexprojectile:SetGravity(G)
    product.components.complexprojectile:Launch(targetpos, inst, inst)
end

local function HarvestCrop(inst, target)
    if target and target.components.crop or target.components.pickable then
        if target:HasTag("readyforharvest") or (target.components.pickable and target.components.pickable.canbepicked) then
            local x,y,z = target.Transform:GetWorldPosition()
            --print(target.prefab.." X:"..x.." Z:"..z)        --print
            if target.components.crop then      --旧农场
                target.components.crop:Harvest()
            elseif target.components.pickable and target.components.lootdropper then      --新农场
                local loot = {}
                    for _, prefab in ipairs(target.components.lootdropper:GenerateLoot()) do
                        --local item = SpawnPrefab(prefab)
                        local item = target.components.lootdropper:SpawnLootPrefab(prefab, target:GetPosition())
                        table.insert(loot, item)
                        -- if item ~= nil then
                        --     if item.components.inventoryitem ~= nil then
                        --         item.components.inventoryitem:InheritMoisture(TheWorld.state.wetness, TheWorld.state.iswet)
                        --     end
                        -- end
                    end
                    if next(loot) ~= nil then
                        inst:PushEvent("picksomething", { object = target, loot = loot })
                    end
                    -- for i, item in ipairs(loot) do
                    --     target.components.lootdropper:FlingItem(item, target:GetPosition())
                    -- end
                target.components.pickable:Pick(inst)
                --------------如果是巨大蔬菜，锤它
                for k, v in ipairs(TheSim:FindEntities(x, y, z, 2)) do
                    if v.components.workable and v.components.equippable and v.components.lootdropper then
                        --v.components.workable.onfinish(v)
                        v.components.lootdropper:DropLoot()
                        v:Remove()
                    end
                end
            end
            inst:DoTaskInTime(1.5,function ()       --修复合并物品mod导致的无法获取到作物, 等待物品合并完毕再移动
                for k, v in ipairs(TheSim:FindEntities(x, y, z, 2)) do
                    if VEGGIES[v.prefab] or TUNING.EA_LEGION_ITEM[v.prefab]
                    or (v:HasTag("deployedplant") and v:HasTag("cookable") and v.prefab~="acorn") then
                        local fx = SpawnPrefab("fx_trans")
                        local x,y,z = v.Transform:GetWorldPosition()        --生成特效
                        fx.Transform:SetPosition(x,y,z)
                        inst.AnimState:PlayAnimation("trans",true)
                        --inst:DoTaskInTime(0.5, function()
                            TransCrop(inst, v)    --移动作物到机器的位置，并收入容器
                            inst:DoTaskInTime(3, function()
                                inst.AnimState:PlayAnimation("idle",true)
                            end)
                        --end)
                    end
                end
            end)
        end
    end
end

local function CheckForFarm()
    return function (inst)
            if not inst:HasTag("burnt") then
                local x, y, z = inst.Transform:GetWorldPosition()
                local willharvest = false
                for k, v in ipairs(TheSim:FindEntities(x, y, z, LENGTH*2)) do
                    if v:HasTag("readyforharvest") or (v.components.pickable and v.components.pickable.canbepicked) then
                        local pos = v:GetPosition()
                        if x < pos.x and pos.x <= x+LENGTH and z-WIDTH/2 <= pos.z and pos.z <= z+WIDTH/2 then
                            willharvest = true
                            inst:DoTaskInTime(0.3, function()
                                HarvestCrop(inst, v)  --收获作物
                            end)
                        end
                    end
                end
                if willharvest then
                    local fx = SpawnPrefab("fx_harvest")
                    fx.Transform:SetPosition(x+0.4,y,z)
                    inst.AnimState:PlayAnimation("hit")
                    inst.AnimState:PushAnimation("idle",true)
                end
            end
    end
end
inst:DoPeriodicTask(7, CheckForFarm())
end
AddPrefabPostInit("auto_harvest_machine", setharvestmachine)
AddPrefabPostInit("auto_seeding_machine", setseedsmanchine)


--plant_normal
local function setplants(inst)
local assets =
{
    Asset("ANIM", "anim/plant_normal_ground.zip"),
}
    inst.AnimState:SetBank("plant_normal_ground")
    inst.AnimState:SetBuild("plant_normal_ground")
end

--corn
local function setcron(inst)
local function onhammered(inst, worker)
	for index = 1, 3 do
	local s = math.random()
	if s < .3 then
	inst.components.lootdropper:SpawnLootPrefab("corn_seeds")
	else
	inst.components.lootdropper:SpawnLootPrefab("seeds")
	end
	end
    inst:Remove()
end
    inst:AddComponent("lootdropper")	    
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(onhammered)
end


--mode
if mode == "mini" then
PrefabFiles =
{
	"superfarm_mini",
	"extra_plantables",
}

AddRecipe("superfarm",{Ingredient("poop",9),Ingredient("cutstone",3),Ingredient("ash",9)},RECIPETABS.FARM,TECH.SCIENCE_TWO, "superfarm_placer", nil, nil, nil, nil, "images/inventoryimages/superfarm.xml")		

AddPrefabPostInit("corn", setcron)
if plant then
AddPrefabPostInit("plant_normal", setplants)
TUNING.SOILSCALE = 0.4
else
TUNING.SOILSCALE = 0.8
end

elseif mode == "normal" then
PrefabFiles =
{
	"superfarm",
	"extra_plantables",
}

AddRecipe("superfarm",{Ingredient("poop",9),Ingredient("cutstone",3),Ingredient("ash",9)},RECIPETABS.FARM,TECH.SCIENCE_TWO, "superfarm_placer", nil, nil, nil, nil, "images/inventoryimages/superfarm.xml")		

AddPrefabPostInit("corn", setcron)
if plant then
AddPrefabPostInit("plant_normal", setplants)
TUNING.SOILSCALE = 0.4
else
TUNING.SOILSCALE = 0.8
end

elseif mode == "farm" then
PrefabFiles =
{
	"superfarm_farm",
}
AddRecipe("superfarm",{Ingredient("poop",9),Ingredient("transistor",3),Ingredient("ash",9)},RECIPETABS.FARM,TECH.SCIENCE_TWO, "superfarm_placer", nil, nil, nil, nil, "images/inventoryimages/superfarm.xml")	
end


--fence
local function setstone(inst)
if stone=="stone1" then
inst.AnimState:PlayAnimation("1")
elseif stone=="stone2" then
inst.AnimState:PlayAnimation("2")
elseif stone=="stone3" then
inst.AnimState:PlayAnimation("8")
elseif stone=="stone4" then
inst.AnimState:PlayAnimation("3")
elseif stone=="stone5" then
inst.AnimState:SetBank("hydroponic_farm_decor")
inst.AnimState:SetBuild("hydroponic_farm_decor")
inst.AnimState:PlayAnimation("4")
elseif stone=="stone6" then
inst.AnimState:PlayAnimation("5")
elseif stone=="stone7" then
inst.AnimState:PlayAnimation("14")
elseif stone=="stone8" then
inst.AnimState:PlayAnimation("12")
elseif stone=="rock1" then
inst.AnimState:SetBank("hydroponic_farm_decor")
inst.AnimState:SetBuild("hydroponic_farm_decor")
inst.AnimState:PlayAnimation("1")
elseif stone=="rock2" then
inst.AnimState:SetBank("hydroponic_farm_decor")
inst.AnimState:SetBuild("hydroponic_farm_decor")
inst.AnimState:PlayAnimation("8")
elseif stone=="bamboo" then
inst.AnimState:SetBank("hydroponic_farm_decor")
inst.AnimState:SetBuild("hydroponic_farm_decor")
inst.AnimState:PlayAnimation("3")
elseif stone=="coral" then
inst.AnimState:SetBank("hydroponic_farm_decor")
inst.AnimState:SetBuild("hydroponic_farm_decor")
inst.AnimState:PlayAnimation("5")
end
end
AddPrefabPostInit("superfarm_rocks", setstone)

--language
if lan=="EN" then
STRINGS.NAMES.SUPERFARM = "Super Farm"
STRINGS.RECIPE_DESC.SUPERFARM = "Large farm with multiple planting sites"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SUPERFARM = "A nice big garden"
STRINGS.NAMES.ALOE = "aloe"
STRINGS.NAMES.ALOE_SEEDS = "aloe seeds"
STRINGS.NAMES.ALOE_COOKED = "aloe_cooked"
elseif lan=="CN" then
STRINGS.NAMES.SUPERFARM = "超级农场"
STRINGS.RECIPE_DESC.SUPERFARM = "让多个种子快速生长"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SUPERFARM = "很棒的大农场"
STRINGS.NAMES.ALOE = "芦荟"
STRINGS.NAMES.ALOE_SEEDS = "芦荟种子"
STRINGS.NAMES.ALOE_COOKED = "烤芦荟"
elseif lan=="RU" then
STRINGS.NAMES.SUPERFARM = "супер ферма"
STRINGS.RECIPE_DESC.SUPERFARM = "Большая ферма с несколькими посадочными площадками"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SUPERFARM = "Хороший большой сад"
STRINGS.NAMES.ALOE = "алоэ"
STRINGS.NAMES.ALOE_SEEDS = "семена алоэ"
STRINGS.NAMES.ALOE_COOKED = "алоэ_приготовленный"
elseif lan=="FR" then
STRINGS.NAMES.SUPERFARM = "super ferme"
STRINGS.RECIPE_DESC.SUPERFARM = "Grande ferme avec plusieurs sites de plantation"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SUPERFARM = "Un beau grand jardin"
STRINGS.NAMES.ALOE = "aloès"
STRINGS.NAMES.ALOE_SEEDS = "graines d'aloès"
STRINGS.NAMES.ALOE_COOKED = "aloe_cooked"
elseif lan=="ES" then
STRINGS.NAMES.SUPERFARM = "súper granja"
STRINGS.RECIPE_DESC.SUPERFARM = "Granja grande con múltiples sitios de plantación."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SUPERFARM = "Un bonito jardín grande"
STRINGS.NAMES.ALOE = "áloe"
STRINGS.NAMES.ALOE_SEEDS = "semillas de áloe"
STRINGS.NAMES.ALOE_COOKED = "aloe_cocinado"
elseif lan=="KO" then
STRINGS.NAMES.SUPERFARM = "슈퍼팜"
STRINGS.RECIPE_DESC.SUPERFARM = "여러 재배 장소가 있는 대규모 농장"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SUPERFARM = "멋진 큰 정원"
STRINGS.NAMES.ALOE = "노회"
STRINGS.NAMES.ALOE_SEEDS = "알로에 씨앗"
STRINGS.NAMES.ALOE_COOKED = "알로에_요리"
elseif lan=="PL" then
STRINGS.NAMES.SUPERFARM = "Super farma"
STRINGS.RECIPE_DESC.SUPERFARM = "Duże gospodarstwo z wieloma miejscami do"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SUPERFARM = "Ładny duży ogród?"
STRINGS.NAMES.ALOE = "aloes"
STRINGS.NAMES.ALOE_SEEDS = "nasiona aloesu"
STRINGS.NAMES.ALOE_COOKED = "aloes_gotowany"
elseif lan=="BR" then
STRINGS.NAMES.SUPERFARM = "Super fazenda"
STRINGS.RECIPE_DESC.SUPERFARM = "Grande fazenda com vários locais de plantio"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SUPERFARM = "Um belo jardim grande"
STRINGS.NAMES.ALOE = "babosa"
STRINGS.NAMES.ALOE_SEEDS = "sementes de aloe"
STRINGS.NAMES.ALOE_COOKED = "aloe_cooked"
elseif lan=="JA" then
STRINGS.NAMES.SUPERFARM = "スーパーファーム"
STRINGS.RECIPE_DESC.SUPERFARM = "複数の植栽地がある大規模な農場"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SUPERFARM = "素敵な大きな庭"
STRINGS.NAMES.ALOE = "アロエ"
STRINGS.NAMES.ALOE_SEEDS = "アロエシード"
STRINGS.NAMES.ALOE_COOKED = "アロエ調理"
elseif lan=="TUR" then
STRINGS.NAMES.SUPERFARM = "süper çiftlik"
STRINGS.RECIPE_DESC.SUPERFARM = "Birden fazla ekim alanına sahip büyük çiftlik"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SUPERFARM = "Güzel bir büyük bahçe"
STRINGS.NAMES.ALOE = "aloe"
STRINGS.NAMES.ALOE_SEEDS = "aloe tohumları"
STRINGS.NAMES.ALOE_COOKED = "aloe pişmiş"
end
