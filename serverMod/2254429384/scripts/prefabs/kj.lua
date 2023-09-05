local assets =
{
    Asset("ANIM", "anim/kj_sw.zip"),
	Asset("ATLAS", "images/inventoryimages/kj.xml"),
    Asset("IMAGE", "images/inventoryimages/kj.tex"),
}

local function OnBlocked(owner) 
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_armour")
end

local function OnAttacked(inst, data) 
    if (data.weapon == nil or (not data.weapon:HasTag("projectile") and data.weapon.projectile == nil))
		and data.attacker and data.attacker.components.combat and data.stimuli ~= "thorns" and not data.attacker:HasTag("thorny")
		and (data.attacker.components.combat == nil or (data.attacker.components.combat.defaultdamage > 0))
        and data.attacker.components.health then
       data.attacker.components.health:DoDelta(-34)
    end
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_body", "kj_sw", "kj_sw")                     
    inst:ListenForEvent("blocked", OnBlocked, owner)
    inst:ListenForEvent("attacked", OnAttacked, owner)
end
    
local function onunequip(inst, owner)  
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst:RemoveEventCallback("blocked", OnBlocked, owner)
	inst:RemoveEventCallback("attacked", OnAttacked, owner)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("kj")
    inst.AnimState:SetBuild("kj_sw")
    inst.AnimState:PlayAnimation("anim")
	
	 inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/kj.xml"  
    
    inst:AddComponent("waterproofer")  
    inst.components.waterproofer:SetEffectiveness(0.2)

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(1350, 0.9)
	
    inst:AddComponent("equippable") 
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY 
    --inst.components.equippable.dapperness = TUNING.DAPPERNESS_LARGE
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
	--inst.components.equippable.walkspeedmult = 1.15
    return inst
end

return Prefab("kj", fn, assets)