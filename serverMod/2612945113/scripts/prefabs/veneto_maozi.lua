
local assets=
{
	Asset("ANIM", "anim/veneto_maozi.zip"), 
	Asset("IMAGE", "images/inventoryimages/veneto_maozi.tex"),
	Asset("ATLAS", "images/inventoryimages/veneto_maozi.xml"),
}

local prefabs =
{
}
local function onequiphat(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_hat", "veneto_maozi", "swap_hat")
								
    owner.AnimState:Show("HAT")
    owner.AnimState:Show("HAT_HAIR")
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

local function onunequiphat(inst, owner) 
    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAT_HAIR")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")
    
        if owner:HasTag("player") then
            owner.AnimState:Show("HEAD")
            owner.AnimState:Hide("HEAD_HAT")
        end

        if inst.components.fueled ~= nil then 
            inst.components.fueled:StopConsuming()
        end
end

local function opentop_onequip(inst, owner) 
        owner.AnimState:OverrideSymbol("swap_hat", "veneto_maozi", "swap_hat")
        owner.AnimState:Show("HAT")
        owner.AnimState:Hide("HAT_HAIR")
        owner.AnimState:Show("HAIR_NOHAT")
        owner.AnimState:Show("HAIR")
        
        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAIR")
		if inst.components.fueled ~= nil then
            inst.components.fueled:StartConsuming()
        end
       
    end
local function finished(inst) 
        inst:Remove()			
end

local function OnChosen(inst,owner)
	return owner:HasTag("VV")
end 


local function fn(Sim)
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("veneto_maozi")  
    inst.AnimState:SetBuild("veneto_maozi")
    inst.AnimState:PlayAnimation("anim")

	inst:AddTag("hat")
	inst:AddTag("hide")
    	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable") 
		
    inst:AddComponent("inventoryitem") 
	inst.components.inventoryitem.atlasname = "images/inventoryimages/veneto_maozi.xml"
	
	inst:AddComponent("waterproofer")  
	inst.components.waterproofer:SetEffectiveness(0.2)
	
	inst:AddComponent("chosenpeople")
    inst.components.chosenpeople:SetChosenFn(OnChosen)
       
	inst:AddComponent("equippable") 
	inst.components.equippable.equipslot = EQUIPSLOTS.HEAD 
	inst.components.equippable:SetOnEquip( onequiphat ) 
    inst.components.equippable:SetOnUnequip( onunequiphat ) 
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_LARGE  
    inst.components.equippable.walkspeedmult = 1.05
    inst.components.equippable:SetOnEquip(opentop_onequip) 
  
    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.USAGE
    inst.components.fueled:InitializeFuelLevel(TUNING.RAINCOAT_PERISHTIME)
    inst.components.fueled:SetDepletedFn(inst.Remove)

	MakeHauntableLaunchAndPerish(inst) 
    return inst
end 
    
return Prefab( "common/inventory/veneto_maozi", fn, assets, prefabs) 