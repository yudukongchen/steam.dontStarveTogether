local assets =
{
    Asset("ANIM", "anim/jinhat.zip"),
	Asset("ATLAS", "images/inventoryimages/jinhat.xml"),
    Asset("IMAGE", "images/inventoryimages/jinhat.tex"),
}

 
	
local function onequip(inst, owner, symbol_override)
    owner.AnimState:OverrideSymbol("swap_hat", "jinhat", "jinhat")  
	    owner.AnimState:Show("HAT")
        owner.AnimState:Show("HAIR_HAT")
        owner.AnimState:Hide("HAIR_NOHAT")
        owner.AnimState:Hide("HAIR")

        if owner:HasTag("player") then
            owner.AnimState:Hide("HEAD")
            owner.AnimState:Show("HEAD_HAT")
        end

        if inst.components.fueled ~= nil then
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

    
     inst.AnimState:SetBank("jinhat")  
    inst.AnimState:SetBuild("jinhat")
    inst.AnimState:PlayAnimation("idle")
 	
	
	inst:AddTag("hat")
	--inst:AddTag("hide")
    	
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("armor")
    inst.components.armor.maxcondition =900
    inst.components.armor:SetCondition(900)
	inst.components.armor:SetAbsorption(0.85)

	inst:AddComponent("waterproofer") 
    inst.components.waterproofer:SetEffectiveness(0.2)
	
    inst:AddComponent("inspectable") 
		
    inst:AddComponent("inventoryitem") 
	inst.components.inventoryitem.atlasname = "images/inventoryimages/jinhat.xml"
       
	inst:AddComponent("equippable") 
	inst.components.equippable.equipslot = EQUIPSLOTS.HEAD 
	inst.components.equippable:SetOnEquip(onequip) 
    inst.components.equippable:SetOnUnequip(onunequip) 
  
    inst:AddComponent("tradable") 
	
	MakeHauntableLaunchAndPerish(inst)
    return inst
end

return Prefab("jinhat", fn, assets, prefabs)


