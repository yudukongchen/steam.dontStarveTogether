local TzWeaponCharge = Class(function(self,inst)
	self.inst = inst
	self.cur_time = 0
	self.state = "RELEASED"
	self.percent = 0 
	self.attack_keys = {
		[CONTROL_PRIMARY] = false,
		[CONTROL_SECONDARY] = false,
		[CONTROL_ATTACK] = false,
		[CONTROL_CONTROLLER_ATTACK] = false,
	}

	inst:ListenForEvent("newstate",function(inst,data)
		if not inst.sg:HasStateTag("charging_attack") then 
			self:Release()
		end
	end)
end)

function TzWeaponCharge:SetKey(key,pressed)
	if pressed == nil then 
		pressed = false
	end 

	if self.attack_keys[key] ~= nil then 
		self.attack_keys[key] = pressed
	end
end

function TzWeaponCharge:AtkPressed(is_free_charge)
	if is_free_charge then 
		return self.attack_keys[CONTROL_SECONDARY]
	else
		for k,v in pairs(self.attack_keys) do 
			if v then 
				return v
			end 
		end
	end 

	return false
end

function TzWeaponCharge:GetFaceVector()
	local angle = (self.inst.Transform:GetRotation() + 90) * DEGREES
	local sinangle = math.sin(angle)
	local cosangle = math.cos(angle)

	return Vector3(sinangle,0,cosangle)
end

function TzWeaponCharge:DoSmallAttack()
	local weapon = self.inst.components.combat and self.inst.components.combat:GetWeapon()

	if weapon and weapon.components.tz_chargeable_weapon and weapon.components.tz_chargeable_weapon.small_attack_override then 
		weapon.components.tz_chargeable_weapon.small_attack_override(self.inst,self:GetFaceVector())
	end 
end

function TzWeaponCharge:DoSuperAttack()
	local weapon = self.inst.components.combat and self.inst.components.combat:GetWeapon()

	if weapon and weapon.components.tz_chargeable_weapon and weapon.components.tz_chargeable_weapon.super_attack_override then 
		weapon.components.tz_chargeable_weapon.super_attack_override(self.inst,self:GetFaceVector())
	end 
end

function TzWeaponCharge:Start()
	self.inst:StartUpdatingComponent(self)
	self.percent = 0
end

function TzWeaponCharge:Stop()
	self.inst:StopUpdatingComponent(self)
end

function TzWeaponCharge:Complete()
	self:Stop()
	self.percent = 1
	local weapon = self.inst.components.combat:GetWeapon()
	if weapon and weapon.components.tz_chargeable_weapon then 
		weapon.components.tz_chargeable_weapon:Complete()
	end
end

function TzWeaponCharge:Release()
	self:Stop()
	self.percent = 0
	local weapon = self.inst.components.combat:GetWeapon()
	if weapon and weapon.components.tz_chargeable_weapon then 
		weapon.components.tz_chargeable_weapon:Release()
	end
end

function TzWeaponCharge:GetState()
	local weapon = self.inst.components.combat:GetWeapon()
	if weapon and weapon.components.tz_chargeable_weapon then 
		return weapon.components.tz_chargeable_weapon:GetState()
	end
end

function TzWeaponCharge:IsComplete()
	return self:GetState() == "COMPLETE"
end

function TzWeaponCharge:IsCharging()
	return self:GetState() == "CHARGING"
end

function TzWeaponCharge:GetPercent()
	return self.percent
end

function TzWeaponCharge:OnUpdate(dt)
	local weapon = self.inst.components.combat:GetWeapon()
	if weapon and weapon.components.tz_chargeable_weapon then 
		weapon.components.tz_chargeable_weapon:TimeDelta(dt)
		self.percent = weapon.components.tz_chargeable_weapon:GetTimePercent()
		if weapon.components.tz_chargeable_weapon:GetState() == "COMPLETE" then 
			self:Stop()
		end
	end
end


return TzWeaponCharge