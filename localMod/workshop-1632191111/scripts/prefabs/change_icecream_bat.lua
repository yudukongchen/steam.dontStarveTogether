local assets =
{
    --Asset("ANIM", "anim/change_icecream_bat.zip"),
    Asset("ANIM", "anim/swap_change_icecream_bat.zip"),
	Asset("IMAGE","images/inventoryimages/change_icecream_bat.tex"),
	Asset("ATLAS","images/inventoryimages/change_icecream_bat.xml")
	
}

local MAX_DAMAGE = 80
local DAMAGE_MODIFIER = 0.3

local function UpdateDamage(inst)
    if inst.components.perishable and inst.components.weapon then
        local dmg = MAX_DAMAGE * inst.components.perishable:GetPercent()
        dmg = Remap(dmg, 0, MAX_DAMAGE, DAMAGE_MODIFIER*MAX_DAMAGE, MAX_DAMAGE)
        inst.components.weapon:SetDamage(dmg)
    end
end

local function OnLoad(inst, data)
    UpdateDamage(inst)
end

local function onequip(inst, owner)
    UpdateDamage(inst)
    owner.AnimState:OverrideSymbol("swap_object", "swap_change_icecream_bat", "swap_change_icecream_bat")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    UpdateDamage(inst)
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

    inst.AnimState:SetBank("swap_change_icecream_bat")
    inst.AnimState:SetBuild("swap_change_icecream_bat")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("show_spoilage")
    inst:AddTag("icebox_valid")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(MAX_DAMAGE)
    inst.components.weapon:SetOnAttack(UpdateDamage)

    inst.OnLoad = OnLoad

    -------
    
    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.VEGGIE
    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = TUNING.CALORIES_MED
    inst.components.edible.sanityvalue = TUNING.SANITY_HUGE
    

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "change_icecream_bat"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/change_icecream_bat.xml"

    MakeHauntableLaunchAndPerish(inst)

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    return inst
end

return Prefab( "change_icecream_bat", fn, assets) 