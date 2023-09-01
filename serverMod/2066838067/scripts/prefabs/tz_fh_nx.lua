local TzEntity = require("util/tz_entity")
local TzWeaponSkill = require("util/tz_weaponskill")
local TzFh = require("util/tz_fh")

local assets = {
    Asset("ANIM", "anim/tz_fh_nx.zip"),
    Asset("ANIM", "anim/ui_fh_nx_7x7.zip"),
    Asset("IMAGE", "images/inventoryimages/tz_fh_nx.tex"),
    Asset("ATLAS", "images/inventoryimages/tz_fh_nx.xml"),
}

local prefabs = {}

local function OnEquip(inst,data)
    if data and data.owner and data.owner.components.combat and TheWorld.state.phase == "night" then
        data.owner.components.combat.externaldamagemultipliers:SetModifier(inst, 1.25)
    end
end

local function OnUnEquip(inst,data)
    if data.owner and data.owner.components.combat then
        data.owner.components.combat.externaldamagemultipliers:RemoveModifier(inst)
    end
end

local function UpdateSpeed(inst,phase)
    local owner = inst.components.equippable:IsEquipped() and inst.components.inventoryitem.owner ~= nil and inst.components.inventoryitem.owner or nil
    if phase == "night" then
        inst.components.equippable.walkspeedmult = 1.25
        if owner and owner.components.combat then
            owner.components.combat.externaldamagemultipliers:SetModifier(inst, 1.25)
        end
    else
        inst.components.equippable.walkspeedmult = 1
        if owner and owner.components.combat then
            owner.components.combat.externaldamagemultipliers:RemoveModifier(inst)
        end
    end
end

local SHIELD_DURATION = 10 * FRAMES
local SHIELD_VARIATIONS = 3
local MAIN_SHIELD_CD = 1.2

local RESISTANCES =
{
    "_combat",
    "explosive",
    "quakedebris",
    "caveindebris",
    "trapdamage",
}

for j = 0, 3, 3 do
    for i = 1, SHIELD_VARIATIONS do
        table.insert(prefabs, "shadow_shield"..tostring(j + i))
    end
end

local function PickShield(inst)
    local t = GetTime()
    local flipoffset = math.random() < .5 and SHIELD_VARIATIONS or 0

    local dt = t - inst.lastmainshield
    if dt >= MAIN_SHIELD_CD then
        inst.lastmainshield = t
        return flipoffset + 3
    end

    local rnd = math.random()
    if rnd < dt / MAIN_SHIELD_CD then
        inst.lastmainshield = t
        return flipoffset + 3
    end

    return flipoffset + (rnd < dt / (MAIN_SHIELD_CD * 2) + .5 and 2 or 1)
end


local function OnShieldOver(inst, OnResistDamage)
    inst.task = nil
end

local function OnResistDamage(inst, damage)		
    local owner = inst.components.inventoryitem:GetGrandOwner() or inst
    local fx = SpawnPrefab("shadow_shield" .. tostring(PickShield(inst)))
    fx.entity:SetParent(owner.entity)
    if inst.task ~= nil then
        inst.task:Cancel()
    end
    inst.task = inst:DoTaskInTime(SHIELD_DURATION, OnShieldOver)
    inst.components.rechargeable:Discharge(15)
end

local function ShouldResistFn(inst)
    if not inst.components.equippable:IsEquipped() then
        return false
    end
	if inst.task then
		return true
	end
	if not inst.components.rechargeable:IsCharged() then
		return false
	end
    local owner = inst.components.inventoryitem.owner
    return owner ~= nil
end

return  
    TzEntity.CreateNormalArmor({
    assets = assets,
    prefabname = "tz_fh_nx",
    tags = {"rechargeable","tz_fh_nx","tz_fanhao"},
    bank = "tz_fh_nx",
    build = "tz_fh_nx",
    anim = "idle",
    armor_data = {
        swapanims = {"tz_fh_nx","swap"},
        equipslot = EQUIPSLOTS.BACK or EQUIPSLOTS.BODY,
    },
    clientfn = function(inst)
        TzFh.AddOwnerName(inst)
        TzFh.AddFhLevel(inst,true)
    end,
    serverfn = function(inst)
        TzFh.AddLibrarySkill(inst,{name = "yingci"})
        TzFh.AddLibrarySkill(inst,{name = "anyexingzhe"})
        TzFh.MakeWhiteList(inst)
        inst.lastmainshield = 0
        inst:AddComponent("container")
        inst.components.container:WidgetSetup("tz_fh_nx")
        inst.components.container.skipclosesnd = true
        inst.components.container.skipopensnd = true

        inst:WatchWorldState("phase", UpdateSpeed)
        UpdateSpeed(inst, TheWorld.state.phase)
        
        inst:AddComponent("preserver")
        inst.components.preserver:SetPerishRateMultiplier(0)

        inst:ListenForEvent("equipped",OnEquip)
        inst:ListenForEvent("unequipped",OnUnEquip)

        inst:AddComponent("rechargeable")

        inst:AddComponent("resistance")
		for i, v in ipairs(RESISTANCES) do
			inst.components.resistance:AddResistance(v)
		end
        inst.components.resistance:SetShouldResistFn(ShouldResistFn)
        inst.components.resistance:SetOnResistDamageFn(OnResistDamage)
    end,
})