local tzinternalloot =
{
	["butterfly"] =
	{
		loot =
		{
			butterfly = 3
		}
	},
	
	["rabbit"] =
	{
		loot =
		{
			rabbit = 3
		}
	},
	
	["perd"] =
	{
		loot =
		{
			perd = 2
		}
	},

	["mole"] =
	{
		loot =
		{
			mole = 2,
		},

	},

	["crow"] =
	{
		loot =
		{
			crow = 3,
		}
	},

	["robin"] =
	{
		loot =
		{
			robin = 3,
		}
	},

	["robin_winter"] =
	{
		loot =
		{
			robin_winter = 3,
		}
	},

	["tz_tfsword"] =
	{
		loot =
		{
			tz_tfsword = 3,
		}
	},
	
	["canary"] =
	{
		loot =
		{
			canary = 3,
		},
	},
	["smallbird"] =
	{
		loot =
		{
			smallbird = 2,
		},
	},

---------------------------------------OK LIST

	["bunnyman"] = 
	{
		loot = 
		{
			bunnyman = 2,
		},
	},

	["pigman"] = 
	{
		loot = 
		{
			pigman = 2,
		},
	},

	["monkey"] =
	{
		loot =
		{
			monkey = 2,
		},
	},	

	["beefalo"] =
	{
		loot =
		{
			beefalo = 2,
		},
	},
	["babybeefalo"] =
	{
		loot =
		{
			babybeefalo = 2, 
		},
	},
	["mandrake"] =
	{
		loot =
		{
			mandrake = 1, 
		},
	},
	["koalefant"] =
	{
		loot =
		{
			koalefant_summer = 1,
			koalefant_winter = 1,
		},
	},

	["lightninggoat"] =
	{
		loot =
		{
			lightninggoat = 2,
		},
	},

	["bee"] =
	{
		loot =
		{
			bee = 3,
		},
	},

	["bearger"] =
	{
		loot =
		{
			bearger = 1,

		},
	},
			["krampus"] =
	{
		loot = 
		{
			krampus = 3, 
		},
	},
			["leif"] =
	{
		loot = 
		{
			leif = 2, 
		},
	},
			["leif_sparse"] =
	{
		loot = 
		{
			leif_sparse = 1, 
		},
	},
			["checheche"] =
	{
		loot = 
		{
			knight = 1, 
			bishop = 1, 
			rook = 1, 
		},
	},


	["book_birds"] =
	{
		loot = 
		{
			book_birds = 1, 
		},
	},

	["book_sleep"] =
	{
		loot = 
		{
			book_sleep = 1, 
		},
	},
	["book_brimstone"] =
	{
		loot = 
		{
			book_brimstone = 1, 
		},
	},
	["book_horticulture"] =
	{
		loot = 
		{
			book_horticulture = 1, 
		},
	},
--------------------------------------BAD LIST
	["spider"] =
	{
		loot =
		{
			spider = 3,
		},
	},

  	["spider_warrior"] =
	{
		loot =
		{
			spider_warrior= 3,
		},
	},

  	["mosquito"] =
	{
		loot =
		{
			mosquito = 3,
		},
	},

	  	["hounds"] =
	{
		loot =
		{
			hound = 3,
		},
	},

		["firehounds"] =
	{
		loot =
		{
			firehound = 3,
		},
	},

		["icehounds"] =
	{
		loot = 
		{
			icehound = 3,
		},
	},

			["merm"] =
	{
		loot = 
		{
			merm = 3,
		},
	},
			["spiderqueen"] =
	{
		loot = 
		{
			spiderqueen = 1,
		},
	},
			["worm"] =
	{
		loot = 
		{
			worm = 3, 
		},
	},
			["spider_dropper"] =
	{
		loot = 
		{
			spider_dropper = 3, 
		},
	},
			["spider_hider"] =
	{
		loot = 
		{
			spider_hider = 3, 
		},
	},
			["spider_spitter"] =
	{
		loot = 
		{
			spider_spitter = 3, 
		},
	},
			["killerbee"] =
	{
		loot = 
		{
			killerbee = 3, 
		},
	},
			["warg"] =
	{
		loot = 
		{
			warg = 1, 
		},
	},
	["slurtle"] =
	{
		loot = 
		{
			slurtle = 1, 
		},
	},
	["tz_spiritualism"] =
	{
		loot = 
		{
			tz_spiritualism = 1, 
		},
	},	
	["deerclops"] =
	{
		loot = 
		{
			deerclops = 1, 
		},
	},
}

local TreasureLootList = {}

function AddTreasureLoot(name, data)
	TreasureLootList[name] = data
end

for name, data in pairs(tzinternalloot) do
	AddTreasureLoot(name, data)
end

function GetTreasureLootDefinitionTable()
	return TreasureLootList
end

function GetTreasureLootDefinition(name)
	return TreasureLootList[name]
end

function ApplyModsToTreasureLoot()
	for name, data in pairs(TreasureLootList) do
		local modfns = ModManager:GetPostInitFns("TreasureLootPreInit", name)
		for i,modfn in ipairs(modfns) do
			print("Applying mod to treasure loot ", name)
			modfn(data)
		end
	end
end

local function GetTreasureLoot(loots)
	local lootlist = {}
	if loots then
		if loots.loot then
			for prefab, n in pairs(loots.loot) do
				if lootlist[prefab] == nil then
					lootlist[prefab] = 0
				end
				lootlist[prefab] = lootlist[prefab] + n
			end
		end
		if loots.random_loot then
			for i = 1, (loots.num_random_loot or 1), 1 do
				local prefab = weighted_random_choice(loots.random_loot)
				if prefab then
					if lootlist[prefab] == nil then
						lootlist[prefab] = 0
					end
					lootlist[prefab] = lootlist[prefab] + 1
				end
			end
		end
		if loots.chance_loot then
			for prefab, chance in pairs(loots.chance_loot) do
				if math.random() < chance then
					if lootlist[prefab] == nil then
						lootlist[prefab] = 0
					end
					lootlist[prefab] = lootlist[prefab] + 1
				end
			end
		end
		if loots.custom_lootfn then
			loots.custom_lootfn(lootlist)
		end
	end
	return lootlist
end

function GetTreasureLootList(name)
	return GetTreasureLoot(GetTreasureLootDefinition(name))
end

function SpawnTreasureLoot(name, lootdropper, pt, nexttreasure)
	if name and lootdropper ~= nil then
		if not pt then
			pt = Point(lootdropper.inst.Transform:GetWorldPosition())
		end

		if nexttreasure and nexttreasure ~= nil then
			local bottle = inst.components.lootdropper:SpawnLootPrefab("messagebottle")
			bottle.treasure = nexttreasure

		end
		--local player = GetPlayer()
		local loots = GetTreasureLootDefinition(name)
		local lootprefabs = GetTreasureLoot(loots)
		for p, n in pairs(lootprefabs) do
			for i = 1, n, 1 do
				local loot = lootdropper:SpawnLootPrefab(p, pt)
				assert(loot, "can't spawn "..tostring(p))
				if not loot.components.inventoryitem then
					-- attacker?
					--if loot.components.combat then
					--	loot.components.combat:SuggestTarget(player)
					--end
				end
			end
		end
	end
end