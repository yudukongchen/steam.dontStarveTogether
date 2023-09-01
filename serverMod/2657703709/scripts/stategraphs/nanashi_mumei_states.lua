local GLOBAL = GLOBAL
local FRAMES = GLOBAL.FRAMES
local EQUIPSLOTS = GLOBAL.EQUIPSLOTS

local function cooldownAttack(cooldown)
    return cooldown * (TUNING.NANASHI_MUMEI_DAGGER_ATKSPEED_BONUS/TUNING.WILSON_ATTACK_PERIOD*1.5)
end

local function nanashi_mumeistates(sg,client)

    local attack = sg.states["attack"]  
    if attack and not client then
        local old_attack_onenter = attack.onenter
        attack.onenter = function(inst,...)
            if inst._nanashi_mumei_killer and inst._nanashi_mumei_killer:value() then -- Fixes broken animation
                inst.sg:RemoveStateTag("autopredict")
                inst.sg:AddStateTag("pausepredict")
            end
            if inst.components.combat ~= nil and inst.prefab == "nanashi_mumei" and inst:HasTag("NANASHI_MUMEI_DAGGER_EQUIP")
            and (inst.components.rider and not inst.components.rider:IsRiding()) 
            and TUNING.NANASHI_MUMEI_DAGGER_ATKSPEED_BONUS ~= 0.4
            then
                if inst.components.combat:InCooldown() then
                    inst.sg:RemoveStateTag("abouttoattack")
                    inst:ClearBufferedAction()
                    inst.sg:GoToState("idle", true)
                    return
                end
                if inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS) == nil and inst.subweapon then
                    local subweapon = inst.components.inventory:FindItem(function (v)
                        return inst.subweapon == v.prefab
                    end)
                    inst.components.inventory:Equip(subweapon)
                end
                inst.subweapon = inst.equipped_weapon
                local buffaction = inst:GetBufferedAction()
                local target = buffaction ~= nil and buffaction.target or nil
                local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                inst.components.combat:SetTarget(target)
                inst.components.combat:StartAttack()
                inst.components.locomotor:Stop()
                local cooldown = inst.components.combat.min_attack_period + .5 * FRAMES
                if equip ~= nil and equip.components.weapon ~= nil then
                    -- inst.AnimState:PlayAnimation("lunge_pre")
                    inst.AnimState:PlayAnimation("atk_pre")
                    inst.AnimState:PushAnimation("atk", false)
                    cooldown = math.max(cooldown, 13 * FRAMES)
                end
                cooldown = cooldownAttack(cooldown)
                inst.sg:SetTimeout(cooldown)

                if target ~= nil then
                    inst.components.combat:BattleCry()
                    if target:IsValid() then
                        inst:FacePoint(target:GetPosition())
                        inst.sg.statemem.attacktarget = target
                    end
                end
            else
                old_attack_onenter(inst,...)
            end
        end
    elseif attack and client then
        local old_attack_onenter = attack.onenter
        attack.onenter = function(inst,...)
            local rider = inst.replica.rider
            if inst.prefab == "nanashi_mumei" and inst:HasTag("NANASHI_MUMEI_DAGGER_EQUIP")
            and (rider and not rider:IsRiding())  
            and TUNING.NANASHI_MUMEI_DAGGER_ATKSPEED_BONUS ~= 0.4
            then
                local buffaction = inst:GetBufferedAction()
                local cooldown = 0
                if inst.replica.combat ~= nil then
                    if inst.replica.combat:InCooldown() then
                        inst.sg:RemoveStateTag("abouttoattack")
                        inst:ClearBufferedAction()
                        inst.sg:GoToState("idle", true)
                        return
                    end
                    inst.replica.combat:StartAttack()
                    cooldown = inst.replica.combat:MinAttackPeriod()
                    if inst.sg.laststate == inst.sg.currentstate then
                        inst.sg.statemem.chained = true
                    end
                end
                inst.components.locomotor:Stop()
                local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                if equip ~= nil and
                    equip.replica.inventoryitem ~= nil and
                    equip.replica.inventoryitem:IsWeapon() then
                        inst.AnimState:PlayAnimation("atk_pre")
                        inst.AnimState:PushAnimation("atk", false)
                    if cooldown > 0 then
                        cooldown = math.max(cooldown, 13 * FRAMES)
                    end
                end

                if buffaction ~= nil then
                    inst:PerformPreviewBufferedAction()

                    if buffaction.target ~= nil and buffaction.target:IsValid() then
                        inst:FacePoint(buffaction.target:GetPosition())
                        inst.sg.statemem.attacktarget = buffaction.target
                    end
                end

                if cooldown > 0 then
                    cooldown = cooldownAttack(cooldown)
                    inst.sg:SetTimeout(cooldown)
                end
            else
               return old_attack_onenter(inst,...)
            end
        end
    end
    local hit = sg.states["hit"]  -- hit state is only on server version of states (none in client version)
    if hit and not client then
        local old_hit_onenter = hit.onenter
        hit.onenter = function(inst, frozen)
            if inst:HasTag("nanashi_mumei") 
            and inst._nanashi_mumei_killer 
            and inst._nanashi_mumei_killer:value() then
                inst.sg:GoToState("idle")
            else
                old_hit_onenter(inst, frozen)
            end
        end
    end
    local run_start = sg.states["run_start"]
    if run_start and not client then
        local old_run_start_onenter = run_start.onenter
        run_start.onenter = function(inst)
            if inst:HasTag("nanashi_mumei") 
            and inst._nanashi_mumei_killer 
            and inst._nanashi_mumei_killer:value() then
                inst.sg:RemoveStateTag("autopredict")
                inst.sg:AddStateTag("nopredict")

                old_run_start_onenter(inst)
            else
                old_run_start_onenter(inst)
            end
        end
    end
    local run = sg.states["run"]
    if run and not client then
        local old_run_onenter = run.onenter
        run.onenter = function(inst)
            if inst:HasTag("nanashi_mumei") 
            and inst._nanashi_mumei_killer 
            and inst._nanashi_mumei_killer:value() then
                inst.sg:RemoveStateTag("autopredict")
                inst.sg:AddStateTag("nopredict")

                old_run_onenter(inst)
            else
                old_run_onenter(inst)
            end
        end
    end
end

-- Server
AddStategraphPostInit("wilson", function(sg)
    nanashi_mumeistates(sg,false)    
end)
-- Client
AddStategraphPostInit("wilson_client", function(sg)
    nanashi_mumeistates(sg,true)
end)