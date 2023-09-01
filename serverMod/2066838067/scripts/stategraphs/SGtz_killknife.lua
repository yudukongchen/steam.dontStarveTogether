--tz_killknife
AddStategraphPostInit("wilson", function(sg)
	local old_CASTAOE = sg.actionhandlers[ACTIONS.CASTAOE].deststate
    sg.actionhandlers[ACTIONS.CASTAOE].deststate = function(inst, action)
		local weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		if weapon  then 
			if  weapon:HasTag("tz_killknife") then 
				return "tz_killknife_shadowatk"
			end 
		end 
		return old_CASTAOE(inst, action)
	end
end)


AddStategraphPostInit("wilson_client", function(sg)
	local old_CASTAOE = sg.actionhandlers[ACTIONS.CASTAOE].deststate
    sg.actionhandlers[ACTIONS.CASTAOE].deststate = function(inst, action)
		local weapon = inst.replica.combat:GetWeapon()
		if weapon  then 
			if  weapon:HasTag("tz_killknife") then 
				return "tz_killknife_shadowatk"
			end 
		end 
		return old_CASTAOE(inst, action)
	end
end)

local function TzErodeAway(inst, erode_time)
    local time_to_erode = erode_time or 1
    local tick_time = TheSim:GetTickTime()

    if inst.DynamicShadow ~= nil then
        inst.DynamicShadow:Enable(false)
    end

    local thread = inst:StartThread(function()
        local ticks = 0
        while ticks * tick_time < time_to_erode do
            local erode_amount = ticks * tick_time / time_to_erode
            inst.AnimState:SetErosionParams(erode_amount, 0.1, 1.0)
            ticks = ticks + 1
			Yield()
        end
		inst:PushEvent("tz_erodeaway_finish")
    end)
	
	return thread
end

local TzErodeAwayTime = 0.5
local DoShadowAtkTime = 0.7
local TimeOut = 3.2

AddStategraphState("wilson", 
	State{
		name = "tz_killknife_shadowatk",
        tags = { "aoe", "notalking", "abouttoattack", "autopredict" },
		onenter = function(inst)
			inst.components.locomotor:Stop()
			inst.AnimState:PlayAnimation("atk_leap_pre")	
			inst.AnimState:PushAnimation("atk_leap_lag",false)
			inst.components.health:SetInvincible(true)
			inst.components.playercontroller:Enable(false)
			inst.sg.statemem.TzErodeAwayTask = TzErodeAway(inst,TzErodeAwayTime)
			inst.sg:SetTimeout(TimeOut)
		end,

		
		timeline =
		{
		
			
			TimeEvent(0.7, function(inst)
				inst.SoundEmitter:PlaySound("tz_killknife_fx/fx/killknife_skill")
			end),
			TimeEvent(DoShadowAtkTime, function(inst)
				inst:PerformBufferedAction()
			end),
		},

		events =
		{
			EventHandler("unequip", function(inst)
                inst.sg:GoToState("idle")
            end),
		},
		
		ontimeout = function(inst)
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle")
        end,
		


		onexit = function(inst)			
			if inst.DynamicShadow ~= nil then
				inst.DynamicShadow:Enable(true)
			end
			if inst.sg.statemem.TzErodeAwayTask then 
				KillThread(inst.sg.statemem.TzErodeAwayTask)
			end
			inst.sg.statemem.TzErodeAwayTask = nil 
			inst.AnimState:SetErosionParams(0, 0, 1.0)
			inst.components.health:SetInvincible(false)
			inst.components.playercontroller:Enable(true)
			SpawnAt("statue_transition",inst:GetPosition()).Transform:SetScale(1.5,1.5,1.5)
			SpawnAt("statue_transition_2",inst:GetPosition()).Transform:SetScale(1.5,1.5,1.5)
		end,
			
	}
)

AddStategraphState("wilson_client", 
	State{
		name = "tz_killknife_shadowatk",
        tags = { "aoe", "notalking", "abouttoattack", "autopredict" },
		onenter = function(inst)
			inst.components.locomotor:Stop()
			inst.AnimState:PlayAnimation("atk_leap_pre")	
			inst.AnimState:PushAnimation("atk_leap_lag",false)
			inst:PerformPreviewBufferedAction()
			inst.sg:SetTimeout(TimeOut)
		end,

		
		timeline =
		{

		},

		events =
		{
			EventHandler("unequip", function(inst)
                inst.sg:GoToState("idle")
            end),
		},
		
		ontimeout = function(inst)
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle")
        end,
		


		onexit = function(inst)			
			if inst.DynamicShadow ~= nil then
				inst.DynamicShadow:Enable(true)
			end
		end,
			
	}
)