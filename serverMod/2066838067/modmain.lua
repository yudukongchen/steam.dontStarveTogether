GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})
PrefabFiles = {
	"taizhen_science_buildings",
	"taizhen",
	"taizhen_none",
	"tz_spiritualism",
	"tz_malibag",
	"tz_enchanter",
	"tz_thurible_smoke",
	"tz_shadow",
	"tz_evil_teacher",
	"tz_takefuel",
	"tz_lostday",
	"tz_pangbaixiong",
	"tz_pangballoons_empty",
	"tz_vast_string",
    "taizhen_teleport_classified",
    "tz_teleport",
	"tz_delivery",
	"tz_shandian",
	"tz_packbox",
	"tz_packbox_fx",
	--"tz_icesword",
	--"tz_firesword",		
	"tz_icesword_fx",
	"tz_firesword_fx",
	"tz_firesword_fx2",
	"tz_icetornado",
	"tz_firetornado",
	--"tz_miemieback",
	--"tz_tuji",
	"tz_cannedtnt",
	"tz_swordcemetery",
	"taizhen_cosplay",
	"tz_unknow",
	"tz_spear",
	"tz_liang",
	"tz_staff",
	"tz_image",
	"tz_food",
	"tz_machine",
	"tz_projectile",
	"tz_shadowfire",
	"tz_yexingzhe",
	"tzyexing_wheel",
	"tz_shadow_fx",
	"tz_lightning",
	"tz_feidie",
	"tz_meteor",
	"tz_luobo",
	"tz_groundpoundringfx",
	"tz_yezhao",
	"tz_luobostaff",
	"tz_books",
	"tz_canying",
	"tz_tentacle",
    --"tz_dragonfloor",
	"tz_tfsword",
	"tz_yanjing",
	"tz_jrby",

	"qimoge", 
	"tz_coin", 
	
	----------------------------------灵衣做的
	"tz_floating_music_minion", --漂浮的音乐随从
	"tz_dragonpot", --中华龙腾锅
	"tz_statues",--太真的雕像
	"tz_killknife",
	"tz_shadow_killknife",
	"tz_boomtong",
	'tz_shadow_buff',
	'tz_pipaxingfx',
	"tz_zhua_attack",
	"tz_healthball_fx",
	"tz_whitewing",
	"tz_doubles",
	"tz_pills",
	"tz_yexingzhe_purple",
	"yexingzhe_victorian_fx",
	
	
	"tz_jioyin",
	"tz_iceball",
	"tz_orb_small",
	"tz_reticuleline",
	"tz_xx_fxs",
	"tz_ling",
	"tzxx_mnq",
	"tz_elong_box",

	"tz_dark_cookpot",
	"preparedfoods_tz_dark_cookpot",
	"nightmare_tangyuan_fx",
	"tz_book_surpassing",
	"tz_evil_teacher_super",

	"tz_fhspts",
	"tz_fhzlz",
	"tz_fhzc",
	"tz_fhft",
	"tz_fhbm",
	"tz_fhgx",
	"tz_fh_fishgirl",
	"tz_fhdx",
	"tz_fhym",

	"tz_character_shadow",
	"tz_hlmj",

	-- "tz_fanta_blade_stream",
	-- "tz_fanta_blade_stream_vfx",
	"tz_jianqi",
	"tz_fanta_blade_hit_vfx",
	"tz_ecyballoonspeed",

	"tz_rpg",
	"tz_rpg_explode_vfx",
	------------------------------ 鑫 ------------------------------
	"tz_xin_wupin",
	"tz_xin_texiao",
	----------------------------------------------------------------

	"tz_elong",
	"tz_elong_horn",

	"tz_reticules",

	"tz_pugalisk",
	"tz_pugalisk_meteor",
	"tz_pugalisk_summon",
	"tz_pugalisk_summon_rocket_fire_vfx",
	"tz_pugalisk_crystal",
	"tz_pugalisk_cursed_mark",

	"tz_skill_swing_fx",

	"tz_plants",
	"tz_fh_you",
	"tz_fh_you_curve_fx",
	"tz_fh_ml",
	"tz_truthbasketball",
	"ta_wzk_armor",

	"tz_darkhand_fx",
	"tz_fh_nx",
	"tz_fh_hf",
	"tz_fh_ly",
	"tz_fh_ns",
	"tz_firebird_puff_fx",
	"yk_tz_h",
	"tz_fh_jhz",
	"tz_fh_xhws",
	"tz_fh_fl",
	"tz_fh_ht",
	"tz_fh_ys",
	"tz_fhmt",
	
	
	"tz_ping_candy",
}

Assets = {
    Asset("ANIM", "anim/tzsama.zip"),
    Asset("ANIM", "anim/tz_darkfire.zip"),
    Asset("ANIM", "anim/taizhen_avatar_attack.zip"),
    Asset("ANIM", "anim/tz_bianshen.zip"),
	Asset("ANIM", "anim/tz_creature1.zip"),
    Asset("ANIM", "anim/tz_creature2.zip"),
    Asset("ANIM", "anim/tz_ui_pills.zip"),
	Asset("ANIM", "anim/tz_shadowunbrella.zip"),
	Asset("ANIM", "anim/tz_skillsystem_flashmove.zip"),
	Asset("ANIM", "anim/tz_skillsystem_ghostfour.zip"),

    Asset("ANIM", "anim/swap_tz_fanta_blade_blade.zip"),
	 
    Asset("ANIM", "anim/ui_tz_pi_1x1.zip"),
	Asset( "IMAGE", "images/tzui/ui.tex" ),
    Asset( "ATLAS", "images/tzui/ui.xml" ),  
    Asset( "ANIM", "anim/tzui_back.zip" ),
    Asset( "ANIM", "anim/tz_button_readbook.zip" ),
    Asset( "IMAGE", "images/saveslot_portraits/taizhen.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/taizhen.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/taizhen.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/taizhen.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/taizhen_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/taizhen_silho.xml" ),

	Asset( "IMAGE", "images/colour_cubes/tz_timecubes.tex"),

    Asset( "IMAGE", "bigportraits/taizhen.tex" ),
    Asset( "ATLAS", "bigportraits/taizhen.xml" ),
    
	Asset( "IMAGE", "bigportraits/elong_none.tex" ),
    Asset( "ATLAS", "bigportraits/elong_none.xml" ),
	
	Asset( "IMAGE", "bigportraits/taizhen_none.tex" ),
    Asset( "ATLAS", "bigportraits/taizhen_none.xml" ),
	
	Asset( "IMAGE", "bigportraits/taizhen_avatar.tex" ),
    Asset( "ATLAS", "bigportraits/taizhen_avatar.xml" ),	
	
    Asset( "IMAGE", "bigportraits/taizhen_pink_none.tex" ),
    Asset( "ATLAS", "bigportraits/taizhen_pink_none.xml" ),

    Asset( "IMAGE", "bigportraits/taizhen_boying_none.tex" ),
    Asset( "ATLAS", "bigportraits/taizhen_boying_none.xml" ),
	--change 2019-05-16
    --change
	Asset( "IMAGE", "images/map_icons/taizhen.tex" ),
	Asset( "ATLAS", "images/map_icons/taizhen.xml" ),
    
	Asset( "IMAGE", "images/names_taizhen.tex" ),
	Asset( "ATLAS", "images/names_taizhen.xml" ),
    
	Asset( "IMAGE", "images/avatars/avatar_taizhen.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_taizhen.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_taizhen.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_taizhen.xml" ),
	
	Asset( "IMAGE", "images/avatars/self_inspect_taizhen.tex" ), 
    Asset( "ATLAS", "images/avatars/self_inspect_taizhen.xml" ),
	
	--other
	Asset( "IMAGE", "images/map_icons/tz_malibag.tex" ),
	Asset( "ATLAS", "images/map_icons/tz_malibag.xml" ),
	
	Asset( "IMAGE", "images/map_icons/tz_spiritualism.tex" ),
	Asset( "ATLAS", "images/map_icons/tz_spiritualism.xml" ),
	
	Asset( "IMAGE", "images/map_icons/tz_enchanter.tex" ),
	Asset( "ATLAS", "images/map_icons/tz_enchanter.xml" ),

	Asset( "IMAGE", "images/map_icons/taizhen_avatar.tex" ),
	Asset( "ATLAS", "images/map_icons/taizhen_avatar.xml" ),
	
	Asset( "IMAGE", "images/map_icons/dragoncat_express.tex" ),
	Asset( "ATLAS", "images/map_icons/dragoncat_express.xml" ),

	Asset( "IMAGE", "images/map_icons/tz_yexingzhe_purple.tex" ),
	Asset( "ATLAS", "images/map_icons/tz_yexingzhe_purple.xml" ),
	
	Asset( "IMAGE", "images/map_icons/tz_miemieback.tex" ),
	Asset( "ATLAS", "images/map_icons/tz_miemieback.xml" ),
	
	Asset( "IMAGE", "images/map_icons/tz_swordcemetery.tex" ),
	Asset( "ATLAS", "images/map_icons/tz_swordcemetery.xml" ),
	
	Asset("ATLAS", "images/map_icons/tz_machine.xml"),
	Asset("IMAGE", "images/map_icons/tz_machine.tex"),
	
	Asset("ATLAS", "images/map_icons/tz_delivery.xml"),	
	Asset("IMAGE", "images/map_icons/tz_delivery.tex"),
	
	Asset("IMAGE", "images/map_icons/tz_dragonpot_mapicon.tex"), 
	Asset("ATLAS", "images/map_icons/tz_dragonpot_mapicon.xml"), 
	Asset("IMAGE", "images/map_icons/tz_elong_box_map.tex"), 
	Asset("ATLAS", "images/map_icons/tz_elong_box_map.xml"), 	

	Asset( "ATLAS", "images/hud/evil_doctrine.xml" ),
	Asset( "IMAGE", "images/hud/evil_doctrine.tex" ),
	
	
	Asset( "ATLAS", "images/hud/tz_maimeng.xml" ),
	Asset( "IMAGE", "images/hud/tz_maimeng.tex" ),
	
	Asset( "ATLAS", "images/hud/tz_jianzhong.xml" ),
	Asset( "IMAGE", "images/hud/tz_jianzhong.tex" ),	
	
	Asset( "ATLAS", "images/hud/tz_reizhen.xml" ),
	Asset( "IMAGE", "images/hud/tz_reizhen.tex" ),

	Asset( "ATLAS", "images/hud/tz_lvjing.xml" ),
	Asset( "IMAGE", "images/hud/tz_lvjing.tex" ),
	
	Asset( "SOUND" , "sound/malibag.fsb" ),
	Asset( "SOUNDPACKAGE" , "sound/malibag.fev" ),
	
	Asset( "SOUND" , "sound/tz_truthbasketballsound.fsb" ),
	Asset( "SOUNDPACKAGE" , "sound/tz_truthbasketballsound.fev" ),

	Asset( "SOUND" , "sound/tz_machine.fsb" ),
	Asset( "SOUNDPACKAGE" , "sound/tz_machine.fev" ),
	
	Asset( "SOUND" , "sound/tzdoydoy.fsb" ),
	Asset( "SOUNDPACKAGE" , "sound/tzdoydoy.fev" ),
	
	Asset( "SOUND" , "sound/tzdoydoy.fsb" ),
	Asset( "SOUNDPACKAGE" , "sound/tzdoydoy.fev" ),

	Asset( "SOUND" , "sound/ta_timeskill.fsb" ),
	Asset( "SOUNDPACKAGE" , "sound/ta_timeskill.fev" ),

	Asset( "SOUND" , "sound/tz_wzk_armor_sound.fsb" ),
	Asset( "SOUNDPACKAGE" , "sound/tz_wzk_armor_sound.fev" ),
	
	Asset( "SOUND" , "sound/tzcrab.fsb" ),
	Asset( "SOUNDPACKAGE" , "sound/tzcrab.fev" ),
	
	Asset( "SOUND" , "sound/tzcrocodog.fsb" ),
	Asset( "SOUNDPACKAGE" , "sound/tzcrocodog.fev" ),

	Asset( "SOUND" , "sound/tz_bianshen_sound.fsb" ),
	Asset( "SOUNDPACKAGE" , "sound/tz_bianshen_sound.fev" ),

	Asset( "SOUND" , "sound/tz_yexinzghe.fsb" ),
	Asset( "SOUNDPACKAGE" , "sound/tz_yexinzghe.fev" ),

	Asset("ATLAS", "images/qimoge.xml"),

	Asset("SOUND", "sound/shadow_buff.fsb"),
	Asset("SOUNDPACKAGE", "sound/shadow_buff.fev"),
	Asset("SOUND", "sound/tz_fhbmbgm.fsb"),
	Asset("SOUNDPACKAGE", "sound/tz_fhbmbgm.fev"),
	
	Asset("ATLAS", "images/inventoryimages/tz_drogenbox.xml"),
	Asset("IMAGE", "images/inventoryimages/tz_drogenbox.tex"),
	Asset("ATLAS", "images/inventoryimages/tz_elong_box.xml"),
	Asset("IMAGE", "images/inventoryimages/tz_elong_box.tex"),
	Asset("ATLAS", "images/map_icons/tz_drogenbox.xml"),
	Asset("IMAGE", "images/map_icons/tz_drogenbox.tex"),	

    Asset("ANIM", "anim/tz_mouse.zip"),
    Asset("ANIM", "anim/tz_floating_texiao.zip"),
    Asset("ANIM", "anim/tz_avatar_texie.zip"),
	Asset("ANIM", "anim/werewilba_actions.zip"),
    Asset("ANIM", "anim/tz_quiklygo.zip"),
    Asset("ANIM", "anim/tz_button_fx_xiuxian.zip"),
	Asset("IMAGE","images/inventoryimages/change_researchlab2.tex"),
	Asset("ATLAS","images/inventoryimages/change_researchlab2.xml"),
    Asset("IMAGE","images/inventoryimages/turf_tz_dragonfloor.tex"),
	Asset("ATLAS","images/inventoryimages/turf_tz_dragonfloor.xml"),
    Asset("IMAGE","images/inventoryimages/tz_fuhuo.tex"),
	Asset("ATLAS","images/inventoryimages/tz_fuhuo.xml"),
	
    Asset("IMAGE","images/tzxx/tzxx_back.tex"),
	Asset("ATLAS","images/tzxx/tzxx_back.xml"),

    Asset("IMAGE","images/tzxx/tzxx_ren.tex"),
	Asset("ATLAS","images/tzxx/tzxx_ren.xml"),

    Asset("IMAGE","images/tzxx/tz_wu.tex"),
	Asset("ATLAS","images/tzxx/tz_wu.xml"),
    Asset("IMAGE","images/tzxx/tzxx_xht.tex"),
	Asset("ATLAS","images/tzxx/tzxx_xht.xml"),
	
	Asset("ANIM", "anim/tz_zsq.zip"),
	Asset("ANIM", "anim/tz_xx_dawei.zip"),
	
	Asset("ANIM", "anim/tz_skill_ui.zip"),
	Asset("ANIM", "anim/tz_skill_cd.zip"),
	Asset("ANIM", "anim/tz_xx_texie.zip"),
	
	Asset("ATLAS", "images/map_icons/tz_nobeautiful_room.xml"),
	Asset("IMAGE", "images/map_icons/tz_nobeautiful_room.tex"),
	
    Asset("ANIM", "anim/tz_button_huihuan_fx.zip"),
    Asset("ANIM", "anim/tz_dargonfire.zip"),
	Asset("ATLAS", "images/tz_xin_wp_tb/tz_dargonfire.xml"),
	Asset("IMAGE", "images/tz_xin_wp_tb/tz_dargonfire.tex"),

	Asset("ANIM", "anim/tz_elong_sg1.zip"),
	Asset("ANIM", "anim/tz_elong_sg2.zip"),
	Asset("ANIM", "anim/tz_elong_sg3.zip"),
	Asset("ANIM", "anim/tz_elong_sg4.zip"),
	Asset("ANIM", "anim/tz_elong_sg5.zip"),
    Asset("ANIM", "anim/tz_elong_sg6.zip"),
    Asset("ANIM", "anim/tz_elong_sg7.zip"),
	Asset("ANIM", "anim/tz_elong_sg8.zip"),
    Asset("ANIM", "anim/tz_fh_fly.zip"),
	Asset("ANIM", "anim/tz_aoaolong_ui.zip"),

	Asset( "IMAGE", "images/map_icons/tz_elong.tex" ),
	Asset( "ATLAS", "images/map_icons/tz_elong.xml" ),
	Asset( "IMAGE", "images/map_icons/tz_elong_horn.tex" ),
	Asset( "ATLAS", "images/map_icons/tz_elong_horn.xml" ),
	Asset( "ATLAS", "images/map_icons/tz_truthbasketball.xml" ),

	Asset( "IMAGE", "images/tz_elong_nameui.tex" ),
	Asset( "ATLAS", "images/tz_elong_nameui.xml" ),
	------------------------------ 鑫 ------------------------------
    Asset("ANIM", "anim/tz_xin_fuckyouklei.zip"),
    Asset("ANIM", "anim/tz_xin_xingyuan.zip"),
    Asset("ANIM", "anim/tz_xin_zhuazi.zip"),
    Asset("ANIM", "anim/tz_xin_huanmengjing.zip"),
	----------------------------------------------------------------

	Asset( "ATLAS", "images/taizhen_xiaoshuoui.xml" ),
	Asset("ANIM", "anim/tz_writer_apcxjhka.zip"),
	Asset("ANIM", "anim/tz_writer_apingjun.zip"),
	Asset("ANIM", "anim/tz_writer_wen.zip"),
	Asset("ANIM", "anim/tz_writer_zgsd.zip"),
	Asset("ANIM", "anim/tz_writer_royian.zip"),
	Asset("ANIM", "anim/tz_writer_mr.eureka.zip"),
	--------------------------------------
	Asset("ANIM", "anim/tz_feilong_actinos.zip"),
	Asset("ANIM", "anim/tz_feilong.zip"),
	Asset("ANIM", "anim/tz_shikong_ui.zip"),
	Asset("ANIM", "anim/tz_trip_fx.zip"),
}

for k = 1, 7 do
	table.insert(Assets, Asset("ATLAS", "images/tz_xin_jm_tp/" .. k .. ".xml"))
	table.insert(Assets, Asset("IMAGE", "images/tz_xin_jm_tp/" .. k .. ".tex"))
end

--所有物品的介绍相关
modimport "scripts/prefab_desc.lua"
modimport "scripts/debug.lua"
modimport "scripts/tznewtree.lua"
--使用了大量api，设置了太真动作及部分sg
modimport "scripts/tz_actions.lua"
modimport "scripts/stategraphs/SGtz_floating_music_player.lua"
modimport "scripts/stategraphs/SGtz_killknife.lua"
modimport "scripts/stategraphs/SGtz_boomtong_player.lua"
--变身sg相关
modimport "scripts/stategraphs/SGtz_bianshen.lua"
--修仙修特喵的
modimport "scripts/tz_xiuxian.lua"
--bilibili
modimport("scripts/tzbilibili.lua")
--
modimport("main/tz_san_yyxk.lua") --
modimport("scripts/tz_tile")
--加载QM控件
modimport("QingMu_Mod.lua")
modimport("main/tz_skin.lua")
modimport("main/tz_elong.lua")
modimport("main/tz_littletz_api.lua")
modimport("main/tz_weaponcharge_api.lua")
modimport("main/tz_aoeweapon_common.lua")
modimport("main/tz_fh_api.lua")
modimport("main/tz_hide_map_button.lua")
modimport("main/tz_pugalisk_api.lua")
modimport("main/tz_plant.lua")
modimport("main/tz_rpg_api.lua")
modimport("main/tz_self_inspect_inv_api.lua")

--与影人相关的修改
--containers容器组件修改，包括影人和箱子等
modimport("scripts/xg_containers.lua")
--修改了潮湿值组件，在保护者附近的玩家起效
modimport("scripts/xg_moisture.lua")
--修改所有玩家周围有保护者的效果
modimport("scripts/xg_wilson.lua")

--
AddMinimapAtlas("images/map_icons/tz_spiritualism.xml")
AddMinimapAtlas("images/map_icons/taizhen.xml")
AddMinimapAtlas("images/map_icons/dragoncat_express.xml")
AddMinimapAtlas("images/map_icons/tz_miemieback.xml")
AddMinimapAtlas("images/map_icons/tz_swordcemetery.xml")
AddMinimapAtlas("images/map_icons/tz_machine.xml")
AddMinimapAtlas("images/map_icons/tz_delivery.xml")
AddMinimapAtlas("images/map_icons/tz_dragonpot_mapicon.xml")
AddMinimapAtlas("images/map_icons/taizhen_avatar.xml")
AddMinimapAtlas("images/map_icons/tz_yexingzhe_purple.xml")
AddMinimapAtlas("images/map_icons/tz_elong_box_map.xml")
AddMinimapAtlas("images/map_icons/tz_nobeautiful_room.xml")
AddMinimapAtlas("images/map_icons/tz_truthbasketball.xml")
AddModCharacter("taizhen", "MALE")
--[[
GLOBAL.TUNING.TZ_YEZHAO_SPECIFIC = GetModConfigData("tz_yezhao_specific")
GLOBAL.TUNING.TZ_YEXINGZHE_SPECIFIC = GetModConfigData("tz_yexingzhe_specific")
GLOBAL.TUNING.TZ_ENCHANTER_SPECIFIC = GetModConfigData("tz_enchanter_specific")
--]]

TUNING.TZ_FANHAO_SPECIFIC = GetModConfigData("tz_fanhao_specific")
TUNING.TZ_CAT_BOX_BAOXIAN = GetModConfigData("cat-box")

local minisignatlas = {
	"tz_enchanter","tz_yexingzhe","tz_yezhao","tz_fhspts","tz_fhzlz","tz_fhzc","tz_fhft","tz_fhbm",
	"tz_fhgx","tz_fh_fishgirl","tz_enchanter_yellow","tz_fhdx","tz_fhym","tz_fh_you","lostumbrella_builder","lostearth_builder",
	"lostchester_builder","lostfight_builder","tz_dark_cookpot"
}
for i, v in ipairs(minisignatlas) do
	--table.insert(Assets,Asset("ATLAS_BUILD", "images/inventoryimages/"..v..".xml", 256))
end

local evil_doctrine = AddRecipeTab( STRINGS.PEIFANGEVIL, 522, "images/hud/evil_doctrine.xml", "evil_doctrine.tex", "tz_builder")
local tz_maimeng = AddRecipeTab( STRINGS.PEIFANGMENG, 524, "images/hud/tz_maimeng.xml", "tz_maimeng.tex", "tz_builder")
local tz_jianzhong = AddRecipeTab( STRINGS.PEIFANGJIAN, 521, "images/hud/tz_jianzhong.xml", "tz_jianzhong.tex", "tz_builder")

--------------------------------------------    邪心教义科技树    ---------------------------------------------
STRINGS.CHARACTERS.GENERIC.ACTIONFAIL.BUILD.NOENOUGHMAXSAMA = "撒麻值上限不足400"
local function candopet(recipe, inst, pt, rotation)
	if not (inst.components.tzsama and inst.components.tzsama.max >= 400) then
		return false,"NOENOUGHMAXSAMA"
	end
	return true
end
AddRecipe2("lostumbrella_builder",
{Ingredient("nightmarefuel", 5),Ingredient(GLOBAL.CHARACTER_INGREDIENT.MAX_SANITY, 0.1)},
TECH.TZ_EVIL_TEACHER_TWO, {nounlock = true, builder_tag = "tz_builder", atlas = "images/inventoryimages/lostumbrella_builder.xml",image = "lostumbrella_builder.tex" },
{"CRAFTING_STATION"}).istzpet = true

AddRecipe2("lostumbrella_gai_builder",
{Ingredient("nightmarefuel", 10),Ingredient(GLOBAL.CHARACTER_INGREDIENT.MAX_SANITY, 0.1)},
TECH.TZ_EVIL_TEACHER_THREE, {canbuild = candopet, nounlock = true, builder_tag = "tz_builder", atlas = "images/inventoryimages/lostumbrella_gai_builder.xml",image = "lostumbrella_gai_builder.tex" },
{"CRAFTING_STATION"}).istzpet = true

AddRecipe2("lostearth_builder",
{Ingredient("nightmarefuel", 5), Ingredient(GLOBAL.CHARACTER_INGREDIENT.MAX_SANITY, 0.1)},
TECH.TZ_EVIL_TEACHER_TWO, {nounlock = true, builder_tag = "tz_builder", atlas = "images/inventoryimages/lostearth_builder.xml",image = "lostearth_builder.tex" },
{"CRAFTING_STATION"}).istzpet = true

AddRecipe2("lostearth_gai_builder",
{Ingredient("nightmarefuel", 10), Ingredient(GLOBAL.CHARACTER_INGREDIENT.MAX_SANITY, 0.1)},
TECH.TZ_EVIL_TEACHER_THREE, {canbuild = candopet, nounlock = true, builder_tag = "tz_builder", atlas = "images/inventoryimages/lostearth_gai_builder.xml",image = "lostearth_gai_builder.tex" },
{"CRAFTING_STATION"}).istzpet = true

AddRecipe2("lostchester_builder",
{Ingredient("nightmarefuel", 5), Ingredient(GLOBAL.CHARACTER_INGREDIENT.MAX_SANITY, 0.1)},
TECH.TZ_EVIL_TEACHER_TWO, {nounlock = true, builder_tag = "tz_builder", atlas = "images/inventoryimages/lostchester_builder.xml",image = "lostchester_builder.tex" },
{"CRAFTING_STATION"}).istzpet = true

AddRecipe2("lostchester_gai_builder",
{Ingredient("nightmarefuel", 10), Ingredient(GLOBAL.CHARACTER_INGREDIENT.MAX_SANITY, 0.1)},
TECH.TZ_EVIL_TEACHER_THREE, {canbuild = candopet, nounlock = true, builder_tag = "tz_builder", atlas = "images/inventoryimages/lostchester_gai_builder.xml",image = "lostchester_gai_builder.tex" },
{"CRAFTING_STATION"}).istzpet = true


AddRecipe2("lostfight_builder",
{Ingredient("nightmarefuel", 5), Ingredient(GLOBAL.CHARACTER_INGREDIENT.MAX_SANITY, 0.1)},
TECH.TZ_EVIL_TEACHER_TWO, {nounlock = true, builder_tag = "tz_builder", atlas = "images/inventoryimages/lostfight_builder.xml",image = "lostfight_builder.tex" },
{"CRAFTING_STATION"}).istzpet = true

AddRecipe2("lostfight_gai_builder",
{Ingredient("nightmarefuel", 10), Ingredient(GLOBAL.CHARACTER_INGREDIENT.MAX_SANITY, 0.1)},
TECH.TZ_EVIL_TEACHER_THREE, {canbuild = candopet, nounlock = true, builder_tag = "tz_builder", atlas = "images/inventoryimages/lostfight_gai_builder.xml",image = "lostfight_gai_builder.tex" },
{"CRAFTING_STATION"}).istzpet = true


AddRecipe2("tz_dark_cookpot",
{Ingredient("nightmarefuel", 9)},
TECH.TZ_EVIL_TEACHER_THREE, {nounlock = true, builder_tag = "tz_builder", atlas = "images/inventoryimages/tz_dark_cookpot.xml",image = "tz_dark_cookpot.tex" },
{"CRAFTING_STATION"})


local function canbiubiu(recipe, inst, pt, rotation)
	if inst.components.inventory then
		local item = inst.components.inventory:FindItem(function(item)
			 return item.prefab == "tz_pugalisk_crystal" and item.level == 10
		end)
		if item then
			item:Remove() --找到就直接移除
			return true
		end		
	end
	return false,"NOPUGALISK_CRYSTAL"
end

--======================================太真太真
--AddRecipeFilter({
--	name = "TAIZHENTAIZHEN",
--	atlas = "images/hud/tz_maimeng.xml",
--	image = "tz_maimeng.tex",
--	image_size = 64,
--	})
--STRINGS.UI.CRAFTING_FILTERS.TAIZHENTAIZHEN = "太真太真"

local old_alt,oldimg = CRAFTING_FILTERS.CHARACTER.atlas,CRAFTING_FILTERS.CHARACTER.image
CRAFTING_FILTERS.CHARACTER.atlas = function(owner)
	if owner and owner.prefab == "taizhen" then
		return "images/hud/tz_maimeng.xml"
	end
	return old_alt(owner)
end
CRAFTING_FILTERS.CHARACTER.image = function(owner)
	if owner and owner.prefab == "taizhen" then
		return "tz_maimeng.tex"
	end
	return oldimg(owner)
end
--CHARACTER
--番号盛宴
AddRecipe2("tz_enchanter",
{Ingredient("tz_spiritualism", 1,"images/inventoryimages/tz_spiritualism.xml"),Ingredient("nightmarefuel", 30)},
TECH.NONE, {builder_tag = "tz_builder", atlas = "images/inventoryimages/tz_enchanter.xml",image = "tz_enchanter.tex" },
{"CHARACTER"})
--番号月蚀
AddRecipe2("tz_yexingzhe",
{Ingredient("tz_spiritualism", 1, "images/inventoryimages/tz_spiritualism.xml"),Ingredient("nightmarefuel", 15)},
TECH.NONE, {builder_tag = "tz_builder", atlas = "images/inventoryimages/tz_yexingzhe.xml",image = "tz_yexingzhe.tex" },
{"CHARACTER"})
--番号照夜
AddRecipe2("tz_yezhao",
{Ingredient("tz_spiritualism", 1, "images/inventoryimages/tz_spiritualism.xml"),Ingredient("nightmarefuel", 15)},
TECH.NONE, {builder_tag = "tz_builder", atlas = "images/inventoryimages/tz_yezhao.xml",image = "tz_yezhao.tex" },
{"CHARACTER"})

--番号盛宴-饿龙
AddRecipe2("tz_enchanter_yellow",
{Ingredient("tz_enchanter",1,"images/inventoryimages/tz_enchanter.xml"),Ingredient("taizhen_cosplayyellow", 1,"images/inventoryimages/taizhen_cosplayyellow.xml")},
TECH.LOST, {canbuild = xxcanbuildfh,builder_tag = "tz_builder", atlas = "images/inventoryimages/tz_enchanter_yellow.xml",image = "tz_enchanter_yellow.tex" },
{"CHARACTER"})

--专属番号修仙等级要求
TUNING.TZ_FH_XXDJ = GetModConfigData("fh_xxdj") or 0
STRINGS.CHARACTERS.GENERIC.ACTIONFAIL.BUILD.TZ_XXLOCK = "修仙等级不够"
local function xxcanbuildfh(recipe, inst, pt, rotation)
	if inst.components.tz_xx ~= nil then
		if inst.components.tz_xx.dengji >= TUNING.TZ_FH_XXDJ then
			return true
		end
		return false, "TZ_XXLOCK"
	end
	return false
end

--番号审判天使
AddRecipe2("tz_fhspts",
{Ingredient("tz_spiritualism", 1,"images/inventoryimages/tz_spiritualism.xml"),Ingredient("redgem", 2),Ingredient("marble", 10)},
TECH.LOST, {canbuild = xxcanbuildfh,builder_tag = "tz_builder", atlas = "images/inventoryimages/tz_fhspts.xml",image = "tz_fhspts.tex" },
{"CHARACTER"})
--番号再临者
AddRecipe2("tz_fhzlz",
{Ingredient("tz_spiritualism", 1,"images/inventoryimages/tz_spiritualism.xml"),Ingredient("opalpreciousgem", 1),Ingredient("dragon_scales", 1)},
TECH.LOST, {canbuild = xxcanbuildfh,builder_tag = "tz_builder", atlas = "images/inventoryimages/tz_fhzlz.xml",image = "tz_fhzlz.tex" },
{"CHARACTER"})
--番号仲裁
AddRecipe2("tz_fhzc",
{Ingredient("tz_spiritualism", 1,"images/inventoryimages/tz_spiritualism.xml"),Ingredient("nightmarefuel", 5),Ingredient("petals", 5)},
TECH.LOST, {canbuild = xxcanbuildfh,builder_tag = "tz_builder", atlas = "images/inventoryimages/tz_fhzc.xml",image = "tz_fhzc.tex" },
{"CHARACTER"})

--番号否天
AddRecipe2("tz_fhft",
{Ingredient("tz_spiritualism", 1,"images/inventoryimages/tz_spiritualism.xml"),Ingredient("ruinshat", 1),Ingredient("nightmarefuel", 100)},
TECH.LOST, {canbuild = xxcanbuildfh,builder_tag = "tz_builder", atlas = "images/inventoryimages/tz_fhft.xml",image = "tz_fhft.tex" },
{"CHARACTER"})

--番号薄暝
AddRecipe2("tz_fhbm",
{Ingredient("tz_spiritualism", 1,"images/inventoryimages/tz_spiritualism.xml"),Ingredient("alterguardianhat", 1),Ingredient("opalpreciousgem", 20)},
TECH.LOST, {canbuild = xxcanbuildfh,builder_tag = "tz_builder", atlas = "images/inventoryimages/tz_fhbm.xml",image = "tz_fhbm.tex" },
{"CHARACTER"})

--番号归墟
AddRecipe2("tz_fhgx",
{Ingredient("tz_spiritualism", 1,"images/inventoryimages/tz_spiritualism.xml"),Ingredient("redmooneye", 2),Ingredient("bluemooneye", 2)},
TECH.LOST, {canbuild = xxcanbuildfh,builder_tag = "tz_builder", atlas = "images/inventoryimages/tz_fhgx.xml",image = "tz_fhgx.tex" },
{"CHARACTER"})

--番号鱼妞的眷恋
AddRecipe2("tz_fh_fishgirl",
{Ingredient("tz_spiritualism", 1,"images/inventoryimages/tz_spiritualism.xml"),Ingredient("nightmarefuel", 10),Ingredient("icestaff", 1),Ingredient("cane", 1)},
TECH.LOST, {canbuild = xxcanbuildfh,builder_tag = "tz_builder", atlas = "images/inventoryimages/tz_fh_fishgirl.xml",image = "tz_fh_fishgirl.tex" },
{"CHARACTER"})

--番号凝心
AddRecipe2("tz_fh_nx",
{Ingredient("tz_spiritualism", 1,"images/inventoryimages/tz_spiritualism.xml"),Ingredient("moonrocknugget", 10),Ingredient("redgem", 1)},
TECH.LOST, {canbuild = xxcanbuildfh,builder_tag = "tz_builder", atlas = "images/inventoryimages/tz_fh_nx.xml",image = "tz_fh_nx.tex" },
{"CHARACTER"})

--番号化凡
AddRecipe2("tz_fh_hf",
{Ingredient("tz_spiritualism", 1,"images/inventoryimages/tz_spiritualism.xml"),Ingredient("flint", 5),Ingredient("twigs", 5)},
TECH.LOST, {canbuild = xxcanbuildfh,builder_tag = "tz_builder", atlas = "images/inventoryimages/tz_fh_hf.xml",image = "tz_fh_hf.tex" },
{"CHARACTER"})

--番号两仪
AddRecipe2("tz_fh_ly",
{Ingredient("tz_spiritualism", 1,"images/inventoryimages/tz_spiritualism.xml"),Ingredient("armor_sanity", 1),Ingredient("opalpreciousgem", 1)},
TECH.LOST, {canbuild = xxcanbuildfh,builder_tag = "tz_builder", atlas = "images/inventoryimages/tz_fh_ly.xml",image = "tz_fh_ly.tex" },
{"CHARACTER"})

--番号海洋女神
AddRecipe2("tz_fh_ns",
{Ingredient("tz_spiritualism", 1,"images/inventoryimages/tz_spiritualism.xml"),Ingredient("goldnugget", 88),Ingredient("bluegem", 8)},
TECH.LOST, {canbuild = xxcanbuildfh,builder_tag = "tz_builder", atlas = "images/inventoryimages/tz_fh_ns.xml",image = "tz_fh_ns.tex" },
{"CHARACTER"})

--番号地仙
AddRecipe2("tz_fhdx",
{Ingredient("tz_spiritualism", 1,"images/inventoryimages/tz_spiritualism.xml"), Ingredient("feather_robin", 1),Ingredient("petals", 1),},
TECH.LOST,{canbuild = xxcanbuildfh,builder_tag = "tz_builder",image = "tz_fhdx.tex",atlas = "images/inventoryimages/tz_fhdx.xml",},
{"CHARACTER"})

--番号夜幕
AddRecipe2("tz_fhym",
{Ingredient("tz_spiritualism", 1,"images/inventoryimages/tz_spiritualism.xml"), Ingredient("cutgrass", 5),Ingredient("twigs", 5),},
TECH.LOST,{canbuild = xxcanbuildfh,builder_tag = "tz_builder",image = "tz_fhym.tex",atlas = "images/inventoryimages/tz_fhym.xml",},
{"CHARACTER"})

--番号魔饕
AddRecipe2("tz_fhmt",
{Ingredient("tz_spiritualism", 1,"images/inventoryimages/tz_spiritualism.xml"), Ingredient("meat", 2),Ingredient("charcoal", 5),},
TECH.LOST,{canbuild = xxcanbuildfh,builder_tag = "tz_builder",image = "tz_fhmt.tex",atlas = "images/inventoryimages/tz_fhmt.xml",},
{"CHARACTER"})


--番号忆思
AddRecipe2("tz_fh_ys",
{Ingredient("tz_spiritualism", 1,"images/inventoryimages/tz_spiritualism.xml"), Ingredient("glommerwings", 1),Ingredient("glommerfuel", 2),},
TECH.LOST,{canbuild = xxcanbuildfh,builder_tag = "tz_builder",image = "tz_fh_ys.tex",atlas = "images/inventoryimages/tz_fh_ys.xml",},
{"CHARACTER"})

--番号游
AddRecipe2("tz_fh_you",
{Ingredient("tz_spiritualism", 1,"images/inventoryimages/tz_spiritualism.xml"), Ingredient("silk", 5),Ingredient("livinglog", 2),},
TECH.LOST,{canbuild = xxcanbuildfh,builder_tag = "tz_builder",image = "tz_fh_you.tex",atlas = "images/inventoryimages/tz_fh_you.xml",},
{"CHARACTER"})

--番号魔临
AddRecipe2("tz_fh_ml",
{Ingredient("tz_spiritualism", 1,"images/inventoryimages/tz_spiritualism.xml"), 
Ingredient("tz_deathbook", 10,"images/inventoryimages/tz_deathbook.xml"),
Ingredient("shadow_throne", 10,"images/inventoryimages/shadow_throne.xml"),},
TECH.LOST,{canbuild = xxcanbuildfh,builder_tag = "tz_builder",image = "tz_fh_ml.tex",atlas = "images/inventoryimages/tz_fh_ml.xml",},
{"CHARACTER"})

--黑天
AddRecipe2("tz_fh_ht",
{Ingredient("tz_spiritualism", 1,"images/inventoryimages/tz_spiritualism.xml"), 
Ingredient("tz_evil_teacher", 1,"images/inventoryimages/tz_evil_teacher.xml"),
Ingredient("nightmarefuel", 5),},
TECH.LOST,{canbuild = xxcanbuildfh,builder_tag = "tz_builder",image = "tz_fh_ht.tex",atlas = "images/inventoryimages/tz_fh_ht.xml",},
{"CHARACTER"})

--羲和望舒
AddRecipe2("tz_fh_xhws",
{Ingredient("tz_spiritualism", 1,"images/inventoryimages/tz_spiritualism.xml"), 
Ingredient("redgem", 3),
Ingredient("bluegem", 3),
Ingredient("nightmarefuel", 3),},
TECH.LOST,{canbuild = xxcanbuildfh,builder_tag = "tz_builder",image = "tz_fh_xhws.tex",atlas = "images/inventoryimages/tz_fh_xhws.xml",},
{"CHARACTER"})

--风雷
AddRecipe2("tz_fh_fl",
{Ingredient("tz_spiritualism", 1,"images/inventoryimages/tz_spiritualism.xml"), 
Ingredient("petals", 12),
Ingredient("nightmarefuel", 5),},
TECH.LOST,{canbuild = xxcanbuildfh,builder_tag = "tz_builder",image = "tz_fh_fl.tex",atlas = "images/inventoryimages/tz_fh_fl.xml",},
{"CHARACTER"})

--汲取者
AddRecipe2("tz_fh_jhz",
{Ingredient("tz_spiritualism", 1,"images/inventoryimages/tz_spiritualism.xml"), 
Ingredient(CHARACTER_INGREDIENT.SANITY, 180),
Ingredient("nightmarefuel", 5),},
TECH.LOST,{canbuild = xxcanbuildfh,builder_tag = "tz_builder",image = "tz_fh_jhz.tex",atlas = "images/inventoryimages/tz_fh_jhz.xml",},
{"CHARACTER"})

local AddTzRecipe  = function(name,ingredients,tab,tech,placer,min_spacing,nounlock,numtogive,builder_tag,atlas,image,testfn, product)
	AddRecipe2(name,ingredients,tech,{
	placer = placer,
	min_spacing = min_spacing or 3.2,
	nounlock = false,
	numtogive = numtogive or 1,
	builder_tag= builder_tag or "tz_builder",
	atlas = atlas,
	image = image,
	testfn = testfn ,
	product = product or name},
	{"CHARACTER"})
	if atlas then
		--table.insert(Assets,Asset("ATLAS_BUILD", atlas, 256))
	end
end
--种子1
AddTzRecipe("tz_seed_bdzx",{Ingredient("ice", 99),Ingredient("seeds", 1)}, tz_maimeng, TECH.SCIENCE_TWO, 
nil, nil, nil, nil, "tz_builder","images/inventoryimages/tz_seed_bdzx.xml", "tz_seed_bdzx.tex")

--种子2
AddTzRecipe("tz_seed_hhzx",{Ingredient("cutgrass", 99),Ingredient("seeds", 1)}, tz_maimeng, TECH.SCIENCE_TWO, 
nil, nil, nil, nil, "tz_builder","images/inventoryimages/tz_seed_hhzx.xml", "tz_seed_hhzx.tex")
--------------------------------------------    玩具箱科技树    ---------------------------------------------
---
AddTzRecipe("tzxx_mnq",{Ingredient("nightmarefuel", 3)}, tz_maimeng, TECH.NONE, 
nil, nil, nil, nil, "tz_builder","images/inventoryimages/tzxx_mnq.xml", "tzxx_mnq.tex")

AddTzRecipe("tz_hlmj",{Ingredient("goldnugget", 2)}, tz_maimeng, TECH.NONE, 
nil, nil, nil, nil, "tz_builder","images/inventoryimages/tz_hlmj.xml", "tz_hlmj.tex")

--邪心教典【魇】
AddTzRecipe("tz_deathbook",{Ingredient("papyrus",2),Ingredient("nightmarefuel", 10)}, tz_maimeng, TECH.MAGIC_TWO, 
nil, nil, nil, nil, "tz_builder","images/inventoryimages/tz_deathbook.xml", "tz_deathbook.tex")
--邪心教典【织影】
AddTzRecipe("tz_evil_teacher",{Ingredient("papyrus", 2), Ingredient("nightmarefuel", 5), Ingredient(GLOBAL.CHARACTER_INGREDIENT.HEALTH, 50)}, tz_maimeng, TECH.NONE,
nil, nil, nil, nil, "tz_builder","images/inventoryimages/tz_evil_teacher.xml", "tz_evil_teacher.tex")
--邪心教典【织影】
AddTzRecipe("tz_evil_teacher_super",{Ingredient("nightmarefuel", 9)}, tz_maimeng, TECH.NONE,
nil, nil, nil, nil, "tz_builder","images/inventoryimages/tz_evil_teacher_super.xml", "tz_evil_teacher_super.tex")
--超级包裹
if GetModConfigData("packbox")  then
AddTzRecipe("tz_packbox",{Ingredient("waxpaper", 1),Ingredient("rope", 3),Ingredient("papyrus", 10)}, tz_maimeng, TECH.SCIENCE_TWO, 
nil,nil,nil,nil, "tz_builder","images/inventoryimages/tz_packbox.xml", "tz_packbox.tex")
end
--替身布偶
AddTzRecipe("tz_staff",{Ingredient("reviver", 1),Ingredient("nightmarefuel", 5),Ingredient("rope", 1)}, tz_maimeng, TECH.MAGIC_TWO, 
nil,nil,nil,nil, "tz_builder","images/inventoryimages/tz_staff.xml", "tz_staff.tex")
--转生布偶
AddTzRecipe("tz_doubles",{Ingredient("reviver", 1),Ingredient("feather_crow", 9)}, tz_maimeng, TECH.MAGIC_THREE, 
nil,nil,nil,nil, "tz_builder","images/inventoryimages/tz_doubles.xml", "tz_doubles.tex")
--胖白熊星朵
--AddTzRecipe("pangballoons_empty",{Ingredient("trunk_summer", 1),Ingredient("rope", 5),Ingredient("lightbulb", 5)}, tz_maimeng, TECH.NONE, 
--nil,nil,nil,nil, "tz_builder","images/inventoryimages/pangballoons_empty.xml", "pangballoons_empty.tex") 

AddTzRecipe("tz_ecyballoonspeed",{Ingredient("rope", 1)}, tz_maimeng, TECH.SCIENCE_TWO,
nil,nil,nil,nil, "tz_builder","images/inventoryimages/pangballoons_empty.xml", "pangballoons_empty.tex") 

--化学饮料
AddTzRecipe("tz_cannedtnt",{Ingredient("goldnugget", 1),Ingredient("nitre", 2),Ingredient("rocks", 3)}, tz_maimeng, TECH.SCIENCE_TWO, 
nil, nil, nil, nil,"tz_builder","images/inventoryimages/tz_cannedtnt.xml", "tz_cannedtnt.tex")
--招财进宝桶
AddTzRecipe("tz_boomtong_item",{Ingredient("gunpowder", 3),Ingredient("nitre", 9),Ingredient("boards", 6)}, tz_maimeng, TECH.SCIENCE_TWO, 
nil,nil,nil,nil, "tz_builder","images/inventoryimages/tz_boomtong_item.xml", "tz_boomtong_item.tex")
--威尔逊武器
AddTzRecipe("tz_spear",{Ingredient("rope", 2),Ingredient("nightmarefuel", 1)}, tz_maimeng, TECH.SCIENCE_ONE,  
nil,nil,nil,nil, "tz_builder","images/inventoryimages/tz_spear.xml", "tz_spear.tex")
--萝卜即正义
AddTzRecipe("tz_luobostaff",{Ingredient("livinglog", 1),Ingredient("carrot", 99),Ingredient("rope", 2)}, tz_maimeng, TECH.MAGIC_THREE,  
nil,nil,nil,nil, "tz_builder","images/inventoryimages/tz_luobostaff.xml", "tz_luobostaff.tex")

--光明铠甲
AddRecipe2("ta_wzk_armor",
{Ingredient("tz_pugalisk_crystal", 0,"images/inventoryimages/tz_pugalisk_crystal.xml")},
TECH.MAGIC_THREE, {canbuild = canbiubiu,builder_tag = "tz_builder", atlas = "images/inventoryimages/ta_wzk_armor.xml",image = "ta_wzk_armor.tex" },
{"CHARACTER"})

--雪球投掷游戏
AddTzRecipe("tz_iceball",{Ingredient("ice", 5)}, tz_maimeng, TECH.MAGIC_THREE,  
nil,nil,nil,nil, "tz_builder","images/inventoryimages/tz_iceball.xml", "tz_iceball.tex")
--大进化药
AddTzRecipe("tz_pills",{Ingredient("meat", 9),Ingredient("ash", 3),Ingredient("bandage", 1)}, tz_maimeng, TECH.MAGIC_THREE, 
nil,nil,nil,nil, "tz_builder","images/inventoryimages/tz_pills.xml", "tz_pills.tex")
--恐吓加热炉
AddTzRecipe("tz_liang",{Ingredient("redgem", 2),Ingredient("gears", 1),Ingredient("transistor", 2)}, tz_maimeng, TECH.SCIENCE_TWO, 
nil,nil,nil,nil, "tz_builder","images/inventoryimages/tz_liang.xml", "tz_liang.tex")
--刺杀匕首
-- AddTzRecipe("tz_killknife",{Ingredient("spear", 1),Ingredient("boneshard", 9),Ingredient("petals", 9)}, tz_maimeng, TECH.MAGIC_THREE, 
-- nil,nil,nil,nil, "tz_builder","images/inventoryimages/tz_killknife.xml", "tz_killknife.tex")
--亚龙美少女琵琶
AddTzRecipe("tz_floating_music_weapon",{Ingredient("transistor", 4),Ingredient("opalpreciousgem", 2),Ingredient("cutstone", 3)}, tz_maimeng, TECH.MAGIC_THREE, 
nil,nil,nil,nil, "tz_builder","images/inventoryimages/tz_floating_music_weapon.xml", "tz_floating_music_weapon.tex")
-- 太真rpg
AddTzRecipe("tz_rpg",{Ingredient("gears", 2),Ingredient("transistor", 2),Ingredient("gunpowder", 2)}, tz_maimeng, TECH.MAGIC_THREE, 
nil,nil,nil,nil, "tz_builder","images/inventoryimages/tz_rpg.xml", "tz_rpg.tex")
--小丑兔奇莫格
AddTzRecipe("qimoge", {Ingredient("manrabbit_tail", 19), Ingredient("cutreeds", 12), Ingredient("rope", 4)}, tz_maimeng, TECH.MAGIC_THREE,
nil,nil,nil,nil,"tz_builder", "images/qimoge.xml", "qimoge.tex")
--太阳镜
AddTzRecipe("tz_yanjing",{Ingredient("flint", 2),Ingredient("goldnugget", 10)}, tz_maimeng, TECH.SCIENCE_TWO, 
nil, nil,nil,nil, "tz_builder","images/inventoryimages/tz_yanjing.xml", "tz_yanjing.tex") 
--蜗牛的微型时空
AddTzRecipe("tz_delivery",{Ingredient("transistor", 1),Ingredient("rocks", 1)}, tz_maimeng, TECH.MAGIC_THREE, 
nil,nil,nil,nil, "tz_builder","images/inventoryimages/tz_delivery.xml", "tz_delivery.tex")
--时空旋涡枢纽
AddTzRecipe("tz_teleport", {Ingredient("transistor", 3),Ingredient("cutstone",3)},tz_maimeng,TECH.MAGIC_THREE,"tz_teleport_placer",1,
nil,nil,nil,"images/inventoryimages/tz_teleport.xml","tz_teleport.tex")
--中华龙腾锅
AddTzRecipe("tz_dragonpot",{Ingredient("redgem", 3),Ingredient("cutstone", 3),Ingredient("goldnugget", 1)}, tz_maimeng, TECH.SCIENCE_TWO, "tz_dragonpot_placer",4,
nil,nil, "tz_builder","images/inventoryimages/tz_dragonpot.xml", "tz_dragonpot.tex")
--饿龙冰箱
AddTzRecipe("tz_elong_box", {Ingredient("gears", 1),Ingredient("meat", 9)}, tz_maimeng, TECH.SCIENCE_TWO, "tz_elong_box_placer", 1.5, 
nil, nil,"tz_builder","images/inventoryimages/tz_elong_box.xml", "tz_elong_box.tex")
--科学鲲与魔法篮球
AddTzRecipe("zhanli", {Ingredient("purplegem", 1),Ingredient("cutstone", 4),Ingredient("transistor", 4)}, tz_maimeng, SCIENCE_ONE, "zhanli_placer",1,
nil,nil,nil,"images/inventoryimages/change_researchlab2.xml", "change_researchlab2.tex")
AddMinimapAtlas("images/inventoryimages/change_researchlab2.xml")
--勇者斗恶龙
AddTzRecipe("tz_machine", {Ingredient("transistor", 4),Ingredient("goldnugget", 10),Ingredient("cutstone", 10)}, tz_maimeng, TECH.MAGIC_TWO, "tz_machine_placer", 4, 
nil, nil,"tz_builder","images/inventoryimages/tz_machine.xml", "tz_machine.tex")

--硬币
AddRecipe2("tz_coin",
{Ingredient("goldnugget", 10), Ingredient("boards", 1)},
TECH.SCIENCE_ONE,{builder_tag = "tz_builder",image = "tz_coin.tex",atlas = "images/inventoryimages/tz_coin.xml",},
{"CHARACTER"})

--受侵蚀的神秘祭坛
AddTzRecipe("tz_swordcemetery", {Ingredient("petals_evil", 10),Ingredient("nightmarefuel", 10),Ingredient("thulecite", 10)}, tz_maimeng, TECH.ANCIENT_FOUR, "tz_swordcemetery_placer", 6, 
nil, nil,"tz_builder","images/inventoryimages/tz_swordcemetery.xml", "tz_swordcemetery.tex")

--爱与坤坤
AddRecipe2("tz_truthbasketball",
{Ingredient("atrium_key", 1),Ingredient("thulecite", 10)},
TECH.MAGIC_THREE,{no_deconstruction = true,min_spacing=6,placer = "tz_truthbasketball_placer",builder_tag = "tz_builder",image = "tz_truthbasketball.tex",atlas = "images/inventoryimages/tz_truthbasketball.xml",},
{"CHARACTER"})
--AddTzRecipe("tz_truthbasketball", {Ingredient("atrium_key", 1),Ingredient("thulecite", 10)}, tz_maimeng, TECH.MAGIC_THREE, "tz_truthbasketball_placer", 6, 
--nil, nil,"tz_builder","images/inventoryimages/tz_truthbasketball.xml", "tz_truthbasketball.tex")

--龙图腾地毯   
AddTzRecipe("turf_tz_dragonfloor",{Ingredient("furtuft",4),Ingredient("turf_carpetfloor", 1)}, tz_maimeng, TECH.SCIENCE_TWO, 
nil, nil, true,4, "tz_builder","images/inventoryimages/turf_tz_dragonfloor.xml", "turf_tz_dragonfloor.tex")
--石心
AddTzRecipe("tz_statue_stoneheart",{Ingredient("rocks", 10),Ingredient("pickaxe",1)}, tz_maimeng, TECH.SCIENCE_ONE, 
nil,nil,nil,nil, "tz_builder","images/inventoryimages/tz_statue_stoneheart.xml", "tz_statue_stoneheart.tex")
--灵狐雕像
AddTzRecipe("tz_statue_fox",{Ingredient("tz_statue_stoneheart",9,"images/inventoryimages/tz_statue_stoneheart.xml")}, tz_maimeng, TECH.SCIENCE_TWO, "tz_statue_fox_placer",4,
nil,nil, "tz_builder","images/inventoryimages/tz_statue_fox.xml", "tz_statue_fox.tex")
--精灵雕像
AddTzRecipe("tz_statue_spirit",{Ingredient("tz_statue_stoneheart",9,"images/inventoryimages/tz_statue_stoneheart.xml")}, tz_maimeng, TECH.SCIENCE_TWO, "tz_statue_spirit_placer",4,
nil,nil, "tz_builder","images/inventoryimages/tz_statue_spirit.xml", "tz_statue_spirit.tex")

-- Ly:Delete craft item_fanta_blade
-- AddTzRecipe("item_fanta_blade",{Ingredient("goldnugget", 99)}, tz_maimeng, TECH.NONE, 
-- nil, nil, true, nil, "tz_builder","images/QM_UI10.xml", "item_fanta_blade.tex")

--饿龙
AddTzRecipe("tz_elong_horn",{Ingredient("minotaurhorn", 1)},tz_maimeng, TECH.SCIENCE_TWO,
nil, nil, nil, nil, nil,
"images/inventoryimages/tz_elong_horn.xml")

--葬爱小学时装包
AddTzRecipe("taizhen_cosplayblue",{Ingredient("goldnugget", 50)}, tz_maimeng, TECH.SCIENCE_TWO, 
nil,nil,nil,nil, "tz_builder","images/inventoryimages/taizhen_cosplayblue.xml", "taizhen_cosplayblue.tex")
--饿龙时装包
AddTzRecipe("taizhen_cosplayyellow",{Ingredient("goldnugget", 50)}, tz_maimeng, TECH.SCIENCE_TWO, 
nil,nil,nil,nil, "tz_builder","images/inventoryimages/taizhen_cosplayyellow.xml", "taizhen_cosplayyellow.tex")
--逐暗浪客时装包
AddTzRecipe("taizhen_cosplayblack",{Ingredient("goldnugget", 50)}, tz_maimeng, TECH.MAGIC_THREE, 
nil,nil,nil,nil, "tz_builder","images/inventoryimages/taizhen_cosplayblack.xml", "taizhen_cosplayblack.tex")
--来自火星
AddTzRecipe("tz_feidie",{Ingredient("goldnugget", 99)}, tz_maimeng, TECH.MAGIC_TWO, 
nil,nil,nil,nil, "tz_builder","images/inventoryimages/tz_feidie.xml", "tz_feidie.tex")
--饿龙时装包Pro版
AddTzRecipe("taizhen_cosplayyellowpro",{Ingredient("goldnugget", 99)}, tz_maimeng, TECH.MAGIC_THREE, 
nil,nil,nil,nil, "tz_builder","images/inventoryimages/taizhen_cosplayyellowpro.xml", "taizhen_cosplayyellowpro.tex")

AddTzRecipe("taizhen_cosplaypink",{Ingredient("goldnugget", 99)}, tz_maimeng, TECH.MAGIC_THREE, 
nil,nil,nil,nil, "tz_builder","images/inventoryimages/taizhen_cosplaypink.xml", "taizhen_cosplaypink.tex")

AddTzRecipe("taizhen_cosplaypurple",{Ingredient("goldnugget", 99)}, tz_maimeng, TECH.MAGIC_THREE, 
nil,nil,nil,nil, "tz_builder","images/inventoryimages/taizhen_cosplaypurple.xml", "taizhen_cosplaypurple.tex")

--------------------------------------------    已移除的道具    ---------------------------------------------
--[[
--图勒凛风
AddTzRecipe("tz_icesword",{Ingredient("thulecite", 2),Ingredient("walrus_tusk", 1),Ingredient("tz_unknowf", 1, "images/inventoryimages/tz_unknowf.xml")},tz_jianzhong, TECH.TZ_SWORD_TEACHER_TWO, 
nil, nil, true, nil, "tz_builder","images/inventoryimages/tz_icesword.xml", "tz_icesword.tex")
--图勒热火
AddTzRecipe("tz_firesword",{Ingredient("thulecite", 2),Ingredient("dragon_scales", 3),Ingredient("tz_unknowk", 1, "images/inventoryimages/tz_unknowk.xml" )}, tz_jianzhong, TECH.TZ_SWORD_TEACHER_TWO, 
nil, nil, true, nil, "tz_builder","images/inventoryimages/tz_firesword.xml", "tz_firesword.tex")
--讨伐大剑
AddTzRecipe("tz_tfsword",{Ingredient("thulecite", 2),Ingredient("skeletonhat", 1),Ingredient("tz_unknowm", 1, "images/inventoryimages/tz_unknowm.xml" )}, tz_jianzhong, TECH.TZ_SWORD_TEACHER_TWO, 
nil, nil, true, nil, "tz_builder","images/inventoryimages/tz_tfsword.xml", "tz_tfsword.tex")
--在恐惧之上
AddTzRecipe("tz_kjbook", {Ingredient("nightmarefuel", 4) ,Ingredient("tentaclespots", 1)}, evil_doctrine, TECH.MAGIC_TWO, 
nil, nil, true, nil, "tz_builder","images/inventoryimages/tz_kjbook.xml", "tz_kjbook.tex")
--小羊背包
AddTzRecipe("tz_miemieback",{Ingredient("steelwool", 3),Ingredient("rope", 2)}, tz_maimeng, TECH.SCIENCE_TWO, 
nil,nil,nil,nil, "tz_builder","images/inventoryimages/tz_miemieback.xml", "tz_miemieback.tex")
--维森莫·拉莫帅
AddTzRecipe("tz_tuji", {Ingredient("manrabbit_tail", 4),Ingredient("cutreeds", 8),Ingredient("rope", 2),}, tz_maimeng, TECH.MAGIC_TWO, 
nil, nil, nil, nil, "tz_builder","images/inventoryimages/tz_tuji.xml", "tz_tuji.tex")
--神秘古代皿器
AddTzRecipe("tz_drogenbox",{Ingredient("gears", 2),Ingredient("ice", 33),Ingredient("cutstone", 2)},tz_maimeng,  TECH.SCIENCE_TWO,"tz_drogenbox_placer", 1, 
nil, nil, nil,"images/inventoryimages/tz_drogenbox.xml" ,"tz_drogenbox.tex" )
AddMinimapAtlas("images/map_icons/tz_drogenbox.xml")
--]]
--------------------------------------------------------------------------------------------------------------------

local function tz_ecyballoonspeed_init_fn(inst,skin)
	inst.AnimState:OverrideSymbol("swap_balloon", "tz_ecyballoonspeed", skin)
	inst.AnimState:SetBuild("balloon2")
end

local tz_ecyballoonspeed_clear_fn = function(inst,skin) 
	tz_ecyballoonspeed_init_fn(inst,"none")
end

MakeItemSkinDefaultImage("tz_ecyballoonspeed","images/inventoryimages/tz_ecyballoonspeed.xml","tz_ecyballoonspeed")
MakeItemSkin("tz_ecyballoonspeed","bilibili",
{
	basebuild = "balloon2",
	rarity = "Loyal",
	type = "item",
	name = "2233娘",
    atlas = "images/inventoryimages/tz_ecyballoonspeed_bilibili.xml",
    image = "tz_ecyballoonspeed_bilibili",
	init_fn  = function(inst) tz_ecyballoonspeed_init_fn(inst,"bilibili")  end,
	clear_fn = tz_ecyballoonspeed_clear_fn,
})
MakeItemSkin("tz_ecyballoonspeed","hmbb",
{
	basebuild = "balloon2",
	rarity = "Loyal",
	type = "item",
	name = "海绵宝宝",
    atlas = "images/inventoryimages/tz_ecyballoonspeed_hmbb.xml",
    image = "tz_ecyballoonspeed_hmbb",
	init_fn  = function(inst) tz_ecyballoonspeed_init_fn(inst,"hmbb")  end,
	clear_fn = tz_ecyballoonspeed_clear_fn,
})


local containers = GLOBAL.require("containers")
containers._widgetsetup = containers.widgetsetup
containers.widgetsetup = function( container, prefab, data )
	prefab = container.inst.prefab == "qimoge" and (prefab or "krampus_sack") or prefab
	containers._widgetsetup(container, prefab, data)
end

--change 2019-05-16
--修改大图
if data and data.base_skin ~= nil and data.base_skin == "taizhen_pink_none" then
	if self.base_image ~= nil then
		if self.base_image._text ~= nil  then
			self.base_image._text:SetString("三周年贺岁")
			self.base_image._text:SetColour(255/255, 255/255, 0/255, 1)
		end
		if self.base_image._image ~= nil  then
			self.base_image._image:GetAnimState():OverrideSkinSymbol("SWAP_ICON", "tz_pink_icon", "SWAP_ICON")
		end
	end	
end
--tzBigportraits
local function ChangeBigportraits(self)  
	local oldUpdateData = self.UpdateData
	self.UpdateData = function(self,data,...)
		oldUpdateData(self,data,...)
		if self.currentcharacter == "taizhen" then 
			if ThePlayer._bianshen ~= nil and ThePlayer._bianshen:value() == true then
				self.portrait:SetTexture("bigportraits/taizhen_avatar.xml", "taizhen_avatar.tex")			
			elseif ThePlayer:HasTag("taizhen_yellowpro") then
				self.portrait:SetTexture("bigportraits/elong_none.xml", "elong_none.tex")
				self.base_image._text:SetMultilineTruncatedString("饿龙Pro版", 1, 100, 35, true, false)
				self.base_image._text:SetColour({ 1,0, 0, 1 })
				self.base_image._image:GetAnimState():OverrideSymbol("SWAP_ICON", "taizhen_yellowpro", "SWAP_ICON")
			end
		end
	end  
	if self.currentcharacter == "taizhen" then 
			if ThePlayer._bianshen ~= nil and ThePlayer._bianshen:value() == true then
				self.portrait:SetTexture("bigportraits/taizhen_avatar.xml", "taizhen_avatar.tex")				
			elseif ThePlayer:HasTag("taizhen_yellowpro") then
				self.portrait:SetTexture("bigportraits/elong_none.xml", "elong_none.tex")
				self.base_image._text:SetMultilineTruncatedString("饿龙Pro版", 1, 100, 35, true, false)
				self.base_image._text:SetColour({ 1,0, 0, 1 })
				self.base_image._image:GetAnimState():OverrideSymbol("SWAP_ICON", "taizhen_yellowpro", "SWAP_ICON")
			end
	end
end 
AddClassPostConstruct("widgets/playeravatarpopup", ChangeBigportraits) 
--change

AddPrefabPostInit("marble",function(inst)
    if not TheWorld.ismastersim then
        return inst
    end
    if not inst.components.tradable then
		inst:AddComponent("tradable")
	end
end)


local old_GIVE_strfn = ACTIONS.GIVE.strfn
ACTIONS.GIVE.strfn = function(act,...)
	return (act.target and (act.target:HasTag("tz_floating_music_weapon") or act.target:HasTag("tz_floating_music_minion"))) and "充能"
	or old_GIVE_strfn(act,...)
end 

local old_GIVE_stroverridefn = ACTIONS.GIVE.stroverridefn
ACTIONS.GIVE.stroverridefn = function(act,...)
	return (act.target and (act.target:HasTag("tz_floating_music_weapon") or act.target:HasTag("tz_floating_music_minion"))) and "充能"
	or old_GIVE_stroverridefn(act,...)
end 

local old_DEPLOY_strfn = ACTIONS.DEPLOY.strfn
ACTIONS.DEPLOY.strfn = function(act,...)
    return act.invobject ~= nil
        and (   (act.invobject:HasTag("tz_boomtong_item") and "TURRET")
			or old_DEPLOY_strfn(act,...)
		)
        or nil
end

AddReplicableComponent("taizhen_teleport")

local TechTree = require("techtree")

local function aaa(self)
	function self:EvaluateTechTrees()
		local pos = self.inst:GetPosition()
		local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, TUNING.RESEARCH_MACHINE_DIST, { "prototyper" }, self.exclude_tags)

		local old_accessible_tech_trees = deepcopy(self.accessible_tech_trees or TECH.NONE)
		local old_station_recipes = self.station_recipes
		local old_prototyper = self.current_prototyper
		self.current_prototyper = nil
		self.station_recipes = {}

		local prototyper_active = false
		for i, v in ipairs(ents) do
			
			--主要是这里
			
			--太真的
			
			if v.prefab == "zhanli" and self.inst:GetDistanceSqToInst(v) <= 6.25 and v.components.prototyper ~= nil and (v.components.prototyper.restrictedtag == nil or self.inst:HasTag(v.components.prototyper.restrictedtag)) then
				
				if not prototyper_active then
					v.components.prototyper:TurnOn(self.inst)
					self.accessible_tech_trees = v.components.prototyper:GetTechTrees()
                
					if v.components.craftingstation ~= nil then
						local recs = v.components.craftingstation:GetRecipes(self.inst)
						for _, recname in ipairs(recs) do
							local recipe = GetValidRecipe(recname)
							if recipe ~= nil and recipe.nounlock then
								--only nounlock recipes can be unlocked via crafting station
								self.station_recipes[recname] = true
							end
						end
					end                    

					prototyper_active = true
					self.current_prototyper = v
				else
                --you've already activated a machine. Turn all the other machines off.
					v.components.prototyper:TurnOff(self.inst)
				end			
			
			--别的物品的
			elseif v.prefab~= "zhanli" and v.components.prototyper ~= nil and (v.components.prototyper.restrictedtag == nil or self.inst:HasTag(v.components.prototyper.restrictedtag)) then
				 if not prototyper_active then
                --activate the first machine in the list. This will be the one you're closest to.
                v.components.prototyper:TurnOn(self.inst)
                self.accessible_tech_trees = v.components.prototyper:GetTechTrees()
                
                if v.components.craftingstation ~= nil then
                    local recs = v.components.craftingstation:GetRecipes(self.inst)
                    for _, recname in ipairs(recs) do
						local recipe = GetValidRecipe(recname)
                        if recipe ~= nil and recipe.nounlock then
                            --only nounlock recipes can be unlocked via crafting station
                            self.station_recipes[recname] = true
						end
                    end
				end                    

                prototyper_active = true
                self.current_prototyper = v
            else
                --you've already activated a machine. Turn all the other machines off.
                v.components.prototyper:TurnOff(self.inst)
            end
        end
    end

    --V2C: Hacking giftreceiver logic in here so we do
    --     not have to duplicate the same search logic
    if self.inst.components.giftreceiver ~= nil then
        self.inst.components.giftreceiver:SetGiftMachine(
            self.current_prototyper ~= nil and
            self.current_prototyper:HasTag("giftmachine") and
            CanEntitySeeTarget(self.inst, self.current_prototyper) and
            self.inst.components.inventory.isopen and --ignores .isvisible, as long as it's .isopen
            self.current_prototyper or
            nil)
    end

    --add any character specific bonuses to your current tech levels.
    if not prototyper_active then
        for i, v in ipairs(TechTree.AVAILABLE_TECH) do
            self.accessible_tech_trees[v] = self[string.lower(v).."_bonus"] or 0
        end
    else
		for i, v in ipairs(TechTree.BONUS_TECH) do
			self.accessible_tech_trees[v] = self.accessible_tech_trees[v] + (self[string.lower(v).."_bonus"] or 0)
		end
	end

    if old_prototyper ~= nil and
        old_prototyper ~= self.current_prototyper and
        old_prototyper.components.prototyper ~= nil and
        old_prototyper.entity:IsValid() then
        old_prototyper.components.prototyper:TurnOff(self.inst)
    end

    local trees_changed = false

    for recname, _ in pairs(self.station_recipes) do
        if old_station_recipes[recname] then
            old_station_recipes[recname] = nil
        else
            self.inst.replica.builder:AddRecipe(recname)
            trees_changed = true
        end
    end

    if next(old_station_recipes) ~= nil then
        for recname, _ in pairs(old_station_recipes) do
            self.inst.replica.builder:RemoveRecipe(recname)
        end
		trees_changed = true
    end

    if not trees_changed then
        for k, v in pairs(old_accessible_tech_trees) do
            if v ~= self.accessible_tech_trees[k] then 
                trees_changed = true
                break
            end
        end
        if not trees_changed then
            for k, v in pairs(self.accessible_tech_trees) do
                if v ~= old_accessible_tech_trees[k] then 
                    trees_changed = true
                    break
                end
            end
        end
    end

    if trees_changed then
        self.inst:PushEvent("techtreechange", { level = self.accessible_tech_trees })
        self.inst.replica.builder:SetTechTrees(self.accessible_tech_trees)
    end
	end
end
--AddComponentPostInit("builder", aaa)
    
AddPrefabPostInit('turf_tz_dragonfloor',function(inst) 
	if TheWorld.ismastersim then
		inst.components.inventoryitem.atlasname="images/inventoryimages/turf_tz_dragonfloor.xml"
		inst.components.inventoryitem.imagename="turf_tz_dragonfloor"
	end 
end)
    
--鼠标皮肤
if GetModConfigData("mouse") then
    local function TZIsHUDScreen()
        local defaultscreen = false
        if TheFrontEnd:GetActiveScreen() and TheFrontEnd:GetActiveScreen().name and type(TheFrontEnd:GetActiveScreen().name) == "string" and TheFrontEnd:GetActiveScreen().name == "HUD" then
            defaultscreen = true
        end
        return defaultscreen
    end
    local tz_mouse = require("widgets/tz_mouse")    
	local function Addtz_mouse(self)    
		if self.owner:HasTag("taizhen") then          
			self.tz_mouse = self:AddChild(tz_mouse(self.owner))     
            self.tz_mouse.TZIsHUDScreen = TZIsHUDScreen
		end  
	end 
	AddClassPostConstruct("widgets/controls", Addtz_mouse) 
    AddSimPostInit(function()
            TheWorld:DoPeriodicTask(0.2,function()
                if ThePlayer and ThePlayer:HasTag("taizhen") and TZIsHUDScreen() then
                    TheInputProxy:SetCursorVisible(false)
                else
                    TheInputProxy:SetCursorVisible(true)
                end
            end)
        end)
end
--[[本就注释的功能，具体效果暂未研究
local OnDeath = function(inst, data)
	local fh = data.afflicter.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	if fh.prefab == 'tz_spiritualism' then
		inst.components.lootdropper:SetLoot(nil)
		inst.components.lootdropper:SetChanceLootTable(nil)
	end
end
local OnAttacked = function(inst, data)
	if data.attacker and data.attacker.components and data.attacker.components.inventory and data.attacker.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
		local weapon = data.attacker.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		if weapon.prefab == 'tz_spiritualism' then
			inst.components.health:SetVal(0, '', data.attacker)
		end
	end
end

AddPrefabPostInitAny(function(inst)
	if inst:HasTag('nightmarecreature') or inst:HasTag('shadowcreature') then
		inst:ListenForEvent("death", OnDeath)
		inst:ListenForEvent("attacked", OnAttacked)
	end
end)

AddPrefabPostInit('crawling')
--]]

--风铃风铃风铃铃铃铃铃铃铃
--开始风铃
local function sorabaseenable(self)
	if self.name == "LoadoutSelect" then
		if not table.contains(GLOBAL.DST_CHARACTERLIST,"taizhen") then
			table.insert(GLOBAL.DST_CHARACTERLIST,"taizhen")
		end
	elseif	self.name == "LoadoutRoot" then
		if table.contains(GLOBAL.DST_CHARACTERLIST,"taizhen") then
			GLOBAL.RemoveByValue(GLOBAL.DST_CHARACTERLIST,"taizhen")
		end
	end
end
AddClassPostConstruct("widgets/widget", sorabaseenable)

local oldTheInventoryCheckOwnership = TheInventory.CheckOwnership
local mt = getmetatable(TheInventory)
mt.__index.CheckOwnership  = function(i,name,...) 
	if name and type(name)=="string"  and name:find("taizhen")  then
		return true 
	else
		return oldTheInventoryCheckOwnership(i,name,...)
	end
end
local oldTheInventoryCheckClientOwnership = TheInventory.CheckClientOwnership
mt.__index.CheckClientOwnership  = function(i,userid,name,...) 
	print(i,userid,name,...)
	if name and type(name)=="string"  and name:find("taizhen")  then
		return true 
	else
		return oldTheInventoryCheckClientOwnership(i,userid,name,...)
	end
end	
local oldExceptionArrays = GLOBAL.ExceptionArrays
GLOBAL.ExceptionArrays = function(ta,tb,...)
	local need
	for i=1,100,1 do
		local data = debug.getinfo(i,"S")
		if data then
			if data.source and data.source:match("^scripts/networking.lua") then
				need = true
			end
		else
			break
		end
	end
	if need then
		local newt = oldExceptionArrays(ta,tb,...)
		table.insert(newt,"taizhen")
		return newt
	else
		return oldExceptionArrays(ta,tb,...)
	end
end	

GLOBAL.PREFAB_SKINS["taizhen"] = {
	"taizhen_none",
	"taizhen_pink_none",
	"taizhen_boying_none",
}
--结束风铃

local oldBaseSort = {
	CompareItemDataForSortByName = 1,
	CompareItemDataForSortByRarity = 1,
	CompareItemDataForSortByRelease = 1,
	CompareItemDataForSortByCount = 1,
}
local BaseSort = {}

for k,v in pairs(oldBaseSort) do
	local thisfunc = GLOBAL[k]
	GLOBAL[k] = function (item_a,item_b,...)
		if next(BaseSort) == nil then
			for i,name in ipairs(PREFAB_SKINS["taizhen"]) do
				BaseSort[name] = i
			end
		end
		if item_a and item_b and BaseSort[item_a] and BaseSort[item_b] then
			return BaseSort[item_a] < BaseSort[item_b]
		end
		return thisfunc(item_a,item_b,...)
	end
end

local PlayerAvatarPopup = require("widgets/playeravatarpopup")
local Old_UpdateData = PlayerAvatarPopup.UpdateData
function PlayerAvatarPopup:UpdateData(data)
	Old_UpdateData(self,data)
	if data and data.base_skin ~= nil then
		--[[if  data.base_skin == "taizhen_pink_none" then
			if self.owner._bianshen ~= nil and self.owner._bianshen:value() == true then
				return
			end
			if self.base_image ~= nil then
				if self.base_image._text ~= nil  then
					self.base_image._text:SetString("三周年贺岁")
					self.base_image._text:SetColour(255/255, 255/255, 0/255, 1)
				end
				if self.base_image._image ~= nil  then
					self.base_image._image:GetAnimState():OverrideSkinSymbol("SWAP_ICON", "tz_pink_icon", "SWAP_ICON")
				end
			end
		elseif  data.base_skin == "taizhen_boying_none" then
			if self.owner._bianshen ~= nil and self.owner._bianshen:value() == true then
					return
			end
			if self.base_image ~= nil then
				--if self.base_image._text ~= nil  then
				--	self.base_image._text:SetString("薄樱")
					--self.base_image._text:SetColour(255/255, 255/255, 0/255, 1)
				--end
				--if self.base_image._image ~= nil  then
				--	self.base_image._image:GetAnimState():OverrideSkinSymbol("SWAP_ICON", "taizhen_boying", "SWAP_ICON")
				--end
			end]]
		if 	data.base_skin == "taizhen_none" then
			if self.base_image._image ~= nil  then
				self.base_image._image:GetAnimState():OverrideSkinSymbol("SWAP_ICON", "tz_icon", "SWAP_ICON")
			end			
		end
	end
end
local EquipSlot = require("equipslotutil")
local Old_UpdateEquipWidgetForSlot = PlayerAvatarPopup.UpdateEquipWidgetForSlot
function PlayerAvatarPopup:UpdateEquipWidgetForSlot(image_group, slot, equipdata)
	if self.owner.prefab == "taizhen" and  image_group._text ~= nil then
		image_group._text.shrink_in_progress = true
	end
	Old_UpdateEquipWidgetForSlot(self,image_group, slot, equipdata)
	local name = equipdata ~= nil and equipdata[EquipSlot.ToID(slot)] or nil
	name = name ~= nil and #name > 0 and name or "none"
	if name == "tz_yezhao_pink" then
		image_group._text:SetColour(255/255, 255/255, 0/255, 1)
	end
end

local Old_UpdateSkinWidgetForSlot = PlayerAvatarPopup.UpdateSkinWidgetForSlot
function PlayerAvatarPopup:UpdateSkinWidgetForSlot(image_group, slot, skin_name,...)
	if self.owner.prefab == "taizhen" and  image_group._text ~= nil then
		image_group._text.shrink_in_progress = true
	end
	Old_UpdateSkinWidgetForSlot(self,image_group, slot, skin_name,...)
end

--机神抛射物特效修复
AddPrefabPostInit("explosivehit", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	inst:DoTaskInTime(1, inst.Remove)
end)

--人物三维相关
TUNING.TAIZHEN_HEALTH = 75
TUNING.TAIZHEN_HUNGER  = 150
TUNING.TAIZHEN_SANITY = 200

TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.TAIZHEN = {"tz_spiritualism","tz_evil_teacher","nightmarefuel"}

STRINGS.CHARACTER_SURVIVABILITY.taizhen = "让太真和主人一起冒险吧！（\\\>w<\\\)" --生存几率自己写
local taizhen_startitem = {
	tz_spiritualism = {
		atlas = "images/inventoryimages/tz_spiritualism.xml",
		image = "tz_spiritualism.tex",
	},
	tz_evil_teacher = {
		atlas = "images/inventoryimages/tz_evil_teacher.xml",
		image = "tz_evil_teacher.tex",
	},	
}
for k,v in pairs(taizhen_startitem) do
	TUNING.STARTING_ITEM_IMAGE_OVERRIDE[k] = v
end


-- 暗影锅相关动作
AddStategraphPostInit("wilson", function(sg)
    local old_BUILD = sg.actionhandlers[ACTIONS.BUILD].deststate
    sg.actionhandlers[ACTIONS.BUILD].deststate = function(inst, action,...)
    	if action.recipe == "tz_dark_cookpot" then 
    		return "tz_dark_cookpot_building"
    	else
    		return old_BUILD(inst, action,...)
    	end 
	end
end)

AddStategraphPostInit("wilson_client", function(sg)
    local old_BUILD = sg.actionhandlers[ACTIONS.BUILD].deststate
    sg.actionhandlers[ACTIONS.BUILD].deststate = function(inst, action,...)
    	if action.recipe == "tz_dark_cookpot" then 
    		return "tz_dark_cookpot_building"
    	else
    		return old_BUILD(inst, action,...)
    	end 
	end
end)

AddStategraphState("wilson",
	State{
        name = "tz_dark_cookpot_building",
        tags = { "doing", "busy", "nodangle" },

        onenter = function(inst, timeout)
        	timeout = timeout or 2
            inst.sg:SetTimeout(timeout)
            inst.components.locomotor:Stop()
            inst.SoundEmitter:PlaySound("dontstarve/wilson/use_gemstaff", "make",nil,true)
            inst.AnimState:PlayAnimation("channel_pre")
            inst.AnimState:PushAnimation("channel_loop", true)
            if inst.bufferedaction ~= nil then
                inst.sg.statemem.action = inst.bufferedaction
            end
        end,

        timeline =
        {
            TimeEvent(4 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
            end),
        },

        ontimeout = function(inst)
            inst.SoundEmitter:KillSound("make")
            inst.SoundEmitter:PlaySound("dontstarve/common/rebirth_amulet_poof")
            inst:PerformBufferedAction()
            inst.AnimState:PlayAnimation("channel_pst")
            inst.sg:GoToState("idle", true)
        end,

        -- events =
        -- {
        --     EventHandler("animqueueover", function(inst)
        --         if inst.AnimState:AnimDone() then
        --             inst.sg:GoToState("idle")
        --         end
        --     end),
        -- },

        onexit = function(inst)
            inst.SoundEmitter:KillSound("make")
            if inst.bufferedaction == inst.sg.statemem.action then
                inst:ClearBufferedAction()
            end
        end,
    }
)

AddStategraphState("wilson_client",
	State{
        name = "tz_dark_cookpot_building",
        tags = { "doing", "busy" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.SoundEmitter:PlaySound("dontstarve/wilson/use_gemstaff", "make_preview",nil,true)
            inst.AnimState:PlayAnimation("channel_pre")
            inst.AnimState:PushAnimation("channel_loop", true)

            inst:PerformPreviewBufferedAction()
            inst.sg:SetTimeout(2)
        end,

        timeline =
        {
            TimeEvent(4 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
            end),
        },

        onupdate = function(inst)
            if inst:HasTag("doing") then
                if inst.entity:FlattenMovementPrediction() then
                    inst.sg:GoToState("idle", "noanim")
                end
            elseif inst.bufferedaction == nil then
                inst.AnimState:PlayAnimation("channel_pst")
            	inst.sg:GoToState("idle", true)
            end
        end,

        ontimeout = function(inst)
            inst:ClearBufferedAction()
            inst.AnimState:PlayAnimation("channel_pst")
            inst.sg:GoToState("idle", true)
        end,

        onexit = function(inst)
            inst.SoundEmitter:KillSound("make_preview")
        end,
    }
)

local DESTROY = Action()
DESTROY.id = "DESTROY"
DESTROY.distance = 4
DESTROY.str = STRINGS.ACTIONS.STOPCHANNELING
DESTROY.priority = 10
DESTROY.fn = function(act) -- 动作触发的函数。传入的是一个BufferedAction对象。可以通过它直接调用动作的执行者，目标，具体的动作内容等等，详情请查看bufferedaction.lua文件，也可以参考actions.lua里各个action的fn。
	local item = act.target
	if item and item:IsValid() and item.components.destroyable then 
		item.components.destroyable:Destroy()
		return true 
	end
	return false
end
--注册动作
AddAction(DESTROY) -- 将上面编写的内容传入MOD API,添加动作。
AddComponentAction("SCENE", "destroyable", function(inst, doer, actions, right) -- 设置动作的检测函数，如果满足条件，就向人物的动作可执行表中加入某个动作。right表示是否是右键动作。
	if doer:HasTag("player") and inst:HasTag("destroyable") and right then
		table.insert(actions, ACTIONS.DESTROY)
	end
end)
AddStategraphActionHandler("wilson",ActionHandler(ACTIONS.DESTROY, "tz_dark_cookpot_building"))
AddStategraphActionHandler("wilson_client",ActionHandler(ACTIONS.DESTROY,"tz_dark_cookpot_building"))

AddStategraphPostInit("wilson", function(sg)
	local old_attacked = sg.events["attacked"].fn 
	sg.events["attacked"].fn = function(inst,data)
		if not inst.components.health:IsDead() then
			if inst.components.inventory:EquipHasTag("tz_no_attacked_sg") then
				return 
			end

		end

		return old_attacked(inst,data)
	end 
end)

AddPlayerPostInit(function(inst)
	if not TheWorld.ismastersim then 
		return inst
	end 
	inst:AddComponent("resurrect_ticker")
end)

local isstr = function(vla) return type(vla) == "string" end
local function hh(inst,recipe)
	-- if isstr(recipe) then
	-- 	if  not inst.components.builder:KnowsRecipe(recipe) then
	-- 		inst.components.builder:UnlockRecipe(recipe)
	-- 	else
	-- 		inst.components.talker:Say("太真建议你多喝热水！")
	-- 	end
	-- end

	if inst.components.talker then
		inst.components.talker:Say("密码解锁番号的代码已经废弃了，太真建议你多喝阿平！")
	end
end

AddModRPCHandler("tz_xiuxian!!!", "benaping", hh)

--/这里是猫猫
AddUserCommand("这里是猫猫", {
    aliases =nil,
    prettyname = nil,
    desc = nil,
    permission = COMMAND_PERMISSION.USER,
    confirm = false,
    slash = true,
    usermenu = false,
    servermenu = false,
    params = {},
    vote = false,
    localfn = function(params, caller)
		SendModRPCToServer( MOD_RPC["tz_xiuxian!!!"]["benaping"],"tz_fhspts")
    end,
})

AddUserCommand("5119000", {
    aliases =nil,
    prettyname = nil,
    desc = nil,
    permission = COMMAND_PERMISSION.USER,
    confirm = false,
    slash = true,
    usermenu = false,
    servermenu = false,
    params = {},
    vote = false,
    localfn = function(params, caller)
		SendModRPCToServer( MOD_RPC["tz_xiuxian!!!"]["benaping"],"tz_fhzlz")
    end,
})

AddUserCommand("243694", {
    aliases =nil,
    prettyname = nil,
    desc = nil,
    permission = COMMAND_PERMISSION.USER,
    confirm = false,
    slash = true,
    usermenu = false,
    servermenu = false,
    params = {},
    vote = false,
    localfn = function(params, caller)
		SendModRPCToServer( MOD_RPC["tz_xiuxian!!!"]["benaping"],"tz_fhzc")
    end,
})

AddUserCommand("421222", {
    aliases =nil,
    prettyname = nil,
    desc = nil,
    permission = COMMAND_PERMISSION.USER,
    confirm = false,
    slash = true,
    usermenu = false,
    servermenu = false,
    params = {},
    vote = false,
    localfn = function(params, caller)
		SendModRPCToServer( MOD_RPC["tz_xiuxian!!!"]["benaping"],"tz_fhft")
    end,
})

AddUserCommand("4628335似似花", {
    aliases =nil,
    prettyname = nil,
    desc = nil,
    permission = COMMAND_PERMISSION.USER,
    confirm = false,
    slash = true,
    usermenu = false,
    servermenu = false,
    params = {},
    vote = false,
    localfn = function(params, caller)
		SendModRPCToServer( MOD_RPC["tz_xiuxian!!!"]["benaping"],"tz_fhbm")
    end,
})

AddUserCommand("xuangezaici", {
    aliases =nil,
    prettyname = nil,
    desc = nil,
    permission = COMMAND_PERMISSION.USER,
    confirm = false,
    slash = true,
    usermenu = false,
    servermenu = false,
    params = {},
    vote = false,
    localfn = function(params, caller)
		SendModRPCToServer( MOD_RPC["tz_xiuxian!!!"]["benaping"],"tz_fhgx")
    end,
})

AddUserCommand("鱼妞", {
    aliases =nil,
    prettyname = nil,
    desc = nil,
    permission = COMMAND_PERMISSION.USER,
    confirm = false,
    slash = true,
    usermenu = false,
    servermenu = false,
    params = {},
    vote = false,
    localfn = function(params, caller)
		SendModRPCToServer( MOD_RPC["tz_xiuxian!!!"]["benaping"],"tz_fh_fishgirl")
    end,
})

AddUserCommand("cc224534", {
    aliases =nil,
    prettyname = nil,
    desc = nil,
    permission = COMMAND_PERMISSION.USER,
    confirm = false,
    slash = true,
    usermenu = false,
    servermenu = false,
    params = {},
    vote = false,
    localfn = function(params, caller)
		SendModRPCToServer( MOD_RPC["tz_xiuxian!!!"]["benaping"],"tz_fhdx")
    end,
})

AddUserCommand("想吃泡芙", {
    aliases =nil,
    prettyname = nil,
    desc = nil,
    permission = COMMAND_PERMISSION.USER,
    confirm = false,
    slash = true,
    usermenu = false,
    servermenu = false,
    params = {},
    vote = false,
    localfn = function(params, caller)
		SendModRPCToServer( MOD_RPC["tz_xiuxian!!!"]["benaping"],"tz_fhym")
    end,
})



-----------------------------------------------------------------------------------
modimport("scripts/tz_xin/tz_xin.lua")
-----------------------------------------------------------------------------------
GLOBAL.TZUP = require("util/tz_upvaluehelper")      --upvaluehook
-----------------------------------------------------------------------------------

-----------------------------------------yyxk------------------------------------------
local function MooseRightMindControl(inst, target, pos)
    return target ~= inst and target ~= nil and inst.components.playeractionpicker:SortActionList({ ACTIONS.LOOKAT }, target, nil) or nil
end
local function DisableActions(inst, b)--把动作都变成检查
	if b then
		if inst.components.playeractionpicker ~= nil then
			inst.components.playeractionpicker.leftclickoverride = MooseRightMindControl
			inst.components.playeractionpicker.rightclickoverride = MooseRightMindControl
		end
	else
		if inst.components.playeractionpicker ~= nil then
			inst.components.playeractionpicker.leftclickoverride = nil
			inst.components.playeractionpicker.rightclickoverride = nil
		end
	end
end

local function ToggleLagCompensation(b)
	if b ~= Profile:GetMovementPredictionEnabled() then
		ThePlayer:EnableMovementPrediction(b)
		Profile:SetMovementPredictionEnabled(b)
	end
end

local function SetCamera(zoomstep, mindist, maxdist, mindistpitch, maxdistpitch, distance, distancetarget)
	local camera = TheCamera
	if camera ~= nil then
		camera.zoomstep = zoomstep or camera.zoomstep --镜头移动速度
		camera.mindist = mindist or camera.mindist --镜头最小距离
		camera.maxdist = maxdist or camera.maxdist --最大距离
		camera.mindistpitch = mindistpitch or camera.mindistpitch 
		camera.maxdistpitch = maxdistpitch or camera.maxdistpitch --感觉是旋转角度，自己试试区别的，我不知道怎么描述
		-- camera.distance = distance or camera.distance
		camera.distancetarget = distancetarget or camera.distancetarget
	end
end

local function tran(inst,maxdist)
	local camera = TheCamera
	if camera ~= nil then
		camera.maxdist = maxdist
		if maxdist > 50 then
			inst:DoTaskInTime(0.1, function()
				tran(inst,maxdist - 4)
			end)
		else
			if TheWorld:HasTag("cave") then
				SetCamera(4, 15, 35, 25, 40, 25, 25)
			else
				SetCamera(4, 15, 50, 30, 60, 30, 30)
			end
		end
		-- TheCamera.maxdist = 50;TheCamera.maxdistpitch = 60
		-- TheCamera.maxdist = 80;TheCamera.maxdistpitch = 85
	end
end

local function SetDefaultView() --默认视野
	if TheWorld ~= nil then
		if TheWorld:HasTag("cave") then
			SetCamera(10, 15, 80, 25, 85.7, 25, 25)
		else
			SetCamera(10, 15, 80, 30, 85.7, 30, 30)
		end
		-- tran(ThePlayer,180)
		ThePlayer:DoTaskInTime(3, function()
			if TheWorld:HasTag("cave") then
				SetCamera(4, 15, 35, 25, 40, 25, 25)
			else
				SetCamera(4, 15, 50, 30, 60, 30, 30)
			end
		end)
	end
end
local function SetAerialView() --高空视野
	if TheWorld ~= nil then
		if TheWorld:HasTag("cave") then
			SetCamera(10, 15, 80, 25, 85.7, 60, 60)
		else
			SetCamera(10, 15, 80, 30, 85.7, 60, 60)
		end
	end
end

AddClientModRPCHandler("tz", "disableactions", function(b)
	if ThePlayer ~= nil then
		ToggleLagCompensation(not b)--延迟补偿
		DisableActions(ThePlayer, b)
	end
end)
AddClientModRPCHandler("tz", "camera", function(b)
	if ThePlayer ~= nil then
		if b then
			SetAerialView() --高空视野
			TheCamera.fov = 35
		else
			SetDefaultView() --默认视野
			TheCamera.fov = 35
		end
	end
end)
-----------------------------------------------------------------------------------
