local brain = require("brains/_flybrain")

local assets =
{
    Asset("ANIM", "anim/dragonfly_build.zip"),
    Asset("ANIM", "anim/dragonfly_fire_build.zip"),
    Asset("ANIM", "anim/dragonfly_basic.zip"),
    Asset("ANIM", "anim/dragonfly_actions.zip"),
    Asset("ANIM", "anim/dragonfly_yule_build.zip"),
    Asset("ANIM", "anim/dragonfly_fire_yule_build.zip"),
    Asset("SOUND", "sound/dragonfly.fsb"),
}

local prefabs =
{
    "firesplash_fx",
    "tauntfire_fx",
    "attackfire_fx",
    "vomitfire_fx",
    "firering_fx",
}

STRINGS.NAMES._DRAGONFLY = "战火怒龙 DRAGONFLY"

function starttask(inst)
	if inst.brain then 
		inst.brain:Start()
	end
end

function stoptask(inst)
	if inst.brain then 
		inst.brain:Stop()
	end
end

local function TransformNormal(inst)
    inst.AnimState:SetBuild(IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) and "dragonfly_yule_build" or "dragonfly_build")
    inst.enraged = false

    inst.components.locomotor.walkspeed = TUNING.DRAGONFLY_SPEED
    inst.components.combat:SetDefaultDamage(inst.dengji*10+20)
    inst.components.combat:SetAttackPeriod(TUNING.DRAGONFLY_ATTACK_PERIOD)
    inst.components.combat:SetRange(TUNING.DRAGONFLY_ATTACK_RANGE, TUNING.DRAGONFLY_HIT_RANGE)

    inst.components.freezable:SetResistance(TUNING.DRAGONFLY_FREEZE_THRESHOLD)

    inst.Light:Enable(false)
end

local function _OnRevert(inst)
    inst.reverttask = nil
    if inst.enraged then
        inst:PushEvent("transform", { transformstate = "normal" })
    end
end

local function TransformFire(inst)
    inst.AnimState:SetBuild(IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) and "dragonfly_fire_yule_build" or "dragonfly_fire_build")
    inst.enraged = true
    inst.can_ground_pound = true
    inst.components.locomotor.walkspeed = TUNING.DRAGONFLY_FIRE_SPEED
    inst.components.combat:SetDefaultDamage(TUNING.DRAGONFLY_FIRE_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.DRAGONFLY_FIRE_ATTACK_PERIOD)
    inst.components.combat:SetRange(TUNING.DRAGONFLY_ATTACK_RANGE, TUNING.DRAGONFLY_FIRE_HIT_RANGE)

    inst.Light:Enable(true)

    inst.components.moisture:DoDelta(-inst.components.moisture:GetMoisture())

    inst.components.freezable:SetResistance(TUNING.DRAGONFLY_ENRAGED_FREEZE_THRESHOLD)

    if inst.reverttask ~= nil then
        inst.reverttask:Cancel()
    end
    inst.reverttask = inst:DoTaskInTime(TUNING.DRAGONFLY_ENRAGE_DURATION/2, _OnRevert)
end
--[[
local function RetargetFn(inst)

    local target = inst.components.combat.target

    local inrange = target ~= nil and inst:IsNear(target, TUNING.DRAGONFLY_ATTACK_RANGE + target:GetPhysicsRadius(0))
    local nearplayers = {}
    for k, v in pairs(inst.components.grouptargeter:GetTargets()) do
        if inst:IsNear(k, inrange and TUNING.DRAGONFLY_ATTACK_RANGE + k:GetPhysicsRadius(0) or TUNING.DRAGONFLY_AGGRO_DIST) then
            table.insert(nearplayers, k)
        end
    end
    return #nearplayers > 0 and nearplayers[math.random(#nearplayers)] or nil, true
end]]

local function OnHealthTrigger(inst)
    inst:PushEvent("transform", { transformstate = "fire" })
end

local function KeepTargetFn(inst, target)
    return target ~= nil
        and not (inst.sg:HasStateTag("hidden") or inst.sg:HasStateTag("statue") or inst:HasTag("player"))
        and inst:IsNear(target, 10)
        and inst.components.combat:CanTarget(target)
        and not target.components.health:IsDead()
end

local function OnTimerDone(inst, data)
    if data.name == "groundpound_cd" then
        inst.can_ground_pound = true
    end
end

local function OnAttacked(inst, data)
    if data.attacker ~= nil then
        local target = inst.components.combat.target
        if not (target ~= nil and
                target:IsNear(inst, TUNING.DRAGONFLY_ATTACK_RANGE + target:GetPhysicsRadius(0))) then
            inst.components.combat:SetTarget(data.attacker)
        end
    end
end

local function OnGetItemFromPlayer(inst, giver, item) 
	if inst.components.follower:GetLeader() == giver or not inst.components.follower:GetLeader() then
		if item.prefab == "hotchili" then
			inst.components.health:DoDelta(inst.components.health.maxhealth*0.2)
			inst.sg:GoToState("transform_fire") 
		elseif item.prefab == "poop" then
			inst.components.health:DoDelta(-inst.components.health.maxhealth*0.4)
			giver.components.talker:Say("它好像受伤了 it seems to be hurt")
		else
			if inst.dengji == 1 then
				inst.dengji = 2
				inst.components.combat:SetDefaultDamage(40)
				giver.components.talker:Say("当前攻击力：40 ATK:40")
			elseif inst.dengji == 2 then
				inst.dengji = 3
				inst.components.combat:SetDefaultDamage(50)
				giver.components.talker:Say("当前攻击力：50 ATK:50")
			else 
				giver.components.talker:Say("已满级 Full level")
			end
		end
	else
		if giver.components.talker then
			giver.components.talker:Say("它不吃陌生人的食物 It doesn't eat strangers' food")
			local x,y,z = inst:GetPosition():Get()
			SpawnPrefab(item.prefab).Transform:SetPosition(x+2*math.random()-1,y+3,z+2*math.random()-1)
		end
	end
end

local function ShouldAcceptTest(inst, item)
	if item.prefab == "redgem" or item.prefab == "dragon_scales" or item.prefab == "hotchili" or item.prefab == "poop" then
	    return true
    end
    return false
end

local function onpreload(inst,data)
    if data.dengji then
        inst.dengji = data.dengji
	    inst.components.combat:SetDefaultDamage(inst.dengji*10+20)
	end
end

local function onsave(inst,data)
    data.dengji = inst.dengji
end

local function linktoplayer(inst, player)
    player.components.leader:AddFollower(inst)
	inst._playerlink = player
    inst:ListenForEvent("onremove", inst._onlostplayerlink, player)
end

local function setloot(inst)
	local x,y,z = inst:GetPosition():Get()
	SpawnPrefab("hotchili").Transform:SetPosition(x,y+5,z)
	SpawnPrefab("lavae_cocoon").Transform:SetPosition(x,y+5,z)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.DynamicShadow:SetSize(6, 3.5)
    inst.Transform:SetSixFaced()
    inst.Transform:SetScale(0.75, 0.75, 0.75)

    MakeFlyingGiantCharacterPhysics(inst, 300, 1.4)

    inst.AnimState:SetBank("dragonfly")
    inst.AnimState:SetBuild(IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) and "dragonfly_yule_build" or "dragonfly_build")
    inst.AnimState:PlayAnimation("idle", true)

	inst:AddTag("followme")
	inst:AddTag("mypet")
    inst:AddTag("largecreature")
    inst:AddTag("flying")
    inst:AddTag("ignorewalkableplatformdrowning")
	inst:AddTag("noabandon")
	inst:AddTag("CRITTER_MUST_TAGS")
	inst:AddTag("critter")
    inst:AddTag("companion")
    inst:AddTag("notraptrigger")
    inst:AddTag("noauradamage")
    inst:AddTag("small_livestock")
    inst:AddTag("NOBLOCK")
    inst:AddTag("noplayertarget")

    inst.Light:Enable(false)
    inst.Light:SetRadius(2)
    inst.Light:SetFalloff(0.5)
    inst.Light:SetIntensity(0.75)
    inst.Light:SetColour(235/255, 121/255, 12/255)

    inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/fly", "flying")

    inst._isengaged = net_bool(inst.GUID, "dragonfly._isengaged", "isengageddirty")
    inst._playingmusic = false
    inst._musictask = nil

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.dengji = 1

	inst.stoptask = nil
	inst.starttask = inst:DoPeriodicTask(1,starttask)

	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(ShouldAcceptTest) 
	inst.components.trader.onaccept = OnGetItemFromPlayer
	inst:AddComponent("followme")
    inst:AddComponent("inspectable")
    inst.components.inspectable.description = "这是一条龙 This is a dragon"

    inst:AddComponent("health")
    inst:AddComponent("groundpounder")
    inst:AddComponent("combat")
    inst:AddComponent("explosiveresist")

	inst:ListenForEvent("death", setloot)
    inst:AddComponent("locomotor")
    inst:AddComponent("cooker")
    --inst:AddComponent("inventory")
    inst:AddComponent("timer")
    --inst:AddComponent("grouptargeter")
    inst:AddComponent("propagator")
    inst:AddComponent("healthtrigger")
    inst:AddComponent("moisture")
	
    inst:SetStateGraph("SGdragonfly")

	inst:AddComponent("follower")
    inst.components.follower:KeepLeaderOnAttacked()
    inst.components.follower.keepdeadleader = true
    inst.components.follower.keepleaderduringminigame = true

    inst.components.healthtrigger:AddTrigger(0.8, OnHealthTrigger)
    inst.components.healthtrigger:AddTrigger(0.5, OnHealthTrigger)
    inst.components.healthtrigger:AddTrigger(0.2, OnHealthTrigger)

    inst.components.health:SetMaxHealth(TUNING.flyhealth)
    inst.components.health.nofadeout = true
    inst.components.health.fire_damage_scale = 0

    inst.components.groundpounder.numRings = 2
    inst.components.groundpounder.groundpoundfx = "firesplash_fx"
    inst.components.groundpounder.groundpounddamagemult = 0.5
    inst.components.groundpounder.groundpoundringfx = "firering_fx"
    inst.components.groundpounder.noTags = { "FX", "NOCLICK", "DECOR", "INLIMBO","player","critter"}

    inst.components.combat:SetAttackPeriod(TUNING.DRAGONFLY_ATTACK_PERIOD)
    inst.components.combat:SetDefaultDamage(inst.dengji*10+20)
    inst.components.combat:SetRange(TUNING.DRAGONFLY_ATTACK_RANGE, TUNING.DRAGONFLY_HIT_RANGE)
    --inst.components.combat:SetRetargetFunction(3, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
    inst.components.combat.battlecryenabled = false
    inst.components.combat.hiteffectsymbol = "dragonfly_body"
    inst.components.combat:SetHurtSound("dontstarve_DLC001/creatures/dragonfly/hurt")

	inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = TUNING.SANITYAURA_TINY
	inst:AddComponent("embarker")
    inst.components.embarker.embark_speed = inst.components.locomotor.walkspeed
	
	inst.LinkToPlayer = linktoplayer
	inst._onlostplayerlink = function(player) inst._playerlink = nil end
	
    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorewalls = true, allowocean = true }
    inst.components.locomotor.walkspeed = TUNING.DRAGONFLY_SPEED*1.5

    inst._ontargetdeathtask = nil

    inst:ListenForEvent("moisturedelta", OnMoistureDelta)
    inst:ListenForEvent("timerdone", OnTimerDone)
    inst:ListenForEvent("attacked", OnAttacked)

    inst.TransformFire = TransformFire
    inst.TransformNormal = TransformNormal
    inst.can_ground_pound = false
	
	inst:DoPeriodicTask(TUNING.rehealth,function()
        if inst.components.health.currenthealth > 0 then
            inst.components.health:DoDelta(1)
		end
    end)

    MakeHugeFreezableCharacter(inst)
    inst.components.freezable:SetResistance(TUNING.DRAGONFLY_FREEZE_THRESHOLD)
    inst.components.freezable.damagetobreak = TUNING.DRAGONFLY_FREEZE_RESIST
    inst.components.freezable.diminishingreturns = true
	
	inst:SetBrain(brain)
	
    inst.OnSave = onsave
	inst.OnPreLoad = onpreload

    return inst
end

return Prefab("_dragonfly", fn, assets, prefabs)
