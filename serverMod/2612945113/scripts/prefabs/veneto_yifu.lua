local assets =
{
    Asset("ANIM", "anim/veneto_yifu.zip"),  
	Asset("ATLAS", "images/inventoryimages/veneto_yifu.xml"), 
    Asset("IMAGE", "images/inventoryimages/veneto_yifu.tex"),
}


local function onequip(inst, owner) 
	owner.AnimState:OverrideSymbol("swap_body", "veneto_yifu", "swap_body")
end

local function onunequip(inst, owner)  
    owner.AnimState:ClearOverrideSymbol("swap_body")
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

    inst.AnimState:SetBank("veneto_yifu")
    inst.AnimState:SetBuild("veneto_yifu")
    inst.AnimState:PlayAnimation("anim")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable") 

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/veneto_yifu.xml"  
    
	inst:AddComponent("waterproofer")  
	inst.components.waterproofer:SetEffectiveness(0.8)
	
	inst:AddComponent("insulator") 
	inst.components.insulator:SetInsulation(240)

    inst:AddComponent("chosenpeople")
    inst.components.chosenpeople:SetChosenFn(OnChosen)

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.USAGE
    inst.components.fueled:InitializeFuelLevel(TUNING.TRUNKVEST_PERISHTIME)
    inst.components.fueled:SetDepletedFn(inst.Remove)

    inst:AddComponent("equippable") 
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY 
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
	inst.components.equippable.walkspeedmult = 1.05

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("veneto_yifu", fn, assets)
