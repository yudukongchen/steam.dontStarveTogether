local tz_xin_naozi_tongyong = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

function tz_xin_naozi_tongyong:ForcePetrify()
    self._petrifytime = GetTime() + math.random()
end

function tz_xin_naozi_tongyong:OnStart()
	local root = PriorityNode(
	{
        WhileNode(function()
			return self.inst.components.combat.target == nil or not self.inst.components.combat:InCooldown()
		end, "追击",
		ChaseAndAttack(self.inst, 10, 20)),
		
		Follow(self.inst, function() return self.inst.components.follower.leader end, 1, 5, 9),
	}, .25)
	self.bt = BT(self.inst, root)
end

return tz_xin_naozi_tongyong