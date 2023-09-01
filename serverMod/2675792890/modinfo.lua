local L = locale ~= "zh" and locale ~= "zhr"
name = L and "Gem Crystal Cluster" or "宝石水晶簇"
description = ""
author = ""
version = "1.2"

forumthread = ""

dst_compatible = true
all_clients_require_mod=true
api_version = 10  

icon_atlas = "modicon.xml"
icon = "modicon.tex"

configuration_options =
{
   {
        name = "growtime",
        label = "Growth Cycle(day)/生长周期设置(天)",
        hover = "Growth Cycle(day)/生长周期设置(天)",
        options = 
        {
            {description = "1", data = 1},
            {description = "3", data = 3},
            {description = "5", data = 5},
            {description = "8", data = 8},
            {description = "10", data = 10},
        },
        default = 5,
    },
    {
        name = "gemcost",
        label = "Gem Cost/消耗宝石数量",
        hover = "Gem Cost/消耗宝石数量",
        options = 
        {
            {description = "1", data = 1},
            {description = "2", data = 2},
            {description = "3", data = 3},
            {description = "5", data = 5},
            {description = "8", data = 8},
            {description = "10", data = 10},
        },
        default = 5,
    },
}

