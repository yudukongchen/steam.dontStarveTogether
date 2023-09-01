local TzEntity = require("util/tz_entity")
local TzWeaponSkill = require("util/tz_weaponskill")
local TzFh = require("util/tz_fh")

local assets = {
    Asset("ANIM", "anim/tz_fh_xhws.zip"),
    Asset("IMAGE", "images/inventoryimages/tz_fh_xhws.tex"),
    Asset("ATLAS", "images/inventoryimages/tz_fh_xhws.xml")
}
local function TakeFuelItem(self,item, doer)
    if self:CanAcceptFuelItem(item) then
        local wetmult = item:GetIsWet() and TUNING.WET_FUEL_PENALTY or 1
        local masterymult = doer ~= nil and doer.components.fuelmaster ~= nil and doer.components.fuelmaster:GetBonusMult(item, self.inst) or 1
        self:DoDelta(50 * self.bonusmult * wetmult * masterymult, doer)
        if doer and doer:HasTag("player") then
            local pos = doer:GetPosition()
            SpawnAt("tz_takefuel",pos + Vector3(-0.1,-2.6,0))
        end
        self.inst.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
        item:Remove()
        self.inst:PushEvent("takefuel", { fuelvalue = 50 })
        return true
    end
end

local function OnEquip(inst,data)
    if data and data.owner then
        data.owner.AnimState:OverrideSymbol("swap_object", "tz_fh_xhws", inst.type)
    end
end
local function OnAttack(inst, owner, target)
    if inst.type == "xh" and owner.components.health ~= nil and owner.components.health:GetPercent() < 1 and not (target:HasTag("wall") or target:HasTag("engineering")) then
        owner.components.health:DoDelta(1, false)
    elseif inst.type == "ws" and owner.components.sanity ~= nil and owner.components.sanity:GetPercent() < 1 then
        owner.components.sanity:DoDelta(1)
        if target:IsValid() and not (target.components.health and target.components.health:IsDead()) then
            if target.components.freezable ~= nil then
                target.components.freezable:AddColdness(1)
                target.components.freezable:SpawnShatterFX()
            end
        end
    end
    inst.components.fueled:DoDelta(-1)
end

local function SetType(inst)
    if inst.type == "xh" then
        inst:RemoveTag("goggles")
        inst:RemoveTag("tz_heat_resistant")
        inst:AddTag("tz_cold_resistant")
        inst.components.waterproofer:SetEffectiveness(1)
        inst.components.weapon:SetDamage(100)	
    else
        inst:AddTag("goggles")
        inst:AddTag("tz_heat_resistant")
        inst:RemoveTag("tz_cold_resistant")
        inst.components.weapon:SetDamage(50)	
        inst.components.waterproofer:SetEffectiveness(0)
    end
end
local function OnSave(inst,data)
    data.type = inst.type
end

local function OnLoad(inst,data)
    if data ~= nil then
        if data.type ~= nil then
            inst.type = data.type
            SetType(inst)
        end
    end
end

local function onuse(inst,doer,load)
    local owner = inst.components.inventoryitem.owner
    if owner then
        inst.type =  inst.type == "xh" and "ws" or "xh"
        SetType(inst)
        if owner.AnimState then
            owner.AnimState:OverrideSymbol("swap_object", "tz_fh_xhws", inst.type)
        end
        if owner.tz_gogglevision then
            owner.tz_gogglevision:set_local(false)
            owner.tz_gogglevision:set(true)
        end
    end
    return false
end

return TzEntity.CreateNormalWeapon({
    assets = assets,
    prefabname = "tz_fh_xhws",
    tags = {"tz_fh_xhws","tz_fanhao","waterproofer"},
    bank = "tz_fh_xhws",
    build = "tz_fh_xhws",
    anim = "idle",

    weapon_data = {
        -- However,the damage delt by this weapon is pierce damage
        -- So do this in another way....
        swapanims = {"tz_fh_xhws","xh"},
        damage = 50,
        ranges = 14,
    },
    
    clientfn = function(inst)
        TzFh.AddFhLevel(inst,true)
        TzFh.AddOwnerName(inst)
    end,
    serverfn = function(inst)

        inst.type = "xh"
        inst.OnSave = OnSave 
        inst.OnLoad = OnLoad
        TzFh.MakeWhiteList(inst)
        TzFh.AddFueledComponent(inst,{
            max = 5000,
        })

        inst:AddComponent("waterproofer")

        inst.components.fueled.TakeFuelItem = TakeFuelItem
        TzFh.SetReturnSpiritualism(inst)
            
        -- night explosion
        inst.explosion_fn = TzFh.SKILL_LIBIARY.night_explosion.on_attack_fn_wrapper(3,
            { "INLIMBO", "notarget", "noattack", "flight", "invisible", "playerghost","wall","structure" }
        )
        inst.components.weapon:SetOnAttack(function(inst,owner,target)
            inst.explosion_fn(inst,owner,target)
            OnAttack(inst, owner, target)
        end)

        --猎杀天性 每生存10天，攻击力+0.5，上限50
        local olddamage = inst.components.weapon.GetDamage
        inst.components.weapon.GetDamage = function(self,attacker,...)
            local damage = olddamage(self,attacker,...)
            if attacker and attacker.components.age then
                local days = math.floor(attacker.components.age:GetAgeInDays()/10)
                damage = damage + math.min(days*0.5,50)
            end
            return damage
        end

        inst:AddComponent("useableitem")
        inst.components.useableitem:SetOnUseFn(onuse)

        TzFh.AddLibrarySkill(inst,{name = "shadowstep"})
        TzFh.AddLibrarySkill(inst,{name = "zhaoye"})
        TzFh.AddLibrarySkill(inst,{name = "shadow_ball"})
        SetType(inst)
        inst:ListenForEvent("equipped",OnEquip)
    end,
})