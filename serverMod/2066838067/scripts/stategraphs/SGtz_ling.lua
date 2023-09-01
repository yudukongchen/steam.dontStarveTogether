require("stategraphs/commonstates")

local events =
{
    CommonHandlers.OnLocomote(true, true),
    EventHandler("godie", function(inst)
        inst.sg:GoToState("godie")
    end),
}

local states =
{
    State
    {
        name = "idle",
        tags = { "idle", "canrotate", "canslide" },

        onenter = function(inst)
			inst.AnimState:PlayAnimation("proximity_loop", true)
        end,
    },
    State
    {
        name = "appear",

        onenter = function(inst)
            inst.AnimState:PlayAnimation("proximity_pre")
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
        name = "godie",
        tags = { "busy"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("lost")
        end,
        events =
        {
            EventHandler("animover", function(inst)
                inst:Remove()
            end),
        },
    },
}

CommonStates.AddSimpleWalkStates(states, "proximity_loop")
CommonStates.AddSimpleRunStates(states, "proximity_loop")

return StateGraph("tz_ling", states, events, "appear")
