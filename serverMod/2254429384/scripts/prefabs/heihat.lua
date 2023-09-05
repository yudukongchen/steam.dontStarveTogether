local assets =
{
    Asset("ANIM", "anim/heihat.zip"),
	Asset("ATLAS", "images/inventoryimages/heihat.xml"),
    Asset("IMAGE", "images/inventoryimages/heihat.tex"),
}

local function turnon(inst)
		local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
		if not inst.components.fueled:IsEmpty() then			
			inst.components.fueled:StartConsuming()
	        if not inst.fire then 
	            inst.fire = SpawnPrefab( "heifire" )        
	            local follower = inst.fire.entity:AddFollower()
	            follower:FollowSymbol( owner.GUID, "swap_hat", 0, -250, 0 )
	        end 
		end
	end
	
	local function turnoff(inst, ranout)
		if inst.components.equippable and inst.components.equippable:IsEquipped() then
			local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
		end
		inst.components.fueled:StopConsuming()

	    if inst.fire then 
	        inst.fire:Remove()
	        inst.fire = nil
	    end 
	end
	
	local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_hat", "heihat", "heihat")  
	
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
		turnon(inst)
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
		turnoff(inst)
end
	
	local function nofuel(inst)
		local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
		if owner then
			owner:PushEvent("torchranout", {torch = inst})
		end
		turnoff(inst)
	end

local function takefuel(inst)
		if inst.components.equippable and inst.components.equippable:IsEquipped() then			
			turnon(inst)
		end
	end
	
	local function candle_drop(inst)
		turnoff(inst)
	end
	
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    
     inst.AnimState:SetBank("heihat")  
    inst.AnimState:SetBuild("heihat")
    inst.AnimState:PlayAnimation("idle")
 	
	
	inst:AddTag("hat")
	--inst:AddTag("hide")
    	
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("armor")
    inst.components.armor.maxcondition =1350
    inst.components.armor:SetCondition(1350)
	inst.components.armor:SetAbsorption(0.9)

	inst:AddComponent("fueled")
    inst.components.fueled:InitializeFuelLevel(1080)
	inst.components.fueled.fueltype = "NIGHTMARE"
	inst.components.fueled.accepting = true
	inst.components.fueled:SetDepletedFn(nofuel)
    inst.components.fueled.ontakefuelfn = takefuel
	
	inst:AddComponent("waterproofer") 
    inst.components.waterproofer:SetEffectiveness(0.2)
	
    inst:AddComponent("inspectable") 
		
    inst:AddComponent("inventoryitem") 
	inst.components.inventoryitem.atlasname = "images/inventoryimages/heihat.xml"
	inst.components.inventoryitem:SetOnDroppedFn( candle_drop )
       
	inst:AddComponent("equippable") 
	inst.components.equippable.equipslot = EQUIPSLOTS.HEAD 
	inst.components.equippable:SetOnEquip(onequip) 
    inst.components.equippable:SetOnUnequip(onunequip) 
  
    inst:AddComponent("tradable") 
	
	MakeHauntableLaunchAndPerish(inst)
    return inst
end

return Prefab("heihat", fn, assets, prefabs)


