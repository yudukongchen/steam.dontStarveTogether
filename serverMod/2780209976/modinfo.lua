name = "新护甲"
description = "强化护甲 \n耐久度为木甲5倍 减伤90% 防水20% 精神+1.8 二本解锁制作\n原料2金子+1木甲\n不灭铠甲 \n耐久度为1440 减伤90% 每5秒恢复15点耐久 精神+1.8  魔法二本解锁\n6骨头碎片 4活木 2金子"
author = "富萝莉"
version = "2022.10.6"

forumthread = ""

dst_compatible = true --兼容联机
dont_starve_compatible = false --不兼容单机
reign_of_giants_compatible = false --不兼容巨人
all_clients_require_mod=true --所有人mod

api_version = 10  

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {"xiaobanhua"} --服务器标签可以不写


local OPTIONS_DAMAGE_REDUCTION_VALUE = {
    {
        description = "80%",
        data = 0.8
    },
    {
        description = "85%",
        data = 0.85
    },
    {
        description = "90%（默认）",
        data = 0.90
    },
    {
        description = "95%",
        data = 0.95
    },

}
local function OptionTitle(title)
	return {
		name = title,
		options = {{description = "", data = 0}},
		default = 0,
	}
end
local SPACER = OptionTitle("")

configuration_options = {

    OptionTitle("不灭铠甲设定:"),
    {
        name = "ARMOR_BM_BLOCK_VALUE",
        label = "不灭铠甲减伤设定比例%",
        options = OPTIONS_DAMAGE_REDUCTION_VALUE,
        default = 0.90,
    },
  SPACER,
    OptionTitle("强化护甲设定:"),
    {
        name = "ARMOR_QH_BLOCK_VALUE",
        label = "强化护甲减伤设定比例%",
        options = OPTIONS_DAMAGE_REDUCTION_VALUE,
        default = 0.90,
    },
}


