
name = "Slots Tweak & UI optimizer"
description = "Adds fully optional backpack, amulet and compass slots to the game. And you can set the inventory slots number you want with it. The UI can now automatically fit the changes for slots, crafttab, recipe popup and HUD scale."
author = "EvenMr, inspired by the original Extra Equip Slots MOD"
version = "2.0.6"

forumthread = ""

api_version = 6
api_version_dst = 10
priority = 10

all_clients_require_mod = true
client_only_mod = false

dont_starve_compatible = true
reign_of_giants_compatible = true
shipwrecked_compatible = true
dst_compatible = true

server_filter_tags = {"slots tweak"}

icon_atlas = "modicon.xml"
icon = "modicon.tex"

configuration_options =
{
    {
        name = "slots_num",
        label = "Inventory Slots #",
		hover = "The number of inventory slots that you need.",
        options = 
        {
            {description = "1", data = 1, hover = "Wanna try something crazy?"},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "10", data = 10},
			{description = "15", data = 15},
			{description = "20", data = 20},
			{description = "25", data = 25},
			{description = "30", data = 30},
			{description = "40", data = 40},
			{description = "35", data = 35},
        }, 
        default = 15,
    },
	
	{
        name = "backpack_slot",
        label = "Backpack Slot On/Off",
		hover = "Do you want the backpack slot on or off?",
        options = 
        {
            {description = "Off", data = 0},
			{description = "On", data = 1},
        }, 
        default = 1,
    },
	
	{
        name = "compass_slot",
        label = "Compass Slot On/Off",
		hover = "Do you want the compass slot on or off?",
        options = 
        {
            {description = "Off", data = 0},
			{description = "On", data = 1},
        }, 
        default = 0,
    },

    {
        name = "amulet_slot",
        label = "Amulet Slot On/Off",
		hover = "Do you want the Amulet slot on or off?",
        options = 
        {
            {description = "Off", data = 0},
			{description = "On", data = 1},
        }, 
        default = 1,
    },
	
	{
        name = "render_strategy",
        label = "Rendering strategy",
		hover = "Which one would you like to render when both amulets and armors are equipped?",
        options = 
        {
            {description = "Default", data = "none"},
			{description = "Amulets", data = "body"},
			{description = "Armor", data = "neck"},
        }, 
        default = "neck",
    },
	
    {
        name = "enable_ui",
        label = "Enable UI Tweaks",
		hover = "Do you want the UI optimization function?",
        options = 
        {
            {description = "Off", data = 0},
			{description = "On", data = 1},
        }, 
        default = 1,
    },
}