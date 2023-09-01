local TzEntity = require("util/tz_entity")
local TzWeaponSkill = require("util/tz_weaponskill")
local TzFh = require("util/tz_fh")
local neednum = 1000 --需要给几个噩梦燃料才会触发加成和伤害抵抗

--本文件 tz_fh tz_actions tzfhbm_ui taizhen   zip
local assets = {
    Asset("ANIM", "anim/tz_fhbm.zip"),
    Asset("ANIM", "anim/tz_fhbmfxs.zip"),
    Asset("ANIM", "anim/swap_tz_fhbm.zip"),
    Asset("IMAGE", "images/inventoryimages/tz_fhbm.tex"),
    Asset("ATLAS", "images/inventoryimages/tz_fhbm.xml")
}

local function FhbmClientFn(inst)
    TzFh.AddOwnerName(inst)
    TzFh.AddFhLevel(inst,true)
    TzWeaponSkill.AddAoetargetingClient(inst,nil,nil,12)
end

local function OnAttack(inst,attacker,target)
    if target.components.health:IsDead() then
        inst.EnemyKilled = math.min(inst.EnemyKilled + 1,100 * 100)
    end

    if inst.components.timer:TimerExists("tz_fhbm_skill") then
        attacker.components.health:DoDelta(2)
    end
end

local TRAIL_FLAGS = { "tz_fhbm_movefx" }
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
        SpawnPrefab("tz_fhbm_movefx").Transform:SetPosition(x + offset.x, 0, z + offset.z)
    end
end
local aa = {
    "a","b","c","d",
}

local function IsWeaponEquipped(inst, weapon)
    return weapon ~= nil
        and weapon.components.equippable ~= nil
        and weapon.components.equippable:IsEquipped()
        and weapon.components.inventoryitem ~= nil
        and weapon.components.inventoryitem:IsHeldBy(inst)
end
local function onnewsleeptick(inst,owner)
	if IsWeaponEquipped(owner, inst) then
		owner.AnimState:OverrideSymbol("swap_object", "swap_tz_fhbm", aa[inst.animnum])
		inst.animnum = inst.animnum%4 + 1 
	end
end

local function OnEquip(inst,data)
    if inst.lightfx then
        inst.lightfx:Remove()
    end

    inst.lightfx = SpawnPrefab("minerhatlight")
    inst.lightfx.entity:SetParent(data.owner.entity)
    inst.lightfx.entity:AddFollower()
    inst.lightfx.Follower:FollowSymbol(data.owner.GUID, "swap_object", 0, -110, 0)

    if inst.components.fueled ~= nil then
        inst.components.fueled:StartConsuming()
    end

    if data.owner.components.hunger then
        data.owner.components.hunger.burnratemodifiers:SetModifier(inst,2,inst.prefab)
    end

    if data.owner.components.combat then
        data.owner.components.combat.externaldamagetakenmultipliers:SetModifier(inst,1.25,inst.prefab)
    end
    inst._trailtask = inst:DoPeriodicTask(6 * FRAMES, cane_do_trail, 2 * FRAMES)

    if inst.components.timer:TimerExists("tz_fhbm_skill") then
        local time = inst.components.timer:GetTimeLeft("tz_fhbm_skill")
        if time and data.owner.tzfhbmtime then
            data.owner.tzfhbmtime:set_local(0)
            data.owner.tzfhbmtime:set(time)
        end
    end
    inst.animnum = 1
    if inst.newnumatask ~= nil then
        inst.newnumatask:Cancel()
    end
    inst.newnumatask = inst:DoPeriodicTask(0.1, onnewsleeptick,FRAMES,data.owner)
    inst._wheel = SpawnPrefab("tz_fhbm_huan")
    inst._wheel.entity:AddFollower()
    inst._wheel.Follower:FollowSymbol(data.owner.GUID, "swap_object", 50, -246, 0)  ---环的坐标
end

local function OnUnEquip(inst,data)
    if inst.lightfx then
        inst.lightfx:Remove()
    end
    if inst.newnumatask ~= nil then
        inst.newnumatask:Cancel()
        inst.newnumatask = nil
    end
	if inst._wheel ~= nil then
        inst._wheel:Remove()
        inst._wheel = nil
    end
    if inst._trailtask ~= nil then
        inst._trailtask:Cancel()
        inst._trailtask = nil
    end
    inst.lightfx = nil 

    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end

    if data.owner.components.hunger then
        data.owner.components.hunger.burnratemodifiers:RemoveModifier(inst,inst.prefab)
    end

    if data.owner.components.combat then
        data.owner.components.combat.externaldamagetakenmultipliers:RemoveModifier(inst,inst.prefab)
    end

    if data.owner.SoundEmitter then
        data.owner.SoundEmitter:KillSound("tz_fhbmbgm_sit")
    end

    if data.owner.tzfhbmtime then
        data.owner.tzfhbmtime:set(0)
    end
end

local function OnTimerDone(inst, data)
    local name = data and data.name or nil
    if name == "tz_fhbm_skill" then
        if inst.components.equippable:IsEquipped() and inst.components.inventoryitem.owner ~= nil then
            local owner = inst.components.inventoryitem.owner
            if owner and owner.tzfhbmtime then
                owner.tzfhbmtime:set(0)
            end
        end 
    elseif name == "时停充能" then
        inst.timeskill =  inst.timeskill + 1
        if inst.timeskill < 3 and not inst.components.timer:TimerExists("时停充能") then
            inst.components.timer:StartTimer("时停充能",480)
        end
    end
end

local function GetDamageFn(inst,attacker,target)
    return (70 + math.floor(inst.EnemyKilled / 100)) * (attacker.components.health and attacker.components.health:GetPercent() >= 1.0 and 2.5 or 1.0) * (inst.components.timer:TimerExists("tz_fhbm_skill") and 2 or 1)
    + (inst.CurrentNum >= neednum and target and target.components.health and target.components.health.maxhealth*0.01 or 0)

end

local function OnBlink(inst,caster,pos)
    SpawnAt("tz_fhbm_blinkfx",pos)
    caster.Transform:SetPosition(pos:Get())
    local ents = TheSim:FindEntities(pos.x,pos.y,pos.z,6,nil,{"INLIMBO","structure"},nil)
    for k,v in pairs(ents) do
        if v.components.combat and not caster.components.combat:IsAlly(v) then
            --4.8 修复 combat 不一定有damagemultiplier
            v.components.combat:GetAttacked(caster,200 * (caster.components.combat.damagemultiplier or 1) * caster.components.combat.externaldamagemultipliers:Get())
        end

        if v.components.workable and v.components.workable:CanBeWorked() and v.components.workable.action ~= ACTIONS.NET then
            v.components.workable:Destroy(caster)
        end
    end

    inst.components.rechargeable:Discharge(30)
end

local function ShouldResistFn(inst)
    if not inst.components.equippable:IsEquipped() then
        return false
    end
    local owner = inst.components.inventoryitem.owner
    return owner ~= nil and inst.CurrentNum >= neednum and not inst.resisttask
end

local function OnResistDamage(inst,damage_amount)
    local owner = inst.components.inventoryitem:GetGrandOwner() or inst
    owner:SpawnChild("shadow_shield"..math.random(1,6))
    inst.resisttask  = inst:DoTaskInTime(3,function()
        inst.resisttask = nil
    end)
end

local function OnSave(inst,data)
    data.EnemyKilled = inst.EnemyKilled
    data.CurrentNum  = inst.CurrentNum 
    data.timeskill = inst.timeskill
end

local function OnLoad(inst,data)
    if data ~= nil then
        if data.EnemyKilled ~= nil then
            inst.EnemyKilled = data.EnemyKilled
        end
        if data.CurrentNum  then
            inst.CurrentNum  = data.CurrentNum 
        end
        if data.timeskill  then
            inst.timeskill  = data.timeskill
        end
    end
end

local RESISTANCES =
{
    "_combat",
    "explosive",
    "quakedebris",
    "caveindebris",
    "trapdamage",
}

local function ontakefuel(inst,giver,item)
    --inst.components.fueled:DoDelta(384)
    inst.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
    
    local owner = inst.components.inventoryitem:GetGrandOwner()
    if owner and owner:HasTag("player") then
        local pos = owner:GetPosition()
        SpawnAt("tz_takefuel",pos + Vector3(0,-2.6,0))
    end
    if item and item.prefab == "nightmarefuel" then
        inst.CurrentNum = inst.CurrentNum + 1
    end
end

local function OnDropped(inst)
    inst.SoundEmitter:PlaySound("tz_fhbmbgm/tz_fhbmbgm/drop")
end

local function FhbmServerFn(inst)
    inst.components.equippable.walkspeedmult = 1.25

    inst.components.weapon:SetOnAttack(OnAttack)

    inst:AddComponent("timer")

    inst:AddComponent("resistance")
    inst.components.resistance:SetShouldResistFn(ShouldResistFn)
    inst.components.resistance:SetOnResistDamageFn(OnResistDamage)

    --4.8 修复
    for i, v in ipairs(RESISTANCES) do
        inst.components.resistance:AddResistance(v)
    end

    TzFh.MakeWhiteList(inst)

    TzFh.AddFueledComponent(inst,{
        accepting = false,
    })

    TzFh.AddTraderComponent(inst,{
        trade_list = {
            nightmarefuel = 0.05,
            shadowheart = 1.00,
        },
        additionalfn = ontakefuel,
    })
    
    TzWeaponSkill.AddAoetargetingServer(inst,OnBlink)

    inst.EnemyKilled = 0
    inst.CurrentNum = 0
    inst.timeskill = 3
    inst.OnSave = OnSave 
    inst.OnLoad = OnLoad
    inst.TryTrigerSkill = function(inst,owner,time)
        if owner and owner.components.hunger and owner.components.hunger.current >= 50 then
            owner.components.hunger:DoDelta(-50)
            if owner.tzfhbmtime then
                owner.tzfhbmtime:set(time)
            end
            inst.components.timer:StopTimer("tz_fhbm_skill")
            inst.components.timer:StartTimer("tz_fhbm_skill",time)
        end
    end
    inst.Use_Time_Skill = function(inst,owner)
        if inst.components.timer:TimerExists("时停") then
            owner.components.talker:Say(string.format("时停冷却还剩%.1f秒",inst.components.timer:GetTimeLeft("时停")))
        elseif inst.timeskill < 1 then
            if inst.components.timer:TimerExists("时停充能") then
                owner.components.talker:Say(string.format("时停可使用次数不足,下一次时停充能还剩%.1f秒",inst.components.timer:GetTimeLeft("时停充能")))
            end
        elseif  owner.components.taizhen_timepauseskill then
            inst.timeskill =  inst.timeskill - 1
            owner.components.taizhen_timepauseskill:UseSkill()
            inst.components.timer:StartTimer("时停",20)
            if not inst.components.timer:TimerExists("时停充能") then
                inst.components.timer:StartTimer("时停充能",480)
            end
        end
    end
    inst:ListenForEvent("equipped",OnEquip)
    inst:ListenForEvent("unequipped",OnUnEquip)
    inst:ListenForEvent("ondropped", OnDropped)
    inst:ListenForEvent("timerdone", OnTimerDone)
    inst:ListenForEvent("onremove",function()
        if inst.lightfx then
            inst.lightfx:Remove()
        end
        inst.lightfx = nil 
    end)
end

local function movefx()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("tz_fhbm_movefx")
    inst:AddTag("taizhenTag_ignoretimemagic")
    inst.AnimState:SetBank("tz_fhbmfxs")
    inst.AnimState:SetBuild("tz_fhbmfxs")
    inst.AnimState:PlayAnimation("tx3")
    inst.AnimState:SetFinalOffset(3)

    inst.Transform:SetScale(2, 2, 2)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
    inst.persists = false
    inst:ListenForEvent("animover", inst.Remove)
    return inst
end

local function blinkfx()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("tz_fhbm_movefx")
    inst:AddTag("taizhenTag_ignoretimemagic")
    inst.AnimState:SetBank("tz_fhbmfxs")
    inst.AnimState:SetBuild("tz_fhbmfxs")
    inst.AnimState:PlayAnimation("tx1")
    inst.AnimState:SetFinalOffset(3)

    inst.Transform:SetScale(3, 3, 3)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
    inst.persists = false
    inst:ListenForEvent("animover", inst.Remove)
    return inst
end

local function huanfx()
    local inst = CreateEntity()

    inst.entity:AddTransform()

    inst.entity:AddNetwork()
    inst.entity:AddAnimState()

    inst:AddTag("FX")
    inst.AnimState:SetBank("tz_fhbm_fx")
    inst.AnimState:SetBuild("swap_tz_fhbm")
	inst.AnimState:PlayAnimation("ring",true)
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetFinalOffset(1)
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst.persists = false
    return inst
end

return Prefab("tz_fhbm_movefx", movefx),
    Prefab("tz_fhbm_blinkfx", blinkfx),
    Prefab("tz_fhbm_huan", huanfx),

    TzEntity.CreateNormalWeapon({
    assets = assets,
    prefabname = "tz_fhbm",
    tags = {"tz_fhbm","veryquickcast","tz_fanhao"},
    bank = "tz_fhbm",
    build = "tz_fhbm",
    anim = "idle",

    weapon_data = {
        damage = GetDamageFn,
        ranges = 1.2,
    },
    
    clientfn = FhbmClientFn,
    serverfn = FhbmServerFn,
})