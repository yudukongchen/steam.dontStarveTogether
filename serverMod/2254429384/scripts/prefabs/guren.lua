local assets =
{
   Asset("ANIM", "anim/guren.zip"),
    Asset("ANIM", "anim/guren_sw.zip"),
	Asset("ATLAS", "images/inventoryimages/guren.xml"),
    Asset("IMAGE", "images/inventoryimages/guren.tex"),
}


local function onfinished(inst)
    inst:Remove()
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object","guren_sw","guren")
	owner.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
    end
	
local function onattack(inst, owner, target)
if target.components.health:IsDead() then
local heatxt = target.components.health.maxhealth/50
if inst.components.finiteuses.current < 600 then
	inst.components.finiteuses.current = inst.components.finiteuses.current + heatxt
	if inst.components.finiteuses.current > 600 then
	inst.components.finiteuses.current = 600
	end
	end
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

     inst.AnimState:SetBank("guren")
    inst.AnimState:SetBuild("guren")
    inst.AnimState:PlayAnimation("idle")


    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP, 2)
	
    inst:AddTag("sharp")
	
    inst:AddComponent("weapon")
	inst.components.weapon:SetOnAttack(onattack)
    inst.components.weapon:SetDamage(68)
    inst.components.weapon:SetRange(1,2)

    inst:AddComponent("inspectable")

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(600)
    inst.components.finiteuses:SetUses(600)   
    inst.components.finiteuses:SetOnFinished( onfinished )
    inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 1)
	
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/guren.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip ) 
    return inst
end

return Prefab("guren", fn, assets, prefabs)


