name = "冰之花环"
author = "瓜瓜"
description = [[版本：0.46
装备后增加幸运效果的幸运值，具体在幸运效果mod中设置。
花环配方：15花瓣，2蓝宝石，1红宝石。需要三本科技。
耐久同海象帽，使用缝纫包修复，每次修复20%耐久。
采收获得经验，升级后增加采收暴击率，触发后双倍采收。
可给予格罗姆翅膀升级，提升采收多倍暴击的次数上限。

装备后降低饥饿速率，增加最大生命值，获得生命减伤。
装备后获得被动长歌行，右键使用治愈术。猪人、兔人获得花环后转职为牧师。可作祟复活。
装备后体温偏低时逐步获得保暖，体温偏高时逐步获得隔热。
装备后回复精神，在（地下）月岛时变为三倍扣除精神。
装备后防雨，加速，小范围发光。装备后拥有暴食手杖特效。
装备后小动物不再害怕，发情皮弗娄、眼球草、春天蜜蜂不再攻击，收获海草、蜂箱不会惊醒生物。
按Z键开启【危险感知】，按X键开启【抗拒冰环】。
在蜂后区域自然生成一个冰之花环。
]]

version = "0.46"
forumthread = ""
api_version = 10

dst_compatible = true
all_clients_require_mod = true
client_only_mod = false

icon_atlas = "ice_flowerhat.xml"
icon = "ice_flowerhat.tex"

server_filter_tags = {""}


local opt_Empty = {
	{description = "", data = 0},
}
local function title(title,hover)
	return {
		name = title,
		hover = hover,
		options = opt_Empty,
		default = 0,
	}
end
local enable_opt = {
	{description = "是", data = true},
	{description = "否", data = false},
}
local recover_sanity_opt = {
	{description = "1.2", data = 1.2},
	{description = "3", data = 3},
	{description = "6", data = 6},
	{description = "9", data = 9},
}
local repeat_opt = {
	{description = "同上", data = true},
}
local max_double_pick_probability_opt = {
	{description = "20%", data = 0.2},
	{description = "30%", data = 0.3},
	{description = "50%", data = 0.5},
	{description = "80%", data = 0.8},
	{description = "100%", data = 1},
}
local double_pick_level_up_basal_experience_opt = {
	{description = "10", data = 10},
	{description = "15", data = 15},
	{description = "20", data = 20},
	{description = "25", data = 25},
	{description = "30", data = 30},
}
local max_multiple_pick_opt = {
	{description = "3", data = 3},
	{description = "4", data = 4},
	{description = "5", data = 5},
	{description = "8", data = 8},
	{description = "10", data = 10},
}
local ratio_opt = {
	{description = "3%", data = 0.03},
	{description = "5%", data = 0.05},
	{description = "10%", data = 0.1},
	{description = "15%", data = 0.15},
	{description = "20%", data = 0.2},
	{description = "25%", data = 0.25},
	{description = "30%", data = 0.3},
	{description = "40%", data = 0.4},
	{description = "50%", data = 0.5},
	{description = "60%", data = 0.6},
	{description = "70%", data = 0.7},
	{description = "80%", data = 0.8},
	{description = "90%", data = 0.9},
	{description = "100%", data = 1},
}
local largen_maxhealth_value_opt = {
	{description = "30", data = 30},
	{description = "50", data = 50},
	{description = "70", data = 70},
	{description = "90", data = 90},
}
local light_intensity_opt = {
	{description = "30%", data = 0.3},
	{description = "50%", data = 0.5},
	{description = "80%", data = 0.8},
}
local light_radius_opt = {
	{description = "1", data = 1},
	{description = "2", data = 2},
	{description = "3", data = 3},
	{description = "4", data = 4},
	{description = "5", data = 5},
}
local key_opt = {
	{description = "Z/z", data = 122},--KEY_Z == 122
	{description = "X/x", data = 120},--KEY_X == 120
	{description = "V/v", data = 118},--KEY_V == 118
	{description = "B/b", data = 98},--KEY_B == 98
	{description = "N/n", data = 110},--KEY_N == 110
	{description = "G/g", data = 103},--KEY_G == 103
	{description = "H/h", data = 104},--KEY_H == 104
	{description = "J/j", data = 106},--KEY_J == 106
	{description = "K/k", data = 107},--KEY_K == 107
	{description = "L/l", data = 108},--KEY_L == 108
	{description = "R/r", data = 114},--KEY_R == 114
	{description = "O/o", data = 111},--KEY_O == 111
}
local sense_distance_opt = {
	{description = "10", data = 10},
	{description = "20", data = 20},
	{description = "30", data = 30},
	{description = "40", data = 40},
}
local sense_sanity_cost_opt = {
	{description = "1", data = 1},
	{description = "2", data = 2},
	{description = "3", data = 3},
	{description = "4", data = 4},
	{description = "5", data = 5},
}
local icering_sanity_cost_opt = {
	{description = "5", data = 5},
	{description = "10", data = 10},
	{description = "15", data = 15},
	{description = "20", data = 20},
	{description = "25", data = 25},
}
local duration_opt = {
	{description = "1", data = 1},
	{description = "2", data = 2},
	{description = "3", data = 3},
	{description = "4", data = 4},
	{description = "5", data = 5},
}
local cd_time_opt = {
	{description = "3", data = 3},
	{description = "5", data = 5},
	{description = "10", data = 10},
	{description = "15", data = 15},
	{description = "20", data = 20},
}

configuration_options =
{
	title("基础相关："),
	{	name = "ifh_need_repair",
		label = "需要修复",
		hover = "关闭则无限耐久",
		options = enable_opt,
		default = true,
	},
	{	name = "ifh_recover_sanity",
		label = "装备后每分钟回复精神值",
		options = recover_sanity_opt,
		default = 3,
	},
	
	title(""),
	title("采收暴击相关："),
	{	name = "ifh_double_pick_enable",
		label = "开启采集暴击",
		hover = "包括一般采集、堆肥桶、捕虫、新农场、多汁浆果、刮牛毛、刮胡子、刮海草海芽、刮蜘蛛巢、牛毛刷洗刷 \n",
		options = enable_opt,
		default = true,
	},
	{	name = "ifh_double_pick_enable2",
		label = "开启收获暴击",
		hover = "包括蘑菇农场、（寄居蟹）蜂箱、海草海芽、（寄居蟹）晾肉架、（便携）烹饪锅、香料锅、鸟笼 \n"
				.."若鸟笼不生效，则可能是与其他模组冲突",
		options = repeat_opt,
		default = true,
	},
	{	name = "ifh_double_pick_enable3",
		label = "开启获得暴击",
		hover = "包括砍树、挖矿、敲毁。 \n"
				.."若敲毁有配方的物品，则进行完整回收",
		options = repeat_opt,
		default = true,
	},
	{	name = "ifh_max_double_pick_probability",
		label = "最大采收暴击率",
		options = max_double_pick_probability_opt,
		default = 0.5,
	},
	{	name = "ifh_double_pick_show_experience",
		label = "显示经验信息",
		options = enable_opt,
		default = true,
	},
	{	name = "ifh_double_pick_level_up_basal_experience",
		label = "采收暴击率基础升级经验",
		hover = "每级升级经验 = 基础升级经验 * 1.5^采收暴击等级",
		options = double_pick_level_up_basal_experience_opt,
		default = 20,
	},

	title(""),
	{	name = "ifh_multiple_pick_enable",
		label = "开启多倍暴击",
		hover = "包括采集、收获、获得（不包括回收） \n",
		options = enable_opt,
		default = true,
	},
	{	name = "ifh_max_multiple_pick",
		label = "多倍暴击次数上限",
		options = max_multiple_pick_opt,
		default = 5,
	},
	
	title(""),
	title("存活相关："),
	{	name = "ifh_hunger_modifier_enable",
		label = "装备后饥饿速率下降",
        options = enable_opt,
        default = true,
    },
    {	name = "ifh_hunger_modifier_ratio",
		label = "饥饿速率下降比例",
        options = ratio_opt,
        default = 0.25,
    },

    title(""),
    {	name = "ifh_largen_maxhealth_enable",
		label = "装备后增加最大生命值",
        options = enable_opt,
        default = true,
    },
    {	name = "ifh_largen_maxhealth_value",
		label = "增加的最大生命值",
        options = largen_maxhealth_value_opt,
        default = 50,
    },

    title(""),
	{	name = "ifh_damage_absorb_enable",
		label = "开启伤害吸收",
		hover = "伤害吸收与护甲不叠加，在护甲抵销伤害后生效。 \n"
				.."对火焰伤害也生效。",
        options = enable_opt,
        default = true,
    },
   	{	name = "ifh_damage_absorb_ratio",
		label = "伤害吸收率",
		options = ratio_opt,
		default = 0.2,
	},
	
	title(""),
	{	name = "ifh_changgexing_enable",
		label = "蔡文姬的被动长歌行",
		hover = "受到伤害时增加70%持续衰减的移速，持续两秒； ".."同时每秒回复15%的生命，持续2秒。 \n"
				.."每10秒只能触发一次。",
        options = enable_opt,
		default = true,
    },
    {	name = "ifh_cure_enable",
		label = "开启治愈术",
		hover = "消耗自身30点生命，恢复15单位范围内玩家90点生命。 \n"
				.."每10秒只能使用一次。不可叠加，仅刷新时间。",
        options = enable_opt,
		default = true,
    },
    {	name = "ifh_cure_enable2",
		label = "猪猪牧师",
		hover = "猪人戴上花环后添加牧师后缀，不会拒绝肉食，最大忠诚时间为1年，玩家靠近也不会远离。 \n"
				.."猪人牧师不会自己主动攻击怪物，不会怕黑，晚上不会回家，月圆之夜不会变疯。",
        options = repeat_opt,
		default = true,
    },
    {	name = "ifh_cure_enable3",
		label = "兔人牧师",
		hover = "兔人戴上花环后添加牧师后缀，不会拒绝（烤）胡萝卜，最大忠诚时间为1年，玩家靠近也不会远离。 \n"
				.."兔人牧师不会自己主动攻击怪物，不会怕boss，白天不会回家，黑兔人状态也不会变成降san光环。。",
        options = repeat_opt,
		default = true,
    },
    {	name = "ifh_cure_enable4",
		label = "牧师",
		hover = "若牧师有领导者且领导者为玩家时，则会监测玩家血量并使用治愈术。 \n"
				.."治愈术使用条件：玩家血量低于（满血-90），或玩家血量低于于30",
        options = repeat_opt,
		default = true,
    },

    title(""),
	{	name = "ifh_revive_enable",
       label = "可作祟复活",
        options = enable_opt,
        default = true,
    },

    title(""),
	title("装备后效果相关："),
	{	name = "ifh_cane_enable",
		label = "装备后加速",
		options = enable_opt,
		default = true,
	},
	{	name = "ifh_cane_speedmult",
		label = "增速比例",
		options = ratio_opt,
		default = 0.1,
	},

	title(""),
	{	name = "ifh_light_enable",
		label = "装备后发光",
		options = enable_opt,
		default = true,
	},
	{	name = "ifh_light_intensity",
		label = "发光强度",
		options = light_intensity_opt,
		default = 0.5,
	},
	{	name = "ifh_light_radius",
		label = "发光半径",
		options = light_radius_opt,
		default = 3,
	},

	title(""),
	{	name = "ifh_waterproof_enable",
		label = "装备后防雨",
		options = enable_opt,
		default = true,
	},
	{	name = "ifh_waterproof_ratio",
		label = "防雨比例",
		options = ratio_opt,
		default = 0.9,
	},

	title(""),
	{	name = "ifh_remove_scarytoprey",
		label = "装备后小动物不会害怕",
        options = enable_opt,
        default = true,
    },
    {	name = "ifh_add_beefalo",
		label = "装备后春天的皮弗娄不会攻击",
        options = enable_opt,
        default = true,
    },
    {	name = "ifh_add_eyeplant",
		label = "装备后眼球草不会攻击",
		hover = "若不生效，则可能是与其他模组冲突",
        options = enable_opt,
        default = true,
    },
    {	name = "ifh_add_springbee",
		label = "装备后春天的蜜蜂不会攻击",
		hover = "若不生效，则可能是与其他模组冲突",
        options = enable_opt,
        default = true,
    },
    {	name = "ifh_add_waterplant",
		label = "装备后收获海草不会惊醒对方",
		hover = "若不生效，则可能是与其他模组冲突",
        options = enable_opt,
        default = true,
    },
    {	name = "ifh_add_beebox",
		label = "装备后收获蜂箱不会惊醒蜜蜂",
		hover = "若不生效，则可能是与其他模组冲突",
        options = enable_opt,
        default = true,
    },
   
    title(""),
	{	name = "ifh_cane_victorian_fx_enable",
        label = "开启暴食手杖特效",
        options = enable_opt,
        default = true,
    },

    title(""),
    title("主动技能相关："),
    {	name = "ifh_sense_enable",
		label = "启用范围感知",
		options = enable_opt,
		default = true,
	},
    {	name = "ifh_sense_key",
		label = "开启范围感知",
		options = key_opt,
		default = 122,--KEY_Z == 122
	},
	{	name = "ifh_sense_distance",
		label = "感知距离",
		options = sense_distance_opt,
		default = 20,
	},
	{	name = "ifh_sense_sanity_cost",
		label = "每5秒降低精神值",
		options = sense_sanity_cost_opt,
		default = 3,
	},

	title(""),
	{	name = "ifh_icering_enable",
		label = "启用抗拒冰环",
		options = enable_opt,
		default = true,
	},
	{	name = "ifh_icering_key",
		label = "开启抗拒冰环",
		options = key_opt,
		default = 120,--KEY_X == 120
	},
	{	name = "ifh_icering_cost_sanity",
		label = "消耗精神值",
		options = icering_sanity_cost_opt,
		default = 15,
	},
	{	name = "ifh_icering_cd_time",
		label = "冷却时间",
		options = cd_time_opt,
		default = 10,
	},
	{	name = "ifh_icering_decelerate_probability",
		label = "减速几率",
		options = ratio_opt,
		default = 0.7,
	},
	{	name = "ifh_icering_decelerate_duration",
		label = "减速时间",
		options = duration_opt,
		default = 3,
	},
	{	name = "ifh_icering_decelerate_ratio",
		label = "减速比例",
		options = ratio_opt,
		default = 0.7,
	},
	{	name = "ifh_boss_decelerate_resistance",
		label = "boss减速抗性",
		options = ratio_opt,
		default = 0.5,
	},
	{	name = "ifh_icering_freeze_probability",
		label = "冰冻几率",
		options = ratio_opt,
		default = 0.3,
	},
	{	name = "ifh_icering_freeze_duration",
		label = "冰冻时间",
		options = duration_opt,
		default = 2,
	},
	{	name = "ifh_boss_freeze_resistance",
		label = "boss冰冻抗性",
		options = ratio_opt,
		default = 0.7,
	},
	{	name = "ifh_boss_vector_resistance",
		label = "boss位移衰减",
		options = ratio_opt,
		default = 0.5,
	},

    title(""),
	title("彩蛋相关："),
	{	name = "ifh_worldgen_enable",
		label = "是否白给",
		hover = "生成一个在蜂后区域",
		options = enable_opt,
		default = true,
	},

	title(""),
}



