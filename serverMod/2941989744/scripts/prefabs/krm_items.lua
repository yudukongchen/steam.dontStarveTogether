local Book = require("prefabs/books").book_defs
local SongBook = require("prefabs/battlesongdefs").song_defs

local containers = require "containers"
local cooking = require("cooking")
local params = containers.params

params["krm_uniform"] = {
    widget = {
        slotpos = {},
        animbank = "ui_backpack_2x4",
        animbuild = "ui_backpack_2x4",
        -- pos = Vector3(-5, -70, 0),
        pos = Vector3(-5, -80, 0)
    },
    issidewidget = true,
    type = "pack",
    openlimit = 1
}
local krm_uniformrongqi = params["krm_uniform"]

function krm_uniformrongqi.itemtestfn(container, item, slot)
    return item.prefab ~= "krm_uniform"
end

for y = 0, 3 do
    table.insert(params["krm_uniform"].widget.slotpos, Vector3(-162, -75 * y + 114, 0))
    table.insert(params["krm_uniform"].widget.slotpos, Vector3(-162 + 75, -75 * y + 114, 0))
end

params["krm_zafkiel"] = {
    widget = {
        slotpos = {},
        animbank = "ui_icepack_2x3",
        animbuild = "ui_icepack_2x3",
        pos = Vector3(-5, -70, 0)
        -- pos = Vector3(-5, -80, 0),        
    },
    issidewidget = true,
    type = "pack",
    openlimit = 1
}

-- local krm_zafkielrongqi = params["krm_zafkiel"]

-- function krm_zafkielrongqi.itemtestfn(container, item, slot)
-- return item:HasTag("krm_dregs")
-- end

for y = 0, 2 do
    table.insert(params["krm_zafkiel"].widget.slotpos, Vector3(-162, -75 * y + 75, 0))
    table.insert(params["krm_zafkiel"].widget.slotpos, Vector3(-162 + 75, -75 * y + 75, 0))
end

params["krm_gun"] = {
    widget = {
        slotpos = {Vector3(0, 32 + 4, 0)},
        slotbg = {{
            image = "slingshot_ammo_slot.tex"
        }},
        animbank = "ui_cookpot_1x2",
        animbuild = "ui_cookpot_1x2",
        pos = Vector3(0, 15, 0)
    },
    usespecificslotsforitems = true,
    type = "hand_inv",
    excludefromcrafting = true
}

local krm_krm_gun = params["krm_gun"]

function krm_krm_gun.itemtestfn(container, item, slot)
    return item:HasTag("krm_bullets")
end

-- function params.slingshot.itemtestfn(container, item, slot)
-- return item:HasTag("slingshotammo")
-- end

for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end

local assets = {Asset("ANIM", "anim/krm_gun.zip"), Asset("ANIM", "anim/swap_krm_gun.zip"),
                Asset("ANIM", "anim/swap_krm_gun_hand.zip"), Asset("ANIM", "anim/swap_krm_gun_hand1.zip"),
                Asset("ANIM", "anim/krm_arms.zip"), Asset("ANIM", "anim/krm_items.zip"),
                Asset("ANIM", "anim/krm_flute.zip"), Asset("ANIM", "anim/krm_city.zip"),
                Asset("ANIM", "anim/krm_icebox.zip"), Asset("ANIM", "anim/krm_dregsfx.zip"),
                Asset("ANIM", "anim/krm_bulletfx.zip"), Asset("ANIM", "anim/krm_crystalfx.zip"),
                Asset("ANIM", "anim/krm_zafkielfx.zip"), Asset("ANIM", "anim/krm_icebox_ui_3x6.zip"),
                Asset("ATLAS", "images/inventoryimages/krm_items.xml")}

local function SetPos(inst)
    if inst.owner and inst.owner:IsValid() then
        local facing = inst.owner.AnimState:GetCurrentFacing() or 0
        if facing == 0 or facing == 2 then
            inst.entity:AddFollower():FollowSymbol(inst.owner.GUID, "swap_hat", -250, -200, 0)

        elseif facing == 1 then
            inst.entity:AddFollower():FollowSymbol(inst.owner.GUID, "swap_hat", 0, -250, 0)

        elseif facing == 3 then
            inst.entity:AddFollower():FollowSymbol(inst.owner.GUID, "swap_hat", 0, -200, -1)
        end
    end
end

local function ShouldAcceptItem(inst, item, giver)
    if item ~= nil and item.prefab == "krm_crystal" then
        return true
    end
    return false
end
local function OnGetItem(inst, giver, item)
    if inst then
        inst:SetBooName()
    end
end

local function bofangyinxiao(inst)
    if inst then
        if inst.SoundEmitter then
            inst.SoundEmitter:PlaySound("guipai/NGXY/guipaiya")
        end
    end
end

local function taluopaixiaoguo(inst, reader) ---塔罗牌总代码
	suijitaluopai(inst, reader)
    return true
end
local function taluoyuedu(inst, reader) ---塔罗牌总代码
    if inst.components.rechargeable then
        inst.components.rechargeable:SetCharge(0)
		        taluopaixiaoguo(inst, reader)
    end
	return true
end


local function F2tY(ZNXs3Bwd, Ginn)

        if ZNXs3Bwd:HasTag("notarget") then
            ZNXs3Bwd:RemoveTag("notarget")
        end
end

local function tianjiayinshhen (inst,sKy2P9i)
    local S, AD, AkxLdb66 = sKy2P9i["Transform"]:GetWorldPosition()
	
    for aUR, c4 in pairs(TheSim:FindEntities(S, AD, AkxLdb66, 48, {"_combat"})) do
        if c4 ~= nil and c4 ~= sKy2P9i and c4["components"]["combat"] and c4["components"]["combat"]:TargetIs(sKy2P9i) 
		and (c4["components"]["inventoryitem"] == nil or (c4["components"]["inventoryitem"] and not c4["components"]["inventoryitem"]:IsHeld())) then
			if sKy2P9i:HasTag("notarget") then sKy2P9i:RemoveTag("notarget") end
            return
        end
    end
	
    if not sKy2P9i:HasTag("notarget") then sKy2P9i:AddTag("notarget") end

end

local function tingzhiyinshen (inst,sKy2P9i)
	if sKy2P9i["yinshenxunhuan"] ~= nil then
		sKy2P9i["yinshenxunhuan"]:Cancel()
		sKy2P9i["yinshenxunhuan"] = nil
	end
	if sKy2P9i:HasTag("notarget") then sKy2P9i:RemoveTag("notarget") end
end

local function fn1()
    local inst = CreateEntity()
    inst.entity:AddNetwork()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()

    inst.MiniMapEntity:SetIcon("krm_zafkielfx.tex")

    inst.AnimState:SetBank("krm_zafkielfx")
    inst.AnimState:SetBuild("krm_zafkielfx") ----c_findnext("krm_zafkielfx").AnimState:SetSortOrder(1)
    inst.AnimState:PlayAnimation("idle", true) -- c_findnext("krm_zafkielfx").entity:AddFollower():FollowSymbol(ThePlayer.GUID, "swap_hat", 0, -200, -20)
    -- inst.AnimState:SetSortOrder(2)
    inst.Transform:SetFourFaced()
    -- inst.Transform:SetScale(0.7, 0.7, 0.7)

    inst:AddTag("FX")
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.owner = nil
    inst.persists = false

    inst:DoTaskInTime(4, inst.Remove)
    inst.SetTarget = function(inst, target) -- print(ThePlayer.AnimState:GetCurrentFacing())
        inst.owner = target
        target.zafk = inst
        inst.entity:SetParent(target.entity)
        inst.entity:AddFollower():FollowSymbol(target.GUID, "swap_hat", 0, -200, 0)
        -- inst.Transform:SetPosition(0, 4.6, 0) 

        inst:DoPeriodicTask(0, SetPos)
    end

    return inst
end

local songli = {"durability", "healthgain", "sanitygain", "sanityaura", "fireresistance"}

local function fn3()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("krm_flute.tex")

    inst.AnimState:SetBank("pan_flute")
    inst.AnimState:SetBuild("krm_flute")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "small", 0.05, 0.8)

    inst:AddTag("tool")
    inst:AddTag("flute")
    inst:AddTag("krm_flute")
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("rechargeable")
    inst.components.rechargeable:SetChargeTime(60)
    inst.components.rechargeable:SetOnDischargedFn(function()
        inst:RemoveComponent("instrument")
    end)
    inst.components.rechargeable:SetOnChargedFn(function()
        inst:AddPlay()
    end)
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/krm_items.xml"

    inst.AddPlay = function(inst)
        inst:AddComponent("instrument")
        inst.components.instrument.range = TUNING.PANFLUTE_SLEEPRANGE
        inst.components.instrument:SetOnHeardFn(function(target, musician, instrument)

            if target ~= musician and (TheNet:GetPVPEnabled() or not target:HasTag("player")) and
                not (target.components.freezable ~= nil and target.components.freezable:IsFrozen()) and
                not (target.components.pinnable ~= nil and target.components.pinnable:IsStuck()) and
                not (target.components.fossilizable ~= nil and target.components.fossilizable:IsFossilized()) then
                local mount = target.components.rider ~= nil and target.components.rider:GetMount() or nil
                if mount ~= nil then
                    mount:PushEvent("ridersleep", {
                        sleepiness = 10,
                        sleeptime = TUNING.PANFLUTE_SLEEPTIME
                    })
                end
                if target.components.farmplanttendable ~= nil then
                    target.components.farmplanttendable:TendTo(musician)
                elseif target.components.sleeper ~= nil then
                    target.components.sleeper:AddSleepiness(10, TUNING.PANFLUTE_SLEEPTIME)
                elseif target.components.grogginess ~= nil then
                    target.components.grogginess:AddGrogginess(10, TUNING.PANFLUTE_SLEEPTIME)
                else
                    target:PushEvent("knockedout")
                end
            end
            if target:HasTag("player") then
                local name = songli[math.random(1, #songli)]
                if SongBook["battlesong_" .. name] then
                    inst.components.rechargeable:SetCharge(0)
                    SongBook["battlesong_" .. name]["ONAPPLY"](inst, target)
                end
            end

        end)
    end

    inst:ListenForEvent("floater_startfloating", function(inst)
        inst.AnimState:PlayAnimation("float")
    end)
    inst:ListenForEvent("floater_stopfloating", function(inst)
        inst.AnimState:PlayAnimation("idle")
    end)

    inst:AddPlay()
    MakeHauntableLaunch(inst)

    return inst
end

local MUST_TAG = {"kurumi"}
local function DoKrmHealthDel(inst)
    if inst.krmcity:value() and not inst.components.fueled:IsEmpty() and not inst:IsInLimbo() then
        local dodel = false
        local player = FindEntity(inst, 20, nil, MUST_TAG)
        if player then

            local x, y, z = inst.Transform:GetWorldPosition()
            local nottags = {'FX', 'NOCLICK', 'INLIMBO', 'playerghost', 'companion', 'player', 'wall',
                             'moonstorm_static'}
            local ents = TheSim:FindEntities(x, y, z, 20, {"_combat"}, nottags)
            for k, v in ipairs(ents) do
                if v.components.health and not v.components.health:IsDead() and player.replica.combat:CanTarget(v) and
                    not player.replica.combat:IsAlly(v) then
                    local fx = SpawnPrefab("shadow_teleport_in")
                    fx.Transform:SetPosition(v.Transform:GetWorldPosition())
                    v.components.health:DoDelta(-50)
                    if v.components.locomotor then
                        if v.shizhichengjiansu ~= nil then
                            v.shizhichengjiansu:Cancel()
                            v.shizhichengjiansu = nil
                        end
                        if v.components.locomotor then
                            v.components.locomotor:SetExternalSpeedMultiplier(v, "shizhichengjiansu", 0.3)
                            v.shizhichengjiansu = v:DoTaskInTime(6, function()
                                v.components.locomotor:RemoveExternalSpeedMultiplier(v, "shizhichengjiansu")
                            end)
                        end
                    end
                    dodel = true
                end
            end

            if dodel and not player.components.health:IsDead() then
                player.components.health:DoDelta(10, true, "krm_heal")
            end
        end
    end
end

local function GunChange(inst, owner)
    if inst:HasTag("short_gun") then
        inst:RemoveTag("short_gun")
        inst.components.weapon:SetDamage(inst.damage)
    else
        inst:AddTag("short_gun")
        inst.components.weapon:SetDamage(inst.damage / 3)
    end
    if inst.components.equippable:IsEquipped() then
        local owner = inst.components.inventoryitem.owner or nil
        if owner then
            if inst:HasTag("short_gun") then
                owner.AnimState:OverrideSymbol("swap_object", "swap_krm_gun_hand", "swap_handgun_albert")
            else
                owner.AnimState:OverrideSymbol("swap_object", "swap_krm_gun", "swap_handgun_albert")
            end
        end
    end
end

local function ondeploy(inst, pt, deployer)
    inst.Transform:SetPosition(pt:Get())
    inst.SoundEmitter:PlaySound("dontstarve/common/together/moonbase/repair", nil, 0.3)
end

local function fn4()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("krm_city.tex")

    inst.AnimState:SetBank("krm_city")
    inst.AnimState:SetBuild("krm_city")
    inst.AnimState:PlayAnimation("close")

    inst:AddTag("krm_city")
    inst:AddTag("structure")
    inst:AddTag("portableitem")

    inst.entity:SetPristine()

    inst.krmcity = net_bool(inst.GUID, "KrmCity", "KrmCity")

    if not TheWorld.ismastersim then
        return inst
    end

    --[[    食时之城：（活木*2、红宝石*1、食人花种子*1、时间残渣*6、恶魔燃料*6）放置类道具，放置在地上后右键启动，可以持续两天，填充时间残渣恢复耐久，一个时间残渣恢复5%耐久。
    当狂三位于效果范围内时将缓慢吸收范围内的生物生命值恢复狂三的时间值（无论多少怪物，恢复速率都一样），当范围内有生物死亡时将掉落额外的时间残渣。]]

    inst:AddComponent("inspectable")

    inst:AddComponent("krm_bindaction")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "krm_city"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/krm_items.xml"

    inst:AddComponent("fueled")
    inst.components.fueled:InitializeFuelLevel(960)

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploy
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.NONE)

    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(function(item, fixer, giver)
        if fixer.prefab == "greengem" then
            inst.components.fueled:DoDelta(960)
            inst.SoundEmitter:PlaySound("dontstarve/common/telebase_gemplace")
            return true
        end
        return false
    end)

    inst:ListenForEvent("KrmCity", function(inst)
        if inst.krmcity:value() then
            inst.components.fueled:StartConsuming()
            inst.AnimState:PlayAnimation("open", true)
        else
            inst.components.fueled:StopConsuming()
            inst.AnimState:PlayAnimation("close")
        end
    end)

    inst:ListenForEvent("percentusedchange", function(inst, data)
        if data.percent <= 0 then
            inst.krmcity:set(false)
        end
    end)

    inst:ListenForEvent("entity_death", function(src, data)
        if inst.krmcity:value() and not inst.components.fueled:IsEmpty() then
            if data.inst and data.inst:IsValid() and data.inst.components.health and inst:IsNear(data.inst, 20) and
                not data.inst:HasTag("wall") then
                data.inst:DoTaskInTime(1, function()
                    local maxhealth = data.inst.components.health.maxhealth
                    local num = math.floor(maxhealth / 10000)
                    if num > 0 then
                        SpawnPrefab("krm_crystalfx"):SetInfo(data.inst, num)
                    end
                    num = math.floor((maxhealth - (10000 * num)) / 100)
                    if num > 0 then
                        SpawnPrefab("krm_dregsfx"):SetInfo(data.inst, num)
                    end
                end)
            end
        end
    end, TheWorld)

    inst:DoPeriodicTask(5, DoKrmHealthDel)

    return inst
end

local icebox = Prefabs.icebox.fn
local function fn5()
    local inst = icebox()
    inst.AnimState:SetBank("krm_icebox")
    inst.AnimState:SetBuild("krm_icebox")

    inst:AddTag("krm_icebox")

    if not TheWorld.ismastersim then
        return inst
    end

    if inst.components.container then
        inst.components.container:WidgetSetup("krm_icebox")
        inst:AddComponent("preserver")
        inst.components.preserver:SetPerishRateMultiplier(0)
    end

    return inst
end

local function GivePlayerItem(giver, name, num)
    local item = SpawnPrefab(name)
    local value = math.min(num, item.components.stackable.maxsize)
    item.components.stackable:SetStackSize(value)
    giver.components.inventory:GiveItem(item, nil, giver:GetPosition())
    num = num - value
    if num > 0 then
        GivePlayerItem(giver, name, num)
    end
end

local function OnAmmoLoaded(inst, data)
    if inst.components.weapon ~= nil then
        if data ~= nil and data.item ~= nil then
            inst.components.weapon:SetProjectile(data.item.prefab .. "_proj")
            inst:AddTag("ammoloaded")
            data.item:PushEvent("ammoloaded", {
                slingshot = inst
            })
        end
    end
end

local function OnAmmoUnloaded(inst, data)
    if inst.components.weapon ~= nil then
        inst.components.weapon:SetProjectile(nil)
        inst:RemoveTag("ammoloaded")
        if data ~= nil and data.prev_item ~= nil then
            data.prev_item:PushEvent("ammounloaded", {
                slingshot = inst
            })
        end
    end
end

local function MakeFxs(name, item)
    local function fn()
        local inst = CreateEntity()
        inst.entity:AddNetwork()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()

        inst.AnimState:SetBank(name)
        inst.AnimState:SetBuild(name)
        inst.AnimState:PlayAnimation("idle_loop", true)
        inst.AnimState:SetFinalOffset(3)

        MakeInventoryPhysics(inst)
        RemovePhysicsColliders(inst)

        inst:AddTag("FX")
        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.hasnum = 1
        inst.persists = false

        inst:AddComponent("projectile")
        inst.components.projectile:SetSpeed(6)
        inst.components.projectile:SetRange(20)
        inst.components.projectile:SetHoming(true)
        inst.components.projectile:SetOnHitFn(function(inst, attacker, target)
            if inst:IsValid() then
                GivePlayerItem(target, item, inst.hasnum)
                inst.SoundEmitter:PlaySound("dontstarve/characters/wortox/soul/spawn", nil, .5)
                inst:Remove()
            end
        end)
        inst.components.projectile:SetOnMissFn(inst.Remove)

        inst.SetInfo = function(inst, target, hasnum)
            inst.hasnum = hasnum
            inst.AnimState:PlayAnimation("idle_pre")
            inst.AnimState:PushAnimation("idle_loop")
            inst.Transform:SetPosition(target.Transform:GetWorldPosition())
            inst.SoundEmitter:PlaySound("dontstarve/characters/wortox/soul/spawn", nil, 0.5)
            return inst
        end

        inst:DoTaskInTime(2, function()
            inst.FindTarget = inst:DoPeriodicTask(1, function()
                FindEntity(inst, 10, function(target)
                    inst.components.projectile:Throw(inst, target)
                    inst.FindTarget:Cancel()
                end, {"kurumi"}, {"playerghost"})
            end)
        end)

        inst.OnSave = function(inst, data)
            data.hasnum = inst.hasnum
        end

        inst.OnLoad = function(inst, data)
            if data then
                inst.hasnum = data.hasnum
            end
        end

        return inst
    end

    return Prefab(name, fn)
end

local ToolLi = {ACTIONS.CHOP, ACTIONS.MINE, ACTIONS.DIG}
local DESTSOUNDSMAP = {}
local DESTSOUNDS = {{
    soundpath = "dontstarve/common/destroy_magic",
    ing = {"nightmarefuel", "livinglog"}
}, {
    soundpath = "dontstarve/common/destroy_clothing",
    ing = {"silk", "beefalowool"}
}, {
    soundpath = "dontstarve/common/destroy_tool",
    ing = {"twigs"}
}, {
    soundpath = "dontstarve/common/gem_shatter",
    ing = {"redgem", "bluegem", "greengem", "purplegem", "yellowgem", "orangegem"}
}, {
    soundpath = "dontstarve/common/destroy_wood",
    ing = {"log", "boards"}
}, {
    soundpath = "dontstarve/common/destroy_stone",
    ing = {"rocks", "cutstone"}
}, {
    soundpath = "dontstarve/common/destroy_straw",
    ing = {"cutgrass", "cutreeds"}
}}
for i, v in ipairs(DESTSOUNDS) do
    for i2, v2 in ipairs(v.ing) do
        DESTSOUNDSMAP[v2] = v.soundpath
    end
end
local function GetPrefabName(target)
    local name = target:GetDisplayName() or (target.components.named and target.components.named.name)
    if name and name ~= "MISSING NAME" then
        local adj = target:GetAdjective()
        if adj then
            name = adj .. " " .. name
        end
        if target.components.stackable then
            local size = target.components.stackable:StackSize()
            if size > 1 then
                name = name .. " x" .. tostring(size)
            end
        end
    else
        name = "未知物品"
    end
    return name
end
local function AddFoodInfo(inst, ftype, edibles, eatenfn)
    inst:AddComponent("edible")
    inst.components.edible.foodtype = ftype
    inst.components.edible.healthvalue = edibles[1]
    inst.components.edible.hungervalue = edibles[2]
    inst.components.edible.sanityvalue = edibles[3]
    inst.components.edible:SetOnEatenFn(eatenfn)
end

local function onattack(inst, owner, target)
    if target ~= nil and target:IsValid() then
        -- print("onattack")
    end
end

local function OnEquipToModel(inst, owner, from_ground)
    if inst.components.container ~= nil then
        inst.components.container:Close()
    end
end

local function onattack_knife(inst, owner, target)
    -- print("攻击")
    if inst:HasTag("knife_open") and inst.info[7] ~= nil and type(inst.info[7]) == "number" and inst.info[7] > 0 and
        math.random() <= (inst.info[7] * 0.05) and target ~= nil and target:IsValid() and target.components.freezable then -- T
        target.components.freezable:AddColdness(20)
        target.components.freezable:SpawnShatterFX()
    end

    if baizhinvwangzhenshi and not inst:HasTag("knife_open") then --远程没有 真实伤害
        if math.random() >= 0.9 and target ~= nil and target:IsValid() and target.components.health and
            not target.components.health:IsDead() then -- math.random() >= 0.9 and 
            local mult = inst.info[6] == true and 0.1 or 0.05
            -- print("mult = "..mult)
            local damageNum = target.components.health.maxhealth * mult or 50
            local percent = owner.components.health:GetPercent()
            -- local combat_mult = (percent <= 0.3 and 0.3) or (percent <= 0.4 and 0.25) or (percent <= 0.5 and 0.2) or (percent <= 0.65 and 0.15) or (percent <= 0.9 and 0.1)
            local combat_mult = (percent <= 0.3 and 0.3) or (percent <= 0.4 and 0.26) or (percent <= 0.5 and 0.23) or
                                    (percent <= 0.6 and 0.2) or (percent <= 0.7 and 0.17) or (percent <= 0.8 and 0.15) or
                                    (percent <= 0.9 and 0.1) or 0
            if inst.info[6] == true then
                -- print("伤害翻倍")
                combat_mult = combat_mult * 2
            end

            damageNum = damageNum + (damageNum * combat_mult)
            -- print("真实伤害"..damageNum)
            -- print(combat_mult)

            -- print("攻击提升"..combat_mult)
            target.components.health:DoDelta(-damageNum, nil, (inst.nameoverride or inst.prefab), true, owner, true)

            if target.components.health:IsDead() then -- 如果怪物死亡
                owner:PushEvent("killed", {
                    victim = target
                }) -- 玩家发出击杀事件

                if target.components.combat and target.components.combat.onhitfn ~= nil then -- 如果怪物被攻击会执行特殊函数的话
                    target.components.combat.onhitfn(target, owner, damageNum) -- 执行特殊函数
                end

                if target.components.combat ~= nil and target.components.combat.onkilledbyother ~= nil then -- 如果怪物有死亡会执行特殊函数的话
                    target.components.combat.onkilledbyother(target, owner) -- 执行死亡特殊函数
                end
            end
        end
    end
end

local function OnKill(inst, data) -- nightmarebeak   crawlingnightmare
    if math.random() < TUNING.KURUMI_SHADOW_CHANCE and data.victim ~= nil and data.victim:IsValid() and
        inst.components.leader:CountFollowers("krm_shadow_pet") < 3 then
        -- print("杀死")
        local pet = SpawnPrefab(math.random() > 0.5 and "krm_nightmarebeak" or "krm_crawlingnightmare")
        pet.Transform:SetPosition(data.victim.Transform:GetWorldPosition())

        inst.components.leader:AddFollower(pet)
    end
end

local ClientFn = {
    ["krm_dregs"] = function(inst)
        inst:AddTag("krm_dregs")
        inst.AnimState:SetBank("krm_dregsfx")
        inst.AnimState:SetBuild("krm_dregsfx")
        inst.AnimState:PlayAnimation("idle_loop", true)
    end,
    ["krm_crystal"] = function(inst)
        inst.entity:AddLight()
        inst.Light:SetRadius(0.5)
        inst.Light:SetFalloff(.7)
        inst.Light:SetIntensity(.65)
        inst.Light:SetColour(223 / 255, 208 / 255, 69 / 255)
        inst.Light:Enable(true)
        if inst.components.bloomer ~= nil then
            inst.components.bloomer:PushBloom(inst, "shaders/anim.ksh", 1)
        else
            inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        end
        inst.AnimState:SetBank("krm_crystalfx")
        inst.AnimState:SetBuild("krm_crystalfx")
        inst.AnimState:PlayAnimation("idle_loop", true)
    end,
    ["krm_magazine"] = function(inst)
        inst.AnimState:SetBank("krm_items")
        inst.AnimState:SetBuild("krm_items")
        inst.AnimState:PlayAnimation("krm_magazine")
    end,
    ["krm_zafkiel"] = function(inst)
        inst:AddTag("hide_percentage")
        inst:AddTag("krm_zafkiel")
        inst.AnimState:SetBank("krm_items")
        inst.AnimState:SetBuild("krm_items")
        inst.AnimState:PlayAnimation("krm_zafkiel")
    end,
    ["krm_gun"] = function(inst)
        inst:AddTag("krm_gun")
        inst.AnimState:SetBank("krm_gun")
        inst.AnimState:SetBuild("krm_gun")
        inst.AnimState:PlayAnimation("idle")
    end,
    ["krm_key"] = function(inst)
        inst:AddTag("krm_change")
        inst:AddTag("irreplaceable")
        inst.AnimState:SetBank("krm_key")
        inst.AnimState:SetBuild("krm_arms")
        inst.AnimState:PlayAnimation("idle")
        inst.krmchange = net_bool(inst.GUID, "KrmChange", "KrmChange")
        inst.packname = net_string(inst.GUID, "PackName", "PackName")
    end,
    ["krm_broom"] = function(inst)
        inst:AddTag("irreplaceable")
        inst:AddTag("krm_broom")
        inst.AnimState:SetBank("krm_broom")
        inst.AnimState:SetBuild("krm_arms")
        inst.AnimState:PlayAnimation("idle")
    end,
    ["krm_cane"] = function(inst)

        inst.AnimState:SetBank("krm_cane")
        inst.AnimState:SetBuild("krm_arms")
        inst.AnimState:PlayAnimation("idle")
    end,
    ["krm_knife"] = function(inst)
        inst:AddTag("krm_change")
        inst.AnimState:SetBank("krm_knife")
        inst.AnimState:SetBuild("krm_arms")
        inst.AnimState:PlayAnimation("idle")
        inst.krmchange = net_bool(inst.GUID, "KrmChange", "KrmChange")
    end,
    ["krm_book"] = function(inst)
        inst:AddTag("irreplaceable")
        inst.AnimState:SetBank("krm_items")
        inst.AnimState:SetBuild("krm_items")
        inst.AnimState:PlayAnimation("krm_book")
    end,
    ["krm_uniform"] = function(inst)
        inst.AnimState:SetBank("krm_items")
        inst.AnimState:SetBuild("krm_items")
        inst.AnimState:PlayAnimation("krm_uniform")
    end
}
local ServerFn = {
    ["krm_dregs"] = function(inst)
        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
        AddFoodInfo(inst, FOODTYPE.GOODIES, {0, 0, 0}, function(inst, eater)
            if eater:HasTag("kurumi") then
                eater.components.health:DoDelta(25, true, "krm_heal")
                SpawnPrefab("pocketwatch_heal_fx").entity:SetParent(eater.entity)
            end
        end)
    end,
    ["krm_crystal"] = function(inst)
        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
        AddFoodInfo(inst, FOODTYPE.GOODIES, {0, 0, 0}, function(inst, eater)
            if eater:HasTag("kurumi") then
                eater.components.krm_ability:LeaveUp()
            end
        end)
    end,
    ["krm_magazine"] = function(inst)
        inst:AddComponent("container")
        inst.components.container:WidgetSetup("krm_magazine")
    end,
    ["krm_zafkiel"] = function(inst)
        inst:AddComponent("equippable")
        inst.components.equippable.equipslot = EQUIPSLOTS.BODY
        inst.components.equippable.restrictedtag = "kurumi"
        inst.components.equippable:SetOnEquip(function(inst, owner)
            if owner:HasTag("kurumi") then
                owner:AddTag("krm_recipe")
                owner:AddTag("woodcutter")
                SpawnPrefab("krm_zafkielfx"):SetTarget(owner)
                owner.components.krm_ability:SetSkinKey("kurumi1")
                owner.components.workmultiplier:AddMultiplier(ACTIONS.CHOP, 2, inst)
                owner.components.workmultiplier:AddMultiplier(ACTIONS.MINE, 2, inst)
            end
            if inst.components.container then
                inst.components.container:Open(owner)
            end
        end)
        inst.components.equippable:SetOnUnequip(function(inst, owner)
            if owner:HasTag("kurumi") then
                owner:RemoveTag("krm_recipe")
                owner:RemoveTag("woodcutter")
                owner.components.krm_ability:SetSkinKey("kurumi")
                if owner.zafk and owner.zafk:IsValid() then
                    owner.zafk:Remove()
                    owner.zafk = nil
                end
            end
            if inst.components.container then
                inst.components.container:Close(owner)
            end
        end)
		
		inst:AddComponent("planardefense")
		inst.components.planardefense:SetBaseDefense(10)
		
        inst:AddComponent("armor")
        inst.components.armor:InitIndestructible(0.4)
        inst:AddComponent("container")
        inst.components.container:WidgetSetup("krm_zafkiel")
        inst.components.container.skipclosesnd = true
        inst.components.container.skipopensnd = true
    end,
    ["krm_gun"] = function(inst)
        inst.Change = GunChange
        inst:AddComponent("krm_gun")

        inst.damage = 33
        inst.bullet = nil

        inst:AddComponent("weapon")
        inst.components.weapon:SetRange(7)
        inst.components.weapon:SetDamage(inst.damage)
        inst.components.weapon:SetProjectile("krm_bullet")
        inst.components.weapon:SetOnAttack(onattack)

        inst:AddComponent("container")
        inst.components.container:WidgetSetup("krm_gun")
        inst.components.container.canbeopened = false
        -- inst:ListenForEvent("itemget", OnAmmoLoaded)
        -- inst:ListenForEvent("itemlose", OnAmmoUnloaded)
        inst.components.container.onclosefn = function(inst)
            local bullet = inst.components.container:GetItemInSlot(1)
            if bullet and bullet.prefab == "nightmarefuel" and inst.damage < 51 then
                local num = bullet.components.stackable:StackSize() or 1
                for i = 1, num do
                    if inst.damage < 51 then
                        inst.damage = math.min(inst.damage + 0.2, 51)
                        num = num - 1
                    else
                        break
                    end
                end
                inst.components.weapon:SetDamage(inst.damage)
                if num > 0 then
                    bullet.components.stackable:SetStackSize(num)
                else
                    bullet:Remove()
                end
            end
        end
        inst:AddComponent("equippable")
        inst.components.equippable.restrictedtag = "kurumi"
        inst.components.equippable:SetOnEquip(function(inst, owner)
            if inst:HasTag("short_gun") then
                owner.AnimState:OverrideSymbol("swap_object", "swap_krm_gun_hand", "swap_handgun_albert")
            else
                owner.AnimState:OverrideSymbol("swap_object", "swap_krm_gun", "swap_handgun_albert")
            end

            owner.AnimState:Show("ARM_carry")
            owner.AnimState:Hide("ARM_normal")
            if inst.components.container ~= nil then
                inst.components.container:Open(owner)
            end
        end)

        inst.components.equippable:SetOnUnequip(function(inst, owner)
            owner.AnimState:Hide("ARM_carry")
            owner.AnimState:Show("ARM_normal")
            if inst.components.container ~= nil then
                inst.components.container:Close(owner)
            end
        end)
        inst.components.equippable:SetOnEquipToModel(OnEquipToModel)

        inst.OnSave = function(inst, data)
            data.damage = inst.damage
        end

        inst.OnLoad = function(inst, data)
            if data then
                inst.damage = data.damage or 33
                inst.components.weapon:SetDamage(inst.damage)
            end
        end
    end,
    ["krm_key"] = function(inst)
        inst.package = nil
        inst.krmchange:set_local(false)
        inst.krmchange:set(false)
        inst:AddComponent("follower_krm")
        inst:AddComponent("named")
        inst:AddComponent("krm_bindaction")
        inst:AddComponent("equippable")
        inst.components.equippable:SetOnEquip(function(inst, owner)
            owner.AnimState:OverrideSymbol("swap_object", "krm_arms", "spaw_krm_key")
            owner.AnimState:Show("ARM_carry")
            owner.AnimState:Hide("ARM_normal")
        end)
        inst.components.equippable:SetOnUnequip(function(inst, owner)
            owner.AnimState:Hide("ARM_carry")
            owner.AnimState:Show("ARM_normal")
        end)
        inst:AddComponent("spellcaster")
        inst.components.spellcaster.canuseontargets = true
        inst.components.spellcaster:SetSpellFn(function(tool, target, pos)
                if target and target:HasTag("irreplaceable") or target and target.components.container then
                    return false
                end
            if inst.krmchange:value() then
                local recipe = AllRecipes[target.prefab]
                if recipe and not FunctionOrValue(recipe.no_deconstruction, target) then
                    local ingredient_percent = ((target.components.finiteuses and
                                                   target.components.finiteuses:GetPercent()) or
                                                   (target.components.fueled and target.components.inventoryitem and
                                                       target.components.fueled:GetPercent()) or
                                                   (target.components.armor and target.components.inventoryitem and
                                                       target.components.armor:GetPercent()) or 1) / recipe.numtogive
                    local caster = inst.components.inventoryitem.owner
                    for i, v in ipairs(recipe.ingredients) do
                        if caster and DESTSOUNDSMAP[v.type] then
                            caster.SoundEmitter:PlaySound(DESTSOUNDSMAP[v.type])
                        end
                        if string.sub(v.type, -3) ~= "gem" or string.sub(v.type, -11, -4) == "precious" then
                            local amt = v.amount == 0 and 0 or math.max(1, math.ceil(v.amount * ingredient_percent))
                            for n = 1, amt do
                                if v.type then
                                    local loot = SpawnPrefab(v.type)
                                    if loot then
                                        local x, y, z = target.Transform:GetWorldPosition()
                                        if loot.Physics then
                                            local angle = math.random() * 2 * PI
                                            loot.Physics:SetVel(2 * math.cos(angle), 10, 2 * math.sin(angle))
                                            if target.Physics then
                                                local len = loot:GetPhysicsRadius(0) + target:GetPhysicsRadius(0)
                                                x = x + math.cos(angle) * len
                                                z = z + math.sin(angle) * len
                                            end
                                            loot:DoTaskInTime(1, function(loot)
                                                if loot.components.inventoryitem then
                                                    loot.components.inventoryitem:TryToSink()
                                                else
                                                    local lootx, looty, lootz = loot.Transform:GetWorldPosition()
                                                    if ShouldEntitySink(loot, true) or
                                                        TheWorld.Map:IsPointNearHole(Vector3(lootx, 0, lootz)) then
                                                        SinkEntity(loot)
                                                    end
                                                end
                                            end)
                                        end
                                        loot.Transform:SetPosition(x, y, z)
                                        loot:PushEvent("on_loot_dropped", {
                                            dropper = target
                                        })
                                    end
                                end
                            end
                        end
                    end
                    if target.components.inventory then
                        target.components.inventory:DropEverything()
                    end
                    if target.components.container then
                        target.components.container:DropEverything()
                    end
                    if target.components.spawner and target.components.spawner:IsOccupied() then
                        target.components.spawner:ReleaseChild()
                    end
                    if target.components.occupiable and target.components.occupiable:IsOccupied() then
                        local item = target.components.occupiable:Harvest()
                        if item then
                            item.Transform:SetPosition(target.Transform:GetWorldPosition())
                            item.components.inventoryitem:OnDropped()
                        end
                    end
                    if target.components.trap then
                        target.components.trap:Harvest()
                    end
                    if target.components.dryer then
                        target.components.dryer:DropItem()
                    end
                    if target.components.harvestable then
                        target.components.harvestable:Harvest()
                    end
                    if target.components.stewer then
                        target.components.stewer:Harvest()
                    end
                    target:PushEvent("ondeconstructstructure", caster)
                    if target.components.stackable then
                        target.components.stackable:Get():Remove()
                    else
                        target:Remove()
                    end
                    inst.components.rechargeable:SetCharge(0)
                end
            else
                if inst.package then
                    inst:KeyUnpack(pos)
                    inst.components.rechargeable:SetCharge(0)
                else
                    inst:KeyPack(target)
                end
            end
        end)
        inst.components.spellcaster:SetCanCastFn(function(doer, target, pos)
            if inst.components.rechargeable:IsCharged() then
                return true
            else
                return false
            end
        end)
        inst:AddComponent("rechargeable")
        inst.components.rechargeable:SetChargeTime(60)
        inst.components.rechargeable:SetOnDischargedFn(function()
            inst.components.spellcaster.canuseontargets = false
            inst.components.spellcaster.canusefrominventory = false
        end)
        inst.components.rechargeable:SetOnChargedFn(function()
            inst.components.spellcaster.canuseontargets = true
            inst.components.spellcaster.canusefrominventory = true
        end)

        inst:ListenForEvent("KrmChange", function(inst)
            if inst.krmchange:value() then
                inst.components.spellcaster.canuseonpoint = false
                inst.components.spellcaster.canuseonpoint_water = false
                inst.components.spellcaster.canonlyuseonrecipes = true
                inst.components.spellcaster.canusefrominventory = false
                inst.components.named:SetName(STRINGS.NAMES.KRM_KEY .. ":分解")
            else
                inst.components.spellcaster.canonlyuseonrecipes = false
                inst.components.spellcaster.canusefrominventory = true
                inst.packname:set_local(inst.packname:value())
                inst.packname:set(inst.packname:value())
            end
        end)

        inst:ListenForEvent("PackName", function(inst)
            if inst.packname:value() ~= "" then
                inst.components.spellcaster.canuseonpoint = true
                inst.components.spellcaster.canuseonpoint_water = true
                inst.components.named:SetName(STRINGS.NAMES.KRM_KEY .. ":封印[" .. inst.packname:value() .. "]")
            else
                inst.components.spellcaster.canuseonpoint = false
                inst.components.spellcaster.canuseonpoint_water = false
                inst.components.named:SetName(STRINGS.NAMES.KRM_KEY .. ":封印")
            end
        end)

        inst.CanPackTest = function(inst, target)
            return target and target:IsValid() and not target:IsInLimbo() and
                       not (target:HasTag("teleportato") or target:HasTag("nobundling") or target:HasTag("player") or
                           target:HasTag("nonpackable") or target:HasTag("companion") or target:HasTag("character") or
                           target.prefab == "wormhole" or target.prefab == "beequeenhivegrown" or target.prefab ==
                           "beequeenhive" or target.prefab == "cave_entrance" or target.prefab == "cave_entrance_ruins" or
                           target.prefab == "cave_entrance_open" or target.prefab == "multiplayer_portal" or
                           target.prefab == "tentacle_pillar_hole" or target.prefab == "tentacle_pillar")
        end
        inst.KeyPack = function(inst, target)
            if inst:IsValid() and not inst.package and inst:CanPackTest(target) then
                inst.package = {
                    prefab = target.prefab,
                    name = GetPrefabName(target),
                    skin_id = target.skin_id or nil,
                    skinname = target.skinname or nil
                }
                inst.package.data, inst.package.refs = target:GetPersistData()
                inst.packname:set(inst.package.name)

                if target.components.spawner and target.components.spawner.child and
                    target.components.spawner.child:IsValid() then
                    target.components.spawner.child:Remove()
                    -- target.components.spawner:ReleaseChild()
                end
                target:Remove()
            end
        end
        inst.KeyUnpack = function(inst, pos)
            if inst.package and pos then
                local target = SpawnPrefab(inst.package.prefab, inst.package.skinname, inst.package.skin_id)
                if target then
                    inst.package = nil
                    inst.packname:set("")
                    target.Transform:SetPosition(pos:Get())
                end
            end
        end
        inst.OnSave = function(inst, data)
            data.package = inst.package
            data.packname = inst.packname:value()
        end
        inst.OnLoad = function(inst, data)
            if data then
                inst.package = data.package
                inst.packname:set(data.packname)
            end
        end
    end,
    ["krm_broom"] = function(inst)
        inst:AddComponent("follower_krm")
        inst:AddComponent("equippable")
        inst.components.equippable:SetOnEquip(function(inst, owner)
            owner.AnimState:OverrideSymbol("swap_object", "krm_arms", "spaw_krm_broom")
            owner.AnimState:Show("ARM_carry")
            owner.AnimState:Hide("ARM_normal")
        end)
        inst.components.equippable:SetOnUnequip(function(inst, owner)
            owner.AnimState:Hide("ARM_carry")
            owner.AnimState:Show("ARM_normal")
        end)

        inst:AddComponent("spellcaster")
        inst.components.spellcaster.quickcast = true
        inst.components.spellcaster.canuseontargets = true
        inst.components.spellcaster.canusefrominventory = true
        inst.components.spellcaster:SetSpellFn(function(tool, target, pos)

            if target and target:IsValid() then
                if target and target:HasTag("irreplaceable") or target and target.components.container then
                    return false
                end
                if not target.components.health then
                    local info = target:GetSaveRecord()
                    local item = SpawnPrefab(info.prefab, info.skinname, info.skin_id)
                    if item and item:IsValid() then
                        item:AddTag("yanpin")
                        if item and item.AnimState then
                            item.AnimState:SetScale(2, 2)
                        end

                        if item.Physics then
                            item.Physics:Teleport(target.Transform:GetWorldPosition())
                        else
                            item.Transform:SetPosition(target.Transform:GetWorldPosition())
                        end
                        item:SetPersistData(info.data)
                        if item.components.inventoryitem then
                            item.components.inventoryitem:OnDropped(true, 0.5)
                        end
                    end
                    inst.components.rechargeable:SetCharge(0)
                end
            end
        end)
        inst.components.spellcaster:SetCanCastFn(function(doer, target, pos)
            if inst.components.rechargeable:IsCharged() then
                return true
            else
                return false
            end
        end)
        inst:AddComponent("rechargeable")
        inst.components.rechargeable:SetChargeTime(4800)
        inst.components.rechargeable:SetOnDischargedFn(function()
            inst.components.spellcaster.canuseontargets = false
        end)
        inst.components.rechargeable:SetOnChargedFn(function()
            inst.components.spellcaster.canuseontargets = true
        end)
    end,
    ["krm_cane"] = function(inst)
        inst.info = {0, 0, false}
        inst:AddComponent("weapon")
        inst.components.weapon:SetDamage(34)
        inst:AddComponent("tool")
		inst.components.tool:EnableToughWork(true)
		
		
		
        inst:AddComponent("fishingrod")
        inst.components.fishingrod:SetWaitTimes(5, 10)
        inst.components.fishingrod:SetStrainTimes(60, 60)
		inst:RemoveComponent("fishingrod")
		
        inst:AddComponent("equippable")
        inst.components.equippable.restrictedtag = "kurumi"
        inst.components.equippable:SetOnEquip(function(inst, owner)
            owner.AnimState:OverrideSymbol("swap_object", "krm_arms", "spaw_krm_cane")
            owner.AnimState:Show("ARM_carry")
            owner.AnimState:Hide("ARM_normal")
        end)
        inst.components.equippable:SetOnUnequip(function(inst, owner)
            owner.AnimState:Hide("ARM_carry")
            owner.AnimState:Show("ARM_normal")
        end)
        inst:AddComponent("trader")
        inst.components.trader:SetAcceptTest(function(item, fixer, giver)
            local result = false
            if fixer.prefab == "cane" then
                if inst.info[1] < 0.45 then
                    inst.info[1] = inst.info[1] + 0.05
                    result = true
                end
            elseif fixer.prefab == "gears" then
                if inst.info[2] < 3 then
                    inst.info[2] = inst.info[2] + 1
                    result = true
                end
            elseif fixer.prefab == "opalpreciousgem" then
                if not inst.info[3] then
                    inst.info[3] = true
                    result = true
                end
            end
            inst:SetInfo()
            if result then
                inst.SoundEmitter:PlaySound("dontstarve/common/telebase_gemplace")
            end

            return result
        end)

        inst.SetInfo = function(inst)
            local amount = inst.info[3] and 10 or 1
            inst.components.equippable.walkspeedmult = 1 + inst.info[1]
            for i = 1, inst.info[2] do
                inst.components.tool:SetAction(ToolLi[i], amount)
				inst.components.tool:SetAction(ACTIONS.NET)
				if inst.components.fishingrod == nil then 
				inst:AddComponent("fishingrod")
				inst.components.fishingrod:SetWaitTimes(5, 10)
				inst.components.fishingrod:SetStrainTimes(60, 60)
				end
            end
            if inst.info[3] then
                inst.components.weapon:SetOnAttack(function(inst, owner, target)
                    if target and target:IsValid() then
                        local x, y, z = target.Transform:GetWorldPosition()
                        local ents = TheSim:FindEntities(x, y, z, 3, {"_combat"},
                            {"INLIMBO", "companion", "wall", "abigail", "shadowminion"})
                        for i, v in ipairs(ents) do
                            if v ~= target and v ~= owner and owner.components.combat:IsValidTarget(v) and
                                (owner.components.leader and not owner.components.leader:IsFollower(v)) then
                                owner:PushEvent("onareaattackother", {
                                    target = v,
                                    weapon = inst,
                                    stimuli = nil
                                })
                                v.components.combat:GetAttacked(owner, 34, inst, nil)
                            end
                        end
                    end
                end)
            end
        end
        inst.OnSave = function(inst, data)
            data.info = inst.info
        end
        inst.OnLoad = function(inst, data)
            if data then
                inst.info = data.info
                inst:SetInfo()
            end
        end
    end,

    ["krm_knife"] = function(inst)
        --[[击杀生物时概率召唤小影怪，并10%概率造成生物当前生命值5%的真实伤害，时间值越低伤害越高，最高为当时间值为30%时增加30%伤害。]]
        inst.info = {0, 0, 0, 0, 0, false, 0}
        inst.krmchange:set_local(false)
        inst.krmchange:set(false)

        inst.get_bluegem = false

        inst.atk_num = 0

        inst:AddTag("krm_knife")

        inst:AddComponent("named")
        inst:AddComponent("krm_bindaction")

        inst.Use_Skill =  function(inst,doer)
            inst.krmchange:set(not inst.krmchange:value())
        end

        inst:AddComponent("weapon")
        inst.components.weapon:SetDamage(40)
        inst.components.weapon:SetOnAttack(onattack_knife)
        local olddamage = inst.components.weapon.GetDamage
        inst.components.weapon.GetDamage = function(self, ...)
            local damage = olddamage(self, ...)
            if math.random() < inst.info[3] * 0.03 then
                return 2 * damage
            end
            return damage
        end

        inst:AddComponent("equippable")
        inst.components.equippable.restrictedtag = "kurumi"

        inst.components.equippable:SetOnEquip(function(inst, owner)
            if inst:HasTag("knife_open") then
                owner.AnimState:OverrideSymbol("swap_object", "swap_krm_gun_hand1", "swap_handgun_albert")
            else
                owner.AnimState:OverrideSymbol("swap_object", "krm_arms", "spaw_krm_knife")
            end
            owner.AnimState:Show("ARM_carry")
            owner.AnimState:Hide("ARM_normal")
            owner:ListenForEvent("killed", OnKill)
        end)

        inst.components.equippable:SetOnUnequip(function(inst, owner)
            owner.AnimState:Hide("ARM_carry")
            owner.AnimState:Show("ARM_normal")
            owner:RemoveEventCallback("killed", OnKill)
        end)

        inst.SetMyName = function(inst)
            local basename = inst:HasTag("knife_open") and STRINGS.NAMES.KRM_KNIFE .. ":远程" or
                                 STRINGS.NAMES.KRM_KNIFE .. ":近战"
            local str = ""
            local gemname = {{0, 1}, {"红", 1}, {"紫", 1}, {"橙", 1}, {"黄", 1}, {0, 1}, {"蓝", 1}}
            for i, v in pairs(gemname) do
                if v[1] ~= 0 then
                    if math.floor(inst.info[i] * 100) ~= 0 then
                        local count = inst.info[i]
                        str = str .. (str == "" and "" or " ") .. v[1] .. count
                    end
                end
            end
            if str ~= "" then
                basename = basename .. "\n" .. str
            end
            inst.components.named:SetName(basename)
        end

        inst:AddComponent("trader")
        local old_AcceptGift = inst.components.trader.AcceptGift
        inst.components.trader.AcceptGift = function(self, giver, item, count)
            if item and item.prefab == "krm_crystal" then
                count = item.components.stackable and item.components.stackable.stacksize or 1
            end
            return old_AcceptGift(self, giver, item, count)
        end
        inst.components.trader.onaccept = function(inst, giver, item)
            if item.prefab == "krm_crystal" then
                local count = item.components.stackable and item.components.stackable.stacksize or 1
                inst.info[1] = inst.info[1] + count
                inst:SetInfo()
            end
        end
        inst.components.trader:SetAcceptTest(function(item, fixer, giver)
            local result = false
            if fixer.prefab == "krm_crystal" then
                result = true
            elseif fixer.prefab == "redgem" then
                if inst.info[2] < 20 then
                    inst.info[2] = inst.info[2] + 1
                    result = true
                end

            elseif fixer.prefab == "bluegem" then
                if inst.info[7] ~= nil and type(inst.info[7]) == "number" and inst.info[7] < 10 then
                    inst.info[7] = inst.info[7] + 1
                    result = true
                end
            elseif fixer.prefab == "purplegem" then
                if inst.info[3] < 10 then
                    inst.info[3] = inst.info[3] + 1
                    result = true
                end
            elseif fixer.prefab == "orangegem" then
                if inst.info[4] < 10 then
                    inst.info[4] = inst.info[4] + 1
                    result = true
                end
            elseif fixer.prefab == "yellowgem" then
                if inst.info[5] < 10 then
                    inst.info[5] = inst.info[5] + 1
                    result = true
                end
            elseif fixer.prefab == "opalpreciousgem" then
                if not inst.info[6] then
                    inst.info[6] = true
                    result = true
                end
            end
            inst:SetInfo()
            if result then
                inst.SoundEmitter:PlaySound("dontstarve/common/telebase_gemplace")
            end
            return result
        end)

        inst:ListenForEvent("KrmChange", function(inst)
            if inst.krmchange:value() then
                -- print("远距离")
                inst:AddTag("knife_open")
                inst.components.weapon:SetProjectile("krm_bullet")
                inst.components.weapon:SetOnAttack(function(inst, owner, target)
                    if inst.info[5] > 0 and inst:HasTag("knife_open") and target.components.combat then
                        target.components.combat.externaldamagetakenmultipliers:SetModifier(owner,
                            1 + inst.info[5] * 0.05)
                    end

                    -- owner.components.health:DoDelta(-12.5, true, "krm_heal")
                    if target and target:IsValid() then -- and math.random() < 0.33
                        onattack_knife(inst, owner, target)

                        local x, y, z = target.Transform:GetWorldPosition()
                        local ents = TheSim:FindEntities(x, y, z, 3, {"_combat"},
                            {"INLIMBO", "companion", "wall", "abigail", "shadowminion"})
                        for i, v in ipairs(ents) do
                            if v ~= target and v ~= owner and owner.components.combat:IsValidTarget(v) and
                                (owner.components.leader and not owner.components.leader:IsFollower(v)) and
                                v.components.combat then
                                owner:PushEvent("onareaattackother", {
                                    target = v,
                                    weapon = inst,
                                    stimuli = nil
                                })
                                v.components.combat:GetAttacked(owner, 34, inst, nil)
                            end
                        end
                    end
                end)
            else
                -- print("进距离")
                inst:RemoveTag("knife_open")
                inst.components.weapon:SetProjectile(nil)
                inst.components.weapon:SetOnAttack(onattack_knife)
            end

            if inst.components.equippable:IsEquipped() then
                local owner = inst.components.inventoryitem.owner or nil
                if owner then
                    if inst:HasTag("knife_open") then
                        owner.AnimState:OverrideSymbol("swap_object", "swap_krm_gun_hand1", "swap_handgun_albert")
                    else
                        owner.AnimState:OverrideSymbol("swap_object", "krm_arms", "spaw_krm_knife")
                    end
                end
            end
            inst:SetInfo()
        end)

        inst.SetInfo = function(inst)
            local damage = 40 + inst.info[1] * 0.5 + inst.info[2]
            if inst:HasTag("knife_open") then
                damage = math.min(damage,100)
            end
            inst.components.weapon:SetDamage(damage)
            if inst.krmchange:value() then
                inst.components.weapon:SetRange(5 + inst.info[4] * 0.2)
            else
                inst.components.weapon:SetRange(0 + inst.info[4] * 0.2)
            end
            inst:SetMyName()
        end
        inst.OnSave = function(inst, data)
            data.info = inst.info
        end
        inst.OnLoad = function(inst, data)
            if data then
                inst.info = data.info
                for k, v in pairs(inst.info) do
                    if type(v) == "number" then
                        inst.info[k] = math.floor(v)
                    end
                end
                inst:SetInfo()
            end
        end
    end,
    ["krm_book"] = function(inst)
        inst:AddComponent("follower_krm")
        inst.bukeqiehuan = nil
        -- inst.bookname = nil
        -- inst:AddComponent("named")
        inst:AddComponent("rechargeable")

        inst:AddComponent("book")

        inst.components.rechargeable:SetChargeTime(60)
        inst.components.rechargeable:SetOnDischargedFn(function()
            if inst and inst.components.book then
                inst:RemoveComponent("book")
            end
            inst.bukeqiehuan = 1
        end)
        inst.components.rechargeable:SetOnChargedFn(function()
            inst.bukeqiehuan = nil
            -- inst:SetBooFn()
            if inst.components.book then
            else
                inst:AddComponent("book")
                inst.components.book.onread = taluoyuedu
            end
        end)
        -- inst.components.rechargeable:SetCharge(0)
        inst.components.book.onread = taluoyuedu
        -- inst:WatchWorldState("phase", function(inst, phase)
        -- if phase == "day" then
        -- inst:SetBooName()
        -- end
        -- end)

        -- inst:DoTaskInTime(0.1, function()
        -- if inst.bookname == nil then
        -- inst:SetBooName()
        -- end
        -- end)

        -- inst.SetBooName = function(inst)
        -- inst.bookname = KrmBookLi[math.random(1,#KrmBookLi)]
        -- inst:SetBooFn()
        -- end
        -- inst.SetBooFn = function(inst)
        -- local info = KrmBooks[inst.bookname]
        -- if info then
        -- if inst and inst.components.book then
        -- else
        -- inst:AddComponent("book")
        -- end
        -- if inst and inst.components.book then
        -- inst.components.book:SetOnRead(function(inst, reader)
        -- local result = info.onread(inst, reader)
        -- if result and inst.components.rechargeable then
        -- inst.components.rechargeable:SetCharge(0)
        -- end
        -- return result
        -- end)
        -- inst.components.book:SetOnPeruse(info.perusefn)
        -- inst.components.book:SetReadSanity(info.readsanity)
        -- inst.components.book:SetPeruseSanity(info.perusesanity)
        -- inst.components.book:SetFx(info.fx, info.fxmount)
        -- end
        -- if inst and inst.components.named then inst.components.named:SetName(STRINGS.NAMES.KRM_BOOK..":"..STRINGS.NAMES[string.upper(inst.bookname)]) end
        -- if inst and inst.bukeqiehuan ~= nil and inst.components.book then inst:RemoveComponent("book") elseif inst.components.book == nil then inst:AddComponent("book") end
        -- end
        -- end

        -- inst:AddComponent("trader")
        -- inst.components.trader:SetAcceptTest(ShouldAcceptItem)
        -- inst.components.trader.onaccept = OnGetItem
        -- inst.components.trader.acceptnontradable = true

        inst.OnSave = function(inst, data)
            data.bukeqiehuan = inst.bukeqiehuan
            -- data.bookname = inst.bookname
        end
        inst.OnLoad = function(inst, data)
            if data then
                inst.bukeqiehuan = data.bukeqiehuan
                -- inst.bookname = data.bookname
                -- inst:DoTaskInTime(0.3, inst.SetBooFn)
            end
        end
    end,
    ["krm_uniform"] = function(inst)
        inst:AddComponent("equippable")
        inst.components.equippable.restrictedtag = "kurumi"
        inst.components.equippable.dapperness = 0.093
        inst.components.equippable.walkspeedmult = 1.25
        inst.components.equippable.equipslot = EQUIPSLOTS.BODY
        inst.components.equippable:SetOnEquip(function(inst, owner)
            if owner:HasTag("kurumi") then
				if owner.yinshenxunhuan == nil then
					owner.yinshenxunhuan = owner:DoPeriodicTask(2, function() if inst and owner then tianjiayinshhen (inst,owner) end  end)
				end
				
				if owner.kunwen == nil then
					owner.kunwen = owner:DoPeriodicTask(2, function() 
					
					if owner and owner.components.temperature then
					owner.components.temperature.current = 30 ---让温度循环到30
					end
					
					end)
				end
				
				
				owner:ListenForEvent("onattackother", F2tY)
                owner.components.oldager.base_rate = 1 / 80
                owner.components.krm_ability:SetSkinKey("kurumi3")
                owner.components.combat.externaldamagemultipliers:SetModifier("krm_uniform", xiaofushanghaijiangdi)
            end
            if inst.components.container then
                inst.components.container:Open(owner)
            end
        end)
        inst.components.equippable:SetOnUnequip(function(inst, owner)
            if owner:HasTag("kurumi") then
				if owner and owner["kunwen"] ~= nil then
				owner["kunwen"]:Cancel()
				owner["kunwen"] = nil
				end
                tingzhiyinshen (inst,owner)
				owner:RemoveEventCallback("onattackother", F2tY)
                owner.components.oldager.base_rate = 1 / 40
                owner.components.krm_ability:SetSkinKey("kurumi")
                owner.components.combat.externaldamagemultipliers:RemoveModifier("krm_uniform")
            end
            if inst.components.container then
                inst.components.container:Close(owner)
            end
        end)
        inst:AddComponent("container")
        inst.components.container:WidgetSetup("krm_uniform")
        inst.components.container.skipclosesnd = true
        inst.components.container.skipopensnd = true

    end
}
local function MakeItems(name)
    local function fn()
        local inst = CreateEntity()
        inst.entity:AddNetwork()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        if name and name ~= "krm_dregs" and name ~= "krm_crystal" then
            inst.entity:AddMiniMapEntity()
        end
        inst.entity:AddSoundEmitter()

        if name and name ~= "krm_dregs" and name ~= "krm_crystal" then
            inst.MiniMapEntity:SetIcon(name .. ".tex")
        end
        ClientFn[name](inst)
        MakeInventoryPhysics(inst)
        MakeInventoryFloatable(inst, "small", 0.05, {1.2, 0.75, 1.2})

        inst:AddTag(name)
        inst:AddTag("krm_items")
        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("tradable")
        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = "images/inventoryimages/krm_items.xml"

        ServerFn[name](inst)

        return inst
    end

    return Prefab(name, fn)
end

local function MakeBullets(name)
    local function fn()
        local inst = CreateEntity()
        inst.entity:AddNetwork()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()

        inst.AnimState:SetBank("krm_items")
        inst.AnimState:SetBuild("krm_items")
        inst.AnimState:PlayAnimation(name)

        MakeInventoryPhysics(inst)
        MakeInventoryFloatable(inst, "small", 0.05, {1.2, 0.75, 1.2})

        inst:AddTag(name)
        inst:AddTag("krm_bullets")
        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("tradable")
        inst:AddComponent("inspectable")
        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = "images/inventoryimages/krm_items.xml"

        return inst
    end

    return Prefab(name, fn)
end



mpatubiaozhuce("images/inventoryimages/krm_items.xml")

return Prefab("krm_zafkielfx", fn1, assets), Prefab("krm_flute", fn3), Prefab("krm_city", fn4),
    Prefab("krm_icebox", fn5), MakeFxs("krm_dregsfx", "krm_dregs"), MakeFxs("krm_crystalfx", "krm_crystal"),
    MakeItems("krm_gun"), MakeItems("krm_key"), MakeItems("krm_broom"), MakeItems("krm_cane"), MakeItems("krm_knife"),
    MakeItems("krm_book"), MakeItems("krm_dregs"), MakeItems("krm_crystal"), MakeItems("krm_magazine"),
    MakeItems("krm_zafkiel"), MakeItems("krm_uniform"), MakeBullets("krm_bullet1"), MakeBullets("krm_bullet2"),
    MakeBullets("krm_bullet3"), MakeBullets("krm_bullet4"), MakeBullets("krm_bullet5"), MakeBullets("krm_bullet6"),
    MakeBullets("krm_bullet7"), MakeBullets("krm_bullet8"), MakeBullets("krm_bullet9"), MakeBullets("krm_bullet10"),
    MakeBullets("krm_bullet11"), MakeBullets("krm_bullet12"),
    MakePlacer("krm_icebox_placer", "krm_icebox", "krm_icebox", "closed"),
    MakePlacer("krm_city_placer", "krm_city", "krm_city", "close")
