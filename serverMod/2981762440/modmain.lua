GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})
 
PrefabFiles = { 
	"stu",  
	"stu_none",
	"stu_chainsaw",
	"stu_hat",
	"stu_amulet1",	
	"stu_amulet2",

	"stu_ghost_skill",
	"stu_chesspieces"	 
}

Assets = {
    Asset( "IMAGE", "bigportraits/stu.tex" ), 
    Asset( "ATLAS", "bigportraits/stu.xml" ),
	
	Asset( "IMAGE", "images/map_icons/stu.tex" ),
	Asset( "ATLAS", "images/map_icons/stu.xml" ),

	Asset( "IMAGE", "images/avatars/avatar_stu.tex" ), 
    Asset( "ATLAS", "images/avatars/avatar_stu.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_stu.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_stu.xml" ),
	
	Asset( "IMAGE", "images/avatars/self_inspect_stu.tex" ), 
    Asset( "ATLAS", "images/avatars/self_inspect_stu.xml" ), 
	
	Asset( "IMAGE", "images/names_stu.tex" ),  
    Asset( "ATLAS", "images/names_stu.xml" ),
	
    Asset( "IMAGE", "bigportraits/stu_none.tex" ), 
    Asset( "ATLAS", "bigportraits/stu_none.xml" ),

    Asset( "IMAGE", "bigportraits/stu_skin1_none.tex" ), 
    Asset( "ATLAS", "bigportraits/stu_skin1_none.xml" ),

    Asset( "IMAGE", "images/skill/stu_skill1.tex" ),  
    Asset( "ATLAS", "images/skill/stu_skill1.xml" ),

    Asset( "IMAGE", "images/skill/stu_skill2.tex" ),  
    Asset( "ATLAS", "images/skill/stu_skill2.xml" ),

    Asset( "IMAGE", "images/skill/stu_skill3.tex" ),  
    Asset( "ATLAS", "images/skill/stu_skill3.xml" ),
 
    Asset("SOUNDPACKAGE", "sound/stu_sound.fev"),
	Asset("SOUND", "sound/stu_sound.fsb")     
}

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

GLOBAL.PREFAB_SKINS["stu"] = {   
	"stu_none",
	"stu_skin1_none"
}

TUNING.STU_MODE = GetModConfigData("Stu_Mode")

TUNING.STU_WP_DAMAGE = GetModConfigData("Stu_Wp_Damage")
TUNING.STU_SKILL3_ATK_HEL = GetModConfigData("Skill3_Atk_Hel") 

TUNING.STU_HS_SET = GetModConfigData("Stu_Hs_Set") 
TUNING.STU_SKILL_MULT = GetModConfigData("Stu_Skill_Mult") 
TUNING.STU_HAT_MULT = GetModConfigData("Stu_Hat_Mult") 
TUNING.STU_WP_MULT = GetModConfigData("Stu_Wp_Mult") 

TUNING.STU_Language = GetModConfigData("Stu_Language") 

TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.STU = {"stu_chainsaw", "stu_hat"}

TUNING.STARTING_ITEM_IMAGE_OVERRIDE["stu_chainsaw"] = {
	atlas = "images/inventoryimages/stu_chainsaw.xml",
	image = "stu_chainsaw.tex",
}

TUNING.STARTING_ITEM_IMAGE_OVERRIDE["stu_hat"] = {
	atlas = "images/inventoryimages/stu_hat.xml",
	image = "stu_hat.tex",
}

AddMinimapAtlas("images/map_icons/stu.xml")  
AddModCharacter("stu", "FEMALE")

modimport("scripts/stu_Strings.lua")  
modimport("scripts/stu_Hook.lua") 
modimport("scripts/stu_Skill.lua")
modimport("scripts/stu_Recipes.lua") 

modimport("scripts/postinits/skin.lua")  

