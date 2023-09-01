local size = GetModConfigData("MAXSTACKSIZE")
local animalStack = GetModConfigData("ANIMALSTACK")
local eggStack = GetModConfigData("EGGSTACK")
local trapStack = GetModConfigData("TRAPSTACK")
local toolStack = GetModConfigData("TOOLSTACK")
local wqStack =  GetModConfigData("WQSTACK")
local yfStack =  GetModConfigData("YFSTACK")
local Miscellaneous =  GetModConfigData("Miscellaneous")
local IsServer = GLOBAL.TheNet:GetIsServer()

GLOBAL.TUNING.STACK_SIZE_LARGEITEM = size
GLOBAL.TUNING.STACK_SIZE_MEDITEM = size
GLOBAL.TUNING.STACK_SIZE_SMALLITEM = size 
GLOBAL.TUNING.WORTOX_MAX_SOULS = size

local stackable_replica = GLOBAL.require("components/stackable_replica")
stackable_replica._ctor = function(self, inst)
	self.inst = inst
	self._stacksize = GLOBAL.net_shortint(inst.GUID, "stackable._stacksize", "stacksizedirty")
	self._maxsize = GLOBAL.net_tinybyte(inst.GUID, "stackable._maxsize")
end

local function DecreaseSizeByOne(inst)
    local size = inst.components.stackable:StackSize() - 1
    inst.components.stackable:SetStackSize(size)    
end
local function onfinish(inst)
    DecreaseSizeByOne(inst)

    if inst.components.finiteuses ~= nil then
        inst.components.finiteuses:SetPercent(1)
    elseif inst.components.fueled ~= nil then
        inst.components.fueled:SetPercent(1)
    end         
end


local function CaseLeft(inst, components1, components2)
    local percent = components1:GetPercent() + components2:GetPercent()
    if percent > 1 then
        percent = percent - 1
    else
       DecreaseSizeByOne(inst)
    end
    components1:SetPercent(percent)
end


local function CaseRight(item, components1, components2)
    local sourceper = components1:GetPercent()
    if sourceper < 1 then
        local itemper = components2:GetPercent()
        local percentleft = 1 - sourceper
        if itemper > percentleft then
            local percent = itemper - percentleft
            components2:SetPercent(percent)
            components1:SetPercent(1)
        else
            if item.components.stackable:StackSize() > 1 then
                components1:SetPercent(1)
                local percent = 1 - (percentleft - itemper)
                components2:SetPercent(percent)
                DecreaseSizeByOne(item)
            else
                local percent = sourceper + itemper
                components1:SetPercent(percent)
                item:Remove()
                return true
            end
        end
        if components2:GetPercent() < 0.01 then
            item:Remove()
            return true
        end
    end
    return false
end

local function newStackable(self)
    local _Put = self.Put
    self.Put = function(self, item, source_pos)
        if item.prefab == self.inst.prefab then
            local newtotal = item.components.stackable:StackSize() + self.inst.components.stackable:StackSize()
            if item.components.finiteuses ~= nil then               
                if newtotal <= self.inst.components.stackable.maxsize then
                    CaseLeft(self.inst, self.inst.components.finiteuses, item.components.finiteuses)
                else                                    
                    if CaseRight(item, self.inst.components.finiteuses, item.components.finiteuses) then
                        return nil
                    end
                end 
            elseif item.components.fueled ~= nil then
                if newtotal <= self.inst.components.stackable.maxsize then
                    CaseLeft(self.inst, self.inst.components.fueled, item.components.fueled)
                else
                    if CaseRight(item, self.inst.components.fueled, item.components.fueled) then
                        return nil
                    end
                end
            elseif item.components.armor ~= nil then
                if newtotal <= self.inst.components.stackable.maxsize then
                    CaseLeft(self.inst, self.inst.components.armor, item.components.armor)
                else                        
                    if CaseRight(item, self.inst.components.armor, item.components.armor) then
                        return nil
                    end
                end
            end
        end
        return _Put(self, item, source_pos)
    end
end

local function addITem(name)
	AddPrefabPostInit(name,function(inst)
		if  inst.components.sanity ~= nil  then
			return
		end
		if  inst.components.inventoryitem == nil  then
			return
		end
        if(inst.components.stackable == nil) then
            inst:AddComponent("stackable")
        end
        if inst:HasTag("trap") then
            inst.components.stackable.forcedropsingle = true
        end
        if inst.components.projectile == nil or (inst.components.projectile ~= nil and not inst.components.projectile.cancatch) then
            if inst.components.throwable == nil then
                if inst.components.equippable ~= nil then
                    inst.components.equippable.equipstack = true
                end 
            end 
        end
        
        if inst.components.finiteuses == nil then
            if inst.components.fueled == nil then
                return
            end     
        end
                
        if inst.components.finiteuses ~= nil then
            local _onfinished = inst.components.finiteuses.onfinished and inst.components.finiteuses.onfinished or nil
            if _onfinished ~= nil then
                inst.components.finiteuses.onfinished = function (inst)         
                    if inst.components.stackable:StackSize() > 1 then
                        onfinish(inst)
                    else
                        _onfinished(inst)
                    end 
                end
            end
        end
        if inst.components.fueled ~= nil then
            local _sectionfn = inst.components.fueled.sectionfn and inst.components.fueled.sectionfn or nil
            if _sectionfn ~= nil then
                    inst.components.fueled.sectionfn = function (newsection, oldsection, inst)
                        if newsection == 0 then
                            if inst.components.stackable:StackSize() > 1 then
                                onfinish(inst)
                            else
                                 _sectionfn(newsection, oldsection, inst)
                            end 
                        end
                    end
            else
                local _depleted = inst.components.fueled.depleted and inst.components.fueled.depleted or nil
                if _depleted ~= nil then
                    inst.components.fueled.depleted = function (inst)   
                        if inst.components.stackable:StackSize() > 1 then
                            onfinish(inst)
                        else
                            _depleted(inst)
                        end 
                    end
                end 
            end 
        end
    end)
end

if IsServer then
	if animalStack then
		addITem("spider")--蜘蛛
		addITem("spider_hider")--洞穴蜘蛛
		addITem("spider_spitter")--喷射蜘蛛
		addITem("spider_warrior")--蜘蛛战士
		addITem("spider_moon")--破碎蜘蛛
		addITem("spider_healer")--护士蜘蛛
		addITem("spider_dropper")--穴居悬蛛
		addITem("spider_water")--水蜘蛛

		addITem("rabbit")--兔子
		addITem("mole")--鼹鼠
		addITem("crow")--乌鸦
		addITem("canary")--金丝雀
		addITem("robin")--红雀
		addITem("robin_winter")--雪雀
		addITem("puffin")--海雀
		
		addITem("pondfish")--淡水鱼
		addITem("pondeel")--鳗鱼
		addITem("oceanfish_medium_1_inv")--泥鱼
		addITem("oceanfish_medium_2_inv")--深海鲈鱼
		addITem("oceanfish_medium_3_inv")--华丽狮子鱼
		addITem("oceanfish_medium_4_inv")--黑鲇鱼
		addITem("oceanfish_medium_5_inv")--玉米鱼
		addITem("oceanfish_medium_6_inv")--花锦鱼
		addITem("oceanfish_medium_7_inv")--金锦鱼
		addITem("oceanfish_medium_8_inv")--冰鲷鱼
		addITem("oceanfish_medium_9_inv")--甜味儿鱼
		addITem("oceanfish_small_1_inv")--小孔雀鱼
		addITem("oceanfish_small_2_inv")--针鼻喷墨鱼
		addITem("oceanfish_small_3_inv")--小饵鱼
		addITem("oceanfish_small_4_inv")--三文鱼苗
		addITem("oceanfish_small_5_inv")--爆米花鱼
		addITem("oceanfish_small_6_inv")--落叶比目鱼
		addITem("oceanfish_small_7_inv")--花朵金枪鱼
		addITem("oceanfish_small_8_inv")--炽热太阳鱼
		addITem("oceanfish_small_9_inv")--口水鱼
		addITem("wobster_sheller_land")--龙虾
		addITem("wobster_moonglass_land")--月光龙虾
    end

	if eggStack then
		addITem("tallbirdegg")--高鸟蛋
		addITem("minotaurhorn")--犀牛角
        addITem("deerclops_eyeball")--鹿角怪眼球
        addITem("shadowheart")--暗影心房
        addITem("eyeturret_item")--眼球塔
        addITem("glommerwings")--格罗姆翅膀
        addITem("lavae_egg")--岩浆虫卵
	end
	
	if trapStack then
		--陷阱
		addITem("trap")--陷阱
		addITem("birdtrap")--捕鸟
		addITem("trap_teeth")--狗牙
		addITem("trap_bramble")--海葵陷阱
		addITem("beemine")--海葵陷阱
	end

	if toolStack then
        --工具
        
        addITem("horn")--牛角
        addITem("axe")--工具
        addITem("pickaxe")--工具
        addITem("shovel")--工具
        addITem("pitchfork")--工具
        addITem("goldenaxe")--工具
        addITem("goldenshovel")--工具
        addITem("goldenpickaxe")--工具
        addITem("pitchfork")--工具
        addITem("hammer")--工具
        addITem("farm_hoe")--工具
        addITem("golden_farm_hoe")--工具
        addITem("razor")--工具
        addITem("pocket_scale")--工具
        addITem("saddlehorn")--工具
        --addITem("saddle_basic")--工具
        --addITem("saddle_war")--工具
        --addITem("saddle_race")--工具
        addITem("fishingrod")--钓鱼竿
        addITem("minifan")--风车
        addITem("reviver")--告密的心
        addITem("fertilizer")--便便桶
        addITem("sewing_kit")--针线包
    
        addITem("brush")--工具
        --照明
        addITem("torch")
        addITem("bugnet")
    
        --2021.11.27加入
        addITem("multitool_axe_pickaxe")--斧稿
        
    end

    --武器 11.27
    if wqStack then
        addITem("spear")--长茅
        addITem("hambat")--火腿棒
        addITem("spear_wathgrithr")--女武神战矛
        addITem("telestaff")--传送法杖
        addITem("tentaclespike")--触手尖刺
        addITem("nightsword")--暗夜剑
        
    end
    --衣服
    if yfStack then
        addITem("armorgrass")--草甲
        addITem("armorwood")--木甲
        addITem("armormarble")--大理石甲
        addITem("armor_sanity")--暗影护甲
        
    end
    --杂项 11.27
    if Miscellaneous then
        addITem("oar")--船桨
        addITem("oar_driftwood")--浮木船桨
        addITem("farm_plow_item")--耕地机
        addITem("staff_tornado")--风向标
        addITem("boat_item")--物品形态的船
        addITem("anchor_item")--船锚物品
        addITem("steeringwheel_item")--方向舵套装物品
        addITem("mast_item")--帆物品
        addITem("mast_malbatross_item")--邪天翁帆
        addITem("mastupgrade_lamp_item")--夹板照明灯物品
        addITem("redmooneye")--红月眼
        addITem("bluemooneye")--蓝月眼
        addITem("purplemooneye")--紫月眼
        addITem("greenmooneye")--绿月眼
        addITem("yellowmooneye")--黄月眼
        addITem("orangemooneye")--橙月眼
        addITem("deer_antler1")--鹿角1
        addITem("deer_antler2")--鹿角2
        addITem("deer_antler3")--鹿角3
        addITem("klaussackkey")--麋鹿茸
    end

	AddComponentPostInit("stackable", newStackable)
end
bugtracker_config = {
    email = "1103613479@qq.com",
    upload_client_log = true,
    upload_server_log = true,
    -- 其它配置项目...
}