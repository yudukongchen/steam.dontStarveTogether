--The name of the mod displayed in the 'mods' screen.
name = "Increased Stack size 改变堆叠大小 MAX9999"

--A description of the mod.
description = [[
更改最大堆叠数(MAX9999)，堆叠动物、陷阱、工具和物品~
Change the maximum number of stacks (MAX9999),Stacked animals, Trops, Tools and items~

1.9 修复了客机叠加问题 Fixed the problem of passenger plane stacking to 1

2.0 加入了评论区的杂项在杂项选项中 Added the miscellaneous items in the comment section in the miscellaneous options

2.1 加入了武器和衣服堆叠，暂时只有基础，如需要请在评论区提出，有空会加上 
Added weapons and clothing stacks

2.2 修复了可能会导致崩溃的东西，杂项和武器项更新，如果出现问题，可以尝试关闭武器，衣服，杂项堆叠
Fixed things that may cause crashes. Miscellaneous and weapon items are updated. If there is a problem, 
you can try to turn off weapons, clothes, and miscellaneous stacks.

2.3 移除导致错误的堆叠

2.4 移除soil_amender

2.5 增加了月眼鹿角护士蜘蛛甜味儿鱼等物品的堆叠
]]
author = "MK"
 
version = "2.5"

api_version = 10

dont_starve_compatible = true
dst_compatible = true
client_only_mod = false
server_only_mod = true
all_clients_require_mod = true
standalone = false
icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {"utility"}

-- ModConfiguration option
configuration_options =
{
	{
		name = "MAXSTACKSIZE",
		label = "Max Stack Size/最大堆叠(MAX9999)",
		options =	{
						{description = "99", data = 99},
						{description = "250", data = 250},
						{description = "500", data = 500},
						{description = "999", data = 999},
						{description = "9999", data = 9999},
					},

		default = 99,
	},
	{
		name = "ANIMALSTACK",
		label = "Animal Stack/动物堆叠",
		options =	{
						{description = "Yes", data = true},
						{description = "No", data = false},
					},

		default = true,
	},
	{
		name = "EGGSTACK",
		label = "High bird eggs and eyeballs/眼球和高鸟蛋",
		options =	{
						{description = "Yes", data = true},
						{description = "No", data = false},
					},

		default = true,
	},
	{
		name = "TRAPSTACK",
		label = "Trap Stack/陷阱堆叠",
		options =	{
						{description = "Yes", data = true},
						{description = "No", data = false},
					},

		default = true,
	},
	{
		name = "TOOLSTACK",
		label = "Tool Stack/工具堆叠",
		options =	{
						{description = "Yes", data = true},
						{description = "No", data = false},
					},

		default = false,
	},
	{
		name = "WQSTACK",
		label = "Weapons Stack/武器堆叠",
		options =	{
						{description = "Yes", data = true},
						{description = "No", data = false},
					},
	
		default = false,
	},
	{
		name = "YFSTACK",
		label = "Clothing Stack/护甲堆叠",
		options =	{
						{description = "Yes", data = true},
						{description = "No", data = false},
					},
	
		default = false,
	},
	{
		name = "Miscellaneous",
		label = "Miscellaneous/杂项",
		options =	{
						{description = "Yes", data = true},
						{description = "No", data = false},
					},
	
		default = false,
	},
}

priority = 0.00374550642