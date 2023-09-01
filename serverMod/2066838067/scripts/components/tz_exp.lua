local TzExp = Class(function(self,inst)
    self.inst = inst

    self.level = 1
    self.max_level = 9

    self.exp = 0
    self.max_exp = 100

    self.calc_max_exp_fn = nil 
    self:CalcMaxExp()
end)

function TzExp:SetCalcMaxExpFn(fn)
    self.calc_max_exp_fn = fn 
    self:CalcMaxExp()
end

function TzExp:IsLevelMax()
    return self.level >= self.max_level
end

function TzExp:DoDeltaLevel(delta)
    local old_level = self.level
    self.level = math.clamp(self.level + delta,1,self.max_level)
    self:CalcMaxExp()

    self.inst:PushEvent("tz_level_delta",{old=old_level,current=self.level})
end

function TzExp:DoDeltaExp(delta)
    self.exp = self.exp + delta
    while self.exp >= self.max_exp do
        self.exp = self.exp - self.max_exp
        self:DoDeltaLevel(1)
        if self:IsLevelMax() then
            self.exp = 0
            break
        end
    end
    self.inst:PushEvent("tz_exp_delta",{current=self.exp})
end

function TzExp:OnSave()
    return {
        level = self.level,
        exp = self.exp,
    }
end

function TzExp:OnLoad(data)
    if data ~= nil then 
        if data.level ~= nil then 
            self.level = data.level
        end

        if data.exp ~= nil then 
            self.exp = data.exp
        end
    end

    self:DoDeltaExp(0)
    self:DoDeltaLevel(0)
    self:CalcMaxExp()
end

function TzExp:GetLevel()
    return self.level
end

function TzExp:GetExp()
    return self.exp
end

function TzExp:GetMaxLevel()
    return self.max_level
end

function TzExp:GetMaxExp()
    return self.max_exp
end

function TzExp:CalcMaxExp()
    self.max_exp = self.calc_max_exp_fn and self.calc_max_exp_fn(self.inst,self.level) 
                    or 100
end

return TzExp