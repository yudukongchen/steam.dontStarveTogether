GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})
local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local Recipe = GLOBAL.Recipe
local TECH = GLOBAL.TECH
local resolvefilepath = GLOBAL.resolvefilepath
local TUNING = GLOBAL.TUNING
local Action = GLOBAL.Action
local ACTIONS = GLOBAL.ACTIONS
local ActionHandler = GLOBAL.ActionHandler
local State = GLOBAL.State
local TimeEvent = GLOBAL.TimeEvent
local EventHandler = GLOBAL.EventHandler
local FRAMES = GLOBAL.FRAMES
local Vector3 = GLOBAL.Vector3
local net_bool = GLOBAL.net_bool
local SpawnPrefab = GLOBAL.SpawnPrefab
local FindValidPositionByFan = GLOBAL.FindValidPositionByFan

PrefabFiles = {    --所有出现在prefabs里的文件都应该在这里注册，否则无效。
	"diting",  --人物代码文件
	"diting_none",  --人物皮肤
    "diting_bloom_fx",   --不能大写！！
    "hellhotpot",
    "pawsicles",
    "freezeocean",
    "reviverocket",
    "littlematch",
    "littlematchfire",
    "tianluhat",
    "shadowhelmet",
    "bixiehat",
    "qiongqibao",
    "transmitfire",
    "transmitbluefire",
    "icecake",
    "icecakefire",
    "diting_bloom_track",
}
---对比老版本 主要是增加了names图片 人物检查图标 还有人物的手臂修复（增加了上臂）
--人物动画里面有个SWAP_ICON 里面的图片是在检查时候人物头像那里显示用的


----2019.05.08 修复了 人物大图显示错误和检查图标显示错误

Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/diting.tex" ), --存档图片
    Asset( "ATLAS", "images/saveslot_portraits/diting.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/diting.tex" ), --单机选人界面
    Asset( "ATLAS", "images/selectscreen_portraits/diting.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/diting_silho.tex" ), --单机未解锁界面
    Asset( "ATLAS", "images/selectscreen_portraits/diting_silho.xml" ),

    Asset( "IMAGE", "bigportraits/diting.tex" ), --人物大图（方形的那个）
    Asset( "ATLAS", "bigportraits/diting.xml" ),
	
	Asset( "IMAGE", "images/map_icons/diting.tex" ), --小地图
	Asset( "ATLAS", "images/map_icons/diting.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_diting.tex" ), --tab键人物列表显示的头像
    Asset( "ATLAS", "images/avatars/avatar_diting.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_diting.tex" ),--tab键人物列表显示的头像（死亡）
    Asset( "ATLAS", "images/avatars/avatar_ghost_diting.xml" ),
	
	Asset( "IMAGE", "images/avatars/self_inspect_diting.tex" ), --人物检查按钮的图片
    Asset( "ATLAS", "images/avatars/self_inspect_diting.xml" ),
	
	Asset( "IMAGE", "images/names_diting.tex" ),  --人物名字
    Asset( "ATLAS", "images/names_diting.xml" ),
	
    Asset( "IMAGE", "bigportraits/diting_none.tex" ),  --人物大图（椭圆的那个）
    Asset( "ATLAS", "bigportraits/diting_none.xml" ),

    Asset( "IMAGE", "bigportraits/diting_godmeghost_none.tex" ),  --人物皮肤
    Asset( "ATLAS", "bigportraits/diting_godmeghost_none.xml" ),
    
    Asset("SOUNDPACKAGE", "sound/diting.fev"),  --音效测试
    Asset("SOUND", "sound/diting.fsb"),

    Asset( "IMAGE", "images/inventoryimages/reviverocket.tex" ),
    Asset( "ATLAS", "images/inventoryimages/reviverocket.xml" ),

    Asset( "IMAGE", "images/inventoryimages/littlematch.tex" ),
    Asset( "ATLAS", "images/inventoryimages/littlematch.xml" ),

    Asset( "IMAGE", "images/inventoryimages/tianluhat.tex" ),
    Asset( "ATLAS", "images/inventoryimages/tianluhat.xml" ),

    Asset( "IMAGE", "images/inventoryimages/shadowhelmet.tex" ),
    Asset( "ATLAS", "images/inventoryimages/shadowhelmet.xml" ),

    Asset( "IMAGE", "images/inventoryimages/bixiehat.tex" ),
    Asset( "ATLAS", "images/inventoryimages/bixiehat.xml" ),

    Asset( "IMAGE", "images/inventoryimages/qiongqibao.tex" ),
    Asset( "ATLAS", "images/inventoryimages/qiongqibao.xml" ),

    Asset( "IMAGE", "images/inventoryimages/icecake.tex" ),
    Asset( "ATLAS", "images/inventoryimages/icecake.xml" ),

    Asset("ANIM", "anim/ditinglisten.zip"),  --按钮
    Asset("ANIM", "anim/listen.zip"),  --自制动画
    Asset("ANIM", "anim/listen_fx.zip"),  --特效

    Asset("ATLAS", "images/hud/QM_UI01.xml"),
    Asset("IMAGE", "images/hud/QM_UI01.tex"),

    Asset("ATLAS", "images/hud/QM_UI02.xml"),
    Asset("IMAGE", "images/hud/QM_UI02.tex"),

--[[---注意事项
1、目前官方自从熔炉之后人物的界面显示用的都是那个椭圆的图
2、官方人物目前的图片跟名字是分开的 （这些参照其他的mod搞定了）
3、names_diting 和 diting_none 这两个文件需要特别注意！！！
这两文件每一次重新转换之后！需要到对应的xml里面改对应的名字 否则游戏里面无法显示
具体为：
降names_esctemplatxml 里面的 Element name="diting.tex" （也就是去掉names——）
将diting_none.xml 里面的 Element name="diting_none_oval" 也就是后面要加  _oval
（注意看修改的名字！不是两个都需要修改）
	]]         --（好像别人已经改好了）
}

RegisterInventoryItemAtlas("images/cookbookimages/hellhotpot.xml", "hellhotpot.tex")  --新增
RegisterInventoryItemAtlas("images/cookbookimages/pawsicles.xml", "pawsicles.tex")

local function sorabaseenable(self)
    if self.name == "LoadoutSelect" then
		if not table.contains(GLOBAL.DST_CHARACTERLIST, "diting") then
			table.insert(GLOBAL.DST_CHARACTERLIST, "diting")
		end 
	elseif self.name == "LoadoutRoot" then
		if table.contains(GLOBAL.DST_CHARACTERLIST,"diting") then
			GLOBAL.RemoveByValue(GLOBAL.DST_CHARACTERLIST,"diting")
		end
	end
end
AddClassPostConstruct("widgets/widget", sorabaseenable)

local oldTheInventoryCheckOwnership = TheInventory.CheckOwnership
local mt = getmetatable(TheInventory)
mt.__index.CheckOwnership  = function(i,name,...) 
	if name and type(name)=="string" and name:find("diting") then
		return true 
	else
		return oldTheInventoryCheckOwnership(i,name,...)
	end
end


local oldTheInventoryCheckClientOwnership = TheInventory.CheckClientOwnership
mt.__index.CheckClientOwnership = function(i,userid,name,...) 
	if name and type(name)=="string" and name:find("diting")  then
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
		table.insert(newt,"diting")    -- 我也偷渡
		return newt
	else
		return oldExceptionArrays(ta,tb,...)
	end
end 

GLOBAL.PREFAB_SKINS["diting"] = {   --修复人物大图显示
	"diting_none",
	"diting_godmeghost_none",
}
local ditingfood =      --不加香料不加香料
{
hellhotpot =
	{	
		test = function(cooker, names, tags) return names.redgem and (names.pepper or names.pepper_cooked) and tags.veggie and tags.veggie >= 1.5 and tags.meat end,
		priority = 30,
		weight = 1,
		foodtype = GLOBAL.FOODTYPE.MEAT,
		health = -10,			
		hunger = 100,			
		perishtime = TUNING.PERISH_MED,			
		sanity = -20,			
        cooktime = 0.5,
        temperaturedelta = TUNING.HOT_FOOD_WARMING_THRESHOLD,
        temperatureduration = TUNING.BUFF_FOOD_TEMP_DURATION*3,   --写在这里没用？
        oneat_desc = "辣到怀疑人生。"
    },
pawsicles = 
    {
        test = function(cooker, names, tags) return names.petals and (tags.frozen and tags.frozen == 2) and names.twigs and not tags.meat and not tags.fish  end,
		priority = 20,
		foodtype = GLOBAL.FOODTYPE.VEGGIE,
		health = 10,
		hunger = 20,
		perishtime = TUNING.PERISH_SUPERFAST,
		sanity = 20,
		temperaturedelta = TUNING.COLD_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
		cooktime = 0.25,
    },
}

for k,v in pairs(ditingfood) do
	v.name = k
	v.weight = v.weight or 1
	v.priority = v.priority or 0
end
for k,recipe in pairs(ditingfood) do
    AddCookerRecipe("cookpot", recipe)
    RegisterInventoryItemAtlas("images/cookbookimages/"..recipe.name..".xml", recipe.name..".tex")
end
AddIngredientValues({"redgem"}, {inedible=1,magic=1})
AddIngredientValues({"petals"}, {inedible=1,fruit=.5})

AddRecipe2(
    "reviverocket",
    {Ingredient("nightmarefuel", 2), Ingredient("rope", 1), Ingredient("twigs", 1) ,},
    TECH.SCIENCE_ONE,
    {
        atlas = "images/inventoryimages/reviverocket.xml",
        image = "reviverocket.tex",
        numtogive = 1,
        builder_tag = "diting",
    },
    {"CHARACTER",}
)

AddRecipe2(
    "littlematch",
    {Ingredient("nightmarefuel", 1), Ingredient("cutgrass", 2), Ingredient("twigs", 2),},
    TECH.NONE,
    {
        atlas = "images/inventoryimages/littlematch.xml",
        image = "littlematch.tex",
        numtogive = 1,
        builder_tag = "diting",
    },
    {"LIGHT", "CHARACTER",}
)

AddRecipe2(
    "tianluhat",
    {Ingredient("footballhat", 5), Ingredient("winterhat", 3), Ingredient("bluegem", 10) ,},
    TECH.SCIENCE_ONE,
    {
        atlas = "images/inventoryimages/tianluhat.xml",
        image = "tianluhat.tex",
        numtogive = 1,
    },
    {"ARMOUR","CHARACTER",}
)

AddRecipe2(
    "shadowhelmet",
    {Ingredient("nightmarefuel", 3), Ingredient("papyrus", 1) ,},
    TECH.MAGIC_TWO,
    {
        atlas = "images/inventoryimages/shadowhelmet.xml",
        image = "shadowhelmet.tex",
        numtogive = 1,
    },
    {"ARMOUR","CHARACTER",}
)

AddRecipe2(
    "bixiehat",
    { Ingredient("shadowhelmet", 5,"images/inventoryimages/shadowhelmet.xml"), Ingredient("ruinshat", 3), Ingredient("redgem", 10),},
    TECH.SCIENCE_ONE,
    {
        atlas = "images/inventoryimages/bixiehat.xml",
        image = "bixiehat.tex",
        numtogive = 1,
    },
    {"ARMOUR","CHARACTER",}
)

AddRecipe2(
    "qiongqibao",
    { Ingredient("heatrock", 1), Ingredient("redgem", 1), Ingredient("dragon_scales", 1) ,},
    TECH.SCIENCE_TWO,
    {
        atlas = "images/inventoryimages/qiongqibao.xml",
        image = "qiongqibao.tex",
        numtogive = 1,
    },
    {"WINTER","CHARACTER",}
)
-- The character select screen lines  --人物选人界面的描述

STRINGS.CHARACTER_TITLES.diting = "谛听"
STRINGS.CHARACTER_NAMES.diting = "谛听" 
STRINGS.NAMES.DITING = "谛听"
STRINGS.CHARACTER_DESCRIPTIONS.diting = "*地府神兽，极寒体质\n*辨听万物，千里追位\n*习惯性烧东西，随身携带小火柴"
STRINGS.CHARACTER_QUOTES.diting = "\"谛识人间千万面，伏听金地辨真言\""
STRINGS.NAMES.HELLHOTPOT= "地狱辣九宫格"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HELLHOTPOT= "我没有勇气吃……"
STRINGS.NAMES.PAWSICLES= "爪爪冰棍"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PAWSICLES= "这是用它的爪子当模具做的！"
STRINGS.NAMES.REVIVEROCKET= "速速还阳箭"
STRINGS.RECIPE_DESC.REVIVEROCKET = "地府到人间，只要一瞬间！"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.REVIVEROCKET= "点了这个，就能还阳吗？"
STRINGS.NAMES.LITTLEMATCH= "小火柴"
STRINGS.RECIPE_DESC.LITTLEMATCH = "地府特制小火柴。"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LITTLEMATCH= "我可以寄快递了！"
STRINGS.CHARACTERS.GENERIC.ANNOUNCE_MATCH_OUT= "灭掉了！"
STRINGS.NAMES.TIANLUHAT= "天禄帽"
STRINGS.RECIPE_DESC.TIANLUHAT = "感觉就像是戴了貔貅一样。"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TIANLUHAT= "有一股狗味……"
STRINGS.NAMES.SHADOWHELMET= "暗影胄"
STRINGS.RECIPE_DESC.SHADOWHELMET = "普通的头盔。"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SHADOWHELMET= "头发可以穿过它！"
STRINGS.NAMES.BIXIEHAT= "辟邪帽"
STRINGS.FEED_PIXIU = "喂养"
STRINGS.RECIPE_DESC.BIXIEHAT = "感觉就像是戴了貔貅一样。"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BIXIEHAT= "妖魔鬼怪快离开！"
STRINGS.NAMES.QIONGQIBAO= "穷奇宝"
STRINGS.RECIPE_DESC.QIONGQIBAO = "会逃跑的穷奇暖手宝(目前不会)。" --逃跑？不存在的。以后有机会再写吧……
STRINGS.CHARACTERS.GENERIC.DESCRIBE.QIONGQIBAO= "热气扑面而来呢！"
STRINGS.NAMES.ICECAKE= "小块冰"
STRINGS.NAMES.DITING_BLOOM_TRACK = "彼岸花"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ICECAKE= "就是小块冰，有什么问题么？"
STRINGS.CHARACTER_SURVIVABILITY.diting = "难呐"

STRINGS.SKIN_NAMES.diting_none = "谛听"
STRINGS.SKIN_NAMES.diting_godmeghost_none = "谛听-非人哉"

STRINGS.SKIN_QUOTES.diting_godmeghost = "\"我来看望先生。\""
STRINGS.SKIN_DESCRIPTIONS.diting_godmeghost = "来自隔壁！"

TUNING.HEALTHCFG = GetModConfigData("healthcfg")
TUNING.DITING_HEALTH = TUNING.HEALTHCFG
TUNING.DITING_HUNGER = 150
TUNING.DITING_SANITY = 150
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.DITING = {"littlematch","amulet"}
TUNING.STARTING_ITEM_IMAGE_OVERRIDE.littlematch = {
    atlas = "images/inventoryimages/littlematch.xml",
    image = "littlematch.tex",
}


-- Custom speech strings  ----人物语言文件  可以进去自定义
STRINGS.CHARACTERS.DITING = require "speech_diting"

-- The character's name as appears in-game  --人物在游戏里面的名字
STRINGS.NAMES.diting = "谛听" 
AddMinimapAtlas("images/map_icons/diting.xml")  --增加小地图图标

--增加人物到mod人物列表的里面 性别为女性（MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL）
AddModCharacter("diting", "MALE") 

STRINGS.CHARACTERS.DITING.DESCRIBE.HELLHOTPOT= "这是地府的招牌美食！"
STRINGS.CHARACTERS.DITING.DESCRIBE.PAWSICLES= "好吃又实惠！"
STRINGS.CHARACTERS.DITING.DESCRIBE.REVIVEROCKET= "准备好了吗？我要点了哦。"
STRINGS.CHARACTERS.DITING.DESCRIBE.LITTLEMATCH= "大火钱快递！"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.DITING = 
{
	GENERIC = "是谛听!",
	ATTACKER = "你在做什么！",
	MURDERER =  "凶手！",
	REVIVER = "欢迎回来！",
	GHOST = "它回去工作了！",
}

local FOODTYPE = GLOBAL.FOODTYPE
FOODTYPE.REDGEM="REDGEM"
FOODTYPE.BLUEGEM="BLUEGEM"
AddPrefabPostInit("redgem", function(inst)  --红宝石可以吃。
       -- inst:AddComponent("edible")
       if not GLOBAL.TheWorld.ismastersim then  
        return inst
       end
        inst.components.edible.secondaryfoodtype = FOODTYPE.REDGEM  --第二种食物类型 是特意给modder留的吗？
        inst.components.edible.foodtype = FOODTYPE.ELEMENTAL  --重复。
        inst.components.edible.healthvalue = 20
        inst.components.edible.hungervalue = 0
        inst.components.edible.sanityvalue = 50
        inst.components.edible.temperaturedelta = TUNING.HOT_FOOD_WARMING_THRESHOLD
        inst.components.edible.temperatureduration = TUNING.BUFF_FOOD_TEMP_DURATION
    end)
AddPrefabPostInit("bluegem", function(inst)  --蓝宝石可以吃。
       -- inst:AddComponent("edible")
       if not GLOBAL.TheWorld.ismastersim then  
        return inst
       end
        inst.components.edible.secondaryfoodtype = FOODTYPE.BLUEGEM 
        inst.components.edible.foodtype = FOODTYPE.ELEMENTAL
        inst.components.edible.healthvalue = 20
        inst.components.edible.hungervalue = 0
        inst.components.edible.sanityvalue = 50
    end)
AddComponentPostInit("eater", function(self)   --API eater 添加吃宝石
        self.CanEatGems = function(self)
            table.insert(self.preferseating, FOODTYPE.REDGEM)  --prefers eating??
            table.insert(self.caneat, FOODTYPE.REDGEM)
            self.inst:AddTag(FOODTYPE.REDGEM.."_eater")
            table.insert(self.preferseating, FOODTYPE.BLUEGEM)
            table.insert(self.caneat, FOODTYPE.BLUEGEM)
            self.inst:AddTag(FOODTYPE.BLUEGEM.."_eater")
        end
    end)
--[[AddPrefabPostInit("rocky", function(inst)  --加上一点由于上述重新定义宝蓝宝石食物类型的缘故导致无法用红蓝宝石喂养石虾。（不过我觉得没人会这么做，谁知道呢）
    if not GLOBAL.TheWorld.ismastersim then  --一个困扰很久的问题。用local TheWorld = GLOBAL.TheWorld 会报错
        return inst
    end

    local function ShouldAcceptItem(inst, item)
        return item.components.edible ~= nil and (item.components.edible.foodtype == FOODTYPE.ELEMENTAL or item.components.edible.foodtype == FOODTYPE.REDGEM or item.components.edible.foodtype == FOODTYPE.BLUEGEM)
    end
    local function OnGetItemFromPlayer(inst, giver, item)
        if item.components.edible ~= nil and
        (item.components.edible.foodtype == FOODTYPE.ELEMENTAL or item.components.edible.foodtype == FOODTYPE.REDGEM or item.components.edible.foodtype == FOODTYPE.BLUEGEM) and
            item.components.inventoryitem ~= nil and
            (   --make sure it didn't drop due to pockets full
                item.components.inventoryitem:GetGrandOwner() == inst or
                --could be merged into a stack
                (   not item:IsValid() and
                    inst.components.inventory:FindItem(function(obj)
                        return obj.prefab == item.prefab
                            and obj.components.stackable ~= nil
                            and obj.components.stackable:IsStack()
                    end) ~= nil)
            ) then
            if inst.components.combat:TargetIs(giver) then
                inst.components.combat:SetTarget(nil)
            elseif giver.components.leader ~= nil then
                if giver.components.minigame_participator == nil then
                    giver:PushEvent("makefriend")
                    giver.components.leader:AddFollower(inst)
                end
                inst.components.follower:AddLoyaltyTime(
                    giver:HasTag("polite")
                    and TUNING.ROCKY_LOYALTY + TUNING.ROCKY_POLITENESS_LOYALTY_BONUS
                    or TUNING.ROCKY_LOYALTY
                )
                inst.sg:GoToState("rocklick")
            end
        end
        if inst.components.sleeper:IsAsleep() then
            inst.components.sleeper:WakeUp()
        end
    end
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
end)  ]]
AddPrefabPostInit("beefalo", function(inst)
    if inst.components and inst.components.eater then
        local OldOnEat = inst.components.eater.oneatfn  --加上这个才有吃东西的动画，不然牛只瞪大眼睛看着你，喂东西的效果在，就是不张嘴。
        inst.components.eater:SetOnEatFn(function(inst,food)         
        	if food:HasTag("hellhotpot") then  
                inst.components.lootdropper:SpawnLootPrefab("horn")    --辣到掉角
                inst.components.lootdropper:SpawnLootPrefab("horn")
            end
            OldOnEat(inst,food) 
         end)
    end
end)
AddPrefabPostInit("nightlight", function(inst)   --小玩意儿
    inst:AddTag("nightlight")
end)
AddComponentPostInit("temperature", function(self)   --不会过热
    self.CannotOverHeated = function(self)
        self.maxtemp = TUNING.MAX_ENTITY_TEMP-30
    end  
end)
AddComponentPostInit("inventoryitem", function(self)   --穷奇宝小功能
    local old = self.OnRemoved
    self.OnRemoved = function(self,...)
        if self.owner and self.owner:HasTag("diting") then
            if self.inst.prefab == "qiongqibao" then
                --self.owner.components.talker:Say("东西掉了")
                self.owner:PushEvent("donnothaveqiongqibao")
            end
        end
        return old(self,...)
    end  
end)

local Pixiufoods = {"goldnugget","thulecite_pieces","redgem","bluegem","purplegem","thulecite","greengem","orangegem","yellowgem","opalpreciousgem","nightmarefuel"}
for k,v in pairs(Pixiufoods) do            --也许要把金弹弹加进来。
    AddPrefabPostInit(v, function(inst)   --貔貅食物
        inst:AddComponent("pixiufood")
        if k<3 then
             inst.components.pixiufood.value = 1
             else if k<5 then
                inst.components.pixiufood.value = 2
             else if k<11 then
                inst.components.pixiufood.value = 4
                 else 
                     inst.components.pixiufood.value = 0.8
                     inst.components.pixiufood.foodtype = "bixiefood"
                 end
            end
        end
    end)
end
local FEED_PIXIU = Action({ mount_valid=true, encumbered_valid=true })	
FEED_PIXIU.id = "FEED_PIXIU"
FEED_PIXIU.str = "喂养"
FEED_PIXIU.fn = function(act)
    if act.target ~= nil and act.target.components.armor ~= nil and act.invobject then
        local value = act.invobject.components.pixiufood.value
        act.target.components.armor:SetCondition(act.target.components.armor.condition+250*value)
        if act.doer and act.doer.entity:IsVisible() then 
            act.doer:PushEvent("feedincontainer")  
        end
		if act.invobject.components.stackable ~= nil then
			act.invobject.components.stackable:Get():Remove()
		else
			act.invobjectm:Remove()
		end
		return true
    end
end

GLOBAL.ALLFIREPITS = {}
AddPrefabPostInit("firepit",function(inst)
    table.insert(GLOBAL.ALLFIREPITS,inst)
    inst:ListenForEvent("onremove",function(inst)   --还有浪费空间的快速移除法。。。打表万岁。。。
        local index = nil                           --如果以后卡的话。。。再优化。。。实际上一把游戏的篝火应该也不会到10000啊啥的吧
	    for i,v in ipairs(GLOBAL.ALLFIREPITS) do
	    	if v == inst then
	    		index = i
	    		break
	    	end
	    end
	    if index then table.remove(GLOBAL.ALLFIREPITS, index) end
    end)
end)

AddPlayerPostInit(function(inst)    --大火钱快递 脏
    inst._showbuttom = net_bool(inst.GUID, "player._showbuttom", "showbuttomdirty")
    inst._csplayer = net_bool(inst.GUID, "player._csplayer", "csplayer")
    inst._csfirepit = net_bool(inst.GUID, "player._csfirepit", "csfirepit")
    inst._csplayer:set(false)
    inst._csfirepit:set(false)
end)

AddAction(FEED_PIXIU)
AddComponentAction("USEITEM", "pixiufood" , function(inst, doer, target, actions, right)   --如果可执行，就会提示。
    if right then
        if inst.components.pixiufood.foodtype == "tianlufood" and target:HasTag("tianluhat") then
             table.insert(actions, ACTIONS.FEED_PIXIU)
        elseif inst.components.pixiufood.foodtype == "bixiefood" and target:HasTag("bixiehat") then
                table.insert(actions, ACTIONS.FEED_PIXIU)
        end
    end
end)
AddStategraphActionHandler("wilson",ActionHandler(ACTIONS.FEED_PIXIU, "dolongaction"))
AddStategraphActionHandler("wilson_client",ActionHandler(ACTIONS.FEED_PIXIU, "dolongaction"))

AddAction("TRANSMIT","烧",function(act)
    if act.doer and act.doer.entity:IsVisible() then
     act.invobject.components.transmit:trans(act.invobject,act:GetActionPoint(), act.doer)
     return true
    end
end)
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.TRANSMIT, "give"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.TRANSMIT, "give"))
AddComponentAction("POINT", "transmit", function(inst, doer, pos,actions, right)
    if right and doer.cdtimetime == nil then
             table.insert(actions, ACTIONS.TRANSMIT)
    end
end)
--辨听万物
AddAction("LISTENING","千里追位",function(act)
    if act.doer and act.doer.entity:IsVisible() then
        if act.doer.components and act.doer.components.sanity:GetPercent()<0.25 then 
            act.doer.components.talker:Say("我状态不好！")
            return true
        end
        if act.doer.components and act.doer.components.hunger:GetPercent()<0.35 then 
            act.doer.components.talker:Say("我状态不好！")
            return true
        end
        local pos = act.doer:GetPosition() 
        SpawnPrefab("sand_puff_large_front").Transform:SetPosition(pos.x, pos.y, pos.z)
        act.target.components.listening:trans(act.doer)
          return true
    end
end)
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.LISTENING, "give"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.LISTENING, "give"))
AddComponentAction("SCENE", "listening", function(inst, doer,actions, right)
   if doer and doer:HasTag("player") then
        if inst and inst.components.listening ~= nil then
            table.insert(actions, ACTIONS.LISTENING)
       end
   end
end)

local ditingui = require("widgets/ditingui")
local listenfx = require("widgets/listenfx")
local transmitchoose = require("widgets/transmitchoose")
local function Addditingui(self) 
	if self.owner and self.owner:HasTag("diting")   then
        self.ditingui = self:AddChild(ditingui(self.owner))	
		self.owner:DoTaskInTime(0.5, function()      --自动调整位置，nb
			local x1 ,y1,z1 = self.stomach:GetPosition():Get()
			local x2 ,y2,z2 = self.brain:GetPosition():Get()		
			local x3 ,y3,z3 = self.heart:GetPosition():Get()		
			if y2 == y1 or  y2 == y3 then --开了三维mod
				self.ditingui:SetPosition(self.stomach:GetPosition() + Vector3(x1-x2, 0, 0))
				self.boatmeter:SetPosition(self.moisturemeter:GetPosition() + Vector3(x1-x2, 0, 0))
			else
                self.ditingui:SetPosition(self.stomach:GetPosition() + Vector3(x1-x3, -4, 0))
			end
		end)

	end
	
	local old_SetGhostMode = self.SetGhostMode  
	function self:SetGhostMode(ghostmode,...)
		old_SetGhostMode(self,ghostmode,...)
		if ghostmode then		
			if self.ditingui ~= nil then 
				self.ditingui:Hide()
			end	
		else
			if self.ditingui ~= nil then
				self.ditingui:Show()
			end
		end
	end
end

local function Addlistenfx(self)
    if self.owner and self.owner:HasTag("diting")   then
        self.listenfx = self:AddChild(listenfx(self.owner))	
        self.listenfx:SetHAnchor(0)
        self.listenfx:SetVAnchor(0)
        self.listenfx:SetPosition(0,0,0)
    end
end

local function Addtransmitchoose(self)
    if self.owner then
        self.transmitchoose = self:AddChild(transmitchoose(self.owner))	
        self.transmitchoose:SetHAnchor(0)
        self.transmitchoose:SetVAnchor(0)
        self.transmitchoose:SetPosition(0,250,0)
        self.transmitchoose:Hide()
        self.owner:ListenForEvent("showbuttomdirty", function(inst)
            if self.owner and not self.owner:HasTag("playerghost") then
                self.transmitchoose:Show()
                self.owner:DoTaskInTime(3,function() 
                    self.transmitchoose:Hide()
                    self.owner._showbuttom:set_local(false)
                    self.owner._csplayer:set(false)
                    self.owner._csfirepit:set(false)
                end)	
            end
        end)
    end
end

AddClassPostConstruct("widgets/statusdisplays", Addditingui)  --添加徽章。
AddClassPostConstruct("widgets/statusdisplays", Addlistenfx)  --添加特效。 --也许有不覆盖物品栏的widget。
AddClassPostConstruct("widgets/statusdisplays", Addtransmitchoose)  --添加按钮，statusdisplays我也不知道为啥。
-- 这个函数是官方的MOD API，用于修改游戏中的类的构造函数。第一个参数是类的文件路径，根目录为scripts。第二个自定义的修改函数，第一个参数固定为self，指代要修改的类。
--from longfei
--添加状态

--辨听万物
--ui  from myth

GLOBAL.DITINGINDICATORS = {}    --这里会存有indtargets中的inst，活着即存在。1 }
GLOBAL.LISTENFLAG = {}
local TAILONLAND = 35  --1 -- 32 
local HEADINCAVE = 33  --26 -- #GLOBAL.DITINGINDICATORS(37)
local IndTargets={-- 第33个生物为地洞生物
    "pigman","pigking","walrus_camp","knight",
    "bishop","rook" ,"antlion","spiderqueen","catcoon","beefalo","koalefant_summer","koalefant_winter","tallbird",
    "lightninggoat","deer","mandrake","moose","mossling","chester_eyebone","deerclops",
    "bearger","dragonfly","beequeenhive","crabking","hermitcrab","glommer","leif","frog","perd","moonspiderden",
    "houndmound","fruitdragon",
    --地上
    "bat", "bunnyman","spiderden",
    --
    "toadstool_cap","hutch_fishbowl",
    "slurper", "worm",  "bishop_nightmare", "rook_nightmare", "knight_nightmare", "monkey", "rocky",
    "minotaur","tentacle_pillar","slurtlehole",--暂时这么多生物，蜘蛛就免了。
}

GLOBAL.LISTENSOUND={
    "dontstarve/pig/oink",  --猪人 地上
    "dontstarve/pig/PigKingHappy", --猪王 地上
    "dontstarve/creatures/mctusk/taunt", --海象 地上
    "dontstarve/creatures/knight/voice",  --齿轮马 地上
    "dontstarve/creatures/bishop/shoot",   --主教  地上
    "dontstarve/creatures/rook/explo",    --战车 地上
    "dontstarve/creatures/together/antlion/swallow",   --蚁狮 地上
    "dontstarve/creatures/spiderqueen/scream_short", --蜘蛛女王 地上
    "dontstarve_DLC001/creatures/catcoon/hiss_pre",  --猫  地上
    "dontstarve/beefalo/yell",  --牛 地上
    "dontstarve/creatures/koalefant/shake", --大象 地上
    "dontstarve/creatures/koalefant/shake", --大象 地上
    "dontstarve/creatures/tallbird/chirp",  --高脚鸟 地上
    "dontstarve_DLC001/creatures/lightninggoat/taunt",  --羊 地上
    "dontstarve/creatures/together/deer/curious", --鹿 地上
    "dontstarve/creatures/mandrake/pullout", --曼德拉（好可爱的叫声- -） 地上
    "dontstarve_DLC001/creatures/moose/taunt",--麋鹿鹅 地上
    "dontstarve_DLC001/creatures/mossling/eat", --小鹅 地上
    "dontstarve/creatures/chester/lick", --切斯特 地上
    "dontstarve/creatures/deerclops/taunt_howl", --巨鹿 地上
    "dontstarve_DLC001/creatures/bearger/taunt", --熊 地上
    "dontstarve_DLC001/creatures/dragonfly/angry", --龙蝇 地上
    "dontstarve/creatures/together/bee_queen/taunt", --女王蜂 地上
    "hookline_2/creatures/boss/crabking/inert_hide", --帝王蟹 地上（海里非冬勿传）
    "hookline_2/characters/hermit/talk",  --寄居蟹 地上
    "dontstarve_DLC001/creatures/glommer/idle_voice", --格罗姆 地上 NEW
    "dontstarve/creatures/leif/attack_VO", --树精 地上 NEW
    --ThePlayer.SoundEmitter:PlaySound("dontstarve/bee/bee_fly_LP")-- 杀人蜂放弃根本停不下来
    "dontstarve/frog/walk", --青蛙 地上 NEW
    "dontstarve/creatures/perd/gobble", --火鸡 地上 NEW
    --新增
    "turnoftides/creatures/together/spider_moon/scream",  --月岛蜘蛛巢 地上 NEW
    "dontstarve/creatures/hound/bark", --猎狗丘 地上 NEW
    "turnoftides/creatures/together/fruit_dragon/hit",  --沙拉曼蛇 地上 NEW

    
    "dontstarve/creatures/bat/taunt",  --蝙蝠 地上--洞穴
    "dontstarve/creatures/bunnyman/idle_med",   --兔人  洞穴 地上--洞穴
    "dontstarve/creatures/spider/scream", --蜘蛛巢  洞穴 地上 NEW

    "dontstarve/creatures/together/toad_stool/roar",  --蛤蟆 洞穴
    "dontstarve/creatures/together/hutch/open",   --哈奇 洞穴
    "dontstarve/creatures/slurper/taunt",   --餟食者  洞穴
    "dontstarve/creatures/worm/eat",   --蠕虫 洞穴
    "dontstarve/creatures/bishop/shoot",   --主教 洞穴
    "dontstarve/creatures/rook/explo",  --战车 洞穴
    "dontstarve/creatures/knight/voice",   --齿轮马 洞穴
    "dontstarve/creatures/monkey/taunt", --猴子  洞穴
    "dontstarve/creatures/rocklobster/taunt", --龙虾 洞穴
    "dontstarve/creatures/rook_minotaur/voice", --犀牛  洞穴
    "dontstarve/tentacle/tentacle_emerge", --大触手 洞穴 NEW
    "dontstarve/creatures/slurtle/idle", --蜗牛 洞穴 NEW
    --暂时这么多生物，蜘蛛就免了。
}

local function SetupDitingIndicator(inst,i)
    if GLOBAL.DITINGINDICATORS[i] == nil then   --插入总指示表
        GLOBAL.DITINGINDICATORS[i] = {}
    end
    table.insert(GLOBAL.DITINGINDICATORS[i],inst)
    inst:ListenForEvent("onremove",function(int)
	    local index = nil
	    for _,v in ipairs(GLOBAL.DITINGINDICATORS[i]) do
	    	if v == inst then
	    		index = _
	    		break
	    	end
	    end
        if index then 
            table.remove(GLOBAL.DITINGINDICATORS[i], index) 
        end
    end)
end

for i,v in ipairs(IndTargets) do
	AddPrefabPostInit(v, function(inst)
		SetupDitingIndicator(inst,i)
	end)
end

--传送花
local function ArrowFx(inst)
    if inst._listen:value() == true then
    local fx = SpawnPrefab("diting_bloom_track")
    local fx2 = SpawnPrefab("small_puff")
    local x, y, z = inst.Transform:GetWorldPosition()
    local map = GLOBAL.TheWorld.Map
    local pt = Vector3(0, 0, 0) 
    local offset = FindValidPositionByFan(  
            math.random() * 6,   --相当于offset.x？
            math.random() * 1,  --相当于offset.z？
            3,
            function(offset)
                pt.x = x + offset.x
                pt.z = z + offset.z
                local tile = map:GetTileAtPoint(pt:Get()) --pt即为实体产生的地点
                return 
                     tile ~= GROUND.IMPASSABLE  
                    and tile ~= GROUND.INVALID     --有时间找找海面
                    and map:IsDeployPointClear(pt, nil, .5)
                    and not map:IsPointNearHole(pt, .4)
            end
        )
        if offset ~= nil then
        fx.Transform:SetPosition(x + offset.x+1, 0, z + offset.z+1)
        fx2.Transform:SetPosition(x + offset.x+1, 0, z + offset.z+1)
        local rnd = math.random(1,4)
        fx:SetVariation(rnd)
        fx.components.listening:getposition()
        end
    end
end
--local listenSound={}
--for i=1,34 do
 --[[   local str = IndTargets[i]
    listenSound[str] = SoundAdd[i]
end
local str = "chess"
listenSound[str] =SoundAdd[5]
local function listen_bloom(inst)
    if mark<=#listentg then
        local bloom = GLOBAL.SpawnPrefab("diting_bloom_track")
        local x,y,z = listentg[mark]:Get()
        local ix,iy,iz = inst:GetPosition():Get()
        local dx,dz = x- ix, z - iz
        local dissq = inst:GetDistanceSqToPoint(x,y,z)
        local tx,ty,tz
        if dissq <=250 *250 then
            tx,ty,tz = ix + math.sqrt(dx*dx/dissq), iy, iz + math.sqrt(dz*dz/dissq)
        else
            local rate = math.sqrt(dissq) / 250
            tx,ty,tz = ix + dx*rate, iy, iz + dz*rate
        end
        bloom.Transform:SetPosition(tx,ty,tz)]]
      --  bloom.SoundEmitter:PlaySound(listenSound[listentg_name[mark]])
      --  mark = mark +1
   -- end
--end
AddStategraphState('wilson',
    State{
        name = "diting_listen",
        tags = { "busy", "diting_listen", "pausepredict"},
		
        onenter = function(inst, data)
            inst.components.locomotor:Stop() --止步
            inst.components.hunger:DoDelta(-10)
            inst.components.sanity:DoDelta(-10)
            inst.AnimState:PlayAnimation("listen", false)  --播放动作
			if inst.components.playercontroller ~= nil then         --疑
                inst.components.playercontroller:RemotePausePrediction()
            end
            inst._listen:set(true)
            inst.listeningcd = true
            GLOBAL.LISTENFLAG = {}
            if GLOBAL.TheWorld:HasTag("cave") then
                for i = HEADINCAVE,#IndTargets do
                    table.insert(GLOBAL.LISTENFLAG,i)
                end
            else
                for i=1,TAILONLAND do
                    table.insert(GLOBAL.LISTENFLAG,i)
                end
            end
		end,
			
		timeline =
			{
                TimeEvent(1,ArrowFx),
				TimeEvent(1, function(inst)   --在1秒后可以被打断。
                    inst.sg:RemoveStateTag("pausepredict")
                    inst.sg:RemoveStateTag("busy")
                end),
                TimeEvent(5,ArrowFx),
                TimeEvent(10,ArrowFx),
                TimeEvent(15,ArrowFx),
                TimeEvent(20,ArrowFx),
                TimeEvent(25,function(inst)
                    inst.sg:GoToState("idle")
                end),
		},

		events =
			{
				EventHandler("animover", function(inst)
					if inst.AnimState:AnimDone() then
						inst.AnimState:PlayAnimation("listenidle", true)
                    end
				end),
        },
         onexit = function(inst)  --状态结束应该做什么。
            inst._listen:set(false)
            inst:DoTaskInTime(10,function(inst) if inst then inst.listeningcd = false end end)
        end,
	}
)

--免疫硬直，from myth
AddStategraphPostInit("wilson", function(sg)
    local old_onattacked = sg.events['attacked'].fn
    sg.events['attacked'] = EventHandler('attacked', function(inst,data,...)
        if inst:HasTag("diting") and inst.BodhisattvaBlessing == true then
            inst.BodhisattvaBlessing = false
            if not inst.sg:HasStateTag('frozen') and not inst.sg:HasStateTag('sleeping') then
                return
            end
        end     
        return old_onattacked(inst,data,...)
    end)
end)

--接口，通过徽章触发状态。
local function Listening(inst)
	if inst:HasTag("playerghost") or not inst:HasTag("diting") then return end
    if not inst.sg or inst.sg:HasStateTag("diting_listen") or inst.sg:HasStateTag("busy") then return end
    if inst.listeningcd then return end
	if not (inst.components.playercontroller and inst.components.playercontroller:IsEnabled()) then return end
	inst.sg:GoToState("diting_listen")
end
AddModRPCHandler("diting", "listenforeverything", Listening)

-- local function draw(inst)
	-- if inst.components.drawable then
		-- local oldondrawnfn = inst.components.drawable.ondrawnfn or nil
		-- inst.components.drawable.ondrawnfn = function(inst, image, src)
			-- if oldondrawnfn ~= nil then
				  -- oldondrawnfn(inst, image, src)
			-- end

			-- if image ~= nil and wolverine_item[image] ~= nil then
				  -- inst.AnimState:OverrideSymbol("SWAP_SIGN", resolvefilepath("images/inventoryimages/"..image..".xml"), image..".tex")
			-- end
		-- end
	-- end
-- end


  
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
			for i,name in ipairs(PREFAB_SKINS["diting"]) do
				BaseSort[name] = i
			end
		end
		if item_a and item_b and BaseSort[item_a] and BaseSort[item_b] then
			return BaseSort[item_a] < BaseSort[item_b]
		end
		return thisfunc(item_a,item_b,...)
	end
end



-- AddPrefabPostInit("minisign", draw)
-- AddPrefabPostInit("minisign_drawn", draw)
-- sunriver  debug
--modimport("scripts/make_skins")
