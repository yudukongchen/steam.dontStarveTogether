local function OnTaskTick(inst, self, period)
    self:DoDec(period)
end
local Foodspill = Class(function(self, inst)
    self.inst = inst
    self.max = 100
	self.min = 0
    self.current = self.min
    self.rate = 2
    local period = 1
    self.inst:DoPeriodicTask(period, OnTaskTick, nil, self, period)
end,
nil,
{
})


function Foodspill:OnSave()
    return self.current ~= self.min and { foodspill = self.current } or nil
end

function Foodspill:OnLoad(data)
    if data.foodspill ~= nil and self.current ~= data.foodspill then
        self.current = data.foodspill
    end
end

function Foodspill:LongUpdate(dt)
    self:DoDec(dt, true)
end

function Foodspill:SetMax(amount)
    self.max = amount
end

function Foodspill:DoDelta(delta, overtime)
    local old = self.current
    self.current = math.clamp(self.current + delta, self.min, self.max)
    self.inst:PushEvent("foodspilldelta", { oldpercent = old / self.max, newpercent = self.current / self.max, overtime = overtime, delta = self.current-old })
end

function Foodspill:DoDec(dt)
    local old = self.current
    if self.current > 0 then
		self:DoDelta( - self.rate/6 * dt * .1, true)
    end
end  

function Foodspill:SetRate(num)
    self.rate = num
end
return Foodspill