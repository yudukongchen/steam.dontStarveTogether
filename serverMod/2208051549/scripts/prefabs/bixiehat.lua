
local assets=
{
	Asset("ANIM", "anim/bixiehat.zip"),  --动画文件
	Asset("IMAGE", "images/inventoryimages/bixiehat.tex"), --物品栏贴图
    Asset("ATLAS", "images/inventoryimages/bixiehat.xml"),
    Asset("SOUNDPACKAGE", "sound/goodluck.fev"),  --音效
    Asset("SOUND", "sound/goodluck.fsb"),
}

local function lowhurttarget(target)  
	local tgs = { 'shadow', 'shadowminion', 'shadowchesspiece','stalker'}
	if target then
		for _, v in ipairs(tgs)do
			if target:HasTag(v) then return true end
        end
	end
end

local bossprize = {"goldnugget","redgem","bluegem","purplegem","thulecite","greengem","orangegem","yellowgem","opalpreciousgem",         --boss(>4000叫boss?)
"amulet","mandrake","deerclops_eyeball","dragon_scales","hivehat","shroom_skin","blueamulet","purpleamulet","orangeamulet","greenamulet",
"yellowamulet","orangestaff","greenstaff","yellowstaff","opalstaff","ruinshat","tianluhat"}                               --偷懒了，完全随机四样。

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

local function OnBlocked(owner,data,inst)
    if inst.shouldwork and data and data.damage then
        local attacker = data.attacker
        if attacker and lowhurttarget(attacker) then 
            if  attacker.components.combat then 
                local olddamage = attacker.components.combat.defaultdamage
                attacker.components.combat:SetDefaultDamage(olddamage*0.5)  --伤害衰减。
                attacker:DoTaskInTime(10,function(attacker) 
                    attacker.components.combat:SetDefaultDamage(olddamage)    end)
            end
        end
    end
end
       

local function onequiphat(inst, owner) --装备的函数
    owner.AnimState:OverrideSymbol("swap_hat", "bixiehat", "swap_hat")
    owner.AnimState:Show("HAT")
    owner.AnimState:Show("HAT_HAIR")
    owner.AnimState:Hide("HAIR_NOHAT")
    owner.AnimState:Hide("HAIR")
    owner.Luckydog =function(world,data)  
        if data and data.inst and data.afflicter ~= nil and data.afflicter == owner then --暗影生物也有奖励。
            if data.inst.components.health then
               local health = data.inst.components.health:GetMaxWithPenalty()
               if lowhurttarget(data.inst) and data.inst.components.lootdropper then
                data.inst.components.lootdropper:SpawnLootPrefab("nightmarefuel")
               end
               if health>=4000 then 
                 Bosstrophies(data.inst)
               elseif health>= 100 and data.inst.components.lootdropper then
                  local k = math.random(1,100)
                     if k<=25 then           
                        data.inst.components.lootdropper:SpawnLootPrefab("nightmarefuel")
                     end
                end
            end
        end
    end
        
    if owner:HasTag("player") then --隐藏head  显示head——hat
            owner.AnimState:Hide("HEAD")
            owner.AnimState:Show("HEAD_HAT")
            owner:ListenForEvent("entity_death", owner.Luckydog,TheWorld)
            owner:ListenForEvent("attacked", inst.onblocked)   
            if owner.components.sanity ~= nil then  
                owner.components.sanity.neg_aura_absorb = 0.01
            end
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
            owner:RemoveEventCallback("entity_death", owner.Luckydog,TheWorld)
            owner:RemoveEventCallback("attacked", inst.onblocked)  
            if owner.components.sanity ~= nil then
                owner.components.sanity.neg_aura_absorb = 0
            end
        end
end

local function fn(Sim)
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("bixiehat")  --地上动画
    inst.AnimState:SetBuild("bixiehat")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("hat")
    inst:AddTag("bixiehat")
    inst:AddTag("hide")
    
    MakeInventoryFloatable(inst)   --海上漂浮
    inst.components.floater:SetSize("med")
    inst.components.floater:SetVerticalOffset(0.1)
    inst.components.floater:SetScale(0.6)
    	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable") --可检查
		
    inst:AddComponent("inventoryitem") --物品组件
	inst.components.inventoryitem.atlasname = "images/inventoryimages/bixiehat.xml"
       
	inst:AddComponent("equippable") --装备组件
	inst.components.equippable.equipslot = EQUIPSLOTS.HEAD 
	inst.components.equippable:SetOnEquip( onequiphat )
    inst.components.equippable:SetOnUnequip( onunequiphat ) 

    inst:AddComponent("armor")   --护甲
    inst.shouldwork = true
    inst.components.armor:InitCondition(TUNING.ARMORMARBLE*1.2, TUNING.ARMOR_RUINSHAT_ABSORPTION)
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_LARGE  --贝雷帽
    inst.components.armor.SetCondition = function(self,amount)  --不可被摧毁
        self.condition = math.min(amount, self.maxcondition)
        if self.condition <= 0 then 
            self.condition = 0
            self.absorb_percent = 0
        end
        if self.condition > 0 then
            self.absorb_percent = TUNING.ARMOR_RUINSHAT_ABSORPTION
        end
        self.inst:PushEvent("percentusedchange", { percent = self:GetPercent() })
        if self.condition == 0 then   --这里是做什么的？这么写着总有点后怕……
          ProfileStatsSet("armor_broke_"..self.inst.prefab, true)
          ProfileStatsSet("armor", self.inst.prefab)
        end
    end
    inst:ListenForEvent("percentusedchange", function(inst,data)
        if data.percent <= 0 and inst.shouldwork then 
            inst.components.equippable.dapperness = 0
            inst.shouldwork = false
        end
        if data.percent > 0 and not inst.shouldwork then
            inst.components.equippable.dapperness = TUNING.DAPPERNESS_LARGE
            inst.shouldwork = true
        end
    end)
	
    inst:AddComponent("tradable") --可交易组件  有了这个就可以给猪猪 
    inst.onblocked = function(owner, data) 
        OnBlocked(owner, data, inst) 
    end 
	
	MakeHauntableLaunchAndPerish(inst) --作祟相关
    return inst
end 
    
return Prefab( "common/inventory/bixiehat", fn, assets) 