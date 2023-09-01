local function oncurrent(self,current)
	if self.inst._lvl then
		self.inst._lvl:set(current)
	end
end
local Tz_yexinglvl = Class(function(self,inst)
    self.inst = inst
    self.max = 100
    self.min = 0
	self.current = self.min
end,
nil,
{
    current = oncurrent
})
function Tz_yexinglvl:GetPercent()
    return self.current / self.max
end
function Tz_yexinglvl:DoDelta(delta, overtime)  		
    local old = self.current 
	self.current = math.clamp(self.current + delta, 0, self.max)
    self.inst:PushEvent("yexinglvldelete",{oldpercent = old / self.max, newpercent = self.current / self.max, overtime = overtime, delta = self.current-old})
	
end
function Tz_yexinglvl:Chazuo()  		
	if self.inst.components.inventoryitem then
		self.inst.components.inventoryitem.canbepickedup = false 
	end
	local x,y,z = self.inst.Transform:GetWorldPosition()
	local light = SpawnPrefab("tz_yexiang_up")
		if  light then
			light.Transform:SetPosition(x,y,z)
			light:DoTaskInTime(light.AnimState:GetCurrentAnimationLength()*5, function() 
				light:Remove()
				self.inst:Remove() 
				SpawnPrefab("tz_yezhao").Transform:SetPosition(x,y,z)
			end)
		end
end

function Tz_yexinglvl:OnSave()
	return {
	current = self.current
	}
	
end
function Tz_yexinglvl:OnLoad(data)
	if data.current then
        self.current = data.current
    end
end
return Tz_yexinglvl