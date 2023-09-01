local MakePlayerCharacter = require "prefabs/player_common"


local assets = {
	Asset( "ANIM", "anim/zan2.zip" ),
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
}
local prefabs = {
	"asa_blade",
	"asa_ring",
	"asa_repair",
	--"asa_shadow_fx",
}

-- 初始物品
local start_inv = {
	"asa_repair",
	"asa_boost",
}

local function KnockOutTest(inst)
	return false
end

local function OnRespawnedFromGhost(inst)
	inst.components.grogginess:SetKnockOutTest(KnockOutTest)
end

local function onsave(inst, data)
    data.asa_blade2 = inst.asa_blade2:value()
end

local BEAVERVISION_COLOURCUBES =
{
    day = "images/colour_cubes/snow_cc.tex",
    dusk = "images/colour_cubes/snow_cc.tex",
    night = "images/colour_cubes/snow_cc.tex",
    full_moon = "images/colour_cubes/snow_cc.tex",
}

local function SetBeaverVision(inst, enable)
    local enable = inst._zanvision:value() ~= 0
	if enable then
        --inst.components.playervision:ForceNightVision(true)
        inst.components.playervision:SetCustomCCTable(BEAVERVISION_COLOURCUBES)
    else
        --inst.components.playervision:ForceNightVision(false)
        inst.components.playervision:SetCustomCCTable(nil)
    end
end

-- 当人物复活的时候
local function onbecamehuman(inst)
	-- 设置人物的移速（1表示1倍于wilson）
	inst.components.locomotor:SetExternalSpeedMultiplier(inst, "asakiri_speed_mod", 1)
	--（也可以用以前的那种
	--inst.components.locomotor.walkspeed = 4
	--inst.components.locomotor.runspeed = 6）
end

local function RemoveBuff(inst)
	inst:PushEvent("asa_recover")
	inst:RemoveTag("NOCLICK")
	if inst.asa_blade2:value() == false then
		inst.AnimState:OverrideSymbol("zan", "asakiri", "zan")
	end
	inst.AnimState:SetAddColour(0,0,0,0)
	inst.maxskill:set(0)
	inst.components.asa_power.boost = 0		--死都死了就别浪了……
	if inst.maxcharge then
		inst.maxcharge:Cancel()
		inst.maxcharge = nil
	end
	if inst.asamaxtask then
		inst.SoundEmitter:KillSound("asa_max_pre")
		inst.asamaxtask = nil
	end
	if inst.tornadotask then
		inst.tornadotask:Cancel()
		inst.tornadotask = nil
	end
	if inst.windtask then
		inst.windtask:Cancel()
		inst.windtask = nil
	end
	if inst.windsound then
		inst.windsound:Cancel()
		inst.windsound = nil
	end
	if inst.tornado then
		inst.tornado:Remove()
	end
	inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "asakiri_tornado")

	ChangeToCharacterPhysics(inst)
	inst.SoundEmitter:KillSound("windsound")
end
--当人物死亡的时候
local function onbecameghost(inst)
	-- 变成鬼魂的时候移除速度修正，并移除大招计时和效果等
	inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "asakiri_speed_mod")
	inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "asakiri_tornado")
	inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "asakiri_bolt")
end


local function ondeath(inst)
	-- 死亡时移除大招计时和效果等
	RemoveBuff(inst)
end

-- 重载游戏或者生成一个玩家的时候
local function onload(inst, data)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    inst:ListenForEvent("ms_becameghost", onbecameghost)
	inst:ListenForEvent("death", ondeath)
	
	if data and data.asa_blade2 ~= nil then
		inst.asa_blade2:set(data.asa_blade2)
		if data.asa_blade2 == true then
			inst.AnimState:OverrideSymbol("zan", "zan2", "zan2") --替换刀光
		end
	end
	inst.components.asa_power.skchange = false	--偷偷同步一下技能点数据
    if inst:HasTag("playerghost") then
        onbecameghost(inst)
    else
        onbecamehuman(inst)
    end
	inst:DoTaskInTime(2,function()
		inst.asa_barshow:set(true)
	end)
end


--这个函数将在服务器和客户端都会执行
--一般用于添加小地图标签等动画文件或者需要主客机都执行的组件（少数）
local common_postinit = function(inst)
	-- Minimap icon
	inst.MiniMapEntity:SetIcon( "asakiri.tex" )
	inst:AddTag("asakiri")
    inst:AddTag("insomniac")
	
	--Net
	inst.asa_pwlimit = net_int(inst.GUID,"AsaPwLimit","AsaPwLimit")
	inst.asa_pw = net_int(inst.GUID,"AsaPw","AsaPw")
	inst.asa_maxpw = net_int(inst.GUID,"AsaMaxPw","AsaMaxPw")
	inst.asa_maxcd = net_int(inst.GUID,"MaxAsaCD","MaxAsaCD")
	inst.asa_cd = net_int(inst.GUID,"AsaCD","AsaCD")
	inst._zanvision = net_tinybyte(inst.GUID, "AsaZanvision", "asa_zanning")	--蓝斩视野
	inst.maxskill = net_tinybyte(inst.GUID, "MaxSkill", "MaxSkill")		--大招类型
	inst.poweruse = net_bool(inst.GUID, "AsaUse", "AsaUse")	--反复横跳，触发判定范围提示
	inst.asaparry = net_bool(inst.GUID, "InParry", "InParry")	--格挡状态
	inst.asa_skills = net_string(inst.GUID,"AsaSkills","AsaSkills") --技能列表
	inst.asa_skp = net_int(inst.GUID,"AsaSkP","AsaSkP") --当前技能点数
	inst.asa_invincible = net_bool(inst.GUID, "AsaInv", "AsaInv")	--无敌状态
	inst.asa_blade2 = net_bool(inst.GUID, "AsaBlade2", "AsaBlade2")	--升级红刀
	inst.asa_barshow = net_bool(inst.GUID, "AsaBar", "AsaBar")	--显示界面
	-- --打印一下技能表
	-- inst:ListenForEvent("AsaSkills", function()
		-- print(inst.asa_skills)
	-- end)
	
	inst:ListenForEvent("asa_zanning", SetBeaverVision)
	
	inst.ring2 = SpawnPrefab("asa_ring")
	inst.ring2.entity:SetParent(inst.entity)
	inst.ring2:Hide()
	
	inst.ring1 = SpawnPrefab("asa_ring")
	inst.ring1.entity:SetParent(inst.entity)
	local s = 6.3
	inst.ring1.AnimState:SetScale(s,s,s)
	inst.ring1.AnimState:PlayAnimation("idle_parry")
	inst.ring1:Hide()
	
--[[	 inst:ListenForEvent("asa_zanning",function()
		 if inst._zanvision:value() then
			 PostProcessor:SetLunacyIntensity(20) --月岛模糊，好像高了没用
			 PostProcessor:SetZoomBlurEnabled(true) --模糊本体
			 PostProcessor:SetOverlayBlend(1) --总特效强度
			 PostProcessor:SetColourCubeLerp(1, 0) --San滤镜（1是类型，强度为0）
			 PostProcessor:SetColourCubeLerp(2, 0) --月岛滤镜（2是类型，强度为0）
			 --distortion是旋转幻影，不明为何是反色，不建议加
		 end
		
		 -- if inst.sg:HasStateTag("idle") or inst.sg:HasStateTag("dash") then
			 -- inst:DoTaskInTime(0.3,function()
				 -- inst:PushEvent("asa_recover")
			 -- end)
		 -- else
			 -- inst:DoTaskInTime(1.2,function()
				 -- inst:PushEvent("asa_recover")
			 -- end)
		 -- end
		 inst:DoTaskInTime(0.8,function()
			 inst:PushEvent("asa_recover")
		 end)
	 end)]]
	--暂时禁用范围圆环
	inst:ListenForEvent("AsaUse",function()
	end)
	
	inst:ListenForEvent("asa_powerdown",function()
		inst.maxskill:set(0)
		inst.asaparry:set(false)
	end)
	
end

-- 这里的的函数只在主机执行  一般组件之类的都写在这里
local master_postinit = function(inst)
	-- 人物音效
	inst.talker_path_override = "asakiri/"
	inst.soundsname = "asakiri"
	
	-- 三维	
-- 	inst.components.health:SetMaxHealth(175)    修改血量值
	inst.components.health:SetMaxHealth(375)
	inst.components.hunger:SetMax(120)
	inst.components.sanity:SetMax(150)
	
	-- 食物减成
	inst.components.eater:SetAbsorptionModifiers(0.5, 0.6, 0.5)
	
	-- 伤害系数
--     inst.components.combat.damagemultiplier = 1  修改伤害系数
    inst.components.combat.damagemultiplier = 1.5

	-- 饥饿速度
	inst.components.hunger.hungerrate = 1 * TUNING.WILSON_HUNGER_RATE
	
	inst:AddComponent("asa_equip")
	inst:AddComponent("asa_power")
	inst:AddComponent("asa_exp")
	
	inst:ListenForEvent("MaxSkill",function()
		if inst.maxskill:value() == 0 then
			RemoveBuff(inst)
		end
	end)

	inst:ListenForEvent("unequip",function(inst, data)
		if data.item ~= nil and data.item:HasTag("asa_blade") then
			inst.customidleanim = nil
		end
	end)

	inst:ListenForEvent("ms_respawnedfromghost", OnRespawnedFromGhost)
	OnRespawnedFromGhost(inst)

	--简易防猴
	inst:ListenForEvent("itemget", function(inst, data)
		if data.item and data.item:IsValid() and data.item.components.curseditem then
			inst:DoTaskInTime(0.1, function()
				inst.components.cursable:RemoveCurse("MONKEY", 10)
			end)
		end
	end)
	
	inst.OnLoad = onload
	inst.OnSave = onsave
    inst.OnNewSpawn = onload
	
end

return MakePlayerCharacter("asakiri", prefabs, assets, common_postinit, master_postinit, start_inv)
