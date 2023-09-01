require("stategraphs/commonstates")
local events =
{
    CommonHandlers.OnLocomote(true, true),
}



local states =
{
    State{
        name = "idle",
        tags = { "idle", "canrotate", "canslide" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("book_loop", true)
        end,
    },
}

CommonStates.AddSimpleWalkStates(states, "book_loop")
CommonStates.AddSimpleRunStates(states, "book_loop")

return StateGraph("SGtz_book_surpassing", states, events, "idle")
