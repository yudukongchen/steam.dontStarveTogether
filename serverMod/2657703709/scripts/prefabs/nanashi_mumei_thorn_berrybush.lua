require "prefabutil"

-- * Based on plantables.lua prefab
local function createplantable(name)
    local assets =
    {
        Asset("ANIM", "anim/berrybush.zip"),  -- TODO: Change to dug thorn berrybush's
        Asset("INV_IMAGE", "dug_berrybush")    -- TODO: Change to dug thorn berrybush's
    }

    -- if data.build ~= nil then  -- ! No build on default dug_berrybush (plantables table) so maybe ok to not set it
    --     table.insert(assets, Asset("ANIM", "anim/"..data.build..".zip"))
    -- end

    local function ondeploy(inst, pt, deployer)
        local tree = SpawnPrefab("nanashi_mumei_thorn_berrybush")
        if tree ~= nil then
            tree.Transform:SetPosition(pt:Get())
            inst.components.stackable:Get():Remove()
            if tree.components.pickable ~= nil then
                tree.components.pickable:OnTransplant()
            end
            if deployer ~= nil and deployer.SoundEmitter ~= nil then
                deployer.SoundEmitter:PlaySound("dontstarve/common/plant")
            end
        end
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        --inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst:AddTag("deployedplant")

        inst.AnimState:SetBank("berrybush") -- TODO: Change to dug thorn berrybush's
        inst.AnimState:SetBuild("berrybush") -- TODO: Change to dug thorn berrybush's
        inst.AnimState:PlayAnimation("dropped")

        MakeInventoryFloatable(inst, "med", 0.2, 0.95)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

        inst:AddComponent("inspectable")
        inst.components.inspectable.nameoverride = name
        inst:AddComponent("inventoryitem")

        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

        MakeMediumBurnable(inst, TUNING.LARGE_BURNTIME)
        MakeSmallPropagator(inst)

        MakeHauntableLaunchAndIgnite(inst)

        inst:AddComponent("deployable")
        --inst.components.deployable:SetDeployMode(DEPLOYMODE.ANYWHERE)
        inst.components.deployable.ondeploy = ondeploy
        inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
        --inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.MEDIUM) -- TODO: Check how is it when deploy

        return inst
    end

    return Prefab("nanashi_mumei_dug_thorn_berrybush", fn, assets)
end

-- * Below are based on berrybush.lua prefab
local function setberries(inst, pct)
    if inst._setberriesonanimover then
        inst._setberriesonanimover = nil
        inst:RemoveEventCallback("animover", setberries)
    end

    local berries =
        (pct == nil and "") or
        (pct >= .9 and "berriesmost") or
        (pct >= .33 and "berriesmore") or
        "berries"

    for i, v in ipairs({ "berries", "berriesmore", "berriesmost" }) do
        if v == berries then
            inst.AnimState:Show(v)
        else
            inst.AnimState:Hide(v)
        end
    end
end

local function setberriesonanimover(inst)
    if inst._setberriesonanimover then
        setberries(inst, nil)
    else
        inst._setberriesonanimover = true
        inst:ListenForEvent("animover", setberries)
    end
end

local function cancelsetberriesonanimover(inst)
    if inst._setberriesonanimover then
        setberries(inst, nil)
    end
end

local function makeemptyfn(inst)
    if POPULATING then
        inst.AnimState:PlayAnimation("idle", true)
        inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())
    elseif inst:HasTag("withered") or inst.AnimState:IsCurrentAnimation("dead") then
        --inst.SoundEmitter:PlaySound("dontstarve/common/bush_fertilize")
        inst.AnimState:PlayAnimation("dead_to_idle")
        inst.AnimState:PushAnimation("idle")
    else
        inst.AnimState:PlayAnimation("idle", true)
    end
    setberries(inst, nil)
end

local function makebarrenfn(inst)--, wasempty)
    if not POPULATING and (inst:HasTag("withered") or inst.AnimState:IsCurrentAnimation("idle")) then
        inst.AnimState:PlayAnimation("idle_to_dead")
        inst.AnimState:PushAnimation("dead", false)
    else
        inst.AnimState:PlayAnimation("dead")
    end
    cancelsetberriesonanimover(inst)
end

local function shake(inst)
    if inst.components.pickable ~= nil and
        not inst.components.pickable:CanBePicked() and
        inst.components.pickable:IsBarren() then
        inst.AnimState:PlayAnimation("shake_dead")
        inst.AnimState:PushAnimation("dead", false)
    else
        inst.AnimState:PlayAnimation("shake")
        inst.AnimState:PushAnimation("idle")
    end
    cancelsetberriesonanimover(inst)
end

local function spawnperd(inst)
    if inst:IsValid() then
        local perd = SpawnPrefab("perd")
        local x, y, z = inst.Transform:GetWorldPosition()
        local angle = math.random() * 2 * PI
        perd.Transform:SetPosition(x + math.cos(angle), 0, z + math.sin(angle))
        perd.sg:GoToState("appear")
        perd.components.homeseeker:SetHome(inst)
        shake(inst)
    end
end

local function onpickedfn(inst, picker)
    if inst.components.pickable ~= nil then
        --V2C: nil cycles_left means unlimited picks, so use max value for math
        --local old_percent = inst.components.pickable.cycles_left ~= nil and (inst.components.pickable.cycles_left + 1) / inst.components.pickable.max_cycles or 1
        --setberries(inst, old_percent)
        if inst.components.pickable:IsBarren() then
            inst.AnimState:PlayAnimation("idle_to_dead")
            inst.AnimState:PushAnimation("dead", false)
            setberries(inst, nil)
        else
            inst.AnimState:PlayAnimation("picked")
            inst.AnimState:PushAnimation("idle")
            setberriesonanimover(inst)
        end
    end

    if not (picker:HasTag("berrythief") or inst._noperd) and math.random() < (IsSpecialEventActive(SPECIAL_EVENTS.YOTG) and TUNING.YOTG_PERD_SPAWNCHANCE or TUNING.PERD_SPAWNCHANCE) then
        inst:DoTaskInTime(3 + math.random() * 3, spawnperd)
    end
end

local function getregentimefn_normal(inst)
    if inst.components.pickable == nil then
        return TUNING.BERRY_REGROW_TIME
    end
    --V2C: nil cycles_left means unlimited picks, so use max value for math
    local max_cycles = inst.components.pickable.max_cycles
    local cycles_left = inst.components.pickable.cycles_left or max_cycles
    local num_cycles_passed = math.max(0, max_cycles - cycles_left)
    return TUNING.BERRY_REGROW_TIME
        + TUNING.BERRY_REGROW_INCREASE * num_cycles_passed
        + TUNING.BERRY_REGROW_VARIANCE * math.random()
end

local function makefullfn(inst)
    local anim = "idle"
    local berries = nil
    if inst.components.pickable ~= nil then
        if inst.components.pickable:CanBePicked() then
            berries = inst.components.pickable.cycles_left ~= nil and inst.components.pickable.cycles_left / inst.components.pickable.max_cycles or 1
        elseif inst.components.pickable:IsBarren() then
            anim = "dead"
        end
    end
    if anim ~= "idle" then
        inst.AnimState:PlayAnimation(anim)
    elseif POPULATING then
        inst.AnimState:PlayAnimation("idle", true)
        inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())
    else
        inst.AnimState:PlayAnimation("grow")
        inst.AnimState:PushAnimation("idle", true)
    end
    setberries(inst, berries)
end

local function dig_up_common(inst, worker, numberries)
    if inst.components.pickable ~= nil and inst.components.lootdropper ~= nil then
        local withered = inst.components.witherable ~= nil and inst.components.witherable:IsWithered()


        if withered or inst.components.pickable:IsBarren() then
            inst.components.lootdropper:SpawnLootPrefab("twigs")
            inst.components.lootdropper:SpawnLootPrefab("twigs")
        else
            if inst.components.pickable:CanBePicked() then
                local pt = inst:GetPosition()
                pt.y = pt.y + (inst.components.pickable.dropheight or 0)
                for i = 1, numberries do
                    inst.components.lootdropper:SpawnLootPrefab(inst.components.pickable.product, pt)
                end
            end
            inst.components.lootdropper:SpawnLootPrefab("nanashi_mumei_dug_thorn_berrybush")
        end
    end
    inst:Remove()
end

local function dig_up_normal(inst, worker)
    dig_up_common(inst, worker, 1)
end

-- * For mine component
local function dig_up_deactivate(inst)
    dig_up_common(inst, nil, 1)
end

local function ontransplantfn(inst)
    inst.AnimState:PlayAnimation("dead")
    setberries(inst, nil)
    inst.components.pickable:MakeBarren()
end

local function on_anim_over(inst)
    if inst.components.mine.issprung then
        return
    end
    ---soundhelp i can't get these sounds to play at the begining of idle 2 and idle 3
    ---i need your help, your my only hope
    local random_value = math.random()
    if random_value < 0.4 then
        inst.AnimState:PushAnimation("idle_2")
        -- inst.SoundEmitter:PlaySound("turnoftides/creatures/together/starfishtrap/idle")
        inst.AnimState:PushAnimation("idle", true)


    elseif random_value < 0.8 then
        inst.AnimState:PushAnimation("idle_3")
        -- inst.SoundEmitter:PlaySound("turnoftides/creatures/together/starfishtrap/idle")
        inst.AnimState:PushAnimation("idle", true)
    end
end

-- Copied from mine.lua to emulate its mine test.
local mine_test_fn = function(target, inst)
    return not (target.components.health ~= nil and target.components.health:IsDead())
            and (target.components.combat ~= nil and target.components.combat:CanBeAttacked(inst))
end
local mine_test_tags = { "monster", "character", "animal" }
local mine_must_tags = { "_combat" }
local mine_no_tags = { "notraptrigger", "flying", "ghost", "playerghost" }

local function do_snap(inst)
    -- We're going off whether we hit somebody or not, so play the trap sound.
    inst.SoundEmitter:PlaySound("turnoftides/creatures/together/starfishtrap/trap")

    -- Do an AOE attack, based on how the combat component does it.
    local x, y, z = inst.Transform:GetWorldPosition()
    local target_ents = TheSim:FindEntities(x, y, z, TUNING.STARFISH_TRAP_RADIUS, mine_must_tags, mine_no_tags, mine_test_tags)
    for i, target in ipairs(target_ents) do
        if target ~= inst and target.entity:IsVisible() and mine_test_fn(target, inst) then
            target.components.combat:GetAttacked(inst, TUNING.STARFISH_TRAP_DAMAGE)
        end
    end

    if inst._snap_task ~= nil then
        inst._snap_task:Cancel()
        inst._snap_task = nil
    end
end

local function start_reset_task(inst)
    if inst._reset_task ~= nil then
        inst._reset_task:Cancel()
    end
    local reset_task_randomized_time = GetRandomWithVariance(TUNING.STARFISH_TRAP_NOTDAY_RESET.BASE, TUNING.STARFISH_TRAP_NOTDAY_RESET.VARIANCE)
    inst._reset_task = inst:DoTaskInTime(reset_task_randomized_time, reset)
    inst._reset_task_end_time = GetTime() + reset_task_randomized_time
end

local function on_explode(inst, target)
    inst.AnimState:PlayAnimation("trap")
    inst.AnimState:PushAnimation("trap_idle", true)

    inst:RemoveEventCallback("animover", on_anim_over)

    if target ~= nil and inst._snap_task == nil then
        local frames_until_anim_snap = 8
        inst._snap_task = inst:DoTaskInTime(frames_until_anim_snap * FRAMES, do_snap)
    end

    start_reset_task(inst)
end

local function on_reset(inst)
    inst:ListenForEvent("animover", on_anim_over)

    if inst.AnimState:IsCurrentAnimation("trap_idle") then
        inst.AnimState:PlayAnimation("reset")
        --- scott this one is playing as expected
        inst.SoundEmitter:PlaySound("turnoftides/creatures/together/starfishtrap/idle")
        inst.AnimState:PushAnimation("idle", true)
    end
end

local function on_sprung(inst)
    inst.AnimState:PlayAnimation("trap_idle", true)

    inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())

    inst:RemoveEventCallback("animover", on_anim_over)

    start_reset_task(inst)
end

local function calculate_mine_test_time()
    return TUNING.STARFISH_TRAP_TIMING.BASE + (math.random() * TUNING.STARFISH_TRAP_TIMING.VARIANCE)
end

local function OnHaunt(inst)
    if math.random() <= TUNING.HAUNT_CHANCE_ALWAYS then
        shake(inst)
        inst.components.hauntable.hauntvalue = TUNING.HAUNT_COOLDOWN_TINY
        return true
    end
    return false
end

local function createbush(name, inspectname, berryname, master_postinit)
    local assets =
    {
        Asset("ANIM", "anim/berrybush.zip"), -- TODO: Change to thorn berrybush's
        --Asset("ANIM", "anim/"..name.."_diseased_build.zip"), -- No longer need maybe
    }

    local prefabs =
    {
        berryname,
        "nanashi_mumei_dug_thorn_berrybush",
        "perd",
        "twigs",
        "spoiled_food",
    }

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()

        MakeSmallObstaclePhysics(inst, .1)

        inst:AddTag("bush")
        inst:AddTag("plant")
        inst:AddTag("renewable")

        --witherable (from witherable component) added to pristine state for optimization
        inst:AddTag("witherable")

        if TheNet:GetServerGameMode() == "quagmire" then
            -- for stats tracking
            inst:AddTag("quagmire_wildplant")
        end

        inst.MiniMapEntity:SetIcon("berrybush.png")  -- TODO: Change to thorn berrybush's

        inst.AnimState:SetBank("berrybush")  -- TODO: Change to thorn berrybush's
        inst.AnimState:SetBuild("berrybush")  -- TODO: Change to thorn berrybush's
        inst.AnimState:PlayAnimation("idle", true)
        setberries(inst, 1)

        MakeSnowCoveredPristine(inst)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())

        inst:AddComponent("pickable")
        inst.components.pickable.picksound = "dontstarve/wilson/harvest_berries"
        inst.components.pickable.onpickedfn = onpickedfn
        inst.components.pickable.makeemptyfn = makeemptyfn
        inst.components.pickable.makebarrenfn = makebarrenfn
        inst.components.pickable.makefullfn = makefullfn
        inst.components.pickable.ontransplantfn = ontransplantfn

        inst:AddComponent("witherable")

        inst:AddComponent("mine")
        inst.components.mine:SetRadius(TUNING.STARFISH_TRAP_RADIUS)
        inst.components.mine:SetAlignment(nil) -- starfish trigger on EVERYTHING on the ground, players and non-players alike.
        inst.components.mine:SetOnExplodeFn(on_explode)
        inst.components.mine:SetOnResetFn(on_reset)
        inst.components.mine:SetOnSprungFn(on_sprung)
        inst.components.mine:SetOnDeactivateFn(dig_up_deactivate)
        inst.components.mine:SetTestTimeFn(calculate_mine_test_time)
        inst.components.mine:SetReusable(false)
        inst.components.mine:Reset()

        MakeLargeBurnable(inst)
        MakeMediumPropagator(inst)

        MakeHauntableIgnite(inst)
        AddHauntableCustomReaction(inst, OnHaunt, false, false, true)

        inst:AddComponent("lootdropper")

        if not GetGameModeProperty("disable_transplanting") then
            inst:AddComponent("workable")
            inst.components.workable:SetWorkAction(ACTIONS.DIG)
            inst.components.workable:SetWorkLeft(1)
        end

        inst:AddComponent("inspectable")
        inst.components.inspectable.nameoverride = name

        inst:ListenForEvent("onwenthome", shake)
        MakeSnowCovered(inst)
        MakeNoGrowInWinter(inst)

        master_postinit(inst)

        if IsSpecialEventActive(SPECIAL_EVENTS.YOTG) then
            inst:ListenForEvent("spawnperd", spawnperd)
        end

        if TheNet:GetServerGameMode() == "quagmire" then
            event_server_data("quagmire", "prefabs/berrybush").master_postinit(inst)
        end

        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end

local function thorn_berrybush_postinit(inst)
    inst.components.pickable:SetUp("berries", TUNING.BERRY_REGROW_TIME)
    inst.components.pickable.getregentimefn = getregentimefn_normal
    inst.components.pickable.max_cycles = TUNING.BERRYBUSH_CYCLES + math.random(2)
    inst.components.pickable.cycles_left = inst.components.pickable.max_cycles

    if inst.components.workable ~= nil then
        inst.components.workable:SetOnFinishCallback(dig_up_normal)
    end
end

-- TODO: Change all "berrybush" to thorn berrybush's asset
return createbush("nanashi_mumei_thorn_berrybush", "berrybush", "berries", thorn_berrybush_postinit),
createplantable("nanashi_mumei_dug_thorn_berrybush"),
MakePlacer("nanashi_mumei_dug_thorn_berrybush_placer", "nanashi_mumei_thorn_berrybush", "berrybush", "idle")

