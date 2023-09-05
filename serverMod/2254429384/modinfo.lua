name = "更多武器"
description = "更多武器"
author = "WPX4521"
version = "1.1.6.0.5"
forumthread = ""
icon_atlas = "modicon.xml"
icon = "modicon.tex"
dont_starve_compatible = true
reign_of_giants_compatible = true
shipwrecked_compatible = true
hamlet_compatible = true
dst_compatible = true 
all_clients_require_mod=true 

-- this setting is dumb; this mod is likely compatible with all future versions
api_version = 10

configuration_options = {
{
        name = "healthdodelta",
        label = "振奋铠甲回血",
		hover = "设置振奋铠甲回血",
        options =	
		{
			{description = "默认", data = 1},
			{description = "关闭", data = 0},
		},
		default = 1,
    },
	}
