local Asa_Exp = Class(function(self, inst)
    self.inst = inst
	
	self.exp = 0
	
	self.lv1 = 10 --等级门槛，约为10只小蜘蛛
	self.lv2 = 20
	self.lv3 = 40	--三级解锁斩模式，门槛显著提高
	self.lv4 = 100	--需求急速提升
	self.lv5 = 250
	self.lv6 = 500	--六级解锁开大，门槛显著提高
	self.lv7 = 1000
	self.lv8 = 2000
	self.lv9 = 3500
	self.lv10 = 5000
	
	--实测单挑一只熊0.5倍速大概200经验左右
	
	self.max = self.lv10
	
	self.rate = 0.5 --升级倍率
	
	--更新
	inst:ListenForEvent("attacked",function(inst, data)
		if data.damage >= 10 then
			self:DoDelta(2 * self.rate)
		elseif data.damage >= 4 then
			self:DoDelta(1 * self.rate)
		else
			self:DoDelta(0.5 * self.rate)
		end
	end)
	
	inst:ListenForEvent("onhitother",function(inst, data)
		if data.target and data.target.components.combat then
			if data.target:HasTag("epic") then
				self:DoDelta(3 * self.rate)
			elseif data.target:HasTag("monster") or data.target.components.combat.defaultdamage >= 20 then
				self:DoDelta(1 * self.rate)
			else
				self:DoDelta(0.5 * self.rate)
			end
		end
	end)
	
	
	
end,
nil,
{
    
})

--获取经验值
function Asa_Exp:Get()
	return self.exp or 0
end

--设定经验值
function Asa_Exp:Set(amount)
	self.exp:DoDelta(amount - self.exp)
end

--变更经验值
function Asa_Exp:DoDelta(amount)
	self.exp = self.exp + amount <= self.max and self.exp + amount or self.max
	if self.exp >= self.lv10 then
		self.inst.components.asa_power:SetMax(10)
	elseif self.exp >= self.lv9 then 
		self.inst.components.asa_power:SetMax(9)
	elseif self.exp >= self.lv8 then 
		self.inst.components.asa_power:SetMax(8)
	elseif self.exp >= self.lv7 then 
		self.inst.components.asa_power:SetMax(7)
	elseif self.exp >= self.lv6 then 
		self.inst.components.asa_power:SetMax(6)
	elseif self.exp >= self.lv5 then 
		self.inst.components.asa_power:SetMax(5)
	elseif self.exp >= self.lv4 then 
		self.inst.components.asa_power:SetMax(4)
	elseif self.exp >= self.lv3 then 
		self.inst.components.asa_power:SetMax(3)
	elseif self.exp >= self.lv2 then 
		self.inst.components.asa_power:SetMax(2)
	elseif self.exp >= self.lv1 then 
		self.inst.components.asa_power:SetMax(1)
	else
		self.inst.components.asa_power:SetMax(0)
	end
	
end

--保存
function Asa_Exp:OnSave()
	return {
		exp = self.exp,
		rate = self.rate
	}
end
--加载
function Asa_Exp:OnLoad(data)
	if data then
		self.exp = data.exp
		self.rate = data.rate
    end
end

return Asa_Exp