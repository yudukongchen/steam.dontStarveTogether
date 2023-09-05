local assets =
{
    Asset("ANIM", "anim/suozi_sw.zip"),
	Asset("ATLAS", "images/inventoryimages/suozi.xml"),
    Asset("IMAGE", "images/inventoryimages/suozi.tex"),
}

local function OnBlocked(owner, data) 
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_armour")
end
local function onequip(inst, owner) 
	owner.AnimState:OverrideSymbol("swap_body", "suozi_sw", "suozi")						
    inst:ListenForEvent("blocked", OnBlocked, owner)
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst:RemoveEventCallback("blocked", OnBlocked, owner)
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

     inst.AnimState:SetBank("suozi") 
    inst.AnimState:SetBuild("suozi_sw") 
    inst.AnimState:PlayAnimation("anim")	

    inst:AddTag("wood")

    --inst.foleysound = "dontstarve/movement/foley/logarmour"

    --inst.entity:SetPristine()

    inst:AddComponent("inspectable") 

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/suozi.xml"  
    
	inst:AddComponent("waterproofer") 
    inst.components.waterproofer:SetEffectiveness(0.2)
    
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(900,0.85) 
    --inst.components.armor:AddWeakness("beaver", TUNING.BEAVER_WOOD_DAMAGE)

    inst:AddComponent("equippable") 
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY 

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    return inst
end

return Prefab("suozi", fn, assets, prefabs)


