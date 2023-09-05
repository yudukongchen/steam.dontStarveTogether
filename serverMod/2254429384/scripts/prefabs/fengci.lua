local assets =
{
    Asset("ANIM", "anim/fengci.zip"),
    Asset("ANIM", "anim/fengci_sw.zip"),
	Asset("ATLAS", "images/inventoryimages/fengci.xml"),
    Asset("IMAGE", "images/inventoryimages/fengci.tex"),
}


local function onfinished(inst)
    inst:Remove()
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object","fengci_sw","fengci")
	owner.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal")
    end
	
local function onattack(inst, owner, target)
if target.components.health.maxhealth > 3000 then 
inst.components.finiteuses:Use(1)
end
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

    inst.AnimState:SetBank("fengci")
    inst.AnimState:SetBuild("fengci")
    inst.AnimState:PlayAnimation("idle")


    inst:AddComponent("tool")
  
   
    inst:AddTag("sharp")
	
	

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(60)
	inst.components.weapon.onattack = onattack
    inst.components.weapon:SetRange(0)

    inst:AddComponent("inspectable")

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(200)
    inst.components.finiteuses:SetUses(200)   
    inst.components.finiteuses:SetOnFinished( onfinished )
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fengci.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip ) 
    return inst
end

return Prefab("fengci", fn, assets, prefabs)


