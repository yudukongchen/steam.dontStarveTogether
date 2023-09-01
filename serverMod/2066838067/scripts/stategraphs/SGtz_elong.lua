require("stategraphs/commonstates")

local RANDOM_IDLES = { "bark_idle", "shake", "sit", "scratch" }

local actionhandlers =
{
}


local events=
{
    --CommonHandlers.OnStep(),
    CommonHandlers.OnLocomote(true,true),
    CommonHandlers.OnFreeze(),
    --EventHandler("gotosleep", function(inst) inst.sg:GoToState("sleeping") end),
    CommonHandlers.OnSleepEx(),
    --这两个待定吧？？
    CommonHandlers.OnHop(),
    --CommonHandlers.OnSink(),
    --SGCritterEvents.OnEat(),
    EventHandler("death", function(inst)
        inst.sg:GoToState("death")
    end),
    EventHandler("oneat", function(inst, data)
        if not inst.components.health:IsDead()
           and not inst.sg:HasStateTag("attack") then
           inst.sg:GoToState("eat", data)
       end
    end),
    EventHandler("attacked", function(inst)
        if not inst.components.health:IsDead() then
            inst.sg:GoToState("hit")
        end
    end),
}

local states=
{
    State{
        name = "death",
        tags = { "busy" },

        onenter = function(inst)
            inst.SoundEmitter:PlaySound(inst.sounds.death)
            inst.AnimState:PlayAnimation("sile")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)
            local leader = inst.components.follower:GetLeader()
            if leader and leader.components.aowu_elong  then
                leader:Remove()
            end
        end,
        timeline =
        {
            TimeEvent(1, function(inst)
                inst:Remove()
            end)
        },
    },

    State{
        name = "hit",
        onenter = function(inst)
            inst.AnimState:PlayAnimation("hit")
            inst.Physics:Stop()
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },
    },

    State{
        name = "idle",
        tags = {"idle", "canrotate"},

        onenter = function(inst, pushanim)
            inst.components.locomotor:StopMoving()

            if pushanim then
                inst.AnimState:PushAnimation("idle_loop", true)
            else
                inst.AnimState:PlayAnimation("idle_loop", true)
            end

            inst.sg:SetTimeout(2 + math.random())

        end,

        ontimeout=function(inst)
            inst.sg:GoToState("idle")
        end,
    },

    State{
        name = "despawn",
        tags = {"busy", "notinterupt"},

        onenter = function(inst, pushanim)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("idle_loop", true)
        end,

        onexit = function(inst)
			inst:DoTaskInTime(0, inst.Remove)
        end,
    },

    State{
        name = "eat",
        tags = {"busy"},

        onenter = function(inst, pushanim)
            if inst.components.locomotor ~= nil then
                inst.components.locomotor:StopMoving()
            end
            inst.AnimState:PlayAnimation("weishi")
        end,
        timeline=
        {
            TimeEvent(0.4, function(inst) inst.SoundEmitter:PlaySound("dontstarve/characters/walter/woby/small/eat") end)
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
        name = "shake",
        tags = {"idle", "canrotate"},

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("shake_woby")
        end,

        timeline=
        {
            TimeEvent(3*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/characters/walter/woby/big/foley") end),
            TimeEvent(8*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/characters/walter/woby/big/foley") end),
        },

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "run_start",
        tags = { "moving", "running", "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:RunForward()
            inst.AnimState:PlayAnimation("run_pre")
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
        tags = { "moving", "running", "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:RunForward()
            inst.AnimState:PlayAnimation("run_loop", true)
            inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())
        end,

        timeline=
        {
            TimeEvent(math.random(1,11)*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/characters/walter/woby/big/run_chuff") end),
            TimeEvent(1*FRAMES, function(inst) inst.SoundEmitter:PlaySoundWithParams("dontstarve/characters/walter/woby/big/footstep", {intensity= 1}) end),
            TimeEvent(3*FRAMES, function(inst) inst.SoundEmitter:PlaySoundWithParams("dontstarve/characters/walter/woby/big/footstep", {intensity= 1}) end),
            TimeEvent(8*FRAMES, function(inst) inst.SoundEmitter:PlaySoundWithParams("dontstarve/characters/walter/woby/big/footstep", {intensity= 1}) end),
            TimeEvent(10*FRAMES, function(inst) inst.SoundEmitter:PlaySoundWithParams("dontstarve/characters/walter/woby/big/footstep", {intensity= 1}) end),
        },

        ontimeout = function(inst)
            inst.sg:GoToState("run")
        end,
    },

    State{
        name = "run_stop",
        tags = { "idle" },

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("run_pst")
        end,

        timeline=
        {
            TimeEvent(1*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/characters/walter/woby/big/footstep") end),
            TimeEvent(3*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/characters/walter/woby/big/footstep") end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },
}

CommonStates.AddWalkStates(
    states,
    {
        walktimeline =
        {
            TimeEvent(7*FRAMES, function(inst)
                inst.SoundEmitter:PlaySoundWithParams("dontstarve/creatures/together/hutch/land_hit", {intensity= .3}) -- Regular walk sounds
            end),


            TimeEvent(30*FRAMES, function(inst)
                inst.SoundEmitter:PlaySoundWithParams("dontstarve/creatures/together/hutch/land_hit", {intensity= .3}) -- Regular walk sounds
            end),

            TimeEvent(45*FRAMES, function(inst)
                inst.SoundEmitter:PlaySoundWithParams("dontstarve/creatures/together/hutch/land_hit", {intensity= .3}) -- Regular walk sounds
            end),

            TimeEvent(60*FRAMES, function(inst)
                inst.SoundEmitter:PlaySoundWithParams("dontstarve/creatures/together/hutch/land_hit", {intensity= .3})
            end),
        }
    },
    {
        startwalk =  function(inst)
            return "walk_pre"
        end,

        walk = function(inst)
            return "walk_loop"
        end,

        stopwalk = function(inst)
            return "walk_pst"
        end,
    })
    CommonStates.AddRunStates(states,
    {
        starttimeline =
        {
            TimeEvent(0, function(inst)
                inst.SoundEmitter:PlaySoundWithParams("dontstarve/creatures/together/hutch/land_hit", {intensity= .3})
            end),
        },
        runtimeline =
        {
            TimeEvent(8*FRAMES, function(inst)
                inst.SoundEmitter:PlaySoundWithParams("dontstarve/creatures/together/hutch/land_hit", {intensity= .3}) -- Regular walk sounds
            end),

            TimeEvent(15*FRAMES, function(inst)
                inst.SoundEmitter:PlaySoundWithParams("dontstarve/creatures/together/hutch/land_hit", {intensity= .3}) -- Regular walk sounds
            end),
        },
        endtimeline =
        {
            --TimeEvent(0 * FRAMES, DoStopFootStep),
        },
    })
    

CommonStates.AddFrozenStates(states)
--CommonStates.AddSinkAndWashAsoreStates(states)
CommonStates.AddHopStates(states, true, { pre = "boat_jump_pre", loop = "boat_jump_loop", pst = "boat_jump_pst"},
{
    hop_pre =
    {
        TimeEvent(46*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/characters/walter/woby/big/sleep") end)
    },

    hop_loop =
    {
        TimeEvent(46*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/characters/walter/woby/big/sleep") end)
    },

    hop_pst =
    {
        TimeEvent(46*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/characters/walter/woby/big/sleep") end)
    },
})

CommonStates.AddSleepStates(states,
{
    sleeptimeline =
    {
        TimeEvent(46*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/characters/walter/woby/big/sleep") end)
    },
})

return StateGraph("tz_elong", states, events, "idle", actionhandlers)