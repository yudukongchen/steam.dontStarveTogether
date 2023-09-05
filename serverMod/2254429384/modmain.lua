PrefabFiles = {
    "duanjian",	
	"changjian",
    "dajian",
    "muchui",
    "heiqie",
    "xuese",
	"wujin",
	"pobai",
	"yinxue",
	"tymt",
	"fengci",
	"duocui",
	"tanyu",
	"jujiu",
	"gouya",
	"luya",
	"longying",
	"yanqiu",
	"xiongguan",
	"beargerhat",
	"icesword",
	"suozi",
	"bingxin",
	"zhenfen",
	"huomu",
	"guren",
	"landun",
	"riyan",
	"riyanhuo",
	"banjia",
	"jinhat",
	"zyry",
	"heihat",
	"heifire",
	"longfire",
	"heijian",
	"qlter",
	"yeyun",
	"youming",
	"hongyao",
	"lanyao",
	"ziyao",
	"eyao",
	"taiyangta",
	"wufeng",
	"zhufeng",
	"ziran",
	"guyan",
	"wudu",
	"wange",
	"liuli",
	"xiaocou",
	"fengnu",
	"zhongdu",
	"tk",
	"kj",
	"shouhu",
	"chengxing",
	"dianhu",
	"tornadoz",
	"foodbox",
	"toolbox",
	"combatbox",
	--"duogong",
	--"healingcircle",
}

Assets = 
{   Asset("ATLAS", "images/inventoryimages/duanjian.xml"),
	Asset("ATLAS", "images/inventoryimages/changjian.xml"),
	Asset("ATLAS", "images/inventoryimages/dajian.xml"),
	Asset("ATLAS", "images/inventoryimages/muchui.xml"),
	Asset("ATLAS", "images/inventoryimages/heiqie.xml"),
	Asset("ATLAS", "images/inventoryimages/xuese.xml"),
	Asset("ATLAS", "images/inventoryimages/wujin.xml"),
	Asset("ATLAS", "images/inventoryimages/pobai.xml"),
	Asset("ATLAS", "images/inventoryimages/yinxue.xml"),
	Asset("ATLAS", "images/inventoryimages/tymt.xml"),
    Asset("ATLAS", "images/inventoryimages/fengci.xml"),
	Asset("ATLAS", "images/inventoryimages/duocui.xml"),
	Asset("ATLAS", "images/inventoryimages/tanyu.xml"),
	Asset("ATLAS", "images/inventoryimages/jujiu.xml"),
	Asset("ATLAS", "images/inventoryimages/gouya.xml"),
	Asset("ATLAS", "images/inventoryimages/luya.xml"),
	Asset("ATLAS", "images/inventoryimages/longying.xml"),
	Asset("ATLAS", "images/inventoryimages/yanqiu.xml"),
	Asset("ATLAS", "images/inventoryimages/xiongguan.xml"),
	Asset("ATLAS", "images/inventoryimages/beargerhat.xml"),
	Asset("ATLAS", "images/inventoryimages/suozi.xml"),
	Asset("ATLAS", "images/inventoryimages/bingxin.xml"),
	Asset("ATLAS", "images/inventoryimages/zhenfen.xml"),
	Asset("ATLAS", "images/inventoryimages/huomu.xml"),
	Asset("ATLAS", "images/inventoryimages/guren.xml"),
	Asset("ATLAS", "images/inventoryimages/landun.xml"),
	Asset("ATLAS", "images/inventoryimages/riyan.xml"),
	Asset("ATLAS", "images/inventoryimages/banjia.xml"),
	Asset("ATLAS", "images/inventoryimages/zyry.xml"),
	Asset("ATLAS", "images/inventoryimages/jinhat.xml"),
	Asset("ATLAS", "images/inventoryimages/heihat.xml"),
	Asset("ATLAS", "images/inventoryimages/heijian.xml"),
	Asset("ATLAS", "images/inventoryimages/qlter.xml"),
	Asset("ATLAS", "images/inventoryimages/yeyun.xml"),
	Asset("ATLAS", "images/inventoryimages/hongyao.xml"),
	Asset("ATLAS", "images/inventoryimages/lanyao.xml"),
	Asset("ATLAS", "images/inventoryimages/ziyao.xml"),
	Asset("ATLAS", "images/inventoryimages/eyao.xml"),
	Asset("ATLAS", "images/inventoryimages/taiyangta.xml"),
	Asset("ATLAS", "images/inventoryimages/wufeng.xml"),
	Asset("ATLAS", "images/inventoryimages/zhufeng.xml"),
	Asset("ATLAS", "images/inventoryimages/ziran.xml"),
	Asset("ATLAS", "images/inventoryimages/guyan.xml"),
	Asset("ATLAS", "images/inventoryimages/wudu.xml"),
	Asset("ATLAS", "images/inventoryimages/wange.xml"),
	Asset("ATLAS", "images/inventoryimages/liuli.xml"),
	Asset("ATLAS", "images/inventoryimages/xiaocou.xml"),
	Asset("ATLAS", "images/inventoryimages/fengnu.xml"),
	Asset("ATLAS", "images/inventoryimages/chengxing.xml"),
	Asset("ATLAS", "images/inventoryimages/dianhu.xml"),
	Asset("ATLAS", "images/inventoryimages/foodbox.xml"),
	Asset("ATLAS", "images/inventoryimages/toolbox.xml"),
	Asset("ATLAS", "images/inventoryimages/combatbox.xml"),
	--Asset("ATLAS", "images/inventoryimages/duogong.xml"),
	--Asset("IMAGE", "images/hud/moreweapon.tex" ),
	Asset( "ATLAS", "images/hud/moreweapon.xml" ),
	
	Asset( "ATLAS", "images/map_icons/luya.xml" ),
	Asset( "ATLAS", "images/map_icons/longying.xml" ),
	Asset( "ATLAS", "images/map_icons/xiongguan.xml" ),
	Asset( "ATLAS", "images/map_icons/yanqiu.xml" ),
	Asset( "ATLAS", "images/map_icons/beargerhat.xml" ),
	Asset( "ATLAS", "images/map_icons/taiyangta.xml" ),
}

AddMinimapAtlas("images/map_icons/luya.xml") 
AddMinimapAtlas("images/map_icons/longying.xml") 
AddMinimapAtlas("images/map_icons/xiongguan.xml") 
AddMinimapAtlas("images/map_icons/yanqiu.xml") 
AddMinimapAtlas("images/map_icons/beargerhat.xml") 
AddMinimapAtlas("images/map_icons/taiyangta.xml") 

local STRINGS = GLOBAL.STRINGS                                       
local RECIPETABS = GLOBAL.RECIPETABS
local Ingredient = GLOBAL.Ingredient
local TECH = GLOBAL.TECH
local TUNING = GLOBAL.TUNING

TUNING.HEALTHDODELTA = GetModConfigData("healthdodelta")

STRINGS.NAMES.DUANJIAN = "短剑"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DUANJIAN = "基础武器"  
STRINGS.RECIPE_DESC.DUANJIAN = "基础武器"   

STRINGS.NAMES.CHANGJIAN = "长剑"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CHANGJIAN = "基础武器"  
STRINGS.RECIPE_DESC.CHANGJIAN = "基础武器"   

STRINGS.NAMES.DAJIAN = "大剑"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DAJIAN = "暴风大剑"  
STRINGS.RECIPE_DESC.DAJIAN = "进阶武器"   

STRINGS.NAMES.TYMT = "提亚马特"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TYMT = "斧头？？？？"  
STRINGS.RECIPE_DESC.TYMT = "范围性武器"   

STRINGS.NAMES.MUCHUI = "净蚀"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MUCHUI = "小木锤"  
STRINGS.RECIPE_DESC.MUCHUI = "进阶武器"

STRINGS.NAMES.KJ = "尖齿铠甲"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.KJ= "相当多的尖齿"  
STRINGS.RECIPE_DESC.KJ = "用于回击你的敌人"   

STRINGS.NAMES.HEIQIE = "黑切"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HEIQIE = "双刃斧"  
STRINGS.RECIPE_DESC.HEIQIE = "切割敌人护甲"

STRINGS.NAMES.XUESE = "血色之刃"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.XUESE = "吸收敌人的力量"  
STRINGS.RECIPE_DESC.XUESE = "纯粹的暴力"

STRINGS.NAMES.WUJIN = "无尽之刃"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.WUJIN = "暴击！！！！"  
STRINGS.RECIPE_DESC.WUJIN = "给敌人暴击"

STRINGS.NAMES.POBAI = "破败王者之刃"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.POBAI  = "专门对付大型生物的武器"  
STRINGS.RECIPE_DESC.POBAI  = "对巨人造成更多伤害"

STRINGS.NAMES.YINXUE = "饮血剑"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.YINXUE  = "吸取敌人的鲜血"  
STRINGS.RECIPE_DESC.YINXUE  = "痛饮敌人的鲜血"

STRINGS.NAMES.DUOCUI = "夺萃之镰"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DUOCUI  = "吞掉他们的灵魂"  
STRINGS.RECIPE_DESC.DUOCUI  = "掠夺灵魂"   

STRINGS.NAMES.TANYU = "贪欲九头蛇"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TANYU  = "九头蛇"  
STRINGS.RECIPE_DESC.TANYU  = "范围性武器"   

STRINGS.NAMES.JUJIU = "巨型九头蛇"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.JUJIU  = "九头蛇"  
STRINGS.RECIPE_DESC.JUJIU  = "范围性武器"   

STRINGS.NAMES.GOUYA = "狗牙大剑"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GOUYA  = "大狗狗的牙齿做的武器"  
STRINGS.RECIPE_DESC.GOUYA  = "斩断你的敌人"  

STRINGS.NAMES.HEIJIAN = "暗影大剑"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HEIJIAN  = "挥舞来自暗影的力量"  
STRINGS.RECIPE_DESC.HEIJIAN  = "暗影之力"  

STRINGS.NAMES.LUYA = "鹿鸭剑"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LUYA  = "大鹅的羽毛做的武器"  
STRINGS.RECIPE_DESC.LUYA  = "风刃"   

STRINGS.NAMES.LONGYING = "龙蝇之爪"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LONGYING  = "龙的鳞片做的武器"  
STRINGS.RECIPE_DESC.LONGYING  = "毁灭你的敌人"

STRINGS.NAMES.YANQIU = "眼球剑"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.YANQIU  = "巨鹿的眼珠子做的武器"  
STRINGS.RECIPE_DESC.YANQIU  = "大眼珠子"

STRINGS.NAMES.XIONGGUAN = "大熊棒"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.XIONGGUAN  = "熊熊的毛皮做的武器"  
STRINGS.RECIPE_DESC.XIONGGUAN  = "毛绒绒的武器"

STRINGS.NAMES.BEARGERHAT = "大熊帽"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BEARGERHAT  = "熊熊的毛皮做的头盔"  
STRINGS.RECIPE_DESC.BEARGERHAT  = "毛绒绒的头盔"          

STRINGS.NAMES.SUOZI = "锁子甲"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SUOZI  = "能为我抵御更多的伤害"  
STRINGS.RECIPE_DESC.SUOZI  = "坚固的盔甲"

STRINGS.NAMES.JINHAT = "金质头盔"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.JINHAT  = "能为我抵御更多的伤害"  
STRINGS.RECIPE_DESC.JINHAT  = "坚固的头盔"

STRINGS.NAMES.BINGXIN = "冰霜之心"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BINGXIN = "抵御炎热和伤害"  
STRINGS.RECIPE_DESC.BINGXIN  = "寒冷的心石"

STRINGS.NAMES.ZHENFEN = "振奋铠甲"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ZHENFEN = "提供更多的治疗"  
STRINGS.RECIPE_DESC.ZHENFEN = "更多的治疗"

STRINGS.NAMES.HUOMU = "活木甲"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HUOMU = "这件铠甲有生命"  
STRINGS.RECIPE_DESC.HUOMU = "活的铠甲" 

STRINGS.NAMES.LANDUN = "兰顿之兆"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LANDUN = "这件铠甲相当硬"  
STRINGS.RECIPE_DESC.LANDUN = "十分坚固的铠甲"    

STRINGS.NAMES.RIYAN = "日炎斗篷"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.RIYAN = "燃烧生命的铠甲"  
STRINGS.RECIPE_DESC.RIYAN = "燃烧的铠甲"

STRINGS.NAMES.BANJIA = "亡者板甲"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BANJIA = "“只有一种方法能让你从我这里拿到这件盔甲……” - 被遗忘的名字"  
STRINGS.RECIPE_DESC.BANJIA = "亡者的铠甲"

STRINGS.NAMES.ZYRY = "正义荣耀"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ZYRY = "向敌人冲锋"  
STRINGS.RECIPE_DESC.ZYRY = "强大的头盔"

STRINGS.NAMES.TK = "尖角头盔"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TK= "这能提供良好的保护"  
STRINGS.RECIPE_DESC.TK = "用于保护你的头部" 

STRINGS.NAMES.ZYRY = "正义荣耀"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ZYRY = "向敌人冲锋"  
STRINGS.RECIPE_DESC.ZYRY = "强大的头盔"

STRINGS.NAMES.HEIHAT = "黑炎帽"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HEIHAT = "燃烧黑暗的炎火"  
STRINGS.RECIPE_DESC.HEIHAT = "黑炎之火"   

STRINGS.NAMES.QLTER = "恰丽塔尔"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.QLTER = "它会回到我身边"  
STRINGS.RECIPE_DESC.QLTER = "大型飞刃"          

STRINGS.NAMES.YEYUN = "夜陨"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.YEYUN = "某个残暴君主的武器"  
STRINGS.RECIPE_DESC.YEYUN= "粉碎一切"  

STRINGS.NAMES.SHOUHU = "守护天使"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SHOUHU = "这能让我复活"  
STRINGS.RECIPE_DESC.SHOUHU= "天使之剑"  

--STRINGS.NAMES.DUOGONG = "多功能工具"         
--STRINGS.CHARACTERS.GENERIC.DESCRIBE.DUOGONG = "这能干很多活"  
--STRINGS.RECIPE_DESC.DUOGONG= "多用工具"

STRINGS.NAMES.FENGCI = "蜂刺棒"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FENGCI  = "蜜蜂的尾针做的武器"  
STRINGS.RECIPE_DESC.FENGCI  = "尖锐的刺"  

STRINGS.NAMES.GUREN = "骨刃"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GUREN  = "这把武器能自我修复"  
STRINGS.RECIPE_DESC.GUREN  = "自我修复的武器"          

STRINGS.NAMES.WUFENG = "无锋岩脊"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.WUFENG  = "对付群体敌人"  
STRINGS.RECIPE_DESC.WUFENG  = "令人安息的重量！"   

STRINGS.NAMES.ZHUFENG = "逐风杖"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ZHUFENG  = "轻盈的法杖"  
STRINGS.RECIPE_DESC.ZHUFENG  = "皮一下就跑，很刺激！"               

STRINGS.NAMES.ZIRAN = "自然法杖"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ZIRAN  = "生命的法杖"  
STRINGS.RECIPE_DESC.ZIRAN  = "治疗你和队友！"       

STRINGS.NAMES.GUYAN = "古岩之脊"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GUYAN  = "击破敌人的护甲！！！"  
STRINGS.RECIPE_DESC.GUYAN  = "像石头一样强壮！" 

STRINGS.NAMES.WUDU = "巫毒吹箭"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.WUDU  = "用毒的吹箭"  
STRINGS.RECIPE_DESC.WUDU  = "用毛绒绒的巫术给它们放血！"              

STRINGS.NAMES.WANGE = "挽歌"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.WANGE  = "用毒的吹箭"  
STRINGS.RECIPE_DESC.WANGE  = "用毛绒绒的巫术给它们放血！" 
             
STRINGS.NAMES.LIULI = "琉璃"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LIULI  = "用毒的吹箭"  
STRINGS.RECIPE_DESC.LIULI  = "用毛绒绒的巫术给它们放血！"

STRINGS.NAMES.XIAOCOU = "琉璃"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.XIAOCOU  = "用毒的吹箭"  
STRINGS.RECIPE_DESC.XIAOCOU = "用毛绒绒的巫术给它们放血！"

STRINGS.NAMES.FENGNU = "琉璃"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FENGNU  = "用毒的吹箭"  
STRINGS.RECIPE_DESC.FENGNU  = "用毛绒绒的巫术给它们放血！" 

STRINGS.NAMES.CHENGXING = "晨星之刃"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CHENGXING  = "这柄刀刃能刺穿黑夜"  
STRINGS.RECIPE_DESC.CHENGXING  = "星辰之刃划破夜空"   

STRINGS.NAMES.DIANHU = "电弧手里剑"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DIANHU  = "划破黑夜的闪电"  
STRINGS.RECIPE_DESC.DIANHU  = "电光四射"        

STRINGS.NAMES.FOODBOX = "食物箱子"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FOODBOX  = "我要把好吃的都放进去"  
STRINGS.RECIPE_DESC.FOODBOX  = "装你最爱吃的东西"    

STRINGS.NAMES.TOOLBOX = "工具箱子"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TOOLBOX  = "我要用的工具都在里面"  
STRINGS.RECIPE_DESC.TOOLBOX = "装你最爱的工具"     

STRINGS.NAMES.COMBATBOX = "武器箱子"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.COMBATBOX  = "我战斗的装备都在里面"  
STRINGS.RECIPE_DESC.COMBATBOX  = "装你最爱的武器"            

STRINGS.NAMES.HONGYAO = "生命药水"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HONGYAO   = "这个能治疗我的伤势"  
STRINGS.RECIPE_DESC.HONGYAO   = "来点治疗"

STRINGS.NAMES.LANYAO = "精神药水"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LANYAO   = "这个能让我恢复理智"  
STRINGS.RECIPE_DESC.LANYAO   = "恢复理智"

STRINGS.NAMES.ZIYAO  = "腐败药水"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ZIYAO  = "这个能治疗我的伤势和精神"  
STRINGS.RECIPE_DESC.ZIYAO  = "治疗和精神" 

STRINGS.NAMES.EYAO  = "饥饿药水"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.EYAO  = "吃一个就饱了"  
STRINGS.RECIPE_DESC.EYAO  = "填饱你的胃"           

STRINGS.NAMES.TAIYANGTA  = "太阳圆盘"         
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TAIYANGTA  = "这是我领土的标识"  
STRINGS.RECIPE_DESC.TAIYANGTA  = "标识你的统治"       
  
local moreweapon = AddRecipeTab("更多武器", 996, "images/hud/moreweapon.xml", "moreweapon.tex")
local AddRecipe = AddRecipe
local taiyangta = AddRecipe("taiyangta", { Ingredient("cutstone", 10),Ingredient("goldnugget", 10),Ingredient("dragon_scales", 1),Ingredient("deerclops_eyeball", 1)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, "taiyangta_placer")
taiyangta.atlas = "images/inventoryimages/taiyangta.xml"
taiyangta.sortkey  = -993

local duanjian = AddRecipe("duanjian", {Ingredient("twigs", 1),Ingredient("flint", 1)},moreweapon, TECH.SCIENCE_NONE)
duanjian.atlas = "images/inventoryimages/duanjian.xml"
duanjian.sortkey  = -998

local hongyao = AddRecipe("hongyao", { Ingredient("honey", 2),Ingredient("nightmarefuel", 2),Ingredient("red_cap", 1)}, RECIPETABS.SURVIVAL,  TECH.SCIENCE_NONE)
hongyao.atlas = "images/inventoryimages/hongyao.xml"
hongyao.sortkey  = -997

local lanyao = AddRecipe("lanyao", { Ingredient("honey", 2),Ingredient("nightmarefuel", 2),Ingredient("blue_cap", 1)},  RECIPETABS.SURVIVAL,  TECH.SCIENCE_ONE)
lanyao.atlas = "images/inventoryimages/lanyao.xml"
lanyao.sortkey  = -996

local ziyao = AddRecipe("ziyao", { Ingredient("lanyao", 1, "images/inventoryimages/lanyao.xml"),Ingredient("hongyao", 1, "images/inventoryimages/hongyao.xml"),Ingredient("honey", 2)},  RECIPETABS.SURVIVAL,  TECH.SCIENCE_TWO)
ziyao.atlas = "images/inventoryimages/ziyao.xml"
ziyao.sortkey  = -995

local eyao = AddRecipe("eyao", { Ingredient("bonestew", 1),Ingredient("nightmarefuel", 2),Ingredient("honey", 2)},  RECIPETABS.SURVIVAL,  TECH.SCIENCE_TWO)
eyao.atlas = "images/inventoryimages/eyao.xml"
eyao.sortkey  = -994

local foodbox = AddRecipe("foodbox", { Ingredient("goldnugget", 8),Ingredient("gears", 1),Ingredient("cutstone", 1)},  RECIPETABS.SURVIVAL,  TECH.SCIENCE_TWO)
foodbox.atlas = "images/inventoryimages/foodbox.xml"
foodbox.sortkey  = -993

local toolbox = AddRecipe("toolbox", { Ingredient("goldnugget", 8),Ingredient("axe", 1),Ingredient("pickaxe", 1)},  RECIPETABS.SURVIVAL,  TECH.SCIENCE_TWO)
toolbox.atlas = "images/inventoryimages/toolbox.xml"
toolbox.sortkey  = -992

local combatbox = AddRecipe("combatbox", { Ingredient("goldnugget", 8),Ingredient("spear", 1),Ingredient("armorwood", 1)},  RECIPETABS.SURVIVAL,  TECH.SCIENCE_TWO)
combatbox.atlas = "images/inventoryimages/combatbox.xml"
combatbox.sortkey  = -991

local changjian = AddRecipe("changjian", { Ingredient("log", 1),Ingredient("goldnugget", 2)}, moreweapon, TECH.SCIENCE_ONE)
changjian.atlas = "images/inventoryimages/changjian.xml"

--[[local wufeng = AddRecipe("wufeng", { Ingredient("hammer", 1),Ingredient("marble", 4),Ingredient("nitre", 3)}, RECIPETABS.WAR, TECH.SCIENCE_ONE)
wufeng.atlas = "images/inventoryimages/wufeng.xml"

local zhufeng = AddRecipe("zhufeng", { Ingredient("compass", 1),Ingredient("tallbirdegg", 2),Ingredient("feather_canary", 3)}, RECIPETABS.WAR, TECH.SCIENCE_ONE)
zhufeng.atlas = "images/inventoryimages/zhufeng.xml"

local ziran = AddRecipe("ziran", { Ingredient("livinglog", 12),Ingredient("greengem", 1),Ingredient("feather_canary", 3)}, RECIPETABS.WAR, TECH.SCIENCE_ONE)
ziran.atlas = "images/inventoryimages/ziran.xml"

local wudu = AddRecipe("wudu", { Ingredient("furtuft", 1),Ingredient("houndstooth", 8),Ingredient("cutreeds", 4)}, RECIPETABS.WAR, TECH.SCIENCE_ONE, nil, nil, nil, 4)
wudu.atlas = "images/inventoryimages/wudu.xml"

local wange = AddRecipe("wange", { Ingredient("furtuft", 1),Ingredient("houndstooth", 8),Ingredient("cutreeds", 4)}, RECIPETABS.WAR, TECH.SCIENCE_ONE)
wange.atlas = "images/inventoryimages/wange.xml"

local liuli = AddRecipe("liuli", { Ingredient("furtuft", 1),Ingredient("houndstooth", 8),Ingredient("cutreeds", 4)}, RECIPETABS.WAR, TECH.SCIENCE_ONE)
liuli.atlas = "images/inventoryimages/liuli.xml"]]


local suozi = AddRecipe("suozi", {  Ingredient("armorwood", 1),Ingredient("goldnugget", 2)}, moreweapon, TECH.SCIENCE_TWO)
suozi.atlas = "images/inventoryimages/suozi.xml"

local jinhat = AddRecipe("jinhat", {  Ingredient("footballhat", 1),Ingredient("goldnugget", 2)}, moreweapon, TECH.SCIENCE_TWO)
jinhat.atlas = "images/inventoryimages/jinhat.xml"

local dajian = AddRecipe("dajian", { Ingredient("changjian", 1, "images/inventoryimages/changjian.xml" ),Ingredient("goldnugget", 2)}, moreweapon, TECH.SCIENCE_TWO)
dajian.atlas = "images/inventoryimages/dajian.xml"

local muchui = AddRecipe("muchui", { Ingredient("changjian", 1, "images/inventoryimages/changjian.xml" ),Ingredient("hammer", 1)}, moreweapon, TECH.SCIENCE_TWO)
muchui.atlas = "images/inventoryimages/muchui.xml"

local tymt = AddRecipe("tymt", { Ingredient("changjian", 1, "images/inventoryimages/changjian.xml" ),Ingredient("axe", 2)}, moreweapon, TECH.SCIENCE_TWO)
tymt.atlas = "images/inventoryimages/tymt.xml"

local heiqie = AddRecipe("heiqie", { Ingredient("muchui", 1, "images/inventoryimages/muchui.xml" ),Ingredient("dajian", 1, "images/inventoryimages/dajian.xml")}, moreweapon, TECH.SCIENCE_TWO)
heiqie.atlas = "images/inventoryimages/heiqie.xml"

local xuese = AddRecipe("xuese", { Ingredient("changjian", 1, "images/inventoryimages/changjian.xml" ),Ingredient("dajian", 1, "images/inventoryimages/dajian.xml"),Ingredient("duanjian", 1, "images/inventoryimages/duanjian.xml")}, moreweapon, TECH.SCIENCE_TWO)
xuese.atlas = "images/inventoryimages/xuese.xml"

local wujin = AddRecipe("wujin", { Ingredient("redgem", 1),Ingredient("dajian", 2, "images/inventoryimages/dajian.xml")}, moreweapon, TECH.SCIENCE_TWO)
wujin.atlas = "images/inventoryimages/wujin.xml"

local pobai = AddRecipe("pobai", { Ingredient("greengem", 1),Ingredient("dajian", 1, "images/inventoryimages/dajian.xml"),Ingredient("batbat", 1)}, moreweapon, TECH.SCIENCE_TWO)
pobai.atlas = "images/inventoryimages/pobai.xml"

local yinxue = AddRecipe("yinxue", { Ingredient("changjian", 1, "images/inventoryimages/changjian.xml" ),Ingredient("dajian", 1, "images/inventoryimages/dajian.xml"),Ingredient("batbat", 1)}, moreweapon, TECH.SCIENCE_TWO)
yinxue.atlas = "images/inventoryimages/yinxue.xml"

local duocui = AddRecipe("duocui", { Ingredient("bluegem", 1 ),Ingredient("dajian", 1, "images/inventoryimages/dajian.xml"),Ingredient("nightmarefuel", 10)}, moreweapon, TECH.SCIENCE_TWO)
duocui.atlas = "images/inventoryimages/duocui.xml"

local tanyu = AddRecipe("tanyu", { Ingredient("tymt", 1, "images/inventoryimages/tymt.xml" ),Ingredient("batbat", 1),Ingredient("goldenpickaxe", 1)}, moreweapon, TECH.SCIENCE_TWO)
tanyu.atlas = "images/inventoryimages/tanyu.xml"

local jujiu = AddRecipe("jujiu", { Ingredient("tymt", 1, "images/inventoryimages/tymt.xml" ),Ingredient("goldenaxe", 1),Ingredient("goldenpickaxe", 1)}, moreweapon, TECH.SCIENCE_TWO)
jujiu.atlas = "images/inventoryimages/jujiu.xml"

local guren = AddRecipe("guren", { Ingredient("batbat", 1),Ingredient("dajian", 1, "images/inventoryimages/dajian.xml"),Ingredient("boneshard", 4)}, moreweapon, TECH.SCIENCE_TWO)
guren.atlas = "images/inventoryimages/guren.xml"

local gouya = AddRecipe("gouya", { Ingredient("dajian", 1, "images/inventoryimages/dajian.xml"),Ingredient("houndstooth", 5),Ingredient("goldnugget", 4)}, moreweapon, TECH.SCIENCE_TWO)
gouya.atlas = "images/inventoryimages/gouya.xml"

local heijian = AddRecipe("heijian", { Ingredient("dajian", 1, "images/inventoryimages/dajian.xml"),Ingredient("nightmarefuel", 10),Ingredient("nightsword", 1)}, moreweapon, TECH.SCIENCE_TWO)
heijian.atlas = "images/inventoryimages/heijian.xml"

local qlter = AddRecipe("qlter", { Ingredient("dajian", 1, "images/inventoryimages/dajian.xml"),Ingredient("goldnugget", 2),Ingredient("boomerang", 2)}, moreweapon, TECH.SCIENCE_TWO)
qlter.atlas = "images/inventoryimages/qlter.xml"

local dianhu = AddRecipe("dianhu", { Ingredient("chengxing", 1, "images/inventoryimages/chengxing.xml"),Ingredient("transistor", 4),Ingredient("qlter", 1, "images/inventoryimages/qlter.xml")}, moreweapon, TECH.SCIENCE_TWO)
dianhu.atlas = "images/inventoryimages/dianhu.xml"

local yeyun = AddRecipe("yeyun", { Ingredient("muchui", 1, "images/inventoryimages/muchui.xml"),Ingredient("goldnugget", 2), Ingredient("dajian", 1, "images/inventoryimages/dajian.xml")}, moreweapon, TECH.SCIENCE_TWO)
yeyun.atlas = "images/inventoryimages/yeyun.xml"

local chengxing = AddRecipe("chengxing", { Ingredient("nightstick", 1),Ingredient("goldnugget", 2), Ingredient("dajian", 1, "images/inventoryimages/dajian.xml")}, moreweapon, TECH.SCIENCE_TWO)
chengxing.atlas = "images/inventoryimages/chengxing.xml"

local shouhu = AddRecipe("shouhu", {Ingredient("suozi", 1, "images/inventoryimages/suozi.xml"),Ingredient("amulet", 1), Ingredient("dajian", 1, "images/inventoryimages/dajian.xml")}, moreweapon, TECH.SCIENCE_TWO)
shouhu.atlas = "images/inventoryimages/shouhu.xml"

local bingxin = AddRecipe("bingxin", {  Ingredient("blueamulet", 1),Ingredient("suozi", 1, "images/inventoryimages/suozi.xml"),Ingredient("ice", 15)}, moreweapon, TECH.SCIENCE_TWO)
bingxin.atlas = "images/inventoryimages/bingxin.xml"

local zhenfen = AddRecipe("zhenfen", {  Ingredient("amulet", 1),Ingredient("suozi", 1, "images/inventoryimages/suozi.xml"),Ingredient("livinglog", 4)}, moreweapon, TECH.SCIENCE_TWO)
zhenfen.atlas = "images/inventoryimages/zhenfen.xml"

local huomu = AddRecipe("huomu", {  Ingredient("fertilizer", 1),Ingredient("suozi", 1, "images/inventoryimages/suozi.xml"),Ingredient("livinglog", 4)}, moreweapon, TECH.SCIENCE_TWO)
huomu.atlas = "images/inventoryimages/huomu.xml"

local landun = AddRecipe("landun", {  Ingredient("cutstone", 1),Ingredient("suozi", 1, "images/inventoryimages/suozi.xml"),Ingredient("goldnugget", 2)}, moreweapon, TECH.SCIENCE_TWO)
landun.atlas = "images/inventoryimages/landun.xml"

local riyan = AddRecipe("riyan", {  Ingredient("redgem", 1),Ingredient("suozi", 1, "images/inventoryimages/suozi.xml"),Ingredient("charcoal", 10)}, moreweapon, TECH.SCIENCE_TWO)
riyan.atlas = "images/inventoryimages/riyan.xml"

local banjia = AddRecipe("banjia", {  Ingredient("boneshard", 4),Ingredient("suozi", 1, "images/inventoryimages/suozi.xml"),Ingredient("goldnugget", 2)}, moreweapon, TECH.SCIENCE_TWO)
banjia.atlas = "images/inventoryimages/banjia.xml"

local kj = AddRecipe("kj", {  Ingredient("houndstooth", 4),Ingredient("suozi", 1, "images/inventoryimages/suozi.xml"),Ingredient("goldnugget", 2)}, moreweapon, TECH.SCIENCE_TWO)
kj.atlas = "images/inventoryimages/kj.xml"

local zyry = AddRecipe("zyry", {  Ingredient("jinhat", 1, "images/inventoryimages/jinhat.xml"),Ingredient("feather_crow", 4),Ingredient("goldnugget", 2)}, moreweapon, TECH.SCIENCE_TWO)
zyry.atlas = "images/inventoryimages/zyry.xml"

local heihat = AddRecipe("heihat", {  Ingredient("jinhat", 1, "images/inventoryimages/jinhat.xml"),Ingredient("nightmarefuel", 6),Ingredient("goldnugget", 2)}, moreweapon, TECH.SCIENCE_TWO)
heihat.atlas = "images/inventoryimages/heihat.xml"

local tk = AddRecipe("tk", {  Ingredient("jinhat", 1, "images/inventoryimages/jinhat.xml"),Ingredient("flint", 2),Ingredient("goldnugget", 2)}, moreweapon, TECH.SCIENCE_TWO)
tk.atlas = "images/inventoryimages/tk.xml"

local luya = AddRecipe("luya", { Ingredient("dajian", 1, "images/inventoryimages/dajian.xml"),Ingredient("goose_feather", 8),Ingredient("goldnugget", 8)}, moreweapon, TECH.SCIENCE_TWO)
luya.atlas = "images/inventoryimages/luya.xml"

local longying = AddRecipe("longying", {  Ingredient("hambat", 1),Ingredient("dragon_scales", 1),Ingredient("goldnugget", 8)}, moreweapon, TECH.SCIENCE_TWO)
longying.atlas = "images/inventoryimages/longying.xml"

local yanqiu = AddRecipe("yanqiu", {  Ingredient("dajian", 1, "images/inventoryimages/dajian.xml"),Ingredient("deerclops_eyeball", 1),Ingredient("ice", 15)}, moreweapon, TECH.SCIENCE_TWO)
yanqiu.atlas = "images/inventoryimages/yanqiu.xml"

local xiongguan = AddRecipe("xiongguan", { Ingredient("hambat", 1),Ingredient("bearger_fur", 1),Ingredient("goldnugget", 8)}, moreweapon, TECH.SCIENCE_TWO)
xiongguan.atlas = "images/inventoryimages/xiongguan.xml"

local beargerhat = AddRecipe("beargerhat", {  Ingredient("footballhat", 1),Ingredient("bearger_fur", 1),Ingredient("goldnugget", 8)}, moreweapon, TECH.SCIENCE_TWO)
beargerhat.atlas = "images/inventoryimages/beargerhat.xml"

local fengci = AddRecipe("fengci", { Ingredient("boards", 1),Ingredient("stinger", 10)}, moreweapon, TECH.SCIENCE_TWO)
fengci.atlas = "images/inventoryimages/fengci.xml"

--[[local guyan = AddRecipe("guyan", { Ingredient("wufeng", 1, "images/inventoryimages/wufeng.xml"),Ingredient("minotaurhorn", 1),Ingredient("fossil_piece", 12)}, RECIPETABS.WAR, TECH.SCIENCE_TWO)
guyan.atlas = "images/inventoryimages/guyan.xml"]]
if TUNING.HEALTHDODELTA == 1 then 
AddComponentPostInit("health", function(inst)
    local CDS=inst.DoDelta
		 inst.DoDelta=function(self,amount, overtime, cause, ignore_invincible)
			local inv=self.inst.components.inventory
			local hat=inv and inv:GetEquippedItem(GLOBAL.EQUIPSLOTS.BODY)
			local hbt=inv and inv:Has("zhenfen", 1)
			if amount >= 0 then
			
			  if hat and hat.prefab=="zhenfen" then
				return CDS(self,amount*2, overtime, cause, ignore_invincible)
			    elseif hbt  then 
			     return CDS(self,amount*1.25, overtime, cause, ignore_invincible)
			    else
				return CDS(self,amount, overtime, cause, ignore_invincible)
			  end
			  
			  
			   else
			if self.inst:HasTag("yishun") then 
			return CDS(self,amount*1.25, overtime, cause, ignore_invincible)
			else
			return CDS(self,amount, overtime, cause, ignore_invincible)
			end
		end	
		
			end
   end)
end
   
local G = GLOBAL

AddAction("SOUGE", "Reaps", function(act)
	G.SpawnPrefab("duocui"):HarvestTarget(act.target)
	if act.target and act.target.prefab == "worm" and act.target.components.pickable then
		act.target.components.pickable.onpickedfn(act.target, act.doer)
	end
	return true
end)

AddComponentAction("EQUIPPED", "harvestablereapers", function(inst, doer, target, actions, right)
	if target:HasTag("harvestable") or target:HasTag("pickable") or target:HasTag("readyforharvest") or target:HasTag("withered") then
		table.insert(actions, G.ACTIONS.SOUGE)
	end
end)

AddStategraphActionHandler("wilson", G.ActionHandler(G.ACTIONS.SOUGE, "dojostleaction"))
AddStategraphActionHandler("wilson_client", G.ActionHandler(G.ACTIONS.SOUGE, "dojostleaction"))

AddComponentPostInit("playercontroller", function(self)
	local GABA = self.GetActionButtonAction
	function self:GetActionButtonAction(...)
		local result = GABA(self, ...)
		if result ~= nil and (result.action == G.ACTIONS.PICK or result.action == G.ACTIONS.HARVEST) then
			local tools = self.inst.replica.inventory:GetEquippedItem(G.EQUIPSLOTS.HANDS)
			if tools ~= nil and tools:HasTag("scythes") then
				result.action = G.ACTIONS.SOUGE
				result.invobject = tools
			end
		end
		return result
	end
end)
AddPrefabPostInit("marble",function(inst)
	if not inst.components.tradable then
		inst:AddComponent("tradable")
    end
end)
AddPrefabPostInit("wolfgang",function(inst)
		inst:AddTag("wolfgang")
end)	
AddPrefabPostInit("pitchfork",function(inst)
		inst:AddComponent("tool")
end)
AddPrefabPostInit("trap",function(inst)
		inst:AddComponent("tool")
end)
AddPrefabPostInit("birdtrap",function(inst)
		inst:AddComponent("tool")
end)
AddPrefabPostInit("bugnet",function(inst)
		inst:AddComponent("tool")
end)
AddPrefabPostInit("fishingrod",function(inst)
		inst:AddComponent("tool")
end)
AddPrefabPostInit("razor",function(inst)
		inst:AddComponent("tool")
end)
AddPrefabPostInit("oceanfishingrod",function(inst)
		inst:AddComponent("tool")
end)
AddPrefabPostInit("farm_hoe",function(inst)
		inst:AddComponent("tool")
end)
AddPrefabPostInit("golden_farm_hoe",function(inst)
		inst:AddComponent("tool")
end)
AddPrefabPostInit("wateringcan",function(inst)
		inst:AddComponent("tool")
end)
AddPrefabPostInit("premiumwateringcan",function(inst)
		inst:AddComponent("tool")
end)
AddPrefabPostInit("featherpencil",function(inst)
		inst:AddComponent("tool")
end)
AddPrefabPostInit("pocket_scale",function(inst)
		inst:AddComponent("tool")
end)
AddPrefabPostInit("beef_bell",function(inst)
		inst:AddComponent("tool")
end)
AddPrefabPostInit("saddlehorn",function(inst)
		inst:AddComponent("tool")
end)
AddPrefabPostInit("saddle_basic",function(inst)
		inst:AddComponent("tool")
end)
AddPrefabPostInit("saddle_war",function(inst)
		inst:AddComponent("tool")
end)
AddPrefabPostInit("saddle_race",function(inst)
		inst:AddComponent("tool")
end)
AddPrefabPostInit("brush",function(inst)
		inst:AddComponent("tool")
end)
AddPrefabPostInit("saltlick",function(inst)
		inst:AddComponent("tool")
end)
AddPrefabPostInit("scythe",function(inst)
		inst:AddComponent("tool")
end)
AddPrefabPostInit("scythe_golden",function(inst)
		inst:AddComponent("tool")
end)


