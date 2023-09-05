local assets =
{
    Asset("ANIM", "anim/tymt.zip"),
    Asset("ANIM", "anim/tymt_sw.zip"),
	Asset("ATLAS", "images/inventoryimages/tymt.xml"),
    Asset("IMAGE", "images/inventoryimages/tymt.tex"),
}


local function onfinished(inst)
    inst:Remove()
end

local function onequip(inst, owner) 
    owner.components.combat.areahitrange=3
    owner.AnimState:OverrideSymbol("swap_object","tymt_sw","tymt")
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
 local sword_thud =SpawnPrefab("groundpound_fx")
    sword_thud.entity:SetParent(target.entity)
    sword_thud.Transform:SetPosition(0,0.5,0)
    sword_thud.Transform:SetScale(1.0,1.0,1.0)
    local sword_thud2 =SpawnPrefab("groundpoundring_fx")
    sword_thud2.entity:SetParent(target.entity)
    sword_thud2.Transform:SetPosition(0,0.5,0)
    sword_thud2.Transform:SetScale(0.5,0.5,0.5)
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

    inst.AnimState:SetBank("tymt")
    inst.AnimState:SetBuild("tymt")
    inst.AnimState:PlayAnimation("idle")


    inst:AddComponent("tool")
  inst.components.tool:SetAction(ACTIONS.CHOP, 1)
   
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
	inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 1)
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tymt.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip ) 
    return inst
end

return Prefab("tymt", fn, assets, prefabs)


