local assets = {
    Asset("ANIM", "anim/tz_hlmj.zip"),
    Asset("IMAGE", "images/inventoryimages/tz_hlmj.tex"),
    Asset("ATLAS", "images/inventoryimages/tz_hlmj.xml")
}

local prefabs = {}

local function OnAttacked(inst,data)
    if data and data.attacker and not (data.attacker.components.health and data.attacker.components.health:IsDead()) and 
    data.attacker.components.combat and data.attacker.components.combat.target == inst then
        data.attacker.components.combat:DropTarget()
    end
end

local function onunequiphat(inst, owner)
    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAT_HAIR")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAT")
    end
    inst:RemoveEventCallback("attacked", OnAttacked, owner)
end

local function opentop_onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_hat", "tz_hlmj", "swap_hat")
    owner.AnimState:Show("HAT")
    owner.AnimState:Hide("HAT_HAIR")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")

    owner.AnimState:Show("HEAD")
    owner.AnimState:Hide("HEAD_HAIR")

    inst:ListenForEvent("attacked", OnAttacked, owner)
end

local function finished(inst)
    inst:Remove()
end

local function heal(inst)
    if inst.components.armor:GetPercent() < 1 then
        inst.components.armor:SetCondition(inst.components.armor.condition + 0.05)
    end
end

local function fn(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("tz_hlmj")
    inst.AnimState:SetBuild("tz_hlmj")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("hat")
    inst:AddTag("hide")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_hlmj.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnUnequip(onunequiphat)
    inst.components.equippable:SetOnEquip(opentop_onequip)

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(200, 0.8)

    inst:DoPeriodicTask(1,heal,1)

    inst:AddComponent("tradable")

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("tz_hlmj", fn, assets, prefabs)
