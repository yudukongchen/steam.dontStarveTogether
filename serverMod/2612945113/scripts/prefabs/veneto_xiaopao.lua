local assets =
{
    Asset("ANIM", "anim/veneto_xiaopao.zip"),
    Asset("ANIM", "anim/swap_veneto_xiaopao.zip"),
    Asset("ATLAS", "images/inventoryimages/veneto_xiaopao.xml"),
    Asset("IMAGE", "images/inventoryimages/veneto_xiaopao.tex"),
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_veneto_xiaopao", "swap_wuqi")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("veneto_xiaopao")
    inst.AnimState:SetBuild("veneto_xiaopao")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp") 
    inst:AddTag("pointy")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon") 
	inst.components.weapon:SetDamage(45) 

    inst:AddComponent("finiteuses") 
    inst.components.finiteuses:SetMaxUses(150)
    inst.components.finiteuses:SetUses(150)

    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("inspectable") 

    inst:AddComponent("inventoryitem") 
    inst.components.inventoryitem.atlasname = "images/inventoryimages/veneto_xiaopao.xml" 

    inst:AddComponent("equippable") 
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
	
	inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)

    MakeHauntableLaunch(inst)

    return inst
end	

return Prefab("common/inventory/veneto_xiaopao", fn, assets, prefabs)