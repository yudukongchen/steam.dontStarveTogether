local brain = require "brains/shadowtzbrain"
SetSharedLootTable("shadowtz",
{
    { "nightmarefuel",  0.5 },
})
local function retargetfn(inst) 
    local leader = inst.components.follower:GetLeader() 
    return leader ~= nil
        and FindEntity(
            leader,
            TUNING.SHADOWWAXWELL_TARGET_DIST,
            function(guy)
                return guy ~= inst
                    and (guy.components.combat:TargetIs(leader) or
                        guy.components.combat:TargetIs(inst))
                    and inst.components.combat:CanTarget(guy)
            end,
            { "_combat" }, 
            { "playerghost", "INLIMBO" }
        )
        or nil
end

local function keeptargetfn(inst, target) 
    return inst.components.follower:IsNearLeader(18)
        and inst.components.combat:CanTarget(target)
end
local function OnAttacked(inst, data)
    if data.attacker ~= nil then
        if data.attacker.components.tzpetshadow ~= nil and
            data.attacker.components.tzpetshadow:IsPet(inst) then
            if inst.components.health and not inst.components.health:IsDead() then
				inst.components.health:Kill()
			end
		elseif data.attacker.components.combat ~= nil then
            inst.components.combat:SuggestTarget(data.attacker)
        end
    end
end

local function OnTimerDone(inst, data)
    inst:Remove()
end

local function MakeShadowTz(data)
    local bank = data.bank 
    local build = data.build 

    local assets =
    {
        Asset("ANIM", "anim/"..data.build..".zip"),
    }

    local sounds = 
    {
        attack = "dontstarve/sanity/creature"..data.num.."/attack",
        attack_grunt = "dontstarve/sanity/creature"..data.num.."/attack_grunt",
        death = "dontstarve/sanity/creature"..data.num.."/die",
        idle = "dontstarve/sanity/creature"..data.num.."/idle",
        taunt = "dontstarve/sanity/creature"..data.num.."/taunt",
        appear = "dontstarve/sanity/creature"..data.num.."/appear",
        disappear = "dontstarve/sanity/creature"..data.num.."/dissappear",
    }

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        inst.Transform:SetFourFaced()

		MakeGhostPhysics(inst, 1, 0.5)
       
        inst.AnimState:SetBank(bank)
        inst.AnimState:SetBuild(build)
        inst.AnimState:PlayAnimation("idle_loop")
        inst.AnimState:SetMultColour(1, 1, 1, 0.5)
		inst.Transform:SetScale(data.tx, data.tx,data.tx)

        if not data.fh_ml then
            inst:AddTag("tzxiaoyingguai")
        else
            inst:AddTag("tz_ml_pet")
            inst:SetPrefabNameOverride(data.prefabname or "tz_nightmare2")
        end

        inst:AddTag("notraptrigger")
        inst:AddTag("scarytoprey")
        inst:AddTag("shadowminion")
        inst:AddTag("NOBLOCK")
		inst:AddTag("companion")
        inst:AddTag("bramble_resistant")
        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end
            
        inst:AddComponent("locomotor") 
        inst.components.locomotor.walkspeed =  data.speed

		inst:AddComponent("inspectable")
		--inst:AddComponent("inventory")
		
        inst:AddComponent("health")
        inst.components.health:SetMaxHealth(data.health)
		inst.components.health.nofadeout = true
		inst.components.health.absorb = data.armor

        inst:AddComponent("combat")
        inst.components.combat:SetDefaultDamage(data.damage)
        inst.components.combat:SetAttackPeriod(data.attackperiod)
        inst.components.combat:SetRetargetFunction(2, retargetfn)
		inst.components.combat:SetKeepTargetFunction(keeptargetfn)
		
        inst:AddComponent("follower")
        inst.components.follower:KeepLeaderOnAttacked()
        inst.components.follower.keepdeadleader = true

        inst:AddComponent("lootdropper")
        inst.components.lootdropper:SetChanceLootTable('shadowtz')

        inst:SetBrain(brain)
        inst.sounds = sounds
        inst:SetStateGraph("SGshadowcreature")
        inst:AddComponent("knownlocations")
        inst:ListenForEvent("attacked", OnAttacked)

        if data.fh_ml then
            inst:AddComponent("timer")
            inst:ListenForEvent("timerdone", OnTimerDone)
        end
        return inst
    end
    return Prefab(data.name, fn, assets, prefabs)
end

local data =
{
    {
        name = "tz_nightmare1", 
        build = "shadow_insanity1_basic",
        bank = "shadowcreature1",
        num = 1,
        tx = 0.3,
        speed = 25,
        health = 150,
        damage = 30,
        armor = 0.2,
        attackperiod = 2.5, 
    },
    {
        name = "tz_nightmare2", 
        build = "shadow_insanity2_basic",
        bank = "shadowcreature2",
        num = 2,
        tx = 0.3,
        speed = 20,
        health = 250,
        damage = 45,
        armor = 0.2,
        attackperiod = 1.5,
    },
    {
        name = "tz_nightmare3", 
        build = "shadow_insanity2_basic",
        bank = "shadowcreature2",
        num = 2,
        fh_ml = true,
        tx = 0.3,
        speed = 20,
        health = 250,
        damage = 45,
        armor = 0.2,
        prefabname = "tz_nightmare2",
        attackperiod = 1.5,
    },
    {
        name = "tz_creature1", 
        build = "tz_creature1",
        bank = "tz_creature1",
        num = 1,
        tx = 0.54,
        speed = 25,
        health = 300,
        damage = 50,
        armor = 0.4,
        attackperiod = 2.5, 
    },
    {
        name = "tz_creature2", 
        build = "tz_creature2",
        bank = "tz_creature2",
        num = 2,
        tx = 0.54,
        speed = 20,
        health = 400,
        damage = 80,
        armor = 0.4,
        attackperiod = 1.5,
    },
    {
        name = "tz_creature3", 
        build = "tz_creature2",
        bank = "tz_creature2",
        num = 2,
        tx = 0.54,
        speed = 20,
        health = 400,
        damage = 80,
        armor = 0.4,
        attackperiod = 1.5,
        prefabname = "tz_creature2",
        fh_ml = true,
    },
}

local ret = {}
for i, v in ipairs(data) do
    table.insert(ret, MakeShadowTz(v))
end

return unpack(ret) 