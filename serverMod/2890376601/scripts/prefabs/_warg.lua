local prefabs_basic =
{
    "monstermeat",
    "houndstooth",
}

local prefabs_wave = prefabs_basic

local assets =
{
    Asset("SOUND", "sound/vargr.fsb"),
	Asset("ANIM", "anim/warg_actions.zip"),
    Asset("ANIM", "anim/warg_build.zip")
}


local brain = require("brains/_wargbrain")

local sounds =
{
    idle = "dontstarve_DLC001/creatures/vargr/idle",
    howl = "dontstarve_DLC001/creatures/vargr/howl",
    hit = "dontstarve_DLC001/creatures/vargr/hit",
    attack = "dontstarve_DLC001/creatures/vargr/attack",
    death = "dontstarve_DLC001/creatures/vargr/death",
    sleep = "dontstarve_DLC001/creatures/vargr/sleep",
}

STRINGS.NAMES._WARG = "獠牙战狼 WARG"

local function KeepTargetFn(inst, target)
    return target ~= nil
        and not (inst.sg:HasStateTag("hidden") or inst.sg:HasStateTag("statue") or inst:HasTag("player"))
        and inst:IsNear(target, 10)
        and inst.components.combat:CanTarget(target)
        and not target.components.health:IsDead()
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, TUNING.WARG_MAXHELPERS,
    function(dude)
        return not (dude.components.health ~= nil and dude.components.health:IsDead())
            and data.attacker ~= (dude.components.follower ~= nil and dude.components.follower.leader or nil)
    end, TUNING.WARG_TARGETRANGE)
end

local function OnGetItemFromPlayer(inst, giver, item) 
	if inst.components.follower:GetLeader() == giver or not inst.components.follower:GetLeader() then
		if item.prefab == "monsterlasagna" then
			inst.components.health:DoDelta(inst.components.health.maxhealth*0.2)
			inst.sg:GoToState("attack")
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
	if item.prefab == "houndstooth" or item.prefab == "monsterlasagna" or item.prefab == "poop" then
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

local function MakeWarg(name, bank, build, prefabs)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddDynamicShadow()
        inst.entity:AddNetwork()
        inst.Transform:SetScale(0.8, 0.8, 0.8)
        inst.DynamicShadow:SetSize(2.5, 1.5)

        inst.Transform:SetSixFaced()

        MakeFlyingGiantCharacterPhysics(inst, 300, 1.4)

        inst:AddTag("warg")
        inst:AddTag("scarytoprey")
        inst:AddTag("largecreature")

        inst.AnimState:SetBank("warg")
        inst.AnimState:SetBuild("warg_build")
        inst.AnimState:PlayAnimation("idle_loop", true)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.dengji = 1

		inst:AddComponent("trader")
		inst.components.trader:SetAcceptTest(ShouldAcceptTest) 
		inst.components.trader.onaccept = OnGetItemFromPlayer
		inst:AddComponent("followme")
        inst:AddComponent("inspectable")
        inst.components.inspectable.description = "它不会伤害我！ It won't hurt me!"
        inst:AddComponent("locomotor")
        inst.components.locomotor.runspeed = TUNING.WARG_RUNSPEED*1.5
        inst.components.locomotor:SetShouldRun(true)
		inst.components.locomotor.pathcaps = { ignorewalls = true, allowocean = true }
        inst:AddComponent("embarker")
        inst.components.embarker.embark_speed = inst.components.locomotor.walkspeed
		
        inst:AddComponent("combat")
        inst.components.combat:SetDefaultDamage(inst.dengji*10+20)
        inst.components.combat:SetRange(TUNING.WARG_ATTACKRANGE)
        inst.components.combat:SetAttackPeriod(TUNING.WARG_ATTACKPERIOD)
        inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
        inst:ListenForEvent("attacked", OnAttacked)
		
		inst:AddComponent("follower")
	    inst.components.follower:KeepLeaderOnAttacked()
        inst.components.follower.keepdeadleader = true
        inst.components.follower.keepleaderduringminigame = true

		inst:AddTag("flying")
		inst:AddTag("ignorewalkableplatformdrowning")
		inst:AddTag("followme")
		inst:AddTag("mypet")
		inst:AddTag("CRITTER_MUST_TAGS")
		inst:AddTag("critter")
        inst:AddTag("companion")
        inst:AddTag("notraptrigger")
        inst:AddTag("noauradamage")
        inst:AddTag("small_livestock")
        inst:AddTag("NOBLOCK")
		inst:AddTag("noplayertarget")
		
	    inst:AddComponent("sanityaura")
        inst.components.sanityaura.aura = TUNING.SANITYAURA_TINY
	
        inst:AddComponent("health")
        inst.components.health:SetMaxHealth(TUNING.warghealth)

        inst:AddComponent("lootdropper")
		inst.components.lootdropper:SetLoot({"monsterlasagna", "houndstooth"})

        inst.components.combat:SetHurtSound("dontstarve_DLC001/creatures/vargr/hit")

        inst.sounds = sounds

        inst:DoPeriodicTask(TUNING.rehealth,function()
		    if inst.components.health.currenthealth > 0 then
                inst.components.health:DoDelta(1)
			end
        end)

		inst:DoPeriodicTask(5,function()
		    local pt = inst:GetPosition()
			local dog = {}
		    local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 25,{"mypet"}, {"FX", "NOCLICK", "DECOR", "INLIMBO", "playerghost","player"})
			for k,v in pairs(ents) do                          
                if v and v.prefab == "_warglet" then
                    table.insert(dog, v)
				end
			end
			if #dog < TUNING.wolf then
				if inst.components.follower:GetLeader() then
					inst.sg:GoToState("howl",{howl = true})
					inst:DoTaskInTime(2,function()
						if inst.components.follower:GetLeader() then
							local pet = SpawnPrefab("_warglet")
							local x,y,z = inst:GetPosition():Get()
							pet.Transform:SetPosition(x-10+20*math.random(),y,z-10+20*math.random())
							inst.components.follower:GetLeader().components.leader:AddFollower(pet)
						end
					end)
				end
			end
        end)

        MakeLargeBurnableCharacter(inst, "swap_fire")

        MakeLargeFreezableCharacter(inst)

        inst:SetStateGraph("SG_warg")

        inst:SetBrain(brain)
 
 	    inst.OnSave = onsave
	    inst.OnPreLoad = onpreload
		
        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end

return MakeWarg("_warg", "warg", "warg_build", prefabs_basic)
