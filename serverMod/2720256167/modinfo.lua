name = "无限燃料灭火器（雪球机）"
author = "moon（双月）&丫丫蔻蔻"
version = "1.08"
description = "声明：本mod基于双月的版本升级而来，对比其他版本灭火器的功能，双月版的灭火器我觉得更适用。本人能力有限，功能不足的地方请谅解，如果觉得有影响游戏平衡的地方可以在设置里面关闭，其他细节以后再优化。\n更新说明：修复冲突导致失效问题。\n版本.1.08 功能：灭火器无限燃料，灭火器燃料扩容，灭火器范围扩展，灭火器发光加强，灭火器不灭营火，灭火器范围显示，灭火器更小间距。\nQQ交流群52109022"
forumthread = ""
api_version = 10
priority = -20.1
dst_compatible = true
reign_of_giants_compatible = true
dont_starve_compatible = false
all_clients_require_mod = true
client_only_mod = false
icon_atlas = "wxmhq.xml"
icon = "wxmhq.tex"
configuration_options ={

{
        name = "mhqsj",
        label = "灭火器燃料容量",
        hover = "然后燃料添加起来也很麻烦 只不过相当于容器增加了",
        options =
        {
            	{description = "默认", data = 1, hover = "原版好像也是一天"},
            	{description = "2倍",  data = 2,  hover = ""},
            	{description = "3倍",  data = 3,  hover = ""},
            	{description = "4倍",  data = 4,  hover = ""},
            	{description = "5倍",  data = 5,  hover = ""},
            	{description = "10倍", data = 10, hover = ""},
		{description = "20倍", data = 20, hover = ""},
		{description = "50倍", data = 50, hover = ""},
		{description = "100倍", data = 100, hover = ""},
		{description = "200倍", data = 200, hover = ""},
		{description = "500倍", data = 500, hover = ""},
		{description = "1000倍", data = 1000, hover = ""},
		{description = "2000倍", data = 2000, hover = ""},
        },
        default = 1,
    },

	{
        name = "mhqfw",
        label = "灭火器灭火范围",
        hover = "",
        options =
        {
            {description = "默认", data = 1.55, hover = ""},
            {description = "2倍",  data = 2.15,  hover = ""},
            {description = "3倍",  data = 2.67,  hover = ""},
        },
        default = 1.55,
    },
	
	{
        name = "fg",
        label = "灭火器发光加强",
        hover = "",
        options =
        {
            {description = "默认", data = .8, hover = ""},
            {description = "增亮",  data = 18,  hover = ""},
            {description = "关闭",  data = 0,  hover = ""},


        },
        default = .8,
    },

{
        name = "rlkg",
        label = "灭火器无限燃料",
        hover = "关闭燃料消耗",
        options =
        {
            {description = "开启", data = 1, hover = "燃料停止消耗，燃料无限使用无需添加"},
            {description = "关闭", data = 2, hover = "原版灭火器正常消耗燃料"},
            
        },
        default = 1,
    },

{
        name = "bmyh",
        label = "灭火器不灭营火",
        hover = "不会扑灭营火",
        options =
        {
	{description = "开启", data = 2, hover = "打开功能，保护营火不灭"},
            	{description = "关闭", data = 1, hover = "关闭功能，保留扑灭营火"},
            
            
        },
        default = 1,
    },

{
        name = "fwxs",
        label = "灭火器范围显示",
        hover = "显示灭火器范围",
        options =
        {
	{description = "开启", data = 2, hover = "打开功能，显示范围"},
            	{description = "关闭", data = 1, hover = "关闭功能，不显示范围"},
            
            
        },
        default = 1,
    },

{
        name = "jzmhq",
        label = "灭火器更小间距",
        hover = "更小的建造间隔",
        options =
        {
	{description = "开启", data = 2, hover = "打开功能，更小的建造间隔"},
            	{description = "关闭", data = 1, hover = "关闭功能，原版建造间隔"},
            
            
        },
        default = 1,
    },

}