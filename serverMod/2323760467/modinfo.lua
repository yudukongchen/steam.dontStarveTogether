name = "Friendly Skeleton AI"
description = "Get the help of your skeletons servant!"
author = "DrBLOOD, temiruya"
version = "1.221"

forumthread = ""

--api_version = 6
api_version = 10

--dont_starve_compatible = true
--reign_of_giants_compatible = true
--shipwrecked_compatible = true
--hamlet_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false
hamlet_compatible = false
dst_compatible = true

all_clients_require_mod = true
client_only_mod = false

icon_atlas = "skeletonaimod.xml"
icon = "skeletonaimod.tex"

priority = -1

local opt_Empty = {{description = "", data = 0}}
local function Title(title,hover)
return {
name=title,
hover=hover,
options=opt_Empty,
default=0,
}
end
local SEPARATOR = Title("")

configuration_options =
{
	{
		name = "skeleton_passerby_sinkhole",
		label = "Passerby Sinkhole",
        hover = "A Skeleton can go and come through Sinkhole by himself.",
		options =
		{
			{description = "Enable",  data = true,  hover = "A Skeleton can pass through Sinkhole."},
			{description = "Disable", data = false, hover = "A Skeleton can,t pass through Sinkhole."},
		},
		default = true,
	},
	{
		name = "skeleton_start",
		label = "Starting Items",
        hover = "Number of Skeletons for starting items",
		options =
		{
			{description = "None",     data = 0, hover = "You start to play with no Skeleton"},
			{description = "1S",       data = 1, hover = "With 1 Servant"},
			{description = "1S,1W",    data = 2, hover = "With 1 Servant, 1 Warrior"},
			{description = "1S,1W,1M", data = 3, hover = "With 1 Servant, 1 Warrior, 1 Mage"},
			{description = "1S,2W",    data = 4, hover = "With 1 Servant, 2 Warriors"},
			{description = "1S,2W,1M", data = 5, hover = "With 1 Servant, 2 Warriors, 1 Mage"},
		},
		default = 1,
	},
	{
		name = "skeleton_revive",
		label = "Rrsurrection",
        hover = "You can employ the lying skeleton on the ground.",
		options =
		{
			{description = "Enable",  data = true,  hover = "Giving a Telltale Heart to him."},
			{description = "Disable", data = false, hover = "No way"},
		},
		default = true,
	},

	Title("SERVANT"),
	{
		name = "skeleton_tough_servant",
		label = "Tough Servant",
        hover = "Damage absorption of a Servant.",
		options =
		{
			{description = "20%", data = 0.2, hover = "20% damage absorption"},
			{description = "40%", data = 0.4, hover = "40% damage absorption"},
			{description = "60%", data = 0.6, hover = "60% damage absorption"},
			{description = "80%", data = 0.8, hover = "80% damage absorption"},
			{description = "80%", data = 0.96, hover = "96% damage absorption"},
		},
		default = 0.8,
	},
	{
		name = "skeleton_backpacking",
		label = "Backpackers",
        hover = "A Servant can pick up Backpack on the ground, and equip it.",
		options =
		{
			{description = "Enable",  data = true,  hover = "A Servant can equip Backpack."},
			{description = "Disable", data = false, hover = "A Servant can't equip Backpack."},
		},
		default = true,
	},
	{
		name = "skeleton_freezer",
		label = "Keeping foods fresh",
        hover = "A Servant keeps foods fresh which he has.",
		options =
		{
			{description = "Enable",  data = true,  hover = "Food keeps freshness."},
			{description = "Disable", data = false, hover = "Foods rot."},
		},
		default = true,
	},
	{
		name = "skeleton_leaveGunpowder",
		label = "Ignoreing a Gunpowder",
        hover = "A Servant ignores Gunpowder on the ground.",
		options =
		{
			{description = "Enable",  data = true,  hover = "A Servant ignores Gunpowder on the ground."},
			{description = "Disable", data = false, hover = "A Servant picks up Gunpowder on the ground."},
		},
		default = true,
	},
	{
		name = "skeleton_pickupHamBat",
		label = "Picking up a Ham Bat",
        hover = "A Servant picks up Ham Bat on the ground.",
		options =
		{
			{description = "Enable",  data = true,  hover = "A Servant picks up Ham Bat on the ground."},
			{description = "Disable", data = false, hover = "A Servant ignores Ham Bat on the ground."},
		},
		default = true,
	},

	Title("WARRIOR"),
	{
		name = "skeleton_tough_warrior",
		label = "Tough Warrior",
        hover = "Damage absorption of an Warrior.",
		options =
		{
			{description = "20%", data = 0.2, hover = "20% damage absorption"},
			{description = "40%", data = 0.4, hover = "40% damage absorption"},
			{description = "60%", data = 0.6, hover = "60% damage absorption"},
			{description = "80%", data = 0.8, hover = "80% damage absorption"},
			{description = "80%", data = 0.96, hover = "96% damage absorption"},
		},
		default = 0.8,
	},
	{
		name = "skeleton_lantern",
		label = "Lighting Equipments",
        hover = "Lighting which Warrior equips in night.",
		options =
		{
			{description = "Torch",   data = false, hover = "A Warrior equips Torch in night."},
			{description = "Lantern", data = true,  hover = "A Warrior equips Lantern in night."},
		},
		default = true,
	},

	Title("MAGE"),
	{
		name = "skeleton_tough_mage",
		label = "Tough Mage",
        hover = "Damage absorption of a Mage.",
		options =
		{
			{description = "20%", data = 0.2, hover = "20% damage absorption"},
			{description = "40%", data = 0.4, hover = "40% damage absorption"},
			{description = "60%", data = 0.6, hover = "60% damage absorption"},
			{description = "80%", data = 0.8, hover = "80% damage absorption"},
			{description = "80%", data = 0.96, hover = "96% damage absorption"},
		},
		default = 0.8,
	},
}
