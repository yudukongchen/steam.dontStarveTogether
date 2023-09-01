local SourceModifierList = require("util/sourcemodifierlist")

local function onsetnet(self,num) 
	if self.inst.tz_xx ~= nil then
		local dengji = self.dengji or 0 
		local jieduan = self.jieduan or 1
		local ba = self.ba or 0
		local sh =  self.sh or 0
		local hd =  self.hd or 0
		local kz = self.kz or 0
		local jd_1 = self.jd_1 or 0
		local jd_2 = self.jd_2 or 0
		local jd_3 = self.jd_3 or 0
		local jd_4 = self.jd_4 or 0
		self.inst.tz_xx:set({dengji,jieduan,ba,sh,hd,kz,jd_1,jd_2,jd_3,jd_4})
	end
end

local function onkill(inst,data)
	if data and data.victim then
		if data.victim.components.health ~= nil then
			local health = data.victim.components.health.maxhealth
			local x,y,z = data.victim.Transform:GetWorldPosition()
			if health >= 500 then
				local sizi = "small"
				if health >= 3000 then
					sizi = "big"
				elseif health >= 1000 then
					sizi = "nolmal"
				end
				inst:DoTaskInTime(2,function()
					local pet = SpawnPrefab("tz_ling_"..sizi)
					if pet then
						pet.Transform:SetPosition(x,0,z)
						pet.components.timer:StartTimer("gotodie", 240)
					end
				end)
			end
		end
	end
end

local function ondengji(self,dengji) --影响奖励和事件
	if self.oldlevel and TUNING.TZXX[self.oldlevel] then
		TUNING.TZXX[self.oldlevel].RemoveEventCallback(self.inst) --移除旧的事件
	end
	
	if TUNING.TZXX[dengji] ~= nil then
		TUNING.TZXX[dengji].RemoveEventCallback(self.inst) --移除旧的事件
		TUNING.TZXX[dengji].ListenForEvent(self.inst) --触发新的事件
	end
	self.oldlevel = dengji
	onsetnet(self)
	self.inst.tz_xx_level:set(dengji)
	if dengji > 9 then 
		self.inst:AddTag("tz_fanhao_rider")
		self.inst:ListenForEvent("killed", onkill)
	elseif dengji > 5 then 
		self.inst:AddTag("tz_fanhao_rider")
	end
end

local function onba(self,ba)
	local inst = self.inst
	if ba ~= 0 then
		if inst.components.health then
			inst.components.health.externalabsorbmodifiers:SetModifier("tzxx", 0.005*ba) --减伤+0.5%
		end
		if inst.components.eater then
			inst.components.eater:SetAbsorptionModifiers(1+0.01*ba, 1+0.01*ba, 1+0.01*ba) --食用食物回复效率+1%
		end
		if inst.components.hunger then
			local hunger_percent = inst.components.hunger:GetPercent() --饥饿度上限+2  ba 
			inst.components.hunger.max = math.ceil(150 + ba*2)
			inst.components.hunger:SetPercent(hunger_percent)
		end		
		onsetnet(self)
	end
end

local function onsh(self,sh)
	local inst = self.inst
	if sh ~= 0 then
		if inst.components.tzsama then
			inst.components.tzsama.addrate = sh --撒麻值回复+1/min 
		end
		self.shanbi = 0.005 * sh --对攻击闪避几率+0.5%
		if inst.components.health then
			local health_percent = inst.components.health:GetPercent() --生命值上限+1
			inst.components.health.maxhealth = math.ceil(75 + sh)
			inst.components.health:SetPercent(health_percent)
		end		
		onsetnet(self)
	end
end

local function onhd(self,hd)
	local inst = self.inst
	if hd ~= 0 then
		self.xixue = 0.001 * hd --吸血
		if inst.components.sanity then
			local sanity_percent = inst.components.sanity:GetPercent() --脑力值上限+1
			inst.components.sanity.max = math.ceil(200 + hd)
			inst.components.sanity:SetPercent(sanity_percent)
		end
		onsetnet(self)
	end
end

local function onkz(self,kz)
	local inst = self.inst
	if kz ~= 0 then
		self.xisanity = 0.001 * kz --吸精神
		if inst.components.combat then
			inst.components.combat.externaldamagemultipliers:SetModifier("tzxx", 1 + kz*0.02)
		end
		onsetnet(self)
	end
end

local function onadddamageforlevel1(self,adddamageforlevel1)
	if adddamageforlevel1 then
		if self.inst.components.combat then
			self.inst.components.combat.externaldamagemultipliers:SetModifier("tzxx_level1", 1.1)
		end
	end
end

local function ontrigger(self,trigger)
	if trigger then
		if self.inst.components.carefulwalker then
			self.inst.components.carefulwalker:SetCarefulWalkingSpeedMultiplier(1)
		end
		self.inst:AddTag("tzxx_nospeedlow")
	end
end

local function oncanreadbook(self,canreadbook)
	if canreadbook then
		if not self.inst.components.reader then
			self.inst:AddComponent("reader")
		end
	end
end

local function onxiuxian(self,xiuxian)
	if self.inst.isxiuxian then
		self.inst.isxiuxian:set(xiuxian)
	end
end
--ThePlayer.components.locomotor.triggerscreep = false
--ThePlayer.components.tz_xx:DoDeltaLevel()

local  leveup =  {
	--[1] = function(player,self)
	--	if player.components.tzsama then
	--		player.components.tzsama:SetAdd(25) --一阶段 +25sama
	--	end
	--end,

	[2] = function(player,self)
		if player.components.tzsama then
			player.components.tzsama:SetAdd(75) --二阶段开启奖励 +75sama
		end
		self.adddamageforlevel1 = true--一阶段完成奖励 +10%攻击系数
	end,
	[3] = function(player,self)
		if player.components.tzsama then
			player.components.tzsama:SetAdd(125) --三阶段开启奖励 +75sama
		end
		self.trigger = true--二阶段完成奖励 +蛛网地形、塌陷地形、粘液地形减速无效
	end,	
	[4] = function(player,self)
		if player.components.tzsama then
			player.components.tzsama:SetAdd(175) --四阶段开启奖励 +175sama
		end
		self.nightbuff = 0.2 --食用噩梦燃料回复效率+20%
		--三阶段完成奖励 获取boss位置 待写！！
	end,
	
	[5] = function(player,self)
		if player.components.tzsama then
			player.components.tzsama:SetAdd(225) --五阶段开启奖励 +225sama
		end
		self.nightbuff = 0.4 --食用噩梦燃料回复效率+40%
		self.addshanbi = 0.15--四阶段完成奖励对攻击闪避几率+15%
	end,
	
	[6] = function(player,self)
		if player.components.tzsama then
			player.components.tzsama:SetAdd(275) --六阶段开启奖励 +275sama
		end
		self.nightbuff = 0.6 --食用噩梦燃料回复效率+60%
		self.canreadbook = true --五阶段完成奖励 获得所有书籍使用权
	end,
	
	[7] = function(player,self)
		if player.components.tzsama then
			player.components.tzsama:SetAdd(325) --七阶段开启奖励 +325sama
		end
		self.nightbuff = 0.8 --食用噩梦燃料回复效率+80%
		if player.components.petleashlostday then
			player.components.petleashlostday:SetAdd(1) --影人数量+1
		end							 
	end,
	
	[8] = function(player,self)
		if player.components.tzsama then
			player.components.tzsama:SetAdd(375) --8阶段开启奖励 +325sama
		end
		self.nightbuff = 1 --食用噩梦燃料回复效率+100%
		if player.components.petleashlostday then
			player.components.petleashlostday:SetAdd(2) --影人数量+1
		end							 
		--self.canreadbook = true -- 7 阶段完成奖励 佩戴番号时，获得伤害倍率+25%、撒麻值+12/min
	end,
	
	[9] = function(player,self)
		if player.components.tzsama then
			player.components.tzsama:SetAdd(425)
		end
		self.nightbuff = 1.2
		if player.components.petleashlostday then
			player.components.petleashlostday:SetAdd(3)
		end							 
	end,
	[10] = function(player,self)
		if player.components.talker then
			player.components.talker:Say("已经掌握灵狐的所有奥义")
		end
		--解锁最终的技能!!!!!
	end,
}

local  Tz_XX = Class(function(self, inst)
	self.inst = inst
	
	self.xiuxian = false
	
	self.dengji = 1 --等级
	
	self.jieduan = 1 --从1阶段开始
	
	self.shanbi = 0 --闪避
	self.xixue = 0 -- 吸血
	self.xisanity = 0 --吸精神
	
	self.ba = 0 --四个属性
	self.sh = 0
	self.kz = 0
	self.hd = 0
	self.jd_1 = 0 --任务进度
	self.jd_2 = 0
	self.jd_3 = 0
	self.jd_4 = 0
	
	self.adddamageforlevel1 = false --一阶段升级攻击奖励
	self.trigger = false
	self.nightbuff = 0
	self.addshanbi = 0
	self.canreadbook = false
	self.shanbitask = {}

	self.externalshanbimodifiers = SourceModifierList(inst, 0, SourceModifierList.additive)
	
	if inst.components.combat ~= nil then --闪避的接口
		local old_GetAttacked = inst.components.combat.GetAttacked
		inst.components.combat.GetAttacked = function(self2,...)
			--if not self.shanbicd then
			local shanbi = self:GetShanBi()
			if shanbi ~= 0 and math.random() < shanbi then
				local fx = SpawnPrefab("tz_shanbi_fx")
				if fx then 
					fx.Transform:SetPosition(self2.inst.Transform:GetWorldPosition())
					fx:SetOwner(self2.inst)	
				end
				--self.shanbicd = true
				--self2.inst:DoTaskInTime(0.5, function() self.shanbicd = false end)
				return false
			end
			--end
			return old_GetAttacked(self2,...)
		end
	end
	inst:ListenForEvent("onhitother", function(owner,data)
		if data and data.damageresolved and data.damageresolved > 0 then
			if self.xixue ~= 0 and owner.components.health and not owner.components.health:IsDead() then
				owner.components.health:DoDelta(self.xixue *data.damageresolved)
			end
			if self.xisanity ~= 0 and owner.components.sanity then
				owner.components.sanity:DoDelta(self.xisanity *data.damageresolved)
			end
		end
	end)
end,
nil,
{
	xiuxian = onxiuxian,
	dengji = ondengji,
	jieduan = onsetnet,
	ba = onba,
	sh = onsh,
	hd = onhd,
	kz = onkz,
	jd_1 = onsetnet,
	jd_2 = onsetnet,
	jd_3 = onsetnet,
	jd_4 = onsetnet,
	adddamageforlevel1 = onadddamageforlevel1,
	trigger  = ontrigger ,	
	canreadbook  = oncanreadbook ,
})

function Tz_XX:GetShanBi()
	return self.shanbi + self.addshanbi + self.externalshanbimodifiers:Get()
end

local function done(inst, self,name)
	self.shanbitask[name] = nil
	self.externalshanbimodifiers:RemoveModifier(name)
end

function Tz_XX:AddShanbi(name,value,time)
	self.externalshanbimodifiers:SetModifier(name, value)
	if time then
		if self.shanbitask[name] then
			self.shanbitask[name]:Cancel()
		end
		self.shanbitask[name] = self.inst:DoTaskInTime(time, done, self,name)
	end
end

function Tz_XX:StartXiuXian(item)
	self.xiuxian = not self.xiuxian
	if self.inst.components.talker then
		self.inst.components.talker:Say(self.xiuxian and "太真身体里的暗影能力已经被唤醒" or "太真身体里的暗影能力已陷入沉睡" )
		if not self.isgiveping_candy and self.xiuxian and self.inst.components.inventory then
			self.isgiveping_candy = true
			self.inst.components.inventory:GiveItem(SpawnPrefab("tz_ping_candy"), nil, self.inst:GetPosition())
		end
	end
	return true
end

function Tz_XX:DoDeltaJd(num,leibie,cishu) --进度改变
	if not self.xiuxian then return end
	if self["jd_"..num] ~= nil then
		self["jd_"..num] = self["jd_"..num] + (cishu or 1)
		local renwu = self.jieduan > 9 and TUNING.TZXX[self.dengji].task2 or TUNING.TZXX[self.dengji].task1	
		local needmax = self.jieduan > 9 and renwu[tonumber(num)].num or (9 + (self.jieduan-1)*10)
		if self["jd_"..num] >= needmax then
			self:DoDeltaJieDuan(leibie)
		end
	end
end
--ThePlayer.components.tz_xx:DoDeltaJieDuan("ba")
--ThePlayer.components.tz_xx:DoDeltaLevel()
function Tz_XX:DoDeltaJieDuan(leibie) --任务完成 阶段改变
	self[leibie] = self[leibie] + ( self.jieduan > 9 and 5 or 1)
	if self.jieduan > 9 then  --阶段满了 升等级
		self.jieduan = 1 --重置阶段
		--升级!!
		self:DoDeltaLevel()
		self.inst.SoundEmitter:PlaySound("dontstarve/HUD/get_gold")
		if self.inst.components.talker then
			self.inst.components.talker:Say("太真又变强了！嗷呜！")
		end
	else--阶段没满 升阶段
		self.jieduan = self.jieduan + 1
		self.inst.SoundEmitter:PlaySound("dontstarve/HUD/get_gold")
		if self.inst.components.talker then
			self.inst.components.talker:Say("主人，太真完成了一个修炼内容哦")
		end
	end
	self.jd_1 = 0 --清空进度
	self.jd_2 = 0
	self.jd_3 = 0
	self.jd_4 = 0
end

function Tz_XX:DoDeltaLevel() --等级任务完成
	if self.dengji > 9 then return end
	self.dengji = self.dengji + 1
	--每突破一个大阶段，四项属性额外+5
	self.ba = self.ba + 5
	self.sh = self.sh + 5
	self.hd = self.hd + 5
	self.kz = self.kz + 5
	if leveup[self.dengji] ~= nil then
		leveup[self.dengji](self.inst,self)
	end
end

function Tz_XX:OnSave()
	return {
		dengji = self.dengji,
		jieduan = self.jieduan,
		ba = self.ba,
		sh = self.sh,
		hd = self.hd,
		kz = self.kz,
		jd_1 = self.jd_1,
		jd_2 = self.jd_2,
		jd_3 = self.jd_3,
		jd_4 = self.jd_4,	
		adddamageforlevel1 = self.adddamageforlevel1,
		xiuxian = self.xiuxian,
		trigger = self.trigger,
		nightbuff = self.nightbuff,
		addshanbi = self.addshanbi,
		canreadbook = self.canreadbook,
		isgiveping_candy = self.isgiveping_candy,
	}
end

function Tz_XX:OnLoad(data)
	if data then
		self.xiuxian = data.xiuxian or false
		self.dengji = data.dengji or 0
		self.jieduan = data.jieduan or 1
		self.ba = data.ba or 0
		self.sh = data.sh or 0
		self.hd = data.hd or 0
		self.kz = data.kz or 0
		self.jd_1 = data.jd_1 or 0
		self.jd_2 = data.jd_2 or 0
		self.jd_3 = data.jd_3 or 0
		self.jd_4 = data.jd_4 or 0	
		self.adddamageforlevel1 = data.adddamageforlevel1 or false
		self.trigger = data.trigger or false
		self.nightbuff = data.nightbuff or 0
		self.addshanbi = data.addshanbi or 0
		self.canreadbook = data.canreadbook or false
		self.isgiveping_candy = data.isgiveping_candy or false
	end
end

function Tz_XX:DoneInfoLoad()
	if self.dengji ~= 1 then
		for k = 2 ,self.dengji do
			if leveup[k] ~= nil then
				leveup[k](self.inst,self)
			end
		end
	end
end

return Tz_XX
