local assets =
{   Asset("ANIM", "anim/ziran.zip"),
    Asset("ANIM", "anim/ziran_sw.zip"),
	Asset("ATLAS", "images/inventoryimages/ziran.xml"),
    Asset("IMAGE", "images/inventoryimages/ziran.tex"),
}

local function onequip(inst, owner) 
	 owner.AnimState:OverrideSymbol("swap_object","ziran_sw","ziran")
	owner.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
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
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
	

    inst.AnimState:SetBank("ziran") 
    inst.AnimState:SetBuild("ziran") 
    inst.AnimState:PlayAnimation("idle")	
  
    inst:AddComponent("inspectable") 

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/ziran.xml"  
    
	inst:AddComponent("waterproofer") 
    inst.components.waterproofer:SetEffectiveness(0.2)
    
	inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(10)
    inst.components.weapon:SetRange(8,12)
  

    inst:AddComponent("equippable") 
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    return inst
end

return Prefab("ziran", fn, assets, prefabs)


