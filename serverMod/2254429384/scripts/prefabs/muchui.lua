local assets =
{
    Asset("ANIM", "anim/muchui.zip"),
    Asset("ANIM", "anim/muchui_sw.zip"),
	Asset("ATLAS", "images/inventoryimages/muchui.xml"),
    Asset("IMAGE", "images/inventoryimages/muchui.tex"),
}

local function onfinished(inst)
    inst:Remove()
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object","muchui_sw","muchui_sw")
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
		   owner.components.locomotor.walkspeed =  owner.components.locomotor.walkspeed+2
              owner.components.locomotor.runspeed =  owner.components.locomotor.runspeed+2
			   owner:DoTaskInTime( 2, function()
        owner.components.locomotor.walkspeed =  owner.components.locomotor.walkspeed-2
	owner.components.locomotor.runspeed =  owner.components.locomotor.runspeed-2
	 end)
	 else
	  owner.components.locomotor.walkspeed =  owner.components.locomotor.walkspeed+1
      owner.components.locomotor.runspeed =  owner.components.locomotor.runspeed+1
        owner:DoTaskInTime( 2, function()
        owner.components.locomotor.walkspeed =  owner.components.locomotor.walkspeed-1
		owner.components.locomotor.runspeed =  owner.components.locomotor.runspeed-1
		end)
			  end
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

    inst.AnimState:SetBank("muchui")
    inst.AnimState:SetBuild("muchui")
    inst.AnimState:PlayAnimation("idle")


    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.HAMMER, 1)
   
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
    inst.components.finiteuses:SetConsumption(ACTIONS.HAMMER, 1)
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/muchui.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip ) 
    return inst
end

return Prefab("muchui", fn, assets, prefabs)


