local assets =
{
    Asset("ANIM", "anim/xuese.zip"),
    Asset("ANIM", "anim/xuese_sw.zip"),
	Asset("ATLAS", "images/inventoryimages/xuese.xml"),
    Asset("IMAGE", "images/inventoryimages/xuese.tex"),
}

local function onfinished(inst)
    inst:Remove()
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object","xuese_sw","xuese_sw")
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
		   inst.components.weapon.damage =  inst.components.weapon.damage + 51
		   inst.components.weapon.damage =  inst.components.weapon.damage + 51
		   inst:RemoveTag("yuse")
		   inst.components.lengliang.lengliang = 15
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

    inst.AnimState:SetBank("xuese")
    inst.AnimState:SetBuild("xuese")
    inst.AnimState:PlayAnimation("idle")


    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP, 1)
   
    inst:AddTag("sharp")
	
	inst:AddTag("yuse")
	
	inst:DoPeriodicTask(1, function()
	if inst.components.lengliang.lengliang < 0 then
	inst:AddTag("yuse")
	inst.components.lengliang.lengliang = 0
	end
	inst.components.lengliang.lengliang = inst.components.lengliang.lengliang - 1
	if inst:HasTag("yuse") then
	inst.components.weapon.damage =51
	end
	end)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(51)
	inst.components.weapon.onattack = onattack
    inst.components.weapon:SetRange(0)

    inst:AddComponent("inspectable")
	
	inst:AddComponent("lengliang")
    inst.components.lengliang.lengliang=15

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(600)
    inst.components.finiteuses:SetUses(600)   
    inst.components.finiteuses:SetOnFinished( onfinished )
    inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 1)
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/xuese.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip ) 
    return inst
end

return Prefab("xuese", fn, assets, prefabs)


