local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
local TUNING = GLOBAL.TUNING

-- The character select screen lines
STRINGS.CHARACTER_TITLES.nanashi_mumei = "The Guardian of Civilization"
STRINGS.CHARACTER_NAMES.nanashi_mumei = "Nanashi Mumei"
STRINGS.CHARACTER_DESCRIPTIONS.nanashi_mumei = [[
    󰀩 Adept hunter in the dark
    󰀠 Loves Berries
    󰀀 ███ █████████ ███████████
    ]]
STRINGS.CHARACTER_QUOTES.nanashi_mumei = "\"I forgot.\""
STRINGS.CHARACTER_SURVIVABILITY.nanashi_mumei = "As long as civilazation exist"

-- Custom Config Variables
-- Nanashi_mumei's stats
TUNING.NANASHI_MUMEI_HEALTH = GetModConfigData("nanashi_mumei_health")
TUNING.NANASHI_MUMEI_HUNGER = GetModConfigData("nanashi_mumei_hunger")
TUNING.NANASHI_MUMEI_SANITY = GetModConfigData("nanashi_mumei_sanity")
TUNING.NANASHI_MUMEI_HUNGER_RATE = GetModConfigData("nanashi_mumei_hunger_rate")

TUNING.NANASHI_MUMEI_MS = GetModConfigData("nanashi_mumei_movespeed")
TUNING.NANASHI_MUMEI_DPS = GetModConfigData("nanashi_mumei_dmg")

TUNING.MODNAME = modname

-- Nanashi_mumei's perks & items
-- Night Owl
-- * These bonuses are different from multiplier, Ex. 0.3 means 30% more damage
TUNING.NANASHI_MUMEI_NIGHT_OWL_TERROR_BONUS_ATK = GetModConfigData("nanashi_mumei_night_owl_terror_bonus_atk")  
TUNING.NANASHI_MUMEI_NIGHT_OWL_MS_BONUS = GetModConfigData("nanashi_mumei_night_owl_ms_bonus")
TUNING.NANASHI_MUMEI_NIGHT_OWL_WORK_EFF_BONUS = GetModConfigData("nanashi_mumei_night_owl_work_eff_bonus")
TUNING.NANASHI_MUMEI_REVERSE_DAY_NIGHT_SANITY_DRAIN = GetModConfigData("nanashi_mumei_reverse_day_night_sanity_drain")

-- The Guardian's Dagger
TUNING.NANASHI_MUMEI_DAGGER_RECIPE = 0
TUNING.NANASHI_MUMEI_DAGGER_DAMAGE = GetModConfigData("nanashi_mumei_dagger_dmg")
TUNING.NANASHI_MUMEI_DAGGER_ATKSPEED_BONUS = GetModConfigData("nanashi_mumei_dagger_atkspeed_bonus")
TUNING.NANASHI_MUMEI_DAGGER_USAGES = GetModConfigData("nanashi_mumei_dagger_usages")
TUNING.NANASHI_MUMEI_DAGGER_THROW_DURA_LOST_PER = GetModConfigData("nanashi_mumei_dagger_throw_dura_lost_per")  -- * Percent of durability lost each throw
TUNING.NANASHI_MUMEI_DAGGER_THROW_AUTO_EQUIP = GetModConfigData("nanashi_mumei_dagger_throw_auto_equip") -- * Equip a new dagger after thrown if available

--TERROR
TUNING.NANASHI_MUMEI_TERROR_ATK_DEBUFF_MULTI = GetModConfigData("nanashi_mumei_terror_atk_debuff_multi")  -- * -20% atk debuff = 0.8 (80%) atk multiplier
TUNING.NANASHI_MUMEI_TERROR_DEBUFF_DURATION = GetModConfigData("nanashi_mumei_terror_debuff_duration")
TUNING.NANASHI_MUMEI_TERROR_MOVESPEED_MULTI = GetModConfigData("nanashi_mumei_terror_movespeed_multi")

-- Killer form Bonus
TUNING.NANASHI_MUMEI_KILLER_MOVESPEED = GetModConfigData("nanashi_mumei_killer_movespeed")
TUNING.NANASHI_MUMEI_KILLER_BONUS = GetModConfigData("nanashi_mumei_killer_bonus")
TUNING.NANASHI_MUMEI_KILLER_AMULET = GetModConfigData("nanashi_mumei_killer_amulet")
TUNING.NANASHI_MUMEI_KILLER_AUTOHEAL = GetModConfigData("nanashi_mumei_killer_autoheal")

-- Belt Lantern
TUNING.NANASHI_MUMEI_LANTERN_RECIPE = 0
TUNING.NANASHI_MUMEI_LANTERN_LIGHTTIME = GetModConfigData("nanashi_mumei_lantern_lighttime")
TUNING.NANASHI_MUMEI_LANTERN_FUELTYPE_STR = GetModConfigData("nanashi_mumei_lantern_fueltype_str")
TUNING.NANASHI_MUMEI_LANTERN_FUELTYPE = GLOBAL.FUELTYPE.CAVE -- * Default
if TUNING.NANASHI_MUMEI_LANTERN_FUELTYPE_STR == "lightbulb" then
    TUNING.NANASHI_MUMEI_LANTERN_FUELTYPE = GLOBAL.FUELTYPE.CAVE
elseif TUNING.NANASHI_MUMEI_LANTERN_FUELTYPE_STR == "burnable" then
    TUNING.NANASHI_MUMEI_LANTERN_FUELTYPE = GLOBAL.FUELTYPE.BURNABLE
elseif TUNING.NANASHI_MUMEI_LANTERN_FUELTYPE_STR == "nightmare" then
    TUNING.NANASHI_MUMEI_LANTERN_FUELTYPE = GLOBAL.FUELTYPE.NIGHTMARE
elseif TUNING.NANASHI_MUMEI_LANTERN_FUELTYPE_STR == "chemical" then
    TUNING.NANASHI_MUMEI_LANTERN_FUELTYPE = GLOBAL.FUELTYPE.CHEMICAL
elseif TUNING.NANASHI_MUMEI_LANTERN_FUELTYPE_STR == "wormlight" then
    TUNING.NANASHI_MUMEI_LANTERN_FUELTYPE = GLOBAL.FUELTYPE.WORMLIGHT
end

-- Berry Lover
TUNING.NANASHI_MUMEI_BERRY_BONUS_HUNGER_GAIN = GetModConfigData("nanashi_mumei_berry_bonus_hunger_gain")
TUNING.NANASHI_MUMEI_BUSH_HAT_DAPPERNESS_STR = GetModConfigData("nanashi_mumei_bush_hat_dapperness_str")
TUNING.NANASHI_MUMEI_BUSH_HAT_DAPPERNESS = 0  -- * No dapperness
if TUNING.NANASHI_MUMEI_BUSH_HAT_DAPPERNESS_STR == "tiny" then
    TUNING.NANASHI_MUMEI_BUSH_HAT_DAPPERNESS = TUNING.DAPPERNESS_TINY
elseif TUNING.NANASHI_MUMEI_BUSH_HAT_DAPPERNESS_STR == "small" then
    TUNING.NANASHI_MUMEI_BUSH_HAT_DAPPERNESS = TUNING.DAPPERNESS_SMALL
elseif TUNING.NANASHI_MUMEI_BUSH_HAT_DAPPERNESS_STR == "medium" then
    TUNING.NANASHI_MUMEI_BUSH_HAT_DAPPERNESS = TUNING.DAPPERNESS_MED
elseif TUNING.NANASHI_MUMEI_BUSH_HAT_DAPPERNESS_STR == "mediumlarge" then
    TUNING.NANASHI_MUMEI_BUSH_HAT_DAPPERNESS = TUNING.DAPPERNESS_MED_LARGE
elseif TUNING.NANASHI_MUMEI_BUSH_HAT_DAPPERNESS_STR == "large" then
    TUNING.NANASHI_MUMEI_BUSH_HAT_DAPPERNESS = TUNING.DAPPERNESS_LARGE
elseif TUNING.NANASHI_MUMEI_BUSH_HAT_DAPPERNESS_STR == "huge" then
    TUNING.NANASHI_MUMEI_BUSH_HAT_DAPPERNESS = TUNING.DAPPERNESS_HUGE
elseif TUNING.NANASHI_MUMEI_BUSH_HAT_DAPPERNESS_STR == "superhuge" then
    TUNING.NANASHI_MUMEI_BUSH_HAT_DAPPERNESS = TUNING.DAPPERNESS_SUPERHUGE
end

--Friend
TUNING.NANASHI_MUMEI_FRIEND_PICKUP = GetModConfigData("nanashi_mumei_friend_pickup")

-- Other settings
TUNING.NANASHI_MUMEI_HIDDEN = GetModConfigData("nanashi_mumei_clothes")
TUNING.NANASHI_MUMEI_AURA = GetModConfigData("nanashi_mumei_aura")

--VOICE
TUNING.NANASHI_MUMEI_VOICE1 = GetModConfigData("nanashi_mumei_voice1")
-- Language settings
TUNING.NANASHI_MUMEI_LANGUAGE = GetModConfigData("nanashi_mumei_language")

if TUNING.NANASHI_MUMEI_LANGUAGE == "AUTO" then   
    if tostring(GLOBAL.LanguageTranslator.defaultlang) == "ja" or GLOBAL.Profile:GetLanguageID() == 20 then
        TUNING.NANASHI_MUMEI_LANGUAGE = "JP"
    -- TODO: Waiting for Corneille to translates these
    -- elseif GLOBAL.Profile:GetLanguageID() == 21 or GLOBAL.Profile:GetLanguageID() == 22 or GLOBAL.Profile:GetLanguageID() == 23 then
    --     TUNING.NANASHI_MUMEI_LANGUAGE = "CN"
    else
        TUNING.NANASHI_MUMEI_LANGUAGE = "EN"
    end
end

-- Custom speech strings
STRINGS.CHARACTERS.NANASHI_MUMEI = require "speech_nanashi_mumei"

-- The character's name as appears in-game 
STRINGS.NAMES.NANASHI_MUMEI = "Nanashi Mumei"
STRINGS.SKIN_NAMES.nanashi_mumei_none = "Nanashi Mumei"

--Items' names and descriptions
STRINGS.NAMES.NANASHI_MUMEI_DAGGER = "The Guardian's Dagger"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.NANASHI_MUMEI_DAGGER = "Wow, cool looking dagger."
STRINGS.CHARACTERS.NANASHI_MUMEI.DESCRIBE.NANASHI_MUMEI_DAGGER = "This is just for a.. self-defense."
STRINGS.RECIPE_DESC.NANASHI_MUMEI_DAGGER = "Ready to hunt and end lives."

STRINGS.NAMES.NANASHI_MUMEI_LANTERN = "Belt Lantern"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.NANASHI_MUMEI_LANTERN = "This is quite convenience, isn't it?"
STRINGS.CHARACTERS.NANASHI_MUMEI.DESCRIBE.NANASHI_MUMEI_LANTERN = "With this, my hands are free to do.. stuffs."
STRINGS.RECIPE_DESC.NANASHI_MUMEI_LANTERN = "Lantern for adventurers."

STRINGS.NAMES.NANASHI_MUMEI_FRIEND = "\"Friend\""
STRINGS.CHARACTERS.GENERIC.DESCRIBE.NANASHI_MUMEI_FRIEND = "It's Mumei's friend."
STRINGS.CHARACTERS.NANASHI_MUMEI.DESCRIBE.NANASHI_MUMEI_FRIEND = "This is my friend."

STRINGS.NAMES.NANASHI_MUMEI_FRIEND_BUILDER = "\"Friend\""
STRINGS.RECIPE_DESC.NANASHI_MUMEI_FRIEND_BUILDER = "It can hold berries!"

STRINGS.NAMES.NANASHI_MUMEI_THORN_BERRYBUSH = "Thorn Berry Bush"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.NANASHI_MUMEI_THORN_BERRYBUSH = "Better not get close to it."
STRINGS.CHARACTERS.NANASHI_MUMEI.DESCRIBE.NANASHI_MUMEI_THORN_BERRYBUSH = "Doesn't matter, berry is still a berry."
STRINGS.RECIPE_DESC.NANASHI_MUMEI_THORN_BERRYBUSH = "Careful not to get pricked."

STRINGS.NAMES.NANASHI_MUMEI_DUG_THORN_BERRYBUSH = "Thorn Berry Bush"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.NANASHI_MUMEI_DUG_THORN_BERRYBUSH = "Will I get hurt by touching that?"
STRINGS.CHARACTERS.NANASHI_MUMEI.DESCRIBE.NANASHI_MUMEI_DUG_THORN_BERRYBUSH = "Now, where should I plant this?"
STRINGS.RECIPE_DESC.NANASHI_MUMEI_DUG_THORN_BERRYBUSH = "Careful not to get pricked."

-- Other languages
if TUNING.NANASHI_MUMEI_LANGUAGE == "JP" then
    STRINGS.NAMES.NANASHI_MUMEI = "七詩ムメイ"
    STRINGS.SKIN_NAMES.nanashi_mumei_none = "七詩ムメイ"
    --Items' names and descriptions

    STRINGS.NAMES.NANASHI_MUMEI_DAGGER = "守護者の短剣"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.NANASHI_MUMEI_DAGGER = "格好いい探検だね。"
    STRINGS.CHARACTERS.NANASHI_MUMEI.DESCRIBE.NANASHI_MUMEI_DAGGER = "ただ自分を守るための武器だよ。"
    STRINGS.RECIPE_DESC.NANASHI_MUMEI_DAGGER = "狩り用道具"

    STRINGS.NAMES.NANASHI_MUMEI_LANTERN = "小型ランタン"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.NANASHI_MUMEI_LANTERN = "便利なランタンだ。"
    STRINGS.CHARACTERS.NANASHI_MUMEI.DESCRIBE.NANASHI_MUMEI_LANTERN = "これで暗闇の中でも手が空いている。"
    STRINGS.RECIPE_DESC.NANASHI_MUMEI_LANTERN = "冒険者のランタン"

    STRINGS.NAMES.NANASHI_MUMEI_FRIEND = "\"フクロ\""
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.NANASHI_MUMEI_FRIEND = "いつもムメイちゃんに付いているものだ。"
    STRINGS.CHARACTERS.NANASHI_MUMEI.DESCRIBE.NANASHI_MUMEI_FRIEND = "あたしのお友達だよ。"

    STRINGS.NAMES.NANASHI_MUMEI_FRIEND_BUILDER = "\"フクロ\""
    STRINGS.RECIPE_DESC.NANASHI_MUMEI_FRIEND_BUILDER = "ベリー収穫のお手伝い"

elseif TUNING.NANASHI_MUMEI_LANGUAGE == "CN" then  -- TODO: Waiting for CN translations
    STRINGS.NAMES.NANASHI_MUMEI = "Nanashi Mumei"
    STRINGS.SKIN_NAMES.nanashi_mumei_none = "Nanashi Mumei"
    --Items' names and descriptions
end

-- Custom starting inventory
TUNING.NANASHI_MUMEI_STARTING_ITEMS = GetModConfigData("nanashi_mumei_starting_items")

--! STARTING ITEM TEMPLATE
if TUNING.NANASHI_MUMEI_STARTING_ITEMS == 0 then
    TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.NANASHI_MUMEI = {
        "nanashi_mumei_dagger",
		"nanashi_mumei_lantern",
    }
    TUNING.STARTING_ITEM_IMAGE_OVERRIDE["nanashi_mumei_dagger"] = 
    {
        atlas = "images/inventoryimages/nanashi_mumei_dagger.xml",
        image = "nanashi_mumei_dagger.tex",
    }
    TUNING.STARTING_ITEM_IMAGE_OVERRIDE["nanashi_mumei_lantern"] = 
    {
        atlas = "images/inventoryimages/nanashi_mumei_lantern.xml",
        image = "nanashi_mumei_lantern.tex",
    }
elseif TUNING.NANASHI_MUMEI_STARTING_ITEMS == 1 then
    TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.NANASHI_MUMEI = {
        "nanashi_mumei_dagger",
    }
    TUNING.STARTING_ITEM_IMAGE_OVERRIDE["nanashi_mumei_dagger"] = 
    {
        atlas = "images/inventoryimages/nanashi_mumei_dagger.xml",
        image = "nanashi_mumei_dagger.tex",
    }
else
    TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.NANASHI_MUMEI = {
    }
end

