local assets =
{
    Asset("ANIM", "anim/beargerhat.zip"),
	Asset("ATLAS", "images/inventoryimages/beargerhat.xml"),
    Asset("IMAGE", "images/inventoryimages/beargerhat.tex"),
}

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_hat", "beargerhat", "beargerhat")  
	
   owner.AnimState:Show("HAT")
    owner.AnimState:Show("HAT_HAIR")
    owner.AnimState:Hide("HAIR_NOHAT")
    owner.AnimState:Hide("HAIR")
	owner:AddTag("bearbee")
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
    owner:RemoveTag("bearbee")
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
    inst.entity:SetPristine()
	inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("beargerhat.tex")
    if not TheWorld.ismastersim then
        return inst
    end

     inst.AnimState:SetBank("beargerhat")  
    inst.AnimState:SetBuild("beargerhat")
    inst.AnimState:PlayAnimation("idle")

	inst:AddTag("hat")
	inst:AddTag("beargerhat")
	inst:AddTag("hide")
    	
	inst:AddComponent("armor")
    inst.components.armor.maxcondition =1500
    inst.components.armor:SetCondition(1500)
	inst.components.armor:SetAbsorption(0.9)

	inst:AddComponent("insulator")
    inst.components.insulator:SetInsulation(TUNING.INSULATION_LARGE)
	
	inst:AddComponent("waterproofer") 
    inst.components.waterproofer:SetEffectiveness(0.8)
	
    inst:AddComponent("inspectable") 
		
    inst:AddComponent("inventoryitem") 
	inst.components.inventoryitem.atlasname = "images/inventoryimages/beargerhat.xml"
       
	inst:AddComponent("equippable") 
	inst.components.equippable.equipslot = EQUIPSLOTS.HEAD 
	inst.components.equippable:SetOnEquip( onequip ) 
    inst.components.equippable:SetOnUnequip( onunequip ) 
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED_LARGE	  
  
    inst:AddComponent("tradable") 
    return inst
end

return Prefab("beargerhat", fn, assets, prefabs)


