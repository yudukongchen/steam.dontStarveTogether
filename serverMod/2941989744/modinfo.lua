local L = locale ~= "zh" and locale ~= "zhr" -- true 英文  false 中文

name = "时崎狂三"
description = "永不退转的灾厄,支配时间和暗影的第三精灵"
author = "时崎狂Ⅲ、萌萌哒女王Yao、乌拉、无影水镜"
version = "1.7.0"
forumthread = "/files/file/950-extended-sample-character/"

api_version = 10
dst_compatible = true

dont_starve_compatible = false
reign_of_giants_compatible = false
all_clients_require_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {
    "character"
}

local keys = {"0","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","V","W","X","Z","0","TAB","MINUS","EQUALS","SPACE","ENTER","ESCAPE","HOME","INSERT","DELETE","END","PAUSE","PRINT","CAPSLOCK","SCROLLOCK","RSHIFT","LSHIFT","RCTRL","LCTRL","RALT","LALT","BACKSPACE","UP","DOWN","RIGHT","LEFT","PAGEUP","PAGEDOWN","F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12","PERIOD","BACKSLASH","SEMICOLON","LEFTBRACKET","RIGHTBRACKET","TILDE","KP_PERIOD","KP_DIVIDE","KP_MULTIPLY","KP_MINUS","KP_PLUS","KP_ENTER","KP_EQUALS","LSUPER","RSUPER"}

local function zhuanyi(key)
	if key == "MINUS" then
		return "-"
	elseif key == "EQUALS" then
		return "="
	elseif key == "SPACE" then
		return "空格"
	elseif key == "ENTER" then
		return "回车"
	elseif key == "ESCAPE" then
		return "Esc"
	elseif key == "CAPSLOCK" then
		return "大写"
	elseif key == "PERIOD" then
		return "."
	elseif key == "BACKSLASH" then
		return "\\"
	elseif key == "SEMICOLON" then
		return ";"
	elseif key == "LEFTBRACKET" then
		return "["
	elseif key == "RIGHTBRACKET" then
		return "]"
	elseif key == "TILDE" then
		return "~"
	elseif key == "KP_PERIOD" then
		return "小键盘 ."
	elseif key == "KP_DIVIDE" then
		return "小键盘 /"
	elseif key == "KP_MULTIPLY" then
		return "小键盘 *"
	elseif key == "KP_MINUS" then
		return "小键盘 -"
	elseif key == "KP_PLUS" then
		return "小键盘 +"
	elseif key == "KP_ENTER" then
		return "小键盘 回车"
	elseif key == "KP_EQUALS" then
		return "小键盘 ="
	elseif key == "LSUPER" then
		return "左 Win"
	elseif key == "RSUPER" then
		return "右 Win"
	elseif key == "LSHIFT" then
		return "左 Shift"
	elseif key == "RSHIFT" then
		return "右 Shift"
	elseif key == "LCTRL" then
		return "左 Ctrl"
	elseif key == "RCTRL" then
		return "右 Ctrl"
	elseif key == "LALT" then
		return "左 Alt"
	elseif key == "RALT" then
		return "右 Alt"
	else
		return key
	end
end

local keylist = {}
for i = 1, #keys do
    keylist[i] = {description = zhuanyi(keys[i]), data = keys[i]}
end
local kaiguan = {
    {description = "『是』", data = true,hover = "你已经开启了这个功能，祝您体验愉快"},
    {description = "『否』", data = false,hover = "你已经关闭了这个功能，祝您体验愉快"},
}
configuration_options =
{
	{
        name = "language",
        label = L and "Language" or "语言",
        hover = L and "Set language" or "设置语言",
        options =  {
            {description = L and "Auto" or "自动", data = "AUTO"},
            {description = "English", data = "ENG"},
            {description = "中文", data = "CHI"}, 
        },
        default = "AUTO",
    },

	{
		name = "KEY_Z",
		label = L and 'switching button' or '枪体切换按键设置',
		options = keylist,
		default = "Z",
	},	
	
	{
		name = "KEY_Z_NEW",
		label = L and 'switching Knife button' or '白之女王切换按键设置',
		options = keylist,
		default = "Z",
	},	
	{
		name = "shaodw_chance",
		label = L and 'Probability summoning shadow monsters' or '召唤影怪概率',
		options = {
			{description = "0%", data = 0},
			{description = "10%", data = 0.1},
			{description = "20%", data = 0.2},
			{description = "30%", data = 0.3},
			{description = "40%", data = 0.4},
			{description = "50%", data = 0.5},
			{description = "60%", data = 0.6},
			{description = "70%", data = 0.7},
			{description = "80%", data = 0.8},
			{description = "90%", data = 0.9},
			{description = "100%", data = 1},
		},
		default = 0.3,
	},	
	{
		name = "白之女王真实伤害",
		label =  L and 'True injury' or '白之女王造成真伤',
		hover = L and 'The Queen of White causes real injury' or '白之女王造成真伤',
		options = kaiguan,
		default = true,
	},
	{
		name = "校服降低伤害",
		label =  L and 'School uniforms reduce damage' or '校服降低伤害',
		hover = L and 'School uniforms reduce damage' or '降低多少攻击力？',
		options = {
			{description = "100%", data = 0},
			{description = "90%", data = 0.10},
			{description = "80%", data = 0.20},
			{description = "70%", data = 0.30},
			{description = "60%", data = 0.40},
			{description = "50%", data = 0.50},
			{description = "40%", data = 0.60},
			{description = "30%", data = 0.70},
			{description = "20%", data = 0.80},
			{description = "10%", data = 0.90},
			{description = "0%", data = 1.00},
		},
		default = 0.80,
	},
	
	{
		name = "枪的声音",
		label =  L and '枪的声音' or '枪的声音',
		hover = L and '枪的声音' or '枪的声音',
		options = {
			    {description = "『模拟真枪』", data = true,hover = "有点刺耳"},
				{description = "『BIOBIOBIO』", data = false,hover = "BIOBIOBIO，像是玩具枪一样"},
		},
		default = true,
	},
	
	{
		name = "解锁科技",
		label =  L and '解锁科技' or '解锁科技',
		hover = L and '是否可以给其他玩家解锁科技' or '是否可以给其他玩家解锁科技',
		options = {
			    {description = "『是』", data = true,hover = "可以给其他玩家解锁科技"},
				{description = "『否』", data = false,hover = "只能给自己解锁科技"},
		},
		default = true,
	},




}	