local gmcd = GetModConfigData
local SME = {
	use_numpad = gmcd("SMEconfig_NumPad"),
	is_classic_control = gmcd("SMEconfig_IsClassic"),
	allow_sounds = gmcd("SMEconfig_PlaySounds"),
	hotkey_save = gmcd("SMEconfig_KeySave"),
	hotkey_restart = gmcd("SMEconfig_KeyRestart"),
	hotkey_rollback = gmcd("SMEconfig_KeyRollback"),
	hotkey_keyswitch = gmcd("SMEconfig_KeySwitch"),
	key_page2 = GLOBAL["KEY_"..gmcd("SMEconfig_KeyPage2")],
	key_page3 = GLOBAL["KEY_"..gmcd("SMEconfig_KeyPage3")],
	key_page4 = GLOBAL["KEY_"..gmcd("SMEconfig_KeyPage4")],
	key_page5 = GLOBAL["KEY_"..gmcd("SMEconfig_KeyPage5")],
	--enable_turfs = gmcd("SMEconfig_FeatureTurfs"),
	--enable_copy = gmcd("SMEconfig_FeatureCopy"),
	--enable_delete = gmcd("SMEconfig_FeatureDelete"),
	--enable_creative = gmcd("SMEconfig_FeatureCreative"),
	--enable_telepoof = gmcd("SMEconfig_FeatureTelepoof"),
	--enable_mapreveal = gmcd("SMEconfig_FeatureReveal"),
	--enable_meteor = gmcd("SMEconfig_FeatureMeteor"),
	--enable_lightning = gmcd("SMEconfig_FeatureLightning"),
}

local G = GLOBAL
local _Add = function(mod,name,funct)
    local newfunct=function(player,...)
        if G.TheNet:GetClientTableForUser(player.userid).admin then
            funct(player,...)
        end
    end
    AddModRPCHandler(mod,name,newfunct)
end
local _Send = SendModRPCToServer
turf_nokp = 0
cboard = {}
--	= {
--		prefab = "evergreen",
--		skin = nil,
--		health = nil,
--		wspeed = nil,
--		rspeed = nil,
--		stack = nil,
--		text = nil,
--		image = nil,
--		stage = nil,
--		scale = { l = 1, h = 1, w = 1 },
--		rot = 0,
--		tags = {},
--	}

local function IsStringStartsWith(String,Start)
	return type(String)=="string" and string.sub(String,1,string.len(Start))==Start
end
local function IsStringEndsWith(String,End)
	return End=='' or string.sub(String,-string.len(End))==End
end

function table.has(tabl, val)
	for k,v in pairs(tabl or {}) do
		if v == val then
			return true
		elseif k == val then
			return true
		end
	end
	return false
end

local function CZ() -- CarlZalph made this function
	if G.ThePlayer~=nil and G.TheFrontEnd and G.TheFrontEnd:GetActiveScreen().name == "HUD" then
		return true
	end
	return false
end

function sme_setTile(newType, px, py, pz) -- Rezecib made this function
	local W = G.TheWorld
	local x, y = W.Map:GetTileCoordsAtPoint(px, py, pz)
	local oldType = W.Map:GetTileAtPoint(px, py, pz)
	if oldType ~= newType and oldType ~= 255 then
		W.Map:SetTile(x, y, newType)
		W.Map:RebuildLayer(oldType, x, y)
		W.Map:RebuildLayer(newType, x, y)
		W.minimap.MiniMap:RebuildLayer(oldType, x, y)
		W.minimap.MiniMap:RebuildLayer(newType, x, y)
	end
end

local function sme_sound(sound,volume,turf)
	local FP = G.TheFocalPoint
	if SME.allow_sounds == 3 then
		FP.SoundEmitter:PlaySound(sound,nil,volume or 1)
	elseif SME.allow_sounds == 2 then
		if not turf then
			FP.SoundEmitter:PlaySound(sound,nil,volume or 1)
		end
	elseif SME.allow_sounds == 1 then
		if turf then
			FP.SoundEmitter:PlaySound(sound,nil,volume or 1)
		end
	end
end

function sme_playTurfSound(tile, px, py, pz)
	local oldType = G.TheWorld.Map:GetTileAtPoint(px, py, pz)
	if oldType ~= tile and oldType ~= 255 then
		if tile == 5 or tile == 6 or tile == 7 or tile == 11 or tile == 30 then
			sme_sound("dontstarve/common/place_structure_straw",0.9,true)
		elseif tile == 2 or tile == 3 or tile == 16 then
			sme_sound("dontstarve/common/place_structure_stone",1,true)
		elseif tile == 10 or tile == 12 or tile == 14 or tile == 24 or tile == 25 or tile == 32 then
			sme_sound("dontstarve/common/sign_craft",0.75,true)
		elseif tile == 8 or tile == 13 or tile == 15 or tile == 17 then
			sme_sound("dontstarve/creatures/spider/spider_egg_sack",0.7,true)
		elseif tile == 4 or tile == 31 then
			sme_sound("dontstarve/wilson/dig",0.4,true)
		elseif  tile == 18 or tile == 19 or tile == 20 or tile == 21 or tile == 22 or tile == 23 then
			sme_sound("dontstarve/wilson/hit_scalemail",0.8,true)
		else
			sme_sound("dontstarve/creatures/pengull/splash",0.5,true)
		end
	end
end

-- Save with F1
_Add(modname,"SME_Save", function(inst)
	for k,v in ipairs(G.AllPlayers or {}) do
		if SME.allow_sounds >= 2 then
			v.SoundEmitter:PlaySound("dontstarve_DLC001/common/firesupressor_warningbell")
		end
	end
	G.TheNet:Announce("Saving...")
	G.TheWorld:PushEvent("ms_save") -- Save map
end)
G.TheInput:AddKeyUpHandler(SME.hotkey_save, function()
	if CZ() and G.TheNet:GetIsServerAdmin() then
		_Send(MOD_RPC[modname]["SME_Save"])
	end
end)

-- Restart with F2
_Add(modname,"SME_Restart", function(inst)
	for k,v in ipairs(G.AllPlayers or {}) do
		if SME.allow_sounds >= 2 then
			v.SoundEmitter:PlaySound("dontstarve_DLC001/common/firesupressor_warningbell")
		end
	end
	G.TheNet:Announce("Saving and restarting...")
	G.TheSystemService:EnableStorage(true)
	G.SaveGameIndex:SaveCurrent() -- Save map
	G.TheWorld:DoTaskInTime(0.5,function() G.TheNet:SendWorldRollbackRequestToServer(0) end) -- Restart
end)
G.TheInput:AddKeyUpHandler(SME.hotkey_restart, function()
	if CZ() and G.TheNet:GetIsServerAdmin() then
		sme_sound("dontstarve_DLC001/common/firesupressor_warningbell")
		_Send(MOD_RPC[modname]["SME_Restart"])
	end
end)

-- Rollback with F3
_Add(modname,"SME_Rollback", function(inst)
	for k,v in ipairs(G.AllPlayers or {}) do
		if SME.allow_sounds >= 2 then
			v.SoundEmitter:PlaySound("dontstarve_DLC001/common/firesupressor_warningbell")
		end
	end
	G.TheNet:Announce("Loading last save...")
	G.TheWorld:DoTaskInTime(0.5,function() G.TheNet:SendWorldRollbackRequestToServer(0) end) -- Restart
end)
G.TheInput:AddKeyUpHandler(SME.hotkey_rollback, function()
	if CZ() and G.TheNet:GetIsServerAdmin() then
		_Send(MOD_RPC[modname]["SME_Rollback"])
	end
end)

-- Change character with F4
_Add(modname,"SME_Despawn", function(inst)
	for k,v in ipairs(G.AllPlayers or {}) do
		if SME.allow_sounds >= 2 then
			v.SoundEmitter:PlaySound("dontstarve_DLC001/common/firesupressor_warningbell")
		end
	end
	GLOBAL.TheNet:Announce("Despawning "..inst.name.."...")
	G.TheWorld:DoTaskInTime(0.5,function() G.TheWorld:PushEvent("ms_playerdespawnanddelete", inst) end)
end)
G.TheInput:AddKeyUpHandler(SME.hotkey_keyswitch, function()
	if CZ() and G.TheNet:GetIsServerAdmin() then
		_Send(MOD_RPC[modname]["SME_Despawn"])
	end
end)

-- Enable creative mode with Stroke
_Add(modname,"SME_Creative", function(inst)
	local ic = inst.components
	if inst:HasTag("playerghost") then
		inst:PushEvent("respawnfromghost")
	elseif ic.builder.freebuildmode ~= true then
		ic.health:SetInvincible(false)
		ic.builder.freebuildmode = true
		inst:PushEvent("unlockrecipe")
		inst:PushEvent("stopstarving")
		ic.health.minhealth = 65535
		ic.hunger.burnrate = -65535
		ic.sanity.dapperness = 65535
		ic.moisture.maxDryingRate = 65535
		ic.moisture.minDryingRate = 65535
		ic.moisture.maxMoistureRate = -65535
		ic.moisture.minMoistureRate = -65535
		ic.temperature.maxtemp = 65
		ic.temperature.mintemp = 5
		ic.health:SetPercent(1)
		ic.sanity:SetPercent(1)
		ic.hunger:SetPercent(1)
		ic.moisture:SetPercent(0)
		ic.temperature:SetTemperature(25)
		if ic.thirst~=nil then
			if ic.thirst.SetPercent~=nil then
				ic.thirst:SetPercent(1)
			end
			ic.thirst.thirstrate = -65535
		end
	else
		ic.builder.freebuildmode = false
		inst:PushEvent("unlockrecipe")
		ic.health.minhealth = 0
		ic.hunger.burnrate = 1
		ic.sanity.dapperness = 0
		ic.moisture.maxDryingRate = 0.1
		ic.moisture.minDryingRate = 0
		ic.moisture.maxMoistureRate = .75
		ic.moisture.minMoistureRate = 0
		ic.temperature.maxtemp = TUNING.MAX_ENTITY_TEMP
		ic.temperature.mintemp = TUNING.MIN_ENTITY_TEMP
		ic.health:SetInvincible(false)
		if ic.thirst~=nil then
			ic.thirst.thirstrate = 1
		end
	end
end)
G.TheInput:AddKeyUpHandler( (SME.use_numpad and 267) or 287, function()
	if CZ() and G.TheNet:GetIsServerAdmin() then
		sme_sound("dontstarve/HUD/feed")
		_Send(MOD_RPC[modname]["SME_Creative"])
	end
end)

-- Teleport the player to mouse with Asterisk
_Add(modname,"SME_Telepoof", function(inst,x,y,z)
	inst.Transform:SetPosition(x,y,z)  -- Teleport to mouse
end)
_Add(modname,"SME_Lightning", function(inst,x,y,z)
	G.TheWorld:PushEvent("ms_sendlightningstrike", G.Vector3(x,y,z))  -- Strike mouse with lightning
end)

G.TheInput:AddKeyDownHandler( (SME.use_numpad and 268) or 288, function()
	if CZ() and G.TheNet:GetIsServerAdmin() then
		if G.TheInput:IsKeyDown(SME.key_page2) and not G.TheInput:IsKeyDown(SME.key_page3) then
			local pos = G.TheInput:GetWorldPosition()
			_Send(MOD_RPC[modname]["SME_Lightning"], pos.x, pos.y, pos.z)
		else
			local pos = G.TheInput:GetWorldPosition()
			G.ThePlayer.Transform:SetPosition(pos.x, pos.y, pos.z)
			sme_sound("dontstarve/common/minerhatAddFuel")
			_Send(MOD_RPC[modname]["SME_Telepoof"], pos.x, pos.y, pos.z)
		end
	end
end)

-- Reveal the entire map with Hyphen
_Add(modname,"SME_Map", function(inst,x,y,z)
	local size = G.TheWorld.Map:GetSize()*4.1
	for x = -size,size,35 do
		for y = -size,size,35 do
			inst.player_classified.MapExplorer:RevealArea(x,0,y)
		end
	end
end)

G.TheInput:AddKeyUpHandler( (SME.use_numpad and 269) or 289, function()
	if CZ() and G.TheNet:GetIsServerAdmin() then
		if G.TheInput:IsKeyDown(SME.key_page2) and not G.TheInput:IsKeyDown(SME.key_page3) then
			if G.TheCamera.maxdist > 50 then
				if G.TheWorld:HasTag("cave") then
					G.TheCamera.mindist = 15
					G.TheCamera.maxdist = 35
					G.TheCamera.mindistpitch = 25
					G.TheCamera.maxdistpitch = 40
					G.TheCamera.distancetarget = 25
				else
					G.TheCamera.mindist = 15
					G.TheCamera.maxdist = 50
					G.TheCamera.mindistpitch = 30
					G.TheCamera.maxdistpitch = 60
					G.TheCamera.distancetarget = 30
				end
			else
				G.TheCamera.mindist = 1
				G.TheCamera.maxdist = 300
				G.TheCamera.mindistpitch = 25
				G.TheCamera.maxdistpitch = 120
				G.TheCamera.distancetarget = 60
			end
		else
			sme_sound("dontstarve/common/together/draw")
			_Send(MOD_RPC[modname]["SME_Map"])
		end
	end
end)

_Add(modname,"SME_SetTile", function(inst,tile,x,y,z)
	sme_setTile(tile,x,y,z)
end)

if SME.is_classic_control then
	local function sme_getTurfName(tile)
		if tile == 2 then			return "Cobblestones"
		elseif tile == 3 then		return "Rocky Turf"
		elseif tile == 4 then		return "Barren"
		elseif tile == 5 then		return "Savannah Turf"
		elseif tile == 6 then		return "Grass Turf"
		elseif tile == 7 then		return "Forest Turf"
		elseif tile == 8 then		return "Marsh Turf"
		elseif tile == 10 then	return "Wooden Flooring"
		elseif tile == 11 then	return "Carpeted Flooring"
		elseif tile == 12 then	return "Checkerboard Flooring"
		elseif tile == 13 then	return "Guano Turf"
		elseif tile == 14 then	return "Blue Fungal Turf"
		elseif tile == 15 then	return "Slimey Turf"
		elseif tile == 16 then	return "Cave Rock Turf"
		elseif tile == 17 then	return "Mud Turf"
		elseif tile == 18 then	return "Runic Bricks"
		elseif tile == 19 then	return "Dark Runic Bricks"
		elseif tile == 20 then	return "Runic Tiles"
		elseif tile == 21 then	return "Dark Runic Tiles"
		elseif tile == 22 then	return "Runic Trim"
		elseif tile == 23 then	return "Dark Runic Trim"
		elseif tile == 24 then	return "Red Fungal Turf"
		elseif tile == 25 then	return "Green Fungal Turf"
		elseif tile == 30 then	return "Deciduous Turf"
		elseif tile == 31 then	return "Desert Turf"
		elseif tile == 32 then	return "Scaled Flooring"
		elseif tile == 35 then	return "Quagmire Peatforest"
		elseif tile == 36 then	return "Quagmire Parkfield"
		elseif tile == 37 then	return "Quagmire Parkstone"
		elseif tile == 38 then	return "Quagmire Gateway"
		elseif tile == 39 then	return "Quagmire Soil"
		elseif tile == 41 then	return "Quagmire Citystone"
		elseif tile == 42 then	return "Pebble Beach"
		elseif tile == 43 then	return "Meteor"
		elseif tile == 201 then	return "Ocean start/coastal"
		elseif tile == 202 then	return "Ocean coastal shore"
		elseif tile == 203 then	return "Ocean swell"
		elseif tile == 204 then	return "Ocean rough"
		elseif tile == 205 then	return "Ocean reef"
		elseif tile == 206 then	return "Ocean reef shore"
		elseif tile == 207 then	return "Ocean hazardous"
		elseif tile == 247 then	return "Ocean end"
		else								return "Old ocean"
		end
	end

	function sme_getTurfID(number)
		if number == 1 then			return 4 -- Barren
		elseif number == 2 then		return 3 -- Rocky Turf
		elseif number == 3 then		return 5 -- Savanna Turf
		elseif number == 4 then		return 6 -- Grass Turf
		elseif number == 5 then		return 7 -- Forest Turf
		elseif number == 6 then		return 30 -- Deciduous Turf
		elseif number == 7 then		return 31 -- Desert Turf
		elseif number == 8 then		return 8 -- Marsh Turf
		elseif number == 9 then		return 10 -- Wooden Flooring
		elseif number == 10 then	return 11 -- Carpeted Flooring
		elseif number == 11 then	return 12 -- Checkerboard Flooring
		elseif number == 12 then	return 2 -- Cobblestones
		elseif number == 13 then	return 32 -- Scaled Flooring
		elseif number == 14 then	return 16 -- Cave Rock Turf
		elseif number == 15 then	return 17 -- Mud Turf
		elseif number == 16 then	return 13 -- Guano Turf
		elseif number == 17 then	return 15 -- Slimey Turf
		elseif number == 18 then	return 18 -- Runic Bricks
		elseif number == 19 then	return 20 -- Runic Tiles
		elseif number == 20 then	return 22 -- Runic Trim
		elseif number == 21 then	return 19 -- Dark Runic Bricks
		elseif number == 22 then	return 21 -- Dark Runic Tiles
		elseif number == 23 then	return 23 -- Dark Runic Trim
		elseif number == 24 then	return 14 -- Blue Fungal Turf
		elseif number == 25 then	return 24 -- Red Fungal Turf
		elseif number == 26 then	return 25 -- Green Fungal Turf
		elseif number == 27 then	return 35
		elseif number == 28 then	return 36
		elseif number == 29 then	return 37
		elseif number == 30 then	return 38
		elseif number == 31 then	return 39
		elseif number == 32 then	return 41
		elseif number == 33 then	return 42
		elseif number == 34 then	return 43
		elseif number == 35 then	return 201
		elseif number == 36 then	return 202
		elseif number == 37 then	return 203
		elseif number == 38 then	return 204
		elseif number == 39 then	return 205
		elseif number == 40 then	return 206
		elseif number == 41 then	return 207
		elseif number == 42 then	return 247
		else										return 1 -- Ocean
		end 
	end


	local SME_tiles = {
		{	263, -- Numpad 7
			1, -- Old ocean
			10, -- Wooden Flooring
			18, -- Runic Bricks Shiny
			35, -- QUAGMIRE_PEATFOREST
			202, -- NEW OCEAN
		},
		{	264, -- Numpad 8
			4, -- Barren
			11, -- Carpeted Flooring
			20, -- Runic Tiles Shiny
			36, -- QUAGMIRE_PARKFIELD
			203, -- NEW OCEAN
		},
		{	265, -- Numpad 9
			3, -- Rocky Turf
			12, -- Checkerboard Flooring
			22, -- Runic Trim Shiny
			37, -- QUAGMIRE_PARKSTONE
			204, -- NEW OCEAN
		},
		{	260, -- Numpad 4
			5, -- Savannah Turf
			2, -- Cobblestone
			19, -- Runic Bricks Dark
			38, -- QUAGMIRE_GATEWAY
			205, -- NEW OCEAN
		},
		{	261, -- Numpad 5
			6, -- Grass Turf
			32, -- Scaled Flooring
			21, -- Runic Tiles Dark
			39, -- QUAGMIRE_SOIL
			206, -- NEW OCEAN
		},
		{	262, -- Numpad 6
			7, -- Forest Turf
			16, -- Cave Rock Turf
			23, -- Runic Trim Dark
			41, -- QUAGMIRE_CITYSTONE
			207, -- NEW OCEAN
		},
		{	257, -- Numpad 1
			30, -- Deciduous Turf
			17, -- Mud Turf
			14, -- Blue Fungal Turf
			42, -- PEBBLEBEACH
			247, -- NEW OCEAN
		},
		{	258, -- Numpad 2
			31, -- Desert Turf
			13, -- Guano Turf
			24, -- Red Fungal Turf
			43, -- METEOR
			247, -- NEW OCEAN
		},
		{	259, -- Numpad 3
			8, -- Marsh Turf
			15, -- Slimey Turf
			25, -- Green Fungal Turf
			201, -- NEW OCEAN
			247, -- NEW OCEAN
		},
	}

	for i = 1, #SME_tiles do
		G.TheInput:AddKeyDownHandler( SME_tiles[i][1], function()
			if CZ() and G.TheNet:GetIsServerAdmin() then
				local pos = G.TheInput:GetWorldPosition()
				if G.TheInput:IsKeyDown(SME.key_page2) then
					sme_playTurfSound(SME_tiles[i][3], pos.x, pos.y, pos.z)
					_Send(MOD_RPC[modname]["SME_SetTile"], SME_tiles[i][3], pos.x, pos.y, pos.z)
				elseif G.TheInput:IsKeyDown(SME.key_page3) then
					sme_playTurfSound(SME_tiles[i][4], pos.x, pos.y, pos.z)
					_Send(MOD_RPC[modname]["SME_SetTile"], SME_tiles[i][4], pos.x, pos.y, pos.z)
				elseif G.TheInput:IsKeyDown(SME.key_page4) then
					sme_playTurfSound(SME_tiles[i][5], pos.x, pos.y, pos.z)
					_Send(MOD_RPC[modname]["SME_SetTile"], SME_tiles[i][5], pos.x, pos.y, pos.z)
				elseif G.TheInput:IsKeyDown(SME.key_page5) then
					sme_playTurfSound(SME_tiles[i][6], pos.x, pos.y, pos.z)
					_Send(MOD_RPC[modname]["SME_SetTile"], SME_tiles[i][6], pos.x, pos.y, pos.z)
				else
					sme_playTurfSound(SME_tiles[i][2], pos.x, pos.y, pos.z)
					_Send(MOD_RPC[modname]["SME_SetTile"], SME_tiles[i][2], pos.x, pos.y, pos.z)
				end
			end
		end)
	end

	function sme_findPrefab(name)
		local pref = nil
		for k,v in pairs(G.STRINGS.NAMES) do
			if string.lower(string.gsub(name," ","")) == string.lower(string.gsub(tostring(v)," ","")) then
				local test = G.SpawnPrefab(string.lower(tostring(k)))
				if test ~= nil then
					if test.components and test.components.inventoryitem and pref ~= nil then
					else
						pref = string.lower(tostring(k))
					end
				end
			end
		end
		return pref
	end

	-- No-keypad mode
	if not use_numpad then

		_Add(modname,"SME_SayTile", function(inst,turf)
			if inst~=nil and inst.components~=nil and inst.components.talker~=nil then
				inst.components.talker:Say("SME: Selected "..turf, 1, true, true)
			end
		end)

		-- K
		G.TheInput:AddKeyDownHandler( 107, function()
			if CZ() and G.TheNet:GetIsServerAdmin() then
				turf_nokp = (turf_nokp>=42 and 0) or turf_nokp+1
				_Send(MOD_RPC[modname]["SME_SayTile"], sme_getTurfName(sme_getTurfID(turf_nokp)))
			end
		end)
		
		-- J
		G.TheInput:AddKeyDownHandler( 106, function()
			if CZ() and G.TheNet:GetIsServerAdmin() then
				turf_nokp = (turf_nokp<=0 and 42) or turf_nokp-1
				_Send(MOD_RPC[modname]["SME_SayTile"], sme_getTurfName(sme_getTurfID(turf_nokp)))
			end
		end)
		
		-- L
		G.TheInput:AddKeyDownHandler( 108, function()
			if CZ() and G.TheNet:GetIsServerAdmin() then
				local pos = G.TheInput:GetWorldPosition()
				sme_playTurfSound(sme_getTurfID(turf_nokp), pos.x, pos.y, pos.z)
				_Send(MOD_RPC[modname]["SME_SetTile"], sme_getTurfID(turf_nokp), pos.x, pos.y, pos.z)
			end
		end)

	end

	-- Chat commands
	AddComponentPostInit("talker", function(self)
		local _Say = self.Say
		self.Say = function(self, script, time, noanim, force, nobroadcast, colour)
			if (IsStringStartsWith(script,"!clipboard ") or IsStringStartsWith(script,"!cb ")) and colour ~= nil then
				local pref = string.lower(string.gsub(string.gsub(string.gsub(string.gsub(script,"!clipboard ",""),"!cb ",""),"\"",""),"\'",""))
				local test = G.SpawnPrefab(string.lower(pref))
				if test ~= nil then
					local i = self.inst.userid
					if cboard[i] == nil then cboard[i] = {} end
					cboard[i].prefab = pref
					cboard[i].skin = nil
					cboard[i].health = nil
					cboard[i].wspeed = nil
					cboard[i].rspeed = nil
					cboard[i].stack = nil
					cboard[i].text = nil
					cboard[i].image = nil
					cboard[i].stage = nil
					cboard[i].armour = nil
					cboard[i].leif = nil
					cboard[i].scale = { l = 1, h = 1, w = 1 }
					cboard[i].rot = 0
					if cboard[i].tags == nil then cboard[i].tags = {} end
					for k,v in pairs(cboard[i].tags) do cboard[i].tags[k]=nil end
					test:Remove()
					return _Say(self, "SME: \'"..cboard[i].prefab.."\' added to clipboard", 1, true, true)
				elseif sme_findPrefab(pref) ~= nil then
					local test = G.SpawnPrefab(sme_findPrefab(pref))
					if test ~= nil then
						local i = self.inst.userid
						pref = sme_findPrefab(pref)
						if cboard[i] == nil then cboard[i] = {} end
						cboard[i].prefab = pref
						cboard[i].skin = nil
						cboard[i].health = nil
						cboard[i].wspeed = nil
						cboard[i].rspeed = nil
						cboard[i].stack = nil
						cboard[i].text = nil
						cboard[i].image = nil
						cboard[i].stage = nil
						cboard[i].armour = nil
						cboard[i].leif = nil
						cboard[i].scale = { l = 1, h = 1, w = 1 }
						cboard[i].rot = 0
						if cboard[i].tags == nil then cboard[i].tags = {} end
						for k,v in pairs(cboard[i].tags) do cboard[i].tags[k]=nil end
						test:Remove()
						return _Say(self, "SME: \'"..cboard[i].prefab.."\' added to clipboard", 1, true, true)
					else
						return _Say(self, "SME: \'"..cboard[i].prefab.."\' not found", 1, true, true)
					end
				else
					return _Say(self, "SME: \'"..pref.."\' not found", 1, true, true)
				end
			elseif script=="!clipboard" and colour ~= nil then
				return _Say(self, "SME: Incomplete command, \'!clipboard <prefab>\'", 1, true, true)
			elseif script=="!cb" and colour ~= nil then
				return _Say(self, "SME: Incomplete command, \'!cb <prefab>\'", 1, true, true)
			elseif (IsStringStartsWith(script,"!linedistance ") or IsStringStartsWith(script,"!ld ")) and colour ~= nil then
				local dist = string.gsub(string.lower(string.gsub(string.gsub(string.gsub(string.gsub(script,"!linedistance ",""),"!ld ",""),"\"",""),"\'",""))," ","")
				local i = self.inst.userid
				if cboard[i] == nil then cboard[i] = {} end
				if dist ~= nil and dist ~= 1 then
					cboard[i].linedist = math.max(1,math.floor(dist+0.5))
					_Say(self, "SME: Distance for pasting lines set to "..cboard[i].linedist.." metres", 1, true, true)
				else
					cboard[i].linedist = 1
					_Say(self, "SME: Distance for pasting lines set to 1 metre", 1, true, true)
				end
			elseif script=="!linedistance" and colour ~= nil then
				return _Say(self, "SME: Incomplete command, \'!linedistance <metres>\'", 1, true, true)
			elseif script=="!ld" and colour ~= nil then
				return _Say(self, "SME: Incomplete command, \'!ld <metres>\'", 1, true, true)
			elseif (IsStringStartsWith(script,"!overlap ") or IsStringStartsWith(script,"!ol ")) and colour ~= nil then
				local bool = string.lower(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(script,"!overlap ",""),"!ol ",""),"\"",""),"\'","")," ",""))
				local i = self.inst.userid
				if cboard[i] == nil then cboard[i] = {} end
				if bool=="true" or bool=="1" or bool=="yes" or bool=="allowed" or bool=="allow" then
					cboard[i].overlap = true
					_Say(self, "SME: Stacking pasted objects allowed", 1, true, true)
				elseif bool=="false" or bool=="0" or bool=="no" or bool=="not allowed" or bool=="disallowed" or bool=="disallow" then
					cboard[i].overlap = false
					_Say(self, "SME: Stacking pasted objects disallowed", 1, true, true)
				else
					cboard[i].overlap = (cboard[i].overlap==false and true) or false
					_Say(self, "SME: Stacking pasted objects "..((cboard[i].overlap==true and "allowed") or "disallowed"), 1, true, true)
				end
			elseif script=="!overlap" and colour ~= nil then
				local i = self.inst.userid
				if cboard[i] == nil then cboard[i] = {} end
				cboard[i].overlap = (cboard[i].overlap==false and true) or false
				_Say(self, "SME: Stacking pasted objects "..((cboard[i].overlap==true and "allowed") or "disallowed"), 1, true, true)
			elseif script=="!ol" and colour ~= nil then
				local i = self.inst.userid
				if cboard[i] == nil then cboard[i] = {} end
				cboard[i].overlap = (cboard[i].overlap==false and true) or false
				_Say(self, "SME: Stacking pasted objects "..((cboard[i].overlap==true and "allowed") or "disallowed"), 1, true, true)
			else
				return _Say(self, script, time, noanim, force, nobroadcast, colour)
			end
		end
	end)
else
	local GROUND=GLOBAL.GetWorldTileMap()
	local INVALID=GROUND.INVALID
	local GROUND_BY_INDEX=table.invert(GLOBAL.GROUND)
	local ORDERED_INDEX={}
	for k,v in pairs(GROUND_BY_INDEX) do
		table.insert(ORDERED_INDEX,k)
	end
	
	local function Say(text)
		if GLOBAL.ThePlayer and GLOBAL.ThePlayer.components.talker then
			GLOBAL.ThePlayer.components.talker:Say(text, 15, true, true, true, {.5,.5,.5,1})
		end
	end
	
	if SME.use_numpad then
		local Page=0
		local MAX_PAGES=math.ceil(#ORDERED_INDEX/9)
		
		local function setwidth(text,width)
			while(string.len(text)<width) do
				text=text.." "
			end
			return text
		end
		
		local function SayPage(page)
			local text=""
			for i=2,0,-1 do
				for j=0,2 do
					local ground=ORDERED_INDEX[page*9+i*3+j+1] or INVALID
					local ground_name=setwidth(GROUND_BY_INDEX[ground], j==2 and 0 or 25)
					text=text..ground_name
				end
				text=text.."\n"
			end
			Say(text)
		end
		
		for num=0,9 do
			G.TheInput:AddKeyDownHandler(GLOBAL["KEY_KP_"..num], function()
				if CZ() and G.TheNet:GetIsServerAdmin() then
					local pos = G.TheInput:GetWorldPosition()
					local current_page=Page%MAX_PAGES
					local ground=ORDERED_INDEX[current_page*9+num] or INVALID
					_Send(MOD_RPC[modname]["SME_SetTile"], ground, pos.x, pos.y, pos.z)
				end
			end)
		end
		G.TheInput:AddKeyDownHandler(GLOBAL.KEY_RIGHT, function()
			if CZ() and G.TheNet:GetIsServerAdmin() then
				Page=Page+1
				SayPage(Page%MAX_PAGES)
			end
		end)
		G.TheInput:AddKeyDownHandler(GLOBAL.KEY_LEFT, function()
			if CZ() and G.TheNet:GetIsServerAdmin() then
				Page=Page-1
				SayPage(Page%MAX_PAGES)
			end
		end)
		G.TheInput:AddKeyDownHandler(GLOBAL.KEY_UP, function()
			if CZ() and G.TheNet:GetIsServerAdmin() then
				SayPage(Page%MAX_PAGES)
			end
		end)
	else
		local current_tile=0
		G.TheInput:AddKeyDownHandler(GLOBAL.KEY_K, function()
			if CZ() and G.TheNet:GetIsServerAdmin() then
				current_tile=current_tile+1
				Say(GROUND_BY_INDEX[ORDERED_INDEX[current_tile%#ORDERED_INDEX]])
			end
		end)
		
		G.TheInput:AddKeyDownHandler(GLOBAL.KEY_J, function()
			if CZ() and G.TheNet:GetIsServerAdmin() then
				current_tile=current_tile-1
				Say(GROUND_BY_INDEX[ORDERED_INDEX[current_tile%#ORDERED_INDEX]])
			end
		end)
		
		G.TheInput:AddKeyDownHandler(GLOBAL.KEY_L, function()
			if CZ() and G.TheNet:GetIsServerAdmin() then
				local pos = G.TheInput:GetWorldPosition()
				_Send(MOD_RPC[modname]["SME_SetTile"], ORDERED_INDEX[current_tile], pos.x, pos.y, pos.z)
			end
		end)
	end
end

-- Numpad Del
_Add(modname,"SME_Delet", function(inst,p)
	if p == nil then return end
	if p.userid == nil or p.userid == "" or p.prefab == "skeleton_player" then
		if p.SoundEmitter ~= nil and SME.allow_sounds >= 2 then
			p.SoundEmitter:PlaySound("dontstarve/common/deathpoof")
		elseif inst.SoundEmitter ~= nil and SME.allow_sounds >= 2 then
			inst.SoundEmitter:PlaySound("dontstarve/common/deathpoof")
		end
		p:Remove()
	end
end)
G.TheInput:AddKeyDownHandler( (SME.use_numpad and 266) or 127, function()
	if CZ() and G.TheNet:GetIsServerAdmin() then
		local p = G.TheInput:GetWorldEntityUnderMouse()
		if p ~= nil then
			_Send(MOD_RPC[modname]["SME_Delet"], p)
		end
	end
end)

-- Ctrl + C
_Add(modname,"SME_Copy", function(inst,p,delete,shif)
	if p == nil then return end
	local i = inst.userid
	local pc = p.components or nil
	if cboard[i] == nil then cboard[i] = {} end
	cboard[i].prefab = p.prefab
	cboard[i].skin = nil
	cboard[i].health = nil
	cboard[i].wspeed = nil
	cboard[i].rspeed = nil
	cboard[i].stack = nil
	cboard[i].text = nil
	cboard[i].image = nil
	cboard[i].stage = nil
	cboard[i].armour = nil
	cboard[i].leif = nil
	cboard[i].scale = { l = 1, h = 1, w = 1 }
	cboard[i].rot = 0
	if cboard[i].tags == nil then cboard[i].tags = {} end
	for k,v in pairs(cboard[i].tags) do cboard[i].tags[k]=nil end
	if shif and delete then
		p:Remove()
	elseif shif then
		return
	end
	if p.Transform then
		cboard[i].rot = p.Transform:GetRotation()
		local pscale = {p.Transform:GetScale()}
		cboard[i].scale.l = pscale[1]
		cboard[i].scale.h = pscale[2]
		cboard[i].scale.w = pscale[3]
	end
	if p.skinname ~= nil then
		cboard[i].skin = p.skinname
	end
	if pc then
		if pc.locomotor then
			cboard[i].wspeed = pc.locomotor.walkspeed
			cboard[i].rspeed = pc.locomotor.runspeed
		end
		if pc.stackable then
			cboard[i].stack = pc.stackable:StackSize()
		end
		if pc.writeable then
			cboard[i].text = pc.writeable.text
		end
		if pc.drawable then
			cboard[i].image = pc.drawable:GetImage()
		end
		if pc.growable then
			cboard[i].stage = pc.growable.stage
		end
		if pc.armor then
			cboard[i].armour = pc.armor.condition
		end
		if pc.werebeast then
			if pc.werebeast:IsInWereState() then
				table.insert(cboard[i].tags,"werepig")
			end
		end
	end
	if p:HasTag("leif") then
		if p.Transform then
			local pscale = {p.Transform:GetScale()}
			cboard[i].leif = (pscale[1]+pscale[2])/2
		end
	end
	if p:HasTag("wall") then
		cboard[i].health = pc.health.currenthealth
	end
	if p:HasTag("stump") then
		table.insert(cboard[i].tags,"stump")
	end
	if p:HasTag("burnt") then
		table.insert(cboard[i].tags,"burnt")
	end
	if p:HasTag("monster") then
		table.insert(cboard[i].tags,"monster")
	end
	if delete then
		if p.userid == nil or p.userid == "" or p.prefab == "skeleton_player" then
			if p.SoundEmitter ~= nil and SME.allow_sounds >= 2 then
				p.SoundEmitter:PlaySound("dontstarve/common/deathpoof")
			elseif inst.SoundEmitter ~= nil and SME.allow_sounds >= 2 then
				inst.SoundEmitter:PlaySound("dontstarve/common/deathpoof")
			end
			p:Remove()
		end
	end
end)

G.TheInput:AddKeyDownHandler( 99, function()
	if CZ() and G.TheInput:IsKeyDown(G.KEY_CTRL) and G.TheNet:GetIsServerAdmin() then
		local p = G.TheInput:GetWorldEntityUnderMouse()
		if p ~= nil then
			sme_sound("dontstarve/beefalo/hairgrow_pop",0.5)
			_Send(MOD_RPC[modname]["SME_Copy"], p, false, G.TheInput:IsKeyDown(G.KEY_SHIFT))
		end
	end
end)

-- Ctrl + X
G.TheInput:AddKeyDownHandler( 120, function()
	if CZ() and G.TheInput:IsKeyDown(G.KEY_CTRL) and G.TheNet:GetIsServerAdmin() then
		local p = G.TheInput:GetWorldEntityUnderMouse()
		if p ~= nil then
			sme_sound("dontstarve/beefalo/hairgrow_pop",0.5)
			_Send(MOD_RPC[modname]["SME_Copy"], p, true, G.TheInput:IsKeyDown(G.KEY_SHIFT))
		end
	end
end)

function _cantplacehere(p)
	local pos = G.Vector3(p.Transform:GetWorldPosition())
	local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 0.01)
	for i, v in ipairs(ents) do
		if v.prefab==p.prefab and v~=p then
			return true
		end
	end
	return false
end
local function _iswall(pref)
	if (IsStringStartsWith(tostring(pref),"fence") or IsStringStartsWith(tostring(pref),"wall_")) and not IsStringEndsWith(tostring(pref),"_item") then
		return true
	end
	return false
end
local function _canplacewall(x,y,z)
	local ents = TheSim:FindEntities(x, y, z, 0.5)
	for i, v in ipairs(ents) do
		if _iswall(v.prefab) then
			return false
		end
	end
	return true
end
local function _poswall(c)
	if type(c) == "number" then
		return (math.ceil(c)-0.5)
	end
	return 0
end
local function _distanceFormula(x1, z1, x2, z2) -- Get the distance between two points
	return math.sqrt (  ( (x1 - x2 )^2 ) + ( (z1 - z2 )^2 ) ) 
end
local function _getFactors(n) 
	local f = {}
	for i = 1, n/2 do
		if n % i == 0 then 
			f[#f+1] = i
		end
	end
	f[#f+1] = n
	return f
end
local function _tableHasValue(tabl, val)
	for k,v in pairs(tabl or {}) do
		if v == val then
			return true
		end
	end
	return false
end

-- Ctrl + V
function sme_PasteIt(inst,x,y,z,shif)
	local i = inst.userid
	if cboard[i] == nil or cboard[i].prefab == nil then return inst.components.talker:Say("SME: Clipboard is empty",0) end
	if _iswall(cboard[i].prefab) then
		if not _canplacewall(_poswall(x),0,_poswall(z)) then
			return
		end
	end
	local p = G.SpawnPrefab(cboard[i].prefab, cboard[i].skin, nil, tostring(i))
	local pc = p.components or nil
	if cboard[i].leif ~= nil then
		if p.SetLeifScale ~= nil then
			p:SetLeifScale(cboard[i].leif)
		end
	end
	if p.Transform then
		if _iswall(p.prefab) then
			p.Transform:SetPosition(_poswall(x),0,_poswall(z))
			if not shif then
				cboard[i].lastposx = _poswall(x)
				cboard[i].lastposz = _poswall(z)
			end
		else
			p.Transform:SetPosition(x,y,z)
			if not shif then
				cboard[i].lastposx = x
				cboard[i].lastposz = z
			end
		end
		p.Transform:SetScale(cboard[i].scale.l,cboard[i].scale.h,cboard[i].scale.w)
		p.Transform:SetRotation(cboard[i].rot)
	end
	if pc then
		if pc.health and cboard[i].health ~= nil then
			pc.health:DoDelta(cboard[i].health-pc.health.currenthealth, nil, cboard[i].prefab)
		end
		if pc.locomotor then
			pc.locomotor.walkspeed = cboard[i].wspeed or pc.locomotor.walkspeed
			pc.locomotor.runspeed = cboard[i].rspeed or pc.locomotor.runspeed
		end
		if pc.stackable and cboard[i].stack ~= nil then
			pc.stackable:SetStackSize(cboard[i].stack)
		end
		if pc.writeable and cboard[i].text ~= nil then
			pc.writeable:SetText(cboard[i].text)
		end
		if pc.drawable and cboard[i].image ~= nil then
			local img = G.SpawnPrefab(cboard[i].image)
			pc.drawable:OnDrawn(cboard[i].image, img)
			if img ~= nil then img:Remove() end
		end
		if pc.armor and cboard[i].armour ~= nil then
			pc.armor:SetCondition(cboard[i].armour)
		end
		if pc.growable and cboard[i].stage ~= nil then
			pc.growable:SetStage(cboard[i].stage)
			if p.AnimState then
				if p.anims ~= nil and p.anims.sway1 ~= nil and p.anims.sway2 ~= nil then
					p.AnimState:PlayAnimation(math.random() < .5 and p.anims.sway1 or p.anims.sway2, true)
				end
			end
		end
		if table.has(cboard[i].tags, "werepig") then
			p.components.werebeast:SetWere()
		end
	end
	if table.has(cboard[i].tags, "stump") then
		if p.OnLoad ~= nil then
			p:OnLoad({stump=true})
		end
	end
	if table.has(cboard[i].tags, "burnt") then
		if p.OnLoad ~= nil then
			p:OnLoad({burnt=true})
		end
	end
	if table.has(cboard[i].tags, "monster") then
		if p.OnLoad ~= nil then
			p:OnLoad({monster=true})
		end
	end
	if (_cantplacehere(p) and p.Transform) and (shif or cboard[i].overlap==false) then
		p:Remove()
	else
		if p.SoundEmitter ~= nil and SME.allow_sounds >= 2 then
			p.SoundEmitter:PlaySound("dontstarve/beefalo/saddle/dismount")
		elseif inst.SoundEmitter ~= nil and SME.allow_sounds >= 2 then
			inst.SoundEmitter:PlaySound("dontstarve/beefalo/saddle/dismount")
		end
	end
end

_Add(modname,"SME_Paste", function(inst,x,y,z,shif)
	local i = inst.userid
	if shif and cboard[i]~=nil and cboard[i].lastposx ~= nil and cboard[i].lastposz ~= nil then
		if cboard[i].linedist == nil then cboard[i].linedist = 1 end
		local dist = math.floor(_distanceFormula(x, z, cboard[i].lastposx, cboard[i].lastposz)+0.5)/cboard[i].linedist
		local angle = 0
		angle = (math.atan2((x)-(cboard[i].lastposx), (z)-(cboard[i].lastposz)) * (360 / 3.1415926535898))
		for j = 1,math.ceil(dist) do
			local k = j*cboard[i].linedist
			if angle <=(-315) or (angle >= 315 and angle <= 360) then
				sme_PasteIt(inst,cboard[i].lastposx,y,cboard[i].lastposz-k,true)
				if j >= dist then
					cboard[i].lastposx = cboard[i].lastposx
					cboard[i].lastposz = cboard[i].lastposz-k
				end
			elseif angle >= (-315) and angle <= -225 then
				if j <= dist/math.sqrt(2) then
					sme_PasteIt(inst,cboard[i].lastposx-k,y,cboard[i].lastposz-k,true)
					if j >= dist/math.sqrt(2)-1 then
						cboard[i].lastposx = cboard[i].lastposx-k
						cboard[i].lastposz = cboard[i].lastposz-k
					end
				end
			elseif angle <= (-135) then
				sme_PasteIt(inst,cboard[i].lastposx-k,y,cboard[i].lastposz,true)
				if j >= dist then
					cboard[i].lastposx = cboard[i].lastposx-k
					cboard[i].lastposz = cboard[i].lastposz
				end
			elseif angle <= (-45) then
				if j <= dist/math.sqrt(2) then
					sme_PasteIt(inst,cboard[i].lastposx-k,y,cboard[i].lastposz+k,true)
					if j >= dist/math.sqrt(2)-1 then
						cboard[i].lastposx = cboard[i].lastposx-k
						cboard[i].lastposz = cboard[i].lastposz+k
					end
				end
			elseif angle <= 45 then
				sme_PasteIt(inst,cboard[i].lastposx,y,cboard[i].lastposz+k,true)
				if j >= dist then
					cboard[i].lastposx = cboard[i].lastposx
					cboard[i].lastposz = cboard[i].lastposz+k
				end
			elseif angle <= 135 then
				if j <= dist/math.sqrt(2) then
					sme_PasteIt(inst,cboard[i].lastposx+k,y,cboard[i].lastposz+k,true)
					if j >= dist/math.sqrt(2)-1 then
						cboard[i].lastposx = cboard[i].lastposx+k
						cboard[i].lastposz = cboard[i].lastposz+k
					end
				end
			elseif angle <= 225 then
				sme_PasteIt(inst,cboard[i].lastposx+k,y,cboard[i].lastposz,true)
				if j >= dist then
					cboard[i].lastposx = cboard[i].lastposx+k
					cboard[i].lastposz = cboard[i].lastposz
				end
			else
				if j <= dist/math.sqrt(2) then
					sme_PasteIt(inst,cboard[i].lastposx+k,y,cboard[i].lastposz-k,true)
					if j >= dist/math.sqrt(2)-1 then
						cboard[i].lastposx = cboard[i].lastposx+k
						cboard[i].lastposz = cboard[i].lastposz-k
					end
				end
			end
		end
	else
		sme_PasteIt(inst,x,y,z,false)
	end
end)
G.TheInput:AddKeyDownHandler( 118, function()
	if CZ() and G.TheInput:IsKeyDown(G.KEY_CTRL) and G.TheNet:GetIsServerAdmin() then
		local pos = G.TheInput:GetWorldPosition()
		_Send(MOD_RPC[modname]["SME_Paste"], pos.x, pos.y, pos.z, G.TheInput:IsKeyDown(G.KEY_SHIFT))
	end
end)
