require("stategraphs/commonstates")

local events =
{
    EventHandler("locomote", function(inst)
        local is_moving = inst.sg:HasStateTag("moving")
        local is_running = inst.sg:HasStateTag("running")
        local is_idling = inst.sg:HasStateTag("idle")

        local should_move = inst.components.locomotor:WantsToMoveForward()
        local should_run = inst.components.locomotor:WantsToRun()
        if is_moving and not should_move then
            if is_running then
                inst.sg:GoToState("run_stop")
            else
                inst.sg:GoToState("walk_stop")
            end
        elseif (is_idling and should_move) or (is_moving and should_move and is_running ~= should_run) then
            if should_run then
                if inst.sg:HasStateTag("empty") then
                    inst.sg:GoToState("spawn")
                else
                    inst.sg:GoToState("run_start")
                end
            else
                inst.sg:GoToState("walk_start")
            end
        end
    end)
}

local function destroystuff(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 4, nil, { "INLIMBO" })
    for i, v in ipairs(ents) do
        if v ~= inst.WINDSTAFF_CASTER and v:IsValid() and not v:HasTag("player")then
			if v.components.burnable ~= nil then
				v.components.burnable:Ignite()
			end 
			if v.components.burnable ~= nil and not v.components.burnable:IsBurning() then
				if v.components.freezable ~= nil and v.components.freezable:IsFrozen() then
					v.components.freezable:Unfreeze()
				end
			end			
        end
    end
end

local states =
{
    State
    {
        name = "empty",
        tags = {"idle", "empty"},

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("empty")
        end,
    },

    State
    {
        name = "idle",
        tags = {"idle"},

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PushAnimation("tornado_loop", false)
            --destroystuff(inst)
        end,

        events =
        {
            EventHandler("animqueueover", function(inst)
                inst.sg:GoToState("idle")
            end)
        },
    },

    State
    {
        name = "spawn",
        tags = {"moving", "canrotate"},

        onenter = function(inst)
            inst.components.locomotor:RunForward()
            inst.AnimState:PlayAnimation("tornado_pre")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("walk")
            end)
        },
    },

    State
    {
        name = "despawn",
        tags = {"busy"},

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("tornado_pst")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst:Remove()
            end)
        },
    },

    State
    {
        name = "walk_start",
        tags = {"moving", "canrotate"},

        onenter = function(inst)
            inst.sg:GoToState("walk")
        end,
    },

    State
    {
        name = "walk",
        tags = {"moving", "canrotate"},

        onenter = function(inst)
            inst.components.locomotor:WalkForward()
            inst.AnimState:PushAnimation("tornado_loop", false)
            --destroystuff(inst)
        end,

        timeline =
        {
            TimeEvent(5*FRAMES, destroystuff),
        },

        events =
        {
            EventHandler("animqueueover", function(inst)
                inst.sg:GoToState("walk")
            end)
        },
    },

    State
    {
        name = "walk_stop",
        tags = {"canrotate"},

        onenter = function(inst)
            inst.sg:GoToState("idle")
        end,
    },

    State
    {
        name = "run_start",
        tags = {"moving", "running", "canrotate"},

        onenter = function(inst)
            inst.components.locomotor:RunForward()
            inst.AnimState:PushAnimation("tornado_loop", false)
        end,

        timeline =
        {
            --TimeEvent(5*FRAMES, destroystuff),
        },

        events =
        {
            EventHandler("animqueueover", function(inst)
                inst.sg:GoToState("run")
            end),
        },
    },

    State
    {
        name = "run",
        tags = {"moving", "running", "canrotate"},

        onenter = function(inst)
            inst.components.locomotor:RunForward()
            inst.AnimState:PushAnimation("tornado_loop", false)
        end,

        timeline =
        {
            TimeEvent(5*FRAMES, destroystuff),
			--TimeEvent(10*FRAMES, destroystuff),
        },

        events =
        {
            EventHandler("animqueueover", function(inst)
                inst.sg:GoToState("run")
            end),
        },
    },

    State
    {
        name = "run_stop",
        tags = {"idle"},

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PushAnimation("tornado_loop", false)
        end,

        timeline =
        {
            --TimeEvent(5*FRAMES, destroystuff),
        },

        events =
        {
            EventHandler("animqueueover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },
}

return StateGraph("tz_firetornado", states, events, "empty")
