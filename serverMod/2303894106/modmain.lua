GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

local containers = require("containers")
require("prefabs/veggies")

PrefabFiles = {
    "jinkela",
    "jinkela_ash",
    "jinkela_machine",
    "fx_harvest",
    "fx_trans",
    "fx_shoplight",
    "fx_shopnote",
    "well",
}

Assets = {
    Asset("ATLAS", "images/minimap/jinkela_machine_mini.xml"),
    Asset("IMAGE", "images/minimap/jinkela_machine_mini.tex"),
    Asset("ATLAS", "images/minimap/auto_seeding_machine_mini.xml"),
    Asset("IMAGE", "images/minimap/auto_seeding_machine_mini.tex"),
    Asset("ATLAS", "images/minimap/auto_harvest_machine_mini.xml"),
    Asset("IMAGE", "images/minimap/auto_harvest_machine_mini.tex"),
    Asset("ATLAS", "images/minimap/shop_mini.xml"),
    Asset("IMAGE", "images/minimap/shop_mini.tex"),
    Asset("ATLAS", "images/minimap/well_mini.xml"),
    Asset("IMAGE", "images/minimap/well_mini.tex"),
    Asset("ANIM", "anim/ui_seeding_1x1.zip"),
}

-----------------判断是否测试版(新农场)----------------
if TUNING.FARM_TILL_SPACING ~= nil then
    TUNING.IS_NEW_AGRICULTURE = true
else TUNING.IS_NEW_AGRICULTURE = false
end
--------------兼容其他mod特殊作物--------------
_G.CONFIGS_EA =
{
    ENABLEDMODS = {},
}

--棱镜
_G.CONFIGS_EA.ENABLEDMODS.legion = _G.KnownModIndex:IsModEnabled("workshop-1392778117") and TUNING.LEGION_NEWCROPS
TUNING.EA_LEGION_ITEM =
{
    pineananas = "pineananas",
    catmint = "catmint",
}

--------------获取用户数据--------------

TUNING.EA_MAX_ACCEPT_ITEM_NUM = GetModConfigData('max store num')
TUNING.EA_PRICE_COEFFICIENT = GetModConfigData('coefficient of price')
TUNING.EA_REFRESH_FREQUENCY = GetModConfigData('refresh frequency')
TUNING.EA_ADDED_HARVEST = GetModConfigData('harvest machine')
TUNING.EA_ADDED_SEEDING = GetModConfigData('seeding machine')
TUNING.EA_ADDED_VENDING = GetModConfigData('vending machine')

--------------加入机器prefab------------

if TUNING.EA_ADDED_HARVEST then
    table.insert(PrefabFiles,"auto_harvest_machine")
end
if TUNING.EA_ADDED_SEEDING then
    table.insert(PrefabFiles,"auto_seeding_machine")
end
if TUNING.EA_ADDED_VENDING then
    table.insert(PrefabFiles,"shop")
end

----------------设置语言----------------
local MOD_LANGUAGE_SETTING = "CHINESE"

if GetModConfigData('Language') ~= 'AUTO' then     --不是自动则为玩家设置的语言
	MOD_LANGUAGE_SETTING = GetModConfigData('Language')
else    --否则检测系统语言，根据系统语言设置
	local loc = require "languages/loc"
	local lan = loc and loc.GetLanguage and loc.GetLanguage()
	if lan == LANGUAGE.CHINESE_S or lan == LANGUAGE.CHINESE_S_RAIL then
		MOD_LANGUAGE_SETTING = "CHINESE"
	else
		MOD_LANGUAGE_SETTING = "ENGLISH"
	end
end

GLOBAL.MOD_LANGUAGE_SETTING = MOD_LANGUAGE_SETTING

if MOD_LANGUAGE_SETTING == "CHINESE" then
	modimport("scripts/languages/strings_chs.lua")
else
	modimport("scripts/languages/strings_en.lua")
end


-----------------配方部分----------------

AddRecipe2("jinkela",
{Ingredient("jinkela_ash", 8, "images/inventoryimages/jinkela_ash.xml"), Ingredient("goldnugget", 1)},
    TECH.SCIENCE_ONE,
    {
        atlas = "images/inventoryimages/jinkela.xml",
        image = "jinkela.tex",
    },
    {CRAFTING_FILTERS.GARDENING.name}
)

AddRecipe2("jinkela_machine",
    {Ingredient("boards", 2), Ingredient("transistor", 2), Ingredient("cutstone", 2)},
    TECH.SCIENCE_ONE,
    {
        atlas = "images/inventoryimages/jinkela_machine.xml",
        image = "jinkela_machine.tex",
        placer = "jinkela_machine_placer",
        min_spacing = 1.5,
    },
    {CRAFTING_FILTERS.GARDENING.name}
)

if TUNING.EA_ADDED_SEEDING then
    AddRecipe2("auto_seeding_machine",
        {Ingredient("gears", 1), Ingredient("transistor", 4), Ingredient("seeds", 4)},
        TECH.SCIENCE_TWO,
        {
            atlas = "images/inventoryimages/auto_seeding_machine.xml",
            image = "auto_seeding_machine.tex",
            placer = "auto_seeding_machine_placer",
            min_spacing = 1.5,
        },
        {CRAFTING_FILTERS.GARDENING.name}
    )
end

if TUNING.EA_ADDED_HARVEST then
    AddRecipe2("auto_harvest_machine",
        {Ingredient("boards", 2), Ingredient("transistor", 1)},
        TECH.SCIENCE_TWO,
        {
            atlas = "images/inventoryimages/auto_harvest_machine.xml",
            image = "auto_harvest_machine.tex",
            placer = "auto_harvest_machine_placer",
            min_spacing = 2,
        },
        {CRAFTING_FILTERS.GARDENING.name}
    )
end

if TUNING.EA_ADDED_VENDING then
    AddRecipe2("shop",
        {Ingredient("boards", 5), Ingredient("transistor", 4)},
        TECH.SCIENCE_TWO,
        {
            atlas = "images/inventoryimages/shop.xml",
            image = "shop.tex",
            placer = "shop_placer",
            min_spacing = 4,
        },
        {CRAFTING_FILTERS.GARDENING.name}
    )
end

AddRecipe2("well",
    {Ingredient("cutstone", 8), Ingredient("boards", 4)},
    TECH.SCIENCE_ONE,
    {
        atlas = "images/inventoryimages/well.xml",
        image = "well.tex",
        placer = "well_placer",
        min_spacing = 4,
    },
    {CRAFTING_FILTERS.GARDENING.name}
)


-----------------小地图logo-----------------
AddMinimapAtlas("images/minimap/jinkela_machine_mini.xml")  --注册地图图标
AddMinimapAtlas("images/minimap/auto_seeding_machine_mini.xml")  --注册地图图标
AddMinimapAtlas("images/minimap/auto_harvest_machine_mini.xml")  --注册地图图标
AddMinimapAtlas("images/minimap/shop_mini.xml")  --注册地图图标
AddMinimapAtlas("images/minimap/well_mini.xml")  --注册地图图标


---------------容器widget注册---------------
local params = {}

local containers_widgetsetup = containers.widgetsetup or function() return true end
function containers.widgetsetup(container, prefab, data, ...)
	local pfb = prefab or container.inst.prefab
	if pfb == "auto_seeding_machine" or pfb == "auto_harvest_machine" or pfb == "jinkela_machine" then
		local pfbw = params[pfb]
		if pfbw ~= nil then
			for k, v in pairs(pfbw) do
				container[k] = v
			end
			container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
		end
	else
		-- 针对游戏内容器，用原始的函数来处理
		return containers_widgetsetup(container, prefab, data, ...)
	end
end

params.auto_seeding_machine =
{
    widget = {
        slotpos = {Vector3(0,40,0)},
        animbank = "ui_seeding_1x1",
        animbuild = "ui_seeding_1x1",
        pos = Vector3(0,0,0),
        buttoninfo = {
            text = STRINGS.SEED_BUTTOM,
            position = Vector3(0, -20, 0),
        },
    },
    numslots=1,
    acceptsstacks=true,
    usespecificslotsforitems=false,
    issidewidget=false,
    type="seeding",
    itemtestfn = function(inst, item, slot)
        if item:HasTag("deployedplant") and item:HasTag("cookable") and item.prefab~="acorn" then
            return true
        else return false
        end
    end
}
function auto_seeding_machineFn(player,inst)
    inst.components.container:Close(inst.owner)
    inst.checkforfarm(inst, player)
end
function auto_seeding_machine_validFn(player,inst)
    if not inst.components.container:IsEmpty() then
        inst.isvalid:set(true)
        return true
    else    
        inst.isvalid:set(false)
        return false
    end
end
function params.auto_seeding_machine.widget.buttoninfo.fn(inst)
    if TheWorld.ismastersim then
        auto_seeding_machineFn(ThePlayer, inst)
    else
        SendModRPCToServer(MOD_RPC["auto_seeding_machine"]["auto_seeding_machineFn"], inst)
    end
end
function params.auto_seeding_machine.widget.buttoninfo.validfn(inst)
    if TheWorld.ismastersim then
        return auto_seeding_machine_validFn(nil,inst)
    else
        SendModRPCToServer(MOD_RPC["auto_seeding_machine"]["auto_seeding_machine_validFn"], inst)
        return inst.isvalid:value()
    end
end
AddModRPCHandler("auto_seeding_machine", "auto_seeding_machineFn", auto_seeding_machineFn)
AddModRPCHandler("auto_seeding_machine", "auto_seeding_machine_validFn", auto_seeding_machine_validFn)

params.jinkela_machine =
{
    widget = {
        slotpos = {Vector3(0,40,0)},
        animbank = "ui_cookpot_1x2",
        animbuild = "ui_cookpot_1x2",
        pos = Vector3(0,0,0),
        buttoninfo = {
            text = STRINGS.JINKELA_BUTTOM,
            position = Vector3(0, -20, 0),
        },
    },
    numslots=1,
    acceptsstacks=true,
    usespecificslotsforitems=false,
    issidewidget=false,
    type="seeding",
}
function jinkela_machineFn(player,inst)
    inst.components.container:Close(inst.owner)
    inst.onproduce(inst, player)
end
function jinkela_machine_validFn(player,inst)
    if not inst.components.container:IsEmpty() then
        inst.isvalid:set(true)
    else    
        inst.isvalid:set(false)
    end
    return inst.isvalid:value()
end
function params.jinkela_machine.widget.buttoninfo.fn(inst)      --inst:机器实例
    SendModRPCToServer(MOD_RPC["jinkela_machine"]["jinkela_machineFn"], inst)
end
function params.jinkela_machine.widget.buttoninfo.validfn(inst)
    SendModRPCToServer(MOD_RPC["jinkela_machine"]["jinkela_machine_validFn"], inst)
    return inst.isvalid:value()
end
AddModRPCHandler("jinkela_machine", "jinkela_machineFn", jinkela_machineFn)
AddModRPCHandler("jinkela_machine", "jinkela_machine_validFn", jinkela_machine_validFn)

local WEED_DEFS = require("prefabs/weed_defs").WEED_DEFS
params.auto_harvest_machine =
{
    widget = {
        slotpos = { Vector3(-72,72,0),Vector3(0,72,0),Vector3(72,72,0),
                    Vector3(-72,0,0),Vector3(0,0,0),Vector3(72,0,0),
                    Vector3(-72,-72,0),Vector3(0,-72,0),Vector3(72,-72,0)},
        animbank = "ui_chest_3x3",
        animbuild = "ui_chest_3x3",
        pos = Vector3(0,-200,0),
    },
    numslots=9,
    acceptsstacks=true,
    usespecificslotsforitems=false,
    issidewidget=false,
    type="harvest",
    itemtestfn = function(inst, item, slot)
        if VEGGIES[item.prefab] or TUNING.EA_LEGION_ITEM[item.prefab]
        or (item:HasTag("deployedplant") and item:HasTag("cookable") and item.prefab~="acorn") then
            return true
        end
		for weed, data in pairs(WEED_DEFS) do
			if data.product == item.prefab then
				return true
			end
		end
        return false
    end,
}



---------金坷垃可研究(未完成)----------
require("prefabs/fertilizer_nutrient_defs").FERTILIZER_DEFS.jinkela = {nutrients = {8, 8, 8}, uses = TUNING.JINKELA_USES, inventoryimage = "images/inventoryimages/jinkela.tex", name = "JINKELA"}

------------容器组件修改-------------
local function ContainerCanOpenInit(self)
    self.canopen = true
    local old = self.Open
    self.Open = function (self,doer)
        if self.canopen then
            old(self,doer)
        end
    end
end
AddComponentPostInit("container", ContainerCanOpenInit)