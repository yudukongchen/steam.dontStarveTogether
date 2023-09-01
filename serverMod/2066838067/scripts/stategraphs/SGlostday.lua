require("stategraphs/commonstates")

local actionhandlers = {
}

local events = {
	CommonHandlers.OnLocomote(true, false), 
	CommonHandlers.OnDeath(),
    CommonHandlers.OnAttacked(),
    CommonHandlers.OnAttack(),
}

local states = {
    State{
        name = "idle",
        tags = {"idle", "canrotate"},

        onenter = function(inst, pushanim)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("idle_loop", true)
        end,
    },
    State{
        name = "run_start",
        tags = {"moving", "running", "canrotate"},

        onenter = function(inst)
            inst.components.locomotor:RunForward()
            inst.AnimState:PlayAnimation("run_pre")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("run")
                end
            end),
        },

        timeline =
        {
            TimeEvent(4*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_step")
            end),
        },
    },

    State{
        name = "run",
        tags = {"moving", "running", "canrotate"},

        onenter = function(inst)
            inst.components.locomotor:RunForward()
            if not inst.AnimState:IsCurrentAnimation("run_loop") then
                inst.AnimState:PlayAnimation("run_loop", true)
            end
            inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())
        end,

        timeline =
        {
            TimeEvent(7 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_step")
            end),
            TimeEvent(15 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_step")
            end),
        },

        ontimeout = function(inst)
            inst.sg:GoToState("run")
        end,
    },

    State{
        name = "run_stop",
        tags = {"canrotate", "idle"},

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("run_pst")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },

    State{
        name = "attack",
        tags = {"attack", "notalking", "abouttoattack", "busy"},

        onenter = function(inst)
            inst.sg.statemem.target = inst.components.combat.target
            inst.components.combat:StartAttack()
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("atk")
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_nightsword")

            if inst.components.combat.target ~= nil and inst.components.combat.target:IsValid() then
                inst:FacePoint(inst.components.combat.target.Transform:GetWorldPosition())
            end
        end,

        timeline =
        {
            TimeEvent(8*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) inst.sg:RemoveStateTag("abouttoattack") end),
            TimeEvent(12*FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
            end),
            TimeEvent(13*FRAMES, function(inst)
                inst.sg:RemoveStateTag("attack")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },

    State{
        name = "death",
        tags = {"busy"},

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:Hide("swap_arm_carry")
            inst.AnimState:PlayAnimation("death")
			if inst.components.container ~= nil then
				inst.components.container:DropEverything()
			end
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    local x, y, z = inst.Transform:GetWorldPosition()
                    SpawnPrefab("shadow_despawn").Transform:SetPosition(x, y, z)
                    SpawnPrefab("statue_transition_2").Transform:SetPosition(x, y, z)
                    inst:Remove()
                end
            end),
        },
    },

    State{
        name = "hit",
        tags = {"busy"},

        onenter = function(inst)
            inst:ClearBufferedAction()
            inst.AnimState:PlayAnimation("hit")
            inst.Physics:Stop()
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        timeline =
        {
            TimeEvent(3*FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
            end),
        },
    },
    State{
        name = "jiasi",
        tags = {"busy"},

        onenter = function(inst,doer)
            inst.Physics:Stop()
			inst.bianshen = true
			if inst.components.container ~= nil then
            inst.components.container:DropEverything()
            inst.components.container:Close()
			end
			inst.components.health:SetInvincible(true)
            inst.AnimState:Hide("swap_arm_carry")
			inst.AnimState:ClearOverrideSymbol("swap_body")
            inst.AnimState:PlayAnimation("death")
			inst.sg.statemem.doer = doer
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
					inst.sg:GoToState("amulet_rebirth", inst.sg.statemem.doer)
                end
            end),
        },
    },
    State{
        name = "amulet_rebirth",
        tags = { "busy", "nopredict", "silentmorph" },

        onenter = function(inst,doer)
			inst.bianshen = true
            inst.AnimState:PlayAnimation("amulet_rebirth")
            inst.AnimState:OverrideSymbol("FX", "player_amulet_resurrect", "FX")
			inst.AnimState:OverrideSymbol("swap_body", "torso_amulets", "redamulet")
            inst.components.health:SetInvincible(true)
			if doer ~= nil then
				inst.sg.statemem.doer = doer
			end
        end,

        timeline =
        {
            TimeEvent(0, function(inst)
                local stafflight = SpawnPrefab("staff_castinglight")
                stafflight.Transform:SetPosition(inst.Transform:GetWorldPosition())
                stafflight:SetUp({ 150 / 255, 46 / 255, 46 / 255 }, 1.7, 1)
                inst.SoundEmitter:PlaySound("dontstarve/common/rebirth_amulet_raise")
            end),
            TimeEvent(60 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/common/rebirth_amulet_poof")
            end),
            TimeEvent(88 * FRAMES, function(inst)
					if inst.sg.statemem.doer.components.petleashlostday ~=nil then
					local x,y,z = inst.Transform:GetWorldPosition()
					local pet = inst.prefab.."_gai"
                    inst:Remove()
					inst.sg.statemem.doer.components.petleashlostday:SpawnPetAt(x, 0, z ,pet)
					inst.sg.statemem.doer = nil
					end
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)

            end),
        },
    },
}
return StateGraph("lostday", states, events, "idle", actionhandlers)
