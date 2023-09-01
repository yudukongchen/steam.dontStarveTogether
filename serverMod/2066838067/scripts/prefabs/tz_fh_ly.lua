local TzEntity = require("util/tz_entity")
local TzWeaponSkill = require("util/tz_weaponskill")
local TzFh = require("util/tz_fh")

local assets = {
    Asset("ANIM", "anim/tz_fh_ly.zip"),
    Asset("IMAGE", "images/inventoryimages/tz_fh_ly.tex"),
    Asset("ATLAS", "images/inventoryimages/tz_fh_ly.xml"),
    Asset("ATLAS", "images/inventoryimages/tz_fh_ly_black.xml"),
    Asset("ATLAS", "images/inventoryimages/tz_fh_ly_white.xml"),
}

local prefabs = {}

local function onreflectdamagefn(inst, attacker, damage, weapon, stimuli)
    if inst.components.equippable:IsEquipped() and inst.components.inventoryitem.owner ~= nil and attacker then
        local owner = inst.components.inventoryitem.owner
        if  owner and owner.components.fh_ly_gy and owner.components.fh_ly_gy:HasWhite() then
            local weapon  = owner.components.combat:GetWeapon()
            if weapon and weapon.components.weapon then
                --return weapon.components.weapon:GetDamage(attacker, attacker)
                return owner.components.combat:CalcDamage(attacker, weapon)
            end
            return 10
        end
    end
    return 0
end

local function OnEquip(inst,data)
    if data and data.owner and data.owner.components.fh_ly_gy then
        data.owner.components.fh_ly_gy:Start()
    end
end

local function OnUnEquip(inst,data)
    if data.owner and data.owner.components.fh_ly_gy then
        data.owner.components.fh_ly_gy:Stop()
    end
end

return  
    TzEntity.CreateNormalArmor({
    assets = assets,
    prefabname = "tz_fh_ly",
    tags = {"tz_fh_ly","tz_fanhao","hide_percentage"},
    bank = "tz_fh_ly",
    build = "tz_fh_ly",
    anim = "idle",
    armor_data = {
        swapanims = {"tz_fh_ly","swap"},
        equipslot = EQUIPSLOTS.BODY,
    },
    clientfn = function(inst)
        TzFh.AddOwnerName(inst)
        TzFh.AddFhLevel(inst,true)
    end,
    serverfn = function(inst)
        inst._percent_dark_energy = 1.5
        TzFh.AddLibrarySkill(inst,{name = "zhaoye"})
        TzFh.AddLibrarySkill(inst,{name = "anyexingzhe"})
        TzFh.AddLibrarySkill(inst,{name = "shadowstep"})
        TzFh.AddLibrarySkill(inst,{name = "dark_energy"})
        TzFh.MakeWhiteList(inst)

        inst:AddComponent("armor")
        inst.components.armor:InitIndestructible(0.95)

        inst:AddComponent("damagereflect")
        inst.components.damagereflect.reflectdamagefn  = onreflectdamagefn

        inst:ListenForEvent("equipped",OnEquip)
        inst:ListenForEvent("unequipped",OnUnEquip)
    end,
})