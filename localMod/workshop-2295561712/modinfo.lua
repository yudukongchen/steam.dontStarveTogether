name = "Better Volt Goat Drop"
description = [[
Now volt goat horn is 100% chance to drop and non charged volt goat have chance to drop electric milk

1.10
- Added configuration options
]]
author = "Sorry Late"
version = "1.10"

forumthread = ""

api_version = 10

icon_atlas = "modicon.xml"
icon = "modicon.tex"

dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false
dst_compatible = true


all_clients_require_mod = true
client_only_mod = false
server_filter_tags = {}

configuration_options =
{
	{
		name = "lightning_goat_milk",
		label = "Lightning goat milk % drop",
		options = 
        {	
			{description = "10%", data = 0.10},
			{description = "20%", data = 0.20},
			{description = "30%", data = 0.30},
			{description = "40%", data = 0.40},
			{description = "50%", data = 0.50},
			{description = "60%", data = 0.60},
			{description = "70%", data = 0.70},
			{description = "80%", data = 0.80},
			{description = "90%", data = 0.90},
			{description = "100%", data = 1.00},
     	 },
	    default = 0.30,
	},
	
	{
		name = "lightning_goat_horn",
		label = "Lightning horn % drop",
		options = 
       {	
			{description = "10%", data = 0.10},
			{description = "20%", data = 0.20},
			{description = "30%", data = 0.30},
			{description = "40%", data = 0.40},
			{description = "50%", data = 0.50},
			{description = "60%", data = 0.60},
			{description = "70%", data = 0.70},
			{description = "80%", data = 0.80},
			{description = "90%", data = 0.90},
			{description = "100%", data = 1.00},
     	 },
	    default = 1.00,
	},
	
	{
		name = "charged_lightning_goat_milk",
		label = "Charged lightning milk % drop",
		options = 
       {	
			{description = "10%", data = 0.10},
			{description = "20%", data = 0.20},
			{description = "30%", data = 0.30},
			{description = "40%", data = 0.40},
			{description = "50%", data = 0.50},
			{description = "60%", data = 0.60},
			{description = "70%", data = 0.70},
			{description = "80%", data = 0.80},
			{description = "90%", data = 0.90},
			{description = "100%", data = 1.00},
     	 },
	    default = 1.00,
	},
	
	{
		name = "charged_lightning_goat_horn",
		label = "Charged lightning horn % drop",
		options = 
       {	
			{description = "10%", data = 0.10},
			{description = "20%", data = 0.20},
			{description = "30%", data = 0.30},
			{description = "40%", data = 0.40},
			{description = "50%", data = 0.50},
			{description = "60%", data = 0.60},
			{description = "70%", data = 0.70},
			{description = "80%", data = 0.80},
			{description = "90%", data = 0.90},
			{description = "100%", data = 1.00},
     	 },
	    default = 1.00,
	},
}

