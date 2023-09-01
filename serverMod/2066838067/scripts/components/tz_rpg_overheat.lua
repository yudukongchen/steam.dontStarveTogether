local SourceModifierList = require("util/sourcemodifierlist")

local TzRpgOverheat = Class(function(self,inst)
    self.inst = inst

    self.current = 0
    self.overload_threshold = 20
    self.max = 32

    -- 热量减少1点所需的时间
    self.cold_one_time = SourceModifierList(inst, 0, SourceModifierList.additive)
    self.overheat_resume_time = 10

    -- 基础下降速度是-2热量/秒，所以热量减少1点所需的时间初始值为0.5
    self.cold_one_time:SetModifier(self.inst,0.5,"m_base")

    self.infinite_cooldown = false 

    self.inst:StartUpdatingComponent(self)
end)

function TzRpgOverheat:DoDelta(val)
    if val > 0 and self.infinite_cooldown then
        val = 0  
    end

    local old = self.current
    self.current = math.clamp(self.current + val,0,self.max)

    if self:IsOverload() then 
        self.inst:AddTag("tz_rpg_overloaded")
    else
        self.inst:RemoveTag("tz_rpg_overloaded")
    end

    if self:IsOverHeated() then 
        self.inst:AddTag("tz_rpg_overheated")
        self:OnOverheat()
    else
        self.inst:RemoveTag("tz_rpg_overheated")
    end

    self.inst:PushEvent("tz_rpg_heat_delta",{old=old,current=self.current})
end

function TzRpgOverheat:OnOverheat()
    self.inst:StopUpdatingComponent(self)
    if self.overheating_task then 
        self.overheating_task:Cancel()
    end
    self.overheating_task = self.inst:DoTaskInTime(self.overheat_resume_time,function()
        self.inst:StartUpdatingComponent(self)
        self:DoDelta(-self.max)
        self.overheating_task = nil 
    end)
end

function TzRpgOverheat:IsOverload()
    return self.current >= self.overload_threshold
end

function TzRpgOverheat:IsOverHeated()
    return self.current >= self.max 
end


function TzRpgOverheat:OnSave()
    return {
        current = self.current,
    }
end

function TzRpgOverheat:OnLoad(data)
    if data then 
        if data.current ~= nil then 
            self.current = data.current
        end
    end

    self:DoDelta(0)
end

function TzRpgOverheat:OnUpdate(dt)
    local speed = 1 / math.max(0.01,self.cold_one_time:Get())
    self:DoDelta(-dt * speed)
end

return TzRpgOverheat