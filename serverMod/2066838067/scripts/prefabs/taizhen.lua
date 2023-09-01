local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
	Asset("ANIM", "anim/taizhen.zip"), 
	Asset("ANIM", "anim/taizhen_blue.zip"),
    Asset("ANIM", "anim/taizhen_yellow.zip"), 
	Asset("ANIM", "anim/taizhen_yellowpro.zip"),
    Asset("ANIM", "anim/taizhen_black.zip"), 
	Asset("ANIM", "anim/taizhen_avatar.zip"),
	Asset("ANIM", "anim/swap_tzwings.zip"), 
	Asset("ANIM", "anim/ghost_taizhen_build.zip")}

local prefabs = {
	"cane_ancient_fx", 
	"shadow_despawn", 
	"statue_transition_2", 
	"tz_mindcontroller", 
	"tz_shadow_fx",
}

local start_inv = {
	"tz_spiritualism", 
	"tz_evil_teacher", 
	"nightmarefuel", 
	"nightmarefuel", 
	"nightmarefuel",
    "nightmarefuel", 
	"nightmarefuel"
}

for j = 0, 3, 3 do
    for i = 1, 3 do
        table.insert(prefabs, "shadow_shield" .. tostring(j + i))
    end
end
local function PickShield(inst)
    local t = GetTime()
    local flipoffset = math.random() < .5 and 3 or 0
    local dt = t - inst.lastmainshield
    if dt >= 1.2 then
        inst.lastmainshield = t
        return flipoffset + 3
    end

    local rnd = math.random()
    if rnd < dt / 1.2 then
        inst.lastmainshield = t
        return flipoffset + 3
    end

    return flipoffset + (rnd < dt / (1.2 * 2) + .5 and 2 or 1)
end

local TRAIL_FLAGS = {"shadowtrail"}
local function cane_do_trail(inst)
    local owner = inst
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
    local offset = FindValidPositionByFan(math.random() * 2 * PI, (mounted and 1 or .5) + math.random() * .5, 4,
        function(offset)
            local pt = Vector3(x + offset.x, 0, z + offset.z)
            return map:IsPassableAtPoint(pt:Get()) and not map:IsPointNearHole(pt) and
                       #TheSim:FindEntities(pt.x, 0, pt.z, .7, TRAIL_FLAGS) <= 0
        end)

    if offset ~= nil then
        SpawnPrefab("cane_ancient_fx").Transform:SetPosition(x + offset.x, 0, z + offset.z)
    end
end

local function cccc(inst, owner, food)
    local projectile = SpawnPrefab("tz_projectile")
    if projectile then
        projectile.AnimState:SetMultColour(0, 0, 0, 0.1)
        projectile.Transform:SetPosition(inst.Transform:GetWorldPosition())
        if projectile.components.projectile then
            projectile.components.projectile:SetOnHitFn(function(qiu, owner, target)
                if target:IsValid() then
                    if target.components.tzsama then
                        target.components.tzsama:DoDelta(food.sama / 2)
                    end
                    if target.components.sanity then
                        target.components.sanity:DoDelta(food.sanity / 2)
                    end
                    target:SpawnChild("tz_fireball_hit_fx")
                    local fx = SpawnPrefab("tz_fireball_hit_fx")
                    fx.Transform:SetPosition(target.Transform:GetWorldPosition())
                    fx.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
                end
                qiu:Remove()
            end)
            projectile.components.projectile:Throw(projectile, owner)
        end
    end
end

local huifufoood = {
    nightmarefuel = {
        sanity = 12,
        sama = 30
    },
    nightmarefuel_spirit = {
        sanity = 30,
        sama = 50
    }
}
local function oneat(inst, food)
    if food and food.components.edible then
        if huifufoood[food.prefab] then
            local nightbuff = inst.components.tz_xx.nightbuff
            inst.components.tzsama:DoDelta(huifufoood[food.prefab].sama + huifufoood[food.prefab].sama * nightbuff)
            inst.components.sanity:DoDelta(huifufoood[food.prefab].sanity * nightbuff)
            if inst.components.tz_xx.dengji > 6 then
                local x, y, z = inst.Transform:GetWorldPosition()
                local ents = TheSim:FindEntities(x, 0, z, 16, {"taizhen"})
                for i, v in ipairs(ents) do
                    if v ~= inst and not (v.components.health and v.components.health:IsDead()) then
                        cccc(inst, v, huifufoood[food.prefab])
                    end
                end
            end
        end
    end
end

local function onbecamehuman(inst, isghost)
    if inst._trailtask ~= nil then
        inst._trailtask:Cancel()
        inst._trailtask = nil
    end
end
local function ontzsama(inst)
    inst.components.tzsama:SetCurrentSama(100)
    local tzsama_percent = inst.components.tzsama:GetPercent()
    inst.components.tzsama:SetPercent(tzsama_percent)
end

local function DoEffects(pet)
    local x, y, z = pet.Transform:GetWorldPosition()
    SpawnPrefab("shadow_despawn").Transform:SetPosition(x, y, z)
    SpawnPrefab("statue_transition_2").Transform:SetPosition(x, y, z)
end

local function KillPet(pet)
    DoEffects(pet)
    if pet.components.container ~= nil then
        pet.components.container:DropEverything()
    end
    pet:Remove()
end

local function OnSpawnPet(inst, pet)
    if pet:HasTag("tzlostday") then
        pet:DoTaskInTime(0, DoEffects)
        if not (inst.components.health:IsDead() or inst:HasTag("playerghost")) then
            inst.components.sanity:AddSanityPenalty(pet, 0.1)
            inst:ListenForEvent("onremove", inst._onpetlost, pet)
        elseif pet._killtask == nil then
            pet._killtask = pet:DoTaskInTime(math.random(), KillPet)
        end
    elseif inst._OnSpawnPet ~= nil then
        inst:_OnSpawnPet(pet)
    end
end

local function OnDespawnPet(inst, pet)
    if pet:HasTag("tzlostday") then
        DoEffects(pet)
        pet:Remove()
    elseif inst._OnDespawnPet ~= nil then
        inst:_OnDespawnPet(pet)
    end
end

local function OnDespawnXinPet(inst, pet)
    local x, y, z = pet.Transform:GetWorldPosition()
    SpawnPrefab("sanity_lower").Transform:SetPosition(x, y, z)
    pet:Remove()
end

local function Onattacked(inst, data)
    if data and data.damageresolved ~= nil and data.attacker ~= nil then
        if inst.components.tzsama and inst.components.tzsama.current > 50 then
            if inst.components.rider and inst.components.rider:IsRiding() then
                return
            end
            if inst:HasTag("taizhen_black") and inst.components.tzsama.current > 60 then
                return
            end
            if inst.components.health.absorb == 0.8 then
                inst.components.tzsama:DoDelta(-data.damageresolved * 1.5)
            else
                inst.components.tzsama:DoDelta(-data.damageresolved)
            end
            local fx = SpawnPrefab("shadow_shield" .. tostring(PickShield(inst)))
            fx.entity:SetParent(inst.entity)
        end
    end
end

local function OnSamachange(inst)
	if inst._bianshen:value() then
		inst.components.combat.damagebonus = inst.components.tzsama.current * 0.1
	else
		inst.components.combat.damagebonus = 0
	end
    if inst.components.tzsama.current < 40 and inst._bianshen:value() == true and not inst.components.health:IsDead() and
        not inst.sg:HasStateTag("busy") then
        inst.sg:GoToState("tz_cosplay_a")
    end
    if inst.components.tzsama and inst.components.tzsama.current > 50 then
        local wuqi = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if wuqi ~= nil and wuqi.components.tz_yexinglvl and wuqi.components.tz_yexinglvl.current == 100 then
            inst.components.health.absorb = 0.8
        else
            inst.components.health.absorb = 0.5
        end
        inst.components.sanity.dapperness = 0
    elseif inst.components.tzsama.current > 40 then
        inst.components.health.absorb = 0.0
        inst.components.sanity.dapperness = -5 / 60
    elseif inst.components.tzsama.current > 0 then
        inst.components.health.absorb = 0.0
        inst.components.sanity.dapperness = -10 / 60
    else
        inst.components.health.absorb = 0.0
        inst.components.sanity.dapperness = -30 / 60
    end
end

-- death
local function OnDeath(inst)
    for k, v in pairs(inst.components.petleashlostday:GetPets()) do
        if v._killtask == nil then
            v._killtask = v:DoTaskInTime(math.random(), KillPet)
        end
    end
    if inst._bianshen:value() == true then
        inst._bianshen:set(false)
    end
    -- change 2019-05-18
    inst:RemoveTag("taizhen_yellowpro")
    -- change 
    inst:RemoveTag("taizhen_yellow")
    inst:RemoveTag("taizhen_blue")
    inst:RemoveTag("taizhen_black")
    inst:RemoveTag("taizhen_pink")
    inst._blue = false
    inst._yellow = false
    -- change 2019-05-18
    inst._yellowpro = false
    -- change 
    inst._black = false
    inst._pink = false
    inst.components.temperature.inherentinsulation = 0
    inst.components.temperature.inherentsummerinsulation = 0
    inst.components.tzsama:DoDeath()
end
local function tzyifu(inst)
    if inst._yellow then
        inst.components.temperature.inherentinsulation = 60
        inst.components.temperature.inherentsummerinsulation = 0
        inst:AddTag("taizhen_yellow")
        inst:RemoveTag("taizhen_blue")
        inst:RemoveTag("taizhen_black")
        inst:RemoveTag("taizhen_pink")
        inst:RemoveTag("taizhen_yellowpro")
        inst.AnimState:SetBuild("taizhen_yellow")
        inst.AnimState:OverrideSymbol("backpack", "swap_tzwings", "backpack")
        inst.AnimState:OverrideSymbol("swap_body", "swap_tzwings", "swap_body")
        inst.AnimState:ClearOverrideSymbol("swap_hat")
        inst.AnimState:Show("hair")
    elseif inst._blue then
        inst.AnimState:SetBuild("taizhen_blue")
        inst:AddTag("taizhen_blue")
        inst:RemoveTag("taizhen_yellow")
        inst:RemoveTag("taizhen_black")
        inst:RemoveTag("taizhen_yellowpro")
        inst:RemoveTag("taizhen_pink")
        inst.components.temperature.inherentinsulation = 0
        inst.components.temperature.inherentsummerinsulation = 60
    elseif inst._black then
        inst.AnimState:SetBuild("taizhen_black")
        inst:AddTag("taizhen_black")
        inst:RemoveTag("taizhen_yellow")
        inst:RemoveTag("taizhen_blue")
        inst:RemoveTag("taizhen_pink")
        inst:RemoveTag("taizhen_yellowpro")
        inst.components.temperature.inherentinsulation = 0
        inst.components.temperature.inherentsummerinsulation = 0
        -- change 2019-05-18
    elseif inst._yellowpro then
        inst.AnimState:SetBuild("taizhen_yellowpro")
        inst:RemoveTag("taizhen_black")
        inst:RemoveTag("taizhen_yellow")
        inst:RemoveTag("taizhen_blue")
        inst:RemoveTag("taizhen_pink")
        inst:AddTag("taizhen_yellowpro")
        -- change
    elseif inst._pink then
        inst.AnimState:SetBuild("taizhen_pink")
        inst:RemoveTag("taizhen_black")
        inst:RemoveTag("taizhen_yellow")
        inst:RemoveTag("taizhen_blue")
        inst:RemoveTag("taizhen_yellowpro")
        inst:AddTag("taizhen_pink")
    end
end

-- appear angry dissipate hit idle shy
local function getbuild(inst)
    local normal_skin = inst.prefab

    local skin_name = inst.components.skinner.skin_name
    if skin_name ~= nil and skin_name ~= "" then
        local skin_prefab = Prefabs[skin_name] or nil
        if skin_prefab and skin_prefab.skins and skin_prefab.skins.normal_skin ~= nil then
            normal_skin = skin_prefab.skins.normal_skin
        end
    end
    return normal_skin
end

local function SetBuild(inst)
    if inst._bianshen:value() == false then
        inst.AnimState:SetBuild(getbuild(inst))
    else
        inst.AnimState:SetBuild("taizhen_avatar")
    end
end

local IsFlying = function(inst)
    if inst.components.rider and inst.components.rider:IsRiding() then
        return true
    elseif inst.components.mk_flyer and inst.components.mk_flyer:IsFlying() then
        return true
    end
    return false
end
local function jiaoyin(inst)
    if not IsFlying(inst) and inst.components.locomotor.wantstomoveforward then
        local jiaoyin = SpawnPrefab("tz_jioyin")
        jiaoyin.Transform:SetPosition(inst.Transform:GetWorldPosition())
        jiaoyin.Transform:SetRotation(inst.Transform:GetRotation())
        jiaoyin.AnimState:PlayAnimation(inst.left and "left" or "right")
        inst.left = not inst.left
    end
end

local function SetNewState(inst)
    if inst._bianshen:value() == false then
        inst.components.combat.damagemultiplier = 1
        inst.components.combat:SetDefaultDamage(10)
		inst.components.tzsama:DoDelta(0, true)
        inst.components.locomotor:SetExternalSpeedMultiplier(inst, "tz_bishen", 1)
        if inst.jiaoyinfx ~= nil then
            inst.jiaoyinfx:Cancel()
            inst.jiaoyinfx = nil
        end
        inst.components.tz_skill_saver:LoadSkill("mama", true)
    else
        if not inst.nochangeskill then
            inst.components.tz_skill_saver:Transform_Skill("mama")
        else
            inst.nochangeskill = false
        end
        inst.components.locomotor:SetExternalSpeedMultiplier(inst, "tz_bishen", 1.25)
        inst.components.combat.damagemultiplier = 2
        inst.components.combat:SetDefaultDamage(10)
		inst.components.tzsama:DoDelta(0, true)
        inst.left = true
        inst.jiaoyinfx = inst:DoPeriodicTask(0.2, function(inst)
            jiaoyin(inst)
        end)
    end
    SetBuild(inst)
end

local function onsave(inst, data)
    data._yellow = inst._yellow or nil
    -- change 2019-05-18
    data._yellowpro = inst._yellowpro or nil
    -- change
    data._blue = inst._blue or nil
    data._black = inst._black or nil
    data._pink = inst._pink or nil

    data.isfeilong = inst.isfeilong -- 骑龙
    data.is_shikong = inst.is_shikong -- 时空旅行
    -- data["数据"] = inst["数据"] or nil
    -- 变身
    data._bianshen = inst._bianshen:value() == true and true or nil
end

local function onload(inst)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    inst:ListenForEvent("ms_respawnedfromghost", ontzsama)
    if not inst:HasTag("playerghost") then
        onbecamehuman(inst, false)
        SetBuild(inst)
    else
    end
end

local function onpreload(inst, data)
    if data ~= nil then
        -- if data["数据"] then
        -- inst["数据"] = data["数据"]
        -- if inst["数据"]["赤子之心"] then
        -- inst.components.builder["太真_鑫_科技_解锁道具_赤子之心_bonus"] = 2
        -- end
        -- end
        if data.isfeilong ~= nil then
            inst.isfeilong = data.isfeilong
            if inst.isfeilong then
                inst:feilongup()
            end
        end
		inst.is_shikong = data.is_shikong
    end
    if data ~= nil and data._bianshen then
        inst.nochangeskill = true
        inst._bianshen:set(true)
    elseif data ~= nil and data._yellow then
        inst._yellow = data._yellow
        -- change 2019-05-18
    elseif data ~= nil and data._yellowpro then
        inst._yellowpro = data._yellowpro
        -- change
    elseif data ~= nil and data._blue then
        inst._blue = data._blue
    elseif data ~= nil and data._black then
        inst._black = data._black
    elseif data ~= nil and data._pink then
        inst._pink = data._pink
    end

    if data ~= nil and data.tz_xx ~= nil then
        inst.level = data.level
        inst.components.hunger.max = math.ceil(150 + (data.tz_xx.ba or 0) * 2)
        inst.components.health.maxhealth = math.ceil(75 + (data.tz_xx.sh or 0))
        inst.components.sanity.max = math.ceil(200 + (data.tz_xx.hd or 0))
        if data.health ~= nil and data.health.health ~= nil then
            inst.components.health:SetCurrentHealth(data.health.health)
        end
        if data.hunger ~= nil and data.hunger.hunger ~= nil then
            inst.components.hunger.current = data.hunger.hunger
        end
        if data.sanity ~= nil and data.sanity.current ~= nil then
            inst.components.sanity.current = data.sanity.current
        end
        inst.components.health:DoDelta(0)
        inst.components.hunger:DoDelta(0)
        inst.components.sanity:DoDelta(0)
    end
end
local function OnMaxSama(inst, data)
    if data and data.num then
        if inst.components.petleashlostday then
            inst.components.petleashlostday:SetMaxPets(3 + math.floor(data.num / 400))
        end
    end
end
local function OnSpeed(inst)
    inst.components.locomotor:SetExternalSpeedMultiplier(inst, "TzLost", 1 + inst._speed:value() * 0.15)
end

local function onbianshen(inst)
    if inst._bianshen:value() == false then
        inst.MiniMapEntity:SetIcon("taizhen.tex")
    else
        inst.MiniMapEntity:SetIcon("taizhen_avatar.tex")
    end
    if TheWorld.ismastersim then
        SetNewState(inst)
    end
end

local function OnKilled(inst, data)
    if data and data.victim ~= nil and data.victim.Transform ~= nil then
        if not (inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) == nil and inst._bianshen:value() == true) then
            return
        end
        local health = (data.victim.components.health and data.victim.components.health.maxhealth or 0) * 0.05
        local x, y, z = data.victim.Transform:GetWorldPosition()
        inst:DoTaskInTime(0.5, function()
            local fx = SpawnPrefab("tz_healthball_fx_pre")
            fx.Transform:SetPosition(x, y, z)
            fx.owner = inst
            fx.health = health
        end)
    end
end

local function onhitother(inst, data)
    if data and data.target and not inst.hit_mubiao[data.target.GUID] then
        if (inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) == nil and inst._bianshen:value()) then
            inst.hit_mubiao[data.target.GUID] = true
        end
    end
    if inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) == nil and inst._bianshen:value() == true and
        not inst.components.health:IsDead() and inst.ghosthsnd_samaskilladd and (inst.ghosthsnd_samaskilladd < 5) then
			inst.ghosthsnd_samaskilladd = inst.ghosthsnd_samaskilladd + 1
			inst.components.tzsama:DoDelta(1, true)
    end
end

local function onfhtime(inst)
    inst:PushEvent("tzfhbmtime", {
        time = inst.tzfhbmtime:value()
    })
end
local function ontz_gogglevision(inst)
    if inst.components.playervision then
        local self = inst.components.playervision
        if self.gogglevision == not inst.replica.inventory:EquipHasTag("goggles") then
            self.gogglevision = not self.gogglevision
            if not self.forcegogglevision then
                inst:PushEvent("gogglevision", { enabled = self.gogglevision })
            end
        end
    end
end

local common_postinit = function(inst)
    inst:AddTag("taizhen")
    inst:AddTag("taizhennomal")
    inst:AddTag("tz_builder")
    inst.MiniMapEntity:SetIcon("taizhen.tex")

    inst._bianshen = net_bool(inst.GUID, "tz._bianshen", "tz_bianshendirty")
    inst._speed = net_tinybyte(inst.GUID, "tz.currentspeed", "tzspeeddirty")
    inst._tzsamamax = net_ushortint(inst.GUID, "tzsama.current", "tzsamamaxdirty")
    inst._tzsamacurrent = net_ushortint(inst.GUID, "tzsama.max", "tzsamacurrentdirty")
    inst._tzsamaratescale = net_tinybyte(inst.GUID, "tzsama.ratescale")
    inst._tzsamadeath = net_float(inst.GUID, "tzsama.death")

    inst.tzfhbmtime = net_float(inst.GUID, "tzfhbmtime", "tzfhbmtimedirty")

    inst.tz_gogglevision = net_bool(inst.GUID, "tz_gogglevision", "tz_gogglevisiondirty")

    inst.isxiuxian = net_bool(inst.GUID, "tz._isxiuxian", "tz_isxiuxiandirty")
    inst.tz_xx = net_bytearray(inst.GUID, "tz_xx", "tz_xxdrity")
    inst.tz_xx_level = net_smallbyte(inst.GUID, "tz_xx_level", "tz_xx_leveldrity")
    inst.tz_xx_skill = net_tinybyte(inst.GUID, "tz_xx_skill", "tz_xx_skilldrity")

    inst.fh_ly_gy = net_bytearray(inst.GUID, "fh_ly_gy", "fh_ly_gydrity")

    inst:ListenForEvent("tz_bianshendirty", onbianshen)
    inst:ListenForEvent("tzfhbmtimedirty", onfhtime)
    inst:ListenForEvent("tz_gogglevisiondirty", ontz_gogglevision)

    if inst.components.playervision then
        inst.components.playervision.SetGhostVision = function(self, ...)
            self.ghostvision = false
        end
    end
end

local function getpenaltydamage(num)
    if num > 0.5 then
        return 1.6
    elseif num > 0.25 then
        return 1.3
    elseif num > 0 then
        return 1.15
    end
    return 0
end
local function getyexingzhe(self)
    for k, v in pairs(self.equipslots) do
        if v:HasTag("yexing") and v.components.tz_fh_level and v.components.tz_fh_level.level ~= 0 then
            return v.components.tz_fh_level.level
        end
    end
end
local function OnTimerDone(inst, data)
    if data.name == "sama_max_cd" then
        inst.components.tzsama:OutDeath()
        inst.components.timer:StartTimer("sama_max_cd", 10 * 480)
    end
end
local master_postinit = function(inst)
    -- inst["数据"] = {}

    inst.hit_mubiao = {}
    inst.soundsname = "wallace"
    inst._yellow = false
    inst._blue = false
    inst._black = false
    inst._pink = false

    inst.feilongup = function(inst)
        -- 骑龙
        if not (inst.components.rider:IsRiding() or inst:HasTag("playerghost")) then
			-- if inst.components.freezable and inst.components.freezable:IsFrozen() then
				-- inst.components.freezable:Unfreeze()
			-- end
			inst.sg:GoToState("idle")
            inst:SetStateGraph("SGtz_feilong")
            inst.sg:GoToState("ks")
            inst.isfeilong = true
        end
    end
    inst.feilonglow = function(inst)
        -- 下来
        inst.sg:GoToState("exit")
        inst.isfeilong = false
    end

    inst:AddComponent("tzsama")
    inst.components.tzsama:SetMax(225)

    inst:AddComponent("tz_xx")

    inst:AddComponent("tz_xx_ling")

    -- Ly modifide:Add Taizhen Skill saver to save or load skill table 
    inst:AddComponent("tz_skill_saver")

    inst:AddComponent("fh_ly_gy")

    inst._hungertask = nil
    inst.lastmainshield = 0
    inst.components.health:SetMaxHealth(75)
    inst.components.hunger:SetMax(150)
    inst.components.sanity:SetMax(200)
    inst.components.eater:SetCanEatNightmarefuel()
    inst.components.eater:SetOnEatFn(oneat)
    inst.components.combat.damagemultiplier = 1

    local old_CalcDamage = inst.components.combat.CalcDamage
    inst.components.combat.CalcDamage = function(self, target, ...)
        local num = old_CalcDamage(self, target, ...)
        if self.inst.components.inventory and self.inst.components.inventory:EquipHasTag("tz_fh_beishui") then
            local getrate = getpenaltydamage(self.inst.components.health.penalty)
            if getrate ~= 0 then
                num = num * getrate
            end
        end
        return num
    end
    inst:AddComponent("petleashlostday")
    inst.components.petleashlostday:SetMaxPets(3)
    inst._OnSpawnPet = inst.components.petleashlostday.onspawnfn
    inst._OnDespawnPet = inst.components.petleashlostday.ondespawnfn
    inst.components.petleashlostday:SetOnSpawnFn(OnSpawnPet)
    inst.components.petleashlostday:SetOnDespawnFn(OnDespawnPet)
    inst.components.petleashlostday:CheckUp()

    inst._onpetlost = function(pet)
        inst.components.sanity:RemoveSanityPenalty(pet)
    end

    inst:AddComponent("tzpetshadow")
    inst.components.tzpetshadow:SetMaxPets(6)
    inst:DoTaskInTime(0.1, tzyifu)

    inst:AddComponent("fh_ml_pet")
    inst:AddComponent("tz_xin_pets")
    inst.components.tz_xin_pets.ondespawnfn = OnDespawnXinPet
    inst.components.hunger.hungerrate = 1 * TUNING.WILSON_HUNGER_RATE
    inst.components.builder.TaizhenDoBuild = inst.components.builder.DoBuild
    function inst.components.builder:DoBuild(recname, pt, rotation, skin)
        local recipe = GetValidRecipe(recname)
        if recipe ~= nil and (self:IsBuildBuffered(recname) or self:CanBuild(recname)) then
            if recipe.level.TZ_EVIL_TEACHER and recipe.level.TZ_EVIL_TEACHER > 0 and recipe.istzpet and
                (self.inst.components.petleashlostday == nil or self.inst.components.petleashlostday:IsFull()) then
                return false, "HASLOSY"
            end
        end
        return inst.components.builder:TaizhenDoBuild(recname, pt, rotation, skin)
    end

    if inst.components.timer then
        inst.components.timer:StartTimer("sama_max_cd", 10 * 480)
        inst:ListenForEvent("timerdone", OnTimerDone)
    end
    local old_apply = inst.components.inventory.ApplyDamage
    inst.components.inventory.ApplyDamage = function(self, damage, attacker, weapon, ...)
        if self.inst.components.fh_ly_gy and self.inst.components.fh_ly_gy:HasBlack() then
            return 0
        end
        if self.inst._bianshen ~= nil and self.inst._bianshen:value() == true and damage > 0 then
            self.inst.components.tzsama:DoDelta(-damage * 0.5)
            damage = damage * 0.05
        end
        local old = old_apply(self, damage, attacker, weapon, ...)
        if old > 0 then
            local level = getyexingzhe(self)
            if level then
                old = old * (1 - level / (level + 100))
            end
            if self:EquipHasTag("tz_yexingzhemax") then
                old = old * 0.9
            end
        end
        return old
    end
    inst.OnLoad = onload
    inst.OnNewSpawn = onload
    inst.OnSave = onsave
    inst.OnPreLoad = onpreload

    inst._OnEntityDeath = function(world, data)
        if inst.components.health:IsDead() or inst:HasTag("playerghost") then
            return
        end
        if data and data.inst and data.inst.GUID and inst.hit_mubiao[data.inst.GUID] then
            if not (data.inst:IsValid() and inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) == nil and
                inst._bianshen:value() == true) then
                return
            end

            local x, y, z = data.inst.Transform:GetWorldPosition()
            local x1, y, z1 = inst.Transform:GetWorldPosition()

            if distsq(x, z, x1, z1) > 400 then
                return
            end
            local health = (data.inst.components.health and data.inst.components.health.maxhealth or 0) * 0.05
            inst:DoTaskInTime(0.5, function()
                local fx = SpawnPrefab("tz_healthball_fx_pre")
                fx.Transform:SetPosition(x, y, z)
                fx.owner = inst
                fx.health = health
            end)
        end
    end

    inst.components.age.PauseAging = function(...) -- 时间永不停歇

    end

    inst:ListenForEvent("entity_death", inst._OnEntityDeath, TheWorld)

    OnSamachange(inst)
    inst:ListenForEvent("death", OnDeath)
    -- inst:ListenForEvent("tzsmamaxchange", OnMaxSama)
    -- inst:ListenForEvent("ms_becameghost", OnDeath)
    inst:ListenForEvent("tzspeeddirty", OnSpeed)
    inst:ListenForEvent("tzsamadelta", OnSamachange)
    inst:ListenForEvent("attacked", Onattacked)
    -- inst:ListenForEvent("killed",OnKilled)
    inst:ListenForEvent("onhitother", onhitother)

    inst:ListenForEvent("ms_becameghost", function()
        if inst.apingfuhuo:value() then
            return
        end
        inst.AnimState:SetBank("tz_ghost_fx")
        inst.AnimState:SetBuild("tz_ghost_fx")
        inst.sg:GoToState("tz_appear")
        if inst._trailtask == nil then
            inst._trailtask = inst:DoPeriodicTask(6 * FRAMES, cane_do_trail, 2 * FRAMES)
        end
    end)

    inst:ListenForEvent("equip", function()

        if inst:HasTag("taizhen_yellow") then
            inst.AnimState:OverrideSymbol("backpack", "swap_tzwings", "backpack")
            inst.AnimState:OverrideSymbol("swap_body", "swap_tzwings", "swap_body")
            inst.AnimState:ClearOverrideSymbol("swap_hat")
            inst.AnimState:Show("hair")
        end
    end)
end

return MakePlayerCharacter("taizhen", prefabs, assets, common_postinit, master_postinit, start_inv)
