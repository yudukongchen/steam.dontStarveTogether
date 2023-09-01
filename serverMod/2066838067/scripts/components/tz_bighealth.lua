
local function sethealth(owner,num)
    local health = num
    owner.components.health:SetTzMaxHealth(health)
    local p = owner.components.health:GetPercent()
    owner.components.health.maxhealth  = owner.components.health.basemaxhealth
    owner.components.health:SetPercent(p)
end

local function onrate(self,rate)
	if rate ~= 0 then
		if self.combat then
			self.combat.externaldamagemultipliers:SetModifier("tz_bighealth", 1 + rate * 0.25)
		end	
		if self.hunger then
			self.hunger.burnratemodifiers:SetModifier("tz_bighealth", math.min(10,1+rate * 0.1))
		end
		self.inst:ApplyScale("tz_bighealth", 1 + rate * 0.1)
	else
		if self.combat then
			self.combat.externaldamagemultipliers:RemoveModifier("tz_bighealth")
		end
		if self.hunger then
			self.hunger.burnratemodifiers:RemoveModifier("tz_bighealth")
		end	
		self.inst:ApplyScale("tz_bighealth", 1)
	end
	--if self.health then
	--	sethealth(self.inst,rate*50)
	--end
end

local  Tz_Bighealth = Class(function(self, inst)
	self.inst = inst
	self.hunger = inst.components.hunger or nil
	self.health = inst.components.health or nil
	self.combat = inst.components.combat or nil
	self.rate = 0
	self.time = 16*60
    self.targettime = nil
    self.task = nil
	
	inst:ListenForEvent("death", function(inst)
		if self.rate ~= 0 then
			self:RemoveBuff()
		end
	end)
end,
nil,
{
	rate = onrate,
})

local function done(inst, self)
	self:RemoveBuff()
end

function Tz_Bighealth:AddBuff()
	self.rate = math.min(self.rate + 1,10)
    self.targettime = GetTime() + self.time
    if self.task ~= nil then
        self.task:Cancel()
    end
    self.task = self.inst:DoTaskInTime(self.time, done, self)
	if self.inst.apingbighealthtime ~= nil then
		self.inst.apingbighealthtime:set_local(0)
		self.inst.apingbighealthtime:set(self.time)
	end
	if not self.inst.components.health:IsDead() then
		self.inst.sg:PushEvent("powerup")
	end
end

function Tz_Bighealth:RemoveBuff()
    self.task = nil
    self.targettime = nil
	self.rate = 0
	if self.inst.apingbighealthtime ~= nil then
		self.inst.apingbighealthtime:set(0)
	end
	if not self.inst.components.health:IsDead() then
		self.inst.sg:PushEvent("powerdown")
	end
end

function Tz_Bighealth:OnSave()
    local remainingtime = self.targettime ~= nil and self.targettime - GetTime() or 0
    return
    {
        rate = self.rate,
        remainingtime = remainingtime > 0 and remainingtime or nil,
    }
end

function Tz_Bighealth:OnLoad(data)
    if data.rate ~= nil then
		self.rate = data.rate
	end

    if self.task ~= nil then
        self.task:Cancel()
        self.task = nil
    end
    self.targettime = nil

    if data.remainingtime ~= nil then
        self.targettime = GetTime() + math.max(0, data.remainingtime)
		self.task = self.inst:DoTaskInTime(data.remainingtime, done, self)
		if self.inst.apingbighealthtime ~= nil then
			self.inst.apingbighealthtime:set_local(0)
			self.inst.apingbighealthtime:set(data.remainingtime)
		end
	end
end

function Tz_Bighealth:LongUpdate(dt)

    if self.task ~= nil and self.targettime ~= nil then
        self.task:Cancel()
        if self.targettime - dt > GetTime() then
            self.targettime = self.targettime - dt
			local needtime = self.targettime - GetTime()
            self.task = self.inst:DoTaskInTime(needtime, done, self)
			if self.inst.apingbighealthtime ~= nil then
				self.inst.apingbighealthtime:set_local(0)
				self.inst.apingbighealthtime:set(needtime)
			end
        else
            done(self.inst,self)
        end
    end
end

return Tz_Bighealth
