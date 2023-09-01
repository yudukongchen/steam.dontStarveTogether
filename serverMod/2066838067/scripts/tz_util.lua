local function CreateFx(prefabname,assets,bank,build,anim,loop,forever,extrafn)
	assets = assets or {
		Asset("ANIM", "anim/"..prefabname..".zip"),
	}
	local function fxfn()
		local inst = CreateEntity()
		
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter() 
		inst.entity:AddNetwork()

		
		inst.AnimState:SetBank(bank or prefabname)
		inst.AnimState:SetBuild(build or prefabname)
		
		if anim then 
			inst.AnimState:PlayAnimation(anim or "idle",loop)
		end 
		
		inst.entity:SetPristine()
		if not TheWorld.ismastersim then
			return inst
		end
		
		if forever then 
			
		else
			inst.persists = false 
			inst:ListenForEvent("animover",inst.Remove)
		end 
		
		if extrafn then 
			extrafn(inst)
		end 
		
		return inst
	end 
	
	return Prefab(prefabname, fxfn, assets)
end 

local function OnInvalidOwner(inst,owner,delay,saysth,return_to_inventory)
	delay = delay or 0
	owner:DoTaskInTime(delay, function()
		if owner.components.inventory then
			if return_to_inventory then 
				owner.components.inventory:GiveItem(inst)
			else
				owner.components.inventory:DropItem(inst, true, true)
			end 
		end
		if owner.components.talker and saysth then
			owner.components.talker:Say(saysth)
		end
	end)
end

local function CreateWeapon(prefabname,assets,tags,bank,build,anim,swapanims,damage,ranges,maxuse,clientfn,serverfn)
	assets = assets or {
		Asset("ANIM", "anim/"..prefabname..".zip"),
		Asset("ANIM", "anim/swap_"..prefabname..".zip"),
		
		Asset("IMAGE","images/inventoryimages/"..prefabname..".tex"),
		Asset("ATLAS","images/inventoryimages/"..prefabname..".xml"),
	}
	swapanims = swapanims or {"swap_"..prefabname,"swap_"..prefabname}
	local function onequip(inst, owner) 
		owner.AnimState:OverrideSymbol("swap_object", swapanims[1],swapanims[2])
		owner.AnimState:Show("ARM_carry") 
		owner.AnimState:Hide("ARM_normal") 
	end

	local function onunequip(inst, owner) 
		owner.AnimState:Hide("ARM_carry") 
		owner.AnimState:Show("ARM_normal") 
	end
	local function WeaponFn()
		local inst = CreateEntity()
		
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter() 
		inst.entity:AddNetwork()
		
		MakeInventoryPhysics(inst)
		
		inst.AnimState:SetBank(bank or prefabname)
		inst.AnimState:SetBuild(build or prefabname) 
		inst.AnimState:PlayAnimation(anim or "idle")
		
		if tags then
			for k,v in pairs(tags) do 
				inst:AddTag(v)
			end
		end  

		if clientfn then 
			clientfn(inst) 
		end 

		inst.entity:SetPristine()	
		
		if not TheWorld.ismastersim then
			return inst
		end	  

		inst:AddComponent("weapon")
		inst.components.weapon:SetDamage(damage)	
		if ranges then 
			if type(ranges) == "table"	then 
				inst.components.weapon:SetRange(ranges[1],ranges[2])
			else
				inst.components.weapon:SetRange(ranges)
			end 
		end 
		-------
		
		if maxuse then 
			inst:AddComponent("finiteuses")
			inst.components.finiteuses:SetMaxUses(maxuse)
			inst.components.finiteuses:SetUses(maxuse)
			inst.components.finiteuses:SetOnFinished(inst.Remove)
		end 

		inst:AddComponent("inspectable")
		
		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.imagename = prefabname
		inst.components.inventoryitem.atlasname = "images/inventoryimages/"..prefabname..".xml"
		
		inst:AddComponent("equippable")
		inst.components.equippable:SetOnEquip( onequip )
		inst.components.equippable:SetOnUnequip( onunequip )
		
		if serverfn then
			serverfn(inst) 
		end
		
		return inst
	end

	return Prefab(prefabname, WeaponFn, assets) 
end


return {
	CreateFx = CreateFx,
	CreateWeapon = CreateWeapon,
	OnInvalidOwner = OnInvalidOwner,
}