PrefabFiles = {
	"change",  --人物代码文件
	"change_none",  --人物皮肤
	"flowers_change",
	"change_light",
	"change_tree",
	"change_ju_flower",
	
	"change_lotus",
	"change_lotus_flower",
	"change_lotus_pond",
	
	"change_lifeplant",
	"change_waterdrop",
	
	"change_food_cookpot",
	
	"change_jungletrees",
	"change_jungletreeseed",
	
	"change_palmtrees",
	"change_coconut",
	
	"change_light_circle",
	
	"change_science_buildings",
	"change_icecream_bat",
	"change_moonsword",
	"change_mace",
	
	"change_redlantern",
	"change_bunnyhouse",
	
	"ly_statue",
	"change_backpack",
	
	"change_fountain",
	"change_fishgang",
}
---对比老版本 主要是增加了names图片 人物检查图标 还有人物的手臂修复（增加了上臂）
--人物动画里面有个SWAP_ICON 里面的图片是在检查时候人物头像那里显示用的
Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/change.tex" ), --存档图片
    Asset( "ATLAS", "images/saveslot_portraits/change.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/change.tex" ), --单机选人界面
    Asset( "ATLAS", "images/selectscreen_portraits/change.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/change_silho.tex" ), --单机未解锁界面
    Asset( "ATLAS", "images/selectscreen_portraits/change_silho.xml" ),

    Asset( "IMAGE", "bigportraits/change.tex" ), --人物大图（方形的那个）
    Asset( "ATLAS", "bigportraits/change.xml" ),
	
	Asset( "IMAGE", "images/map_icons/change.tex" ), --小地图
	Asset( "ATLAS", "images/map_icons/change.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_change.tex" ), --tab键人物列表显示的头像
    Asset( "ATLAS", "images/avatars/avatar_change.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_change.tex" ),--tab键人物列表显示的头像（死亡）
    Asset( "ATLAS", "images/avatars/avatar_ghost_change.xml" ),
	
	Asset( "IMAGE", "images/avatars/self_inspect_change.tex" ), --人物检查按钮的图片
    Asset( "ATLAS", "images/avatars/self_inspect_change.xml" ),
	
	Asset( "IMAGE", "images/names_change.tex" ),  --人物名字
    Asset( "ATLAS", "images/names_change.xml" ),
	
	Asset( "IMAGE", "images/change_tab.tex" ), 
    Asset( "ATLAS", "images/change_tab.xml" ),
	
    Asset( "IMAGE", "bigportraits/change_none.tex" ),  --人物大图（椭圆的那个）
    Asset( "ATLAS", "bigportraits/change_none.xml" ),
	
	Asset( "IMAGE", "images/inventoryimages/flowers_change.tex" ),
	Asset( "ATLAS", "images/inventoryimages/flowers_change.xml" ),
	
	Asset( "IMAGE", "images/inventoryimages/change_light.tex" ),
	Asset( "ATLAS", "images/inventoryimages/change_light.xml" ),
	
	Asset( "IMAGE", "images/inventoryimages/change_tree.tex" ),
	Asset( "ATLAS", "images/inventoryimages/change_tree.xml" ),
	
	Asset( "IMAGE", "images/inventoryimages/change_ju_flower.tex" ),
	Asset( "ATLAS", "images/inventoryimages/change_ju_flower.xml" ),
	
	--Asset( "IMAGE", "images/inventoryimages/change_lotus_pond.tex" ),
	--Asset( "ATLAS", "images/inventoryimages/change_lotus_pond.xml" ),

--[[---注意事项
1、目前官方自从熔炉之后人物的界面显示用的都是那个椭圆的图
2、官方人物目前的图片跟名字是分开的 
3、names_change 和 change_none 这两个文件需要特别注意！！！
这两文件每一次重新转换之后！需要到对应的xml里面改对应的名字 否则游戏里面无法显示
具体为：
降names_esctemplatxml 里面的 Element name="change.tex" （也就是去掉names——）
将change_none.xml 里面的 Element name="change_none_oval" 也就是后面要加  _oval
（注意看修改的名字！不是两个都需要修改）
	]]
}

GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})


-- The character select screen lines  --人物选人界面的描述
STRINGS.CHARACTER_TITLES.change = "嫦娥"
STRINGS.CHARACTER_NAMES.change = "嫦娥"
STRINGS.CHARACTER_DESCRIPTIONS.change = "*Perk 1\n*Perk 2\n*Perk 3"
STRINGS.CHARACTER_QUOTES.change = "\"Quote\""

-- Custom speech strings  ----人物语言文件  可以进去自定义
STRINGS.CHARACTERS.CHANGE = require "speech_change"

-- The character's name as appears in-game  --人物在游戏里面的名字
STRINGS.NAMES.CHANGE = "嫦娥"

STRINGS.NAMES[string.upper("change_researchlab2")] = "科学雕像"
STRINGS.RECIPE_DESC[string.upper("change_researchlab2")] = "一看就很科学的雕像。"

STRINGS.NAMES[string.upper("change_researchlab3")] = "魔法雕像"
STRINGS.RECIPE_DESC[string.upper("change_researchlab3")] = "一看就很魔性的雕像。"

STRINGS.NAMES[string.upper("flowers_change")] = "杜鹃花盆栽"
STRINGS.RECIPE_DESC[string.upper("flowers_change")] = "漂亮的花花。"

STRINGS.NAMES[string.upper("change_ju_flower")] = "菊花盆栽"
STRINGS.RECIPE_DESC[string.upper("change_ju_flower")] = "采摘菊花。"
STRINGS.NAMES[string.upper("change_ju_flower_picked")] = "菊花"

STRINGS.NAMES[string.upper("change_light")] = "宫灯"
STRINGS.RECIPE_DESC[string.upper("change_light")] = "一只宫灯。"

STRINGS.NAMES[string.upper("change_tree")] = "月桂树"
STRINGS.RECIPE_DESC[string.upper("change_tree")] = "睡觉的地方。"


STRINGS.NAMES[string.upper("change_lotus_pond")] = "荷花池"
STRINGS.RECIPE_DESC[string.upper("change_lotus_pond")] = "里面有一朵荷花。"

STRINGS.NAMES[string.upper("change_lotus")] = "荷花"
STRINGS.NAMES[string.upper("change_lotus_flower")] = "摘下的荷花"
STRINGS.NAMES[string.upper("change_lotus_flower_cooked")] = "烤莲藕"

STRINGS.NAMES[string.upper("change_waterdrop")] = "魔力泉水"
STRINGS.RECIPE_DESC[string.upper("change_waterdrop")] = "香香的水仙。"

STRINGS.NAMES[string.upper("change_fountain")] = "兔子喷泉"
STRINGS.RECIPE_DESC[string.upper("change_fountain")] = "就是一个喷泉。"

STRINGS.NAMES[string.upper("change_lifeplant")] = "水仙花"

STRINGS.NAMES[string.upper("change_jungletree")] = "丛林树"
STRINGS.NAMES[string.upper("change_jungletreeseed")] = "丛林树种子"
STRINGS.RECIPE_DESC[string.upper("change_jungletreeseed")] = "热带丛林树的种子。"

STRINGS.NAMES[string.upper("change_palmtree")] = "椰子树"
STRINGS.NAMES[string.upper("change_coconut")] = "椰子"
STRINGS.NAMES[string.upper("change_coconut_cooked")] = "烤椰子"
STRINGS.NAMES[string.upper("change_coconut_halved")] = "一半椰子"
STRINGS.RECIPE_DESC[string.upper("change_coconut")] = "做一个椰子树。"

STRINGS.NAMES[string.upper("change_icecream_bat")] = "冰淇淋棒"
STRINGS.RECIPE_DESC[string.upper("change_icecream_bat")] = "用食物猎捕食物。"

STRINGS.NAMES[string.upper("change_moonsword")] = "月光宝剑"
STRINGS.RECIPE_DESC[string.upper("change_moonsword")] = "天色越晚，威力越大。"

STRINGS.NAMES[string.upper("change_redlantern")] = "红灯笼"
STRINGS.RECIPE_DESC[string.upper("change_redlantern")] = "更亮了。"


STRINGS.NAMES[string.upper("change_bunnyhouse")] = "兔子窝"
STRINGS.RECIPE_DESC[string.upper("change_bunnyhouse")] = "可以用来养兔子。"

STRINGS.NAMES[string.upper("change_bunnyhouse_grass")] = "兔子窝的粮草"
STRINGS.RECIPE_DESC[string.upper("change_bunnyhouse_grass")] = "兔子最喜欢吃了。"

STRINGS.NAMES[string.upper("ly_statue")] = "灵衣的雕像"
STRINGS.RECIPE_DESC[string.upper("ly_statue")] = "应该是某位制作者的雕像吧(雾)"

STRINGS.NAMES[string.upper("change_backpack")] = "兔叽背包"
STRINGS.RECIPE_DESC[string.upper("change_backpack")] = "兔叽兔叽兔叽!"

STRINGS.NAMES[string.upper("change_mace")] = "狼牙棒"
STRINGS.RECIPE_DESC[string.upper("change_mace")] = "胱叽！"

STRINGS.NAMES[string.upper("change_elixir")] = "仙丹"
STRINGS.RECIPE_DESC[string.upper("change_elixir")] = "中和蘑菇的属性~"

STRINGS.NAMES[string.upper("change_fishgang")] = "荷花缸"
STRINGS.RECIPE_DESC[string.upper("change_fishgang")] = "可以养死鱼~"


ChangeTab = AddRecipeTab("嫦娥",234, "images/change_tab.xml", "change_tab.tex", "change")

Recipe("change_researchlab2", 
{Ingredient("boards", 8),Ingredient("cutstone", 4), Ingredient("transistor", 4)}, 
ChangeTab, TECH.SCIENCE_ONE, "change_researchlab2_placer",1,nil,nil,"change","images/inventoryimages/change_researchlab2.xml", "change_researchlab2.tex")

Recipe("change_researchlab3", 
{Ingredient("livinglog", 6), Ingredient("purplegem", 2), Ingredient("nightmarefuel", 14)}, 
ChangeTab, TECH.MAGIC_TWO, "change_researchlab3_placer",1,nil,nil,"change","images/inventoryimages/change_researchlab3.xml", "change_researchlab3.tex")

Recipe("change_elixir", 
{Ingredient("red_cap",1),Ingredient("green_cap",1),Ingredient("blue_cap",2)}, 
ChangeTab, TECH.SCIENCE_ONE, nil,1,nil,nil,"change","images/inventoryimages/change_elixir.xml", "change_elixir.tex")

Recipe("change_backpack", 
{Ingredient("cutgrass",8),Ingredient("twigs",8),Ingredient("rabbit",1)}, 
ChangeTab, TECH.SCIENCE_ONE, nil,1,nil,nil,"change","images/inventoryimages/change_backpack.xml", "change_backpack.tex")

Recipe("change_icecream_bat", 
{Ingredient("butter",1),Ingredient("goatmilk",1),Ingredient("corn",2)}, 
ChangeTab, TECH.SCIENCE_TWO, nil,1,nil,nil,"change","images/inventoryimages/change_icecream_bat.xml", "change_icecream_bat.tex")

Recipe("change_moonsword", 
{Ingredient("moonrocknugget",16),Ingredient("goldnugget",5),Ingredient("livinglog",2)}, 
ChangeTab, TECH.SCIENCE_TWO, nil,1,nil,nil,"change","images/inventoryimages/change_moonsword.xml", "change_moonsword.tex")

Recipe("change_mace", 
{Ingredient("tentaclespike",5),Ingredient("goldnugget",5),Ingredient("twigs",2)}, 
ChangeTab, TECH.SCIENCE_TWO, nil,1,nil,nil,"change","images/inventoryimages/change_mace.xml", "change_mace.tex")


Recipe("flowers_change", 
{Ingredient("petals", 8),Ingredient("slurtle_shellpieces", 1)}, 
ChangeTab, TECH.SCIENCE_TWO, "flowers_change_placer",1,nil,nil,"change","images/inventoryimages/flowers_change.xml", "flowers_change.tex")

Recipe("change_ju_flower", 
{Ingredient("petals", 12),Ingredient("slurtle_shellpieces", 1)}, 
ChangeTab, TECH.SCIENCE_TWO, "change_ju_flower_placer",1,nil,nil,"change","images/inventoryimages/change_ju_flower.xml", "change_ju_flower.tex")

Recipe("change_light", 
{Ingredient("cutstone", 20),Ingredient("goldnugget", 40),Ingredient("greengem", 5)}, 
ChangeTab, TECH.SCIENCE_TWO, "change_light_placer",1,nil,nil,"change","images/inventoryimages/change_light.xml", "change_light.tex")

Recipe("change_tree", 
{Ingredient("petals", 8),Ingredient("yellowgem", 2),Ingredient("livinglog", 12)}, 
ChangeTab, TECH.SCIENCE_TWO, "change_tree_placer",1,nil,nil,"change","images/inventoryimages/change_tree.xml", "change_tree.tex")

Recipe("change_waterdrop", 
{Ingredient("petals", 8),Ingredient("ice", 12)}, 
ChangeTab, TECH.SCIENCE_TWO, nil,1,nil,nil,"change","images/inventoryimages/change_waterdrop.xml", "change_waterdrop.tex")

Recipe("change_fountain", 
{Ingredient("marble", 12),Ingredient("change_waterdrop", 3,"images/inventoryimages/change_waterdrop.xml", "change_waterdrop.tex")}, 
ChangeTab, TECH.SCIENCE_TWO, "change_fountain_placer",1,nil,nil,"change","images/inventoryimages/change_fountain.xml", "change_fountain.tex")

Recipe("change_lotus_pond", 
{Ingredient("poop", 8),Ingredient("goldenshovel",1),Ingredient("change_waterdrop",3,"images/inventoryimages/change_waterdrop.xml", "change_waterdrop.tex")}, 
ChangeTab, TECH.SCIENCE_TWO, "change_lotus_pond_placer",1,nil,nil,"change","images/inventoryimages/change_lotus_flower.xml", "change_lotus_flower.tex")

Recipe("lucky_goldnugget", 
{Ingredient("goldnugget", 1)}, 
ChangeTab, TECH.SCIENCE_TWO, nil,1,nil,nil,"change")

Recipe("change_redlantern", 
{Ingredient("livinglog", 3),Ingredient("glommerfuel",8),Ingredient("twigs",5),}, 
ChangeTab, TECH.SCIENCE_TWO, nil, nil, true,nil,"change","images/inventoryimages/change_redlantern.xml", "change_redlantern.tex")

Recipe("change_jungletreeseed", 
{Ingredient("pinecone",2)}, 
ChangeTab, TECH.SCIENCE_TWO, nil,1,nil,nil,"change","images/inventoryimages/change_jungletreeseed.xml", "change_jungletreeseed.tex")

Recipe("change_coconut", 
{Ingredient("pinecone",2)}, 
ChangeTab, TECH.SCIENCE_TWO, nil,1,nil,nil,"change","images/inventoryimages/change_coconut.xml", "change_coconut.tex")

Recipe("change_bunnyhouse_grass", 
{Ingredient("cutgrass",15),Ingredient("carrot",4)}, 
ChangeTab, TECH.SCIENCE_ONE, nil,1,nil,4,"change","images/inventoryimages/change_bunnyhouse_grass.xml", "change_bunnyhouse_grass.tex")

Recipe("change_bunnyhouse", 
{Ingredient("rabbit",2),Ingredient("boards",3),Ingredient("carrot",8)}, 
ChangeTab, TECH.SCIENCE_TWO, "change_bunnyhouse_placer",1,nil,nil,"change","images/inventoryimages/change_bunnyhouse_2.xml", "change_bunnyhouse_2.tex")

Recipe("change_fishgang", 
{Ingredient("poop", 8),Ingredient("goldenshovel",1),Ingredient("change_waterdrop",3,"images/inventoryimages/change_waterdrop.xml", "change_waterdrop.tex")}, 
ChangeTab, TECH.SCIENCE_TWO, "change_fishgang_placer",1,nil,nil,"change","images/inventoryimages/change_fishgang.xml", "change_fishgang.tex")

Recipe("ly_statue", 
{Ingredient("marble",8)}, 
ChangeTab, TECH.SCIENCE_TWO, "ly_statue_placer",1,nil,nil,"change","images/inventoryimages/ly_statue.xml", "ly_statue.tex")

AddMinimapAtlas("images/map_icons/change.xml")  --增加小地图图标

--增加人物到mod人物列表的里面 性别为女性（MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL）
AddModCharacter("change", "FEMALE") 

-- local change_foods = require("preparedfoods_change")
-- local function IsChangeFood(food)
-- 	return food and change_foods[food] ~= nil 
-- end 
-- local function showproduct(inst)
-- 	if not inst:HasTag("burnt") then
-- 		local product = inst.components.stewer.product
-- 		if IsChangeFood(product) then 
-- 			inst.AnimState:OverrideSymbol("swap_cooked", "change_food_cookpot", product)
-- 		end 
-- 	end
-- end
-- AddPrefabPostInit("cookpot", function(inst)
-- 	if not TheWorld.ismastersim then 
-- 		return inst 
-- 	end  
-- 	local old_ondonecooking = inst.components.stewer.ondonecooking
-- 	inst.components.stewer.ondonecooking = function(inst)
-- 		old_ondonecooking(inst)
-- 		showproduct(inst)
-- 	end
-- 	inst:DoTaskInTime(0,showproduct)
-- end)



local function is_meat(item)
	return item.components.edible ~= nil  and item.components.edible.foodtype == FOODTYPE.MEAT
end 

local function IsAngryByMeat(guy)
	return guy.components.inventory ~= nil and
		guy.components.inventory:FindItem(is_meat) ~= nil
end 

AddPrefabPostInit("bunnyman", function(inst)
	if not TheWorld.ismastersim then 
		return inst 
	end  
	
	if inst.components.combat then 
		local old_retargetfn = inst.components.combat.targetfn
		local old_retargetcd = inst.components.combat.retargetperiod
		local function retarget(inst)
			local target = old_retargetfn(inst)
			if target and target:IsValid() and target:HasTag("change") and IsAngryByMeat(target) then 
				target = nil 
			end
			return target
		end
		inst.components.combat:SetRetargetFunction(old_retargetcd,retarget)
	end 
end)



