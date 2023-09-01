name = "缪尔赛思/Muelsyse"  ---mod名字
description = [[明日方舟最可爱的精灵！

流形初始属性一般，但随着装备提升，可以获得爆炸的输出！五个小可爱陪你勇闯永恒大陆哦。

交流群号：364906225

制作缪缪的料理有惊喜XD

作者：阮糖面包
码师：鑫
美工：树萝莉&Mcdanno
英译：阮糖面包
特别感谢：风早Zanoku

English version available in settings

The cutest Elf in Arknights！

The initial properties of Muelsyse’s water drops are average, but with equipment upgrade in game, they will gain get explosive output! Plus, what’s better than FIVE little cuties accompany you to brave the eternal world of survival? 

To report bugs, you can either find me in QQ group: 364906225, or just directly comment in the steam mod comment section. 

Making Miu Miu's cuisine has a surprise XD Try it out! 
]]  --mod描述
author = "阮糖面包" --作者
version = "1.9" -- mod版本 上传mod需要两次的版本不一样
forumthread = ""
api_version = 10
priority = -9528

dst_compatible = true --兼容联机
dont_starve_compatible = false --不兼容原版
reign_of_giants_compatible = false --不兼容巨人DLC
all_clients_require_mod = true --所有人mod

icon_atlas = "modicon.xml" --mod图标
icon = "modicon.tex"

server_filter_tags = {  --服务器标签
	"character",
}

configuration_options = {
	{
		name = "muelsyse_xin_yysz",
		label = "语言设置 language",
		hover = "English is still being translated",
		options = {
			{ description = "中文", data = "CN" },
			{ description = "English", data = "EN" },
		},
		default = "CN",
	},
}