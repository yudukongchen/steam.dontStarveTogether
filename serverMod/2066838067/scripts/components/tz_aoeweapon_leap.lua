
local AOEWeapon_Leap = Class(function(self, inst)
    self.inst = inst
	self.range = 4
	self.canattack = nil 
	self.onleapoverride = nil 
end)

function AOEWeapon_Leap:SetRange(range)
	self.range = range
end

function AOEWeapon_Leap:SetOnLeap(fn)
	self.onleapoverride = fn
end

function AOEWeapon_Leap:SetCanAttack(fn)
	self.canattack = fn
end 

function AOEWeapon_Leap:DoLeap(leaper, startingpos, targetpos)
	if self.onleapoverride then 
		self.onleapoverride(leaper, startingpos, targetpos)
	else
		local found_mobs = {}
		local x, y, z = targetpos:Get()
		local ents = TheSim:FindEntities(x, y, z, self.range,{"_combat"})
		for _,ent in ipairs(ents) do
			if leaper ~= nil and ent ~= leaper and leaper.components.combat:IsValidTarget(ent) and ent.components.health 
			and (self.canattack == nil or self.canattack(self.inst,leaper,ent)) then
				leaper.components.combat.ignorehitrange = true
				leaper.components.combat:DoAttack(ent)
				SpawnPrefab("icey_hits_variety_fx"):SetTarget(ent)
				
				leaper.components.combat.ignorehitrange = false
			end
		end
		SpawnPrefab("superjump_fx"):SetTarget(leaper)
	end 
end

return AOEWeapon_Leap
