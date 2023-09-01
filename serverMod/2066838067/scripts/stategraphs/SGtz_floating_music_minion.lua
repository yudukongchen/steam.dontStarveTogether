require("stategraphs/commonstates")

local actionhandlers =
{

}

local events =
{
    CommonHandlers.OnLocomote(true),
}

local states = {
	State{
		name = "idle",
		tags = {"idle"},

		onenter = function(inst)
			inst.components.locomotor:StopMoving()
			--inst.AnimState:PushAnimation("loop_1",true)
			inst:PlayLevelAnim(true)
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
	
	State
    {
        name = "run_start",
        tags = { "moving", "running", "canrotate" },

        onenter = function(inst)
			inst.sg:GoToState("run")
        end,
    },
	State
    {
        name = "run",
        tags = { "moving", "running", "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:RunForward()
            inst:PlayLevelAnim(true)
            inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())
        end,


        ontimeout = function(inst)
			inst.sg:GoToState("run")
		end,
    },
	
	State
    {
        name = "run_stop",
        tags = { "idle" },

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.sg:GoToState("idle")
        end,
		
		EventHandler("animqueueover", function(inst)
			if inst.AnimState:AnimDone() then
				inst.sg:GoToState("idle")
			end
		end),
    },
}


return StateGraph("SGtz_floating_music_minion", states, events, "idle", actionhandlers)