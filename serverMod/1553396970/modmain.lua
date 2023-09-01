PrefabFiles = {

	"skyshow",
}

Assets = {
	Asset( "ATLAS", "images/skyshow.xml" ),
	Asset("IMAGE", "images/skyshow.tex"), 
	Asset("ANIM", "anim/skyshow.zip"),
	Asset("ANIM", "anim/swap_skyshow.zip"),
}

local RECIPETABS = GLOBAL.RECIPETABS
local Recipe = GLOBAL.Recipe
local Ingredient = GLOBAL.Ingredient
local TECH = GLOBAL.TECH
local TheWorld = GLOBAL.TheWorld
local ACTIONS=GLOBAL.ACTIONS
local FUELTYPE=GLOBAL.FUELTYPE
local SpawnPrefab=GLOBAL.SpawnPrefab
local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
local Vector3 = GLOBAL.Vector3

local SKYSHOW = {}
SKYSHOW.LAN = GetModConfigData("lan")
SKYSHOW.CRAFT = GetModConfigData("craft")
SKYSHOW.AXE = GetModConfigData("axe")
SKYSHOW.DRAFT = GetModConfigData("draft")
SKYSHOW.DAMAGE = GetModConfigData("damage")
SKYSHOW.WALKSPEED = GetModConfigData("walkspeed")
SKYSHOW.UPGRADE = GetModConfigData("upgrade")
SKYSHOW.WARM = GetModConfigData("warm")
SKYSHOW.HEALTH = GetModConfigData("health")
SKYSHOW.SANITY = GetModConfigData("sanity")
SKYSHOW.NET = GetModConfigData("net")
SKYSHOW.FREEZABLE = GetModConfigData("freezable")
SKYSHOW.WATERPROOFER = GetModConfigData("waterproofer")
SKYSHOW.RANGE = GetModConfigData("range")
SKYSHOW.DIG = GetModConfigData("dig")
SKYSHOW.HAMMER = GetModConfigData("hammer")
SKYSHOW.MAGIC = GetModConfigData("magic")
SKYSHOW.BURN = GetModConfigData("burn")
SKYSHOW.BINGHUOTX = GetModConfigData("binghuotx")
SKYSHOW.XUANFENGTX = GetModConfigData("xuanfengtx")
SKYSHOW.LIUXINGTX = GetModConfigData("liuxingtx")
SKYSHOW.SHACITX = GetModConfigData("shacitx")
SKYSHOW.MOGUTX = GetModConfigData("mogutx")
SKYSHOW.BACK = GetModConfigData("back")
SKYSHOW.UPGRADEDAMAGE = GetModConfigData("upgradedamage")
--SKYSHOW.HUJIA = GetModConfigData("hujia")
SKYSHOW.BAOJILV = GetModConfigData("baojilv")
SKYSHOW.REPAIR = GetModConfigData("repair")
SKYSHOW.AOE = GetModConfigData("aoe")
SKYSHOW.AOERANGE = GetModConfigData("aoerange")
SKYSHOW.AOEDAMAGE = GetModConfigData("aoedamage")
SKYSHOW.SHENGJI = GetModConfigData("shengji")
SKYSHOW.FULL = GetModConfigData("full")

USE = GetModConfigData("use")
--FANGYU = GetModConfigData("fangyu")
BAOJI = GetModConfigData("baoji")

--GLOBAL.FANGYU = GetModConfigData("fangyu")
GLOBAL.BAOJI = GetModConfigData("baoji")
GLOBAL.DIAOYU = GetModConfigData("diaoyu")
GLOBAL.USE = GetModConfigData("use")
GLOBAL.HUISAN = GetModConfigData("huisan")
GLOBAL.TIDENG = GetModConfigData("tideng")
GLOBAL.FUHUO = GetModConfigData("fuhuo")
GLOBAL.ZHANGZHANG = GetModConfigData("zhangzhang")
GLOBAL.TEMPERATURE = GetModConfigData("temperature")
GLOBAL.HUJIA = GetModConfigData("hujia")
--GLOBAL.BAG = GetModConfigData("bag")

 AddPrefabPostInit("skyshow",function(inst)
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(SKYSHOW.DAMAGE)
    inst.components.weapon:SetRange(SKYSHOW.RANGE,SKYSHOW.RANGE)
	if USE > 0 then 
		inst:AddComponent("finiteuses")
		inst.components.finiteuses:SetMaxUses(USE)
		inst.components.finiteuses:SetUses(USE)  
		inst.components.finiteuses:SetOnFinished(inst.Remove)
		inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 1)
		inst.components.finiteuses:SetConsumption(ACTIONS.MINE, 1)	
		inst.components.finiteuses:SetConsumption(ACTIONS.HAMMER, 1)
		inst.components.finiteuses:SetConsumption(ACTIONS.DIG, 1)
		inst.components.finiteuses:SetConsumption(ACTIONS.NET, 1)
	end
	inst:AddComponent("tool")
	if SKYSHOW.AXE ~= 0 then inst.components.tool:SetAction(ACTIONS.CHOP, SKYSHOW.AXE) end
	if SKYSHOW.DRAFT ~= 0 then inst.components.tool:SetAction(ACTIONS.MINE, SKYSHOW.DRAFT) end
	if SKYSHOW.DIG == 1 then inst.components.tool:SetAction(ACTIONS.DIG) end
	if SKYSHOW.NET == 1 then inst.components.tool:SetAction(ACTIONS.NET) end
	if SKYSHOW.HAMMER ~= 0 then inst.components.tool:SetAction(ACTIONS.HAMMER, SKYSHOW.HAMMER) end
	
    if inst.components.equippable then inst.components.equippable.walkspeedmult = SKYSHOW.WALKSPEED end
	if SKYSHOW.MAGIC == 1 then     --催眠
		local function HearPanFlute(inst, target, pos)
			local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 30)
			if USE > 0 then inst.components.finiteuses:Use(10) end
			for k,v in pairs(ents) do
				if v.components.sleeper~= nil and not v:HasTag("player")  then
					v.components.sleeper:AddSleepiness(10, TUNING.PANFLUTE_SLEEPTIME)
				end
				if v.components.grogginess~= nil and not v:HasTag("player")  then
					v.components.grogginess:AddGrogginess(10, TUNING.PANFLUTE_SLEEPTIME)
				end    
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(HearPanFlute)
		inst.components.spellcaster.canuseonpoint = true
	elseif SKYSHOW.MAGIC == 2 then     --瞬移
		local function onblink(staff, pos, caster)
			if caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			if USE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster then
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("flash!!")
				else
					caster.components.talker:Say("闪现！！")
				end
			end
		end
		inst:AddComponent("blinkstaff")
		inst.components.blinkstaff.onblinkfn = onblink
	elseif SKYSHOW.MAGIC == 3 then   --矮星
		local function createlight(staff, target, pos)
			local light = SpawnPrefab("stafflight")
			light.Transform:SetPosition(pos:Get())
			if USE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			--local caster = staff.components.inventoryitem.owner
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("Nice！This fruit knife works too well！")
				else
					caster.components.talker:Say("nice！这西瓜刀也太好使了！")
				end
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true
	elseif SKYSHOW.MAGIC == 4 then   --极光
		local function createlight(staff, target, pos)
				local light = SpawnPrefab("staffcoldlight")
				light.Transform:SetPosition(pos:Get())
				if USE > 0 then staff.components.finiteuses:Use(10) end
				local caster = staff.components.inventoryitem.owner
				if caster ~= nil and caster.components.sanity ~= nil then
					caster.components.sanity:DoDelta(-5)
				end
				if caster then 
					if SKYSHOW.LAN == 1 then
						caster.components.talker:Say("Nice！This fruit knife works too well！")
					else
						caster.components.talker:Say("nice！这西瓜刀也太好使了！")
					end
				end
			end
			inst:AddComponent("spellcaster")
			inst.components.spellcaster:SetSpellFn(createlight)
			inst.components.spellcaster.canuseonpoint = true
	elseif SKYSHOW.MAGIC == 5 then    --寒冰坑
		local function createlight(staff, target, pos)
			local light = SpawnPrefab("deer_ice_circle")
			light.Transform:SetPosition(pos:Get())
			light:DoTaskInTime(0, light.TriggerFX)
			light:DoTaskInTime(5, light.KillFX)
			if USE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("So cold! T^T ")
				else
					caster.components.talker:Say("好冷啊！呜呜呜呜呜！")
				end
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true	
	elseif SKYSHOW.MAGIC == 6 then    --火焰坑
		local function createlight(staff, target, pos)
			local light = SpawnPrefab("deer_fire_circle")
			light.Transform:SetPosition(pos:Get())
			light:DoTaskInTime(0, light.TriggerFX)
			light:DoTaskInTime(5, light.KillFX)
			if USE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("So hot! T^T ")
				else
					caster.components.talker:Say("好热啊！呜呜呜呜呜！")
				end
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true
	elseif SKYSHOW.MAGIC == 7 then     --旋风
		local function createlight(staff, target, pos)
			local x, y, z = pos:Get()
			local lighta = SpawnPrefab("tornado")
			lighta.Transform:SetPosition(x+1, y, z)
			local lightb = SpawnPrefab("tornado")
			lightb.Transform:SetPosition(x-1, y, z)
			local lighte = SpawnPrefab("tornado")
			lighte.Transform:SetPosition(x, y, z+1)
			local lightf = SpawnPrefab("tornado")
			lightf.Transform:SetPosition(x, y, z-1)
			if USE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("Hasagay！！！")
				else
					caster.components.talker:Say("哈撒给！！！")
				end
			end
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true		
	elseif SKYSHOW.MAGIC == 8 then    --眼球塔
		local function createlight(staff, target, pos)
			local light = SpawnPrefab("eyeturret")
			light.Transform:SetPosition(pos:Get())
			if USE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("Its eye is bigger than my head? !")
				else
					caster.components.talker:Say("眼睛比我头都大？！")
				end 
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true
	elseif SKYSHOW.MAGIC == 9 then   --古代科技塔
		local function createlight(staff, target, pos)
			local light = SpawnPrefab("ancient_altar")
			light.Transform:SetPosition(pos:Get())
			if USE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("What's this stuff? What if I want to smash it? Will I die?")
				else
					caster.components.talker:Say("这啥玩意啊？想把它砸了咋办？会死吗？")
				end
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true
	elseif SKYSHOW.MAGIC == 10 then   --铥矿
		local function createlight(staff, target, pos)
			local light = SpawnPrefab("thulecite")
			light.Transform:SetPosition(pos:Get())
			if USE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("This? ...Then why am I going to cave exploration? Hahaha")
				else
					caster.components.talker:Say("这？...那我还去洞穴探险干啥呢？嘿嘿")
				end
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true	
	elseif SKYSHOW.MAGIC == 11 then   --流星
		local function createlight(staff, target, pos)
			local light = SpawnPrefab("shadowmeteor")
			light.Transform:SetPosition(pos:Get())
			if USE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("Wow! meteor!")
				else
					caster.components.talker:Say("哇！流星！")
				end			
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true
	elseif SKYSHOW.MAGIC == 12 then   --孢子云
		local function createlight(staff, target, pos)
			local light = SpawnPrefab("sporecloud")
			light.Transform:SetPosition(pos:Get())
			if USE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("I must not bring food in！！")
				else
					caster.components.talker:Say("我可不能带着食物进去鸭~")
				end	
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true
	elseif SKYSHOW.MAGIC == 13 then   --沙刺
		local function createlight(staff, target, pos)
			local x, y, z = pos:Get()
			local lighta = SpawnPrefab("sandspike_tall")
			lighta.Transform:SetPosition(x+1, y, z)
			local lightb = SpawnPrefab("sandspike_tall")
			lightb.Transform:SetPosition(x-1, y, z)
			local lighte = SpawnPrefab("sandspike_tall")
			lighte.Transform:SetPosition(x, y, z+1)
			local lightf = SpawnPrefab("sandspike_tall")
			lightf.Transform:SetPosition(x, y, z-1)
			if USE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("Shurima! Your emperor has returned!")
				else
					caster.components.talker:Say("我！就是沙漠皇帝阿兹尔~")
				end	
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true
	elseif SKYSHOW.MAGIC == 14 then   --爆炸蘑菇
		local function createlight(staff, target, pos)
			local x, y, z = pos:Get()
			local lighta = SpawnPrefab("mushroombomb")
			lighta.Transform:SetPosition(x+1.73, y, z-1)
			local lightb = SpawnPrefab("mushroombomb")
			lightb.Transform:SetPosition(x-1.72, y, z-1)
			local lightc = SpawnPrefab("mushroombomb")
			lightc.Transform:SetPosition(x, y, z+2)
			if USE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("Captain Teemo on duty!")
				else
					caster.components.talker:Say("三个蘑菇一条命！")
				end	 
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true
	elseif SKYSHOW.MAGIC == 15 then   --爆炸蘑菇plus
		local function createlight(staff, target, pos)
			local x, y, z = pos:Get()
			local lighta = SpawnPrefab("mushroombomb_dark")
			lighta.Transform:SetPosition(x+1.73, y, z-1)
			local lightb = SpawnPrefab("mushroombomb_dark")
			lightb.Transform:SetPosition(x-1.72, y, z-1)
			local lightc = SpawnPrefab("mushroombomb_dark")
			lightc.Transform:SetPosition(x, y, z+2)
			if USE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("Captain Teemo on duty!")
				else
					caster.components.talker:Say("三个蘑菇一条命！")
				end	 
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true
	elseif SKYSHOW.MAGIC == 16 then   --催眠云
		local function createlight(staff, target, pos)
			local light = SpawnPrefab("sleepcloud")
			light.Transform:SetPosition(pos:Get())
			if USE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("Sleep, sleep, my bb~")
				else
					caster.components.talker:Say("睡吧睡吧，弟弟们~")
				end	 
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true
	elseif SKYSHOW.MAGIC == 17 then   --小光源
		local function createlight(staff, target, pos)
			local light = SpawnPrefab("yellowamuletlight")
			light.Transform:SetPosition(pos:Get())
			if USE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("Light of hope！")
				else
					caster.components.talker:Say("希望之光~")
				end	 
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true
	elseif SKYSHOW.MAGIC == 18 then   --天体灵球
		local function createlight(staff, target, pos)
			local light = SpawnPrefab("moonrockseed")
			light.Transform:SetPosition(pos:Get())
			if USE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("Cute little snowball?")
				else
					caster.components.talker:Say("可爱的小雪球？")
				end	 
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true
	elseif SKYSHOW.MAGIC == 19 then   --月亮祭坛
		local function createlight(staff, target, pos)
			local x, y, z = pos:Get()
			local light = SpawnPrefab("moon_altar")
			light.Transform:SetPosition(x,y,z)
			local lighta = SpawnPrefab("moon_altar_idol")
			lighta.Transform:SetPosition(x+1,y,z)
			local lightb = SpawnPrefab("moon_altar_seed")
			lightb.Transform:SetPosition(x-1,y,z)
			if USE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("You have to assemble it yourself, the mod author is so stupid")
				else
					caster.components.talker:Say("还得自己组装，这mod作者不行啊")
				end	 
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true
	elseif SKYSHOW.MAGIC == 20 then   --风滚草
		local function createlight(staff, target, pos)
			local light = SpawnPrefab("tumbleweedspawner")
			light.Transform:SetPosition(pos:Get())
			if USE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("What the f**k! So many tumbleweeds. which one shall I chase first?")
				else
					caster.components.talker:Say("wrng！这么多我先追哪个？")
				end	 
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true
	elseif SKYSHOW.MAGIC == 21 then   --触手
		local function createlight(staff, target, pos)
			local x, y, z = pos:Get()
			local lighta = SpawnPrefab("tentacle")
			lighta.Transform:SetPosition(x+1, y, z)
			local lightb = SpawnPrefab("tentacle")
			lightb.Transform:SetPosition(x-1, y, z)
			local lightc = SpawnPrefab("tentacle")
			lightc.Transform:SetPosition(x, y, z+1)
			local lightd = SpawnPrefab("tentacle")
			lightd.Transform:SetPosition(x, y, z-1)
			if USE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("An upgraded version of the Tentacle Book?")
				else
					caster.components.talker:Say("指哪放哪的触手书plus？！我要去打蜂后！")
				end	 
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true
	elseif SKYSHOW.MAGIC == 22 then   --鸟
		local function createlight(staff, target, pos)
			local TheWorld = GLOBAL.TheWorld  
			local Sleep = GLOBAL.Sleep
			local birdspawner = TheWorld.components.birdspawner
            if birdspawner == nil then
                return false
            end
			local caster = staff.components.inventoryitem.owner
			local pt = caster:GetPosition()
			local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 10, nil, nil, { "magicalbird" })
            if #ents > 30 then
				if caster then 
					if SKYSHOW.LAN == 1 then
						caster.components.talker:Say("There are too many f**king birds. I should stop doing it.")
					else
						caster.components.talker:Say("这鸟也太几把多了！！别搞了吧！")
					end	 
				end
            else
                local num = math.random(10, 20)
                if #ents > 20 then
					if caster then 
						if SKYSHOW.LAN == 1 then
							caster.components.talker:Say("These birds are too fucking too many!！And they are all asleep？！W T F？")
						else
							caster.components.talker:Say("哇！这鸟贼几把多！还都睡着了？！这mod作者搞事情啊？")
						end	 
					end
                else
                    num = num + 10
                end
                caster:StartThread(function()
                    for k = 1, num do
                        local pos = birdspawner:GetSpawnPoint(pt)
                        if pos ~= nil then
                            local bird = birdspawner:SpawnBird(pos, true)
                            if bird ~= nil then
                               bird:AddTag("magicalbird")
                            end
                        end
                        Sleep(math.random(.2, .25))
                    end
                end)
            end
			if USE > 0 then staff.components.finiteuses:Use(10) end
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			
			local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 30)
			for k,v in pairs(ents) do
				if v.components.sleeper~= nil and not v:HasTag("player")  then
					v.components.sleeper:AddSleepiness(10, TUNING.PANFLUTE_SLEEPTIME)
				end
				if v.components.grogginess~= nil and not v:HasTag("player")  then
					v.components.grogginess:AddGrogginess(10, TUNING.PANFLUTE_SLEEPTIME)
				end    
			end
			
			return true
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true
	elseif SKYSHOW.MAGIC == 23 then   --催熟
		local function createlight(staff, target, pos)
		
			local function trygrowth(inst)
				if inst:IsInLimbo()
					or (inst.components.witherable ~= nil and
						inst.components.witherable:IsWithered()) then
					return
				end

				if inst.components.pickable ~= nil then
					if inst.components.pickable:CanBePicked() and inst.components.pickable.caninteractwith then
						return
					end
					inst.components.pickable:FinishGrowing()
				end

				if inst.components.crop ~= nil and (inst.components.crop.rate or 0) > 0 then
					inst.components.crop:DoGrow(1 / inst.components.crop.rate, true)
				end

				if inst.components.growable ~= nil then
					-- If we're a tree and not a stump, or we've explicitly allowed magic growth, do the growth.
					if ((inst:HasTag("tree") or inst:HasTag("winter_tree")) and not inst:HasTag("stump")) or
							inst.components.growable.magicgrowable then
						inst.components.growable:DoGrowth()
					end
				end

				if inst.components.harvestable ~= nil and inst.components.harvestable:CanBeHarvested() and inst:HasTag("mushroom_farm") then
					inst.components.harvestable:Grow()
				end
			end

			local caster = staff.components.inventoryitem.owner
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("Damn it? This is the gardening book of Wickerbottom? !")
				else
					caster.components.talker:Say("卧槽？这可是老奶奶的园艺书？！")
				end	 
			end
			local x, y, z = caster.Transform:GetWorldPosition()
            local range = 30
            local ents = TheSim:FindEntities(x, y, z, range, nil, { "pickable", "stump", "withered", "INLIMBO" })
            if #ents > 0 then
                trygrowth(table.remove(ents, math.random(#ents)))
                if #ents > 0 then
                    local timevar = 1 - 1 / (#ents + 1)
                    for i, v in ipairs(ents) do
                        v:DoTaskInTime(timevar * math.random(), trygrowth)
                    end
                end
            end
			if USE > 0 then staff.components.finiteuses:Use(10) end
			
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			return true
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true
	elseif SKYSHOW.MAGIC == 24 then   --闪电
		local function createlight(staff, target, pos)
			local caster = staff.components.inventoryitem.owner
			--local Sleep = GLOBAL.Sleep
			local TheWorld = GLOBAL.TheWorld 
            local num_lightnings = 16
            caster:StartThread(function()
                for k = 0, num_lightnings do
                    local pos = Vector3(pos:Get()) + Vector3(math.random(0,1),0,math.random(0,1))
                    TheWorld:PushEvent("ms_sendlightningstrike", pos)
                    --Sleep(.3 + math.random() * .2)
                end
            end)
			if USE > 0 then staff.components.finiteuses:Use(10) end
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("Where is WX-78? Come to recharge!")
				else
					caster.components.talker:Say("机器人呢？来充电！")
				end	 
			end
			return true
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true
	elseif  SKYSHOW.MAGIC == 0 then
		
	end	
	
	local function onattack(weapon, attacker, target)
	
		if attacker then
			if  target.components.freezable then
				if  target ~= nil and target.components.freezable ~= nil then
					target.components.freezable:AddColdness(SKYSHOW.FREEZABLE)	
				end	               
			end
		end
		--冰冻
		if SKYSHOW.BURN == 1 then
			if target.components.burnable ~= nil and not target.components.burnable:IsBurning() then
				if target.components.freezable ~= nil and target.components.freezable:IsFrozen() then
					target.components.freezable:Unfreeze()
				elseif target.components.fueled == nil then
					target.components.burnable:Ignite(true)
				elseif target.components.fueled.fueltype == FUELTYPE.BURNABLE
					or target.components.fueled.secondaryfueltype == FUELTYPE.BURNABLE then
					local fuel = SpawnPrefab("cutgrass")
					if fuel ~= nil then
						if fuel.components.fuel ~= nil and
							fuel.components.fuel.fueltype == FUELTYPE.BURNABLE then
							target.components.fueled:TakeFuelItem(fuel)
						else
							fuel:Remove()
						end
					end
				end
			end
		end
		--火焰
		if SKYSHOW.BACK == 1 then
			SpawnPrefab("stalker_shield2").Transform:SetPosition(target.Transform:GetWorldPosition())
		end
		--击退
		
		
		
		if SKYSHOW.BINGHUOTX == 1 then
			local light = SpawnPrefab("deer_fire_circle")
			light.Transform:SetPosition(target.Transform:GetWorldPosition())
			light:DoTaskInTime(0, light.TriggerFX)
			light:DoTaskInTime(5, light.KillFX)
		elseif SKYSHOW.BINGHUOTX == 2 then
			local light = SpawnPrefab("deer_ice_circle")
			light.Transform:SetPosition(target.Transform:GetWorldPosition())
			light:DoTaskInTime(0, light.TriggerFX)
			light:DoTaskInTime(5, light.KillFX)
		elseif SKYSHOW.BINGHUOTX == 3 then
			local light = SpawnPrefab("sleepcloud")
			light.Transform:SetPosition(target.Transform:GetWorldPosition())
			light:DoTaskInTime(0, light.TriggerFX)
			light:DoTaskInTime(5, light.KillFX)
		elseif SKYSHOW.BINGHUOTX == 4 then
			local light = SpawnPrefab("sporecloud")
			light.Transform:SetPosition(target.Transform:GetWorldPosition())
			light:DoTaskInTime(0, light.TriggerFX)
			light:DoTaskInTime(5, light.KillFX)
		end
		
		
		
		if SKYSHOW.XUANFENGTX == 1 then
			SpawnPrefab("tornado").Transform:SetPosition(target.Transform:GetWorldPosition())
		end
		
		if SKYSHOW.LIUXINGTX == 1 then
			SpawnPrefab("shadowmeteor").Transform:SetPosition(target.Transform:GetWorldPosition())
		end
		
		if SKYSHOW.SHACITX == 1 then
			SpawnPrefab("sandspike_tall").Transform:SetPosition(target.Transform:GetWorldPosition())
		end
		
		if SKYSHOW.SHACITX == 1 then
			SpawnPrefab("sandspike_tall").Transform:SetPosition(target.Transform:GetWorldPosition())
		end
		
		if SKYSHOW.MOGUTX == 1 then
			SpawnPrefab("mushroombomb").Transform:SetPosition(target.Transform:GetWorldPosition())
		elseif SKYSHOW.MOGUTX == 2 then
			SpawnPrefab("mushroombomb_dark").Transform:SetPosition(target.Transform:GetWorldPosition())
		end
		
		
	if attacker then
	    if attacker.components.health then
		    attacker.components.health:DoDelta(SKYSHOW.HEALTH)
		end
	end
	--吸血
	if attacker then
	    if attacker.components.sanity then
		    attacker.components.sanity:DoDelta(SKYSHOW.SANITY)
		end
	end
	--吸san
	if BAOJI ~= 0 then
		if attacker then 
			local BOOM = 0
			if math.random() < SKYSHOW.BAOJILV then
				if BAOJI == 1 then
					BOOM = SKYSHOW.DAMAGE
				else
					BOOM = BAOJI
				end
				if SKYSHOW.LAN == 1 then
					attacker.components.talker:Say("！！Critical Hit！！")
				else
					attacker.components.talker:Say("！！暴击！！")
				end	 
				
			end
			target.components.health:DoDelta(-BOOM)
		end
	end
	--暴击
	if SKYSHOW.AOE == 1 then
		target:AddTag("mubiao")
		local aoepos = SpawnPrefab("explode_small")
		if aoepos then
			local follower = aoepos.entity:AddFollower()
			follower:FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0, 0 )
		end

		if not target:IsValid() then
				--target killed or removed in combat damage phase
			return
		end
		
		--target.components.health:DoDelta(SKYSHOW.AOEDAMAGE)
		if target.components.sleeper and target.components.sleeper:IsAsleep() then
			target.components.sleeper:WakeUp()
		end

		if target.sg ~= nil and not target.sg:HasStateTag("frozen") then
			target:PushEvent("attacked", { attacker = attacker, damage = 0 })
		end
		local pos = Vector3(target.Transform:GetWorldPosition())
		local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, SKYSHOW.AOERANGE)
			for k,v in pairs(ents) do
				if v.components.freezable and not v:HasTag("player") and not v:HasTag("wall") and not v:HasTag("glommer") and not v:HasTag("companion") then
					v.components.freezable:AddColdness(SKYSHOW.FREEZABLE)
					v.components.freezable:SpawnShatterFX()
				end
			end
		SpawnPrefab("groundpoundring_fx").Transform:SetPosition(target.Transform:GetWorldPosition())
		local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, SKYSHOW.AOERANGE)
		for k,v in pairs(ents) do
			if v.components.health and not v:HasTag("mubiao") and not v:HasTag("player") and not v:HasTag("abigail") and not v:HasTag("wall") and not v:HasTag("glommer") and not v:HasTag("companion") then
					SpawnPrefab("explode_small").Transform:SetPosition(v.Transform:GetWorldPosition())
					v.components.health:DoDelta(-SKYSHOW.AOEDAMAGE)
			end
		end
		target:RemoveTag("mubiao")
	end
	
	
	
    end
    inst.components.weapon:SetOnAttack(onattack)
	inst:AddComponent("waterproofer")
	inst.components.waterproofer:SetEffectiveness(SKYSHOW.WATERPROOFER)
	inst:AddComponent("insulator") 
	if SKYSHOW.WARM >= 0 then 
		inst.components.insulator:SetWinter()
	else 
		inst.components.insulator:SetSummer()
	end
	inst.components.insulator:SetInsulation(math.abs(SKYSHOW.WARM))
	--[[if FANGYU ~= 0 then
		inst:AddComponent("armor")
		inst.components.armor:InitCondition(SKYSHOW.HUJIA,FANGYU)
	end]]
end)


if SKYSHOW.CRAFT == 1 then
	AddRecipe("skyshow", {Ingredient("cutgrass", 1),Ingredient("flint", 1),Ingredient("twigs", 1)}, RECIPETABS.WAR, TECH.NONE, nil, nil, nil, nil, nil, "images/skyshow.xml", "skyshow.tex" )
elseif SKYSHOW.CRAFT == 2 then
	AddRecipe("skyshow", {Ingredient("redgem", 2),Ingredient("goldnugget", 10),Ingredient("twigs", 5)}, RECIPETABS.WAR, TECH.NONE, nil, nil, nil, nil, nil, "images/skyshow.xml", "skyshow.tex" )
else
	AddRecipe("skyshow", {Ingredient("orangegem", 2),Ingredient("nightmarefuel", 5),Ingredient("cane", 1)}, RECIPETABS.WAR, TECH.NONE, nil, nil, nil, nil, nil, "images/skyshow.xml", "skyshow.tex" )
end

if SKYSHOW.LAN == 1 then
	STRINGS.NAMES.SKYSHOW="Fruit Knife"
	STRINGS.CHARACTERS.GENERIC.SKYSHOW ="Fruit Knife"
	STRINGS.RECIPE_SKYSHOW= "Fruit Knife"
	STRINGS.RECIPE_DESC.SKYSHOW= "Aoao use it to cut watermelon."
else
	STRINGS.NAMES.SKYSHOW="西瓜刀"
	STRINGS.CHARACTERS.GENERIC.SKYSHOW ="西瓜刀"
	STRINGS.RECIPE_SKYSHOW= "西瓜刀"
	STRINGS.RECIPE_DESC.SKYSHOW= "嗷嗷一般用它来切西瓜"
end

if SKYSHOW.SHENGJI == 1 then 
local function OnGetItemFromPlayer(inst, giver, item, player)
	inst.components.weapon:SetDamage(SKYSHOW.DAMAGE+inst.mater*SKYSHOW.UPGRADEDAMAGE)
	local currentperc = 1
	if item  then
		if  item.prefab == SKYSHOW.UPGRADE then
			if inst.mater<SKYSHOW.FULL then
				inst.mater = inst.mater+1
				inst.components.weapon:SetDamage(SKYSHOW.DAMAGE+inst.mater*SKYSHOW.UPGRADEDAMAGE)
				if SKYSHOW.LAN == 1 then
					giver.components.talker:Say("level:"..inst.mater.."/"..SKYSHOW.FULL.."!")
				else
					giver.components.talker:Say("等级:"..inst.mater.."/"..SKYSHOW.FULL.."!")
				end
				inst.entity:AddSoundEmitter()
				inst.SoundEmitter:PlaySound("dontstarve/characters/wx78/levelup")
			else
				if SKYSHOW.LAN == 1 then
					giver.components.talker:Say("Full level!")
				else
					giver.components.talker:Say("已满级!")
				end
			end
		end
		if USE > 0 then
			local currentperc = inst.components.finiteuses:GetPercent()
			if item.prefab == SKYSHOW.REPAIR then
				currentperc=currentperc +0.2
				if currentperc >= 1 then
					currentperc = 1
				end
				inst.components.finiteuses:SetPercent(currentperc)
				inst.SoundEmitter:PlaySound("dontstarve/characters/wx78/levelup")
			end
		end
			
	end
	--[[if USE > 0 then 
		if inst.mater >= 1000 then
			inst.components.finiteuses:SetMaxUses(100000000)
		end
		if currentperc >= 1 then
			currentperc = 1
		end
		inst.components.finiteuses:SetPercent(currentperc)
	end]]
end

	local function onpreload(inst, data)
		if data then
			if data.mater then
				inst.mater = data.mater
			end
			OnGetItemFromPlayer(inst)
		end
	end

	local function onsave(inst, data)
		data.mater = inst.mater
	end	

	local function OnRefuseItem(inst, giver, item)
		if item then
			if SKYSHOW.LAN == 1 then
				giver.components.talker:Say("level:"..inst.mater.."/"..SKYSHOW.FULL.."!")
			else
				giver.components.talker:Say("等级:"..inst.mater.."/"..SKYSHOW.FULL.."!")
			end
		end
	end

		
	local function AcceptTest(inst, item)
		return item.prefab == SKYSHOW.UPGRADE or item.prefab == SKYSHOW.REPAIR
	end


AddPrefabPostInit("skyshow",function(inst)
	inst.mater=0
	inst.components.weapon:SetDamage(SKYSHOW.DAMAGE)
    inst:ListenForEvent("equipped",OnGetItemFromPlayer)
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(AcceptTest)
	inst.components.trader.onaccept = OnGetItemFromPlayer
	inst.components.trader.onrefuse = OnRefuseItem
	inst.OnSave = onsave
	inst.OnPreLoad = onpreload
end)

AddPrefabPostInit(SKYSHOW.UPGRADE,function(inst)
	if not inst.components.tradable then
		inst:AddComponent("tradable")
	end
end)

AddPrefabPostInit(SKYSHOW.REPAIR,function(inst)
	if not inst.components.tradable then
		inst:AddComponent("tradable")
	end
end)
end