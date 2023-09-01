local assets=
{
    Asset("ANIM", "anim/shinai.zip"),   
    Asset("ANIM", "anim/swap_shinai.zip"),
    
    Asset("ATLAS", "images/inventoryimages/shinai.xml"),
    Asset("IMAGE", "images/inventoryimages/shinai.tex"),	
}
local DMG = 25
local function OnEquip(inst, owner)	
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
	owner.AnimState:OverrideSymbol("swap_object", "swap_shinai", "swap_shinai")

	if owner.kenjutsulevel ~= nil then --Owner
	inst.components.spellcaster.canusefrominventory = true
	
	if owner.kenjutsulevel >= 1 and not inst:HasTag("mkatana") then inst:AddTag("mkatana") end		
	end	
end
  
local function OnUnequip(inst, owner)
	owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
	
	if owner.kenjutsulevel ~= nil then --Owner
	inst.components.spellcaster.canusefrominventory = false	
	inst:RemoveTag("mkatana")	
	end
	
end

local trainingcount = 0
local function castFn(inst, target)
local owner = inst.components.inventoryitem.owner

	if owner.kenjutsulevel ~= nil then 
		if owner.kenjutsulevel < 10 and owner.kenjutsuexp < owner.kenjutsumaxexp - (owner.kenjutsumaxexp/2) then owner.kenjutsuexp = owner.kenjutsuexp + 1
			trainingcount = trainingcount +1
			owner.components.hunger:DoDelta(-1)
				if trainingcount == 5 then
				owner.kenjutsuexp = owner.kenjutsuexp + 1
				owner.SoundEmitter:PlaySound("turnoftides/common/together/boat/jump")
				trainingcount = 0
				end	
		else owner.components.talker:Say("Enough for training.")
		end
	end
end

local function onattack(inst, owner, target)
	if owner.components.rider:IsRiding() then return end		
	if owner.kenjutsulevel ~= nil then 
		if owner.kenjutsulevel >= 1 and not inst:HasTag("mkatana") then inst:AddTag("mkatana") end		
		if  math.random(1, 5) == 1 then 
			if owner.kenjutsulevel < 10 then owner.kenjutsuexp = owner.kenjutsuexp +  math.random(1, 3) end
			owner.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")				
			local effect = SpawnPrefab("impact")		
			effect.Transform:SetPosition(target:GetPosition():Get())
		end
	end
end


local function fn()  
    local inst = CreateEntity()
	
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()	
    
    MakeInventoryPhysics(inst)  
      
    inst.AnimState:SetBank("shinai")
    inst.AnimState:SetBuild("shinai")
    inst.AnimState:PlayAnimation("idle")
	  
	inst:AddTag("katanaskill")
	inst:AddTag("woodensword")
	
	inst.spelltype = "SCIENCE"   
    inst:AddTag("quickcast")
    
	MakeInventoryFloatable(inst)
	inst.components.floater:SetSize("small")
    inst.components.floater:SetVerticalOffset(0.1)		    
	
    if not TheWorld.ismastersim then
        return inst
    end 
    inst.entity:SetPristine()   

    inst:AddComponent("weapon")	
	inst.components.weapon:SetDamage(DMG)
	inst.components.weapon:SetOnAttack(onattack)
	inst.components.weapon:SetRange(.6, 1)
	
	inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(300)
    inst.components.finiteuses:SetUses(300)
    inst.components.finiteuses:SetOnFinished(inst.Remove)
	
    inst:AddComponent("inspectable")
	inst:AddComponent("timer")
    inst:AddComponent("inventoryitem")
	
	inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)
	
	inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(castFn)
	inst.components.spellcaster.quickcast = true
	inst.components.spellcaster.canusefrominventory = false	
	
    inst.components.inventoryitem.imagename = "shinai"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/shinai.xml"	
	--inst.components.inventoryitem.canonlygoinpocket = true
	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )	
	
	--MakeHauntableLaunch(inst)		
    return inst
end

return  Prefab("common/inventory/shinai", fn, assets) 