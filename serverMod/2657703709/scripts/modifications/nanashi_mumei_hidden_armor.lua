local function hidden(inst)
    	--Hides Armor and Hat
	if TUNING.NANASHI_MUMEI_HIDDEN then
		inst:ListenForEvent("equip", function()
			inst.AnimState:ClearOverrideSymbol("swap_hat")
			inst.AnimState:Show("hair")
			inst.AnimState:ClearOverrideSymbol("swap_body")
			inst.AnimState:Show("body")
		end)
	end
end
return hidden