-- This information tells other players more about the mod
name = "Nanashi Mumei"
description = [[
    󰀠 HololiveEN: Nanashi Mumei 󰀠

    Stats:
        󰀍 150 󰀎 150 󰀓 200
    
    Perks:
		󰀩 Adept hunter in the dark
		󰀠 Loves Berries
		󰀀 ███ █████████ ███████████
    
    There is a config if you want to change her perks and other stats
    
    Join Hoomans here! 󰀮:
    "https://www.youtube.com/channel/UC3n5uGu18FoCy23ggWWp8tA"
            ]]
author = "ZeroRyuk, CoolChilli"
version = "1.2.5" -- This is the version of the template. Change it to your own number.

-- This lets other players know if your mod is out of date, update it to match the current version in the game
api_version = 10

-- Compatible with Don't Starve Together
dst_compatible = true

-- Not compatible with Don't Starve
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false

-- Character mods are required by all clients
all_clients_require_mod = true 

icon_atlas = "modicon.xml"
icon = "modicon.tex"

-- The mod's tags displayed on the server list
server_filter_tags = {
"character",
"animation",
}

local function Title(title)
    return {
        name=title,
        hover = "",
        options={{description = "", data = 0}},
        default = 0,
        }
end
local sounds = {'gura','walter', 'warly', 'wathgrithr', 'waxwell', 'webber', 'wendy', 'wickerbottom', 'willow', 'wilson', 'winnie', 'winona', 'wolfgang', 'woodie', 'wortox', 'wurt', 'wx78'}
local soundOptions = {}
for i = 1, #sounds, 1 do
		soundOptions[i] = {description=sounds[i],data=sounds[i]}
end
local keys = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12","LAlt","RAlt","LCtrl","RCtrl","LShift","RShift","Tab","Capslock","Space","Minus","Equals","Backspace","Insert","Home","Delete","End","Pageup","Pagedown","Print","Scrollock","Pause","Period","Slash","Semicolon","Leftbracket","Rightbracket","Backslash","Up","Down"}
local keylist = {}
local string = ""
for i = 1, #keys do
	if keys[i] == "Z" then
		keylist[i] = {description = keys[i].." (Default)", data = "KEY_"..string.upper(keys[i])}
	else
		keylist[i] = {description = keys[i], data = "KEY_"..string.upper(keys[i])}
	end
end

configuration_options = {
    Title("Language/言語"),
	{
		name = "nanashi_mumei_language", 
		label = "Language settings/言語設定",
		hover = "Set language for some speechs and descriptions.",
		options = 
		{
			{description = "Auto (Default)", data = "AUTO"},
			{description = "日本語", data = "JP", hover="固有パーク及びアイテムの台詞と説明のみ日本語翻訳対応"},
			-- {description = "中文", data = "CN", hover="Only translates perks and unique items to CN"}, -- TODO: Waiting for Corneille to translates these
			{description = "English", data = "EN"},
		},
		default = "AUTO",
	},
    Title(""),
    Title("Basic Stats"),
    {
		name = "nanashi_mumei_health",
		label = "Health 󰀍",
		hover = "How much health Nanashi Mumei has?",
		options =	
		{
			{description = "50", data = 50},
			{description = "75", data = 75},
			{description = "100", data = 100},
			{description = "125", data = 125},
			{description = "150 (Default)", data = 150},
			{description = "175", data = 175},
			{description = "200", data = 200},
			{description = "225", data = 225},
			{description = "250", data = 250},
			{description = "275", data = 275},
			{description = "300", data = 300},
		},
		default = 150,
	},
	{
		name = "nanashi_mumei_hunger",
		label = "Hunger 󰀎",
		hover = "How much hunger Nanashi Mumei has?",
		options =	
		{
			{description = "50", data = 50},
			{description = "75", data = 75},
			{description = "100", data = 100},
			{description = "125", data = 125},
			{description = "150 (Default)", data = 150},
			{description = "175", data = 175},
			{description = "200 ", data = 200},
			{description = "225", data = 225},
			{description = "250", data = 250},
			{description = "275", data = 275},
			{description = "300", data = 300},
		},
		default = 150,
	},
	{
		name = "nanashi_mumei_sanity",
		label = "Sanity 󰀓",
		hover = "How much sanity Nanashi Mumei has?",
		options =	
		{
			{description = "50", data = 50},
			{description = "75", data = 75},
			{description = "100", data = 100},
			{description = "125", data = 125},
			{description = "150", data = 150},
			{description = "175", data = 175},
			{description = "200 (Default)", data = 200},
			{description = "225", data = 225},
			{description = "250", data = 250},
			{description = "275", data = 275},
			{description = "300", data = 300},
		},
		default = 200,
	},
	{
		name = "nanashi_mumei_hunger_rate",
		label = "Hunger Rate",
		hover = "How long Nanashi Mumei takes to get hungry?",
		options =	
		{
			{description = "x0.1", data = 0.1},
			{description = "x0.2", data = 0.2},
			{description = "x0.3", data = 0.3},
			{description = "x0.4", data = 0.4},
			{description = "x0.5", data = 0.5},
			{description = "x0.6", data = 0.6},
			{description = "x0.7", data = 0.7},
			{description = "x0.8", data = 0.8},
			{description = "x0.9", data = 0.9},
			{description = "x1 (Default)", data = 1},
			{description = "x1.1", data = 1.1},
			{description = "x1.25", data = 1.25},
			{description = "x1.5", data = 1.5},
			{description = "x1.75", data = 1.75},
			{description = "x2", data = 2},
			{description = "x3", data = 3},
			{description = "x4", data = 4},
			{description = "x5", data = 5},
		},
		default = 1,	
	},
	{
		name = "nanashi_mumei_movespeed",
		label = "Movement Speed",
		hover = "How fast Nanashi Mumei can run?",
		options =	
		{
			{description = "x0.1", data = 0.1},
			{description = "x0.2", data = 0.2},
			{description = "x0.3", data = 0.3},
			{description = "x0.4", data = 0.4},
			{description = "x0.5", data = 0.5},
			{description = "x0.6", data = 0.6},
			{description = "x0.7", data = 0.7},
			{description = "x0.8", data = 0.8},
			{description = "x0.9", data = 0.9},
			{description = "x1 (Default)", data = 1},
			{description = "x1.1", data = 1.1},
			{description = "x1.25", data = 1.25},
			{description = "x1.5", data = 1.5},
			{description = "x1.75", data = 1.75},
			{description = "x2", data = 2},
			{description = "x3", data = 3},
			{description = "x4", data = 4},
			{description = "x5", data = 5},
		},
		default = 1,	
	},
	{
		name = "nanashi_mumei_dmg",
		label = "Damage Multiplier",
		hover = "Nanashi Mumei's attack damage multiplier.",
		options =	
		{
			{description = "x0.1", data = 0.1},
			{description = "x0.2", data = 0.2},
			{description = "x0.3", data = 0.3},
			{description = "x0.4", data = 0.4},
			{description = "x0.5", data = 0.5},
			{description = "x0.6", data = 0.6},
			{description = "x0.7", data = 0.7},
			{description = "x0.8", data = 0.8},
			{description = "x0.9", data = 0.9},
			{description = "x1 (Default)", data = 1},
			{description = "x1.1", data = 1.1},
			{description = "x1.25", data = 1.25},
			{description = "x1.5", data = 1.5},
			{description = "x1.75", data = 1.75},
			{description = "x2", data = 2},
			{description = "x3", data = 3},
			{description = "x4", data = 4},
			{description = "x5", data = 5},
		},
		default = 1,
	},
	Title(""),
    Title("Night Owl"),
	{
		name = "nanashi_mumei_night_owl_terror_bonus_atk",
		label = "Mumei's Bonus Damage On Terrorized Enemies",
		hover = "How much damage Mumei deals to terrorized target at night/cave (half at dusk)?",
		options =	
		{
			{description = "100%", data = 1.00},
			{description = "125% (Default)", data = 1.25},
			{description = "150%", data = 1.50},
			{description = "175%", data = 1.75},
			{description = "200% ", data = 2.00},
			{description = "225%", data = 2.25},
			{description = "250%", data = 2.50},
			{description = "275%", data = 2.75},
			{description = "300%", data = 3.00},
		},
		default = 1.25,
	},
	{
		name = "nanashi_mumei_night_owl_ms_bonus",
		label = "Mumei's Move Speed Bonus In The Dark",
		hover = "How fast Mumei moves at night/cave (half at dusk)?",
		options =	
		{
			{description = "0%", data = 0, hover="No bonus move speed"},
			{description = "10%", data = 0.1},
			{description = "20%", data = 0.2},
			{description = "30% (Default)", data = 0.3},
			{description = "40% ", data = 0.4},
			{description = "50%", data = 0.5},
			{description = "60%", data = 0.6},
			{description = "70%", data = 0.7},
			{description = "80%", data = 0.8},
			{description = "90%", data = 0.9},
			{description = "100%", data = 1, hover="2 times faster"},
			{description = "125%", data = 1.25},
			{description = "150%", data = 1.5},
			{description = "175%", data = 1.75},
			{description = "200%", data = 2, hover="3 times faster"},
		},
		default = 0.3,
	},
	{
		name = "nanashi_mumei_night_owl_work_eff_bonus",
		label = "Mumei's Work Efficiency Bonus In The Dark",
		hover = "How fast Mumei works at night/cave (half at dusk)?",
		options =	
		{
			{description = "0%", data = 0, hover="No bonus work efficiency"},
			{description = "10%", data = 0.1},
			{description = "20%", data = 0.2},
			{description = "30%", data = 0.3},
			{description = "40% ", data = 0.4},
			{description = "50% (Default)", data = 0.5},
			{description = "60%", data = 0.6},
			{description = "70%", data = 0.7},
			{description = "80%", data = 0.8},
			{description = "90%", data = 0.9},
			{description = "100%", data = 1, hover="2 times faster"},
			{description = "125%", data = 1.25},
			{description = "150%", data = 1.5},
			{description = "175%", data = 1.75},
			{description = "200%", data = 2, hover="3 times faster"},
		},
		default = 0.5,
	},
	{
		name = "nanashi_mumei_reverse_day_night_sanity_drain", 
		label = "Reverse Day/Night Sanity Drain",
		hover = "Make Mumei's sanity drain at day, not change at night?",
		options = 
		{
			{description = "Reverse (Default)", data = true},
			{description = "Normal", data = false},
		},
		default = true,
	},
    Title(""),
    Title("The Guardian's Dagger"),
	{
		name = "nanashi_mumei_dagger_dmg",
		label = "Dagger Attack Damage",
		hover = "Guardian's Dagger base attack damage.",
		options =	
		{
			{description = "15", data = 15},
			{description = "20", data = 20},
			{description = "27.2", data = 27, hover="The same as Axe"},
			{description = "34", data = 34, hover="The same as Spear"},
			{description = "40", data = 40},
			{description = "47 (Default)", data = 47},
			{description = "51", data = 51, hover="The same as Tentacle Spike"},
			{description = "57", data = 57},
			{description = "63", data = 63},
			{description = "68", data = 68, hover="The same as Dark Sword"},
			{description = "74", data = 74},
			{description = "80", data = 80},
			{description = "86", data = 86},
			{description = "92", data = 92},
			{description = "100", data = 100},
		},
		default = 47,
	},
	{
		name = "nanashi_mumei_dagger_atkspeed_bonus", 
		label = "Dagger Attack Speed",
		hover = "Guardian's Dagger attack speed.",
		options = 
		{
			{description = "Very fast", data = 0.1},
			{description = "Fast (Default)", data = 0.2},
			{description = "Normal", data = 0.4, hover="Same as regular weapon"},
			{description = "Slow", data = 0.6},
		},
		default = 0.2,
	},
	{
		name = "nanashi_mumei_dagger_usages",
		label = "Dagger Durability",
		hover = "Guardian's Dagger Durability.",
		options =	
		{
			{description = "50", data = 50},
			{description = "100", data = 100, hover="The same as Axe"},
			{description = "150 (Default)", data = 150, hover="The same as Spear"},
			{description = "200", data = 200},
			{description = "250", data = 250},
			{description = "300", data = 300},
			{description = "Infinite", data = 9999},
		},
		default = 150,
	},
	{
		name = "nanashi_mumei_dagger_throw_dura_lost_per",
		label = "Dagger Throw Durability Lost %",
		hover = "Guardian's Dagger durability lost % for each throw.",
		options =	
		{
			{description = "No loss", data = 0},
			{description = "10%", data = 0.1},
			{description = "20% (Default)", data = 0.2},
			{description = "30%", data = 0.3},
			{description = "40%", data = 0.4},
			{description = "50%", data = 0.5},
			{description = "60%", data = 0.6},
			{description = "70%", data = 0.7},
			{description = "80%", data = 0.8},
			{description = "90%", data = 0.9},
			{description = "Break", data = 1, hover="Dagger breaks when thrown"},
		},
		default = 0.2,
	},
	{
		name = "nanashi_mumei_dagger_throw_auto_equip", 
		label = "Dagger Throw Auto Equip",
		hover = "Enable auto-equip a new dagger after thrown?",
		options = 
		{
			{description = "Enable (Default)", data = true},
			{description = "Disable", data = false},
		},
		default = true,
	},
	Title(""),
    Title("Belt Lantern"),
	{
		name = "nanashi_mumei_lantern_fueltype_str", 
		label = "Belt Lantern Fuel Type",
		hover = "Which kind of fuel should belt lantern uses?",
		options = 
		{
			{description = "Lightbulb (Default)", data = "lightbulb", hover="Light Bulbs, Fireflies, Slurtle Slime"},
			{description = "Burable", data = "burnable", hover="Any burnable uses on firepit"},
			{description = "Nightmare Fuel", data = "nightmare"},
			{description = "Nitre", data = "chemical"},
			{description = "Glow Berries", data = "wormlight"},
		},
		default = "lightbulb",
	},
	{
		name = "nanashi_mumei_lantern_lighttime",
		label = "Belt Lantern Max Fuel",
		hover = "How long belt lantern can illuminate from full before light out?",
		options =	
		{
			{description = "3mins", data = 180},
			{description = "4mins", data = 240, hover="1/2 day"},
			{description = "5mins", data = 300},
			{description = "6mins", data = 360},
			{description = "7mins", data = 420},
			{description = "7m48s (Default)", data = 468, hover="Same as default lantern"},
			{description = "8mins", data = 480, hover="1 day"},
			{description = "9mins", data = 540},
			{description = "10mins", data = 600},
			{description = "11mins", data = 660},
			{description = "12mins", data = 720, hover="1 and 1/2 days"},
			{description = "13mins", data = 780},
			{description = "14mins", data = 840},
			{description = "15mins", data = 900},
			{description = "16mins", data = 960, hover="2 days"},
			{description = "Super Long", data = 999999},
		},
		default = 468,
	},
	Title(""),
    Title("Terror Debuff"),
	{
		name = "nanashi_mumei_terror_atk_debuff_multi",
		label = "Terror Atk Debuff %",
		hover = "How much % terror debuff reduces target's attack damage?",
		options =	
		{
			{description = "No Debuff", data = 1},
			{description = "10%", data = 0.9},
			{description = "20% (Default)", data = 0.8},
			{description = "30%", data = 0.7},
			{description = "40%", data = 0.6},
			{description = "50%", data = 0.5},
			{description = "60%", data = 0.4},
			{description = "70%", data = 0.3},
			{description = "80%", data = 0.2},
			{description = "90%", data = 0.1},
			{description = "100%", data = 0, hover="Victim deal no damage"},
		},
		default = 0.8,
	},
	{
		name = "nanashi_mumei_terror_movespeed_multi",
		label = "Terror Movespeed Debuff %",
		hover = "How much % terror debuff reduces target's movement speed?",
		options =	
		{
			{description = "No Debuff", data = 1},
			{description = "10%", data = 0.9},
			{description = "20% (Default)", data = 0.8},
			{description = "30%", data = 0.7},
			{description = "40%", data = 0.6},
			{description = "50%", data = 0.5},
			{description = "60%", data = 0.4},
			{description = "70%", data = 0.3},
			{description = "80%", data = 0.2},
			{description = "90%", data = 0.1},
			{description = "100%", data = 0, hover="Victim deal no damage"},
		},
		default = 0.8,
	},
	{
		name = "nanashi_mumei_terror_debuff_duration",
		label = "Terror Debuff Duration",
		hover = "How long does dagger throw terror attack debuff last?",
		options =	
		{
			{description = "5s", data = 5, hover="5 seconds"},
			{description = "8s", data = 8, hover="8 seconds"},
			{description = "10s", data = 10, hover="10 seconds"},
			{description = "20s", data = 20, hover="20 seconds"},
			{description = "30s (Default)", data = 30, hover="30 seconds"},
			{description = "40s", data = 40, hover="40 seconds"},
			{description = "50s", data = 50, hover="50 seconds"},
			{description = "60s", data = 60, hover="60 seconds"},
			{description = "70s", data = 70, hover="70 seconds"},
			{description = "80s", data = 80, hover="80 seconds"},
			{description = "90s", data = 90, hover="90 seconds"},
			{description = "100s", data = 100, hover="100 seconds"},
		},
		default = 30,
	},
	Title(""),
    Title("██████"),
	{
		name = "nanashi_mumei_killer_movespeed",
		label = "Movement Speed Bonus",
		hover = "How fast Nanashi Mumei can run in this transformation?",
		options =	
		{
			{description = "x0.1", data = 0.1},
			{description = "x0.2", data = 0.2},
			{description = "x0.3", data = 0.3},
			{description = "x0.4", data = 0.4},
			{description = "x0.5", data = 0.5},
			{description = "x0.6", data = 0.6},
			{description = "x0.7", data = 0.7},
			{description = "x0.8", data = 0.8},
			{description = "x0.9", data = 0.9},
			{description = "x1", data = 1},
			{description = "x1.1", data = 1.1},
			{description = "x1.25", data = 1.25},
			{description = "x1.5", data = 1.5},
			{description = "x1.75", data = 1.75},
			{description = "x2", data = 2},
			{description = "x3", data = 3},
			{description = "x4", data = 4},
			{description = "x5 (Default)", data = 5},
			{description = "x6", data = 6},
			{description = "x7", data = 7},
		},
		default = 5,	
	},
	{
		name = "nanashi_mumei_killer_bonus",
		label = "Mumei?'s Damage bonus",
		hover = "Extra damage when Mumei goes ██████.",
		options =	
		{
			{description = "100%", data = 1.00},
			{description = "125%", data = 1.25},
			{description = "150%", data = 1.50},
			{description = "175%", data = 1.75},
			{description = "200% (Default)", data = 2.00},
			{description = "225%", data = 2.25},
			{description = "250%", data = 2.50},
			{description = "275%", data = 2.75},
			{description = "300%", data = 3.00},
		},
		default = 2.00,
	},
	{
		name = "nanashi_mumei_killer_amulet",
		label = "Insanity inducing items",
		hover = "Items like the Nightmare amulet can trigger it.",
		options =	
		{
			{description = "TRUE", data = true},
			{description = "FALSE", data = false},
		},
		default = false,
	},
	{
		name = "nanashi_mumei_killer_autoheal",
		label = "Auto Healing",
		hover = "She will eat healing food automatically. The priority is based on the placement in the hotbar. LEFT to RIGHT, 1-0",
		options =	
		{
			{description = "TRUE", data = true},
			{description = "FALSE", data = false,hover="(CAN'T HEAL IN COMBAT!)"},
		},
		default = true,
	},
    Title(""),
    Title("Berry Lover"),
	{
		name = "nanashi_mumei_berry_bonus_hunger_gain",
		label = "Mumei's Berries Bonus Hunger",
		hover = "Bonus hunger gain when Mumei eats any berries.",
		options =	
		{
			{description = "0%", data = 1.00},
			{description = "25% (Default)", data = 1.25},
			{description = "50%", data = 1.50},
			{description = "75%", data = 1.75},
			{description = "100%", data = 2.00},
			{description = "125%", data = 2.25},
			{description = "150%", data = 2.50},
			{description = "175%", data = 2.75},
			{description = "200%", data = 3.00},
		},
		default = 1.25,
	},
	{
		name = "nanashi_mumei_bush_hat_dapperness_str",
		label = "Mumei's Bush Hat Sanity Gain",
		hover = "How much sanity Mumei recover while wearing bush hat?",
		options =	
		{
			{description = "None", data = "none"},
			{description = "Tiny", data = "tiny", hover = "Same as Garland"},
			{description = "Small", data = "small", hover = "Same as Feather Hat"},
			{description = "Medium (Default)", data = "medium", hover = "Same as Top Hat"},
			{description = "Medium Large", data = "mediumlarge", hover = "Same as Hibearnation Vest"},
			{description = "Large", data = "large", hover = "Same as Tam o' Shanter"},
			{description = "Huge", data = "huge"},
			{description = "Super Huge", data = "superhuge"},
		},
		default = "medium",
	},	
	Title(""),
    Title("Friend"),
	{
		name = "nanashi_mumei_friend_pickup", 
		label = "Pick up Berries",
		hover = "Auto Harvest Berries",
		options = 
		{
			{description = "ON (Default)", data = true},
			{description = "OFF", data = false},
		},
		default = true,
	},
    Title(""),
    Title("Others"),
	{
		name = "nanashi_mumei_aura", 
		label = "Immunity to aura",
		hover = "By default it's both negative and positive",
		options = 
		{
			{description = "Immune to Auras", data = 1},
			{description = "Immune to Negative Auras", data = 2},
			{description = "No immunity", data = 3},
		},
		default = 1,
	},
	{
		name = "nanashi_mumei_starting_items", 
		label = "Starting items",
		hover = "What items should Nanashi Mumei starts with?",
		options = 
		{
			{description = "Dagger & Lantern", data = 0},
			{description = "Dagger (Default)", data = 1},
			{description = "Nothing", data = 2},
		},
		default = 1,
	},
	{
		name = "nanashi_mumei_voice1",
		label = "Character Voice",
		hover = "What voice should Nanashi Mumei use?",
		options = soundOptions,
		default = "gura",
	},
    {
		name = "nanashi_mumei_clothes", 
		label = "Hidden Ingame Armor",
		hover = "Hides your Armor/Outer Clothing and Hats",
		options = 
		{
			{description = "ON", data = true},
			{description = "OFF (Default)", data = false},
		},
		default = false,
	},
}