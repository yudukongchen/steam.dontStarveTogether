-- GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

-- 支持世界设置扩展
local OPTIONS = rawget(_G,"OCEANFISHEDMOD_OPTIONS") or {}
-- if #OPTIONS > 0 then
-- 	print("创建海钓世界设置扩展内容")
-- 	rawset(GLOBAL, "OCEANFISHEDMOD_OPTIONS", OPTIONS)
-- else
-- 	local custom_1 = {
-- 		name = "测试扩展名称",
-- 		task_set = {
-- 			ocean_prefill_setpieces = {["Nightmare_Home"] = {count =1},},
-- 		}
-- 	}

-- 	table.insert(OPTIONS, custom_1)

-- 	rawset(GLOBAL, "OCEANFISHEDMOD_OPTIONS", OPTIONS)	
-- end



local map_max = GetModConfigData("minmap") or 0
local start = GetModConfigData("start") or "default_start"

--全局表中是否存在WorldSim表
if rawget(GLOBAL,"WorldSim") and map_max > 0 then
    local idx = getmetatable(WorldSim).__index
    local SetWorldSize_ = idx.SetWorldSize
    local ConvertToTileMap_ = idx.ConvertToTileMap
    idx.SetWorldSize = function(self,a,b) SetWorldSize_(self,map_max,map_max) end --没有啥用的
    idx.ConvertToTileMap = function(self,x) ConvertToTileMap_(self,map_max) end --设置地图大小,单位一地皮
end

require("map/network")
require("util")
require("gamemodes")


local StaticLayout = require("map/static_layout")
local obj_layout = require("map/object_layout")
local Layouts = require("map/layouts").Layouts
-- skull grail
Layouts["DefaultStart1"] = StaticLayout.Get("map/static_layouts/"..start, {
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    layout_position = LAYOUT_POSITION.CENTER,

	defs={
		--有特别活动吗
		welcomitem = IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS) and {"pumpkin_lantern"} or {"flower"},
	},
})

Layouts["OceanBoss"] = StaticLayout.Get("map/static_layouts/boss", {
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    layout_position = LAYOUT_POSITION.CENTER,
    add_topology = {room_id = "StaticLayoutIsland:OceanBoss", tags = {"sandstorm"}, node_type = 7},

	defs={
		--有特别活动吗
		welcomitem = IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS) and {"pumpkin_lantern"} or {"flower"},
	},
})


-- 中庭布局
Layouts["AtriumEnd"] = StaticLayout.Get("map/static_layouts/rooms/atrium_end/atrium_end", {
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    layout_position = LAYOUT_POSITION.CENTER,
    add_topology = {room_id = "StaticLayoutIsland:AtriumEnd", tags = {"Atrium"}, node_type = 7},

	defs={
		--有特别活动吗
		welcomitem = IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS) and {"pumpkin_lantern"} or {"flower"},
	},
})

-- 小月岛布局
Layouts["OceanMoon"] = StaticLayout.Get("map/static_layouts/ocean_moon", {
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    layout_position = LAYOUT_POSITION.CENTER,
    add_topology = {room_id = "StaticLayoutIsland:OceanMoon", tags = {"lunacyarea"}, node_type = 7},

	defs={
		--有特别活动吗
		welcomitem = IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS) and {"pumpkin_lantern"} or {"flower"},
	},
})

-- 小月岛布局
Layouts["OceanMoon2"] = StaticLayout.Get("map/static_layouts/ocean_moon", {
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    layout_position = LAYOUT_POSITION.CENTER,
    add_topology = {room_id = "StaticLayoutIsland:OceanMoon2", tags = {"lunacyarea"}, node_type = 7},

	defs={
		--有特别活动吗
		welcomitem = IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS) and {"pumpkin_lantern"} or {"flower"},
	},
})

-- 月台岛布局
Layouts["OceanMoonbase"] = StaticLayout.Get("map/static_layouts/ocean_moonbase", {
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    layout_position = LAYOUT_POSITION.CENTER,
    add_topology = {room_id = "StaticLayoutIsland:OceanMoonbase", node_type = 7},

	defs={
		--有特别活动吗
		welcomitem = IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS) and {"pumpkin_lantern"} or {"flower"},
	},
})
-- of_spawnlayout("NightmareHome")
-- 噩梦家园布局
Layouts["NightmareHome"] = StaticLayout.Get("map/static_layouts/nightmare_home", {
	areas = {
		item_area = function(area, data)
			local vert = data.height > data.width
			local x = data.x - data.width/2.0
			local y = data.y - data.height/2.0
			local spacing = math.random(3,8)
			local num = math.ceil((vert and data.height or data.width) / spacing)
			local prefabs = {}
			for i = 1, num do
				table.insert(prefabs,
				{
					prefab = "fissure", --噩梦裂缝
					x = x,
					y = y,
				})
				if vert then
					y = y + spacing
				else
					x = x + spacing
				end
			end
			return prefabs
		end
	},
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    layout_position = LAYOUT_POSITION.CENTER,
    add_topology = {room_id = "StaticLayoutIsland:NightmareHome", node_type = 7},
	defs={
		--有特别活动吗
		welcomitem = IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS) and {"pumpkin_lantern"} or {"flower"},
	},
})
-- 风滚草岛布局
Layouts["TumbleweedLand"] = StaticLayout.Get("map/static_layouts/tumbleweed_land", {
	areas = {
		item_area = function(area, data)
			local vert = data.height > data.width
			local x = data.x - data.width/2.0
			local y = data.y - data.height/2.0
			local spacing = math.random(80,160)/10.0
			local num = math.ceil((vert and data.height or data.width) / spacing)
			local prefabs = {}
			for i = 1, num do
				table.insert(prefabs,
				{
					prefab = "tumbleweedspawner",
					x = x,
					y = y,
				})
				if vert then
					y = y + spacing
				else
					x = x + spacing
				end
			end
			return prefabs
		end
	},
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    layout_position = LAYOUT_POSITION.CENTER,
    add_topology = {room_id = "StaticLayoutIsland:TumbleweedLand", node_type = 7},
	defs={
		--有特别活动吗
		welcomitem = IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS) and {"pumpkin_lantern"} or {"flower"},
	},
})

-- 移除蟹岛上面的物品
Layouts["HermitcrabIsland"].layout["sapling_moon"] = nil
Layouts["HermitcrabIsland"].layout["bullkelp_beachedroot"] = nil
Layouts["HermitcrabIsland"].layout["moon_tree"] = nil
Layouts["HermitcrabIsland"].layout["moonglass_rock"] = nil

-- Layouts["HermitcrabIsland"].add_topology.tags = {"lunacyarea"}
-- 使得瓶中信可查岛
if obj_layout.LayoutForDefinition("桃园") then -- 判断一下是否加载了神话内容 如果加载了那么为神话岛添加id 方便查找
	Layouts["桃园"].add_topology = {room_id = "StaticLayoutIsland:桃园"}
	Layouts["广寒宫"].add_topology = {room_id = "StaticLayoutIsland:广寒宫"}
	Layouts["熊猫林"].add_topology = {room_id = "StaticLayoutIsland:熊猫林"}
end

----------------------------------------------------------------------------------------------------------------
-- 测试自定义生成岛屿

local function GetLand()
	local layout = {}

	layout.type = 0 --0~5
	layout.scale = 1
	layout.layout_file = {} -- 布局文件的内容
	layout.ground_types = {
		202,203,202,15,23,24
	}
	layout.ground = {}
	local w = math.random(16,22)
	local h = math.random(12,w)
	for i=1,w do
		local t = {}
		for j=1,h do
			table.insert(t,math.random(1,#layout.ground_types))
		end
		table.insert(layout.ground,t)
	end
	local prefab = "ancient_altar_broken_spawner" --损坏的远古伪科技站刷新点 查看文件..\scripts\prefabs\ruinsrespawner.lua
	layout.layout = {}
	if layout.layout[prefab] == nil then
		layout.layout[prefab] = {}
	end
	table.insert(layout.layout[prefab], {x=0, y=0, properties={}, width=0, height=0})
    
    layout.start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED
    layout.fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED
    layout.layout_position = LAYOUT_POSITION.CENTER

	layout.add_topology = {room_id = "StaticLayoutIsland:Confusion", node_type = 7}
	layout.defs={
		--有特别活动吗
		welcomitem = IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS) and {"pumpkin_lantern"} or {"flower"},
	}
	return layout
end

Layouts["Confusion"] = GetLand()

Layouts["NineGrid"] = StaticLayout.Get("map/static_layouts/ninegrid", {
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    layout_position = LAYOUT_POSITION.CENTER,

    add_topology = {room_id = "StaticLayoutIsland:NineGrid", node_type = 7},

	defs={
		--有特别活动吗
		welcomitem = IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS) and {"pumpkin_lantern"} or {"flower"},
	},
})

----------------------------------------------------------------------------------------------------------------

-- 定义海洋房间
AddRoom("OceanSwell_cs", {
					colour={r=.5,g=0.6,b=.080,a=.10},
					value = GROUND.OCEAN_SWELL,
					contents =  {
						distributepercent = 0.001,
						distributeprefabs =
						{
							oceanfish_shoalspawner = 0.01, --鱼场
                        },
						countstaticlayouts =
						{
					        ["AtriumEnd"] = {count = 1},
						},
					}})


--自定义起始位置
AddStartLocation("cs_sl", {
    name = "测试起始地",
    location = "forest",
    --起始布局
    start_setpeice = "DefaultStart1",
    --布局在的房间名称
    start_node = "Blank",
})

AddTask("Isolated Island", {
		locks={},
		keys_given={},
		room_choices={
			["Blank"] = 1, -- 添加空白房间
		},
		room_bg=GROUND.GRASS,
		background_room="Blank", --也为空白房间
		colour={r=0,g=1,b=0,a=1}
	})
local task_set = {
    name = "海岛",
    location = "forest",
    tasks = {
		"Isolated Island",
    },
    --保留原因是用于覆盖
    numoptionaltasks = 0,
    optionaltasks = {},
    valid_start_tasks = nil,
    required_prefabs = {},
    set_pieces = {},

	ocean_prefill_setpieces = {
		["BrinePool1"] = {count = 1},
		["Waterlogged1"] = {count = 1},
		["CrabKing"] = {count =1},
		["HermitcrabIsland"] = {count =1},
		["MonkeyIsland"] = {count =1},
		["OceanMoon"] = {count =1},
		["OceanMoon2"] = {count =1},
		["OceanMoonbase"] = {count =1},
		["OceanBoss"] = {count =1},
		["Confusion"] = {count =1},
		["NightmareHome"] = {count =1},
		["TumbleweedLand"] = {count =1},
		-- ["NineGrid"] = {count =1},
    },
    
    -- 海洋房间
	ocean_population = {
		"OceanSwell_cs",
	},
}
--生物群落设置
AddTaskSet("cs_sz2", task_set)
local overrides = {
    start_location = "cs_sl",
    season_start = "default",
    world_size = "default",
    task_set = "cs_sz2",
    layout_mode = "LinkNodesByKeys",
    wormhole_prefab = "wormhole",
    roads = "never", --道路
    -- birds = "never", --鸟
	keep_disconnected_tiles = true,
	no_wormholes_to_disconnected_tiles = true,
	no_joining_islands = true,
	has_ocean = true, --有海洋
	is_oceanfishing = true, --标记用的, 专服要么拷贝客户端的leveldataoverride.lua 要么自己在它中的overrides添加这一条
}
--预设
AddLevel("oceanfishing", {
        id = "CS_ZDY_YS1",
        name = "默认预设",
        desc = "默认【海岛】，默认修改出生点",
        location = "forest",
        version = 4,
        overrides=overrides,
        background_node_range = {0,1},
    })

-- 添加风格
local Levels = require("map/levels")
if Levels.GetPlaystyleDef("oceanfishing") == nil then
	AddPlaystyleDef({
	    id = "oceanfishing",
	    default_preset = "SURVIVAL_TOGETHER",
	    location = "forest",
	    name = "海钓风格",
	    desc = "选择海钓模式",
	    image = {atlas = "images/serverplaystyles.xml", icon = "survival.tex"},
	    smallimage = {atlas = "images/serverplaystyles.xml", icon = "survival_small.tex"},
	    is_default = false,
	    priority = 99,
	    overrides = {
	        is_oceanfishing = true,
	    },
	})
end

-- 省一下进行服务器世界设置
AddLevelPreInitAny(function(self)
	-- print("执行了",self.location,self.id)
	if self.location == "forest" then --加载世界设置时
		if self.id ~= "CS_ZDY_YS1" then
			self:SetID("CS_ZDY_YS1")
			self:SetBaseID("CS_ZDY_YS1")

			for key, vel in pairs(overrides) do
				self.overrides[key] = vel
			end
			for k, v in pairs(task_set) do
				self[k] = v
			end
		end

		--执行扩展mod内容
		for _,mod in pairs(OPTIONS) do
			print("【海钓随机物品】添加世界设置扩展mod:"..(mod.name or "？？？"))

			for key, vel in pairs(mod.overrides or {}) do
				self.overrides[key] = vel
			end		
			for k,v in pairs(mod.task_set or {}) do
				if type(v)=="table" and type(self[k])=="table" and not mod.iscover then
					for i,j in pairs(v) do
						if type(i) == "string" then
							self[k][i] = j
						else
							table.insert(self[k], j)
						end
					end
				else
					self[k] = v
				end
			end
		end
	end
end)
