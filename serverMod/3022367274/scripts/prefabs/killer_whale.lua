local assets = {
    Asset('ANIM', 'anim/shark_basic.zip'),
    Asset('ANIM', 'anim/shark_basic_water.zip'),
    Asset('ANIM', 'anim/killer_whale.zip')
}

local prefabs = {
    'splash_green',
    'splash_green_large'
}

local SHARE_TARGET_DIST = 30
local JUMPDIST = 10
local CHARGEDIST = 10

local brain = require('brains/killer_whalebrain')

SetSharedLootTable(
    'killer_whale_1',
    {
        {'fishmeat', 1.00},
        {'fishmeat', 1.00},
        {'fishmeat', 1.00},
        {'fishmeat', 1.00},
        {'fishmeat', 1.00},
        {'fishmeat', 1.00}
    }
)

SetSharedLootTable(
    'killer_whale_2',
    {
        {'fishmeat', 1.00},
        {'fishmeat', 1.00},
        {'fishmeat', 1.00},
        {'fishmeat', 1.00},
        {'fishmeat', 1.00},
        {'fishmeat', 1.00},
        {'fishmeat', 1.00},
        {'fishmeat', 1.00},
        {'fishmeat', 1.00}
    }
)

SetSharedLootTable(
    'killer_whale_3',
    {
        {'fishmeat', 1.00},
        {'fishmeat', 1.00},
        {'fishmeat', 1.00},
        {'fishmeat', 1.00},
        {'fishmeat', 1.00},
        {'fishmeat', 1.00},
        {'fishmeat', 1.00},
        {'fishmeat', 1.00},
        {'fishmeat', 1.00},
        {'fishmeat', 1.00},
        {'fishmeat', 1.00},
        {'fishmeat', 1.00}
    }
)

local sounds = {}
local function area_check(target, inst)
    if target:HasTag('killer_whale') or target:HasTag('player') or target:HasTag('wall') then
        return false
    end
    return true
end
local function ShouldWakeUp(inst)
    return DefaultWakeTest(inst) or
        (inst.components.follower and inst.components.follower.leader and
            not inst.components.follower:IsNearLeader(WAKE_TO_FOLLOW_DISTANCE))
end

local function ShouldSleep(inst)
    return false
end

local function OnNewTarget(inst, data)
    if inst.components.sleeper and inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end
    if data.target:GetDistanceSqToInst(inst) < CHARGEDIST * CHARGEDIST then
        inst.components.timer:StartTimer('getdistance', 3)
    end
end

local function KeepTarget(inst, target)
    if target then
        local x, y, z = target.Transform:GetWorldPosition()
        if not TheWorld.Map:IsVisualGroundAtPoint(x, y, z) then
            return true
        end
    end
end

local function Retarget(inst)
    return FindEntity(
        inst,
        15,
        function(guy)
            local x, y, z = guy.Transform:GetWorldPosition()
            if
                not guy:HasTag('killer_whale') and not inst.components.timer:TimerExists('calmtime') and
                    not TheWorld.Map:IsVisualGroundAtPoint(x, y, z) and
                    not guy:HasTag('player') and
                    not guy:HasTag('wall')
             then
                if guy.prefab == 'shark' or guy.prefab == 'gnarwail' then
                    return inst.components.combat:CanTarget(guy)
                elseif inst.components.hunger:GetPercent() < .75 and not guy.prefab == 'puffin' then
                    return inst.components.combat:CanTarget(guy)
                end
            end
        end
    ) or nil
end

local function ShouldAcceptItem(inst, item)
    return inst.components.eater:CanEat(item)
end

local function OnGetItemFromPlayer(inst, giver, item)
    if inst.components.combat:TargetIs(giver) then
        inst.components.combat:SetTarget(nil)
    end

    inst.components.eater:Eat(item, giver)
    inst:PushEvent('onfedbyplayer', {food = item, feeder = giver})
    if inst.components.sleeper and inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end

    if
        giver:HasTag('ningen') and giver.components.killerwhalefriend.follower == nil and
            not inst:HasTag('killer_whale_leader')
     then
        if
            giver.components.leader ~= nil and inst.components.follower.leader and
                not inst.components.follower.leader:HasTag('ningen')
         then
            if math.random() < 0.1 then
                giver:PushEvent('makefriend')
                giver.components.killerwhalefriend:makefriend(inst)
            end
        end
    elseif
        giver:HasTag('ningen') and giver.components.killerwhalefriend.follower == inst and
            item.prefab == 'monsterlasagna'
     then
        giver.components.killerwhalefriend:breakoff(inst)
    end
end

local function OnRefuseItem(inst, item)
    inst.sg:GoToState('refuse')
    if inst.components.sleeper and inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(
        data.attacker,
        SHARE_TARGET_DIST,
        function(dude)
            return not (dude.components.health ~= nil and dude.components.health:IsDead()) and
                dude:HasTag('killer_whale')
        end,
        5
    )
    inst.components.timer:StopTimer('calmtime')
end

local function OnAttackOther(inst, data)
    inst.components.combat:ShareTarget(
        data.target,
        SHARE_TARGET_DIST,
        function(dude)
            return not (dude.components.health ~= nil and dude.components.health:IsDead()) and
                dude:HasTag('killer_whale')
        end,
        5
    )
end

local function removefood(inst, target)
    inst.foodtoeat = nil
end

local function testfooddist(inst)
    if inst.sg:HasStateTag('eating') then
        return
    end
    if not inst.foodtoeat then
        local target = inst.foodtarget
        if target and target:IsValid() and (target:HasTag('oceanfish') or target.prefab == 'puffin') then
            inst.foodtoeat = target
            inst:ClearBufferedAction()
        end
    end
    if inst.foodtoeat then
        if inst.foodtoeat:IsValid() and (inst.foodtoeat:HasTag('oceanfish') or inst.foodtoeat.prefab == 'puffin') then
            inst:PushEvent('dive_eat')
        else
            inst.foodtoeat = nil
        end
    end
end

local UP_VECTOR = Vector3(0, 1, 0)
local SEPARATION_AMOUNT = 25.0
local SEPARATION_MUST_NOT_TAGS = {'flying', 'FX', 'DECOR', 'INLIMBO'}
local SEPARATION_MUST_ONE_TAGS = {'blocker', 'killer_whale'}
local MAX_STEER_FORCE = 2.0
local MAX_STEER_FORCE_SQ = MAX_STEER_FORCE * MAX_STEER_FORCE
local DESIRED_BOAT_DISTANCE = TUNING.MAX_WALKABLE_PLATFORM_RADIUS + 4
local function GetFormationOffsetNormal(inst, boat_velocity)
    if not inst.targetboat then
        return Vector3(1, 0, 0)
    end

    local my_location = inst:GetPosition()

    -- calculate desired position
    local boat_p_position = inst.targetboat:GetPosition()
    local mtlp_normal, mtlp_length = (boat_p_position - my_location):GetNormalizedAndLength()

    local boat_direction, boat_speed = boat_velocity:GetNormalizedAndLength()
    local my_locomotor = inst.components.locomotor
    local inst_move_speed = (my_locomotor.isrunning and my_locomotor:GetRunSpeed()) or my_locomotor:GetWalkSpeed()
    local speed = math.min(boat_speed, inst_move_speed)

    -- separation steering --
    local separation_steering = Vector3(0, 0, 0)
    local mx, my, mz = inst.Transform:GetWorldPosition()
    local separation_entities =
        TheSim:FindEntities(mx, my, mz, SEPARATION_AMOUNT, nil, SEPARATION_MUST_NOT_TAGS, SEPARATION_MUST_ONE_TAGS)
    local separation_affecting_ents_count = 0
    for _, se in ipairs(separation_entities) do
        if se ~= inst then
            -- Generate a vector pointing directly away from this entity, length inversely proportional to its distance away
            local se_to_me_normal, se_to_me_length = (my_location - se:GetPosition()):GetNormalizedAndLength()
            separation_steering = separation_steering + (se_to_me_normal * speed / se_to_me_length)
            separation_affecting_ents_count = separation_affecting_ents_count + 1
        end
    end
    if separation_affecting_ents_count > 0 then
        separation_steering = separation_steering / separation_affecting_ents_count
    end
    if separation_steering:LengthSq() > 0 then
        local recalculated_separation_steering = (separation_steering:Normalize() * speed) - (mtlp_normal * speed)
        if recalculated_separation_steering:LengthSq() > MAX_STEER_FORCE_SQ then
            recalculated_separation_steering = recalculated_separation_steering:GetNormalized() * MAX_STEER_FORCE
        end
        separation_steering = recalculated_separation_steering
    end
    -- separation steering --

    local desired_position_offset = mtlp_normal * (mtlp_length - DESIRED_BOAT_DISTANCE)
    return desired_position_offset + separation_steering
end

local function OnStarve(inst)
    if inst.components.follower.leader and inst.components.follower.leader:HasTag('ningen') then
        return
    end
    if inst.leave_event == nil then
        inst.leave_event =
            inst:DoPeriodicTask(
            1.0,
            function()
                if not inst.components.health:IsDead() and not inst.sg:HasStateTag('busy') then
                    inst.leave_event:Cancel()
                    inst.sg:GoToState('leave')
                end
            end
        )
    end
end

local function OnLostTarget(inst)
end

local function OnNewTarget(inst, data)
    local tar = data.target
end

local function normal_distibution_calc(x)
    return 1.0 / math.sqrt(2.0 * math.pi) * math.exp(-x ^ 2 / 2)
end

local function gaussrand()
    local u = 0
    local v = 0
    local z = 0
    while z <= 0 or z >= 1.0 do
        u = math.random() * 2 - 1
        v = math.random() * 2 - 1
        z = u * u + v * v
    end
    z = math.sqrt(-2.0 * math.log(z) / z)
    if math.random() > .5 then
        return normal_distibution_calc(z * u)
    else
        return normal_distibution_calc(z * v)
    end
end

local function setfriend(inst, player)
    if inst.components.follower.leader and inst.components.follower.leader == player then
        player.components.killerwhalefriend.follower = inst
    end
end

local function OnPlayerJoined(inst, player)
    inst:DoTaskInTime(0.5, setfriend, player)
end

local function OnTimerDone(inst, data)
    if data.name == 'masteronland' or data.name == 'summononland' then
        if inst.components.follower.leader and inst.components.follower.leader:HasTag('ningen') then
            local leader = inst.components.follower.leader
            leader.components.killerwhalefriend:leave(inst)
        end
    end
end

local function ondeath(inst)
    if inst.components.follower.leader and inst.components.follower.leader:HasTag('ningen') then
        local leader = inst.components.follower.leader
        leader.components.killerwhalefriend:death()
    end
end

local function OnSave(inst, data)
    data.size = inst.Transform:GetScale()
end

local function OnLoad(inst, data)
    if data == nil then
        return
    end
    local x = data.size
    inst.Transform:SetScale(x, x, x)
    inst.killer_whale_size = x
    inst.components.combat:SetDefaultDamage(TUNING.SHARK.DAMAGE * 3.0 * x)
    inst.components.combat:SetAreaDamage(TUNING.SHARK.AOE_RANGE * x, 1.0, area_check)
    inst.components.health:SetMaxHealth(TUNING.SHARK.HEALTH * 3.0 * x)
    inst.components.health:StartRegen(TUNING.BEEFALO_HEALTH_REGEN * 3.0 * x, TUNING.BEEFALO_HEALTH_REGEN_PERIOD)
    local num = '_1'
    if x > 1.75 then
        num = '_3'
    elseif x > 1.25 then
        num = '_2'
    end
    inst.components.lootdropper:SetChanceLootTable('killer_whale' .. num)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 100, .5)

    inst.DynamicShadow:SetSize(2.5, 1.5)
    inst.Transform:SetSixFaced()
    inst.Transform:SetScale(2.0, 2.0, 2.0)

    inst.AnimState:SetBank('shark')
    inst.AnimState:SetBuild('killer_whale')
    inst.AnimState:PlayAnimation('idle', true)

    inst:AddTag('animal')
    inst:AddTag('largecreature')
    inst:AddTag('killer_whale')
    inst:AddTag('companion')

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.sounds = sounds

    inst:AddComponent('eater')
    inst.components.eater:SetDiet({FOODTYPE.MEAT}, {FOODTYPE.MEAT})
    inst.components.eater:SetCanEatHorrible()
    inst.components.eater:SetStrongStomach(true) -- can eat monster meat!
    inst.components.eater:SetAbsorptionModifiers(10, 1, 1)

    inst:AddComponent('combat')
    inst.components.combat.hiteffectsymbol = 'shark_parts'
    inst.components.combat:SetRetargetFunction(1, Retarget)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)
    inst.components.combat:SetAttackPeriod(1.5)

    inst:AddComponent('health')
    inst:AddComponent('hunger')
    inst.components.hunger:SetMax(200)
    inst.components.hunger.burnratemodifiers:SetModifier(inst, 0.5, 'killer_whale_stomach')

    inst:AddComponent('lootdropper')

    inst:AddComponent('inspectable')

    MakeLargeBurnableCharacter(inst, 'beefalo_body')
    MakeLargeFreezableCharacter(inst, 'beefalo_body')

    inst:AddComponent('timer')
    inst:AddComponent('named')

    inst:AddComponent('locomotor') -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = TUNING.SHARK.WALK_SPEED_LAND
    inst.components.locomotor.runspeed = TUNING.SHARK.RUN_SPEED_LAND

    inst:AddComponent('trader')
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem

    inst.components.locomotor.pathcaps = {allowocean = true, ignoreland = true}

    inst:AddComponent('amphibiouscreature')
    inst.components.amphibiouscreature:SetBanks('shark', 'shark_water')
    inst.components.amphibiouscreature:SetEnterWaterFn(
        function(inst)
            inst.landspeed = inst.components.locomotor.runspeed
            inst.landspeedwalk = inst.components.locomotor.walkspeed
            inst.components.locomotor.runspeed = TUNING.SHARK.RUN_SPEED
            inst.components.locomotor.walkspeed = TUNING.SHARK.WALK_SPEED
            inst.DynamicShadow:Enable(false)
        end
    )

    inst.components.amphibiouscreature:SetExitWaterFn(
        function(inst)
            if inst.landspeed then
                inst.components.locomotor.runspeed = inst.landspeed
            end
            if inst.landspeedwalk then
                inst.components.locomotor.walkspeed = inst.landspeedwalk
            end
            inst.DynamicShadow:Enable(true)
        end
    )

    inst:AddComponent('updatelooper')
    inst.components.updatelooper:AddOnWallUpdateFn(
        function()
            if inst:GetCurrentPlatform() then
                if inst.readytoswim then
                    inst:PushEvent('leap')
                end
            else
                local target = inst.components.combat.target
                if target then
                    if target:GetCurrentPlatform() then
                        if
                            not inst.sg:HasStateTag('jumping') and not inst.components.timer:TimerExists('getdistance') and
                                target:GetDistanceSqToInst(inst) < JUMPDIST * JUMPDIST
                         then
                            inst:PushEvent('leap')
                        end
                    end
                end
            end
        end
    )

    inst:AddComponent('sleeper')
    inst.components.sleeper:SetResistance(3)
    inst.components.sleeper.testperiod = GetRandomWithVariance(6, 2)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWakeUp)

    inst:AddComponent('follower')
    inst:AddComponent('leader')

    inst:AddComponent('killer_whalecharacteristics')

    -- inst:AddComponent('groundpounder')
    -- inst.components.groundpounder.destroyer = false
    -- inst.components.groundpounder.damageRings = 2
    -- inst.components.groundpounder.platformPushingRings = 2
    -- inst.components.groundpounder.numRings = 3
    -- inst.components.groundpounder.groundpounddamagemult = 1
    -- inst.components.groundpounder.noTags = {
    --     'FX',
    --     'NOCLICK',
    --     'DECOR',
    --     'INLIMBO',
    --     'ningen',
    --     'killer_whale',
    --     'player',
    --     'companion',
    --     'wall',
    --     'abigail',
    --     'shadowminion'
    -- }

    inst:ListenForEvent('newcombattarget', OnNewTarget)

    inst.removefood = removefood
    inst.testfooddist = testfooddist
    inst.GetFormationOffsetNormal = GetFormationOffsetNormal

    -- MakeHauntablePanic(inst)

    inst:SetBrain(brain)
    inst:SetStateGraph('SGkiller_whale')
    inst.OnAttacked = OnAttacked
    inst.OnAttackOther = OnAttackOther
    inst:ListenForEvent('attacked', inst.OnAttacked)
    inst:ListenForEvent('onattackother', inst.OnAttackOther)

    inst:ListenForEvent('losttarget', OnLostTarget)
    inst:ListenForEvent('newcombattarget', OnNewTarget)

    inst:ListenForEvent('timerdone', OnTimerDone)
    inst:ListenForEvent(
        'ms_playerjoined',
        function(src, player)
            OnPlayerJoined(inst, player)
        end,
        TheWorld
    )

    inst:ListenForEvent('death', ondeath)

    inst:DoTaskInTime(600, OnStarve)
    inst:DoTaskInTime(
        0,
        function()
            local x
            if inst.killer_whale_size then
                x = inst.killer_whale_size
            else
                x = gaussrand() * math.sqrt(2.0 * math.pi) * .5
                if math.random() > .5 then
                    x = -x
                end
                if x > 0 then
                    x = 1.0 + x
                else
                    x = 2.0 + x
                end
            end
            -- print("whale size:",x)
            inst.Transform:SetScale(x, x, x)
            inst.killer_whale_size = x
            inst.components.combat:SetDefaultDamage(TUNING.SHARK.DAMAGE * 3.0 * x)
            inst.components.combat:SetAreaDamage(TUNING.SHARK.AOE_RANGE * x, 1.0, area_check)
            inst.components.health:SetMaxHealth(TUNING.SHARK.HEALTH * 3.0 * x)
            inst.components.health:StartRegen(TUNING.BEEFALO_HEALTH_REGEN * 3.0 * x, TUNING.BEEFALO_HEALTH_REGEN_PERIOD)
            local num = '_1'
            if x > 1.75 then
                num = '_3'
            elseif x > 1.25 then
                num = '_2'
            end
            inst.components.lootdropper:SetChanceLootTable('killer_whale' .. num)
        end
    )

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    inst:DoPeriodicTask(
        2.0,
        function()
            if inst.components.health and not inst.components.health:IsDead() then
                if inst.components.hunger:IsStarving() then
                    OnStarve(inst)
                end
            end
        end
    )

    TheWorld:PushEvent('kw_spawned', {target = inst})
    return inst
end

return Prefab('killer_whale', fn, assets, prefabs)
