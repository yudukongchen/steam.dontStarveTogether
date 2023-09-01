local TzUtil = require("tz_util")
local TzFh = require("util/tz_fh")

local assets = {
    Asset("ANIM", "anim/customanim.zip"),
    Asset("ANIM", "anim/tz_fhspts.zip"),
    Asset("IMAGE", "images/inventoryimages/tz_fhspts.tex"),
    Asset("ATLAS", "images/inventoryimages/tz_fhspts.xml")
}
local prefabs = {
    "tz_thurible_smoke",
    "statue_transition",
}

--change
local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "tz_fhspts", "swap")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if inst.components.fueled ~= nil then
        inst.components.fueled:StartConsuming()
    end
    if owner.components.temperature then
        owner.components.temperature:SetTemp(30)
    end
    if inst._light == nil or not inst._light:IsValid() then
        inst._light = SpawnPrefab("tz_fhspts_light")
    end
    if owner ~= nil then
        inst._light.entity:SetParent(owner.entity)
    end
    if owner.components.combat then
        owner.components.combat.externaldamagetakenmultipliers:SetModifier(inst,0.5)
    end
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    if inst._light ~= nil then
        if inst._light:IsValid() then
            inst._light:Remove()
        end
        inst._light = nil
    end

    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end
    if owner.components.temperature then
        owner.components.temperature:SetTemp(nil)
    end
    if owner.components.combat then
        owner.components.combat.externaldamagetakenmultipliers:RemoveModifier(inst)
    end
end

local function onfinished(inst)
    local spiritualism = SpawnPrefab("tz_spiritualism")
    if spiritualism then
        local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner or nil
        local pt = Vector3(inst.Transform:GetWorldPosition())
        local holder = owner and (owner.components.inventory or owner.components.container)
        local slot = holder and holder:GetItemSlot(inst)
        inst:Remove()
        if holder then
            holder:Equip(spiritualism, slot)
        else
            spiritualism.Transform:SetPosition(pt:Get())
        end
    end
end

local function updatedamage(inst)
    inst.components.weapon:SetDamage(100 +inst.attackdiejia * 6)
end
local function ontakefuel(inst)
    inst.components.fueled:DoDelta(384)
    local owner = inst.components.inventoryitem.owner
    if owner then
        local pos = Vector3(owner.Transform:GetWorldPosition())
        inst.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
        SpawnPrefab("tz_takefuel").Transform:SetPosition(pos.x - 0.1, pos.y - 2.6, pos.z)
    end
end

local function clearlianjifn(inst)
    inst.attackdiejia = 0 
    inst.components.weapon:SetDamage(100)
end
local function onattack(inst, owner, target)
    if inst._attackdiejiatask ~= nil then
        inst._attackdiejiatask:Cancel()
    end
    inst._attackdiejiatask =inst:DoTaskInTime(5, inst.clearlianjifn)

    inst.attackdiejia = math.min(inst.attackdiejia +1 ,6)
    updatedamage(inst)
    if target and target.components.health and target.components.health:IsDead() and math.random() < 0.33 and target.components.lootdropper then
        target.components.lootdropper:SpawnLootPrefab("nightmarefuel")
    end
    if owner.components.health ~= nil and owner.components.health:GetPercent() < 1 and not (target:HasTag("wall") or target:HasTag("engineering")) then
        owner.components.health:DoDelta(1, false, inst.prefab)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("tz_fhspts")
    inst.AnimState:SetBuild("tz_fhspts")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("pointy")
    inst:AddTag("tz_fhspts")
    inst:AddTag("tz_fanhao")

    MakeInventoryFloatable(inst, "med", 0.2, {1.1, 0.5, 1.1})
    inst.entity:SetPristine()

    TzFh.AddOwnerName(inst)
    TzFh.AddFhLevel(inst,true)

    if not TheWorld.ismastersim then
        return inst
    end
    inst.attackdiejia = 0
    inst.clearlianjifn = clearlianjifn

    TzFh.MakeWhiteList(inst)


    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(100)
    inst.components.weapon:SetRange(1.4)
    inst.components.weapon.onattack = onattack

    --inst:AddComponent("named")
    --inst.components.named:SetName("番号审判天使\n眷属：神御座审判长猫猫")

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_fhspts.xml"

    inst:AddComponent("samaequip")
    inst.components.samaequip.equipsama = 3

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.dapperness = 3 / 60
    inst.components.equippable.walkspeedmult = 1.5

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.NIGHTMARE
    inst.components.fueled:InitializeFuelLevel(3840)
    inst.components.fueled:SetDepletedFn(onfinished)
    inst.components.fueled:SetTakeFuelFn(ontakefuel)
    inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)
    inst.components.fueled.accepting = true ---0.5					--1/60

    MakeHauntableLaunch(inst)

    return inst
end

local function lightfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.Light:SetFalloff(0.9)
    inst.Light:SetIntensity(.6)
    inst.Light:SetRadius(5)
    inst.Light:SetColour(180 / 255, 195 / 255, 150 / 255)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

return Prefab("tz_fhspts", fn, assets, prefabs),Prefab("tz_fhspts_light", lightfn)
