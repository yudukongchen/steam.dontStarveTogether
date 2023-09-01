local TzWeaponCharge = Class(function(self,inst)
	self.inst = inst
end)

function TzWeaponCharge:AtkPressed(is_free_charge)
	if is_free_charge then 
		return self.inst.components.playercontroller:IsAnyOfControlsPressed(
                        CONTROL_SECONDARY)
	else
		return self.inst.components.playercontroller:IsAnyOfControlsPressed(
                        CONTROL_PRIMARY,
                        CONTROL_ATTACK,
                        CONTROL_CONTROLLER_ATTACK)
	end 

	return false
end


return TzWeaponCharge