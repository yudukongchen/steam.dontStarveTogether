local assets =
{
    Asset("ANIM", "anim/wange.zip"),
    Asset("ANIM", "anim/wange_sw.zip"),
	Asset("ATLAS", "images/inventoryimages/wange.xml"),
    Asset("IMAGE", "images/inventoryimages/wange.tex"),
}


local function onfinished(inst)
    inst:Remove()
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object","wange_sw","wange")
	owner.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner) 
    owner.components.combat.areahitrange=0
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal")
    end
	
local function onattack(inst, owner, target)

end

local function OnGetItemFromPlayer(inst, giver, item, player)
    
	local currentperc = inst.components.finiteuses:GetPercent()
		if item.prefab == "marble" then
			currentperc=currentperc +0.25
		end
		
	if currentperc>=1 then
		currentperc=1
	end
	inst.components.finiteuses:SetPercent(currentperc)
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

    inst.AnimState:SetBank("wange")
    inst.AnimState:SetBuild("wange")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
	
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(53)
	inst.components.weapon.onattack = onattack
    inst.components.weapon:SetRange(0)

    inst:AddComponent("inspectable")

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(150)
    inst.components.finiteuses:SetUses(150)   
    inst.components.finiteuses:SetOnFinished( onfinished )
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/wange.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip ) 
	
	inst:AddComponent("trader")
	inst.components.trader.onaccept = OnGetItemFromPlayer
	
	
    return inst
end

return Prefab("wange", fn, assets, prefabs)


