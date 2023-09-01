
local  tz_plant_grower = Class(function(self, inst)
	self.inst = inst
	self.current = 0
	self.max = 100
	self.bad = 0
	self.good = 0
	self.fertilizers = {}
	self.timers = {}
	self.cdtimers = {}
	self.goodtime = 10*60 --好的心情 10分钟掉一点
	self.badtime = 16*60--不好的心情 16分钟掉一点
	self.currenttime = 16*60 --好感度16分钟掉一次
	self.inst:DoTaskInTime(0,function()
		if not self:TimerExists("currenttime") then
			self:StartTimer("currenttime",self.currenttime)
		end
	end)
	inst:AddTag("tz_plant_fertilized")
end)

function tz_plant_grower:SetMax(num)
	self.max = num
end

function tz_plant_grower:AddFertilizer(name,valus,timeinterval,max,addfn)
	self.fertilizers[name] = {valus,timeinterval,max,addfn}
end
function tz_plant_grower:SetItem(time)
	self.goodtime = time
end
function tz_plant_grower:SetBadItem(time)
	self.badtime = time
end

function tz_plant_grower:Fertilize(item,doer,isitem)
	local added = false
	if self.fertilizers[item.prefab] ~= nil then 
		if self.timers[item.prefab] ~= nil then
			if (GetTime() - self.timers[item.prefab].time) >= self.fertilizers[item.prefab][2] then
				self.timers[item.prefab] = {time = GetTime(),count = 1}
				added = true
			elseif self.timers[item.prefab].count  <  self.fertilizers[item.prefab][3] then 
				self.timers[item.prefab].count = self.timers[item.prefab].count + 1
				added = true
			else
			end
		else
			self.timers[item.prefab] = {time = GetTime(),count = 1}
			added = true
		end
		if self.fertilizers[item.prefab][4] ~= nil then
			self.fertilizers[item.prefab][4](self,doer)
		end
		if added then
			self:DoDelta(self.fertilizers[item.prefab][1],doer)
		end
		if isitem then
			if item.components.finiteuses then
				item.components.finiteuses:Use(1)
			elseif item.components.stackable then
				item.components.stackable:Get():Remove()
			else
				item:Remove()
			end
		end
	end
end

local function OnTimerDone(inst, self, name)
    self:StopTimer(name)
	if name == "currenttime" then
		self:DoDelta(-1)
		self:StartTimer("currenttime",self.currenttime)
	elseif name == "goodtime" then
		self:DoEffectDelta("good",-1,"goodtime")
	elseif name == "badtime" then
		self:DoEffectDelta("bad",-1,"badtime")
	end
end

function tz_plant_grower:TimerExists(name)
    return self.cdtimers[name] ~= nil
end

function tz_plant_grower:StartTimer(name, time)
    if self:TimerExists(name) then
        return
    end
    self.cdtimers[name] =
    {
        timer = self.inst:DoTaskInTime(time, OnTimerDone, self, name),
        timeleft = time,
        end_time = GetTime() + time,
    }
end

function tz_plant_grower:StopTimer(name)
    if not self:TimerExists(name) then
        return
    end
    if self.cdtimers[name].timer ~= nil then
        self.cdtimers[name].timer:Cancel()
        self.cdtimers[name].timer = nil
    end
    self.cdtimers[name] = nil
end

function tz_plant_grower:DoEffectDelta(type,delta,name)
    self[type] = math.max(self[type] + delta,0)
	if delta < 0 and self[type] > 0 then
		self:StartTimer(name,self[name])
	end
end

function tz_plant_grower:DoDelta(delta,doer)
    self.current = math.clamp(self.current + delta,0,self.max)
	if doer and doer.components.talker then
		local fx = SpawnPrefab("farm_plant_happy")
		fx.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
		doer.components.talker:Say("她看上去很高兴")
	end
	if self.current >= self.max then
		self.inst:DoGrow()
	end
end

function tz_plant_grower:GetTimeLeft(name)
    if not self:TimerExists(name) then
        return
	end
    return self.cdtimers[name].end_time - GetTime()
end

function tz_plant_grower:OnSave()
	local cdtimers = {}
	local timers = {}
    for k, v in pairs(self.cdtimers) do
        cdtimers[k] =
        {
            timeleft = self:GetTimeLeft(k),
        }
    end
    for k, v in pairs(self.timers) do
		if (GetTime() - v.time) >= (self.fertilizers[k] ~= nil and self.fertilizers[k][2] or 0) then
			self.timers[k] = nil
		else
			timers[k] =
        	{
           		time = v.time,
				count = v.count,
				timeleft = (self.fertilizers[k] ~= nil and self.fertilizers[k][2] or 0) - (GetTime()-v.time)
        	}
		end
    end
	return
	{ 
		timers = timers,
		cdtimers = cdtimers ,
		bad = self.bad ,
		good = self.good ,
		current = self.current,
	}
end

function tz_plant_grower:OnLoad(data)
    if data then
		self.bad = data.bad
		self.good = data.good
		self.current = data.current
		if data.cdtimers then
			for k, v in pairs(data.cdtimers) do
				self:StopTimer(k)
				self:StartTimer(k, v.timeleft)
			end
		end
		if data.timers then
			for k, v in pairs(data.timers) do
				self.timers[k] = {time = v.timeleft - (self.fertilizers[k] ~= nil and self.fertilizers[k][2] or 0) + GetTime(),count = v.count}
			end
		end
    end
end

return tz_plant_grower
