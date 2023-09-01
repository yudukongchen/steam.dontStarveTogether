
local Tz_firelvl = Class(function(self,inst)
    self.inst = inst
    self.max = 30
    self.min = 0
	self.current = self.min
end)
function Tz_firelvl:Setmax(num)  		
	self.max = num
end
function Tz_firelvl:DoDelta(delta)  		
	local newexp = self.current+delta  
    self.current = newexp 
	if self.current < 0 then 
        self.current = 0
    elseif self.current > self.max then
        self.current = self.max
    end
    self.inst:PushEvent("tz_firelvl",{current = newexp})
end
function Tz_firelvl:OnSave()
	return {
	current = self.current
	}
	
end
function Tz_firelvl:OnLoad(data)
	if data.current then
        self.current = data.current
    end
end
return Tz_firelvl