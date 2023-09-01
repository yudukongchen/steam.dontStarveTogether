local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
local resolvefilepath = GLOBAL.resolvefilepath
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
Recipe = GLOBAL.Recipe
TECH = GLOBAL.TECH
local ACTIONS = GLOBAL.ACTIONS
local ThePlayer = GLOBAL.ThePlayer
local IsServer = GLOBAL.TheNet:GetIsServer()
local containers = require("containers")

PrefabFiles = {
    "fhl",
    "fhl_zzj",
    "fhl_hsf",
    "fhl_bz",
    "fhl_cake",
    "fhl_x",
    "fhl_cy",
    "personal_licking",
    "personal_licking_eyebone",
    "ancient_soul",
    "ancient_gem",
    "fhl_tree",
    --"krampus_sack",
    "fhl_bb",
}

GLOBAL.TUNING.FHL = {}

GLOBAL.STRINGS.NAMES.ANCIENT_GEM = "耀古之晶"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.ANCIENT_GEM = "我感受到了上古的气息."
GLOBAL.STRINGS.RECIPE_DESC.ANCIENT_GEM = "充斥着澎湃的\n古老的气息"

GLOBAL.STRINGS.NAMES.FHL_TREE = "希雅蕾丝树枝"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_TREE = "我感受到了生命的气息."
GLOBAL.STRINGS.RECIPE_DESC.FHL_TREE = "生命之树的枝条\n恩,有股香蕉的味道."

GLOBAL.STRINGS.NAMES.ANCIENT_SOUL = "符文结晶"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.ANCIENT_SOUL = "这是符文的结晶."
GLOBAL.STRINGS.RECIPE_DESC.ANCIENT_SOUL = "这是符文的结晶"

STRINGS.NAMES.FHL_ZZJ = "金芜菁之杖"
STRINGS.RECIPE_DESC.FHL_ZZJ = "妹子萌萌哒的\n智障剑啊!"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_ZZJ = "胸大无脑的智障剑"

STRINGS.CHARACTER_TITLES.fhl = "风幻龙"
STRINGS.CHARACTER_NAMES.fhl = "风幻龙"
STRINGS.CHARACTER_DESCRIPTIONS.fhl = "*吃火龙果升级! (满级30),移动速度随等级提高加快\n*自带武器金芜菁之杖(附带冰柱/着火特效).\n*是图书管理员的朋友!"
STRINGS.CHARACTER_QUOTES.fhl = "\"守护者风幻龙.\""

STRINGS.NAMES.FHL_HSF = "瑟尔泽的护身符"
STRINGS.RECIPE_DESC.FHL_HSF = "由塞尔泽的羽毛制成\n守护持有者"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_HSF = "这是守护者的神器啊!"

STRINGS.NAMES.FHL_BZ = "彩虹糕"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_BZ = "这是传说中的彩虹糕啊"
STRINGS.RECIPE_DESC.FHL_BZ = "美味可口的彩虹糕"

STRINGS.NAMES.FHL_CAKE = "南瓜布丁"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_CAKE = "看上去似乎很美味."
STRINGS.RECIPE_DESC.FHL_CAKE = "简单的点心"

STRINGS.NAMES.FHL_X = "黑夜祝福X型"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_X = "这是...一瓶药水?"
STRINGS.RECIPE_DESC.FHL_X = "黑夜中散发着迷人\n的清香"

STRINGS.NAMES.FHL_CY = "放松茶叶"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_CY = "looks great."
STRINGS.RECIPE_DESC.FHL_CY = "回复生命和脑力的\n饮品"

STRINGS.NAMES.PERSONAL_LICKING = "风幻的宝宝"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PERSONAL_LICKING = "这是......葫芦娃?"
STRINGS.NAMES.PERSONAL_LICKING_EYEBONE = "风幻的铃铛"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PERSONAL_LICKING_EYEBONE = "铃铛的声音很好听."

--GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.KRAMPUS_SACK = "it looks great."
--GLOBAL.STRINGS.RECIPE_DESC.KRAMPUS_SACK = "集冰箱护甲暖石一身的\n高级背包"

STRINGS.NAMES.FHL_BB = "瑟尔泽的背包"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_BB = "it looks great."
STRINGS.RECIPE_DESC.FHL_BB = "集冰箱护甲雨衣于\n一身的高级背包"

-- 人物语言反馈
STRINGS.CHARACTERS.GENERIC.DESCRIBE.fhl =
{
    GENERIC = "这是风幻妹子啊!",
    ATTACKER = "风幻妹妹攻击很强啊...",
    MURDERER = "谋杀啊!",
    REVIVER = "风幻将一生一世守护塞尔菲亚大陆.",
    GHOST = "风幻虽死不悔.",
}

-- 人物的名字出现在游戏中
STRINGS.NAMES.fhl = "风幻龙"

-- 人物说话
STRINGS.CHARACTERS.ESCTEMPLATE = require "speech_fhl"

Assets = {
    --存档界面人物头像
    Asset("IMAGE", "images/saveslot_portraits/fhl.tex"),
    Asset("ATLAS", "images/saveslot_portraits/fhl.xml"),

    --选择人物界面的人物头像
    Asset("IMAGE", "images/selectscreen_portraits/fhl.tex"),
    Asset("ATLAS", "images/selectscreen_portraits/fhl.xml"),
    --人物大图
    Asset("IMAGE", "bigportraits/fhl.tex"),
    Asset("ATLAS", "bigportraits/fhl.xml"),
    --地图上的人物图标
    Asset("IMAGE", "images/map_icons/fhl.tex"),
    Asset("ATLAS", "images/map_icons/fhl.xml"),
    --人物头像
    Asset("IMAGE", "images/avatars/avatar_fhl.tex"),
    Asset("ATLAS", "images/avatars/avatar_fhl.xml"),
    --人物死后图像
    Asset("IMAGE", "images/avatars/avatar_ghost_fhl.tex"),
    Asset("ATLAS", "images/avatars/avatar_ghost_fhl.xml"),
    --剑小图标
    Asset("ATLAS", "images/inventoryimages/fhl_zzj.xml"),
    Asset("IMAGE", "images/inventoryimages/fhl_zzj.tex"),

    Asset("ATLAS", "images/inventoryimages/fhltab.xml"),
    Asset("IMAGE", "images/inventoryimages/fhltab.tex"),

    Asset("ATLAS", "images/inventoryimages/fhl_hsf.xml"),

    Asset("ANIM", "anim/sweet_n_sour.zip"),
    Asset("IMAGE", "images/inventoryimages/fhl_bz.tex"),
    Asset("ATLAS", "images/inventoryimages/fhl_bz.xml"),

    Asset("ANIM", "anim/cake.zip"),
    Asset("IMAGE", "images/inventoryimages/fhl_cake.tex"),
    Asset("ATLAS", "images/inventoryimages/fhl_cake.xml"),

    Asset("ANIM", "anim/dy_x.zip"),
    Asset("IMAGE", "images/inventoryimages/fhl_x.tex"),
    Asset("ATLAS", "images/inventoryimages/fhl_x.xml"),

    Asset("ANIM", "anim/fhl_cy.zip"),
    Asset("IMAGE", "images/inventoryimages/fhl_cy.tex"),
    Asset("ATLAS", "images/inventoryimages/fhl_cy.xml"),

    Asset("ANIM", "anim/ancient_soul.zip"),
    Asset("ATLAS", "images/inventoryimages/ancient_soul.xml"),
    Asset("IMAGE", "images/inventoryimages/ancient_soul.tex"),

    Asset("ANIM", "anim/ancient_gem.zip"),
    Asset("ATLAS", "images/inventoryimages/ancient_gem.xml"),
    Asset("IMAGE", "images/inventoryimages/ancient_gem.tex"),

    Asset("ANIM", "anim/fhl_tree.zip"),
    Asset("ATLAS", "images/inventoryimages/fhl_tree.xml"),
    Asset("IMAGE", "images/inventoryimages/fhl_tree.tex"),

    Asset("ATLAS", "images/inventoryimages/fhl_bb.xml"),
    Asset("IMAGE", "images/inventoryimages/fhl_bb.tex"),

}

--function Addtradableprefab(inst)
--if not inst.components.tradable then
--inst:AddComponent("tradable")
--end end

------------------box


local oldwidgetsetup = containers.widgetsetup
containers.widgetsetup = function(container, prefab)
    if not prefab and container.inst.prefab == "fhl_bb" then
        prefab = "krampus_sack"
    end
    oldwidgetsetup(container, prefab)
end

---------------
--small icebox1
local params = {}
local OVERRIDE_WIDGETSETUP = false
local containers_widgetsetup_base = containers.widgetsetup
function containers.widgetsetup(container, prefab)
    local t = params[prefab or container.inst.prefab]
    if t ~= nil then
        for k, v in pairs(t) do
            container[k] = v
        end
        container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
        if OVERRIDE_WIDGETSETUP then
            container.type = "frostsmall"
        end
    else
        containers_widgetsetup_base(container, prefab)
    end
end

local function frostsmall()
    local container =
    {
        widget =
        {
            slotpos = {},
            animbank = "ui_backpack_2x4",
            animbuild = "ui_chest_frosthammer",
            pos = GLOBAL.Vector3(-5, 100, 0),
            side_align_tip = 160,
        },
        issidewidget = true,
        type = "chest",
    }

    for y = 0, 1 do
        table.insert(container.widget.slotpos, GLOBAL.Vector3(-126, -y * 75 + 114, -126 + 75, -y * 75 + 114))

    end
    return container
end

params.frostsmall = frostsmall()
for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end
local containers_widgetsetup_custom = containers.widgetsetup
local MAXITEMSLOTS = containers.MAXITEMSLOTS
AddPrefabPostInit("world_network", function(inst)
    if containers.widgetsetup ~= containers_widgetsetup_custom then
        OVERRIDE_WIDGETSETUP = true
        local containers_widgetsetup_base2 = containers.widgetsetup
        function containers.widgetsetup(container, prefab)
            containers_widgetsetup_base2(container, prefab)
            if container.type == "frostsmall" then
                container.type = "chest"
            end
        end
    end
    if containers.MAXITEMSLOTS < MAXITEMSLOTS then
        containers.MAXITEMSLOTS = MAXITEMSLOTS
    end
end)

function params.frostsmall.itemtestfn(container, item, slot)
    return not item:HasTag("heatrock")

end

--------------------------------------------------
--icebox1
local params = {}
local OVERRIDE_WIDGETSETUP = false
local containers_widgetsetup_base = containers.widgetsetup
function containers.widgetsetup(container, prefab)
    local t = params[prefab or container.inst.prefab]
    if t ~= nil then
        for k, v in pairs(t) do
            container[k] = v
        end
        container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
        if OVERRIDE_WIDGETSETUP then
            container.type = "frostbox"
        end
    else
        containers_widgetsetup_base(container, prefab)
    end
end

local function frostbox()
    local container =
    {
        widget =
        {
            slotpos = {},
            animbank = "ui_backpack_2x4",
            animbuild = "ui_chest_frosthammer2",
            pos = GLOBAL.Vector3(-5, -70, 0),
            side_align_tip = 160,
        },
        issidewidget = true,
        type = "pack",
    }
    for y = 0, 4 do
        table.insert(container.widget.slotpos, GLOBAL.Vector3(-162, -y * 58 + 124, 0))
        table.insert(container.widget.slotpos, GLOBAL.Vector3(-162 + 75, -y * 58 + 124, 0))

    end
    return container
end

params.frostbox = frostbox()
for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end
local containers_widgetsetup_custom = containers.widgetsetup
local MAXITEMSLOTS = containers.MAXITEMSLOTS
AddPrefabPostInit("world_network", function(inst)
    if containers.widgetsetup ~= containers_widgetsetup_custom then
        OVERRIDE_WIDGETSETUP = true
        local containers_widgetsetup_base2 = containers.widgetsetup
        function containers.widgetsetup(container, prefab)
            containers_widgetsetup_base2(container, prefab)
            if container.type == "frostbox" then
                container.type = "pack"
            end
        end
    end
    if containers.MAXITEMSLOTS < MAXITEMSLOTS then
        containers.MAXITEMSLOTS = MAXITEMSLOTS
    end
end)

function params.frostbox.itemtestfn(container, item, slot)
    return not item:HasTag("heatrock")

end

--------------------------------------------------

--box1
local params = {}
local OVERRIDE_WIDGETSETUP = false
local containers_widgetsetup_base = containers.widgetsetup
function containers.widgetsetup(container, prefab)
    local t = params[prefab or container.inst.prefab]
    if t ~= nil then
        for k, v in pairs(t) do
            container[k] = v
        end
        container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
        if OVERRIDE_WIDGETSETUP then
            container.type = "chest_yamche0"
        end
    else
        containers_widgetsetup_base(container, prefab)
    end
end

local function chest_yamche0()
    local container =
    {
        widget =
        {
            slotpos = {},
            animbank = "ui_chest_3x2",
            animbuild = "ui_chest_yamche0",
            pos = GLOBAL.Vector3(0, 200, 0),
            side_align_tip = 160,
        },
        type = "chest",
    }
    for y = 1, 0, -1 do
        table.insert(container.widget.slotpos, GLOBAL.Vector3(74 * y - 74 * 2 + 70, 0))

    end
    return container
end

params.chest_yamche0 = chest_yamche0()
for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end
local containers_widgetsetup_custom = containers.widgetsetup
local MAXITEMSLOTS = containers.MAXITEMSLOTS
AddPrefabPostInit("world_network", function(inst)
    if containers.widgetsetup ~= containers_widgetsetup_custom then
        OVERRIDE_WIDGETSETUP = true
        local containers_widgetsetup_base2 = containers.widgetsetup
        function containers.widgetsetup(container, prefab)
            containers_widgetsetup_base2(container, prefab)
            if container.type == "chest_yamche0" then
                container.type = "chest"
            end
        end
    end
    if containers.MAXITEMSLOTS < MAXITEMSLOTS then
        containers.MAXITEMSLOTS = MAXITEMSLOTS
    end
end)
---------------------------------------------------------------
--box2
local params = {}
local OVERRIDE_WIDGETSETUP = false
local containers_widgetsetup_base = containers.widgetsetup
function containers.widgetsetup(container, prefab)
    local t = params[prefab or container.inst.prefab]
    if t ~= nil then
        for k, v in pairs(t) do
            container[k] = v
        end
        container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
        if OVERRIDE_WIDGETSETUP then
            container.type = "chest_yamche1"
        end
    else
        containers_widgetsetup_base(container, prefab)
    end
end

local function chest_yamche1()
    local container =
    {
        widget =
        {
            slotpos = {},
            animbank = "ui_chest_3x3",
            animbuild = "ui_chest_yamche1",
            pos = GLOBAL.Vector3(0, 200, 0),
            side_align_tip = 160,
        },
        type = "chest",
    }
    for y = 1, 0, -1 do
        for x = 0, 1 do
            table.insert(container.widget.slotpos, GLOBAL.Vector3(80 * x - 80 * 2 + 78, 80 * y - 80 * 2 + 80, 0))
        end
    end
    return container
end

params.chest_yamche1 = chest_yamche1()
for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end
local containers_widgetsetup_custom = containers.widgetsetup
local MAXITEMSLOTS = containers.MAXITEMSLOTS
AddPrefabPostInit("world_network", function(inst)
    if containers.widgetsetup ~= containers_widgetsetup_custom then
        OVERRIDE_WIDGETSETUP = true
        local containers_widgetsetup_base2 = containers.widgetsetup
        function containers.widgetsetup(container, prefab)
            containers_widgetsetup_base2(container, prefab)
            if container.type == "chest_yamche1" then
                container.type = "chest"
            end
        end
    end
    if containers.MAXITEMSLOTS < MAXITEMSLOTS then
        containers.MAXITEMSLOTS = MAXITEMSLOTS
    end
end)
---------------------------------------------------------------
--box3
local params = {}
local OVERRIDE_WIDGETSETUP = false
local containers_widgetsetup_base = containers.widgetsetup
function containers.widgetsetup(container, prefab)
    local t = params[prefab or container.inst.prefab]
    if t ~= nil then
        for k, v in pairs(t) do
            container[k] = v
        end
        container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
        if OVERRIDE_WIDGETSETUP then
            container.type = "chest_yamche2"
        end
    else
        containers_widgetsetup_base(container, prefab)
    end
end

local function chest_yamche2()
    local container =
    {
        widget =
        {
            slotpos = {},
            animbank = "ui_chest_3x3",
            animbuild = "ui_chest_yamche2",
            pos = GLOBAL.Vector3(0, 200, 0),
            side_align_tip = 160,
        },
        type = "chest",
    }

    for y = 2, 0, -1 do
        for x = 0, 1 do
            table.insert(container.widget.slotpos, GLOBAL.Vector3(80 * x - 80 * 2 + 78, 80 * y - 80 * 2 + 80, 0))
        end
    end
    return container
end

params.chest_yamche2 = chest_yamche2()
for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end
local containers_widgetsetup_custom = containers.widgetsetup
local MAXITEMSLOTS = containers.MAXITEMSLOTS
AddPrefabPostInit("world_network", function(inst)
    if containers.widgetsetup ~= containers_widgetsetup_custom then
        OVERRIDE_WIDGETSETUP = true
        local containers_widgetsetup_base2 = containers.widgetsetup
        function containers.widgetsetup(container, prefab)
            containers_widgetsetup_base2(container, prefab)
            if container.type == "chest_yamche2" then
                container.type = "chest"
            end
        end
    end
    if containers.MAXITEMSLOTS < MAXITEMSLOTS then
        containers.MAXITEMSLOTS = MAXITEMSLOTS
    end
end)
---------------------------------------------------------------
--box5
local params = {}
local OVERRIDE_WIDGETSETUP = false
local containers_widgetsetup_base = containers.widgetsetup
function containers.widgetsetup(container, prefab)
    local t = params[prefab or container.inst.prefab]
    if t ~= nil then
        for k, v in pairs(t) do
            container[k] = v
        end
        container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
        if OVERRIDE_WIDGETSETUP then
            container.type = "chest_yamche4"
        end
    else
        containers_widgetsetup_base(container, prefab)
    end
end

local function chest_yamche4()
    local container =
    {
        widget =
        {
            slotpos = {},
            animbank = "ui_chest_3x3",
            animbuild = "ui_chest_3x3",
            pos = GLOBAL.Vector3(0, 200, 0),
            side_align_tip = 160,
        },
        type = "chest",
    }
    for y = 3, 0, -1 do
        for x = 0, 2 do
            table.insert(container.widget.slotpos, GLOBAL.Vector3(75 * x - 75 * 2 + 75, 60 * y - 60 * 2 + 32, 0))
        end
    end
    return container
end

params.chest_yamche4 = chest_yamche4()
for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end
local containers_widgetsetup_custom = containers.widgetsetup
local MAXITEMSLOTS = containers.MAXITEMSLOTS
AddPrefabPostInit("world_network", function(inst)
    if containers.widgetsetup ~= containers_widgetsetup_custom then
        OVERRIDE_WIDGETSETUP = true
        local containers_widgetsetup_base2 = containers.widgetsetup
        function containers.widgetsetup(container, prefab)
            containers_widgetsetup_base2(container, prefab)
            if container.type == "chest_yamche4" then
                container.type = "chest"
            end
        end
    end
    if containers.MAXITEMSLOTS < MAXITEMSLOTS then
        containers.MAXITEMSLOTS = MAXITEMSLOTS
    end
end)
---------------------------------------------------------------
--box6
local params = {}
local OVERRIDE_WIDGETSETUP = false
local containers_widgetsetup_base = containers.widgetsetup
function containers.widgetsetup(container, prefab)
    local t = params[prefab or container.inst.prefab]
    if t ~= nil then
        for k, v in pairs(t) do
            container[k] = v
        end
        container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
        if OVERRIDE_WIDGETSETUP then
            container.type = "chest_yamche5"
        end
    else
        containers_widgetsetup_base(container, prefab)
    end
end

local function chest_yamche5()
    local container =
    {
        widget =
        {
            slotpos = {},
            animbank = "ui_chest_3x3",
            animbuild = "ui_chest_3x3",
            pos = GLOBAL.Vector3(0, 200, 0),
            side_align_tip = 160,
        },
        type = "chest",
    }
    for y = 3, 0, -1 do
        for x = 0, 3 do
            table.insert(container.widget.slotpos, GLOBAL.Vector3(60 * x - 60 * 2 + 30, 60 * y - 60 * 2 + 30, 0))
        end
    end
    return container
end

params.chest_yamche5 = chest_yamche5()
for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end
local containers_widgetsetup_custom = containers.widgetsetup
local MAXITEMSLOTS = containers.MAXITEMSLOTS
AddPrefabPostInit("world_network", function(inst)
    if containers.widgetsetup ~= containers_widgetsetup_custom then
        OVERRIDE_WIDGETSETUP = true
        local containers_widgetsetup_base2 = containers.widgetsetup
        function containers.widgetsetup(container, prefab)
            containers_widgetsetup_base2(container, prefab)
            if container.type == "chest_yamche5" then
                container.type = "chest"
            end
        end
    end
    if containers.MAXITEMSLOTS < MAXITEMSLOTS then
        containers.MAXITEMSLOTS = MAXITEMSLOTS
    end
end)

---------------------------------------------------------------
---------------------------------------------------------------
--box7
local params = {}
local OVERRIDE_WIDGETSETUP = false
local containers_widgetsetup_base = containers.widgetsetup
function containers.widgetsetup(container, prefab)
    local t = params[prefab or container.inst.prefab]
    if t ~= nil then
        for k, v in pairs(t) do
            container[k] = v
        end
        container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
        if OVERRIDE_WIDGETSETUP then
            container.type = "chest_yamche6"
        end
    else
        containers_widgetsetup_base(container, prefab)
    end
end

local function chest_yamche6()
    local container =
    {
        widget =
        {
            slotpos = {},
            animbank = "ui_chest_3x3",
            animbuild = "", --"ui_chest_moon",
            pos = GLOBAL.Vector3(0, 200, 0),
            side_align_tip = 160,
        },
        type = "chest",
    }
    for y = 5, 0, -1 do
        for x = 0, 14 do
            table.insert(container.widget.slotpos, GLOBAL.Vector3(60 * x - 60 * 2 + -150, 60 * y - 60 * 2 + 10, 0))
        end
    end
    return container
end

params.chest_yamche6 = chest_yamche6()
for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end
local containers_widgetsetup_custom = containers.widgetsetup
local MAXITEMSLOTS = containers.MAXITEMSLOTS
AddPrefabPostInit("world_network", function(inst)
    if containers.widgetsetup ~= containers_widgetsetup_custom then
        OVERRIDE_WIDGETSETUP = true
        local containers_widgetsetup_base2 = containers.widgetsetup
        function containers.widgetsetup(container, prefab)
            containers_widgetsetup_base2(container, prefab)
            if container.type == "chest_yamche6" then
                container.type = "chest"
            end
        end
    end
    if containers.MAXITEMSLOTS < MAXITEMSLOTS then
        containers.MAXITEMSLOTS = MAXITEMSLOTS
    end
end)


--AddPrefabPostInit("ancient_soul", Addtradableprefab)
--AddPrefabPostInit("maxwellintro", InoriMaxwellIntro)
----------------------------------------------------------------------------------------------------

local function Givelickingbone(inst)
    local lickingbone = GLOBAL.SpawnPrefab("personal_licking_eyebone")
    if lickingbone then
        lickingbone.owner = inst
        inst.lickingbone = lickingbone
        inst.components.inventory.ignoresound = true
        inst.components.inventory:GiveItem(lickingbone)
        inst.components.inventory.ignoresound = false
        lickingbone.components.named:SetName(inst.name .. "的铃铛")
        return lickingbone
    end
end

local function GetSpawnPoint(pt)
    local theta = math.random() * 2 * GLOBAL.PI
    local radius = 4
    local offset = GLOBAL.FindWalkableOffset(pt, theta, radius, 12, true)
    return offset ~= nil and (pt + offset) or nil
end

local function Personallicking(inst)
    if not inst:HasTag("speciallickingowner") then
        return
    end

    local OnDespawn_prev = inst.OnDespawn
    local OnDespawn_new = function(inst)
        -- Remove licking
        if inst.licking then
            -- Don't allow licking to despawn with irreplaceable items
            inst.licking.components.container:DropEverythingWithTag("irreplaceable")

            -- We need time to save before despawning.
            inst.licking:DoTaskInTime(0.1, function(inst)
                if inst and inst:IsValid() then
                    inst:Remove()
                end
            end)

        end

        if inst.lickingbone then
            -- lickingbone drops from whatever its in
            local owner = inst.lickingbone.components.inventoryitem.owner
            if owner then
                -- Remember if lickingbone is held
                if owner == inst then
                    inst.lickingbone.isheld = true
                else
                    inst.lickingbone.isheld = false
                end
                if owner.components.container then
                    owner.components.container:DropItem(inst.lickingbone)
                elseif owner.components.inventory then
                    owner.components.inventory:DropItem(inst.lickingbone)
                end
            end
            -- Remove lickingbone
            inst.lickingbone:DoTaskInTime(0.1, function(inst)
                if inst and inst:IsValid() then
                    inst:Remove()
                end
            end)
        else
            print("Error: Player has no linked lickingbone!")
        end
        if OnDespawn_prev then
            return OnDespawn_prev(inst)
        end
    end
    inst.OnDespawn = OnDespawn_new

    local OnSave_prev = inst.OnSave
    local OnSave_new = function(inst, data)
        local references = OnSave_prev and OnSave_prev(inst, data)
        if inst.licking then
            -- Save licking
            local refs = {}
            if not references then
                references = {}
            end
            data.licking, refs = inst.licking:GetSaveRecord()
            if refs then
                for k, v in pairs(refs) do
                    table.insert(references, v)
                end
            end
        end
        if inst.lickingbone then
            -- Save lickingbone
            local refs = {}
            if not references then
                references = {}
            end
            data.lickingbone, refs = inst.lickingbone:GetSaveRecord()
            if refs then
                for k, v in pairs(refs) do
                    table.insert(references, v)
                end
            end
            -- Remember if was holding lickingbone
            if inst.lickingbone.isheld then
                data.holdinglickingbone = true
            else
                data.holdinglickingbone = false
            end
        end
        return references
    end
    inst.OnSave = OnSave_new

    local OnLoad_prev = inst.OnLoad
    local OnLoad_new = function(inst, data, newents)
        if data.licking ~= nil then
            -- Load licking
            inst.licking = GLOBAL.SpawnSaveRecord(data.licking, newents)
        else
            --print("Warning: No licking was loaded from save file!")
        end

        if data.lickingbone ~= nil then
            -- Load licking
            inst.lickingbone = GLOBAL.SpawnSaveRecord(data.lickingbone, newents)

            -- Look for lickingbone at spawn point and re-equip
            inst:DoTaskInTime(0, function(inst)
                if data.holdinglickingbone or (inst.lickingbone and inst:IsNear(inst.lickingbone, 4)) then
                    --inst.components.inventory:GiveItem(inst.lickingbone)
                    inst:Returnlickingbone()
                end
            end)
        else
            print("Warning: No lickingbone was loaded from save file!")
        end

        -- Create new lickingbone if none loaded
        if not inst.lickingbone then
            Givelickingbone(inst)
        end

        inst.lickingbone.owner = inst


        if OnLoad_prev then
            return OnLoad_prev(inst, data, newents)
        end
    end
    inst.OnLoad = OnLoad_new

    local OnNewSpawn_prev = inst.OnNewSpawn
    local OnNewSpawn_new = function(inst)
        -- Give new lickingbone. Let licking spawn naturally.
        Givelickingbone(inst)
        if OnNewSpawn_prev then
            return OnNewSpawn_prev(inst)
        end
    end
    inst.OnNewSpawn = OnNewSpawn_new

    if GLOBAL.TheNet:GetServerGameMode() == "wilderness" then
        local function ondeath(inst, data)
            -- Kill player's licking in wilderness mode :(
            if inst.licking then
                inst.licking.components.health:Kill()
            end
            if inst.lickingbone then
                inst.lickingbone:Remove()
            end
        end

        inst:ListenForEvent("death", ondeath)
    end

    -- Debug function to return lickingbone
    inst.Returnlickingbone = function()
        if inst.lickingbone and inst.lickingbone:IsValid() then
            if inst.lickingbone.components.inventoryitem.owner ~= inst then
                inst.components.inventory:GiveItem(inst.lickingbone)
            end
        else
            Givelickingbone(inst)
        end
        if inst.licking and not inst:IsNear(inst.licking, 20) then
            local pt = inst:GetPosition()
            local spawn_pt = GetSpawnPoint(pt)
            if spawn_pt ~= nil then
                inst.licking.Physics:Teleport(spawn_pt:Get())
                inst.licking:FacePoint(pt:Get())
            end
        end
    end
end

GLOBAL.c_returnlickingbone = function(inst)
    if not inst then
        inst = GLOBAL.ThePlayer or GLOBAL.AllPlayers[1]
    end
    if not inst or not inst.Returnlickingbone then
        print("Error: Cannot return lickingbone")
        return
    end
    inst:Returnlickingbone()
end

AddPlayerPostInit(Personallicking)

--No One Enters Chester cept the one with the licking bone!

local function HaslickingBone(doer)
    if doer.components.inventory and doer.components.inventory:FindItem(function(item)
        if item.prefab == "personal_licking_eyebone" then return true end
    end) ~= nil then
        return true
    else
        return false
    end
end

local oldACTIONSTORE = GLOBAL.ACTIONS.STORE.fn
GLOBAL.ACTIONS.STORE.fn = function(act)
    if act.target and act.target.prefab == "personal_licking" and act.target.components.container ~= nil and
        act.invobject.components.inventoryitem ~= nil and act.doer.components.inventory ~= nil then
        print(act.doer.name, "is trying to do something with a licking")
        if HaslickingBone(act.doer) then
            print(act.doer.name, "has licking Bone, proceed")
            return oldACTIONSTORE(act)
        else
            print(act.doer.name, "doesn't has the licking Bone, exit")
            if act.doer.components.talker then act.doer.components.talker:Say("No Can Do!") end
            return true
        end
    else
        return oldACTIONSTORE(act)
    end
end

local old_RUMMAGE = GLOBAL.ACTIONS.RUMMAGE.fn
GLOBAL.ACTIONS.RUMMAGE.fn = function(act)
    if act.target and act.target.prefab == "personal_licking" then
        print("GLOBAL.ACTIONS.RUMMAGE--" .. tostring(act.doer.components.inventory))
        result = act.doer.components.inventory:FindItem(function(item)
            if item.prefab == "personal_licking_eyebone" then
                print("GLOBAL.ACTIONS.RUMMAGE--" .. tostring(item) .. "--ok--")
                return true
            end
        end)
        if result then
            return old_RUMMAGE(act)
        else
            print("GLOBAL.ACTIONS.RUMMAGE--" .. tostring(item) .. "--fail--")
            act.doer:DoTaskInTime(1, function()
                act.doer.components.talker:Say("No Can Do!")
            end)
            return false
        end
    else
        return old_RUMMAGE(act)
    end
end


AddMinimapAtlas("images/inventoryimages/personal_licking.xml")

TUNING.ZZJ_DAMAGE = GetModConfigData("zzj_damage")
TUNING.ZZJ_TIMES = GetModConfigData("zzj_times")
TUNING.ZZJ_CAN_USE_AS_HAMMER = GetModConfigData("zzj_canuseashammer")
TUNING.ZZJ_CAN_USE_AS_SHOVEL = GetModConfigData("zzj_canuseasshovel")
TUNING.ZZJ_FINITE_USES = GetModConfigData("zzj_finiteuses")
TUNING.ZZJ_CANKANSHU = GetModConfigData("zzj_cankanshu")
TUNING.ZZJ_CANWAKUANG = GetModConfigData("zzj_canwakuang")
TUNING.ZZJ_PRE = GetModConfigData("zzj_pre")
TUNING.ZZJ_RANGE = GetModConfigData("zzj_range")
TUNING.OPENLIGHT = GetModConfigData("openlight")
TUNING.OPENLI = GetModConfigData("openli")
TUNING.BUFFGO = GetModConfigData("buffgo")
TUNING.FHL_HJOPEN = GetModConfigData("fhl_hjopen")
TUNING.ZZJ_FIREOPEN = GetModConfigData("zzj_fireopen")

GLOBAL.STRINGS.TABS.FHL = "风幻空间"
GLOBAL.RECIPETABS['FHL'] = { str = "FHL", sort = 10, icon = "fhltab.tex",
    icon_atlas = "images/inventoryimages/fhltab.xml", "fhl" }

local ancient_soul18 = Ingredient("ancient_soul", 18)
ancient_soul18.atlas = "images/inventoryimages/ancient_soul.xml"

local ancient_soul8 = Ingredient("ancient_soul", 8)
ancient_soul8.atlas = "images/inventoryimages/ancient_soul.xml"

local ancient_soul5 = Ingredient("ancient_soul", 5)
ancient_soul5.atlas = "images/inventoryimages/ancient_soul.xml"

local ancient_soul3 = Ingredient("ancient_soul", 3)
ancient_soul3.atlas = "images/inventoryimages/ancient_soul.xml"

local ancient_soul1 = Ingredient("ancient_soul", 1)
ancient_soul1.atlas = "images/inventoryimages/ancient_soul.xml"

local fhl_zzj = AddRecipe("fhl_zzj", { ancient_soul5, Ingredient("goldnugget", 6) }, RECIPETABS.FHL, { SCIENCE = 0 },
    nil, nil, nil, nil, "fhl", "images/inventoryimages/fhl_zzj.xml")

local fhl_hsf = AddRecipe("fhl_hsf", { Ingredient("feather_robin", 3), Ingredient("feather_crow", 3), ancient_soul5 },
    RECIPETABS.FHL, { SCIENCE = 0 },
    nil, nil, nil, nil, "fhl", "images/inventoryimages/fhl_hsf.xml")

local fhl_bz = AddRecipe("fhl_bz", { Ingredient("berries", 8), Ingredient("watermelon", 2) }, RECIPETABS.FHL, { SCIENCE = 0 }
    ,
    nil, nil, nil, nil, "fhl", "images/inventoryimages/fhl_bz.xml")

local fhl_cake = AddRecipe("fhl_cake", { Ingredient("berries", 4), Ingredient("pumpkin", 2) }, RECIPETABS.FHL,
    { SCIENCE = 0 },
    nil, nil, nil, nil, "fhl", "images/inventoryimages/fhl_cake.xml")

local fhl_x = AddRecipe("fhl_x", { Ingredient("froglegs_cooked", 3), Ingredient("berries", 3) }, RECIPETABS.FHL,
    { SCIENCE = 0 },
    nil, nil, nil, nil, "fhl", "images/inventoryimages/fhl_x.xml")

local fhl_cy = AddRecipe("fhl_cy", { Ingredient("butterflywings", 5), Ingredient("honey", 2) }, RECIPETABS.FHL,
    { SCIENCE = 0 },
    nil, nil, nil, nil, "fhl", "images/inventoryimages/fhl_cy.xml")

--local ancient_soul = AddRecipe("ancient_soul", {Ingredient( "flint",8), Ingredient("goldnugget", 4)}, RECIPETABS.FHL, {SCIENCE=0},
--nil, nil, nil, nil, "fhl","images/inventoryimages/ancient_soul.xml")

local ancient_gem = AddRecipe("ancient_gem", { ancient_soul18, Ingredient("goldnugget", 12) }, RECIPETABS.FHL,
    { SCIENCE = 0 },
    nil, nil, nil, nil, "fhl", "images/inventoryimages/ancient_gem.xml")

local fhl_tree = AddRecipe("fhl_tree", { ancient_soul3, Ingredient("twigs", 3) }, RECIPETABS.FHL, { SCIENCE = 0 },
    nil, nil, nil, nil, "fhl", "images/inventoryimages/fhl_tree.xml")

local fhl_bb = AddRecipe("fhl_bb", { Ingredient("cutgrass", 5), Ingredient("twigs", 5), ancient_soul8 }, RECIPETABS.FHL,
    { SCIENCE = 0 },
    nil, nil, nil, nil, "fhl", "images/inventoryimages/fhl_bb.xml")

----BOOK----
AddRecipe("book_birds", { Ingredient("papyrus", 2), Ingredient("bird_egg", 2) }, RECIPETABS.FHL, TECH.NONE, nil, nil, nil
    , nil, "bookbuilder")
AddRecipe("book_gardening", { Ingredient("papyrus", 2), Ingredient("seeds", 1), Ingredient("poop", 1) }, RECIPETABS.FHL,
    TECH.NONE, nil, nil, nil, nil, "bookbuilder")
AddRecipe("book_sleep", { Ingredient("papyrus", 2), Ingredient("nightmarefuel", 2) }, RECIPETABS.FHL, TECH.NONE, nil, nil
    , nil, nil, "bookbuilder")
AddRecipe("book_brimstone", { Ingredient("papyrus", 2), Ingredient("redgem", 1) }, RECIPETABS.FHL, TECH.NONE, nil, nil,
    nil, nil, "bookbuilder")
AddRecipe("book_tentacles", { Ingredient("papyrus", 2), Ingredient("tentaclespots", 1) }, RECIPETABS.FHL, TECH.NONE, nil
    , nil, nil, nil, "bookbuilder")

-----------创建地图图标和角色基础属性
AddMinimapAtlas("images/map_icons/fhl.xml")
AddModCharacter("fhl", "FEMALE")

GLOBAL.glassesdrop = GetModConfigData("DROPGLASSES")
