GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

AddStategraphPostInit("wilson", function(sg)
    sg.states["krm_gun_atk_right"] = State {
        name = "krm_gun_atk_right",
        tags = { "doing" },
        onenter = function(inst)
            --print("右键射击")
            inst.AnimState:PlayAnimation("hand_shoot")
            inst.AnimState:SetDeltaTimeMultiplier(1.5)

            local buffaction = inst:GetBufferedAction()
            if buffaction then   
                local target = buffaction.target or nil
                inst.sg.statemem.target = target
            end

            inst.components.locomotor:Stop()
        end,
        timeline = {
            TimeEvent(14 * FRAMES, function(inst)
                inst:PerformBufferedAction()
                inst.SoundEmitter:PlaySound("lw_homura/pistol/silent", nil, 0.3)
                --inst.components.combat:DoAttack(inst.sg.statemem.target)
            end)
        },

        onexit = function(inst)
            inst.AnimState:SetDeltaTimeMultiplier(1)
        end,

        events = {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end)
        }
    }
end)

AddStategraphPostInit("wilson_client", function(sg)
    sg.states["krm_gun_atk_right"] = State {
        name = "krm_gun_atk_right",
        tags = { "doing" },
        onenter = function(inst)
            inst.AnimState:PlayAnimation("hand_shoot")

            inst:PerformPreviewBufferedAction()
            inst.sg:SetTimeout(14 * FRAMES)
            inst.components.locomotor:Stop()
        end,

        onexit = function(inst)
            inst:ClearBufferedAction()
            inst.AnimState:SetDeltaTimeMultiplier(1)
        end,

        events = {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end)
        }
    }
end)
