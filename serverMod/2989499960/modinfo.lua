-- This information tells other players more about the mod
name = "豪华的营火2.11"
description = '显著的改善！ \n [ 2.11 版本 (DST 0.51 测试)]'
author = 'Mark Pick (PiKL78)'
version = "2.11 (DST 0.51 beta)"
-- Compatibility checks
dont_starve_compatible = true
reign_of_giants_compatible = true
dst_compatible = true
client_only_mod = false
all_clients_require_mod = true

-- Star of Boreas - winter + gives sanity boost
-- Star of Anchiale - heat + gives sanity boost
-- Star of Cronus - evil (nightmare fuel) or both (swaps betwen warm and cold automatically) + gives sanity boost and healing

-- This is the URL name of the mod's thread on the forum; the part after the ? and before the first & in the URL
-- Example:
-- http://forums.kleientertainment.com/showthread.php?19505-Modders-Your-new-friend-at-Klei!
-- becomes
-- 19505-Modders-Your-new-friend-at-Klei!
forumthread = "19505-Modders-Your-new-friend-at-Klei!"


-- This lets other players know if your mod is out of date, update it to match the current version in the game
api_version = 10


icon_atlas = "deluxe_firepit.xml"
icon = "deluxe_firepit.tex"
icon_atlas = "endo_firepit.xml"
icon = "endo_firepit.tex"
icon_atlas = "deluxe_endofirepit.xml"
icon = "deluxe_endofirepit.tex"
icon_atlas = "ice_star.xml"
icon = "ice_star.tex"
icon_atlas = "heat_star.xml"
icon = "heat_star.tex"

configuration_options =
{
    {
        name = "deluxeFirepitBurnRate",
        label = "Firepit Burn Rate",
        options =
        {
            {description = "25\% longer burn (default)", data = 0.75, hover = "25\% longer burn"},
            {description = "50\% longer burn", data = 0.5, hover = "50\% longer burn"},
            {description = "75\% longer burn", data = 0.25, hover = "75\% longer burn"}
       },
        default = 0.75,
    },
    {
        name = "deluxeEndoFirepitBurnRate",
        label = "Endothermic Firepit Burn Rate",
        options =
        {
            {description = "25\% longer burn (default)", data = 0.75, hover = "25\% longer burn"},
            {description = "50\% longer burn", data = 0.5, hover = "50\% longer burn"},
            {description = "75\% longer burn", data = 0.25, hover = "75\% longer burn"}
       },
        default = 0.75,
    },
    {
        name = "iceStarBurnRate",
        label = "Ice Star Burn Rate",
        options =
        {
            {description = "1 day", data = 0.72},
            {description = "3/4 day (default)", data = 0.9},
             {description = "1/2 day", data = 1.5}
       },
        default = 0.9,
    },
    {
        name = "heatStarBurnRate",
        label = "Heat Star Burn Rate",
        options =
        {
            {description = "1 day", data = 0.72},
            {description = "3/4 day (default)", data = 0.9},
             {description = "1/2 day", data = 1.5}
       },
        default = 0.9,
    },
    {
        name = "recipeCost",
        label = "Recipe Cost",
        options =
        {
            {description = "Testing only", data = "testing"},
            {description = "Beginner", data = "cheap"},
            {description = "Standard (default)", data = "standard"},
            {description = "Advanced", data = "expensive"}
      },
        default = "standard",
    },
    {
        name = "dropLoot",
        label = "FirePit - Drop Loot?",
        options =
        {
            {description = "no", data = "no"},
            {description = "yes (default)", data = "yes"}
      },
        default = "yes",
    },
    {
        name = "endoDropLoot",
        label = "Endothermic - Drop Loot?",
        options =
        {
            {description = "no", data = "no"},
            {description = "yes (default)", data = "yes"}
      },
        default = "yes",
    },
    {
        name = "iceStarDropLoot",
        label = "Ice Star - Drop Loot?",
        options =
        {
            {description = "no", data = "no"},
            {description = "yes (default)", data = "yes"}
      },
        default = "yes",
    },
    {
        name = "heatStarDropLoot",
        label = "Heat Star - Drop Loot?",
        options =
        {
            {description = "no", data = "no"},
            {description = "yes (default)", data = "yes"}
      },
        default = "yes",
    },
    {
        name = "starsSpawnHounds",
        label = "Stars Spawn Hounds?",
        options =
        {
            {description = "no (default)", data = "no"},
            {description = "yes", data = "yes"}
      },
        default = "no",
    },
}