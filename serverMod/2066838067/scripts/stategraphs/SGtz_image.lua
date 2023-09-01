 require("stategraphs/commonstates")

local actionhandlers = {

}
 local events =
{   
	EventHandler("attacked", function(inst, data)
        if not inst.components.health:IsDead() then
                    inst.sg:GoToState("hit")
        end
    end),
    EventHandler("death", function(inst)
        inst.sg:GoToState("death")
    end)		
}
local states = {
	State {
		name= "idle",
		tags = {"idle"},
		onenter = function(inst)
			--inst.Physics:Stop()
			inst.AnimState:PlayAnimation("idle_loop")
			
		end,
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end)
		}     
	},
    State {
		name = "death",
		tags = {"busy"},
		onenter = function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/characters/wallace/death_voice") 
			inst.AnimState:PlayAnimation("death")
			inst.Physics:Stop()
			RemovePhysicsColliders(inst)                      
		end
    },
	State {
		name = "hit",
		tags = {"busy"},
		onenter = function(inst)
			inst:InterruptBufferedAction()     
			inst.AnimState:PlayAnimation("hit")            
		end,
		events = {
			EventHandler("animover", function(inst) 
				inst.sg:GoToState("idle") 
			end),
		},
		timeline = {
			TimeEvent(3*FRAMES, function(inst)
				inst.sg:RemoveStateTag("busy")
			end),
		},
	}
}

return StateGraph("summonclone", states, events, "idle", actionhandlers)