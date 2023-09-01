name = "Sweetcage / 温馨鸟笼"

description = [[
Missing the old birdcage? Now you can have it back!
The bird can accept cooked egg, and gives back more seeds (1 or 2 crop seeds and 50% chance drops an extra regular seed, just like the old version)
Moreover, you can set the bird to never will starve (but can get sick in caves) and never need to sleep (both configurable).
怀旧款鸟笼，鸟可以吃烤熟的鸟蛋，喂作物可以吐出1个或2个作物种子，还有50%几率掉落一个普通种子。鸟笼可以设置鸟儿不会饿死(但是在洞穴中会生病)和睡觉。
]]

author = "asingingbird"

version = "1.0"

dst_compatible = true

all_clients_require_mod= false

api_version = 6

api_version_dst = 10

forumthread = ""

icon_atlas = "modicon.xml"

icon = "modicon.tex"

configuration_options =
{
    {
		name = "bird_never_starve",
		label = "Bird Never Starve / 鸟不会饿死",
		hover = "Bird Never Starve / 鸟不会饿死",
		options =	
		{
			{description = "No / 会饿死", data = false},
			{description = "Yes / 不会饿死", data = true},
		},
		default = true,
	},
    {
        name = "bird_never_sleep",
        label = "Bird Never Sleep / 鸟不会睡觉",
        hover = "Bird Never Sleep At Night / 鸟晚上不会睡觉",
        options = 
        {
			{description = "No / 会睡觉", data = false},
			{description = "Yes / 不会睡觉", data = true},
		},
		default = true,
    },
	{
		name = "bird_accept_cooked_egg",
		label = "Bird Accepts Cooked Egg / 鸟可以吃熟蛋",
		hover = "Bird Can Accept Cooked Egg And Give Back Fresh Bird Egg / 鸟可以吃烤熟的鸟蛋，掉落新鲜的鸟蛋",
		options = 
		{
			{description = "No / 关闭", data = false},
			{description = "Yes / 开启", data = true},
		},
		default = false,
	},
	{
		name = "bird_drop_more_seeds",
		label = "Bird Drops More Seeds / 掉落多个种子",
		hover = "Bird Will Drop 1 Or 2 Crop Seeds And 50% Chance Drops 1 Normal Seed (Like Old Version Birdcage) / 鸟会掉落1或2个作物种子和50%概率掉落一个普通种子 (和旧版鸟笼一样)",
		options = 
		{
			{description = "No / 关闭", data = false},
			{description = "Yes / 开启", data = true},
		},
		default = false,
	},
}