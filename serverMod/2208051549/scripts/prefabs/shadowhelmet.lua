
local assets=
{
	Asset("ANIM", "anim/shadowhelmet.zip"),  --动画文件
	Asset("IMAGE", "images/inventoryimages/shadowhelmet.tex"), --物品栏贴图
	Asset("ATLAS", "images/inventoryimages/shadowhelmet.xml"),
}

local prefabs =
{
}
local function onequiphat(inst, owner) --装备的函数
    owner.AnimState:OverrideSymbol("swap_hat", "shadowhelmet", "swap_hat")
								--替换的动画部件	使用的动画  第三个照样也是文件夹的名字
    owner.AnimState:Show("HAT")
    owner.AnimState:Show("HAT_HAIR")
    owner.AnimState:Hide("HAIR_NOHAT")
    owner.AnimState:Hide("HAIR")
        
    if owner:HasTag("player") then --隐藏head  显示head——hat
            owner.AnimState:Hide("HEAD")
            owner.AnimState:Show("HEAD_HAT")
        end
        if inst.components.fueled ~= nil then --如果有耐久 那么开始掉
            inst.components.fueled:StartConsuming()
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

        if inst.components.fueled ~= nil then --停止掉耐久
            inst.components.fueled:StopConsuming()
        end
end

local function opentop_onequip(inst, owner) 
--这里其实跟装备是一样的 唯一的区别是这个不会隐藏head 这样适用于花环之类的不会遮住头发的帽子
        owner.AnimState:OverrideSymbol("swap_hat", "shadowhelmet", "swap_hat")
        owner.AnimState:Show("HAT")
        owner.AnimState:Hide("HAT_HAIR")
        owner.AnimState:Show("HAIR_NOHAT")
        owner.AnimState:Show("HAIR")
        
        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAIR")
		if inst.components.fueled ~= nil then
            inst.components.fueled:StartConsuming()
        end
    end
local function OnTakeDamage(inst, damage_amount)  -- -吸收伤害的5％san
        local owner = inst.components.inventoryitem.owner
        if owner then
            local sanity = owner.components.sanity
            if sanity then
                local unsaneness = damage_amount * 0.05
                sanity:DoDelta(-unsaneness, false)  
            end
        end
end   

local function finished(inst) --耐久用完之后运行的函数
        inst:Remove()			--移除它
end

local function fn(Sim)
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("shadowhelmet")  --地上动画
    inst.AnimState:SetBuild("shadowhelmet")
    inst.AnimState:PlayAnimation("anim")

	inst:AddTag("hat")
	inst:AddTag("hide")
    	
    inst.entity:SetPristine()

    MakeInventoryFloatable(inst)   --海上漂浮
    inst.components.floater:SetSize("med")
    inst.components.floater:SetVerticalOffset(0.1)
    inst.components.floater:SetScale(0.6)

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable") --可检查
		
    inst:AddComponent("inventoryitem") --物品组件
    inst.components.inventoryitem.atlasname = "images/inventoryimages/shadowhelmet.xml"
    
    inst:AddComponent("armor")   --护甲
    inst.components.armor:InitCondition(TUNING.ARMOR_FOOTBALLHAT, TUNING.ARMOR_SANITY_ABSORPTION)
    inst.components.armor.ontakedamage = OnTakeDamage
       
	inst:AddComponent("equippable") --装备组件
	inst.components.equippable.equipslot = EQUIPSLOTS.HEAD --装在头上
	inst.components.equippable:SetOnEquip( onequiphat ) --装备
    inst.components.equippable:SetOnUnequip( onunequiphat ) --解除装备
    inst.components.equippable.dapperness = TUNING.CRAZINESS_SMALL
    inst.components.equippable.is_magic_dapperness = true  --？
    inst.components.equippable:SetOnEquip(opentop_onequip) --这个只适用于不会遮住头发的帽子 才会加上这一条  没用就删除
    
	
    inst:AddComponent("tradable") --可交易组件  有了这个就可以给猪猪  
	
	MakeHauntableLaunchAndPerish(inst) --作祟相关
    return inst
end 
    
return Prefab( "common/inventory/shadowhelmet", fn, assets, prefabs) 