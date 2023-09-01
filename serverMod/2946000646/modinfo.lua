name = "几何布局(Geometric Placement)"
description = "对配置界面和游戏内界面进行汉化。\n原模组链接：https://steamcommunity.com/sharedfiles/filedetails/?id=351325790"
author = "rezecib 汉化：ByrneShaw"
version = "3.2.0"

forumthread = "/files/file/1108-geometric-placement/"

api_version = 6
api_version_dst = 10

priority = -10

-- Compatible with the base game, RoG, SW, and DST
dont_starve_compatible = true
reign_of_giants_compatible = true
shipwrecked_compatible = true
hamlet_compatible = true
dst_compatible = true

icon_atlas = "geometricplacement.xml"
icon = "geometricplacement.tex"

--These let clients know if they need to get the mod from the Steam Workshop to join the game
all_clients_require_mod = false

--This determines whether it causes a server to be marked as modded (and shows in the mod list)
client_only_mod = true

--This lets people search for servers with this mod by these tags
server_filter_tags = {}

local smallgridsizeoptions = {}
for i=0,10 do smallgridsizeoptions[i+1] = {description=""..(i*2).."", data=i*2} end
local medgridsizeoptions = {}
for i=0,10 do medgridsizeoptions[i+1] = {description=""..(i).."", data=i} end
local biggridsizeoptions = {}
for i=0,5 do biggridsizeoptions[i+1] = {description=""..(i).."", data=i} end

local KEY_A = 65
local keyslist = {}
local string = "" -- can't believe I have to do this... -____-
for i = 1, 26 do
	local ch = string.char(KEY_A + i - 1)
	keyslist[i] = {description = ch, data = ch}
end
keyslist[27] = {description = "禁用", data = ""}

local percent_options = {}
for i = 1, 10 do
	percent_options[i] = {description = i.."0%", data = i/10}
end
percent_options[11] = {description = "无限制", data = false}

local placer_color_options = {
	{description = "绿色", data = "green", hover = "标准绿色"},
	{description = "蓝色", data = "blue", hover = "蓝色，如果你是红/绿色盲的话，用处很大"},
	{description = "红色", data = "red", hover = "标准红色"},
	{description = "白色", data = "white", hover = "明亮的白色，以提高辨识度"},
	{description = "黑色", data = "black", hover = "黑色，与鲜明的颜色形成对比"},
}
local color_options = {}
for i = 1, #placer_color_options do
	color_options[i] = placer_color_options[i]
end
color_options[#color_options+1] = {description = "描边白", data = "whiteoutline", hover = "白色带黑色轮廓，以获得最佳辨识度"}
color_options[#color_options+1] = {description = "描边黑", data = "blackoutline", hover = "黑色带白色轮廓，以获得最佳辨识度"}
local hidden_option = {description = "隐藏", data = "hidden", hover = "完全隐藏起来，反正你也不需要看到这个，对吧？"}
placer_color_options[#placer_color_options+1] = hidden_option
color_options[#color_options+1] = hidden_option

configuration_options =
{
	{
		name = "CTRL",
		label = "CTRL键切换MOD状态：",
		options =	{
						{description = "开启", data = true},
						{description = "关闭", data = false},
					},
		default = false,
		hover = "按住CTRL键开启或关闭MOD",
	},
    {
        name = "KEYBOARDTOGGLEKEY",
        label = "修改选项按键：",
        options = keyslist,
        default = "B",
		-- hover = "A key to open the mod's options. On controllers, open\nthe scoreboard and then use Menu Misc 3 (left stick click).\nI recommend setting this with the Settings menu in DST.",
		hover = "设置的按键能够在游戏中打开MOD的选项菜单",
    },    
    {
        name = "GEOMETRYTOGGLEKEY",
        label = "切换布局按键：",
        options = keyslist,
        default = "V",
		-- hover = "A key to toggle to the most recently used geometry\n(for example, switching between Square and X-Hexagon). No controller binding.\nI recommend setting this with the Settings menu in DST.",
		hover = "设置的按键能够在游戏中切换布局",
    },    
    {
        name = "SNAPGRIDKEY",
        label = "快速布局按键：",
        options = keyslist,
        default = "",
		-- hover = "A key to snap the grid to have a point centered on the hovered object or point. No controller binding.\nI recommend setting this with the Settings menu in DST.",
		hover = "设置的按键能够在游戏中快速布局",
    },    
    {
        name = "SHOWMENU",
        label = "游戏内菜单：",
		options =	{
						{description = "开启", data = true},
						{description = "关闭", data = false},
					},
        default = true,
		hover = "开启后，能够在游戏中打开MOD的配置菜单。\n关闭后，此按键只能切换MOD的开关状态",
    },    
	{
		name = "BUILDGRID",
		label = "显示建造布局：",
		options =	{
						{description = "开启", data = true},
						{description = "关闭", data = false},
					},
		default = true,	
		hover = "是否显示搭建布局",
	},
	{
		name = "GEOMETRY",
		label = "布局形状：",
		options =	{
						{description = "方形", data = "SQUARE"},
						{description = "钻石形", data = "DIAMOND"},
						{description = "X-六边形", data = "X_HEXAGON"},
						{description = "Z-六边形", data = "Z_HEXAGON"},
						{description = "扁平六角形", data = "FLAT_HEXAGON"},
						{description = "尖锐六角形", data = "POINTY_HEXAGON"},
					},
		default = "SQUARE",	
		hover = "使用什么形状的搭建布局",
	},
	{
		name = "TIMEBUDGET",
		label = "刷新率：",
		options = percent_options,
		default = 0.1,	
		hover = "建造布局的刷新频率。\n禁用或设置得太高将会导致游戏滞后现象严重",
	},
	{
		name = "HIDEPLACER",
		label = "隐藏虚影：",
		options =	{
						{description = "开启", data = true},
						{description = "关闭", data = false},
					},
		default = false,	
		hover = "是否隐藏放置时的虚影。\n隐藏后以便更清晰地查看布局",
	},
	{
		name = "HIDECURSOR",
		label = "隐藏鼠标：",
		options =	{
						{description = "隐藏所有", data = 1},
						{description = "显示数字", data = true},
						{description = "显示所有", data = false},
					},
		default = false,	
		hover = "是否隐藏鼠标，以便更清晰地查看布局",
	},
	{
		name = "SMARTSPACING",
		label = "智能间隔：",
		options =	{
						{description = "开启", data = true},
						{description = "关闭", data = false},
					},
		default = false,	
		hover = "是否根据被放置的物块来调整网格的间距。\n允许优化网格，这将使你很难把东西放在想要的位置",
	},
	{
		name = "ACTION_TILL",
		label = "田地布局：",
		options =	{
						{description = "开启", data = true},
						{description = "关闭", data = false},
					},
		default = true,	
		hover = "是否使用布局来翻耕农田土壤",
	},
	{
		name = "SMALLGRIDSIZE",
		label = "精细网格尺寸：",
		options = smallgridsizeoptions,
		default = 10,	
		hover = "对于使用精细网格的东西（如结构、植物等），要做多大的网格？",
	},
	{
		name = "MEDGRIDSIZE",
		label = "中等网格尺寸：",
		options = medgridsizeoptions,
		default = 6,	
		hover = "对于使用中等网格的东西（如墙壁、作物等），要做多大的网格？",
	},
	{
		name = "BIGGRIDSIZE",
		label = "大型网格尺寸：",
		options = biggridsizeoptions,
		default = 2,	
		hover = "对于使用大型网格的东西（如草皮、干草叉等），要做多大的网格？",
	},
	{
		name = "GOODCOLOR",
		label = "可放置区域颜色：",
		options = color_options,
		default = "whiteoutline",	
		hover = "用于可放置区域网格的颜色，你可以在那里放置物体",
	},
	{
		name = "BADCOLOR",
		label = "不可放置区域颜色：",
		options = color_options,
		default = "blackoutline",	
		hover = "用于不可放置区域网格的颜色，你不能在那里放置物体",
	},
	{
		name = "NEARTILECOLOR",
		label = "最近的地皮颜色：",
		options = color_options,
		default = "white",	
		hover = "用于最近的地皮网格的颜色",
	},
	{
		name = "GOODTILECOLOR",
		label = "可放置区域地皮颜色：",
		options = color_options,
		default = "whiteoutline",	
		hover = "用于可放置区域地皮网格的颜色，你可以在那里放置地皮",
	},
	{
		name = "BADTILECOLOR",
		label = "不可放置区域地皮颜色：",
		options = color_options,
		default = "blackoutline",	
		hover = "用于不可放置区域地皮网格的颜色，你不能在那里放置地皮",
	},
	{
		name = "GOODPLACERCOLOR",
		label = "可放置区域放置器颜色：",
		options = placer_color_options,
		default = "white",	
		hover = "用于可放置区域放置器的颜色。\n（你正在放置的物品的模拟位置）",
	},
	{
		name = "BADPLACERCOLOR",
		label = "不可放置区域放置器颜色：",
		options = placer_color_options,
		default = "black",	
		hover = "用于不可放置区域放置器的颜色。\n（你正在放置的物品的模拟位置）",
	},
	{
		name = "REDUCECHESTSPACING",
		label = "紧挨的箱子：",
		options =	{
						{description = "开启", data = true},
						{description = "关闭", data = false},
					},
		default = true,	
		hover = "是否允许箱子相对于正常情况下离得更近。\n这在游戏中可能不起作用",
	},
	{
		name = "CONTROLLEROFFSET",
		label = "控制器偏移值：",
		options =	{
						{description = "开启", data = true},
						{description = "关闭", data = false},
					},
		default = false,	
		hover = "通过控制器，物块是在你的脚下还是在偏移处得以放置",
	},
}