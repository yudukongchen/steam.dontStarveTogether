-- This information tells other players more about the mod
name = "Maple"
description = [[
Maple (from Bofuri)

Hunger : 120
Health : 200 -> 1000
Sanity : 200
	
You don't want to get hurt
You are slow and deals reduced damage	
	
Increase your max health by eating raw monster meat
You are protected with an armor and a devouring shield
You can right click with your shield to jump on your friends
And you have some cool items to craft !

Visit the steam page to see more details !
Good luck, and don't starve !
            ]]
author = "Ealphax"
version = "1.2.3" -- This is the version of the template. Change it to your own number.

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
}

configuration_options = {

	{
		name = "MAPLE_BASE_HEALTH",
		label = "Your starting health",
		hover = "It should increase to unbalanced values.",
		options =	{
						{description = "10", data = 10, hover = "Say pal, you don't look so good."},
						{description = "100", data = 100, hover = ""},						
						{description = "150", data = 150, hover = ""},
						{description = "200", data = 200, hover = "Default."},
						{description = "250", data = 250, hover = ""},
						{description = "300", data = 300, hover = ""},
						{description = "400", data = 400, hover = ""},
						{description = "1000", data = 1000, hover = "Level max from the start, a good choice."},
						{description = "10000", data = 10000, hover = "Try to starve now."},
					},
		default = 200,
    },	
	
	{
		name = "MAPLE_BASE_HUNGER",
		label = "Your starting hunger",
		hover = "It will not increase to unbalanced values.",
		options =	{
						{description = "10", data = 10, hover = "You better find something to eat."},
						{description = "100", data = 100, hover = ""},
						{description = "120", data = 120, hover = "Default."},						
						{description = "150", data = 150, hover = ""},
						{description = "200", data = 200, hover = ""},
						{description = "250", data = 250, hover = ""},
						{description = "300", data = 300, hover = ""},
						{description = "400", data = 400, hover = ""},
						{description = "1000", data = 1000, hover = "You could eat a whole boss."},
					},
		default = 120,
    },	

	{
		name = "MAPLE_BASE_SANITY",
		label = "Your starting sanity",
		hover = "Don't get hurt!",
		options =	{
						{description = "10", data = 10, hover = "Before night comes!"},
						{description = "100", data = 100, hover = ""},
						{description = "120", data = 120, hover = ""},						
						{description = "150", data = 150, hover = ""},
						{description = "200", data = 200, hover = "Default."},
						{description = "250", data = 250, hover = ""},
						{description = "300", data = 300, hover = ""},
						{description = "400", data = 400, hover = ""},
						{description = "1000", data = 1000, hover = "This is fine."},
					},
		default = 200,
    },
	
	{
		name = "MAPLE_MAXIMUM_HEALTH",
		label = "Your maximum health",
		hover = "Choosing 1000 as default was probably an error.",
		options =	{
						{description = "200", data = 200, hover = "No level up."},
						{description = "300", data = 300, hover = ""},
						{description = "400", data = 400, hover = "Seriously, this should be the default value."},
						{description = "500", data = 500, hover = ""},
						{description = "600", data = 600, hover = ""},
						{description = "800", data = 800, hover = ""},
						{description = "1000", data = 1000, hover = "Default."},
						{description = "2000", data = 2000, hover = ""},
						{description = "10000", data = 10000, hover = "What an idea."},
					},
		default = 1000,
    },	
	
	{
		name = "MAPLE_LVLUP",
		label = "Health per raw monster meat",
		hover = "Try to not die by eating them.",
		options =	{
						{description = "1", data = 1, hover = "Take your time."},
						{description = "5", data = 5, hover = ""},
						{description = "10", data = 10, hover = "Default."},
						{description = "20", data = 20, hover = ""},
						{description = "50", data = 50, hover = "Should be fast enough."},
						{description = "100", data = 100, hover = "Good luck to reach the 10000."},
					},
		default = 10,
    },	
	
	{
		name = "MAPLE_SPEED",
		label = "Speed Modifier",
		hover = "You can go faster if you want.",
		options =	{
						{description = "x0", data = 0, hover = "You won. U're a maple tree now."},
						{description = "x0.1", data = 0.1, hover = "U're mad bro."},
						{description = "x0.2", data = 0.2, hover = "There is no point going further."},
						{description = "x0.3", data = 0.3, hover = "Not this way."},
						{description = "x0.5", data = 0.5, hover = "You was supposed to click on the right arrow."},
						{description = "x0.7", data = 0.7, hover = ""},
						{description = "x0.8", data = 0.8, hover = "Default."},
						{description = "x0.9", data = 0.9, hover = ""},
						{description = "x1", data = 1, hover = "No debuff."},
					},
		default = 0.8,
    },
	
    {
		name = "MAPLE_EAT",
		label = "Monster meat damage",
		hover = "You can eat anything if you want.",
		options =	{
						{description = "Damage", data = false, hover = "Default."},
						{description = "No damage", data = true, hover = "Not default."},
					},
		default = false,
    },

	{
		name = "MAPLE_DEVOUR",
		label = "Shield devour damage",
		hover = "You can devour anything if you want.",
		options =	{
						{description = "50", data = 50, hover = ""},
						{description = "100", data = 100, hover = "Default."},
						{description = "150", data = 150, hover = ""},
						{description = "200", data = 200, hover = ""},
						{description = "300", data = 300, hover = "That's good damage."},
						{description = "500", data = 500, hover = "This skill was nerfed for a good reason, you know?"},
						{description = "1000", data = 1000, hover = "Let me remind you that you play a defensive character."},
						{description = "2000", data = 2000, hover = "..."},
						{description = "99999", data = 99999, hover = "Woohoo. Let's oneshot anything. Oh yeah."},
					},
		default = 100,
    },
	
	{
		name = "MAPLE_PROTECTION",
		label = "Shield protection",
		hover = "You can be invincible if you want.",
		options =	{
						{description = "0%", data = 1, hover = "Why do you even hold this thing?"},
						{description = "20%", data = 0.8, hover = ""},
						{description = "50%", data = 0.5, hover = "Default."},
						{description = "80%", data = 0.2, hover = ""},
						{description = "90%", data = 0.1, hover = ""},
						{description = "95%", data = 0.05, hover = "You are near invincible."},
						{description = "100%", data = 0, hover = "Now you are. GG."},
					},
		default = 0.5,
    },
	
	{
		name = "MAPLE_HALO",
		label = "Duration of the halo",
		hover = "You can stay an angel if you want.",
		options =	{
						{description = "1 day", data = 1, hover = ""},
						{description = "2 days", data = 2, hover = ""},
						{description = "3 days", data = 3, hover = ""},
						{description = "6 days", data = 6, hover = "Default."},
						{description = "12 days", data = 12, hover = ""},
						{description = "24 days", data = 24, hover = ""},
						{description = "18750 days", data = 18750, hover = "Radioactive light."},
					},
		default = 6,
    },
	
	{
		name = "MAPLE_HALO_PROTECTION",
		label = "Protection of the halo",
		hover = "You can be a true guardian angel if you want.",
		options =	{
						{description = "0%", data = 1, hover = "Remove Protection."},
						{description = "20%", data = 0.8, hover = ""},
						{description = "50%", data = 0.5, hover = "Default."},
						{description = "80%", data = 0.2, hover = ""},
						{description = "100%", data = 0, hover = "*Sad Deerclops noises*"},
					},
		default = 0.5,
    },

	{
		name = "MAPLE_POISON",
		label = "Poison damage over 5s",
		hover = "You can be as cruel as you want.",
		options =	{
						{description = "30", data = 3, hover = ""},
						{description = "50", data = 5, hover = "Default."},
						{description = "70", data = 7, hover = ""},
						{description = "100", data = 10, hover = ""},
						{description = "200", data = 20, hover = "You are so cruel."},
						{description = "300", data = 30, hover = "No one will like you."},
						{description = "500", data = 50, hover = "Pls stop."},
						{description = "1000", data = 100, hover = "NO, MAPLE, NOOOO!!!"},
						{description = "2000", data = 200, hover = "AAARGHH--"},
					},
		default = 5,
    },
	
	{
		name = "MAPLE_LASER_DAMAGE",
		label = "Damage dealt by lasers",
		hover = "You can destroy the world you want.",
		options =	{
						{description = "100", data = 100, hover = "20 ammo recommended."},
						{description = "200", data = 200, hover = "Default. 10 ammo recommended."},
						{description = "300", data = 300, hover = "7 ammo recommended."},
						{description = "400", data = 400, hover = "5 ammo recommended."},
						{description = "1000", data = 1000, hover = "Now that's realistic!"},
						{description = "2000", data = 2000, hover = "1 shot should be enough."},
						{description = "10000", data = 10000, hover = "When you come back from a long workday."},
					},
		default = 200,
    },
	
	{
		name = "MAPLE_LASER_AMMO",
		label = "Laser ammunition",
		hover = "You can shoot as much you want.",
		options =	{
						{description = "1", data = 100, hover = "Don't miss it!"},
						{description = "5", data = 20, hover = "400 damage recommended."},
						{description = "7", data = 15, hover = "300 damage recommended."},
						{description = "10", data = 10, hover = "Default. 200 damage recommended."},
						{description = "20", data = 5, hover = "100 damage recommended."},
						{description = "100", data = 1, hover = "That's pretty addictive heh?"},
					},
		default = 10,
    },
	
}
