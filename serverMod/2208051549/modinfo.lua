-- This information tells other players more about the mod
name = "谛听"  ---mod名字
description = "来自漫画《有兽焉》\n感谢订阅本mod！如有BUG尽请反馈。\n1.0.5 新增一些可以听到的东西。对付大型BOSS、龙蝇治疗效果减少。\n1.0.6 增加了最大生命值配置。\n1.0.7 增加非人哉皮肤。感谢@sunriver完成皮肤代码！！\n1.0.8 更多的生命值选项。\n1.1.1 水中木皮肤BUG修复。鸣谢@mua尔虞我诈 大佬\n1.1.2 MOD专属物品栏制作"  --mod描述
author = "小猫Giovanni&Game Over" --作者
version = "1.1.2" -- mod版本 上传mod需要两次的版本不一样

-- This is the URL name of the mod's thread on the forum; the part after the ? and before the first & in the url
forumthread = ""--这啥啊 


-- This lets other players know if your mod is out of date, update it to match the current version in the game
api_version = 10

-- Compatible with Don't Starve Together
dst_compatible = true --兼容联机

-- Not compatible with Don't Starve
dont_starve_compatible = false --不兼容原版
reign_of_giants_compatible = false --不兼容巨人DLC
shipwrecked_compatible = false

-- Character mods need this set to true
all_clients_require_mod = true --所有人mod

icon_atlas = "modicon.xml" --mod图标
icon = "modicon.tex"

-- The mod's tags displayed on the server list
server_filter_tags = {  --服务器标签
"character",
}

--configuration_options = {} --mod设置
configuration_options = {
  --[[  {
        name = "Language",
        label = "语言设置(Language)",
        options =   {
                        {description = "English", data = false},
                        {description = "中文", data = true},
                    },
        default = true, --默认中文
    },]]

    {
		name = "healthcfg",
		label = "生命值设置",
		options =
		{
      {description = "30(默认)", data = 30},
    --修改生命值配置项
      {description = "60", data = 60},
      {description = "100", data = 100},
      {description = "150", data = 150},
      {description = "200", data = 200},
      {description = "300", data = 300},
      {description = "400", data = 400},
		},
		default = 30,
	},
} 