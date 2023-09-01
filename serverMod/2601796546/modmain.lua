GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})
require "asa_function"  --独立函数库
PrefabFiles = {
	"asakiri",  --人物代码文件
	"asakiri_none",  --人物皮肤
	"asakiri_skin1",  --人物皮肤
	"asakiri_skin2",  --人物皮肤
	"asakiri_skin3",  --人物皮肤
	"asa_blade",
	"asa_spark",
	"zan_label",
	"asa_fxs",
	"asa_lightning",
	"asa_shadow_fx",
	"asa_upgrade_fx",
	"asa_items",
	"asa_vizard",
	"asa_shop",
	"asa_blade2",
	"asa_blade2_item",
	"asa_axe",
	"asa_manufacture",
}
---对比老版本 主要是增加了names图片 人物检查图标 还有人物的手臂修复（增加了上臂）
--人物动画里面有个SWAP_ICON 里面的图片是在检查时候人物头像那里显示用的

modimport("main/asa_tech.lua")
----2019.05.08 修复了 人物大图显示错误和检查图标显示错误

Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/asakiri.tex" ), --存档图片
    Asset( "ATLAS", "images/saveslot_portraits/asakiri.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/asakiri.tex" ), --单机选人界面
    Asset( "ATLAS", "images/selectscreen_portraits/asakiri.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/asakiri_silho.tex" ), --单机未解锁界面
    Asset( "ATLAS", "images/selectscreen_portraits/asakiri_silho.xml" ),

    Asset( "IMAGE", "bigportraits/asakiri.tex" ), --人物大图（方形的那个）
    Asset( "ATLAS", "bigportraits/asakiri.xml" ),
	
	Asset( "IMAGE", "images/map_icons/asakiri.tex" ), --小地图
	Asset( "ATLAS", "images/map_icons/asakiri.xml" ),
	Asset( "IMAGE", "images/map_icons/asa_shop.tex" ), --小地图
	Asset( "ATLAS", "images/map_icons/asa_shop.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_asakiri.tex" ), --tab键人物列表显示的头像
    Asset( "ATLAS", "images/avatars/avatar_asakiri.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_asakiri.tex" ),--tab键人物列表显示的头像（死亡）
    Asset( "ATLAS", "images/avatars/avatar_ghost_asakiri.xml" ),
	
	Asset( "IMAGE", "images/avatars/self_inspect_asakiri.tex" ), --人物检查按钮的图片
    Asset( "ATLAS", "images/avatars/self_inspect_asakiri.xml" ),
	
	Asset( "IMAGE", "images/names_asakiri.tex" ),  --人物名字
    Asset( "ATLAS", "images/names_asakiri.xml" ),
	
    Asset( "IMAGE", "bigportraits/asakiri_none.tex" ),  --人物大图（椭圆的那个）
    Asset( "ATLAS", "bigportraits/asakiri_none.xml" ),

	Asset( "IMAGE", "bigportraits/asakiri_skin1.tex" ),  --人物大图（椭圆的那个）
	Asset( "ATLAS", "bigportraits/asakiri_skin1.xml" ),

	Asset( "IMAGE", "bigportraits/asakiri_skin2.tex" ),  --人物大图（椭圆的那个）
	Asset( "ATLAS", "bigportraits/asakiri_skin2.xml" ),

	Asset( "IMAGE", "bigportraits/asakiri_skin3.tex" ),  --人物大图（椭圆的那个）
	Asset( "ATLAS", "bigportraits/asakiri_skin3.xml" ),
	
	Asset( "IMAGE", "images/inventoryimages/asa_blade.tex" ),  --武器图标
    Asset( "ATLAS", "images/inventoryimages/asa_blade.xml" ),
	Asset( "IMAGE", "images/inventoryimages/asa_blade2.tex" ),  --武器图标
    Asset( "ATLAS", "images/inventoryimages/asa_blade2.xml" ),
	
	Asset( "IMAGE", "images/inventoryimages/asa_repair.tex" ),  --道具
    Asset( "ATLAS", "images/inventoryimages/asa_repair.xml" ),
	
	Asset( "IMAGE", "images/inventoryimages/asa_boost.tex" ),
    Asset( "ATLAS", "images/inventoryimages/asa_boost.xml" ),
	
	Asset( "IMAGE", "images/inventoryimages/asa_vizard.tex" ),
    Asset( "ATLAS", "images/inventoryimages/asa_vizard.xml" ),
	
	Asset( "IMAGE", "images/inventoryimages/asa_shop.tex" ),
    Asset( "ATLAS", "images/inventoryimages/asa_shop.xml" ),
	
	Asset( "IMAGE", "images/inventoryimages/asa_axe.tex" ),
    Asset( "ATLAS", "images/inventoryimages/asa_axe.xml" ),

	Asset( "IMAGE", "images/inventoryimages/asa_drone.tex" ),
	Asset( "ATLAS", "images/inventoryimages/asa_drone.xml" ),
	
	Asset("SOUNDPACKAGE", "sound/asakiri.fev"),  --语音包
	Asset("SOUND", "sound/asakiri.fsb"),
	
	Asset("SOUNDPACKAGE", "sound/asakiri_sfx.fev"),  --音效包
	Asset("SOUND", "sound/asakiri_sfx.fsb"),
	
	Asset( "ANIM", "anim/asa_action.zip" ),  --动作包
	Asset( "ANIM", "anim/zan2.zip" ),
	Asset( "ANIM", "anim/swap_asa_blade2.zip" ),
	
	Asset( "IMAGE", "images/hud/asa_tab.tex" ),	--UI
	Asset( "ATLAS", "images/hud/asa_tab.xml" ),
	Asset("ANIM", "anim/asa_power.zip"),
	Asset("ANIM", "anim/asa_cd.zip"),
	Asset("ANIM", "anim/asa_power2.zip"),
	
	 --技能面板
	Asset( "IMAGE", "images/hud/asa_panel.tex" ),
	Asset( "ATLAS", "images/hud/asa_panel.xml" ),
	Asset( "IMAGE", "images/hud/asa_panel_explain.tex" ),
	Asset( "ATLAS", "images/hud/asa_panel_explain.xml" ),
	Asset( "IMAGE", "images/hud/asa_panel_explain_en.tex" ),
	Asset( "ATLAS", "images/hud/asa_panel_explain_en.xml" ),
	
	
	--滤镜
	Asset( "ATLAS", "images/hud/asa_vision.xml" ),
	Asset( "IMAGE", "images/hud/asa_vision.tex" ),
	Asset( "ATLAS", "images/hud/asa_vision2.xml" ),
	Asset( "IMAGE", "images/hud/asa_vision2.tex" ),

--[[---注意事项
1、目前官方自从熔炉之后人物的界面显示用的都是那个椭圆的图
2、官方人物目前的图片跟名字是分开的 
3、names_asakiri 和 asakiri_none 这两个文件需要特别注意！！！
这两文件每一次重新转换之后！需要到对应的xml里面改对应的名字 否则游戏里面无法显示
具体为：
降names_esctemplatxml 里面的 Element name="asakiri.tex" （也就是去掉names——）
将asakiri_none.xml 里面的 Element name="asakiri_none_oval" 也就是后面要加  _oval
（注意看修改的名字！不是两个都需要修改）
	]]
}

local _G = GLOBAL
local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local TECH = GLOBAL.TECH
local FRAMES = GLOBAL.FRAMES
local ACTIONS = GLOBAL.ACTIONS
local State = GLOBAL.State
local EventHandler = GLOBAL.EventHandler
local ActionHandler = GLOBAL.ActionHandler
local TimeEvent = GLOBAL.TimeEvent
local EQUIPSLOTS = GLOBAL.EQUIPSLOTS
local CHARACTER_INGREDIENT = GLOBAL.CHARACTER_INGREDIENT


local language_asakiri = GetModConfigData("Language")    --获取设置里"语言"的选项值

if language_asakiri == "chinese" then
    modimport("scripts/languages/strings_chinese.lua")
	-- TUNING.ASAKIRI_MOD_LANGUAGE = "chinese"
	-- Cusasa speech strings  ----人物语言文件  可以进去自定义
	STRINGS.CHARACTERS.ASAKIRI = require "speech_asakiri"
else
    modimport("scripts/languages/strings_english.lua")
	-- TUNING.ASAKIRI_MOD_LANGUAGE = "english"
end
-- 制作配方

local asatab = AddRecipeTab(STRINGS.NAMES.ASATAB, 600, "images/hud/asa_tab.xml", "asa_tab.tex",nil)


AddRecipe("asa_repair", {Ingredient("transistor", 3)}, asatab,  GLOBAL.TECH.NONE, nil, nil, nil, 1, "asakiri", "images/inventoryimages/asa_repair.xml")

AddRecipe("asa_boost", {Ingredient("transistor", 1), Ingredient("moonrocknugget", 2), Ingredient("bluegem", 1)}, asatab,  GLOBAL.TECH.NONE, nil, nil, nil, 1, "asakiri", "images/inventoryimages/asa_boost.xml")

AddRecipe("asa_vizard", {Ingredient("asa_boost", 1, "images/inventoryimages/asa_boost.xml"), Ingredient("lightbulb", 6), Ingredient("nitre", 2)}, asatab,  GLOBAL.TECH.NONE, nil, nil, nil, 1, "asakiri", "images/inventoryimages/asa_vizard.xml")
AddRecipe("asa_axe", { Ingredient("asa_boost", 1, "images/inventoryimages/asa_boost.xml"), Ingredient("moonrocknugget", 1),Ingredient("goldnugget", 4)}, asatab, GLOBAL.TECH.NONE, nil, nil, nil, 1, "asakiri", "images/inventoryimages/asa_axe.xml")
AddRecipe("asa_drone", { Ingredient("asa_boost", 1, "images/inventoryimages/asa_boost.xml"), Ingredient("moonrocknugget", 5)}, asatab, GLOBAL.TECH.NONE, nil, nil, nil, 1, "asakiri", "images/inventoryimages/asa_drone.xml")


AddRecipe("asa_shop", { Ingredient("asa_boost", 1, "images/inventoryimages/asa_boost.xml"), Ingredient("cutstone", 6),Ingredient("gears", 3)}, asatab, GLOBAL.TECH.SCIENCE_TWO, "asa_shop_placer", 4, nil, nil, "asakiri", "images/inventoryimages/asa_shop.xml")

AddRecipe("asa_blade2", { Ingredient("asa_boost", 1, "images/inventoryimages/asa_boost.xml"), Ingredient("moonrocknugget", 3),Ingredient("redgem", 3)}, asatab, GLOBAL.TECH.ASA_TECH_ONE, nil, nil, true, 1, "asakiri", "images/inventoryimages/asa_blade2.xml")
AddRecipe("asa_mirage", { Ingredient("asa_boost", 1, "images/inventoryimages/asa_boost.xml"), Ingredient("transistor", 2), Ingredient("moonglass", 5)}, asatab, GLOBAL.TECH.ASA_TECH_ONE, nil, nil, true, 1, "asakiri", "images/inventoryimages/asa_mirage.xml", "asa_mirage.tex")
AddRecipe2(
		"asa_mine",
		{ Ingredient("asa_boost", 1, "images/inventoryimages/asa_boost.xml"), Ingredient("transistor", 2)},
		TECH.ASA_TECH_ONE,
		{ atlas = "images/inventoryimages/asa_mine.xml", image = "asa_mine.tex", builder_tag = "asakiri" ,numtogive = 6},
		{ "CHARACTER" }
)


GLOBAL.PREFAB_SKINS["asakiri"] = {   --修复人物大图显示
	"asakiri_none",
	"asakiri_skin1",
	"asakiri_skin2",
	"asakiri_skin3",
}

-- The character select screen lines  --人物选人界面的描述
-- STRINGS.CHARACTER_TITLES.asakiri = "义体人"
-- STRINGS.CHARACTER_NAMES.asakiri = "朝雾"
-- STRINGS.CHARACTER_DESCRIPTIONS.asakiri = "*合金之躯，食物无感\n*精进战斗，长路漫漫\n*制造改装，科技不凡\n*探寻自我，没有答案"
-- STRINGS.CHARACTER_QUOTES.asakiri = "\"这个世界，有我的容身之所吗\""

-- The character's name as appears in-game  --人物在游戏里面的名字
-- STRINGS.NAMES.ASAKIRI = "朝雾"
-- STRINGS.SKIN_NAMES.asakiri_none = "朝雾"  --检查界面显示的名字

AddMinimapAtlas("images/map_icons/asakiri.xml")  --增加小地图图标
AddMinimapAtlas("images/map_icons/asa_shop.xml")

--增加人物到mod人物列表的里面 性别为女性（MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL）
AddModCharacter("asakiri", "FEMALE") 

TUNING.ASAKIRI_HEALTH = 175
TUNING.ASAKIRI_HUNGER = 120
TUNING.ASAKIRI_SANITY = 150

--生存几率
-- STRINGS.CHARACTER_SURVIVABILITY.asakiri = "披荆斩棘"

--选人界面初始物品显示
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.ASAKIRI = {"asa_blade", "asa_repair", "asa_boost"}

TUNING.STARTING_ITEM_IMAGE_OVERRIDE["asa_blade"] = {
	atlas = "images/inventoryimages/asa_blade.xml",
	image = "asa_blade.tex",
}

TUNING.STARTING_ITEM_IMAGE_OVERRIDE["asa_repair"] = {
	atlas = "images/inventoryimages/asa_repair.xml",
	image = "asa_repair.tex",
}

TUNING.STARTING_ITEM_IMAGE_OVERRIDE["asa_boost"] = {
	atlas = "images/inventoryimages/asa_boost.xml",
	image = "asa_boost.tex",
}

modimport("scripts/asa_function.lua")
modimport("main/asa_skin.lua")
modimport("main/asa_api.lua")
modimport("main/asa_rpc.lua")

modimport("main/asa_basic.lua")
modimport("main/asa_dodge.lua")
modimport("main/asa_parry.lua")

modimport("main/asa_ui.lua")
-- modimport("main/asa_vision.lua")
modimport("main/asa_max.lua")

modimport("main/asa_items.lua")




AddReplicableComponent('asa_power')



