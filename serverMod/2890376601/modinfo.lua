name = "宠物升级成长系统"
forumthread = ""
description =
[[
可以把宠物喂养长大，时间周期大概10天，有缓慢恢复血量的功能，靠近会有小范围的回理智效果。
1.龙蝇：可以成长为大龙蝇，拥有30点初始攻击力，后期可以通过龙蝇皮以及红宝石升级30-40-50的攻击力，且保留暴怒机制，受到大量伤害暴怒三连拍，并增加攻击速度。特殊效果：玩家可以在龙蝇身上直接烤熟食物,喂食辣椒酱大幅恢复生命。
2.座狼：可以成长为大座狼，拥有30点初始攻击力，可以通过蓝宝石和红宝石升级攻击力，30-40-50，保留咆哮技能，可以召唤3只小座狼辅助战斗，且控制周围可被收买的生物帮助作战喂食怪物千层饼大幅恢复生命。
Pets can be fed to grow up. The time period is about 10 days. It has the function of slowly recovering blood volume, and there will be a small range of sanity recovery effect when approaching.
1. Dragonfly: It can grow into a big dragonfly, with an initial attack power of 30 points. In the later stage, the attack power of 30-40-50 can be upgraded through dragonfly skin and ruby, and the fury mechanism is retained. After receiving a lot of damage, the furious three-shot, And increase attack speed. Special effect: Players can directly roast food on the dragon fly, and feed chili sauce to greatly restore life.
2. Warg: Can grow into a big warg, with 30 initial attack power, can upgrade attack power through sapphire and ruby, 30-40-50, retain roaring skills, can summon 3 little wargs to assist in battle, and control Surrounding bought mobs help Combat Feed Monster Lasagna heal significantly.
]]
author = "山草鸡"
version = "1.5.16"
api_version = 1
priority = 3
dont_starve_compatible = false
reign_of_giants_compatible = false
dst_compatible = true

all_clients_require_mod = true
client_only_mod = false
server_only_mod = false

icon_atlas = "modicon.xml"
icon = "modicon.tex"
configuration_options =
    {
	{
        name = "warghealth",
		hover = "改变獠牙战狼的生命值/Change the HP of the Warg",
        label = "座狼生命值/HP of the Warg",
        options =
        {
			{description = "800", data = 800, hover = ""},
			{description = "1000", data = 1000, hover = ""},
			{description = "1200", data = 1200, hover = ""},
			{description = "1500", data = 1500, hover = ""},
			{description = "2000", data = 2000, hover = ""},
			{description = "2500", data = 2500, hover = ""},
			{description = "3000", data = 3000, hover = ""},
			{description = "5000", data = 5000, hover = ""},
        },
        default = 1000,
    },
	{
        name = "flyhealth",
		hover = "改变战火怒龙的生命值/Change the HP of the Dragonfly",
        label = "蜻蜓生命值/HP of the Dragon",
        options =
        {
			{description = "800", data = 800, hover = ""},
			{description = "1000", data = 1000, hover = ""},
			{description = "1200", data = 1200, hover = ""},
			{description = "1500", data = 1500, hover = ""},
			{description = "2000", data = 2000, hover = ""},
			{description = "2500", data = 2500, hover = ""},
			{description = "3000", data = 3000, hover = ""},
			{description = "5000", data = 5000, hover = ""},
        },
        default = 1000,
    },
	{
        name = "warglethealth",
		hover = "可以改变战狼幼崽的生命值/Change the HP of the Warg Cub",
        label = "小座狼生命值/HP of the warg cub",
        options =
        {
			{description = "200", data = 200, hover = ""},
			{description = "400", data = 400, hover = ""},
			{description = "600", data = 600, hover = ""},
			{description = "800", data = 800, hover = ""},
			{description = "1000", data = 1000, hover = ""},
			{description = "1200", data = 1200, hover = ""},
			{description = "3000", data = 3000, hover = ""},

        },
        default = 600,
    },
	{
        name = "rehealth",
		hover = "回复1点生命值需要的秒数/Seconds required to recover 1 HP",
        label = "回血效率/Efficiency of restoring HP",
        options =
        {
			{description = "1", data = 1, hover = ""},
			{description = "2", data = 2, hover = ""},
			{description = "3", data = 3, hover = ""},
			{description = "5", data = 5, hover = ""},
			{description = "10", data = 10, hover = ""},
			{description = "15", data = 15, hover = ""},
        },
        default = 3,
    },
	{
        name = "time_warg",
		hover = "小座狼成长所需天数/days a warg needs to grow",
        label = "座狼成长天数/days a warg needs to grow",
        options =
        {
			{description = "1", data = 1, hover = ""},
			{description = "3", data = 3, hover = ""},
			{description = "5", data = 5, hover = ""},
			{description = "10", data = 10, hover = ""},
			{description = "15", data = 15, hover = ""},
			{description = "20", data = 20, hover = ""},
        },
        default = 10,
    },
	{
        name = "time_fly",
		hover = "小龙蝇成长所需天数/days a warg needs to grow",
        label = "龙蝇成长天数/days a dragon needs to grow",
        options =
        {
			{description = "1", data = 1, hover = ""},
			{description = "3", data = 3, hover = ""},
			{description = "5", data = 5, hover = ""},
			{description = "10", data = 10, hover = ""},
			{description = "15", data = 15, hover = ""},
			{description = "20", data = 20, hover = ""},
        },
        default = 10,
    },
	{
        name = "wolf",
		hover = "座狼召唤小座狼的数量/The number of small wargs summoned by the wolf",
        label = "小座狼数量/The number of small wargs",
        options =
        {
			{description = "0", data = 0, hover = ""},
			{description = "1", data = 1, hover = ""},
			{description = "2", data = 2, hover = ""},
			{description = "3", data = 3, hover = ""},
			{description = "4", data = 4, hover = ""},
			{description = "5", data = 5, hover = ""},
        },
        default = 3,
    },
}