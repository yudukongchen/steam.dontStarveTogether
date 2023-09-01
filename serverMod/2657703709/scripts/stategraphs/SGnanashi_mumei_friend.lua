require("stategraphs/commonstates")

local actionhandlers =
{
    ActionHandler(ACTIONS.FRIEND_PICKUP, "action"),
    ActionHandler(ACTIONS.PICK, "action"),
}

local events =
{

    EventHandler("locomote", function(inst)
        if not (inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("attack")) and
            inst.sg:HasStateTag("moving") ~= inst.components.locomotor:WantsToMoveForward() then
            inst.sg:GoToState(inst.sg:HasStateTag("moving") and "idle" or "premoving")
        end
    end),
}

local states =
{

    State{
        name = "action",
        tags = { "busy", "canrotate" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("eat_pre")
            inst.AnimState:PushAnimation("eat_loop")
            inst.SoundEmitter:PlaySound("mumei_sounds/mumei/mumei_paperbag_put_in")
        end,

        events =
        {
            EventHandler("animover", function (inst)
                inst:PerformBufferedAction()
                inst.sg:GoToState("action_done")
            end),
        }
    },

    State{
        name = "land",
        tags = { "busy", "canrotate" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("eat_pre")
            inst.AnimState:PushAnimation("eat_loop",true)
        end,
    },

    State{
        name = "action_done",
        tags = { "busy", "canrotate" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("eat_pst")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },

    State{
        name = "premoving",
        tags = { "moving", "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:WalkForward()
            inst.AnimState:PlayAnimation("walk_pre")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("moving")
            end),
        },
    },

    State{
        name = "moving",
        tags = { "moving", "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:WalkForward()
            if not inst.AnimState:IsCurrentAnimation("walk_loop") then
                inst.AnimState:PushAnimation("walk_loop", true)
            end
        end,
    },

    State{
        name = "idle",
        tags = { "idle", "canrotate" },

        onenter = function(inst)
            inst.Physics:Stop()
            if not inst.AnimState:IsCurrentAnimation("idle_loop") then
                inst.AnimState:PlayAnimation("idle_loop", true)
            end
        end,
    },

}

return StateGraph("nanashi_mumei_friend", states, events, "idle", actionhandlers)