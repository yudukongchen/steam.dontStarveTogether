

local function onhd(self,hd)
    if self.inst.components.combat then
        self.inst.components.combat.tz_wzk_hd = hd
    end
end
local tz_wzk_hd = Class(function(self, inst)
    self.inst = inst
    self.hd = nil
    self.spawnhd = true
    self.targettime = nil
    self.task = nil
    self.cdtime = 240
end,
nil,
{
    hd = onhd,
})

local function donecd(inst,self)
    self.targettime = nil
    self.task = nil
end

function tz_wzk_hd:CanSpawnHd()
    return not IsEntityDeadOrGhost(self.inst, true) and self.hd == nil and self.targettime == nil
end

function tz_wzk_hd:CD()
    self.targettime =  GetTime() + self.cdtime
    self.task = self.inst:DoTaskInTime(self.cdtime, donecd, self)
end

function tz_wzk_hd:IsHD(hd)
    return self.hd == hd
end

function tz_wzk_hd:HasHD()
    return self.hd ~= nil
end

function tz_wzk_hd:SpawnHd(armor,nofx)
    if not armor then 
        return
    end
    self.hd = SpawnPrefab("tz_wzk_armor_fx")
    self.hd.entity:SetParent(self.inst.entity)
    self.hd.player = self.inst
    self.hd.absorb = armor.nengliang
    self.armor = armor
    self.hd:SetOwner(self.inst)
    if self.inst.components.inventory:IsItemEquipped(armor) and not nofx then
        self.inst:SpawnChild("tz_wzk_armor_lightfx")
    end
    --播放护盾音效
end

function tz_wzk_hd:EndHd()
    if self.hd ~= nil then
        self.hd:DoEnd()
        self.hd = nil
        self:CD()
        if self.armor and self.armor.addbuff then
            self.armor.addbuff[self.inst] = nil
            self.armor = nil
        end
    end
end

function tz_wzk_hd:LongUpdate(dt)
    if self.targettime ~= nil  then
        if self.task ~= nil then
            self.task:Cancel()
        end
        if self.targettime - dt > GetTime() then
            self.targettime = self.targettime - dt
            self.task = self.inst:DoTaskInTime(self.targettime - GetTime(), donecd, self)
            dt = 0
        else
            dt = dt - self.targettime + GetTime()
            donecd(self.inst, self)
        end
    end
end

function tz_wzk_hd:OnSave()
    local remainingtime = self.targettime ~= nil and self.targettime - GetTime() or 0
    return
    {
        hashd = self.hd ~= nil,
        remainingtime = remainingtime > 0 and remainingtime or nil,
    }
end

function tz_wzk_hd:OnLoad(data)
    if data.remainingtime ~= nil then
        self.targettime = GetTime() + math.max(0, data.remainingtime)
        self.task = self.inst:DoTaskInTime(data.remainingtime, donecd, self)
    elseif data.hashd then
        if self:HasHD() then
            self:EndHd()
        else
            self:CD()
        end
    end
end

return tz_wzk_hd
