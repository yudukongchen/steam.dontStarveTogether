local assets =
{
    --Asset("ANIM", "anim/spear.zip"),
    Asset("ANIM", "anim/swap_change_mace.zip"),
	Asset("IMAGE","images/inventoryimages/change_mace.tex"),
	Asset("ATLAS","images/inventoryimages/change_mace.xml")
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_change_mace", "swap_change_mace")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
	owner.AnimState:ClearOverrideSymbol("swap_object")
end


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("swap_change_mace")
    inst.AnimState:SetBuild("swap_change_mace")
    inst.AnimState:PlayAnimation("idle")

    --inst:AddTag("sharp")
    --inst:AddTag("pointy")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(56)

    -------

--[[    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(250)
    inst.components.finiteuses:SetUses(250)
    inst.components.finiteuses:SetOnFinished(inst.Remove)
--]]
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "change_mace"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/change_mace.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("change_mace", fn, assets)