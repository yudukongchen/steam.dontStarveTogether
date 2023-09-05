local assets =
{
    Asset("ANIM", "anim/tk_sw.zip"),
	Asset("ATLAS", "images/inventoryimages/tk.xml"),
    Asset("IMAGE", "images/inventoryimages/tk.tex"),
}

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_hat", "tk_sw", "tk_sw")  
	
   owner.AnimState:Show("HAT")
    owner.AnimState:Show("HAT_HAIR")
    owner.AnimState:Hide("HAIR_NOHAT")
    owner.AnimState:Hide("HAIR")
	
	if owner:HasTag("player") then
            owner.AnimState:Hide("HEAD")
            owner.AnimState:Show("HEAD_HAT")
        end
        if inst.components.fueled then
            inst.components.fueled:StartConsuming()        
        end
end
    

local function onunequip(inst, owner)  
     owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAT_HAIR")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")
    
        if owner:HasTag("player") then
            owner.AnimState:Show("HEAD")
            owner.AnimState:Hide("HEAD_HAT")
        end

      if inst.components.fueled then
            inst.components.fueled:StopConsuming()        
        end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("tk")
    inst.AnimState:SetBuild("tk_sw")
    inst.AnimState:PlayAnimation("anim")
    
    inst:AddTag("hat")
	inst:AddTag("hide")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
  inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tk.xml"  
    
    inst:AddComponent("waterproofer")  
    inst.components.waterproofer:SetEffectiveness(0.8)
    
    inst:AddComponent("armor")
     inst.components.armor:InitCondition(1350, 0.9)
    
    inst:AddComponent("equippable") 
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD 
    --inst.components.equippable.dapperness = TUNING.DAPPERNESS_LARGE
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
	--inst.components.equippable.walkspeedmult = 1.15

    
    return inst
end

return Prefab("tk", fn, assets)



