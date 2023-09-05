local assets =
{
    Asset("ANIM", "anim/zhufeng.zip"),
    Asset("ANIM", "anim/zhufeng_sw.zip"),
	Asset("ATLAS", "images/inventoryimages/zhufeng.xml"),
    Asset("IMAGE", "images/inventoryimages/zhufeng.tex"),
}

local function onfinished(inst)
    inst:Remove()
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object","zhufeng_sw","zhufeng")
	owner.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
    end
	
local function onattack(inst, owner, target)
if  target.components.health.currenthealth <= 0 then
		   owner.components.locomotor.walkspeed =  owner.components.locomotor.walkspeed+0.6
              owner.components.locomotor.runspeed =  owner.components.locomotor.runspeed+0.6
			   owner:DoTaskInTime( 10, function()
        owner.components.locomotor.walkspeed =  owner.components.locomotor.walkspeed-0.6
	owner.components.locomotor.runspeed =  owner.components.locomotor.runspeed-0.6
	 end)
	 else
	  owner.components.locomotor.walkspeed =  owner.components.locomotor.walkspeed+0.4
      owner.components.locomotor.runspeed =  owner.components.locomotor.runspeed+0.4
        owner:DoTaskInTime( 10, function()
        owner.components.locomotor.walkspeed =  owner.components.locomotor.walkspeed-0.4
		owner.components.locomotor.runspeed =  owner.components.locomotor.runspeed-0.4
		end)
			  end
	end
	
	local function OnGetItemFromPlayer(inst, giver, item, player)
    
	local currentperc = inst.components.finiteuses:GetPercent()
		if item.prefab == "feather_canary" then
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

    inst.AnimState:SetBank("zhufeng")
    inst.AnimState:SetBuild("zhufeng")
    inst.AnimState:PlayAnimation("idle")
	
    inst:AddTag("sharp")

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(42.5)
	inst.components.weapon.onattack = onattack
    inst.components.weapon:SetRange(0)

    inst:AddComponent("inspectable")

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(300)
    inst.components.finiteuses:SetUses(300)   
    inst.components.finiteuses:SetOnFinished( onfinished )
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/zhufeng.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip ) 
	
	inst:AddComponent("trader")
	inst.components.trader.onaccept = OnGetItemFromPlayer
	
    return inst
end

return Prefab("zhufeng", fn, assets, prefabs)


