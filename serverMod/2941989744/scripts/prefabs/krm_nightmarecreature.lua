local prefabs =
{
    "nightmarefuel",
}

local brain = require( "brains/krm_shadow_pet_brain")

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
            { "_combat" }, -- see entityreplica.lua
            { "playerghost", "INLIMBO", "krm_pet", "player" }
        )
        or nil
end

local function keeptargetfn(inst, target)
    return inst.components.combat:CanTarget(target)
end

local function CanShareTargetWith(dude)
    return dude:HasTag("krm_shadow_pet") and not dude.components.health:IsDead()
end

local function OnAttacked(inst, data)
    if data.attacker ~= nil then
        inst.components.combat:SetTarget(data.attacker)
        inst.components.combat:ShareTarget(data.attacker, 30, CanShareTargetWith, 1)
    end
end

local function OnHitOther(inst, data) 
    if data.target ~= nil and data.target.components.combat then
        data.target.components.combat:SuggestTarget(inst)
    end
end

local function MakeShadowCreature(data)
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

        MakeCharacterPhysics(inst, 10, 1.5)
        RemovePhysicsColliders(inst)
        inst.Physics:SetCollisionGroup(COLLISION.SANITY)
        inst.Physics:CollidesWith(COLLISION.SANITY)

        inst.AnimState:SetBank(bank)
        inst.AnimState:SetBuild(build)
        inst.AnimState:PlayAnimation("idle_loop")
        inst.AnimState:SetMultColour(1, 1, 1, 0.5)
        inst.Transform:SetScale(0.6, 0.6, 0.6)

        --inst:AddTag("shadow")
        inst:AddTag("companion")
        inst:AddTag("krm_pet")
        inst:AddTag("krm_shadow_pet")

        inst.nameoverride = "crawlingnightmare"

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
	    inst.components.locomotor:SetTriggersCreep(false)
        inst.components.locomotor.pathcaps = { ignorecreep = true }
        inst.components.locomotor.walkspeed = data.speed
        inst.sounds = sounds

        inst:SetStateGraph("SGshadowcreature")
        inst:SetBrain(brain)

        inst:AddComponent("health")
        inst.components.health:SetMaxHealth(data.health)

        inst:AddComponent("combat")
        inst.components.combat:SetDefaultDamage(data.damage)
        inst.components.combat:SetAttackPeriod(data.attackperiod)
        inst.components.combat:SetRetargetFunction(3, retargetfn)
        inst.components.combat:SetKeepTargetFunction(keeptargetfn)

        inst:ListenForEvent("attacked", OnAttacked)
        inst:ListenForEvent("onhitother", OnHitOther)

        inst:AddComponent("follower")
        inst.components.follower:KeepLeaderOnAttacked()
        inst.components.follower.keepdeadleader = true
        inst.components.follower.keepleaderduringminigame = true

        inst.components.follower.StartLeashing = function(self)
            if self._onleaderwake == nil and self.leader ~= nil then
               self._onleaderwake = function() OnEntitySleep(self.inst) end
               self.inst:ListenForEvent("entitywake", self._onleaderwake, self.leader)
               self.inst:ListenForEvent("entitysleep", OnEntitySleep)
            end

            self.inst:PushEvent("startleashing")
        end  

        inst:AddComponent("shadowsubmissive")

        inst:AddComponent("lootdropper")

        inst:AddComponent("knownlocations")

        inst.persists = false

        return inst
    end

    return Prefab(data.name, fn, assets, prefabs)
end

local data =
{
    {
        name = "krm_crawlingnightmare",
        build = "shadow_insanity1_basic",
        bank = "shadowcreature1",
        num = 1,
        speed = TUNING.CRAWLINGHORROR_SPEED*2,
        health = 250,
        damage = 20,
        attackperiod = TUNING.CRAWLINGHORROR_ATTACK_PERIOD,
        sanityreward = TUNING.SANITY_MED,
    },
    {
        name = "krm_nightmarebeak",
        build = "shadow_insanity2_basic",
        bank = "shadowcreature2",
        num = 2,
        speed = TUNING.TERRORBEAK_SPEED*2,
        health = 150,
        damage = 30,
        attackperiod = TUNING.TERRORBEAK_ATTACK_PERIOD,
        sanityreward = TUNING.SANITY_LARGE,
    },
}

local ret = {}
for i, v in ipairs(data) do
    table.insert(ret, MakeShadowCreature(v))
end

return unpack(ret)
