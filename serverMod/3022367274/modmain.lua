GLOBAL.setmetatable(
    env,
    {
        __index = function(t, k)
            return GLOBAL.rawget(GLOBAL, k)
        end
    }
)

function AddPrefabFiles(...)
    for _, v in ipairs({...}) do
        table.insert(PrefabFiles, v)
    end
end

local function import(t)
    for _, v in ipairs(t) do
        modimport('main/' .. v)
    end
end

Assets = {
    Asset('IMAGE', 'images/saveslot_portraits/ningen.tex'),
    Asset('ATLAS', 'images/saveslot_portraits/ningen.xml'),
    Asset('IMAGE', 'images/selectscreen_portraits/ningen.tex'),
    Asset('ATLAS', 'images/selectscreen_portraits/ningen.xml'),
    Asset('IMAGE', 'images/selectscreen_portraits/ningen_silho.tex'),
    Asset('ATLAS', 'images/selectscreen_portraits/ningen_silho.xml'),
    Asset('IMAGE', 'bigportraits/ningen.tex'),
    Asset('ATLAS', 'bigportraits/ningen.xml'),
    Asset('IMAGE', 'images/map_icons/ningen.tex'),
    Asset('ATLAS', 'images/map_icons/ningen.xml'),
    Asset('IMAGE', 'images/avatars/avatar_ningen.tex'),
    Asset('ATLAS', 'images/avatars/avatar_ningen.xml'),
    Asset('IMAGE', 'images/avatars/avatar_ghost_ningen.tex'),
    Asset('ATLAS', 'images/avatars/avatar_ghost_ningen.xml'),
    Asset('IMAGE', 'images/avatars/self_inspect_ningen.tex'),
    Asset('ATLAS', 'images/avatars/self_inspect_ningen.xml'),
    Asset('IMAGE', 'images/names_ningen.tex'),
    Asset('ATLAS', 'images/names_ningen.xml'),
    Asset('IMAGE', 'images/names_gold_ningen.tex'),
    Asset('ATLAS', 'images/names_gold_ningen.xml'),
    Asset('IMAGE', 'images/xxx_kujiao_inv.tex'),
    Asset('ATLAS', 'images/xxx_kujiao_inv.xml'),
    Asset('IMAGE', 'images/skeleton_fish_inv.tex'),
    Asset('ATLAS', 'images/skeleton_fish_inv.xml'),
    Asset('IMAGE', 'images/armor_shrimp_inv.tex'),
    Asset('ATLAS', 'images/armor_shrimp_inv.xml'),
    Asset('IMAGE', 'images/nl_ccguo.tex'),
    Asset('ATLAS', 'images/nl_ccguo.xml'),
    Asset('IMAGE', 'images/nl_ccguo_seeds.tex'),
    Asset('ATLAS', 'images/nl_ccguo_seeds.xml'),
    Asset('IMAGE', 'images/nl_ccguo_cooked.tex'),
    Asset('ATLAS', 'images/nl_ccguo_cooked.xml'),
    Asset('ANIM', 'anim/farm_plant_nl_cc114514.zip'),
    Asset('ANIM', 'anim/farm_plant_nl_ccguo.zip')
}

import {
    'ningendryness',
    'ningen_parasitize',
    'ningen_componentsmodify',
    'ningen_swim',
    'nl_fishset'
    -- 'nl_farmplantset'
}

PrefabFiles = {
    'sea_walls',
    'ningen',
    'ne_fishbed',
    'killer_whale',
    'ningen_parasitize_fx',
    'ningen_floatfx',
    'nl_fish',
    -- 'nl_farmplants',
    'ningenbuffs',
    'ningen_heartfx'
}

AddMinimapAtlas('images/map_icons/ningen.xml')

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

-- The character select screen lines
STRINGS.CHARACTER_TITLES.ningen = '冰海鬼影'
STRINGS.CHARACTER_NAMES.ningen = '宁恩'
STRINGS.CHARACTER_DESCRIPTIONS.ningen = '*冰海之下的鬼影\n*基因融合的造物\n*吸食血液的异形'
STRINGS.CHARACTER_QUOTES.ningen = '"求求你让我咬一口嘛~"'
STRINGS.CHARACTER_SURVIVABILITY.ningen = '普通'

-- Custom speech strings
STRINGS.CHARACTERS.NINGEN = require 'speech_ningen'

-- The character's name as appears in-game
STRINGS.NAMES.NINGEN = '宁恩'

-- The skins shown in the cycle view window on the character select screen.
-- A good place to see what you can put in here is in skinutils.lua, in the function GetSkinModes
local skin_modes = {
    {
        type = 'ghost_skin',
        anim_bank = 'ghost',
        idle_anim = 'idle',
        scale = 0.75,
        offset = {0, -25}
    }
}

-- Add mod character to mod character list. Also specify a gender. Possible genders are MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL.
AddModCharacter('ningen', 'FEMALE', skin_modes)

local GS_MOD_LANGUAGE_SETTING = 'CHINESE'

-- if GetModConfigData('Language') ~= 'A' then
--     GS_MOD_LANGUAGE_SETTING = GetModConfigData('Language')
-- else
--     local loc = require 'languages/loc'
--     local lan = loc and loc.GetLanguage and loc.GetLanguage()
--     if lan == LANGUAGE.CHINESE_S or lan == LANGUAGE.CHINESE_S_RAIL then
--         GS_MOD_LANGUAGE_SETTING = 'CHINESE'
--     else
--         GS_MOD_LANGUAGE_SETTING = 'ENGLISH'
--     end
-- end

if GS_MOD_LANGUAGE_SETTING == 'CHINESE' then
    modimport('scripts/languages/string_ningen_chs.lua')
else
    modimport('scripts/languages/string_ningen_en.lua')
end

TUNING.NINGEN_SWIMS = true
TUNING.NINGEN_SWIM_RATE = 50
TUNING.NINGEN_WET_SANITY = 0
TUNING.NINGEN_SWIM_KEY = GLOBAL.KEY_LSHIFT
TUNING.NINGEN_MUCUS_KEY = GLOBAL.KEY_Z
TUNING.NINGEN_SUMMON_KEY = GLOBAL.KEY_X
TUNING.DROWNING_DAMAGE_NINGEN = {
    HEALTH_PENALTY = 0,
    HUNGER = 25,
    SANITY = 100,
    WETNESS = 100
}

local function swimswitch(inst, ismaster)
    if not inst:HasTag('ningen') or inst:HasTag('playerghost') or inst._switch_cd == false then
        return
    end
    inst._switch_cd = false
    if not inst.sg:HasStateTag('jumping') then
        local a = not inst._ningen_swimmer:value()
        inst._ningen_swimmer:set(a)
        if inst.components.talker then
            if a == true then
                inst.components.talker:Say('游泳启用')
            else
                inst.components.talker:Say('游泳关闭')
            end
        end
    end
    inst:DoTaskInTime(
        0.3,
        function()
            inst._switch_cd = true
        end
    )
end

AddModRPCHandler('ningen', 'swim', swimswitch)
TheInput:AddKeyDownHandler(
    TUNING.NINGEN_SWIM_KEY,
    function()
        local IsHUDscreen = GLOBAL.TheFrontEnd:GetActiveScreen() and GLOBAL.TheFrontEnd:GetActiveScreen().name == 'HUD'
        if IsHUDscreen then
            SendModRPCToServer(MOD_RPC['ningen']['swim'], TheWorld.ismastersim)
        end
    end
)

----------------------------------------------------------------------------

local function secretemucus(inst, ismaster)
    if
        not inst:HasTag('ningen') or inst:HasTag('playerghost') or inst._secrete_cd == false or
            inst._secrete_attackcd == false
     then
        return
    end
    inst._secrete_cd = false
    if inst.onsecretemucus == false then
        inst.onsecretemucus = true
        inst:AddTag('notarget')
        if inst.components.talker then
            inst.components.talker:Say('信息素开始分泌')
        end
        if inst.heartfx == nil then
            inst.heartfx = SpawnPrefab('ningen_heartfx')
            inst.heartfx.entity:SetParent(inst.entity)
        end
    else
        inst.onsecretemucus = false
        inst:RemoveTag('notarget')
        if inst.components.talker then
            inst.components.talker:Say('信息素停止分泌')
        end
        if inst.heartfx ~= nil then
            inst.heartfx:Remove()
            inst.heartfx = nil
        end
    end
    inst:DoTaskInTime(
        0.3,
        function()
            inst._secrete_cd = true
        end
    )
end

AddModRPCHandler('ningen', 'mucus', secretemucus)
TheInput:AddKeyDownHandler(
    TUNING.NINGEN_MUCUS_KEY,
    function()
        local IsHUDscreen = GLOBAL.TheFrontEnd:GetActiveScreen() and GLOBAL.TheFrontEnd:GetActiveScreen().name == 'HUD'
        if IsHUDscreen then
            SendModRPCToServer(MOD_RPC['ningen']['mucus'], TheWorld.ismastersim)
        end
    end
)

----------------------------------------------------------------------------

local bite_exclude_tags = {
    'FX',
    'NOCLICK',
    'DECOR',
    'INLIMBO',
    'ningen',
    'killer_whale',
    'player',
    'companion',
    'wall',
    'abigail',
    'shadowminion'
}

local function OnWater(x, y, z)
    return TheWorld.Map:IsOceanAtPoint(x, y, z, false)
end

local function takeabite(inst, x, z)
    inst:DoTaskInTime(
        0.4,
        function()
            local ents = TheSim:FindEntities(x, 0, z, 6, {'_combat'}, bite_exclude_tags)
            for k, v in ipairs(ents) do
                v.components.combat:GetAttacked(inst, inst.components.combat.defaultdamage)
                if v.components.freezable ~= nil then
                    v.components.freezable:Freeze(5)
                end
            end

            local fx = SpawnPrefab('crabking_ring_fx')
            fx.Transform:SetScale(0.9, 0.9, 0.9)
            fx.Transform:SetPosition(x, 0, z)
        end
    )
end

local function summonfriend(inst, x, y, z)
    if not inst:HasTag('ningen') or inst:HasTag('playerghost') then
        return
    end

    local friend = inst.components.killerwhalefriend.friend
    local follower = inst.components.killerwhalefriend.follower

    if friend == false then
        if inst.components.talker then
            inst.components.talker:Say('我还没有能够帮忙的好朋友。')
        end
        return
    end

    if inst._summon_cd == false then
        if inst.components.talker then
            inst.components.talker:Say('大哥哥现在很忙，得靠自己！')
        end
        return
    end

    if inst.components.killerwhalefriend.exist == true then
        if follower == nil then
            return
        end

        local time = follower.components.timer:GetTimeLeft('masteronland') or 60

        if time < 10 or follower:HasTag('busy') then
            if inst.components.talker then
                inst.components.talker:Say('大哥哥现在很忙，得靠自己！')
            end
            return
        end
        follower.Transform:SetPosition(x, 0, z)
        follower.components.amphibiouscreature:OnEnterOcean()
        follower.sg:GoToState('eat_pst')
        if not OnWater(x, 0, z) then
            -- follower.components.groundpounder:GroundPound()
            ShakeAllCameras(CAMERASHAKE.VERTICAL, .7, .025, 1.25, follower, 40)

            follower.components.timer:StartTimer('summononland', 3)
        end
        takeabite(follower, x, z)
    else
        inGamePlay = false
        -- dumptable(inst.components.killerwhalefriend.whaledata)
        follower = SpawnSaveRecord(inst.components.killerwhalefriend.whaledata)
        follower.Transform:SetPosition(x, 0, z)
        inGamePlay = true
        follower.components.amphibiouscreature:OnEnterOcean()
        follower.sg:GoToState('eat_pst')
        inst.components.killerwhalefriend:makefriend(follower)
        if not OnWater(x, 0, z) then
            -- follower.components.groundpounder:GroundPound()
            ShakeAllCameras(CAMERASHAKE.VERTICAL, .7, .025, 1.25, follower, 40)

            follower.components.timer:StartTimer('summononland', 3)
        end
        takeabite(follower, x, z)
    end

    if inst.components.talker then
        inst.components.talker:Say('帮帮我，黑白相间的大哥哥！')
    end

    inst._summon_cd = false

    inst:DoTaskInTime(
        20,
        function()
            inst._summon_cd = true
        end
    )
end

AddModRPCHandler('ningen', 'summon', summonfriend)
TheInput:AddKeyDownHandler(
    TUNING.NINGEN_SUMMON_KEY,
    function()
        local IsHUDscreen = GLOBAL.TheFrontEnd:GetActiveScreen() and GLOBAL.TheFrontEnd:GetActiveScreen().name == 'HUD'
        if IsHUDscreen then
            local x, y, z = (TheInput:GetWorldPosition()):Get()
            SendModRPCToServer(MOD_RPC['ningen']['summon'], x, y, z)
        end
    end
)

----------------------------------------------------------------------------

local function forest_modify(inst)
    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent('timer')
    inst:AddComponent('killer_whalespawner')
end
AddPrefabPostInit('forest', forest_modify)

----------------------------------------------------------------------------

-- local function ReplaceWith114514Plant(inst)
--     local plant = SpawnPrefab('farm_plant_nl_cc114514')
--     plant.Transform:SetPosition(inst.Transform:GetWorldPosition())
--     plant.components.growable:DoGrowth()
--     -- plant.AnimState:OverrideSymbol("veggie_seed", "farm_soil", "seed")
--     -- if plant.plant_def ~= nil then
--     -- 	plant.no_oversized = true
--     -- 	plant.long_life = inst.long_life
--     -- 	plant.components.farmsoildrinker:CopyFrom(inst.components.farmsoildrinker)
--     -- 	plant.components.farmplantstress:CopyFrom(inst.components.farmplantstress)
--     -- 	plant.components.growable:DoGrowth()
--     -- 	plant.AnimState:OverrideSymbol("veggie_seed", "farm_soil", "seed")
--     -- end

--     -- inst.grew_into = plant -- so the caller can get the new plant that replaced this object
--     inst:Remove()
-- end

-- local function guo_114514(a)
--     if not TheWorld.ismastersim then
--         return a
--     end
--     if a.components.growable and a.prefab == 'farm_plant_nl_ccguo' then
--         local old_fn = a.components.growable.stages[2].fn

--         a.components.growable.stages[2].fn = function(inst, ...)
--             if inst.prefab == 'farm_plant_nl_ccguo' then
--                 ReplaceWith114514Plant(inst)
--             else
--                 old_fn(inst, ...)
--             end
--         end
--     end
-- end

-- AddPrefabPostInit('farm_plant_nl_ccguo', guo_114514)

----------------------------------------------------------------------------

--调试用指令
require('debugcommands_ningen')
