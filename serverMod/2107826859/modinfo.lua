name = "Show Range"
description = "show Firefighter catapult lightning_rod Range（Client Only）"
author = "ACLegend"
version = "1.3.0"

forumthread = ""


api_version = 10

dont_starve_compatible = true
reign_of_giants_compatible = true
shipwrecked_compatible=true
dst_compatible = true
all_clients_require_mod = false
client_only_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"


configuration_options =
{
    {
        name = "Show Range Duration",
        options =
        {
            {description = "5s", data = "5"},
			{description = "10s", data = "10"},
			{description = "15s", data = "15"},
			{description = "20s", data = "20"},
            {description = "25s", data = "25"},
            {description = "30s", data = "30"},
            {description = "60s", data = "60"},
			{description = "always", data = "-1"},
        },
        default = "10",
    }
	
}
