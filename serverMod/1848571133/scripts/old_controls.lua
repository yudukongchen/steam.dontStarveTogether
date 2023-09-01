function old_controls()
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
				if G.TheInput:IsKeyDown(256) then
					sme_playTurfSound(SME_tiles[i][3], pos.x, pos.y, pos.z)
					_Send(MOD_RPC[modname]["SME_SetTile"], SME_tiles[i][3], pos.x, pos.y, pos.z)
				elseif G.TheInput:IsKeyDown(270) then
					sme_playTurfSound(SME_tiles[i][4], pos.x, pos.y, pos.z)
					_Send(MOD_RPC[modname]["SME_SetTile"], SME_tiles[i][4], pos.x, pos.y, pos.z)
				elseif G.TheInput:IsKeyDown(276) then
					sme_playTurfSound(SME_tiles[i][5], pos.x, pos.y, pos.z)
					_Send(MOD_RPC[modname]["SME_SetTile"], SME_tiles[i][5], pos.x, pos.y, pos.z)
				elseif G.TheInput:IsKeyDown(275) then
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
end