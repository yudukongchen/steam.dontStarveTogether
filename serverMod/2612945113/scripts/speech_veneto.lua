return
{
	ACTIONFAIL =
	{
        APPRAISE = 
        {
            NOTNOW = "在忙。",		--暂无注释
        },
        REPAIR =
        {
            WRONGPIECE = "犯了和长官一样的错误。",		--化石骨架拼接错误
        },
        BUILD =
        {
            MOUNTED = "没那么多地方捣腾。",		--建造失败（骑乘状态）
            HASPET = "养太多就没资源给长官挥霍了。",		--建造失败（已经有一个宠物了）
        },
		SHAVE =
		{
			AWAKEBEEFALO = "安德烈亚都不会这么做！",		--给醒着的牛刮毛
			GENERIC = "完美如我也有做不到的事！",		--刮牛毛失败
			NOBITS = "和德国情报机构一样搞笑。",		--给没毛的牛刮毛
            REFUSE = "只有伍迪才会用",		--暂无注释
            SOMEONEELSESBEEFALO = "只有小喽啰才会做把戏。",		--暂无注释
		},
		STORE =
		{
			GENERIC = "淑女没办法携带这么多东西。",		--存放东西失败
			NOTALLOWED = "这地方被英国佬用过。",		--存放东西--不被允许
			INUSE = "就和德国人一样死板。",		--别人正在用箱子
            NOTMASTERCHEF = "长官可能会用到。",		--暂无注释
		},
        CONSTRUCT =
        {
            INUSE = "咳...先来后到。",		--建筑正在使用
            NOTALLOWED = "它不匹配。",		--建筑不允许使用
            EMPTY = "帮我拿点材料过来，不然造不了。",		--建筑空了
            MISMATCH = "笨蛋，现在用不了！",		--升级套件错误（目前用不到）
        },
		RUMMAGE =
		{	
			GENERIC = "暂时做不到。",		--打开箱子失败
			INUSE = "和罗马的房间一样“饱满”。",		--打开箱子 正在使用
            NOTMASTERCHEF = "长官可能会用到。",		--暂无注释
		},
		UNLOCK =
        {
        	WRONGKEY = "我也有做不到的事情。",		--暂无注释
        },
		USEKLAUSSACKKEY =
        {
        	WRONGKEY = "犯了和长官一样的错误，张冠李戴。",		--使用克劳斯钥匙
        	KLAUS = "看来今天来了个贵宾。",		--克劳斯
        },
		ACTIVATE = 
		{
			LOCKED_GATE = "门被锁上了。",		--远古钥匙
		},
        COOK =
        {
            GENERIC = "是不是英国人动过了这口锅。",		--做饭失败
            INUSE = "不知道别人做的料理好不好吃。",		--做饭失败-别人在用锅
            TOOFAR = "你的手有2米长么？",		--做饭失败-太远
        },
        START_CARRAT_RACE =
        {
            NO_RACERS = "不能像长官一样丢三落四。",		--暂无注释
        },
		DISMANTLE =
		{
			COOKING = "料理还在烹调，要耐心等待。",		--暂无注释
			INUSE = "应当注重礼节，先来后到才是。",		--暂无注释
			NOTEMPTY = "得先把里面的东西取出来才行。",		--暂无注释
        },
        FISH_OCEAN =
		{
			TOODEEP = "海钓要用海钓竿。",		--暂无注释
		},
        OCEAN_FISHING_POND =
		{
			WRONGGEAR = "这个鱼塘不适合用这个。",		--暂无注释
		},
        READ =
        {
            GENERIC = "博闻强识的人才能阅读，或许长春也可以",		--暂无注释
            NOBIRDS = "阅历更加丰富的人才能阅读它"		--暂无注释
        },
        GIVE =
        {
            GENERIC = "Ta很忙，等Ta停下忙碌的脚步再说。",		--给予失败
            DEAD = "不如留给长官。",		--给予 -目标死亡
            SLEEPING = "睡的真香。",		--给予--目标睡觉
            BUSY = "就再给这一次哦。",		--给予--目标正忙
            ABIGAILHEART = "或许值得一试。",		--给阿比盖尔 救赎之心
            GHOSTHEART = "这主意不好。",		--给鬼魂 救赎之心
            NOTGEM = "这玩意不合适！",		--给的不是宝石
            WRONGGEM = "要换个宝石。",		--给错了宝石
            NOTSTAFF = "形状有些不对。",		--给月石祭坛的物品不是法杖
            MUSHROOMFARM_NEEDSSHROOM = "需要蘑菇进行培养。",		--蘑菇农场需要蘑菇
            MUSHROOMFARM_NEEDSLOG = "或许活动的树木可以用。",		--蘑菇农场需要活木
            MUSHROOMFARM_NOMOONALLOWED = "这些蘑菇的心不在这里。",		--暂无注释
            SLOTFULL = "里面已经有东西了。",		--已经放了材料后，再给雕像桌子再给一个材料
            FOODFULL = "这儿已经有一顿饭了。",		--没调用
            NOTDISH = "它肯定不想吃那个。",		--没调用
            DUPLICATE = "我学过这个。",		--给雕像桌子已经学习过的图	纸
            NOTSCULPTABLE = "这么做连泥巴都捏不好。",		--给陶艺圆盘的东西不对
            NOTATRIUMKEY = "它没法开锁。",		--中庭钥匙不对
            CANTSHADOWREVIVE = "看来它还没睡醒。",		--中庭仍在CD
            WRONGSHADOWFORM = "组装不对。",		--没调用
            NOMOON = "洞穴里怎么可能会有月亮。",		--洞穴里建造月石科技
			PIGKINGGAME_MESSY = "得先打扫干净才行。",		--猪王旁边有建筑，不能开始抢元宝
			PIGKINGGAME_DANGER = "气氛不太对。",		--危险，不能开始抢元宝
			PIGKINGGAME_TOOLATE = "夜色已深，该喝咖啡。",		--不是白天，不能开始抢元宝
        },
        GIVETOPLAYER =
        {
            FULL = "Ta的口袋里或许塞满了去年的里拉",		--给玩家一个东西 -但是背包满了
            DEAD = "留着以后再给吧。",		--给死亡的玩家一个东西
            SLEEPING = "Ta睡得挺香的。",		--给睡觉的玩家一个东西
            BUSY = "再给一次咯。",		--给忙碌的玩家一个东西
        },
        GIVEALLTOPLAYER =
        {
            FULL = "可能是塞的是前年的里拉",		--给人一组东西 但是背包满了
            DEAD = "不如留着给长官。",		--给于死去的玩家一组物品
            SLEEPING = "Ta睡得很香，下次再给吧。",		--给于正在睡觉的玩家一组物品
            BUSY = "再给一次吧，Ta忙的很",		--给于正在忙碌的玩家一组物品
        },
        WRITE =
        {
            GENERIC = "现在这样挺好。",		--鞋子失败
            INUSE = "这是只能容纳一个画家的空间。",		--写字 正在使用中
        },
        DRAW =
        {
            NOIMAGE = "如果以前有这东西，就比较容易了。",		--画图缺乏图像
        },
        CHANGEIN =
        {
            GENERIC = "现在这样挺好的。",		--换装失败 
            BURNING = "有点儿危险！",		--换装失败-着火了
            INUSE = "别人在用着。",		--衣橱有人占用
            NOTENOUGHHAIR = "需要皮毛来装扮。",		--暂无注释
            NOOCCUPANT = "得在上面栓一头牛。",		--暂无注释
        },
        ATTUNE =
        {
            NOHEALTH = "现在感觉不够好。",		--制造肉雕像血量不足
        },
        MOUNT =
        {
            TARGETINCOMBAT = "西班牙人才会去挑衅发疯的牛！",		--骑乘，牛正在战斗
            INUSE = "有人先行一步了。",		--骑乘（牛被占据）
        },
        SADDLE =
        {
            TARGETINCOMBAT = "毕竟我不是西班牙人。",		--给战斗状态的牛上鞍
        },
        TEACH =
        {
            KNOWN = "长官以前教过我这些。",		--学习已经知道的蓝图
            CANTLEARN = "这就涉及到我的知识盲区了。",		--学习无法学习的蓝图
            WRONGWORLD = "这地图在这用不了。",		--学习另外一个世界的地图
			MESSAGEBOTTLEMANAGER_NOT_FOUND = "探照灯呢？卡米契亚快开灯",--Likely trying to read messagebottle treasure map in caves		--暂无注释
        },
        WRAPBUNDLE =
        {
            EMPTY = "两手空空。",		--打包纸是空的
        },
        PICKUP =
        {
			RESTRICTION = "技能不够熟练，用不了。",		--熔炉模式下捡起错误的武器
			INUSE = "再等等吧，不着急。",		--捡起已经打开的容器
            NOTMINE_YOTC =
            {
                "你可不是我的胡萝卜鼠。",		--暂无注释
                "你敢咬我！",		--暂无注释
            },
        },
        SLAUGHTER =
        {
            TOOFAR = "它逃走了。",		--屠杀？？ 因为太远而失败
        },
        REPLATE =
        {
            MISMATCH = "它需要另一种碟子。", 		--暴食-换盘子换错了 比如用碗换碟子
            SAMEDISH = "只需要用一个碟子。", 		--暴食-换盘子已经换了
        },
        SAIL =
        {
        	REPAIR = "它不需要修理。",		--暂无注释
        },
        ROW_FAIL =
        {
            BAD_TIMING0 = "太快了！",		--暂无注释
            BAD_TIMING1 = "要顺着水流！",		--暂无注释
            BAD_TIMING2 = "这样不行！",		--暂无注释
        },
        LOWER_SAIL_FAIL =
        {
            "触礁了！",		--暂无注释
            "得赶紧停下来！",		--暂无注释
            "再试一次！",		--暂无注释
        },
        BATHBOMB =
        {
            GLASSED = "犹如琉璃般美丽。",		--暂无注释
            ALREADY_BOMBED = "不需要再反应了。",		--暂无注释
        },
		GIVE_TACKLESKETCH =
		{
			DUPLICATE = "它不是这样的。",		--暂无注释
		},
		COMPARE_WEIGHABLE =
		{
            FISH_TOO_SMALL = "巴掌大小的鱼？。",		--暂无注释
            OVERSIZEDVEGGIES_TOO_SMALL = "需要两条这种才好做料理。",		--暂无注释
		},
        BEGIN_QUEST =
        {
            ONEGHOST = "只有温蒂能沟通",		--暂无注释
        },
		TELLSTORY = 
		{
			GENERIC = "只有沃尔特能用",		--暂无注释
			NOT_NIGHT = "只有沃尔特能用",		--暂无注释
			NO_FIRE = "只有沃尔特能用r",		--暂无注释
		},
        SING_FAIL =
        {
            SAMESONG = "only_used_by_wathgrithr",		--暂无注释
        },
        PLANTREGISTRY_RESEARCH_FAIL =
        {
            GENERIC = "有的事情还是不知道的为好。",		--暂无注释
            FERTILIZER = "知道的太多并不好。",		--暂无注释
        },
        FILL_OCEAN =
        {
            UNSUITABLE_FOR_PLANTS = "海水如果能淡化的话就好了。",		--暂无注释
        },
        POUR_WATER =
        {
            OUT_OF_WATER = "需要再次灌满。",		--暂无注释
        },
        POUR_WATER_GROUNDTILE =
        {
            OUT_OF_WATER = "水用完了。",		--暂无注释
        },
        USEITEMON =
        {
            BEEF_BELL_INVALID_TARGET = "即使完美如我，也有做不到的事情！",		--暂无注释
            BEEF_BELL_ALREADY_USED = "这头皮弗娄牛已经属于别人了。",		--暂无注释
            BEEF_BELL_HAS_BEEF_ALREADY = "我不需要整个牛群。",		--暂无注释
        },
        HITCHUP =
        {
            NEEDBEEF = "有铃铛吹学就能和皮弗娄牛交友了。",		--暂无注释
            NEEDBEEF_CLOSER = "它离得太远了，叫不回来。",		--暂无注释
            BEEF_HITCHED = "它已经拴好了。",		--暂无注释
            INMOOD = "它看起来太好动了。",		--暂无注释
        },
        MARK = 
        {
            ALREADY_MARKED = "已经选好了。",		--暂无注释
            NOT_PARTICIPANT = "我没有选手参赛。",		--暂无注释
        },
        YOTB_STARTCONTEST = 
        {
            DOESNTWORK = "看来这里并不支持艺术。",		--暂无注释
            ALREADYACTIVE = "他可能忙着比别的比赛呢。",		--暂无注释
        },
        YOTB_UNLOCKSKIN = 
        {
            ALREADYKNOWN = "一个熟悉的样子……这个已经学过了！",		--暂无注释
        }
	},
	ACTIONFAIL_GENERIC = "长官也办不到。",		--动作失败
	ANNOUNCE_BOAT_LEAK = "水漫金山。",		--暂无注释
	ANNOUNCE_BOAT_SINK = "看来今天是免不了泡澡了。",		--暂无注释
	ANNOUNCE_DIG_DISEASE_WARNING = "它看过去好多了。",		--挖起生病的植物
	ANNOUNCE_PICK_DISEASE_WARNING = "好臭……它生病了？",		--（植物生病）
	ANNOUNCE_ADVENTUREFAIL = "这次不太顺利。我得再试一次。",		--没调用（废案）
    ANNOUNCE_MOUNT_LOWHEALTH = "它坚持不了多久了。",		--牛血量过低
    ANNOUNCE_TOOMANYBIRDS = "only_used_by_waxwell_and_wicker",		--暂无注释
    ANNOUNCE_WAYTOOMANYBIRDS = "only_used_by_waxwell_and_wicker",		--暂无注释
    ANNOUNCE_NORMALTOMIGHTY = "only_used_by_wolfang",		--暂无注释
    ANNOUNCE_NORMALTOWIMPY = "only_used_by_wolfang",		--暂无注释
    ANNOUNCE_WIMPYTONORMAL = "only_used_by_wolfang",		--暂无注释
    ANNOUNCE_MIGHTYTONORMAL = "only_used_by_wolfang",		--暂无注释
	ANNOUNCE_BEES = "虽然无伤大雅，但还是很不爽。",		--戴养蜂帽被蜜蜂蛰
	ANNOUNCE_BOOMERANG = "想起了再港区里养的小狗。",		--回旋镖
	ANNOUNCE_CHARLIE = "唔...情况有些不太对！",		--查理即将攻击
	ANNOUNCE_CHARLIE_ATTACK = "可恶，被阴了一手。",		--被查理攻击
	ANNOUNCE_CHARLIE_MISSED = "only_used_by_winona", --winona specific 		--暂无注释
	ANNOUNCE_COLD = "嘶...我的大衣呢？卡米契亚，快帮我拿来！",		--过冷
	ANNOUNCE_HOT = "好热...好想吃冰淇淋...",		--过热
	ANNOUNCE_CRAFTING_FAIL = "材料不足。",		--没调用
	ANNOUNCE_DEERCLOPS = "看来来了个贵宾呢！",		--boss来袭
	ANNOUNCE_CAVEIN = "远处有炮击？！不对，是地震。",		--要地震了？？？
	ANNOUNCE_ANTLION_SINKHOLE = 
	{
		"紧急规避！",		--蚁狮地震
		"地震！",		--蚁狮地震
		"应该早点处理掉那个家伙的！",		--蚁狮地震
	},
	ANNOUNCE_ANTLION_TRIBUTE =
	{
        "啧。",		--向蚁狮致敬
        "拿去。",		--给蚁狮上供
        "下次应该灭了它...",		--给蚁狮上供
	},
	ANNOUNCE_SACREDCHEST_YES = "它或许值这个价。",		--远古宝箱物品正确给出蓝图
	ANNOUNCE_SACREDCHEST_NO = "它不喜欢那个。",		--远古宝箱
    ANNOUNCE_DUSK = "夕阳西下。",		--进入黄昏
    ANNOUNCE_CHARGE = "only_used_by_wx78",		--暂无注释
	ANNOUNCE_DISCHARGE = "only_used_by_wx78",		--暂无注释
	ANNOUNCE_EAT =
	{
		GENERIC = "有点想吃长官做的...",		--吃东西
		PAINFUL = "墨索里尼的O股！",		--吃怪物肉
		SPOILED = "这是英国佬做的食物吗？！",		--吃腐烂食物
		STALE = "像法国人做的食物。",		--吃黄色食物
		INVALID = "呸，恶心！",		--拒吃
        YUCKY = "呕！",		--吃红色食物
		COOKED = "only_used_by_warly",		--暂无注释
		DRIED = "only_used_by_warly",		--暂无注释
        PREPARED = "only_used_by_warly",		--暂无注释
        RAW = "only_used_by_warly",		--暂无注释
		SAME_OLD_1 = "only_used_by_warly",		--暂无注释
		SAME_OLD_2 = "only_used_by_warly",		--暂无注释
		SAME_OLD_3 = "only_used_by_warly",		--暂无注释
		SAME_OLD_4 = "only_used_by_warly",		--暂无注释
        SAME_OLD_5 = "only_used_by_warly",		--暂无注释
		TASTY = "only_used_by_warly",		--暂无注释
    },
    ANNOUNCE_ENCUMBERED =
    {
        "气喘...吁吁...",		--搬运雕像、可疑的大理石
        "长官...帮我...可恶...",		--搬运雕像、可疑的大理石
        "庞贝...西庇阿...加里波第...",		--搬运雕像、可疑的大理石
        "卡米契亚...阿维埃尔...安东尼奥...",		--搬运雕像、可疑的大理石
        "罗马...帝国...安德烈亚....卡约...！",		--搬运雕像、可疑的大理石
        "这东西...不应该由我来背.....",		--搬运雕像、可疑的大理石
        "天鹰...鹞鹰...阿布鲁齐...奥斯塔...扎拉...！",		--搬运雕像、可疑的大理石
        "气喘...吁吁...",		--搬运雕像、可疑的大理石
        "真糟糕...为什么不把其他姐妹送过来？",		--搬运雕像、可疑的大理石
    },
    ANNOUNCE_ATRIUM_DESTABILIZING = 
    {
		"话剧该落幕了！",		--中庭击杀boss后即将刷新
		"中庭的胎动",		--中庭震动
		"新的时代即将开启。",		--中庭击杀boss后即将刷新
	},
    ANNOUNCE_RUINS_RESET = "一切如故。",		--地下重置
    ANNOUNCE_SNARED = "这个骨头可能煲汤比较美味。",		--远古嘤嘤怪的骨笼
    ANNOUNCE_SNARED_IVY = "啧，明明只是杂草!",		--暂无注释
    ANNOUNCE_REPELLED = "它被保护着！",		--嘤嘤怪保护状态
	ANNOUNCE_ENTER_DARK = "好黑啊！",		--进入黑暗
	ANNOUNCE_ENTER_LIGHT = "又能重新看见了！",		--进入光源
	ANNOUNCE_FREEDOM = "呼呼...！",		--没调用（废案）
	ANNOUNCE_HIGHRESEARCH = "又学到了新知识！",		--没调用（废案）
	ANNOUNCE_HOUNDS = "烦人的狗哪儿都有！",		--猎犬将至
	ANNOUNCE_WORMS = "烦人的东西总是滔滔不绝！",		--蠕虫袭击
	ANNOUNCE_HUNGRY = "肚子好饿...",		--饥饿
	ANNOUNCE_HUNT_BEAST_NEARBY = "美味一定就在这附近。",		--即将找到野兽
	ANNOUNCE_HUNT_LOST_TRAIL = "我居然会跟丢？！",		--猎物（大象脚印丢失）
	ANNOUNCE_HUNT_LOST_TRAIL_SPRING = "煮熟的鸭子飞了。",		--大猎物丢失踪迹
	ANNOUNCE_INV_FULL = "该舍弃些不必要的东西了",		--身上的物品满了
	ANNOUNCE_KNOCKEDOUT = "好.....困....",		--被催眠
	ANNOUNCE_LOWRESEARCH = "没从那儿学到什么。",		--没调用（废案）
	ANNOUNCE_MOSQUITOS = "啊！滚开！",		--没调用
    ANNOUNCE_NOWARDROBEONFIRE = "好烫好烫！！我的衣服都烧起来了！",		--橱柜着火
    ANNOUNCE_NODANGERGIFT = "气氛不太对，有埋伏！",		--周围有危险的情况下打开礼物
    ANNOUNCE_NOMOUNTEDGIFT = "骑着牛打开礼物不符合礼节。",		--骑牛的时候打开礼物
	ANNOUNCE_NODANGERSLEEP = "危机四伏，暂不能寐",		--危险，不能睡觉
	ANNOUNCE_NODAYSLEEP = "现在不得不多付出时间弥补差距。",		--白天睡帐篷
	ANNOUNCE_NODAYSLEEP_CAVE = "还有事要做。",		--洞穴里白天睡帐篷
	ANNOUNCE_NOHUNGERSLEEP = "想和长官一起吃Canolo....",		--饿了无法睡觉
	ANNOUNCE_NOSLEEPONFIRE = "现在有燃眉之急等着我去处理。",		--营帐着火无法睡觉
	ANNOUNCE_NODANGERSIESTA = "别如此没精打采，还有活等着我去完成！",		--危险，不能午睡
	ANNOUNCE_NONIGHTSIESTA = "在这里睡觉太不淑女了。",		--夜晚睡凉棚
	ANNOUNCE_NONIGHTSIESTA_CAVE = "又湿又冷的地方怎么能睡觉嘛！",		--在洞穴里夜晚睡凉棚
	ANNOUNCE_NOHUNGERSIESTA = "想和长官吃意大利面......",		--饱度不足无法午睡
	ANNOUNCE_NODANGERAFK = "觉得现在不是逃避的时候！",		--战斗状态下线（已经移除）
	ANNOUNCE_NO_TRAP = "好吧，挺简单的。",		--没有陷阱？？？没调用
	ANNOUNCE_PECKED = "噢！不要这样！",		--被小高鸟啄
	ANNOUNCE_QUAKE = "炮击？不对....",		--地震
	ANNOUNCE_RESEARCH = "活到老学到老！",		--没调用
	ANNOUNCE_SHELTER = "躲树下不太明智.....算了。",		--下雨天躲树下
	ANNOUNCE_THORNS = "啊！",		--玫瑰、仙人掌、荆棘扎手
	ANNOUNCE_BURNT = "呀，烫！",		--烧完了
	ANNOUNCE_TORCH_OUT = "没油了！",		--火把用完了
	ANNOUNCE_THURIBLE_OUT = "它消耗殆尽了。",		--香炉燃尽
	ANNOUNCE_FAN_OUT = "毕竟是手工制作的。",		--小风车停了
    ANNOUNCE_COMPASS_OUT = "这个指南针再也指不了方向了。",		--指南针用完了
	ANNOUNCE_TRAP_WENT_OFF = "哎呀。",		--触发陷阱（例如冬季陷阱）
	ANNOUNCE_UNIMPLEMENTED = "噢！这应该还没准备好。",		--没调用
	ANNOUNCE_WORMHOLE = "呜哇...黏糊糊的真恶心！",		--跳虫洞
	ANNOUNCE_TOWNPORTALTELEPORT = "不符合逻辑，但是能用就好。",		--豪华传送
	ANNOUNCE_CANFIX = "或许我能修好这个。",		--墙壁可以修理
	ANNOUNCE_ACCOMPLISHMENT = "嗯哼！",		--没调用
	ANNOUNCE_ACCOMPLISHMENT_DONE = "在这里难免有些寂寞...",			--没调用
	ANNOUNCE_INSUFFICIENTFERTILIZER = "土地太贫瘠了。",		--土地肥力不足
	ANNOUNCE_TOOL_SLIP = "啊！滑出去了！",		--工具滑出
	ANNOUNCE_LIGHTNING_DAMAGE_AVOIDED = "差点闪电般归来",		--规避闪电
	ANNOUNCE_TOADESCAPING = "它知道了我的厉害。",		--蟾蜍正在逃跑
	ANNOUNCE_TOADESCAPED = "犹如丧家之犬。",		--蟾蜍逃走了
	ANNOUNCE_DAMP = "唔，我的伞呢？",		--潮湿（1级）
	ANNOUNCE_WET = "呜啊，我好不容易打扮好的！",		--潮湿（2级）
	ANNOUNCE_WETTER = "妆全花了，衣服也湿透了！",		--潮湿（3级）
	ANNOUNCE_SOAKED = "比掉到海里还难受！",		--潮湿（4级）
	ANNOUNCE_WASHED_ASHORE = "想洗个澡...",		--暂无注释
    ANNOUNCE_DESPAWN = "休息一下，马上回来",		--下线
	ANNOUNCE_BECOMEGHOST = "呜啊！！",		--变成鬼魂
	ANNOUNCE_GHOSTDRAIN = "唔...没注意到吗？",		--队友死亡掉san
	ANNOUNCE_PETRIFED_TREES = "树在尖叫？",		--石化树
	ANNOUNCE_KLAUS_ENRAGE = "事情变得棘手了！",		--克劳斯被激怒（杀死了鹿）
	ANNOUNCE_KLAUS_UNCHAINED = "它的链条松开了！",		--克劳斯-未上锁的  猜测是死亡准备变身？
	ANNOUNCE_KLAUS_CALLFORHELP = "居然在喊小弟来！",		--克劳斯召唤小偷
	ANNOUNCE_MOONALTAR_MINE =
	{
		GLASS_MED = "里面有东西。",		--暂无注释
		GLASS_LOW = "快挖出来了。",		--暂无注释
		GLASS_REVEAL = "你自由了！",		--暂无注释
		IDOL_MED = "里面有东西。",		--暂无注释
		IDOL_LOW = "快挖出来了。",		--暂无注释
		IDOL_REVEAL = "你自由了！",		--暂无注释
		SEED_MED = "里面有东西。",		--暂无注释
		SEED_LOW = "快挖出来了。",		--暂无注释
		SEED_REVEAL = "你自由了！",		--暂无注释
	},
    ANNOUNCE_SPOOKED = "这是什么？！",		--被吓到
	ANNOUNCE_BRAVERY_POTION = "那些树看上去没那么可怕了。",		--勇气药剂
	ANNOUNCE_MOONPOTION_FAILED = "可能没泡够时间……",		--暂无注释
	ANNOUNCE_EATING_NOT_FEASTING = "应该跟其他人分享。",		--暂无注释
	ANNOUNCE_WINTERS_FEAST_BUFF = "满满的节日精神！",		--暂无注释
	ANNOUNCE_IS_FEASTING = "冬季盛宴快乐！",		--暂无注释
	ANNOUNCE_WINTERS_FEAST_BUFF_OVER = "节过的真快……",		--暂无注释
    ANNOUNCE_REVIVING_CORPSE = "让我帮帮你。",		--没调用（熔炉）
    ANNOUNCE_REVIVED_OTHER_CORPSE = "焕然一新！",		--没调用（熔炉）
    ANNOUNCE_REVIVED_FROM_CORPSE = "好多了，谢谢啦。",		--没调用（熔炉）
    ANNOUNCE_FLARE_SEEN = "是谁发出的信号？",		--暂无注释
    ANNOUNCE_OCEAN_SILHOUETTE_INCOMING = "不好，是海怪！",		--暂无注释
	ANNOUNCE_LIGHTFIRE =
	{
		"only_used_by_willow",		--暂无注释
    },
    ANNOUNCE_HUNGRY_SLOWBUILD = 
    {
	    "only_used_by_winona",		--暂无注释
    },
    ANNOUNCE_HUNGRY_FASTBUILD = 
    {
	    "only_used_by_winona",		--暂无注释
    },
    ANNOUNCE_KILLEDPLANT = 
    {
        "only_used_by_wormwood",		--暂无注释
    },
    ANNOUNCE_GROWPLANT = 
    {
        "only_used_by_wormwood",		--暂无注释
    },
    ANNOUNCE_BLOOMING = 
    {
        "only_used_by_wormwood",		--暂无注释
    },
    ANNOUNCE_SOUL_EMPTY =
    {
        "only_used_by_wortox",		--暂无注释
    },
    ANNOUNCE_SOUL_FEW =
    {
        "only_used_by_wortox",		--暂无注释
    },
    ANNOUNCE_SOUL_MANY =
    {
        "only_used_by_wortox",		--暂无注释
    },
    ANNOUNCE_SOUL_OVERLOAD =
    {
        "only_used_by_wortox",		--暂无注释
    },
	ANNOUNCE_SLINGHSOT_OUT_OF_AMMO =
	{
		"only_used_by_walter",		--暂无注释
		"only_used_by_walter",		--暂无注释
	},
	ANNOUNCE_STORYTELLING_ABORT_FIREWENTOUT =
	{
        "only_used_by_walter",		--暂无注释
	},
	ANNOUNCE_STORYTELLING_ABORT_NOT_NIGHT =
	{
        "only_used_by_walter",		--暂无注释
	},
    ANNOUNCE_ROYALTY =
    {
        "噗。",		--向带着蜂王帽的队友鞠躬
        "你看过去挺滑稽的。",		--向带着蜂王帽的队友鞠躬
        "好好笑",		--向带着蜂王帽的队友鞠躬
    },
    ANNOUNCE_ATTACH_BUFF_ELECTRICATTACK    = "准备开火！",		--暂无注释
    ANNOUNCE_ATTACH_BUFF_ATTACK            = "为了罗马的荣光！",		--暂无注释
    ANNOUNCE_ATTACH_BUFF_PLAYERABSORPTION  = "稍微安全点了，至少现在是。",		--暂无注释
    ANNOUNCE_ATTACH_BUFF_WORKEFFECTIVENESS = "干劲十足！",		--暂无注释
    ANNOUNCE_ATTACH_BUFF_MOISTUREIMMUNITY  = "干燥了许多。",		--暂无注释
    ANNOUNCE_ATTACH_BUFF_SLEEPRESISTANCE   = "神清气爽了起来。",		--暂无注释
    ANNOUNCE_DETACH_BUFF_ELECTRICATTACK    = "还有一丝残余的电力。",		--暂无注释
    ANNOUNCE_DETACH_BUFF_ATTACK            = "有点困。",		--暂无注释
    ANNOUNCE_DETACH_BUFF_PLAYERABSORPTION  = "感觉上还行。",		--暂无注释
    ANNOUNCE_DETACH_BUFF_WORKEFFECTIVENESS = "阿米契亚，帮我把剩下的事情做完......啊？...",		--暂无注释
    ANNOUNCE_DETACH_BUFF_MOISTUREIMMUNITY  = "就这？",		--暂无注释
    ANNOUNCE_DETACH_BUFF_SLEEPRESISTANCE   = "……（哈欠）……困……",		--暂无注释
	ANNOUNCE_OCEANFISHING_LINESNAP = "它很顽强。",		--暂无注释
	ANNOUNCE_OCEANFISHING_LINETOOLOOSE = "收线也许管用。",		--暂无注释
	ANNOUNCE_OCEANFISHING_GOTAWAY = "它逃走了。",		--暂无注释
	ANNOUNCE_OCEANFISHING_BADCAST = "没办法，术业有专攻……",		--暂无注释
	ANNOUNCE_OCEANFISHING_IDLE_QUOTE = 
	{
		"鱼儿呢？",		--暂无注释
		"或许该换个地方钓。",		--暂无注释
		"看来这里不是产渔区！",		--暂无注释
		"这活罗马应该比较喜欢……",		--暂无注释
	},
	ANNOUNCE_WEIGHT = "重量：{weight}",		--暂无注释
	ANNOUNCE_WEIGHT_HEAVY  = "重量: {weight}\n看来我也能和罗马一样厉害!",		--暂无注释
	ANNOUNCE_WINCH_CLAW_MISS = "好像没对准。",		--暂无注释
	ANNOUNCE_WINCH_CLAW_NO_ITEM = "空手而归。",		--暂无注释
    ANNOUNCE_KINGCREATED = "only_used_by_wurt",		--暂无注释
    ANNOUNCE_KINGDESTROYED = "only_used_by_wurt",		--暂无注释
    ANNOUNCE_CANTBUILDHERE_THRONE = "only_used_by_wurt",		--暂无注释
    ANNOUNCE_CANTBUILDHERE_HOUSE = "only_used_by_wurt",		--暂无注释
    ANNOUNCE_CANTBUILDHERE_WATCHTOWER = "only_used_by_wurt",		--暂无注释
    ANNOUNCE_READ_BOOK = 
    {
        BOOK_SLEEP = "only_used_by_wurt",		--暂无注释
        BOOK_BIRDS = "only_used_by_wurt",		--暂无注释
        BOOK_TENTACLES =  "only_used_by_wurt",		--暂无注释
        BOOK_BRIMSTONE = "only_used_by_wurt",		--暂无注释
        BOOK_GARDENING = "only_used_by_wurt",		--暂无注释
		BOOK_SILVICULTURE = "only_used_by_wurt",		--暂无注释
		BOOK_HORTICULTURE = "only_used_by_wurt",		--暂无注释
    },
    ANNOUNCE_WEAK_RAT = "这只胡萝卜鼠不在训练的状态。",		--暂无注释
    ANNOUNCE_CARRAT_START_RACE = "实验——，比赛开始！",		--暂无注释
    ANNOUNCE_CARRAT_ERROR_WRONG_WAY = 
    {
        "不，不！方向错了！",		--暂无注释
        "掉头，你什么眼神啊！",		--暂无注释
    },
    ANNOUNCE_CARRAT_ERROR_FELL_ASLEEP = "你居然偷懒！给我起来！",    		--暂无注释
    ANNOUNCE_CARRAT_ERROR_WALKING = "不要用走，跑！",    		--暂无注释
    ANNOUNCE_CARRAT_ERROR_STUNNED = "站起来！冲，冲！",		--暂无注释
    ANNOUNCE_GHOST_QUEST = "only_used_by_wendy",		--暂无注释
    ANNOUNCE_GHOST_HINT = "only_used_by_wendy",		--暂无注释
    ANNOUNCE_GHOST_TOY_NEAR = 
    {
        "only_used_by_wendy",		--暂无注释
    },
	ANNOUNCE_SISTURN_FULL = "only_used_by_wendy",		--暂无注释
    ANNOUNCE_ABIGAIL_DEATH = "only_used_by_wendy",		--暂无注释
    ANNOUNCE_ABIGAIL_RETRIEVE = "only_used_by_wendy",		--暂无注释
	ANNOUNCE_ABIGAIL_LOW_HEALTH = "only_used_by_wendy",		--暂无注释
    ANNOUNCE_ABIGAIL_SUMMON = 
	{
		LEVEL1 = "only_used_by_wendy",		--暂无注释
		LEVEL2 = "only_used_by_wendy",		--暂无注释
		LEVEL3 = "only_used_by_wendy",		--暂无注释
	},
    ANNOUNCE_GHOSTLYBOND_LEVELUP = 
	{
		LEVEL2 = "only_used_by_wendy",		--暂无注释
		LEVEL3 = "only_used_by_wendy",		--暂无注释
	},
    ANNOUNCE_NOINSPIRATION = "only_used_by_wathgrithr",		--暂无注释
    ANNOUNCE_BATTLESONG_INSTANT_TAUNT_BUFF = "only_used_by_wathgrithr",		--暂无注释
    ANNOUNCE_BATTLESONG_INSTANT_PANIC_BUFF = "only_used_by_wathgrithr",		--暂无注释
    ANNOUNCE_ARCHIVE_NEW_KNOWLEDGE = "哦哦，长官也不知道的知识！",		--暂无注释
    ANNOUNCE_ARCHIVE_OLD_KNOWLEDGE = "我已经学过了！",		--暂无注释
    ANNOUNCE_ARCHIVE_NO_POWER = "它似乎也缺石油。",		--暂无注释
    ANNOUNCE_PLANT_RESEARCHED =
    {
        "原来是这样！",		--暂无注释
    },
    ANNOUNCE_PLANT_RANDOMSEED = "小禾才露尖尖角。",		--暂无注释
    ANNOUNCE_FERTILIZER_RESEARCHED = "虽然臭是臭了点，但是能种出好的食材。",		--暂无注释
	ANNOUNCE_FIRENETTLE_TOXIN = 
	{
		"我并不喜欢这种植物！",		--暂无注释
		"切，这东西扔给德国佬应该能让他们撑过冬天！",		--暂无注释
	},
	ANNOUNCE_FIRENETTLE_TOXIN_DONE = "要让妹妹们远离火荨麻。",		--暂无注释
	ANNOUNCE_TALK_TO_PLANTS = 
	{
        "扛上背包和行装，我要出发到远方！",		--暂无注释
        "当那春天来到，大地充满阳光！",		--暂无注释
		"梯里通吧~梯里通吧~！",		--暂无注释
        "玫瑰花上露珠闪闪发光，鸟儿振翅飞翔！",		--暂无注释
        "小河清清流水欢唱，我要出发到远方！",		--暂无注释
	},
    ANNOUNCE_CALL_BEEF = "你给我过来！",		--暂无注释
    ANNOUNCE_CANTBUILDHERE_YOTB_POST = "放在这里裁判是看不到我的皮弗娄牛的。",		--暂无注释
    ANNOUNCE_YOTB_LEARN_NEW_PATTERN =  "我满满都是皮弗娄牛造型的灵感！",		--暂无注释
	BATTLECRY =
	{
		GENERIC = "受死吧！",		--战斗
		PIG = "该死的猪！",		--战斗 猪人
		PREY = "战斗吧！",		--战斗 猎物？？大象？
		SPIDER = "讨厌的蜘蛛！",		--战斗 蜘蛛
		SPIDER_WARRIOR = "这就是无视我的代价！",		--战斗 蜘蛛战士
		DEER = "接受最强炮火的洗礼吧！",		--战斗 无眼鹿
	},
	COMBAT_QUIT =
	{
		GENERIC = "他肯定尝到我的厉害了！",		--攻击目标被卡住，无法攻击
		PIG = "这次我放他走。",		--退出战斗-猪人
		PREY = "他速度太快了！",		--退出战斗 猎物？？大象？
		SPIDER = "我讨厌蜘蛛。",		-- 退出战斗 蜘蛛
		SPIDER_WARRIOR = "嘘…你这个讨厌的家伙！",		--退出战斗 蜘蛛战士
	},
	DESCRIBE =
	{
		MULTIPLAYER_PORTAL = "先安定下来等待长官的消息吧。",		-- 物品名:"绚丽之门"
        MULTIPLAYER_PORTAL_MOONROCK = "先按照已知的情报来安排下一步吧。",		-- 物品名:"天体传送门"
        MOONROCKIDOL = "我只喜欢长官。",		-- 物品名:"月岩雕像" 制造描述:"重要人物。"
        CONSTRUCTION_PLANS = "科学用品！",		-- 物品名:未找到
        ANTLION =
        {
            GENERIC = "我身上有它想要的东西。",		-- 物品名:"蚁狮"->默认
            VERYHAPPY = "看起来跟我关系不错。",		-- 物品名:"蚁狮"
            UNHAPPY = "看起来很生气。",		-- 物品名:"蚁狮"
        },
        ANTLIONTRINKET = "有人可能对此感兴趣。",		-- 物品名:"沙滩玩具"
        SANDSPIKE = "我原本会被刺穿的！",		-- 物品名:"沙刺"
        SANDBLOCK = "真是坚持不懈！",		-- 物品名:"沙堡"
        GLASSSPIKE = "我还没有被刺穿时的记忆。",		-- 物品名:"玻璃尖刺"
        GLASSBLOCK = "漂亮的城堡。",		-- 物品名:"玻璃城堡"
        ABIGAIL_FLOWER =
        {
            GENERIC ="太漂亮了，让人流连忘返。",		-- 物品名:"阿比盖尔之花"->默认 制造描述:"一个神奇的纪念品。"
			LEVEL1 = "你想一个人待着吗？",		-- 物品名:"阿比盖尔之花" 制造描述:"一个神奇的纪念品。"
			LEVEL2 = "她准备跟我们吐露心扉了。",		-- 物品名:"阿比盖尔之花" 制造描述:"一个神奇的纪念品。"
			LEVEL3 = "精神头真足啊！",		-- 物品名:"阿比盖尔之花" 制造描述:"一个神奇的纪念品。"
            LONG = "看到那东西时，我的灵魂受伤了。",		-- 物品名:"阿比盖尔之花"->还需要很久 制造描述:"一个神奇的纪念品。"
            MEDIUM = "这让我感到害怕。",		-- 物品名:"阿比盖尔之花" 制造描述:"一个神奇的纪念品。"
            SOON = "那朵花有情况！",		-- 物品名:"阿比盖尔之花" 制造描述:"一个神奇的纪念品。"
            HAUNTED_POCKET = "我该放下它。",		-- 物品名:"阿比盖尔之花" 制造描述:"一个神奇的纪念品。"
            HAUNTED_GROUND = "我会查明它到底做了些什么。",		-- 物品名:"阿比盖尔之花" 制造描述:"一个神奇的纪念品。"
        },
        BALLOONS_EMPTY = "气球，派对用品。",		-- 物品名:"一堆气球" 制造描述:"要是有更简单的方法该多好。"
        BALLOON = "有庆典的气氛了。",		-- 物品名:"气球" 制造描述:"谁不喜欢气球呢？"
		BALLOONPARTY = "每年的秋天，港区满是这样的气球。",		-- 物品名:"派对气球" 制造描述:"散播一点欢笑。"
		BALLOONSPEED =
        {
            DEFLATED = "所有气球都一样。",		-- 物品名:"迅捷气球" 制造描述:"让你的脚步变得轻盈。"
            GENERIC = "能够减少行动阻力的气球！",		-- 物品名:"迅捷气球"->默认 制造描述:"让你的脚步变得轻盈。"
        },
		BALLOONVEST = "安德烈亚她们应该会喜欢，噗呼呼。",		-- 物品名:"充气背心" 制造描述:"划船时带上这些艳丽的气球。"
		BALLOONHAT = "并不优雅的帽子，还会弄乱我的头发。",		-- 物品名:"气球帽" 制造描述:"开启对话的出色工具！"
        BERNIE_INACTIVE =
        {
            BROKEN = "我并不喜欢这个布偶的设计。",		-- 物品名:"伯尼" 制造描述:"这个疯狂的世界总有你熟悉的人。"
            GENERIC = "它全烧焦了。",		-- 物品名:"伯尼"->默认 制造描述:"这个疯狂的世界总有你熟悉的人。"
        },
        BERNIE_ACTIVE = "我想请个优秀的服装师来重新设计。",		-- 物品名:"伯尼"
        BERNIE_BIG = "它的行为不够优雅。",		-- 物品名:"伯尼！"
        BOOK_BIRDS = "鸟类百科全书。",		-- 物品名:"世界鸟类大全" 制造描述:"涵盖1000个物种：习性、栖息地及叫声。"
        BOOK_TENTACLES = "我并不想看这本书。",		-- 物品名:"触手的召唤" 制造描述:"让我们来了解一下地下的朋友们！"
        BOOK_GARDENING = "不错的一本书。",		-- 物品名:"应用园艺学" 制造描述:"讲述培育和照料植物的相关知识。"
		BOOK_SILVICULTURE = "我还是自己研究好了。",		-- 物品名:"应用造林学" 制造描述:"分支管理的指引。"
		BOOK_HORTICULTURE = "不错的一本书。",		-- 物品名:"应用园艺学，简编" 制造描述:"讲述培育和照料植物的相关知识。"
        BOOK_SLEEP = "安德烈亚可能需要这本书入睡。",		-- 物品名:"睡前故事" 制造描述:"送你入梦的睡前故事。"
        BOOK_BRIMSTONE = "想起毁于火山的庞贝古城。",		-- 物品名:"末日将至！" 制造描述:"世界将在火焰和灾难中终结！"
        PLAYER =
        {
            GENERIC = "贵安，%s！",		-- 物品名:未找到
            ATTACKER = "%s 看着很善变...",		-- 物品名:未找到
            MURDERER = "谋杀犯！",		-- 物品名:未找到
            REVIVER = "%s，鬼魂的朋友。",		-- 物品名:"告密的心" 制造描述:"鬼魂朋友复活了，好可怕。"
            GHOST = "%s 可以使用一颗心。",		-- 物品名:"幽灵"
            FIRESTARTER = "烧掉这个并不科学，%s。",		-- 物品名:未找到
        },
        WILSON =
        {
            GENERIC = "日安，%s！",		-- 物品名:"威尔逊"->默认
            ATTACKER = "是的。我总是看起来很吓人吗？",		-- 物品名:"威尔逊"
            MURDERER = "你的行为让我感到厌恶，%s！",		-- 物品名:"威尔逊"
            REVIVER = "%s很专业地将我们的理论付诸实现。",		-- 物品名:"告密的心" 制造描述:"鬼魂朋友复活了，好可怕。"
            GHOST = "最好想办法让他复活。",		-- 物品名:"幽灵"
            FIRESTARTER = "烧掉这个并不科学，%s。",		-- 物品名:"威尔逊"
        },
        WOLFGANG =
        {
            GENERIC = "很高兴见到你，%s！",		-- 物品名:"沃尔夫冈"->默认
            ATTACKER = "不要和强者挑起战斗...",		-- 物品名:"沃尔夫冈"
            MURDERER = "谋杀犯！我能抓到你！",		-- 物品名:"沃尔夫冈"
            REVIVER = "%s只是一个大力士。",		-- 物品名:"告密的心" 制造描述:"鬼魂朋友复活了，好可怕。"
            GHOST = "我跟你说过不要硬拉那个大石头了。数值都不对。",		-- 物品名:"幽灵"
            FIRESTARTER = "你是没法打倒火的，%s！",		-- 物品名:"沃尔夫冈"
        },
        WAXWELL =
        {
            GENERIC = "日安，%s！",		-- 物品名:"麦斯威尔"->默认
            ATTACKER = "你似乎从“说话干净利落”变成“粘舌”。",		-- 物品名:"麦斯威尔"
            MURDERER = "我要教教你逻辑和推理...这是我的强项！",		-- 物品名:"麦斯威尔"
            REVIVER = "%s他把能力用在正义的事业。",		-- 物品名:"告密的心" 制造描述:"鬼魂朋友复活了，好可怕。"
            GHOST = "不要那样看我，%s！我在努力！",		-- 物品名:"幽灵"
            FIRESTARTER = "%s只求火烤。",		-- 物品名:"麦斯威尔"
        },
        WX78 =
        {
            GENERIC = "日安，%s！",		-- 物品名:"WX-78"->默认
            ATTACKER = "%s，我想我得调整你的首要指令...",		-- 物品名:"WX-78"
            MURDERER = "%s！你已经违反了第一律法！",		-- 物品名:"WX-78"
            REVIVER = "我猜是%s让感同身受组件启动并运行。",		-- 物品名:"告密的心" 制造描述:"鬼魂朋友复活了，好可怕。"
            GHOST = "我一直认为%s该长点心。我觉得现在，我很确定！",		-- 物品名:"幽灵"
            FIRESTARTER = "%s！你看起来快融化了。发生什么事？",		-- 物品名:"WX-78"
        },
        WILLOW =
        {
            GENERIC = "日安，%s！",		-- 物品名:"薇洛"->默认
            ATTACKER = "%s紧紧抓住那个打火机...",		-- 物品名:"薇洛"
            MURDERER = "谋杀犯！纵火犯！",		-- 物品名:"薇洛"
            REVIVER = "%s，鬼魂的朋友。",		-- 物品名:"告密的心" 制造描述:"鬼魂朋友复活了，好可怕。"
            GHOST = "%s，我敢肯定你渴望有一颗心。",		-- 物品名:"幽灵"
            FIRESTARTER = "再来？",		-- 物品名:"薇洛"
        },
        WENDY =
        {
            GENERIC = "你好，%s！",		-- 物品名:"温蒂"->默认
            ATTACKER = "%s没有尖锐的东西，有吗？",		-- 物品名:"温蒂"
            MURDERER = "谋杀犯！",		-- 物品名:"温蒂"
            REVIVER = "%s视鬼魂为家人。",		-- 物品名:"告密的心" 制造描述:"鬼魂朋友复活了，好可怕。"
            GHOST = "我看到两个！我最好给%s制造一颗心。",		-- 物品名:"幽灵"
            FIRESTARTER = "我知道是你点的那些火焰，%s。",		-- 物品名:"温蒂"
        },
        WOODIE =
        {
            GENERIC = "你好，%s！",		-- 物品名:"伍迪"->默认
            ATTACKER = "%s最近有点活力...",		-- 物品名:"伍迪"
            MURDERER = "凶手！来把斧子，我们砍起来！",		-- 物品名:"伍迪"
            REVIVER = "%s救下了大家的培根。",		-- 物品名:"告密的心" 制造描述:"鬼魂朋友复活了，好可怕。"
            GHOST = "%s，“宇宙”包括虚无吗？",		-- 物品名:"幽灵"
            BEAVER = "%s在疯狂的砍树，根本停不下来！",		-- 物品名:"伍迪"
            BEAVERGHOST = "%s，如果我不复活你，你会生气吗？",		-- 物品名:"伍迪"
            MOOSE = "好奇怪啊，这是一头鹿！",		-- 物品名:"伍迪"
            MOOSEGHOST = "那一定很不舒服吧。",		-- 物品名:"伍迪"
            GOOSE = "瞧瞧这玩意！",		-- 物品名:"伍迪"
            GOOSEGHOST = "以后长点心，你这头蠢鹅！",		-- 物品名:"伍迪"
            FIRESTARTER = "%s，别把自己烧了。",		-- 物品名:"伍迪"
        },
        WICKERBOTTOM =
        {
            GENERIC = "日安，%s！",		-- 物品名:"薇克巴顿"->默认
            ATTACKER = "我感觉%s准备拿书丢我。",		-- 物品名:"薇克巴顿"
            MURDERER = "同行评审来了！",		-- 物品名:"薇克巴顿"
            REVIVER = "我对%s的实践原理深怀敬意。",		-- 物品名:"告密的心" 制造描述:"鬼魂朋友复活了，好可怕。"
            GHOST = "这似乎不太科学，不是吗，%s？",		-- 物品名:"幽灵"
            FIRESTARTER = "我相信你很有理由才点火。",		-- 物品名:"薇克巴顿"
        },
        WES =
        {
            GENERIC = "你好，%s！",		-- 物品名:"韦斯"->默认
            ATTACKER = "%s死寂般沉默...",		-- 物品名:"韦斯"
            MURDERER = "用哑剧表达这个！",		-- 物品名:"韦斯"
            REVIVER = "%s突破固有的思维模式。",		-- 物品名:"告密的心" 制造描述:"鬼魂朋友复活了，好可怕。"
            GHOST = "怎样用哑剧动作表示“我要弄个复活装备”？",		-- 物品名:"幽灵"
            FIRESTARTER = "等等，不要跟我说。火是你点的。",		-- 物品名:"韦斯"
        },
        WEBBER =
        {
            GENERIC = "日安，%s！",		-- 物品名:"韦伯"->默认
            ATTACKER = "我会卷起一张纸莎草报纸，以防万一。",		-- 物品名:"韦伯"
            MURDERER = "杀人凶手！我要灭了你，%s！",		-- 物品名:"韦伯"
            REVIVER = "%s和其他人打成一片。",		-- 物品名:"告密的心" 制造描述:"鬼魂朋友复活了，好可怕。"
            GHOST = "%s真的很想让我给它一颗心。",		-- 物品名:"幽灵"
            FIRESTARTER = "我们得开个防火安全群组会议。",		-- 物品名:"韦伯"
        },
        WATHGRITHR =
        {
            GENERIC = "日安，%s！",		-- 物品名:"薇格弗德"->默认
            ATTACKER = "有可能的话，我会躲开%s的拳头。",		-- 物品名:"薇格弗德"
            MURDERER = "%s变得狂暴！",		-- 物品名:"薇格弗德"
            REVIVER = "%s精神饱满。",		-- 物品名:"告密的心" 制造描述:"鬼魂朋友复活了，好可怕。"
            GHOST = "做的不错。你还没逃离英灵殿呢，%s。",		-- 物品名:"幽灵"
            FIRESTARTER = "%s是个加热好手。",		-- 物品名:"薇格弗德"
        },
        WINONA =
        {
            GENERIC = "日安，%s！",		-- 物品名:"薇诺娜"->默认
            ATTACKER = "%s是安全隐患.",		-- 物品名:"薇诺娜"
            MURDERER = "到此为止了，%s！",		-- 物品名:"薇诺娜"
            REVIVER = "你可真是方便好用啊，%s。",		-- 物品名:"告密的心" 制造描述:"鬼魂朋友复活了，好可怕。"
            GHOST = "好像有人在给你的计划泼冷水呢。",		-- 物品名:"幽灵"
            FIRESTARTER = "工厂的东西烧起来了。",		-- 物品名:"薇诺娜"
        },
        WORTOX =
        {
            GENERIC = "你好，%s！",		-- 物品名:"沃拓克斯"->默认
            ATTACKER = "我就知道%s不可信！",		-- 物品名:"沃拓克斯"
            MURDERER = "是时候正面对抗这个长角的恶魔了！",		-- 物品名:"沃拓克斯"
            REVIVER = "多谢你的援助之爪%s。",		-- 物品名:"告密的心" 制造描述:"鬼魂朋友复活了，好可怕。"
            GHOST = "我拒绝接受有鬼魂和恶魔的现实。",		-- 物品名:"幽灵"
            FIRESTARTER = "%s正在变成一个生存的负担。",		-- 物品名:"沃拓克斯"
        },
        WORMWOOD =
        {
            GENERIC = "你好，%s！",		-- 物品名:"沃姆伍德"->默认
            ATTACKER = "%s今天似乎比平时更多刺。",		-- 物品名:"沃姆伍德"
            MURDERER = "准备被除草吧，小杂草，%s!",		-- 物品名:"沃姆伍德"
            REVIVER = "%s从来不会放弃他的朋友。",		-- 物品名:"告密的心" 制造描述:"鬼魂朋友复活了，好可怕。"
            GHOST = "需要一些帮助吧，小伙伴？",		-- 物品名:"幽灵"
            FIRESTARTER = "我以为你讨厌火，%s.",		-- 物品名:"沃姆伍德"
        },
        WARLY =
        {
            GENERIC = "你好，%s！",		-- 物品名:"沃利"->默认
            ATTACKER = "酝酿着灾难。",		-- 物品名:"沃利"
            MURDERER = "别打杀我的主意！",		-- 物品名:"沃利"
            REVIVER = "总是可以指望%s来做一个计划。",		-- 物品名:"告密的心" 制造描述:"鬼魂朋友复活了，好可怕。"
            GHOST = "它我觉得现在用幽灵辣椒做饭吧。",		-- 物品名:"幽灵"
            FIRESTARTER = "他会把这个地方都烧了！",		-- 物品名:"沃利"
        },
        WURT =
        {
            GENERIC = "日安，%s！",		-- 物品名:"沃特"->默认
            ATTACKER = "%s今天一副凶神恶煞的样子……",		-- 物品名:"沃特"
            MURDERER = "你是条杀人鱼！",		-- 物品名:"沃特"
            REVIVER = "为什么要谢你，%s！",		-- 物品名:"告密的心" 制造描述:"鬼魂朋友复活了，好可怕。"
            GHOST = "%s鱼鳃周围比平时更绿了。",		-- 物品名:"幽灵"
            FIRESTARTER = "就没人教你别玩火吗？！",		-- 物品名:"沃特"
        },
        WALTER =
        {
            GENERIC = "日安，%s！",		-- 物品名:"沃尔特"->默认
            ATTACKER = "这是松树先锋队员该做的事吗？",		-- 物品名:"沃尔特"
            MURDERER = "你的故事素材用完了吗，%s？",		-- 物品名:"沃尔特"
            REVIVER = "%s永远靠谱。",		-- 物品名:"告密的心" 制造描述:"鬼魂朋友复活了，好可怕。"
            GHOST = "我知道你玩的很开心，但是我们要去找一颗心。",		-- 物品名:"幽灵"
            FIRESTARTER = "那个看起来可不像是营火，%s。",		-- 物品名:"沃尔特"
        },
        MIGRATION_PORTAL =
        {
            GENERIC = "我要是有朋友，就能用这玩意去看他们。",		-- 物品名:"Matic 朋友之门"->默认
            OPEN = "过去以后，我还是我吗？",		-- 物品名:"Matic 朋友之门"->打开
            FULL = "这似乎在那边很火。",		-- 物品名:"Matic 朋友之门"->满了
        },
        GLOMMER = 
        {
            GENERIC = "它的长相似乎符合一个我并不能接受的艺术流派。",		-- 物品名:"格罗姆"->默认
            SLEEPING = "悠闲的小飞虫。",		-- 物品名:"格罗姆"->睡着了
        },
        GLOMMERFLOWER =
        {
            GENERIC = "我反而比较欣赏这个花朵的艺术流派。",		-- 物品名:"格罗姆花"->默认
            DEAD = "可惜了。",		-- 物品名:"格罗姆花"->死了
        },
        GLOMMERWINGS = "希望能做一些新艺术品！",		-- 物品名:"格罗姆翅膀"
        GLOMMERFUEL = "唔…….我不愿意评论这个材料。",		-- 物品名:"格罗姆的黏液"
        BELL = "叮呤呤。",		-- 物品名:"远古铃铛" 制造描述:"这可不是普通的铃铛。"
        STATUEGLOMMER =
        {
            GENERIC = "一个不错的大理石雕像。",		-- 物品名:"格罗姆雕像"->默认
            EMPTY = "毁掉艺术品是不好的。",		-- 物品名:"格罗姆雕像"
        },
        LAVA_POND_ROCK = "可以用于雕刻。",		-- 物品名:"岩石"
		WEBBERSKULL = "可怜的小家伙。应该为他举办一个体面的葬礼。",		-- 物品名:"韦伯的头骨"
		WORMLIGHT = "可以用来做很多美食。",		-- 物品名:"发光浆果"
		WORMLIGHT_LESSER = "口感不错的好浆果。",		-- 物品名:"小发光浆果"
		WORM =
		{
		    PLANT = "它似乎想隐藏自己。",		-- 物品名:"洞穴蠕虫"
		    DIRT = "我并不喜欢它的样子。",		-- 物品名:"洞穴蠕虫"
		    WORM = "这是一只蠕虫！",		-- 物品名:"洞穴蠕虫"
		},
        WORMLIGHT_PLANT = "它似乎想隐藏自己。",		-- 物品名:"神秘植物"
		MOLE =
		{
			HELD = "可怜的小动物。",		-- 物品名:"鼹鼠"->拿在手里
			UNDERGROUND = "它在寻找矿物。",		-- 物品名:"鼹鼠"
			ABOVEGROUND = "我想打昏这个金子小偷",		-- 物品名:"鼹鼠"
		},
		MOLEHILL = "这算是它的小窝！",		-- 物品名:"鼹鼠洞"
		MOLEHAT = "利用动物制作的夜视设备。",		-- 物品名:"鼹鼠帽" 制造描述:"为穿戴者提供夜视能力。"
		EEL = "这种鱼类烹饪得当的话味道很不错。",		-- 物品名:"鳗鱼"
		EEL_COOKED = "加一点西西里海盐和白胡椒粉，再淋上柠檬汁。",		-- 物品名:"烤鳗鱼"
		UNAGI = "需要调一点鲜酱油！",		-- 物品名:"鳗鱼料理"
		EYETURRET = "我并不喜欢被它直视。",		-- 物品名:"眼睛炮塔"
		EYETURRET_ITEM = "需要安装下去。",		-- 物品名:"眼睛炮塔" 制造描述:"要远离讨厌的东西，就得杀了它们。"
		MINOTAURHORN = "这个角本身就是一个艺术品。",		-- 物品名:"守护者之角"
		MINOTAURCHEST = "战胜敌人之后会获得战利品。",		-- 物品名:"大号华丽箱子"
		THULECITE_PIECES = "可以用于合成优质矿石的碎片。",		-- 物品名:"铥矿碎片"
		POND_ALGAE = "池塘边的水藻。",		-- 物品名:"水藻"
		GREENSTAFF = "能够没有损耗的分解物品。",		-- 物品名:"拆解魔杖" 制造描述:"干净而有效的摧毁。"
		GIFT = "那是给我的吗？",		-- 物品名:"礼物"
        GIFTWRAP = "我太厉害了！",		-- 物品名:"礼物包装" 制造描述:"把东西打包起来，好看又可爱！"
		POTTEDFERN = "盆里的蕨类植物。",		-- 物品名:"蕨类盆栽" 制造描述:"做个花盆，里面栽上蕨类植物。"
        SUCCULENT_POTTED = "盆里的多肉植物。",		-- 物品名:"多肉盆栽" 制造描述:"塞进陶盆的漂亮多肉植物。"
		SUCCULENT_PLANT = "沙漠绿洲的馈赠。",		-- 物品名:"多肉植物"
		SUCCULENT_PICKED = "可以用于缓解面部疲劳。",		-- 物品名:"多肉植物"
		SENTRYWARD = "用来测绘地图，获取情报。",		-- 物品名:"月眼守卫" 制造描述:"绘图者最有价值的武器。"
        TOWNPORTAL =
        {
			GENERIC = "将古代埃及和现代雕刻艺术结合在一起。",		-- 物品名:"强征传送塔"->默认 制造描述:"用沙子的力量聚集你的朋友们。"
			ACTIVE = "可以用于远距离传送！",		-- 物品名:"强征传送塔"->激活了 制造描述:"用沙子的力量聚集你的朋友们。"
		},
        TOWNPORTALTALISMAN = 
        {
			GENERIC = "很不错的石头。",		-- 物品名:"沙之石"->默认
			ACTIVE = "希望我们的军队也能这么快的到达亚历山大。",		-- 物品名:"沙之石"->激活了
		},
        WETPAPER = "我希望它快点干。",		-- 物品名:"纸张"
        WETPOUCH = "小小的包裹。",		-- 物品名:"起皱的包裹"
        MOONROCK_PIECES = "一块可以修复的石头祭坛。",		-- 物品名:"月亮石碎块"
        MOONBASE =
        {
            GENERIC = "似乎需要插入钥匙。",		-- 物品名:"月亮石"->默认
            BROKEN = "搞砸了。",		-- 物品名:"月亮石"
            STAFFED = "然后呢？",		-- 物品名:"月亮石"
            WRONGSTAFF = "似乎选择了错误的答案。",		-- 物品名:"月亮石"->插错法杖
            MOONSTAFF = "看来舞台开始了。",		-- 物品名:"月亮石"->已经插了法杖的（月杖）
        },
        MOONDIAL = 
        {
			GENERIC = "利用水来观测月相。",		-- 物品名:"月晷"->默认 制造描述:"追踪月相！"
			NIGHT_NEW = "是新月。",		-- 物品名:"月晷"->新月 制造描述:"追踪月相！"
			NIGHT_WAX = "月亮慢慢在变圆。",		-- 物品名:"月晷"->上弦月 制造描述:"追踪月相！"
			NIGHT_FULL = "是满月。",		-- 物品名:"月晷"->满月 制造描述:"追踪月相！"
			NIGHT_WANE = "月亮正在变小。",		-- 物品名:"月晷"->下弦月 制造描述:"追踪月相！"
			CAVE = "地下并不能看到月亮。",		-- 物品名:"月晷"->洞穴 制造描述:"追踪月相！"
			WEREBEAVER = "only_used_by_woodie", --woodie specific		-- 物品名:"月晷" 制造描述:"追踪月相！"
			GLASSED = "有股不让人舒服的视线。",		-- 物品名:"月晷" 制造描述:"追踪月相！"
        },
		THULECITE = "这种金属能制作很多有用的设备。",		-- 物品名:"铥矿" 制造描述:"将小碎片合成一大块。"
		ARMORRUINS = "稳定安全的护甲。",		-- 物品名:"铥矿甲" 制造描述:"炫目并且能提供保护。"
		ARMORSKELETON = "我并不喜欢这个盔甲的设计风格。",		-- 物品名:"骨头盔甲"
		SKELETONHAT = "只能算是一个恶趣味的头盔。",		-- 物品名:"骨头头盔"
		RUINS_BAT = "顺手的武器。",		-- 物品名:"铥矿棒" 制造描述:"尖钉让一切变得更好。"
		RUINSHAT = "罗马帝国的统治者！",		-- 物品名:"铥矿皇冠" 制造描述:"附有远古力场！"
		NIGHTMARE_TIMEPIECE =
		{
            CALM = "一切都好了。",		-- 物品名:"铥矿徽章" 制造描述:"跟踪周围魔力水平的流动。"
            WARN = "有股相当强的能量。",		-- 物品名:"铥矿徽章" 制造描述:"跟踪周围魔力水平的流动。"
            WAXING = "能量变得越来越密集了！",		-- 物品名:"铥矿徽章" 制造描述:"跟踪周围魔力水平的流动。"
            STEADY = "能量好像保持稳定了。",		-- 物品名:"铥矿徽章" 制造描述:"跟踪周围魔力水平的流动。"
            WANING = "我感觉这股能量正在逐渐减弱。",		-- 物品名:"铥矿徽章" 制造描述:"跟踪周围魔力水平的流动。"
            DAWN = "噩梦终于要结束了！",		-- 物品名:"铥矿徽章" 制造描述:"跟踪周围魔力水平的流动。"
            NOMAGIC = "这里没有魔法能量。",		-- 物品名:"铥矿徽章" 制造描述:"跟踪周围魔力水平的流动。"
		},
		BISHOP_NIGHTMARE = "损坏的西洋棋主教。",		-- 物品名:"损坏的发条主教"
		ROOK_NIGHTMARE = "设计的相当差劲！",		-- 物品名:"损坏的发条战车"
		KNIGHT_NIGHTMARE = "这个骑士似乎只剩下了它丑陋的马。",		-- 物品名:"损坏的发条骑士"
		MINOTAUR = "巨大的类犀牛生物。",		-- 物品名:"远古守护者"
		SPIDER_DROPPER = "挂在天花板上的蜘蛛。",		-- 物品名:"穴居悬蛛"
		NIGHTMARELIGHT = "似乎是一种新型的灯具。",		-- 物品名:"梦魇灯座"
		NIGHTSTICK = "提供电力的武器！",		-- 物品名:"晨星锤" 制造描述:"用于夜间战斗的晨光。"
		GREENGEM = "能够够买一些石油的绿色宝石。",		-- 物品名:"绿宝石"
		MULTITOOL_AXE_PICKAXE = "将斧子与稿子结合的多用途产品！",		-- 物品名:"多用斧镐" 制造描述:"加倍实用。"
		ORANGESTAFF = "能够提供战斗所必须的机动性。",		-- 物品名:"懒人魔杖" 制造描述:"适合那些不喜欢走路的人。"
		YELLOWAMULET = "提供夜晚所必须的光照。",		-- 物品名:"魔光护符" 制造描述:"从天堂汲取力量。"
		GREENAMULET = "能够节省建造材料的物品！",		-- 物品名:"建造护符" 制造描述:"用更少的材料合成物品！"
		SLURPERPELT = "上好的魔法材料。",			-- 物品名:"铥矿徽章"->啜食者皮 制造描述:"跟踪周围魔力水平的流动。"
		SLURPER = "这个生物让我觉得反感！",		-- 物品名:"啜食者"
		SLURPER_PELT = "死了以后也没什么区别。",		-- 物品名:"啜食者皮"
		ARMORSLURPER = "可以让我更适应低消耗的生活。",		-- 物品名:"饥饿腰带" 制造描述:"保持肚子不饿。"
		ORANGEAMULET = "比罗马好用不少！ ",		-- 物品名:"懒人护符" 制造描述:"适合那些不喜欢捡东西的人。"
		YELLOWSTAFF = "召唤星星的法杖。",		-- 物品名:"唤星者魔杖" 制造描述:"召唤一个小星星。"
		YELLOWGEM = "能够交易得到弹药的黄色宝石。",		-- 物品名:"黄宝石"
		ORANGEGEM = "能够换一些钢材的橙色宝石。",		-- 物品名:"橙宝石"
        OPALSTAFF = "月亮在我的手中！",		-- 物品名:"唤月者魔杖"
        OPALPRECIOUSGEM = "这个宝石看上去能换不少的物资。",		-- 物品名:"彩虹宝石"
        TELEBASE = 
		{
			VALID = "它准备好了。",		-- 物品名:"传送焦点"->有效 制造描述:"装上宝石试试。"
			GEMS = "我需要更多紫宝石。",		-- 物品名:"传送焦点"->需要宝石 制造描述:"装上宝石试试。"
		},
		GEMSOCKET = 
		{
			VALID = "看起来准备就绪了。",		-- 物品名:"宝石底座"->有效
			GEMS = "它需要一颗宝石。",		-- 物品名:"宝石底座"->需要宝石
		},
		STAFFLIGHT = "太阳一样耀眼！",		-- 物品名:"矮星"
        STAFFCOLDLIGHT = "我还是喜欢地中海的气候。",		-- 物品名:"极光"
        ANCIENT_ALTAR = "只有法国人会把塔做的那么丑。",		-- 物品名:"远古伪科学站"
        ANCIENT_ALTAR_BROKEN = "坏掉了之后更难看了。",		-- 物品名:"损坏的远古伪科学站"
        ANCIENT_STATUE = "它可以改变世界的旋律。",		-- 物品名:"远古雕像"
        LICHEN = "食用未烹饪的野生蔬菜并不合适。",		-- 物品名:"洞穴苔藓"
		CUTLICHEN = "希望用它做的意大利面会好吃。",		-- 物品名:"苔藓"
		CAVE_BANANA = "只要不放到披萨上，吃起来还是可以的。",		-- 物品名:"洞穴香蕉"
		CAVE_BANANA_COOKED = "烹饪香蕉还是需要技巧的。",		-- 物品名:"烤香蕉"
		CAVE_BANANA_TREE = "也不知道它生长需不需要阳光。",		-- 物品名:"洞穴香蕉树"
		ROCKY = "又大又硬的石头虾。",		-- 物品名:"石虾"
		COMPASS =
		{
			GENERIC="我找不着北？",		-- 物品名:"指南针"->默认 制造描述:"指向北方。"
			N = "北。",		-- 物品名:"指南针" 制造描述:"指向北方。"
			S = "南。",		-- 物品名:"指南针" 制造描述:"指向北方。"
			E = "东。",		-- 物品名:"指南针" 制造描述:"指向北方。"
			W = "西。",		-- 物品名:"指南针" 制造描述:"指向北方。"
			NE = "东北。",		-- 物品名:"指南针" 制造描述:"指向北方。"
			SE = "东南。",		-- 物品名:"指南针" 制造描述:"指向北方。"
			NW = "西北。",		-- 物品名:"指南针" 制造描述:"指向北方。"
			SW = "西南。",		-- 物品名:"指南针" 制造描述:"指向北方。"
		},
        HOUNDSTOOTH = "令人厌恶的狗的牙齿！",		-- 物品名:"犬牙"
        ARMORSNURTLESHELL = "我不想背着它，蠢爆了。",		-- 物品名:"蜗壳护甲"
        BAT = "呃！我不喜欢它！",		-- 物品名:"洞穴蝙蝠"
        BATBAT = "还行，至少能够看出一定的设计感。",		-- 物品名:"蝙蝠棒" 制造描述:"所有科技都如此...耗费精神。"
        BATWING = "哪怕是它们都已经死了依旧让我觉得反感。",		-- 物品名:"洞穴蝙蝠翅膀"
        BATWING_COOKED = "还是给英国人吃吧。",		-- 物品名:"烤蝙蝠翅膀"
        BATCAVE = "我可不想惹它们。",		-- 物品名:"蝙蝠洞"
        BEDROLL_FURRY = "看上去很软，但是我还是很抗拒露天休息。",		-- 物品名:"毛皮铺盖" 制造描述:"舒适地一觉睡到天亮！"
        BUNNYMAN = "喜欢胡萝卜的兔子人。",		-- 物品名:"兔人"
        FLOWER_CAVE = "能够发光的植物。",		-- 物品名:"荧光花"
        GUANO = "还好能用作肥料。",		-- 物品名:"鸟粪"
        LANTERN = "精致，便携的灯具。",		-- 物品名:"提灯" 制造描述:"可加燃料、明亮、便携！"
        LIGHTBULB = "发着微弱的光。",		-- 物品名:"荧光果"
        MANRABBIT_TAIL = "似乎可以用这个绒毛来设计制作衣服。",		-- 物品名:"兔绒"
        MUSHROOMHAT = "虽然材料有点奇怪，但是我能够接受它的艺术风格。",		-- 物品名:"蘑菇帽"
        MUSHROOM_LIGHT2 =
        {
            ON = "精致生活离不开灯。",		-- 物品名:"菌伞灯"->开启 制造描述:"受到火山岩浆灯饰学问的激发。"
            OFF = "需要加一些发光材料。",		-- 物品名:"菌伞灯"->关闭 制造描述:"受到火山岩浆灯饰学问的激发。"
            BURNT = "烧焦后变得有些滑稽可笑了。",		-- 物品名:"菌伞灯"->烧焦的 制造描述:"受到火山岩浆灯饰学问的激发。"
        },
        MUSHROOM_LIGHT =
        {
            ON = "这个灯具也不错。",		-- 物品名:"蘑菇灯"->开启 制造描述:"任何蘑菇的完美添加物。"
            OFF = "需要添加一些材料让它亮起来。",		-- 物品名:"蘑菇灯"->关闭 制造描述:"任何蘑菇的完美添加物。"
            BURNT = "完全烧焦的滑稽家具。",		-- 物品名:"蘑菇灯"->烧焦的 制造描述:"任何蘑菇的完美添加物。"
        },
        SLEEPBOMB = "需要咖啡提一下神。",		-- 物品名:"睡袋" 制造描述:"可以扔掉的袋子睡意沉沉。"
        MUSHROOMBOMB = "一朵蘑菇云正在生成！",		-- 物品名:"炸弹蘑菇"
        SHROOM_SKIN = "作为一种材料它确实不太优雅。",		-- 物品名:"蘑菇皮"
        TOADSTOOL_CAP =
        {
            EMPTY = "只是地上的一个洞。",		-- 物品名:"毒菌蟾蜍"
            INGROUND = "有东西伸出来了。",		-- 物品名:"毒菌蟾蜍"->在地里面
            GENERIC = "住着地下的奇特生物。",		-- 物品名:"毒菌蟾蜍"->默认
        },
        TOADSTOOL =
        {
            GENERIC = "噗噗噗，喜欢吃蛙腿的法国人一定喜欢它的长相！",		-- 物品名:"毒菌蟾蜍"->默认
            RAGE = "真的是太逊了！",		-- 物品名:"毒菌蟾蜍"->愤怒
        },
        MUSHROOMSPROUT =
        {
            GENERIC = "有艺术感！",		-- 物品名:"孢子帽"->默认
            BURNT = "法国人设计的吧！",		-- 物品名:"孢子帽"->烧焦的
        },
        MUSHTREE_TALL =
        {
            GENERIC = "好大的蘑菇。",		-- 物品名:"蓝蘑菇树"->默认
            BLOOM = "味道有点大。",		-- 物品名:"蓝蘑菇树"->蘑菇树繁殖？？
        },
        MUSHTREE_MEDIUM =
        {
            GENERIC = "我有个疑惑，就是蘑菇怎么长在树上。",		-- 物品名:"红蘑菇树"->默认
            BLOOM = "虽然没有味道，但是还是要远离。",		-- 物品名:"红蘑菇树"->蘑菇树繁殖？？
        },
        MUSHTREE_SMALL =
        {
            GENERIC = "绿色的蘑菇树相比之下比较好看。",		-- 物品名:"绿蘑菇树"->默认
            BLOOM = "它在努力繁殖。",		-- 物品名:"绿蘑菇树"->蘑菇树繁殖？？
        },
        MUSHTREE_TALL_WEBBED = "蜘蛛利用树搭建巢穴。",		-- 物品名:"蛛网蓝蘑菇树"
        SPORE_TALL =
        {
            GENERIC = "它四处飘荡。",		-- 物品名:"蓝色孢子"->默认
            HELD = "我要在口袋里装一点光。",		-- 物品名:"蓝色孢子"->拿在手里
        },
        SPORE_MEDIUM =
        {
            GENERIC = "在这世上已了无牵挂。",		-- 物品名:"红色孢子"->默认
            HELD = "我要在口袋里装一点光。",		-- 物品名:"红色孢子"->拿在手里
        },
        SPORE_SMALL =
        {
            GENERIC = "绿色孢子还是很好看的。",		-- 物品名:"绿色孢子"->默认
            HELD = "我要在口袋里装一点光。",		-- 物品名:"绿色孢子"->拿在手里
        },
        RABBITHOUSE =
        {
            GENERIC = "兔子人的窝。",		-- 物品名:"兔屋"->默认 制造描述:"可容纳一只巨大的兔子及其所有物品。"
            BURNT = "我倒是希望法国人的地标也给烧掉，噗噗噗。",		-- 物品名:"兔屋"->烧焦的 制造描述:"可容纳一只巨大的兔子及其所有物品。"哦
        },
        SLURTLE = "呕...恶心...",		-- 物品名:"蛞蝓龟"
        SLURTLE_SHELLPIECES = "碎片反而挺好看的。",		-- 物品名:"壳碎片"
        SLURTLEHAT = "有种斯巴达风？看上去还行。",		-- 物品名:"背壳头盔"
        SLURTLEHOLE = "“黏糊糊的石头。",		-- 物品名:"蛞蝓龟窝"
        SLURTLESLIME = "真不想碰这个东西。",		-- 物品名:"蛞蝓龟黏液"
        SNURTLE = "法国人最爱吃的蜗牛，噗呼呼。",		-- 物品名:"蜗牛龟"
        SPIDER_HIDER = "这蜘蛛真让人不适！",		-- 物品名:"洞穴蜘蛛"
        SPIDER_SPITTER = "我讨厌蜘蛛！",		-- 物品名:"喷射蜘蛛"
        SPIDERHOLE = "它外面盖满了蛛网。",		-- 物品名:"蛛网岩"
        SPIDERHOLE_ROCK = "它外面盖满了蛛网。",		-- 物品名:" 蛛网岩""
        STALAGMITE = "优质的矿产资源。",		-- 物品名:"石笋"
        STALAGMITE_TALL = "能开采就更好了。",		-- 物品名:"石笋"
        TURF_CARPETFLOOR = "这才符合我的身份。",		-- 物品名:"地毯地板" 制造描述:"超级柔软。闻着就像皮弗娄牛。"
        TURF_CHECKERFLOOR = "这种地板可以铺在浴室里。",		-- 物品名:"棋盘地板" 制造描述:"精心制作成棋盘状的大理石地砖。"
        TURF_DIRT = "一块地皮。",		-- 物品名:"泥土地皮"
        TURF_FOREST = "一块地皮。",		-- 物品名:"森林地皮" 制造描述:"一块森林地皮。"
        TURF_GRASS = "一块地皮。",		-- 物品名:"长草地皮" 制造描述:"一片草地。"
        TURF_MARSH = "一块地皮。",		-- 物品名:"沼泽地皮" 制造描述:"沼泽在哪，家就在哪！"
        TURF_METEOR = "一块月球地面。",		-- 物品名:"月球环形山地皮" 制造描述:"月球表面的月坑。"
        TURF_PEBBLEBEACH = "一块海滩。",		-- 物品名:"岩石海滩地皮" 制造描述:"一块鹅卵石海滩地皮。"
        TURF_ROAD = "草草铺砌的石头。",		-- 物品名:"卵石路" 制造描述:"修建你自己的道路，通往任何地方。"
        TURF_ROCKY = "一块地皮。",		-- 物品名:"岩石地皮" 制造描述:"一块石头地皮。"
        TURF_SAVANNA = "一块地皮。",		-- 物品名:"热带草原地皮" 制造描述:"一块热带草原地皮。"
        TURF_WOODFLOOR = "这些是木地板。",		-- 物品名:"木地板" 制造描述:"优质复合地板。"
		TURF_CAVE="据说可以提炼出尿素来合成氨。",		-- 物品名:"鸟粪地皮" 制造描述:"洞穴地面冰冷的岩石。"
		TURF_FUNGUS="又一种地皮类型。",		-- 物品名:"菌类地皮" 制造描述:"一块长满了真菌的洞穴地皮。"
		TURF_FUNGUS_MOON = "又一种地皮类型。",		-- 物品名:"变异菌类地皮" 制造描述:"一块长满了变异真菌的洞穴地皮。"
		TURF_ARCHIVE = "又一种地皮类型。",		-- 物品名:"远古石刻"
		TURF_SINKHOLE="又一种地皮类型。",		-- 物品名:"黏滑地皮" 制造描述:"一块潮湿、沾满泥巴的草地地皮。"
		TURF_UNDERROCK="又一种地皮类型。",		-- 物品名:"洞穴岩石地皮" 制造描述:"一块乱石嶙峋的洞穴地皮。"
		TURF_MUD="又一种地皮类型。",		-- 物品名:"泥泞地皮" 制造描述:"一块泥地地皮。"
		TURF_DECIDUOUS = "又一种地皮类型。",		-- 物品名:"桦树地皮" 制造描述:"一块桦树森林地皮。"
		TURF_SANDY = "又一种地皮类型。",		-- 物品名:"兔屋" 制造描述:"可容纳一只巨大的兔子及其所有物品。"
		TURF_BADLANDS = "又一种地皮类型。",		-- 物品名:"兔屋" 制造描述:"可容纳一只巨大的兔子及其所有物品。"
		TURF_DESERTDIRT = "一块地皮。",		-- 物品名:"沙漠地皮" 制造描述:"一片干燥的沙子。"
		TURF_FUNGUS_GREEN = "一块地皮。",		-- 物品名:"菌类地皮" 制造描述:"一块爬满绿菌的洞穴地皮。"
		TURF_FUNGUS_RED = "一块地皮。",		-- 物品名:"菌类地皮" 制造描述:"一块爬满红菌的洞穴地皮。"
		TURF_DRAGONFLY = "你想证明它能防火吗？",		-- 物品名:"龙鳞地板" 制造描述:"消除火灾蔓延速度。"
        TURF_SHELLBEACH = "一块海滩。",		-- 物品名:"贝壳海滩地皮" 制造描述:"一块贝壳海岸。"
		POWCAKE = "看上去像是英国佬的伙食。",		-- 物品名:"芝士蛋糕"
        CAVE_ENTRANCE = "准备移开这块石头。",		-- 物品名:"被堵住的洞穴"
        CAVE_ENTRANCE_RUINS = "它有可能在隐瞒什么事情。",		-- 物品名:"被堵住的陷洞"->单机 洞二入口
       	CAVE_ENTRANCE_OPEN = 
        {
            GENERIC = "大地的入口！",		-- 物品名:"洞穴"->默认
            OPEN = "我敢打赌在那下面肯定能发现各种各样的东西。",		-- 物品名:"洞穴"->打开
            FULL = "我会等到有人离开进入。",		-- 物品名:"洞穴"->满了
        },
        CAVE_EXIT = 
        {
            GENERIC = "我想我该待在这下面。",		-- 物品名:"楼梯"->默认
            OPEN = "我暂时不想再探险了。",		-- 物品名:"楼梯"->打开
            FULL = "上面太拥挤！",		-- 物品名:"楼梯"->满了
        },
		MAXWELLPHONOGRAPH = "音乐原来是从那来的。",		-- 物品名:"麦斯威尔的留声机"->单机 麦斯威尔留声机
		BOOMERANG = "小时候和罗马她们一起玩过！",		-- 物品名:"回旋镖" 制造描述:"来自澳洲土著。"
		PIGGUARD = "它对入侵它领地的物种充满敌意。",		-- 物品名:"猪人守卫"
		ABIGAIL =
		{
            LEVEL1 =
            {
                "噢，她有一个可爱的小蝴蝶结。",		-- 物品名:未找到 制造描述:未找到
                "噢，她有一个可爱的小蝴蝶结。",		-- 物品名:未找到 制造描述:未找到
            },
            LEVEL2 = 
            {
                "噢，她有一个可爱的小蝴蝶结。",		-- 物品名:未找到 制造描述:未找到
                "噢，她有一个可爱的小蝴蝶结。",		-- 物品名:未找到 制造描述:未找到
            },
            LEVEL3 = 
            {
                "噢，她有一个可爱的小蝴蝶结。",		-- 物品名:未找到 制造描述:未找到
                "噢，她有一个可爱的小蝴蝶结。",		-- 物品名:未找到 制造描述:未找到
            },
		},
		ADVENTURE_PORTAL = "我不想再一次上当了。",		-- 物品名:"麦斯威尔之门"->单机 麦斯威尔之门
		AMULET = "能够提供一次机会的红宝石项链。",		-- 物品名:"重生护符" 制造描述:"逃离死神的魔爪。"
		ANIMAL_TRACK = "可以开始狩猎了。",		-- 物品名:"动物足迹"
		ARMORGRASS = "过于简陋的盔甲。",		-- 物品名:"草甲" 制造描述:"提供少许防护。"
		ARMORMARBLE = "我希望能够兼顾一下机动性。",		-- 物品名:"大理石甲" 制造描述:"它很重，但能够保护你。"
		ARMORWOOD = "有一款罗马样式的木甲还是不错的。",		-- 物品名:"木甲" 制造描述:"为你抵御部分伤害。"
		ARMOR_SANITY = "感觉这个护具有自己的想法。",		-- 物品名:"魂甲" 制造描述:"保护你的躯体，但无法保护你的心智。"
	ASH =
		{
			GENERIC = "火灾后就剩下灰烬了",
			REMAINS_GLOMMERFLOWER = "花朵在我传送时被火焰吞噬了。",
			REMAINS_EYE_BONE = "当我传送的时候，眼骨被火焰吞噬了！",
			REMAINS_THINGIE = "在这个被烧毁前它曾经是某样东西……",
		},
		AXE = "行动起来吧。",		-- 物品名:"斧头" 制造描述:"砍倒树木！"
		BABYBEEFALO = 
		{
			GENERIC = "啊。太可爱了！",		-- 物品名:"小皮弗娄牛"->默认
		    SLEEPING = "珍惜童年的时光吧。",		-- 物品名:"小皮弗娄牛"->睡着了
        },
        BUNDLE = "包裹着的物资！",		-- 物品名:"捆绑物资"
        BUNDLEWRAP = "将物资打包起来，方便运输。",		-- 物品名:"捆绑包装" 制造描述:"打包你的东西的部分和袋子。"
		BACKPACK = "可以装不少的物资。",		-- 物品名:"背包" 制造描述:"携带更多物品。"
		BACONEGGS = "美国佬早上也就吃这些了，噗呼呼。",		-- 物品名:"培根煎蛋"
		BANDAGE = "便携式创口贴。",		-- 物品名:"蜂蜜药膏" 制造描述:"愈合小伤口。"
		BASALT = "可以用来做防轰炸平台！",		-- 物品名:"玄武岩"
		BEARDHAIR ="不卫生的胡子。",		-- 物品名:"胡子"
		BEARGER = "它似乎在寻找食物。",		-- 物品名:"熊獾"
		BEARGERVEST = "呼，可以去阿尔卑斯山度假了！",		-- 物品名:"熊皮背心" 制造描述:"熊皮背心。"
		ICEPACK = "能够保温保鲜的背包，很有意思。",		-- 物品名:"保鲜背包" 制造描述:"容量虽小，但能保持东西新鲜。"
		BEARGER_FUR = "厚厚的动物皮毛。",		-- 物品名:"熊皮" 制造描述:"毛皮再生。"
		BEDROLL_STRAW = "我并不愿意在上面休息。",		-- 物品名:"草席卷" 制造描述:"一觉睡到天亮。"
		BEEQUEEN = "我需要征服你的蜜蜂王国！",		-- 物品名:"蜂王"
		BEEQUEENHIVE = 
		{
			GENERIC = "让人难以行动。",		-- 物品名:"蜂蜜地块"->默认
			GROWING = "那东西以前在那里吗？",		-- 物品名:"蜂蜜地块"->正在生长
		},
        BEEQUEENHIVEGROWN = "这个蜂窝有点大！",		-- 物品名:"巨大蜂窝"
        BEEGUARD = "它正在守卫它们的女王。",		-- 物品名:"嗡嗡蜜蜂"
        HIVEHAT = "这个也比较符合我的身份。",		-- 物品名:"蜂王冠"
        MINISIGN =
        {
            GENERIC = "画的还不错！",		-- 物品名:"小木牌"->默认
            UNDRAWN = "我们应该在那上面画些东西。",		-- 物品名:"小木牌"->没有画画
        },
        MINISIGN_ITEM = "需要放在地上做标记。",		-- 物品名:"小木牌" 制造描述:"用羽毛笔在这些上面画画。"
		BEE =
		{
			GENERIC = "嗡嗡嗡，嗡嗡嗡。",		-- 物品名:"蜜蜂"->默认
			HELD = "当心！",		-- 物品名:"蜜蜂"->拿在手里
		},
		BEEBOX =
		{
			READY = "可以生产美味的蜂蜜。",		-- 物品名:"蜂箱"->准备好的 满的 制造描述:"贮存你自己的蜜蜂。"
			FULLHONEY = "那群小家伙肯定羡慕这么多甜食。",		-- 物品名:"蜂箱"->蜂蜜满了 制造描述:"贮存你自己的蜜蜂。"
			GENERIC = "有蜂箱就是好！",		-- 物品名:"蜂箱"->默认 制造描述:"贮存你自己的蜜蜂。"
			NOHONEY = "它是空的。",		-- 物品名:"蜂箱"->没有蜂蜜 制造描述:"贮存你自己的蜜蜂。"
			SOMEHONEY = "我需要等一会。",		-- 物品名:"蜂箱"->有一些蜂蜜 制造描述:"贮存你自己的蜜蜂。"
			BURNT = "这是不小的浪费。",		-- 物品名:"蜂箱"->烧焦的 制造描述:"贮存你自己的蜜蜂。"
		},
		MUSHROOM_FARM =
		{
			STUFFED = "那真是许许多多的蘑菇！",		-- 物品名:"蘑菇农场"->塞，满了？？ 制造描述:"种蘑菇。"
			LOTS = "木头上长满了蘑菇。",		-- 物品名:"蘑菇农场"->很多 制造描述:"种蘑菇。"
			SOME = "我觉得现在它应该继续生长。",		-- 物品名:"蘑菇农场"->有一些 制造描述:"种蘑菇。"
			EMPTY = "我可以使用一个蘑菇或者孢子进行移植。",		-- 物品名:"蘑菇农场" 制造描述:"种蘑菇。"
			ROTTEN = "需要加入新的能量。",		-- 物品名:"蘑菇农场"->腐烂的--需要活木 制造描述:"种蘑菇。"
			BURNT = "更加难以接受的设计。",		-- 物品名:"蘑菇农场"->烧焦的 制造描述:"种蘑菇。"
			SNOWCOVERED = "在这种寒冷的天气里蘑菇没办法生长。",		-- 物品名:"蘑菇农场"->被雪覆盖 制造描述:"种蘑菇。"
		},
		BEEFALO =
		{
			FOLLOWER = "他在静静地跟着我。",		-- 物品名:"皮弗娄牛"->追随者
			GENERIC = "我挺喜欢牛的！",		-- 物品名:"皮弗娄牛"->默认
			NAKED = "呃，它好像不很开心。",		-- 物品名:"皮弗娄牛"->牛毛被刮干净了
			SLEEPING = "这个牛牛睡得真死。",		-- 物品名:"皮弗娄牛"->睡着了
            DOMESTICATED = "他是个乖乖的牛！",		-- 物品名:"皮弗娄牛"->驯化牛
            ORNERY = "适合我的战斗牛。",		-- 物品名:"皮弗娄牛"->战斗牛
            RIDER = "拥有高机动的牛。",		-- 物品名:"皮弗娄牛"->骑行牛
            PUDGY = "它吃的似乎有点多。",		-- 物品名:"皮弗娄牛"->胖牛
            MYPARTNER = "姑且算是一个合适的伙伴。",		-- 物品名:"皮弗娄牛"
		},
		BEEFALOHAT = "我不想评论这个帽子的设计，但是确实比较温暖。",		-- 物品名:"牛角帽" 制造描述:"成为牛群中的一员！连气味也变得一样。"
		BEEFALOWOOL = "可以用于做保暖衣物！",		-- 物品名:"牛毛"
		BEEHAT = "无论何时，我都厌恶空中的嗡嗡飞的东西。",		-- 物品名:"养蜂帽" 制造描述:"防止被愤怒的蜜蜂蜇伤。"
        BEESWAX = "蜂蜡是不错的防腐用品！",		-- 物品名:"蜂蜡" 制造描述:"一种有用的防腐蜂蜡。"
		BEEHIVE = "蜜蜂的巢穴！",		-- 物品名:"蜂窝"
		BEEMINE = "不管放到哪里我都不喜欢蜜蜂。",		-- 物品名:"蜜蜂地雷" 制造描述:"变成武器的蜜蜂。会出什么问题？"
		BEEMINE_MAXWELL = "被装在地雷里的狂暴蚊子！",		-- 物品名:"麦斯威尔的蚊子陷阱"->单机 麦斯威尔的蚊子陷阱
		BERRIES = "加热做成果酱更好。",		-- 物品名:"浆果"
		BERRIES_COOKED = "可以淋在卡诺罗上。",		-- 物品名:"烤浆果"
        BERRIES_JUICY = "美味的同时还足够解渴。",		-- 物品名:"多汁浆果"
        BERRIES_JUICY_COOKED = "坏的似乎比较快！",		-- 物品名:"烤多汁浆果"
		BERRYBUSH =
		{
			BARREN = "我想它需要施肥。",		-- 物品名:"浆果丛"
			WITHERED = "浆果丛因为高温枯萎了。",		-- 物品名:"浆果丛"->枯萎了
			GENERIC = "可以采摘一些浆果了。",		-- 物品名:"浆果丛"->默认
			PICKED = "要等一会才能采摘。",		-- 物品名:"浆果丛"->被采完了
			DISEASED = "看上去病的很重。",		-- 物品名:"浆果丛"->生病了
			DISEASING = "呃...有些地方不对劲。",		-- 物品名:"浆果丛"->正在生病？？
			BURNING = "需要尽早灭火。",		-- 物品名:"浆果丛"->正在燃烧
		},
		BERRYBUSH_JUICY =
		{
			BARREN = "在这种状态下，它长不出浆果。",		-- 物品名:"多汁浆果丛"
			WITHERED = "需要水来灌溉。",		-- 物品名:"多汁浆果丛"->枯萎了
			GENERIC = "我应该把浆果丛种一下。",		-- 物品名:"多汁浆果丛"->默认
			PICKED = "浆果长出来还需要时间。",		-- 物品名:"多汁浆果丛"->被采完了
			DISEASED = "它看上去很不舒服。",		-- 物品名:"多汁浆果丛"->生病了
			DISEASING = "呃...有些地方不对劲。",		-- 物品名:"多汁浆果丛"->正在生病？？
			BURNING = "需要尽早灭火。",		-- 物品名:"多汁浆果丛"->正在燃烧
		},
		BIGFOOT = "那真是一只巨大无比的脚。",		-- 物品名:"大脚怪"->单机 大脚怪
		BIRDCAGE =
		{
			GENERIC = "可以放进去一只鸟。",		-- 物品名:"鸟笼"->默认 制造描述:"为你的鸟类朋友提供一个幸福的家。"
			OCCUPIED = "只能放进去一只。",		-- 物品名:"鸟笼"->被占领 制造描述:"为你的鸟类朋友提供一个幸福的家。"
			SLEEPING = "鸟需要休息。",		-- 物品名:"鸟笼"->睡着了 制造描述:"为你的鸟类朋友提供一个幸福的家。"
			HUNGRY = "鸟需要一些的食物。",		-- 物品名:"鸟笼"->有点饿了 制造描述:"为你的鸟类朋友提供一个幸福的家。"
			STARVING = "这只鸟正在挨饿。",		-- 物品名:"鸟笼"->挨饿 制造描述:"为你的鸟类朋友提供一个幸福的家。"
			DEAD = "鸟因为没人投喂而死掉了。",		-- 物品名:"鸟笼"->死了 制造描述:"为你的鸟类朋友提供一个幸福的家。"
			SKELETON = "那只鸟肯定死了。",		-- 物品名:"骷髅"
		},
		BIRDTRAP = "捕捉鸟类的陷阱",		-- 物品名:"捕鸟陷阱" 制造描述:"捕捉会飞的动物。"
		CAVE_BANANA_BURNT = "好可惜。",		-- 物品名:->烧焦的洞穴香蕉树 
		BIRD_EGG = "可以搭配很多食物的鸟蛋。",		-- 物品名:"鸟蛋"
		BIRD_EGG_COOKED = "可以配上一些迷迭香！",		-- 物品名:"煎蛋"
		BISHOP = "我很怀疑你的设计者的艺术品味！",		-- 物品名:"发条主教"
		BLOWDART_FIRE = "利用箭头引燃目标。",		-- 物品名:"火焰吹箭" 制造描述:"向你的敌人喷火。"
		BLOWDART_SLEEP = "能够麻痹神经的吹箭。",		-- 物品名:"催眠吹箭" 制造描述:"催眠你的敌人。"
		BLOWDART_PIPE = "比较原始的狩猎武器，实用但是并不够优雅。",		-- 物品名:"吹箭" 制造描述:"向你的敌人喷射利齿。"
		BLOWDART_YELLOW = "能够引入雷电的吹箭。",		-- 物品名:"雷电吹箭" 制造描述:"朝你的敌人放闪电。"
		BLUEAMULET = "能够减缓高温侵袭的项链！",		-- 物品名:"寒冰护符" 制造描述:"多么冰冷酷炫的护符。"
		BLUEGEM = "能够换不少珍贵资源的蓝宝石。",		-- 物品名:"蓝宝石"
		BLUEPRINT = 
		{ 
            COMMON = "我学会了新的知识！",		-- 物品名:"蓝图"
            RARE = "太棒了！",		-- 物品名:"蓝图"->罕见的
        },
        SKETCH = "需要陶轮来进行雕塑。",		-- 物品名:"{item}草图"
		BLUE_CAP = "感觉只有法国佬会吃。",		-- 物品名:"采摘的蓝蘑菇"
		BLUE_CAP_COOKED = "不知道法国佬还吃不吃。",		-- 物品名:"烤蓝蘑菇"
		BLUE_MUSHROOM =
		{
			GENERIC = "是蘑菇。",		-- 物品名:"蓝蘑菇"->默认
			INGROUND = "还没到时间。",		-- 物品名:"蓝蘑菇"->在地里面
			PICKED = "需要一定的时间。",		-- 物品名:"蓝蘑菇"->被采完了
		},
		BOARDS = "可以用来建造各种设备的木板。",		-- 物品名:"木板" 制造描述:"更平直的木头。"
		BONESHARD = "希望你能在亚得里亚海里安眠。",		-- 物品名:"骨头碎片"
		BONESTEW = "自从油荒之后很难吃上饱饭了。",		-- 物品名:"炖肉汤"
		BUGNET = "我更想击碎这些飞行生物，而不是捕捉它们。",		-- 物品名:"捕虫网" 制造描述:"抓虫子用的。"
		BUSHHAT = "陆地迷彩帽子！",		-- 物品名:"灌木丛帽" 制造描述:"很好的伪装！"
		BUTTER = "黄油提供了美食的灵魂！",		-- 物品名:"黄油"
		BUTTERFLY =
		{
			GENERIC = "我并不讨厌这个飞行生物。",		-- 物品名:"蝴蝶"->默认
			HELD = "抓蝴蝶还是很有趣的！",		-- 物品名:"蝴蝶"->拿在手里
		},
		BUTTERFLYMUFFIN = "作为一道甜点还是很合格的。",		-- 物品名:"蝴蝶松饼"
		BUTTERFLYWINGS = "能够作为食材烹饪！",		-- 物品名:"蝴蝶翅膀"
		BUZZARD = "和那些该死的舰载机一样丑陋！",		-- 物品名:"秃鹫"
		SHADOWDIGGER = "可以提高生产力。",		-- 物品名:"暗影挖掘者"
		CACTUS = 
		{
			GENERIC = "我有点抵触吃这个。",		-- 物品名:"仙人掌"->默认
			PICKED = "还要在等一段时间才行。",		-- 物品名:"仙人掌"->被采完了
		},
		CACTUS_MEAT_COOKED = "如果我们占领亚历山大，我会选择尝试。",		-- 物品名:"烤仙人掌肉"
		CACTUS_MEAT = "需要用手段处理掉仙人掌的刺。",		-- 物品名:"仙人掌肉"
		CACTUS_FLOWER = "仙人掌开的花，来自沙漠的美丽。",		-- 物品名:"仙人掌花"
		COLDFIRE =
		{
			EMBERS = "火就要灭了，该加一些燃料了。",		-- 物品名:"吸热营火"->即将熄灭 制造描述:"这火是越烤越冷的冰火。"
			GENERIC = "驱走黑暗，保持凉爽。",		-- 物品名:"吸热营火"->默认 制造描述:"这火是越烤越冷的冰火。"
			HIGH = "似乎燃料加的有点多，有些浪费。",		-- 物品名:"吸热营火"->高 制造描述:"这火是越烤越冷的冰火。"
			LOW = "再加点燃料就好了。",		-- 物品名:"吸热营火"->低？ 制造描述:"这火是越烤越冷的冰火。"
			NORMAL = "凉凉的像是亚得里亚海的海风。",		-- 物品名:"吸热营火"->普通 制造描述:"这火是越烤越冷的冰火。"
			OUT = "哦，火灭了。",		-- 物品名:"吸热营火"->出去？外面？ 制造描述:"这火是越烤越冷的冰火。"
		},
		CAMPFIRE =
		{
			EMBERS = "得加燃料了，不然火就要灭了。",		-- 物品名:"营火"->即将熄灭 制造描述:"燃烧时发出光亮。"
			GENERIC = "驱走黑暗，保持温暖。",		-- 物品名:"营火"->默认 制造描述:"燃烧时发出光亮。"
			HIGH = "好大的火，像是篝火晚会！",		-- 物品名:"营火"->高 制造描述:"燃烧时发出光亮。"
			LOW = "火变得有点小了，要再加点燃料。",		-- 物品名:"营火"->低？ 制造描述:"燃烧时发出光亮。"
			NORMAL = "真舒服。",		-- 物品名:"营火"->普通 制造描述:"燃烧时发出光亮。"
			OUT = "哦，火灭了。",		-- 物品名:"营火"->出去？外面？ 制造描述:"燃烧时发出光亮。"
		},
		CANE = "象征权利的手杖！",		-- 物品名:"步行手杖" 制造描述:"泰然自若地快步走。"
		CATCOON = "虽然它很可爱，但我还是更喜欢狗。",		-- 物品名:"浣猫"
		CATCOONDEN = 
		{
			GENERIC = "树桩里的窝。",		-- 物品名:"空心树桩"->默认
			EMPTY = "它等不到它的主人回来了。",		-- 物品名:"空心树桩"
		},
		CATCOONHAT = "这个帽子的设计很不错！",		-- 物品名:"猫帽" 制造描述:"适合那些重视温暖甚于朋友的人。"
		COONTAIL = "还在摆动的尾巴。",		-- 物品名:"猫尾"
		CARROT = "可以用来做意大利面。",		-- 物品名:"胡萝卜"
		CARROT_COOKED = "煮熟的胡萝卜也很好吃。",		-- 物品名:"烤胡萝卜"
		CARROT_PLANTED = "藏在地里的蔬菜。",		-- 物品名:"胡萝卜"
		CARROT_SEEDS = "胡萝卜种子。",		-- 物品名:"椭圆形种子"
		CARTOGRAPHYDESK =
		{
			GENERIC = "可以共享地图情报了。",		-- 物品名:"制图桌"->默认 制造描述:"准确地告诉别人你去过哪里。"
			BURNING = "我们需要抢救一下作战指挥室。",		-- 物品名:"制图桌"->正在燃烧 制造描述:"准确地告诉别人你去过哪里。"
			BURNT = "防火是个严肃的课题。",		-- 物品名:"制图桌"->烧焦的 制造描述:"准确地告诉别人你去过哪里。"
		},
		WATERMELON_SEEDS = "西瓜种子。",		-- 物品名:"方形种子"
		CAVE_FERN = "它是一种蕨类植物。",		-- 物品名:"蕨类植物"
		CHARCOAL = "木炭的用途有很多。",		-- 物品名:"木炭"
        CHESSPIECE_PAWN = "西洋棋雕塑，达到了及格线。",		-- 物品名:"卒子雕塑"
        CHESSPIECE_ROOK =
        {
            GENERIC = "它比看上去的更重。",		-- 物品名:"战车雕塑"->默认
            STRUGGLE = "棋子们在动！",		-- 物品名:"战车雕塑"->三基佬棋子晃动
        },
        CHESSPIECE_KNIGHT =
        {
            GENERIC = "这就是法国佬的胸甲骑士吗，噗呼呼。",		-- 物品名:"骑士雕塑"->默认
            STRUGGLE = "棋子们在动！",		-- 物品名:"骑士雕塑"->三基佬棋子晃动
        },
        CHESSPIECE_BISHOP =
        {
            GENERIC = "不管是什么姿态的主教，我都无法接受它的设计风格。",		-- 物品名:"主教雕塑"->默认
            STRUGGLE = "棋子们在动！",		-- 物品名:"主教雕塑"->三基佬棋子晃动
        },
        CHESSPIECE_MUSE = "嗯...看起来很熟悉。",		-- 物品名:"女王雕塑"
        CHESSPIECE_FORMAL = "罗马皇帝！",		-- 物品名:"国王雕塑"
        CHESSPIECE_HORNUCOPIA = "象征着丰收的号角。",		-- 物品名:"丰饶角雕塑"
        CHESSPIECE_PIPE = "抽烟一直是海军的禁忌之一。",		-- 物品名:"泡泡烟斗雕塑"
        CHESSPIECE_DEERCLOPS = "这个生物做雕像到是有种希腊风情。",		-- 物品名:"独眼巨鹿雕塑"
        CHESSPIECE_BEARGER = "还是很生动的。",		-- 物品名:"熊獾雕塑"
        CHESSPIECE_MOOSEGOOSE =
        {
            "这个鸭子还是太吵了。",		-- 物品名:"麋鹿鹅雕塑" 制造描述:未找到
        },
        CHESSPIECE_DRAGONFLY = "就算是雕塑，我还是讨厌这个大型飞行生物。",		-- 物品名:"龙蝇雕塑"
		CHESSPIECE_MINOTAUR = "可惜它再也动不了了，噗呼呼。",		-- 物品名:"远古守护者雕塑"
        CHESSPIECE_BUTTERFLY = "这个雕塑感觉起源于意大利，很优雅。",		-- 物品名:"月蛾雕塑"
        CHESSPIECE_ANCHOR = "锚是港区的象征。",		-- 物品名:"锚雕塑"
        CHESSPIECE_MOON = "这个雕塑能够给我不小的灵感。",		-- 物品名:"“月亮” 雕塑"
        CHESSPIECE_CARRAT = "哈哈，象征着胜利。",		-- 物品名:"胡萝卜鼠雕塑"
        CHESSPIECE_MALBATROSS = "不像其他的飞行生物那么讨厌。",		-- 物品名:"邪天翁雕塑"
        CHESSPIECE_CRABKING = "在我面前它不配称为海上霸主。",		-- 物品名:"帝王蟹雕塑"
        CHESSPIECE_TOADSTOOL = "像是用法棍做的法国菜一样滑稽。",		-- 物品名:"毒菌蟾蜍雕塑"
        CHESSPIECE_STALKER = "感觉这个雕塑受到西班牙风格影响较大。",		-- 物品名:"远古织影者雕塑"
        CHESSPIECE_KLAUS = "它给我们带来礼物的同时还带来了危险。",		-- 物品名:"克劳斯雕塑"
        CHESSPIECE_BEEQUEEN = "嗯，这个雕塑很不错。",		-- 物品名:"蜂王雕塑"
        CHESSPIECE_ANTLION = "这个雕塑有一定的埃及风格。",		-- 物品名:"蚁狮雕塑"
        CHESSPIECE_BEEFALO = "写实风格的牛雕塑。",		-- 物品名:"皮弗娄牛雕塑"
        CHESSPIECE_GUARDIANPHASE3 = "它和其他生物给我的感觉完全不同。",		-- 物品名:"天体英雄雕塑"
        CHESSJUNK1 = "一堆烂发条装置。",		-- 物品名:"损坏的发条装置"
        CHESSJUNK2 = "另一堆烂发条装置。",		-- 物品名:"损坏的发条装置"
        CHESSJUNK3 = "更多的烂发条装置。",		-- 物品名:"损坏的发条装置"
		CHESTER = "相比它的不体面，我更看重它的便携性。",		-- 物品名:"切斯特"
		CHESTER_EYEBONE =
		{
			GENERIC = "它在看着我。",		-- 物品名:"眼骨"->默认
			WAITING = "它睡着了。",		-- 物品名:"眼骨"->需要等待
		},
		COOKEDMANDRAKE = "这个植物的故事版本到是有不少，可是我都不喜欢。",		-- 物品名:"烤曼德拉草"
		COOKEDMEAT = "需要加点大蒜和洋葱。",		-- 物品名:"烤大肉"
		COOKEDMONSTERMEAT = "没有人愿意吃这种东西。",		-- 物品名:"烤怪物肉"
		COOKEDSMALLMEAT = "可以淋一点蜂蜜。",		-- 物品名:"烤小肉"
		COOKPOT =
		{
			COOKING_LONG = "美食需要时间加工。",		-- 物品名:"烹饪锅"->饭还需要很久 制造描述:"制作更好的食物。"
			COOKING_SHORT = "耐心是成熟的标志之一。",		-- 物品名:"烹饪锅"->饭快做好了 制造描述:"制作更好的食物。"
			DONE = "需要留一份给罗马她们。",		-- 物品名:"烹饪锅"->完成了 制造描述:"制作更好的食物。"
			EMPTY = "烹饪也是一门艺术。",		-- 物品名:"烹饪锅" 制造描述:"制作更好的食物。"
			BURNT = "需要重新制作烹饪锅。",		-- 物品名:"烹饪锅"->烧焦的 制造描述:"制作更好的食物。"
		},
		CORN = "可以做玉米奶油烩饭。",		-- 物品名:"玉米"
		CORN_COOKED = "爆米花零食，留着给罗马好了。",		-- 物品名:"爆米花"
		CORN_SEEDS = "玉米种子。",		-- 物品名:"簇状种子"
        CANARY =
		{
			GENERIC = "符合我身份的优雅金丝雀。",		-- 物品名:"金丝雀"->默认
			HELD = "脆弱的鸟儿需要保护。",		-- 物品名:"金丝雀"->拿在手里
		},
        CANARY_POISONED = "鸟儿失去生机了。",		-- 物品名:"金丝雀（中毒）"
		CRITTERLAB = "那里面似乎有一些东西。",		-- 物品名:"岩石巢穴"
        CRITTER_GLOMLING = "可爱的小飞虫！",		-- 物品名:"小格罗姆"
        CRITTER_DRAGONLING = "这个小龙蝇真不错。",		-- 物品名:"小龙蝇"
		CRITTER_LAMB = "好乖的羊啊！",		-- 物品名:"小钢羊"
        CRITTER_PUPPY = "有一只听话的小狗也很不错。",		-- 物品名:"小座狼"
        CRITTER_KITTEN = "虽然我喜欢小狗，但是这个小猫也不错。",		-- 物品名:"小浣猫"
        CRITTER_PERDLING = "它现在还不会飞。",		-- 物品名:"小火鸡"
		CRITTER_LUNARMOTHLING = "它还会围着我飞呢。",		-- 物品名:"小蛾子"
		CROW =
		{
			GENERIC = "我并不喜欢它的叫声！",		-- 物品名:"乌鸦"->默认
			HELD = "它在那里不太快乐。",		-- 物品名:"乌鸦"->拿在手里
		},
		CUTGRASS = "可以用草做不少的装备，或者搓成绳子。",		-- 物品名:"采下的草"
		CUTREEDS = "用芦苇做莎草纸的方法来自埃及，我很想去那里。",		-- 物品名:"采下的芦苇"
		CUTSTONE = "切削石头是雕刻家的基本功。",		-- 物品名:"石砖" 制造描述:"切成正方形的石头。"
		DEADLYFEAST = "英国佬应该都不吃这东西。",		-- 物品名:"致命的盛宴"->致命盛宴 单机
		DEER =
		{
			GENERIC = "这鹿似乎很难获得外界的信息。",		-- 物品名:"无眼鹿"->默认
			ANTLER = "它的鹿角相比它的主人漂亮多了！",		-- 物品名:"无眼鹿"
		},
        DEER_ANTLER = "很不错的工艺品",		-- 物品名:"鹿角"
        DEER_GEMMED = "它被那头野兽控制着！",		-- 物品名:"无眼鹿"
		DEERCLOPS = "我觉得它有种希腊风格，但是依然缺少美感。",		-- 物品名:"独眼巨鹿"
		DEERCLOPS_EYEBALL = "我还是有些无法接受。",		-- 物品名:"独眼巨鹿眼球"
		EYEBRELLAHAT =	"能够隔绝雨水的优质伞帽。",		-- 物品名:"眼球伞" 制造描述:"面向天空的眼球让你保持干燥。"
		DEPLETED_GRASS =
		{
			GENERIC = "应该是一丛草。",		-- 物品名:"草"->默认
		},
        GOGGLESHAT = "应该算是一种现代艺术品。",		-- 物品名:"时髦的护目镜" 制造描述:"你可以瞪大眼睛看装饰性护目镜。"
        DESERTHAT = "兼顾设计感和实用性的护目镜！",		-- 物品名:"沙漠护目镜" 制造描述:"从你的眼睛里把沙子揉出来。"
		DEVTOOL = "开发工具！",		-- 物品名:"开发工具"
		DEVTOOL_NODEV = "需要一定的技巧。",		-- 物品名:"
		DIRTPILE = "狩猎的信号。",		-- 物品名:"可疑的土堆"
		DIVININGROD =
		{
			COLD = "信号不是很好。",		-- 物品名:"冻伤"->冷了
			GENERIC = "看起来像一种雷达定位装置。",		-- 物品名:"探测杖"->默认 制造描述:"肯定有方法可以离开这里..."
			HOT ="我控制不住这东西了！",		-- 物品名:"中暑"->热了
			WARM = "我在正确的方向上。",		-- 物品名:"探测杖"->温暖 制造描述:"肯定有方法可以离开这里..."
			WARMER = "肯定很接近了。",		-- 物品名:"探测杖" 制造描述:"肯定有方法可以离开这里..."
		},
		DIVININGRODBASE =
		{
			GENERIC = "像是什么东西的底座。",		-- 物品名:"探测杖底座"->默认
			READY = "看起来它需要一把大钥匙。",		-- 物品名:"探测杖底座"->准备好的 满的
			UNLOCKED = "我觉得现在机器可以工作了！",		-- 物品名:"探测杖底座"->解锁了
		},
		DIVININGRODSTART = "那根手杖看起来很有用！",		-- 物品名:"探测杖底座"->单机探测杖底座
		DRAGONFLY = "我最讨厌的就是路基大型飞行生物！",		-- 物品名:"龙蝇"
		ARMORDRAGONFLY = "可以免疫火焰的盔甲。",		-- 物品名:"鳞甲" 制造描述:"脾气火爆的盔甲。"
		DRAGON_SCALES = "还有余温残存。",		-- 物品名:"鳞片"
		DRAGONFLYCHEST = "一个大容量箱子，便于整理。",		-- 物品名:"龙鳞宝箱" 制造描述:"一种结实且防火的容器。"
		DRAGONFLYFURNACE = 
		{
			HAMMERED = "看起来有点不太对啊。",		-- 物品名:"龙鳞火炉"->被锤了 制造描述:"给自己建造一个苍蝇暖炉。"
			GENERIC = "有个火炉还是很不错的。", --no gems		-- 物品名:"龙鳞火炉"->默认 制造描述:"给自己建造一个苍蝇暖炉。"
			NORMAL = "烹饪还是取暖，火炉总是好的。", --one gem		-- 物品名:"龙鳞火炉"->普通 制造描述:"给自己建造一个苍蝇暖炉。"
			HIGH = "唔，有点烫！", --two gems		-- 物品名:"龙鳞火炉"->高 制造描述:"给自己建造一个苍蝇暖炉。"
		},
        HUTCH = "相比外表我还是更看重实用性和便携性。",		-- 物品名:"哈奇"
        HUTCH_FISHBOWL =
        {
            GENERIC = "有了它确实方便不少。",		-- 物品名:"星空"->默认
            WAITING = "或许他需要点时间。",		-- 物品名:"星空"->需要等待
        },
		LAVASPIT = 
		{
			HOT = "滚烫的岩浆！",		-- 物品名:"中暑"->热了
			COOL = "我喜欢把它叫作“干唾液”。",		-- 物品名:"龙蝇唾液"
		},
		LAVA_POND = "像是在西西里岛一样。",		-- 物品名:"岩浆池"
		LAVAE = "有意识的岩浆虫。",		-- 物品名:"岩浆虫"
		LAVAE_COCOON = "虽然冷静下来了，但是似乎失去了生命。",		-- 物品名:"冷冻虫卵"
		LAVAE_PET = 
		{
			STARVING = "可怜的小东西一定饿的受不了了。",		-- 物品名:"超级可爱岩浆虫"->挨饿
			HUNGRY = "它的小肚子在咕咕叫。",		-- 物品名:"超级可爱岩浆虫"->有点饿了
			CONTENT = "它似乎很快乐。",		-- 物品名:"超级可爱岩浆虫"->内容？？？、
			GENERIC = "我的可爱小虫子。",		-- 物品名:"超级可爱岩浆虫"->默认
		},
		LAVAE_EGG = 
		{
			GENERIC = "里面是生命的温度。",		-- 物品名:"岩浆虫卵"->默认
		},
		LAVAE_EGG_CRACKED =
		{
			COLD = "还需要加点火。",		-- 物品名:"冻伤"->冷了
			COMFY = "它似乎很开心。",		-- 物品名:"岩浆虫卵"->舒服的
		},
		LAVAE_TOOTH = "一颗蛋牙！",		-- 物品名:"岩浆虫尖牙"
		DRAGONFRUIT = "火龙果的味道还是很不错的。",		-- 物品名:"火龙果"
		DRAGONFRUIT_COOKED = "我感觉可以加一点草籽。",		-- 物品名:"烤火龙果"
		DRAGONFRUIT_SEEDS = "火龙果种子。",		-- 物品名:"球茎状种子"
		DRAGONPIE = "一个大火龙果馅饼。",		-- 物品名:"火龙果派"
		DRUMSTICK = "鸟腿可以做不少美味。",		-- 物品名:"鸟腿"
		DRUMSTICK_COOKED = "蜂蜜和蒜粉能够增添它的风味！",		-- 物品名:"炸鸟腿"
		DUG_BERRYBUSH = "可以进行移植了。",		-- 物品名:"浆果丛"
		DUG_BERRYBUSH_JUICY = "可以重新种植浆果丛了。",		-- 物品名:"多汁浆果丛"
		DUG_GRASS = "可以在合适的地方种下来。",		-- 物品名:"草丛"
		DUG_MARSH_BUSH = "生长于恶劣环境的灌木，需要重新种植。",		-- 物品名:"尖刺灌木"
		DUG_SAPLING = "要重新种植。",		-- 物品名:"树苗"
		DURIAN = "我对这个水果有一种本能的抗拒。",		-- 物品名:"榴莲"
		DURIAN_COOKED = "怎么会有人把放着东西的面饼叫披萨？",		-- 物品名:"超臭榴莲"
		DURIAN_SEEDS = "榴莲种子。",		-- 物品名:"脆籽荚"
		EARMUFFSHAT = "我的耳朵不怕冻着了。",		-- 物品名:"兔耳罩" 制造描述:"毛茸茸的保暖物品。"
		EGGPLANT = "好大的茄子啊。",		-- 物品名:"茄子"
		EGGPLANT_COOKED = "可以放上蒜泥和蘑菇。",		-- 物品名:"烤茄子"
		EGGPLANT_SEEDS = "茄子种子。",		-- 物品名:"漩涡种子"
		ENDTABLE = 
		{
			BURNT = "一个放在烧焦的桌子上的烧焦的花瓶。",		-- 物品名:"茶几"->烧焦的 制造描述:"一张装饰桌。"
			GENERIC = "桌上花瓶里的一朵花。",		-- 物品名:"茶几"->默认 制造描述:"一张装饰桌。"
			EMPTY = "我应该把一些东西放进那里。",		-- 物品名:"茶几" 制造描述:"一张装饰桌。"
			WILTED = "保证花的新鲜是淑女的基本功。",		-- 物品名:"茶几"->枯萎的 制造描述:"一张装饰桌。"
			FRESHLIGHT = "一点微光，点缀黑夜。",		-- 物品名:"茶几"->茶几-新的发光的 制造描述:"一张装饰桌。"
			OLDLIGHT = "需要更换一下。", -- will be wilted soon, light radius will be very small at this point		-- 物品名:"茶几"->茶几-旧的发光的 制造描述:"一张装饰桌。"
		},
		DECIDUOUSTREE = 
		{
			BURNING = "每年意大利都有森林火灾。",		-- 物品名:"桦栗树"->正在燃烧
			BURNT = "地中海的夏日的确缺乏降水。",		-- 物品名:"桦栗树"->烧焦的
			CHOPPED = "需要收集更多的木材。",		-- 物品名:"桦栗树"->被砍了
			POISON = "哈，看来它想阻止我的计划安排。",		-- 物品名:"桦栗树"->毒化的
			GENERIC = "这种树无论是做装饰还是木材都很不错。",		-- 物品名:"桦栗树"->默认
		},
		ACORN = "桦栗树的球状果实。",		-- 物品名:"桦栗果"
        ACORN_SAPLING = "资源的再生是必要的。",		-- 物品名:"桦栗树树苗"
		ACORN_COOKED = "可以当做小零食直接吃。",		-- 物品名:"烤桦栗果"
		BIRCHNUTDRAKE = "叽叽喳喳的小坚果。",		-- 物品名:"桦栗果精"
		EVERGREEN =
		{
			BURNING = "每年意大利都有森林火灾。",		-- 物品名:"常青树"->正在燃烧
			BURNT = "地中海的夏日的确缺乏降水。",		-- 物品名:"常青树"->烧焦的
			CHOPPED = "需要收集更多的木材。",		-- 物品名:"常青树"->被砍了
			GENERIC = "松树树种，有森林的芳香。",		-- 物品名:"常青树"->默认
		},
		EVERGREEN_SPARSE =
		{
			BURNING = "每年意大利都有森林火灾。",		-- 物品名:"粗壮常青树"->正在燃烧
			BURNT = "地中海的夏日的确缺乏降水。",		-- 物品名:"粗壮常青树"->烧焦的
			CHOPPED = "需要收集更多的木材。",		-- 物品名:"粗壮常青树"->被砍了
			GENERIC = "这种树似乎无法通过种植来再生。",		-- 物品名:"粗壮常青树"->默认
		},
		TWIGGYTREE = 
		{
			BURNING = "每年意大利都有森林火灾。",		-- 物品名:"多枝树"->正在燃烧
			BURNT = "地中海的夏日的确缺乏降水。",		-- 物品名:"多枝树"->烧焦的
			CHOPPED = "需要收集更多的木材。",		-- 物品名:"多枝树"->被砍了
			GENERIC = "满是树枝。",					-- 物品名:"多枝树"->默认
			DISEASED = "它看起来很糟糕。比平常还严重。",		-- 物品名:"多枝树"->生病了
		},
		TWIGGY_NUT_SAPLING = "快点生长吧。",		-- 物品名:"多枝树苗"
        TWIGGY_OLD = "那棵树看起来年龄大了。",		-- 物品名:"多枝树"
		TWIGGY_NUT = "它里面有一棵想要出去的多枝树。",		-- 物品名:"多枝树种"->多枝树果
		EYEPLANT = "盯着别人看是很不礼貌的行为。",		-- 物品名:"眼球草"
		INSPECTSELF = "这棵树好多树枝。",		-- 物品名:"多枝树"->检查自己
		FARMPLOT =
		{
			GENERIC = "我应该试着种一些庄稼。",		-- 物品名:未找到
			GROWING = "长啊，植物，长啊！",		-- 物品名:未找到
			NEEDSFERTILIZER = "需要施肥。",		-- 物品名:未找到
			BURNT = "灰烬中长不出庄稼。",		-- 物品名:未找到
		},
		FEATHERHAT = "这种帽子有一种地域风情，不错。",		-- 物品名:"羽毛帽" 制造描述:"头上的装饰。"
		FEATHER_CROW = "黑鸟的羽毛。",		-- 物品名:"黑色羽毛"
		FEATHER_ROBIN = "红雀的羽毛。",		-- 物品名:"红色羽毛"
		FEATHER_ROBIN_WINTER = "雪雀的羽毛。",		-- 物品名:"蔚蓝羽毛"
		FEATHER_CANARY = "华丽的金丝雀的羽毛。",		-- 物品名:"黄色羽毛"
		FEATHERPENCIL = "签字需要符合身份的笔，虽然我并不想签。",		-- 物品名:"羽毛笔" 制造描述:"是的，羽毛是必须的。"
        COOKBOOK = "记录我摸索出的食谱。",		-- 物品名:"烹饪指南" 制造描述:"查看你收集的食谱。"
		FEM_PUPPET = "她被困住了！",		-- 物品名:未找到
		FIREFLIES =
		{
			GENERIC = "发光的飞虫，烘托夏夜的温馨。",		-- 物品名:"萤火虫"->默认
			HELD = "漂亮的小虫子。在我手中发着光。",		-- 物品名:"萤火虫"->拿在手里
		},
		FIREHOUND = "很多时候是森林火灾的元凶。",		-- 物品名:"红色猎犬"
		FIREPIT =
		{
			EMBERS = "得加燃料了，不然火就要灭了。",		-- 物品名:"火坑"->即将熄灭 制造描述:"一种更安全、更高效的营火。"
			GENERIC = "驱走黑暗，保持温暖。",		-- 物品名:"火坑"->默认 制造描述:"一种更安全、更高效的营火。"
			HIGH = "石头围住了火，保证了安全。",		-- 物品名:"火坑"->高 制造描述:"一种更安全、更高效的营火。"
			LOW = "火变得有点小了，要再加点燃料。",		-- 物品名:"火坑"->低？ 制造描述:"一种更安全、更高效的营火。"
			NORMAL = "真舒服。",		-- 物品名:"火坑"->普通 制造描述:"一种更安全、更高效的营火。"
			OUT = "再加入燃料就可以继续烧起来。",		-- 物品名:"火坑"->出去？外面？ 制造描述:"一种更安全、更高效的营火。"
		},
		COLDFIREPIT =
		{
			EMBERS = "火就要灭了，该加一些燃料了。",		-- 物品名:"吸热火坑"->即将熄灭 制造描述:"燃烧效率更高，但仍然越烤越冷。"
			GENERIC = "驱走黑暗，保持凉爽。",		-- 物品名:"吸热火坑"->默认 制造描述:"燃烧效率更高，但仍然越烤越冷。"
			HIGH = "燃料加多了，但是没有关系。",		-- 物品名:"吸热火坑"->高 制造描述:"燃烧效率更高，但仍然越烤越冷。"
			LOW = "再加点燃料就好了。",		-- 物品名:"吸热火坑"->低？ 制造描述:"燃烧效率更高，但仍然越烤越冷。"
			NORMAL = "凉凉的像是亚得里亚海的海风。",		-- 物品名:"吸热火坑"->普通 制造描述:"燃烧效率更高，但仍然越烤越冷。"
			OUT = "至少我能让它再烧起来。",		-- 物品名:"吸热火坑"->出去？外面？ 制造描述:"燃烧效率更高，但仍然越烤越冷。"
		},
		FIRESTAFF = "红色的火焰权杖。",		-- 物品名:"火魔杖" 制造描述:"利用火焰的力量！"
		FIRESUPPRESSOR = 
		{	
			ON = "防范火焰的灾难",		-- 物品名:"雪球发射器"->开启 制造描述:"拯救植物，扑灭火焰，可添加燃料。"
			OFF = "平定下来了。",		-- 物品名:"雪球发射器"->关闭 制造描述:"拯救植物，扑灭火焰，可添加燃料。"
			LOWFUEL = "要加点燃料才行。",		-- 物品名:"雪球发射器"->燃料不足 制造描述:"拯救植物，扑灭火焰，可添加燃料。"
		},
		FISH = "鱼的做法可太多了。",		-- 物品名:"鱼"
		FISHINGROD = "钓鱼是不错的消遣。",		-- 物品名:"钓竿" 制造描述:"去钓鱼。为了鱼。"
		FISHSTICKS = "英国佬的食物依然如此可悲。",		-- 物品名:"炸鱼排"
		FISHTACOS = "我做的话会比这个更美味。",		-- 物品名:"鱼肉玉米卷"
		FISH_COOKED = "可以撒上一些茴香。",		-- 物品名:"烤鱼"
		FLINT = "有很多用途的尖锐石头。",		-- 物品名:"燧石"
		FLOWER = 
		{
            GENERIC = "美丽的花儿。",		-- 物品名:"花"->默认
            ROSE = "美丽，优雅。",		-- 物品名:"花"->玫瑰
        },
        FLOWER_WITHERED = "我觉得它还没晒够太阳呢。",		-- 物品名:"枯萎的花"
		FLOWERHAT = "如果用橄榄枝串起来就更好了。",		-- 物品名:"花环" 制造描述:"放松神经的东西。"
		FLOWER_EVIL = "我本能的排斥这种花朵。",		-- 物品名:"邪恶花"
		FOLIAGE = "一种多叶蕨类植物。",		-- 物品名:"蕨叶"
		FOOTBALLHAT = "也就是美国佬和英国佬会玩这种野蛮人的运动。",		-- 物品名:"橄榄球头盔" 制造描述:"保护你的脑壳。"
        FOSSIL_PIECE = "满载着历史的厚重。",		-- 物品名:"化石碎片"
        FOSSIL_STALKER =
        {
			GENERIC = "还有些碎片没找到。",		-- 物品名:"奇异的骨架"->默认
			FUNNY = "它缺少艺术所必须的协调性。",		-- 物品名:"奇异的骨架"->趣味？？
			COMPLETE = "可以给骨架点缀灵魂了。",		-- 物品名:"奇异的骨架"->准备好了
        },
        STALKER = "它在融合成为一个能量体。",		-- 物品名:"复活的骨架"
        STALKER_ATRIUM = "它有些像西西里神话里的生物。",		-- 物品名:"远古织影者"
        STALKER_MINION = "爬虫依然让我反感。",		-- 物品名:"编织暗影"
        THURIBLE = "闻起来好奇怪。",		-- 物品名:"暗影香炉"
        ATRIUM_OVERGROWTH = "我并不能解读上面的语言。",		-- 物品名:"远古方尖碑"
		FROG =
		{
			DEAD = "它死了。",		-- 物品名:"青蛙"->死了
			GENERIC = "我无法评价这种生物。",		-- 物品名:"青蛙"->默认
			SLEEPING = "睡着的青蛙。",		-- 物品名:"青蛙"->睡着了
		},
		FROGGLEBUNWICH = "我对法国菜不置可否。",		-- 物品名:"蛙腿三明治"
		FROGLEGS = "奥斯塔那边倒是有吃这个的。",		-- 物品名:"蛙腿"
		FROGLEGS_COOKED = "味道还是可以的。",		-- 物品名:"烤蛙腿"
		FRUITMEDLEY = "累的时候来一杯，解暑降温。",		-- 物品名:"水果圣代"
		FURTUFT = "黑白色的动物毛皮。", 		-- 物品名:"毛丛"
		GEARS = "一大堆机械零件。",		-- 物品名:"齿轮"
		GHOST = "幽灵居然是存在的吗。",		-- 物品名:"幽灵"
		GOLDENAXE = "用黄金做的斧子。",		-- 物品名:"黄金斧头" 制造描述:"砍树也要有格调！"
		GOLDENPICKAXE = "黄金的硬度真的能够砸碎石头吗。",		-- 物品名:"黄金鹤嘴锄" 制造描述:"像大Boss一样砸碎岩石。"
		GOLDENPITCHFORK = "一把叉子我都能做的这么精美？",		-- 物品名:"黄金干草叉" 制造描述:"重新布置整个世界。"
		GOLDENSHOVEL = "总感觉有些浪费。",		-- 物品名:"黄金铲子" 制造描述:"挖掘作用相同，但使用寿命更长。"
		GOLDNUGGET = "黄金是战争时期的硬通货。",		-- 物品名:"金块"
		GRASS =
		{
			BARREN = "它需要肥料。",		-- 物品名:"草"
			WITHERED = "夏天又热又缺少降水。",		-- 物品名:"草"->枯萎了
			BURNING = "要想办法灭火。",		-- 物品名:"草"->正在燃烧
			GENERIC = "是一丛草。",		-- 物品名:"草"->默认
			PICKED = "需要时间来再长出来。",		-- 物品名:"草"->被采完了
			DISEASED = "它看上去很不舒服。",		-- 物品名:"草"->生病了
			DISEASING = "呃...有些地方不对劲。",		-- 物品名:"草"->正在生病？？
		},
		GRASSGEKKO = 
		{
			GENERIC = "这种蜥蜴尾巴上长有干草。",			-- 物品名:"草壁虎"->默认
			DISEASED = "它看上去真的很不舒服。",		-- 物品名:"草壁虎"->生病了
		},
		GREEN_CAP = "绿色蘑菇看上去不错。",		-- 物品名:"采摘的绿蘑菇"
		GREEN_CAP_COOKED = "还是配菜吃更好。",		-- 物品名:"烤绿蘑菇"
		GREEN_MUSHROOM =
		{
			GENERIC = "是蘑菇。",		-- 物品名:"绿蘑菇"->默认
			INGROUND = "还没到时间。",		-- 物品名:"绿蘑菇"->在地里面
			PICKED = "不知道它会不会长回来？",		-- 物品名:"绿蘑菇"->被采完了
		},
		GUNPOWDER = "威力巨大的烈性炸药。",		-- 物品名:"火药" 制造描述:"一把火药。"
		HAMBAT = "这个武器用起来感觉不错。",		-- 物品名:"火腿棒" 制造描述:"舍不得火腿套不着狼。"
		HAMMER = "可以敲掉很多东西。",		-- 物品名:"锤子" 制造描述:"敲碎各种东西。"
		HEALINGSALVE = "热的草木灰和腺体可以给伤口消毒。",		-- 物品名:"治疗药膏" 制造描述:"对割伤和擦伤进行消毒杀菌。"
		HEATROCK =
		{
			FROZEN = "可以记录温度的石头。",		-- 物品名:"暖石"->冰冻 制造描述:"储存热能供旅行途中使用。"
			COLD = "冰凉舒适。",		-- 物品名:"冻伤"->冷了
			GENERIC = "可以改变它的温度。",		-- 物品名:"暖石"->默认 制造描述:"储存热能供旅行途中使用。"
			WARM = "呼呼呼，好暖和。",		-- 物品名:"暖石"->温暖 制造描述:"储存热能供旅行途中使用。"
			HOT = "还有些烫手。",		-- 物品名:"中暑"->热了
		},
		HOME = "有人住在这里。",		-- 物品名:"暖石"->没调用 制造描述:"储存热能供旅行途中使用。"
		HOMESIGN =
		{
			GENERIC = "港区是我们的家。",		-- 物品名:"路牌"->默认 制造描述:"在世界中留下你的标记。"
            UNWRITTEN = "那让我来写上字吧。",		-- 物品名:"路牌"->没有写字 制造描述:"在世界中留下你的标记。"
			BURNT = "注意防火",		-- 物品名:"路牌"->烧焦的 制造描述:"在世界中留下你的标记。"
		},
		ARROWSIGN_POST =
		{
			GENERIC = "它说“那个方向”。",		-- 物品名:"指路标志"->默认 制造描述:"对这个世界指指点点。或许只是打下手势。"
            UNWRITTEN = "这块牌子现在是空白的。",		-- 物品名:"指路标志"->没有写字 制造描述:"对这个世界指指点点。或许只是打下手势。"
			BURNT = "注意防火",		-- 物品名:"指路标志"->烧焦的 制造描述:"对这个世界指指点点。或许只是打下手势。"
		},
		ARROWSIGN_PANEL =
		{
			GENERIC = "它说“那个方向”。",		-- 物品名:"指路标志"->默认
            UNWRITTEN = "这块牌子现在是空白的。",		-- 物品名:"指路标志"->没有写字
			BURNT = "“注意防火。”",		-- 物品名:"指路标志"->烧焦的
		},
		HONEY = "甜味让人陶醉。",		-- 物品名:"蜂蜜"
		HONEYCOMB = "蜜蜂的劳动结果。",		-- 物品名:"蜂巢"
		HONEYHAM = "蜂蜜增加了肉的风味，还起到保险的作用。",		-- 物品名:"蜜汁火腿"
		HONEYNUGGETS = "绵软鲜甜的小口肉。",		-- 物品名:"蜜汁卤肉"
		HORN = "可以吹奏号角。",		-- 物品名:"牛角"
		HOUND = "这种品种的狗让人无法喜欢。",		-- 物品名:"猎犬"
		HOUNDCORPSE =
		{
			GENERIC = "浑身上下都让人无法喜欢。",		-- 物品名:"猎犬"->默认
			BURNING = "需要跟进观察。",		-- 物品名:"猎犬"->正在燃烧
			REVIVING = "我的挑战者吗。",		-- 物品名:"猎犬"
		},
		HOUNDBONE = "有些吓人。",		-- 物品名:"犬骨"
		HOUNDMOUND = "那些狗也就只能住在这种缺少艺术感的巢穴中。",		-- 物品名:"猎犬丘"
		ICEBOX = "为美食提供生命。",		-- 物品名:"冰箱" 制造描述:"延缓食物变质。"
		ICEHAT = "把这个带在头上显得有点傻。",		-- 物品名:"冰帽" 制造描述:"用科学技术合成的冰帽。"
		ICEHOUND = "冬天的猎犬吗？",		-- 物品名:"蓝色猎犬"
		INSANITYROCK =
		{
			ACTIVE = "能从塔兰托直达亚历山大吗。",		-- 物品名:"方尖碑"->激活了
			INACTIVE = "它更像一座金字塔。",		-- 物品名:"方尖碑"->没有激活
		},
		JAMMYPRESERVES = "可以浇在卷饼上。",		-- 物品名:"果酱"
		KABOBS = "肉串作为小吃偶尔可以吃一下，不可以多吃。",		-- 物品名:"肉串"
		KILLERBEE =
		{
			GENERIC = "杀人蜂和航母的舰载机一样令人反感。",		-- 物品名:"杀人蜂"->默认
			HELD = "这东西很危险。",		-- 物品名:"杀人蜂"->拿在手里
		},
		KNIGHT = "胸甲骑士只剩下马了。",		-- 物品名:"发条骑士"
		KOALEFANT_SUMMER = "狩猎的美味。",		-- 物品名:"考拉象"
		KOALEFANT_WINTER = "看上去更加暖和。",		-- 物品名:"考拉象"
		KRAMPUS = "这是一个小偷。",		-- 物品名:"坎普斯"
		KRAMPUS_SACK = "大容量背包。",		-- 物品名:"坎普斯背包"
		LEIF = "森林守护者想阻止我获取木材。",		-- 物品名:"树精守卫"
		LEIF_SPARSE = "森林守护者想阻止我获取木材。",		-- 物品名:"树精守卫"
		LIGHTER  = "漂亮的便携式打火机。",		-- 物品名:"薇洛的打火机" 制造描述:"火焰在雨中彻夜燃烧。"
		LIGHTNING_ROD =
		{
			CHARGED = "防火的同时也要防雷电！",		-- 物品名:"避雷针" 制造描述:"防雷劈。"
			GENERIC = "雷电也无法阻止我们的计划。",		-- 物品名:"避雷针"->默认 制造描述:"防雷劈。"
		},
		LIGHTNINGGOAT = 
		{
			GENERIC = "伏特教授用锌和银控制了电力。",		-- 物品名:"伏特羊"->默认
			CHARGED = "伏特教授并不支持生物电的假说。",		-- 物品名:"伏特羊"
		},
		LIGHTNINGGOATHORN = "需要皇家科学院的那些人去研究一下。",		-- 物品名:"伏特羊角"
		GOATMILK = "长官难道觉得我需要喝羊奶吗？",		-- 物品名:"带电的羊奶"
		LITTLE_WALRUS = "罗马小时候也是这么淘气。",		-- 物品名:"小海象"
		LIVINGLOG = "一种有生命的木头。",		-- 物品名:"活木头" 制造描述:"用你的身体来代替\n你该干的活吧。"
		LOG =
		{
			BURNING = "木头在燃烧，要想办法扑灭。",		-- 物品名:"木头"->正在燃烧
			GENERIC = "实用的木材。",		-- 物品名:"木头"->默认
		},
		LUCY = "好漂亮的斧子。",		-- 物品名:"露西斧"
		LUREPLANT = "这个花长得并不讨喜。",		-- 物品名:"食人花"
		LUREPLANTBULB = "我可以想办法把这个种下去。",		-- 物品名:"食人花种子"
		MALE_PUPPET = "他被困住了！",		-- 物品名:"木头"
		MANDRAKE_ACTIVE = "切断它！",		-- 物品名:"曼德拉草"
		MANDRAKE_PLANTED = "噗呼呼，它的故事怕不是起源于路易十六。",		-- 物品名:"曼德拉草"
		MANDRAKE = "曼德拉草的传说有不少。",		-- 物品名:"曼德拉草"
        MANDRAKESOUP = "可以放点盐来提鲜。",		-- 物品名:"曼德拉草汤"
        MANDRAKE_COOKED = "它看起来没有那么奇怪了。",		-- 物品名:"木头"
        MAPSCROLL = "需要笔来做图。",		-- 物品名:"地图卷轴" 制造描述:"向别人展示你看到什么！"
        MARBLE = "够坚硬的材料。",		-- 物品名:"大理石"
        MARBLEBEAN = "好像可以种下去。",		-- 物品名:"大理石豌豆" 制造描述:"种植一片大理石森林。"
        MARBLEBEAN_SAPLING = "看起来刻了点什么。",		-- 物品名:"大理石芽"
        MARBLESHRUB = "一种无机生命体。",		-- 物品名:"大理石灌木"
        MARBLEPILLAR = "可以算是石头艺术品。",		-- 物品名:"大理石柱"
        MARBLETREE = "斧子应该没有它坚硬。",		-- 物品名:"大理石树"
        MARSH_BUSH =
        {
			BURNT = "无论是在哪里还是要注意防火。",		-- 物品名:"尖刺灌木"->烧焦的
            BURNING = "烧得好快，尽快灭火！",		-- 物品名:"尖刺灌木"->正在燃烧
            GENERIC = "它看起来很多刺。",		-- 物品名:"尖刺灌木"->默认
            PICKED = "有人采摘了它。！",		-- 物品名:"尖刺灌木"->被采完了
        },
        BURNT_MARSH_BUSH = "无论是在哪里还是要注意防火。",		-- 物品名:"尖刺灌木"
        MARSH_PLANT = "这是一株不太需要水的植物。",		-- 物品名:"植物"
        MARSH_TREE =
        {
            BURNING = "准备灭火！",		-- 物品名:"针刺树"->正在燃烧
            BURNT = "现在它是一棵被烧焦了的针刺树。",		-- 物品名:"针刺树"->烧焦的
            CHOPPED = "它遭到了砍伐！",		-- 物品名:"针刺树"->被砍了
            GENERIC = "通过变成刺来减少水分的消耗！",		-- 物品名:"针刺树"->默认
        },
        MAXWELL = "我恨那个家伙。",		-- 物品名:"麦斯威尔"->单机 麦斯威尔
        MAXWELLHEAD = "我可以看到他毛孔里面的东西。",		-- 物品名:"麦斯威尔的头"->单机 麦斯威尔的头
        MAXWELLLIGHT = "我想知道它们是怎么工作的。",		-- 物品名:"麦斯威尔灯"->单机 麦斯威尔的灯
        MAXWELLLOCK = "看起来就像一个钥匙孔。",		-- 物品名:"梦魇锁"->单机 麦斯威尔的噩梦锁
        MAXWELLTHRONE = "那个看起来不太舒适。",		-- 物品名:"梦魇王座"->单机 麦斯威尔的噩梦王座
        MEAT = "肉总是好的。",		-- 物品名:"肉"
        MEATBALLS = "量多管饱。",		-- 物品名:"肉丸"
        MEATRACK =
        {
            DONE = "晒肉架做好了。",		-- 物品名:"晾肉架"->完成了 制造描述:"晾肉的架子。"
            DRYING = "需要耐心。",		-- 物品名:"晾肉架"->正在风干 制造描述:"晾肉的架子。"
            DRYINGINRAIN = "空气太潮湿了。",		-- 物品名:"晾肉架"->雨天风干 制造描述:"晾肉的架子。"
            GENERIC = "可以晾晒肉和海带。",		-- 物品名:"晾肉架"->默认 制造描述:"晾肉的架子。"
            BURNT = "需要重新再做一个了。",		-- 物品名:"晾肉架"->烧焦的 制造描述:"晾肉的架子。"
            DONE_NOTMEAT = "晒成的肉干味道更好也更便于储存。",		-- 物品名:"晾肉架" 制造描述:"晾肉的架子。"
            DRYING_NOTMEAT = "美味的烟熏风干肉。",		-- 物品名:"晾肉架" 制造描述:"晾肉的架子。"
            DRYINGINRAIN_NOTMEAT = "等晴天吧。",		-- 物品名:"晾肉架" 制造描述:"晾肉的架子。"
        },
        MEAT_DRIED = "便携式军粮。",		-- 物品名:"风干肉"
        MERM = "它身上一股沼泽的味道。",		-- 物品名:"鱼人"
        MERMHEAD =
        {
            GENERIC = "好难闻。",		-- 物品名:"鱼人头"->默认
            BURNT = "糊味和腥味的混合，令人不适。",		-- 物品名:"鱼人头"->烧焦的
        },
        MERMHOUSE =
        {
            GENERIC = "我另可不睡觉也不睡在这种地方。",		-- 物品名:"漏雨的小屋"->默认
            BURNT = "现在它没地方住下来了。",		-- 物品名:"漏雨的小屋"->烧焦的
        },
        MINERHAT = "头戴式便携光源。",		-- 物品名:"矿工帽" 制造描述:"用你脑袋上的灯照亮夜晚。"
        MONKEY = "好奇的灵长类动物。",		-- 物品名:"穴居猴"
        MONKEYBARREL = "猴子的家",		-- 物品名:"穴居猴桶"
        MONSTERLASAGNA = "和夏威夷馅饼一样糟糕。",		-- 物品名:"怪物千层饼"
        FLOWERSALAD = "晚餐吃沙拉就很合适。",		-- 物品名:"花沙拉"
        ICECREAM = " 它应该被称为Gelato。",		-- 物品名:"冰淇淋"
        WATERMELONICLE = "夏日小吃，味道真不错。",		-- 物品名:"西瓜冰棍"
        TRAILMIX = "绵和酥的混合口感，真不错。",		-- 物品名:"什锦干果"
        HOTCHILI = "长官喜欢的炖肉，利用蔬菜压制肉的腥味。",		-- 物品名:"辣椒炖肉"
        GUACAMOLE = "牛油果更像是一种营销手段，长官还一直想让我吃说是可以帮助发育（恼）。",		-- 物品名:"鳄梨酱"
        MONSTERMEAT = "呜，这种肉根本不能吃。",		-- 物品名:"怪物肉"
        MONSTERMEAT_DRIED = "即便晒成肉干，它的味道依然让人不适。",		-- 物品名:"怪物肉干"
        MOOSE = "这房子在漏雨。",		-- 物品名:"漏雨的小屋"
        MOOSE_NESTING_GROUND = "它把它的婴儿放在那里。",		-- 物品名:"漏雨的小屋"
        MOOSEEGG = "好大的蛋。",		-- 物品名:"卤鹅蛋"
        MOSSLING = "小鸭子还是有活力！",		-- 物品名:"麋鹿鹅幼崽"
        FEATHERFAN = "在夏日带来凉风。",		-- 物品名:"羽毛扇" 制造描述:"超柔软、超大的扇子。"
        MINIFAN = "跑起来就有风了。",		-- 物品名:"旋转的风扇" 制造描述:"你得跑起来，才能带来风！"
        GOOSE_FEATHER = "毛茸茸的羽毛！",		-- 物品名:"麋鹿鹅羽毛"
        STAFF_TORNADO = "可以用这个来控制暴风天气。",		-- 物品名:"天气风向标" 制造描述:"把你的敌人吹走。"
        MOSQUITO =
        {
            GENERIC = "天上的蚊子无论何时都令人讨厌。",		-- 物品名:"蚊子"->默认
            HELD = "我想干掉它。",		-- 物品名:"蚊子"->拿在手里
        },
        MOSQUITOSACK = "又有人被蚊子伤害了。",		-- 物品名:"蚊子血囊"
        MOUND =
        {
            DUG = "请安息吧。",		-- 物品名:"坟墓"->被挖了
            GENERIC = "有人在这里安眠！",		-- 物品名:"坟墓"->默认
        },
        NIGHTLIGHT = "噩梦比夜晚更加恐怖。",		-- 物品名:"魂灯" 制造描述:"用你的噩梦点亮夜晚。"
        NIGHTMAREFUEL = "不到万不得已我并不想用这种燃料。",		-- 物品名:"噩梦燃料" 制造描述:"傻子和疯子使用的邪恶残渣。"
        NIGHTSWORD = "黑暗与噩梦的力量。",		-- 物品名:"暗夜剑" 制造描述:"造成噩梦般的伤害。"
        NITRE = "无论是做肥料还是炸药，硝石资源都很宝贵。",		-- 物品名:"硝石"
        ONEMANBAND = "我更喜欢交响乐。",		-- 物品名:"独奏乐器" 制造描述:"疯子音乐家也有粉丝。"
        OASISLAKE =
		{
			GENERIC = "沙漠绿洲！",		-- 物品名:"湖泊"->默认
			EMPTY = "现在是旱季。",		-- 物品名:"湖泊"
		},
        PANDORASCHEST = "战胜敌人之后会获得战利品。",		-- 物品名:"华丽箱子"
        PANFLUTE = "它的特殊旋律让人入睡。",		-- 物品名:"排箫" 制造描述:"抚慰凶猛野兽的音乐。"
        PAPYRUS = "文明的传承。",		-- 物品名:"莎草纸" 制造描述:"用于书写。"
        WAXPAPER = "用于打包的蜡纸。",		-- 物品名:"蜡纸" 制造描述:"用于打包东西。"
        PENGUIN = "我没怎么见过企鹅。",		-- 物品名:"企鸥"
        PERD = "离我的浆果远点，该死的火鸡！",		-- 物品名:"火鸡"
        PEROGIES = "和Ravioli做法差不多。",		-- 物品名:"波兰水饺"
        PETALS = "它给我的手带来清香！",		-- 物品名:"花瓣"
        PETALS_EVIL = "我不想拿这个东西。",		-- 物品名:"恶魔花瓣"
        PHLEGM = "太恶心了。",		-- 物品名:"脓鼻涕"
        PICKAXE = "可以砸碎岩石的锄头。",		-- 物品名:"鹤嘴锄" 制造描述:"凿碎岩石。"
        PIGGYBACK = "容量不错的背包。",		-- 物品名:"小猪包" 制造描述:"能装许多东西，但会减慢你的速度。"
        PIGHEAD =
        {
            GENERIC = "像是一种祭祀用品。",		-- 物品名:"猪头"->默认
            BURNT = "并不好闻。",		-- 物品名:"猪头"->烧焦的
        },
        PIGHOUSE =
        {
            FULL = "里面住着一只猪。",		-- 物品名:"猪屋"->满了 制造描述:"可以住一只猪。"
            GENERIC = "它们的房子有一定的设计感。",		-- 物品名:"猪屋"->默认 制造描述:"可以住一只猪。"
            LIGHTSOUT = "猪休息了。",		-- 物品名:"猪屋"->关灯了 制造描述:"可以住一只猪。"
            BURNT = "有些可惜了。",		-- 物品名:"猪屋"->烧焦的 制造描述:"可以住一只猪。"
        },
        PIGKING = "这些猪的统帅！",		-- 物品名:"猪王"
        PIGMAN =
        {
            DEAD = "应该找人通知它的伙伴。",		-- 物品名:"猪人"->死了
            FOLLOWER = "利用这些猪我们可以开展计划。",		-- 物品名:"猪人"->追随者
            GENERIC = "他们有点吓人。",		-- 物品名:"猪人"->默认
            GUARD = "他看起来很不友善。",		-- 物品名:"猪人"->警戒
            WEREPIG = "这头猪失去了理智。",		-- 物品名:"猪人"->疯猪
        },
        PIGSKIN = "一块韧性十足的猪皮。",		-- 物品名:"猪皮"
        PIGTENT = "它似乎并不在意自己的清洁。",		-- 物品名:"猪人"
        PIGTORCH = "需要有人点燃火炬。",		-- 物品名:"猪火炬"
        PINECONE = "种下去便可收获一片树林。",		-- 物品名:"松果"
        PINECONE_SAPLING = "它很快将长成一棵大树！",		-- 物品名:"常青树苗"
        LUMPY_SAPLING = "这棵树是怎么繁殖的？",		-- 物品名:"有疙瘩的树苗"
        PITCHFORK = "可以改变地皮。",		-- 物品名:"干草叉" 制造描述:"铲地用具。"
        PLANTMEAT = "看上去更像是植物而非肉类。",		-- 物品名:"叶肉"
        PLANTMEAT_COOKED = "勉强可以入口。",		-- 物品名:"烤叶肉"
        PLANT_NORMAL =
        {
            GENERIC = "我的作物。",		-- 物品名:"农作物"->默认
            GROWING = "它在汲取营养。",		-- 物品名:"农作物"->正在生长
            READY = "所有的耐心收到了回报。",		-- 物品名:"农作物"->准备好的 满的
            WITHERED = "它枯萎了。",		-- 物品名:"农作物"->枯萎了
        },
        POMEGRANATE = "石榴是很好的开胃水果。",		-- 物品名:"石榴"
        POMEGRANATE_COOKED = "可以做很多美食。",		-- 物品名:"切片熟石榴"
        POMEGRANATE_SEEDS = "石榴种子。",		-- 物品名:"风刮来的种子"
        POND = "好深的池塘，里面应该有不少鱼。",		-- 物品名:"池塘"
        POOP = "虽然味道不好，但是可以做肥料。",		-- 物品名:"粪肥"
        FERTILIZER = "高效施肥的设备。",		-- 物品名:"便便桶" 制造描述:"少拉点在手上，多拉点在庄稼上。"
        PUMPKIN = "好大的南瓜啊。",		-- 物品名:"南瓜"
        PUMPKINCOOKIE = "酥脆美味的饼干！",		-- 物品名:"南瓜饼干"
        PUMPKIN_COOKED = "可以放很多蔬菜和肉豆蔻。",		-- 物品名:"烤南瓜"
        PUMPKIN_LANTERN = "庞贝喜欢做这个。",		-- 物品名:"南瓜灯" 制造描述:"长着鬼脸的照明用具。"
        PUMPKIN_SEEDS = "南瓜种子。",		-- 物品名:"尖种子"
        PURPLEAMULET = "噩梦的来源，并不让人舒服。",		-- 物品名:"梦魇护符" 制造描述:"引起精神错乱。"
        PURPLEGEM = "这种宝石似乎蕴藏了什么，希望能够换一些资源。",		-- 物品名:"紫宝石" 制造描述:"结合你们的颜色！"
        RABBIT =
        {
            GENERIC = "兔子其实不怎么吃胡萝卜。",		-- 物品名:"兔子"->默认
            HELD = "兔子也可以用于烹饪。",		-- 物品名:"兔子"->拿在手里
        },
        RABBITHOLE =
        {
            GENERIC = "兔子的家有很多。",		-- 物品名:"兔洞"->默认
            SPRING = "它的家被雨水毁掉了。",		-- 物品名:"兔洞"->春天 or 潮湿
        },
        RAINOMETER =
        {
            GENERIC = "我对自己的适航性很有自信。",		-- 物品名:"雨量计"->默认 制造描述:"观测降雨机率。"
            BURNT = "无法得到合适的情报了。",		-- 物品名:"雨量计"->烧焦的 制造描述:"观测降雨机率。"
        },
  RAINCOAT = "雨水无法透过我的雨衣。",
		RAINHAT = "希望能够改良一下雨帽的设计。",
		RATATOUILLE = "对火候的把握是做出美味炖菜的关键。",
		RAZOR = "长官的刮胡刀。",
		REDGEM = "红色的宝石，应该可以换些油料。",
		RED_CAP = "看起来就知道有毒的红蘑菇。",
		RED_CAP_COOKED = "煮了还是有毒……",
        RED_MUSHROOM =
        {
            GENERIC = "是蘑菇。",		-- 物品名:"红蘑菇"->默认
            INGROUND = "不在合适的时间。",		-- 物品名:"红蘑菇"->在地里面
            PICKED = "不知道它会不会长回来？",		-- 物品名:"红蘑菇"->被采完了
        },
        REEDS =
        {
            BURNING = "需要灭火！",		-- 物品名:"芦苇"->正在燃烧
            GENERIC = "造纸和很多东西要用的原料。",		-- 物品名:"芦苇"->默认
            PICKED = "芦苇被我收集完了。",		-- 物品名:"芦苇"->被采完了
        },
        RELIC = "远古家居用品。",		-- 物品名:"废墟"
        RUINS_RUBBLE = "我可以修复。",		-- 物品名:"损毁的废墟"
        RUBBLE = "只是些碎石块。",		-- 物品名:"碎石"
        RESEARCHLAB =
        {
            GENERIC = "需要成立意大利皇家科学院。",		-- 物品名:"科学机器"->默认 制造描述:"解锁新的合成配方！"
            BURNT = "现在做不了科学研究了。",		-- 物品名:"科学机器"->烧焦的 制造描述:"解锁新的合成配方！"
        },
        RESEARCHLAB2 =
        {
            GENERIC = "和维维亚尼一样成立科学机构。",		-- 物品名:"炼金引擎"->默认 制造描述:"解锁更多合成配方！"
            BURNT = "火焰是文明和科学的吞噬者。",		-- 物品名:"炼金引擎"->烧焦的 制造描述:"解锁更多合成配方！"
        },
        RESEARCHLAB3 =
        {
            GENERIC = "似乎是全新的事物，尤里卡？",		-- 物品名:"暗影操控器"->默认 制造描述:"这还是科学吗？"
            BURNT = "被火烧掉的装置。",		-- 物品名:"暗影操控器"->烧焦的 制造描述:"这还是科学吗？"
        },
        RESEARCHLAB4 =
        {
            GENERIC = "兔子和高礼帽做这个东西？。",		-- 物品名:"灵子分解器"->默认 制造描述:"增强高礼帽的魔力。"
            BURNT = "新时代的布鲁诺吗。",		-- 物品名:"灵子分解器"->烧焦的 制造描述:"增强高礼帽的魔力。"
        },
        RESURRECTIONSTATUE =
        {
            GENERIC = "我很难理解它的原理！",		-- 物品名:"肉块雕像"->默认 制造描述:"以肉的力量让你重生。"
            BURNT = "没有用了。",		-- 物品名:"肉块雕像"->烧焦的 制造描述:"以肉的力量让你重生。"
        },
        RESURRECTIONSTONE = "似乎能够给我们再一次机会。",		-- 物品名:"试金石"
        ROBIN =
        {
            GENERIC = "再见吧寒冬，春天就要到了。",		-- 物品名:"红雀"->默认
            HELD = "我的口袋还是很舒适的。",		-- 物品名:"红雀"->拿在手里
        },
        ROBIN_WINTER =
        {
            GENERIC = "来自北大西洋的生灵。",		-- 物品名:"雪雀"->默认
            HELD = "温暖的小生命。",		-- 物品名:"雪雀"->拿在手里
        },
        ROBOT_PUPPET = "它被困住了！",		-- 物品名:"机器人傀儡"
        ROCK_LIGHT =
        {
            GENERIC = "裹了石皮的熔岩坑。",		-- 物品名:"熔岩坑"->默认
            OUT = "看起来很易碎。",		-- 物品名:"熔岩坑"->出去？外面？
            LOW = "那块熔岩正在裹上石皮。",		-- 物品名:"熔岩坑"->低？
            NORMAL = "真舒服。",		-- 物品名:"熔岩坑"->普通
        },
        CAVEIN_BOULDER =
        {
            GENERIC = "我觉得我可以举起这个。",		-- 物品名:"岩石"->默认
            RAISED = "太远了够不着。",		-- 物品名:"岩石"->提高了？
        },
        ROCK = "沉甸甸的石头。",		-- 物品名:"岩石"
        PETRIFIED_TREE = "它失去了生机。",		-- 物品名:"岩石"
        ROCK_PETRIFIED_TREE = "美杜莎的故事吗。",		-- 物品名:"石化树"
        ROCK_PETRIFIED_TREE_OLD = "这里可没有美杜莎。",		-- 物品名:"岩石"
        ROCK_ICE =
        {
            GENERIC = "地中海上倒是没有冰山。",		-- 物品名:"迷你冰川"->默认
            MELTED = "等待它再次结冰。",		-- 物品名:"迷你冰川"->融化了
        },
        ROCK_ICE_MELTED = "现在还能开采一部分。",		-- 物品名:"融化的迷你冰川"
        ICE = "冰的用途有很多。",		-- 物品名:"冰"
        ROCKS = "沉甸甸的石头。",		-- 物品名:"石头"
        ROOK = "横冲直撞。",		-- 物品名:"发条战车"
        ROPE = "草绳。",		-- 物品名:"绳子" 制造描述:"紧密编成的草绳，非常有用。"
        ROTTENEGG = "呕！我受不了这味道好难闻！",		-- 物品名:"腐烂鸟蛋"
        ROYAL_JELLY = "比蜂蜜还要甜！",		-- 物品名:"蜂王浆"
        JELLYBEAN = "我喜欢糖豆！",		-- 物品名:"彩虹糖豆"
        SADDLE_BASIC = "有了它就可以骑牛了。",		-- 物品名:"鞍具" 制造描述:"你坐在动物身上。仅仅是理论上。"
        SADDLE_RACE = "这鞍具能够提供十足的机动性！",		-- 物品名:"闪亮鞍具" 制造描述:"抵消掉完成目标所花费的时间。或许。"
        SADDLE_WAR = "罗马统帅！可惜骑的并不是牛。",		-- 物品名:"战争鞍具" 制造描述:"战场首领的王位。"
        SADDLEHORN = "这能够卸下鞍具。",		-- 物品名:"鞍角" 制造描述:"把鞍具撬开。"
        SALTLICK = "暂时能让动物留在这里。",		-- 物品名:"舔盐块" 制造描述:"好好喂养你家的牲畜。"
        BRUSH = "能够梳理皮弗娄牛的毛。",		-- 物品名:"刷子" 制造描述:"减缓皮弗娄牛毛发的生长速度。"
		SANITYROCK =
		{
			ACTIVE = "那石头看起来有点意思。",		-- 物品名:"方尖碑"->激活了
			INACTIVE = "它的其余部分藏于地下。",		-- 物品名:"方尖碑"->没有激活
		},
		SAPLING =
		{
			BURNING = "需要赶紧灭火。",		-- 物品名:"树苗"->正在燃烧
			WITHERED = "如果能给它降温浇水，也许它能好起来。",		-- 物品名:"树苗"->枯萎了
			GENERIC = "小树苗真可爱！",		-- 物品名:"树苗"->默认
			PICKED = "要等一段时间才好。",		-- 物品名:"树苗"->被采完了
			DISEASED = "它看上去很不舒服。",		-- 物品名:"树苗"->生病了
			DISEASING = "呃...有些地方不对劲。",		-- 物品名:"树苗"->正在生病？？
		},
   		SCARECROW = 
   		{
			GENERIC = "稻草人能够吓跑乌鸦，吸引金丝雀。",		-- 物品名:"友善的稻草人"->默认 制造描述:"模仿最新的秋季时尚。"
			BURNING = "要赶紧灭火不然会烧到农田的。",		-- 物品名:"友善的稻草人"->正在燃烧 制造描述:"模仿最新的秋季时尚。"
			BURNT = "农田防火措施需要提上议程了。",		-- 物品名:"友善的稻草人"->烧焦的 制造描述:"模仿最新的秋季时尚。"
   		},
   		SCULPTINGTABLE=
   		{
			EMPTY = "开始学习米开朗琪罗的艺术。",		-- 物品名:"陶轮" 制造描述:"大理石在你手里将像黏土一样！"
			BLOCK = "准备雕刻。",		-- 物品名:"陶轮"->锁住了 制造描述:"大理石在你手里将像黏土一样！"
			SCULPTURE = "一个杰作！",		-- 物品名:"陶轮"->雕像做好了 制造描述:"大理石在你手里将像黏土一样！"
			BURNT = "完全烧焦。",		-- 物品名:"陶轮"->烧焦的 制造描述:"大理石在你手里将像黏土一样！"
   		},
        SCULPTURE_KNIGHTHEAD = "它似乎是从什么东西上掉下来的。",		-- 物品名:"可疑的大理石"
		SCULPTURE_KNIGHTBODY = 
		{
			COVERED = "是一个古怪的大理石雕像。",		-- 物品名:"大理石雕像"->被盖住了-三基佬雕像可以敲大理石的时候
			UNCOVERED = "它需要被开采。",		-- 物品名:"大理石雕像"->没有被盖住-三基佬雕像被开采后
			FINISHED = "终于又弄到一起了。",		-- 物品名:"大理石雕像"->三基佬雕像修好了
			READY = "里面有东西在动。",		-- 物品名:"大理石雕像"->准备好的 满的
		},
        SCULPTURE_BISHOPHEAD = "那是一颗头吗？",		-- 物品名:"可疑的大理石"
		SCULPTURE_BISHOPBODY = 
		{
			COVERED = "需要敲一敲看一看。",		-- 物品名:"大理石雕像"->被盖住了-三基佬雕像可以敲大理石的时候
			UNCOVERED = "有一个大的碎片没找到。",		-- 物品名:"大理石雕像"->没有被盖住-三基佬雕像被开采后
			FINISHED = "然后呢？",		-- 物品名:"大理石雕像"->三基佬雕像修好了
			READY = "里面有东西在动。",		-- 物品名:"大理石雕像"->准备好的 满的
		},
        SCULPTURE_ROOKNOSE = "这是哪儿来的？",		-- 物品名:"可疑的大理石"
		SCULPTURE_ROOKBODY = 
		{
			COVERED = "一种大理石雕像。",		-- 物品名:"大理石雕像"->被盖住了-三基佬雕像可以敲大理石的时候
			UNCOVERED = "里面似乎才是关键。",		-- 物品名:"大理石雕像"->没有被盖住-三基佬雕像被开采后
			FINISHED = "所有都修补好了。",		-- 物品名:"大理石雕像"->三基佬雕像修好了
			READY = "里面有东西在动。",		-- 物品名:"大理石雕像"->准备好的 满的
		},
        GARGOYLE_HOUND = "一种矿物岩石。",		-- 物品名:"可疑的月岩"
        GARGOYLE_WEREPIG = "它看起来栩栩如生。",		-- 物品名:"可疑的月岩"
		SEEDS = "他可能长成又大又多汁的番茄。",		-- 物品名:"种子"
		SEEDS_COOKED = "凑合当零食吃！",		-- 物品名:"烤种子"
		SEWING_KIT = "优秀的服装师同样擅长修补。",		-- 物品名:"针线包" 制造描述:"缝补受损的衣物。"
		SEWING_TAPE = "多用途胶带。",		-- 物品名:"可靠的胶布" 制造描述:"缝补受损的衣物。"
		SHOVEL = "可以挖掘底下的秘密。",		-- 物品名:"铲子" 制造描述:"挖掘各种各样的东西。"
		SILK = "蜘蛛丝的用途就很多了。",		-- 物品名:"蜘蛛丝"
		SKELETON = "请安息吧。",		-- 物品名:"骷髅"
		SCORCHED_SKELETON = "真可怕。",		-- 物品名:"易碎骨骼"
		SKULLCHEST = "不确定要不要打开。",		-- 物品名:"骷髅箱"
		SMALLBIRD =
		{
			GENERIC = "好小的一只鸟。",		-- 物品名:"小鸟"->默认
			HUNGRY = "它看起来饿了。",		-- 物品名:"小鸟"->有点饿了
			STARVING = "它一定很饿。",		-- 物品名:"小鸟"->挨饿
			SLEEPING = "它都不偷偷睁眼看一下。",		-- 物品名:"小鸟"->睡着了
		},
		SMALLMEAT = "一小块动物肉。",		-- 物品名:"小肉"
		SMALLMEAT_DRIED = "一小块肉干。",		-- 物品名:"小风干肉"
		SPAT = "波河平原上的羊比它温顺也可爱的多。",		-- 物品名:"钢羊"
		SPEAR = "好尖的一根棍子。",		-- 物品名:"长矛" 制造描述:"使用尖的那一端。"
		SPEAR_WATHGRITHR = "来自北欧的战斗武器。",		-- 物品名:"战斗长矛" 制造描述:"黄金使它更锋利。"
		WATHGRITHRHAT = "罗马人曾经统治过维京人。",		-- 物品名:"战斗头盔" 制造描述:"独角兽是你的保护神。"
		SPIDER =
		{
			DEAD = "恶心！",		-- 物品名:"蜘蛛"->死了
			GENERIC = "我讨厌蜘蛛。",		-- 物品名:"蜘蛛"->默认
			SLEEPING = "我想在它睡着的时候解决它。",		-- 物品名:"蜘蛛"->睡着了
		},
		SPIDERDEN = "蜘蛛的巢穴。",		-- 物品名:"蜘蛛巢"
		SPIDEREGGSACK = "我想找地方扔掉这些蜘蛛卵。",		-- 物品名:"蜘蛛卵" 制造描述:"跟你的朋友寻求点帮助。"
		SPIDERGLAND = "能够治疗我的伤口。",		-- 物品名:"蜘蛛腺"
		SPIDERHAT = "我不想带着这个东西。",		-- 物品名:"蜘蛛帽" 制造描述:"蜘蛛们会喊你\"妈妈\"。"
		SPIDERQUEEN = "我觉得它不配被称为女王。",		-- 物品名:"蜘蛛女王"
		SPIDER_WARRIOR =
		{
			DEAD = "终于摆脱了！",		-- 物品名:"蜘蛛战士"->死了
			GENERIC = "看起来比平常的蜘蛛更好战。",		-- 物品名:"蜘蛛战士"->默认
			SLEEPING = "我应当保持距离。",		-- 物品名:"蜘蛛战士"->睡着了
		},
		SPOILED_FOOD = "腐烂物应该还有别的用途。",		-- 物品名:"腐烂物"
        STAGEHAND =
        {
			AWAKE = "我觉得它是在玷污舞台。",		-- 物品名:"舞台之手"->醒了
			HIDING = "我感受到了恶意。",		-- 物品名:"舞台之手"->藏起来了
        },
        STATUE_MARBLE = 
        {
            GENERIC = "高级的大理石雕像。",		-- 物品名:"大理石雕像"->默认
            TYPE1 = "不要失去理智！",		-- 物品名:"大理石雕像"->类型1
            TYPE2 = "大卫！",		-- 物品名:"大理石雕像"->类型2
            TYPE3 = "我想知道是哪个艺术家的作品。", --bird bath type statue		-- 物品名:"大理石雕像"
        },
		STATUEHARP = "他的头怎么了？",		-- 物品名:"竖琴雕像"
		STATUEMAXWELL = "他本人还要矮一点。",		-- 物品名:"麦斯威尔雕像"
		STEELWOOL = "质地坚硬的毛团。",		-- 物品名:"钢丝绵"
		STINGER = "尖锐的麻醉用药。",		-- 物品名:"蜂刺"
		STRAWHAT = "这狗草帽并不符合我的身份。",		-- 物品名:"草帽" 制造描述:"帮助你保持清凉干爽。"
		STUFFEDEGGPLANT = "将蔬菜放入掏空的茄子种蒸熟，味道好极了。",		-- 物品名:"酿茄子"
		SWEATERVEST = "这件背心的花纹确实有精心设计过。",		-- 物品名:"犬牙背心" 制造描述:"粗糙，但挺时尚。"
		REFLECTIVEVEST = "清凉透气的衣服！",		-- 物品名:"清凉夏装" 制造描述:"穿上这件时尚的背心，让你神清气爽。"
		HAWAIIANSHIRT = "因为食物我对夏威夷没有什么好感。",		-- 物品名:"花衬衫" 制造描述:"适合夏日穿着，或在周五便装日穿着。"
		TAFFY = "甜食要给罗马留一些。",		-- 物品名:"太妃糖"
		TALLBIRD = "这个高鸟似乎有很大的敌意。",		-- 物品名:"高脚鸟"
		TALLBIRDEGG = "它会孵化吗？",		-- 物品名:"高脚鸟蛋"
		TALLBIRDEGG_COOKED = "用初榨橄榄油风味更佳。",		-- 物品名:"煎高脚鸟蛋"
		TALLBIRDEGG_CRACKED =
		{
			COLD = "是它在哆嗦还是我在哆嗦？",		-- 物品名:"冻伤"->冷了
			GENERIC = "看起来它正在孵化！",		-- 物品名:"孵化中的高脚鸟蛋"->默认
			HOT = "它似乎有点热。",		-- 物品名:"中暑"->热了
			LONG = "我感觉这需要一些时间...",		-- 物品名:"孵化中的高脚鸟蛋"->还需要很久
			SHORT = "它我觉得现在随时要孵出来了。",		-- 物品名:"孵化中的高脚鸟蛋"->很快了
		},
		TALLBIRDNEST =
		{
			GENERIC = "鸟蛋会孵化吗。",		-- 物品名:"高脚鸟巢"->默认
			PICKED = "她的鸟蛋被拿走了。",		-- 物品名:"高脚鸟巢"->被采完了
		},
		TEENBIRD =
		{
			GENERIC = "不是很高的鸟。",		-- 物品名:"小高脚鸟"->默认
			HUNGRY = "你想吃东西想的不行了？",		-- 物品名:"小高脚鸟"->有点饿了
			STARVING = "它好像饿了。",		-- 物品名:"小高脚鸟"->挨饿
			SLEEPING = "它在眯眼休息。",		-- 物品名:"小高脚鸟"->睡着了
		},
		TELEPORTATO_BASE =
		{
			ACTIVE = "有了这个，我肯定可以穿越时空！",		-- 物品名:"木制传送台"->激活了
			GENERIC = "这好像可以通往另一个世界！",		-- 物品名:"木制传送台"->默认
			LOCKED = "还少了些什么东西。",		-- 物品名:"木制传送台"->锁住了
			PARTIAL = "很快，这个发明就要大功告成！",		-- 物品名:"木制传送台"->已经有部分了
		},
		TELEPORTATO_BOX = "这可能控制着整个宇宙的极性。",		-- 物品名:"盒状零件"
		TELEPORTATO_CRANK = "结实到足以应付最危险的实验。",		-- 物品名:"曲柄零件"
		TELEPORTATO_POTATO = "这个金属土豆包含强大而又可怕的力量...",		-- 物品名:"金属土豆状零件"
		TELEPORTATO_RING = "一个可以聚集空间能量的圆环。",		-- 物品名:"环状零件"
		TELESTAFF = "能够进行大范围的战略转移。",		-- 物品名:"传送魔杖" 制造描述:"穿越空间的法杖！时间要另外收费。"
		TENT = 
		{
			GENERIC = "野外露宿并不足够优雅。",		-- 物品名:"帐篷"->默认 制造描述:"回复理智值，但要花费时间并导致饥饿。"
			BURNT = "现在也无法休息了。",		-- 物品名:"帐篷"->烧焦的 制造描述:"回复理智值，但要花费时间并导致饥饿。"
		},
		SIESTAHUT = 
		{
			GENERIC = "中午是工作的时间，不能犯懒。",		-- 物品名:"遮阳篷"->默认 制造描述:"躲避烈日，回复理智值。"
			BURNT = "我觉得现在遮不了多少阳了。",		-- 物品名:"遮阳篷"->烧焦的 制造描述:"躲避烈日，回复理智值。"
		},
		TENTACLE = "这个生物危险而恐怖。",		-- 物品名:"触手"
		TENTACLESPIKE = "它如此尖锐。",		-- 物品名:"触手尖刺"
		TENTACLESPOTS = "触手皮似乎可以防水。",		-- 物品名:"触手皮"
		TENTACLE_PILLAR = "这触手很大。",		-- 物品名:"大触手"
        TENTACLE_PILLAR_HOLE = "它连通着另一个地方。",		-- 物品名:"硕大的泥坑"
		TENTACLE_PILLAR_ARM = "滑溜溜的小触手。",		-- 物品名:"小触手"
		TENTACLE_GARDEN = "一种黏滑的触手。",		-- 物品名:"大触手"
		TOPHAT = "符合我审美的艺术与地位的结合。",		-- 物品名:"高礼帽" 制造描述:"最经典的帽子款式。"
		TORCH = "黑暗中的光。",		-- 物品名:"火炬" 制造描述:"可携带的光源。"
		TRANSISTOR = "科学的基础。",		-- 物品名:"电子元件" 制造描述:"科学至上！滋滋滋！"
		TRAP = "紧密的捕捉小动物的陷阱。",		-- 物品名:"陷阱" 制造描述:"捕捉小型生物。"
		TRAP_TEETH = "可以咬伤其他生物的陷阱。",		-- 物品名:"犬牙陷阱" 制造描述:"弹出来并咬伤任何踩到它的东西。"
		TRAP_TEETH_MAXWELL = "我可不想踩在那上面！",		-- 物品名:"麦斯威尔的犬牙陷阱" 制造描述:"弹出来并咬伤任何踩到它的东西。"
		TREASURECHEST = 
		{
			GENERIC = "放东西的小木箱。",		-- 物品名:"箱子"->默认 制造描述:"一种结实的容器。"
			BURNT = "我的箱子被烧毁了。",		-- 物品名:"箱子"->烧焦的 制造描述:"一种结实的容器。"
		},
		TREASURECHEST_TRAP = "好漂亮的箱子！",		-- 物品名:"宝箱"
		SACRED_CHEST = 
		{
			GENERIC = "它想要什么东西来交换。",		-- 物品名:"远古宝箱"->默认
			LOCKED = "它正在做出判断。",		-- 物品名:"远古宝箱"->锁住了
		},
		TREECLUMP = "是不是有人想把我困在这里。",		-- 物品名:"远古宝箱"
		TRINKET_1 = "要很高的温度才能够将它熔化。", --Melted Marbles		-- 物品名:"熔化的弹珠"
		TRINKET_2 = "只是个假货。", --Fake Kazoo		-- 物品名:"假卡祖笛"
		TRINKET_3 = "奇怪的玩具", --Gord's Knot		-- 物品名:"戈尔迪之结"
		TRINKET_4 = "好像是童话中的生物。", --Gnome		-- 物品名:"地精爷爷"
		TRINKET_5 = "不幸的是，它太小了，我没法乘坐它逃离。", --Toy Rocketship		-- 物品名:"迷你火箭"
		TRINKET_6 = "可以回收利用里面的铜。", --Frazzled Wires		-- 物品名:"烂电线"
		TRINKET_7 = "我没有时间享乐和游戏！", --Ball and Cup		-- 物品名:"杯子和球"
		TRINKET_8 = "想起了能泡澡的日子。", --Rubber Bung		-- 物品名:"硬化橡胶塞"
		TRINKET_9 = "缝纫剩下的边角料。", --Mismatched Buttons		-- 物品名:"不搭的纽扣"
		TRINKET_10 = "我希望能在需要用到这些东西之前就能离开这里。", --Dentures		-- 物品名:"二手假牙"
		TRINKET_11 = "或许长官会喜欢?", --Lying Robot		-- 物品名:"机器人玩偶"
		TRINKET_12 = "很难想象干燥的触手浸水后会不会活过来。", --Dessicated Tentacle		-- 物品名:"干瘪的触手"
		TRINKET_13 = "童话里面的生物诶。", --Gnomette		-- 物品名:"地精奶奶"
		TRINKET_14 = "我觉得现在要是能喝点茶，或者和长官一起喝咖啡，该有多好。", --Leaky Teacup		-- 物品名:"漏水的茶杯"
		TRINKET_15 = "...麦斯威尔又落下了他的行头。", --Pawn		-- 物品名:"白色主教"
		TRINKET_16 = "...麦斯威尔又落下了他的行头。", --Pawn		-- 物品名:"黑色主教"
		TRINKET_17 = "可以来吃意面。", --Bent Spork		-- 物品名:"弯曲的叉子"
		TRINKET_18 = "特洛伊木马。", --Trojan Horse		-- 物品名:"玩具木马"
		TRINKET_19 = "结网不是很顺利。", --Unbalanced Top		-- 物品名:"失衡陀螺"
		TRINKET_20 = "给长官用，他一定很需要？！", --Backscratcher		-- 物品名:"痒痒挠"
		TRINKET_21 = "这个搅蛋器整个都弯曲变形了。", --Egg Beater		-- 物品名:"破搅拌器"
		TRINKET_22 = "关于这个绳子，我有几个理论。", --Frayed Yarn		-- 物品名:"磨损的纱线"
		TRINKET_23 = "我可以自己穿鞋，谢谢。", --Shoehorn		-- 物品名:"鞋拔子"
		TRINKET_24 = "我想薇克巴顿应该有只猫。", --Lucky Cat Jar		-- 物品名:"幸运猫扎尔"
		TRINKET_25 = "闻起来有点不新鲜。", --Air Unfreshener		-- 物品名:"臭气制造器"
		TRINKET_26 = "食物和杯子！终极生存容器。", --Potato Cup		-- 物品名:"土豆杯"
		TRINKET_27 = "如果你解开它，你可以从远处刺到别人。", --Coat Hanger		-- 物品名:"钢丝衣架"
		TRINKET_28 = "简直就是阴谋。", --Rook		-- 物品名:"白色战车"
        TRINKET_29 = "简直就是阴谋。", --Rook		-- 物品名:"黑色战车"
        TRINKET_30 = "他怎么到处乱丢呢。", --Knight		-- 物品名:"白色骑士"
        TRINKET_31 = "他怎么到处乱丢呢。", --Knight		-- 物品名:"黑色骑士"
        TRINKET_32 = "我认识喜欢这个的人！", --Cubic Zirconia Ball		-- 物品名:"立方氧化锆球"
        TRINKET_33 = "我希望不会引来蜘蛛。", --Spider Ring		-- 物品名:"蜘蛛指环"
        TRINKET_34 = "让我们许个愿望吧。为了科学。", --Monkey Paw		-- 物品名:"猴爪"
        TRINKET_35 = "很难在这附近找到一个好的烧瓶。", --Empty Elixir		-- 物品名:"空的长生不老药"
        TRINKET_36 = "在吃完所有的糖果后我可能会需要这些东西。", --Faux fangs		-- 物品名:"人造尖牙"
        TRINKET_37 = "我不相信超自然现象。", --Broken Stake		-- 物品名:"断桩"
        TRINKET_38 = "我想它来自另外一个世界，一个满是欺诈的世界。", -- Binoculars Griftlands trinket		-- 物品名:"双筒望远镜"
        TRINKET_39 = "我想知道另一只在哪里？", -- Lone Glove Griftlands trinket		-- 物品名:"单只手套"
        TRINKET_40 = "拿着它让我觉得在赶集。", -- Snail Scale Griftlands trinket		-- 物品名:"蜗牛秤"
        TRINKET_41 = "摸起来有点温热。", -- Goop Canister Hot Lava trinket		-- 物品名:"黏液罐"
        TRINKET_42 = "它充满了某人的童年记忆。", -- Toy Cobra Hot Lava trinket		-- 物品名:"玩具眼镜蛇"
        TRINKET_43= "它不太擅长跳跃。", -- Crocodile Toy Hot Lava trinket		-- 物品名:"鳄鱼玩具"
        TRINKET_44 = "它是某种植物标本。", -- Broken Terrarium ONI trinket		-- 物品名:"破碎的玻璃罐"
        TRINKET_45 = "它正在接收另一个世界的频率。", -- Odd Radio ONI trinket		-- 物品名:"奇怪的收音机"
        TRINKET_46 = "也许是测试空气动力学的工具？", -- Hairdryer ONI trinket		-- 物品名:"损坏的吹风机"
        LOST_TOY_1  = "这些都是它的宝贝。",		-- 物品名:"遗失的玻璃球"
        LOST_TOY_2  = "这些都是它的宝贝。",		-- 物品名:"多愁善感的卡祖笛"
        LOST_TOY_7  = "这些都是它的宝贝。",		-- 物品名:"珍视的抽线陀螺"
        LOST_TOY_10 = "这些都是它的宝贝。",		-- 物品名:"缺少的牙齿"
        LOST_TOY_11 = "这些都是它的宝贝。",		-- 物品名:"珍贵的玩具机器人"
        LOST_TOY_14 = "这些都是它的宝贝。",		-- 物品名:"妈妈最爱的茶杯"
        LOST_TOY_18 = "这些都是它的宝贝。",		-- 物品名:"宝贵的玩具木马"
        LOST_TOY_19 = "这些都是它的宝贝。",		-- 物品名:"最爱的陀螺"
        LOST_TOY_42 = "这些都是它的宝贝。",		-- 物品名:"装错的玩具眼镜蛇"
        LOST_TOY_43 = "这些都是它的宝贝。",		-- 物品名:"宠爱的鳄鱼玩具"
        HALLOWEENCANDY_1 = "就算蛀牙也值得了，对吧？",		-- 物品名:"糖果苹果"
        HALLOWEENCANDY_2 = "什么样腐败的科学长出了这些东西？",		-- 物品名:"糖果玉米"
        HALLOWEENCANDY_3 = "是…玉米。",		-- 物品名:"不太甜的玉米"
        HALLOWEENCANDY_4 = "它们一路蠕动下来。",		-- 物品名:"粘液蜘蛛"
        HALLOWEENCANDY_5 = "明天我的牙齿可能会对此发表意见。",		-- 物品名:"浣猫糖果"
        HALLOWEENCANDY_6 = "我…不认为我会吃那些东西。",		-- 物品名:"\"葡萄干\""
        HALLOWEENCANDY_7 = "每个人遇到这些东西都会激动的。",		-- 物品名:"葡萄干"
        HALLOWEENCANDY_8 = "只有傻瓜才不会爱上这东西。",		-- 物品名:"鬼魂棒棒糖"
        HALLOWEENCANDY_9 = "粘牙。",		-- 物品名:"果冻虫"
        HALLOWEENCANDY_10 = "只有傻瓜才不会爱上这东西。",		-- 物品名:"触须棒棒糖"
        HALLOWEENCANDY_11 = "比真的东西尝起来味道好多了。",		-- 物品名:"巧克力猪"
        HALLOWEENCANDY_12 = "那块糖果刚动了一下吗？", --ONI meal lice candy		-- 物品名:"糖果虱"
        HALLOWEENCANDY_13 = "哎呀，我可怜的下巴。", --Griftlands themed candy		-- 物品名:"无敌硬糖"
        HALLOWEENCANDY_14 = "我吃不了辣。", --Hot Lava pepper candy		-- 物品名:"熔岩椒"
        CANDYBAG = "它是某种美味的小小的甜点。",		-- 物品名:"糖果袋" 制造描述:"只带万圣夜好吃的东西。"
		HALLOWEEN_ORNAMENT_1 = "一个可以挂在树上的装饰物。",		-- 物品名:"幽灵装饰"
		HALLOWEEN_ORNAMENT_2 = "古怪的装饰。",		-- 物品名:"蝙蝠装饰"
		HALLOWEEN_ORNAMENT_3 = "这块木头看起来很适合挂起来。", 		-- 物品名:"蜘蛛装饰"
		HALLOWEEN_ORNAMENT_4 = "触触逼真。",		-- 物品名:"触手装饰"
		HALLOWEEN_ORNAMENT_5 = "八只手的装饰。",		-- 物品名:"悬垂蜘蛛装饰"
		HALLOWEEN_ORNAMENT_6 = "最近大家都在热烈讨论树的装饰。", 		-- 物品名:"乌鸦装饰"
		HALLOWEENPOTION_DRINKS_WEAK = "原以为会更大呢。",		-- 物品名:"远古宝箱"
		HALLOWEENPOTION_DRINKS_POTENT = "强力药水。",		-- 物品名:"远古宝箱"
        HALLOWEENPOTION_BRAVERY = "满满的勇气。",		-- 物品名:"远古宝箱"
		HALLOWEENPOTION_MOON = "注入了变异的力量。",		-- 物品名:"月亮精华液"
		HALLOWEENPOTION_FIRE_FX = "烈火结晶。", 		-- 物品名:"远古宝箱"
		MADSCIENCE_LAB = "为了科学就算疯了又如何！",		-- 物品名:"疯狂科学家实验室" 制造描述:"疯狂实验无极限。唯独神智有极限。"
		LIVINGTREE_ROOT = "里面有东西！我要把它彻底根除。", 		-- 物品名:"完全正常的树根"
		LIVINGTREE_SAPLING = "它会长得大到吓人。",		-- 物品名:"完全正常的树苗"
        DRAGONHEADHAT = "所以谁要在前面？",		-- 物品名:"幸运兽脑袋" 制造描述:"野兽装束的前端。"
        DRAGONBODYHAT = "中间的部分让我有点犹豫。",		-- 物品名:"幸运兽躯体" 制造描述:"野兽装束的中间部分。"
        DRAGONTAILHAT = "神龙摆尾的洋气帽子。",		-- 物品名:"幸运兽尾巴" 制造描述:"野兽装束的尾端。"
        PERDSHRINE =
        {
            GENERIC = "感觉它想要什么东西。",		-- 物品名:"火鸡神龛"->默认 制造描述:"供奉庄严之火鸡。"
            EMPTY = "我要在那里种些东西。",		-- 物品名:"火鸡神龛" 制造描述:"供奉庄严之火鸡。"
            BURNT = "完全没用了。",		-- 物品名:"火鸡神龛"->烧焦的 制造描述:"供奉庄严之火鸡。"
        },
        REDLANTERN = "这个灯笼感觉比其他灯笼特别。",		-- 物品名:"红灯笼" 制造描述:"照亮你的路的幸运灯笼。"
        LUCKY_GOLDNUGGET = "多么幸运的发现！",		-- 物品名:"幸运黄金"
        FIRECRACKERS = "充满爆炸科学。",		-- 物品名:"红鞭炮" 制造描述:"用重击来庆祝！"
        PERDFAN = "非常大。",		-- 物品名:"幸运扇" 制造描述:"额外的运气，超级多。"
        REDPOUCH = "里面有什么东西吗？",		-- 物品名:"红袋子"
        WARGSHRINE = 
        {
            GENERIC = "我得做点好玩的东西。",		-- 物品名:"座狼神龛"->默认 制造描述:"供奉陶土之座狼。"
            EMPTY = "我需要在里面放支火把。",		-- 物品名:"座狼神龛" 制造描述:"供奉陶土之座狼。"
            BURNING = "我得做点好玩的东西。", --for willow to override		-- 物品名:"座狼神龛"->正在燃烧 制造描述:"供奉陶土之座狼。"
            BURNT = "它烧毁了。",		-- 物品名:"座狼神龛"->烧焦的 制造描述:"供奉陶土之座狼。"
        },
        CLAYWARG = 
        {
        	GENERIC = "黏土怪物！",		-- 物品名:"黏土座狼"->默认
        	STATUE = "它刚刚是不是动了？",		-- 物品名:"黏土座狼"->雕像
        },
        CLAYHOUND = 
        {
        	GENERIC = "它脱离束缚了！",		-- 物品名:"黏土猎犬"->默认
        	STATUE = "它看起来好逼真。",		-- 物品名:"黏土猎犬"->雕像
        },
        HOUNDWHISTLE = "这个能阻挡狗的脚步。",		-- 物品名:"幸运哨子" 制造描述:"对野猎犬吹哨。"
        CHESSPIECE_CLAYHOUND = "反正栓着了，我才不担心呢。",		-- 物品名:"猎犬雕塑"
        CHESSPIECE_CLAYWARG = "我竟然没被吃掉！",		-- 物品名:"座狼雕塑"
		PIGSHRINE =
		{
            GENERIC = "有更多东西要做。",		-- 物品名:"猪神龛"->默认 制造描述:"供奉富饶之猪人。"
            EMPTY = "它想要肉。",		-- 物品名:"猪神龛" 制造描述:"供奉富饶之猪人。"
            BURNT = "烧焦了。",		-- 物品名:"猪神龛"->烧焦的 制造描述:"供奉富饶之猪人。"
		},
		PIG_TOKEN = "这个看起来很重要。",		-- 物品名:"金色腰带"
		PIG_COIN = "在战斗中花掉它会有好的回报。",		-- 物品名:"猪鼻铸币"
		YOTP_FOOD1 = "一场适合我的盛宴。",		-- 物品名:"致敬烤肉" 制造描述:"向猪王敬肉。"
		YOTP_FOOD2 = "只有野兽才会喜欢的食物。",		-- 物品名:"八宝泥馅饼" 制造描述:"那里隐藏着什么？"
		YOTP_FOOD3 = "没什么精致的。",		-- 物品名:"鱼头串" 制造描述:"棍子上的荣华富贵。"
		PIGELITE1 = "看什么呢？", --BLUE		-- 物品名:"韦德"
		PIGELITE2 = "他得了淘金热！", --RED		-- 物品名:"伊格内修斯"
		PIGELITE3 = "你眼里有泥！", --WHITE		-- 物品名:"德米特里"
		PIGELITE4 = "难道你不想打其他人吗？", --GREEN		-- 物品名:"索耶"
		PIGELITEFIGHTER1 = "看什么看？", --BLUE		-- 物品名:"韦德"
		PIGELITEFIGHTER2 = "他得了淘金热！", --RED		-- 物品名:"伊格内修斯"
		PIGELITEFIGHTER3 = "你眼里有泥！", --WHITE		-- 物品名:"德米特里"
		PIGELITEFIGHTER4 = "难道你不想打其他人吗？", --GREEN		-- 物品名:"索耶"
		CARRAT_GHOSTRACER = "真令人不安啊。",		-- 物品名:"查理的胡萝卜鼠"
        YOTC_CARRAT_RACE_START = "不错的起点。",		-- 物品名:"起点" 制造描述:"冲向比赛！"
        YOTC_CARRAT_RACE_CHECKPOINT = "关键的一点。",		-- 物品名:"检查点" 制造描述:"通往光荣之路上的一站。"
        YOTC_CARRAT_RACE_FINISH =
        {
            GENERIC = "与其说是终点线，不如说是终点圈。",		-- 物品名:"终点线"->默认 制造描述:"你走投无路了。"
            BURNT = "一把火烧的干干净净！",		-- 物品名:"终点线"->烧焦的 制造描述:"你走投无路了。"
            I_WON = "哈哈！科学胜出了！",		-- 物品名:"终点线" 制造描述:"你走投无路了。"
            SOMEONE_ELSE_WON = "哎……恭喜了，{winner}。",		-- 物品名:"终点线" 制造描述:"你走投无路了。"
        },
		YOTC_CARRAT_RACE_START_ITEM = "好吧，算是个开始。",		-- 物品名:"起点套装" 制造描述:"冲向比赛！"
        YOTC_CARRAT_RACE_CHECKPOINT_ITEM = "总会抵达终点。",		-- 物品名:"检查点套装" 制造描述:"通往光荣之路上的一站。"
		YOTC_CARRAT_RACE_FINISH_ITEM = "大限将至。",		-- 物品名:"终点线套装" 制造描述:"你走投无路了。"
		YOTC_SEEDPACKET = "如果你问我，我会说看起来很多籽。",		-- 物品名:"种子包" 制造描述:"一包普通的混合种子。"
		YOTC_SEEDPACKET_RARE = "哟，还是稀罕货啊！",		-- 物品名:"高级种子包" 制造描述:"一包高质量的种子。"
		MINIBOATLANTERN = "真亮！",		-- 物品名:"漂浮灯笼" 制造描述:"闪着暖暖的光亮。"
        YOTC_CARRATSHRINE =
        {
            GENERIC = "做什么呢……",		-- 物品名:"胡萝卜鼠神龛"->默认 制造描述:"供奉灵巧之胡萝卜鼠。"
            EMPTY = "嗯……胡萝卜鼠喜欢吃什么呢？",		-- 物品名:"胡萝卜鼠神龛" 制造描述:"供奉灵巧之胡萝卜鼠。"
            BURNT = "烤胡萝卜的气味。",		-- 物品名:"胡萝卜鼠神龛"->烧焦的 制造描述:"供奉灵巧之胡萝卜鼠。"
        },
        YOTC_CARRAT_GYM_DIRECTION = 
        {
            GENERIC = "为训练指明方向。",		-- 物品名:"方向健身房"->默认
            RAT = "你能当一只优秀的小白鼠。",		-- 物品名:"方向健身房"
            BURNT = "我的训练计划灰飞烟灭。",		-- 物品名:"方向健身房"->烧焦的
        },
        YOTC_CARRAT_GYM_SPEED = 
        {
            GENERIC = "我需要提高胡萝卜鼠的速度。",		-- 物品名:"速度健身房"->默认
            RAT = "快点……快点！",		-- 物品名:"速度健身房"
            BURNT = "我可能放太多燃料了。",		-- 物品名:"速度健身房"->烧焦的
        },
        YOTC_CARRAT_GYM_REACTION = 
        {
            GENERIC = "我们来训练胡萝卜鼠的反应速度！",		-- 物品名:"反应健身房"->默认
            RAT = "对象的反应时间正在稳步提高！",		-- 物品名:"反应健身房"
            BURNT = "追求科学的过程中付出的微小代价。",		-- 物品名:"反应健身房"->烧焦的
        },
        YOTC_CARRAT_GYM_STAMINA = 
        {
            GENERIC = "变得更加强壮了！",		-- 物品名:"耐力健身房"->默认
            RAT = "这只胡萝卜鼠……将无人能挡！！",		-- 物品名:"耐力健身房"
            BURNT = "谁都阻挡不了进步！但这个会推迟它……",		-- 物品名:"耐力健身房"->烧焦的
        }, 
        YOTC_CARRAT_GYM_DIRECTION_ITEM = "我也该练练了！",		-- 物品名:"方向健身房套装" 制造描述:"提高你的胡萝卜鼠的方向感。"
        YOTC_CARRAT_GYM_SPEED_ITEM = "我最好把这个组装起来。",		-- 物品名:"速度健身房套装" 制造描述:"增加你的胡萝卜鼠的速度。"
        YOTC_CARRAT_GYM_STAMINA_ITEM = "这个会改善胡萝卜鼠的耐力",		-- 物品名:"耐力健身房套装" 制造描述:"增强你的胡萝卜鼠的耐力。"
        YOTC_CARRAT_GYM_REACTION_ITEM = "这个应该能显著提高胡萝卜鼠的反应时间。",		-- 物品名:"反应健身房套装" 制造描述:"加快你的胡萝卜鼠的反应时间。"
        YOTC_CARRAT_SCALE_ITEM = "可以秤我的胡萝卜鼠。",           		-- 物品名:"胡萝卜鼠秤套装" 制造描述:"看看你的胡萝卜鼠的情况。"
        YOTC_CARRAT_SCALE = 
        {
            GENERIC = "希望天平向我倾斜。",		-- 物品名:"胡萝卜鼠秤"->默认
            CARRAT = "它终究只是一个有知觉的蔬菜。",		-- 物品名:"胡萝卜鼠" 制造描述:"灵巧机敏，富含胡萝卜素。"
            CARRAT_GOOD = "胡萝卜鼠熟到可以赛跑了！",		-- 物品名:"胡萝卜鼠秤"
            BURNT = "真是一团糟",		-- 物品名:"胡萝卜鼠秤"->烧焦的
        },                
        YOTB_BEEFALOSHRINE =
        {
            GENERIC = "做什么呢……",		-- 物品名:"皮弗娄牛神龛"->默认 制造描述:"供奉坚毅的皮弗娄牛。"
            EMPTY = "嗯……皮弗娄牛是什么做的呢？",		-- 物品名:"皮弗娄牛神龛" 制造描述:"供奉坚毅的皮弗娄牛。"
            BURNT = "闻起来是烤肉的味道。",		-- 物品名:"皮弗娄牛神龛"->烧焦的 制造描述:"供奉坚毅的皮弗娄牛。"
        },
        BEEFALO_GROOMER =
        {
            GENERIC = "没有皮弗娄牛让我打扮。",		-- 物品名:"皮弗娄牛美妆台"->默认 制造描述:"美牛原型机。"
            OCCUPIED = "让我们来打扮一下这头牛！",		-- 物品名:"皮弗娄牛美妆台"->被占领 制造描述:"美牛原型机。"
            BURNT = "烧焦了。",		-- 物品名:"皮弗娄牛美妆台"->烧焦的 制造描述:"美牛原型机。"
        },
        BEEFALO_GROOMER_ITEM = "我还是换个地方把它装起来吧。",		-- 物品名:"美妆台套装" 制造描述:"美牛原型机。"
		BISHOP_CHARGE_HIT = "噢！",		-- 物品名:"皮弗娄牛美妆台"->被主教攻击 制造描述:"美牛原型机。"
		TRUNKVEST_SUMMER = "远距离行军的装束。",		-- 物品名:"透气背心" 制造描述:"暖和，但算不上非常暖和。"
		TRUNKVEST_WINTER = "抵御寒风的背心。",		-- 物品名:"松软背心" 制造描述:"足以抵御冬季暴雪的保暖背心。"
		TRUNK_COOKED = "橄榄油和洋葱能够提高它的风味。",		-- 物品名:"象鼻排"
		TRUNK_SUMMER = "大象的鼻子，肉很多，不过我没怎么吃过。",		-- 物品名:"象鼻"
		TRUNK_WINTER = "冬象的多肉象鼻。",		-- 物品名:"冬象鼻"
		TUMBLEWEED = "里面有不少好东西的风滚草。",		-- 物品名:"风滚草"
		TURKEYDINNER = "想到美国佬的感恩故事就想笑。",		-- 物品名:"火鸡大餐"
		TWIGS = "一根根小棍子。",		-- 物品名:"树枝"
		UMBRELLA = "我讨厌头发喝衣服被水弄湿。",		-- 物品名:"雨伞" 制造描述:"遮阳挡雨！"
		GRASS_UMBRELLA = "淑女的美来自方方面面。",		-- 物品名:"花伞" 制造描述:"漂亮轻便的保护伞。"
		UNIMPLEMENTED = "看起来还没有完工！可能有危险。",		-- 物品名:"皮弗娄牛美妆台" 制造描述:"美牛原型机。"
		WAFFLES = "不需要其他的香料，已经足够美味了。",		-- 物品名:"华夫饼"
		WALL_HAY = 
		{	
			GENERIC = "草墙也可以使用。",		-- 物品名:"草墙"->默认
			BURNT = "完全没用了。",		-- 物品名:"草墙"->烧焦的
		},
		WALL_HAY_ITEM = "感觉不太结实。",		-- 物品名:"草墙" 制造描述:"草墙墙体。不太结实。"
		WALL_STONE = "结实的墙体。",		-- 物品名:"石墙"
		WALL_STONE_ITEM = "有墙的保护好多了。",		-- 物品名:"石墙" 制造描述:"石墙墙体。"
		WALL_RUINS = "古老而优雅的墙。",		-- 物品名:"铥矿墙"
		WALL_RUINS_ITEM = "这墙壁坚不可摧。",		-- 物品名:"铥矿墙" 制造描述:"这些墙可以承受相当多的打击。"
		WALL_WOOD = 
		{
			GENERIC = "尖的木墙！",		-- 物品名:"木墙"->默认
			BURNT = "木墙烧焦了！",		-- 物品名:"木墙"->烧焦的
		},
		WALL_WOOD_ITEM = "木桩！",		-- 物品名:"木墙" 制造描述:"木墙墙体。"
		WALL_MOONROCK = "倾诉着月亮的轻灵！",		-- 物品名:"月岩墙"
		WALL_MOONROCK_ITEM = "它的材料比强度很高。",		-- 物品名:"月岩墙" 制造描述:"月球疯子之墙。"
		FENCE = "漂亮的木头栅栏。",		-- 物品名:"木栅栏"
        FENCE_ITEM = "栅栏美丽而坚固。",		-- 物品名:"木栅栏" 制造描述:"木栅栏部分。"
        FENCE_GATE = "门和家紧密而不可分开。",		-- 物品名:"木门"
        FENCE_GATE_ITEM = "摆放下牢固的门吧。",		-- 物品名:"木门" 制造描述:"木栅栏的门。"
		WALRUS = "我是猎人，它才是猎物。",		-- 物品名:"海象"
		WALRUSHAT = "苏格兰风格帽子。",		-- 物品名:"贝雷帽"
		WALRUS_CAMP =
		{
			EMPTY = "冬天会有人在这里安营。",		-- 物品名:"海象营地"
			GENERIC ="我只听说过冰屋并没有看过。",		-- 物品名:"海象营地"->默认
		},
		WALRUS_TUSK = "用海象牙可以做很多东西。",		-- 物品名:"海象牙"
		WARDROBE = 
		{
			GENERIC = "少女的衣柜可是秘密..",		-- 物品名:"衣柜"->默认 制造描述:"随心变换面容。"
            BURNING = "赶紧灭火吧！",		-- 物品名:"衣柜"->正在燃烧 制造描述:"随心变换面容。"
			BURNT = "就这样吧。",		-- 物品名:"衣柜"->烧焦的 制造描述:"随心变换面容。"
		},
		WARG = "我不喜欢这个大狗。",		-- 物品名:"座狼"
		WASPHIVE = "讨厌的蜜蜂的巢穴。",		-- 物品名:"杀人蜂蜂窝"
		WATERBALLOON = "灭火和玩耍的时用的水球。",		-- 物品名:"水球" 制造描述:"球体灭火。"
		WATERMELON = "甜甜的大西瓜。",		-- 物品名:"西瓜"
		WATERMELON_COOKED = "流淌着温热的西瓜汁。",		-- 物品名:"烤西瓜"
		WATERMELONHAT = "感觉有些滑稽。",		-- 物品名:"西瓜帽" 制造描述:"提神醒脑，但感觉黏黏的。"
		WAXWELLJOURNAL = "有些可怕。",		-- 物品名:"暗影秘典" 制造描述:"这将让你大吃一惊。"
		WETGOOP = "烹饪过程中难免会失败。",		-- 物品名:"失败料理"
        WHIP = "能够发出很大声音的皮鞭。",		-- 物品名:"皮鞭" 制造描述:"提出有建设性的反馈意见。"
		WINTERHAT = "冬天保温的小帽子。",		-- 物品名:"冬帽" 制造描述:"保持脑袋温暖。"
		WINTEROMETER = 
		{
			GENERIC = "地中海气候非常舒适。",		-- 物品名:"温度测量仪"->默认 制造描述:"测量环境气温。"
			BURNT = "无法测量了。",		-- 物品名:"温度测量仪"->烧焦的 制造描述:"测量环境气温。"
		},
        WINTER_TREE =
        {
            BURNT = "节日气氛受了影响。",		-- 物品名:"冬季圣诞树"->烧焦的
            BURNING = "我认为那是个错误。",		-- 物品名:"冬季圣诞树"->正在燃烧
            CANDECORATE = "冬季盛宴快乐！",		-- 物品名:"冬季圣诞树"->烛台？？？
            YOUNG = "马上就到冬季盛宴了！",		-- 物品名:"冬季圣诞树"->还年轻
        },
		WINTER_TREESTAND = 
		{
			GENERIC = "我需要一颗松果。",		-- 物品名:"圣诞树墩"->默认 制造描述:"种植并装饰一棵冬季圣诞树！"
            BURNT = "节日气氛受了影响。",		-- 物品名:"圣诞树墩"->烧焦的 制造描述:"种植并装饰一棵冬季圣诞树！"
		},
        WINTER_ORNAMENT = "每个科学家都会欣赏一个好的玩意。",		-- 物品名:"圣诞小玩意"
        WINTER_ORNAMENTLIGHT = "一棵树没有电流就不算完整。",		-- 物品名:"圣诞灯"
        WINTER_ORNAMENTBOSS = "这一个尤其令人印象深刻。",		-- 物品名:"华丽的装饰"
		WINTER_ORNAMENTFORGE = "我应该把它悬火上烤。",		-- 物品名:"熔炉装饰"
		WINTER_ORNAMENTGORGE = "不知道为什么，这让我觉得很饿。",		-- 物品名:"暴食装饰"
        WINTER_FOOD1 = "解剖结构是错的，但是我会忽略它。", --gingerbread cookie		-- 物品名:"小姜饼"
        WINTER_FOOD2 = "我要吃四十个。为了科学。", --sugar cookie		-- 物品名:"糖曲奇饼"
        WINTER_FOOD3 = "圣诞节期间的牙疼马上就要发生了。", --candy cane		-- 物品名:"拐杖糖"
        WINTER_FOOD4 = "那个实验可能有点儿不道德。", --fruitcake		-- 物品名:"永远的水果蛋糕"
        WINTER_FOOD5 = "能有一次吃浆果以外的东西真是好。", --yule log cake		-- 物品名:"巧克力树洞蛋糕"
        WINTER_FOOD6 = "直接放进嘴里！", --plum pudding		-- 物品名:"李子布丁"
        WINTER_FOOD7 = "充满了美味汁液的空心苹果。", --apple cider		-- 物品名:"苹果酒"
        WINTER_FOOD8 = "它是怎么保持温暖的？一个热力马克杯？", --hot cocoa		-- 物品名:"热可可"
        WINTER_FOOD9 = "科学能够解释它为什么味道这么棒吗？", --eggnog		-- 物品名:"美味的蛋酒"
		WINTERSFEASTOVEN =
		{
			GENERIC = "喜庆的炉子，用来做火烤的食物！",		-- 物品名:"砖砌烤炉"->默认 制造描述:"燃起了喜庆的火焰。"
			COOKING = "烹饪果然是科学。",		-- 物品名:"砖砌烤炉" 制造描述:"燃起了喜庆的火焰。"
			ALMOST_DONE_COOKING = "科学就快完成了！",		-- 物品名:"砖砌烤炉" 制造描述:"燃起了喜庆的火焰。"
			DISH_READY = "科学说完成了。",		-- 物品名:"砖砌烤炉" 制造描述:"燃起了喜庆的火焰。"
		},
		BERRYSAUCE = "浆果果酱。",		-- 物品名:"快乐浆果酱"
		BIBINGKA = "像海绵一样软。",		-- 物品名:"比宾卡米糕"
		CABBAGEROLLS = "肉躲在白菜里面躲避天敌。",		-- 物品名:"白菜卷"
		FESTIVEFISH = "品尝品尝时令海鲜。",		-- 物品名:"节庆鱼料理"
		GRAVY = "全是肉汁。",		-- 物品名:"好肉汁"
		LATKES = "我能吃好多个。",		-- 物品名:"土豆饼"
		LUTEFISK = "那有喇叭鱼吗？",		-- 物品名:"苏打鱼"
		MULLEDDRINK = "这杯潘趣酒劲很足。",		-- 物品名:"香料潘趣酒"
		PANETTONE = "这个仲冬节的面包真是应景。",		-- 物品名:"托尼甜面包"
		PAVLOVA = "我最爱巴甫洛娃了。",		-- 物品名:"巴甫洛娃蛋糕"
		PICKLEDHERRING = "无可挑剔的美味。",		-- 物品名:"腌鲱鱼"
		POLISHCOOKIE = "我要来一次光碟行动！",		-- 物品名:"波兰饼干"
		PUMPKINPIE = "为了科学，我要全部吃掉。",		-- 物品名:"南瓜派"
		ROASTTURKEY = "肥美多汁的鸡腿，专门为我做的。",		-- 物品名:"烤火鸡"
		STUFFING = "都是好料！",		-- 物品名:"烤火鸡面包馅"
		SWEETPOTATO = "科学创造出了晚餐和甜点的完美混合物。",		-- 物品名:"红薯焗饭"
		TAMALES = "我要是再多吃一些，也许会变得健壮了。",		-- 物品名:"塔马利"
		TOURTIERE = "很高兴肉食你！",		-- 物品名:"饕餮馅饼"
		TABLE_WINTERS_FEAST = 
		{
			GENERIC = "节庆餐桌。",		-- 物品名:"冬季盛宴餐桌"->默认 制造描述:"一起来享用冬季盛宴吧。"
			HAS_FOOD = "吃饭时间到了！",		-- 物品名:"冬季盛宴餐桌" 制造描述:"一起来享用冬季盛宴吧。"
			WRONG_TYPE = "不是吃这个的季节。",		-- 物品名:"冬季盛宴餐桌" 制造描述:"一起来享用冬季盛宴吧。"
			BURNT = "谁会做这种事？",		-- 物品名:"冬季盛宴餐桌"->烧焦的 制造描述:"一起来享用冬季盛宴吧。"
		},
		GINGERBREADWARG = "舔品一下甜品。", 		-- 物品名:"姜饼座狼"
		GINGERBREADHOUSE = "管吃管住。", 		-- 物品名:"姜饼猪屋"
		GINGERBREADPIG = "我最好跟着他。",		-- 物品名:"姜饼猪"
		CRUMBS = "走一路掉一路。",		-- 物品名:"饼干屑"
		WINTERSFEASTFUEL = "冬季精神!",		-- 物品名:"节日欢愉"
        KLAUS = "看来今天来了个贵宾！",		-- 物品名:"克劳斯"
        KLAUS_SACK = "它还给我们带来了礼物。",		-- 物品名:"赃物袋"
		KLAUSSACKKEY = "这个鹿角艺术感十足。",		-- 物品名:"麋鹿茸"
		WORMHOLE =
		{
			GENERIC = "呜哇...黏糊糊的真恶心。",		-- 物品名:"虫洞"->默认
			OPEN = "尝试一下跳下去。",		-- 物品名:"虫洞"->打开
		},
		WORMHOLE_LIMITED = "啊，那玩意看着不太对啊。",		-- 物品名:"生病的虫洞"->一次性虫洞 单机
		ACCOMPLISHMENT_SHRINE = "我想用一下它，我想让全世界都知道我的所作所为。",        		-- 物品名:"奖杯" 制造描述:"证明你作为一个人的价值。"
		LIVINGTREE = "这棵树有些别致。",		-- 物品名:"完全正常的树"
		ICESTAFF = "能够冰冻住目标。",		-- 物品名:"冰魔杖" 制造描述:"把敌人冰冻在原地。"
		REVIVER = "将鬼魂复活的心脏！",		-- 物品名:"告密的心" 制造描述:"鬼魂朋友复活了，好可怕。"
		SHADOWHEART = "它为骨架提供灵魂。",		-- 物品名:"暗影心房"
        ATRIUM_RUBBLE = 
        {
			LINE_1 = "它描绘了一个古老的文明。人们看起来又饿又怕。",		-- 物品名:"远古壁画"->第一行
			LINE_2 = "这块石板已经无法识别了。",		-- 物品名:"远古壁画"->第二行
			LINE_3 = "有黑暗的东西悄悄逼近这座城市和城里的人。",		-- 物品名:"远古壁画"->第三行
			LINE_4 = "人们的皮肤在脱落。他们的表里截然不同。",		-- 物品名:"远古壁画"->第四行
			LINE_5 = "这里描绘了一座科技发达的宏伟城市。",		-- 物品名:"远古壁画"->第五行
		},
        ATRIUM_STATUE = "这看起来并不全是真的。",		-- 物品名:"远古雕像"
        ATRIUM_LIGHT = 
        {
			ON = "非常令人不安的光。",		-- 物品名:"远古灯柱"->开启
			OFF = "它必须有能量来源。",		-- 物品名:"远古灯柱"->关闭
		},
        ATRIUM_GATE =
        {
			ON = "回到正常运转状态。",		-- 物品名:"远古大门"->开启
			OFF = "主要部分依然完好无损。",		-- 物品名:"远古大门"->关闭
			CHARGING = "它正在获得能量。",		-- 物品名:"远古大门"->充能中
			DESTABILIZING = "大门在晃动。",		-- 物品名:"远古大门"->不稳定
			COOLDOWN = "它需要时间休息，我也是。",		-- 物品名:"远古大门"->冷却中
        },
        ATRIUM_KEY = "打开大门用的钥匙。",		-- 物品名:"远古钥匙"
		LIFEINJECTOR = "让我获得更大的生命力，恢复合适的心跳。",		-- 物品名:"强心针" 制造描述:"提高下你那日渐衰退的最大健康值吧。"
		SKELETON_PLAYER =
		{
			MALE = "%s一定是在和%s进行试验时死的。",		-- 物品名:"骷髅"->男性
			FEMALE = "%s一定是在和%s进行试验时死的。",		-- 物品名:"骷髅"->女性
			ROBOT = "%s一定是在和%s进行试验时死的。",		-- 物品名:"骷髅"->机器人
			DEFAULT = "%s一定是在和%s进行试验时死的。",		-- 物品名:"物品栏物品"->默认
		},
		HUMANMEAT = "肉就是肉。有区别么？",		-- 物品名:"长猪"
		HUMANMEAT_COOKED = "煮的粉嫩，但在道德上还是灰色地带。",		-- 物品名:"煮熟的长猪"
		HUMANMEAT_DRIED = "风干了就不是人肉了，对吧？",		-- 物品名:"长猪肉干"
		ROCK_MOON = "那块石头来自月亮。",		-- 物品名:"岩石"
		MOONROCKNUGGET = "这个岩石真不错。",		-- 物品名:"月岩"
		MOONROCKCRATER = "我应该把闪亮的东西粘在它里面。用来研究。",		-- 物品名:"带孔月岩" 制造描述:"用于划定地盘的岩石。"
		MOONROCKSEED = "来自月亮的宝球！",		-- 物品名:"天体宝球"
        REDMOONEYE = "它能记录每个地点。",		-- 物品名:"红色月眼"
        PURPLEMOONEYE = "总感觉它会发出激光。",		-- 物品名:"紫色月眼"
        GREENMOONEYE = "它像是一个摄像头。",		-- 物品名:"绿色月眼"
        ORANGEMOONEYE = "指路的月亮之眼。",		-- 物品名:"橘色月眼"
        YELLOWMOONEYE = "像是太阳一样指点方向。",		-- 物品名:"黄色月眼"
        BLUEMOONEYE = "万事要留一个心眼。",		-- 物品名:"蓝色月眼"
        BOARRIOR = "你可真大！",		-- 物品名:"大熔炉猪战士"->大熔炉猪战士
        BOARON = "我可以应对他！",		-- 物品名:"战猪"
        PEGHOOK = "那家伙喷出来的东西有腐蚀性！",		-- 物品名:"蝎子"
        TRAILS = "他的胳膊真壮啊。",		-- 物品名:"野猪猩"
        TURTILLUS = "它的壳有尖刺！",		-- 物品名:"坦克龟"
        SNAPPER = "这家伙会咬人。",		-- 物品名:"鳄鱼指挥官"
		RHINODRILL = "他的鼻子很适合干这个活。",		-- 物品名:"后扣帽犀牛兄弟"
		BEETLETAUR = "我在这里都能闻到他的气味！",		-- 物品名:"地狱独眼巨猪"
        LAVAARENA_PORTAL = 
        {
            ON = "我要走了。",		-- 物品名:"远古大门"->开启
            GENERIC = "能过来，应该也能回去吧？",		-- 物品名:"远古大门"->默认
        },
        HEALINGSTAFF = "释放再生的力量。",		-- 物品名:"生命魔杖"
        FIREBALLSTAFF = "召唤流星从天而降。",		-- 物品名:"地狱魔杖"
        HAMMER_MJOLNIR = "这把敲东西的锤子可真重。",		-- 物品名:"锻锤"
        SPEAR_GUNGNIR = "我可以用它快速充电。",		-- 物品名:"尖齿矛"
        BLOWDART_LAVA = "我可以在范围内用这个武器。",		-- 物品名:"吹箭"
        BLOWDART_LAVA2 = "它利用一股强气流来推动抛射物。",		-- 物品名:"熔化吹箭"
        WEBBER_SPIDER_MINION = "可以说他们是在为我们战斗吧。",		-- 物品名:"蜘蛛宝宝"
        BOOK_FOSSIL = "这样能把那些怪物拖住一阵子。",		-- 物品名:"石化之书"
		SPEAR_LANCE = "它直击要害。",		-- 物品名:"螺旋矛"
		BOOK_ELEMENTAL = "我看不清这些字。",		-- 物品名:"召唤之书"
        QUAGMIRE_ALTAR = 
        {
        	GENERIC = "我们最好开始煮些祭品。",		-- 物品名:"饕餮祭坛"->默认
        	FULL = "它正在消化。",		-- 物品名:"饕餮祭坛"->满了
    	},
		QUAGMIRE_SUGARWOODTREE = 
		{
			GENERIC = "它含有大量美味可口的树液。",		-- 物品名:"糖木树"->默认
			STUMP = "那棵树哪去了？真是一桩谜题。",		-- 物品名:"糖木树"->暴食模式糖木树只剩树桩了
			TAPPED_EMPTY = "丰富的汁液。",		-- 物品名:"糖木树"->暴食模式糖木树空了
			TAPPED_READY = "香甜的金黄色汁液。",		-- 物品名:"糖木树"->暴食模式糖木树好了
			TAPPED_BUGS = "蚂蚁就是这样来的。",		-- 物品名:"糖木树"->暴食模式糖木树上有蚂蚁
			WOUNDED = "它看上去生病了。",		-- 物品名:"糖木树"->暴食糖木树生病了
		},
		QUAGMIRE_SPOTSPICE_SHRUB = 
		{
			GENERIC = "它让我想起来那些带触手的怪物。",		-- 物品名:"带斑点的小灌木"->默认
			PICKED = "从那丛灌木中采集不到更多果实了。",		-- 物品名:"带斑点的小灌木"->被采完了
		},
		QUAGMIRE_SALT_RACK =
		{
			READY = "盐积聚在绳子上了。",		-- 物品名:"盐架"->准备好的 满的
			GENERIC = "科学是需要时间的。",		-- 物品名:"盐架"->默认
		},
		QUAGMIRE_SAFE = 
		{
			GENERIC = "这是保险箱，用来保护物品安全的。",		-- 物品名:"保险箱"->默认
			LOCKED = "没有钥匙就打不开。",		-- 物品名:"保险箱"->锁住了
		},
		QUAGMIRE_MUSHROOMSTUMP =
		{
			GENERIC = "那些是蘑菇吗？这真是一桩难题。",		-- 物品名:"蘑菇"->默认
			PICKED = "应该不会长回来了。",		-- 物品名:"蘑菇"->被采完了
		},
        QUAGMIRE_RUBBLE_HOUSE =
        {
            "空无一人。",		-- 物品名:"残破的房子" 制造描述:未找到
            "这个小镇被摧毁了。",		-- 物品名:"残破的房子" 制造描述:未找到
            "不知道他们惹怒了谁。",		-- 物品名:"残破的房子" 制造描述:未找到
        },
        QUAGMIRE_SWAMPIGELDER =
        {
            GENERIC = "我猜你是这里的老大？",		-- 物品名:"沼泽猪长老"->默认
            SLEEPING = "它睡着了，暂时睡着了。",		-- 物品名:"沼泽猪长老"->睡着了
        },
        QUAGMIRE_FOOD =
        {
        	GENERIC = "我应该把它献祭在饕餮祭坛上。",		-- 物品名:未找到
            MISMATCH = "不是它想要的。",		-- 物品名:未找到
            MATCH = "科学说这样会安抚天空之神。",		-- 物品名:未找到
            MATCH_BUT_SNACK = "真的，这更像是小吃。",		-- 物品名:未找到
        },
        QUAGMIRE_PARK_GATE =
        {
            GENERIC = "没钥匙不行。",		-- 物品名:"铁门"->默认
            LOCKED = "锁得牢牢的。",		-- 物品名:"铁门"->锁住了
        },
        QUAGMIRE_PIGEON =
        {
            DEAD = "死了。",		-- 物品名:"鸽子"->死了 制造描述:"这是一只完整的活鸽。"
            GENERIC = "羽翼丰满。",		-- 物品名:"鸽子"->默认 制造描述:"这是一只完整的活鸽。"
            SLEEPING = "暂时睡着了。",		-- 物品名:"鸽子"->睡着了 制造描述:"这是一只完整的活鸽。"
        },
        WINONA_CATAPULT = 
        {
        	GENERIC = "没有我的152副炮好用。",		-- 物品名:"薇诺娜的投石机"->默认 制造描述:"向敌人投掷大石块"
        	OFF = "一样需要电力。",		-- 物品名:"薇诺娜的投石机"->关闭 制造描述:"向敌人投掷大石块"
        	BURNING = "防卫装置需要灭火！",		-- 物品名:"薇诺娜的投石机"->正在燃烧 制造描述:"向敌人投掷大石块"
        	BURNT = "可惜了啊。",		-- 物品名:"薇诺娜的投石机"->烧焦的 制造描述:"向敌人投掷大石块"
        },
        WINONA_SPOTLIGHT = 
        {
        	GENERIC = "我在聚光灯下！",		-- 物品名:"薇诺娜的聚光灯"->默认 制造描述:"白天夜里都发光"
        	OFF = "一样需要电力。",		-- 物品名:"薇诺娜的聚光灯"->关闭 制造描述:"白天夜里都发光"
        	BURNING = "照明装置需要灭火！",		-- 物品名:"薇诺娜的聚光灯"->正在燃烧 制造描述:"白天夜里都发光"
        	BURNT = "可惜了啊。",		-- 物品名:"薇诺娜的聚光灯"->烧焦的 制造描述:"白天夜里都发光"
        },
        WINONA_BATTERY_LOW = 
        {
        	GENERIC = "硝酸根被还原时会释放能量，将这股能量转换为电力。",		-- 物品名:"薇诺娜的发电机"->默认 制造描述:"要确保电力供应充足"
        	LOWPOWER = "电量正在下降。",		-- 物品名:"薇诺娜的发电机"->没电了 制造描述:"要确保电力供应充足"
        	OFF = "需要加入硝石燃料。",		-- 物品名:"薇诺娜的发电机"->关闭 制造描述:"要确保电力供应充足"
        	BURNING = "发电装置需要灭火！",		-- 物品名:"薇诺娜的发电机"->正在燃烧 制造描述:"要确保电力供应充足"
        	BURNT = "可惜了啊。",		-- 物品名:"薇诺娜的发电机"->烧焦的 制造描述:"要确保电力供应充足"
        },
        WINONA_BATTERY_HIGH = 
        {
        	GENERIC = "我知道宝石的光学用途但是不知道它们的电学用途。",		-- 物品名:"薇诺娜的宝石发电机"->默认 制造描述:"这玩意烧宝石，所以肯定不会差。"
        	LOWPOWER = "马上就没电了。",		-- 物品名:"薇诺娜的宝石发电机"->没电了 制造描述:"这玩意烧宝石，所以肯定不会差。"
        	OFF = "没电了。",		-- 物品名:"薇诺娜的宝石发电机"->关闭 制造描述:"这玩意烧宝石，所以肯定不会差。"
        	BURNING = "发电装置需要灭火！",		-- 物品名:"薇诺娜的宝石发电机"->正在燃烧 制造描述:"这玩意烧宝石，所以肯定不会差。"
        	BURNT = "可惜了啊。",		-- 物品名:"薇诺娜的宝石发电机"->烧焦的 制造描述:"这玩意烧宝石，所以肯定不会差。"
        },
        COMPOSTWRAP = "熟练掌握合成氨技术野生摆脱进口依赖的关键之一。",		-- 物品名:"肥料包" 制造描述:"\"草本\"的疗法。"
        ARMOR_BRAMBLE = "可以安全的采摘仙人掌了。",		-- 物品名:"荆棘外壳" 制造描述:"让大自然告诉你什么叫\"滚开\"。"
        TRAP_BRAMBLE = "谁要是踩上去肯定会受伤的。",		-- 物品名:"荆棘陷阱" 制造描述:"都有机会中招的干\n扰陷阱。"
        BOATFRAGMENT03 = "这就是船只的命运吗。",		-- 物品名:"船碎片"
        BOATFRAGMENT04 = "这就是船只的命运吗。",		-- 物品名:"船碎片"
        BOATFRAGMENT05 = "这就是船只的命运吗。",		-- 物品名:"船碎片"
		BOAT_LEAK = "需要把漏洞补上。",		-- 物品名:"漏洞"
        MAST = "迎向海风！",		-- 物品名:"桅杆" 制造描述:"乘风破浪会有时。"
        SEASTACK = "这是海上的石头。",		-- 物品名:"浮堆"
        FISHINGNET = "就是一张网。",		-- 物品名:"渔网" 制造描述:"就是一张网。"
        ANTCHOVIES = "啊,这条鱼长得真有特色。",		-- 物品名:"蚁头凤尾鱼"
        STEERINGWHEEL = "舰娘应该在海上走才对。",		-- 物品名:"方向舵" 制造描述:"航海必备道具。"
        ANCHOR = "让船停在合适的地方。",		-- 物品名:"锚" 制造描述:"船用刹车"
        BOATPATCH = "预防万一。",		-- 物品名:"船补丁" 制造描述:"打补丁永远不晚。"
        DRIFTWOOD_TREE = 
        {
            BURNING = "浮木在燃烧！",		-- 物品名:"浮木"->正在燃烧
            BURNT = "看起来没什么用了。",		-- 物品名:"浮木"->烧焦的
            CHOPPED = "还可以再挖一下。",		-- 物品名:"浮木"->被砍了
            GENERIC = "软木有自己的用途。",		-- 物品名:"浮木"->默认
        },
        DRIFTWOOD_LOG = "空心的浮木桩子。",		-- 物品名:"浮木桩"
        MOON_TREE = 
        {
            BURNING = "需要赶紧灭火。",		-- 物品名:"月树"->正在燃烧
            BURNT = "树烧尽了。",		-- 物品名:"月树"->烧焦的
            CHOPPED = "能够清楚的看到树的年轮。",		-- 物品名:"月树"->被砍了
            GENERIC = "它和大陆上的树完全不同。",		-- 物品名:"月树"->默认
        },
		MOON_TREE_BLOSSOM = "月亮上的花。",		-- 物品名:"月树花"
        MOONBUTTERFLY = 
        {
        	GENERIC = "吸收月光的蝴蝶。",		-- 物品名:"月蛾"->默认
        	HELD = "这下抓到你了。",		-- 物品名:"月蛾"->拿在手里
        },
		MOONBUTTERFLYWINGS = "美丽的蝴蝶翅膀。",		-- 物品名:"月蛾翅膀"
        MOONBUTTERFLY_SAPLING = "月光似乎让蝴蝶变成了树。",		-- 物品名:"月树苗"
        ROCK_AVOCADO_FRUIT = "包裹着蔬菜的石头。",		-- 物品名:"石果"
        ROCK_AVOCADO_FRUIT_RIPE = "有点像牛油果。",		-- 物品名:"成熟石果"
        ROCK_AVOCADO_FRUIT_RIPE_COOKED = "配点青柠味道会更好。",		-- 物品名:"熟石果"
        ROCK_AVOCADO_FRUIT_SPROUT = "它正在生长。",		-- 物品名:"发芽的石果"
        ROCK_AVOCADO_BUSH = 
        {
        	BARREN = "准备结果了。",		-- 物品名:"石果灌木丛"
			WITHERED = "被热坏了。",		-- 物品名:"石果灌木丛"->枯萎了
			GENERIC = "是月亮上来的灌木！",		-- 物品名:"石果灌木丛"->默认
			PICKED = "需要再等一些时间。",		-- 物品名:"石果灌木丛"->被采完了
			DISEASED = "看上去病的很重。",		-- 物品名:"石果灌木丛"->生病了
            DISEASING = "呃...有些地方不对劲。",		-- 物品名:"石果灌木丛"->正在生病？？
			BURNING = "需要灭火。",		-- 物品名:"石果灌木丛"->正在燃烧
		},
        DEAD_SEA_BONES = "现在看来这样反而更好。",		-- 物品名:"海骨"
        HOTSPRING = 
        {
        	GENERIC = "我觉得这里的水有问题。",		-- 物品名:"温泉"->默认
        	BOMBED = "水里面肉眼可见很多玻璃态非晶体。",		-- 物品名:"温泉"
        	GLASS = "看上去水里面的硅酸盐含量很高。",		-- 物品名:"温泉"
			EMPTY = "它也遵循潮汐规则。",		-- 物品名:"温泉"
        },
        MOONGLASS = "小心被划破手指。",		-- 物品名:"月亮碎片"
        MOONGLASS_CHARGED = "它拥有不小的能量！",		-- 物品名:"注能月亮碎片"
        MOONGLASS_ROCK = "晶莹剔透的玻璃。",		-- 物品名:"月光玻璃"
        BATHBOMB = "能让这里的温泉沸腾。",		-- 物品名:"沐浴球" 制造描述:"春天里来百花香？这点子把地都炸碎了"
        TRAP_STARFISH =
        {
            GENERIC = "一只海星！",		-- 物品名:"海星"->默认
            CLOSED = "它看上去很不友好！",		-- 物品名:"海星"
        },
        DUG_TRAP_STARFISH = "它再也骗不了人了。",		-- 物品名:"海星陷阱"
        SPIDER_MOON = 
        {
        	GENERIC = "蜘蛛收到月亮的照射变异了。",		-- 物品名:"破碎蜘蛛"->默认
        	SLEEPING = "我想乘机解决掉它。",		-- 物品名:"破碎蜘蛛"->睡着了
        	DEAD = "真的死了吧？",		-- 物品名:"破碎蜘蛛"->死了
        },
        MOONSPIDERDEN = "适应月亮环境的蜘蛛巢。",		-- 物品名:"破碎蜘蛛洞"
		FRUITDRAGON =
		{
			GENERIC = "我还是第一次见这种生物。",		-- 物品名:"沙拉蝾螈"->默认
			RIPE = "它还变了颜色。",		-- 物品名:"沙拉蝾螈"
			SLEEPING = "在打盹呢。",		-- 物品名:"沙拉蝾螈"->睡着了
		},
        PUFFIN =
        {
            GENERIC = "海上总是有不少的这样的海鸟。",		-- 物品名:"海鹦鹉"->默认
            HELD = "我想和他做伙伴。",		-- 物品名:"海鹦鹉"->拿在手里
            SLEEPING = "呼呼的安睡。",		-- 物品名:"海鹦鹉"->睡着了
        },
		MOONGLASSAXE = "效率极高的斧子。",		-- 物品名:"月光玻璃斧" 制造描述:"脆弱而有效。"
		GLASSCUTTER = "这把武器很顺手。",		-- 物品名:"玻璃刀" 制造描述:"尖端武器。"
        ICEBERG =
        {
            GENERIC = "舰娘一定要避开那东西。",		-- 物品名:"迷你冰山"->默认
            MELTED = "完全融化了。",		-- 物品名:"迷你冰山"->融化了
        },
        ICEBERG_MELTED = "完全融化了。",		-- 物品名:"融化的迷你冰山"
        MINIFLARE = "海上的信号弹。",		-- 物品名:"信号弹" 制造描述:"为你信任的朋友照亮前路。"
		MOON_FISSURE = 
		{
			GENERIC = "它似乎想在潜移默化中改变你。", 		-- 物品名:"天体裂隙"->默认
			NOLIGHT = "这里的裂隙越来越明显了。",		-- 物品名:"天体裂隙"
		},
        MOON_ALTAR =
        {
            MOON_ALTAR_WIP = "似乎没完成。",		-- 物品名:未找到
            GENERIC = "唔？你说什么？",		-- 物品名:未找到
        },
        MOON_ALTAR_IDOL = "我想把它搬走。",		-- 物品名:"天体祭坛雕像"
        MOON_ALTAR_GLASS = "它不想待在地上。",		-- 物品名:"天体祭坛底座"
        MOON_ALTAR_SEED = "它想让我给它一个家。",		-- 物品名:"天体祭坛宝球"
        MOON_ALTAR_ROCK_IDOL = "里面有东西。",		-- 物品名:"在呼唤我"
        MOON_ALTAR_ROCK_GLASS = "里面有东西。",		-- 物品名:"在呼唤我"
        MOON_ALTAR_ROCK_SEED = "里面有东西。",		-- 物品名:"在呼唤我"
        MOON_ALTAR_CROWN = "它要安装在裂缝上",		-- 物品名:"未激活天体贡品"
        MOON_ALTAR_COSMIC = "我觉得它在等什么事情发生。",		-- 物品名:"天体贡品"
        MOON_ALTAR_ASTRAL = "它只是一个设备的一部分。",		-- 物品名:"天体圣殿"
        MOON_ALTAR_ICON = "我知道把你放哪了。",		-- 物品名:"天体圣殿象征"
        MOON_ALTAR_WARD = "它需要和其他的那些放在一起。",        		-- 物品名:"天体圣殿卫戍"
        SEAFARING_PROTOTYPER =
        {
            GENERIC = "全新的航海科技。",		-- 物品名:"智囊团"->默认 制造描述:"海上科学。"
            BURNT = "烧着了。",		-- 物品名:"智囊团"->烧焦的 制造描述:"海上科学。"
        },
        BOAT_ITEM = "舰娘要划船出海吗。",		-- 物品名:"船套装" 制造描述:"让大海成为你的领地。"
        STEERINGWHEEL_ITEM = "它能做成方向舵。",		-- 物品名:"方向舵套装" 制造描述:"航海必备道具。"
        ANCHOR_ITEM = "我觉得现在我能造出锚了。",		-- 物品名:"锚套装" 制造描述:"船用刹车"
        MAST_ITEM = "桅杆是一艘船的象征。",		-- 物品名:"桅杆套装" 制造描述:"乘风破浪会有时。"
        MUTATEDHOUND = 
        {
        	DEAD = "我觉得现在我可以轻松的呼吸了。",		-- 物品名:"恐怖猎犬"->死了
        	GENERIC = "它被月亮的力量改造成了这种模样。",		-- 物品名:"恐怖猎犬"->默认
        	SLEEPING = "这是干掉它的最好时机。",		-- 物品名:"恐怖猎犬"->睡着了
        },
        MUTATED_PENGUIN = 
        {
			DEAD = "它走到了尽头。",		-- 物品名:"月岩企鸥"->死了
			GENERIC = "丑陋的企鹅！",		-- 物品名:"月岩企鸥"->默认
			SLEEPING = "谢天谢地，它在睡觉。",		-- 物品名:"月岩企鸥"->睡着了
		},
        CARRAT = 
        {
        	DEAD = "它走到了尽头。",		-- 物品名:"胡萝卜鼠"->死了 制造描述:"灵巧机敏，富含胡萝卜素。"
        	GENERIC = "胡萝卜有了生命？",		-- 物品名:"胡萝卜鼠"->默认 制造描述:"灵巧机敏，富含胡萝卜素。"
        	HELD = "近看真是不好看。",		-- 物品名:"胡萝卜鼠"->拿在手里 制造描述:"灵巧机敏，富含胡萝卜素。"
        	SLEEPING = "乖乖的胡萝卜鼠。",		-- 物品名:"胡萝卜鼠"->睡着了 制造描述:"灵巧机敏，富含胡萝卜素。"
        },
		BULLKELP_PLANT = 
        {
            GENERIC = "海带可以做很多特色美食。",		-- 物品名:"公牛海带"->默认
            PICKED = "等一会就可以采摘了。",		-- 物品名:"公牛海带"->被采完了
        },
		BULLKELP_ROOT = "种在海里搜获海带。",		-- 物品名:"公牛海带茎"
        KELPHAT = "会弄乱我的头发。",		-- 物品名:"海花冠" 制造描述:"让人神经焦虑的东西。"
		KELP = "没处理的海带味道并不好。",		-- 物品名:"海带叶"
		KELP_COOKED = "海带还是要做汤。",		-- 物品名:"熟海带叶"
		KELP_DRIED = "海带干是不错的小零食。",		-- 物品名:"干海带叶"
		GESTALT = "它在干什么。",		-- 物品名:"虚影"
        GESTALT_GUARD = "它想改变我的思想。",		-- 物品名:"大虚影"
		COOKIECUTTER = "作为舰娘我不喜欢它。",		-- 物品名:"饼干切割机"
		COOKIECUTTERSHELL = "只剩下空壳。",		-- 物品名:"饼干切割机壳"
		COOKIECUTTERHAT = "我无法接受这个帽子的设计。",		-- 物品名:"饼干切割机帽子" 制造描述:"穿着必须犀利。"
		SALTSTACK =
		{
			GENERIC = "盐能够增添美食的风味，保鲜肉类。",		-- 物品名:"盐堆"->默认
			MINED_OUT = "已经收获完了！",		-- 物品名:"盐堆"
			GROWING = "这群盐堆有文艺复兴的感觉。",		-- 物品名:"盐堆"->正在生长
		},
		SALTROCK = "可以给食物提鲜。",		-- 物品名:"盐晶"
		SALTBOX = "可以最大化的防止食物变质。",		-- 物品名:"盐盒" 制造描述:"用盐来储存食物。"
		TACKLESTATION = "可以存放各式钓具。",		-- 物品名:"钓具容器" 制造描述:"传统的用饵钓鱼。"
		TACKLESKETCH = "根据这些图片就可以做钓具了。",		-- 物品名:"{item}广告"
        MALBATROSS = "好大的海鸟！",		-- 物品名:"邪天翁"
        MALBATROSS_FEATHER = "大鸟身上掉落的漂亮羽毛。",		-- 物品名:"邪天翁羽毛"
        MALBATROSS_BEAK = "用它划船动力十足啊。",		-- 物品名:"邪天翁喙"
        MAST_MALBATROSS_ITEM = "为风帆战舰提供十足的动力。",		-- 物品名:"飞翼风帆套装" 制造描述:"像海鸟一样航向深蓝。"
        MAST_MALBATROSS = "远航高歌！",		-- 物品名:"飞翼风帆" 制造描述:"像海鸟一样航向深蓝。"
		MALBATROSS_FEATHERED_WEAVE = "轻盈，柔软，结实的帆布。",		-- 物品名:"羽毛帆布" 制造描述:"精美的羽毛布料。"
        GNARWAIL =
        {
            GENERIC = "这个角真漂亮。",		-- 物品名:"一角鲸"->默认
            BROKENHORN = "哈哈哈，你的角没了！",		-- 物品名:"一角鲸"
            FOLLOWER = "好乖好可爱的鲸鱼。",		-- 物品名:"一角鲸"->追随者
            BROKENHORN_FOLLOWER = "这就是你到处伸角的下场！",		-- 物品名:"一角鲸"
        },
        GNARWAIL_HORN = "不可思议！",		-- 物品名:"一角鲸的角"
        WALKINGPLANK = "没有其他的备用方案吗？",		-- 物品名:"木板"
        OAR = "我不排斥划船但是为什么舰娘需要划船？",		-- 物品名:"桨" 制造描述:"划，划，划小船。"
		OAR_DRIFTWOOD = "我不排斥划船但是为什么舰娘需要划船？ ",		-- 物品名:"浮木桨" 制造描述:"小桨要用浮木造？"
		OCEANFISHINGROD = "这才是货真价实的海钓竿！",		-- 物品名:"海钓竿" 制造描述:"像职业选手一样钓鱼吧。"
		OCEANFISHINGBOBBER_NONE = "可以用浮标提高准度。",		-- 物品名:"鱼钩"
        OCEANFISHINGBOBBER_BALL = "可以提高扔钩的准度。",		-- 物品名:"木球浮标" 制造描述:"经典设计，初学者和职业钓手两相宜。"
        OCEANFISHINGBOBBER_OVAL = "那些鱼跑不掉了！",		-- 物品名:"硬物浮标" 制造描述:"在经典浮标的基础上融入了时尚设计。"
		OCEANFISHINGBOBBER_CROW = "乌鸦羽毛做的浮标。",		-- 物品名:"黑羽浮标" 制造描述:"深受职业钓手的喜爱。"
		OCEANFISHINGBOBBER_ROBIN = "希望能钓到大鱼。",		-- 物品名:"红羽浮标" 制造描述:"深受职业钓手的喜爱。"
		OCEANFISHINGBOBBER_ROBIN_WINTER = "雪鸟的羽毛做的漂亮浮标。",		-- 物品名:"蔚蓝羽浮标" 制造描述:"深受职业钓手的喜爱。"
		OCEANFISHINGBOBBER_CANARY = "符合我身份的金色浮标！",		-- 物品名:"黄羽浮标" 制造描述:"深受职业钓手的喜爱。"
		OCEANFISHINGBOBBER_GOOSE = "看上去就好用的超级浮标！",		-- 物品名:"鹅羽浮标" 制造描述:"高级羽绒浮标。"
		OCEANFISHINGBOBBER_MALBATROSS = "用漂亮羽毛做的浮标。",		-- 物品名:"邪天翁羽浮标" 制造描述:"高级巨鸟浮标。"
		OCEANFISHINGLURE_SPINNER_RED = "根据情况选择钓饵！",		-- 物品名:"日出旋转亮片" 制造描述:"早起的鱼儿有虫吃。"
		OCEANFISHINGLURE_SPINNER_GREEN = "根据情况选择钓饵！",		-- 物品名:"黄昏旋转亮片" 制造描述:"低光照环境里效果最好。"
		OCEANFISHINGLURE_SPINNER_BLUE = "根据情况选择钓饵！",		-- 物品名:"夜间旋转亮片" 制造描述:"适用于夜间垂钓。"
		OCEANFISHINGLURE_SPOON_RED = "根据情况选择钓饵！",		-- 物品名:"日出匙型假饵" 制造描述:"早起的鱼儿有虫吃。"
		OCEANFISHINGLURE_SPOON_GREEN = "根据情况选择钓饵！",		-- 物品名:"黄昏匙型假饵" 制造描述:"在夕阳中继续垂钓。"
		OCEANFISHINGLURE_SPOON_BLUE = "根据情况选择钓饵！",		-- 物品名:"夜间匙型假饵" 制造描述:"适用于夜间垂钓。"
		OCEANFISHINGLURE_HERMIT_RAIN = "雨天专用钓饵。",		-- 物品名:"雨天鱼饵" 制造描述:"留着雨天用。"
		OCEANFISHINGLURE_HERMIT_SNOW = "能够在雪天让鱼儿上钩！",		-- 物品名:"雪天鱼饵" 制造描述:"雪天适合用它钓鱼。"
		OCEANFISHINGLURE_HERMIT_DROWSY = "能够减少鱼儿的挣扎力度！",		-- 物品名:"麻醉鱼饵" 制造描述:"把鱼闷住就抓住了一半。"
		OCEANFISHINGLURE_HERMIT_HEAVY = "专门针对大鱼的鱼饵。",		-- 物品名:"重量级鱼饵" 制造描述:"钓一条大鱼！"
		OCEANFISH_SMALL_1 = "小鱼只能当零食吃。",		-- 物品名:"小孔雀鱼"
		OCEANFISH_SMALL_2 = "这条鱼不够大。",		-- 物品名:"针鼻喷墨鱼"
		OCEANFISH_SMALL_3 = "好小的鱼。",		-- 物品名:"小饵鱼"
		OCEANFISH_SMALL_4 = "小鱼小虾，成不了大气候。",		-- 物品名:"三文鱼苗"
		OCEANFISH_SMALL_5 = "爆米花鱼可还行！",		-- 物品名:"爆米花鱼"
		OCEANFISH_SMALL_6 = "这条鱼是素菜？",		-- 物品名:"落叶比目鱼"
		OCEANFISH_SMALL_7 = "这条鱼在开花！",		-- 物品名:"花朵金枪鱼"
		OCEANFISH_SMALL_8 = "好热！",		-- 物品名:"炽热太阳鱼"
        OCEANFISH_SMALL_9 = "和藤壶共生的鱼。",		-- 物品名:"口水鱼"
		OCEANFISH_MEDIUM_1 = "这条鱼不好看。",		-- 物品名:"泥鱼"
		OCEANFISH_MEDIUM_2 = "花大力气钓的石斑鱼。",		-- 物品名:"斑鱼"
		OCEANFISH_MEDIUM_3 = "这条鱼真不错！",		-- 物品名:"浮夸狮子鱼"
		OCEANFISH_MEDIUM_4 = "鲶鱼可以做不少的美味。",		-- 物品名:"黑鲶鱼"
		OCEANFISH_MEDIUM_5 = "这条鱼看着有些俗气。",		-- 物品名:"玉米鳕鱼"
		OCEANFISH_MEDIUM_6 = "好一条漂亮的大肥鱼！",		-- 物品名:"花锦鲤"
		OCEANFISH_MEDIUM_7 = "好一条漂亮的大肥鱼！",		-- 物品名:"金锦鲤"
		OCEANFISH_MEDIUM_8 = "冰冰凉凉。",		-- 物品名:"冰鲷鱼"
		PONDFISH = "鱼肉考验厨师的水平。",		-- 物品名:"淡水鱼"
		PONDEEL = "这能做一道好菜。",		-- 物品名:"活鳗鱼"
        FISHMEAT = "一块大鱼肉。",		-- 物品名:"生鱼肉"
        FISHMEAT_COOKED = "烤得香喷喷的，加点香料就好了。",		-- 物品名:"鱼排"
        FISHMEAT_SMALL = "一小块鱼肉。",		-- 物品名:"小鱼块"
        FISHMEAT_SMALL_COOKED = "一点点烤鱼肉。",		-- 物品名:"烤小鱼块"
		SPOILED_FISH = "鱼肉变质的味道真不好。",		-- 物品名:"变质的鱼"
		FISH_BOX = "塞满了鱼！",		-- 物品名:"锡鱼罐" 制造描述:"保持鱼与网捕之日一样新鲜。"
        POCKET_SCALE = "简易称重设备。",		-- 物品名:"弹簧秤" 制造描述:"随时称鱼的重量！"
		TACKLECONTAINER = "这件额外的储存工具钩住了我的注意力。",		-- 物品名:"钓具箱" 制造描述:"整齐收纳你的钓具。"
		SUPERTACKLECONTAINER = "它有足够的空间来容纳钓具。",		-- 物品名:"超级钓具箱" 制造描述:"更多收纳钓具的空间？我上钩了！"
		TROPHYSCALE_FISH =
		{
			GENERIC = "来瞻仰我今天的海钓成绩吧！",		-- 物品名:"鱼类计重器"->默认 制造描述:"炫耀你的斩获。"
			HAS_ITEM = "重量: {weight}\n捕获人: {owner}",		-- 物品名:"鱼类计重器" 制造描述:"炫耀你的斩获。"
			HAS_ITEM_HEAVY = "重量: {weight}\n捕获人: {owner}\n所获颇丰!",		-- 物品名:"鱼类计重器" 制造描述:"炫耀你的斩获。"
			BURNING = "需要赶紧灭火，不然我的成果就没有了。",		-- 物品名:"鱼类计重器"->正在燃烧 制造描述:"炫耀你的斩获。"
			BURNT = "我辛辛苦苦钓的鱼！",		-- 物品名:"鱼类计重器"->烧焦的 制造描述:"炫耀你的斩获。"
			OWNER = "我就是如此完美……\n重量: {weight}\n捕获人: {owner}",		-- 物品名:"鱼类计重器" 制造描述:"炫耀你的斩获。"
			OWNER_HEAVY = "重量: {weight}\n捕获人: {owner}\n还真抓了条大肥鱼！",		-- 物品名:"鱼类计重器" 制造描述:"炫耀你的斩获。"
		},
		OCEANFISHABLEFLOTSAM = "泥和草纠缠到了一起。",		-- 物品名:"海洋残骸"
		CALIFORNIAROLL = "东方的食物，似乎吃起来需要一定的讲究！",		-- 物品名:"加州卷"
		SEAFOODGUMBO = "鱼虾番茄洋葱炖煮出的美味。",		-- 物品名:"海鲜浓汤"
		SURFNTURF = "我已经很久没有吃这种食物了！",		-- 物品名:"海鲜牛排"
        WOBSTER_SHELLER = "一只调皮的大龙虾。", 		-- 物品名:"龙虾"
        WOBSTER_DEN = "龙虾们的窝。",		-- 物品名:"龙虾窝"
        WOBSTER_SHELLER_DEAD = "这烹饪出来应该挺不错的。",		-- 物品名:"死龙虾"
        WOBSTER_SHELLER_DEAD_COOKED = "我等不及要吃龙虾了。",		-- 物品名:"美味的龙虾"
        LOBSTERBISQUE = "普通的龙虾汤，保留了最纯真的鲜味。",		-- 物品名:"龙虾汤"
        LOBSTERDINNER = "与长官婚礼上烛光晚宴的压轴美食。",		-- 物品名:"龙虾正餐"
        WOBSTER_MOONGLASS = "好一只调皮的月光龙虾。",		-- 物品名:"月光龙虾"
        MOONGLASS_WOBSTER_DEN = "里面有月光龙虾的一块月光玻璃。",		-- 物品名:"月光玻璃窝"
		TRIDENT = "和我的三联主炮一样时髦。",		-- 物品名:"刺耳三叉戟" 制造描述:"在汹涌波涛中引领潮流吧！"
		WINCH =
		{
			GENERIC = "海上起重平台。",		-- 物品名:"夹夹绞盘"->默认 制造描述:"让它帮你捞起重的东西吧。"
			RETRIEVING_ITEM = "重活就交给它干吧。",		-- 物品名:"夹夹绞盘" 制造描述:"让它帮你捞起重的东西吧。"
			HOLDING_ITEM = "让我看看这里是什么东西？",		-- 物品名:"夹夹绞盘" 制造描述:"让它帮你捞起重的东西吧。"
		},
        HERMITHOUSE =
         {
            GENERIC = "好破旧的家。",		-- 物品名:"隐士之家"->默认
            BUILTUP = "需要准备不少材料！",		-- 物品名:"隐士之家"
        }, 
        SHELL_CLUSTER = "我喜欢里面的贝壳。",		-- 物品名:"贝壳堆"
		SINGINGSHELL_OCTAVE3 =
		{
			GENERIC = "调有点低。",		-- 物品名:"低音贝壳钟"->默认
		},
		SINGINGSHELL_OCTAVE4 =
		{
			GENERIC = "亚得里亚海的声音。",		-- 物品名:"中音贝壳钟"->默认
		},
		SINGINGSHELL_OCTAVE5 =
		{
			GENERIC = "它可以发出高音C。",		-- 物品名:"高音贝壳钟"->默认
        },
        CHUM = "聚集吸引鱼儿的美味佳肴！",		-- 物品名:"鱼食" 制造描述:"鱼儿的美食。"
        SUNKENCHEST =
        {
            GENERIC = "宝箱里是什么呢。",		-- 物品名:"沉底宝箱"->默认
            LOCKED = "贝壳闭上了！",		-- 物品名:"沉底宝箱"->锁住了
        },
        HERMIT_BUNDLE = "她有不少这样的东西。",		-- 物品名:"一包谢意"
        HERMIT_BUNDLE_SHELLS = "她确实是卖海贝壳的！",		-- 物品名:"贝壳钟包" 制造描述:"她卖的贝壳。"
        RESKIN_TOOL = "有特殊作用的扫把！",		-- 物品名:"清洁扫把" 制造描述:"把装潢的东西清扫的干干净净。"
        MOON_FISSURE_PLUGGED = "这方法挺有效。",		-- 物品名:"堵住的裂隙"
        WOBYBIG = 
        {
            "它刚刚吃了些什么？",		-- 物品名:"沃比" 制造描述:未找到
            "它刚刚吃了些什么？",		-- 物品名:"沃比" 制造描述:未找到
        },
        WOBYSMALL = 
        {
            "我也很喜欢小狗。",		-- 物品名:"沃比" 制造描述:未找到
            "我也很喜欢小狗。",		-- 物品名:"沃比" 制造描述:未找到
        },
		WALTERHAT = "这帽子不错。",		-- 物品名:"松树先锋队帽子" 制造描述:"形式和功能高于时尚。"
		SLINGSHOT = "玩具武器，简单可靠。",		-- 物品名:"可靠的弹弓" 制造描述:"不带它千万别去冒险！"
		SLINGSHOTAMMO_ROCK = "简单，低效的弹药。",				-- 物品名:"鹅卵石" 制造描述:"简单，低效。"
		SLINGSHOTAMMO_MARBLE = "坚硬的弹药。",				-- 物品名:"大理石弹" 制造描述:"可别把它们弄丢了！"
		SLINGSHOTAMMO_THULECITE = "奇怪的弹药。",			-- 物品名:"诅咒弹药" 制造描述:"会出什么问题？"
        SLINGSHOTAMMO_GOLD = "合适的弹药。",		-- 物品名:"黄金弹药" 制造描述:"因为高级，所以有效。"
        SLINGSHOTAMMO_SLOW = "？？？魔法的弹药。",		-- 物品名:"减速弹药" 制造描述:"什么是“物理定律”？"
        SLINGSHOTAMMO_FREEZE = "冰魔法弹药。",		-- 物品名:"冰冻弹药" 制造描述:"把敌人冰冻在原地。"
		SLINGSHOTAMMO_POOP = "粪便弹道。",		-- 物品名:"便便弹" 制造描述:"恶心，但是能让敌人分心。"
        PORTABLETENT = "我感觉已经几辈子没睡过好觉了！",		-- 物品名:"宿营帐篷" 制造描述:"便捷的保护设备，让你免受风吹雨打。"
        PORTABLETENT_ITEM = "有了帐篷可不要膨胀。",		-- 物品名:"帐篷卷" 制造描述:"便捷的保护设备，让你免受风吹雨打。"
        BATTLESONG_DURABILITY = "我喜欢和长官去欣赏舞台剧。",		-- 物品名:"武器化的颤音" 制造描述:"让武器有更多的时间成为焦点。"
        BATTLESONG_HEALTHGAIN = "我喜欢和长官去欣赏舞台剧。",		-- 物品名:"心碎歌谣" 制造描述:"一首偷心的颂歌。"
        BATTLESONG_SANITYGAIN = "我喜欢和长官去欣赏舞台剧。",		-- 物品名:"醍醐灌顶华彩" 制造描述:"用歌声慰藉你的心灵。"
        BATTLESONG_SANITYAURA = "我喜欢和长官去欣赏舞台剧。",		-- 物品名:"英勇美声颂" 制造描述:"无所畏惧！"
        BATTLESONG_FIRERESISTANCE = "希望港区的大家都来看。",		-- 物品名:"防火假声" 制造描述:"抵御火辣的戏评人。"
        BATTLESONG_INSTANT_TAUNT = "这个剧目不能带妹妹们来看。",		-- 物品名:"粗鲁插曲" 制造描述:"用言语扔一个番茄。"
        BATTLESONG_INSTANT_PANIC = "这个剧目可以带妹妹们来看，希望他们喜欢。",		-- 物品名:"惊心独白" 制造描述:"如此出色的表演，就问你怕不怕。"
		GHOSTLYELIXIR_SLOWREGEN = "奇怪的药剂。",		-- 物品名:"亡者补药" 制造描述:"时间会抚平所有伤口。"
		GHOSTLYELIXIR_FASTREGEN = "治疗灵魂的药剂。",		-- 物品名:"灵魂万灵药" 制造描述:"治疗重伤的强力药剂。"
		GHOSTLYELIXIR_SHIELD = "？的药剂。",		-- 物品名:"不屈药剂" 制造描述:"保护你的姐妹不受伤害。"
		GHOSTLYELIXIR_ATTACK = "黑暗的药剂。",		-- 物品名:"夜影万金油" 制造描述:"召唤黑暗的力量。"
		GHOSTLYELIXIR_SPEED = "离谱的药剂。",		-- 物品名:"强健精油" 制造描述:"给你的灵魂来一剂强心针。"
		GHOSTLYELIXIR_RETALIATION = "特殊功能的药剂。",		-- 物品名:"蒸馏复仇" 制造描述:"对敌人以牙还牙。"
		SISTURN =
		{
			GENERIC = "罗马早已经可以独当一面了。",		-- 物品名:"姐妹骨灰罐"->默认 制造描述:"让你疲倦的灵魂休息的地方。"
			SOME_FLOWERS = "多拿些花来应该就可以了。",		-- 物品名:"姐妹骨灰罐" 制造描述:"让你疲倦的灵魂休息的地方。"
			LOTS_OF_FLOWERS = "需要花。",		-- 物品名:"姐妹骨灰罐" 制造描述:"让你疲倦的灵魂休息的地方。"
		},
        WORTOX_SOUL = "only_used_by_wortox", --only wortox can inspect souls		-- 物品名:"灵魂"
        PORTABLECOOKPOT_ITEM =
        {
            GENERIC = "法式珐琅锅，不过也有意大利品牌的。",		-- 物品名:"便携烹饪锅"->默认 制造描述:"随时随地为美食家服务。"
            DONE = "美味制作完成！",		-- 物品名:"便携烹饪锅"->完成了 制造描述:"随时随地为美食家服务。"
			COOKING_LONG = "我耐心等待。",		-- 物品名:"便携烹饪锅"->饭还需要很久 制造描述:"随时随地为美食家服务。"
			COOKING_SHORT = "马上就能好了！",		-- 物品名:"便携烹饪锅"->饭快做好了 制造描述:"随时随地为美食家服务。"
			EMPTY = "我打赌里面什么是空的。",		-- 物品名:"便携烹饪锅" 制造描述:"随时随地为美食家服务。"
        },
        PORTABLEBLENDER_ITEM = "把原料研磨成香料。",		-- 物品名:"便携研磨器" 制造描述:"把原料研磨成粉状调味品。"
        PORTABLESPICER_ITEM =
        {
            GENERIC = "调味粉！香喷喷。",		-- 物品名:"便携香料站"->默认 制造描述:"调味让饭菜更可口。"
            DONE = "好的调味料让饭菜更可口。",		-- 物品名:"便携香料站"->完成了 制造描述:"调味让饭菜更可口。"
        },
        SPICEPACK = "好可爱的袋子！",		-- 物品名:"厨师袋" 制造描述:"使你的食物保持新鲜。"
        SPICE_GARLIC = "蒜粉为美食提供风味。",		-- 物品名:"蒜粉" 制造描述:"用口臭防守是最好的进攻。"
        SPICE_SUGAR = "我喜欢蜂蜜！",		-- 物品名:"蜂蜜水晶" 制造描述:"令人心平气和的甜美。"
        SPICE_CHILI = "吃了之后感觉可以喷火。",		-- 物品名:"辣椒面" 制造描述:"刺激十足的粉末。"
        SPICE_SALT = "盐粉激发食物的鲜香。",		-- 物品名:"调味盐" 制造描述:"为你的饭菜加点咸味。"
        MONSTERTARTARE = "只能说是糟糕的法餐。",		-- 物品名:"怪物鞑靼"
        FRESHFRUITCREPES = "法式卷饼，味道确实不错。",		-- 物品名:"鲜果可丽饼"
        FROGFISHBOWL = "法式蓝带猪排的变种么。。。",		-- 物品名:"蓝带鱼排"
        POTATOTORNADO = "旋风土豆串零食！",		-- 物品名:"花式回旋块茎"
        DRAGONCHILISALAD = "帮助我抵御寒冷的侵袭。",		-- 物品名:"辣龙椒沙拉"
        GLOWBERRYMOUSSE = "吃了之后就可以在夜间看清四周了。",		-- 物品名:"发光浆果慕斯"
        VOLTGOATJELLY = "电力为我提供力量。",		-- 物品名:"伏特羊肉冻"
        NIGHTMAREPIE = "法国佬都吃这些东西吗？",		-- 物品名:"恐怖国王饼"
        BONESOUP = "满满的营养丰富的一大锅汤。",		-- 物品名:"骨头汤"
        MASHEDPOTATOES = "这个小吃我也会做。",		-- 物品名:"奶油土豆泥"
        POTATOSOUFFLE = "可口的法式小吃。",		-- 物品名:"蓬松土豆蛋奶酥"
        MOQUECA = "唔，喝完之后感觉浑身充满了力量。",		-- 物品名:"海鲜杂烩"
        GAZPACHO = "西班牙特色冷汤小吃。",		-- 物品名:"芦笋冷汤"
        ASPARAGUSSOUP = "鲜芦笋的味道真不错。",		-- 物品名:"芦笋汤"
        VEGSTINGER = "用最新鲜的蔬菜做的蔬菜饮料。",		-- 物品名:"蔬菜鸡尾酒"
        BANANAPOP = "兼顾软硬的小吃。",		-- 物品名:"香蕉冻"
        CEVICHE = "需要加入柠檬和海盐。",		-- 物品名:"酸橘汁腌鱼"
        SALSA = "西红柿和洋葱的风味精妙结合到了一起。",		-- 物品名:"生鲜萨尔萨酱"
        PEPPERPOPPER = "将肉馅填到辣椒中烹饪的产物！",		-- 物品名:"爆炒填馅辣椒"
        TURNIP = "是个大萝卜。",		-- 物品名:"大萝卜"
        TURNIP_COOKED = "美食的实践。",		-- 物品名:"烤大萝卜"
        TURNIP_SEEDS = "大萝卜种子。",		-- 物品名:"圆形种子"
        GARLIC = "吃完要漱口。",		-- 物品名:"大蒜"
        GARLIC_COOKED = "它应该和其他菜一起烹饪。",		-- 物品名:"烤大蒜"
        GARLIC_SEEDS = "大蒜种子。",		-- 物品名:"种子荚"
        ONION = "让我流泪。",		-- 物品名:"洋葱"
        ONION_COOKED = "用来烤肉味道更好。",		-- 物品名:"烤洋葱"
        ONION_SEEDS = "洋葱种子。",		-- 物品名:"尖形种子"
        POTATO = "土豆是很棒的主食。",		-- 物品名:"土豆"
        POTATO_COOKED = "可以加点香葱和蒜。",		-- 物品名:"烤土豆"
        POTATO_SEEDS = "土豆种子。",		-- 物品名:"毛茸茸的种子"
        TOMATO = "富含营养，可口多汁。",		-- 物品名:"番茄"
        TOMATO_COOKED = "番茄做鱼汤最合适了。",		-- 物品名:"烤番茄"
        TOMATO_SEEDS = "番茄种子。",		-- 物品名:"带刺的种子"
        ASPARAGUS = "我曾经不喜欢吃芦笋。", 		-- 物品名:"芦笋"
        ASPARAGUS_COOKED = "但是品尝了以后逐渐能够接受了。",		-- 物品名:"烤芦笋"
        ASPARAGUS_SEEDS = "芦笋种子。",		-- 物品名:"筒状种子"
        PEPPER = "来自美洲的作物。",		-- 物品名:"辣椒"
        PEPPER_COOKED = "我可不想吃这个。",		-- 物品名:"烤辣椒"
        PEPPER_SEEDS = "辣椒种子。",		-- 物品名:"块状种子"
        WEREITEM_BEAVER = "海狸的诅咒吗。",		-- 物品名:"俗气海狸像" 制造描述:"唤醒海狸人的诅咒"
        WEREITEM_GOOSE = "它让我浑身起鸡皮疙瘩。",		-- 物品名:"俗气鹅像" 制造描述:"唤醒鹅人的诅咒"
        WEREITEM_MOOSE = "我觉得这是受诅咒的鹿。",		-- 物品名:"俗气鹿像" 制造描述:"唤醒鹿人的诅咒"
        MERMHAT = "我能够涉足鱼人社会了。",		-- 物品名:"聪明的伪装" 制造描述:"鱼人化你的朋友。"
        MERMTHRONE =
        {
            GENERIC = "沼泽之王！",		-- 物品名:"皇家地毯"->默认
            BURNT = "什么都不剩了。",		-- 物品名:"皇家地毯"->烧焦的
        },        
        MERMTHRONE_CONSTRUCTION =
        {
            GENERIC = "我们的小个子朋友似乎准备建立一个傀儡政权。",		-- 物品名:"皇家手工套装"->默认 制造描述:"建立一个新的鱼人王朝。"
            BURNT = "烧焦的牛毛和猪皮的味道。",		-- 物品名:"皇家手工套装"->烧焦的 制造描述:"建立一个新的鱼人王朝。"
        },        
        MERMHOUSE_CRAFTED = 
        {
            GENERIC = "有一定的设计感。",		-- 物品名:"鱼人工艺屋"->默认 制造描述:"适合鱼人的家。"
            BURNT = "这真不好闻！",		-- 物品名:"鱼人工艺屋"->烧焦的 制造描述:"适合鱼人的家。"
        },
        MERMWATCHTOWER_REGULAR = "他们找到了国王后高兴了起来。",		-- 物品名:"鱼人工艺屋" 制造描述:"适合鱼人的家。"
        MERMWATCHTOWER_NOKING = "鱼人守卫没有国王。",		-- 物品名:"鱼人工艺屋" 制造描述:"适合鱼人的家。"
        MERMKING = "看上去它不过是一个傀儡。",		-- 物品名:"鱼人之王"
        MERMGUARD = "但是这些护卫的战斗力确实不错。",		-- 物品名:"忠诚鱼人守卫"
        MERM_PRINCE = "他们的选举过程很朴素。",		-- 物品名:"过程中的皇室"
        SQUID = "这鱿鱼还会发光。",		-- 物品名:"鱿鱼"
		GHOSTFLOWER = "小幽灵的回报。",		-- 物品名:"哀悼荣耀"
        SMALLGHOST = "看上去它有些害怕。",		-- 物品名:"小惊吓"
        CRABKING = 
        {
            GENERIC = "这个螃蟹看上去好大。",		-- 物品名:"帝王蟹"->默认
            INERT = "我要用宝石来点缀这座城堡。",		-- 物品名:"帝王蟹"
        },
		CRABKING_CLAW = "蟹爪会毁掉我的船",		-- 物品名:"巨钳"
		MESSAGEBOTTLE = "长官送给我的信？",		-- 物品名:"瓶中信"
		MESSAGEBOTTLEEMPTY = "一个空瓶子。",		-- 物品名:"空瓶子"
        MEATRACK_HERMIT =
        {
             DONE = "晒肉架做好了。",		-- 物品名:"晾肉架"->完成了 制造描述:"晾肉的架子。"
            DRYING = "需要耐心。",		-- 物品名:"晾肉架"->正在风干 制造描述:"晾肉的架子。"
            DRYINGINRAIN = "空气太潮湿了。",		-- 物品名:"晾肉架"->雨天风干 制造描述:"晾肉的架子。"
            GENERIC = "可以晾晒肉和海带。",		-- 物品名:"晾肉架"->默认 制造描述:"晾肉的架子。"
            BURNT = "需要重新再做一个了。",		-- 物品名:"晾肉架"->烧焦的 制造描述:"晾肉的架子。"
            DONE_NOTMEAT = "晒成的肉干味道更好也更便于储存。",		-- 物品名:"晾肉架" 制造描述:"晾肉的架子。"
            DRYING_NOTMEAT = "美味的烟熏风干肉。",		-- 物品名:"晾肉架" 制造描述:"晾肉的架子。"
            DRYINGINRAIN_NOTMEAT = "等晴天吧。",		-- 物品名:"晾肉架" 制造描述:"晾肉的架子。"
        },
        BEEBOX_HERMIT =
        {
            READY = "可以生产美味的蜂蜜。",		-- 物品名:"蜂箱"->准备好的 满的 制造描述:"贮存你自己的蜜蜂。"
			FULLHONEY = "那群小家伙肯定羡慕这么多甜食。",		-- 物品名:"蜂箱"->蜂蜜满了 制造描述:"贮存你自己的蜜蜂。"
			GENERIC = "有蜂箱就是好！",		-- 物品名:"蜂箱"->默认 制造描述:"贮存你自己的蜜蜂。"
			NOHONEY = "它是空的。",		-- 物品名:"蜂箱"->没有蜂蜜 制造描述:"贮存你自己的蜜蜂。"
			SOMEHONEY = "我需要等一会。",		-- 物品名:"蜂箱"->有一些蜂蜜 制造描述:"贮存你自己的蜜蜂。"
			BURNT = "这是不小的浪费。",		-- 物品名:"蜂箱"->烧焦的 制造描述:"贮存你自己的蜜蜂。"
        },
        HERMITCRAB = "一个人无论怎么样都会寂寞的。",		-- 物品名:"寄居蟹隐士"
        HERMIT_PEARL = "我会保护好它的。",		-- 物品名:"珍珠的珍珠"
        HERMIT_CRACKED_PEARL = "我失败了。",		-- 物品名:"开裂珍珠"
        WATERPLANT = "这海草长得有点奇特。",		-- 物品名:"海草"
        WATERPLANT_BOMB = "海草的种子吧。",		-- 物品名:"种壳"
        WATERPLANT_BABY = "还在萌芽阶段的海草。",		-- 物品名:"海芽"
        WATERPLANT_PLANTER = "可以种在岩石上。",		-- 物品名:"海芽插穗"
        SHARK = "鲨鱼没有资格挑战我。",		-- 物品名:"岩石大白鲨"
        MASTUPGRADE_LAMP_ITEM = "船上照明设备。",		-- 物品名:"甲板照明灯" 制造描述:"桅杆照明附件。"
        MASTUPGRADE_LIGHTNINGROD_ITEM = "闪电无法威胁到我的船了。",		-- 物品名:"避雷导线" 制造描述:"为你的桅杆带来过电般的刺激。"
        WATERPUMP = "手摇式灭火器。",		-- 物品名:"消防泵" 制造描述:"水水水，到处都是水！"
        BARNACLE = "作为舰娘我不喜欢藤壶。",		-- 物品名:"藤壶"
        BARNACLE_COOKED = "肉还是有点少。",		-- 物品名:"熟藤壶"
        BARNACLEPITA = "很有嚼劲的皮塔饼，我喜欢加入鸡肉和金枪鱼。",		-- 物品名:"藤壶皮塔饼"
        BARNACLESUSHI = "日式美食吗，确实很精致。",		-- 物品名:"藤壶握寿司"
        BARNACLINGUINE = "细面和意大利面一样都有自己的特色。",		-- 物品名:"藤壶中细面"
        BARNACLESTUFFEDFISHHEAD = "我不怎么想吃鱼头。",		-- 物品名:"酿鱼头"
        LEAFLOAF = "透明的蔬菜肉冻。",		-- 物品名:"叶肉糕"
        LEAFYMEATBURGER = "我觉得这样的烹饪方式有些浪费，不过味道还可以。",		-- 物品名:"素食堡"
        LEAFYMEATSOUFFLE = "软软甜甜的真好吃！",		-- 物品名:"果冻沙拉"
        MEATYSALAD = "管饱的美味蔬菜沙拉。",		-- 物品名:"牛肉绿叶菜"
		MOLEBAT = "这个动物长得好奇怪。",		-- 物品名:"裸鼹鼠蝙蝠"
        MOLEBATHILL = "我并不知道那个老鼠窝里藏了什么。",		-- 物品名:"裸鼹鼠蝙蝠山丘"
        BATNOSE = "似乎是那个奇怪动物的鼻孔。",		-- 物品名:"裸露鼻孔"
        BATNOSE_COOKED = "虽然我不排斥新型食材，但是这个确实有些离谱。",		-- 物品名:"炭烤鼻孔"
        BATNOSEHAT = "这个帽子的设计风格有些后现代。",		-- 物品名:"牛奶帽"
        MUSHGNOME = "它会周期性的发起旋转攻击。",		-- 物品名:"蘑菇地精"
        SPORE_MOON = "我会离这些孢子远一点。",		-- 物品名:"月亮孢子"
        MOON_CAP = "看起来不怎么好吃。",		-- 物品名:"月亮蘑菇"
        MOON_CAP_COOKED = "看上去一点营养都没有。",		-- 物品名:"熟月亮蘑菇"
        MUSHTREE_MOON = "这颗蘑菇树像是受到了变异。",		-- 物品名:"月亮蘑菇树"
        LIGHTFLIER = "装在我的口袋里的发光飞虫！",		-- 物品名:"球状光虫"
        GROTTO_POOL_BIG = "这里的水硅酸盐含量有点超标了。",		-- 物品名:"玻璃绿洲"
        GROTTO_POOL_SMALL = "这里的水硅酸盐含量有点超标了。",		-- 物品名:"小玻璃绿洲"
        DUSTMOTH = "真是些整齐的小家伙。",		-- 物品名:"尘蛾"
        DUSTMOTHDEN = "它们在里面过得很舒服。",		-- 物品名:"整洁洞穴"
        ARCHIVE_LOCKBOX = "我怎么把知识取出来呢？",		-- 物品名:"蒸馏的知识"
        ARCHIVE_CENTIPEDE = "它想阻止我的计划。",		-- 物品名:"远古哨兵蜈蚣"
        ARCHIVE_CENTIPEDE_HUSK = "它目前缺少驱动它运动的能量。",		-- 物品名:"哨兵蜈蚣壳"
        ARCHIVE_COOKPOT =
        {
            COOKING_LONG = "美食需要时间。",		-- 物品名:"远古窑"->饭还需要很久
            COOKING_SHORT = "我有耐心！",		-- 物品名:"远古窑"->饭快做好了
            DONE = "嗯！可以吃了！",		-- 物品名:"远古窑"->完成了
            EMPTY = "把上面的灰尘搽干净。",		-- 物品名:"远古窑"
            BURNT = "锅给烧没了。",		-- 物品名:"远古窑"->烧焦的
        },
        ARCHIVE_MOON_STATUE = "这些宏伟的月亮雕像让我充满了诗意。",		-- 物品名:"远古月亮雕像"
        ARCHIVE_RUNE_STATUE = 
        {
            LINE_1 = "我看不懂！",		-- 物品名:"远古月亮符文石"->第一行
            LINE_2 = "这些标记看起来与其他废墟中的标记不同。",		-- 物品名:"远古月亮符文石"->第二行
            LINE_3 = "它上面写的是什么东西！",		-- 物品名:"远古月亮符文石"->第三行
            LINE_4 = "这些标记看起来与其他废墟中的标记不同。",		-- 物品名:"远古月亮符文石"->第四行
            LINE_5 = "如此多的知识，我要是能看懂就好了！",		-- 物品名:"远古月亮符文石"->第五行
        },        
        ARCHIVE_RESONATOR = 
        {
            GENERIC = "能够探测天体能量。",		-- 物品名:"天体探测仪"->默认
            IDLE = "好像是找到了。",		-- 物品名:"天体探测仪"
        },
        ARCHIVE_RESONATOR_ITEM = "这个是一种雷达设备？ ",		-- 物品名:"天体探测仪" 制造描述:"它会出土什么秘密呢？"
        ARCHIVE_LOCKBOX_DISPENCER = 
        {
          POWEROFF = "现在它好像还缺少能量。",		-- 物品名:"知识饮水机"
          GENERIC =  "我并不想说明我觉得它长得像什么。",		-- 物品名:"知识饮水机"->默认
        },
        ARCHIVE_SECURITY_DESK = 
        {
            POWEROFF = "它已经失去了从前的作用。",		-- 物品名:"远古哨所"
            GENERIC = "它想接近我。",		-- 物品名:"远古哨所"->默认
        },
        ARCHIVE_SECURITY_PULSE = "这是要到那里去呢",		-- 物品名:"远古哨所"
        ARCHIVE_SWITCH = 
        {
            VALID = "可以看到宝石提供了它的能量。",		-- 物品名:"华丽基座"->有效
            GEMS = "需要放上宝石。",		-- 物品名:"华丽基座"->需要宝石
        },
        ARCHIVE_PORTAL = 
        {
            POWEROFF = "好奇怪，一点反应都没有。",		-- 物品名:"封印的传送门"
            GENERIC = "奇怪，电源是开着的，但它却没反应。",		-- 物品名:"封印的传送门"->默认
        },
        WALL_STONE_2 = "不错的墙。",		-- 物品名:"档案馆石墙"
        WALL_RUINS_2 = "一段古老的墙。",		-- 物品名:"档案馆铥墙"
        REFINED_DUST = "啊——嚏！",		-- 物品名:"尘土块" 制造描述:"远古甜品的关键原料。"
        DUSTMERINGUE = "这玩意谁会愿意吃？",		-- 物品名:"琥珀美食"
        SHROOMCAKE = "这能称为蛋糕吗。",		-- 物品名:"蘑菇蛋糕"
        NIGHTMAREGROWTH = "这块城墙让人感到未知的恐惧。",		-- 物品名:"梦魇城墙"
        TURFCRAFTINGSTATION = "能够建造全新的土地类型了！",		-- 物品名:"土地夯实器" 制造描述:"一点点的改变世界。"
        MOON_ALTAR_LINK = "这是什么。",		-- 物品名:"神秘能量"
        COMPOSTINGBIN =
        {
            GENERIC = "利用发酵将有机物降解称为便于吸收的肥料。",		-- 物品名:"堆肥桶"->默认 制造描述:"能让土壤变得臭烘烘和肥沃。"
            WET = "湿垃圾加的有点多。",		-- 物品名:"堆肥桶" 制造描述:"能让土壤变得臭烘烘和肥沃。"
            DRY = "太干了，不好。",		-- 物品名:"堆肥桶" 制造描述:"能让土壤变得臭烘烘和肥沃。"
            BALANCED = "恰到好处！",		-- 物品名:"堆肥桶" 制造描述:"能让土壤变得臭烘烘和肥沃。"
            BURNT = "味道更难闻了。",		-- 物品名:"堆肥桶"->烧焦的 制造描述:"能让土壤变得臭烘烘和肥沃。"
        },
        COMPOST = "植物生长需要的有机发酵肥料。",		-- 物品名:"堆肥"
        SOIL_AMENDER = 
		{ 
			GENERIC = "发酵需要一定的时间。",		-- 物品名:"催长剂起子"->默认 制造描述:"海里来的瓶装养分。"
			STALE = "它在制造植物需要的肥料!",		-- 物品名:"催长剂起子"->过期了 制造描述:"海里来的瓶装养分。"
			SPOILED = "发酵结束了，可以用了！",		-- 物品名:"催长剂起子"->腐烂了 制造描述:"海里来的瓶装养分。"
		},
		SOIL_AMENDER_FERMENTED = "看上去很不错的肥料！",		-- 物品名:"超级催长剂"
        WATERINGCAN = 
        {
            GENERIC = "可以用来浇水和灭火。",		-- 物品名:"空浇水壶"->默认 制造描述:"让植物保持快乐和水分。"
            EMPTY = "需要一个池塘来加水。",		-- 物品名:"空浇水壶" 制造描述:"让植物保持快乐和水分。"
        },
        PREMIUMWATERINGCAN =
        {
            GENERIC = "用鸟类部位改良的超级水壶！",		-- 物品名:"空鸟嘴壶"->默认 制造描述:"灌溉方面的创新!"
            EMPTY = "没水了。",		-- 物品名:"空鸟嘴壶" 制造描述:"灌溉方面的创新!"
        },
		FARM_PLOW = "便携式耕地设备。",		-- 物品名:"耕地机"
		FARM_PLOW_ITEM = "选择合适的地方放下去吧。",		-- 物品名:"耕地机" 制造描述:"为你的植物犁一块地。"
		FARM_HOE = "需要先锄地挖出土坑。",		-- 物品名:"园艺锄" 制造描述:"翻耕，为撒播农作物做准备。"
		GOLDEN_FARM_HOE = "这个挖坑更加高雅。",		-- 物品名:"黄金园艺锄" 制造描述:"优雅地耕地。"
		NUTRIENTSGOGGLESHAT = "记录土壤肥料和种子的知识。",		-- 物品名:"高级耕作先驱帽" 制造描述:"让你看到一个成功的花园。"
		PLANTREGISTRYHAT = "科学要从实验走向理论。。",		-- 物品名:"耕作先驱帽" 制造描述:"让你的园艺专业知识得到增长。"
        FARM_SOIL_DEBRIS = "这些杂物把我的田地弄得很糟。",		-- 物品名:"农田杂物"
		FIRENETTLES = "讨厌的火焰杂草。",		-- 物品名:"火荨麻叶"
		FORGETMELOTS = "一种有淡香的杂草。",		-- 物品名:"必忘我"
		SWEETTEA = "虽然我比较喜欢咖啡。",		-- 物品名:"舒缓茶"
		TILLWEED = "它会让农田一团糟",		-- 物品名:"犁地草"
		TILLWEEDSALVE = "作为药膏它效果并不好。",		-- 物品名:"犁地草膏" 制造描述:"慢慢去处病痛。"
		TROPHYSCALE_OVERSIZEDVEGGIES =
		{
			GENERIC = "称量巨大作物的重量。",		-- 物品名:"农产品秤"->默认 制造描述:"称量你珍贵的水果和蔬菜。"
			HAS_ITEM = "重量: {weight}\n收获日: {day}\n不赖。",		-- 物品名:"农产品秤" 制造描述:"称量你珍贵的水果和蔬菜。"
			HAS_ITEM_HEAVY = "重量: {weight}\n收获日: {day}\n谁能想到会长这么大？",		-- 物品名:"农产品秤" 制造描述:"称量你珍贵的水果和蔬菜。"
            HAS_ITEM_LIGHT = "它太一般了，秤都懒得告诉我它的重量。",		-- 物品名:"农产品秤" 制造描述:"称量你珍贵的水果和蔬菜。"
			BURNING = "需要尽快灭火。",		-- 物品名:"农产品秤"->正在燃烧 制造描述:"称量你珍贵的水果和蔬菜。"
			BURNT = "我的作物和称。。。",		-- 物品名:"农产品秤"->烧焦的 制造描述:"称量你珍贵的水果和蔬菜。"
        },
        CARROT_OVERSIZED = "这个胡萝卜真的大，可以做很多菜!",		-- 物品名:"巨型胡萝卜"
        CORN_OVERSIZED = "玉米作为主食也是不错的选择！",		-- 物品名:"巨型玉米"
        PUMPKIN_OVERSIZED = "它和意大利南瓜长得很不一样。",		-- 物品名:"巨型南瓜"
        EGGPLANT_OVERSIZED = "我想用它做焖茄子。",		-- 物品名:"巨型茄子"
        DURIAN_OVERSIZED = "我并不喜欢这个水果。",		-- 物品名:"巨型榴莲"
        POMEGRANATE_OVERSIZED = "相比之下它更像是雕塑。",		-- 物品名:"巨型石榴"
        DRAGONFRUIT_OVERSIZED = "火龙果味道很棒。",		-- 物品名:"巨型火龙果"
        WATERMELON_OVERSIZED = "好大的西瓜啊，够吃好一阵了。",		-- 物品名:"巨型西瓜"
        TOMATO_OVERSIZED = "意大利番茄的品种超过了三百多种，我爱番茄。",		-- 物品名:"巨型番茄"
        POTATO_OVERSIZED = "土豆总是好的，吃土豆总没错。",		-- 物品名:"巨型土豆"
        ASPARAGUS_OVERSIZED = "芦笋对身体好。",		-- 物品名:"巨型芦笋"
        ONION_OVERSIZED = "洋葱是肉的最佳伴侣。。",		-- 物品名:"巨型洋葱"
        GARLIC_OVERSIZED = "我从来没看到过这么大的大蒜。",		-- 物品名:"巨型大蒜"
        PEPPER_OVERSIZED = "好大的辣椒啊，能吃好久。",		-- 物品名:"巨型辣椒"
        VEGGIE_OVERSIZED_ROTTEN = "多么可怕的浪费啊。",		-- 物品名:"农产品秤" 制造描述:"称量你珍贵的水果和蔬菜。"
		FARM_PLANT =
		{
			GENERIC = "一株植物！",		-- 物品名:未找到
			SEED = "耐心等一下就好了。",		-- 物品名:未找到
			GROWING = "长吧长吧，我的植物！",		-- 物品名:未找到
			FULL = "收获的季节了。",		-- 物品名:未找到
			ROTTEN = "收获的时候慢了一步!",		-- 物品名:未找到
			FULL_OVERSIZED = "合理的搭配生产出了巨型农作物!",		-- 物品名:未找到
			ROTTEN_OVERSIZED = "多么可怕的浪费啊。",		-- 物品名:未找到
			FULL_WEED = "我要处理掉这些杂草！",		-- 物品名:未找到
			BURNING = "赶快给我的花园灭火。",		-- 物品名:未找到
		},
        FRUITFLY = "和蚊子一样烦人的生物！",		-- 物品名:"果蝇"
        LORDFRUITFLY = "别打我植物的注意！",		-- 物品名:"果蝇王"
        FRIENDLYFRUITFLY = "勤勤恳恳的小园丁。",		-- 物品名:"友好果蝇"
        FRUITFLYFRUIT = "它现在听从我的差遣。",		-- 物品名:"友好果蝇果"
        SEEDPOUCH = "这个大袋子可以帮我储存各种种子。",		-- 物品名:"种子袋" 制造描述:"妥善保管好种子。"
        YOTB_SEWINGMACHINE = "缝纫能有多难……对吧？",		-- 物品名:"缝纫机"
        YOTB_SEWINGMACHINE_ITEM = "看来需要组装一下。",		-- 物品名:"缝纫机套装" 制造描述:"做出完美的皮弗娄牛礼服吧。"
        YOTB_STAGE = "奇怪啊，我没见到他登台和离开……",		-- 物品名:"裁判席"
        YOTB_POST =  "这场比赛将会顺利进行！",		-- 物品名:"皮弗娄牛舞台"
        YOTB_STAGE_ITEM = "看起来要搭建一下才行。",		-- 物品名:"裁判席" 制造描述:"邀请专家出席。"
        YOTB_POST_ITEM =  "我最好先装好它。",		-- 物品名:"皮弗娄牛舞台" 制造描述:"让你的皮弗娄牛登上舞台中央。"
        YOTB_PATTERN_FRAGMENT_1 = "我打赌把这些拼在一起之后，一定能做出一件皮弗娄牛礼服。",		-- 物品名:"恐怖款式碎片" 制造描述:"来一点恐怖的灵感。"
        YOTB_PATTERN_FRAGMENT_2 = "我打赌把这些拼在一起之后，一定能做出一件皮弗娄牛礼服。",		-- 物品名:"正式款式碎片" 制造描述:"来一点正式的灵感。"
        YOTB_PATTERN_FRAGMENT_3 = "我打赌把这些拼在一起之后，一定能做出一件皮弗娄牛礼服。",		-- 物品名:"喜庆款式碎片" 制造描述:"来一点喜庆的灵感。"
            GENERIC = "未找到",		-- 物品名:未找到
            YOTB = "未找到",		-- 物品名:未找到
        },
        YOTB_BEEFALO_DOLL_DOLL = 
        {
            GENERIC = "小可爱",		--暂无注释
            YOTB = "给裁判来看看",		--暂无注释
        },
        YOTB_BEEFALO_DOLL_FESTIVE = 
        {
            GENERIC = "小可爱",		--暂无注释
            YOTB = "给裁判来看看",		--暂无注释
        },
        YOTB_BEEFALO_DOLL_NATURE = 
        {
            GENERIC = "小可爱",		--暂无注释
            YOTB = "给裁判来看看",		--暂无注释
        },
        YOTB_BEEFALO_DOLL_ROBOT = 
        {
            GENERIC = "小可爱",		--暂无注释
            YOTB = "给裁判来看看",		--暂无注释
        },
        YOTB_BEEFALO_DOLL_ICE = 
        {
            GENERIC = "小可爱",		--暂无注释
            YOTB = "给裁判来看看",		--暂无注释
        },
        YOTB_BEEFALO_DOLL_FORMAL = 
        {
           GENERIC = "小可爱",		--暂无注释
            YOTB = "给裁判来看看",		--暂无注释
        },
        YOTB_BEEFALO_DOLL_VICTORIAN = 
        {
            GENERIC = "小可爱",		--暂无注释
            YOTB = "给裁判来看看",		--暂无注释
        },
        YOTB_BEEFALO_DOLL_BEAST = 
        {
           GENERIC = "小可爱",		--暂无注释
            YOTB = "给裁判来看看",		--暂无注释
        },
        WAR_BLUEPRINT = "我的牛牛很温柔",		--暂无注释
        DOLL_BLUEPRINT = "漂亮的牛牛",		--暂无注释
        FESTIVE_BLUEPRINT = "喜庆的牛牛",		--暂无注释
        ROBOT_BLUEPRINT = "机械牛牛",		--暂无注释
        NATURE_BLUEPRINT = "自然系牛牛",		--暂无注释
        FORMAL_BLUEPRINT = "华丽牛牛",		--暂无注释
        VICTORIAN_BLUEPRINT = "胜利牛牛",		--暂无注释
        ICE_BLUEPRINT = "冷峻牛牛",		--暂无注释
        BEAST_BLUEPRINT = "野兽牛牛",		--暂无注释
        BEEF_BELL = "叮铃铃，和牛牛做朋友",		--暂无注释
        ALTERGUARDIAN_PHASE1 = 
        {
            GENERIC = "它的能量来自于月亮。",		--暂无注释
            DEAD = "深海随便拉个出来比它强多了。",		--暂无注释
        },
        ALTERGUARDIAN_PHASE2 = 
        {
            GENERIC = "奇怪的月亮能量。",		--暂无注释
            DEAD = "勉强能算得上是个对手。",		--暂无注释
        },
        ALTERGUARDIAN_PHASE2SPIKE = "来吧！",		--暂无注释
        ALTERGUARDIAN_PHASE3 = "更多的强敌我都遇到过，我不怕你",		--暂无注释
        ALTERGUARDIAN_PHASE3TRAP = "准备开始了",		--暂无注释
        ALTERGUARDIAN_PHASE3DEADORB = "还没结束呢",		--暂无注释
        ALTERGUARDIAN_PHASE3DEAD = "可惜了",		--暂无注释
        ALTERGUARDIANHAT = "月光的能量",		--暂无注释
        ALTERGUARDIANHATSHARD = "蕴含月亮能量的碎片",		--暂无注释
        MOONSTORM_GLASS = 
        {
            GENERIC = "好锋利",		--暂无注释
            INFUSED = "好漂亮啊"		--暂无注释
        },
        MOONSTORM_STATIC = "这个掉火花的东西是什么",		--暂无注释
        MOONSTORM_STATIC_ITEM = "它逃不掉了。",		--暂无注释
        MOONSTORM_SPARK = "诶唷，这个东西会电人",		--暂无注释
        BIRD_MUTANT = "这个鸟真的和艺术沾不上半点关系。",		--暂无注释
        BIRD_MUTANT_SPITTER = "我不喜欢它",		--暂无注释
        WAGSTAFF_NPC = "？一个人的投影",		--暂无注释
        ALTERGUARDIAN_CONTAINED = "未找到",		--暂无注释
        WAGSTAFF_TOOL_1 = "奇怪的零件",		--暂无注释
        WAGSTAFF_TOOL_2 = "这个又是什么",		--暂无注释
        WAGSTAFF_TOOL_3 = "这是什么啊",		--暂无注释
        WAGSTAFF_TOOL_4 = "又是奇怪的零件",		--暂无注释
        WAGSTAFF_TOOL_5 = "我什么都不知道",		--暂无注释
        MOONSTORM_GOGGLESHAT = "有什么就用什么，能用就行",		--暂无注释
        MOON_DEVICE = 
        {
            GENERIC = "这个可以做什么呢",		--暂无注释
            CONSTRUCTION1 = "做好了一个阶段",		--暂无注释
            CONSTRUCTION2 = "造好后有什么呢，我很好奇",		--暂无注释
        },
	DESCRIBE_GENERIC = "这是什么东西呢。",		--检查物品描述的缺省值
    DESCRIBE_TOODARK = "太黑了，我什么也看不见！",		--天太黑
    DESCRIBE_SMOLDERING = "高温让这个东西冒烟了。",		--冒烟
    DESCRIBE_PLANTHAPPY = "这个植物好开心!",		--暂无注释
    DESCRIBE_PLANTVERYSTRESSED = "这株植物生长的压力有点大。",		--暂无注释
    DESCRIBE_PLANTSTRESSED = "这个植物受到了不小的压力。",		--暂无注释
    DESCRIBE_PLANTSTRESSORKILLJOYS = "周围杂草很多。",		--暂无注释
    DESCRIBE_PLANTSTRESSORFAMILY = "需要和植物聊聊天。",		--暂无注释
    DESCRIBE_PLANTSTRESSOROVERCROWDING = "周围的作物太多了，有点挤。",		--暂无注释
    DESCRIBE_PLANTSTRESSORSEASON = "这个植物并不喜欢这个季节。",		--暂无注释
    DESCRIBE_PLANTSTRESSORMOISTURE = "这个植物缺少水分。",		--暂无注释
    DESCRIBE_PLANTSTRESSORNUTRIENTS = "这个植物缺少养分!",		--暂无注释
    DESCRIBE_PLANTSTRESSORHAPPINESS = "这个植物似乎不太开心。",		--暂无注释
    EAT_FOOD =
    {
        TALLBIRDEGG_CRACKED = "这种蛋吃起来口感并不好。",		--吃孵化的高脚鸟蛋
		WINTERSFEASTFUEL = "它尝起来是节日的味道。",		--暂无注释
    },
}