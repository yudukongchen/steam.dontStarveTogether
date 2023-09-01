local L = (locale ~= "zh") and (locale ~= "zhr")


name=L and "[A fruit knife]" or "[西瓜刀]"
description = L and
[[



Make it at the bottom of the weapon column
Remember to set your preference under the module (small screw):
·You can set its basic properties
·You can set whether it can be used as various tools
·You can set its special function
·You can set its attack effects
·You can set its spell
·You can set up its upgrade and repair system
·If it crashes, you can turn off the fishing rod function and try

 
 
 
                            Set here  ↘↘↘
]]
or
[[
嗷嗷说这是他用过最好用的武器了
嗷嗷用它来保护啾啾

在武器栏最下方制作哦
记得在模组下方（小螺丝钉）设置你的偏好哦：
·可以设置武器的基本属性
·可以设置武器是否可以被用作各种工具
·可以设置武器的特殊作用
·可以设置武器的攻击特效
·可以设置武器的法术释放
·可以设置武器的升级修复系统
·若出现闪退，可以将鱼竿功能关闭后尝试

·增加了英文！！！


                          在这里设置 ↘↘↘
]]
author ="蠢嗷嗷&傻啾啾" 
version ="3.0.1" 
forumthread = ""
api_version = 10
icon_atlas = "modicon.xml"
icon ="modicon.tex"
dst_compatible = true
all_clients_require_mod = true
client_only_mod = false
server_filter_tags = L and {"fruit knife",} or {"西瓜刀",}

local opt_Empty = {{description = "", data = 0}}

local function Title(title,hover)
	return {
		name=title,
		hover=hover,
		options=opt_Empty,
		default=0,
	}
end

configuration_options =
{
	
	
	L and Title("Language Settings") or Title("语言设置"),
	
	L and
	{
		name = "lan",
		label = "Language",
		hover = "Set the language in the game",
		options = 
        {
	       	{description = "English", data = 1},
			{description = "中文", data = 0},
        },
	    default = 1,
	}
	or
	{
		name = "lan",
		label = "语言",
		hover = "设置语言",
		options = 
        {
	        {description = "English", data = 1},
			{description = "中文", data = 0},
        },
	    default = 0,
	},
	
	
	L and Title("Basic Settings") or Title("基础设置"),
	
	L and
	{
	  name = "craft",
	  label = "Difficulty of making",
	  hover = "Set the difficulty of making a fruit knife",
	   options = 
        {
	       	{description = "Easy", data = 1},
			{description = "Normal", data = 2},
			{description = "Difficult", data = 3},
        },
	    default = 1,
	
	}
	or
	{
	  name = "craft",
	  label = "制作难度",
	  hover = "设置制作西瓜刀的难度",
	   options = 
        {
	       	{description = "简单", data = 1},
			{description = "正常", data = 2},
			{description = "困难", data = 3},
        },
	    default = 1,
	
	},
	
	
	L and 
	{
	  name = "damage",
	  label = "Damage",
	  hover = "Set damage",
	   options = 
        {		
			{description = "30", data = 30},
			{description = "40", data = 40},
			{description = "50", data = 50},
			{description = "60", data = 60},
			{description = "70", data = 70},
			{description = "80", data = 80},
			{description = "90", data = 90},
			{description = "100", data = 100},
			{description = "150", data = 150},
			{description = "200", data = 200},
			{description = "300", data = 300},
			{description = "400", data = 400},
			{description = "500", data = 500},
			{description = "seckill", data = 999999},
     	 },
	    default = 100,
	
	}
	or
	{
	  name = "damage",
	  label = "伤害",
	  hover = "设置伤害",
	   options = 
        {		
			{description = "30", data = 30},
			{description = "40", data = 40},
			{description = "50", data = 50},
			{description = "60", data = 60},
			{description = "70", data = 70},
			{description = "80", data = 80},
			{description = "90", data = 90},
			{description = "100", data = 100},
			{description = "150", data = 150},
			{description = "200", data = 200},
			{description = "300", data = 300},
			{description = "400", data = 400},
			{description = "500", data = 500},
			{description = "秒杀", data = 999999},
     	 },
	    default = 100,
	
	},
	
	
	L and
	{
	  name = "range",
	  label = "Attack range",
	  hover = "Set attack range",
	   options = 
        {		
			{description = "0", data = 0},
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
			{description = "15", data = 15},
			{description = "20", data = 20},
     	 },
	    default = 1,
	
	}
	or
	{
	  name = "range",
	  label = "攻击范围",
	  hover = "设置攻击范围",
	   options = 
        {		
			{description = "0", data = 0},
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
			{description = "15", data = 15},
			{description = "20", data = 20},
     	 },
	    default = 1,
	
	},
	

	L and
	{
       name = "use",
       label = "Durable",
	   hover = "Set durable",
        options = 
        {
			 {description = "100", data = 100},
			 {description = "200", data = 200},
			 {description = "300", data = 300},
			 {description = "400", data = 400},
			 {description = "500", data = 500},
			 {description = "600", data = 600},
			 {description = "700", data = 700},
			 {description = "800", data = 800},
			 {description = "900", data = 900},
			 {description = "1000", data = 1000},
			 {description = "permanent", data = 0},
        },
        default = 0,
    }
	or
    {
       name = "use",
       label = "耐久",
	   hover = "设置耐久",
        options = 
        {
			 {description = "100", data = 100},
			 {description = "200", data = 200},
			 {description = "300", data = 300},
			 {description = "400", data = 400},
			 {description = "500", data = 500},
			 {description = "600", data = 600},
			 {description = "700", data = 700},
			 {description = "800", data = 800},
			 {description = "900", data = 900},
			 {description = "1000", data = 1000},
			 {description = "无耐久", data = 0},
        },
        default = 0,
    },
	
	
	
	L and Title("Tools Settings") or Title("工具设置"),
	
	L and 
	{
	  name = "axe",
	  label = "Axe",
	  hover = "if it can be used as a axe",
	   options = 
        {		
			{description = "Close", data = 0},
			{description = "Normal", data = 1},
			{description = "Accelerated", data = 5},
			{description = "Seckill", data = 22},
     	 },
	    default = 22,
	
	}
	or
	{
	  name = "axe",
	  label = "斧头",
	  hover = "是否可以被用作斧头",
	   options = 
        {		
			{description = "关闭", data = 0},
			{description = "正常", data = 1},
			{description = "加速", data = 5},
			{description = "秒杀", data = 22},
     	 },
	    default = 22,
	
	},
	
	
	L and 
	{
	  name = "draft",
	  label = "Pickaxe",
	  hover = "if it can be used as a pickaxe",
	   options = 
        {		
			{description = "Close", data = 0},
			{description = "Normal", data = 1},
			{description = "Accelerated", data = 2},
			{description = "Seckill", data = 15},
     	 },
	    default = 2,
	
	}
	or
	{
	  name = "draft",
	  label = "鹤嘴锄",
	  hover = "是否可以被用作鹤嘴锄",
	   options = 
        {		
			{description = "关闭", data = 0},
			{description = "正常", data = 1},
			{description = "加速", data = 2},
			{description = "秒杀", data = 15},
     	 },
	    default = 2,
	
	},
	
	
	L and 
	{
       name = "dig",
       label = "（Not recommended）Shovel",
	   hover = "if it can be used as a shovel(Inconvenient to harvest grass and branches)",
        options = 
        {
			 {description = "Close", data = 0},
			 {description = "Open", data = 1},
        },
        default = 0,
    }
	or
	{
       name = "dig",
       label = "（不推荐）铲子",
	   hover = "是否可以被用作铲子（不方便收割草和树枝哈哈）",
        options = 
        {
			 {description = "关闭", data = 0},
			 {description = "打开", data = 1},
        },
        default = 0,
    },
	
	
	L and 
	{
       name = "hammer",
       label = "（Not recommended）Hammer",
	   hover = "if it can be used as a hammer (you will dismantle the base if you are worried!)",
        options = 
        {
			 {description = "Close", data = 0},
			 {description = "Open", data = 1},
			 {description = "Seckill", data = 99},
        },
        default = 0,
    }
	or
	{
       name = "hammer",
       label = "（不推荐）锤子",
	   hover = "是否可以被用作锤子（一不下心就会拆家！）",
        options = 
        {
			 {description = "关闭", data = 0},
			 {description = "打开", data = 1},
			 {description = "秒杀", data = 99},
        },
        default = 0,
    },
	
	
	L and 
	{
	  name = "net",
	  label = "bugnet",
	  hover = "if it can be used as a bugnet",
	   options = 
        {		
			{description = "Close", data = 0},
			{description = "Open", data = 1},
     	 },
	    default = 1,
	
	}
	or
	{
	  name = "net",
	  label = "捕虫网",
	  hover = "是否可以被用作捕虫网",
	   options = 
        {		
			{description = "关闭", data = 0},
			{description = "打开", data = 1},
     	 },
	    default = 1,
	
	},
	
	
	L and
	{
	  name = "tideng",
	  label = "Lantern",
	  hover = "if it can be used as a lantern(Opening the cave may make the lighting uncontrolled)",
	   options = 
        {		
			{description = "Close", data = 0},
			{description = "Torch", data = 3},
			{description = "Nearby", data = 8},
			{description = "Full screen", data = 15},
     	 },
	    default = 15,
	
	}
	or
	{
	  name = "tideng",
	  label = "提灯",
	  hover = "设置提灯照明范围(开启洞穴可能会使照明不受控制)",
	   options = 
        {		
			{description = "关闭", data = 0},
			{description = "火把", data = 3},
			{description = "附近", data = 8},
			{description = "全屏", data = 15},
     	 },
	    default = 15,
	
	},
	
	
	L and
	{
	  name = "diaoyu",
	  label = "Fishingrod",
	  hover = "It is not recommended to open the fishing rod when opening caves",
	   options = 
        {		
			{description = "Close", data = 0},
			{description = "Open", data = 1},
     	 },
	    default = 0,
	
	}
	or
	{
	  name = "diaoyu",
	  label = "鱼竿",
	  hover = "开地下洞穴不建议开启鱼竿哦",
	   options = 
        {		
			{description = "关闭", data = 0},
			{description = "打开", data = 1},
			--{description = "10秒上钩", data = 10},
			--{description = "5秒上钩", data = 5},
			--{description = "3秒上钩", data = 3},
			--{description = "0秒上钩", data = 0},
			--快速钓鱼已不可用
     	 },
	    default = 0,
	
	},
	
	
	
	
	L and Title("Special Settings") or Title("特殊功能"),
	
	L and 
	{
       name = "walkspeed",
       label = "Moving speed",
	   hover = "set moving speed",
        options = 
        {
			 {description = "Close", data = 1},
			 {description = "×1.1", data = 1.1},
			 {description = "×1.2", data = 1.2},
			 {description = "×1.25", data = 1.25},
			 {description = "×1.3", data = 1.3},
			 {description = "×1.4", data = 1.4},
			 {description = "×1.5", data = 1.5},
			 {description = "×2", data = 2},
			 {description = "×2.5", data = 2.5},
        },
        default = 1.5,
    }
	or
	{
       name = "walkspeed",
       label = "移动速度",
	   hover = "设置移动速度",
        options = 
        {
			 {description = "关闭", data = 1},
			 {description = "1.1倍", data = 1.1},
			 {description = "1.2倍", data = 1.2},
			 {description = "1.25倍", data = 1.25},
			 {description = "1.3倍", data = 1.3},
			 {description = "1.4倍", data = 1.4},
			 {description = "1.5倍", data = 1.5},
			 {description = "2倍", data = 2},
			 {description = "2.5倍", data = 2.5},
        },
        default = 1.5,
    },
	
	
	L and 
	{
       name = "warm",
       label = "Insulation\\Summer",
	   hover = "set Insulation\\Summer",
        options = 
        {
			 {description = "Close", data = 0},
			 {description = "Insulation 60 s", data = 60},
			 {description = "Insulation 120 s", data = 120},
			 {description = "Insulation 240 s", data = 240},
			 {description = "Forever Insulation", data = 99999999},
			 {description = "Summer 60 s", data = -60},
			 {description = "Summer 120 s", data = -120},
			 {description = "Summer 240 s", data = -240},
			 {description = "Forever Summer", data = -99999999},
        },
        default = 240,
    }
	or
	{
       name = "warm",
       label = "保暖\\隔热",
	   hover = "设置保暖\\隔热时长",
        options = 
        {
			 {description = "关闭", data = 0},
			 {description = "保暖60秒", data = 60},
			 {description = "保暖120秒", data = 120},
			 {description = "保暖240秒", data = 240},
			 {description = "永久保暖", data = 99999999},
			 {description = "隔热60秒", data = -60},
			 {description = "隔热120秒", data = -120},
			 {description = "隔热240秒", data = -240},
			 {description = "永久隔热", data = -99999999},
        },
        default = 240,
    },
	
	
	L and 
	{
       name = "waterproofer",
       label = "Waterproofer",
	   hover = "set waterproofer",
        options = 
        {
			 {description = "Close", data = 0},
			 {description = "20% Waterproofer", data = 0.2},
			 {description = "50% Waterproofer", data = 0.5},
			 {description = "80% Waterproofer", data = 0.8},
			 {description = "100% Waterproofer", data = 1},
        },
        default = 1,
    }
	or
	{
       name = "waterproofer",
       label = "防雨效果",
	   hover = "设置防雨效果",
        options = 
        {
			 {description = "关闭", data = 0},
			 {description = "20%防雨", data = 0.2},
			 {description = "50%防雨", data = 0.5},
			 {description = "80%防雨", data = 0.8},
			 {description = "完全防雨", data = 1},
        },
        default = 1,
    },
	
	
	L and 
	{
       name = "huisan",
       label = "Sanity",
	   hover = "Set sanity",
        options = 
        {
			 {description = "Close", data = 0, hover = "Close"},
			 {description = "2.7", data = 0.05, hover = "＋2.7/min"},
			 {description = "5.4", data = 0.1, hover = "＋5.4/min"},
			 {description = "10.8", data = 0.2, hover = "＋10.8/min"},
			 {description = "27", data = 0.5, hover = "＋27/min"},
			 {description = "54", data = 1, hover = "＋54/min"},
			 {description = "270", data = 5, hover = "＋270/min"},
			 {description = "-270（moon island）", data = -5, hover = "－270/min"},
        },
        default = 0,
    }
	or
	{
       name = "huisan",
       label = "手持时回san",
	   hover = "设置每分钟手持时回san效果",
        options = 
        {
			 {description = "关闭", data = 0, hover = "关闭"},
			 {description = "2.7", data = 0.05, hover = "每分钟回复2.7"},
			 {description = "5.4", data = 0.1, hover = "每分钟回复5.4"},
			 {description = "10.8", data = 0.2, hover = "每分钟回复10.8"},
			 {description = "27", data = 0.5, hover = "每分钟回复27"},
			 {description = "54", data = 1, hover = "每分钟回复54"},
			 {description = "270", data = 5, hover = "每分钟回复270"},
			 {description = "-270（可月岛用）", data = -5, hover = "每分钟扣除270"},
        },
        default = 0,
    },
	
	
	L and 
	{
       name = "temperature",
       label = "Automatic temperature recovery",
	   hover = "When the temperature reaches 5°C or 65°C, it will automatically return to 35°C, consume 10 durability",
        options = 
        {
			 {description = "Close", data = false},
			 {description = "Open", data = true},
        },
        default = false,
    }
	or
	{
       name = "temperature",
       label = "自动回温",
	   hover = "温度到5°C或者65°C时自动回复到35°C，消耗10耐久",
        options = 
        {
			 {description = "关闭", data = false},
			 {description = "开启", data = true},
        },
        default = false,
    },
	
	
	L and 
	{
       name = "magic",
       label = "Cast spell",
	   hover = "ps:Each spell consumes 10 points of durability and 5 points of sanity",
        options = 
        {
			 {description = "Close", data = 0},
			 {description = "Hypnotic spell", data = 1, hover = "Screen range hypnosis"},
			 {description = "Teleport spell", data = 2, hover = "Flash！"},
			 {description = "dwarf star", data = 3, hover = "Star caller's staff"},
			 {description = "polar light", data = 4, hover = "Moon caller's staff"},
			 {description = "ice-circle", data = 5, hover = "Lasts 5 seconds, klaus' ice deer summon"},
			 {description = "fire-circle", data = 6, hover = "Lasts 5 seconds, klaus' fire deer summon"},
			 {description = "tornado", data = 7, hover = "4 tornado，Cutting down trees is more convenient: Hasagay！！！"},
			 {description = "shadowmeteor", data = 11, hover = "Random damage"},
			 {description = "sporecloud", data = 12, hover = "Lasts 60 seconds, it will rot food!"},
			 {description = "sandspike", data = 13, hover = "4 sandspikes, each 100 damage"},
			 {description = "mushroombomb", data = 14, hover = "3 mushroombombs, each 100 damage"},
			 {description = "big mushroombomb", data = 15, hover = "3 big mushroombombs, each 150 damage"},
			 {description = "napsack", data = 16, hover = "Lasts 20 seconds, hypnotize creatures"},
			 {description = "little light", data = 17, hover = "It always exists"},
			 {description = "houndius shootius", data = 8, hover = "houndius shootius"},
			 {description = "tentacle", data = 21, hover = "An upgraded version of the Tentacle Book?"},
			 {description = "lightning", data = 24, hover = "An upgraded version of the Lightning Book? Be careful! !"},
			 {description = "birds", data = 22, hover = "Is this an Wickerbottom's bird book?"},
			 {description = "Ripening crops", data = 23, hover = "Is this Wickerbottom's gardening book?"},
			 {description = "ancient station", data = 9, hover = "It's quite convenient to put one in the base"},
			 {description = "celestial altar", data = 19, hover = "It's quite convenient to put one in the base.It needs you to assemble it"},
			 {description = "celestial orb", data = 18, hover = "One GPS per person"},
			 {description = "thulecite", data = 10, hover = "Is thulecite renewable?"},
			 {description = "tumbleweed", data = 20, hover = "Ah, there are so many tumbleweeds, which one should I chase first?"},
        },
        default = 1,
    }
	or
	{
       name = "magic",
       label = "法术释放",
	   hover = "ps:每次法术消耗 10点耐久 5点san值",
        options = 
        {
			 {description = "关闭", data = 0},
			 {description = "催眠法术", data = 1, hover = "屏幕范围催眠"},
			 {description = "瞬移法术", data = 2, hover = "闪现！"},
			 {description = "召唤矮星", data = 3, hover = "唤星法杖召唤物"},
			 {description = "召唤极光", data = 4, hover = "唤月法杖召唤物"},
			 {description = "召唤寒冰", data = 5, hover = "持续5秒，克劳斯冰鹿召唤物"},
			 {description = "召唤火焰", data = 6, hover = "持续5秒，克劳斯火鹿召唤物"},
			 {description = "召唤旋风", data = 7, hover = "4个旋风，砍树更加方便：哈撒给！！！"},
			 {description = "召唤流星", data = 11, hover = "伤害根据随机大小而定"},
			 {description = "召唤孢子云", data = 12, hover = "持续一分钟，会使食物腐烂！"},
			 {description = "召唤沙刺", data = 13, hover = "4个沙刺，每个100伤害"},
			 {description = "召唤爆炸蘑菇", data = 14, hover = "3个蘑菇，每个100伤害，三个蘑菇一条命，致敬老蘑菇~"},
			 {description = "召唤爆炸蘑菇plus", data = 15, hover = "3个蘑菇，每个150伤害，三个蘑菇一条命，致敬老蘑菇~"},
			 {description = "召唤催眠云", data = 16, hover = "持续20s，催眠范围内生物"},
			 {description = "召唤光源", data = 17, hover = "一直存在"},
			 {description = "召唤眼球塔", data = 8, hover = "忠于你的眼球塔"},
			 {description = "召唤触手", data = 21, hover = "升级版的触手书？"},
			 {description = "召唤闪电", data = 24, hover = "升级版的闪电书？小心会劈到自己！！"},
			 {description = "召唤鸟", data = 22, hover = "这是老奶奶的鸟书？"},
			 {description = "催熟作物", data = 23, hover = "这是老奶奶的园艺书？"},
			 {description = "召唤远古科技站", data = 9, hover = "在家放一个还蛮方便"},
			 {description = "召唤月岛祭坛", data = 19, hover = "在家放一个还蛮方便,自己组装一下！"},
			 {description = "召唤天体灵球", data = 18, hover = "人手一个GPS"},
			 {description = "召唤铥矿", data = 10, hover = "铥矿可再生了？"},
			 {description = "召唤风滚草", data = 20, hover = "啊好多风滚草，先追哪一个呢？"},
        },
        default = 1,
    },
	
	
	L and 
	{
       name = "fuhuo",
       label = "Resurrection after haunting",
	   hover = "if you can resurrect after haunting",
        options = 
        {
			 {description = "Close", data = 0},
			 {description = "Open", data = 1},
        },
        default = 0,
    }
	or
	{
       name = "fuhuo",
       label = "作祟复活",
	   hover = "是否可以作祟复活",
        options = 
        {
			 {description = "关闭", data = 0},
			 {description = "打开", data = 1},
        },
        default = 0,
    },
	
	
	L and
	{
       name = "zhangzhang",
       label = "Walking special effects",
	   hover = "set the walking special effects",
        options = 
        {
			 {description = "Ancient cane", data = "cane_ancient_fx"},
			 {description = "Gostshead cane", data = "cane_victorian_fx"},
        },
        default = "cane_ancient_fx",
    }
	or
	{
       name = "zhangzhang",
       label = "行走特效",
	   hover = "设置行走特效",
        options = 
        {
			 {description = "远古手杖", data = "cane_ancient_fx"},
			 {description = "暴食手杖", data = "cane_victorian_fx"},
        },
        default = "cane_ancient_fx",
    },
	
	
	L and 
	{
       name = "hujia",
       label = "Bone armor",
	   hover = "if you turn on the effect of bone armor (Immune to damage every 5 seconds, consume 10 durability)",
        options = 
        {
			 {description = "Close", data = 0,hover = "new function"},
			 {description = "Open", data = 1,hover = "new function"},
        },
        default = 0,
    }
	or
	{
       name = "hujia",
       label = "骨制盔甲",
	   hover = "是否开启骨制盔甲的效果(每五秒免疫一次伤害，消耗10耐久)",
        options = 
        {
			 {description = "关闭", data = 0,hover = "刚加的新功能，还在测试阶段~"},
			 {description = "打开", data = 1,hover = "刚加的新功能，还在测试阶段~"},
        },
        default = 0,
    },
	
	
	
	L and Title("Attack special effects") or Title("攻击特效"),
	
	L and 
	{
       name = "sanity",
       label = "Restore sanity when attacking",
	   hover = "set restoring sanity when attacking",
        options = 
        {
			 {description = "Close", data = 0},
			 {description = "0.1", data = 0.1},
			 {description = "0.5", data = 0.5},
			 {description = "1", data = 1},
			 {description = "2", data = 2},
			 {description = "3", data = 3},
			 {description = "4", data = 4},
			 {description = "5", data = 5},
			 {description = "6", data = 6},
			 {description = "7", data = 7},
			 {description = "8", data = 8},
			 {description = "9", data = 9},
			 {description = "10", data = 10},
        },
        default = 0,
    }
	or
	{
       name = "sanity",
       label = "攻击时回san",
	   hover = "设置攻击时回san效果",
        options = 
        {
			 {description = "关闭", data = 0},
			 {description = "0.1", data = 0.1},
			 {description = "0.5", data = 0.5},
			 {description = "1", data = 1},
			 {description = "2", data = 2},
			 {description = "3", data = 3},
			 {description = "4", data = 4},
			 {description = "5", data = 5},
			 {description = "6", data = 6},
			 {description = "7", data = 7},
			 {description = "8", data = 8},
			 {description = "9", data = 9},
			 {description = "10", data = 10},
        },
        default = 0,
    },
	
	
	L and
	{
       name = "health",
       label = "Bloodsucking effect",
	   hover = "set bloodsucking effect",
        options = 
        {
			 {description = "Close", data = 0},
			 {description = "0.1", data = 0.1},
			 {description = "0.5", data = 0.5},
			 {description = "1", data = 1},
			 {description = "2", data = 2},
			 {description = "3", data = 3},
			 {description = "4", data = 4},
			 {description = "5", data = 5},
			 {description = "6", data = 6},
			 {description = "7", data = 7},
			 {description = "8", data = 8},
			 {description = "9", data = 9},
			 {description = "10", data = 10},
        },
        default = 0,
    }
	or
	{
       name = "health",
       label = "吸血效果",
	   hover = "设置吸血效果",
        options = 
        {
			 {description = "关闭", data = 0},
			 {description = "0.1", data = 0.1},
			 {description = "0.5", data = 0.5},
			 {description = "1", data = 1},
			 {description = "2", data = 2},
			 {description = "3", data = 3},
			 {description = "4", data = 4},
			 {description = "5", data = 5},
			 {description = "6", data = 6},
			 {description = "7", data = 7},
			 {description = "8", data = 8},
			 {description = "9", data = 9},
			 {description = "10", data = 10},
        },
        default = 0,
    },
	
	
	L and 
	{
       name = "freezable",
       label = "Freezing effect",
	   hover = "set freezing effect",
        options = 
        {
			 {description = "Close", data = 0},
			 {description = "Slow freezing", data = 0.2},
			 {description = "Normalfreezing", data = 0.5},
			 {description = "Fast freezing", data = 1},
			 {description = "Super freezing", data = 10},
        },
        default = 1,
    }
	or
	{
       name = "freezable",
       label = "冰冻效果",
	   hover = "设置冰冻效果",
        options = 
        {
			 {description = "关闭", data = 0},
			 {description = "慢速冰冻", data = 0.2},
			 {description = "普通冰冻", data = 0.5},
			 {description = "快速冰冻", data = 1},
			 {description = "超级冰冻", data = 10},
        },
        default = 1,
    },
	
	
	L and
	{
       name = "burn",
       label = "Flame effect",
	   hover = "set flame effect",
        options = 
        {
			 {description = "Close", data = 0},
			 {description = "Open", data = 1},
        },
        default = 0,
    }
	or
	{
       name = "burn",
       label = "火焰效果",
	   hover = "设置火焰效果",
        options = 
        {
			 {description = "关闭", data = 0},
			 {description = "打开", data = 1},
        },
        default = 0,
    },
	
	
	L and
	{
       name = "back",
       label = "Knockback effect",
	   hover = "Set knockback effect, additional 10 points of small area damage",
        options = 
        {
			 {description = "Close", data = 0},
			 {description = "Open", data = 1},
        },
        default = 0,
    }
	or
	{
       name = "back",
       label = "击退效果",
	   hover = "设置击退效果，额外附加10点小范围伤害",
        options = 
        {
			 {description = "关闭", data = 0},
			 {description = "打开", data = 1},
        },
        default = 0,
    },
	
	
	L and
	{
       name = "binghuotx",
       label = "fire/ice/sleep circle",
	   hover = "Set fire/ice circle effect",
        options = 
        {
			 {description = "Close", data = 0},
			 {description = "fire-circle", data = 1},
			 {description = "ice-circle", data = 2},
			 {description = "sleepcloud", data = 3},
			 {description = "sporecloud", data = 4},
        },
        default = 0,
    }
	or
	{
       name = "binghuotx",
       label = "冰火坑/催眠/孢子云特效",
	   hover = "设置冰火坑和催眠/孢子云特效",
        options = 
        {
			 {description = "关闭", data = 0},
			 {description = "火焰坑", data = 1},
			 {description = "寒冰坑", data = 2},
			 {description = "催眠云", data = 3},
			 {description = "孢子云", data = 4},
        },
        default = 0,
    },
	
	L and
	{
       name = "xuanfengtx",
       label = "tornado effect",
	   hover = "Set tornado effect",
        options = 
        {
			 {description = "Close", data = 0},
			 {description = "Open", data = 1},
        },
        default = 0,
    }
	or
	{
       name = "xuanfengtx",
       label = "旋风特效",
	   hover = "设置旋风特效，亚索：哈撒给！",
        options = 
        {
			 {description = "关闭", data = 0},
			 {description = "打开", data = 1},
        },
        default = 0,
    },
	
	L and
	{
       name = "liuxingtx",
       label = "shadowmeteor effect",
	   hover = "Set shadowmeteor effect",
        options = 
        {
			 {description = "Close", data = 0},
			 {description = "Open", data = 1},
        },
        default = 0,
    }
	or
	{
       name = "liuxingtx",
       label = "流星特效",
	   hover = "设置流星特效",
        options = 
        {
			 {description = "关闭", data = 0},
			 {description = "打开", data = 1},
        },
        default = 0,
    },
	
	L and
	{
       name = "shacitx",
       label = "sandspike effect",
	   hover = "Set sandspike effect",
        options = 
        {
			 {description = "Close", data = 0},
			 {description = "Open", data = 1},
        },
        default = 0,
    }
	or
	{
       name = "shacitx",
       label = "沙刺特效",
	   hover = "设置沙刺特效",
        options = 
        {
			 {description = "关闭", data = 0},
			 {description = "打开", data = 1},
        },
        default = 0,
    },
	
	L and
	{
       name = "mogutx",
       label = "mushroom effect",
	   hover = "Set mushroom effect",
        options = 
        {
			 {description = "Close", data = 0},
			 {description = "mushroom", data = 1},
			 {description = "mushroom-plus", data = 2},
        },
        default = 0,
    }
	or
	{
       name = "mogutx",
       label = "爆炸蘑菇特效",
	   hover = "设置爆炸蘑菇特效",
        options = 
        {
			 {description = "关闭", data = 0},
			 {description = "爆炸蘑菇", data = 1},
			 {description = "爆炸蘑菇plus", data = 2},
        },
        default = 0,
    },
	
	L and
	{
       name = "baoji",
       label = "Critical hit effect",
	   hover = "set critical hit effect",
        options = 
        {
			 {description = "Close", data = 0},
			 {description = "Double damage", data = 1},
			 {description = "+500 true damage", data = 500},
			 {description = "+1000 true damage", data = 1000},
			 {description = "+2000 true damage", data = 2000},
        },
        default = 0,
    }
	or
	{
       name = "baoji",
       label = "暴击效果",
	   hover = "设置暴击效果",
        options = 
        {
			 {description = "关闭", data = 0},
			 {description = "双倍伤害", data = 1},
			 {description = "额外500真伤", data = 500},
			 {description = "额外1000真伤", data = 1000},
			 {description = "额外2000真伤", data = 2000},
        },
        default = 0,
    },

	
	L and
	{
       name = "baojilv",
       label = "Critical hit rate",
	   hover = "Set critical hit rate",
        options = 
        {
			 {description = "1%", data = 0.01},
			 {description = "5%", data = 0.05},
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
        default = 0,
    }
	or
	{
       name = "baojilv",
       label = "（开启“暴击效果”之后有效）暴击率",
	   hover = "设置暴击率",
        options = 
        {
			 {description = "1%", data = 0.01},
			 {description = "5%", data = 0.05},
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
        default = 0,
    },
	
	
	L and
	{
       name = "aoe",
       label = "AOE",
	   hover = "set AOE",
        options = 
        {
			 {description = "Close", data = 0},
			 {description = "Open", data = 1},
        },
        default = 0,
    }
	or
	{
       name = "aoe",
       label = "AOE",
	   hover = "设置AOE",
        options = 
        {
			 {description = "关闭", data = 0},
			 {description = "打开", data = 1},
        },
        default = 0,
    },
	
	
	L and
	{
       name = "aoerange",
       label = "AOE range ",
	   hover = "Set AOE damage range",
        options = 
        {
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
			{description = "11", data = 11},
			{description = "12", data = 12},
			{description = "13", data = 13},
			{description = "14", data = 14},
			{description = "15", data = 15},
        },
        default = 0,
    }
	or
	{
       name = "aoerange",
       label = "（开启“AOE”之后有效）AOE范围",
	   hover = "设置AOE伤害范围",
        options = 
        {
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
			{description = "11", data = 11},
			{description = "12", data = 12},
			{description = "13", data = 13},
			{description = "14", data = 14},
			{description = "15", data = 15},
        },
        default = 0,
    },
	
	
	L and
	{
       name = "aoedamage",
       label = "AOE damage",
	   hover = "Set AOE damage",
        options = 
        {
			 {description = "1", data = 1},
			 {description = "2", data = 2},
			 {description = "3", data = 3},
			 {description = "4", data = 4},
			 {description = "5", data = 5},
			 {description = "6", data = 6},
			 {description = "7", data = 7},
			 {description = "8", data = 8},
			 {description = "9", data = 9},
			 {description = "10", data = 10},
			 {description = "20", data = 20},
			 {description = "30", data = 30},
			 {description = "40", data = 40},
			 {description = "50", data = 50},
			 {description = "60", data = 60},
			 {description = "70", data = 70},
			 {description = "80", data = 80},
			 {description = "90", data = 90},
			 {description = "100", data = 100},
			 {description = "200", data = 200},
			 {description = "300", data = 300},
			 {description = "400", data = 400},
			 {description = "500", data = 500},
			 {description = "1000", data = 1000},
        },
        default = 10,
    }
	or
	{
       name = "aoedamage",
       label = "（开启“AOE”之后有效）AOE伤害",
	   hover = "设置AOE的真实伤害",
        options = 
        {
			 {description = "1", data = 1},
			 {description = "2", data = 2},
			 {description = "3", data = 3},
			 {description = "4", data = 4},
			 {description = "5", data = 5},
			 {description = "6", data = 6},
			 {description = "7", data = 7},
			 {description = "8", data = 8},
			 {description = "9", data = 9},
			 {description = "10", data = 10},
			 {description = "20", data = 20},
			 {description = "30", data = 30},
			 {description = "40", data = 40},
			 {description = "50", data = 50},
			 {description = "60", data = 60},
			 {description = "70", data = 70},
			 {description = "80", data = 80},
			 {description = "90", data = 90},
			 {description = "100", data = 100},
			 {description = "200", data = 200},
			 {description = "300", data = 300},
			 {description = "400", data = 400},
			 {description = "500", data = 500},
			 {description = "1000", data = 1000},
        },
        default = 10,
    },

	
	
	L and Title("upgrade\\repair system") or Title("升级\\修复系统"),
	
	L and 
	{
       name = "shengji",
       label = "upgrade\\repair",
	   hover = "if turn on the upgrade\\repair system",
        options = 
        {
			 {description = "Close", data = 0},
			 {description = "Open", data = 1},
        },
        default = 1,
    }
	or
	{
       name = "shengji",
       label = "升级修复",
	   hover = "是否开启升级修复系统",
        options = 
        {
			 {description = "关闭", data = 0},
			 {description = "打开", data = 1},
        },
        default = 1,
    },
	
	
	L and 
	{
       name = "full",
       label = "Upper limit",
	   hover = "Set the upper limit of its level",
        options = 
        {
			 {description = "10", data = 10},
			 {description = "20", data = 20},
			 {description = "50", data = 50},
			 {description = "100", data = 100},
			 {description = "200", data = 200},
			 {description = "500", data = 500},
			 {description = "1000", data = 1000},
			 {description = "10000", data = 10000},
			 {description = "100000", data = 100000},
        },
        default = 1000,
    }
	or
	{
       name = "full",
       label = "等级上限",
	   hover = "设置升级的等级上限",
        options = 
        {
			 {description = "10", data = 10},
			 {description = "20", data = 20},
			 {description = "50", data = 50},
			 {description = "100", data = 100},
			 {description = "200", data = 200},
			 {description = "500", data = 500},
			 {description = "1000", data = 1000},
			 {description = "10000", data = 10000},
			 {description = "100000", data = 100000},
        },
        default = 1000,
    },
	
	
	
	L and
	{
	  name = "upgrade",
	  label = "Upgrade difficulty",
	  hover = "You can give the corresponding gem to the fruit knife to upgrade and increase the damage",
	   options = 
        {		
			{description = "Too easy(cutgrass)", data = "cutgrass"},
			{description = "Easy(goldnugget)", data = "goldnugget"},
			{description = "Normal(redgem)", data = "redgem"},
			{description = "Hard(orangegem)", data = "orangegem"},
     	 },
	    default = "goldnugget",
	
	}
	or
	{
	  name = "upgrade",
	  label = "（开启“升级修复”之后有效）升级难度",
	  hover = "可以将对应宝石给予西瓜刀来升级增加伤害",
	   options = 
        {		
			{description = "过于简单（干草）", data = "cutgrass"},
			{description = "简单（黄金）", data = "goldnugget"},
			{description = "正常（红宝石）", data = "redgem"},
			{description = "困难（橙宝石）", data = "orangegem"},
     	 },
	    default = "goldnugget",
	
	},
	
	
	L and
	{
	  name = "repair",
	  label = "Repair materials",
	  hover = "It can repair the fruit knife with 20% durability",
	   options = 
        {		
			{description = "rope", data = "rope"},
			{description = "boards", data = "boards"},
			{description = "cutstone", data = "cutstone"},
			{description = "goldnugget", data = "goldnugget"},
			{description = "redgem", data = "redgem"},
			{description = "orangegem", data = "orangegem"},
     	 },
	    default = "rope",
	
	}
	or
	{
	  name = "repair",
	  label = "（开启“升级修复”之后有效）修复材料",
	  hover = "可以给予使得西瓜刀耐久修复20%",
	   options = 
        {		
			{description = "绳子", data = "rope"},
			{description = "木板", data = "boards"},
			{description = "石砖", data = "cutstone"},
			{description = "黄金", data = "goldnugget"},
			{description = "红宝石", data = "redgem"},
			{description = "橙宝石", data = "orangegem"},
     	 },
	    default = "rope",
	
	},
	
	
	L and
	{
	  name = "upgradedamage",
	  label = "Increased damage per level ",
	  hover = "set increased damage per level",
	   options = 
        {		
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "5", data = 5},
			{description = "10", data = 10},
			{description = "20", data = 20},
     	 },
	    default = 20,
	
	}
	or
	{
	  name = "upgradedamage",
	  label = "（开启“升级修复”之后有效）每级加伤害",
	  hover = "设置每次升级增加的伤害",
	   options = 
        {		
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "5", data = 5},
			{description = "10", data = 10},
			{description = "20", data = 20},
     	 },
	    default = 20,
	
	},
	
	
	--Title("暂时关闭的功能"),
	--{
      -- name = "bag",
       --label = "背包",
	   --hover = "此项暂时关闭，如果需要打开，在订阅界面会有简单的方法",
       -- options = 
        --{
			 --{description = "关闭", data = "false"},
			 --{description = "开启", data = "true"},
			 --如果你需要开启背包功能，只需把上一行的 -- 符号去掉即可
       -- },
       -- default = "false",
    --},
	
	--[[{
	  name = "fangyu",
	  label = "护甲功能",
	  hover = "设置护甲的防护能力",
	   options = 
        {		
			{description = "关闭", data = 0},
			{description = "60%", data = 0.6},
			{description = "70%", data = 0.7},
			{description = "80%", data = 0.8},
			{description = "90%", data = 0.9},
			{description = "95%", data = 0.95},
			{description = "100%", data = 1},
     	 },
	    default = 0,
	
	},
	
	{
		name = "hujia",
		label = "护甲耐久（开启“护甲功能”后有效）",
		hover = "护甲耐久与武器耐久之一耗尽就消失！！",
		options = 
		{		
			{description = "300", data = 300},
			{description = "500", data = 500},
			{description = "1000", data = 1000},
			{description = "5000", data = 5000},
			{description = "10000", data = 10000},
			{description = "99999999", data = 99999999},
		},
		default = 300,
		
	},]]
	
}