name = "海钓随机物品"
description = [[
当玩家空钩时，将能够随机钓起物品。

【浮标可影响钓起内容】，检查浮标可以看到对应影响内容

【受难模式】，钓起物品耐久和新鲜值都有概率为随机值，恶魔人附近生物死亡有概率生成灵魂

【定期清理】
地面上的物品
1、存在物品的背包容器类物品,不能被清理
2、物品使用耐久低于5%,直接被清理
3、物品可堆叠,堆叠数量一并计数,当计数超最大值,物品一堆一堆的被清理
管理员可以手动清理 of_clean()

]]
author = "月"

version = "1.2.39"

api_version = 10

all_clients_require_mod = true
client_only_mod = false
dst_compatible = true

forumthread = ""

priority = -9998 -- 优先级

server_filter_tags = {
    "海钓","修改地图"
}

-- priority = -9999 -- 需要优先级
-- 模组依赖
-- mod_dependencies = { { workshop = "workshop-2710978964"} }

icon_atlas = "fishingrod.xml"
icon = "fishingrod.tex"

game_modes = {
	{
        name = "OceanFishing",
		label = "海钓",
		description = "海钓的自定义模式",
	    settings =
	    {
	        text = "海钓",
	        description = "每次挥动海钓杆都有惊喜",
	        --level_type = "CAVE",
	        --level_type = "SURVIVAL",
	        level_type = "oceanfishing",
	        mod_game_mode = true,
	        --产卵模式
	        spawn_mode = "fixed",--固定
	        --资源更新
	        resource_renewal = false,
	        --鬼魂队友是否影响理智
	        ghost_sanity_drain = false,
	        --死亡生成鬼魂,不然就直接重选人物了
	        ghost_enabled = true,
	        --大门是否可以复活
	        portal_rez = true,
	        --重置时间
	        reset_time = nil,
	        --配方在游戏模式下有效吗
	        invalid_recipes = nil, --荒野：复活雕像不可用
	        
	        -- 没有空袭
			-- no_air_attack = true,
			-- 无科技
			-- no_crafting = true,
			-- 无小地图
			-- no_minimap = true,
			-- 没有饥饿
			-- no_hunger = true,
			-- -- 没有理智
			-- no_sanity = true,
			-- 没有头像弹出窗口,点尸体不会出现死亡小卡片
			-- no_avatar_popup = true,
			-- 尸体没有记录，
			-- no_morgue_record = true,
			-- -- 大厅等待所有玩家
			-- lobbywaitforallplayers = true,
			-- -- 隐藏worldgen加载屏幕
			-- hide_worldgen_loading_screen = true,
			-- -- 隐藏你收到的礼物
			-- hide_received_gifts = false,
	    },
	}
}

-- mod设置选项
configuration_options = {
	{
		name = "minmap",
		label = "小地图",
		hover = "太小会有岛生成不出来, 推荐200",
		options =
		{
			{description = "小", data = 120, hover = "120"},
			{description = "中", data = 150, hover = "150"},
			{description = "较大", data = 200, hover = "推荐 200"},
			{description = "大", data = 250, hover = "250"},
			{description = "巨大", data = 300, hover = "300"},
			{description = "关闭", data = 0, hover = "默认大小"},
		},
		default = 200,
	},
	{
		name = "start",
		label = "初始岛",
		hover = "在地图未生成前更改有效",
		options =
		{
			{description = "默认", data = "default_start", hover = ""},
			{description = "圣杯", data = "grail", hover = ""},
			{description = "心型", data = "love", hover = ""},
			{description = "骷髅头", data = "skull", hover = ""},
		},
		default = "default_start",
	},
	{
		name = "atriumgate",
		label = "远古大门冷却时间",
		hover = "远古大门默认是20天冷却期",
		options =
		{
			{description = "5天", data = 5, hover = ""},
			{description = "10天", data = 10, hover = ""},
			{description = "20天", data = 20, hover = ""},
			{description = "30天", data = 30, hover = ""},
			{description = "40天", data = 40, hover = ""},
		},
		default = 20,
	},
	{
		name = "sleeper",
		label = "生物是否睡眠",
		hover = "一般生物被钓起时是否处于睡眠状态",
		options =
		{
			{description = "开启(ON)", data = false, hover = ""},
			{description = "关闭(OFF)", data = true, hover = ""},
		},
		default = true,
	},
	{
		name = "build",
		label = "海上建筑",
		hover = "建筑物最终被钓起到岸上，还是钓起在海面上",
		options =
		{
			{description = "开启(ON)", data = true, hover = "在海上"},
			{description = "关闭(OFF)", data = false, hover = "在岸上"},
		},
		default = false,
	},
	-- {
	-- 	name = "no_minimap",
	-- 	label = "玩家不可以使用地图",
	-- 	hover = "玩家不可以按M键使用地图",
	-- 	options =
	-- 	{
	-- 		{description = "开启(ON)", data = true, hover = ""},
	-- 		{description = "关闭(OFF)", data = false, hover = ""},
	-- 	},
	-- 	default = false,
	-- },
	-- {
	-- 	name = "no_crafting",
	-- 	label = "玩家没有科技",
	-- 	hover = "玩家没有左侧科技,没有则无法制作, 开启赌狗模式",
	-- 	options =
	-- 	{
	-- 		{description = "开启(ON)", data = true, hover = ""},
	-- 		{description = "关闭(OFF)", data = false, hover = ""},
	-- 	},
	-- 	default = false,
	-- },
	{
		name = "suffering",
		label = "受难模式",
		hover = "调整怪物掉落物品",
		options =
		{
			{description = "开启(ON)", data = true, hover = ""},
			{description = "关闭(OFF)", data = false, hover = ""},
		},
		default = false,		
	},
	{
		name = "bobbers",
		label = "浮标可影响钓起内容",
		hover = "不同浮标可禁止部分列表物品、一竿钓两次。渔竿可接受堆叠渔具",
		options =
		{
			{description = "开启(ON)", data = true, hover = ""},
			{description = "关闭(OFF)", data = false, hover = ""},
		},
		default = true,
	},
	{
		name = "gift",
		label = "开局礼物",
		hover = "给一个包装好的礼包",
		options =
		{
			{description = "开启(ON)", data = true, hover = ""},
			{description = "关闭(OFF)", data = false, hover = ""},
		},
		default = true,
	},
	{
		name = "pullup",
		label = "可钓起海面物品",
		hover = "海钓竿可以钓起海面上的物品，仅可以放包里的物品才行",
		options =
		{
			{description = "开启(ON)", data = true, hover = ""},
			{description = "关闭(OFF)", data = false, hover = ""},
		},
		default = true,
	},
	{
		name = "regularcleaning",
		label = "定期清理",
		hover = "定期强力清理地面杂物,前三天不清理",
		options =
		{
			{description = "关闭(OFF)", data = -1, hover = ""},
			{description = "一天", data = 1, hover = ""},
			{description = "两天", data = 2, hover = ""},
			{description = "三天", data = 3, hover = ""},
			{description = "四天", data = 4, hover = ""},
			{description = "五天", data = 5, hover = ""},
			{description = "六天", data = 6, hover = ""},
			{description = "七天", data = 7, hover = ""},
		},
		default = -1,
	},
	{
		name = "lightning",
		label = "天雷陷阱开关",
		hover = "有人反馈但我测不出来，没法改。可以钓到，但不起作用",
		options =
		{
			{description = "开启(ON)", data = true, hover = "起作用"},
			{description = "关闭(OFF)", data = false, hover = "不起作用"},
		},
		default = true,
	},
}