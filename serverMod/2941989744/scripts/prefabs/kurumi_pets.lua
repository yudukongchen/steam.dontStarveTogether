local brain = require "brains/krm_pet_brain"

local function OnAttacked(inst, data) 
    if data.attacker ~= nil then
		if data.attacker.components.combat ~= nil and inst.components.combat then
            inst.components.combat:SuggestTarget(data.attacker)
        end
    end
end

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
    return inst.components.follower:IsNearLeader(16)
        and inst.components.combat:CanTarget(target)
end

local function MakePet(name, maxhealth, damage, combatrange, maxnum, damagemultiplier)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()
		inst.entity:AddDynamicShadow()

        MakeGhostPhysics(inst, 1, 0.5)
		inst.DynamicShadow:SetSize(1.3, .6)

        inst.Transform:SetFourFaced(inst)
		
        inst.AnimState:SetBank("wilson")
        inst.AnimState:SetBuild("kurumi")
        inst.AnimState:PlayAnimation("idle")
        --inst.AnimState:SetMultColour(0, 0, 0, 1)
        local colour1 = math.random(1, 255)
        local colour2 = math.random(1, 255)
        local colour3 = math.random(1, 255)

        inst.AnimState:SetMultColour(colour1/255, colour2/255, colour3/255, 0.6) 

        inst.AnimState:Hide("ARM_carry")
        inst.AnimState:Show("ARM_normal")

        inst.AnimState:Hide("HEAD")
        inst.AnimState:Show("HEAD_HAT")

		inst:AddTag("trader")
		inst:AddTag("companion")
		inst:AddTag("NOBLOCK")
		inst:AddTag("scarytoprey")

        inst:AddTag("krm_pet")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then 
            return inst
        end

        inst:AddComponent("timer")
        inst:ListenForEvent("timerdone", function(inst, data)--
            if data.name == "DoRemove" then
                inst.sg:GoToState("death")                                                                                                         
            end             
        end)        

        inst:AddComponent("locomotor")
        inst.components.locomotor.walkspeed = 8       
        inst.components.locomotor.runspeed = 10
        inst.components.locomotor.pathcaps = { ignorecreep = true }

        inst:AddComponent("health")
        inst.components.health:SetMaxHealth(maxhealth)

        inst:AddComponent("combat")
        inst.components.combat.hiteffectsymbol = "torso"
        inst.components.combat.damagemultiplier = 1
        inst.components.combat:SetRange(combatrange)
	    inst.components.combat:SetDefaultDamage(TUNING.NIGHTSWORD_DAMAGE)
		inst.components.combat:SetAttackPeriod(1)

        inst:ListenForEvent("attacked", OnAttacked)
        --inst:ListenForEvent("onhitother", OnHitOther)

        inst:SetBrain(brain)                     

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

		inst:AddComponent("inspectable")
         
        inst:SetStateGraph("SGkrm_pet")

        inst.not_active = true

        return inst
    end

    return Prefab("krm_"..name, fn) 
end

--local x, y, z = ThePlayer:GetPosition():Get() ThePlayer.components.krm_pets:SpawnPetAt(x, 0, z, "krm_pet1", true)

return MakePet("pet1", 300, 20, 2.5, 3, 1)
