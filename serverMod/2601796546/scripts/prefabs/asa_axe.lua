local assets =
{
    Asset("ANIM", "anim/asa_axe.zip"),
    Asset("ANIM", "anim/swap_asa_axe.zip"),
	Asset("ANIM", "anim/swap_asa_axe1.zip"),
    Asset( "IMAGE", "images/inventoryimages/asa_axe1.tex" ),
    Asset( "ATLAS", "images/inventoryimages/asa_axe1.xml" ),
}

local function powerdown(inst)
	inst.components.weapon:SetDamage(34)
	inst.components.tool:SetAction(ACTIONS.CHOP, 1.2)
    inst.components.tool:SetAction(ACTIONS.MINE, 1)
	if inst.components.equippable:IsEquipped() then	--切换贴图，纯属个人兴趣
		inst.components.inventoryitem.owner.AnimState:OverrideSymbol("swap_object", "swap_asa_axe1", "swap_asa_axe1")
	end
    inst.components.inventoryitem.atlasname = "images/inventoryimages/asa_axe1.xml"
    inst.components.inventoryitem:ChangeImageName("asa_axe1")
end

local function onequip(inst, owner)
	if inst.components.fueled:IsEmpty() then
		owner.AnimState:OverrideSymbol("swap_object", "swap_asa_axe1", "swap_asa_axe1")
	else
		owner.AnimState:OverrideSymbol("swap_object", "swap_asa_axe", "swap_asa_axe")
		owner.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/equip")
	end
    
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    if owner:HasTag("player") then
	    inst.components.fueled:StartConsuming()
    end
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
	inst.components.fueled:StopConsuming()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("asa_axe")
    inst.AnimState:SetBuild("asa_axe")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
	inst:AddTag("asa_axe")
    --tool (from tool component) added to pristine state for optimization
    inst:AddTag("tool")
    inst:AddTag("asa_item")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    local swap_data = {sym_build = "swap_multitool_axe_pickaxe", sym_name = "swap_object"}
    MakeInventoryFloatable(inst, "med", 0.05, {0.7, 0.4, 0.7}, true, -13, swap_data)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(59.5)
    -----
    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP, 4)
    inst.components.tool:SetAction(ACTIONS.MINE, 2)
	-- inst.components.tool:SetAction(ACTIONS.HAMMER, 2)
    -------
    -- inst:AddComponent("finiteuses")
    -- inst.components.finiteuses:SetMaxUses(TUNING.MULTITOOL_AXE_PICKAXE_USES)
    -- inst.components.finiteuses:SetUses(TUNING.MULTITOOL_AXE_PICKAXE_USES)
    -- inst.components.finiteuses:SetOnFinished(inst.Remove)
    -- inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 1)
    -- inst.components.finiteuses:SetConsumption(ACTIONS.MINE, 3)
    -------
	inst:AddComponent("fueled")
    inst.components.fueled.maxfuel = 2.5 * TUNING.TORCH_FUEL
	inst.components.fueled:InitializeFuelLevel(2.5 * TUNING.TORCH_FUEL)
    inst.components.fueled.accepting = true
	inst.components.fueled:SetDepletedFn(powerdown)
	-- inst.components.fueled:SetTakeFuelFn(charged)
	inst.components.fueled:StopConsuming()
    local oldDoDelta = inst.components.fueled.DoDelta
    inst.components.fueled.DoDelta = function(self, amount, doer)
        if amount > 0 and self:IsEmpty() then
            inst.components.inventoryitem.atlasname = "images/inventoryimages/asa_axe.xml"
            inst.components.inventoryitem:ChangeImageName("asa_axe")
        end
        oldDoDelta(self, amount, doer)
    end
	
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "asa_axe"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/asa_axe.xml"

	inst:AddComponent("equippable")

    inst.components.equippable:SetOnEquip(onequip)

    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)
	
	inst:DoTaskInTime(2,function()
		if inst.components.fueled:IsEmpty() then
            inst.components.inventoryitem.imagename = "asa_axe1"
            inst.components.inventoryitem.atlasname = "images/inventoryimages/asa_axe1.xml"
			inst.components.weapon:SetDamage(34)
			inst.components.tool:SetAction(ACTIONS.CHOP, 1.2)
			inst.components.tool:SetAction(ACTIONS.MINE, 1)
			if inst.components.equippable:IsEquipped() then
				inst.components.inventoryitem.owner.AnimState:OverrideSymbol("swap_object", "swap_asa_axe1", "swap_asa_axe1")
			end
		end
	end)
	
	
    return inst
end

return Prefab("asa_axe", fn, assets)
