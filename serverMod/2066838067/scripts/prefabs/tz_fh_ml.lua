local TzEntity = require("util/tz_entity")
local TzWeaponSkill = require("util/tz_weaponskill")
local TzFh = require("util/tz_fh")

local assets = {
    Asset("ANIM", "anim/tz_fh_ml.zip"),
    Asset("IMAGE", "images/inventoryimages/tz_fh_ml.tex"),
    Asset("ATLAS", "images/inventoryimages/tz_fh_ml.xml"),
}

local function UpdateDamage(inst,phase)
    if inst.components.equippable:IsEquipped() then
        local owner = inst.components.inventoryitem.owner
        if owner and owner.components.combat then
            if phase == "night" then
                owner.components.combat.externaldamagemultipliers:SetModifier(inst, 1.25)
            else
                owner.components.combat.externaldamagemultipliers:RemoveModifier(inst)
            end
        end
    end
end

local TRAIL_FLAGS = { "shadowtrail" }
local function cane_do_trail(inst)
    local owner = inst.components.inventoryitem:GetGrandOwner() or inst
    if not owner.entity:IsVisible() then
        return
    end

    local x, y, z = owner.Transform:GetWorldPosition()
    if owner.sg ~= nil and owner.sg:HasStateTag("moving") then
        local theta = -owner.Transform:GetRotation() * DEGREES
        local speed = owner.components.locomotor:GetRunSpeed() * .1
        x = x + speed * math.cos(theta)
        z = z + speed * math.sin(theta)
    end
    local mounted = owner.components.rider ~= nil and owner.components.rider:IsRiding()
    local map = TheWorld.Map
    local offset = FindValidPositionByFan(
        math.random() * 2 * PI,
        (mounted and 1 or .5) + math.random() * .5,
        4,
        function(offset)
            local pt = Vector3(x + offset.x, 0, z + offset.z)
            return map:IsPassableAtPoint(pt:Get())
                and not map:IsPointNearHole(pt)
                and #TheSim:FindEntities(pt.x, 0, pt.z, .7, TRAIL_FLAGS) <= 0
        end
    )

    if offset ~= nil then
        SpawnPrefab(inst.trail_fx).Transform:SetPosition(x + offset.x, 0, z + offset.z)
    end
end

local function OnEquip(inst,data)
    UpdateDamage(inst)
    if inst.components.fueled ~= nil then
        inst.components.fueled:StartConsuming()
    end
    if inst._owner then
        inst:RemoveEventCallback("onhitother", inst._onhitother, inst._owner)
    end
    if data and data.owner then
        if data.owner.components.fh_ml_pet then
            data.owner.components.fh_ml_pet:RemoveTime() 
        end
        inst._owner = data.owner
        inst:ListenForEvent("onhitother", inst._onhitother,data.owner)
    end
    if inst.trail_fx ~= nil and inst._trailtask == nil then
        inst._trailtask = inst:DoPeriodicTask(6 * FRAMES, cane_do_trail, 2 * FRAMES)
    end
end

local function OnUnEquip(inst,data)
    if data and data.owner then
        if data.owner.components.fh_ml_pet then
            data.owner.components.fh_ml_pet:StartTimer(60) 
        end
        if data.owner.components.combat then
            data.owner.components.combat.externaldamagemultipliers:RemoveModifier(inst)
        end
    end
    if inst._owner then
        inst:RemoveEventCallback("onhitother", inst._onhitother, inst._owner)
        inst._owner = nil
    end
    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end
    if inst._trailtask ~= nil then
        inst._trailtask:Cancel()
        inst._trailtask = nil
    end
end

local function UpdateSpeed(inst,phase)
    if phase == "night" then
        inst.components.equippable.walkspeedmult = 1.25
    else
        inst.components.equippable.walkspeedmult = 1
    end
    UpdateDamage(inst,phase)
end

return  
    TzEntity.CreateNormalHat({
    assets = assets,
    prefabname = "tz_fh_ml",
    tags = {"rechargeable","tz_fh_ml","tz_fanhao"},
    bank = "tz_fh_ml",
    build = "tz_fh_ml",
    anim = "idle",
    hat_data = {
        swapanims = {"tz_fh_ml","swap_hat"},
        is_top = true,
    },
    
    clientfn = function(inst)
        TzFh.AddOwnerName(inst)
        TzFh.AddFhLevel(inst,true)
    end,
    serverfn = function(inst)
        inst:WatchWorldState("phase", UpdateSpeed)

        TzFh.AddLibrarySkill(inst,{name = "beishui"})
        TzFh.AddLibrarySkill(inst,{name = "yingci"})
        inst.trail_fx = "cane_ancient_fx"
        -- This is Tz-Fh Common
        --TzFh.AddOwnerName(inst)
        TzFh.MakeWhiteList(inst)
        TzFh.AddFueledComponent(inst)
        TzFh.SetReturnSpiritualism(inst)
        inst._onhitother = function(doer,data)
            if inst.inskillon and doer and doer.components.fh_ml_pet then
                local theta = math.random() * 2 * PI
                local pt = doer:GetPosition()
                local radius = 1
                local offset = FindWalkableOffset(pt, theta, radius, 6, true)
                if offset ~= nil then
                    pt.x = pt.x + offset.x
                    pt.z = pt.z + offset.z
                end
                doer.components.fh_ml_pet:SpawnPetAt(pt.x, 0, pt.z, "tz_nightmare3")
            end
        end
        inst.inskillon = false
        inst.Use_Skill = function(inst,doer)
            if inst.components.rechargeable.isready then
                inst.components.rechargeable:StartRecharge()
                if doer and doer.components.tz_xx then
                    doer.components.tz_xx:AddShanbi("tz_fh_ml",1,15)
                end
                inst.inskillon = true
                inst:DoTaskInTime(15,function()
                    inst.inskillon = false
                end)
            else
            
            end
        end
        inst:AddComponent("tz_rechargeable")
        inst.components.rechargeable = inst.components.tz_rechargeable
        inst.components.rechargeable:SetRechargeTime(20)
        inst:RegisterComponentActions("rechargeable")

        inst:ListenForEvent("equipped",OnEquip)
        inst:ListenForEvent("unequipped",OnUnEquip)
    end,
})