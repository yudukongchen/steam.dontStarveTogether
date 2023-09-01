local TzRpgBattery = Class(function(self, inst)
    self.inst = inst

    self.current = 4
    self.max = 4
    self.battery_ui = nil 

    self.reload_curtime = 0
    self.reload_maxtime = 3
    self.is_mannual_reload = false 
    self.reloading = false 
    self.reload_bar = nil 

    self.infinite_battery = false 
    
    inst:ListenForEvent("equipped",function(inst,data)
        if not self.battery_ui then 
            self.battery_ui = data.owner:SpawnChild("tz_rpg_battery")
        end
        self:DoDelta(0)
    end)
    inst:ListenForEvent("unequipped",function(inst,data)
        if self.battery_ui then 
            self.battery_ui:Remove()
            self.battery_ui = nil 
        end 
        self:StopReload()
    end)
    inst:ListenForEvent("onremove",function(inst,data)
        if self.battery_ui then 
            self.battery_ui:Remove()
            self.battery_ui = nil 
        end 
        self:StopReload()
    end)
end)

function TzRpgBattery:SetMax(val)
    self.max = val 
    self:DoDelta(0)
end

function TzRpgBattery:DoDelta(delta)
    if delta < 0 and self.infinite_battery then
        delta = 0
    end

    local old = self.current
    self.current = math.clamp(self.current + delta,0,self.max)

    if self.current <= 0 then 
        self.inst:AddTag("tz_rpg_nobattery")
    else
        self.inst:RemoveTag("tz_rpg_nobattery")
    end

    local owner = self.inst.components.inventoryitem:GetGrandOwner()
    local equipped = self.inst.components.equippable:IsEquipped()

    if owner and equipped then 
        self.battery_ui:SetCount(self.current)
        if self.current <= 0 then 
            self:StartReload(false)
        end
    else
        if self.battery_ui then 
            self.battery_ui:Remove()
            self.battery_ui = nil 
        end
    end

    self.inst:PushEvent("tz_rpg_battery_delta",{old = old,current = self.current})
end

function TzRpgBattery:IsFull()
    return self.current >= self.max
end

function TzRpgBattery:OnSave()
    local data = {}
    data.current = self.current
    return data
end

function TzRpgBattery:OnLoad(data)
    if data then 
        if data.current ~= nil then 
            self.current = data.current
        end
    end
    self:DoDelta(0)
end

function TzRpgBattery:IsReloading()
    return self.reloading
end

function TzRpgBattery:StartReload(is_mannual)
    local owner = self.inst.components.inventoryitem:GetGrandOwner()
    local equipped = self.inst.components.equippable:IsEquipped()

    if not (owner and equipped) then 
        self:StopReload()
        return 
    end
    
    if self.reloading then 
        self:StopReload()
    end
    self.reload_curtime = 0
    self.is_mannual_reload = is_mannual
    self.reloading = true
    self.reload_bar = owner:SpawnChild("tz_rpg_reloadbar")
    self.reload_bar.Transform:SetPosition(0,3.5,0)
    self.inst:StartUpdatingComponent(self)
end

function TzRpgBattery:StopReload()
    self.inst:StopUpdatingComponent(self)
    self.reload_curtime = 0
    self.is_mannual_reload = nil 
    self.reloading = false

    if self.reload_bar then 
        self.reload_bar:Remove()
        self.reload_bar = nil 
    end 
end

function TzRpgBattery:OnUpdate(dt)
    self.reload_curtime = self.reload_curtime + dt 
    self.reload_bar:SetPercent(math.clamp(self.reload_curtime / self.reload_maxtime,0,1))
    if self.reload_curtime >= self.reload_maxtime then 
        self:DoDelta(self.max)
        self.reload_curtime = 0
        if self.is_mannual_reload or self:IsFull() then 
            self:StopReload()
        end
    end
end


return TzRpgBattery