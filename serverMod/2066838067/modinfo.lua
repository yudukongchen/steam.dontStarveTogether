version = "taizhen4.5.97" 
name = "【太真饿龙咆哮，嗷呜！"..version.."】（2022_11_26）"
description = "太真专属快捷键：【F1】盖亚破坏炮填充弹药；【F2】盛宴收集的亡魂隐藏或释放；【F9】关闭小太真；【F10】关闭修仙、星愿祭、文选；想了解跟多太真mod内容，欢迎加QQ群963971883”"
author = "阿平君"
modname = "taizhen"
forumthread = ""
api_version = 10
dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
all_clients_require_mod = true 
icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {
"太真",
}


local options =
{
	{description="TAB", data = 9},
	{description="KP_PERIOD", data = 266},
	{description="KP_DIVIDE", data = 267},
	{description="KP_MULTIPLY", data = 268},
	{description="KP_MINUS", data = 269},
	{description="KP_PLUS", data = 270},
	{description="KP_ENTER", data = 271},
	{description="KP_EQUALS", data = 272},
	{description="MINUS", data = 45},
	{description="EQUALS", data = 61},
	{description="SPACE", data = 32},
	{description="ENTER", data = 13},
	{description="ESCAPE", data = 27},
	{description="HOME", data = 278},
	{description="INSERT", data = 277},
	{description="DELETE", data = 127},
	{description="END", data   = 279},
	{description="PAUSE", data = 19},
	{description="PRINT", data = 316},
	{description="CAPSLOCK", data = 301},
	{description="SCROLLOCK", data = 302},
	{description="RSHIFT", data = 303}, -- use SHIFT instead
	{description="LSHIFT", data = 304}, -- use SHIFT instead
	{description="RCTRL", data = 305}, -- use CTRL instead
	{description="LCTRL", data = 306}, -- use CTRL instead
	{description="RALT", data = 307}, -- use ALT instead
	{description="LALT", data = 308}, -- use ALT instead
	{description="ALT", data = 400},
	{description="CTRL", data = 401},
	{description="SHIFT", data = 402},
	{description="BACKSPACE", data = 8},
	{description="PERIOD", data = 46},
	{description="SLASH", data = 47},
	{description="LEFTBRACKET", data     = 91},
	{description="BACKSLASH", data     = 92},
	{description="RIGHTBRACKET", data = 93},
	{description="TILDE", data = 96},
	{description="A", data = 97},
	{description="B", data = 98},
	{description="C", data = 99},
	{description="D", data = 100},
	{description="E", data = 101},
	{description="F", data = 102},
	{description="G", data = 103},
	{description="H", data = 104},
	{description="I", data = 105},
	{description="J", data = 106},
	{description="K", data = 107},
	{description="L", data = 108},
	{description="M", data = 109},
	{description="N", data = 110},
	{description="O", data = 111},
	{description="P", data = 112},
	{description="Q", data = 113},
	{description="R", data = 114},
	{description="S", data = 115},
	{description="T", data = 116},
	{description="U", data = 117},
	{description="V", data = 118},
	{description="W", data = 119},
	{description="X", data = 120},
	{description="Y", data = 121},
	{description="Z", data = 122},
	{description="F1", data = 282},
	{description="F2", data = 283},
	{description="F3", data = 284},
	{description="F4", data = 285},
	{description="F5", data = 286},
	{description="F6", data = 287},
	{description="F7", data = 288},
	{description="F8", data = 289},
	{description="F9", data = 290},
	{description="F10", data = 291},
	{description="F11", data = 292},
	{description="F12", data = 293},

	{description="UP", data = 273},
	{description="DOWN", data = 274},
	{description="RIGHT", data = 275},
	{description="LEFT", data = 276},
	{description="PAGEUP", data = 280},
	{description="PAGEDOWN", data = 281},

	{description="0", data = 48},
	{description="1", data = 49},
	{description="2", data = 50},
	{description="3", data = 51},
	{description="4", data = 52},
	{description="5", data = 53},
	{description="6", data = 54},
	{description="7", data = 55},
	{description="8", data = 56},
	{description="9", data = 57},
	{description="KP0", data = 256},
	{description="KP1", data = 257},
	{description="KP2", data = 258},
	{description="KP3", data = 259},
	{description="KP4", data = 260},
	{description="KP5", data = 261},
	{description="KP6", data = 262},
	{description="KP7", data = 263},
	{description="KP8", data = 264},
	{description="KP9", data = 265},
}

configuration_options = {
	{
        name = "Language",
        label = "Language",
        options =	{
						{description = "English", data = true},
						{description = "中文", data = false},
					},
		default = false,
    },
	{
        name = "tz_fanhao_specific",
        label = "番号系列道具使用可能",
        options =	{
						{description = "仅太真可以使用", data = true},
						{description = "所有人都能使用", data = false},
					},
		default = true,
    },
	{
        name = "packbox",
        label = "【超级包裹】制作可能",
        options =	{
						{description = "允许制作", data = true},
						{description = "禁止制作", data = false},
					},
		default = false,
    },
    {
        name = "mouse",
        label = "鼠标皮肤",
        options =	{
						{description = "大喵爪子", data = true},
						{description = "无皮肤", data = false},
					},
		default = false,
    },
    {
        name = "xunbao",
        label = "寻宝机制",
        options =	{
						{description = "开启", data = true},
						{description = "关闭", data = false},
					},
		default = true,
    },   
	{
        name = "shikong",
        label = "时空",
		hover = "达到太真群聊100级后生效",
        options =	{
						{description = "开启", data = true},
						{description = "关闭", data = false},
					},
		default = false,
    },	
	-- {
        -- name = "damagedisplay",
        -- label = "伤害显示",
        -- options =	{
						-- {description = "开启", data = true},
						-- {description = "关闭", data = false},
					-- },
		-- default = false,
    -- },	
	-- {
        -- name = "show",
        -- label = "属性显示",
        -- options =	{
						-- {description = "开启", data = true},
						-- {description = "关闭", data = false},
					-- },
		-- default = false,
    -- },	
	{
        name = "fh_xxdj",
        label = "专属番号制作修仙等级要求",
        options =	{
						{description = "初始解锁", data = 0},
						{description = "修仙等级1", data = 1},
						{description = "修仙等级2", data = 2},
						{description = "修仙等级3", data = 3},
						{description = "修仙等级4", data = 4},
						{description = "修仙等级5", data = 5},
						{description = "修仙等级6", data = 6},
						{description = "修仙等级7", data = 7},
						{description = "修仙等级8", data = 8},
						{description = "修仙等级9", data = 9},
					},
		default = 0,
    },
	{
		name = "llskkey",
		label = "太真觉醒技能",
		options = options,
		default = 114,
	},	
	{
		name = "grskkey",
		label = "太真变身技能",
		options = options,
		default = 103,
	},
}