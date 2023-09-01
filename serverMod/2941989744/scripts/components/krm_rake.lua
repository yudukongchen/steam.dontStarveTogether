
local  krm_rake = Class(function(self, inst)
	self.inst = inst
end)

function krm_rake:TryParry(owner, attacker, damage, weapon, stimuli)
	if owner ~= nil and attacker ~= nil and damage > 0  then
		if owner.components.hunger and owner.components.hunger.current > 0 then
			owner.components.hunger:DoDelta(-damage*0.1, false)
		else
			owner.components.health:DoDelta(-damage*0.1, false,attacker.prefab,nil,attacker)
		end
		return true
	end
	return false
end

return krm_rake


