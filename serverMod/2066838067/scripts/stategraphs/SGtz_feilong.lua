require("stategraphs/commonstates")
local ex_fns = require "prefabs/player_common_extensions"

local actionhandlers =
{

}


local events=
{
    CommonHandlers.OnLocomote(true,false),
	EventHandler("death", function(inst, data)
        if inst.sleepingbag ~= nil and (inst.sg:HasStateTag("bedroll") or inst.sg:HasStateTag("tent")) then -- wakeup on death to "consume" sleeping bag first
            inst.sleepingbag.components.sleepingbag:DoWakeUp()
            inst.sleepingbag = nil
        end
		if not inst.sg:HasStateTag("dead") then
            inst.sg:GoToState("death")
        end
    end),
	-- CommonHandlers.OnHop(),
}


local function groundpoundring(inst)
	inst.SoundEmitter:PlaySound("saltydog/creatures/boss/malbatross/flap")
    local sp = SpawnPrefab("groundpoundring_fx")
	sp.Transform:SetPosition(inst.Transform:GetWorldPosition())
	sp.Transform:SetScale(0.65,0.65,0.65)
end

local function redirect(inst, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
	return amount < 0 and afflicter ~= nil
end
local function ServerGetSpeedMultiplier(self)
    return 1
end
local function MooseRightMindControl(inst, target, pos)
    return target ~= inst and target ~= nil and inst.components.playeractionpicker:SortActionList({ ACTIONS.LOOKAT }, target, nil) or nil
end
local function DisableActions(inst, b)
	if b then
		if inst.components.playeractionpicker ~= nil then
			inst.components.playeractionpicker.leftclickoverride = MooseRightMindControl
			inst.components.playeractionpicker.rightclickoverride = MooseRightMindControl
		end
		if inst.components.health.tzoldredirect == nil then
			inst.components.health.tzoldredirect = inst.components.health.redirect --保存一下原血量方法
		end
		inst.components.health.redirect = redirect --修改扣血逻辑
		if inst.tzGetSpeedMultiplier == nil then
			inst.tzGetSpeedMultiplier = inst.components.locomotor.GetSpeedMultiplier
			inst.components.locomotor.GetSpeedMultiplier = ServerGetSpeedMultiplier
		end
		if inst.components.sheltered ~= nil then
			inst.components.sheltered:Stop()
		end
		-- inst:AddTag("flying")
        -- inst:AddTag("ignorewalkableplatformdrowning")
        ex_fns.ConfigureGhostLocomotor(inst)
	else
		ex_fns.ConfigurePlayerLocomotor(inst)
		if inst.components.playeractionpicker ~= nil then
			inst.components.playeractionpicker.leftclickoverride = nil
			inst.components.playeractionpicker.rightclickoverride = nil
		end
		inst.components.health.redirect = inst.components.health.tzoldredirect
		if inst.tzGetSpeedMultiplier ~= nil then
			inst.components.locomotor.GetSpeedMultiplier = inst.tzGetSpeedMultiplier
			inst.tzGetSpeedMultiplier = nil
		end
		if inst.components.sheltered ~= nil then
			inst.components.sheltered:Start()
		end
		inst.isfeilong = false
	end
	if inst.components.drownable ~= nil then
		inst.components.drownable.enabled = not b
	end
	SendModRPCToClient(CLIENT_MOD_RPC["tz"]["disableactions"], inst.userid,b)
end

local TARGET_MUST_TAGS = { "_combat" }
local TARGET_CANT_TAGS = { "INLIMBO" }

local states=
{
	State{
        name = "ks",
        tags = { "noattack","doing", "busy", "nointerrupt", "nomorph" },

        onenter = function(inst)
			local x, y, z = inst.Transform:GetWorldPosition()
			for i, v in ipairs(TheSim:FindEntities(x, y, z, 20, TARGET_MUST_TAGS, TARGET_CANT_TAGS)) do
				if v.components.combat ~= nil and v.components.combat.target == inst then
					v.components.combat:SetTarget(nil)
				end
			end
			DisableActions(inst,true)
			inst.AnimState:Show("HEAD")
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("superjump_pre")
			inst.AnimState:PushAnimation("superjump_lag",false)
			RemovePhysicsColliders(inst)
        end,

        events =
        {
			EventHandler("animqueueover", function(inst)
				inst.sg:GoToState("ksa")
			end),
        },

        onexit = function(inst)
            
        end,
    },

    State{
        name = "ksa",
        tags = { "noattack","doing", "busy", "nointerrupt", "nopredict", "nomorph" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("superjump")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst:Hide()
			-- inst.AnimState:AddOverrideBuild("tz_feilong")
			inst.AnimState:OverrideSymbol("elong_arm", "tz_feilong", "elong_arm")
			inst.AnimState:OverrideSymbol("elong_body", "tz_feilong", "elong_body")
			inst.AnimState:OverrideSymbol("elong_foot", "tz_feilong", "elong_foot")
			inst.AnimState:OverrideSymbol("elong_hand", "tz_feilong", "elong_hand")
			inst.AnimState:OverrideSymbol("elong_head", "tz_feilong", "elong_head")
			inst.AnimState:OverrideSymbol("elong_leg", "tz_feilong", "elong_leg")
			inst.AnimState:OverrideSymbol("elong_swing", "tz_feilong", "elong_swing")
			inst.AnimState:OverrideSymbol("elong_tail", "tz_feilong", "elong_tail")
					
			-- inst.AnimState:ClearOverrideSymbol("arm_lower")
			-- inst.AnimState:ClearOverrideSymbol("arm_lower_cuff")
			-- inst.AnimState:ClearOverrideSymbol("arm_upper")
			-- inst.AnimState:ClearOverrideSymbol("arm_upper_skin")
			-- inst.AnimState:ClearOverrideSymbol("BEARD")
			-- inst.AnimState:ClearOverrideSymbol("cheeks")
			-- inst.AnimState:ClearOverrideSymbol("face")
			-- inst.AnimState:ClearOverrideSymbol("foot")
			-- inst.AnimState:ClearOverrideSymbol("hair")
			-- inst.AnimState:ClearOverrideSymbol("hair_hat")
			-- inst.AnimState:ClearOverrideSymbol("hairfront")
			-- inst.AnimState:ClearOverrideSymbol("hairpigtails")
			-- inst.AnimState:ClearOverrideSymbol("hand")
			-- inst.AnimState:ClearOverrideSymbol("headbase")
			-- inst.AnimState:ClearOverrideSymbol("headbase_hat")
			-- inst.AnimState:ClearOverrideSymbol("lantern_overlay")
			-- inst.AnimState:ClearOverrideSymbol("leg")
			-- inst.AnimState:ClearOverrideSymbol("skirt")
			-- inst.AnimState:ClearOverrideSymbol("swap_body")
			-- inst.AnimState:ClearOverrideSymbol("swap_body_tall")
			-- inst.AnimState:ClearOverrideSymbol("SWAP_FACE")
			-- inst.AnimState:ClearOverrideSymbol("swap_hat")
			-- inst.AnimState:ClearOverrideSymbol("SWAP_ICON")
			-- inst.AnimState:ClearOverrideSymbol("swap_object")
			-- inst.AnimState:ClearOverrideSymbol("tail")
			-- inst.AnimState:ClearOverrideSymbol("torso")
			-- inst.AnimState:ClearOverrideSymbol("torso_pelvis")
					inst.sg:GoToState("tzfl_upper")
                end
            end),
        },

        onexit = function(inst)
            inst:Show()
        end,
    },
	
	State {
        name = "tzfl_upper",
        tags = {"noattack","busy"},
        onenter = function(inst, pushanim)
			inst.DynamicShadow:SetSize(7.8, 3.6)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("tzfl_upper")
        end,
		
		timeline =
        {
            TimeEvent(20 * FRAMES, groundpoundring),
        },

       events=
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },

	State {
        name = "idle",
        tags = {"noattack","idle", "canrotate","nomorph", "hiding", "nodangle"},
        onenter = function(inst, pushanim)
            inst.components.locomotor:StopMoving()
            local anim = "tzfl_idle_loop"

            if pushanim then
                if type(pushanim) == "string" then
                    inst.AnimState:PlayAnimation(pushanim)
                end
                inst.AnimState:PushAnimation(anim, true)
            else
                inst.AnimState:PlayAnimation(anim, true)
            end
        end,
		
		timeline =
        {
            TimeEvent(8 * FRAMES, groundpoundring),
        },

       events=
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
				SendModRPCToClient(CLIENT_MOD_RPC["tz"]["disableactions"], inst.userid,true)
            end),
			EventHandler("equip", function(inst)
				inst.AnimState:Show("HEAD")
			end),
        },
    },
	State{
        name = "run_start",
        tags = { "noattack","busy","moving", "running", "canrotate","nomorph", "hiding", "nodangle" },
        onenter = function(inst)
			inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED *2
			inst.components.locomotor:RunForward()
			inst.AnimState:PlayAnimation("tzfl_walk_pre")
        end,
        events =
        {
            EventHandler("animover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.sg:GoToState("run")
				end
			end),
        },
    }, 
	
	State{
        name = "run",
        tags = { "noattack","moving", "running", "canrotate","nomorph", "hiding", "nodangle" },

        onenter = function(inst)
            inst.components.locomotor:RunForward()
            inst.AnimState:PlayAnimation("tzfl_walk_loop", true)
            inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())
        end,
        onupdate = function(inst)
			if inst.components.locomotor:GetTimeMoving() <= 5 then
				if inst.components.locomotor:GetTimeMoving() > 3 then
					inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED *5
					SendModRPCToClient(CLIENT_MOD_RPC["tz"]["camera"], inst.userid,true)
				elseif inst.components.locomotor:GetTimeMoving() >= 1.5 then
					 -- inst.sg:GoToState("run_fast")
					inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED *3
				end
			end
			inst.components.locomotor:RunForward()
        end,
		events=
        {
			EventHandler("equip", function(inst)
				inst.AnimState:Show("HEAD")
			end),
        },
        ontimeout = function(inst)
			inst.sg.statemem.isrun = true
			inst.sg:GoToState("run")
		end,
		onexit = function(inst)
            if not inst.sg.statemem.isrun then
                inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED
            end
        end,
    }, 
	
	State{
        name = "run_fast",
        tags = {"noattack","moving", "running", "canrotate", "monkey", "autopredict","nomorph", "hiding", "nodangle"},

        onenter = function(inst)
            inst.components.locomotor:RunForward()
            inst.AnimState:PlayAnimation("tzfl_walk_loop", true)
            inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())
        end,

        onupdate = function(inst)
            if inst.components.locomotor:GetTimeMoving() < 2 then
                inst.sg:GoToState("run")
                return
			elseif inst.components.locomotor:GetTimeMoving() >= 3 and not inst.sg.statemem.camera then
				inst.sg.statemem.camera = true
				inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED *5
				SendModRPCToClient(CLIENT_MOD_RPC["tz"]["camera"], inst.userid,true)
            end
            inst.components.locomotor:RunForward()
        end,
		
		events=
        {
			EventHandler("equip", function(inst)
				inst.AnimState:Show("HEAD")
			end),
        },

        ontimeout = function(inst)
            inst.sg.statemem.fastrunning = true
            inst.sg:GoToState("run_fast")
        end,

        onexit = function(inst)
            if not inst.sg.statemem.fastrunning then
				-- SendModRPCToClient(CLIENT_MOD_RPC["tz"]["camera"], inst.userid,false)
                inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED
            end
        end,
    },
	
	State{
        name = "run_stop",
        tags = { "noattack","busy","canrotate", "autopredict","nomorph", "hiding", "nodangle"},

        onenter = function(inst)
			-- inst.Physics:Stop()
			if inst.AnimState:IsCurrentAnimation("tzfl_walk_loop") then
				inst.sg.statemem.isrun = inst.components.locomotor:GetTimeMoving() >= 3
				inst.AnimState:PlayAnimation("tzfl_walk_pst")
			else
				inst.AnimState:PushAnimation("tzfl_walk_pst",false)
			end
			if inst.sg.statemem.isrun then
				inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED * 3
			else
				inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED 
			end
			inst.components.locomotor:RunForward()
        end,
		timeline =
        {
			TimeEvent(9 * FRAMES, function(inst)
				if inst.sg.statemem.isrun then
					inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED *2
				else
					inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED *0.5
				end
				inst.components.locomotor:RunForward()
			end),
			TimeEvent(18 * FRAMES, function(inst)
				if inst.sg.statemem.isrun then
					inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED 
				else
					inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED *0.1
				end
				inst.components.locomotor:RunForward()
			end),
        },
        events =
        {
            EventHandler("animover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED
					inst.components.locomotor:StopMoving()
					SendModRPCToClient(CLIENT_MOD_RPC["tz"]["camera"], inst.userid,false)
					inst.sg:GoToState("idle")
				end
			end),
        },
    },
	
	State{
        name = "exit",
        tags = {"noattack","busy","nomorph", "hiding", "nodangle"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
			inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED
            inst.AnimState:PlayAnimation("tzfl_lower")
        end,
		
		timeline =
        {
            TimeEvent(13 * FRAMES, groundpoundring),
        },
		
        events=
        {
            EventHandler("animover", function(inst)
				-- inst.AnimState:ClearOverrideBuild("tz_feilong_actinos")
				-- inst.AnimState:ClearOverrideSymbol("arm_lower")
				-- inst.AnimState:ClearOverrideSymbol("arm_upper")
				-- inst.AnimState:ClearOverrideSymbol("arm_upper_skin")
				-- inst.AnimState:ClearOverrideSymbol("foot")
				-- inst.AnimState:ClearOverrideSymbol("hand")
				-- inst.AnimState:ClearOverrideSymbol("headbase")
				-- inst.AnimState:ClearOverrideSymbol("leg")
				-- inst.AnimState:ClearOverrideSymbol("torso")
				-- inst.AnimState:ClearOverrideSymbol("torso_pelvis")
				-- inst.AnimState:ClearOverrideSymbol("hair")
				-- inst.AnimState:ClearOverrideSymbol("hair_hat")
				-- inst.AnimState:ClearOverrideSymbol("face")
				-- inst.AnimState:ClearOverrideSymbol("cheeks")
				-- inst.AnimState:ClearOverrideSymbol("hairpigtails")
				-- inst.AnimState:ClearOverrideSymbol("skirt")
				-- inst.AnimState:Show("beard")
				inst.DynamicShadow:SetSize(1.3, .6)
                inst.sg:GoToState("exita")
            end),
        },
    },
	
	State{
        name = "exita",
        tags = {"noattack","busy"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("superjump_land")
			ChangeToCharacterPhysics(inst)
			DisableActions(inst,false)
        end,
		
		events=
        {
            EventHandler("animover", function(inst)
				inst:SetStateGraph("SGwilson")
                inst.sg:GoToState("idle")
            end),
        },
    },
	
	State{
        name = "death",
        tags = { "noattack","busy", "dead", "pausepredict", "nomorph" },
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("tzfl_death_lower")
			-- inst.AnimState:PushAnimation("superjump_land", false)
        end,
        timeline=
        {
			TimeEvent(13 * FRAMES, groundpoundring),
            TimeEvent(20*FRAMES, function(inst) 
				inst.DynamicShadow:SetSize(1.3, .6)
				DisableActions(inst,false)
				inst.AnimState:ClearOverrideBuild("tz_feilong_actinos")
			end),
        },
		events=
        {
            EventHandler("animover", function(inst)
				if inst.AnimState:AnimDone() then
                    if inst.sg:HasStateTag("dismounting") then
                        inst.sg:RemoveStateTag("dismounting")
                        inst.components.rider:ActualDismount()

                        inst.SoundEmitter:PlaySound("dontstarve/wilson/death")

						if inst.deathsoundoverride ~= nil then
							inst.SoundEmitter:PlaySound(FunctionOrValue(inst.deathsoundoverride, inst))
						elseif not inst:HasTag("mime") then
                            inst.SoundEmitter:PlaySound((inst.talker_path_override or "dontstarve/characters/")..(inst.soundsname or inst.prefab).."/death_voice")
                        end

                        if HUMAN_MEAT_ENABLED then
                            inst.components.inventory:GiveItem(SpawnPrefab("humanmeat")) -- Drop some player meat!
                        end
                        if inst.components.revivablecorpse ~= nil then
                            inst.AnimState:PlayAnimation("death2")
                        else
                            inst.components.inventory:DropEverything(true)
                            inst.AnimState:PlayAnimation(inst.deathanimoverride or "death")
                        end

                        inst.AnimState:Hide("swap_arm_carry")
                    elseif inst.components.revivablecorpse ~= nil then
                        inst.sg:GoToState("corpse")
                    elseif inst.ghostenabled then
                        inst.components.cursable:Died()
                        if inst:HasTag("wonkey") then
                            inst:ChangeFromMonkey()
                        else
                            inst:PushEvent("makeplayerghost", { skeleton = TheWorld.Map:IsPassableAtPoint(inst.Transform:GetWorldPosition()) }) -- if we are not on valid ground then don't drop a skeleton
                        end
                    else
                        inst:PushEvent("playerdied", { skeleton = TheWorld.Map:IsPassableAtPoint(inst.Transform:GetWorldPosition()) }) -- if we are not on valid ground then don't drop a skeleton
                    end
                end
            end),
        },
		onexit = function(inst)
			inst.AnimState:SetBank("wilson")
			inst:SetStateGraph("SGwilson")
        end,
    },
	State{
        name = "hop_pre",
        tags = { "doing", "nointerrupt", "busy", "boathopping", "jumping", "autopredict", "nomorph", "nosleep" },

        onenter = function(inst)
			TheNet:Announce("111")
			inst.sg:GoToState("run")
			inst.sg:SetTimeout(FRAMES)
        end,
		ontimeout = function(inst)
			inst.sg:GoToState("run")
		end,
    },
	
}


-- local hop_anims =
-- {
    -- pre = function(inst) return "tzfl_walk_loop" end,
    -- loop = function(inst) return "tzfl_walk_loop" end,
    -- pst = function(inst) return "tzfl_walk_loop" end,
-- }

-- CommonStates.AddRowStates(states, false)
-- CommonStates.AddHopStates(states, true, hop_anims)


return StateGraph("tz_feilong", states, events, "idle", actionhandlers)
