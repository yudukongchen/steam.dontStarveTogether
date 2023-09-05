local assets =
{
    Asset("ANIM", "anim/bingxin_sw.zip"),
	Asset("ATLAS", "images/inventoryimages/bingxin.xml"),
    Asset("IMAGE", "images/inventoryimages/bingxin.tex"),
}

local function OnBlocked(owner, data) 
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_armour")
end

local function onequip(inst, owner) 
	owner.AnimState:OverrideSymbol("swap_body", "bingxin_sw", "bingxin")						
    inst:ListenForEvent("blocked", OnBlocked, owner)
	 inst.freezefn = function(attacked, data)
        if data and data.attacker and data.attacker.components.freezable then
            data.attacker.components.freezable:AddColdness(1)
            data.attacker.components.freezable:SpawnShatterFX()
        end 
    end

    inst:ListenForEvent("attacked", inst.freezefn, owner)
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst:RemoveEventCallback("blocked", OnBlocked, owner)
	inst:RemoveEventCallback("attacked", inst.freezefn, owner)
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

     inst.AnimState:SetBank("bingxin") 
    inst.AnimState:SetBuild("bingxin_sw") 
    inst.AnimState:PlayAnimation("anim")	

    inst:AddComponent("heater")
    inst.components.heater:SetThermics(false, true)
    inst.components.heater.equippedheat = -20

    inst:AddComponent("inspectable") 

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/bingxin.xml"  
    
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

return Prefab("bingxin", fn, assets, prefabs)


