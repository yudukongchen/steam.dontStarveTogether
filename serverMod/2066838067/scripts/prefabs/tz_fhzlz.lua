local TzUtil = require("tz_util")
local TzFh = require("util/tz_fh")
local TzWeaponSkill = require("util/tz_weaponskill")

local assets = {
    Asset("ANIM", "anim/customanim.zip"),
    Asset("ANIM", "anim/tz_fhzlz.zip"),
    Asset("IMAGE", "images/inventoryimages/tz_fhzlz.tex"),
    Asset("ATLAS", "images/inventoryimages/tz_fhzlz.xml")
}
local prefabs = {
    "tz_thurible_smoke",
    "statue_transition",
}

--change
local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "tz_fhzlz", "swap")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if inst.components.fueled ~= nil then
        inst.components.fueled:StartConsuming()
    end

    if inst._light == nil or not inst._light:IsValid() then
        inst._light = SpawnPrefab("tz_fhzlz_light")
    end
    if owner ~= nil then
        inst._light.entity:SetParent(owner.entity)
    end

    inst:ListenForEvent("attacked", inst._onattacked, owner)

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

    inst:RemoveEventCallback("attacked", inst._onattacked, owner)

    if owner.components.combat then
        owner.components.combat.externaldamagetakenmultipliers:RemoveModifier(inst)
    end
end

local function onfinished(inst)
    inst:Remove()
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


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("tz_fhzlz")
    inst.AnimState:SetBuild("tz_fhzlz")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("pointy")
    inst:AddTag("tz_fhzlz")
    inst:AddTag("waterproofer")
    inst:AddTag("tool")
    inst:AddTag("tz_fanhao")

    MakeInventoryFloatable(inst, "med", 0.2, {1.1, 0.5, 1.1})


    TzWeaponSkill.AddAoetargetingClient(inst,"line",nil,12)

    TzFh.AddOwnerName(inst)
    TzFh.AddFhLevel(inst,true)
    
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    TzFh.MakeWhiteList(inst)

    TzWeaponSkill.AddAoetargetingServer(inst,function()
        inst.components.rechargeable:Discharge(3)
    end,nil,nil)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(60)
    inst.components.weapon:SetRange(15)
    inst.components.weapon:SetProjectile("tz_projectile_fhzlz")
    inst.components.weapon.heightoffset = 1

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_ABSOLUTE)
    
    --inst:AddComponent("named")
    --inst.components.named:SetName("番号再临者\n眷属：沐还是云?")

    inst:AddComponent("inspectable")

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP, 1.33)
    inst.components.tool:SetAction(ACTIONS.MINE, 1.33)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_fhzlz.xml"

    inst:AddComponent("samaequip")
    inst.components.samaequip.equipsama = 3

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    --inst.components.equippable.dapperness = 3 / 60
    inst.components.equippable.walkspeedmult = 1.25
    inst.components.equippable.insulated = true

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.NIGHTMARE
    inst.components.fueled:InitializeFuelLevel(3840)
    inst.components.fueled:SetDepletedFn(onfinished)
    inst.components.fueled:SetTakeFuelFn(ontakefuel)
    inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)
    inst.components.fueled.accepting = true ---0.5					--1/60

    inst._onattacked = function(owner,data)
        if data.attacker and data.attacker:IsValid()  and data.attacker.components.combat
            and data.attacker.components.health and not data.attacker.components.health:IsDead() then
                data.attacker.components.combat:GetAttacked(owner,60,nil)
        end
    end
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

return Prefab("tz_fhzlz", fn, assets, prefabs),Prefab("tz_fhzlz_light", lightfn)
