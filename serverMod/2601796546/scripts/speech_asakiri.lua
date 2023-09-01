--[[
	--- This is Wilson's speech file for Don't Starve Together ---
	Write your character's lines here.
	If you want to use another speech file as a base, or use a more up-to-date version, get them from data\scripts\
	
	If you want to use quotation marks in a quote, put a \ before it.
	Example:
	"Like \"this\"."
]]
return {
	ACTIONFAIL =
	{
		SHAVE =
		{
			AWAKEBEEFALO = "不太明智。",
			GENERIC = "那可不行。",
			NOBITS = "没了。",
		},
		STORE =
		{
			GENERIC = "满了，满了。",
			NOTALLOWED = "不太合适吧。",
			INUSE = "耐心。",
		},
		RUMMAGE =
		{	
			GENERIC = "不太合适吧。",
			INUSE = "耐心。",	
		},
        COOK =
        {
            GENERIC = "不太合适吧。",
            INUSE = "耐心。",
            TOOFAR = "我扔不准。",
        },
        GIVE =
        {
            DEAD = "来不及，来不及。",
            SLEEPING = "不如先叫醒吧。",
            BUSY = "一会再试试。",
        },
        GIVETOPLAYER = 
        {
        	FULL = "不可承受之重。",
            DEAD = "来不及，来不及。",
            SLEEPING = "好好休息吧。",
            BUSY = "一会再试试。",
    	},
    	GIVEALLTOPLAYER = 
        {
        	FULL = "不可承受之重。",
            DEAD = "来不及，来不及。",
            SLEEPING = "好好休息吧。",
            BUSY = "一会再试试。",
    	},
        WRITE =
        {
            GENERIC = "不太合适。",
            INUSE = "耐心。",
        },
        CHANGEIN =
        {
            GENERIC = "我做不到，",
            BURNING = "太危险了。",
            INUSE = "等等。",
        },
        ATTUNE =
        {
            NOHEALTH = "身体很虚弱。",
        },
	},
	ACTIONFAIL_GENERIC = "不可能。",
	ANNOUNCE_ADVENTUREFAIL = "现在还不行。",
	ANNOUNCE_BEES = "蜜蜂！",
	ANNOUNCE_BOOMERANG = "嗷，我不擅长这活儿。",
	ANNOUNCE_CHARLIE = "来者不善。",
	ANNOUNCE_CHARLIE_ATTACK = "机体严重受损！原因不明！",
	ANNOUNCE_COLD = "循环系统不畅！",
	ANNOUNCE_HOT = "机体过热！",
	ANNOUNCE_CRAFTING_FAIL = "材料不足。",
	ANNOUNCE_DEERCLOPS = "听起来…有场硬仗要打了。",
	ANNOUNCE_DUSK = "天色已晚。",
	ANNOUNCE_EAT =
	{
		GENERIC = "嗯…",
		PAINFUL = "感觉不太好。",
		SPOILED = "我也会有食腐的一天吗…",
		STALE = "营养价值已经不行了。",
		INVALID = "无法食用。",
		YUCKY = "这能吃吗？",
	},
	ANNOUNCE_ENTER_DARK = "好黑……",
	ANNOUNCE_ENTER_LIGHT = "是光。",
	ANNOUNCE_FREEDOM = "我自由了吗。",
	ANNOUNCE_HIGHRESEARCH = "I feel so smart now!",
	ANNOUNCE_HOUNDS = "远处有东西在吼叫。",
	ANNOUNCE_WORMS = "有什么东西在地下游走。",
	ANNOUNCE_HUNGRY = "燃料不足。",
	ANNOUNCE_HUNT_BEAST_NEARBY = "猎物就在附近。",
	ANNOUNCE_HUNT_LOST_TRAIL = "看来是追不上了。",
	ANNOUNCE_HUNT_LOST_TRAIL_SPRING = "潮湿会掩盖脚印。跟丢了。",
	ANNOUNCE_INV_FULL = "承重能力不足。",
	ANNOUNCE_KNOCKEDOUT = "不行，不能失去意识…",
	ANNOUNCE_LOWRESEARCH = "I didn't learn very much from that.",
	ANNOUNCE_MOSQUITOS = "Aaah! Bug off!",
    ANNOUNCE_NOWARDROBEONFIRE = "火葬不适合我。",
    ANNOUNCE_NODANGERGIFT = "现在太危险了。",
	ANNOUNCE_NODANGERSLEEP = "现在太危险了。",
	ANNOUNCE_NODAYSLEEP = "睡啥，起来嗨！",
	ANNOUNCE_NODAYSLEEP_CAVE = "我还不累呢。",
	ANNOUNCE_NOHUNGERSLEEP = "燃料不足，我可不想昏死过去。",
	ANNOUNCE_NOSLEEPONFIRE = "你在逗我？",
	ANNOUNCE_NODANGERSIESTA = "现在太危险了。",
	ANNOUNCE_NONIGHTSIESTA = "换个时候吧。",
	ANNOUNCE_NONIGHTSIESTA_CAVE = "换个时候吧。",
	ANNOUNCE_NOHUNGERSIESTA = "燃料不足，我可不想昏死过去。",
	ANNOUNCE_NODANGERAFK = "逃跑并不明智。",
	ANNOUNCE_NO_TRAP = "很容易。",
	ANNOUNCE_PECKED = "哈，中了。",
	ANNOUNCE_QUAKE = "地动山摇。",
	ANNOUNCE_RESEARCH = "Never stop learning!",
	ANNOUNCE_SHELTER = "暂时的喘息。",
	ANNOUNCE_THORNS = "哼。",
	ANNOUNCE_BURNT = "灼伤了。",
	ANNOUNCE_TORCH_OUT = "火灭了。",
	ANNOUNCE_FAN_OUT = "扇子碎了。",
    ANNOUNCE_COMPASS_OUT = "指南针坏了。",
	ANNOUNCE_TRAP_WENT_OFF = "嗯。",
	ANNOUNCE_UNIMPLEMENTED = "还没准备好呢。",
	ANNOUNCE_WORMHOLE = "里面好黑。",
	ANNOUNCE_CANFIX = "\n看起来可以修。",
	ANNOUNCE_ACCOMPLISHMENT = "I feel so accomplished!",
	ANNOUNCE_ACCOMPLISHMENT_DONE = "If only my friends could see me now...",	
	ANNOUNCE_INSUFFICIENTFERTILIZER = "缺乏营养嘛。",
	ANNOUNCE_TOOL_SLIP = "抓不住，太滑了！",
	ANNOUNCE_LIGHTNING_DAMAGE_AVOIDED = "命运站在我这边。",

	ANNOUNCE_DAMP = "机体潮湿。",
	ANNOUNCE_WET = "机体渗水。",
	ANNOUNCE_WETTER = "这样下去不是办法。",
	ANNOUNCE_SOAKED = "我讨厌水！",
	
	ANNOUNCE_BECOMEGHOST = "嗷呜!",
	ANNOUNCE_GHOSTDRAIN = "我将……堕入轮回。",

	DESCRIBE_SAMECHARACTER = "我就是我，颜色不一样的烟火，对吧姐妹。",
	
	BATTLECRY =
	{
		GENERIC = "为了生存！",
		PIG = "切成肉末！",
		PREY = "不足挂齿！",
		SPIDER = "切碎你可憎的脸！",
		SPIDER_WARRIOR = "看起来你很有手感啊！",
	},
	COMBAT_QUIT =
	{
		GENERIC = "战或逃。",
		PIG = "战或逃。",
		PREY = "挺快嘛。",
		SPIDER = "数量太多。",
		SPIDER_WARRIOR = "猛啊。",
	},
	DESCRIBE =
	{
		
		ASA_BLADE = "我有自己的仗要打。",
		ASA_REPAIR = "做好准备，百战不殆。",
		ASA_BOOST = "强大的能量源。",
		ASA_VIZARD = "面子不能丢。",
		ASA_SHOP = "休息的驿站，创造的舞台。",
		ASA_MINE = "知己知彼，百战不殆。",
		
		BERNIE_INACTIVE =
		{
			BROKEN = "心疼。",
			GENERIC = "看起来历经沧桑。",
		},
		BERNIE_ACTIVE = "动起来了。",
		

        PLAYER =
        {
            GENERIC = "这位是 %s。",
            ATTACKER = "%s 看起来很危险。",
            MURDERER = "真坏啊。",
            REVIVER = "救人一命，胜造七级浮屠。",
            GHOST = "%s 还有救。",
        },
		WILSON = 
		{
			GENERIC = "屌丝你好。",
			ATTACKER = "你要干啥。",
			MURDERER = "去死吧！",
			REVIVER = "恩人。",
			GHOST = "还有救。",
		},
		WOLFGANG = 
		{
			GENERIC = "猛男你好。",
			ATTACKER = "你要干啥。",
			MURDERER = "去死吧！",
			REVIVER = "恩人。",
			GHOST = "还有救。",
		},
		WAXWELL = 
		{
			GENERIC = "绅士你好。",
			ATTACKER = "你要干啥。",
			MURDERER = "去死吧！",
			REVIVER = "恩人。",
			GHOST = "还有救。",
		},
		WX78 = 
		{
			GENERIC = "同胞你好。",
			ATTACKER = "你要干啥。",
			MURDERER = "去死吧！",
			REVIVER = "恩人。",
			GHOST = "还有救。",
		},
		WILLOW = 
		{
			GENERIC = "小姐姐你好。",
			ATTACKER = "你要干啥。",
			MURDERER = "去死吧！",
			REVIVER = "恩人。",
			GHOST = "还有救。",
		},
		WENDY = 
		{
			GENERIC = "小姐姐你好。",
			ATTACKER = "你要干啥。",
			MURDERER = "去死吧！",
			REVIVER = "恩人。",
			GHOST = "还有救。",
		},
		WOODIE = 
		{
			GENERIC = "怪人你好。",
			ATTACKER = "你要干啥。",
			MURDERER = "去死吧！",
			REVIVER = "恩人。",
			GHOST = "还有救。",
		},
		WICKERBOTTOM = 
		{
			GENERIC = "长者你好。",
			ATTACKER = "你要干啥。",
			MURDERER = "去死吧！",
			REVIVER = "恩人。",
			GHOST = "还有救。",
		},
		WES = 
		{
			GENERIC = "屌丝你好。",
			ATTACKER = "你要干啥。",
			MURDERER = "去死吧！",
			REVIVER = "恩人。",
			GHOST = "还有救。",
		},
		MULTIPLAYER_PORTAL = "一切的起点。",
        MIGRATION_PORTAL = {
            GENERIC = "重新开始。",
            OPEN = "你会记得我吗。",
            FULL = "看起来很挤啊。",
        },
		GLOMMER = "诡异而又可爱。",
		GLOMMERFLOWER = 
		{
			GENERIC = "肥肥的花。",
			DEAD = "死亡的颜色。",
		},
		GLOMMERWINGS = "破碎的翅膀。",
		GLOMMERFUEL = "闻起来像是，不错的燃料。",
		BELL = "叮铃铃。",
		STATUEGLOMMER = 
		{	
			GENERIC = "某种雕塑。",
			EMPTY = "碎了的雕塑。",
		},

		WEBBERSKULL = "可怜的小朋友。",
		WORMLIGHT = "发光的果实。",
		WORMLIGHT_LESSER = "小小的发光果实。",
		WORM =
		{
		    PLANT = "感觉不对劲。",
		    DIRT = "来了，来了！",
		    WORM = "来吧！",
		},
        WORMLIGHT_PLANT = "看起来没啥问题。",
		MOLE =
		{
			HELD = "别挣扎了。",
			UNDERGROUND = "地下的肉。",
			ABOVEGROUND = "就是现在！",
		},
		MOLEHILL = "偷走了多少矿物。",
		MOLEHAT = "夜视吗，我很好奇原理。",

		EEL = "美味的鳗鱼。",
		EEL_COOKED = "真香。",
		UNAGI = "真不错。",
		EYETURRET = "塔在人在。",
		EYETURRET_ITEM = "隐藏着巨大能量。",
		MINOTAURHORN = "丰厚的战利品。",
		MINOTAURCHEST = "华丽的宝箱。",
		THULECITE_PIECES = "矿物碎片。",
		POND_ALGAE = "水草。",
		GREENSTAFF = "方便的工具。",
		POTTEDFERN = "好看的盆栽。",

		THULECITE = "规则的矿物。",
		ARMORRUINS = "轻便的坚实防御。",
		RUINS_BAT = "尖刺和沉重并存。",
		RUINSHAT = "胜者为王。",
		NIGHTMARE_TIMEPIECE =
		{
            CALM = "无事发生。",
            WARN = "开始了。",
            WAXING = "能量涌动。",
            STEADY = "开始稳定。",
            WANING = "开始变弱了。",
            DAWN = "噩梦即将过去。",
            NOMAGIC = "附近没有魔法能量。",
		},
		BISHOP_NIGHTMARE = "你裂开了，我裂开了。",
		ROOK_NIGHTMARE = "好一张大嘴！",
		KNIGHT_NIGHTMARE = "恐怖如斯。",
		MINOTAUR = "有场硬仗要打了。",
		SPIDER_DROPPER = "你很能跳啊。",
		NIGHTMARELIGHT = "红黑色的光。",
		NIGHTSTICK = "雷电招来！",
		GREENGEM = "绿莹莹的，煞是好看。",
		RELIC = "这算古玩么。",
		RUINS_RUBBLE = "能修好。",
		MULTITOOL_AXE_PICKAXE = "花哨但实用。",
		ORANGESTAFF = "我交了闪现。",
		YELLOWAMULET = "发着耀眼的光亮。",
		GREENAMULET = "感觉不错，还能再省。",
		SLURPERPELT = "一块皮而已。",	

		SLURPER = "你走开。",
		SLURPER_PELT = "一块皮而已。",
		ARMORSLURPER = "勒紧腰带！",
		ORANGEAMULET = "有进无出。",
		YELLOWSTAFF = "呼唤星辰。",
		YELLOWGEM = "黄宝石。",
		ORANGEGEM = "橙色宝石。",
		TELEBASE = 
		{
			VALID = "It's ready to go.",
			GEMS = "It needs more purple gems.",
		},
		GEMSOCKET = 
		{
			VALID = "Looks ready.",
			GEMS = "It needs a gem.",
		},
		STAFFLIGHT = "That seems really dangerous.",
	
        ANCIENT_ALTAR = "An ancient and mysterious structure.",

        ANCIENT_ALTAR_BROKEN = "This seems to be broken.",

        ANCIENT_STATUE = "It seems to throb out of tune with the world.",

        LICHEN = "别踩着了。",
		CUTLICHEN = "原始的植物。",

		CAVE_BANANA = "香蕉。",
		CAVE_BANANA_COOKED = "香甜。",
		CAVE_BANANA_TREE = "香蕉树。",
		ROCKY = "再硬给你翘了。",
		
		COMPASS =
		{
			GENERIC="我在看哪边？",
			N = "North",
			S = "South",
			E = "East",
			W = "West",
			NE = "Northeast",
			SE = "Southeast",
			NW = "Northwest",
			SW = "Southwest",
		},

		NIGHTMARE_TIMEPIECE =	-- Duplicated
		{
			WAXING = "I think it's becoming more concentrated!",
			STEADY = "It seems to be staying steady.",
			WANING = "Feels like it's receding.",
			DAWN = "The nightmare is almost gone!",
			WARN = "Getting pretty magical around here.",
			CALM = "All is well.",
			NOMAGIC = "There's no magic around here.",
		},

		HOUNDSTOOTH="锋利的武器。",
		ARMORSNURTLESHELL="这也行？",
		BAT="小东西。",
		BATBAT = "花哨。",
		BATWING="烤翅安排一下。",
		BATWING_COOKED="真香。",
        BATCAVE = "不太安全。",
		BEDROLL_FURRY="舒服的毛毯。",
		BUNNYMAN="我有肉，你打我呀。",
		FLOWER_CAVE="奈落之花。",
		FLOWER_CAVE_DOUBLE="奈落之花。",
		FLOWER_CAVE_TRIPLE="奈落之花。",
		GUANO="高浓度肥料。",
		LANTERN="不错的照明工具。",
		LIGHTBULB="光滑而有弹性。",
		MANRABBIT_TAIL="毛茸茸的。",
		MUSHTREE_TALL = {
            GENERIC = "小蘑菇树。",
            BLOOM = "一股奇怪的味道。",
        },
		MUSHTREE_MEDIUM = {
            GENERIC = "大蘑菇，",
            BLOOM = "一股奇怪的味道。",
        },
		MUSHTREE_SMALL = {
            GENERIC = "巨大蘑菇。",
            BLOOM = "一股奇怪的味道。",
        },
        MUSHTREE_TALL_WEBBED = "不妙。",
        SPORE_TALL = "孢子！",
        SPORE_MEDIUM = "孢子。",
        SPORE_SMALL = "到处飘。",
        SPORE_TALL_INV = "抓住你了。",
        SPORE_MEDIUM_INV = "抓住你了。",
        SPORE_SMALL_INV = "抓住你了。",
		RABBITHOUSE=
		{
			GENERIC = "怪异的造型，奇特的审美。",
			BURNT = "焦土。",
		},
		SLURTLE="Ew. Just ew.",
		SLURTLE_SHELLPIECES="A puzzle with no solution.",
		SLURTLEHAT="I hope it doesn't mess up my hair.",
		SLURTLEHOLE="A den of 'ew'.",
		SLURTLESLIME="If it wasn't useful, I wouldn't touch it.",
		SNURTLE="He's less gross, but still gross.",
		SPIDER_HIDER="Gah! More spiders!",
		SPIDER_SPITTER="I hate spiders!",
		SPIDERHOLE="It's encrusted with old webbing.",
		STALAGMITE="Looks like a rock to me.",
		STALAGMITE_FULL="Looks like a rock to me.",
		STALAGMITE_LOW="Looks like a rock to me.",
		STALAGMITE_MED="Looks like a rock to me.",
		STALAGMITE_TALL="Rocks, rocks, rocks, rocks...",
		STALAGMITE_TALL_FULL="Rocks, rocks, rocks, rocks...",
		STALAGMITE_TALL_LOW="Rocks, rocks, rocks, rocks...",
		STALAGMITE_TALL_MED="Rocks, rocks, rocks, rocks...",

		TURF_CARPETFLOOR = "Yet another ground type.",
		TURF_CHECKERFLOOR = "Yet another ground type.",
		TURF_DIRT = "Yet another ground type.",
		TURF_FOREST = "Yet another ground type.",
		TURF_GRASS = "Yet another ground type.",
		TURF_MARSH = "Yet another ground type.",
		TURF_ROAD = "Yet another ground type.",
		TURF_ROCKY = "Yet another ground type.",
		TURF_SAVANNA = "Yet another ground type.",
		TURF_WOODFLOOR = "Yet another ground type.",

		TURF_CAVE="Yet another ground type.",
		TURF_FUNGUS="Yet another ground type.",
		TURF_SINKHOLE="Yet another ground type.",
		TURF_UNDERROCK="Yet another ground type.",
		TURF_MUD="Yet another ground type.",

		TURF_DECIDUOUS = "Yet another ground type.",
		TURF_SANDY = "Yet another ground type.",
		TURF_BADLANDS = "Yet another ground type.",

		POWCAKE = "这啥。",
        CAVE_ENTRANCE = "开天辟地。",
        CAVE_ENTRANCE_RUINS = "It's probably hiding something.",
        CAVE_ENTRANCE_OPEN = {
            GENERIC = "新世界。",
            OPEN = "不错。",
            FULL = "满了。",
        },
        CAVE_EXIT = {
            GENERIC = "能出去嘛。",
            OPEN = "出去嘛。",
            FULL = "人满为患。",
        },
		MAXWELLPHONOGRAPH = "So that's where the music was coming from.",
		BOOMERANG = "回旋镖射手。",
		PIGGUARD = "你态度好点。",
		ABIGAIL = "姐姐！",
		ADVENTURE_PORTAL = "一切的起点。",
		AMULET = "护身符。",
		ANIMAL_TRACK = "大型生物的踪迹。",
		ARMORGRASS = "没啥大用。",
		ARMORMARBLE = "完美而厚重的防御。",
		ARMORWOOD = "结实的护甲。",
		ARMOR_SANITY = "一切都有代价，不是吗。",
		ASH =
		{
			GENERIC = "灰烬。",
			REMAINS_GLOMMERFLOWER = "The flower was consumed by fire when I teleported!",
			REMAINS_EYE_BONE = "The eyebone was consumed by fire when I teleported!",
			REMAINS_THINGIE = "This was once some thing before it got burned...",
		},
		AXE = "一把斧头。",
		BABYBEEFALO = "小牛。",
		BACKPACK = "背包。",
		BACONEGGS = "还不错。",
		BANDAGE = "没用。",
		BASALT = "很坚实嘛。",
		BATBAT = "花哨。",	-- Duplicated
		BEARDHAIR = "哪来的胡须。",
		BEARGER = "熊大来了。",
		BEARGERVEST = "熊皮袄子。",
		ICEPACK = "冰冷的背包。",
		BEARGER_FUR = "毛皮。",
		BEDROLL_STRAW = "凉草席。",
		BEE =
		{
			GENERIC = "比通常的蜜蜂大而笨拙。",
			HELD = "别嗡了。",
		},
		BEEBOX =
		{
			READY = "蜂蜜满载而归。",
			FULLHONEY = "蜂蜜满载而归。",
			GENERIC = "养蜂的姑娘。",
			NOHONEY = "空了。",
			SOMEHONEY = "再等等。",
			BURNT = "可惜了。",
		},
		BEEFALO =
		{
			FOLLOWER = "平和的追随者。",
			GENERIC = "牛蛙。",
			NAKED = "拔毛的凤凰不如鸡。",
			SLEEPING = "别醒了。",
		},
		BEEFALOHAT = "真帅。",
		BEEFALOWOOL = "多如牛毛。",
		BEEHAT = "防护仅针对蜂类。",
		BEEHIVE = "野蜂飞舞。",
		BEEMINE = "It buzzes when I shake it.",
		BEEMINE_MAXWELL = "Bottled mosquito rage!",
		BERRIES = "简单的营养来源。",
		BERRIES_COOKED = "结构已分解。",
		BERRYBUSH =
		{
			BARREN = "果树需要施肥。",
			WITHERED = "太热了。",
			GENERIC = "红色浆果，充满营养。",
			PICKED = "不急，过几天就长出来了。",
		},
		BIGFOOT = "That is one biiig foot.",
		BIRDCAGE =
		{
			GENERIC = "养只鸟类。",
			OCCUPIED = "你跑不了。",
			SLEEPING = "别睡了。",
			HUNGRY = "它饿了。",
			STARVING = "Did I forget to feed you?",
			DEAD = "Maybe he's just resting?",
			SKELETON = "That bird is definitely deceased.",
		},
		BIRDTRAP = "抓鸟用的。",
		BIRD_EGG = "鸡蛋。",
		BIRD_EGG_COOKED = "太阳蛋。",
		BISHOP = "你要远程传教吗。",
		BLOWDART_FIRE = "火箭。",
		BLOWDART_SLEEP = "无聊的小玩意。",
		BLOWDART_PIPE = "喷射死亡。",
		BLUEAMULET = "散发着寒光。",
		BLUEGEM = "冰冷的心。",
		BLUEPRINT = "未来的蓝图。",
		BELL_BLUEPRINT = "未来的蓝图。",
		BLUE_CAP = "黏糊糊。",
		BLUE_CAP_COOKED = "不知道味道如何。",
		BLUE_MUSHROOM =
		{
			GENERIC = "蘑菇。",
			INGROUND = "生息。",
			PICKED = "时间会治愈一切。",
		},
		BOARDS = "建材。",
		BOAT = "一艘船。",
		BONESHARD = "碎骨。",
		BONESTEW = "浓郁的肉汤。",
		BUGNET = "捉虫子用的。",
		BUSHHAT = "这也行？",
		BUTTER = "有人在玩梗？",
		BUTTERFLY =
		{
			GENERIC = "一只花哨的蝴蝶。",
			HELD = "别想跑。",
		},
		BUTTERFLYMUFFIN = "花哨的松饼。",
		BUTTERFLYWINGS = "昆虫富含蛋白质。",
		BUZZARD = "真吵。",
		CACTUS = 
		{
			GENERIC = "带刺，但富含水分。",
			PICKED = "还会长的。",
		},
		CACTUS_MEAT_COOKED = "美味。",
		CACTUS_MEAT = "还是很多刺。",
		CACTUS_FLOWER = "秀色可餐。",

		COLDFIRE =
		{
			EMBERS = "摇曳着熄灭。",
			GENERIC = "勉强照明。",
			HIGH = "真美。",
			LOW = "还行。",
			NORMAL = "不错。",
			OUT = "需要燃料。",
		},
		CAMPFIRE =
		{
			EMBERS = "摇曳着熄灭。",
			GENERIC = "勉强照明。",
			HIGH = "真美。",
			LOW = "还行。",
			NORMAL = "不错。",
			OUT = "需要燃料。",
		},
		CANE = "健步如飞！",
		CATCOON = "猫咪！",
		CATCOONDEN = 
		{
			GENERIC = "里面有东西。",
			EMPTY = "空巢。",
		},
		CATCOONHAT = "福瑞控的最爱。",
		COONTAIL = "九条命也会有那一天。",
		CARROT = "富含维生素。",
		CARROT_COOKED = "稀稀糊糊的。",
		CARROT_PLANTED = "一棵野生的胡萝卜。",
		CARROT_SEEDS = "种子。",
		WATERMELON_SEEDS = "种子。",
		CAVE_FERN = "可以拿来炒腊肉。",
		CHARCOAL = "木炭，很有用。",
        CHESSJUNK1 = "A pile of broken chess pieces.",
        CHESSJUNK2 = "Another pile of broken chess pieces.",
        CHESSJUNK3 = "Even more broken chess pieces.",
		CHESTER = "忠实的小伙伴。",
		CHESTER_EYEBONE =
		{
			GENERIC = "小骨。",
			WAITING = "长眠。",
		},
		COOKEDMANDRAKE = "你没了。",
		COOKEDMEAT = "7分熟。",
		COOKEDMONSTERMEAT = "还是看起来怪怪的。",
		COOKEDSMALLMEAT = "牙签肉。",
		COOKPOT =
		{
			COOKING_LONG = "耐心等待。",
			COOKING_SHORT = "快好了。",
			DONE = "真好。",
			EMPTY = "要做点什么？",
			BURNT = "这也行？",
		},
		CORN = "富含淀粉。",
		CORN_COOKED = "香甜。",
		CORN_SEEDS = "种子。",
		CROW =
		{
			GENERIC = "乌鸦是不详的象征。",
			HELD = "别叫了。",
		},
		CUTGRASS = "干草，最简单的纤维。",
		CUTREEDS = "紧紧一束芦苇。",
		CUTSTONE = "石砖，重要的建材。",
		DEADLYFEAST = "哦豁。",
		DEERCLOPS = "别闹，这就让你安息。",
		DEERCLOPS_EYEBALL = "还看什么？",
		EYEBRELLAHAT =	"绝妙的防护伞。",
		DEPLETED_GRASS =
		{
			GENERIC = "还是草。",
		},
		DEVTOOL = "闻起来很奇怪。",
		DEVTOOL_NODEV = "很难驾驭。",
		DIRTPILE = "土块。",
		DIVININGROD =
		{
			COLD = "The signal is very faint.",
			GENERIC = "It's some kind of homing device.",
			HOT = "This thing's going crazy!",
			WARM = "I'm headed in the right direction.",
			WARMER = "I must be getting pretty close.",
		},
		DIVININGRODBASE =
		{
			GENERIC = "I wonder what it does.",
			READY = "It looks like it needs a large key.",
			UNLOCKED = "Now my machine can work!",
		},
		DIVININGRODSTART = "That rod looks useful!",
		DRAGONFLY = "不太好对付。",
		ARMORDRAGONFLY = "好了。",
		DRAGON_SCALES = "还在散发余温。",
		DRAGONFLYCHEST = "华丽的宝箱。",
		LAVASPIT = 
		{
			HOT = "不妙。",
			COOL = "嗯哼？",
		},

		LAVAE = "热乎。",
		LAVAE_PET = 
		{
			STARVING = "Poor thing must be starving.",
			HUNGRY = "I hear a tiny stomach grumbling.",
			CONTENT = "It seems happy.",
			GENERIC = "Aww. Who's a good monster?",
		},
		LAVAE_EGG = 
		{
			GENERIC = "要孵化吗？",
		},
		LAVAE_EGG_CRACKED =
		{
			COLD = "完了。",
			COMFY = "还好。",
		},
		LAVAE_TOOTH = "尖尖的。",

		DRAGONFRUIT = "花哨，但有效。",
		DRAGONFRUIT_COOKED = "很香。",
		DRAGONFRUIT_SEEDS = "种子。",
		DRAGONPIE = "还行。",
		DRUMSTICK = "大鸡腿。",
		DRUMSTICK_COOKED = "大快朵颐。",
		DUG_BERRYBUSH = "可以种下。",
		DUG_GRASS = "可以种下。",
		DUG_MARSH_BUSH = "可以种下。",
		DUG_SAPLING = "可以种下。",
		DURIAN = "真香，可惜了。",
		DURIAN_COOKED = "碳烤榴莲！",
		DURIAN_SEEDS = "种子。",
		EARMUFFSHAT = "倒是没啥用。",
		EGGPLANT = "鱼香茄子煲。",
		EGGPLANT_COOKED = "矿物质的酽香。",
		EGGPLANT_SEEDS = "种子。",
		DECIDUOUSTREE = 
		{
			BURNING = "燃烧吧。",
			BURNT = "自然规律使然。",
			CHOPPED = "生命转换为了另一种形式。",
			POISON = "你很愤怒嘛。",
			GENERIC = "美丽的树。",
		},
		ACORN = "坚果，没别的。",
        ACORN_SAPLING = "假以时日，将会是另一棵树。",
		ACORN_COOKED = "散发着坚果的香味。",
		BIRCHNUTDRAKE = "一刀一个。",
		EVERGREEN =
		{
			BURNING = "真美。",
			BURNT = "自然规律使然。",
			CHOPPED = "生命转换为了另一种形式。",
			GENERIC = "郁郁葱葱。",
		},
		EVERGREEN_SPARSE =
		{
			BURNING = "真美。",
			BURNT = "自然规律使然。",
			CHOPPED = "生命转换为了另一种形式。",
			GENERIC = "没有生命力的树吗。",
		},
		EYEPLANT = "真恶心。",
		FARMPLOT =
		{
			GENERIC = "I should try planting some crops.",
			GROWING = "Go plants go!",
			NEEDSFERTILIZER = "I think it needs to be fertilized.",
			BURNT = "I don't think anything will grow in a pile of ash.",
		},
		FEATHERHAT = "花里胡哨。",
		FEATHER_CROW = "黑羽。",
		FEATHER_ROBIN = "鲜红的羽毛。",
		FEATHER_ROBIN_WINTER = "苍白，如我。",
		FEM_PUPPET = "She's trapped!",
		FIREFLIES =
		{
			GENERIC = "静静地发亮。",
			HELD = "手心里散发着的微光。",
		},
		FIREHOUND = "高能量体。",
		FIREPIT =
		{
			EMBERS = "火萎了，我也该添柴了？",
			GENERIC = "散发着光和热。",
			HIGH = "望着发呆入神。",
			LOW = "温和的火苗。",
			NORMAL = "嗯，还不错。",
			OUT = "花有重开日，火亦再燃时。",
		},
		COLDFIREPIT =
		{
			EMBERS = "火萎了，我也该添柴了？",
			GENERIC = "像我的心吗。",
			HIGH = "望着发呆入神。",
			LOW = "温和的冰冷火苗。",
			NORMAL = "嗯，还不错。",
			OUT = "花有重开日，火亦再燃时。",
		},
		FIRESTAFF = "火焰魔法吗。",
		FIRESUPPRESSOR = 
		{	
			ON = "运行良好。",
			OFF = "待机中。",
			LOWFUEL = "你也饿了吗。",
		},

		FISH = "有点腥。",
		FISHINGROD = "钓鱼啦。",
		FISHSTICKS = "香酥，想分享给朋友。",
		FISHTACOS = "看起来很好吃。",
		FISH_COOKED = "小心鱼刺。",
		FLINT = "尖锐的石头。",
		FLOWER = "不够美，但也够了呀。",
        FLOWER_WITHERED = "阳光照进来的话，也会发现我早已疯了。",
		FLOWERHAT = "阳光，草地，花环。",
		FLOWER_EVIL = "别样的美感。",
		FOLIAGE = "植物的芳香。",
		FOOTBALLHAT = "结实，凑合。",
		FROG =
		{
			DEAD = "死青蛙。",
			GENERIC = "黏糊糊的玩意儿。",
			SLEEPING = "睡着了？",
		},
		FROGGLEBUNWICH = "吃肉不吐骨，像个二百五。",
		FROGLEGS = "加点紫苏和花椒油。",
		FROGLEGS_COOKED = "椒盐也行。",
		FRUITMEDLEY = "美丽，转瞬即逝。",
		FURTUFT = "动物的毛皮。", 
		GEARS = "重要机械部件。",
		GHOST = "子不语，怪力乱神。",
		GOLDENAXE = "你是要金斧头，还是银斧头呢。",
		GOLDENPICKAXE = "结实耐用。",
		GOLDENPITCHFORK = "这也行？",
		GOLDENSHOVEL = "结实耐用。",
		GOLDNUGGET = "这个世界仅存的金属。",
		GRASS =
		{
			BARREN = "需要施肥。",
			WITHERED = "太热了。",
			BURNING = "很快它将燃烧殆尽。",
			GENERIC = "一簇繁茂的草丛。",
			PICKED = "春风吹又生。",
		},
		GREEN_CAP = "颜色和我的眼睛一样。",
		GREEN_CAP_COOKED = "闻起来很香。",
		GREEN_MUSHROOM =
		{
			GENERIC = "绿蘑菇，吃了加一条命。",
			INGROUND = "万物都有生长节律。",
			PICKED = "等待。",
		},
		GUNPOWDER = "怀念的气息。",
		HAMBAT = "很笨重的钝器。",
		HAMMER = "锤爆你狗头。",
		HEALINGSALVE = "可惜治愈不了我。",
		HEATROCK =
		{
			FROZEN = "挂霜。",
			COLD = "冰爽宜人。",
			GENERIC = "一块特殊的石头。",
			WARM = "温和宜人。",
			HOT = "摸起来发烫。",
		},
		HOME = "人间烟火气。",
		HOMESIGN =
		{
			GENERIC = "写着啥。",
            UNWRITTEN = "啥也没写。",
			BURNT = "焦炭。",
		},
		ARROWSIGN_POST =
		{
			GENERIC = "写着啥。",
            UNWRITTEN = "啥也没写。",
			BURNT = "焦炭。",
		},
		ARROWSIGN_PANEL =
		{
			GENERIC = "写着啥。",
            UNWRITTEN = "啥也没写。",
			BURNT = "焦炭。",
		},
		HONEY = "富含维生素和果糖。",
		HONEYCOMB = "蜂巢是原始的智慧。",
		HONEYHAM = "甜美多汁。",
		HONEYNUGGETS = "炸肉快。",
		HORN = "牛角。",
		HOUND = "狗东西。",
		HOUNDBONE = "哦豁。",
		HOUNDMOUND = "来啦。",
		ICEBOX = "冰箱是个好东西。",
		ICEHAT = "离谱极了。",
		ICEHOUND = "好家伙。",
		INSANITYROCK =
		{
			ACTIVE = "石头而已。",
			INACTIVE = "石头而已。",
		},
		JAMMYPRESERVES = "这是啥。",
		KABOBS = "啥玩意。",
		KILLERBEE =
		{
			GENERIC = "巧了。我是杀蜂人。",
			HELD = "安分点吧。",
		},
		KNIGHT = "决斗吧。",
		KOALEFANT_SUMMER = "全是肉。",
		KOALEFANT_WINTER = "全是肉。",
		KRAMPUS = "给我滚！",
		KRAMPUS_SACK = "欧皇？",
		LEIF = "帅啊。",
		LEIF_SPARSE = "皱巴巴的。",
		LIGHTNING_ROD =
		{
			CHARGED = "充电了。",
			GENERIC = "保护好的我的家当。",
		},
		LIGHTNINGGOAT = 
		{
			GENERIC = "你会有用处的。",
			CHARGED = "看起来有点猛。",
		},
		LIGHTNINGGOATHORN = "丈八蛇矛。",
		GOATMILK = "神了个奇。",
		LITTLE_WALRUS = "快点长大，然后给我死。",
		LIVINGLOG = "看我干嘛。",
		LOG =
		{
			BURNING = "着了。",
			GENERIC = "木材，很实用。",
		},
		LUREPLANT = "别出现在我家里。",
		LUREPLANTBULB = "有点用。",
		MALE_PUPPET = "他是谁。",

		MANDRAKE_ACTIVE = "再吵切了你！",
		MANDRAKE_PLANTED = "我对这玩意儿没兴趣。",
		MANDRAKE = "你没了。",

		MANDRAKESOUP = "让我来吃挺浪费的。",
		MANDRAKE_COOKED = "你死了。",
		MARBLE = "一种矿物。",
		MARBLEPILLAR = "石柱。",
		MARBLETREE = "这也行。",
		MARSH_BUSH =
		{
			BURNING = "很快它将燃烧殆尽。",
			GENERIC = "顽强的植物。",
			PICKED = "切。",
		},
		BURNT_MARSH_BUSH = "一株焦炭。",
		MARSH_PLANT = "顽强的植物。",
		MARSH_TREE =
		{
			BURNING = "很快它将燃烧殆尽。",
			BURNT = "一株焦炭。",
			CHOPPED = "自然规律。",
			GENERIC = "扭曲而怪异。",
		},
		MAXWELL = "I hate that guy.",
		MAXWELLHEAD = "I can see into his pores.",
		MAXWELLLIGHT = "I wonder how they work.",
		MAXWELLLOCK = "Looks almost like a key hole.",
		MAXWELLTHRONE = "That doesn't look very comfortable.",
		MEAT = "结实的腱子肉。",
		MEATBALLS = "鲍汁狮子头。",
		MEATRACK =
		{
			DONE = "晒好了。",
			DRYING = "风干中。",
			DRYINGINRAIN = "屋漏偏逢连夜雨。",
			GENERIC = "晒肉了。",
			BURNT = "可惜了。",
		},
		MEAT_DRIED = "大块肉干，大快朵颐。",
		MERM = "真丑。",
		MERMHEAD = 
		{
			GENERIC = "啥玩意儿。",
			BURNT = "真好。",
		},
		MERMHOUSE = 
		{
			GENERIC = "又脏又破，谁会住那儿。",
			BURNT = "他们没了。",
		},
		MINERHAT = "便携照明用具。",
		MONKEY = "死远点。",
		MONKEYBARREL = "猴子窝。",
		MONSTERLASAGNA = "看起来很黑暗。",
		FLOWERSALAD = "吃草吗。",
        ICECREAM = "冰锅煮冰淇淋。",
        WATERMELONICLE = "啥玩意。",
        TRAILMIX = "小零食。",
        HOTCHILI = "口味菜。",
        GUACAMOLE = "啊哈哈哈。",
		MONSTERMEAT = "看起来不太好吃。",
		MONSTERMEAT_DRIED = "怪味肉干。",
		MOOSE = "深井烧鹅。",
		MOOSEEGG = "大事不妙。",
		MOSSLING = "熊孩子。",
		FEATHERFAN = "大风吹呀吹。",
        MINIFAN = "啊这。",
		GOOSE_FEATHER = "大羽毛。",
		STAFF_TORNADO = "旋风召唤器。",
		MOSQUITO =
		{
			GENERIC = "真想有杀虫剂。",
			HELD = "跑不了了你。",
		},
		MOSQUITOSACK = "都是血。",
		MOUND =
		{
			DUG = "空穴来风。",
			GENERIC = "盗墓笔记。",
		},
		NIGHTLIGHT = "夜空中最亮的星。",
		NIGHTMAREFUEL = "过去的伤痛将化为力量。",
		NIGHTSWORD = "锋利的意志力。",
		NITRE = "化学原料。",
		ONEMANBAND = "好东西。",
		PANDORASCHEST = "不好说。",
		PANFLUTE = "催眠魔法。",
		PAPYRUS = "草蛇灰线。",
		PENGUIN = "笑死，企鹅肉哎。",
		PERD = "跑得挺快。",
		PEROGIES = "这算水饺吗。",
		PETALS = "落红不是无情物。",
		PETALS_EVIL = "还是很美。",
		PHLEGM = "啊呸。",
		PICKAXE = "可以开采矿物。",
		PIGGYBACK = "很重。",
		PIGHEAD = 
		{	
			GENERIC = "有猪皮了。",
			BURNT = "脆皮烤猪。",
		},
		PIGHOUSE =
		{
			FULL = "人间烟火气。",
			GENERIC = "人间烟火气。",
			LIGHTSOUT = "小样挺会装。",
			BURNT = "干柴一把。",
		},
		PIGKING = "油腻。",
		PIGMAN =
		{
			DEAD = "死猪不怕开水烫。",
			FOLLOWER = "跟着我，有肉吃。",
			GENERIC = "浑身都是宝。",
			GUARD = "那么凶干嘛？",
			WEREPIG = "又肥又凶猛。",
		},
		PIGSKIN = "韧性十足。",
		PIGTENT = "肉味。",
		PIGTORCH = "看起来不太好。",
		PINECONE = "生命轮回不息。",
        PINECONE_SAPLING = "长大吧。",
        LUMPY_SAPLING = "奇迹啊。",
		PITCHFORK = "刀叉。",
		PLANTMEAT = "也是肉。",
		PLANTMEAT_COOKED = "还是很奇怪。",
		PLANT_NORMAL =
		{
			GENERIC = "茁壮生长。",
			GROWING = "慢慢长吧。",
			READY = "收割时间。",
			WITHERED = "卧槽。",
		},
		POMEGRANATE = "籽儿太多了。",
		POMEGRANATE_COOKED = "石榴也能烤着吃？",
		POMEGRANATE_SEEDS = "种子。",
		POND = "这么小的池塘。",
		POOP = "种地还是挺有趣的。",
		FERTILIZER = "肥料桶。",
		PUMPKIN = "大南瓜。",
		PUMPKINCOOKIE = "南瓜饼。",
		PUMPKIN_COOKED = "软糯。",
		PUMPKIN_LANTERN = "可爱的。",
		PUMPKIN_SEEDS = "种子。",
		PURPLEAMULET = "不带比较好。",
		PURPLEGEM = "诡异的气息。",
		RABBIT =
		{
			GENERIC = "弱小而又顽强的生灵。",
			HELD = "你跑不了。",
		},
		RABBITHOLE = 
		{
			GENERIC = "想往里面灌铅水。",
			SPRING = "塌了。",
		},
		RAINOMETER = 
		{	
			GENERIC = "It measures cloudiness.",
			BURNT = "The measuring parts went up in a cloud of smoke.",
		},
		RAINCOAT = "雨衣。",
		RAINHAT = "防雨的帽子。",
		RATATOUILLE = "I cooked it myself!",
		RAZOR = "简单的剃刀",
		REDGEM = "色泽红润的矿物。",
		RED_CAP = "闻起来不对头。",
		RED_CAP_COOKED = "现在还是怪怪的。",
		RED_MUSHROOM =
		{
			GENERIC = "鲜红的蘑菇。",
			INGROUND = "万物都有生长节律。",
			PICKED = "耐心等待。",
		},
		REEDS =
		{
			BURNING = "很快将化为灰烬。",
			GENERIC = "一丛芦苇。",
			PICKED = "可用的部分都被采光了。",
		},
        RELIC = 
        {
            GENERIC = "Ancient household goods.",
            BROKEN = "Nothing to work with here.",
        },
        RUINS_RUBBLE = "可以被修好。",
        RUBBLE = "碎石。",
		RESEARCHLAB = 
		{	
			GENERIC = "原始的科学。",
			BURNT = "可惜了。",
		},
		RESEARCHLAB2 = 
		{
			GENERIC = "离科学越来越近。",
			BURNT = "可惜了。",
		},
		RESEARCHLAB3 = 
		{
			GENERIC = "散发着可怕的能量。",
			BURNT = "可惜了。",
		},
		RESEARCHLAB4 = 
		{
			GENERIC = "奇葩玩意。",
			BURNT = "可惜了。",
		},
		RESURRECTIONSTATUE = 
		{
			GENERIC = "备份身体。",
			BURNT = "可惜了。",
		},		RESURRECTIONSTONE = "从来不缺从头再来的勇气。",
		ROBIN =
		{
			GENERIC = "鲜红的鸟儿。",
			HELD = "挣扎是徒劳的。",
		},
		ROBIN_WINTER =
		{
			GENERIC = "那是我吗。",
			HELD = "抓住你了。",
		},
		ROBOT_PUPPET = "那是谁？",
		ROCK_LIGHT =
		{
			GENERIC = "A crusted over lava pit.",
			OUT = "看起来很脆。",
			LOW = "The lava's crusting over.",
			NORMAL = "Nice and comfy.",
		},
		ROCK = "我需要一把开采工具。",
		ROCK_ICE = 
		{
			GENERIC = "冰山。",
			MELTED = "一滩水而已。",
		},
		ROCK_ICE_MELTED = "一滩水而已。",
		ICE = "冰块。",
		ROCKS = "最基础的建材。",
        ROOK = "战车？",
		ROPE = "结实的草绳。",
		ROTTENEGG = "闻不到，但一定很臭。",
		SANITYROCK =
		{
			ACTIVE = "起来了。",
			INACTIVE = "下去了。",
		},
		SAPLING =
		{
			BURNING = "很快它将燃烧殆尽。",
			WITHERED = "太热了。",
			GENERIC = "小树苗，仅此而已。",
			PICKED = "但愿她不会疼。",
		},
		SEEDS = "开盲盒我没兴趣。",
		SEEDS_COOKED = "嗑瓜子我更没兴趣。",
		SEWING_KIT = "临行密密缝，意恐迟迟归。",
		SHOVEL = "好一把洛阳铲。",
		SILK = "顺滑的丝线。",
		SKELETON = "精神永存。",
		SCORCHED_SKELETON = "看起来不妙。",
		SKULLCHEST = "有点吓人。",
		SMALLBIRD =
		{
			GENERIC = "小鸟依人。",
			HUNGRY = "自己去找吃的吧。",
			STARVING = "看来是真饿了。",
		},
		SMALLMEAT = "骨肉相连。",
		SMALLMEAT_DRIED = "有嚼劲的肉干。",
		SPAT = "丑陋的东西。",
		SPEAR = "原始的武器，但有效。",
		SPIDER =
		{
			DEAD = "哼哼。",
			GENERIC = "你很凶嘛。",
			SLEEPING = "这样倒有几分可爱。",
		},
		SPIDERDEN = "黏糊糊。",
		SPIDEREGGSACK = "安分点。",
		SPIDERGLAND = "一股消毒水味。",
		SPIDERHAT = "我不想戴这玩意儿。",
		SPIDERQUEEN = "就是个大号蜘蛛。",
		SPIDER_WARRIOR =
		{
			DEAD = "没了。",
			GENERIC = "看起来很抗揍。",
			SLEEPING = "可以偷袭。",
		},
		SPOILED_FOOD = "腐殖质。",
		STATUEHARP = "无头骑士异闻录。",
		STATUEMAXWELL = "至于吗。",
		STEELWOOL = "钢丝球。",
		STINGER = "尖刺。",
		STRAWHAT = "农民的草帽。",
		STUFFEDEGGPLANT = "茄子煲。",
		SUNKBOAT = "沉舟侧畔千帆过。",
		SWEATERVEST = "温暖的毛衣。",
		REFLECTIVEVEST = "闪闪亮。",
		HAWAIIANSHIRT = "不错。",
		TAFFY = "甜食的诱惑。",
		TALLBIRD = "气场一米八。",
		TALLBIRDEGG = "好大的蓝蛋蛋。",
		TALLBIRDEGG_COOKED = "充满卡路里。",
		TALLBIRDEGG_CRACKED =
		{
			COLD = "Brrrr!",
			GENERIC = "Looks like it's hatching.",
			HOT = "Are eggs supposed to sweat?",
			LONG = "I have a feeling this is going to take a while...",
			SHORT = "It should hatch any time now.",
		},
		TALLBIRDNEST =
		{
			GENERIC = "诱惑十足。",
			PICKED = "空巢。",
		},
		TEENBIRD =
		{
			GENERIC = "Not a very tall bird.",
			HUNGRY = "I'd better find it some food.",
			STARVING = "It has a dangerous look in it's eye.",
		},
		TELEBASE =	-- Duplicated
		{
			VALID = "可以传送了。",
			GEMS = "需要紫宝石。",
		},
		GEMSOCKET = -- Duplicated
		{
			VALID = "看起来没问题。",
			GEMS = "现在需要一个宝石。",
		},
		TELEPORTATO_BASE =
		{
			ACTIVE = "With this I can surely pass through space and time!",
			GENERIC = "This appears to be a nexus to another world!",
			LOCKED = "There's still something missing.",
			PARTIAL = "Soon, my invention will be complete!",
		},
		TELEPORTATO_BOX = "This may control the polarity of the whole universe.",
		TELEPORTATO_CRANK = "Tough enough to handle the most intense experiments.",
		TELEPORTATO_POTATO = "This metal potato contains great and fearful power...",
		TELEPORTATO_RING = "A ring that could focus dimensional energies.",
		TELESTAFF = "It can show me the world.",
		TENT = 
		{
			GENERIC = "漫漫长夜，何来栖所。",
			BURNT = "反正也用不着。",
		},
		SIESTAHUT = 
		{
			GENERIC = "我从不午休。",
			BURNT = "反正也用不着。",
		},
		TENTACLE = "看起来很危险。",
		TENTACLESPIKE = "尖锐的武器。",
		TENTACLESPOTS = "富含胶原蛋白。",
		TENTACLE_PILLAR = "好大！",
        TENTACLE_PILLAR_HOLE = "别进去比较好。",
		TENTACLE_PILLAR_ARM = "好大！",
		TENTACLE_GARDEN = "嗯…",
		TOPHAT = "绅士的帽子。",
		TORCH = "便携光源。",
		TRANSISTOR = "重要的机械部件。",
		TRAP = "很紧实。",
		TRAP_TEETH = "出其不意。",
		TRAP_TEETH_MAXWELL = "I'll want to avoid stepping on that!",
		TREASURECHEST = 
		{
			GENERIC = "储物设备。",
			BURNT = "快灭火！",
		},
		TREASURECHEST_TRAP = "不对劲。",
		TREECLUMP = "It's almost like someone is trying to prevent me from going somewhere.",
		
		TRINKET_1 = "They are all melted together.", --Melty Marbles
		TRINKET_2 = "It's just a cheap replica.", --Fake Kazoo
		TRINKET_3 = "The knot is stuck. Forever.", --Gord's Knot
		TRINKET_4 = "It must be some kind of religious artifact.", --Gnome
		TRINKET_5 = "Sadly, it's too small for me to escape on.", --Tiny Rocketship
		TRINKET_6 = "Their electricity carrying days are over.", --Frazzled Wires
		TRINKET_7 = "I have no time for fun and games!", --Ball and Cup
		TRINKET_8 = "Great. All of my tub stopping needs are met.", --Hardened Rubber Bung
		TRINKET_9 = "I'm more of a zipper person, myself.", --Mismatched Buttons
		TRINKET_10 = "I hope I get out of here before I need these.", --Second-hand Dentures
		TRINKET_11 = "He whispers beautiful lies to me.", --Lying Robot
		TRINKET_12 = "I'm not sure what I should do with a dessicated tentacle.", --Dessicated Tentacle
		TRINKET_13 = "It must be some kind of religious artifact.", --Gnomette
		TRINKET_14 = "Now if I only had some tea...", -- Leaky Teacup
		TRINKET_15 = "The king's bishop.", -- White Bishop
		TRINKET_16 = "This is the wrong bishop.", -- Black Bishop
		TRINKET_17 = "An ice cream fork!", -- Bent Spork
		TRINKET_18 = "I wonder what it's hiding?", -- Toy Trojan Horse
		TRINKET_19 = "It doesn't spin very well.", -- Unbalanced Top
		TRINKET_20 = "Now I can scratch my back; all my problems are solved!", -- Back Scratcher
		TRINKET_21 = "This egg beater is all bent out of shape.", -- Beaten Beater
		TRINKET_22 = "Sadly, it's not strong enough to be useful for anything.", -- Frayed Yarn
		TRINKET_23 = "I can put my shoes on without help, thanks.", -- Shoe Horn
		TRINKET_24 = "Is it really lucky?", -- Lucky Cat Jar
		TRINKET_25 = "It smells kind of stale.", -- Air Unfreshener
		TRINKET_26 = "Food and a cup! The ultimate survival container.", -- Potato Cup
		TRINKET_27 = "Good, I can hang my clothes up if I ever find a hook.", -- Wire Hanger
		
		TRUNKVEST_SUMMER = "Wilderness casual.",
		TRUNKVEST_WINTER = "Winter survival gear.",
		TRUNK_COOKED = "Somehow even more nasal than before.",
		TRUNK_SUMMER = "A light breezy trunk.",
		TRUNK_WINTER = "A thick, hairy trunk.",
		TUMBLEWEED = "Who knows what that tumbleweed has picked up.",
		TURF_CARPETFLOOR = "It's surprisingly scratchy.",	-- Duplicated
		TURF_CHECKERFLOOR = "These are pretty snazzy.",	-- Duplicated
		TURF_DIRT = "A chunk of ground.",	-- Duplicated
		TURF_FOREST = "A chunk of ground.",	-- Duplicated
		TURF_GRASS = "A chunk of ground.",	-- Duplicated
		TURF_MARSH = "A chunk of ground.",	-- Duplicated
		TURF_ROAD = "Hastily cobbled stones.",	-- Duplicated
		TURF_ROCKY = "A chunk of ground.",	-- Duplicated
		TURF_SAVANNA = "A chunk of ground.",	-- Duplicated
		TURF_WOODFLOOR = "These are floorboards.",	-- Duplicated
		TURKEYDINNER = "丰盛的晚餐。",
		TWIGS = "一把平平无奇的小树枝。",
		UMBRELLA = "好看的皮伞。",
		GRASS_UMBRELLA = "花伞。",
		UNIMPLEMENTED = "还没完事。",
		WAFFLES = "松软香浓。",
		WALL_HAY = 
		{	
			GENERIC = "Hmmmm. I guess that'll have to do.",
			BURNT = "That won't do at all.",
		},
		WALL_HAY_ITEM = "This seems like a bad idea.",
		WALL_STONE = "That's a nice wall.",
		WALL_STONE_ITEM = "They make me feel so safe.",
		WALL_RUINS = "An ancient piece of wall.",
		WALL_RUINS_ITEM = "A solid piece of history.",
		WALL_WOOD = 
		{
			GENERIC = "带刺又如何。",
			BURNT = "这才是它的宿命。",
		},
		WALL_WOOD_ITEM = "可燃的木墙，没啥大用。",
		WALL_MOONROCK = "坚固的墙体。",
		WALL_MOONROCK_ITEM = "可以起到一定防御作用。",
		WALRUS = "送我个手杖吧球球了。",
		WALRUSHAT = "漂亮的帽子。",
		WALRUS_CAMP =
		{
			EMPTY = "会有人来吗。",
			GENERIC = "看起来温暖，却暗藏杀机。",
		},
		WALRUS_TUSK = "光滑洁白。",
		WARDROBE = 
		{
			GENERIC = "换衣服的东西。",
            BURNING = "烧起来了。",
			BURNT = "没办法。",
		},
		WARG = "你啥也不是，你就是条狗。",
		WASPHIVE = "看上去很危险。",
		WATERMELON = "甜甜的。",
		WATERMELON_COOKED = "这也行？",
		WATERMELONHAT = "什么玩意儿。",
		WETGOOP = "嗯……",
		WINTERHAT = "漂亮的帽子。",
		WINTEROMETER = 
		{
			GENERIC = "温度计。华而不实。",
			BURNT = "无所谓。",
		},
		WORMHOLE =
		{
			GENERIC = "通往另一个未知。",
			OPEN = "跳还是不跳？",
		},
		WORMHOLE_LIMITED = "Guh, that thing looks worse off than usual.",
		ACCOMPLISHMENT_SHRINE = "I want to use it, and I want the world to know what I did.",        
		LIVINGTREE = "你看起来很拽嘛。",
		ICESTAFF = "冰冷的心。",
		REVIVER = "心在动。",
		LIFEINJECTOR = "可惜我可以维修自己。",
		SKELETON_PLAYER =
		{
			MALE = "%s 死于 %s.",
			FEMALE = "%s 死于 %s.",
			ROBOT = "%s 死于 %s.",
			DEFAULT = "%s 死于 %s.",
		},
		HUMANMEAT = "都是燃料。",
		HUMANMEAT_COOKED = "依然是燃料。",
		HUMANMEAT_DRIED = "干柴。",
		MOONROCKNUGGET = "高硬度，低密度的天然材料。",
	},
	DESCRIBE_GENERIC = "世界的造物之一。",
	DESCRIBE_TOODARK = "黎明前的黑暗。",
	DESCRIBE_SMOLDERING = "要看着它着火吗？",
	EAT_FOOD =
	{
		TALLBIRDEGG_CRACKED = "毛蛋，呕。",
	},
}
