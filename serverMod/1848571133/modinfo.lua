name =" Simple Map Editor Fix "
description = "For full list of features and hotkeys, look into the configuration options or the Steam Workshop page.\n\nNow works on servers with caves enabled."
author = "John Watson, Trololarion"
version = "1.26"
forumthread = ""
api_version = 10
all_clients_require_mod = true
client_only_mod = false
dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false
server_filter_tags = {}
icon_atlas = "SimpleMapEditor.xml"
icon = "SimpleMapEditor.tex"

local key_list={
	{description = "Numpad 0", data = "KP_0"},
	{description = "Numpad +", data = "KP_PLUS"},
	{description = "Left Arrow", data = "LEFT"},
	{description = "Right Arrow", data = "RIGHT"},
	{description = "Up Arrow", data = "UP"},
	{description = "Down Arrow", data = "DOWN"},
	{description = "Q", data = "Q"},
	{description = "W", data = "W"},
	{description = "E", data = "E"},
	{description = "R", data = "R"},
	{description = "T", data = "T"},
	{description = "Y", data = "Y"},
	{description = "U", data = "U"},
	{description = "I", data = "I"},
	{description = "O", data = "O"},
	{description = "P", data = "P"},
	{description = "A", data = "A"},
	{description = "S", data = "S"},
	{description = "D", data = "D"},
	{description = "F", data = "F"},
	{description = "G", data = "G"},
	{description = "H", data = "H"},
	{description = "Z", data = "Z"},
	{description = "X", data = "X"},
	{description = "C", data = "C"},
	{description = "V", data = "V"},
	{description = "B", data = "B"},
	{description = "N", data = "N"},
	{description = "M", data = "M"},
	{description = "Alt", data = "ALT"},
	{description = "Ctrl", data = "CTRL"},
	{description = "Shift", data = "SHIFT"},
}

configuration_options = {
	{
        name = "SMEconfig_NumPad",
        label = "Use Numpad?",
        options = 
        {
			{description = "Yes", data = true, hover = "Use default Numpad hotkeys"},
			{description = "No", data = false, hover = "Use alternate hotkeys"},
        },
        default = true
	},
	{
        name = "SMEconfig_IsClassic",
        label = "What control to use to place tiles?",
        options = 
        {
			{description = "Classic", data = true, hover = "Original controls developed by John Watson."},
			{description = "Advanced", data = false, hover = "New, more flexible, but less neatly designed controls by Trololarion."},
        },
        default = true
	},
	{
        name = "SMEconfig_PlaySounds",
        label = "Play sounds?",
        options = 
        {
			{description = "Yes", data = 3, hover = "Let the mod play any sound"},
			{description = "No turfs", data = 2, hover = "Don't play sounds when you place turfs"},
			{description = "Turfs only", data = 1, hover = "Only play sounds when you place turfs"},
			{description = "No", data = 0, hover = "Don't let the mod play any sound"},
        },
        default = 3
	},
	{
        name = "SMEconfig_KeySave",
        label = "Save Hotkey",
        options = 
        {
			{description = "Disable", data = 999999999, hover = "Disable this hotkey"},
			{description = "F1", data = 282, hover = "Press 'F1' to save the map"},
			{description = "F2", data = 283, hover = "Press 'F2' to save the map"},
			{description = "F3", data = 284, hover = "Press 'F3' to save the map"},
			{description = "F4", data = 285, hover = "Press 'F4' to save the map"},
			{description = "F5", data = 286, hover = "Press 'F5' to save the map"},
			{description = "F6", data = 287, hover = "Press 'F6' to save the map"},
			{description = "F7", data = 288, hover = "Press 'F7' to save the map"},
			{description = "F8", data = 289, hover = "Press 'F8' to save the map"},
			{description = "F9", data = 290, hover = "Press 'F9' to save the map"},
			{description = "F10", data = 291, hover = "Press 'F10' to save the map"},
			{description = "F11", data = 292, hover = "Press 'F11' to save the map"},
			{description = "F12", data = 293, hover = "Press 'F12' to save the map"},
        },
        default = 282
	},
	{
        name = "SMEconfig_KeyRestart",
        label = "Restart Hotkey",
        options = 
        {
			{description = "Disable", data = 999999999, hover = "Disable this hotkey"},
			{description = "F1", data = 282, hover = "Press 'F1' to save and restart"},
			{description = "F2", data = 283, hover = "Press 'F2' to save and restart"},
			{description = "F3", data = 284, hover = "Press 'F3' to save and restart"},
			{description = "F4", data = 285, hover = "Press 'F4' to save and restart"},
			{description = "F5", data = 286, hover = "Press 'F5' to save and restart"},
			{description = "F6", data = 287, hover = "Press 'F6' to save and restart"},
			{description = "F7", data = 288, hover = "Press 'F7' to save and restart"},
			{description = "F8", data = 289, hover = "Press 'F8' to save and restart"},
			{description = "F9", data = 290, hover = "Press 'F9' to save and restart"},
			{description = "F10", data = 291, hover = "Press 'F10' to save and restart"},
			{description = "F11", data = 292, hover = "Press 'F11' to save and restart"},
			{description = "F12", data = 293, hover = "Press 'F12' to save and restart"},
        },
        default = 283
	},
	{
        name = "SMEconfig_KeyRollback",
        label = "Rollback Hotkey",
        options = 
        {
			{description = "Disable", data = 999999999, hover = "Disable this hotkey"},
			{description = "F1", data = 282, hover = "Press 'F1' to rollback to last save"},
			{description = "F2", data = 283, hover = "Press 'F2' to rollback to last save"},
			{description = "F3", data = 284, hover = "Press 'F3' to rollback to last save"},
			{description = "F4", data = 285, hover = "Press 'F4' to rollback to last save"},
			{description = "F5", data = 286, hover = "Press 'F5' to rollback to last save"},
			{description = "F6", data = 287, hover = "Press 'F6' to rollback to last save"},
			{description = "F7", data = 288, hover = "Press 'F7' to rollback to last save"},
			{description = "F8", data = 289, hover = "Press 'F8' to rollback to last save"},
			{description = "F9", data = 290, hover = "Press 'F9' to rollback to last save"},
			{description = "F10", data = 291, hover = "Press 'F10' to rollback to last save"},
			{description = "F11", data = 292, hover = "Press 'F11' to rollback to last save"},
			{description = "F12", data = 293, hover = "Press 'F12' to rollback to last save"},
        },
        default = 284
	},
	{
        name = "SMEconfig_KeySwitch",
        label = "Change Character Hotkey",
        options = 
        {
			{description = "Disable", data = 999999999, hover = "Disable this hotkey"},
			{description = "F1", data = 282, hover = "Press 'F1' to reset your character"},
			{description = "F2", data = 283, hover = "Press 'F2' to reset your character"},
			{description = "F3", data = 284, hover = "Press 'F3' to reset your character"},
			{description = "F4", data = 285, hover = "Press 'F4' to reset your character"},
			{description = "F5", data = 286, hover = "Press 'F5' to reset your character"},
			{description = "F6", data = 287, hover = "Press 'F6' to reset your character"},
			{description = "F7", data = 288, hover = "Press 'F7' to reset your character"},
			{description = "F8", data = 289, hover = "Press 'F8' to reset your character"},
			{description = "F9", data = 290, hover = "Press 'F9' to reset your character"},
			{description = "F10", data = 291, hover = "Press 'F10' to reset your character"},
			{description = "F11", data = 292, hover = "Press 'F11' to reset your character"},
			{description = "F12", data = 293, hover = "Press 'F12' to reset your character"},
        },
        default = 285
	},
	-------------------------------------NEW
	{
        name = "SMEconfig_KeyPage2",
        label = "Page 2 Key",
        options = key_list,
        default = "KP_0"
	},
	{
        name = "SMEconfig_KeyPage3",
        label = "Page 3 Key",
        options = key_list,
        default = "KP_PLUS"
	},
	{
        name = "SMEconfig_KeyPage4",
        label = "Page 4 Key",
        options = key_list,
        default = "LEFT"
	},
	{
        name = "SMEconfig_KeyPage5",
        label = "Page 5 Key",
        options = key_list,
        default = "RIGHT"
	},
--	{
--		name = "SMEconfig_FeatureTurfs",
--		label = "Turf Editor",
--		options = 
--		{
--			{description = "Enable", data = true, hover = "Press 'Numpad 1-9' to place turfs, hold down 'Numpad 0' or 'Numpad +' for more kinds of turfs"},
--			{description = "Disable", data = false, hover = "Disable this feature"},
--		},
--		default = true
--	},
--	{
--		name = "SMEconfig_FeatureCopy",
--		label = "Copy & Paste",
--		options = 
--		{
--			{description = "Enable", data = true, hover = "'Ctrl' + 'C' to copy an object or turf, 'Ctrl' + 'X' to cut an object, 'Ctrl' + 'V' to paste the object or turf"},
--			{description = "Disable", data = false, hover = "Disable this feature"},
--		},
--		default = true
--	},
--	{
--		name = "SMEconfig_FeatureDelete",
--		label = "Delete Objects",
--		options = 
--		{
--			{description = "Enable", data = true, hover = "Press 'Numpad Del' to delete the object under your mouse"},
--			{description = "Disable", data = false, hover = "Disable this feature"},
--		},
--		default = true
--	},
--	{
--		name = "SMEconfig_FeatureCreative",
--		label = "Creative Mode",
--		options = 
--		{
--			{description = "Enable", data = true, hover = "Press 'Numpad /' to toggle god mode and free crafting"},
--			{description = "Disable", data = false, hover = "Disable this feature"},
--		},
--		default = true
--	},
--	{
--		name = "SMEconfig_FeatureTelepoof",
--		label = "Telepoofer",
--		options = 
--		{
--			{description = "Enable", data = true, hover = "Press 'Numpad *' to telepoof to your mouse pointer"},
--			{description = "Disable", data = false, hover = "Disable this feature"},
--		},
--		default = true
--	},
--	{
--		name = "SMEconfig_FeatureReveal",
--		label = "Reveal Map",
--		options = 
--		{
--			{description = "Enable", data = true, hover = "Press 'Numpad -' to reveal the entire map"},
--			{description = "Disable", data = false, hover = "Disable this feature"},
--		},
--		default = true
--	},
--	{
--		name = "SMEconfig_FeatureMeteor",
--		label = "Meteor Strike",
--		options = 
--		{
--			{description = "Enable", data = true, hover = "Press 'Numpad 0' + 'Numpad *' to strike a meteor at your mouse pointer"},
--			{description = "Disable", data = false, hover = "Disable this feature"},
--		},
--		default = true
--	},
--	{
--		name = "SMEconfig_FeatureLightning",
--		label = "Lightning Strike",
--		options = 
--		{
--			{description = "Enable", data = true, hover = "Press 'Numpad 0' + 'Numpad -' to strike lightning at your mouse pointer"},
--			{description = "Disable", data = false, hover = "Disable this feature"},
--		},
--		default = true
--	},
}
