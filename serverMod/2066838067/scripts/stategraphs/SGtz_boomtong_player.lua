AddStategraphPostInit("wilson", function(sg)
	local old_DEPLOY = sg.actionhandlers[ACTIONS.DEPLOY].deststate
    sg.actionhandlers[ACTIONS.DEPLOY].deststate = function(inst, action,...)
		local item = action.invobject
		if item and item.prefab == "tz_boomtong_item" then 
			return "dolongaction_tz_boomtong"
		end
		return old_DEPLOY(inst, action,...)
	end
end)


AddStategraphPostInit("wilson_client", function(sg)
	local old_DEPLOY = sg.actionhandlers[ACTIONS.DEPLOY].deststate
    sg.actionhandlers[ACTIONS.DEPLOY].deststate = function(inst, action,...)
		local item = action.invobject
		if item and item.prefab == "tz_boomtong_item" then 
			return "dolongaction_tz_boomtong"
		end
		return old_DEPLOY(inst, action,...)
	end
end)


local function StartActionMeter(inst, duration)
    if inst.HUD ~= nil then
        inst.HUD:ShowRingMeter(inst:GetPosition(), duration)
    end
    inst.player_classified.actionmetertime:set(math.min(255, math.floor(duration * 10 + .5)))
    inst.player_classified.actionmeter:set(2)
    if inst.sg.mem.actionmetertask == nil then
        inst.sg.mem.actionmetertask = inst:DoPeriodicTask(.1, UpdateActionMeter, nil, GetTime())
    end
end

local function StopActionMeter(inst, flash)
    if inst.HUD ~= nil then
        inst.HUD:HideRingMeter(flash)
    end
    if inst.sg.mem.actionmetertask ~= nil then
        inst.sg.mem.actionmetertask:Cancel()
        inst.sg.mem.actionmetertask = nil
        inst.player_classified.actionmeter:set(flash and 1 or 0)
    end
end

AddStategraphState("wilson", 
	State{
        name = "dolongaction_tz_boomtong",
        tags = { "doing", "busy", "nodangle" },

        onenter = function(inst, timeout)
            if timeout == nil then
                timeout = 3
            elseif timeout > 3 then
                inst.sg:AddStateTag("slowaction")
            end
            inst.sg:SetTimeout(timeout)
            inst.components.locomotor:Stop()
            inst.SoundEmitter:PlaySound("dontstarve/wilson/make_trap", "make")
            inst.AnimState:PlayAnimation("build_pre")
            inst.AnimState:PushAnimation("build_loop", true)
            if inst.bufferedaction ~= nil then
                inst.sg.statemem.action = inst.bufferedaction
                if inst.bufferedaction.action.actionmeter then
                    inst.sg.statemem.actionmeter = true
                    StartActionMeter(inst, timeout)
                end
                if inst.bufferedaction.target ~= nil and inst.bufferedaction.target:IsValid() then
                    inst.bufferedaction.target:PushEvent("startlongaction")
                end
            end
        end,

        timeline =
        {
            TimeEvent(4 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
            end),
        },

        ontimeout = function(inst)
            inst.SoundEmitter:KillSound("make")
            inst.AnimState:PlayAnimation("build_pst")
            if inst.sg.statemem.actionmeter then
                inst.sg.statemem.actionmeter = nil
                StopActionMeter(inst, true)
            end
            inst:PerformBufferedAction()
        end,

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            inst.SoundEmitter:KillSound("make")
            if inst.sg.statemem.actionmeter then
                StopActionMeter(inst, false)
            end
            if inst.bufferedaction == inst.sg.statemem.action then
                inst:ClearBufferedAction()
            end
        end,
    }
)


AddStategraphState("wilson_client", 
	State
    {
        name = "dolongaction_tz_boomtong",
        tags = { "doing", "busy" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.SoundEmitter:PlaySound("dontstarve/wilson/make_trap", "make_preview")
            inst.AnimState:PlayAnimation("build_pre")
            inst.AnimState:PushAnimation("build_loop", true)

            inst:PerformPreviewBufferedAction()
            inst.sg:SetTimeout(TIMEOUT)
        end,

        timeline =
        {
            TimeEvent(4 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
            end),
        },

        onupdate = function(inst)
            if inst:HasTag("doing") then
                if inst.entity:FlattenMovementPrediction() then
                    inst.sg:GoToState("idle", "noanim")
                end
            elseif inst.bufferedaction == nil then
                inst.AnimState:PlayAnimation("build_pst")
                inst.sg:GoToState("idle", true)
            end
        end,

        ontimeout = function(inst)
            inst:ClearBufferedAction()
            inst.AnimState:PlayAnimation("build_pst")
            inst.sg:GoToState("idle", true)
        end,

        onexit = function(inst)
            inst.SoundEmitter:KillSound("make_preview")
        end,
    }
)