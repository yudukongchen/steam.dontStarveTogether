local TzEntity = require("util/tz_entity")
local TzWeaponSkill = require("util/tz_weaponskill")
local TzFh = require("util/tz_fh")

local assets = {
    Asset("ANIM", "anim/tz_fhdx.zip"),
    Asset("ANIM", "anim/swap_tz_fhdx.zip"),
    Asset("IMAGE", "images/inventoryimages/tz_fhdx.tex"),
    Asset("ATLAS", "images/inventoryimages/tz_fhdx.xml")
}

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

local function GetTornadoSpawnPos(inst, target)
    local x1, y1, z1 = inst.Transform:GetWorldPosition()
    local x2, y2, z2 = target.Transform:GetWorldPosition()
    return x1 + .15 * (x2 - x1), 0, z1 + .15 * (z2 - z1)
end

return TzEntity.CreateNormalWeapon({
    assets = assets,
    prefabname = "tz_fhdx",
    tags = {"tz_fhdx","tz_fanhao"},
    bank = "tz_fhdx",
    build = "tz_fhdx",
    anim = "idle",

    weapon_data = {
        damage = 34,
        ranges = 14,
    },
    
    clientfn = function(inst)
        TzFh.AddFhLevel(inst,true)
        TzFh.AddOwnerName(inst)
    end,
    serverfn = function(inst)

        -- This is Tz-Fh Common
        --TzFh.AddOwnerName(inst)
        TzFh.MakeWhiteList(inst)
        TzFh.AddFueledComponent(inst)
        TzFh.SetReturnSpiritualism(inst)

        -- shadow ball
        TzFh.AddLibrarySkill(inst,{name = "shadow_ball"})

        -- life_steal
        inst._percent_life_steal = 0.5 / 100
        TzFh.AddLibrarySkill(inst,{name = "life_steal"})

        -- dark_energy
        inst._percent_dark_energy = 1.25 
        TzFh.AddLibrarySkill(inst,{name = "dark_energy"})

        -- night explosion
        inst.explosion_fn = TzFh.SKILL_LIBIARY.night_explosion.on_attack_fn_wrapper(3,
            { "INLIMBO", "notarget", "noattack", "flight", "invisible", "playerghost","wall","structure" }
        )
        inst.components.weapon:SetOnAttack(function(inst,owner,target)
            inst.explosion_fn(inst,owner,target)
        end)

        inst.components.weapon:SetOnProjectileLaunch(function(inst, attacker, target)
            local tornado = SpawnPrefab("tornado")

            tornado:SetStateGraph("SGtornado_fhdx")
            

            -- Add damage_multi for BASE_DAMAGE
            local damage_multi = 
                (attacker.components.combat.damagemultiplier or 1) 
                * attacker.components.combat.externaldamagemultipliers:Get()
            
            -- tornado.BASE_DAMAGE = inst.components.weapon:GetDamage(attacker, target)
            tornado.BASE_DAMAGE = 8 * damage_multi
            tornado.WINDSTAFF_CASTER = attacker
            tornado.WINDSTAFF_CASTER_ISPLAYER = tornado.WINDSTAFF_CASTER ~= nil and tornado.WINDSTAFF_CASTER:HasTag("player")
            tornado.Transform:SetPosition(GetTornadoSpawnPos(inst, target))
            tornado.components.knownlocations:RememberLocation("target", target:GetPosition())

            if tornado.WINDSTAFF_CASTER_ISPLAYER then
                tornado.overridepkname = tornado.WINDSTAFF_CASTER:GetDisplayName()
                tornado.overridepkpet = true
            end

            -- Hit count debug test
            -- tornado:ListenForEvent("onhitother",function()
            --     tornado.hits = tornado.hits or 0 
            --     tornado.hits = tornado.hits + 1
            --     print("Hitting,",tornado.hits)
            -- end)
        end)

        inst:ListenForEvent("equipped",OnEquip)
        inst:ListenForEvent("unequipped",OnUnEquip)

    end,
})