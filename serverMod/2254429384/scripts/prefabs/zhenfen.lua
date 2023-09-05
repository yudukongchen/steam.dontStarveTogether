local assets =
{
    Asset("ANIM", "anim/zhenfen_sw.zip"),
	Asset("ATLAS", "images/inventoryimages/zhenfen.xml"),
    Asset("IMAGE", "images/inventoryimages/zhenfen.tex"),
}

local function OnBlocked(owner, data) 
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_armour")
end

local function healowner(inst, owner)
    if (owner.components.health and owner.components.health:IsHurt() and not owner.components.oldager)
    and owner.components.hunger then
	if TUNING.HEALTHDODELTA == 1 then 
        owner.components.health:DoDelta(TUNING.REDAMULET_CONVERSION,false,"redamulet")
		elseif TUNING.HEALTHDODELTA == 0 then 
		 owner.components.health:DoDelta(TUNING.REDAMULET_CONVERSION*2,false,"redamulet")
		end
    end
end

local function onequip(inst, owner) 
	owner.AnimState:OverrideSymbol("swap_body", "zhenfen_sw", "zhenfen")						
    inst:ListenForEvent("blocked", OnBlocked, owner)
	if inst.task == nil then 
	inst.task = inst:DoPeriodicTask(30, healowner, nil, owner)
	end 
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst:RemoveEventCallback("blocked", OnBlocked, owner)
	if inst.task ~= nil then
        inst.task:Cancel()
        inst.task = nil
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
 inst.AnimState:SetBank("zhenfen") 
    inst.AnimState:SetBuild("zhenfen_sw") 
    inst.AnimState:PlayAnimation("anim")	

    inst:AddTag("wood")
    inst.task = nil 
    inst:AddComponent("inspectable") 

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/zhenfen.xml"  
    
	inst:AddComponent("waterproofer") 
    inst.components.waterproofer:SetEffectiveness(0.2)
    
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(1350,0.9) 

    inst:AddComponent("equippable") 
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY 

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    return inst
end

return Prefab("zhenfen", fn, assets, prefabs)


