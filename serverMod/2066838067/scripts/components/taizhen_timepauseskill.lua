
local SKILLDURATION = 15

local Skill = Class(function(self, inst)
    self.inst = inst
	self.inusing = false
end)

function Skill:UseSkill()
	if self.inusing then
		return
	end
	self:StartPauseFn()
	self.inusing = true

	self.inst:DoTaskInTime(SKILLDURATION-1.5, function() 
		self.inst.SoundEmitter:PlaySound("ta_timeskill/ta_timeskill/over")
	end)

	self.inst:DoTaskInTime(SKILLDURATION, function() 
		self:EndSkill() 
		self.inusing = false
	end)
end

function Skill:StartPauseFn()
	self.inst.replica.taizhen_timepauseskill:SetIsMagicCenter(true)
end

function Skill:EndSkill()
	self.inst.replica.taizhen_timepauseskill:SetIsMagicCenter(false)
end

return Skill
