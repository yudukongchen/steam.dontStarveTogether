name = "Super Farm"
description = "You can plant 9 vegetables on the farm"
author = "DrBLOOD;updater:清晨草露"
version = "1.6.2"
icon_atlas = "farm.xml"
icon = "farm.tex"

api_version = 10

dst_compatible = true
client_only_mod = false
all_clients_require_mod = true
restart_required = false
forumthread = ""
priority = -10000
configuration_options =
{
	{
		name = "language",
		label = "Language",
		options =
		{
			{description = "EN", data = "EN"},
			{description = "CN", data = "CN"},
			{description = "RU", data = "RU"},
			{description = "FR", data = "FR"},
			{description = "ES", data = "ES"},
			{description = "KO", data = "KO"},
			{description = "PL", data = "PL"},
			{description = "BR", data = "BR"},
			{description = "JA", data = "JA"},
			{description = "TUR", data = "TUR"},
		},
		default = "EN"
	},
	{
		name = "stone",
		label = "Fence",
		options =
		{
			{description = "default", data = false},
			{description = "normalstone", data = "stone1"},
			{description = "tallstone", data = "stone2"},
			{description = "flatstone", data = "stone3"},
			{description = "fencepost", data = "stone6"},
			{description = "burntfencepost", data = "stone7"},			
			{description = "stick", data = "stone4"},
			{description = "burntstick", data = "stone8"},			
			{description = "sign", data = "stone5"},			
			{description = "rock1", data = "rock1"},
			{description = "rock2", data = "rock2"},
			{description = "bamboo", data = "bamboo"},
			{description = "coral", data = "coral"},	
		},
		default = false
	},
	{
		name = "mode",
		label = "Mode",
		options =
		{
			{description = "mini", data = "mini"},
			{description = "normal", data = "normal"},
			{description = "farm", data = "farm"},			
		},
		default = "normal"
	},
	{
		name = "plant",
		label = "Leafs",
		options =
		{
			{description = "default", data = false},
			{description = "new", data = true},
		},
		default = false
	},	
}