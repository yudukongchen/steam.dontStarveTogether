local function onlevel(self)
	self.inst:DoTaskInTime(0.1, function()
		self.inst.components.combat:KrmDmgDelta(self.level * 0.1)
		self.inst.components.health.maxhealth = TUNING.KURUMI_OLDAGER + self.level * 10
		self.inst.components.health:SetPercent(self.inst.components.health:GetPercent())
	end)
end

local function onskinkey(self,skinkey,old)
	if skinkey ~= "kurumi" then
		self.inst.AnimState:SetBuild(skinkey)
	elseif skinkey == "kurumi" and old ~= skinkey then
		local skin = self.inst.components.skinner.skin_name
		self.inst.AnimState:SetBuild(skin ~= "kurumi_none" and skin or "kurumi")
	end
end

local Krm_Ability = Class(function(self, inst)
	self.inst = inst
	self.level = 0
	self.skinkey = "kurumi"
end,
nil,
{
	level = onlevel,
	skinkey = onskinkey
})

function Krm_Ability:LeaveUp()
	if self.level < 12 then
		self.level = self.level + 1
		self.inst.components.talker:Say("当前等级"..self.level.."!")
	end
	self.inst.components.health:DoDelta(625, true, "krm_heal")
	self.inst.components.hunger:DoDelta(33)
	self.inst.components.sanity:DoDelta(TUNING.KURUMI_SANITY)
end

function Krm_Ability:SetSkinKey(skinkey)
	self.skinkey = skinkey
end

function Krm_Ability:OnSave()
	return {
		level = self.level,
		skinkey = self.skinkey
	}
end

function Krm_Ability:OnLoad(data)
	if data then
		self.level = data.level
		if data.skinkey  and data.skinkey ~= "kurumi" then
			self.inst:DoTaskInTime(0,function()
				self.skinkey = data.skinkey
			end)
		end
	end
end

return Krm_Ability