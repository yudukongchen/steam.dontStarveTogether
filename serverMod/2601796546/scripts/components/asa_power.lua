
local function onmaxpw(self)
	self.inst.asa_maxpw:set(self.maxpw)
end

local function onmaxcd(self)
	self.inst.asa_maxcd:set(self.maxcd)
end

local function oncd(self)
	self.inst.asa_cd:set(self.cd)
end

local function onpwlimit(self)
	self.inst.asa_pwlimit:set(self.pwlimit)
end

local function onpw(self)
	self.inst.replica.pw = self.pw
	self.inst.asa_pw:set(self.pw)
end

local function onsks(self)
	--表转json字符串
	local val1,val2 = pcall(json.encode, self.sks)
	self.inst.asa_skills:set(val2)
end

local function onskp(self)
	self.inst.asa_skp:set(self.skp)
end

local Asa_Power = Class(function(self, inst)
    self.inst = inst
	
	self.chargeperiod = 0.6 --回复周期
	self.rate = 1			--每周期回复
	self.minpw = 0			--能量值下限
	self.maxpw = 0		--能量值上限
	self.maxpw = 10		--能量值上限
--  修改能量值升级上限
--upd 	self.pwlimit = 10		--能量值升级上限
	self.pwlimit = 20		--能量值升级上限
	self.pw = self.maxpw	--能量值初始化
	self.cd = 0		--回复冷却
	self.maxcd = 30 * 8		--常规冷却上限
	self.cdover = 30 * 10	--过载CD惩罚的基数
--  修改冷却恢复速度
--upd 	self.cdrate = 1		--CD减少倍数
	self.cdrate = 2		--CD减少倍数
	self.boost = 0  --充能剩余时间
	self.oldmax = 0		--升级用
	
	--技能开关
	self.sks = {0,0,0, 0,0,0, 0,0,0, 0,0,0, 0}
	self.skchange = nil		--技能变更
	self.skp = 0
	
	--更新
	inst:DoPeriodicTask(self.chargeperiod, function()
		if not inst:HasTag("playerghost") and (self.cd <= 0 or not (inst:HasTag("asa_equipped") or self.cd > self.maxcd)) and self.inst.maxskill:value() == 0
				and not inst:HasTag("asa_bolt")
		then --无刀直接加，除非开大
			self:DoDelta(self.rate)	--刷新
			
		end
		if self.boost > 0 then
			self:DoDelta(self.maxpw)
		end
	end)
	
	inst:DoPeriodicTask(0.033, function()
		if not inst:HasTag("playerghost") and self.cd > 0 then
			self.cd = self.cd - self.cdrate	--刷新cd
		end
	end)
	
	inst:DoPeriodicTask(1, function()
		if not inst:HasTag("playerghost") then
			if self.boost > 0 then
				self.boost = self.boost - 1
			end
			if self.inst.maxskill:value() ~= 0 then --开大锁定扣除
				self:DoDelta(-1)
			end
		end
	end)
	
	--升级监听
	inst:DoPeriodicTask(0.2, function()
		if self.maxpw > self.oldmax then
			self.inst:DoTaskInTime(2,function()	--延迟更新技能点以防不测
				local sks1 = self.sks
				local usedpt = 0
				for i,v in ipairs(sks1) do --分情况计算消耗量
					if v == 1 then
						if i == 3 or i == 6 or i == 9 then
							usedpt = usedpt + 3
						elseif i == 2 or i == 5 or i == 8 then
							usedpt = usedpt + 2
						else
							usedpt = usedpt + 1
						end
					end
				end
				self.inst.asa_skp:set(self.inst.asa_maxpw:value() - usedpt) --更新技能点
			end)
			self.oldmax = self.maxpw	--更新级别
			self.inst.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/upgrade1")	--产生特效音效
			self.inst.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/upgrade2")
			self.inst.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/upgrade2")
			local fx = SpawnPrefab("asa_upgrade_fx").Transform:SetPosition(self.inst.Transform:GetWorldPosition())
		end
	end)
	
	--监听开大结束，CD惩罚
	inst:ListenForEvent("MaxSkill",function()
		if inst.maxskill:value() == 0 then
-- 			修改CD惩罚计算
-- 			self.cd = self.cdover + self.maxpw * 30		--能力越强，代价越大，从11到20秒
			self.cd = self.cdover
		end
	end)
	
end,
nil,
{
    pwlimit = onpwlimit,
	pw = onpw,
	maxcd = onmaxcd,
	cd = oncd,
	maxpw = onmaxpw,
	sks = onsks,
	skchange = onsks,
	skp = onskp
})

--获取能量值
function Asa_Power:Get()
	return self.pw or 0
end
--设定能量值
function Asa_Power:Set(amount)
	self.pw = amount
end
--设定最大能量值
function Asa_Power:SetMax(amount)
--  修改最大能量值(+10)
-- 	self.maxpw = amount < self.pwlimit and amount or self.pwlimit
	local updpw = amount < self.pwlimit and amount or self.pwlimit
	self.maxpw = updpw + 10
end

--升级
function Asa_Power:MaxDelta(amount)
	self:SetMax(self.maxpw + 1)
end

--能量值变更操作
function Asa_Power:SetVal(val)
	self.pw = math.clamp(val, self.minpw, self.maxpw)	--防止值双向溢出
	if self.pw == 0 then
		self.inst:PushEvent("asa_powerdown") --这个事件会触发大招关闭
		if self.inst.powertask then	--我服了，在这设置格挡周期消耗取消总行吧
			self.inst.powertask:Cancel()
			self.inst.powertask = nil
		end
		if self.inst.bolttask then
			self.inst.bolttask:Cancel()
			self.inst.bolttask = nil
			self.inst.components.locomotor:RemoveExternalSpeedMultiplier(self.inst, "asakiri_bolt")
		end
		if self.inst.boltfx then
			self.inst.boltfx:Cancel()
			self.inst.boltfx = nil
		end
		self.inst:RemoveTag("asa_bolt")
		if self.inst.AnimState:IsCurrentAnimation("parry_loop") or self.inst.AnimState:IsCurrentAnimation("parry_block") then	----啊啊啊啊啊啊啊！
			self.inst:DoTaskInTime(0.3,function()
				self.inst.sg:GoToState("asa_parry_pst")
			end)
		end
		if not self.maxpw == 0 then --奇怪的没电噪音
			self.inst.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/discharge")
		end
	end
end
--变更能量值
function Asa_Power:DoDelta(amount)
	if self.boost <= 0 then
		if amount < 0 then
			self.cd = self.maxcd
			if self.inst.poweruse:value() == true then
			    self.inst.poweruse:set(false)
			else
			    self.inst.poweruse:set(true)
			end
		end
	end
	
	if not (self.boost > 0 and amount < 0) then
		self:SetVal(self.pw + amount)
	end
end
--获取能量值百分比
function Asa_Power:GetPercent()
    return self.pw / self.pwlimit
end
--设定能量值百分比
function Asa_Power:SetPercent(percent)
    self:SetVal(self.pwlimit * percent)
end
--变更每秒回复
function Asa_Power:ChangeRate(amount)
	self.rate = self.rate + amount
end

--没电了
function Asa_Power:IsZero()
    return self.pw == 0 
end

--设定技能开关
function Asa_Power:SetSkill(slot, val)
	self.sks[slot] = val
	self.skchange = false	--落尘牛逼，这个触发更新同步！
end
--获取技能
function Asa_Power:GetSkill(slot)
	return self.sks[slot]
end

--获取技能点数
function Asa_Power:GetSkillPoint()
	local sks1 = self.inst.asa_skills:value()
	sks1 = json.decode(sks1)
	local usedpt = 0
	for i,v in ipairs(sks1) do --分情况计算消耗量
		if v == 1 then
			if i == 3 or i == 6 or i == 9 then
				usedpt = usedpt + 3
			elseif i == 2 or i == 5 or i == 8 then
				usedpt = usedpt + 2
			else
				usedpt = usedpt + 1
			end
		end
	end
	return (self.maxpw - usedpt) --更新技能点
end

--保存
function Asa_Power:OnSave()
	return {
		-- pwlimit = self.pwlimit,
		boost = self.boost,
		pw = self.pw,
		maxpw = self.maxpw,
		sks = self.sks,
		skp = self:GetSkillPoint(),
		oldmax = self.oldmax --不加会导致从0变1，额外获得点数
	}
end
--加载
function Asa_Power:OnLoad(data)
	if data then
		-- self.pwlimit = data.pwlimit or 10
		self.boost = data.boost or 0
        self.maxpw = data.maxpw or 0
		self.pw = data.pw or self.maxpw
		self.cd = 0
		self.sks = data.sks
		self.skp = data.skp
		self.oldmax = data.oldmax
    end
end

return Asa_Power