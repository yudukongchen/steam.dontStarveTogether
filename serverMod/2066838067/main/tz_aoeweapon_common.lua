AddStategraphPostInit("wilson", function(sg)
	local old_CASTAOE = sg.actionhandlers[ACTIONS.CASTAOE].deststate
    sg.actionhandlers[ACTIONS.CASTAOE].deststate = function(inst, action)
		local weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		if weapon then 
			if weapon:HasTag("quickcast") then 
				return "quickcastspell"
			elseif weapon:HasTag("veryquickcast") then 
				return "veryquickcastspell"
			elseif weapon:HasTag("tz_fhzlz") then 
				-- Defined in main/tz_fh_api.lua
				return "tz_fhzlz_multithrust"
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
			if weapon:HasTag("quickcast") then 
				return "quickcastspell"
			elseif weapon:HasTag("veryquickcast") then 
				return "veryquickcastspell"
			elseif weapon:HasTag("tz_fhzlz") then 
				inst:PerformPreviewBufferedAction()
				return 
			end 
		end 
		return old_CASTAOE(inst, action)
	end
end)