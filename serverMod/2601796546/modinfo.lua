local L = locale ~= "zh" and locale ~= "zhr" --true-英文; false-中文

-- This information tells other players more about the mod
name = L and "Asakiri the Cyborg" or "义体人·朝雾"  ---mod名字
description = L and "Only change never changes." or "唯有改变，亘古不变。" --mod描述
author = "早雾" --作者
version = "1.3" -- mod版本 上传mod需要两次的版本不一样

-- This is the URL name of the mod's thread on the forum; the part after the ? and before the first & in the url
forumthread = ""


-- This lets other players know if your mod is out of date, update it to match the current version in the game
api_version = 10

-- Compatible with Don't Starve Together
dst_compatible = true --兼容联机

-- Not compatible with Don't Starve
dont_starve_compatible = false --不兼容原版
reign_of_giants_compatible = false --不兼容巨人DLC

-- Character mods need this set to true
all_clients_require_mod = true --所有人mod

icon_atlas = "modicon.xml" --mod图标
icon = "modicon.tex"

-- The mod's tags displayed on the server list
server_filter_tags = {  --服务器标签
"character",
}

configuration_options =
{
    {name = "Title", label = L and "Language" or "语言", options = {{description = "", data = ""},}, default = "",},
    L and {
        name = "Language",
        label = "Set Language",
        hover = "Choose your language", --这个是鼠标指向选项时会显示更详细的信息
        options =
        {
            -- {description = "Auto", data = "auto"},
            {description = "English", data = "english"},
            {description = "Chinese", data = "chinese"},
        },
        default = "english",
    } or {
        name = "Language",
        label = "设置语言",
        hover = "设置mod语言。",
        options =
        {
            -- {description = "自动", data = "auto"},
            {description = "英文", data = "english"},
            {description = "中文", data = "chinese"},
        },
        default = "chinese",
    },
}