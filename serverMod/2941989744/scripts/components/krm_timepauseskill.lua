
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
	self.inst:DoTaskInTime(SKILLDURATION, function() 
		self:EndSkill() 
		self.inusing = false
	end)
end

function Skill:StartPauseFn()
	self.inst.replica.krm_timepauseskill:SetIsMagicCenter(true)
end

function Skill:EndSkill()
	self.inst.replica.krm_timepauseskill:SetIsMagicCenter(false)
end

return Skill
