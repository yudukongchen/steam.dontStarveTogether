local assets =
{
    Asset("ANIM", "anim/tanyu.zip"),
    Asset("ANIM", "anim/tanyu_sw.zip"),
	Asset("ATLAS", "images/inventoryimages/tanyu.xml"),
    Asset("IMAGE", "images/inventoryimages/tanyu.tex"),
}


local function onfinished(inst)
    inst:Remove()
end

local function onequip(inst, owner) 
    owner.components.combat.areahitrange=3
    owner.AnimState:OverrideSymbol("swap_object","tanyu_sw","tanyu")
	owner.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner) 
    owner.components.combat.areahitrange=nil
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
	local pos = Vector3(target.Transform:GetWorldPosition())
    local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 3)
    for k,v in pairs(ents) do
        if v.components.health  and  not v:HasTag("wall")  then
         owner.components.health:DoDelta(3.4)
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

    inst.AnimState:SetBank("tanyu")
    inst.AnimState:SetBuild("tanyu")
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
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tanyu.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip ) 
    return inst
end

return Prefab("tanyu", fn, assets, prefabs)


