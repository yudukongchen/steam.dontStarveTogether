require("stategraphs/commonstates")

local events =
{
    CommonHandlers.OnLocomote(true, true),
}

local states = {

}

CommonStates.AddIdle(states,nil,"idle")
CommonStates.AddSimpleWalkStates(states,"idle")
CommonStates.AddSimpleRunStates(states,"idle")

return StateGraph("SGtz_fhzc_minion", states, events, "idle")
