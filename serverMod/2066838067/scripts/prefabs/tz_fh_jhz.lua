local TzEntity = require("util/tz_entity")
local TzWeaponSkill = require("util/tz_weaponskill")
local TzFh = require("util/tz_fh")

local assets = {
    Asset("ANIM", "anim/tz_fh_jhz.zip"),
    Asset("IMAGE", "images/inventoryimages/tz_fh_jhz.tex"),
    Asset("ATLAS", "images/inventoryimages/tz_fh_jhz.xml")
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
    if inst.components.fueled ~= nil then
        inst.components.fueled:StartConsuming()
    end
end

local function OnUnEquip(inst,data)
    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end
end

local function OnAttack(inst, attacker, target)
    if target and target.components.health and target.components.health:IsDead() then
        local adddamage = target.components.health.maxhealth >= 2000 and 2 or 0.2
        inst.adddamage = math.min(100,inst.adddamage +adddamage)
        inst.components.weapon:SetDamage(50+inst.adddamage)	
    end
end

local function OnSave(inst,data)
    data.adddamage = inst.adddamage
end

local function OnLoad(inst,data)
    if data ~= nil then
        if data.adddamage ~= nil then
            inst.adddamage = data.adddamage
            inst.components.weapon:SetDamage(50+inst.adddamage)	
        end
    end
end

return TzEntity.CreateNormalWeapon({
    assets = assets,
    prefabname = "tz_fh_jhz",
    tags = {"tz_fh_jhz","tz_fanhao"},
    bank = "tz_fh_jhz",
    build = "tz_fh_jhz",
    anim = "idle",

    weapon_data = {
        -- However,the damage delt by this weapon is pierce damage
        -- So do this in another way....
        swapanims = {"tz_fh_jhz","swap"},
        damage = 50,
        ranges = 14,
    },
    
    clientfn = function(inst)
        TzFh.AddFhLevel(inst,true)
        TzFh.AddOwnerName(inst)
    end,
    serverfn = function(inst)

        inst.adddamage = 0
        inst.OnSave = OnSave 
        inst.OnLoad = OnLoad
        TzFh.MakeWhiteList(inst)
        TzFh.AddFueledComponent(inst,{
            max = 5000,
        })
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

        TzFh.AddLibrarySkill(inst,{name = "shadowstep"})
        TzFh.AddLibrarySkill(inst,{name = "zhaoye"})
        TzFh.AddLibrarySkill(inst,{name = "shadow_ball"})

        inst:ListenForEvent("equipped",OnEquip)
        inst:ListenForEvent("unequipped",OnUnEquip)
    end,
})