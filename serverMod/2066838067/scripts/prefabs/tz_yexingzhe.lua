local TzUtil = require("tz_util")
local TzFh = require("util/tz_fh")

local assets = {Asset("ANIM", "anim/tz_yexingzhe.zip"), Asset("ANIM", "anim/swap_tz_yexingzhe.zip"),
                Asset("ANIM", "anim/yexingzhe_hudunfx.zip"), Asset("ANIM", "anim/yexinglight.zip"),
                Asset("IMAGE", "images/inventoryimages/tz_yexingzhe.tex"),
                Asset("ATLAS", "images/inventoryimages/tz_yexingzhe.xml")}
local fanhaoassets = {Asset("ANIM", "anim/tz_fanhao.zip")}

local upassets = {Asset("ANIM", "anim/attune_fx.zip")}

local prefabs = {"tzyexing_wheel", "tz_thurible_smoke_big", "tz_lightning", "tz_yexingzhe_light", "wathgrithr_spirit",
                 "tz_meteor", "tz_shadow_fx", "tz_groundpoundring_fx", "tz_bfoff", "tz_canying", "tz_bfon"}

local MAX_LIGHT_ON_FRAME = 15
local MAX_LIGHT_OFF_FRAME = 30

local function fly_equipped(inst, data)
    if inst.components.tz_yexinglvl.current == 100 and inst.hudunfx == nil then
        inst.hudunfx = SpawnPrefab("tz_yexiang_hudunfx")
        inst.hudunfx.entity:SetParent((data.owner or inst).entity)
    end
end

local function fly_unequipped(inst)
    if inst.hudunfx ~= nil then
        inst.hudunfx:Kill()
        inst.hudunfx = nil
    end
end

local function onremovewheel(inst)
    if inst._wheel ~= nil then
        inst._wheel:Remove()
        inst._wheel = nil
    end
end

local function upderidle(inst)
    if inst._wheel ~= nil then
        if inst.components.tz_yexinglvl then
            inst._wheel:SetSpinning(inst.components.tz_yexinglvl.current)
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

local function onequip(inst, owner)
    if owner.prefab == "taizhen" then
        owner.AnimState:OverrideSymbol("swap_object", "swap_tz_yexingzhe", "swap_tz_yexingzhe")
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
        if inst._wheel ~= nil then
            inst._wheel:Remove()
        end
        inst._wheel = SpawnPrefab("tzyexing_wheel")
        inst._wheel.entity:SetParent(owner.entity)
        if inst.components.tz_yexinglvl then
            inst._wheel:SetSpinning(inst.components.tz_yexinglvl.current)
        end
        inst:ListenForEvent("yexinglvldelete", upderidle)
        if inst._smoke == nil then
            inst._smoke = SpawnPrefab("tz_thurible_smoke_big")
            inst._smoke.entity:AddFollower()
            inst._smoke._miaomiao = inst
            inst._smoke.Follower:FollowSymbol(owner.GUID, "swap_object", 28, -212, 0)
        end
        inst:ListenForEvent("killed", OnKilled, owner)
        if owner.components.tz_xx and owner.components.tz_xx.dengji > 7 then
            if owner.components.combat then
                owner.components.combat.externaldamagemultipliers:SetModifier("tzxx_level7", 1.25)
            end
            --inst.components.samaequip.equipsama = 12 -- 3				
        end
        if owner.components.combat and inst.components.tz_fh_level.level ~= 0 then
            owner.components.combat.externaldamagemultipliers:SetModifier(inst, 1+inst.components.tz_fh_level.level*0.01)
        end
    else
        if TUNING.TZ_FANHAO_SPECIFIC then
            TzUtil.OnInvalidOwner(inst, owner, 0, STRINGS.NOYEXINGZHE, true)
        end
    end
end

local function onunequip(inst, owner)
    if inst._wheel ~= nil then
        inst._wheel:Remove()
        inst._wheel = nil
    end
    inst:RemoveEventCallback("yexinglvldelete", upderidle)
    inst:RemoveEventCallback("killed", OnKilled, owner)

    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    if inst._smoke ~= nil then
        inst._smoke:Remove()
        inst._smoke = nil
    end
    if inst._light ~= nil then
        inst._light:Turnoff()
        inst._light = nil
    end
    if owner.components.tz_xx then
        if owner.components.combat then
            owner.components.combat.externaldamagemultipliers:RemoveModifier("tzxx_level7")
        end
        --inst.components.samaequip.equipsama = 6
    end
    if owner and owner.components.combat then
		owner.components.combat.externaldamagemultipliers:RemoveModifier(inst)
    end
end

local function updatedamage(inst, phase)
    if phase == "night" then
        inst.components.weapon:SetDamage(72)
        lightkai(inst)
    else
        inst.components.weapon:SetDamage(46)
        lightguan(inst)
    end
end

local function levelfn(inst)
    if inst.components.equippable:IsEquipped() and inst.components.inventoryitem.owner ~= nil then
        local owner = inst.components.inventoryitem.owner
        if owner.components.combat and inst.components.tz_fh_level.level ~= 0 then
            owner.components.combat.externaldamagemultipliers:SetModifier(inst, 1+inst.components.tz_fh_level.level*0.01)
        end
    end
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
    inst.components.fueled:DoDelta(384)
    local owner = inst.components.inventoryitem.owner
    if owner then
        local pos = Vector3(owner.Transform:GetWorldPosition())
        inst.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
        SpawnPrefab("tz_takefuel").Transform:SetPosition(pos.x - 0.1, pos.y - 2.6, pos.z)
    end
    inst.components.tz_yexinglvl:DoDelta(1)
end
local function onattack(inst, attacker, target)
    if target and target:IsValid() and inst.components.tz_yexinglvl.current == 100 then
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
                    delay = delay + 0.8
                end
            else
                target.yezhao = target.yezhao + 1
            end
        end
    end
end

-- light
local function OnUpdateLight(inst, dframes)
    local frame = inst._lightframe:value() + dframes
    if frame >= inst._lightmaxframe then
        inst._lightframe:set_local(inst._lightmaxframe)
        inst._lighttask:Cancel()
        inst._lighttask = nil
    else
        inst._lightframe:set_local(frame)
    end
    local k = frame / inst._lightmaxframe
    if inst._islighton:value() then
        inst.Light:SetRadius(4 * k)
    else
        inst.Light:SetRadius(4 * (1 - k))
    end
    if TheWorld.ismastersim then
        inst.Light:Enable(inst._islighton:value() or frame < inst._lightmaxframe)
        if not inst._islighton:value() then
        end
    end
end

local function OnLightDirty(inst)
    if inst._lighttask == nil then
        inst._lighttask = inst:DoPeriodicTask(FRAMES, OnUpdateLight, nil, 1)
    end
    inst._lightmaxframe = inst._islighton:value() and MAX_LIGHT_ON_FRAME or MAX_LIGHT_OFF_FRAME
    OnUpdateLight(inst, 0)
end
local function Turnoon(inst)
    if not inst._islighton:value() then
        inst._islighton:set(true)
        inst._lightframe:set(math.floor((1 - inst._lightframe:value() / MAX_LIGHT_OFF_FRAME) * MAX_LIGHT_ON_FRAME + .5))
        inst.AnimState:PlayAnimation("on")
        inst.AnimState:PushAnimation("idle")
        OnLightDirty(inst)
    end
end

local function Turnoff(inst)
    if inst._islighton:value() then
        inst._islighton:set(false)
        inst._lightframe:set(math.floor((1 - inst._lightframe:value() / MAX_LIGHT_ON_FRAME) * MAX_LIGHT_OFF_FRAME + .5))
        inst.AnimState:PlayAnimation("off")
        OnLightDirty(inst)
        inst:ListenForEvent("animover", inst.Remove)
    end
end

local function onload(inst)
    if inst.components.timer:TimerExists("tzblinkcd") then
        inst:RemoveTag("tzblinkcd")
    end
end

local function imagechage(inst)
    if inst.components.tz_yexinglvl.current > 99 then
        if inst.components.samaequip then
            inst.components.samaequip.equipsama = 6
        end
        inst:AddTag("tz_yexingzhemax") --这个标签会减少10%的伤害
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("tz_yexingzhe")
    inst.AnimState:SetBuild("tz_yexingzhe")
    inst.AnimState:PlayAnimation("idle")
    inst.MiniMapEntity:SetIcon("tz_spiritualism.tex")
    inst:AddTag("sharp")
    inst:AddTag("pointy")
    inst:AddTag("yexing")
    inst:AddTag("tz_yexing")
    inst:AddTag("tz_fanhao")
    inst:AddTag("rangedweapon")
    inst._lvl = net_byte(inst.GUID, "yexingzhe_lvl", "yexingzhe_lvldirty")

    local old_GetDisplayName = inst.GetDisplayName
    inst.GetDisplayName = function(self,...)
        if inst.tz_fh_level ~= nil and inst.tz_fh_level:value() ~= 0 then
            local level = inst.tz_fh_level:value()
            return (old_GetDisplayName(self, ...) or "") 
                .." +" .. level
                .."\n伤害 +"..level.."%"
                ..string.format("\n最终减伤 +%.2f",level*100/(level+100)).."%"
        else
            return old_GetDisplayName(self, ...)
        end
    end
    inst.tz_fh_level = net_ushortint(inst.GUID, "tzfanhaolevel_yexingzhe")

    MakeInventoryFloatable(inst, "med", 0.2, {1.1, 0.5, 1.1})

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "tz_yexingzhe"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_yexingzhe.xml"
    inst:AddComponent("samaequip")
    inst.components.samaequip.equipsama = 3

    inst:AddComponent("tz_yexinglvl")
    
    inst:AddComponent("weapon")

    inst.components.weapon:SetRange(12)
    inst.components.weapon:SetProjectile("tz_projectile_bai")
    inst.components.weapon:SetOnAttack(onattack)
    inst.components.weapon.heightoffset = 1.2
    inst.components.weapon:SetDamage(46)

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.walkspeedmult = 1.25
    inst.components.equippable.dapperness = -3 / 60

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.NIGHTMARE
    inst.components.fueled:InitializeFuelLevel(3840)
    inst.components.fueled:SetDepletedFn(onfinished)
    inst.components.fueled:SetTakeFuelFn(ontakefuel)
    inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)
    inst.components.fueled.accepting = true
    MakeHauntableLaunch(inst)
    inst:WatchWorldState("phase", updatedamage)
    updatedamage(inst, TheWorld.state.phase)
    inst:ListenForEvent("equipped", fly_equipped)
    inst:ListenForEvent("unequipped", fly_unequipped)
    inst:ListenForEvent("yexinglvldelete", imagechage)
    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", function()
        inst:AddTag("tzblinkcd")
    end)
    onload(inst)
    inst:DoTaskInTime(1, imagechage)

    inst:AddComponent("tz_fh_level")
    inst.components.tz_fh_level.levelupfn = levelfn

    inst:ListenForEvent("onremove", function()
        fly_unequipped(inst)
    end)
	
	TzFh.tzsama(inst)

    return inst
end
local function light()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()
    inst.entity:AddAnimState()

    inst:AddTag("FX")
    inst.AnimState:SetBank("yexinglight")
    inst.AnimState:SetBuild("yexinglight")
    inst.Light:Enable(false)
    inst.Light:SetRadius(0)
    inst.Light:SetFalloff(0.8)
    inst.Light:SetIntensity(.9)
    inst.Light:SetColour(180 / 255, 195 / 255, 150 / 255)
    inst.Light:EnableClientModulation(true)
    inst._lightframe = net_smallbyte(inst.GUID, "tz_yexing._lightframe", "yexinglightdirty")
    inst._islighton = net_bool(inst.GUID, "tz_yexing._islighton", "yexinglightdirty")
    inst._lightmaxframe = MAX_LIGHT_OFF_FRAME
    inst._lightframe:set(inst._lightmaxframe)
    inst._lighttask = nil
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst:ListenForEvent("yexinglightdirty", OnLightDirty)
        return inst
    end
    inst.persists = false
    inst.Turnoon = Turnoon
    inst.Turnoff = Turnoff
    return inst
end

local function zhiliao(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    SpawnPrefab("tz_fanhaobo").Transform:SetPosition(x, y, z)
    local wuti = TheSim:FindEntities(x, y, z, 6, nil, {"fx", "INLIMBO"}, {"player"})
    for i, v in ipairs(wuti) do
        if v and v:IsValid() and v.components.health then
            v.components.health:DoDelta(20, false, inst.prefab)
        end
    end
end
local function xianshi(inst)
    inst.AnimState:PlayAnimation("loop")
    if inst.fangbo == nil then
        inst.fangbo = inst:DoPeriodicTask(3, zhiliao, 3)
    end
    inst:DoTaskInTime(26, function()
        if inst.fangbo then
            inst.fangbo:Cancel()
            inst.fangbo = nil
        end
        inst.AnimState:PlayAnimation("xiaoshi")
        inst:DoTaskInTime(1.8, inst.Remove)
    end)
end

local function fanhaofn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.AnimState:SetBank("tz_fanhao")
    inst.AnimState:SetBuild("tz_fanhao")
    inst.AnimState:PlayAnimation("down")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst.persists = false

    inst:ListenForEvent("animover", xianshi)
    return inst
end
local function fanhaobofn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.AnimState:SetBank("tz_fanhao")
    inst.AnimState:SetBuild("tz_fanhao")
    inst.AnimState:PlayAnimation("ring")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetMultColour(1, 1, 1, 0.75)
    inst:AddTag("FX")
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst.persists = false

    inst:ListenForEvent("animover", inst.Remove)
    return inst
end

local function meteor()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()
    inst:AddTag("FX")

    inst.AnimState:SetBank("attune_fx")
    inst.AnimState:SetBuild("attune_fx")
    inst.AnimState:PlayAnimation("attune_in", true)
    inst.AnimState:SetMultColour(0, 0, 0, 1)
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
    inst.persists = false
    return inst
end

local function kill(inst)
    inst.AnimState:PlayAnimation("ok_pst")
    inst:ListenForEvent("animover", inst.Remove)
end

local function hufn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.AnimState:SetBank("yexingzhe_hudunfx")
    inst.AnimState:SetBuild("yexingzhe_hudunfx")
    inst.AnimState:PlayAnimation("ok_pre")
    inst.AnimState:PushAnimation("ok_loop")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false
    inst.Kill = kill

    return inst
end

return Prefab("tz_yexingzhe", fn, assets), Prefab("tz_yexingzhe_light", light, assets),
    Prefab("tz_fanhao", fanhaofn, fanhaoassets), Prefab("tz_fanhaobo", fanhaobofn, fanhaoassets),
    Prefab("tz_yexiang_up", meteor, upassets), Prefab("tz_yexiang_hudunfx", hufn)
