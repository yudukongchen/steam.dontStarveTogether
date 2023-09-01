local assets =
{
    Asset("ANIM", "anim/jgj.zip"),
    Asset("ANIM", "anim/swap_jgj.zip"),

    Asset("ATLAS", "images/inventoryimages/jgj.xml"),
}


local function jgj_lightfn()
    local inst = CreateEntity()	--添加实体

    inst.entity:AddTransform()	--添加变换组件
    inst.entity:AddLight()		--添加发光组件
    inst.entity:AddNetwork()	--添加网络位置

    inst:AddTag("FX")	--设置便签 FX

    inst.Light:SetIntensity(TUNING.JGJ_LIGHT_INTENSITY)	--设置发光强度
    inst.Light:SetRadius(TUNING.JGJ_LIGHT_RADIUS)		--设置发光半径
    inst.Light:Enable(true)		--是否激活
    inst.Light:SetFalloff(1)	--设置散开
    inst.Light:SetColour(245/85,85/85,245/85)		--设置发光颜色

    inst.entity:SetPristine()	--设置原始

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false	--保持

    return inst
end


local function lighton(inst, owner)
    if inst._light == nil or not inst._light:IsValid() then
        inst._light = SpawnPrefab("jgj_light")
    end
    if owner ~= nil then
        inst._light.entity:SetParent(owner.entity)
    end
end


local function lightoff(inst)
    if inst._light ~= nil then
            if inst._light:IsValid() then
                inst._light:Remove()
            end
            inst._light = nil
        end
end

local function onjgbremove(inst)
    SpawnPrefab("moonrocknugget").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end


local function onattack(weapon, attacker, target)
    --target.components.burnable:Ignite(nil, attacker)	--普攻燃烧
	--target.components.freezable:AddColdness(2)	--冻结
	
	if attacker then
		if  target ~= nil and target.components.burnable ~= nil then
			--target.components.freezable:AddColdness(2)	--冰冻
			
		end
	end
	
end

local function saniup(inst)
	if inst.isWeared and not inst.isDropped then
		-- inst:AddComponent("dapperness")
		inst.components.equippable.dapperness = 0.5
	end
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_jgj", "swap_jgj")	--设置手上动画
	owner.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")		--设置声音
    owner.AnimState:Show("ARM_carry")	--显示拿武器动作
    owner.AnimState:Hide("ARM_normal")	--隐藏空手动作

    lighton(inst, owner)
	
	-- 装备加精神
	inst.isWeared = true
	inst.isDropped = false
	saniup(inst)
	
end


local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")	--隐藏拿武器动作
    owner.AnimState:Show("ARM_normal")	--显示空手动作

    lightoff(inst, owner)
	
	-- 不装备不加精神
	inst.isWeared = false
	inst.isDropped = false
	saniup(inst)
	
end

local function fn()


    local inst = CreateEntity()	--添加实体
	local sound = inst.entity:AddSoundEmitter()
	
    inst.entity:AddTransform()	--添加变换组件
    inst.entity:AddAnimState()	--添加动画状态
    inst.entity:AddLight()		--添加发光组件
    inst.entity:AddNetwork()	--添加网络位置

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("jgj")	--动画状态
    inst.AnimState:SetBuild("jgj")	--构造
    inst.AnimState:PlayAnimation("idle")	--播放动画

    inst.entity:SetPristine()	--设置原始
	
    inst:AddTag("sharp")	--设置标签 sharp

    if not TheWorld.ismastersim then
        return inst
    end


	
	inst.Light:SetIntensity(TUNING.JGJ_LIGHT_INTENSITY)	--设置发光强度
    inst.Light:SetRadius(TUNING.JGJ_LIGHT_RADIUS)		--设置发光半径
    inst.Light:Enable(true)		--是否激活
    inst.Light:SetFalloff(1)	--设置散开
    inst.Light:SetColour(245/85,85/85,245/85)		--设置发光颜色

    -----
    inst:AddComponent("tool")		--添加工具组件
	
    inst.components.tool:SetAction(ACTIONS.MINE, 50) --可挖矿
    inst.components.tool:SetAction(ACTIONS.CHOP, 50) --可砍树
  
	
    -- if TUNING.JGJ_CAN_USE_AS_SHOVEL then
        -- inst.components.tool:SetAction(ACTIONS.DIG)  --可铲草
    -- end
	
	--inst.components.tool:SetAction(ACTIONS.NET)  --可捕虫
 
	
    -- if TUNING.JGJ_CAN_USE_AS_HAMMER then
        -- inst.components.tool:SetAction(ACTIONS.HAMMER) --可锤
    -- end
	

    inst:AddComponent("weapon")		--添加武器组件
    inst.components.weapon:SetDamage(TUNING.JGJ_DAMAGE)		--设置武器伤害
    inst.components.weapon:SetRange(TUNING.JGJ_ATTAK_RANGE, TUNING.JGJ_ATTAK_RANGE)	--设置攻击范围
	inst.components.weapon:SetOnAttack(onattack)
	
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")	--添加物品栏组件
    inst.components.inventoryitem.atlasname = "images/inventoryimages/jgj.xml"	--设置物品栏图片


    if TUNING.JGJ_FINITE_USES > 0 then
        inst:AddComponent("finiteuses")		--添加耐久度组件
        inst.components.finiteuses:SetMaxUses(TUNING.JGJ_FINITE_USES)	--设置耐久度最大值
        inst.components.finiteuses:SetUses(TUNING.JGJ_FINITE_USES)		--设置当前耐久度
        inst.components.finiteuses:SetOnFinished(onjgbremove)			--设置删除武器
        inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 1)		--设置砍树减耐久度
        inst.components.finiteuses:SetConsumption(ACTIONS.MINE, 1)		--设置挖矿减耐久度
        inst.components.finiteuses:SetConsumption(ACTIONS.HAMMER, 1)	--设置锤子减耐久度
        inst.components.finiteuses:SetConsumption(ACTIONS.DIG, 1)		--设置铲草减耐久度
    end

    MakeHauntableLaunch(inst)
    inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_INSTANT_REZ)
	
    inst:AddComponent("equippable")		--添加装备组件
    inst.components.equippable:SetOnEquip(onequip)	--设置装备执行
    inst.components.equippable:SetOnUnequip(onunequip)	--设置未装备执行
    inst.components.equippable.walkspeedmult = TUNING.JGJ_MOVE_SPEED_MUL	--设置不行速度


    return inst
end

return Prefab("common/inventory/jgj", fn, assets),
       Prefab("jgj_light", jgj_lightfn)