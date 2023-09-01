local TzBlink = Class(function(self, inst)
    self.inst = inst
    self.onblinkfn = nil
    self.blinktask = nil
end)

function TzBlink:SpawnEffect(inst,pt,invobject)
		local x, y, z = inst.Transform:GetWorldPosition()
		local bfon = SpawnPrefab("tz_bfon")
		if bfon then 
			bfon.Transform:SetPosition(x, y, z)
		end
		inst:DoTaskInTime(0.6, function()
			local fx = SpawnPrefab("tz_canying")
			if fx then
				fx.Transform:SetPosition(x, y, z)
				fx:ForceFacePoint(pt:Get())
				fx.AnimState:OverrideSymbol("swap_object", "swap_"..invobject.prefab, "swap_"..invobject.prefab)
				inst.blinkhy = fx
				fx.owner = inst
				fx:ListenForEvent("onremove", function(inst) 
				if invobject.components.timer  and not invobject.components.timer:TimerExists("tzblinkcd") then 
				invobject.components.timer:StartTimer("tzblinkcd", 15)
				invobject:RemoveTag("tzblinkcd")
				end
				inst.owner.blinkhy = nil end )
			end				
		end)
end

local function OnBlinked(caster, self, pt)
    if caster.components.health ~= nil then
        caster.components.health:SetInvincible(false)
    end
    caster.Physics:Teleport(pt:Get())
    caster:Show()
    if caster.DynamicShadow ~= nil then
        caster.DynamicShadow:Enable(true)
    end
    --caster.SoundEmitter:PlaySound("dontstarve/common/staff_blink")
end

function TzBlink:Blink(pt, caster,invobject)
    if not TheWorld.Map:IsPassableAtPoint(pt:Get()) or TheWorld.Map:IsGroundTargetBlocked(pt) then
        return false
    end
    if self.blinktask ~= nil then
        self.blinktask:Cancel()
    end
	if  caster.blinkhy  == nil then
		self:SpawnEffect(caster,pt,invobject) 
		caster.SoundEmitter:PlaySound("dontstarve/common/use_book_light")
		if caster.DynamicShadow ~= nil then
			caster.DynamicShadow:Enable(false)
		end
		if caster.components.health ~= nil then
			caster.components.health:SetInvincible(true)
		end
		self.blinktask =caster:DoTaskInTime(4 * FRAMES, OnBlinked, self, pt)

		if self.onblinkfn ~= nil then
			self.onblinkfn(self.inst, pt, caster)
		end
	else
		if caster.DynamicShadow ~= nil then
			caster.DynamicShadow:Enable(false)
		end
		if caster.components.health ~= nil then
			caster.components.health:SetInvincible(true)
		end
		self.blinktask = caster:DoTaskInTime(4 * FRAMES, function() 
			if caster.components.health ~= nil then
				caster.components.health:SetInvincible(false)
			end
			if caster.blinkhy ~= nil then
			local x, y, z = caster.blinkhy.Transform:GetWorldPosition()
			local bf = SpawnPrefab("tz_bfoff")
			if bf then 
				bf.Transform:SetPosition(caster.Transform:GetWorldPosition())
			end
			caster.Physics:Teleport(x, y, z )
			caster.blinkhy:Remove()
			if caster.DynamicShadow ~= nil then
				caster.DynamicShadow:Enable(true)
			end
			caster.SoundEmitter:PlaySound("dontstarve/sanity/creature2/die")
			end
			end)
	end
end

return TzBlink
