
name = "额外物品装备栏&UI优化"
description = "(原额外装备栏增强版)\n额外增加可选的背包、护符和罗盘装备栏，并且可以自由调整物品栏格数。同时调整UI，使得它可以自动适应物品栏，建造栏，配方弹窗与界面缩放的变化。"
author = "EvenMr, 受原五格MOD的启发"

configuration_options =
{
    {
        name = "slots_num",
        label = "物品栏格数",
		hover = "你所需要的物品栏格数",
        options = 
        {
            {description = "1", data = 1, hover = "想来点疯狂的？"},
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
        }, 
        default = 15,
    },
	
	{
        name = "backpack_slot",
        label = "背包栏",
		hover = "是否开启背包栏？",
        options = 
        {
            {description = "关闭", data = 0},
			{description = "开启", data = 1},
        }, 
        default = 1,
    },
	
	{
        name = "compass_slot",
        label = "罗盘栏",
		hover = "是否开启罗盘栏？",
        options = 
        {
            {description = "关闭", data = 0},
			{description = "开启", data = 1},
        }, 
        default = 0,
    },

    {
        name = "amulet_slot",
        label = "护符栏",
		hover = "是否开启护符栏？",
        options = 
        {
            {description = "关闭", data = 0},
			{description = "开启", data = 1},
        }, 
        default = 1,
    },
	
	{
        name = "render_strategy",
        label = "渲染策略",
		hover = "当同时装备护甲和护符时，你想显示哪个？",
        options = 
        {
            {description = "默认", data = "none"},
			{description = "护符", data = "body"},
			{description = "护甲", data = "neck"},
        }, 
        default = "neck",
    },
	
    {
        name = "enable_ui",
        label = "启用UI调整",
		hover = "是否希望使用UI优化功能？",
        options = 
        {
            {description = "关闭", data = 0},
			{description = "开启", data = 1},
        }, 
        default = 1,
    },
}