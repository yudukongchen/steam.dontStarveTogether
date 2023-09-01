local TzUtil = require("tz_util")
local TzFh = require("util/tz_fh")

local assets = {Asset("ANIM", "anim/swap_tz_yezhao.zip"), Asset("ANIM", "anim/swap_tz_yezhao_pink.zip"),
                Asset("ANIM", "anim/tz_yezhao_pink.zip"), Asset("ATLAS", "images/inventoryimages/tz_yezhao.xml"),
                Asset("ATLAS", "images/inventoryimages/tz_yezhao_pink.xml")}

local lightassets = {Asset("ANIM", "anim/yezhao_fx.zip")}
local boassets = {Asset("ANIM", "anim/bearger_ring_fx.zip"), Asset("ANIM", "anim/meteor_purple.zip")}
local prefabs = {"tz_bfoff", "tz_canying", "tz_bfon", "yezhao_fx", "tz_takefuel", "tz_thuriblemiemie_big",
                 "tz_projectile_bai", "tz_yexingzhe_light"}
local function lightkai(inst)
    if inst.components.equippable:IsEquipped() and inst.components.inventoryitem.owner ~= nil then
        if inst._light == nil then
            inst._light = SpawnPrefab("tz_yexingzhe_light")
            inst._light:Turnoon()
        end
        inst._light.entity:SetParent((inst._body or inst.components.inventoryitem.owner or inst).entity)
    end
end
local function lightguan(inst)
    if inst.components.equippable:IsEquipped() and inst.components.inventoryitem.owner ~= nil then
        if inst._light ~= nil then
            inst._light:Turnoff()
            inst._light = nil
        end
    end
end
local function OnKilled(owner, data)
    local victim = data.victim
    if victim and math.random() < 0.33 then
        if victim.components.lootdropper then
            victim.components.lootdropper:SpawnLootPrefab("nightmarefuel")
        end
    end
end

local ttttt = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p"}

local function IsWeaponEquipped(inst, weapon)
    return weapon ~= nil and weapon.components.equippable ~= nil and weapon.components.equippable:IsEquipped() and
               weapon.components.inventoryitem ~= nil and weapon.components.inventoryitem:IsHeldBy(inst)
end

local function onsleeptick(inst, owner)
    if IsWeaponEquipped(owner, inst) then
        inst.num = inst.num + 1
        if inst.num > #ttttt then
            inst.num = 1
        end
        owner.AnimState:OverrideSymbol("swap_object", "swap_tz_yezhao_pink", "tz_" .. ttttt[inst.num])
    end
end

local function onequip(inst, owner)
    if owner.prefab == "taizhen" then
        if inst.prefab == "tz_yezhao" then
            owner.AnimState:OverrideSymbol("swap_object", "swap_tz_yezhao", "swap_tz_yezhao")
        else
            inst.num = 1
            owner.AnimState:OverrideSymbol("swap_object", "swap_tz_yezhao_pink", "tz_a")

            if inst.numatask ~= nil then
                inst.numatask:Cancel()
            end
            inst.numatask = inst:DoPeriodicTask(1 / 10, onsleeptick, 1 / 10, owner) -- 回血扣饥饿
        end
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")
        if inst.components.fueled ~= nil then
            inst.components.fueled:StartConsuming()
        end
        if TheWorld.state.phase == "night" then
            if inst._light == nil then
                inst._light = SpawnPrefab("tz_yexingzhe_light")
                inst._light:Turnoon()
            end
            inst._light.entity:SetParent((inst._body or inst.components.inventoryitem.owner or inst).entity)
        end
        if inst.miemie == nil and inst.prefab == "tz_yezhao" then
            inst.miemie = SpawnPrefab("yezhao_fx")
            inst.miemie.entity:AddFollower()
            inst.miemie.Follower:FollowSymbol(owner.GUID, "swap_object", 0, -242, 0)
        end
        if inst._yanwu == nil then
            inst._yanwu = SpawnPrefab("tz_thurible_smoke_big")
            inst._yanwu.entity:AddFollower()
            inst._yanwu._miaomiao = inst
            inst._yanwu.Follower:FollowSymbol(owner.GUID, "swap_object", 28, -318, 0)
        end
        inst:ListenForEvent("killed", OnKilled, owner)
        if owner.components.tz_xx and owner.components.tz_xx.dengji > 7 then
            if owner.components.combat then
                owner.components.combat.externaldamagemultipliers:SetModifier("tzxx_level7", 1.25)
            end
            --inst.components.samaequip.equipsama = 12
        end
		if owner.components.locomotor and inst.components.tz_fh_level.level ~= 0 then
            owner.components.locomotor:SetExternalSpeedMultiplier(owner, inst, 1 + inst.components.tz_fh_level.level * 0.01)
        end
    else
        if TUNING.TZ_FANHAO_SPECIFIC then
            TzUtil.OnInvalidOwner(inst, owner, 0, STRINGS.NOYEXINGZHE, true)
        end
    end
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    inst:RemoveEventCallback("killed", OnKilled, owner)
    if inst.miemie ~= nil then
        inst.miemie:Remove()
        inst.miemie = nil
    end
    if inst._yanwu ~= nil then
        inst._yanwu:Remove()
        inst._yanwu = nil
    end
    if inst._ring ~= nil then
        inst._ring:Remove()
        inst._ring = nil
    end
    if inst._light ~= nil then
        inst._light:Turnoff()
        inst._light = nil
    end
    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end
    if inst.numatask ~= nil then
        inst.numatask:Cancel()
        inst.numatask = nil
    end
    if owner.components.tz_xx then
        if owner.components.combat then
            owner.components.combat.externaldamagemultipliers:RemoveModifier("tzxx_level7")
        end
        --inst.components.samaequip.equipsama = 0
    end
	if owner.components.locomotor then
		owner.components.locomotor:RemoveExternalSpeedMultiplier(owner, inst)
	end
end

local function onisraining(inst, israining)
    -- if israining then
    inst.AnimState:PlayAnimation("yutian")
    inst.AnimState:PushAnimation("gouyu_loop", true)
    -- end
end
local function onfinished(inst)
    local spiritualism = SpawnPrefab("tz_spiritualism")
    if spiritualism then
        local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner or nil
        local pt = Vector3(inst.Transform:GetWorldPosition())
        local holder = owner and (owner.components.inventory or owner.components.container)
        local slot = holder and holder:GetItemSlot(inst)
        inst:Remove()
        if holder then
            holder:Equip(spiritualism, slot)
        else
            spiritualism.Transform:SetPosition(pt:Get())
        end
    end
end
local function ontakefuel(inst)
    inst.components.fueled:DoDelta(630)
    local owner = inst.components.inventoryitem.owner
    if owner then
        local pos = Vector3(owner.Transform:GetWorldPosition())
        inst.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
        SpawnPrefab("tz_takefuel").Transform:SetPosition(pos.x - 0.1, pos.y - 2.6, pos.z)
    end
end
local function onblink(staff, pos, caster)
    if caster.components.tzsama then
        caster.components.tzsama:DoDelta(-15)
    end
end
local function onload(inst)
    if inst.components.timer:TimerExists("tzblinkcd") then
        inst:RemoveTag("tzblinkcd")
    end
end

local function updatespeed(inst, phase)
    if phase == "day" then
        inst.components.equippable.walkspeedmult = 1.25
        lightguan(inst)
    elseif phase == "night" then
        inst.components.equippable.walkspeedmult = 1.5
        lightkai(inst)
    elseif phase == "dusk" then
        inst.components.equippable.walkspeedmult = 1.25
        lightguan(inst)
    end
end
local function onattack(inst, attacker, target)
    if target and target:IsValid() then
        if not target.yezhao then
            target.yezhao = 1
        else
            if target.yezhao == 14 then
                target.yezhao = 0
                local delay = 0.0
                local pos = Vector3(target.Transform:GetWorldPosition())
                for i = 1, 4, 1 do
                    inst:DoTaskInTime(delay, function(inst)
                        local shadowmeteor = SpawnPrefab("yezhao_meteor")
                        shadowmeteor.Transform:SetPosition(pos.x, pos.y, pos.z)
                    end)
                    delay = delay + 0.5
                end
            else
                target.yezhao = target.yezhao + 1
            end
        end
    end
end

local function levelfn(inst)
    local level = inst.components.tz_fh_level.level

    inst.components.weapon:SetDamage(17+level)

    if inst.components.equippable:IsEquipped() and inst.components.inventoryitem.owner ~= nil then
        local owner = inst.components.inventoryitem.owner
        if owner and owner.components.locomotor then
            owner.components.locomotor:SetExternalSpeedMultiplier(owner, inst, 1 + level * 0.01)
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("swap_tz_yezhao")
    inst.AnimState:SetBuild("swap_tz_yezhao")
    inst.AnimState:PlayAnimation("idle")
    inst.MiniMapEntity:SetIcon("tz_spiritualism.tex")
    inst:AddTag("sharp")
    inst:AddTag("pointy")
    inst:AddTag("tzblinkcd")
    inst:AddTag("tz_yezhao")
    inst:AddTag("allow_action_on_impassable")
    inst:AddTag("tz_fanhao")
    inst:AddTag("rangedweapon")
    MakeInventoryFloatable(inst, "med", 0.2, {1.1, 0.5, 1.1})
    local old_GetDisplayName = inst.GetDisplayName
    inst.GetDisplayName = function(self,...)
        local level = inst.tz_fh_level ~= nil and inst.tz_fh_level:value() or 0
        if level == 0 then
            return old_GetDisplayName(self,...)
        else
            return old_GetDisplayName(self,...)
            .." +"..level.."\n攻击力已增加 "..level.."\n移动速度 +"..level.."%"
        end
    end

    inst.tz_fh_level = net_ushortint(inst.GUID, "tzfanhaolevel_yezhao")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(17)
    inst.components.weapon:SetRange(18)
    inst.components.weapon:SetProjectile("tz_projectile_bai")
    -- inst.components.weapon:SetOnAttack(onattack)

    inst:AddComponent("tzblink")
    inst.components.tzblink.onblinkfn = onblink
    inst:AddComponent("inspectable")

    inst:AddComponent("samaequip")
    inst.components.samaequip.equipsama = 0

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.NIGHTMARE
    inst.components.fueled:InitializeFuelLevel(4800)
    inst.components.fueled:SetDepletedFn(onfinished)
    inst.components.fueled:SetTakeFuelFn(ontakefuel)
    inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)
    inst.components.fueled.accepting = true

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.MINE)
    inst.components.tool:SetAction(ACTIONS.CHOP)
    inst.components.tool:SetAction(ACTIONS.DIG)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "tz_yezhao"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_yezhao.xml"
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.walkspeedmult = 1.25
    inst.components.equippable.dapperness = -4 / 60

    inst:WatchWorldState("phase", updatespeed)
    updatespeed(inst, TheWorld.state.phase)

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", function()
        inst:AddTag("tzblinkcd")
    end)
    MakeHauntableLaunch(inst)

    inst:AddComponent("tz_fh_level")
    inst.components.tz_fh_level.levelupfn = levelfn
	
	TzFh.tzsama(inst)
	
    onload(inst)
    return inst
end

local function pinkfn()
    local inst = fn()
    inst.AnimState:SetBank("tz_yezhao_pink")
    inst.AnimState:SetBuild("tz_yezhao_pink")
    inst:AddTag("tz_yezhao_pink")
    if not TheWorld.ismastersim then
        return inst
    end
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_yezhao_pink.xml"
    inst.components.inventoryitem.imagename = "tz_yezhao_pink"
    inst.symbolbuild = "tz_yezhao_pink"
    inst.symbolimage = "shochi"
    return inst
end

local function miemie()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()
    inst.entity:AddAnimState()

    inst:AddTag("FX")
    inst.AnimState:SetBank("yezhao_fx")
    inst.AnimState:SetBuild("yezhao_fx")
    inst.AnimState:PlayAnimation("gouyu_loop")
    inst.AnimState:SetScale(1.2, 1.2, 1.2)
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
    inst.persists = false
    -- inst:WatchWorldState("startrain", onisraining)
    --    onisraining(inst, TheWorld.state.israining)
    return inst
end
local function ring()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()
    inst.entity:AddAnimState()

    inst:AddTag("FX")
    inst.AnimState:SetBank("yezhao_fx")
    inst.AnimState:SetBuild("yezhao_fx")
    inst.AnimState:PlayAnimation("ring", true)
    inst.AnimState:SetScale(1.2, 1.2, 1.2)
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
    inst.persists = false
    return inst
end
local function daji(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 1, {"_health", "_combat"},
        {"INLIMBO", "wall", "playerghost", "player", "companion"})
    for i, v in ipairs(ents) do
        if v and v:IsValid() and not v:IsInLimbo() then
            if v.components.combat ~= nil then
                v.components.combat:GetAttacked(inst, 50, inst)
            end
        end
    end
    SpawnPrefab("yezhao_meteorring").Transform:SetPosition(inst.Transform:GetWorldPosition())
end
local function meteor()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()
    inst:AddTag("FX")

    -- inst.Transform:SetTwoFaced()

    inst.AnimState:SetBank("meteor")
    inst.AnimState:SetBuild("meteor")
    inst.AnimState:PlayAnimation("crash")
    inst.AnimState:SetScale(0.7, 0.7, 0.7)
    inst.AnimState:SetFinalOffset(1)
    inst.AnimState:SetMultColour(0, 0, 0, 0.5)
    inst.entity:SetPristine()
    inst.SoundEmitter:PlaySound("dontstarve/common/meteor_impact")
    if not TheWorld.ismastersim then
        return inst
    end
    inst.Transform:SetRotation(math.random(360))
    inst.persists = false
    inst:DoTaskInTime(0.33, daji)
    inst:ListenForEvent("animover", inst.Remove)
    return inst
end
local function bo(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 4, {"_health", "_combat"},
        {"INLIMBO", "wall", "playerghost", "player", "companion"})
    for i, v in ipairs(ents) do
        if v and v:IsValid() and not v:IsInLimbo() then
            if v.components.combat ~= nil then
                v.components.combat:GetAttacked(inst, 35, inst)
            end
        end
    end
    inst:Remove()
end
local function PlayRingAnim(proxy)
    local inst = CreateEntity()

    inst:AddTag("FX")
    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst.Transform:SetFromProxy(proxy.GUID)

    inst.AnimState:SetBank("bearger_ring_fx")
    inst.AnimState:SetBuild("bearger_ring_fx")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetFinalOffset(1)
    inst.Transform:SetScale(0.7, 0.7, 0.7)
    inst.AnimState:SetMultColour(0, 0, 0, 0.5)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)

    inst:ListenForEvent("animover", bo)
end

local function ringfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    if not TheNet:IsDedicated() then
        inst:DoTaskInTime(0, PlayRingAnim)
    end
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
    inst.persists = false
    inst:DoTaskInTime(3, inst.Remove)
    return inst
end
return Prefab("tz_yezhao", fn, assets, prefabs), Prefab("tz_yezhao_pink", pinkfn, assets, prefabs),
    Prefab("yezhao_fx", miemie, lightassets), Prefab("yezhao_ring", ring, lightassets),
    Prefab("yezhao_meteor", meteor, assets), Prefab("yezhao_meteorring", ringfn, boassets)
