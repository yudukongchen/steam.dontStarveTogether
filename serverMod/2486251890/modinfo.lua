-- This information tells other players more about the mod
name = "洛忧"
description = "洛忧 \n有自己的武器\n武器可自由切換\n消耗30点细胞10点精神上线召唤怪物\nX键召唤蜘蛛, C键召唤蜘蛛展示, V键召唤深渊蠕虫"
author = "Wulmaw"
version = "5.2" -- This is the version of the template. Change it to your own number.

-- This is the URL name of the mod's thread on the forum; the part after the ? and before the first & in the url
forumthread = " "


-- This lets other players know if your mod is out of date, update it to match the current version in the game
api_version = 10

-- Compatible with Don't Starve Together
dst_compatible = true

-- Not compatible with Don't Starve
dont_starve_compatible = false
reign_of_giants_compatible = false

-- Character mods need this set to true
all_clients_require_mod = true 

icon_atlas = "modicon.xml"
icon = "modicon.tex"

-- The mod's tags displayed on the server list
server_filter_tags = {
   "洛忧",
}

configuration_options = {
	{
        name = "heal_del",
        label = "洛忧每秒生命恢复设置",
        options =	{
						{description = "1点", data = 1},
						{description = "2点", data = 2},
						{description = "3点", data = 3},
						{description = "4点", data = 4},
						{description = "5点", data = 5},
					},
		default = 3,
    },

    {
        name = "skill_one",
        label = "不死之躯按键设置", 
        options = {
                        --{description = "禁用", data = false, hover = "『禁用该技能』"},
                        {description = "R键", data = 114, hover = "『技能按键设置为R键』"},                        
                        {description = "K键", data = 107, hover = "『技能按键设置为K键』"},
                        {description = "Z键", data = 122, hover = "『技能按键设置为Z键』"},
                        {description = "X键", data = 120, hover = "『技能按键设置为X键』"},
                        {description = "C键", data = 99, hover = "『技能按键设置为C键』"},
                        {description = "G键", data = 103, hover = "『技能按键设置为G键』"},
                        {description = "H键", data = 104, hover = "『技能按键设置为H键』"},
                        {description = "U键", data = 117, hover = "『技能按键设置为U键』"},
                        {description = "I键", data = 105, hover = "『技能按键设置为I键』"},
                        {description = "J键", data = 106, hover = "『技能按键设置为J键』"},
                        {description = "L键", data = 108, hover = "『技能按键设置为L键』"},
                        {description = "M键", data = 109, hover = "『技能按键设置为M键』"},
                        {description = "N键", data = 110, hover = "『技能按键设置为N键』"},
                        {description = "O键", data = 111, hover = "『技能按键设置为O键』"},
                        {description = "P键", data = 112, hover = "『技能按键设置为P键』"},
                    },
        default = 122,
    },

    {
        name = "skill_two",
        label = "瑟西娅采集功能按键设置", 
        options = {
                        --{description = "禁用", data = false, hover = "『禁用该技能』"},
                        {description = "R键", data = 114, hover = "『技能按键设置为R键』"},                        
                        {description = "K键", data = 107, hover = "『技能按键设置为K键』"},
                        {description = "Z键", data = 122, hover = "『技能按键设置为Z键』"},
                        {description = "X键", data = 120, hover = "『技能按键设置为X键』"},
                        {description = "C键", data = 99, hover = "『技能按键设置为C键』"},
                        {description = "G键", data = 103, hover = "『技能按键设置为G键』"},
                        {description = "H键", data = 104, hover = "『技能按键设置为H键』"},
                        {description = "U键", data = 117, hover = "『技能按键设置为U键』"},
                        {description = "I键", data = 105, hover = "『技能按键设置为I键』"},
                        {description = "J键", data = 106, hover = "『技能按键设置为J键』"},
                        {description = "L键", data = 108, hover = "『技能按键设置为L键』"},
                        {description = "M键", data = 109, hover = "『技能按键设置为M键』"},
                        {description = "N键", data = 110, hover = "『技能按键设置为N键』"},
                        {description = "O键", data = 111, hover = "『技能按键设置为O键』"},
                        {description = "P键", data = 112, hover = "『技能按键设置为P键』"},
                    },
        default = 104,
    },

    {
        name = "skill_three",
        label = "瑟西娅主动攻击按键设置", 
        options = {
                        --{description = "禁用", data = false, hover = "『禁用该技能』"},
                        {description = "R键", data = 114, hover = "『技能按键设置为R键』"},                        
                        {description = "K键", data = 107, hover = "『技能按键设置为K键』"},
                        {description = "Z键", data = 122, hover = "『技能按键设置为Z键』"},
                        {description = "X键", data = 120, hover = "『技能按键设置为X键』"},
                        {description = "C键", data = 99, hover = "『技能按键设置为C键』"},
                        {description = "G键", data = 103, hover = "『技能按键设置为G键』"},
                        {description = "H键", data = 104, hover = "『技能按键设置为H键』"},
                        {description = "U键", data = 117, hover = "『技能按键设置为U键』"},
                        {description = "I键", data = 105, hover = "『技能按键设置为I键』"},
                        {description = "J键", data = 106, hover = "『技能按键设置为J键』"},
                        {description = "L键", data = 108, hover = "『技能按键设置为L键』"},
                        {description = "M键", data = 109, hover = "『技能按键设置为M键』"},
                        {description = "N键", data = 110, hover = "『技能按键设置为N键』"},
                        {description = "O键", data = 111, hover = "『技能按键设置为O键』"},
                        {description = "P键", data = 112, hover = "『技能按键设置为P键』"},
                    },
        default = 106,
    },

    {
        name = "skill_four",
        label = "召唤怪物随从按键设置", 
        options = {
                        --{description = "禁用", data = false, hover = "『禁用该技能』"},
                        {description = "R键", data = 114, hover = "『技能按键设置为R键』"},                        
                        {description = "K键", data = 107, hover = "『技能按键设置为K键』"},
                        {description = "Z键", data = 122, hover = "『技能按键设置为Z键』"},
                        {description = "X键", data = 120, hover = "『技能按键设置为X键』"},
                        {description = "C键", data = 99, hover = "『技能按键设置为C键』"},
                        {description = "G键", data = 103, hover = "『技能按键设置为G键』"},
                        {description = "H键", data = 104, hover = "『技能按键设置为H键』"},
                        {description = "U键", data = 117, hover = "『技能按键设置为U键』"},
                        {description = "I键", data = 105, hover = "『技能按键设置为I键』"},
                        {description = "J键", data = 106, hover = "『技能按键设置为J键』"},
                        {description = "L键", data = 108, hover = "『技能按键设置为L键』"},
                        {description = "M键", data = 109, hover = "『技能按键设置为M键』"},
                        {description = "N键", data = 110, hover = "『技能按键设置为N键』"},
                        {description = "O键", data = 111, hover = "『技能按键设置为O键』"},
                        {description = "P键", data = 112, hover = "『技能按键设置为P键』"},
                    },
        default = 120,
    },

    {
        name = "skill_five",
        label = "火焰攻击按键设置", 
        options = {
                        --{description = "禁用", data = false, hover = "『禁用该技能』"},
                        {description = "R键", data = 114, hover = "『技能按键设置为R键』"},                        
                        {description = "K键", data = 107, hover = "『技能按键设置为K键』"},
                        {description = "Z键", data = 122, hover = "『技能按键设置为Z键』"},
                        {description = "X键", data = 120, hover = "『技能按键设置为X键』"},
                        {description = "C键", data = 99, hover = "『技能按键设置为C键』"},
                        {description = "G键", data = 103, hover = "『技能按键设置为G键』"},
                        {description = "H键", data = 104, hover = "『技能按键设置为H键』"},
                        {description = "U键", data = 117, hover = "『技能按键设置为U键』"},
                        {description = "I键", data = 105, hover = "『技能按键设置为I键』"},
                        {description = "J键", data = 106, hover = "『技能按键设置为J键』"},
                        {description = "L键", data = 108, hover = "『技能按键设置为L键』"},
                        {description = "M键", data = 109, hover = "『技能按键设置为M键』"},
                        {description = "N键", data = 110, hover = "『技能按键设置为N键』"},
                        {description = "O键", data = 111, hover = "『技能按键设置为O键』"},
                        {description = "P键", data = 112, hover = "『技能按键设置为P键』"},
                    },
        default = 99,
    },

    {
        name = "skill_six",
        label = "瑟西娅召唤按键设置", 
        options = {
                        --{description = "禁用", data = false, hover = "『禁用该技能』"},
                        {description = "R键", data = 114, hover = "『技能按键设置为R键』"},
                        {description = "K键", data = 107, hover = "『技能按键设置为K键』"},
                        {description = "Z键", data = 122, hover = "『技能按键设置为Z键』"},
                        {description = "X键", data = 120, hover = "『技能按键设置为X键』"},
                        {description = "C键", data = 99, hover = "『技能按键设置为C键』"},
                        {description = "G键", data = 103, hover = "『技能按键设置为G键』"},
                        {description = "H键", data = 104, hover = "『技能按键设置为H键』"},
                        {description = "U键", data = 117, hover = "『技能按键设置为U键』"},
                        {description = "I键", data = 105, hover = "『技能按键设置为I键』"},
                        {description = "J键", data = 106, hover = "『技能按键设置为J键』"},
                        {description = "L键", data = 108, hover = "『技能按键设置为L键』"},
                        {description = "M键", data = 109, hover = "『技能按键设置为M键』"},
                        {description = "N键", data = 110, hover = "『技能按键设置为N键』"},
                        {description = "O键", data = 111, hover = "『技能按键设置为O键』"},
                        {description = "P键", data = 112, hover = "『技能按键设置为P键』"},
                    },
        default = 114,
    },

    {
        name = "skill_seven",
        label = "狼口按键设置", 
        options = {
                        {description = "鼠标右键", data = false, hover = "『技能按键设置为鼠标右键』"},
                        {description = "R键", data = 114, hover = "『技能按键设置为R键』"},
                        {description = "K键", data = 107, hover = "『技能按键设置为K键』"},
                        {description = "Z键", data = 122, hover = "『技能按键设置为Z键』"},
                        {description = "X键", data = 120, hover = "『技能按键设置为X键』"},
                        {description = "C键", data = 99, hover = "『技能按键设置为C键』"},
                        {description = "G键", data = 103, hover = "『技能按键设置为G键』"},
                        {description = "H键", data = 104, hover = "『技能按键设置为H键』"},
                        {description = "U键", data = 117, hover = "『技能按键设置为U键』"},
                        {description = "I键", data = 105, hover = "『技能按键设置为I键』"},
                        {description = "J键", data = 106, hover = "『技能按键设置为J键』"},
                        {description = "L键", data = 108, hover = "『技能按键设置为L键』"},
                        {description = "M键", data = 109, hover = "『技能按键设置为M键』"},
                        {description = "N键", data = 110, hover = "『技能按键设置为N键』"},
                        {description = "O键", data = 111, hover = "『技能按键设置为O键』"},
                        {description = "P键", data = 112, hover = "『技能按键设置为P键』"},
                    },
        default = false,
    },     
} 

--configuration_options = {}