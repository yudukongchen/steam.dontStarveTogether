local assets =
{
    Asset("ANIM", "anim/banjia_sw.zip"),
	Asset("ATLAS", "images/inventoryimages/banjia.xml"),
    Asset("IMAGE", "images/inventoryimages/banjia.tex"),
}

local function OnBlocked(owner, data) 
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_armour")
end

local function onequip(inst, owner) 
	owner.AnimState:OverrideSymbol("swap_body", "banjia_sw", "banjia")						
    inst:ListenForEvent("blocked", OnBlocked, owner)
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst:RemoveEventCallback("blocked", OnBlocked, owner)
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

     inst.AnimState:SetBank("banjia") 
    inst.AnimState:SetBuild("banjia_sw") 
    inst.AnimState:PlayAnimation("anim")	

    inst:AddComponent("inspectable") 

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/banjia.xml"  
    
	inst:AddComponent("waterproofer") 
    inst.components.waterproofer:SetEffectiveness(0.2)
    
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(1350,0.9) 

    inst:AddComponent("equippable") 
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY 
    inst.components.equippable.walkspeedmult = 1.25
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    return inst
end

return Prefab("banjia", fn, assets, prefabs)


