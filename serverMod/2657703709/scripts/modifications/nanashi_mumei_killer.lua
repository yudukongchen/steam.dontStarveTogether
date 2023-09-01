local KillerDamageBoost = TUNING.NANASHI_MUMEI_KILLER_BONUS
local Say = require("modifications.nanashi_mumei_talker")

local nigthvision = require "modifications.nanashi_mumei_nightvision"

--#region TOGGLE
local function ToggleOffPhysics(inst)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.GROUND)
    local x,y,z = inst.Transform:GetWorldPosition()
    if TheWorld.Map:IsPassableAtPoint(x,y,z) then
        inst.sx,inst.sy,inst.sz = inst.Transform:GetWorldPosition()
    end
end

local function ToggleOnPhysics(inst)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:CollidesWith(COLLISION.GIANTS)
    local x,y,z = inst.Transform:GetWorldPosition()
    local is_on_land = TheWorld.Map:IsPassableAtPoint(x, y, z)
    if not is_on_land and not TheWorld.has_ocean then
        if inst.sx and inst.sy and inst.sz then
            inst.Transform:SetPosition(inst.sx,inst.sy,inst.sz)
        else
            local fx2 = SpawnPrefab("slurper_respawn")
			fx2.Transform:SetPosition(inst.Transform:GetWorldPosition())
			inst:RemoveTag("drowningSafety")
			local dest = FindNearbyLand(inst:GetPosition(), 8)
			if not dest then
				dest = Vector3(FindRandomPointOnShoreFromOcean(inst.Transform:GetWorldPosition()))
			end
            if dest then
                if inst.Physics ~= nil then
                    inst.Physics:Teleport(dest:Get())
                elseif inst.Transform ~= nil then
                    inst.Transform:SetPosition(dest:Get())
                end
                local fx = SpawnPrefab("statue_transition_2")
                fx.Transform:SetPosition(dest:Get())
            end

            inst:ClearBufferedAction()
        end
    elseif is_on_land then
        inst:RemoveTag("drowningSafety")
    end
end
--#endregion

local killer_quotes = {
    "I, just remembered something.",
    "I'm sorry",
    "I'm so sorry.",
    "I'm here to kill!",
    "Hi!"
}

local normal_qoutes ={
    "What was I doing?",
    "Oh?",
    "?",
}
local function miss(inst, data)
    local target = data and data.target
    local dagger = inst.components.inventory and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
    or inst.replica.inventory and inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil

    if target and target:IsValid() and not target:HasTag("INLIMBO") and target:HasTag("_health") and target:HasTag("_combat") 
    and dagger and dagger:HasTag("weapon") then
        target.components.combat:GetAttacked(inst, inst.components.combat:CalcDamage(target, dagger), dagger)
    end
end
local function killer_toggle(inst)


    if inst._nanashi_mumei_killer:value() then
        inst:AddTag("drowningSafety")
        inst:ListenForEvent("onmissother",miss)
        ToggleOffPhysics(inst)
        if inst.components.locomotor then
            inst.components.locomotor:Stop()
            inst.components.locomotor:SetExternalSpeedMultiplier(inst, "nanashi_mumei_killer_speed", TUNING.NANASHI_MUMEI_KILLER_MOVESPEED)
        end
        if TheWorld.ismastersim then
            inst.components.combat.hitrange = TUNING.DEFAULT_ATTACK_RANGE*3
            inst.components.combat.externaldamagemultipliers:SetModifier(inst, KillerDamageBoost,"nanashi_mumei_killer")
            inst.components.skinner:SetSkinMode("killer_skin")
            inst._look_for_kill = inst:DoPeriodicTask(0,function (inst)
                local target = inst.components.combat.target
                if (target and target.components.health:GetPercent() <= 0) or 
                (target and not target:IsValid() )then
                    inst.components.combat:SetTarget(nil)
                end
                if not target then
                    local COMBAT_RANGE = 15
                    local COMBAT_MUSHAVE_TAGS = { "_combat", "_health" }
                    local COMBAT_CANTHAVE_TAGS = { "INLIMBO", "noauradamage", "structure", "wall" ,"companion","notdrawable"}
                    local COMBAT_MUSTONEOF_TAGS_AGGRESSIVE = { "monster", "prey", "insect", "hostile", "character", "animal","smallcreature"}
                    
                    if inst._no_victim_found then
                        COMBAT_RANGE = COMBAT_RANGE * 3
                    end
                    local ix, iy, iz = inst.Transform:GetWorldPosition()
                    local entities_near_me = TheSim:FindEntities(
                        ix, iy, iz, COMBAT_RANGE,
                        COMBAT_MUSHAVE_TAGS, COMBAT_CANTHAVE_TAGS, COMBAT_MUSTONEOF_TAGS_AGGRESSIVE
                    )
                    local prio
                    for _, v in pairs(entities_near_me) do
                        if ( v ~= inst and v.components.health:GetPercent() > 0)
                        then
                            if not prio then
                                prio = v
                                if prio.components.combat.target and prio.components.combat.target == inst then
                                    break
                                elseif (prio:HasTag("player") and TheNet:GetPVPEnabled()) or prio:HasTag("hostile") then
                                    break
                                end
                            elseif prio and v:HasTag("hostile") and not prio:HasTag("hostile") then
                                prio = v
                                break
                            elseif v.components.combat.target and v.components.combat.target == inst then
                                prio = v
                                break
                            else
                                prio = v
                            end
                        end
                    end
                    if prio ~= target then
                        inst.components.combat:SetTarget(prio)
                        inst._no_victim_found = false
                    elseif not inst.components.combat.target then
                        inst._no_victim_found = true
                    end
                end
            end)
        end
        inst._spawn_killer_shadow_fx = inst:DoPeriodicTask(0.1,function ()
            if inst.AnimState and inst.AnimState:IsCurrentAnimation("run_loop") and TheWorld.ismastersim then
                local fx = SpawnPrefab("nanashi_mumei_shadow")
                fx._owner = inst
                fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
                fx.Transform:SetRotation(fx._owner.Transform:GetRotation())
                local weapon = (inst.components.inventory and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)) 
                or (inst.replica.inventory and inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)) or nil
                if weapon then
                    local swap_build, swap_sym = inst.AnimState:GetSymbolOverride("swap_object")
                    local swap_build_lant, swap_sym_lant = inst.AnimState:GetSymbolOverride("lantern_overlay")
                    fx.AnimState:Show("ARM_carry")
                    fx.AnimState:Hide("ARM_normal")
                    if swap_build and swap_sym and weapon.prefab ~= "shieldofterror" then
                        fx.AnimState:OverrideSymbol("swap_object",swap_build,swap_sym)
                    elseif swap_build_lant and swap_sym_lant then
                        fx.AnimState:OverrideSymbol("lantern_overlay", "swap_eye_shield", "swap_shield")
                    end
                end
            end
        end)
        nigthvision(inst)
        inst:RestartBrain()
        if inst.components.playercontroller then
            inst.components.playercontroller:RemoteStopWalking()
            inst.components.playercontroller:Deactivate()
        end
    elseif not inst._nanashi_mumei_killer:value() then
        inst:RemoveEventCallback("onmissother",miss)
        if TheWorld.ismastersim then
            inst.components.combat.hitrange = TUNING.DEFAULT_ATTACK_RANGE
            inst.components.combat.externaldamagemultipliers:RemoveModifier(inst,"nanashi_mumei_killer")
            if not inst:HasTag("playerghost") then
                inst.components.skinner:SetSkinMode("normal_skin")
            end
            if  inst._look_for_kill then
                inst._look_for_kill:Cancel()
                inst._look_for_kill = nil
                inst.components.combat:SetTarget(nil)
            end
            if inst._spawn_killer_shadow_fx then
                inst._spawn_killer_shadow_fx:Cancel()
                inst._spawn_killer_shadow_fx = nil
            end
        end
        nigthvision(inst)
        inst:StopBrain()
        inst:ClearBufferedAction()
        if inst.components.playercontroller then
            inst.components.playercontroller:RemoteStopWalking()
            inst.components.playercontroller:Activate()
        end
        if inst.components.locomotor then
            inst.components.locomotor:Stop()
            inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "nanashi_mumei_killer_speed")
        end
        ToggleOnPhysics(inst)
    end
end

local function killer(inst)
    inst._nanashi_mumei_killer = net_bool(inst.GUID,"nanashi_mumei._nanashi_mumei_killer","_nanashi_mumei_killer_dirty")

    local old_Say = inst.components.talker.Say
    local function talker(inst)
        if inst.components.talker then
            if inst._nanashi_mumei_killer:value() then
                inst.components.talker.Say = Say
                inst:DoTaskInTime(0.1,function ()
                    inst.components.talker:Say(killer_quotes[math.rad(#killer_quotes)],1)
                end)
            else
                inst.components.talker.Say = old_Say
                inst:DoTaskInTime(0.1,function ()
                    inst.components.talker:Say(normal_qoutes[math.rad(#normal_qoutes)],1)
                end)
            end
        end
    end
    inst:ListenForEvent("_nanashi_mumei_killer_dirty",function (inst)
        killer_toggle(inst)
        talker(inst)
    end)
    inst:ListenForEvent("onhitother",function (inst,data)
        local target = data.target
        if target ~= nil and inst._nanashi_mumei_killer:value() then
            if not target.components.debuffable then
                target:AddComponent("debuffable")
            end
            if target.components.debuffable
            then
                target.components.debuffable:AddDebuff("buff_nanashi_mumei_terror_debuff_effect", "buff_nanashi_mumei_terror_debuff_effect")
            end
        end
    end)
    inst:ListenForEvent("makeplayerghost",function ()
        inst._nanashi_mumei_killer:set(false)
    end,inst)
    inst:ListenForEvent("death",function ()
		inst._nanashi_mumei_killer:set(false)
	end,inst)
end

return killer