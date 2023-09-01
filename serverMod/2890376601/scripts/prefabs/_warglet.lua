local assets =
{
    Asset("ANIM", "anim/hound_basic.zip"),
    Asset("ANIM", "anim/hound_basic_water.zip"),
    Asset("ANIM", "anim/hound.zip"),
    Asset("ANIM", "anim/hound_ocean.zip"),
    Asset("ANIM", "anim/hound_warglet.zip"),
    Asset("SOUND", "sound/hound.fsb"),
}

local prefabs =
{
    "houndstooth",
    "monstermeat",
    "splash_green",
	"houndcorpse",
}

STRINGS.NAMES._WARGLET = "战狼幼崽 WARG CUB"

local brain = require("brains/_brain")

local sounds =
{
    pant = "dontstarve/creatures/hound/pant",
    attack = "dontstarve/creatures/hound/attack",
    bite = "dontstarve/creatures/hound/bite",
    bark = "dontstarve/creatures/hound/bark",
    death = "dontstarve/creatures/hound/death",
    sleep = "dontstarve/creatures/hound/sleep",
    growl = "dontstarve/creatures/hound/growl",
    howl = "dontstarve/creatures/together/clayhound/howl",
    hurt = "dontstarve/creatures/hound/hurt",
}

local function KeepTargetFn(inst, target)
    return target ~= nil
        and not (inst.sg:HasStateTag("hidden") or inst.sg:HasStateTag("statue"))
        and inst:IsNear(target, 40)
        and inst.components.combat:CanTarget(target)
        and not target.components.health:IsDead()
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30,
        function(dude)
            return not (dude.components.health ~= nil and dude.components.health:IsDead())
                and data.attacker ~= (dude.components.follower ~= nil and dude.components.follower.leader or nil)
        end, 5)
end

local function fncommon()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()
    MakeGhostPhysics(inst, 10, .5)
    --MakeCharacterPhysics(inst, 10, .5)
    local scale = 1.3
    inst.Transform:SetScale(scale*0.8,scale*0.8,scale*0.8)

    inst.DynamicShadow:SetSize(2.5, 1.5)
    inst.Transform:SetFourFaced()

	inst:AddTag("followme")
	inst:AddTag("mypet")
    inst:AddTag("hostile")
    inst:AddTag("canbestartled")    
	inst:AddTag("CRITTER_MUST_TAGS")
	inst:AddTag("critter")
    inst:AddTag("companion")
    inst:AddTag("notraptrigger")
    inst:AddTag("noauradamage")
    inst:AddTag("small_livestock")
    inst:AddTag("NOBLOCK")
	inst:AddTag("noplayertarget")

    inst.AnimState:SetBank("hound")
    inst.AnimState:SetBuild("hound_warglet")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.sounds = sounds
    inst.persists = false
    inst:AddComponent("locomotor")
    inst.components.locomotor.runspeed = TUNING.HOUND_SPEED * (1/scale)*1.5

    inst:SetStateGraph("SGhound")

	inst:AddComponent("embarker")
	inst.components.embarker.embark_speed = inst.components.locomotor.runspeed
    inst.components.embarker.antic = true

    inst.components.locomotor:SetAllowPlatformHopping(true)

	inst:AddComponent("amphibiouscreature")
	inst.components.amphibiouscreature:SetBanks("hound", "hound_water")
    inst.components.amphibiouscreature:SetEnterWaterFn(
        function(inst)
            inst.landspeed = inst.components.locomotor.runspeed 
            inst.components.locomotor.runspeed = TUNING.HOUND_SWIM_SPEED * (1/scale)
            inst.hop_distance = inst.components.locomotor.hop_distance
            inst.components.locomotor.hop_distance = 4
        end)
    inst.components.amphibiouscreature:SetExitWaterFn(
        function(inst)
            if inst.landspeed then
                inst.components.locomotor.runspeed = inst.landspeed
            end
            if inst.hop_distance then
                inst.components.locomotor.hop_distance = inst.hop_distance
            end
        end)

	inst.components.locomotor.pathcaps = { allowocean = true }

    inst:SetBrain(brain)

	inst:AddComponent("follower")
    inst.components.follower:KeepLeaderOnAttacked()
    inst.components.follower.keepdeadleader = true
    inst.components.follower.keepleaderduringminigame = true
		
    inst:AddComponent("entitytracker")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.warglethealth)

	inst:AddComponent("followme")

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.HOUND_DAMAGE *2)
    inst.components.combat:SetAttackPeriod(TUNING.HOUND_ATTACK_PERIOD)

    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
    inst.components.combat:SetHurtSound(inst.sounds.hurt)

    inst:AddComponent("lootdropper")

	inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = TUNING.SANITYAURA_TINY

    inst:AddComponent("inspectable")
    inst.components.inspectable.description = "这是宠物的宠物! This is my pet's pet"
	
    inst:DoPeriodicTask(5,function()
	    local pt = inst:GetPosition()
		local dog = {}
	    local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 25, {"mypet"}, {"FX", "NOCLICK", "DECOR", "INLIMBO", "playerghost","player"})
		for k,v in pairs(ents) do                          
            if v and v.prefab == "_warglet" then
				if v.components.follower:GetLeader() == inst.components.follower:GetLeader() then
					table.insert(dog, v)
				end
			end
		end
		if #dog > 3 then
			inst:Remove()
		end
    end)

    inst:DoPeriodicTask(60,function()
		inst:Remove()
    end)

    MakeHauntablePanic(inst)

    inst:ListenForEvent("attacked", OnAttacked)

    MakeMediumFreezableCharacter(inst, "hound_body")
    MakeMediumBurnableCharacter(inst, "hound_body")

    return inst
end

return Prefab("_warglet", fncommon, assets, prefabs)
