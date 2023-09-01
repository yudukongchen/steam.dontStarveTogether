local function onlevel(self,level)
	if level ~= 0 and self.inst.tz_fh_level ~= nil then
		self.inst.tz_fh_level:set(level)
	end
end
local function _equipped(inst, data)
    if data and data.owner and data.owner.components.combat and inst.components.tz_fh_level.zhuanshu and inst.components.tz_fh_level.level ~= 0 then
		data.owner.components.combat.externaldamagemultipliers:SetModifier(inst, 1+inst.components.tz_fh_level.level*0.01)
		if data.owner.components.locomotor then
			data.owner.components.locomotor:SetExternalSpeedMultiplier(data.owner, inst, 1+inst.components.tz_fh_level.level*0.01)
		end
    end
end

local function _unequipped(inst, data)
	local owner  = data.owner
    if owner and owner.components.combat and inst.components.tz_fh_level.zhuanshu then
		owner.components.combat.externaldamagemultipliers:RemoveModifier(inst)
		if owner.components.locomotor then
			owner.components.locomotor:RemoveExternalSpeedMultiplier(owner, inst)
		end
    end
end
local tz_fh_level = Class(function(self, inst)
    self.inst = inst
    self.level = 0
	self.zhuanshu = false
	inst:ListenForEvent("equipped", _equipped)
	inst:ListenForEvent("unequipped", _unequipped)
end,
nil,
{
	level = onlevel,
})

function tz_fh_level:GiveItem(item,doer)
	if self.level >= 65535 then
		return --番号强化最大等级
	end
	local num = (item.components.tz_fh_level ~= nil and item.components.tz_fh_level.level or 0) + 1
	self.level = self.level + num
	item:Remove()
	if self.zhuanshu then
		if self.inst.components.equippable:IsEquipped() and self.inst.components.inventoryitem.owner ~= nil then
			_equipped(self.inst,{owner = self.inst.components.inventoryitem.owner })
		end
	end
	if self.levelupfn then
		self.levelupfn(self.inst)
	end
end

function tz_fh_level:OnLoad(data)
    if data then
		if data.level ~= nil then
        	self.level = data.level
			if self.levelupfn then
				self.levelupfn(self.inst)
			end
		end
    end
end

function tz_fh_level:OnSave()
    return self.level ~= 0 and { level = self.level } or nil
end

return tz_fh_level
