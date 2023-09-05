local assets =
{
    Asset("ANIM", "anim/gouya.zip"),
    Asset("ANIM", "anim/gouya_sw.zip"),
	Asset("ATLAS", "images/inventoryimages/gouya.xml"),
    Asset("IMAGE", "images/inventoryimages/gouya.tex"),
}


local function onfinished(inst)
    inst:Remove()
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object","gouya_sw","gouya")
	owner.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
    end
	
local function onattack(inst, owner, target)
target:AddTag("liuxue")
	if target:HasTag("liuxue") and not  target:HasTag("liuxue2")then
 target:DoPeriodicTask(1, function() target.components.health:DoDelta(-10) end)	
	end
	target:AddTag("liuxue2")
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

    inst.AnimState:SetBank("gouya")
    inst.AnimState:SetBuild("gouya")
    inst.AnimState:PlayAnimation("idle")


    inst:AddComponent("tool")
  inst.components.tool:SetAction(ACTIONS.CHOP, 2)
   
    inst:AddTag("sharp")
	
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(68)
	inst.components.weapon.onattack = onattack
    inst.components.weapon:SetRange(0)

    inst:AddComponent("inspectable")

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(600)
    inst.components.finiteuses:SetUses(600)   
    inst.components.finiteuses:SetOnFinished( onfinished )
	inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 1)
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/gouya.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip ) 
    return inst
end

return Prefab("gouya", fn, assets, prefabs)


