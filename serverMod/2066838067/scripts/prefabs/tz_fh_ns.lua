local TzEntity = require("util/tz_entity")
local TzWeaponSkill = require("util/tz_weaponskill")
local TzFh = require("util/tz_fh")

local assets = {
    Asset("ANIM", "anim/tz_fh_ns.zip"),
    Asset("ANIM", "anim/tz_fh_nsfx.zip"),
    Asset("IMAGE", "images/inventoryimages/tz_fh_ns.tex"),
    Asset("ATLAS", "images/inventoryimages/tz_fh_ns.xml"),
}

local prefabs = {}

local function OnEquip(inst,data)
    if data and data.owner  then
        if data.owner.components.moisture then
            data.owner:AddTag("moistureimmunity")
            data.owner.components.moisture:ForceDry(true, inst)
            data.owner.components.moisture:SetWaterproofInventory(true)
        end
        inst:ListenForEvent("onattackother", inst._Attack, data.owner)
    end
end

local function OnUnEquip(inst,data)
    if data.owner then
        if  data.owner.components.moisture then
            if not data.owner.components.debuffable and data.owner.components.debuffable:HasDebuff("buff_moistureimmunity") then
                data.owner:RemoveTag("moistureimmunity")
            end
            data.owner.components.moisture:ForceDry(false, inst)
            data.owner.components.moisture:SetWaterproofInventory(false)
        end
        inst:RemoveEventCallback("onattackother", inst._Attack, data.owner)
    end
end

----------===============fx
local function profn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.AnimState:SetBank("tz_fh_nsfx")
    inst.AnimState:SetBuild("tz_fh_nsfx")
    inst.AnimState:PlayAnimation("fly", true)
    
    inst.AnimState:SetFinalOffset(-1)

    inst:AddTag("projectile")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    
    inst.persists = false
    
    inst:AddComponent("projectile")
    inst.components.projectile.range = 15
    inst.components.projectile:SetSpeed(10)
    inst.components.projectile:SetLaunchOffset(Vector3(0, 1.5, 0))
    inst.components.projectile:SetOnMissFn(inst.Remove)
    inst.components.projectile:SetOnHitFn(function(inst, owner, target)
        if target:IsValid() then
            if target.tz_fh_ns_hitfx and target.tz_fh_ns_hitfx:IsValid() then
                target.tz_fh_ns_hitfx:Remove()
            end
            if target.tz_fh_ns_hitfxtask ~= nil then
                target.tz_fh_ns_hitfxtask:Cancel()
            end
            target.tz_fh_ns_hitfxtask = target:DoTaskInTime(5, function(i) 
                if i.components.locomotor then
                    i.components.locomotor:RemoveExternalSpeedMultiplier(i, "tz_fh_ns_hitfx") 
                end
                if i.components.combat then
                    i.components.combat.externaldamagetakenmultipliers:RemoveModifier("tz_fh_ns_hitfx")
                end
                i.tz_fh_ns_hitfxtask = nil 
            end)
            if target.components.locomotor then
                target.components.locomotor:SetExternalSpeedMultiplier(target, "tz_fh_ns_hitfx", 0.1)
            end
            if target.components.combat then
                target.components.combat.externaldamagetakenmultipliers:SetModifier("tz_fh_ns_hitfx", 1.25)
            end
            local fx = SpawnPrefab("tz_fh_ns_hit")
            fx.entity:SetParent(target.entity)
            target.tz_fh_ns_hitfx = fx
            fx.Transform:SetPosition(0,target:HasTag("epic") and 0 or -1,0)
            if target:HasTag("largecreature") or target:HasTag("epic") then
                fx.Transform:SetScale(4,4,4)
            elseif target:HasTag("smallcreature") then
                fx.Transform:SetScale(1.5,1.5,1.5)
            else
                fx.Transform:SetScale(2.5,2.5,2.5)
            end
        end
        inst:Remove()
    end)
    inst:DoTaskInTime(5,inst.Remove)
    return inst
end

local function hit_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("tz_fh_nsfx")
    inst.AnimState:SetBuild("tz_fh_nsfx")
    inst.AnimState:PlayAnimation("loop",true)
    inst.AnimState:SetFinalOffset(3)
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst.persists = false
    inst:DoTaskInTime(5, inst.Remove)
    return inst
end

return  Prefab("tz_fh_ns_pro", profn),
    Prefab("tz_fh_ns_hit", hit_fn),

    TzEntity.CreateNormalArmor({
    assets = assets,
    prefabname = "tz_fh_ns",
    tags = {"tz_fh_ns","tz_fanhao"},
    bank = "tz_fh_ns",
    build = "tz_fh_ns",
    anim = "idle",
    armor_data = {
        swapanims = {"tz_fh_ns","swap"},
        equipslot = EQUIPSLOTS.NECK or EQUIPSLOTS.BODY,
    },
    clientfn = function(inst)
        TzFh.AddOwnerName(inst)
        TzFh.AddFhLevel(inst,true)
    end,
    serverfn = function(inst)
        TzFh.MakeWhiteList(inst)
        inst.attacktime = 0
        inst._Attack = function(_owner,data)
            if _owner and _owner:IsValid() and data and data.target and data.target:IsValid() and (GetTime() - inst.attacktime) > 2 then
                inst.attacktime = GetTime()
                local projectile = SpawnPrefab("tz_fh_ns_pro")
                local x,y,z = _owner.Transform:GetWorldPosition()
                projectile.Transform:SetPosition(x,y+1.5,z)
                projectile.components.projectile:Throw(projectile, data.target)
            end
        end

        inst:ListenForEvent("equipped",OnEquip)
        inst:ListenForEvent("unequipped",OnUnEquip)
    end,
})