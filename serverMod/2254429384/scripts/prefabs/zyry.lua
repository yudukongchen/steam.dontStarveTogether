local assets =
{
    Asset("ANIM", "anim/zyry.zip"),
	Asset("ATLAS", "images/inventoryimages/zyry.xml"),
    Asset("IMAGE", "images/inventoryimages/zyry.tex"),
}

 local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_hat", "zyry", "zyry")  
	
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

    inst.AnimState:SetBank("zyry")  
    inst.AnimState:SetBuild("zyry")
    inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("hat")
	inst:AddTag("hide")
    	
    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end


	inst:AddComponent("armor")
    inst.components.armor.maxcondition =1350
    inst.components.armor:SetCondition(1350)
	inst.components.armor:SetAbsorption(0.9)

	inst:AddComponent("waterproofer") 
    inst.components.waterproofer:SetEffectiveness(0.2)
	
    inst:AddComponent("inspectable") 
		
    inst:AddComponent("inventoryitem") 
	inst.components.inventoryitem.atlasname = "images/inventoryimages/zyry.xml"
       
	inst:AddComponent("equippable") 
	inst.components.equippable.equipslot = EQUIPSLOTS.HEAD 
	inst.components.equippable:SetOnEquip(onequip) 
    inst.components.equippable:SetOnUnequip(onunequip) 
	inst.components.equippable.walkspeedmult = 1.25
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED_LARGE	  
  
    inst:AddComponent("tradable") 
	
	MakeHauntableLaunchAndPerish(inst)
    return inst
end

return Prefab("zyry", fn, assets, prefabs)


