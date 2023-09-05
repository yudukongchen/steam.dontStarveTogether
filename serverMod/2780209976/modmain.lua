GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})  --GLOBAL相关照抄

PrefabFiles = {
	-- 注册文件 注意这里是文件的名字 也就是scripts/prefabs/xx.lua 里面的xx
	"yifu", -- 衣服（也就是护甲）
	"yifubn", -- 衣服（也就是护甲）
	"yifufy", -- 衣服（也就是护甲）
    "yifugr", -- 衣服（也就是护甲）
    "yifubm", -- 衣服（也就是护甲）
}

Assets = {	
----这里一般加载小地图 或者别的动画文件 没有可以不用写,
}

--命名相关
--yifu  注意命名的时候必须是大写
STRINGS.NAMES.YIFU= "强化护甲"    --名字
STRINGS.RECIPE_DESC.YIFU = "让木甲更耐用，你会感觉很安全！"  --配方上面的描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.YIFU = "这可太抗揍了。"  --人物检查的描述

STRINGS.NAMES.YIFUBN= "强化护甲-保暖"    --名字
STRINGS.RECIPE_DESC.YIFUBN = "让木甲更耐用，你会感觉很安全！"  --配方上面的描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.YIFUBN = "既抗揍又保暖。"  --人物检查的描述

STRINGS.NAMES.YIFUFY= "强化护甲-防水"    --名字
STRINGS.RECIPE_DESC.YIFUFY = "让木甲更耐用，你会感觉很安全！"  --配方上面的描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.YIFUFY = "既抗揍又干燥。"  --人物检查的描述

STRINGS.NAMES.YIFUGR= "强化护甲-隔热"    --名字
STRINGS.RECIPE_DESC.YIFUGR = "让木甲更耐用，你会感觉很安全！"  --配方上面的描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.YIFUGR = "既抗揍又凉快。"  --人物检查的描述

STRINGS.NAMES.YIFUBM= "不灭铠甲"    --名字
STRINGS.RECIPE_DESC.YIFUBM = "可以自动恢复耐久的铠甲"  --配方上面的描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.YIFUBM = "自动修复，活的铠甲！？"  --人物检查的描述

--添加配方
--modimport("scripts/NewArmourrecipe")

--配方相关
--衣服的
--AddRecipe("yifu",  --添加物品的配方
--{Ingredient("armorwood", 1),Ingredient("goldnugget", 2)},  --材料
--RECIPETABS.WAR,  TECH.SCIENCE_TWO,  --制作栏和解锁的科技（这里是战斗栏，需要科学一本）
--nil, nil, nil, nil, nil,  --是否有placer  是否有放置的间隔  科技锁  制作的数量（改成2就可以一次做两个） 需要的标签（比如女武神的配方需要女武神的自有标签才可以看得到）
--"images/inventoryimages/yifu.xml",  --配方的贴图（跟物品栏使用同一个贴图）
--"yifu.tex")

--AddRecipe("yifubn",  --添加物品的配方
--{Ingredient("armorwood", 1),Ingredient("beefalowool", 4),Ingredient("silk", 4),Ingredient("goldnugget", 2)},  --材料
--RECIPETABS.WAR,  TECH.SCIENCE_TWO,  --制作栏和解锁的科技（这里是战斗栏，需要科学一本）
--nil, nil, nil, nil, nil,  --是否有placer  是否有放置的间隔  科技锁  制作的数量（改成2就可以一次做两个） 需要的标签（比如女武神的配方需要女武神的自有标签才可以看得到）
--"images/inventoryimages/yifubn.xml",  --配方的贴图（跟物品栏使用同一个贴图）
--"yifubn.tex")

--AddRecipe("yifufy",  --添加物品的配方
--{Ingredient("armorwood", 1),Ingredient("tentaclespots", 1),Ingredient("pigskin", 1),Ingredient("goldnugget", 2)},  --材料
--RECIPETABS.WAR,  TECH.SCIENCE_TWO,  --制作栏和解锁的科技（这里是战斗栏，需要科学一本）
--nil, nil, nil, nil, nil,  --是否有placer  是否有放置的间隔  科技锁  制作的数量（改成2就可以一次做两个） 需要的标签（比如女武神的配方需要女武神的自有标签才可以看得到）
--"images/inventoryimages/yifufy.xml",  --配方的贴图（跟物品栏使用同一个贴图）
--"yifufy.tex")

--AddRecipe("yifugr",  --添加物品的配方
--{Ingredient("armorwood", 1),Ingredient("feather_robin", 3),Ingredient("pigskin", 2),Ingredient("goldnugget", 2)},  --材料
--RECIPETABS.WAR,  TECH.SCIENCE_TWO,  --制作栏和解锁的科技（这里是战斗栏，需要科学一本）
--nil, nil, nil, nil, nil,  --是否有placer  是否有放置的间隔  科技锁  制作的数量（改成2就可以一次做两个） 需要的标签（比如女武神的配方需要女武神的自有标签才可以看得到）
--"images/inventoryimages/yifugr.xml",  --配方的贴图（跟物品栏使用同一个贴图）
--"yifugr.tex")

--AddRecipe("yifubm",  --添加物品的配方
--{Ingredient("boneshard", 6),Ingredient("livinglog", 4),Ingredient("goldnugget", 2)},  --材料
--RECIPETABS.WAR,  TECH.MAGIC_TWO,  --制作栏和解锁的科技（这里是战斗栏，需要科学一本）
--nil, nil, nil, nil, nil,  --是否有placer  是否有放置的间隔  科技锁  制作的数量（改成2就可以一次做两个） 需要的标签（比如女武神的配方需要女武神的自有标签才可以看得到）
--"images/inventoryimages/yifubm.xml",  --配方的贴图（跟物品栏使用同一个贴图）
--"yifubm.tex")

AddRecipe2("yifu", 				
	{Ingredient("armorwood", 1),Ingredient("goldnugget", 2)},				
	GLOBAL.TECH.SCIENCE_TWO,				
	{atlas = "images/inventoryimages/yifu.xml"},				
	{"CHARACTER", "ARMOUR"})

AddRecipe2("yifubn", 				
	{Ingredient("armorwood", 1),Ingredient("beefalowool", 4),Ingredient("silk", 4),Ingredient("goldnugget", 2)},				
	GLOBAL.TECH.SCIENCE_TWO,				
	{atlas = "images/inventoryimages/yifubn.xml"},				
	{"CHARACTER", "ARMOUR"})

AddRecipe2("yifufy", 				
	{Ingredient("armorwood", 1),Ingredient("tentaclespots", 1),Ingredient("pigskin", 1),Ingredient("goldnugget", 2)},				
	GLOBAL.TECH.SCIENCE_TWO,				
	{atlas = "images/inventoryimages/yifufy.xml"},				
	{"CHARACTER", "ARMOUR"})

AddRecipe2("yifugr", 				
	{Ingredient("armorwood", 1),Ingredient("feather_robin", 3),Ingredient("pigskin", 2),Ingredient("goldnugget", 2)},				
	GLOBAL.TECH.SCIENCE_TWO,				
	{atlas = "images/inventoryimages/yifugr.xml"},				
	{"CHARACTER", "ARMOUR"})

AddRecipe2("yifubm", 				
	{Ingredient("boneshard", 6),Ingredient("livinglog", 4),Ingredient("goldnugget", 2)},				
	GLOBAL.TECH.MAGIC_TWO,				
	{atlas = "images/inventoryimages/yifubm.xml"},				
	{"CHARACTER", "ARMOUR"})
