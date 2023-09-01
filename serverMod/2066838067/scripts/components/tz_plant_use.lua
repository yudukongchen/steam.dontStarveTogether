
local tz_plant_use = Class(function(self, inst)
    self.inst = inst
    self.onusefn = nil
end)

function tz_plant_use:SetUse(fn)
    self.onusefn = fn
end

function tz_plant_use:Use(doer)
    if self.onusefn then
        return self.onusefn(self.inst,doer)
    end
    return true
end

return tz_plant_use