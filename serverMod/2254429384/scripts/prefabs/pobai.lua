local assets =
{
    Asset("ANIM", "anim/pobai.zip"),
    Asset("ANIM", "anim/pobai_sw.zip"),
	Asset("ATLAS", "images/inventoryimages/pobai.xml"),
    Asset("IMAGE", "images/inventoryimages/pobai.tex"),
}

local function onfinished(inst)
    inst:Remove()
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object","pobai_sw","pobai")
	owner.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
    end
	
local function onattack(inst, owner, target)
local delta =  target.components.health.currenthealth*0.01
if inst.components.lengliang.lengliang < 3 then 
inst.components.lengliang.lengliang  =  inst.components.lengliang.lengliang+1
else
      owner.components.locomotor.walkspeed =  owner.components.locomotor.walkspeed+1
      owner.components.locomotor.runspeed =  owner.components.locomotor.runspeed+1.5
        owner:DoTaskInTime( 2, function()
        owner.components.locomotor.walkspeed =  owner.components.locomotor.walkspeed-1
		owner.components.locomotor.runspeed =  owner.components.locomotor.runspeed-1.5
		end)
target.components.health:DoDelta(-delta)
owner.components.health:DoDelta(5.1+delta*0.1)
inst.components.lengliang.lengliang  =  1
end
target.components.health:DoDelta(-delta)
 if owner.components.health and not target:HasTag("wall") then
 owner.components.health:DoDelta(5.1+delta*0.1)
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

    inst.AnimState:SetBank("pobai")
    inst.AnimState:SetBuild("pobai")
    inst.AnimState:PlayAnimation("idle")


    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP, 1)
   
    inst:AddTag("sharp")

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(51)
	inst.components.weapon.onattack = onattack
    inst.components.weapon:SetRange(1,2)
	
	inst:AddComponent("lengliang")
    inst.components.lengliang.lengliang=1

    inst:AddComponent("inspectable")

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(600)
    inst.components.finiteuses:SetUses(600)   
    inst.components.finiteuses:SetOnFinished( onfinished )
    inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 1)
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/pobai.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip ) 
    return inst
end

return Prefab("pobai", fn, assets, prefabs)


