-- Unofficial AOEWeapon_Lunge component
local AOEWeapon_Lunge = Class(function(self, inst)
	self.inst = inst
	self.width = 3
	self.canattack = nil 
end)

function AOEWeapon_Lunge:SetCanAttack(fn)
	self.canattack = fn
end 



function AOEWeapon_Lunge:DoLunge(lunger,startingpos, targetpos)
	local mob_index = {}
	for i = 0,10 do
		lunger:DoTaskInTime(FRAMES*math.ceil(1+i/3.5), function()
			local offset = (targetpos - startingpos):GetNormalized()*(i*0.6)
			local fx = SpawnPrefab("spear_gungnir_lungefx")
			fx.Transform:SetPosition((startingpos+offset):Get())
			fx.AnimState:SetAddColour(1, 1, 0, 0.75)
			
			local x, y, z = (startingpos + offset):Get()
			local ents = TheSim:FindEntities(x, y, z, self.width/2, {"_combat"})
			for k,ent in ipairs(ents) do
				if not mob_index[ent] and ent ~= lunger and lunger.components.combat:IsValidTarget(ent) and ent.components.health
				and (self.canattack == nil or self.canattack(self.inst,lunger,ent)) then
					mob_index[ent] = true
					lunger.components.combat.ignorehitrange = true
					lunger.components.combat:DoAttack(ent)
					SpawnPrefab("icey_hits_variety_fx"):SetTarget(ent)
					lunger.components.combat.ignorehitrange = false
				end
			end
		end)
	end

	return true
end

return AOEWeapon_Lunge