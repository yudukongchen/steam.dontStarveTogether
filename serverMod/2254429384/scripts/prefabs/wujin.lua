local assets =
{
    Asset("ANIM", "anim/wujin.zip"),
    Asset("ANIM", "anim/wujin_sw.zip"),
	Asset("ATLAS", "images/inventoryimages/wujin.xml"),
    Asset("IMAGE", "images/inventoryimages/wujin.tex"),
}

local function onfinished(inst)
    inst:Remove()
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object","wujin_sw","wujin_sw")
	owner.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
    end
	
local function onattack(inst, owner, target)
if math.random() < 0.35 then
			 inst.components.weapon:SetDamage(170)
			 else
			  inst.components.weapon:SetDamage(68)
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

    inst.AnimState:SetBank("wujin")
    inst.AnimState:SetBuild("wujin")
    inst.AnimState:PlayAnimation("idle")


    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP, 1)
   
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
    inst.components.inventoryitem.atlasname = "images/inventoryimages/wujin.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip ) 
    return inst
end

return Prefab("wujin", fn, assets, prefabs)


