local TzEntity = require("util/tz_entity")
local TzFh = require("util/tz_fh")

local assets = {
    Asset("ANIM", "anim/tz_fhgx.zip"),
    Asset("ANIM", "anim/swap_tz_fhgx.zip"),
    Asset("IMAGE", "images/inventoryimages/tz_fhgx.tex"),
    Asset("ATLAS", "images/inventoryimages/tz_fhgx.xml")
}

local function TzFhgxClient(inst)
    TzFh.AddOwnerName(inst)
    TzFh.AddFhLevel(inst,true)
end

local function OnEquip(inst,data)
    if inst.components.fueled ~= nil then
        inst.components.fueled:StartConsuming()
    end

    if data.owner.components.combat then
        data.owner.components.combat.externaldamagetakenmultipliers:SetModifier(inst,0.75,inst.prefab)
    end
end

local function OnUnEquip(inst,data)
    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end

    if data.owner.components.combat then
        data.owner.components.combat.externaldamagetakenmultipliers:RemoveModifier(inst,inst.prefab)
    end
end

local function GetDamageFn(inst,attacker,target)
    local season = TheWorld.state.season
    return 50 * (math.random() <= 0.5 and 2 or 1) * (season == "summer" and 1.2 or 1)
end

local function OnHitOther(owner,data)
    if owner.components.health and not owner.components.health:IsDead() then
        owner.components.health:DoDelta(data.damage * 0.05)
    end
end

local function StimuliFn(inst)
    return TheWorld.state.season == "spring" and "electric" or nil 
end

local function OnAttackFn(inst,attacker,target)
    local season = TheWorld.state.season
    if season == "winter" and target.components.freezable then
        target.components.freezable:AddColdness(1,3)
    end
end

local function OnSeasonChange(inst)
    
    local season = TheWorld.state.season

    inst.components.equippable.walkspeedmult = 1.25

    if season == "spring" then
        
    elseif season == "summer" then

    elseif season == "autumn" then
        inst.components.equippable.walkspeedmult = 1.45
    elseif season == "winter" then

    end
end

local function TzFhgxServer(inst)
    inst.components.equippable.walkspeedmult = 1.25

    inst.components.inventoryitem:EnableMoisture(false)

    inst.components.weapon:SetOverrideStimuliFn(StimuliFn)
    inst.components.weapon:SetOnAttack(OnAttackFn)

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP,5)

    inst:AddComponent("blinkstaff")
    inst.components.blinkstaff:SetFX("sand_puff_large_front", "sand_puff_large_back")

    TzFh.MakeWhiteList(inst)
    
    TzFh.AddFueledComponent(inst)
    

    inst:ListenForEvent("equipped",OnEquip)
    inst:ListenForEvent("unequipped",OnUnEquip)
    inst:WatchWorldState("season",OnSeasonChange)

    OnSeasonChange(inst)
end

return TzEntity.CreateNormalWeapon({
    assets = assets,
    prefabname = "tz_fhgx",
    tags = {"tz_fhgx","tz_fanhao"},
    bank = "tz_fhgx",
    build = "tz_fhgx",
    anim = "idle",

    equippable_data = {
        owner_listeners = {
            {"onhitother",OnHitOther},
        }
    },

    weapon_data = {
        damage = GetDamageFn,
        ranges = 1.2,
    },
    
    clientfn = TzFhgxClient,
    serverfn = TzFhgxServer,
})