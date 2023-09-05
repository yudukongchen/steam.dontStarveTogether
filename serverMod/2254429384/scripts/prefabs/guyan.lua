local assets =
{
    Asset("ANIM", "anim/guyan.zip"),
    Asset("ANIM", "anim/guyan_sw.zip"),
	Asset("ATLAS", "images/inventoryimages/guyan.xml"),
    Asset("IMAGE", "images/inventoryimages/guyan.tex"),
}


local function onfinished(inst)
    --inst:Remove()
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object","guyan_sw","guyan")
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

	if math.random() < 0.5 then
			 local sword_thud =SpawnPrefab("groundpound_fx")
    sword_thud.entity:SetParent(target.entity)
    sword_thud.Transform:SetPosition(0,0.5,0)
    sword_thud.Transform:SetScale(1.0,1.0,1.0)
    local sword_thud2 =SpawnPrefab("groundpoundring_fx")
    sword_thud2.entity:SetParent(target.entity)
    sword_thud2.Transform:SetPosition(0,0.5,0)
    sword_thud2.Transform:SetScale(0.5,0.5,0.5)
	owner.components.combat.areahitrange=3
			 else
			  owner.components.combat.areahitrange=0
			  
		end
		if not owner:HasTag("wolfgang" )then 
		 owner.components.hunger:DoDelta(-3)
		end
		
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

    inst.AnimState:SetBank("guyan")
    inst.AnimState:SetBuild("guyan")
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
    inst.components.inventoryitem.atlasname = "images/inventoryimages/guyan.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip ) 
	
	inst:AddComponent("trader")
	inst.components.trader.onaccept = OnGetItemFromPlayer
	
    return inst
end

return Prefab("guyan", fn, assets, prefabs)


