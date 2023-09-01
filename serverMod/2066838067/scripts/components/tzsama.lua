
local function onmax(self, max)
    self.inst._tzsamamax:set(max)
end
local function oncurrent(self, current)
    self.inst._tzsamacurrent:set(current)
end
local function onratescale(self, ratescale)
    self.inst._tzsamaratescale:set(ratescale)
end
local function ondeath(self, death)
    self.inst._tzsamadeath:set(death)
end
local function onspeed(self, speed)
    self.inst._speed:set(speed)
end
local sama_MOD_TIMER_DT = FRAMES 
local Tzsama = Class(function(self, inst)
    self.inst = inst
    self.max = 100
    self.current = self.max
    self.rate = 0
	self.speed = 0
	self.addrate = 0
    self.ratescale = RATE_SCALE.NEUTRAL
	self.dapperness =0
	self.add = 0
    self.burning = true
    self.death = 0
	
    self.sama_modifiers_add = {}
    self.sama_modifiers_add_timer = {}
	
	self.inst:StartUpdatingComponent(self)
	if TheWorld.ismastersim then
		self.inst:WatchWorldState("cycles", function() 
			self:CheckUp()
		end)
	end
end,
nil,
{
    max = onmax,
    current = oncurrent,
    ratescale = onratescale,
	speed = onspeed,
    death = ondeath,
})

function Tzsama:CheckUp()
	self.inst:DoTaskInTime(0,function()
		if self.inst.components.age   then 
			local a  = math.floor(self.inst.components.age:GetAgeInDays() or 0)
			local percent = self:GetPercent()
			self.max = (200 + a/2 + self.add)*(1-self.death)
			self:SetPercent(percent)
			self.inst:PushEvent("tzsmamaxchange",{num = self.max })
		end
	end)
end

function Tzsama:SetAdd(num)
	self.add = num
	self:CheckUp()
end

function Tzsama:DoDeath()
	self.death = math.min(self.death + 0.15,0.75)
	self:CheckUp()
end

function Tzsama:OutDeath()
	self.death = math.max(self.death - 0.15,0)
	self:CheckUp()
end

function Tzsama:OnSave()
    return
    {
        current = self.current,
        max = self.max,
        sama_modifiers_add = self.sama_modifiers_add,
        sama_modifiers_add_timer = self.sama_modifiers_add_timer,
		add = self.add,
        death = self.death
    }
end

function Tzsama:DoSpeedDelta(delta)
	self._oldspeed = self.speed
    self.speed = self._oldspeed + delta
end

function Tzsama:OnLoad(data)
    if data.current ~= nil then
        self.current = data.current
    end
    if data.max ~= nil then
        self.max = data.max
    end
    if data.sama_modifiers_add then
        self.sama_modifiers_add = data.sama_modifiers_add
    end
	
    if data.add then
        self.add = data.add
    end
    if data.death then
        self.death = data.death 
    end
	
    if data.sama_modifiers_add_timer then
       self.sama_modifiers_add_timer = data.sama_modifiers_add_timer

        if not self.updating_mods_task then
            self.updating_mods_task = self.inst:DoPeriodicTask(sama_MOD_TIMER_DT, function() self:UpdatesamaModifierTimers(sama_MOD_TIMER_DT) end)
        end
    end
	self:CheckUp()
	self:DoDelta(0)
end

function Tzsama:DoneInfoLoad()
	self:CheckUp()
	self:DoDelta(0)
end

function Tzsama:GetDebugString()
	return string.format("%2.2f / %2.2f ,rate: %2.2f ",self.current, self.max , self.rate)
end

function Tzsama:SetMax(amount)
    self.max = amount
    self.current = amount
end

function Tzsama:DoDelta(delta, overtime)
    if not self.burning then
        return
    end
    if not overtime and  (self.inst.components.health and self.inst.components.health:IsInvincible() or self.inst.is_teleporting) then
        return
    end
	self._oldpercent = self:GetPercent()

    self.current = math.clamp(self.current + delta, 0, self.max)
    self.inst:PushEvent("tzsamadelta", { oldpercent = self._oldpercent, newpercent = self:GetPercent(), overtime = overtime })
end

function Tzsama:GetPercent()
    return self.current / self.max
end

function Tzsama:SetPercent(per, overtime)
    local target = per * self.max
    local delta = target - self.current
    self:DoDelta(delta, overtime)
end

function Tzsama:OnUpdate(dt)
    if not self.inst:HasTag("playerghost") then
        self:Recalc(dt)
    else
        self.rate = 0
        self.ratescale = RATE_SCALE.NEUTRAL
    end
end
function Tzsama:GetRateScale()
    return self.ratescale
end

function Tzsama:Pause()
    self.burning = false
end

function Tzsama:Resume()
    self.burning = true
end

function Tzsama:SetCurrentSama(amount)
    self.current = amount
end
function Tzsama:AddsamaModifier_Additive(key, mod, timer)
    self.sama_modifiers_add[key] = mod
    if timer then
        self.sama_modifiers_add_timer[key] = timer

        if not self.updating_mods_task then
            self.updating_mods_task = self.inst:DoPeriodicTask(sama_MOD_TIMER_DT, function() self:UpdatesamaModifierTimers(sama_MOD_TIMER_DT) end)
        end
    end
end

function Tzsama:RemovesamaModifier_Additive(key)
    self.sama_modifiers_add[key] = nil
    
    if self.sama_modifiers_add_timer[key] then
        self.sama_modifiers_add_timer[key] = nil
    end
end
function Tzsama:GetsamaAdditive()  --加成
    local add_modifiers = 0

    for k,v in pairs(self.sama_modifiers_add) do
        add_modifiers = add_modifiers + v
    end

    return add_modifiers
end
function Tzsama:UpdatesamaModifierTimers(dt)
    
    local function CheckForRemainingTimers()
        for k,v in pairs(self.sama_modifiers_add_timer) do
            if self.sama_modifiers_add_timer[k] and self.sama_modifiers_add_timer[k] > 0 then
                return true
            end
        end
        return false
    end
    for k,v in pairs(self.sama_modifiers_add_timer) do
        self.sama_modifiers_add_timer[k] = self.sama_modifiers_add_timer[k] - dt
        if self.sama_modifiers_add_timer[k] <= 0 then 
            self:RemovesamaModifier_Additive(k)
            if not CheckForRemainingTimers() then
                return
            end
        end
    end
    if not CheckForRemainingTimers() then
        self.updating_mods_task:Cancel()
        self.updating_mods_task = nil
    end
end
function Tzsama:LongUpdate(dt)
    if self.updating_mods_task then
        self:UpdatesamaModifierTimers(dt)
    end
end
function Tzsama:Recalc(dt)
	local equip_delta = self.dapperness
		for k, v in pairs(self.inst.components.inventory.equipslots) do
			if v.components.samaequip ~= nil then
				equip_delta = v.components.samaequip.equipsama
			else
				equip_delta = 0
			end
		end
		equip_delta =equip_delta
    local day_delta 
     if  TheWorld.state.phase == "night" then 
		if TheWorld:HasTag("cave") then
        day_delta = 0
		else
		day_delta = 2
		end
    elseif TheWorld.state.phase == "day" then
		day_delta = -4
	elseif TheWorld.state.phase == "dusk" then
		day_delta = -3
	else
		day_delta = 0
    end 

    if self.inst.components.tz_xx and self.inst.components.tz_xx.dengji > 7 and self.inst.components.inventory:EquipHasTag("tz_fanhao") then
        day_delta = day_delta + 12
	end

	if self.inst.sg and self.inst.sg:HasStateTag("sleeping") then --睡觉+60
		day_delta = day_delta + 60
	end
	if self.inst:HasTag("taizhen_black") then --黑太真+10
		day_delta = day_delta + 10
	end
	if self.inst._bianshen ~= nil and self.inst._bianshen:value() == true then --变身-15
		day_delta = day_delta - 15
	end
	local lost_delta 
	if self.inst.components.petleashlostday ~=nil then
			local num = self.inst.components.petleashlostday.numpets
		if num ==0 then
			lost_delta = 0
		else
			lost_delta = -3*num
		end 
	else
			lost_delta = 0
	end
	self.rate =  day_delta  + lost_delta+ equip_delta + self.addrate + self:GetsamaAdditive()
    self.ratescale =
        (self.rate > 5 and RATE_SCALE.INCREASE_HIGH) or
        (self.rate > 2 and RATE_SCALE.INCREASE_MED) or
        (self.rate > 0 and RATE_SCALE.INCREASE_LOW) or
        (self.rate < -10 and RATE_SCALE.DECREASE_HIGH) or
        (self.rate < -5 and RATE_SCALE.DECREASE_MED) or
        (self.rate < 0 and RATE_SCALE.DECREASE_LOW) or
        RATE_SCALE.NEUTRAL
    self:DoDelta(self.rate /6 * dt * .1, true)
end
function Tzsama:SetAddRate(rate)
    self.addrate = rate
end

Tzsama.LongUpdate = Tzsama.OnUpdate
return Tzsama

