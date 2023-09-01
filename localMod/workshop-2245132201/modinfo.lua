-- This information tells other players more about the mod
name = "虚空恐惧"
description = "*b站id:烤箱里的松饼\n*通过吞噬其他生物来成长\n*可以发出令人畏惧的尖叫\n*它会长得很大，真的很大"
author = "muffin"
version = "2.5" -- This is the version of the template. Change it to your own number.

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
   "character",
}

configuration_options = {
	{
        name = "tj",
        label = "体积上限",
        options =	{
						{description = "150%", data = 1.5},
						{description = "170%", data = 1.7},
						{description = "200%", data = 2},
                    --体积上限修改
						{description = "400%", data = 4},
					},
		default = 2,
    },

	{
        name = "kjs_speed",
        label = "移动速度随体积变化",
        options =	{
						{description = "开启", data = true},
						{description = "关闭", data = false},
					},
		default = false,
    },

	{
        name = "skill_one",
        label = "盛宴按键设置",
        options = {
						{description = "禁用", data = false},
						{description = "R键", data = 114},
						{description = "K键", data = 107},
						{description = "Z键", data = 122},
						{description = "X键", data = 120},
						{description = "C键", data = 99},
						{description = "V键", data = 118},
						{description = "G键", data = 103},
                        {description = "H键", data = 104},
                        {description = "U键", data = 117},
                        {description = "I键", data = 105},
                        {description = "J键", data = 106},
                        {description = "L键", data = 108},
                        {description = "M键", data = 109},
                        {description = "N键", data = 110},
                        {description = "O键", data = 111},
                        {description = "P键", data = 112},
					},
		default = 114,
    },

	{
        name = "skill_two",
        label = "咆哮按键设置",
        options = {
						{description = "禁用", data = false},
						{description = "R键", data = 114},
						{description = "K键", data = 107},
						{description = "Z键", data = 122},
						{description = "X键", data = 120},
						{description = "C键", data = 99},
						{description = "V键", data = 118},
						{description = "G键", data = 103},
                        {description = "H键", data = 104},
                        {description = "U键", data = 117},
                        {description = "I键", data = 105},
                        {description = "J键", data = 106},
                        {description = "L键", data = 108},
                        {description = "M键", data = 109},
                        {description = "N键", data = 110},
                        {description = "O键", data = 111},
                        {description = "P键", data = 112},
					},
		default = 118,
    },   
	{
		name = "R_coolingtime",
		label = "盛宴的冷却时间",
		options =
	{
		{description = "100秒", data = 100},
		{description = "200秒", data = 200},
		{description = "300秒", data = 300},
    --冷却时间修改
		{description = "60秒", data = 60},
	},
		default = 300,
	},
	{
		name = "V_coolingtime",
		label = "咆哮的冷却时间",
		options =
	{
    --冷却时间修改
		{description = "10秒", data = 10},
		{description = "20秒", data = 20},
		{description = "30秒", data = 30},
	},
		default = 30,
	},
	{
		name = "initial_health",
		label = "初始生命上限",
		options =
	{
		{description = "100", data = 100},
		{description = "125", data = 125},
		{description = "150", data = 150},
	},
		default = 150,
	},
	{
		name = "initial_hunger",
		label = "初始饥饿上限",
		options =
	{
		{description = "100", data = 100},
		{description = "200", data = 200},
		{description = "300", data = 300},
	},
		default = 300,
	},	
} 

--configuration_options = {}