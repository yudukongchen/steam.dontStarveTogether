require("stategraphs/commonstates")

local actionhandlers =
{
    ActionHandler(ACTIONS.EAT,
        function(inst, action)
            if inst.sg:HasStateTag("busy") then
                return
            end
            local obj = action.target or action.invobject
            if obj == nil then
                return
            elseif obj.components.edible ~= nil then
                if not inst.components.eater:PrefersToEat(obj) then
                    inst:PushEvent("wonteatfood", { food = obj })
                    return
                end
            else
                return
            end
            return "eat"
        end)
}
local events=
{
    EventHandler("locomote", function(inst) --散步
        if not inst.sg:HasStateTag("busy") then
            local is_moving = inst.sg:HasStateTag("moving")
            local wants_to_move = inst.components.locomotor:WantsToMoveForward()
            if not inst.sg:HasStateTag("attack") and is_moving ~= wants_to_move then
                if wants_to_move then
                    inst.sg:GoToState("run_start")
                else
                    inst.sg:GoToState("idle")
                end
            end
        end
    end),
	
	EventHandler("attacked", function(inst, data)--被击
		if not inst.components.health:IsDead() and data.attacker then
		    if inst.components.health:GetPercent() > 0.3 and not inst.sg:HasStateTag("sleeping") then
			    inst.sg:GoToState("attacked")
			end
		end
	end),

	EventHandler("doattack", function(inst) --攻击
		if not inst.components.health:IsDead() and not inst.sg:HasStateTag("attack") then
			if inst.components.combat then
				inst.sg:GoToState("attack")
			end
		end
	end),

	EventHandler("death", function(inst) --死亡
		inst.sg:GoToState("death")
		inst.SoundEmitter:PlaySound("dontstarve/wilson/death")
	end),
}

local states=
{

    State{
        name = "idle",
        tags = {"idle", "canrotate"},
        onenter = function(inst)
            inst.Physics:Stop()
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("idle")
            inst.AnimState:PushAnimation("idle_loop")
        end,

    },
    State{
		name = "run_start",
		tags = {"moving", "running", "canrotate"},
		
		onenter = function(inst)
			inst.components.locomotor:RunForward()
			inst.AnimState:PlayAnimation("run_pre")
		end,
		
		onupdate = function(inst)
			inst.components.locomotor:RunForward()
		end,
		
		events =
		{
			EventHandler("animover", function(inst)
				inst.sg:GoToState("run")
			end),
		},
	},

	State{
		name = "run",
		tags = {"moving", "running", "canrotate"},
		
		onenter = function(inst)
			inst.components.locomotor:RunForward()
			inst.AnimState:PlayAnimation("run_loop")
		end,
		
		onupdate = function(inst)
			inst.components.locomotor:RunForward()
		end,
		
		events =
		{
			EventHandler("animover", function(inst)
				inst.sg:GoToState("run")
			end),
		},
	},

	State{
		name = "run_stop",
		tags = {"canrotate", "idle"},
		
		onenter = function(inst)
			inst.components.locomotor:Stop()
			inst.AnimState:PlayAnimation("run_pst")
		end,
		
		events =
		{
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},

	State{
        name = "eat",
        tags = { "busy", "nodangle" },

        onenter = function(inst, foodinfo)
            inst.components.locomotor:Stop()

            local feed = foodinfo and foodinfo.feed
            if feed ~= nil then
                inst.components.locomotor:Clear()
                inst:ClearBufferedAction()
                inst.sg.statemem.feed = foodinfo.feed
                inst.sg.statemem.feeder = foodinfo.feeder
                inst.sg:AddStateTag("pausepredict")
                if inst.components.playercontroller ~= nil then
                    inst.components.playercontroller:RemotePausePrediction()
                end
            elseif inst:GetBufferedAction() then
                feed = inst:GetBufferedAction().invobject
            end

            if feed == nil or
                feed.components.edible == nil or
                feed.components.edible.foodtype ~= FOODTYPE.GEARS then
                inst.SoundEmitter:PlaySound("dontstarve/wilson/eat", "eating")
            end

            if inst.components.inventory:IsHeavyLifting() and
                not inst.components.rider:IsRiding() then
                inst.AnimState:PlayAnimation("heavy_eat")
            else
                inst.AnimState:PlayAnimation("eat_pre")
                inst.AnimState:PushAnimation("eat", false)
            end

            inst.components.hunger:Pause()
        end,

        timeline =
        {
            TimeEvent(28 * FRAMES, function(inst)
                if inst.sg.statemem.feed == nil then
                    inst:PerformBufferedAction()
                elseif inst.sg.statemem.feed.components.soul == nil then
                    inst.components.eater:Eat(inst.sg.statemem.feed, inst.sg.statemem.feeder)
                end
            end),

            TimeEvent(30 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
                inst.sg:RemoveStateTag("pausepredict")
            end),

            TimeEvent(70 * FRAMES, function(inst)
                inst.SoundEmitter:KillSound("eating")
            end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            inst.SoundEmitter:KillSound("eating")
            if not GetGameModeProperty("no_hunger") then
                inst.components.hunger:Resume()
            end
            if inst.sg.statemem.feed ~= nil and inst.sg.statemem.feed:IsValid() then
                inst.sg.statemem.feed:Remove()
            end
        end,
    },

	State{
		name = "attack",
		tags = {"attack", "notalking", "abouttoattack", "busy"},
		
		onenter = function(inst)
			if inst.components.combat:GetWeapon() then
				inst.AnimState:PlayAnimation("atk")
				inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
			else
				inst.sg.statemem.slow = true
				inst.AnimState:PlayAnimation("punch")
				inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh")
			end
			if inst.components.combat.target then
				inst.components.combat:BattleCry()
				if inst.components.combat.target and inst.components.combat.target:IsValid() then
					inst:FacePoint(Point(inst.components.combat.target.Transform:GetWorldPosition()))
				end
			end
			inst.sg.statemem.target = inst.components.combat.target
			inst.components.combat:StartAttack()
			inst.components.locomotor:Stop()
		end,
		
		timeline =
		{
			TimeEvent(8 * FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) inst.sg:RemoveStateTag("abouttoattack") end),
			TimeEvent(12 * FRAMES, function(inst) 
				inst.sg:RemoveStateTag("busy")
			end),				
			TimeEvent(13 * FRAMES, function(inst)
				if not inst.sg.statemem.slow then
					inst.sg:RemoveStateTag("attack")
				end
			end),
			TimeEvent(24 * FRAMES, function(inst)
				if inst.sg.statemem.slow then
					inst.sg:RemoveStateTag("attack")
				end
			end),
		},
		
		events =
		{
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},

	State{
		name = "attacked",
		tags = {"busy"},
		
		onenter = function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/wilson/hit")
			inst.AnimState:PlayAnimation("hit")
			inst:ClearBufferedAction()
			inst.components.locomotor:Stop()
		end,
		
		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
		},
		
		timeline =
		{
			TimeEvent(3 * FRAMES, function(inst)
				inst.sg:RemoveStateTag("busy")
			end),
		},
	},

	State{
		name = "death",
		tags = {"busy"},
		
		onenter = function(inst)
			inst.components.locomotor:Stop()
			inst.last_death_position = inst:GetPosition()
			inst.AnimState:Hide("swap_arm_carry")
			inst.AnimState:PlayAnimation("death")
		end,
		
		events =
		{
			EventHandler("animover", function(inst)
				inst:DoTaskInTime(0.1, function()
					SpawnPrefab("statue_transition").Transform:SetPosition(inst:GetPosition():Get())
					SpawnPrefab("statue_transition_2").Transform:SetPosition(inst:GetPosition():Get())
					inst.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_despawn")
					inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))
					inst:Remove()
				end)
			end),
		},
	},
}


CommonStates.AddFrozenStates(states)
CommonStates.AddSleepStates(states)

return StateGraph("SGnl_doctor", states, events, "idle", actionhandlers)