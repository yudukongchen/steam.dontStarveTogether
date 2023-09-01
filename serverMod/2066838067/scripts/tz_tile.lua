-- 代码作者：ti_Tout

local WorldTileDefs = require("worldtiledefs")

--------------------------------------------------------------------------
--[[ 补全constants.lua里的信息 ]]
--------------------------------------------------------------------------

--地皮种类，用以生成代号
local tz_tiles = {}
tz_tiles["DRAGONFLOOR"] = 
{
	added = false, floor = true, ground_name = "Dragonfloor",

	name = "tz_dragonfloor",
	noise_texture =  resolvefilepath("levels/textures/tz_dragonfloor.tex",true),
	runsound = "dontstarve/movement/run_carpet",
	walksound = "dontstarve/movement/walk_carpet",
	snowsound = "dontstarve/movement/run_snow",
	mudsound = "dontstarve/movement/run_mud",
	flashpoint_modifier = 0,

	name_turf = "tz_dragonfloor",
	anim = "idle",

	name_minimap = "map_edge",
	noise_texture_minimap = "levels/textures/mini_bog_noise.tex",
	
    atlas = resolvefilepath("levels/tiles/tz_dragonfloor.xml",true),
    texture_name =  resolvefilepath("levels/tiles/tz_dragonfloor.tex",true),
}


--将地皮代号变成下标
local tiles_index = {}
for i, v in pairs(GROUND) do
   tiles_index[v] = true
end

for i, v in pairs(tz_tiles) do
    for var = 70, 89 do  --官方留给moder的地皮序列号为70~89号
        if tiles_index[var] == nil then
        	GROUND[i] = var
        	tiles_index[var] = true
        	tz_tiles[i].added  = true
        	break
        end
    end

    assert(tz_tiles[i].added == true, "Can't add a new tile.")	--没有加入成功，整个游戏结束吧，不玩了
end

--------------------------------------------------------------------------
--[[ 补全新地皮的数据 ]]
--------------------------------------------------------------------------

local GROUND_PROPERTIES_TZ = {}
local TURF_PROPERTIES_TZ = {}
local MINIMAP_GROUND_PROPERTIES_TZ = {}

for i, v in pairs(tz_tiles) do
	--补全terrain.lua里的信息

	GROUND_NAMES[GROUND[i]] = v.ground_name --这种地皮的名字

	if tz_tiles[i].floor then --再生之物不会再生在这个地皮下
		GROUND_FLOORING[i] = true
	end

	--补全worldtiledefs.lua里的信息

	local ground_property_info = {}
	ground_property_info.name = v.name
	ground_property_info.noise_texture = v.noise_texture
	ground_property_info.runsound = v.runsound
	ground_property_info.walksound = v.walksound
	ground_property_info.snowsound = v.snowsound
	ground_property_info.mudsound = v.mudsound
	ground_property_info.flashpoint_modifier = v.flashpoint_modifier
	ground_property_info.atlas = v.atlas
	ground_property_info.texture_name = v.texture_name
	table.insert(WorldTileDefs.ground, {GROUND[i], ground_property_info})
	table.insert(GROUND_PROPERTIES_TZ, {GROUND[i], ground_property_info})

	table.insert(WorldTileDefs.assets, Asset("IMAGE", ground_property_info.noise_texture))
	table.insert(WorldTileDefs.assets, Asset("IMAGE", "levels/tiles/"..ground_property_info.name..".tex"))
	table.insert(WorldTileDefs.assets, Asset("FILE", "levels/tiles/"..ground_property_info.name..".xml"))

	if v.name_turf ~= nil then --这个属性代表是否存在地皮的item
		TURF_PROPERTIES_TZ[GROUND[i]] = {name = v.name_turf, anim = v.anim,bank_build=v.name_turf}	--不需要补全这里，但还是要用到,这里是记录的地皮的prefab名字和动画播放名字
		WorldTileDefs.turf[GROUND[i]] = TURF_PROPERTIES_TZ[GROUND[i]]
	end

	--补全minimap.lua里的信息

	if not _G.ModManager.worldgen then
		local minimap_ground_property_info = {}
		minimap_ground_property_info.name = v.name_minimap
		minimap_ground_property_info.noise_texture = v.noise_texture_minimap
		table.insert(MINIMAP_GROUND_PROPERTIES_TZ, {GROUND[i], minimap_ground_property_info})

		table.insert(WorldTileDefs.assets, Asset("IMAGE", minimap_ground_property_info.noise_texture))
		table.insert(WorldTileDefs.assets, Asset("IMAGE", "levels/tiles/"..minimap_ground_property_info.name..".tex"))
		table.insert(WorldTileDefs.assets, Asset("FILE", "levels/tiles/"..minimap_ground_property_info.name..".xml"))
	end
end

TUNING.TURF_PROPERTIES_TZ = TURF_PROPERTIES_TZ or {}

--还没完吧TERRAIN_FILTER

--------------------------------------------------------------------------
--[[ 补全worldtiledefs.lua里的信息 ]]
--------------------------------------------------------------------------

-- WorldTileDefs.Initialize = CacheAllTileInfo_TZ --不用改

--------------------------------------------------------------------------
--[[ 补全minimap.lua里的信息 ]]
--------------------------------------------------------------------------

if not _G.ModManager.worldgen then
	AddPrefabPostInit("minimap", function(inst)
		for i, data in ipairs(MINIMAP_GROUND_PROPERTIES_TZ) do
		    local tile_type, layer_properties = unpack( data )
		    inst.MiniMap:AddRenderLayer(
		        _G.MapLayerManager:CreateRenderLayer(
		            tile_type,
		            _G.resolvefilepath("levels/tiles/"..layer_properties.name..".xml"),
		            _G.resolvefilepath("levels/tiles/"..layer_properties.name..".tex"),
		            _G.resolvefilepath(layer_properties.noise_texture)
		        )
		    )
		end
	end)
end
