PrefabFiles = {
	"nanashi_mumei",
	"nanashi_mumei_none",
    "nanashi_mumei_dagger",
    "nanashi_mumei_dagger_projectile",
    "nanashi_mumei_buffs",
    "nanashi_mumei_lantern",
    "nanashi_mumei_lantern_glow",
    "nanashi_mumei_debuff_fx",
    -- "nanashi_mumei_thorn_berrybush",
    "nanashi_mumei_friend",
    "nanashi_mumei_shadow",
}

Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/nanashi_mumei.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/nanashi_mumei.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/nanashi_mumei.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/nanashi_mumei.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/nanashi_mumei_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/nanashi_mumei_silho.xml" ),

    Asset( "IMAGE", "bigportraits/nanashi_mumei.tex" ),
    Asset( "ATLAS", "bigportraits/nanashi_mumei.xml" ),
	
	Asset( "IMAGE", "images/map_icons/nanashi_mumei.tex" ),
	Asset( "ATLAS", "images/map_icons/nanashi_mumei.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_nanashi_mumei.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_nanashi_mumei.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_nanashi_mumei.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_nanashi_mumei.xml" ),
	
	Asset( "IMAGE", "images/avatars/self_inspect_nanashi_mumei.tex" ),
    Asset( "ATLAS", "images/avatars/self_inspect_nanashi_mumei.xml" ),
	
    Asset( "IMAGE", "images/names_nanashi_mumei.tex" ),
    Asset( "ATLAS", "images/names_nanashi_mumei.xml" ),
	
	Asset( "IMAGE", "images/names_gold_nanashi_mumei.tex" ),
    Asset( "ATLAS", "images/names_gold_nanashi_mumei.xml" ),

    Asset( "IMAGE", "images/inventoryimages/nanashi_mumei_tab.tex" ),
    Asset( "ATLAS", "images/inventoryimages/nanashi_mumei_tab.xml" ),

    Asset("SOUNDPACKAGE", "sound/gura.fev"),
    Asset("SOUND", "sound/gura.fsb"),
}

AddMinimapAtlas("images/map_icons/nanashi_mumei.xml")


modimport("scripts/util/nanashi_mumei_settings.lua")
modimport("scripts/util/nanashi_mumei_recipes.lua")
-- modimport("scripts/util/nanashi_mumei_skins.lua")
modimport("scripts/stategraphs/nanashi_mumei_states.lua")
modimport("scripts/util/nanashi_mumei_postinit.lua")
modimport("scripts/util/nanashi_mumei_dagger_throw_action.lua")
modimport("scripts/util/nanashi_mumei_friend_actions.lua")

RemapSoundEvent( "dontstarve/characters/gura/death_voice", "gura/characters/gura/death_voice" )
RemapSoundEvent( "dontstarve/characters/gura/hurt", "gura/characters/gura/hurt" )
RemapSoundEvent( "dontstarve/characters/gura/talk_LP", "gura/characters/gura/talk_LP" )
RemapSoundEvent( "dontstarve/characters/gura/emote", "gura/characters/gura/emote" ) --dst
RemapSoundEvent( "dontstarve/characters/gura/ghost_LP", "gura/characters/gura/ghost_LP" ) --dst
RemapSoundEvent( "dontstarve/characters/gura/pose", "gura/characters/gura/pose" ) --dst
RemapSoundEvent( "dontstarve/characters/gura/yawn", "gura/characters/gura/yawn" ) --dst
RemapSoundEvent( "dontstarve/characters/gura/eye_rub_vo", "gura/characters/gura/eye_rub_vo" ) --dst
RemapSoundEvent( "dontstarve/characters/gura/carol", "gura/characters/gura/carol" ) --dst
RemapSoundEvent( "dontstarve/characters/gura/sinking", "gura/characters/gura/sinking" ) --dst

-- The skins shown in the cycle view window on the character select screen.
-- A good place to see what you can put in here is in skinutils.lua, in the function GetSkinModes
local skin_modes = {
    { 
        type = "ghost_skin",
        anim_bank = "ghost",
        idle_anim = "idle", 
        scale = 0.75, 
        offset = { 0, -25 } 
    },
}

-- Add mod character to mod character list. Also specify a gender. Possible genders are MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL.
AddModCharacter("nanashi_mumei", "FEMALE", skin_modes)


-- NOTE VERY IMPORTANT
-- REVIEW (FOR ALL OUTFITS) ALWAYS UPDATE nanashi_mumei_none.xml : Element name="nanashi_mumei_none.tex" ====>> Element name="nanashi_mumei_none_oval.tex"
-- REVIEW ALWAYS UPDATE names_gold_nanashi_mumei.xml : Element name="names_gold_nanashi_mumei.tex" ===>> Element name="nanashi_mumei.tex"
