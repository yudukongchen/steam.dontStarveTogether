name = "维托里奥·维内托-Vittorio Veneto"
description = "WarshipGirls-R，意大利皇家海军（Regia Marina） 战列舰-维托里奥·维内托(BB-Vittorio Veneto)。"  
author = "铝电&阿琪&朋也&年年" --作者
version = "1.1.2" -- mod版本 上传mod需要两次的版本不一样

forumthread = ""

api_version = 10


dst_compatible = true --兼容联机


dont_starve_compatible = false 
reign_of_giants_compatible = false 


all_clients_require_mod = true 

icon_atlas = "modicon.xml" 
icon = "modicon.tex"

-- The mod's tags displayed on the server list
server_filter_tags = {  
"character",
}

configuration_options = {
	{
        name = "aoe",
        label = "群伤开关 AOE",
        hover = "AOE?",
        options =
		{
			{description = "on", data = 1, hover = "On!"},
			{description = "off", data = 0, hover = "no,I will take care of my pigs"},
			
		},
        default = 1
    },
} 