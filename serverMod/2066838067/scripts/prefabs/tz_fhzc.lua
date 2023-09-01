local TzEntity = require("util/tz_entity")
local TzFh = require("util/tz_fh")

local assets = {
    
    Asset("ANIM", "anim/tz_fhzc.zip"),
    Asset("ANIM", "anim/swap_tz_fhzc.zip"),
    Asset("ANIM", "anim/tz_fhzc_minion.zip"),
    Asset("IMAGE", "images/inventoryimages/tz_fhzc.tex"),
    Asset("ATLAS", "images/inventoryimages/tz_fhzc.xml")
}

local function FhzcClientFn(inst)
    TzFh.AddOwnerName(inst)
    TzFh.AddFhLevel(inst,true)
end

local function ApplyLevel(inst)
    local level = inst.components.tz_exp:GetLevel()
    inst.components.weapon:SetDamage(60 + (level - 1))
end

local function OnEquip(inst,data)
    if inst.lightfx then
        inst.lightfx:Remove()
    end

    inst.lightfx = SpawnPrefab("tz_fhzc_light")
    inst.lightfx.entity:SetParent(data.owner.entity)
    inst.lightfx.entity:AddFollower()
    inst.lightfx.Follower:FollowSymbol(data.owner.GUID, "swap_object", 0, -110, 0)

    if inst.consume_naijiu_task then
        inst.consume_naijiu_task:Cancel()
    end

    local max_time = 3840
    local max_condition = inst.components.armor.condition
    inst.consume_naijiu_task = inst:DoPeriodicTask(0,function()
        local damage_amount = FRAMES * max_condition / max_time
        inst.components.armor:SetCondition(inst.components.armor.condition - damage_amount)
    end)

    if inst.minion then
        inst.minion:Remove()
    end
    inst.minion = SpawnAt("tz_fhzc_minion",data.owner)
    inst.minion.components.follower:SetLeader(data.owner)
    
    inst:ListenForEvent("onhitother",inst._on_hit_other,data.owner)
end

local function OnUnEquip(inst,data)
    if inst.lightfx then
        inst.lightfx:Remove()
    end
    inst.lightfx = nil 

    if inst.consume_naijiu_task then
        inst.consume_naijiu_task:Cancel()
    end
    inst.consume_naijiu_task = nil

    if inst.minion then
        inst.minion:Remove()
    end
    inst.minion = nil 

    inst:RemoveEventCallback("onhitother",inst._on_hit_other,data.owner)
end


local function FhzcServerFn(inst)
    TzFh.MakeWhiteList(inst)
    
    inst.components.equippable.walkspeedmult = 1.25

    inst:AddComponent("tz_exp")
    inst.components.tz_exp.max_level = 90
    inst.components.tz_exp:SetCalcMaxExpFn(function(inst,level)
        return 10000
    end)

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(1000,0.15)

    inst:AddComponent("blinkstaff")
    inst.components.blinkstaff:SetFX("sand_puff_large_front", "sand_puff_large_back")

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP,1)
    inst.components.tool:SetAction(ACTIONS.MINE,1)

    TzFh.AddTraderComponent(inst)
    TzFh.SetReturnSpiritualism(inst)
    

    inst._on_hit_other = function(owner,data)
        local target = data.target
        if owner.components.health and not owner.components.health:IsDead() then
            owner.components.health:DoDelta(1,true)
        end
        
        if target.components.sleeper then
            target.components.sleeper:AddSleepiness(target.components.sleeper.resistance * 0.5,5)
        end

        if target.components.grogginess then
            target.components.grogginess:AddGrogginess(target.components.grogginess:GetResistance() * 0.5,5)
        end

        if target.components.freezable then
            target.components.freezable:AddColdness(target.components.freezable.resistance * 0.5,5)
        end

        if target.components.health:IsDead() and math.random() <= 0.2 then
            local x,y,z = target:GetPosition():Get()
            SpawnAt("nightmarefuel",target).components.inventoryitem:DoDropPhysics(x,y,z,true)
        end

        inst.components.tz_exp:DoDeltaExp(data.damage)
    end

    inst:ListenForEvent("tz_level_delta",ApplyLevel)
    inst:ListenForEvent("equipped",OnEquip)
    inst:ListenForEvent("unequipped",OnUnEquip)

    inst.OnRemoveEntity = function()
        if inst.lightfx then
            inst.lightfx:Remove()
        end
        inst.lightfx = nil 
    
        if inst.minion then
            inst.minion:Remove()
        end
        inst.minion = nil 
    end
end

local function lightfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.Light:SetIntensity(.75)
    inst.Light:SetColour(252 / 255, 251 / 255, 237 / 255)
    inst.Light:SetFalloff(.6)
    inst.Light:SetRadius(8)
    inst.Light:Enable(true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

local function MinionClient(inst)
    MakeCharacterPhysics(inst,1,0.5)
end

local function MinionServer(inst)
    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 4
    inst.components.locomotor.runspeed = 6

    inst:AddComponent("follower")
    inst.components.follower:KeepLeaderOnAttacked()
    inst.components.follower.keepdeadleader = true
	inst.components.follower.keepleaderduringminigame = true

    inst:SetStateGraph("SGtz_fhzc_minion")
    local brain = require("brains/tz_fhzc_minionbrain")
    inst:SetBrain(brain)
end

return TzEntity.CreateNormalWeapon({
    assets = assets,
    prefabname = "tz_fhzc",
    tags = {"tz_fhzc","tz_fanhao"},
    bank = "tz_fhzc",
    build = "tz_fhzc",
    anim = "idle",

    -- inventoryitem_data = {

    -- },

    weapon_data = {
        damage = 60,
        ranges = 14,
    },
    
    clientfn = FhzcClientFn,
    serverfn = FhzcServerFn,
}),
TzEntity.CreateNormalEntity({
    assets = assets,
    prefabname = "tz_fhzc_minion",

    tags = {"tz_fhzc_minion"},
    bank = "tz_fhzc_minion",
    build = "tz_fhzc_minion",
    anim = "idle",
    loop_anim = true,

    persists = false,

    clientfn = MinionClient,
    serverfn = MinionServer,
}),
Prefab("tz_fhzc_light",lightfn)