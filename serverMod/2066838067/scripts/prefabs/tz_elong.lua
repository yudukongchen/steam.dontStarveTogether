local fns = {} -- a table to store local functions in so that we don't hit the 60 upvalues limit

local assets =
{
    Asset("ANIM", "anim/tz_elong.zip"),
}

local brain = require("brains/tz_elongbrain")

local sounds = 
{
    walk = "",
    grunt = "",
    yell = "",
    swish = "",
    curious = "",
    angry = "",
    sleep = "",
    death = "",
}

--[[
fns.ClearBellOwner = function(inst)
    local bell_leader = inst.components.follower:GetLeader()
    inst:RemoveEventCallback("onremove", inst._BellRemoveCallback, bell_leader)

    inst.components.follower:SetLeader(nil)
    inst.components.rideable:SetShouldSave(true)

    inst.persists = true
end

fns.GetBeefBellOwner = function(inst)
    local leader = inst.components.follower:GetLeader()
    return (leader ~= nil
        and leader.components.inventoryitem ~= nil
        and leader.components.inventoryitem:GetGrandOwner())
        or nil
end

fns.SetBeefBellOwner = function(inst, bell, bell_user)
    if inst.components.follower:GetLeader() == nil
            and bell ~= nil and bell.components.leader ~= nil then
        bell.components.leader:AddFollower(inst)
        inst.components.rideable:SetShouldSave(false)

        --ThePlayer.components.leader:AddFollower(DebugSpawn"tz_elong")
        inst:ListenForEvent("onremove", inst._BellRemoveCallback, bell)

        inst.persists = false

        return true
    else
        return false, "ALREADY_USED"
    end
end]]

local function ClearBuildOverrides(inst, animstate)
    local basebuild = "tz_elong"
    if animstate ~= inst.AnimState then
        animstate:ClearOverrideBuild(basebuild)
    end
end

local function ApplyBuildOverrides(inst, animstate)
    local basebuild = "tz_elong"
    if animstate ~= nil and animstate ~= inst.AnimState then
        animstate:AddOverrideBuild(basebuild)
    else
        animstate:SetBuild(basebuild)
    end
end

local function KeepTarget(inst, target)
    return false
end

local function OnNewTarget(inst, data)

end

local function CanShareTarget(dude)
    return false
end

local function OnAttacked(inst, data)
end

local function ShouldBeg(inst)
    return false
end

local function OnDeath(inst, data)

end

local function OnEat(inst, food)
    --inst:PushEvent("oneat")
end


local function DoRiderSleep(inst, sleepiness, sleeptime)
    inst._ridersleeptask = nil
    inst.components.sleeper:AddSleepiness(sleepiness, sleeptime)
end

local function PotentialRiderTest(inst, potential_rider)
    local leader = inst.components.follower:GetLeader()
    if leader == nil or leader.components.inventoryitem == nil then
        return false
    end
    local leader_owner = leader.components.inventoryitem:GetGrandOwner()
    return leader_owner == potential_rider
end

local function OnSaddleChanged(inst, data)

end

local function _OnRefuseRider(inst)
    if inst.components.sleeper:IsAsleep() and not inst.components.health:IsDead() then
        -- this needs to happen after the stategraph
        inst.components.sleeper:WakeUp()
    end
end

local function OnRefuseRider(inst, data)
    inst:DoTaskInTime(0, _OnRefuseRider)
end

local function OnRiderSleep(inst, data)
    inst._ridersleep = inst.components.rideable:IsBeingRidden() and {
        time = GetTime(),
        sleepiness = data.sleepiness,
        sleeptime = data.sleeptime,
    } or nil
end

local WAKE_TO_FOLLOW_DISTANCE = 15
local function ShouldWakeUp(inst)
    return DefaultWakeTest(inst)
        or (inst.components.follower.leader ~= nil
            and not inst.components.follower:IsNearLeader(WAKE_TO_FOLLOW_DISTANCE))
end

local SLEEP_NEAR_LEADER_DISTANCE = 10
local function MountSleepTest(inst)
    return not inst.components.rideable:IsBeingRidden()
        and DefaultSleepTest(inst)
        and (inst.components.follower.leader == nil
            or inst.components.follower:IsNearLeader(SLEEP_NEAR_LEADER_DISTANCE))
end

local function OnSink(inst)
    local leader = inst.components.follower:GetLeader()
    if leader and leader.components.aowu_elong and leader.components.aowu_elong.pet == inst then
        leader.components.aowu_elong:DoDespawnPet()
    else
        inst:Remove()
    end
end


local function ShouldAcceptItem(inst, item)
    return inst.components.eater:CanEat(item)
end

local function OnGetItemFromPlayer(inst, giver, item)
    if inst.components.eater:CanEat(item) then
        inst.components.eater:Eat(item, giver)
    end
end

local function OnRefuseItem(inst, item)
    if inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end
end

local function beefalo()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 100, .5)

    inst.DynamicShadow:SetSize(6, 2)
    inst.Transform:SetSixFaced()

    inst.AnimState:SetBank("tz_elong")
    inst.AnimState:SetBuild("tz_elong")
    inst.AnimState:PlayAnimation("idle_loop", true)

    inst.MiniMapEntity:SetIcon("tz_elong.tex")

    inst:AddTag("animal")
    inst:AddTag("largecreature")
    inst:AddTag("companion")
    inst:AddTag("elong")
    inst:AddTag("NOBLOCK")
    inst:AddTag("nobundling")
    inst.sounds = sounds

    inst:AddComponent("spawnfader")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("named")

    inst:AddComponent("bloomer")

    inst:AddComponent("eater")
    inst.components.eater:SetAbsorptionModifiers(3,1,1)
    --inst.components.eater:SetOnEatFn(OnEat)

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "elong_body"
    inst.components.combat:SetDefaultDamage(200)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.TZ_ELONGMAXHEALTH)
    inst.components.health.nofadeout = true

    inst:AddComponent("lootdropper")

    inst:AddComponent("inspectable")

    inst:AddComponent("knownlocations")

    inst:AddComponent("follower")
    inst.components.follower.canaccepttarget = false
    

    inst:AddComponent("rideable")
    inst.components.rideable:SetCustomRiderTest(PotentialRiderTest)
    inst.components.rideable.canride = true
    inst.components.rideable:SetShouldSave(false)

    inst:ListenForEvent("refusedrider", OnRefuseRider)
    inst:ListenForEvent("healthdelta",function(inst)
        local rider = inst.components.rideable.rider
        if rider and rider:IsValid() and rider.elong_health ~= nil then
            rider.elong_health:set(inst.components.health.currenthealth)
        end
    end)

    inst:AddComponent("hunger")
    inst.components.hunger:SetMax(500)
    inst.components.hunger:SetRate(TUNING.BEEFALO_HUNGER_RATE)
    inst.components.hunger:SetPercent(1)
    inst.components.hunger.overridestarvefn = function(...)    end

    MakeLargeBurnableCharacter(inst, "elong_body")
    MakeLargeFreezableCharacter(inst, "elong_body")

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 9
    inst.components.locomotor.runspeed = 9
    inst.components.locomotor:SetAllowPlatformHopping(true)

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(3)
    inst.components.sleeper.sleeptestfn = MountSleepTest
    inst.components.sleeper.waketestfn = ShouldWakeUp

    inst:AddComponent("timer")

    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem
    --inst.components.trader.deleteitemonaccept = false

    inst.ApplyBuildOverrides = ApplyBuildOverrides
    inst.ClearBuildOverrides = ClearBuildOverrides

    inst:ListenForEvent("ridersleep", OnRiderSleep)

    inst:ListenForEvent("onsink", OnSink)

    inst:AddComponent("embarker")
    inst:AddComponent("drownable")

    inst:AddComponent("colourtweener")

    inst:AddComponent("markable_proxy")

    inst.ShouldBeg = ShouldBeg

    inst.healthdeltafn = function(owner,data)
        local owner = inst.components.rideable.rider
        if owner and owner.elong_health then
            owner.elong_health:set(inst.components.health.currenthealth)
        end
    end

    inst:SetBrain(brain)
    inst:SetStateGraph("SGtz_elong")

    inst.GetIsInMood = function(...)
        return false
    end

    return inst
end
--DebugSpawn"tz_elong"
return Prefab("tz_elong", beefalo, assets)
