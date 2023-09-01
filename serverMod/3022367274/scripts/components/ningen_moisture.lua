local function checkmoisture(inst,self,period)
    self:DoDec(period)
end

local Ningen_moisture = Class(function(self, inst)
    self.inst = inst
    self.hurtrate = TUNING.WILSON_HEALTH / TUNING.STARVE_KILL_TIME
    self.isdried = false
    local period = 1
    self.inst:DoPeriodicTask(period, checkmoisture, nil, self, period)
end,
nil,
{

})

function Ningen_moisture:DoDec(dt)
    if self.inst:HasTag("playerghost") then
        return
    end
    local num = self.inst.components.moisture:GetMoisture()
    local isdried = num == 0 and true or false
    if isdried == true then
        self.inst:PushEvent("startdrying")
        self.inst.components.health:DoDelta(-self.hurtrate * dt, true, "dryness") --  ich haber hunger
        self.isdried = true
        self.inst:AddTag("ningenisdried")
    else
        self.inst:RemoveTag("ningenisdried")
        self.isdried = false
        self.inst:PushEvent("stopdrying")
    end
    if num < 30 then
        self.inst:AddTag("groggy")
        if not self.inst:HasTag("playerghost") then
            self.inst.components.locomotor:SetExternalSpeedMultiplier(self.inst,"dryness",0.5)
        end
    else
        if self.inst.components.grogginess and not self.inst.components.grogginess:IsGroggy() then
            self.inst:RemoveTag("groggy")
        end
        self.inst.components.locomotor:RemoveExternalSpeedMultiplier(self.inst,"dryness")
    end
end

function Ningen_moisture:IsDried()
    return self.isdried
end

return Ningen_moisture