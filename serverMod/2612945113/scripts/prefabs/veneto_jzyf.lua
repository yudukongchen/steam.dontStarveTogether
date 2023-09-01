local assets =
{
    Asset("ANIM", "anim/veneto_jzyf.zip"),  
	Asset("ATLAS", "images/inventoryimages/veneto_jzyf.xml"), 
    Asset("IMAGE", "images/inventoryimages/veneto_jzyf.tex"),
}

local function OnBlocked(owner, data) 
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_armour")
end

local function onequip(inst, owner) 
	owner.AnimState:OverrideSymbol("swap_body", "veneto_jzyf", "swap_body")
	inst:ListenForEvent("blocked", OnBlocked, owner)

	if owner.components.drownable then
		owner.components.drownable.enabled = false
	end
	RemovePhysicsColliders(owner)
end

local function onunequip(inst, owner)  
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst:RemoveEventCallback("blocked", OnBlocked, owner)

	if owner.components.drownable then
		owner.components.drownable.enabled = true
	end
	ChangeToCharacterPhysics(owner)
end

local function OnChosen(inst,owner)
	return owner:HasTag("VV")
end 

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("veneto_jzyf")
    inst.AnimState:SetBuild("veneto_jzyf")
    inst.AnimState:PlayAnimation("anim")


    inst.foleysound = "dontstarve/movement/foley/logarmour"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable") 

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/veneto_jzyf.xml"  
    
	inst:AddComponent("waterproofer")  
	inst.components.waterproofer:SetEffectiveness(1)
	
	inst:AddComponent("insulator") 
	inst.components.insulator:SetInsulation(240)

    inst:AddComponent("chosenpeople")
    inst.components.chosenpeople:SetChosenFn(OnChosen)

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(7000,0.95) 

    inst:AddComponent("equippable") 
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY 

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
	
	inst:AddComponent("trader")
	inst.components.trader:SetAbleToAcceptTest(function(inst, item)
		if inst.components.armor:GetPercent() == 1 then
			return false
		end
		
		if item.prefab == "goldnugget" or item.prefab == "gears" or item.prefab == "thulecite" then
			return true
		end
		
		return false
	end)
	inst.components.trader.acceptnontradable = true
	inst.components.trader.onaccept = function(inst, giver, item)
		if item.prefab == "goldnugget" then
			inst.components.armor:SetCondition(inst.components.armor.condition + 150)
		elseif item.prefab == "gears" then
			inst.components.armor:SetCondition(inst.components.armor.condition + 1200)
		elseif item.prefab == "thulecite" then
			inst.components.armor:SetCondition(inst.components.armor.condition + 2500)
		end
	end

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("veneto_jzyf", fn, assets)
