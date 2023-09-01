name = "高效农业 [Efficient agriculture]"
description = "更高效的农业生产方式，解放生产力！是时候告别饥荒了！\nMore efficient agricultural production methods, liberating productivity! Its time to say good-bye to starvation!"
author = "liximi"
version = "2.5.6"

forumthread = ""

dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = true
all_clients_require_mod=true

api_version = 10
priority = -9999

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {} --服务器标签可以不写

configuration_options =
{
    {
        name = "Language",
        label = "Language",
        hover = "Set Language/设置语言",
        options =
        {
            {description = "English", data = "ENGLISH"},
            {description = "中文", data = "CHINESE"},
            {description = "Auto/自动", data = "AUTO"}
        },
        default = "AUTO",
    },
    {
        name = "max store num",
        label = "max store num",
        hover = "Maximum number of items that can be stored in the fertilizer machine/肥料机器最大可存储物品的数量",
        options =
        {
            {description = "20", data = 20},
            {description = "40", data = 40},
            {description = "60", data = 60},
            {description = "80", data = 80},
        },
        default = 20,
    },
    {
        name = "coefficient of price",
        label = "coefficient of price",
        hover = "Coefficient of vending machine exchange ratio/自动贩卖机的兑换比例系数",
        options =
        {
            {description = "0.5", data = 0.5},
            {description = "0.6", data = 0.6},
            {description = "0.8", data = 0.8},
            {description = "1.0", data = 1},
            {description = "1.1", data = 1.1},
            {description = "1.2", data = 1.2},
            {description = "1.3", data = 1.3},
            {description = "1.5", data = 1.5},
        },
        default = 1,
    },
    {
        name = "refresh frequency",
        label = "refresh frequency",
        hover = "Vending machine refresh frequency (unit:day)/自动贩卖机货物刷新频率(单位:天)",
        options =
        {
            {description = "1", data = 1},
            {description = "2", data = 2},
            {description = "3", data = 3},
            {description = "4", data = 4},
            {description = "5", data = 5},
        },
        default = 2,
    },
    {
        name = "harvest machine",
        label = "harvest machine",
        hover = "Is add Auto harvest machine to game/是否加入自动收获机",
        options =
        {
            {description = "yes", data = true},
            {description = "no", data = false},
        },
        default = true,
    },
    {
        name = "seeding machine",
        label = "seeding machine",
        hover = "Is add Auto seeding machine to game/是否加入自动播种机",
        options =
        {
            {description = "yes", data = true},
            {description = "no", data = false},
        },
        default = true,
    },
    {
        name = "vending machine",
        label = "vending machine",
        hover = "Is add vending machine to game/是否加入自动贩卖机",
        options =
        {
            {description = "yes", data = true},
            {description = "no", data = false},
        },
        default = true,
    },
}