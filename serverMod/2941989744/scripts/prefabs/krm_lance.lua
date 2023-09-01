local assets =
{
    Asset("ANIM", "anim/krm_lance.zip"),
    Asset("ATLAS", "images/inventoryimages/krm_lance.xml"),
}
RegisterInventoryItemAtlas("images/inventoryimages/krm_lance.xml", "krm_lance.tex")
local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "krm_lance", "swap")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function Lunge(inst, doer, pos)
    if not pos then
        return
    end
    inst.components.rechargeable:Discharge(5)
    doer:PushEvent("jump_gogogo", {targetpos = pos, weapon = inst})
end

local function OnCharged(inst)
    inst.components.jump_spell.canuse = true
end

local function OnDischarged(inst)
	inst.components.jump_spell.canuse = false
end

local function canuseininventory_krm(inst,doer,right)
    return inst.replica.equippable ~= nil and
        inst.replica.equippable:IsEquipped() and
        doer.replica.inventory ~= nil and
        doer.replica.inventory:IsOpenedBy(doer) and
        not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding()) 
end

local function IsTauntable(inst, target)
    return not (target.components.health ~= nil and target.components.health:IsDead())
        and target.components.combat ~= nil
        and not target.components.combat:TargetIs(inst)
        and target.components.combat:CanTarget(inst)
        --[[and (   target:HasTag("shadowcreature") or
                (   target.components.combat:HasTarget() and
                    (   target.components.combat.target:HasTag("player") or
                        (target.components.combat.target:HasTag("companion") and target.components.combat.target.prefab ~= inst.prefab)
                    )
                )
            )]]
end
local TAUNT_MUST_TAGS = { "_combat", "locomotor" }
local TAUNT_CANT_TAGS = { "INLIMBO", "player", "companion", "notaunt" }
local function TauntCreatures(inst)
    if not inst.components.health:IsDead() then
        local x, y, z = inst.Transform:GetWorldPosition()
        for i, v in ipairs(TheSim:FindEntities(x, y, z, 32, TAUNT_MUST_TAGS, TAUNT_CANT_TAGS)) do
            if IsTauntable(inst, v) then
                v.components.combat:SetTarget(inst)
            end
        end
    end
end
local function onuse(inst, doer)
    TauntCreatures(doer)
    --doer.components.talker:Say("八嘎！来打我啊！")
    return true
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("krm_lance")
    inst.AnimState:SetBuild("krm_lance")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("pointy")
    inst:AddTag("weapon")

    inst.KRM_USE_TYPE = "ZHAOJIA"
    inst.onusesgname_client = "parry_pre"
    inst.onusesgname = "krm_parry_pre"
    inst.canuseininventory_krm = canuseininventory_krm

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(100)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("jump_spell")
    inst.components.jump_spell = inst.components.jump_spell
    inst.components.jump_spell:SetSpellFn(Lunge)

    inst:AddComponent("rechargeable")
	inst.components.rechargeable:SetOnDischargedFn(OnDischarged)
	inst.components.rechargeable:SetOnChargedFn(OnCharged)

    inst:AddComponent("krm_use_inventory")
    inst.components.krm_use_inventory.onusefn = onuse

    inst:AddComponent("krm_rake")

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("krm_lance", fn, assets)