local assets =
{
    Asset("ANIM", "anim/veneto_dapao.zip"),
    Asset("ANIM", "anim/swap_veneto_dapao.zip"),
    Asset("ATLAS", "images/inventoryimages/veneto_dapao.xml"),
    Asset("IMAGE", "images/inventoryimages/veneto_dapao.tex"),
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_veneto_dapao", "swap_wuqi")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function OnChosen(inst,owner)
	return owner:HasTag("VV")
end 

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("veneto_dapao")
    inst.AnimState:SetBuild("veneto_dapao")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp") 
    inst:AddTag("pointy")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon") 
    inst.components.weapon:SetRange(2)
	inst.components.weapon:SetDamage(68) 

    inst:AddComponent("finiteuses") 
    inst.components.finiteuses:SetMaxUses(100)
    inst.components.finiteuses:SetUses(100)

    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("chosenpeople")
    inst.components.chosenpeople:SetChosenFn(OnChosen)

    inst:AddComponent("inspectable") 

    inst:AddComponent("inventoryitem") 
    inst.components.inventoryitem.atlasname = "images/inventoryimages/veneto_dapao.xml" 

    inst:AddComponent("equippable") 
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
	
	inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)

    MakeHauntableLaunch(inst)

    return inst
end	

return Prefab("common/inventory/veneto_dapao", fn, assets, prefabs)