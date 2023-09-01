name = "Laser sword光影激光剑"
description = [[
作者：叶子
修改内容：
	1、装备激光剑可以回复精神值
	2、作祟激光剑可以复活
	3、删除寒冰激光剑和冰冻激光剑
	4、加入一键砍树 一键挖矿 别的工具去掉
	5、增加制作难度（40石砖块 2红宝石 2萤火虫）
	6、攻击伤害可修改（30 50 70 100 120）
	7、攻击距离可修改（1.5 2 3 4 5）
	8、移动速度可修改（1 1.2 1.5 2）
	9、发光半径可修改
	10、发光强度可修改
	11、激光剑耐久度可修改
]]
author = "yezi-叶子"
version = "1.0.3"

forumthread = ""

api_version = 10

icon_atlas = "modicon.xml"
icon = "modicon.tex"

--客户端服务器MOD
all_clients_require_mod = true

client_only_mod = false

dst_compatible = true




configuration_options =
{
    {
		name = "jgjdamage",
		label = "攻击伤害：",
		options =
		{
			{description = "30(默认)", data = 30},
			{description = "50", data = 50},
			{description = "70", data = 70},
			{description = "100", data = 100},
			{description = "120", data = 120},
		},
		default = 30,
	},
	
	{
		name = "jgjattackrange",
		label = "攻击距离：",
		options =
		{
			{description = "1.5(默认)", data = 1.5},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			-- {description = "8", data = 8},
			-- {description = "10", data = 10},
		},
		default = 1.5,
	},
	
	{
		name = "jgjmovespeedmul",
		label = "移动速度:",
		options =
		{
			{description = "1", data = 1},
			{description = "1.2(默认)", data = 1.2},
			{description = "1.5", data = 1.5},
			{description = "2", data = 2},
		},
		default = 1.2,
	},
	
	{
		name = "jgjlightradius",
		label = "光亮半径:",
		options =
		{
			{description = "0.6", data = 0.6},
			{description = "1", data = 1},
			{description = "2(默认)", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "10", data = 10},
		},
		default = 2,
	},

	{
		name = "jgjlightintensity",
		label = "光强度:",
		options =
		{
			{description = "0.3", data = 0.3},
			{description = "0.5(默认)", data = 0.5},
			{description = "0.8", data = 0.8},
		},
		default = 0.5,
	},

	
	{
		name = "jgjfiniteuses",
		label = "武器耐久度:",
		options =
		{
			{description = "500(默认)", data = 500},
			{description = "600", data = 600},
			{description = "700", data = 700},
			{description = "800", data = 800},
			{description = "1000", data = 1000},
			{description = "无耐久", data = 0},
		},
		default = 500,
	},
}