
local assets=               --来自群模板。
{
	Asset("ANIM", "anim/tianluhat.zip"),  --动画文件wwwwwwwww
	Asset("IMAGE", "images/inventoryimages/tianluhat.tex"), --物品栏贴图
    Asset("ATLAS", "images/inventoryimages/tianluhat.xml"),
    Asset("SOUNDPACKAGE", "sound/goodluck.fev"),  --音效
    Asset("SOUND", "sound/goodluck.fsb"),
}

local commonprize = {"goldnugget","goldnugget","goldnugget","goldnugget","goldnugget", --普通战利品
"redgem","bluegem","purplegem",
"thulecite","greengem","orangegem","yellowgem",
"gears","mushroom_light2_blueprint","dragon_scales",
"icecake","icecake","icecake","icecake","icecake"
}

local bossprize = {"goldnugget","redgem","bluegem","purplegem","thulecite","greengem","orangegem","yellowgem","opalpreciousgem",         --boss(>4000叫boss?)
"amulet","mandrake","deerclops_eyeball","dragon_scales","hivehat","shroom_skin","blueamulet","purpleamulet","orangeamulet","greenamulet",
"yellowamulet","orangestaff","greenstaff","yellowstaff","opalstaff","ruinshat","bixiehat"}                               --偷懒了，完全随机四样。

local function Bosstrophies(target)
    local luckynumber = math.random(1,100)
    if luckynumber <= 30 then
    if target.components.lootdropper then   --bug修复：自己用回旋镖杀自己可还行。
        local items = {}
        for i=1,4 do
           local prefab = bossprize[math.random(1,#bossprize)]
            table.insert(items, SpawnPrefab(prefab))
        end
        local bundle = SpawnPrefab("gift")
        bundle.components.unwrappable:WrapItems(items)
        for i, v in ipairs(items) do
            v:Remove()
        end
        target.components.lootdropper:FlingItem(bundle)
        if target.SoundEmitter then
            target.SoundEmitter:PlaySound("goodluck/goodluck/bossprize") 
        end
    end
    end
end

local function Commontrophies(target)
    local luckynumber = math.random(1,100)
    for k,v in pairs(commonprize) do 
    if luckynumber == k then
        if target.components.lootdropper then   --bug修复：自己用回旋镖杀自己可还行。
            target.components.lootdropper:SpawnLootPrefab(v)
            if target.SoundEmitter then
              target.SoundEmitter:PlaySound("goodluck/goodluck/prize") 
            end
         end
    end
    end
end

local function notrophies(target)  
	local tgs = { 'shadow', 'shadowminion', 'shadowchesspiece'}
	if target then
		for _, v in ipairs(tgs)do
			if target:HasTag(v) then return true end
		end
	end
end

local function onequiphat(inst, owner) --装备的函数
    owner.AnimState:OverrideSymbol("swap_hat", "tianluhat", "swap_hat")  --替换的动画部件	使用的动画  第三个照样也是文件夹的名字
    owner.AnimState:Show("HAT")
    owner.AnimState:Show("HAT_HAIR")
    owner.AnimState:Hide("HAIR_NOHAT")
    owner.AnimState:Hide("HAIR")
    owner.Luckydog =function(world,data)     --要这么写才能获取owner 啊。
        if data and data.inst and data.afflicter ~= nil and data.afflicter == owner and not notrophies(data.inst) then --排除暗影生物。
            if data.inst.components.health then
               local health = data.inst.components.health:GetMaxWithPenalty()
               if health>=4000 then 
                 Bosstrophies(data.inst)
                 elseif health >= 100 and data.inst.prefab ~= "krampus" then
                     Commontrophies(data.inst)
                        elseif data.inst.prefab == "krampus" then
                            local k = math.random(1,100)
                            if k<=5 then             --这是额外的5％几率。掉两个包的几率为0.05％
                             data.inst.components.lootdropper:SpawnLootPrefab("krampus_sack")
                             data.inst.SoundEmitter:PlaySound("goodluck/goodluck/bossprize")
                            end
                        elseif  data.inst.prefab == "butterfly" then
                            local k = math.random(1,100)
                            if k<=30 then             --这是额外的30％几率。掉两个的几率为3％?
                             data.inst.components.lootdropper:SpawnLootPrefab("butter")
                             data.inst.SoundEmitter:PlaySound("goodluck/goodluck/prize")
                            end
                end
            end
        end
    end  
        
    if owner:HasTag("player") then --隐藏head  显示head——hat
            owner.AnimState:Hide("HEAD")
            owner.AnimState:Show("HEAD_HAT")
            owner:ListenForEvent("entity_death", owner.Luckydog,TheWorld)   --猪人兔子不可。
    end
end

local function onunequiphat(inst, owner) --解除帽子
    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAT_HAIR")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")
    
        if owner:HasTag("player") then
            owner.AnimState:Show("HEAD")
            owner.AnimState:Hide("HEAD_HAT")
        end
    owner:RemoveEventCallback("entity_death", owner.Luckydog,TheWorld)
end

local function fn(Sim)
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    MakeInventoryFloatable(inst)   --海上漂浮
    inst.components.floater:SetSize("med")
    inst.components.floater:SetVerticalOffset(0.1)
    inst.components.floater:SetScale(0.6)

    inst.AnimState:SetBank("tianluhat")  --地上动画
    inst.AnimState:SetBuild("tianluhat")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("hat")
    inst:AddTag("tianluhat")
    inst:AddTag("hide")
    inst:AddTag("waterproofer")
    	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable") --可检查
		
    inst:AddComponent("inventoryitem") --物品组件
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tianluhat.xml"
    
    inst:AddComponent("waterproofer")  --防水
    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)
     
	inst:AddComponent("equippable") --装备组件
	inst.components.equippable.equipslot = EQUIPSLOTS.HEAD --装在头上
	inst.components.equippable:SetOnEquip( onequiphat ) --装备
    inst.components.equippable:SetOnUnequip( onunequiphat ) --解除装备
    inst:AddComponent("armor")   --护甲
    inst.shouldwork = true
    inst.components.armor:InitCondition(TUNING.ARMORMARBLE*1.3, TUNING.ARMOR_FOOTBALLHAT_ABSORPTION)
    inst.components.armor.SetCondition = function(self,amount)  --不可被摧毁
        self.condition = math.min(amount, self.maxcondition)
        if self.condition <= 0 then 
            self.condition = 0
            self.absorb_percent = 0
        end
        if self.condition > 0 then
            self.absorb_percent = TUNING.ARMOR_FOOTBALLHAT_ABSORPTION
        end
        self.inst:PushEvent("percentusedchange", { percent = self:GetPercent() })
        if self.condition == 0 then   --这里是做什么的？这么写着总有点后怕……
          ProfileStatsSet("armor_broke_"..self.inst.prefab, true)
          ProfileStatsSet("armor", self.inst.prefab)
        end
    end
    inst:ListenForEvent("percentusedchange", function(inst,data)   --这里就不做幸运监听的判断了。即使是0耐久依旧好运气。
        if data.percent <= 0 and inst.shouldwork then 
            inst.components.waterproofer:SetEffectiveness(0)
            inst.components.insulator:SetInsulation(0)
            inst.components.equippable.dapperness = -TUNING.DAPPERNESS_TINY
            inst.shouldwork = false
        end
        if data.percent > 0 and not inst.shouldwork then
            inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)
            inst.components.insulator:SetInsulation(TUNING.INSULATION_MED_LARGE)
            inst.components.equippable.dapperness = TUNING.DAPPERNESS_TINY
            inst.shouldwork = true
        end
    end)
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_TINY  --装备回复san

    inst:AddComponent("insulator")  --不设置就默认为保暖
    inst.components.insulator:SetInsulation(TUNING.INSULATION_MED_LARGE)
    
    inst:AddComponent("tradable") --可交易组件  有了这个就可以给猪猪  
	
    MakeHauntableLaunchAndPerish(inst) --作祟相关
    
    return inst
end 
    
return Prefab( "common/inventory/tianluhat", fn, assets) 