--[[
	--- This is Wilson's speech file for Don't Starve Together ---
	Write your character's lines here.
	If you want to use another speech file as a base, or use a more up-to-date version, get them from data\scripts\
	
	If you want to use quotation marks in a quote, put a \ before it.
	Example:
	"Like \"this\"."
]]
--反正旧模板里出现的都改了。新的太多，弃之！
return {
	ACTIONFAIL =
	{
		SHAVE =
		{
			AWAKEBEEFALO = "当面干这种事情有点不太好吧！",
			GENERIC = "有人在干了",
			NOBITS = "薅不动了呀",
		},
		STORE =
		{
			GENERIC = "满。",
			NOTALLOWED = "这不应该放在那儿。",
			INUSE = "等等吧。",
		},
		RUMMAGE =
		{	
			GENERIC = "做不到。",
			INUSE = "等等吧。",	
		},
        COOK =
        {
            GENERIC = "做不到。",
            INUSE = "等等吧。",
            TOOFAR = "触及不到。",
        },
        GIVE =
        {
            DEAD = "我回到地府再给你吧。",
            SLEEPING = "不值得。",
            BUSY = "忙完了吗？",
        },
        GIVETOPLAYER = 
        {
        	FULL = "已经快溢出了。",
            DEAD = "我回到地府再给你吧。",
            SLEEPING = "不值得。",
            BUSY = "忙完了吗？",
    	},
    	GIVEALLTOPLAYER = 
        {
        	FULL = "已经快溢出了。",
            DEAD = "我回到地府再给你吧。",
            SLEEPING = "不值得。",
            BUSY = "忙完了吗？",
    	},
        WRITE =
        {
            GENERIC = "我做不到。",
            INUSE = "写。",
        },
        CHANGEIN =
        {
            GENERIC = "我做不到。",
            BURNING = "危！",
            INUSE = "一次一换。",
        },
        ATTUNE =
        {
            NOHEALTH = "阴间的食物！",
        },
	},
	ACTIONFAIL_GENERIC = "别这么做。",
	ANNOUNCE_ADVENTUREFAIL = "下地洞还要有通行证吗？",
	ANNOUNCE_BEES = "蜜蜂！！！！！",
	ANNOUNCE_BOOMERANG = "杀敌一千，自损八百。",
	ANNOUNCE_CHARLIE = "哪里来的孤魂野鬼！",
	ANNOUNCE_CHARLIE_ATTACK = "嗷！",
	ANNOUNCE_COLD = "狐裘不暖锦衾薄。",
	ANNOUNCE_HOT = "强大到能够驱散极寒的阳气..(不该出现这句话)",
	ANNOUNCE_CRAFTING_FAIL = "缺少一些什么。",
	ANNOUNCE_DEERCLOPS = "熊咆龙吟殷岩泉，栗深林兮惊层巅。",
	ANNOUNCE_DUSK = "日落尚知合昏",
	ANNOUNCE_EAT =
	{
		GENERIC = "人间烟火。",
		PAINFUL = "阴间食物！",
		SPOILED = "味同嚼蜡。",
		STALE = "它正在衰败。",
		INVALID = "不吃！！！！！",
		YUCKY = "不吃！！！！！！",
	},
	ANNOUNCE_ENCUMBERED =  
    {
        "...可曾想会沦落至此？",
        "..有志者事竞成..",
        "要是能够烧掉就好了...",
		"哪有什么岁月静好...只是有人在负重前行...",
    },   
	   
	ANNOUNCE_ENTER_DARK = "如同地府般黑暗。",
	ANNOUNCE_ENTER_LIGHT = "正道的光！",
	ANNOUNCE_FREEDOM = "从琐事中解脱了",
	ANNOUNCE_HIGHRESEARCH = "智慧树下你和我！",
	ANNOUNCE_HOUNDS = "来者不善！",
	ANNOUNCE_WORMS = "来自黄泉的虫子。",
	ANNOUNCE_HUNGRY = "饥肠辘辘",
	ANNOUNCE_HUNT_BEAST_NEARBY = "听到了野兽的气息。",
	ANNOUNCE_HUNT_LOST_TRAIL = "大地似乎不愿意让我找到它。",
	ANNOUNCE_HUNT_LOST_TRAIL_SPRING = "雨水淹没了证据。",
	ANNOUNCE_INV_FULL = "盈箱溢箧",
	ANNOUNCE_KNOCKEDOUT = "天昏地暗",
	ANNOUNCE_LOWRESEARCH = "也许我该问问白泽先生..",
	ANNOUNCE_MOSQUITOS = "不避风与雨,群飞出菰蒲。",
    ANNOUNCE_NOWARDROBEONFIRE = "莫为风波羡平地，人间处处是危机。",
    ANNOUNCE_NODANGERGIFT = "莫为风波羡平地，人间处处是危机。",
	ANNOUNCE_NODANGERSLEEP = "危机四伏，安得歇寝？",
	ANNOUNCE_NODAYSLEEP = "阳气太重了。",
	ANNOUNCE_NODAYSLEEP_CAVE = "阴间的环境使我精力充沛！",
	ANNOUNCE_NOHUNGERSLEEP = "忧勤不遑宁，夙夜心忡忡。",
	ANNOUNCE_NOSLEEPONFIRE = "夜不能寐。",
	ANNOUNCE_NODANGERSIESTA = "危！",
	ANNOUNCE_NONIGHTSIESTA = "没有白泽枕，睡不着！",
	ANNOUNCE_NONIGHTSIESTA_CAVE = "昼夜颠倒了啊",
	ANNOUNCE_NOHUNGERSIESTA = "来点寒食罢！",
	ANNOUNCE_NODANGERAFK = "金蝉未动蝉先觉 暗算无常死不知",
	ANNOUNCE_NO_TRAP = "很容易",
	ANNOUNCE_PECKED = "停罢！",
	ANNOUNCE_QUAKE = "大地，你怎么了？",
	ANNOUNCE_RESEARCH = "学无止境。",
	ANNOUNCE_SHELTER = "安得广厦千万间，大庇天下寒士俱欢颜！",
	ANNOUNCE_THORNS = "哎!",
	ANNOUNCE_BURNT = "大火钱快递！",
	ANNOUNCE_TORCH_OUT = "我该用无量业火的。",
	ANNOUNCE_FAN_OUT = "小玩意儿没了呐。",
    ANNOUNCE_COMPASS_OUT = "不如问大地可靠。",
	ANNOUNCE_TRAP_WENT_OFF = "唔。",
	ANNOUNCE_UNIMPLEMENTED = "半途而废了。",
	ANNOUNCE_WORMHOLE = "那摩 啊利冶 克施地 嘎诃琶冶!",
	ANNOUNCE_CANFIX = "亡羊补牢。",
	ANNOUNCE_ACCOMPLISHMENT = "成就感爆棚！",
	ANNOUNCE_ACCOMPLISHMENT_DONE = "大地见证了一切！",	
	ANNOUNCE_INSUFFICIENTFERTILIZER = "我用法力试试？",
	ANNOUNCE_TOOL_SLIP = "爪子变得滑了！",
	ANNOUNCE_LIGHTNING_DAMAGE_AVOIDED = "天谴要来了！",

	ANNOUNCE_DAMP = "我该去接白泽先生了。",
	ANNOUNCE_WET = "白泽先生很喜欢这样。",
	ANNOUNCE_WETTER = "还好没有结冰。",
	ANNOUNCE_SOAKED = "长夜沾湿何由彻！",
	
	ANNOUNCE_BECOMEGHOST = "这么快就回到地府了。",
	ANNOUNCE_GHOSTDRAIN = "阴间需要我了，我感受的到。",
	ANNOUNCE_BLOOMING = "彼岸花间彼岸过，生死簿中生死簿。",

	DESCRIBE_SAMECHARACTER = "大地，哪一个才是真的我呢？",
	
	BATTLECRY =
	{
		GENERIC = "生在阳间有散场，死归地府又何妨！",
		PIG = "你的阳寿尽了呐！",
		PREY = "狩猎的话也叫上我啊！",
		SPIDER = "不要负隅顽抗！",
		SPIDER_WARRIOR = "区区蜘蛛！",
	},
	COMBAT_QUIT =
	{
		GENERIC = "姑且活着罢。",
		PIG = "这个魂有点特殊..",
		PREY = "没兴趣了。",
		SPIDER = "走开，蜘蛛！",
		SPIDER_WARRIOR = "我还是不打扰它为妙。",
	},
	DESCRIBE =
	{

		BERNIE_INACTIVE =
		{
			BROKEN = "魂飞魄散了。",
			GENERIC = "玩具小熊。",
		},
		BERNIE_ACTIVE = "让我听听你那执念。",
		
        PLAYER =
        {
            GENERIC = "你好 %s!",
            ATTACKER = " %s 放肆！",
            MURDERER = "你是凶手!",
            REVIVER = "%s,你是个关系户！",
            GHOST = "%s 凄凄惨惨戚戚！",
			FIRESTARTER = "你是要为谁寄东西吗？ %s!",
        },
		WILSON = 
		{
			GENERIC = "%s，凡间科学家。",
			ATTACKER = "可疑的凡人！",
			MURDERER = "审判你！",
			REVIVER = "姑且活着罢。",
			GHOST = "凄凄惨惨戚戚！",
			FIRESTARTER = "你是要为谁寄东西吗？",
		},
		WOLFGANG = 
		{
			GENERIC = "%s，大力士！",
			ATTACKER = "可疑的凡人！",
			MURDERER = "审判你！",
			REVIVER = "你是个关系户！",
			GHOST = "凄凄惨惨戚戚！",
			FIRESTARTER = "你是要为谁寄东西吗？",
		},
		WAXWELL = 
		{
			GENERIC = "%s，麦克斯韦方程组可不是你提出的。",
			ATTACKER = "我知道你的心里在想什么。",
			MURDERER = "审判你！",
			REVIVER = "你是个关系户！",
			GHOST = "凄凄惨惨戚戚！",
			FIRESTARTER = "你是要为谁寄东西吗？",
		},
		WX78 = 
		{
			GENERIC = "%s，机器人啊。",
			ATTACKER = "听不到机器人的内心啊！",
			MURDERER = "大地，它干了什么？！",
			REVIVER = "地府不需要机器人的灵魂！",
			GHOST = "机器人也有灵魂？？",
			FIRESTARTER = "你是要为谁寄东西吗？",
		},
		WILLOW = 
		{
			GENERIC = "%s，烧东西可不是这么玩的。",
			ATTACKER = "让我听听你的内心！",
			MURDERER = "审判你！",
			REVIVER = "你是个关系户！",
			GHOST = "凄凄惨惨戚戚！",
			FIRESTARTER = "本性暴露！",
		},
		WENDY = 
		{
			GENERIC = "%s，地狱不好玩。",
			ATTACKER = "可疑的女孩！",
			MURDERER = "啊！",
			REVIVER = "抱歉，你暂时不能下去。",
			GHOST = "请不要这样。",
			FIRESTARTER = "你是要为姐姐寄东西吗？",
		},
		WOODIE = 
		{
			GENERIC = "你好，%s，伐木工！你好，斧头女士。",
            ATTACKER = "可疑的凡人！还有斧头！",
            MURDERER = "凶手就是你！",
            REVIVER = "你是个关系户！",
            GHOST = "魂魄有点特殊。",
            BEAVER = "我听到了你的过去。",
            BEAVERGHOST = "这下该如何是好呢？",
            MOOSE = "驼鹿行动！",
            MOOSEGHOST = "行动失败了呢。",
            GOOSE = "变成家禽了！",
            GOOSEGHOST = "含笑九泉了。",
            FIRESTARTER = "让我来教你如何使用火。",
		},
		WICKERBOTTOM = 
		{
			GENERIC = "%s，这本《山海经》送给你！",
			ATTACKER = "你的内心不纯洁啊。",
			MURDERER = "杀手老奶奶！",
			REVIVER = "你是个关系户！",
			GHOST = "凄凄惨惨戚戚！",
			FIRESTARTER = "你是要为谁寄东西吗？",
		},
		WES = 
		{
			GENERIC = "....",
			ATTACKER = "...",
			MURDERER = "....",
			REVIVER = "....",
			GHOST = ".....",  
		},
		WEBBER =
        {
            GENERIC = "蜘蛛'人们' %s!",
            ATTACKER = "我猜你们还保持着野性。",
            MURDERER = "凶手团伙！",
            REVIVER = "你们都是关系户！",
            GHOST = "凄凄惨惨戚戚！",
            FIRESTARTER = "让我来教你如何使用火。",
        },
		WATHGRITHR =
        {
            GENERIC = "天马头盔，%s!",
            ATTACKER = "我知道你干了什么。",
            MURDERER = "审判你!",
            REVIVER = "你是个关系户！",
            GHOST = "凄凄惨惨戚戚！",
            FIRESTARTER = "你是要为谁寄东西吗？",
        },
		WINONA =
        {
            GENERIC = "女汉子，%s!",
            ATTACKER = "我知道你干了什么。",
            MURDERER = "审判你！",
            REVIVER = "你是个关系户！",
            GHOST = "凄凄惨惨戚戚！",
            FIRESTARTER = "你是要为谁寄东西吗？",
        },
		WORTOX =
        {
            GENERIC = "西方的恶魔，我在地狱见过！ %s!",
            ATTACKER = "红鬼！",
            MURDERER = "你攫取了谁的灵魂？",
            REVIVER = "你是个关系户！",
            GHOST = "凄凄惨惨戚戚！",
            FIRESTARTER = "你是要为谁寄东西吗？",
        },
		WORMWOOD =
        {
            GENERIC = "我也能开花哦！ %s!",
            ATTACKER = "可疑的凡人！",
			MURDERER = "审判你！",
			REVIVER = "你是个关系户！",
			GHOST = "凄凄惨惨戚戚！",
			FIRESTARTER = "你是要为谁寄东西吗？",
        },
		WARLY =
        {
            GENERIC = "凡人厨师，%s!",
            ATTACKER = "我知道你干了什么。",
            MURDERER = "审判你！",
            REVIVER = "你是个关系户！",
			GHOST = "凄凄惨惨戚戚！",
			FIRESTARTER = "你是要为谁寄东西吗？",
        },
		 WURT =
        {
            GENERIC = "小鱼人，%s!",
            ATTACKER = "可疑的鱼人！",
            MURDERER = "审判你！",
            REVIVER = "你是个关系户！",
			GHOST = "凄凄惨惨戚戚！",
			FIRESTARTER = "你是要为谁寄东西吗？",
        },
		WALTER =
        {
            GENERIC = "。%s!",
            ATTACKER = "我知道你干了什么。",
            MURDERER = "审判你！",
            REVIVER = "你是个关系户！",
			GHOST = "凄凄惨惨戚戚！",
			FIRESTARTER = "你是要为谁寄东西吗？",
        },
		WOBYBIG = 
        {
            "你让我想起了千年前的自己。",
            "我想主人了。",
        },
        WOBYSMALL = 
        {
            "你让我想起了千年前的自己。",
            "我想主人了。",
        }, 
		MULTIPLAYER_PORTAL = "看来凡间和地狱多了一条便捷的通道。",
        MIGRATION_PORTAL = {
            GENERIC = "三界无别法，一切唯心造。",
            OPEN = "七魄有缘归地府。",
            FULL = "三魂无分上天。",
        },
		GLOMMER = "你让我想起了小髅。",
		GLOMMERFLOWER = 
		{
			GENERIC = "如同鬼擎火一般的血红。",
			DEAD = "零落成泥碾作尘！",
		},
		GLOMMERWINGS = "喜欢，埋起来！",
		GLOMMERFUEL = "噫————！",
		BELL = "叮铃——",
		STATUEGLOMMER = 
		{	
			GENERIC = "这个烧不了呀！",
			EMPTY = "哦，我在干什么。",
		},

		WEBBERSKULL = "带回地府种下去！",
		WORMLIGHT = "吃了我能发光吗？",
		WORMLIGHT_LESSER = "吃了我能发光吗？",
		WORM =
		{
		    PLANT = "这是假的！危！",
		    DIRT = "充满敌意的生物。",
		    WORM = "阴间也有不少这玩意儿！",
		}, 
		   
        WORMLIGHT_PLANT = "可以发光的小果子。",
		MOLE =
		{
			HELD = "和我一起回地府，怎么样？",
			UNDERGROUND = "这家伙对矿物有很强的渴望……",
			ABOVEGROUND = "好可爱的生灵。",
		},
		MOLEHILL = "大地告诉我那里面或许有我需要的。",
		MOLEHAT = "这个在地府很有用~",

		EEL = "小髅应该会喜欢的。",
		EEL_COOKED = "但爱鳗鱼美！",
		UNAGI = "自己动手，丰衣足食。",
		EYETURRET = "好强的法力！",
		EYETURRET_ITEM = "法力消逝了。",
		MINOTAURHORN = "我可以用它来炼丹。",
		MINOTAURCHEST = "我可以烧掉吗？",
		THULECITE_PIECES = "貔貅会喜欢这玩意儿的。",
		POND_ALGAE = "池边藻荇交横。",
		GREENSTAFF = "凡间竟有如此神奇的魔法！",
		POTTEDFERN = "要是能种上一株鬼擎火该多好。",

		THULECITE = "可以感受阴阳变化。",
		ARMORRUINS = "可以保护我的凡胎肉体",
		RUINS_BAT = "拥有来自阴间的力量。",
		RUINSHAT = "戴着搁角了。",
		NIGHTMARE_TIMEPIECE =
		{
            CALM = "息。",
            WARN = "禁。",
            WAXING = "何事长向别时圆？",
            STEADY = "静。",
            WANING = "躁。",
            DAWN = "混。",
            NOMAGIC = "法力在涌动。",
		},
		BISHOP_NIGHTMARE = "用业火将你焚尽！",
		ROOK_NIGHTMARE = "用业火将你焚尽！",
		KNIGHT_NIGHTMARE = "用业火将你焚尽！",
		MINOTAUR = "被困在这里很久了吧。",
		SPIDER_DROPPER = "借过一下。",
		NIGHTMARELIGHT = "阎王会喜欢这种灯的。",
		NIGHTSTICK = "比起我的角，它不足以惩治恶灵。",
		GREENGEM = "可以卖给四老板。",
		RELIC = "古老凡人的存在证明。",
		RUINS_RUBBLE = "碎碎平安。",
		MULTITOOL_AXE_PICKAXE = "有意思的工具。",
		ORANGESTAFF = "还不如一把火烧掉直接。",
		YELLOWAMULET = "跑得更快了。",
		GREENAMULET = "事半功倍！",
		SLURPERPELT = "小髅一定会想要这张皮。",	

		SLURPER = "摄魂夺魄的恶灵！",
		SLURPER_PELT = "小髅一定会想要这张皮。",
		ARMORSLURPER = "送给小髅做礼物~",
		ORANGEAMULET = "急急如律令！",
		YELLOWSTAFF = "星陨之杖！",
		YELLOWGEM = "可以卖给四老板。",
		ORANGEGEM = "可以卖给四老板。",
		TELEBASE = 
		{
			VALID = "我可以随时拜访白泽先生了。",
			GEMS = "大地说，你需要紫晶。",
		},
		GEMSOCKET = 
		{
			VALID = "我可以随时拜访白泽先生了。",
			GEMS = "大地说，你需要紫晶。",
		},
		STAFFLIGHT = "金乌升晓气，玉槛漾晨曦。",
	
        ANCIENT_ALTAR = "大地，这个是干什么用的？",

        ANCIENT_ALTAR_BROKEN = "大地，这个是干什么用的？",

        ANCIENT_STATUE = "地府里偶尔会有类似的雕像。",

        LICHEN = "苔花如米小,也学牡丹开。",
		CUTLICHEN = "苔花如米小,也学牡丹开。",

		CAVE_BANANA = "凡间水果。",
		CAVE_BANANA_COOKED = "我更愿意生吃。",
		CAVE_BANANA_TREE = "真想种在院子里。",
		ROCKY = "石头与龙虾精。",
		
		COMPASS =
		{
			GENERIC="我该问大地的。",
			N = "北",
			S = "南",
			E = "东",
			W = "西",
			NE = "东北",
			SE = "东南",
			NW = "西北",
			SW = "西南",
		},

		NIGHTMARE_TIMEPIECE =	
		{
            CALM = "息。",
            WARN = "禁。",
            WAXING = "何事长向别时圆？",
            STEADY = "静。",
            WANING = "躁。",
            DAWN = "混。",
            NOMAGIC = "法力在涌动。",
		},

		HOUNDSTOOTH="同类的牙齿...",
		ARMORSNURTLESHELL="我的腰..",
		BAT="山翠幂灵洞,洞深玄想微。",
		BATBAT = "汲取精气的武器。",
		BATWING="埋掉，也许会长出来。",
		BATWING_COOKED="地狱风味！",
        BATCAVE = "轻轻的我走了, 正如我轻轻的来",
		BEDROLL_FURRY="不如白泽枕舒适。",
		BUNNYMAN="hello,兔儿爷！",
		FLOWER_CAVE="地狱有这种植物吗？",
		FLOWER_CAVE_DOUBLE="地狱有这种植物吗？",
		FLOWER_CAVE_TRIPLE="地狱有这种植物吗？",
		GUANO="噫————！",
		LANTERN="今年元夜时,月与灯依旧。",
		LIGHTBULB="烧点寄给主人尝尝罢。",
		MANRABBIT_TAIL="比我的毛手感更好。",
		MUSHTREE_TALL = {
            GENERIC = "凡间的蘑菇都长这样啊？",
            BLOOM = "闻起来像是罪恶的臭味。",
        },
		MUSHTREE_MEDIUM = {
            GENERIC = "凡间的蘑菇都长这样啊？",
            BLOOM = "闻起来像是罪恶的臭味。",
        },
		MUSHTREE_SMALL = {
            GENERIC = "凡间的蘑菇都长这样啊？",
            BLOOM = "闻起来像是罪恶的臭味。",
        },
        MUSHTREE_TALL_WEBBED = "我听到了蜘蛛的窃窃私语。",
        SPORE_TALL = "处处东风扑晚阳，轻轻醉粉落无香。",
        SPORE_MEDIUM = "处处东风扑晚阳，轻轻醉粉落无香。",
        SPORE_SMALL = "处处东风扑晚阳，轻轻醉粉落无香。",
        SPORE_TALL_INV = "处处东风扑晚阳，轻轻...没了。",
        SPORE_MEDIUM_INV = "处处东风扑晚阳，轻轻...没了。",
        SPORE_SMALL_INV = "处处东风扑晚阳，轻轻...没了。",
		RABBITHOUSE=
		{
			GENERIC = "小兔子乖乖，把门儿开开！",
			BURNT = "你收到了吗，兔儿爷。",
		},
		SLURTLE="长羡蜗牛犹有舍",
		SLURTLE_SHELLPIECES="支离破碎。",
		SLURTLEHAT="就像顶着一只蜗牛一样。",
		SLURTLEHOLE="归来醉卧蜗牛舍",
		SLURTLESLIME="我不吃。",
		SNURTLE="长羡蜗牛犹有舍",
		SPIDER_HIDER="区区蜘蛛，又奈我何？",
		SPIDER_SPITTER="我可不想被吐一口。",
		SPIDERHOLE="里面住着蜘蛛！",
		STALAGMITE="里面有宝贝！",
		STALAGMITE_FULL="里面有宝贝！",
		STALAGMITE_LOW="里面有宝贝！",
		STALAGMITE_MED="里面有宝贝！",
		STALAGMITE_TALL="阴间可曾有此奇景？",
		STALAGMITE_TALL_FULL="阴间可曾有此奇景？",
		STALAGMITE_TALL_LOW="阴间可曾有此奇景？",
		STALAGMITE_TALL_MED="阴间可曾有此奇景？",

		TURF_CARPETFLOOR = "别是一般滋味在心头。",
		TURF_CHECKERFLOOR = "别是一般滋味在心头。",
		TURF_DIRT = "大地的一部分。",
		TURF_FOREST = "皇天后土实所共鉴！",
		TURF_GRASS = "皇天后土实所共鉴！",
		TURF_MARSH = "大地你发霉了么。",
		TURF_ROAD = "皇天后土实所共鉴！",
		TURF_ROCKY = "皇天后土实所共鉴！",
		TURF_SAVANNA = "皇天后土实所共鉴！",
		TURF_WOODFLOOR = "皇天后土实所共鉴！",

		TURF_CAVE="皇天后土实所共鉴！",
		TURF_FUNGUS="大地我确信你发霉了。",
		TURF_SINKHOLE="皇天后土实所共鉴！",
		TURF_UNDERROCK="皇天后土实所共鉴！",
		TURF_MUD="皇天后土实所共鉴！",

		TURF_DECIDUOUS = "皇天后土实所共鉴！",
		TURF_SANDY = "皇天后土实所共鉴！",
		TURF_BADLANDS = "皇天后土实所共鉴！",

		POWCAKE = "犬类不吃蛋糕。",
        CAVE_ENTRANCE = "朝泛苍梧暮却还，洞中日月我为天。",
        CAVE_ENTRANCE_RUINS = "朝泛苍梧暮却还，洞中日月我为天",
        CAVE_ENTRANCE_OPEN = {
            GENERIC = "大地拒绝了我。",
            OPEN = "朝泛苍梧暮却还，洞中日月我为天。",
            FULL = "我断后。",
        },
        CAVE_EXIT = {
            GENERIC = "这才是我的归宿。",
            OPEN = "嚯！",
            FULL = "我断后。",
		},
		DEER =
		{
			GENERIC = "四老板？",		-- 物品名:"无眼鹿"->默认
			ANTLER = "一候鹿角解。",		-- 物品名:"无眼鹿"
		},
		DEER_ANTLER = "一候鹿角解。",
		MAXWELLPHONOGRAPH = "凡人的玩意儿。",
		BOOMERANG = "我可以用嘴叼吗？",
		PIGGUARD = "提携玉龙为君死。",
		ABIGAIL = "悠悠生死别经年，魂魄不曾来入梦。",
		ADVENTURE_PORTAL = "不请自来贪欲念。",
		AMULET = "阎王的免死令牌。",
		ANIMAL_TRACK = "猎物的足迹！",
		ARMORGRASS = "稻草似乎没什么效果。",
		ARMORMARBLE = "寒光照铁衣。",
		ARMORWOOD = "身披铠甲赛冰霜。",
		ARMOR_SANITY = "魑魅魍魉！",
		ASH =
		{
			GENERIC = "先生，收到了吗？",
			REMAINS_GLOMMERFLOWER = "烈火焚身若等闲。",
			REMAINS_EYE_BONE = "安息吧。",
			REMAINS_THINGIE = "抱歉……职业病。",
		},
		AXE = "到乡翻似烂柯人。",
		BABYBEEFALO = "牛犊子。",
		BACKPACK = "别让这法宝被领导知道了...",
		BACONEGGS = "更喜欢寒食。",
		BANDAGE = "我更想吃了它。",
		BASALT = "上古岩石。",
		BATBAT = "汲取精气的武器。",	-- Duplicated
		BEARDHAIR = "烧了吧...",
		BEARGER = "它的心里只有食物！",
		BEARGERVEST = "快点送给小髅。",
		ICEPACK = "远不及吾。",
		BEARGER_FUR = "小髅的最爱。",
		BEDROLL_STRAW = "凑合。",
		BEE =
		{
			GENERIC = "纷纷穿飞万花间，终生未得半日闲。",
			HELD = "蜂儿不食人间仓，玉露为酒花为粮。",
		},
		BEEBOX =
		{
			READY = "采花酿为粮，仓廪自充实。",
			FULLHONEY = "采花酿为粮，仓廪自充实。",
			GENERIC = "采得百花成蜜后，为谁辛苦为谁甜。",
			NOHONEY = "抱歉了。",
			SOMEHONEY = "世人都夸蜜味好，釜底添薪有谁怜。",
			BURNT = "不是我干的！",
		},
		BEEFALO =
		{
			FOLLOWER = "跟我回地府吗？",
			GENERIC = "暮归，忘其牛。",
			NAKED = "薅过头了呀。",
			SLEEPING = "也许我可以做些什么。",
		},
		BEEFALOHAT = "滑稽的帽子。",
		BEEFALOWOOL = "暖和，喜欢！",
		BEEHAT = "免于叮咬。",
		BEEHIVE = "但得蜜成功用足，不辞辛苦与君尝。",
		BEEMINE = "有意思。",
		BEEMINE_MAXWELL = "？！",
		BERRIES = "甜到掉牙了。",
		BERRIES_COOKED = "我觉得应该可以生吃。",
		BERRYBUSH =
		{
			BARREN = "需要我的法力吗？",
			WITHERED = "它枯萎了！",
			GENERIC = "一株是浆果，还有一株也是浆果。",
			PICKED = "空空如也。",
		},
		BIGFOOT = "何方妖孽？",
		BIRDCAGE =
		{
			GENERIC = "有些鸟儿是关不住的——",
			OCCUPIED = "一笼不容二鸟。",
			SLEEPING = "扰鸟清梦。",
			HUNGRY = "鸟饿了。",
			STARVING = "鸟为食亡！",
			DEAD = "我很抱歉。",
			SKELETON = "噢噢！",
		},
		BIRDTRAP = "鸾鹤在冥冥。",
		BIRD_EGG = "鸡蛋里找骨头。",
		BIRD_EGG_COOKED = "喂给鸟吃会怎样呢？",
		BISHOP = "呃啊，真想给主人瞧瞧。",
		BLOWDART_FIRE = "为什么不用法力呢？",
		BLOWDART_SLEEP = "对付大型动物挺有一套。",
		BLOWDART_PIPE = "尝尝幽冥的极寒！",
		BLUEAMULET = "远不及吾。",
		BLUEGEM = "别让貔貅看到了。",
		BLUEPRINT = "窥探天机。",
		BELL_BLUEPRINT = "禁术。",
		BLUE_CAP = "吸收了月的精华，食之补气血。",
		BLUE_CAP_COOKED = "精华没了啊。",
		BLUE_MUSHROOM =
		{
			GENERIC = "蜡面黄紫光欲湿，酥茎娇脆手轻拾。",
			INGROUND = "蘑菇也会睡觉！",
			PICKED = "采蘑菇的小谛听。",
		},
		BOARDS = "木板而已。",
		BOAT = "水能载舟，亦能覆舟。",
		BONESHARD = "也许能种点帮手出来。",
		BONESTEW = "陇馔有熊腊,秦烹唯羊羹。",
		BUGNET = "到这来，小虫！",
		BUSHHAT = "像植物般生活。",
		BUTTER = "为什么蝴蝶里有黄油？？",
		BUTTERFLY =
		{
			GENERIC = "留连戏蝶时时舞。",
			HELD = "蝶恋花！",
		},
		BUTTERFLYMUFFIN = "蝴蝶的味道！",
		BUTTERFLYWINGS = "做成标本。",
		BUZZARD = "上蔡苍鹰何足道！",
		CACTUS = 
		{
			GENERIC = "虽刺犹人爱，不与其他同。",
			PICKED = "拒争芬芳艳，焕然一身清。",
		},
		CACTUS_MEAT_COOKED = "吃了神清气爽！",
		CACTUS_MEAT = "有刺呐...",
		CACTUS_FLOWER = "别去触碰从白骨里开出的花。",

		COLDFIRE =
		{
			EMBERS = "我得做些什么。",
			GENERIC = "不及幽冥的极寒。",
			HIGH = "百泉冻皆咽，我吟寒更切。",
			LOW = "需要我的法力吗？",
			NORMAL = "不及幽冥的极寒。",
			OUT = "转瞬即逝。",
		},
		CAMPFIRE =
		{
			EMBERS = "我得做些什么。",
			GENERIC = "大火钱快递~",
			HIGH = "沙场烽火侵胡月，海畔云山拥蓟城。",
			LOW = "试试三昧真火？",
			NORMAL = "烽火连三月，家书抵万金。",
			OUT = "我该用无量业火的。",
		},
		CANE = "健步如飞！",
		CATCOON = 
		{
		    "我想小髅了。",
			"小完能！！",
		},                       --这里我加了一行，像沃比那样。理论上可以显示两句台词的。
		CATCOONDEN = 
		{
			GENERIC = "里面通向哪里吗？",
			EMPTY = "。。。",
		},
		CATCOONHAT = "暖和！",
		COONTAIL = "是浣熊，亦或是猫？",
		CARROT = "密壤深根蒂，风霜已饱经。",
		CARROT_COOKED = "一丸萝卜火吾宫。",
		CARROT_PLANTED = "锄禾日当午。",
		CARROT_SEEDS = "仅仅是种子。",
		WATERMELON_SEEDS = "秋水仙素何在？",
		CAVE_FERN = "羊齿植物。",
		CHARCOAL = "比我黑。",
        CHESSJUNK1 = "也许我能修复它。",
        CHESSJUNK2 = "凡间的伪科学",
        CHESSJUNK3 = "敲掉会不会蹦出来什么呢。",
		CHESTER = "天地又造出了不同寻常的生物。",
		CHESTER_EYEBONE =
		{
			GENERIC = "勿望我。",
			WAITING = "它安息了。",
		},
		COOKEDMANDRAKE = "跳舞的精灵变成汤了...",
		COOKEDMEAT = "八百里分麾下炙。",
		COOKEDMONSTERMEAT = "地狱九宫格都比这个好...",
		COOKEDSMALLMEAT = "八百里分麾下炙。",
		COOKPOT =
		{
			COOKING_LONG = "稍安勿躁。",
			COOKING_SHORT = "心急吃不了热蚂蚁。",   --别重了……
			DONE = "我的厨艺依旧甚好。",
			EMPTY = "请品尝空气杂烩。",
			BURNT = "我发誓不是我干的。",
		},
		CORN = "普通的玉米。",
		CORN_COOKED = "爆米花！",
		CORN_SEEDS = "种皮、胚乳、胚。",
		CROW =
		{
			GENERIC = "鸦飞九天高,明神讵可招。",
			HELD = "调引个中物象，玉兔配乌鸦。",
		},
		CUTGRASS = "我可以编一只刍狗。",  --emmmmmmm
		CUTREEDS = "蒹葭苍苍，白露为霜。",
		CUTSTONE = "石砖。",
		DEADLYFEAST = "吃了会见阎王。",
		DEERCLOPS = "送你去极寒地狱！",
		DEERCLOPS_EYEBALL = "睇见 睇见 睇见 睇见 心慌慌",
		EYEBRELLAHAT =	"哈，不怕天谴了。",
		DEPLETED_GRASS =
		{
			GENERIC = "离离原上草，一岁一枯荣。",
		},
		DEVTOOL = "闻起来很香。",
		DEVTOOL_NODEV = "爪子可拿不动。",
		DIRTPILE = "你要告诉我什么，大地？",
		DIVININGROD = {
			WARM = "我在正确的方向上。",		-- [√]  探测杖
			WARMER = "肯定很接近了。",		-- [√]  探测杖
			GENERIC = "它是某种自动引导装置。",		-- [√]  探测杖
			COLD = "风寒入骨。",		-- [√]  探测杖
			HOT = "这东西发疯了！",		-- [√]  探测杖
		},     --大概是单机的东西，从别的地方直接复制了。
		DIVININGRODBASE = {
			GENERIC = "我想知道它有什么用。",		-- [√]  探测杖底座
			READY = "看起来它需要一把大钥匙。",		-- [√] 就绪的 探测杖底座
			UNLOCKED = "现在机器可以工作了！",		-- [√]  探测杖底座
		},
		DIVININGRODSTART = "那根手杖看起来很有用！",		-- [√]  探测杖底座
		DRAGONFLY = "可是穷奇的远亲？",
		ARMORDRAGONFLY = "好热啊。",
		DRAGON_SCALES = "吉光片羽。",
		DRAGONFLYCHEST = "冬天可以在里面睡觉吗？",
		LAVASPIT = {
			HOT = "好烫的口水！",		-- [√]  龙蝇唾液
			COOL = "我喜欢把它叫作“干唾液”。",		-- [√]  龙蝇唾液
		},

		LAVAE = "小心变成冰块！",
		LAVAE_PET = 
		{
			STARVING = "我很抱歉。",
			HUNGRY = "想吃灰吗？",
			CONTENT = "看起来很开心。",
			GENERIC = "移动小火炉。",
		},
		LAVAE_EGG = 
		{
			GENERIC = "里面传来微弱的暖意。",
		},
		LAVAE_EGG_CRACKED =
		{
			COLD = "我不能再靠近你了。",
			COMFY = "里面有什么？",
		},
		LAVAE_TOOTH = "喜欢！",

		DRAGONFRUIT = "南方有嘉果 玫瓣裹雪影。",
		DRAGONFRUIT_COOKED = "生吃不好吗？",
		DRAGONFRUIT_SEEDS = "种豆得豆。",
		DRAGONPIE = "厨艺渐增！",
		DRUMSTICK = "是肉。",
		DRUMSTICK_COOKED = "烤肉。",
		DUG_BERRYBUSH = "数椽生草覆莓苔，一径墙阴斸雪开。",
		DUG_GRASS = "我该种下来。",
		DUG_MARSH_BUSH = "我应该移植走。",
		DUG_SAPLING = "树木丛生,百草丰茂。",
		DURIAN = "做为武器可还行。",
		DURIAN_COOKED = "做为武器可还行。",
		DURIAN_SEEDS = "种豆得豆。",
		EARMUFFSHAT = "也许我该戴在耳朵上？",
		EGGPLANT = "紫茄白苋以为珍，守任清真转更贫。",
		EGGPLANT_COOKED = "路訾邪鹭何食？食茄下。",
		EGGPLANT_SEEDS = "种茄得茄。",
		DECIDUOUSTREE = 
		{
			BURNING = "不是我干的！",
			BURNT = "变成炭了。",
			CHOPPED = "我可以坐在上面。",
			POISON = "这是什么这是什么？？",
			GENERIC = "桦烟深处白衫新。",
		},
		ACORN = "小零食。",
        ACORN_SAPLING = "枫丹欲照心!",
		ACORN_COOKED = "小零食。",
		BIRCHNUTDRAKE = "哎！",
		EVERGREEN =
		{
			BURNING = "我在干什么？",
			BURNT = "我猜地府不需要绿化。",
			CHOPPED = "留得青山在, 不愁没柴烧。",
			GENERIC = "时人不识凌云木，直待凌云始道高。",
		},
		EVERGREEN_SPARSE =
		{
			BURNING = "不是我干的！",
			BURNT = "变成炭了。",
			CHOPPED = "我可以坐在上面。",
			GENERIC = "咬住青山不放松，立根原在破岩中。",
		},
		EYEPLANT = "不寒而栗。",
		FARMPLOT =
		{
			GENERIC = "田园将芜胡不归？",
			GROWING = "粒粒皆辛苦。",
			NEEDSFERTILIZER = "需要我的法力吗？",
			BURNT = "悲乎！",
		},
		FEATHERHAT = "我是一只小小鸟。",
		FEATHER_CROW = "和我一样的毛色。",
		FEATHER_ROBIN = "朱羽翾翾。",
		FEATHER_ROBIN_WINTER = "鸷鸟之不群兮！",
		FEM_PUPPET = "她被困住了！",
		FIREFLIES =
		{
			GENERIC = "屏疑神火照，帘似夜珠明。",
			HELD = "逢君拾光彩，不吝此生轻。",
		},
		FIREHOUND = "唔……可恶的祸斗！我要和你决……",
		FIREPIT =
		{
			EMBERS = "我得做些什么。",
			GENERIC = "大火钱快递~",
			HIGH = "沙场烽火侵胡月，海畔云山拥蓟城。",
			LOW = "试试三昧真火？",
			NORMAL = "烽火连三月，家书抵万金。",
			OUT = "我该用无量业火的。",
		},
		COLDFIREPIT =
		{
			EMBERS = "我得做些什么。",
			GENERIC = "不及幽冥的极寒。",
			HIGH = "百泉冻皆咽，我吟寒更切。",
			LOW = "需要我的法力吗？",
			NORMAL = "不及幽冥的极寒。",
			OUT = "转瞬即逝。",
		},
		FIRESTAFF = "班门弄斧！",
		FIRESUPPRESSOR = 
		{	
			ON = "我能和机器打雪仗了！",
			OFF = "它关了。",
			LOWFUEL = "加点料罢。",
		},

		FISH = "鱼，我所欲也。",   --这个为什么没有执行？ --因为并不是淡水鱼
		FISHINGROD = "独钓寒江雪。",
		FISHSTICKS = "做给小髅尝尝。",
		FISHTACOS = "厨艺渐增！",
		FISH_COOKED = "桃花流水鳜鱼肥。",
		FISH_RAW_SMALL_COOKED = "桃花流水鳜鱼肥。",			-- 新增的应该是这个 烤小鱼块
		PONDFISH = "鱼,我所欲也。",    --找到了  淡水鱼！
		PONDEEL = "别看着我，愿者上钩。",             --活鳗鱼。
		FLINT = "尖石头罢了。",
		FLOWER = {
			ROSE = "谁碎辟邪香，氤氲飞作蝶。",		-- [√]  花
			GENERIC = "乱花渐欲迷人眼。",		-- [√]  花
		},               --如有错误请看这行。挪用了一个语言包里的内容
        FLOWER_WITHERED = "只有香如故。",
		FLOWERHAT = "护花使者！",
		FLOWER_EVIL = "地狱的花！",
		FOLIAGE = "多叶植物。",
		FOOTBALLHAT = "变法把角收起来吧。",
		FROG =
		{
			DEAD = "它死了！",
			GENERIC = "白泽先生喜爱的小呱呱。",
			SLEEPING = "它在睡觉呢。",
		},
		FROGGLEBUNWICH = "感觉不是很好吃..",
		FROGLEGS = "感觉不是很好吃。",
		FROGLEGS_COOKED = "蛋白质而已。",
		FRUITMEDLEY = "富含维生素。",
		FURTUFT = "我经常也会掉下来一点儿。", 
		GEARS = "凡人造的小玩意儿。",
		GHOST = "像是从地府里偷跑出来的。",
		GOLDENAXE = "你掉的是这个金斧头，还是这个金斧头？",
		GOLDENPICKAXE = "奢侈！",
		GOLDENPITCHFORK = "不如卖给四老板。",
		GOLDENSHOVEL = "大地啊大地，你会让我挖吗？？",
		GOLDNUGGET = "奈何取之尽锱铢，用之如泥沙。",
		GRASS =
		{
			BARREN = "灵气渐尽。",
			WITHERED = "我来给你降温罢。",
			BURNING = "着了啊！",
			GENERIC = "刍草罢了。",
			PICKED = "春风吹又生。",
		},
		GREEN_CAP = "食之精神萎靡。",
		GREEN_CAP_COOKED = "食之神清气爽！",
		GREEN_MUSHROOM =
		{
			GENERIC = "蜡面黄紫光欲湿，酥茎娇脆手轻拾。",
			INGROUND = "蘑菇也会睡觉！",
			PICKED = "采蘑菇的小谛听。",
		},
		GUNPOWDER = "2KNO3+3C+S=K2S+N2+3CO2。",  --好像过头了。
		HAMBAT = "亏得凡人想出这等奇葩！",
		HAMMER = "大铁椎,不知何许人。",
		HEALINGSALVE = "能治脱毛吗？",
		HEATROCK =
		{
			FROZEN = "怪我咯？",
			COLD = "怪我咯？",
			GENERIC = "暖宝宝！",
			WARM = "有了它我就可以在冬天拜访先生了！",
			HOT = "有了它我就可以在冬天拜访先生了！",
		},
		HOME = "有人住在这儿。",
		HOMESIGN =
		{
			GENERIC = "到此一游。",
            UNWRITTEN = "空白的。",
			BURNT = "谁会去无聊到烧一个牌子？",
		},
		ARROWSIGN_POST =
		{
			GENERIC = "到此一游。",
            UNWRITTEN = "空白的。",
			BURNT = "谁会去无聊到烧一个牌子？",
		},
		ARROWSIGN_PANEL =
		{
			GENERIC = "到此一游。",
            UNWRITTEN = "空白的。",
			BURNT = "谁会去无聊到烧一个牌子？",
		},
		HONEY = "甜！",
		HONEYCOMB = "蜜蜂之家。",
		HONEYHAM = "厨艺渐增！",
		HONEYNUGGETS = "厨艺渐增！",
		HORN = "角声满天秋色里。",
		HOUND = "本是同根生，相煎何太急！",
		HOUNDBONE = "黄尘足今古 白骨乱蓬蒿。",
		HOUNDMOUND = "黄尘足今古 白骨乱蓬蒿。",
		ICEBOX = "不需要电力吗？",
		ICEHAT = "我感到脑子进水了。",
		ICEHOUND = "曾经我也是白色的。",
		INSANITYROCK =
		{
			ACTIVE = "古碑无字草芊芊。",
			INACTIVE = "庙古碑无字，洲晴蕙有香。",
		},
		JAMMYPRESERVES = "厨艺渐增！",
		KABOBS = "厨艺渐增！",
		KILLERBEE =
		{
			GENERIC = "不怀好意。",
			HELD = "红嗡嗡。",
		},
		KNIGHT = "齿轮马儿！",
		KOALEFANT_SUMMER = "“大象”无形，大音希声", -- 中文“”不影响吧。
		KOALEFANT_WINTER = "“大象”无形，大音希声",
		KRAMPUS = "诗书腹内藏千卷，钱串床头没半根！",
		KRAMPUS_SACK = "欧皇包！",
		LEIF = "树都成精了！",
		LEIF_SPARSE = "树都成精了！",
		LIGHTNING_ROD =
		{
			CHARGED = "和我的角有一样的功能！",
			GENERIC = "不怕天谴了。",
		},
		LIGHTNINGGOAT = 
		{
			GENERIC = "咩————",
			CHARGED = "来比比谁的角更厉害啊！",
		},
		LIGHTNINGGOATHORN = "镫青一电瞬,剑碧两龙长。",
		GOATMILK = "羊羔跪乳。",
		LITTLE_WALRUS = "狐假虎威!",
		LIVINGLOG = "地狱的木头也不长这样。",
		LOG =
		{
			BURNING = "烫烫烫烫！",
			GENERIC = "年轻的樵夫哟。",
		},
		--加个蚁狮的，这个模板版本太旧了！
		ANTLION = {
			GENERIC = "好想摸摸它的鼻子！",		-- [√]  蚁狮
			VERYHAPPY = "嘿！",		-- [√]  蚁狮
			UNHAPPY = "石头你拿去便是了。",		-- [√]  蚁狮
		}, 
		
		LUREPLANT = "大地，这是什么？！",
		LUREPLANTBULB = "我要带回去种在小院子里。",
		MALE_PUPPET = "我能做些什么？",

		MANDRAKE_ACTIVE = "好吵啊啊啊啊啊！",
		MANDRAKE_PLANTED = "人参精！",
		MANDRAKE = "要用魔法打败魔法。",

		MANDRAKESOUP = "浪费了啊。",
		MANDRAKE_COOKED = "我很抱歉……",
		MARBLE = "太沉重。",
		MARBLEPILLAR = "残垣断壁。",
		MARBLETREE = "种树得树，没什么问题。",
		MARSH_BUSH =
		{
			BURNING = "它着了！",
			GENERIC = "我不想碰它。",
			PICKED = "哎呦！",
		},
		BURNT_MARSH_BUSH = "烧毁了。",
		MARSH_PLANT = "小立池塘侧。",
		MARSH_TREE =
		{
			BURNING = "不是我干的！",
			BURNT = "外焦里嫩。",
			CHOPPED = "变成了木头。",
			GENERIC = "看着眼睛疼。",
		},
		MAXWELL = "我喜欢这种牌子的咖啡。",  --笑
		MAXWELLHEAD = "我喜欢这种牌子的咖啡。",
		MAXWELLLIGHT = "这是什么？",
		MAXWELLLOCK = "看起来就像一个钥匙孔。",
		MAXWELLTHRONE = "他看起来不舒服啊。",
		MEAT = "割肉奉君尽丹心，但愿主公常清明。",
		MEATBALLS = "大地说：要用冰块搓肉丸。",
		MEATRACK =
		{
			DONE = "迫不及待了！",
			DRYING = "需要耐心。",
			DRYINGINRAIN = "浸水可不好。",
			GENERIC = "肉呢？",
			BURNT = "哎呀！",
		},
		MEAT_DRIED = "肉滑溜醇香，肥而不腻，食之软烂醇香。",
		MERM = "鱼成精了。",
		MERMHEAD = 
		{
			GENERIC = "没有生命气息。",
			BURNT = "不是我干的！",
		},
		MERMHOUSE = 
		{
			GENERIC = "里面塞了多少人哇！",
			BURNT = "付之一炬。",
		},
		MINERHAT = "在地府应该很有用。",
		MONKEY = "这家伙想偷东西。",
		MONKEYBARREL = "为什么我有一种想要烧了它的冲动？",
		MONSTERLASAGNA = "就不能用点正常料理吗？",
		FLOWERSALAD = "厨艺渐增！",
        ICECREAM = "再多个球吧！",
        WATERMELONICLE = "解渴消暑人人爱！",
        TRAILMIX = "水果，水果，一杯水果。",
        HOTCHILI = "不是很辣。",
        GUACAMOLE = "我怎么会做出此等黑暗料理。",
		MONSTERMEAT = "烤熟……应该能吃吧？",
		MONSTERMEAT_DRIED = "烧掉，快烧掉！",
		MOOSE = "它长着漂亮的眼睫毛！",
		MOOSEEGG = "是你，天气之子！",
		MOSSLING = "小鹅？小鸭子？",
		FEATHERFAN = "我不需要它。",
        MINIFAN = "小玩意儿。",
		GOOSE_FEATHER = "舒适的手感。",
		STAFF_TORNADO = "这东西敌我不分啊！",
		MOSQUITO =
		{
			GENERIC = "黑蚊子多！",  --我错了 不该玩梗的
			HELD = "希望你没有变成冰渣。",
		},
		MOSQUITOSACK = "哦！",
		MOUND =
		{
			DUG = "我到底在干什么……",
			GENERIC = "古墓碑表折,荒垄松柏稀。",
		},
		NIGHTLIGHT = "很符合我的颜色。",
		NIGHTMAREFUEL = "莫得灵魂的阿飘。",
		NIGHTSWORD = "不能经常拿着。",
		NITRE = "这是一块硝石。",
		ONEMANBAND = "地狱潮流のboy!",
		PANDORASCHEST = "它里面可能会有很神奇的东西,也可能会有很恐怖的东西.",
		PANFLUTE = "白玉排箫索独吹。",
		PAPYRUS = "莎suo草纸。",
		PENGUIN = "太吵了，这些家伙。",
		PERD = "咕噜！咯噜咯噜咯噜！",
		PEROGIES = "厨艺渐增！",
		PETALS = "沁人心脾，即使是衰败之物。",
		PETALS_EVIL = "花变异了！",
		PHLEGM = "这是什么？这是什么？",
		PICKAXE = "敲石头！",
		PIGGYBACK = "略有些重。",
		PIGHEAD = 
		{	
			GENERIC = "含笑九泉了呐。",
			BURNT = "烧掉才是最好的归宿。",
		},
		PIGHOUSE =
		{
			FULL = "斯是陋室，惟————哎。",
			GENERIC = "猪舍罢了。",
			LIGHTSOUT = "别关灯呀。",
			BURNT = "付之一炬。",
		},
		PIGKING = "我得看看生死簿里有没有这个大块头。",
		PIGMAN =
		{
			DEAD = "阎王要你三更死！",
			FOLLOWER = "且行且珍惜。",
			GENERIC = "让我听听你的内心——嗯？",
			GUARD = "提携玉龙为君死。",
			WEREPIG = "他吸入了过多的阴气！",
		},
		PIGSKIN = "猪浑身是宝。",
		PIGTENT = "好温馨啊。",
		PIGTORCH = "下面的猪头都被压扁了。",
		PINECONE = "白金换得青松树,君既先栽我不栽。",
        PINECONE_SAPLING = "以彼径寸茎，荫此百尺条",
        LUMPY_SAPLING = "白金换得青松树,君既先栽我不栽。",
		PITCHFORK = "人间的工具。",
		PLANTMEAT = "看起来好像能吃。",
		PLANTMEAT_COOKED = "熟的！",
		PLANT_NORMAL =
		{
			GENERIC = "我曾有一片开心农场。",
			GROWING = "魔法水壶忘记带了！",
			READY = "粒粒皆辛苦！",
			WITHERED = "可怜的小家伙。",
		},
		POMEGRANATE = "萧娘初嫁嗜甘酸，嚼破水精千万粒。",
		POMEGRANATE_COOKED = "石榴有必要烤熟吗？？",
		POMEGRANATE_SEEDS = "种子而已。",
		POND = "黄梅时节家家雨,青草池塘处处蛙。",
		POOP = "离我远点！",
		FERTILIZER = "不要带在身上！！",
		PUMPKIN = "岁暮剖南瓜,瓜即卒岁资。",
		PUMPKINCOOKIE = "厨艺渐增！",
		PUMPKIN_COOKED = "差一点就糊了。",
		PUMPKIN_LANTERN = "地府偶尔会有。",
		PUMPKIN_SEEDS = "再多一点就能嗑瓜子了。",
		PURPLEAMULET = "能让穿戴者变成傻子。",
		PURPLEGEM = "可以卖给四老板。",
		RABBIT =
		{
			GENERIC = "雄兔脚扑朔，雌兔眼迷离。",
			HELD = "希望你没有变成冰渣。",
		},
		RABBITHOLE = 
		{
			GENERIC = "狡兔三窟。",
			SPRING = "挖开试试？",
		},
		RAINOMETER = 
		{	
			GENERIC = "凡人的小玩意儿。",
			BURNT = "看来它承受了不该有的伤害。",
		},
		RAINCOAT = "在雨中保护我的皮毛。",
		RAINHAT = "难道戴着帽子就能避雨吗？",
		RATATOUILLE = "蔬菜，全是蔬菜。",
		RAZOR = "你想干什么？！",
		REDGEM = "我能够汲取它的温度。",
		RED_CAP = "毒物。",
		RED_CAP_COOKED = "还是毒物。",
		RED_MUSHROOM =
		{
			GENERIC = "蜡面黄紫光欲湿，酥茎娇脆手轻拾。",
			INGROUND = "蘑菇也会睡觉！",
			PICKED = "采蘑菇的小谛听。",
		},
		REEDS =
		{
			BURNING = "可能是我干的？",
			GENERIC = "蒹葭苍苍,白露为霜。",
			PICKED = "蒹葭萋萋，白露未晞。",
		},
        RELIC = 
        {
            GENERIC = "曾经辉煌的见证。",
            BROKEN = "昙花一现。",
        },
        RUINS_RUBBLE = "残垣断壁。",
        RUBBLE = "残垣断壁！",
		RESEARCHLAB = 
		{	
			GENERIC = "知识就是力量！",
			BURNT = "知识阻止不了业火！",
		},
		RESEARCHLAB2 = 
		{
			GENERIC = "我能点石成金吗？",
			BURNT = "看来不能。",
		},
		RESEARCHLAB3 = 
		{
			GENERIC = "兔子呢？兔子呢？？",
			BURNT = "哎！",
		},
		RESEARCHLAB4 = 
		{
			GENERIC = "这就是魔法！",
			BURNT = "要用魔法打败魔法。",
		},
		RESURRECTIONSTATUE = 
		{
			GENERIC = "天命难违！凡人。",
			BURNT = "烧纸人可还行。",
			RESURRECTIONSTONE = "怎么看都不像是凡间的石头。",
		},		
		ROBIN =
		{
			GENERIC = "朱雀鸟。",
			HELD = "希望你不怕冷。",
		},
		ROBIN_WINTER =
		{
			GENERIC = "雪地又冰天,穷愁十九年。",
			HELD = "我喜欢它！",
		},
		ROBOT_PUPPET = "这是什么这是什么？",
		ROCK_LIGHT =
		{
			GENERIC = "一个陈旧的熔岩坑。",
			OUT = "看起来很脆弱",
			LOW = "岩浆正在冷却.",
			NORMAL = "好看又舒服",
		},
		ROCK = "就是……石头。",
		ROCK_ICE = 
		{
			GENERIC = "能吃上一整个冬天的沙冰！",
			MELTED = "要吃请尽快！",
		},
		ROCK_ICE_MELTED = "试试我的法力？",
		ICE = "冰，水为之，而寒于水。",
		ROCKS = "石头的石头。",
        ROOK = "痛击它队友！",
		ROPE = "绳子。",
		ROTTENEGG = "快扔掉，快！",
		SANITYROCK =
		{
			ACTIVE = "奇怪的凡间建筑。",
			INACTIVE = "奇怪的凡间建筑。",
		},
		SAPLING =
		{
			BURNING = "丧心病狂！",
			WITHERED = "要是我能来的早点。",
			GENERIC = "能长成苹果树吗？",
			PICKED = "莫垂头丧气。",
		},
		SEEDS = "春种一粒粟，秋收万颗子。",
		SEEDS_COOKED = "瓜子一般。",
		SEWING_KIT = "新三年，旧三年，缝缝补补又三年。",
		SHOVEL = "抱歉了，大地。",
		SILK = "十三娘情丝缠缚。",
		SKELETON = "豪杰冢化尘烟。",
		SCORCHED_SKELETON = "烧成炭了！",
		SKULLCHEST = "不确定要不要打开。",
		SMALLBIRD =
		{
			GENERIC = "大眼睛小小鸟！",
			HUNGRY = "我觉得它饿了。",
			STARVING = "肯定是饿了！！",
		},
		SMALLMEAT = "肉食者谋之。",
		SMALLMEAT_DRIED = "绝美的小零食！",
		SPAT = "好一记猛羊摆尾回旋踢！",
		SPEAR = "附上极寒之气。",
		SPIDER =
		{
			DEAD = "魂飞魄散！",
			GENERIC = "这小家伙怕光。",
			SLEEPING = "无家可归的小家伙。",
		},
		SPIDERDEN = "蜘蛛们快乐的家。",
		SPIDEREGGSACK = "种在地狱里？",
		SPIDERGLAND = "有效的药材。",
		SPIDERHAT = "它是用什么……制作的？",
		SPIDERQUEEN = "仅仅是虫子！",
		SPIDER_WARRIOR =
		{
			DEAD = "魂飞魄散吧！",
			GENERIC = "一个陷阱解决你！",
			SLEEPING = "这家伙的警惕性很高……",
		},
		SPOILED_FOOD = "看来我没有好好保存着。",
		STATUEHARP = "分头行动。",
		STATUEMAXWELL = "你介意我敲下来点材料吗？",
		STEELWOOL = "一点都不毛绒绒。",
		STINGER = "手中钉！",
		STRAWHAT = "青箬笠,绿蓑衣。",
		STUFFEDEGGPLANT = "是谁偷了我的酿茄子？！",
		SUNKBOAT = "随波逐流的下场。",
		SWEATERVEST = "用什么做的背心？！",
		REFLECTIVEVEST = "对我来说不实用。",
		HAWAIIANSHIRT = "制芰荷以为衣兮， 集芙蓉以为裳。",
		TAFFY = "犬类摄入太多糖会脱毛！！",
		TALLBIRD = "能飞起来吗？",
		TALLBIRDEGG = "可爱，想养一只！",
		TALLBIRDEGG_COOKED = "我做了什么……",
		TALLBIRDEGG_CRACKED =
		{
			COLD = "我该离远点！",
			GENERIC = "看上去很健康！",
			HOT = "我来给你降温罢！",
			LONG = "我得警惕贪吃的家伙靠近。",
			SHORT = "破壳指日可待！",
		},
		TALLBIRDNEST =
		{
			GENERIC = "有一个蛋！",
			PICKED = "空空如也。",
		},
		TEENBIRD =
		{
			GENERIC = "青鸟，青鸟！",
			HUNGRY = "食物在哪里？",
			STARVING = "它饿极了！",
		},
		TELEBASE =	-- Duplicated
		{
			VALID = "可以进行科学的穿梭了！",
			GEMS = "哎！代价真是高。",
		},
		GEMSOCKET = -- Duplicated
		{
			VALID = "看起来准备就绪了。",
			GEMS = "它需要一颗宝石。",
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
		TELESTAFF = "嘛……效果一般般。",		-- 物品名:"传送魔杖" 制造描述:"穿越空间的法杖！穿越时间的装置需另外购买。"
		TENT = 
		{
			GENERIC = "白泽枕有吗？",
			BURNT = "是我梦游干的吗？",
		},
		SIESTAHUT = 
		{
			GENERIC = "睡午觉！",
			BURNT = "要睡在灰烬里吗？",
		},
		TENTACLE = "我知道你在哪里！",
		TENTACLESPIKE = "好一个杀伤性武器！",
		TENTACLESPOTS = "我打赌小髅也不想要这些皮。",
		TENTACLE_PILLAR = "啊呀！",
        TENTACLE_PILLAR_HOLE = "大地，这个通向何处？",
		TENTACLE_PILLAR_ARM = "危险，别靠近！",
		TENTACLE_GARDEN = "触手，又见触手。",
		TOPHAT = "让人增高的帽子。",
		TORCH = "凡间小火可承受不了阴冷极寒！",
		TRANSISTOR = "就是个电池？",
		TRAP = "你看没有诱饵能行吗？",
		TRAP_TEETH = "为何我踩上去没事呢？",
		TRAP_TEETH_MAXWELL = "我可不想踩在那上面！",
		TREASURECHEST = 
		{
			GENERIC = "别从外表看它小！",
			BURNT = "抱歉，我没能拯救你。",
		},
		TREASURECHEST_TRAP = "不上锁吗？",
		TREECLUMP = "我听不出来里面有什么。",
		
		TRINKET_1 = "小小玻璃球。", --Melty Marbles
		TRINKET_2 = "稀奇古怪的玩意儿。", --Fake Kazoo
		TRINKET_3 = "卖掉或埋掉。", --Gord's Knot
		TRINKET_4 = "卖掉或埋掉。", --Gnome
		TRINKET_5 = "卖掉或埋掉。", --Tiny Rocketship
		TRINKET_6 = "猪财主要此物何用？", --Frazzled Wires
		TRINKET_7 = "卖掉或埋掉。", --Ball and Cup
		TRINKET_8 = "卖掉或埋掉。", --Hardened Rubber Bung
		TRINKET_9 = "我的衣服不需要。", --Mismatched Buttons
		TRINKET_10 = "卖掉或埋掉。", --Second-hand Dentures
		TRINKET_11 = "卖掉或埋掉。", --Lying Robot
		TRINKET_12 = "卖掉或埋掉。", --Dessicated Tentacle
		TRINKET_13 = "卖掉或埋掉。", --Gnomette
		TRINKET_14 = "卖掉或埋掉。", -- Leaky Teacup
		TRINKET_15 = "卖掉或埋掉。", -- White Bishop
		TRINKET_16 = "卖掉或埋掉。", -- Black Bishop
		TRINKET_17 = "卖掉或埋掉。", -- Bent Spork
		TRINKET_18 = "卖掉或埋掉。", -- Toy Trojan Horse
		TRINKET_19 = "卖掉或埋掉。", -- Unbalanced Top
		TRINKET_20 = "卖掉或埋掉。", -- Back Scratcher
		TRINKET_21 = "卖掉或埋掉。", -- Beaten Beater
		TRINKET_22 = "卖掉或埋掉。", -- Frayed Yarn
		TRINKET_23 = "卖掉或埋掉。", -- Shoe Horn
		TRINKET_24 = "卖掉或埋掉。", -- Lucky Cat Jar
		TRINKET_25 = "卖掉或埋掉。", -- Air Unfreshener
		TRINKET_26 = "卖掉或埋掉。", -- Potato Cup
		TRINKET_27 = "卖掉或埋掉。", -- Wire Hanger
		
		TRUNKVEST_SUMMER = "略有点暖和！",
		TRUNKVEST_WINTER = "很适合我！",
		TRUNK_COOKED = "太残忍了！太残忍了！",
		TRUNK_SUMMER = "就是象鼻。",
		TRUNK_WINTER = "就是象鼻。",
		TUMBLEWEED = "我听不出里面的奥秘！",
		TURKEYDINNER = "偶尔吃点也不错！",
		TWIGS = "越多越好！",
		UMBRELLA = "是谁又撑起这一把断桥伞？",
		GRASS_UMBRELLA = "雨丝连成线，牵出几世缘。",
		UNIMPLEMENTED = "求人不如求己。",
		WAFFLES = "厨艺渐增！",
		WALL_HAY = 
		{	
			GENERIC = "一把火就全没了。",
			BURNT = "你看吧？你看吧！",
		},
		WALL_HAY_ITEM = "一把火就全没了。",
		WALL_STONE = "坚固，可靠！",
		WALL_STONE_ITEM = "坚固，可靠！",
		WALL_RUINS = "真是穷奢极欲！",
		WALL_RUINS_ITEM = "真是穷奢极欲！",
		WALL_WOOD = 
		{
			GENERIC = "这里的生物从不把它当墙看…",
			BURNT = "可怜焦土！",
		},
		WALL_WOOD_ITEM = "这里的生物从不把它当墙看…",
		WALL_MOONROCK = "不能放错了啊。",
		WALL_MOONROCK_ITEM = "不能放错了啊。",
		WALRUS = "不错的帽子！",
		WALRUSHAT = "现在我得到它了！",
		WALRUS_CAMP =
		{
			EMPTY = "听到了狩猎者存在的痕迹。",
			GENERIC = "还挺温馨的！",
		},
		WALRUS_TUSK = "牙啊。",
		WARDROBE = 
		{
			GENERIC = "有个问题，衣服从哪里冒出来的？",
            BURNING = "我觉得可以抢救一下！",
			BURNT = "我的衣服啊！",
		},
		WARG = "一起回地府吗？你很强壮呢！",
		WASPHIVE = "别叮我。",
		WATERMELON = "我去吃个瓜。",
		WATERMELON_COOKED = "黑暗料理……",
		WATERMELONHAT = "难道就不能吃几口再做这个帽子吗？",
		WETGOOP = "厨艺渐……哎！",
		WINTERHAT = "毛绒绒的帽子~",
		WINTEROMETER = 
		{
			GENERIC = "呀，会不会做的太大了！",
			BURNT = "它死前一定很痛苦。",
		},
		WORMHOLE =
		{
			GENERIC = "奇怪的东西。",
			OPEN = "二话不说，先跳进去。",
		},
		WORMHOLE_LIMITED = "嘶，我不能跳进去了。",
		ACCOMPLISHMENT_SHRINE = "我想用一下它，我想让全世界都知道我的所作所为。",        
		LIVINGTREE = "你管这个叫完全正常？",
		ICESTAFF = "哈，和我差不多。",
		REVIVER = "我只是来休个假，做不了这种东西！",
		LIFEINJECTOR = "里面塞的是腐烂食物吗！？",
		SKELETON_PLAYER =
		{
			MALE = "%s 在和 %s 的斗争中牺牲了，走得很安详。",
			FEMALE = "%s 在和 %s 的斗争中牺牲了，走得很安详。",
			ROBOT = "%s 在和 %s 的斗争中牺牲了，走得很安详。",
			DEFAULT = "%s 在和 %s 的斗争中牺牲了，走得很安详。",
		},
		HUMANMEAT = "罪恶！",
		HUMANMEAT_COOKED = "罪恶！",
		HUMANMEAT_DRIED = "罪恶！",
		MOONROCKNUGGET = "我将天上月，揉碎在浮藻间。",
	},
	DESCRIBE_GENERIC = "大地知道这是什么。",
	DESCRIBE_TOODARK = "月黑雁飞高！",
	DESCRIBE_SMOLDERING = "冷静点！",
	EAT_FOOD =
	{
		TALLBIRDEGG_CRACKED = "吃了不该吃的东西……",
	},
}
