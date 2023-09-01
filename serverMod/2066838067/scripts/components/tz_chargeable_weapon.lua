-- local function onstate( self, state )
-- 	self.inst:PushEvent("tz_charge_state_change",{state=state})
-- end

-- local function oncur_time(self,cur_time)
-- 	self.inst:PushEvent("tz_charge_time_change",{time=cur_time,percent=self:GetTimePercent()})
-- end

local TzChargeableWeapon = Class(function(self,inst)
	self.inst = inst
	self.small_attack_override = nil 
	self.super_attack_override = nil 

	self.state = "RELEASED"
	
	self.need_time = 1.5
	self.cur_time = 0
	
	inst:AddTag("tz_chargeable_weapon")

	inst:ListenForEvent("unequipped",function()
		self:Release()
	end)
end)

function TzChargeableWeapon:Release()
	self:TimeDelta(-self.need_time)
end

function TzChargeableWeapon:Complete()
	self:TimeDelta(self.need_time)
end

function TzChargeableWeapon:GetState()
	return self.state
end

function TzChargeableWeapon:TimeDelta(delta)
	local old = self.cur_time
	local old_percent = self:GetTimePercent()
	self.cur_time = math.clamp(self.cur_time + delta,0,self.need_time)
	if self.cur_time >= self.need_time then 
		self.state = "COMPLETE"
	elseif self.cur_time  <= 0 then 
		self.state = "RELEASED"
	else
		self.state = "CHARGING"
	end 
	self.inst:PushEvent("tz_charge_time_change",{
		old = old,
		old_percent = old_percent,
		current=self.cur_time,
		current_percent=self:GetTimePercent(),
	})
end

function TzChargeableWeapon:GetTimePercent()
	return self.cur_time / self.need_time
end

return TzChargeableWeapon