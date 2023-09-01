GLOBAL.setmetatable(env, {__index = function(t, k)return GLOBAL.rawget(GLOBAL, k)end})

PrefabFiles = {
	"veneto",  
	"veneto_none",  
	"veneto_jz",
	"veneto_yifu",
	"veneto_jzyf",
	"veneto_maozi",
	"veneto_dapao",
	"veneto_xiaopao",
	"veneto_paodan",
	"veneto_paodanfz",
	"kafeibush",
    "dug_kafeibush",
    "kafei",
    "kafei_cooked",
    "yishinongsuo",
    "kangbaolan",
    "kanongluo",
    "maqiyaduo",
    "shuangbeiyishi",
    "yidalimian",
    "speedbuff",
}

TUNING.AOE = GetModConfigData("aoe")

Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/veneto.tex" ), 
    Asset( "ATLAS", "images/saveslot_portraits/veneto.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/veneto.tex" ), 
    Asset( "ATLAS", "images/selectscreen_portraits/veneto.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/veneto_silho.tex" ), 
    Asset( "ATLAS", "images/selectscreen_portraits/veneto_silho.xml" ),

    Asset( "IMAGE", "bigportraits/veneto.tex" ), 
    Asset( "ATLAS", "bigportraits/veneto.xml" ),
	
	Asset( "IMAGE", "images/map_icons/veneto.tex" ), 
	Asset( "ATLAS", "images/map_icons/veneto.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_veneto.tex" ), 
    Asset( "ATLAS", "images/avatars/avatar_veneto.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_veneto.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_veneto.xml" ),
	
	Asset( "IMAGE", "images/avatars/self_inspect_veneto.tex" ), 
    Asset( "ATLAS", "images/avatars/self_inspect_veneto.xml" ),
	
	Asset( "IMAGE", "images/names_veneto.tex" ),  
    Asset( "ATLAS", "images/names_veneto.xml" ),
	
    Asset( "IMAGE", "bigportraits/veneto_none.tex" ),  
    Asset( "ATLAS", "bigportraits/veneto_none.xml" ),

}

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
local RECIPETABS = GLOBAL.RECIPETABS
local Recipe = GLOBAL.Recipe
local Ingredient = GLOBAL.Ingredient
local TECH = GLOBAL.TECH
local TheWorld = GLOBAL.TheWorld
local ACTIONS = GLOBAL.ACTIONS
local FUELTYPE = GLOBAL.FUELTYPE
local SpawnPrefab = GLOBAL.SpawnPrefab
local I = Ingredient

GLOBAL.PREFAB_SKINS["veneto"] = {   
	"veneto_none",
}

STRINGS.CHARACTER_TITLES.veneto = "维内托"
STRINGS.CHARACTER_NAMES.veneto = "维托里奥·维内托"
STRINGS.CHARACTER_DESCRIPTIONS.veneto = "*喜欢喝咖啡，有独特的料理技巧\n*自尊心强，喜欢打扮自己\n*对敌人绝不心慈手软"
STRINGS.CHARACTER_QUOTES.veneto = "\"buongiorno signor ammiraglio\""

STRINGS.CHARACTERS.VENETO = require "speech_veneto"

STRINGS.NAMES.VENETO = "人物名字"
STRINGS.SKIN_NAMES.veneto_none = "人物皮肤名字"  

AddRecipe("veneto_jz", {Ingredient("gears", 6),Ingredient("transistor", 6),Ingredient("thulecite", 6)}, RECIPETABS.WAR, TECH.ANCIENT_FOUR, nil, nil, nil, nil, "VV", "images/inventoryimages/veneto_jz.xml", "veneto_jz.tex" )

AddRecipe("veneto_yifu", {Ingredient("silk", 4),Ingredient("cutreeds", 2),Ingredient("petals", 4)}, RECIPETABS.DRESS, TECH.SCIENCE_ONE, nil, nil, nil, nil, "VV", "images/inventoryimages/veneto_yifu.xml", "veneto_yifu.tex" )

AddRecipe("veneto_maozi", {Ingredient("silk", 2),Ingredient("cutreeds", 1),Ingredient("pigskin", 1)}, RECIPETABS.DRESS, TECH.SCIENCE_ONE, nil, nil, nil, nil, "VV", "images/inventoryimages/veneto_maozi.xml", "veneto_maozi.tex" )

AddRecipe("veneto_jzyf", {Ingredient("veneto_jz", 1, "images/inventoryimages/veneto_jz.xml"),Ingredient("veneto_yifu", 1, "images/inventoryimages/veneto_yifu.xml")}, RECIPETABS.DRESS, nil, nil, nil, nil, nil, "VV", "images/inventoryimages/veneto_jzyf.xml", "veneto_jzyf.tex" )

AddRecipe("veneto_dapao", {Ingredient("rope", 2),Ingredient("twigs", 3),Ingredient("papyrus", 2)}, RECIPETABS.WAR, TECH.SCIENCE_TWO, nil, nil, nil, nil, "VV", "images/inventoryimages/veneto_dapao.xml", "veneto_dapao.tex" )

AddRecipe("veneto_xiaopao", {Ingredient("rope", 1),Ingredient("twigs", 2),Ingredient("papyrus", 1)}, RECIPETABS.WAR, TECH.SCIENCE_ONE, nil, nil, nil, nil, "VV", "images/inventoryimages/veneto_xiaopao.xml", "veneto_xiaopao.tex" )

AddRecipe("veneto_paodan", {Ingredient("goldnugget", 10),Ingredient("gunpowder", 3),Ingredient("redgem", 1)}, RECIPETABS.WAR, TECH.SCIENCE_TWO, nil, nil, nil, 3, "VV", "images/inventoryimages/veneto_paodan.xml", "veneto_paodan.tex" )

STRINGS.NAMES.VENETO_JZ = "维内托的舰装"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.VENETO_JZ = "维内托小姐的舰装"
STRINGS.CHARACTERS.VENETO.DESCRIBE.VENETO_JZ = "意式设计理念领先时代！...虽然不是港区原装的"
STRINGS.RECIPE_VENETO_JZ = "维内托的舰装"
STRINGS.RECIPE_DESC.VENETO_JZ = "战列舰应该有的阵势"

STRINGS.NAMES.VENETO_YIFU = "小时候的衣服"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.VENETO_YIFU = "非常...适合威严满满的维内托小姐"
STRINGS.CHARACTERS.VENETO.DESCRIBE.VENETO_YIFU = "意外的...非常合身......"
STRINGS.RECIPE_VENETO_YIFU = "小时候的衣服"
STRINGS.RECIPE_DESC.VENETO_YIFU = "小时候最喜欢的衣服"

STRINGS.NAMES.VENETO_MAOZI = "小时候的帽子"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.VENETO_MAOZI = "看上去威严满满"
STRINGS.CHARACTERS.VENETO.DESCRIBE.VENETO_MAOZI = "它看过去是如此的完美！"
STRINGS.RECIPE_VENETO_MAOZI = "小时候的帽子"
STRINGS.RECIPE_DESC.VENETO_MAOZI = "小时候最喜欢的帽子"

STRINGS.NAMES.VENETO_JZYF = "豪华意式舰装"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.VENETO_JZYF = "加了衣服以后更好看一点，不过为什么会毫无违和感？"
STRINGS.CHARACTERS.VENETO.DESCRIBE.VENETO_JZYF = "好看又实用，好看才有战斗力！"
STRINGS.RECIPE_VENETO_JZYF = "豪华意式舰装"
STRINGS.RECIPE_DESC.VENETO_JZYF = "搭配上了合身的衣服"

STRINGS.NAMES.VENETO_DAPAO = "381模型炮塔"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.VENETO_DAPAO = "被这玩意砸到会死人的！"
STRINGS.CHARACTERS.VENETO.DESCRIBE.VENETO_DAPAO = "真家伙过不来，只能整个模型凑合凑合"
STRINGS.RECIPE_VENETO_DAPAO = "381模型炮塔"
STRINGS.RECIPE_DESC.VENETO_DAPAO = "很多人脑子里的炮塔样貌"

STRINGS.NAMES.VENETO_XIAOPAO = "152模型炮塔"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.VENETO_XIAOPAO = "明明是纸糊的，为什么打人这么疼？"
STRINGS.CHARACTERS.VENETO.DESCRIBE.VENETO_XIAOPAO = "尺寸更小，更好做一点"
STRINGS.RECIPE_VENETO_XIAOPAO = "152模型炮塔"
STRINGS.RECIPE_DESC.VENETO_XIAOPAO = "纸糊的模型"

STRINGS.NAMES.VENETO_PAODAN = "381嗑药炮"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.VENETO_PAODAN = "正儿八经的意大利炮"
STRINGS.CHARACTERS.VENETO.DESCRIBE.VENETO_PAODAN = "就稍稍陪你们玩一会好了!"
STRINGS.RECIPE_VENETO_PAODAN = "381嗑药炮"
STRINGS.RECIPE_DESC.VENETO_PAODAN = "发射之前先来一杯咖啡"

STRINGS.NAMES.KAFEIBUSH = "咖啡树丛"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.KAFEIBUSH = "不一样的灌木丛，产出的果子苦苦的"
STRINGS.CHARACTERS.VENETO.DESCRIBE.KAFEIBUSH = "马上就能喝到咖啡了"
STRINGS.NAMES.DUG_KAFEIBUSH = "咖啡树丛"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DUG_KAFEIBUSH = "维内托小姐不知道从哪里带来的"
STRINGS.CHARACTERS.VENETO.DESCRIBE.DUG_KAFEIBUSH = "来种一片咖啡园吧"
STRINGS.RECIPE_DESC.DUG_KAFEIBUSH = "神奇的嫁接技术"

STRINGS.NAMES.KAFEI = "生咖啡豆"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.KAFEI = "又硬又苦……"
STRINGS.CHARACTERS.VENETO.DESCRIBE.KAFEI = "这个阶段的还不能吃，但是很漂亮!"

STRINGS.NAMES.KAFEI_COOKED = "熟咖啡豆"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.KAFEI_COOKED = "虽然有点苦，但是回味还不错"
STRINGS.CHARACTERS.VENETO.DESCRIBE.KAFEI_COOKED = "浓郁又芳香！如果能研磨成咖啡就更棒了！"

STRINGS.NAMES.YISHINONGSUO = "意式浓缩咖啡"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.YISHINONGSUO = "维内托小姐的最爱，不过有点苦"
STRINGS.CHARACTERS.VENETO.DESCRIBE.YISHINONGSUO = "浓稠的口感，适合早上享用"

STRINGS.NAMES.MAQIYADUO = "玛琪雅朵咖啡"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MAQIYADUO = "加了奶泡更好入口了"
STRINGS.CHARACTERS.VENETO.DESCRIBE.MAQIYADUO = "要是能听着优雅钢琴曲就更好了"

STRINGS.NAMES.KANGBAOLAN = "康宝蓝咖啡"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.KANGBAOLAN = "甜甜的，喝起来很舒服"
STRINGS.CHARACTERS.VENETO.DESCRIBE.KANGBAOLAN = "看起来赏心悦目，很有下午茶的气氛"

STRINGS.NAMES.SHUANGBEIYISHI = "双倍意式浓缩咖啡"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SHUANGBEIYISHI = "成年人才能享受的苦涩……好吧我受不了它！"
STRINGS.CHARACTERS.VENETO.DESCRIBE.SHUANGBEIYISHI = "带劲又毫不矫情，但不是所有人都能消受的"

STRINGS.NAMES.KANONGLUO = "卡侬洛"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.KANONGLUO = "酥脆的外皮里面包裹着奶油，很有新意"
STRINGS.CHARACTERS.VENETO.DESCRIBE.KANONGLUO = "西西里的特色甜点，味道十分的甜美"

STRINGS.NAMES.YIDALIMIAN = "番茄意大利面"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.YIDALIMIAN = "意大利人赖以生存的东西"
STRINGS.CHARACTERS.VENETO.DESCRIBE.YIDALIMIAN = "酸甜可口！要是能和长官一起享用就好了..."

AddMinimapAtlas("images/map_icons/veneto.xml")  

AddModCharacter("veneto", "FEMALE") 

AddRecipe(
    "dug_kafeibush",
    {Ingredient("kafei", 2, "images/kafei.xml"), Ingredient("twigs", 2), Ingredient("poop", 2)},
    RECIPETABS.FARM,
    TECH.SCIENCE_ONE,
    nil, nil, nil, nil, "vv",
    "images/dug_kafeibush.xml",
    "dug_kafeibush.tex"
)

AddIngredientValues({"kafei"}, {kafei = 1}, true)

local foods = {
    yishinongsuo = {
        test = function(cooker, names, tags)
            return (names.kafei_cooked and names.kafei_cooked >= 2) and (tags.fruit and tags.fruit >= 0.5) and not names.honey
        end,
        foodtype = FOODTYPE.GOODIES,
        hunger = 15,
        sanity = 15,
        health = 20,
        perishtime = TUNING.PERISH_MED,
        cooktime = 0.5,
    },
    yidalimian = {
        test = function(cooker, names, tags)
            return ((names.tomato and names.tomato >= 1) or (names.tomato_cooked and names.tomato_cooked >= 1))
                and ((names.fig and names.fig >= 1) or (names.fig_cooked and names.fig_cooked >= 1))
                and tags.meat >= 1 and tags.fruit >= 1
        end,
        foodtype = FOODTYPE.GOODIES,
        hunger = 100,
        sanity = 35,
        health = 70,
        perishtime = TUNING.PERISH_MED,
        cooktime = 0.5,
    },
    maqiyaduo = {
        test = function(cooker, names, tags)
            return (names.kafei_cooked and names.kafei_cooked >= 2) and (tags.fruit and tags.fruit >= 0.5) and (names.honey and names.honey >=1)
        end,
        foodtype = FOODTYPE.GOODIES,
        hunger = 20,
        sanity = 10,
        health = 20,
        perishtime = TUNING.PERISH_MED,
        cooktime = 0.5,
    },
    kangbaolan = {
        test = function(cooker, names, tags)
            return (names.kafei_cooked and names.kafei_cooked >= 2) and (names.honey and names.honey >=1) and (names.ice and names.ice >= 1)
        end,
        foodtype = FOODTYPE.GOODIES,
        hunger = 20,
        sanity = 20,
        health = 10,
        perishtime = TUNING.PERISH_MED,
        cooktime = 0.5,
    },
    kanongluo = {
        test = function(cooker, names, tags)
            return (tags.fruit and tags.fruit >= 0.5) and (names.honey and names.honey >=1) and (tags.veggie and tags.veggie >=2)
        end,
        foodtype = FOODTYPE.GOODIES,
        hunger = 40,
        sanity = 40,
        health = 40,
        perishtime = TUNING.PERISH_SLOW,
        cooktime = 0.5,
    },
    shuangbeiyishi = {
        test = function(cooker, names, tags)
            return (names.kafei_cooked and names.kafei_cooked >= 3) and (tags.fruit and tags.fruit >= 0.5)
        end,
        foodtype = FOODTYPE.GOODIES,
        hunger = 20,
        sanity = -10,
        health = 30,
        perishtime = TUNING.PERISH_SLOW,
        cooktime = 0.5,
        priority = 2,
    }
}

for k, v in pairs(foods) do
    v.name = k
    v.weight = 1
    v.priority = v.priority or 1
    v.floater = {"med", nil, 0.55}
    v.cookbook_category = "cookpot"
    v.potlevel = "high"
    v.cookbook_tex = k..".tex"
    v.cookbook_atlas = "images/"..k..".xml"

    AddCookerRecipe("cookpot", v)
    AddCookerRecipe("portablecookpot", v)
end

AddPrefabPostInit(function(inst)
    if not TheWorld.ismastersim then return inst end

    if not inst.components.timer then
        inst:AddComponent("timer")
    end

    inst:DoTaskInTime(0, function(inst)
        if inst.components.timer:TimerExists("yishinongsuo_timer") then
            inst.components.locomotor:SetExternalSpeedMultiplier(inst, "yishinongsuo", 1.15)
        end
        if inst.components.timer:TimerExists("kangbaolan_timer") then
            inst.components.locomotor:SetExternalSpeedMultiplier(inst, "kangbaolan", 1.1)
        end
        if inst.components.timer:TimerExists("maqiyaduo_timer") then
            inst.components.locomotor:SetExternalSpeedMultiplier(inst, "maqiyaduo", 1.1)
        end
        if inst.components.timer:TimerExists("shuangbeiyishi_timer") then
            inst.components.locomotor:SetExternalSpeedMultiplier(inst, "shuangbeiyishi", 1.25)
            if inst.components.combat ~= nil then
                inst.components.combat.externaldamagemultipliers:SetModifier("shuangbeiyishi", 1.2)
            end
        end
    end)

    inst:ListenForEvent("timerdone", function(inst, data)
        if data.name == "yishinongsuo_timer" then
            inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "yishinongsuo")
        end
        if data.name == "kangbaolan_timer" then
            inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "kangbaolan")
        end
        if data.name == "maqiyaduo_timer" then
            inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "maqiyaduo")
        end
        if data.name == "shuangbeiyishi_timer" then
            inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "shuangbeiyishi")
            if inst.components.combat ~= nil then
                inst.components.combat.externaldamagemultipliers:RemoveModifier(inst)
            end
        end
    end)
end)