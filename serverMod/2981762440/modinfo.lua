name = "归溟幽灵鲨"  
description = ""  
author = "乌拉" 
version = "1.3.5.4.1" 

forumthread = ""

api_version = 10

dst_compatible = true 
reign_of_giants_compatible = false 
all_clients_require_mod = true 

icon_atlas = "modicon.xml" 
icon = "modicon.tex"

server_filter_tags = {  
 "归溟幽灵鲨",
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

configuration_options =
{

    {
        name = "Stu_Language",
        label = "语言/Language",
        options =   {
                        {description = "中文", data = 0},
                        {description = "Eng", data = 1},                                                                  
                    },
        default = 0,
    }, 
    
    {
        name = "Stu_Mode",
        label = "归溟幽灵鲨状态设置",
        options =   {
                        {description = "战斗的技艺在不断提升", data = 1},
                        {description = "她已经完全准备好了", data = 2},                                                                     
                    },
        default = 2,
    }, 

    {
        name = "Stu_Wp_Damage",
        label = "电锯攻击力设置",
        options =   {
                        {description = "51", data = 51},
                        {description = "59.5", data = 59.5},
                        {description = "68", data = 68},
                        {description = "100", data = 100},                                                                      
                    },
        default = 51,
    }, 

    {
        name = "Skill3_Atk_Hel",
        label = "三技能攻击消耗血量设置",
        options =   {
                        {description = "6", data = 6},
                        {description = "10", data = 10},
                        {description = "20", data = 20},                                                                     
                    },
        default = 6,
    }, 

    {
        name = "Stu_Hs_Set",
        label = "人物三维设置",
        options =   {
                        {description = "50%", data = 0.5},
                        {description = "75%", data = 0.75},
                        {description = "100%", data = 1},
                        {description = "120%", data = 1.25},
                        {description = "150%", data = 1.5},
                        {description = "200%", data = 2},                                                                                              
                    },
        default = 1,
    },

    {
        name = "Stu_Skill_Mult",
        label = "技能倍率设置",
        options =   {
                        {description = "50%", data = 0.5},
                        {description = "75%", data = 0.75},
                        {description = "100%", data = 1},
                        {description = "120%", data = 1.25},
                        {description = "150%", data = 1.5},
                        {description = "200%", data = 2},                                                                                              
                    },
        default = 1,
    },

    {
        name = "Stu_Hat_Mult",
        label = "帽子移速设置",
        options =   {
                        {description = "0%", data = 0},
                        {description = "10%", data = 1.1},
                        {description = "20%", data = 1.2},
                        {description = "30%", data = 1.3},
                        {description = "40%", data = 1.4},                                                                                             
                    },
        default = 1.1,
    },

    {
        name = "Stu_Wp_Mult",
        label = "武器移速设置",
        options =   {
                        {description = "0%", data = 0},
                        {description = "10%", data = 1.1},
                        {description = "20%", data = 1.2},
                        {description = "30%", data = 1.3},
                        {description = "40%", data = 1.4},                                                                                             
                    },
        default = 1.1,
    },

    {
        name = "KEY_Z",
        label = "技能1按键设置",
        options = keylist,
        default = "Z",
    },

    {
        name = "KEY_X",
        label = "技能2按键设置",
        options = keylist,
        default = "X",
    },

    {
        name = "KEY_C",
        label = "技能3按键设置",
        options = keylist,
        default = "C",
    },   
}  