--Willow
return{
	ACTIONFAIL =
	{
        APPRAISE =
        {
            NOTNOW = "嘿别再做你正在做的事了，看看这个！",
        },
        REPAIR =
        {
            WRONGPIECE = "我们一直带着它，它甚至不是正确的一个！",
        },
        BUILD =
        {
            MOUNTED = "我在这个大家伙身上不能放置任何东西！",
            HASPET = "我已经有了一个！",
            TICOON = "等等..不！不！",
        },
		SHAVE =
		{
			AWAKEBEEFALO = "也许我应该等它分散注意力。。。",
			GENERIC = "嗯~哼",
			NOBITS = "已经剃了！",
--fallback to speech_wilson.lua             REFUSE = "only_used_by_woodie",
            SOMEONEELSESBEEFALO = "呸，让别人做吧。",
		},
		STORE =
		{
			GENERIC = "已经满了。",
			NOTALLOWED = "这不会让我使用的。",
			INUSE = "做完后我会用的。",
            NOTMASTERCHEF = "我不太擅长烹饪。",
		},
        CONSTRUCT =
        {
            INUSE = "啊。有人已经在用了。",
            NOTALLOWED = "它不会进去的。",
            EMPTY = "我需要先做点什么！",
            MISMATCH = "这是错误的计划。天哪！",
        },
		RUMMAGE =
		{
			GENERIC = "让别人去做！",
			INUSE = "如果你这么想的话，里面一定有好东西！",
            NOTMASTERCHEF = "我不太擅长烹饪。",
		},
		UNLOCK =
        {
--fallback to speech_wilson.lua         	WRONGKEY = "I can't do that.",
        },
		USEKLAUSSACKKEY =
        {
        	WRONGKEY = "这该死的东西不行！",
        	KLAUS = "但那个又大又丑的东西在我尾巴上！",
			QUAGMIRE_WRONGKEY = "你是说还有一把钥匙？！",
        },
		ACTIVATE =
		{
			LOCKED_GATE = "啊。我想进去。",
            HOSTBUSY = "嘿。嘿。嘿。嘿。我会一直走直到你回答我！",
            CARNIVAL_HOST_HERE = "我知道我在这附近见过那个花哨的鸟。",
            NOCARNIVAL = "看起来他们都走了。",
			EMPTY_CATCOONDEN = "见鬼，我确信里面会有好东西！",
			KITCOON_HIDEANDSEEK_NOT_ENOUGH_HIDERS = "这太容易了，也许如果有更多这样的小家伙。。。",
			KITCOON_HIDEANDSEEK_NOT_ENOUGH_HIDING_SPOTS = "周围没有很多地方可供他们藏身。",
			KITCOON_HIDEANDSEEK_ONE_GAME_PER_DAY = "我想这一天就够了。",
		},
        OPEN_CRAFTING = 
        {
            PROFESSIONALCHEF = "我不太擅长烹饪。",
            SHADOWMAGIC = "魔法？",
        },
        COOK =
        {
            GENERIC = "我对烹饪不太在行。",
            INUSE = "嘿你在做什么？能给我吗？",
            TOOFAR = "就在那边！！！",
        },
        START_CARRAT_RACE =
        {
            NO_RACERS = "没有人被击败，比赛就没有乐趣。",
        },

		DISMANTLE =
		{
			COOKING = "我不会在它做饭的时候打断它。",
			INUSE = "但我想用它！",
			NOTEMPTY = "嘿，这里还有东西！",
        },
        FISH_OCEAN =
		{
			TOODEEP = "蠢鱼。快上钩！！",
		},
        OCEAN_FISHING_POND =
		{
			WRONGGEAR = "看起来太过分了。",
		},
        --wickerbottom specific action
--fallback to speech_wilson.lua         READ =
--fallback to speech_wilson.lua         {
--fallback to speech_wilson.lua             GENERIC = "only_used_by_wickerbottom",
--fallback to speech_wilson.lua             NOBIRDS = "only_used_by_wickerbottom"
--fallback to speech_wilson.lua         },

        GIVE =
        {
            GENERIC = "不！",
            DEAD = "他们不会特别感激我的礼物。",
            SLEEPING = "现在不行。它在睡觉。",
            BUSY = "这很忙。",
            ABIGAILHEART = "快回来！天哪！",
            GHOSTHEART = "我不会把这些浪费在他们身上！",
            NOTGEM = "我可以把它塞进去，但我不知道我能不能把它弄出来。",
            WRONGGEM = "这是个石头不太对劲！",
            NOTSTAFF = "我不必把东西塞进我看到的每个洞里！",
            MUSHROOMFARM_NEEDSSHROOM = "啊，它不需要这个！它需要一个蘑菇！",
            MUSHROOMFARM_NEEDSLOG = "啊，它不需要这个！它需要一根活木头！",
            MUSHROOMFARM_NOMOONALLOWED = "这些蠢蘑菇长不出来！",
            SLOTFULL = "不，我穿不合身。",
            FOODFULL = "我得等它先吃了这个。",
            NOTDISH = "我不会把它给狗吃的！",
            DUPLICATE = "啊，我们已经知道了！",
            NOTSCULPTABLE = "我希望有人能用它来雕刻！",
--fallback to speech_wilson.lua             NOTATRIUMKEY = "It's not quite the right shape.",
            CANTSHADOWREVIVE = "它不起作用了。",
            WRONGSHADOWFORM = "不。这不对。",
            NOMOON = "笨蛋！这里不行！",
			PIGKINGGAME_MESSY = "啊。。。你是说我得先打扫干净？",
			PIGKINGGAME_DANGER = "不是现在！周围都是大笨蛋。",
			PIGKINGGAME_TOOLATE = "不。太晚了。",
			CARNIVALGAME_INVALID_ITEM = "我想那是行不通的。",
			CARNIVALGAME_ALREADY_PLAYING = "拜托，快点！",
            SPIDERNOHAT = "为什么它需要一顶帽子当它在我口袋里像虫子一样舒服？",
        },
        GIVETOPLAYER =
        {
            FULL = "他们再也搬不动东西了。",
            DEAD = "他们不会完全感激我的礼物。",
            SLEEPING = "我可以把它放在他们的枕头下。。。？",
            BUSY = "快点！我有一份甜蜜的礼物送给你！",
        },
        GIVEALLTOPLAYER =
        {
            FULL = "他们再也搬不动东西了。",
            DEAD = "他们不会完全感激我的礼物。",
            SLEEPING = "我可以把它放在他们的枕头下...？",
            BUSY = "快点！我有一份甜蜜的礼物送给你！",
        },
        WRITE =
        {
            GENERIC = "我不能在上面写字。",
            INUSE = "我想在你写完后再写！",
        },
        DRAW =
        {
            NOIMAGE = "但我该画什么呢？？",
        },
        CHANGEIN =
        {
            GENERIC = "不，太费劲了。",
            BURNING = "这比一些愚蠢的衣服好多了！",
            INUSE = "别霸占了，我也想打扮一下！",
            NOTENOUGHHAIR = "也许我的头发比皮弗娄牛的毛有更多作用。",
            NOOCCUPANT = "这只是一个猜测，但我可能需要先驯服一头皮弗娄牛。",
        },
        ATTUNE =
        {
            NOHEALTH = "哦，不。。。我感觉不太好。",
        },
        MOUNT =
        {
            TARGETINCOMBAT = "等它安定下来我再骑。",
            INUSE = "他们把我打败了。也许这是最好的。",
        },
        SADDLE =
        {
            TARGETINCOMBAT = "等它安定下来我再骑。",
        },
        TEACH =
        {
            --Recipes/Teacher
            KNOWN = "我已经知道了，天哪！",
            CANTLEARN = "呃，不管怎样，反正我也不想知道。",

            --MapRecorder/MapExplorer
            WRONGWORLD = "什么。。。这张地图一点也不对！",

			--MapSpotRevealer/messagebottle
			MESSAGEBOTTLEMANAGER_NOT_FOUND = "没必要在这里读这些。",--Likely trying to read messagebottle treasure map in caves
        },
        WRAPBUNDLE =
        {
            EMPTY = "我可不想把空气包起来！",
        },
        PICKUP =
        {
			RESTRICTION = "我没用那个！",
			INUSE = "但我想用它！",
--fallback to speech_wilson.lua             NOTMINE_SPIDER = "only_used_by_webber",
            NOTMINE_YOTC =
            {
                "嘿，你不是我的卡拉！",
                "我的是那个橘色的胡须。",
            },
--fallback to speech_wilson.lua 			NO_HEAVY_LIFTING = "only_used_by_wanda",
        },
        SLAUGHTER =
        {
            TOOFAR = "嘿，回来！",
        },
        REPLATE =
        {
            MISMATCH = "啊！我不能用那道菜做那道菜！",
            SAMEDISH = "已经在盘子里了！",
        },
        SAIL =
        {
        	REPAIR = "为什么？我觉得不错。",
        },
        ROW_FAIL =
        {
            BAD_TIMING0 = "我不认为那是对的。",
            BAD_TIMING1 = "啊，失去了节奏。",
            BAD_TIMING2 = "在水边不是我的事。",
        },
        LOWER_SAIL_FAIL =
        {
            "下来，你这蠢货！",
            "天啊，我只是喜欢一遍又一遍地做这件事。",
            "嗯~~~",
        },
        BATHBOMB =
        {
            GLASSED = "呸，用玻璃挡道是不行的。",
            ALREADY_BOMBED = "啊，有人已经做过了！",
        },
		GIVE_TACKLESKETCH =
		{
			DUPLICATE = "啊，我们已经知道了！",
		},
		COMPARE_WEIGHABLE =
		{
            FISH_TOO_SMALL = "这东西太小了，根本不需要称重。",
            OVERSIZEDVEGGIES_TOO_SMALL = "不。我都不想麻烦了。",
		},
        BEGIN_QUEST =
        {
            ONEGHOST = "只有温迪用过",
        },
		TELLSTORY =
		{
			GENERIC = "只有沃尔特用过",
--fallback to speech_wilson.lua 			NOT_NIGHT = "only_used_by_walter",
--fallback to speech_wilson.lua 			NO_FIRE = "only_used_by_walter",
		},
        SING_FAIL =
        {
--fallback to speech_wilson.lua             SAMESONG = "only_used_by_wathgrithr",
        },
        PLANTREGISTRY_RESEARCH_FAIL =
        {
            GENERIC = "呸，我已经知道我需要知道什么了。",
            FERTILIZER = "这就是我想知道的关于这件事的全部。",
        },
        FILL_OCEAN =
        {
            UNSUITABLE_FOR_PLANTS = "噢，来吧！一点点海水会使他们变得更坚强！",
        },
        POUR_WATER =
        {
            OUT_OF_WATER = "哦，不，我没水了，太可怕了。",
        },
        POUR_WATER_GROUNDTILE =
        {
            OUT_OF_WATER = "嗯，我没水了。",
        },
        USEITEMON =
        {
            --GENERIC = "I can't use this on that!",

            --construction is PREFABNAME_REASON
            BEEF_BELL_INVALID_TARGET = "对，那是行不通的。",
            BEEF_BELL_ALREADY_USED = "有人已经做到了。",
            BEEF_BELL_HAS_BEEF_ALREADY = "一杯啤酒就足够了。",
        },
        HITCHUP =
        {
            NEEDBEEF = "如果我有一杯啤酒可能会有帮助。。。",
            NEEDBEEF_CLOSER = "我要把那啤酒拿来。",
            BEEF_HITCHED = "已经做了。",
            INMOOD = "呃，当他们变成这样的时候，他们就没有理由了。",
        },
        MARK =
        {
            ALREADY_MARKED = "不要收回！",
            NOT_PARTICIPANT = "这次比赛我没有牛排。",
        },
        YOTB_STARTCONTEST =
        {
            DOESNTWORK = "嘿，怪人！你好？",
            ALREADYACTIVE = "我猜他在别的地方。",
        },
        YOTB_UNLOCKSKIN =
        {
            ALREADYKNOWN = "我已经知道这个了！",
        },
        CARNIVALGAME_FEED =
        {
            TOO_LATE = "我不是太慢，而是太快了。",
        },
        HERD_FOLLOWERS =
        {
            WEBBERONLY = "这些笨蛋不听我的。",
        },
        BEDAZZLE =
        {
--fallback to speech_wilson.lua             BURNING = "only_used_by_webber",
--fallback to speech_wilson.lua             BURNT = "only_used_by_webber",
--fallback to speech_wilson.lua             FROZEN = "only_used_by_webber",
--fallback to speech_wilson.lua             ALREADY_BEDAZZLED = "only_used_by_webber",
        },
        UPGRADE = 
        {
--fallback to speech_wilson.lua             BEDAZZLED = "only_used_by_webber",
        },
		CAST_POCKETWATCH = 
		{
--fallback to speech_wilson.lua 			GENERIC = "only_used_by_wanda",
--fallback to speech_wilson.lua 			REVIVE_FAILED = "only_used_by_wanda",
--fallback to speech_wilson.lua 			WARP_NO_POINTS_LEFT = "only_used_by_wanda",
--fallback to speech_wilson.lua 			SHARD_UNAVAILABLE = "only_used_by_wanda",
		},
        DISMANTLE_POCKETWATCH =
        {
--fallback to speech_wilson.lua             ONCOOLDOWN = "only_used_by_wanda",
        },
    },
    ANNOUNCE_CANNOT_BUILD =
    {
        NO_INGREDIENTS = "我需要更多的东西。",
        NO_TECH = "我还不知道该怎么做……",
        NO_STATION = "我现在做不了。",
    },

	ACTIONFAIL_GENERIC = "我不能。。。",
	ANNOUNCE_BOAT_LEAK = "可恶，我讨厌水。",
	ANNOUNCE_BOAT_SINK = "我要湿透了！！！",
	ANNOUNCE_DIG_DISEASE_WARNING = "看起来已经好多了。", --removed
	ANNOUNCE_PICK_DISEASE_WARNING = "咳，放在背上！", --removed
	ANNOUNCE_ADVENTUREFAIL = "这次你赢了，麦克斯韦尔。",
    ANNOUNCE_MOUNT_LOWHEALTH = "这只野兽看起来很糟糕。",

    --waxwell and wickerbottom specific strings
--fallback to speech_wilson.lua     ANNOUNCE_TOOMANYBIRDS = "only_used_by_waxwell_and_wicker",
--fallback to speech_wilson.lua     ANNOUNCE_WAYTOOMANYBIRDS = "only_used_by_waxwell_and_wicker",

    --wolfgang specific
--fallback to speech_wilson.lua     ANNOUNCE_NORMALTOMIGHTY = "only_used_by_wolfang",
--fallback to speech_wilson.lua     ANNOUNCE_NORMALTOWIMPY = "only_used_by_wolfang",
--fallback to speech_wilson.lua     ANNOUNCE_WIMPYTONORMAL = "only_used_by_wolfang",
--fallback to speech_wilson.lua     ANNOUNCE_MIGHTYTONORMAL = "only_used_by_wolfang",

	ANNOUNCE_BEES = "蜜蜂！！！！",
	ANNOUNCE_BOOMERANG = "噢，我应该试着抓住它！",
	ANNOUNCE_CHARLIE = "我不怕你！",
	ANNOUNCE_CHARLIE_ATTACK = "哎哟，你这个混蛋！",
--fallback to speech_wilson.lua 	ANNOUNCE_CHARLIE_MISSED = "only_used_by_winona", --winona specific
	ANNOUNCE_COLD = "好冷！",
	ANNOUNCE_HOT = "非常热！",
	ANNOUNCE_CRAFTING_FAIL = "我错过了一些东西。",
	ANNOUNCE_DEERCLOPS = "听起来像是个大家伙！",
	ANNOUNCE_CAVEIN = "我最好保护我的头！",
	ANNOUNCE_ANTLION_SINKHOLE =
	{
		"地面裂开了！",
		"小心点！",
		"地震了！",
	},
	ANNOUNCE_ANTLION_TRIBUTE =
	{
        "嘿，我有东西！",
        "晚餐时间！",
        "伟大的蚁狮！接受这个致敬，或者其他什么。",
	},
	ANNOUNCE_SACREDCHEST_YES = "成功了！",
	ANNOUNCE_SACREDCHEST_NO = "粗鲁",
    ANNOUNCE_DUSK = "时间不早了。天快黑了。",

    --wx-78 specific
--fallback to speech_wilson.lua     ANNOUNCE_CHARGE = "only_used_by_wx78",
--fallback to speech_wilson.lua 	ANNOUNCE_DISCHARGE = "only_used_by_wx78",

	ANNOUNCE_EAT =
	{
		GENERIC = "好吃！",
		PAINFUL = "啊！肮脏的",
		SPOILED = "味道糟透了！",
		STALE = "有点恶心。",
		INVALID = "我怎么会吃这个！",
        YUCKY = "哦，不可能！",

        --Warly specific ANNOUNCE_EAT strings
--fallback to speech_wilson.lua 		COOKED = "only_used_by_warly",
--fallback to speech_wilson.lua 		DRIED = "only_used_by_warly",
--fallback to speech_wilson.lua         PREPARED = "only_used_by_warly",
--fallback to speech_wilson.lua         RAW = "only_used_by_warly",
--fallback to speech_wilson.lua 		SAME_OLD_1 = "only_used_by_warly",
--fallback to speech_wilson.lua 		SAME_OLD_2 = "only_used_by_warly",
--fallback to speech_wilson.lua 		SAME_OLD_3 = "only_used_by_warly",
--fallback to speech_wilson.lua 		SAME_OLD_4 = "only_used_by_warly",
--fallback to speech_wilson.lua         SAME_OLD_5 = "only_used_by_warly",
--fallback to speech_wilson.lua 		TASTY = "only_used_by_warly",
    },

    ANNOUNCE_ENCUMBERED =
    {
        "啊！",
        "我为什么要这么做。。。？！",
        "哦！！",
        "嗯哼！",
        "这。。。这不值得！",
        "左脚。。。右脚。。。",
        "啊！我浑身都是汗！",
        "这。。。太。。。糟糕了。。。",
        "我能感觉到燃烧。。。讨厌！",
        "运动~呼呼~",
        "啊~呼呼~",
    },
    ANNOUNCE_ATRIUM_DESTABILIZING =
    {
		"我可能不该在这里。",
		"这似乎很危险！",
		"那是什么？！",
	},
    ANNOUNCE_RUINS_RESET = "啊，我杀的一切都回来了！",
    ANNOUNCE_SNARED = "真恶心！骨头！",
    ANNOUNCE_SNARED_IVY = "嘿，住手！",
    ANNOUNCE_REPELLED = "嘿！这不公平！",
	ANNOUNCE_ENTER_DARK = "太黑了！",
	ANNOUNCE_ENTER_LIGHT = "我又能看见了！",
	ANNOUNCE_FREEDOM = "我自由了！",
	ANNOUNCE_HIGHRESEARCH = "这么多信息！",
	ANNOUNCE_HOUNDS = "我听到一些声音。",
	ANNOUNCE_WORMS = "我不想知道那是什么声音！",
	ANNOUNCE_HUNGRY = "我要吃点什么！",
	ANNOUNCE_HUNT_BEAST_NEARBY = "我会找到你的！",
	ANNOUNCE_HUNT_LOST_TRAIL = "哦。。。他逃走了。",
	ANNOUNCE_HUNT_LOST_TRAIL_SPRING = "呜呜，我在泥地里找不到他了。",
	ANNOUNCE_INV_FULL = "我只能带这么多！！",
	ANNOUNCE_KNOCKEDOUT = "啊，我的小脑袋！",
	ANNOUNCE_LOWRESEARCH = "太无聊了。",
	ANNOUNCE_MOSQUITOS = "滚开，你们这些吸血鬼！",
    ANNOUNCE_NOWARDROBEONFIRE = "为什么？这样更好。",
    ANNOUNCE_NODANGERGIFT = "那个愚蠢的盒子可以等下！",
    ANNOUNCE_NOMOUNTEDGIFT = "在打开它之前，我得从这个大笨蛋身上下来！",
	ANNOUNCE_NODANGERSLEEP = "没时间睡觉了，还有战斗要做！",
	ANNOUNCE_NODAYSLEEP = "外面太亮了。",
	ANNOUNCE_NODAYSLEEP_CAVE = "这里太可怕了，睡不着。",
	ANNOUNCE_NOHUNGERSLEEP = "我肚子咕噜咕噜，睡不着！",
	ANNOUNCE_NOSLEEPONFIRE = "我担心我要昏倒了。",
	ANNOUNCE_NODANGERSIESTA = "现在不是午睡的时间，是战斗的时间！",
	ANNOUNCE_NONIGHTSIESTA = "我在那里感到不舒服。",
	ANNOUNCE_NONIGHTSIESTA_CAVE = "我真的宁愿待在里面。",
	ANNOUNCE_NOHUNGERSIESTA = "我肚子咕噜咕噜的时候不能睡觉！",
	ANNOUNCE_NODANGERAFK = "我现在不走！",
	ANNOUNCE_NO_TRAP = "那很容易。",
	ANNOUNCE_PECKED = "不，坏鸟！",
	ANNOUNCE_QUAKE = "那声音可能并不意味着什么好事。",
	ANNOUNCE_RESEARCH = "这很有用。",
	ANNOUNCE_SHELTER = "毕竟，除了燃烧之外，你还有其他用处。",
	ANNOUNCE_THORNS = "哎哟",
	ANNOUNCE_BURNT = "我希望我能让它燃烧起来。。。",
	ANNOUNCE_TORCH_OUT = "我珍贵的光芒消失了！",
	ANNOUNCE_THURIBLE_OUT = "啊！我喜欢那东西。",
	ANNOUNCE_FAN_OUT = "愚蠢的东西坏了！",
    ANNOUNCE_COMPASS_OUT = "啊，针卡住了！",
	ANNOUNCE_TRAP_WENT_OFF = "啊！",
	ANNOUNCE_UNIMPLEMENTED = "啊！你这个混蛋！",
	ANNOUNCE_WORMHOLE = "那不是一件明智的事。",
	ANNOUNCE_TOWNPORTALTELEPORT = "迪佳想我了？！哈哈！",
	ANNOUNCE_CANFIX = "\n我想我能解决这个问题！",
	ANNOUNCE_ACCOMPLISHMENT = "快走，箭头！移动",
	ANNOUNCE_ACCOMPLISHMENT_DONE = "我做到了！",
	ANNOUNCE_INSUFFICIENTFERTILIZER = "看起来有点开心。",
	ANNOUNCE_TOOL_SLIP = "我通常不是这样一个毛手毛脚的人。",
	ANNOUNCE_LIGHTNING_DAMAGE_AVOIDED = "我差点被击中！",
	ANNOUNCE_TOADESCAPING = "别想跑了，癞蛤蟆！",
	ANNOUNCE_TOADESCAPED = "啊！但我赢了！",


	ANNOUNCE_DAMP = "哦吼！",
	ANNOUNCE_WET = "这可能很糟糕！",
	ANNOUNCE_WETTER = "我讨厌它！",
	ANNOUNCE_SOAKED = "奥，这是最糟糕的！",

	ANNOUNCE_WASHED_ASHORE = "很好，现在我全身都湿透了。",

    ANNOUNCE_DESPAWN = "火光！",
	ANNOUNCE_BECOMEGHOST = "哇哦！！！",
	ANNOUNCE_GHOSTDRAIN = "我的脑袋都模糊了。。。",
	ANNOUNCE_PETRIFED_TREES = "奇怪的事情正在发生。。。！",
	ANNOUNCE_KLAUS_ENRAGE = "我不会反抗的。",
	ANNOUNCE_KLAUS_UNCHAINED = "为什么它就不能死呢？！",
	ANNOUNCE_KLAUS_CALLFORHELP = "天啊，那些奇怪的恶魔东西来了！",

	ANNOUNCE_MOONALTAR_MINE =
	{
		GLASS_MED = "别担心，我会把你救出来的。",
		GLASS_LOW = "我能看见你！",
		GLASS_REVEAL = "抓住！",
		IDOL_MED = "别担心，我会把你救出来的。",
		IDOL_LOW = "我能看见你！",
		IDOL_REVEAL = "抓住！",
		SEED_MED = "别担心，我会把你救出来的。",
		SEED_LOW = "我能看见你！",
		SEED_REVEAL = "抓住！",
	},

    --hallowed nights
    ANNOUNCE_SPOOKED = "那是些蝙蝠，还是我看到了什么东西。",
	ANNOUNCE_BRAVERY_POTION = "哈哈！那些蝙蝠再也吓不倒我了！",
	ANNOUNCE_MOONPOTION_FAILED = "呵呵。那好吧。",

	--winter's feast
	ANNOUNCE_EATING_NOT_FEASTING = "好的，我会和大家分享。",
	ANNOUNCE_WINTERS_FEAST_BUFF = "就好像有小火花在我周围飞舞！",
	ANNOUNCE_IS_FEASTING = "别说话，得吃饭。",
	ANNOUNCE_WINTERS_FEAST_BUFF_OVER = "哦，伙计。我猜是时候让一些真正的火花飞起来了！",

    --lavaarena event
    ANNOUNCE_REVIVING_CORPSE = "嘿！起来！",
    ANNOUNCE_REVIVED_OTHER_CORPSE = "你搞定了！",
    ANNOUNCE_REVIVED_FROM_CORPSE = "谢谢你的帮忙！",

    ANNOUNCE_FLARE_SEEN = "哦，有人叫我过来。",
    ANNOUNCE_OCEAN_SILHOUETTE_INCOMING = "有大事要发生了！",

    --willow specific
	ANNOUNCE_LIGHTFIRE =
	{
		"嘻嘻！",
		"漂亮",
		"卧槽！",
		"我生了火！",
		"燃烧！",
		"我控制不了！",
    },

    --winona specific
--fallback to speech_wilson.lua     ANNOUNCE_HUNGRY_SLOWBUILD =
--fallback to speech_wilson.lua     {
--fallback to speech_wilson.lua 	    "only_used_by_winona",
--fallback to speech_wilson.lua     },
--fallback to speech_wilson.lua     ANNOUNCE_HUNGRY_FASTBUILD =
--fallback to speech_wilson.lua     {
--fallback to speech_wilson.lua 	    "only_used_by_winona",
--fallback to speech_wilson.lua     },

    --wormwood specific
--fallback to speech_wilson.lua     ANNOUNCE_KILLEDPLANT =
--fallback to speech_wilson.lua     {
--fallback to speech_wilson.lua         "only_used_by_wormwood",
--fallback to speech_wilson.lua     },
--fallback to speech_wilson.lua     ANNOUNCE_GROWPLANT =
--fallback to speech_wilson.lua     {
--fallback to speech_wilson.lua         "only_used_by_wormwood",
--fallback to speech_wilson.lua     },
--fallback to speech_wilson.lua     ANNOUNCE_BLOOMING =
--fallback to speech_wilson.lua     {
--fallback to speech_wilson.lua         "only_used_by_wormwood",
--fallback to speech_wilson.lua     },

    --wortox specfic
--fallback to speech_wilson.lua     ANNOUNCE_SOUL_EMPTY =
--fallback to speech_wilson.lua     {
--fallback to speech_wilson.lua         "only_used_by_wortox",
--fallback to speech_wilson.lua     },
--fallback to speech_wilson.lua     ANNOUNCE_SOUL_FEW =
--fallback to speech_wilson.lua     {
--fallback to speech_wilson.lua         "only_used_by_wortox",
--fallback to speech_wilson.lua     },
--fallback to speech_wilson.lua     ANNOUNCE_SOUL_MANY =
--fallback to speech_wilson.lua     {
--fallback to speech_wilson.lua         "only_used_by_wortox",
--fallback to speech_wilson.lua     },
--fallback to speech_wilson.lua     ANNOUNCE_SOUL_OVERLOAD =
--fallback to speech_wilson.lua     {
--fallback to speech_wilson.lua         "only_used_by_wortox",
--fallback to speech_wilson.lua     },

    --walter specfic
ANNOUNCE_SLINGHSOT_OUT_OF_AMMO ={ "弹药用完了！","没有弹药！",},
--fallback to speech_wilson.lua     ANNOUNCE_STORYTELLING_ABORT_FIREWENTOUT =
--fallback to speech_wilson.lua     {
--fallback to speech_wilson.lua         "only_used_by_walter",
--fallback to speech_wilson.lua     },
--fallback to speech_wilson.lua     ANNOUNCE_STORYTELLING_ABORT_NOT_NIGHT =
--fallback to speech_wilson.lua     {
--fallback to speech_wilson.lua         "only_used_by_walter",
--fallback to speech_wilson.lua     },

    --quagmire event
    QUAGMIRE_ANNOUNCE_NOTRECIPE = "好吧，那没用。",
    QUAGMIRE_ANNOUNCE_MEALBURNT = "哎呀，烧了。嘿嘿。",
    QUAGMIRE_ANNOUNCE_LOSE = "我觉得它很生气！！",
    QUAGMIRE_ANNOUNCE_WIN = "我们从这里出去吧！",

--fallback to speech_wilson.lua     ANNOUNCE_ROYALTY =
--fallback to speech_wilson.lua     {
--fallback to speech_wilson.lua         "Your majesty.",
--fallback to speech_wilson.lua         "Your highness.",
--fallback to speech_wilson.lua         "My liege!",
--fallback to speech_wilson.lua     },

    ANNOUNCE_ATTACH_BUFF_ELECTRICATTACK    = "火花！我喜欢！",
    ANNOUNCE_ATTACH_BUFF_ATTACK            = "你想打架吗？！",
    ANNOUNCE_ATTACH_BUFF_PLAYERABSORPTION  = "过来，混蛋！",
    ANNOUNCE_ATTACH_BUFF_WORKEFFECTIVENESS = "从哪里来的动机？！",
    ANNOUNCE_ATTACH_BUFF_MOISTUREIMMUNITY  = "哈，拿着，水！",
    ANNOUNCE_ATTACH_BUFF_SLEEPRESISTANCE   = "是！我将永远保持清醒！",

    ANNOUNCE_DETACH_BUFF_ELECTRICATTACK    = "闪电魔法消失了。",
    ANNOUNCE_DETACH_BUFF_ATTACK            = "不，我还没打够！",
    ANNOUNCE_DETACH_BUFF_PLAYERABSORPTION  = "可能不是选择打架的最佳时机。",
    ANNOUNCE_DETACH_BUFF_WORKEFFECTIVENESS = "好的。这种动力并没有持续下去。",
    ANNOUNCE_DETACH_BUFF_MOISTUREIMMUNITY  = "啊。回到看水坑的时候。",
    ANNOUNCE_DETACH_BUFF_SLEEPRESISTANCE   = "不，我还不想觉得累！",

	ANNOUNCE_OCEANFISHING_LINESNAP = "嘿，那条笨鱼偷了我的钓具！",
	ANNOUNCE_OCEANFISHING_LINETOOLOOSE = "最好开始摇晃，否则它会跑掉的！",
	ANNOUNCE_OCEANFISHING_GOTAWAY = "啊！愚蠢的鱼。",
	ANNOUNCE_OCEANFISHING_BADCAST = "这真的不是我的事。",
	ANNOUNCE_OCEANFISHING_IDLE_QUOTE =
	{
		"鱼在哪里？",
		"啊。不能再快一点吗？",
		"来吧，你这蠢鱼！",
		"也许我应该找个更好的钓鱼地点。",
	},

	ANNOUNCE_WEIGHT = "重量: {weight}",
	ANNOUNCE_WEIGHT_HEAVY  = "重量: {weight}\n这东西太重了！",

	ANNOUNCE_WINCH_CLAW_MISS = "噢，来吧！我离得够近了！",
	ANNOUNCE_WINCH_CLAW_NO_ITEM = "看来我什么都没抓到。",

    --Wurt announce strings
--fallback to speech_wilson.lua     ANNOUNCE_KINGCREATED = "only_used_by_wurt",
--fallback to speech_wilson.lua     ANNOUNCE_KINGDESTROYED = "only_used_by_wurt",
--fallback to speech_wilson.lua     ANNOUNCE_CANTBUILDHERE_THRONE = "only_used_by_wurt",
--fallback to speech_wilson.lua     ANNOUNCE_CANTBUILDHERE_HOUSE = "only_used_by_wurt",
--fallback to speech_wilson.lua     ANNOUNCE_CANTBUILDHERE_WATCHTOWER = "only_used_by_wurt",
    ANNOUNCE_READ_BOOK =
    {
--fallback to speech_wilson.lua         BOOK_SLEEP = "only_used_by_wurt",
--fallback to speech_wilson.lua         BOOK_BIRDS = "only_used_by_wurt",
--fallback to speech_wilson.lua         BOOK_TENTACLES =  "only_used_by_wurt",
--fallback to speech_wilson.lua         BOOK_BRIMSTONE = "only_used_by_wurt",
--fallback to speech_wilson.lua         BOOK_GARDENING = "only_used_by_wurt",
--fallback to speech_wilson.lua 		BOOK_SILVICULTURE = "only_used_by_wurt",
--fallback to speech_wilson.lua 		BOOK_HORTICULTURE = "only_used_by_wurt",
    },
    ANNOUNCE_WEAK_RAT = "那东西看起来有点粗糙。",

    ANNOUNCE_CARRAT_START_RACE = "好吧，让我们赢得那个奖吧！",

    ANNOUNCE_CARRAT_ERROR_WRONG_WAY = {
        "你这个笨蛋，你走错了路！",
        "嘿！终点线在那边！",
    },
    ANNOUNCE_CARRAT_ERROR_FELL_ASLEEP = "嘿！醒醒！",
    ANNOUNCE_CARRAT_ERROR_WALKING = "我们能不能再快一点？！",
    ANNOUNCE_CARRAT_ERROR_STUNNED = "反应不太好吧？",

    ANNOUNCE_GHOST_QUEST = "只有温迪用过",
--fallback to speech_wilson.lua     ANNOUNCE_GHOST_HINT = "only_used_by_wendy",
--fallback to speech_wilson.lua     ANNOUNCE_GHOST_TOY_NEAR = {
--fallback to speech_wilson.lua         "only_used_by_wendy",
--fallback to speech_wilson.lua     },
--fallback to speech_wilson.lua 	ANNOUNCE_SISTURN_FULL = "only_used_by_wendy",
--fallback to speech_wilson.lua     ANNOUNCE_ABIGAIL_DEATH = "only_used_by_wendy",
--fallback to speech_wilson.lua     ANNOUNCE_ABIGAIL_RETRIEVE = "only_used_by_wendy",
--fallback to speech_wilson.lua 	ANNOUNCE_ABIGAIL_LOW_HEALTH = "only_used_by_wendy",
    ANNOUNCE_ABIGAIL_SUMMON =
	{
--fallback to speech_wilson.lua 		LEVEL1 = "only_used_by_wendy",
--fallback to speech_wilson.lua 		LEVEL2 = "only_used_by_wendy",
--fallback to speech_wilson.lua 		LEVEL3 = "only_used_by_wendy",
	},

    ANNOUNCE_GHOSTLYBOND_LEVELUP =
	{
--fallback to speech_wilson.lua 		LEVEL2 = "only_used_by_wendy",
--fallback to speech_wilson.lua 		LEVEL3 = "only_used_by_wendy",
	},

--fallback to speech_wilson.lua     ANNOUNCE_NOINSPIRATION = "only_used_by_wathgrithr",
--fallback to speech_wilson.lua     ANNOUNCE_BATTLESONG_INSTANT_TAUNT_BUFF = "only_used_by_wathgrithr",
--fallback to speech_wilson.lua     ANNOUNCE_BATTLESONG_INSTANT_PANIC_BUFF = "only_used_by_wathgrithr",

--fallback to speech_wilson.lua     ANNOUNCE_WANDA_YOUNGTONORMAL = "only_used_by_wanda",
--fallback to speech_wilson.lua     ANNOUNCE_WANDA_NORMALTOOLD = "only_used_by_wanda",
--fallback to speech_wilson.lua     ANNOUNCE_WANDA_OLDTONORMAL = "only_used_by_wanda",
--fallback to speech_wilson.lua     ANNOUNCE_WANDA_NORMALTOYOUNG = "only_used_by_wanda",

	ANNOUNCE_POCKETWATCH_PORTAL = "哦呜...",

--fallback to speech_wilson.lua 	ANNOUNCE_POCKETWATCH_MARK = "only_used_by_wanda",
--fallback to speech_wilson.lua 	ANNOUNCE_POCKETWATCH_RECALL = "only_used_by_wanda",
--fallback to speech_wilson.lua 	ANNOUNCE_POCKETWATCH_OPEN_PORTAL = "only_used_by_wanda",
--fallback to speech_wilson.lua 	ANNOUNCE_POCKETWATCH_OPEN_PORTAL_DIFFERENTSHARD = "only_used_by_wanda",

    ANNOUNCE_ARCHIVE_NEW_KNOWLEDGE = "我脑子里都是书呆子的垃圾！",
    ANNOUNCE_ARCHIVE_OLD_KNOWLEDGE = "嗯。我以前见过。",
    ANNOUNCE_ARCHIVE_NO_POWER = "那太令人兴奋了。",

    ANNOUNCE_PLANT_RESEARCHED =
    {
        "很大，既无聊又古老的植物。",
    },

    ANNOUNCE_PLANT_RANDOMSEED = "我想我们看看会发生什么。",

    ANNOUNCE_FERTILIZER_RESEARCHED = "哇，太有趣了。很高兴我把时间花在了学习上，没有做任何其他事情。",

	ANNOUNCE_FIRENETTLE_TOXIN =
	{
		"哦喂，那不是一棵好植物！",
		"哎哟，太辣了！",
	},
	ANNOUNCE_FIRENETTLE_TOXIN_DONE = "呵呵。我有点习惯了。",

	ANNOUNCE_TALK_TO_PLANTS =
	{
        "嘿，植物！怎么样？",
        "啊，你孤独吗？我们会陪你的！",
		"所以植物的东西。。。伙计，这太无聊了。",
        "最近有什么有趣的事吗？对，没有。因为你是一株植物。",
        "你是一株很好的植物。",
	},
	
	ANNOUNCE_KITCOON_HIDEANDSEEK_START = "3, 2, 1... 准备好了没，我来了！",
	ANNOUNCE_KITCOON_HIDEANDSEEK_JOIN = "哦，他们在玩捉迷藏。",
	ANNOUNCE_KITCOON_HIDANDSEEK_FOUND = 
	{
		"找到你了！",
		"给你。",
		"我就知道你会躲在那里！",
		"我看见你了！",
	},
	ANNOUNCE_KITCOON_HIDANDSEEK_FOUND_ONE_MORE = "最后一个藏在哪里？",
	ANNOUNCE_KITCOON_HIDANDSEEK_FOUND_LAST_ONE = "我找到了最后一个！",
	ANNOUNCE_KITCOON_HIDANDSEEK_FOUND_LAST_ONE_TEAM = "{name} 终于找到你了！",
	ANNOUNCE_KITCOON_HIDANDSEEK_TIME_ALMOST_UP = "这些小家伙一定不耐烦了。。。",
	ANNOUNCE_KITCOON_HIDANDSEEK_LOSEGAME = "我猜他们不想再玩了。。。",
	ANNOUNCE_KITCOON_HIDANDSEEK_TOOFAR = "他们可能不会藏这么远吧？",
	ANNOUNCE_KITCOON_HIDANDSEEK_TOOFAR_RETURN = "风筝应该在附近。",
	ANNOUNCE_KITCOON_FOUND_IN_THE_WILD = "我就知道我看到有东西藏在这里！",

	ANNOUNCE_TICOON_START_TRACKING	= "他闻到了气味！",
	ANNOUNCE_TICOON_NOTHING_TO_TRACK = "看起来他什么都找不到。",
	ANNOUNCE_TICOON_WAITING_FOR_LEADER = "我应该跟着他！",
	ANNOUNCE_TICOON_GET_LEADER_ATTENTION = "他真的想让我跟着他。",
	ANNOUNCE_TICOON_NEAR_KITCOON = "他一定找到什么了！",
	ANNOUNCE_TICOON_LOST_KITCOON = "看来有人找到了他要找的东西。",
	ANNOUNCE_TICOON_ABANDONED = "我自己去找那些小家伙。",
	ANNOUNCE_TICOON_DEAD = "可怜的家伙。。。他们要到哪里去？",
	
    -- YOTB
    ANNOUNCE_CALL_BEEF = "嘿，皮弗娄牛！过来！",
    ANNOUNCE_CANTBUILDHERE_YOTB_POST = "皮弗娄牛怎么会在这么远的地方看到我的铃铛呢？",
    ANNOUNCE_YOTB_LEARN_NEW_PATTERN =  "我想我现在可以做一件新的皮弗娄服装了。",
	
	 -- AE4AE
    ANNOUNCE_EYEOFTERROR_ARRIVE = "那是什么，一个巨大的浮动眼球？！",
    ANNOUNCE_EYEOFTERROR_FLYBACK = "最后！",
    ANNOUNCE_EYEOFTERROR_FLYAWAY = "回来，我还没跟你说完呢！",
	
    -- PIRATES
    ANNOUNCE_CANT_ESCAPE_CURSE = "等等，这在我口袋里干什么？我不是刚刚。。。？",
    ANNOUNCE_MONKEY_CURSE_1 = "那是什么？我只是起鸡皮疙瘩。",
    ANNOUNCE_MONKEY_CURSE_CHANGE = "什么。。。嘿！我不想成为猴子！",
    ANNOUNCE_MONKEY_CURSE_CHANGEBACK = "啊，我还是觉得浑身发痒。。。",

    ANNOUNCE_PIRATES_ARRIVE = "呃，那声音越来越近了。。。",

    	BATTLECRY =
	{
		GENERIC = "嘿！",		
		PIG = {"你这个笨蛋！","小猪，小猪！"},		
		PREY = "对不起！",		
		FROG = {"去死吧！","你这个变态！"},		
		SPIDER = {"嘿呀！","放马过来"},
		SPIDER_WARRIOR = {"哈哈！","你会死的！"},
		DEER = "你的灵魂是我的了！",
	},
	COMBAT_QUIT =
	{
		GENERIC = "希娅！",
		PIG = "改天吧，猪。",
		PREY = "下次再说",
		SPIDER = "这还没结束！",
		SPIDER_WARRIOR = "下次！",
	},

	DESCRIBE =
	{
		MULTIPLAYER_PORTAL = "很漂亮。。。漂亮的吓人！",
        MULTIPLAYER_PORTAL_MOONROCK = "它是用某种乱石做的。",
        MOONROCKIDOL = "看起来像个混蛋。",
        CONSTRUCTION_PLANS = "我宁愿把东西拆开，也不愿把它们堆起来。",

        ANTLION =
        {
            GENERIC = "你想要什么？！",
            VERYHAPPY = "你心情很好。",
            UNHAPPY = "我们的未来会有震动。",
        },
        ANTLIONTRINKET = "垃圾。。。",
        SANDSPIKE = "打偏了！",
        SANDBLOCK = "事情变得越来越棘手了！",
        GLASSSPIKE = "那是一种危险的装饰。",
        GLASSBLOCK = "这是一大块玻璃。",
        ABIGAIL_FLOWER =
        {
            GENERIC ="美丽的花瓣！",
			LEVEL1 = "真奇怪！",
			LEVEL2 = "焚烧仍然是一种选择。",
			LEVEL3 = "是的，当然，它现在漂浮着，为什么不呢。",

			-- deprecated
            LONG = "我想它在听我说话！",
            MEDIUM = "真奇怪！",
            SOON = "焚烧仍然是一种选择。",
            HAUNTED_POCKET = "它在我口袋里烧了一个洞。嘿。",
            HAUNTED_GROUND = "我不想搞砸了。",
        },

        BALLOONS_EMPTY = "会有派对吗？！",
        BALLOON = "那只是要求被解雇。",
		BALLOONPARTY = "嘿，你什么时候做热气球？我可以帮忙！",
		BALLOONSPEED =
        {
            DEFLATED = "不许飞走！",
            GENERIC = "小丑有强大的肺使气球如此之大！",
        },
		BALLOONVEST = "吱吱吱吱！哈哈，麦克斯韦尔在哪里，这会让他发疯的！",
		BALLOONHAT = "嘿，兔子！不错！",

        BERNIE_INACTIVE =
        {
            BROKEN = "都搞砸了。",
            GENERIC = "泰迪熊。",
        },

        BERNIE_ACTIVE = "那只泰迪熊在动！",
        BERNIE_BIG = "它既恐怖又可爱！！",

        BOOK_BIRDS = "当我可以随心所欲时，学习毫无意义。",
        BOOK_TENTACLES = "有人会被吸引去读这个。",
        BOOK_GARDENING = "我觉得读那本书没有什么意义。",
		BOOK_SILVICULTURE = "我会坚持自己的实验。",
		BOOK_HORTICULTURE = "我觉得读那本书没有什么意义。",
        BOOK_SLEEP = "奇怪的是，只有500页的电报代码。",
        BOOK_BRIMSTONE = "开头很枯燥，但在接近尾声时变得更好了。",

        PLAYER =
        {
            GENERIC = "嗨 %s！",
            ATTACKER = "%s看起来很狡猾。。。",
            MURDERER = "杀了凶手！",
            REVIVER = "鬼魂给谁打电话？%s",
            GHOST = "我最好给%s买颗心脏。",
            FIRESTARTER = "我相信你有一个非常聪明的理由来解释那场火灾。",
        },
        WILSON =
        {
            GENERIC = "嗨 %s！",
            ATTACKER = "为什么，%s……你眼中的火焰！",
            MURDERER = "嘿%s！你的头发真蠢！啊！",
            REVIVER = "%s不会丢下任何人。",
            GHOST = "我最好给%s买颗心。",
            FIRESTARTER = "燃烧不太科学，%s",
        },
        WOLFGANG =
        {
            GENERIC = "嗨 %s！",
            ATTACKER = "%s！放松点，大个子！",
            MURDERER = "杀死杀人犯！",
            REVIVER = "哇！%s将一个灵魂直接从来世中夺走！",
            GHOST = "嘿%s，你知道心脏是肌肉吗？",
            FIRESTARTER = "不要伤害自己，大个子。",
        },
        WAXWELL =
        {
            GENERIC = "嗨 %s！",
            ATTACKER = "你身上有邪恶，哈%s？！",
            MURDERER = "%s！我就知道你不可信！",
            REVIVER = "哈哈哈%s，你关心我们！",
            GHOST = "有颗心，%s！嘿嘿。",
            FIRESTARTER = "%s，不！！火会伤害你！",
        },
        WX78 =
        {
            GENERIC = "嗨 %s！",
            ATTACKER = "最好在吹垫圈前冷却，%s！",
            MURDERER = "杀人机器人！杀了它！",
            REVIVER = "哈哈哈%s，你关心我们！",
            GHOST = "我最好给%s买颗心。",
            FIRESTARTER = "%s，不！！火会伤害你！",
        },
        WILLOW =
        {
            GENERIC = "嘿！那是我的脸，%s！还给我！",
            ATTACKER = "你让我们看起来疯了，%s！",
            MURDERER = "杀人犯！杀死骗子！",
            REVIVER = "哈哈，不错的一个%s.",
            GHOST = "这真的是我的鬼头发吗？",
            FIRESTARTER = "又一场火灾？好吧，只要你高兴……",
        },
        WENDY =
        {
            GENERIC = "嗨 %s！",
            ATTACKER = "我从未见过你如此热情……",
            MURDERER = "她疯了！杀人犯！",
            REVIVER = "那个女孩真的很喜欢鬼！",
            GHOST = "死亡不是你的事吗，%s？",
            FIRESTARTER = "呃，呃，哦，让我们玩一个不同的游戏，%s.",
        },
        WOODIE =
        {
            GENERIC = "嗨 %s！",
            ATTACKER = "你只是在火上浇油，%s！",
            MURDERER = "杀人犯！",
            REVIVER = "你的血管里有糖浆吗，%s？你太甜了！",
            GHOST = "我最好给%s买颗心。",
            BEAVER = "冷静点，%s.想借伯尼吗？",
            BEAVERGHOST = "%s！太搞笑了！",
            MOOSE = "你一定是在开玩笑。",
            MOOSEGHOST = "为什么长脸？哈！",
            GOOSE = "哈！你真是个混蛋，%s.还是一个喇叭？",
            GOOSEGHOST = "别这么沮丧，我会给你一颗心。",
            FIRESTARTER = "嗯，我想你点了火，%s.",
        },
        WICKERBOTTOM =
        {
            GENERIC = "嗨 %s！",
            ATTACKER = "你的发髻太紧了，%s？",
            MURDERER = "是时候好好烧书了！杀人犯！",
            REVIVER = "%s是一个大软糖！",
            GHOST = "你的心发了吗，%s？开玩笑！嘿！",
            FIRESTARTER = "我相信你有一个非常聪明的理由来解释那场火灾。",
        },
        WES =
        {
            GENERIC = "嗨 %s！",
            ATTACKER = "那个哑剧拳真的很有说服力！哈哈，哦！",
            MURDERER = "你的行动胜于雄辩！杀人犯！",
            REVIVER = "鬼魂呼叫谁？%s！",
            GHOST = "告诉我你需要什么，我会帮你拿的。嘿嘿！",
            FIRESTARTER = "等等，别告诉我，你生了火。",
        },
        WEBBER =
        {
            GENERIC = "嗨 %s！",
            ATTACKER = "嘿%s，你没这么恶毒，是吗？",
            MURDERER = "怪物！杀了他们！",
            REVIVER = "鬼魂呼叫谁？%s！",
            GHOST = "别哭，%s，我要给你一颗心。",
            FIRESTARTER = "我们需要召开一次关于消防安全的小组会议。",
        },
        WATHGRITHR =
        {
            GENERIC = "嗨 %s！",
            ATTACKER = "降低一个等级，%s！",
            MURDERER = "哇！那行为不对！杀人犯！",
            REVIVER = "%s不会让任何人在战斗中倒下！",
            GHOST = "嘿%s，如果你让我戴上你的头盔，我会给你一颗心！",
            FIRESTARTER = "你应该在完成后灭火。",
        },
        WINONA =
        {
            GENERIC = "嗨 %s！",
            ATTACKER = "太粗暴了，%s！天哪！",
            MURDERER = "杀人犯！",
            REVIVER = "%s永不放弃任何人。",
            GHOST = "一颗心肯定会派上用场的！",
            FIRESTARTER = "不要生火，%s！",
        },
        WORTOX =
        {
            GENERIC = "嗨 %s！",
            ATTACKER = "你应该恶作剧其他人，而不是我。",
            MURDERER = "怪物！杀人犯！",
            REVIVER = "我想%s并不都是恶作剧。",
            GHOST = "你看起来有点苍白，先生。",
            FIRESTARTER = "不要耍花招，小鬼先生！",
        },
        WORMWOOD =
        {
            GENERIC = "嗨 %s！",
            ATTACKER = "嘿！把那些匍匐的藤蔓留给你自己吧！",
            MURDERER = "我要杀了你！",
            REVIVER = "嘿，谢谢大家，%s！",
            GHOST = "我认为%s需要一些帮助。",
            FIRESTARTER = "我认为你在火旁不安全。",
        },
        WARLY =
        {
            GENERIC = "嗨 %s！",
            ATTACKER = "%s一直在供应指节三明治。",
            MURDERER = "我要杀了你！",
            REVIVER = "%s永远不会丢下任何人。",
            GHOST = "你是故意的吗？",
           FIRESTARTER = "我认为你不应该生火。",
        },

        WURT =
        {
            GENERIC = "嗨 %s！",
            ATTACKER = "你真是个小恐怖分子，不是吗？",
            MURDERER = "别逼我把你掐死！",
            REVIVER = "谢谢你的手，%s……或者，呃，爪？",
            GHOST = "诶，你怎么了？",
            FIRESTARTER = "我……我认为这是不允许的……",
        },

        WALTER =
        {
            GENERIC = "嗨 %s！",
            ATTACKER = "那个糖果终于啪的一声！",
            MURDERER = "嘿%s，我们来谈谈这个……",
            REVIVER = "好吧，我很抱歉叫你一个好人。",
            GHOST = "我觉得他真的很开心。",
            FIRESTARTER = "哦……我也应该开始生火吗？",
        },

        WANDA =
        {
            GENERIC = "嗨 %s！",
            ATTACKER = "嘿，小心！",
            MURDERER = "你的未来化为泡影，杀人犯！",
            REVIVER = "%s总是在我们需要她的时候。",
            GHOST = "呃……我猜出了什么问题。",
            FIRESTARTER = "住手，%s！你会有麻烦的！",
        },

         WONKEY =
        {
            GENERIC = "我发誓这只猴子在跟着我。",
            ATTACKER = "小心点，我觉得有点疯狂！",
            MURDERER = "那东西很危险！烧了它！",
            REVIVER = "作为一只臭猴子，你很聪明。",
            GHOST = "怎么搞的？你是从树上掉下来的吗？", 
            FIRESTARTER = "呵呵。好猴子。",  
        },

--fallback to speech_wilson.lua         MIGRATION_PORTAL =
--fallback to speech_wilson.lua         {
--fallback to speech_wilson.lua         --    GENERIC = "If I had any friends, this could take me to them.",
--fallback to speech_wilson.lua         --    OPEN = "If I step through, will I still be me?",
--fallback to speech_wilson.lua         --    FULL = "It seems to be popular over there.",
--fallback to speech_wilson.lua         },
        GLOMMER =
        {
            GENERIC = "很模糊！而且黏糊糊的。。。",
            SLEEPING = "好吧，我想它有点可爱。",
        },
        GLOMMERFLOWER =
        {
            GENERIC = "闻起来不太好闻。",
            DEAD = "现在闻起来更难闻了。",
        },
        GLOMMERWINGS = "它们太小了！",
        GLOMMERFUEL = "又黏又怪。",
        BELL = "是除夕夜吗？有烟花吗？！",
        STATUEGLOMMER =
        {
            GENERIC = "这应该是什么吗？",
            EMPTY = "看起来差不多。",
        },

        LAVA_POND_ROCK = "太好了，又一块臭石头！",

		WEBBERSKULL = "这不是我的方式，但葬礼就行了。",
		WORMLIGHT = "很轻。",
		WORMLIGHT_LESSER = "漂亮的小灯。",
		WORM =
		{
		    PLANT = "很轻。",
		    DIRT = "泥土在移动吗？",
		    WORM = "没想到！",
		},
        WORMLIGHT_PLANT = "很轻。",
		MOLE =
		{
			HELD = "离开地面。",
			UNDERGROUND = "躲避光线，嗯？",
			ABOVEGROUND = "过来看一眼！",
		},
		MOLEHILL = "鼹鼠洞。",
		MOLEHAT = "鼹鼠的皮肤有弹性。",

		EEL = "这将是一顿美味的饭。",
		EEL_COOKED = "闻起来好香！",
		UNAGI = "乌纳吉·戴苏基·德苏。",
	    EYETURRET = "我希望这不会激怒我。",
		EYETURRET_ITEM = "在它被放置之前是没有用的。",
		MINOTAURHORN = "我想知道这些角是否代表年龄。",
		MINOTAURCHEST = "我想要那样的大箱子！",
		THULECITE_PIECES = "这个铥矿碎成了碎片。",
		POND_ALGAE = "它一定需要很多水。",
		GREENSTAFF = "这会派上用场的。",
		GIFT = "是给我的对吧？！",
        GIFTWRAP = "我想给别人一些好东西！",
		POTTEDFERN = "罐子里的蕨类植物。",
        SUCCULENT_POTTED = "花盆里的多汁植物。",
		SUCCULENT_PLANT = "我想是仙人掌。",
		SUCCULENT_PICKED = "它被选中了。",
		SENTRYWARD = "哇！我打赌它能看到这么远！",
        TOWNPORTAL =
        {
			GENERIC = "神奇的东西。",
			ACTIVE = "走路是傻瓜的事。",
		},
        TOWNPORTALTALISMAN =
        {
			GENERIC = "讨厌。闻起来像硫磺。",
			ACTIVE = "反正我也不想走路。",
		},
        WETPAPER = "我能想出一个非常快速的方法来晾干它。",
        WETPOUCH = "里面有东西。",
        MOONROCK_PIECES = "哦，看！岩石！啊！",
        MOONBASE =
        {
            GENERIC = "它期待着我的一些东西。",
            BROKEN = "看，一堆碎石头！",
            STAFFED = "快点，蠢石头！",
            WRONGSTAFF = "这显然是完全错误的。",
            MOONSTAFF = "啊！这与燃烧完全相反！",
        },
        MOONDIAL =
        {
			GENERIC = "搞什么鬼？我还能看见月亮！",
			NIGHT_NEW = "新月！太好了，我讨厌旧的！",
			NIGHT_WAX = "月亮在打蜡，不像我。",
			NIGHT_FULL = "已经是满月了。",
			NIGHT_WANE = "月亮出来了！",
			CAVE = "这里不行。",
--fallback to speech_wilson.lua 			WEREBEAVER = "only_used_by_woodie", --woodie specific
			GLASSED = "我觉得它在盯着我看。",
        },
		THULECITE = "我想知道这是从哪里来的？",
		ARMORRUINS = "人类可能不应该穿这个。",
		ARMORSKELETON = "这东西不能打我！",
		SKELETONHAT = "我一看就头疼。",
		RUINS_BAT = "这将使恶魔远离。",
		RUINSHAT = "好像有什么东西在流过。",
		NIGHTMARE_TIMEPIECE =
		{
            CALM = "在我看来很正常。",
            WARN = "这是在警告我。",
            WAXING = "燃料开始有生命了！",
            STEADY = "它几乎在嗡嗡作响。",
            WANING = "我想它正在关闭。",
            DAWN = "我想差不多结束了。",
            NOMAGIC = "我认为它不起作用。",
		},
		BISHOP_NIGHTMARE = "啊哈！",
		ROOK_NIGHTMARE = "它的笑容很难看。",
		KNIGHT_NIGHTMARE = "它看起来很破旧。",
		MINOTAUR = "可怜的家伙。被困在这个迷宫里。",
		SPIDER_DROPPER = "他们来自上面。",
		NIGHTMARELIGHT = "我想知道这有什么作用。",
		NIGHTSTICK = "它是电动的！",
		GREENGEM = "这个感觉很轻。",
		MULTITOOL_AXE_PICKAXE = "太有用了！",
		ORANGESTAFF = "这让我头疼。",
		YELLOWAMULET = "它似乎吸收了周围的黑暗。",
		GREENAMULET = "当我戴上它的时候，我感到我的思想开阔了。",
		SLURPERPELT = "呃...它还活着！",

		SLURPER = "不，不，别碰头！",
		SLURPER_PELT = "它还活着！",
		ARMORSLURPER = "哦，哎呀！哎呀！哎呀！(⊙o⊙)…！",
		ORANGEAMULET = "它会收集附近的物品！",
		YELLOWSTAFF = "这很神奇。",
		YELLOWGEM = "它闪闪发光。",
		ORANGEGEM = "它会让你的手指刺痛。",
        OPALSTAFF = "我得用袖子把它拿着，这样我的手就不会冷了。",
        OPALPRECIOUSGEM = "它闪闪发光，令人着迷。",
        TELEBASE =
		{
			VALID = "我能感觉到魔法！",
			GEMS = "它需要更多的东西。",
		},
		GEMSOCKET =
		{
			VALID = "我想知道它们是怎么盘旋的？",
			GEMS = "太空了！",
		},
		STAFFLIGHT = "太美了！",
        STAFFCOLDLIGHT = "嘘！嘶嘶！",

        ANCIENT_ALTAR = "噢！来世的对讲机",

        ANCIENT_ALTAR_BROKEN = "死者无法通过这里。",

        ANCIENT_STATUE = "德拉特，不会燃烧",

        LICHEN = "一种粗糙的、有硬壳的植物",
		CUTLICHEN = "诸如此类，尝起来像锯末",

		CAVE_BANANA = "香蕉！",
		CAVE_BANANA_COOKED = "好吃！",
		CAVE_BANANA_TREE = "看起来容易燃烧！",
		ROCKY = "我们没有太多共同点",

		COMPASS =
		{
			GENERIC="找不到方向。",
			N = "北方",
			S = "南方",
			E = "东方",
			W = "西方",
			NE = "东北",
			SE = "东南",
			NW = "西北",
			SW = "西南",
		},

        HOUNDSTOOTH = "它很锋利。我喜欢它！",
        ARMORSNURTLESHELL = "少防守！多进攻！",
        BAT = "可爱的小家伙！",
        BATBAT = "那东西打击敌人很好。",
        BATWING = "恶心",
        BATWING_COOKED = "仍然恶心！",
        BATCAVE = "如果我在里面丢了一根火柴会怎么样？",
        BEDROLL_FURRY = "太褶边了。",
        BUNNYMAN = "呃，他们看起来太蠢了。",
        FLOWER_CAVE = "里面在燃烧。",
        GUANO = "恶心，但很有用。",
        LANTERN = "更环保的光。",
        LIGHTBULB = "他叫 \"灯泡\" 但有点重。",
        MANRABBIT_TAIL = "兔子们输掉了那场争论。",
        MUSHROOMHAT = "我不喜欢让人把我的头弄乱。",
        MUSHROOM_LIGHT2 =
        {
            ON = "这是个好主意。",
            OFF = "我对如何点燃它有一些想法。嘿嘿。",
            BURNT = "现在怎么办？",
        },
        MUSHROOM_LIGHT =
        {
            ON = "没有温暖的火那么好。",
            OFF = "这个愚蠢的蘑菇没有亮起来。",
            BURNT = "拜托，你看到了。",
        },
        SLEEPBOMB = "谁准备好小睡了！",
        MUSHROOMBOMB = "她要爆炸了！",
        SHROOM_SKIN = "呃！",
        TOADSTOOL_CAP =
        {
            EMPTY = "这是个洞，你想从我这里得到什么？",
            INGROUND = "那是什么？很臭",
            GENERIC = "变异蘑菇！我想要！",
        },
        TOADSTOOL =
        {
            GENERIC = "上面长满了难看的疣和真菌！！",
            RAGE = "哇！它现在正在打一拳！",
        },
        MUSHROOMSPROUT =
        {
            GENERIC = "大蘑菇！",
            BURNT = "这怎么可能不起作用？",
        },
        MUSHTREE_TALL =
        {
            GENERIC = "恶心。这棵树到处都病了。",
            BLOOM = "啊！臭死了！",
        },
        MUSHTREE_MEDIUM =
        {
            GENERIC = "恶心，闻起来像小妖精屁股",
            BLOOM = "到处都是垃圾。",
        },
        MUSHTREE_SMALL =
        {
            GENERIC = "恶心，都是蘑菇状的。",
            BLOOM = "呃，我不想靠得太近。",
        },
        MUSHTREE_TALL_WEBBED = "那一个得到了它应得的。",
        SPORE_TALL =
        {
            GENERIC = "就像五颜六色的火花！",
            HELD = "如果我吃了它，我会变成水！",
        },
        SPORE_MEDIUM =
        {
            GENERIC = "就像漂浮的火焰",
            HELD = "如果我盯着它看，我会变成石头",
        },
        SPORE_SMALL =
        {
            GENERIC = "它不知道它要去哪里。",
           HELD = "如果我舔它，我会变成木头！",
        },
        RABBITHOUSE =
        {
            GENERIC = "啊，愚蠢的兔子",
            BURNT = "哈！好结果。",
        },
        SLURTLE = "我想把它炸了！",
        SLURTLE_SHELLPIECES = "嘿，它坏了。",
        SLURTLEHAT = "它的头部形状非常完美。",
        SLURTLEHOLE = "里面有恶心的东西。",
        SLURTLESLIME = "呃唔！",
        SNURTLE = "咔嘣！",
        SPIDER_HIDER = "多么令人沮丧的混蛋",
        SPIDER_SPITTER = "过来！",
        SPIDERHOLE = "里面满是蜘蛛。",
        SPIDERHOLE_ROCK = "里面满是蜘蛛。",
        STALAGMITE = "岩石很无聊",
        STALAGMITE_TALL = "更多无聊的岩石",

        TURF_CARPETFLOOR = "地面很无聊",
        TURF_CHECKERFLOOR = "地面很无聊",
        TURF_DIRT = "地面很无聊",
        TURF_FOREST = "地面很无聊",
        TURF_GRASS = "地面很无聊",
        TURF_MARSH = "地面很无聊",
        TURF_METEOR = "地面很无聊",
        TURF_PEBBLEBEACH = "地面很无聊",
        TURF_ROAD = "地面很无聊",
        TURF_ROCKY = "地面很无聊",
        TURF_SAVANNA = "地面很无聊",
        TURF_WOODFLOOR = "地面很无聊",

		TURF_CAVE="地面很无聊",
		TURF_FUNGUS="地面很无聊",
		TURF_FUNGUS_MOON = "地面很无聊",
		TURF_ARCHIVE = "地面很无聊",
		TURF_SINKHOLE="地面很无聊",
		TURF_UNDERROCK="地面很无聊",
		TURF_MUD="地面很无聊",

		TURF_DECIDUOUS = "地面很无聊",
		TURF_SANDY = "地面很无聊",
		TURF_BADLANDS = "地面很无聊",
		TURF_DESERTDIRT = "地面很无聊",
		TURF_FUNGUS_GREEN = "地面很无聊",
		TURF_FUNGUS_RED = "地面很无聊",
		TURF_DRAGONFLY = "地面很无聊",

        TURF_SHELLBEACH = "地面很无聊",

		POWCAKE = "这永远不会有好结果。",
        CAVE_ENTRANCE = "谁堵住了那个洞？",
        CAVE_ENTRANCE_RUINS = "谁堵住了那个洞？",

       	CAVE_ENTRANCE_OPEN =
        {
            GENERIC = "我不想进那个恶心的洞！",
            OPEN = "我希望下面某处有熔岩。",
            FULL = "下面人太多了。",
        },
        CAVE_EXIT =
        {
            GENERIC = "不管怎样，这里比较凉快。",
            OPEN = "这里太暗太闷了。",
            FULL = "上面的人太多了。",
        },

		MAXWELLPHONOGRAPH = "我喜欢更刺激的音乐。",--single player
		BOOMERANG = "这不是最令人兴奋的武器。",
		PIGGUARD = "我喜欢他的态度！",
		ABIGAIL =
		{
            LEVEL1 =
            {
                "那么，你怎么了？",
                "那么，你怎么了？",
            },
            LEVEL2 =
            {
                "那么，你怎么了？",
                "那么，你怎么了？",
            },
            LEVEL3 =
            {
                "那么，你怎么了？",
                "那么，你怎么了？",
            },
		},
		ADVENTURE_PORTAL = "也许这会带你回家。",
		AMULET = "我不知道它是干什么的，但戴着它感觉很好！",
		ANIMAL_TRACK = "它会指引我的新朋友。",
		ARMORGRASS = "感觉就像是更多的头发。",
		ARMORMARBLE = "如果你要战斗，你最好受到保护。",
		ARMORWOOD = "现在我可以挑战世界了！",
		ARMOR_SANITY = "就像被烟雾笼罩一样。",
		ASH =
		{
			GENERIC = "造成火灾的东西，我希望它还在这里。",
			REMAINS_GLOMMERFLOWER = "我希望看到那朵奇怪的花燃烧的样子。",
			REMAINS_EYE_BONE = "我敢打赌，那只眼睛一定是一片火海！",
			REMAINS_THINGIE = "我希望这东西还在燃烧，不管它是什么。",
		},
		AXE = "非常锋利。",
		BABYBEEFALO =
		{
			GENERIC = "连婴儿都很丑。",
		    SLEEPING = "醒来！",
        },
        BUNDLE = "这应该让一切都保持新鲜。",
        BUNDLEWRAP = "我想我们可以隐藏一些恶心的东西。",
		BACKPACK = "你可以在这里放上一百万个打火机。",
		BACONEGGS = "黄色粘液部分很恶心，但培根很棒！",
		BANDAGE = "哦，不！",
		BASALT = "太难打破了！", --removed
		BEARDHAIR = "清理你的头发，伙计们！啊！",
		BEARGER = "哇！妮莉丝熊……",
		BEARGERVEST = "就像在毛皮中游泳一样。",
		ICEPACK = "模糊背包！",
		BEARGER_FUR = "一路下来都是毛皮。",
		BEDROLL_STRAW = "发霉。",
		BEEQUEEN = "再多的蜂蜜都不值得！",
		BEEQUEENHIVE =
		{
			GENERIC = "这一切都来自蜜蜂的屁股",
			GROWING = "呃，在它变大之前把它烧了！",
		},
        BEEQUEENHIVEGROWN = "你们敢用锤子砸它。",
        BEEGUARD = "蓬松的飞行混蛋！",
        HIVEHAT = "那只蜜蜂的头看起来很好吃，不是吗？",
        MINISIGN =
        {
            GENERIC = "哈哈哦，老兄，谁画的",
            UNDRAWN = "看起来有点裸露。",
        },
        MINISIGN_ITEM = "它就像一个标志，但更小。",
		BEE =
		{
			GENERIC = "它很胖，但那根毒刺看起来很危险。",
			HELD = "口袋里装满了蜜蜂！",
		},
		BEEBOX =
		{
			READY = "耶！我们去偷蜂蜜吧！",
			FULLHONEY = "耶！我们去偷蜂蜜吧！",
			GENERIC = "来吧，胖蜜蜂，做蜂蜜！",
			NOHONEY = "这里没什么可看的。",
			SOMEHONEY = "耐心。",
			BURNT = "把你熏了！",
		},
		MUSHROOM_FARM =
		{
			STUFFED = "天哪，谁还需要那么多蘑菇？",
			LOTS = "恶心，他们控制了！",
			SOME = "现在里面长着蘑菇。",
			EMPTY = "这只是一个愚蠢的原木。",
			ROTTEN = "讨厌。让我们把腐烂的东西烧掉。",
			BURNT = "霉菌问题已经解决了。.",
			SNOWCOVERED = "它能在这么冷的天气里生长。",
		},
		BEEFALO =
		{
			FOLLOWER = "呃，你在跟踪我吗？",
			GENERIC = "这是一只皮弗娄牛！",
			NAKED = "啊，他太伤心了。",
			SLEEPING = "他们睡觉的时候看起来更傻。",
            --Domesticated states:
            DOMESTICATED = "这一个比其他的气味稍微少一点。",
            ORNERY = "看起来非常生气。",
            RIDER = "我们走！",
            PUDGY = "你需要燃烧一些卡路里。",
            MYPARTNER = "我们永远是朋友皮弗娄牛。",
		},

		BEEFALOHAT = "野兽的头发要盖过人们的头发！",
		BEEFALOWOOL = "厚毛。",
		BEEHAT = "这会让我的口袋远离我。",
        BEESWAX = "那不是我的蜂蜡。",
		BEEHIVE = "里面全是蜜蜂！",
		BEEMINE = "摇动时会嗡嗡响。",
		BEEMINE_MAXWELL = "蚊子在里面。它们听起来不高兴。",--removed
		BERRIES = "红色浆果味道最好。",
		BERRIES_COOKED = "我不认为高温改善了它们。",
        BERRIES_JUICY = "特别美味，但不会持续很久。",
        BERRIES_JUICY_COOKED = "最好在它们变质之前吃掉它们！",
		BERRYBUSH =
		{
			BARREN = "吃屎，愚蠢的植物！",
			WITHERED = "在这种高温下什么也长不出来。",
			GENERIC = "嗯。浆果！",
			PICKED = "但我想要更多浆果！",
			DISEASED = "烧死病菌",--removed
			DISEASING = "你闻到了。",--removed
			BURNING = "我现在无能为力。",
		},
		BERRYBUSH_JUICY =
		{
			BARREN = "我说过你可以停止生长吗？！",
			WITHERED = "它正在燃烧。",
			GENERIC = "准备好采摘！",
			PICKED = "但我想要更多浆果！",
			DISEASED = "烧死病菌！",--removed
			DISEASING = "你闻到了。",--removed
			BURNING = "我现在无能为力",
		},
		BIGFOOT = "这到底是什么",--removed
		BIRDCAGE =
		{
			GENERIC = "鸟笼子！",
			OCCUPIED = "哈！抓住你了！",
			SLEEPING = "愚蠢的小鸟，醒醒！",
			HUNGRY = "怎么这么大惊小怪？",
			STARVING = "他不会安静的",
			DEAD = "至少他现在安静了。",
			SKELETON = "那可能应该清理一下。",
		},
		BIRDTRAP = "要抓住那些可怕的鸟。.",
		CAVE_BANANA_BURNT = "这就是我想要的！",
		BIRD_EGG = "闻起来像鸟屁股。.",
		BIRD_EGG_COOKED = "恶心，黄色的部分都是流淌的。",
		BISHOP = "像一个教主！",
		BLOWDART_FIRE = "这是我在全世界最喜欢的东西。",
		BLOWDART_SLEEP = "不要吸气。",
		BLOWDART_PIPE = "我喜欢一种可以从远处射击的武器。最好是在跑步时。",
		BLOWDART_YELLOW = "这对系统来说是一个冲击。",
		BLUEAMULET = "嘘！",
		BLUEGEM = "呃，这件很难看。",
		BLUEPRINT =
		{
            COMMON = "这将节省一些实验。",
            RARE = "哇，它不会燃烧！！",
        },
        SKETCH = "设计图是为傻瓜准备的。",
		BLUE_CAP = "闻起来像运动袜！",
		BLUE_CAP_COOKED = "被火转化！",
		BLUE_MUSHROOM =
		{
			GENERIC = "哑巴蘑菇。",
			INGROUND = "嘿！你！上来！",
			PICKED = "也许有一天它会回来。",
		},
		BOARDS = "木板。它们会燃烧，和其他木材一样。",
		BONESHARD = "我认为它们不适合打火。",
		BONESTEW = "闻起来像是周日晚餐。",
		BUGNET = "不适合韦伯的大头。",
		BUSHHAT = "太被动了！",
		BUTTER = "好吃，只是有点不安全。",
		BUTTERFLY =
		{
			GENERIC = "飞走吧，蝴蝶！",
			HELD = "我想把它压扁。",
		},
		BUTTERFLYMUFFIN = "嘻嘻，看那只卡在松饼里的蝴蝶。",
		BUTTERFLYWINGS = "不要再为那只蝴蝶飞了！",
		BUZZARD = "你的脖子真恶心。",

		SHADOWDIGGER = "哦，这比真的还要可怕。",

		CACTUS =
		{
			GENERIC = "脊椎！我的弱点！你怎么知道的？",
			PICKED = "我们称之为平局。",
		},
		CACTUS_MEAT_COOKED = "现在看起来不错。",
		CACTUS_MEAT = "看起来仍然很危险。",
		CACTUS_FLOWER = "又是一朵花。",

		COLDFIRE =
		{
			EMBERS = "火需要更多燃料，否则就要熄灭了。",
			GENERIC = "肯定能打败黑暗。",
			HIGH = "火快失控了！",
			LOW = "火势有点小了。",
			NORMAL = "又好又舒服。",
			OUT = "好了，结束了。",
		},
		CAMPFIRE =
		{
			EMBERS = "火需要更多燃料，否则就要熄灭了。",
			GENERIC = "肯定能打败黑暗。",
			HIGH = "火快失控了！",
			LOW = "火势有点小了。",
			NORMAL = "又好又舒服。",
			OUT = "好了，结束了。",
		},
		CANE = "用这个走路更容易！",
		CATCOON = "给你，浣熊！",
		CATCOONDEN =
		{
			GENERIC = "浣熊窝。",
			EMPTY = "九条命是真的！",
		},
		CATCOONHAT = "可爱的帽子。",
		COONTAIL = "我一直保存着比这更奇怪的东西。",
		CARROT = "恶心，全是蔬菜。",
		CARROT_COOKED = "仍然是蔬菜，但最好是在火灾中。",
		CARROT_PLANTED = "也许它特别的胡萝卜朋友在地里。",
		CARROT_SEEDS = "一些种子。",
		CARTOGRAPHYDESK =
		{
			GENERIC = "我想我可以告诉大家我去过哪里。",
			BURNING = "是的！",
			BURNT = "无论如何，侦察兵不需要地图。",
		},
		WATERMELON_SEEDS = "我可以种，但听起来很无聊。",
		CAVE_FERN = "漩涡状植物。",
		CHARCOAL = "嗯，闻起来像火。",
        CHESSPIECE_PAWN = "什么样的农民没有手电筒？！",
        CHESSPIECE_ROOK =
        {
            GENERIC = "那一个看起来可能会造成一些损害。",
            STRUGGLE = "我不想看到结果是什么！",
        },
        CHESSPIECE_KNIGHT =
        {
            GENERIC = "没有屁股的马。",
            STRUGGLE = "我不想看到结果是什么！",
        },
        CHESSPIECE_BISHOP =
        {
            GENERIC = "只是一些愚蠢的主教作品。",
            STRUGGLE = "我不想看到结果是什么！",
        },
        CHESSPIECE_MUSE = "哇，她没有头！",
        CHESSPIECE_FORMAL = "我不怕那家伙。他连胳膊都没有！",
        CHESSPIECE_HORNUCOPIA = "哎哟！我想我把一颗牙齿弄坏了。",
        CHESSPIECE_PIPE = "那从来都不是我喜欢的东西。",
        CHESSPIECE_DEERCLOPS = "我们踢了它的屁股。",
        CHESSPIECE_BEARGER = "那些是尖牙。",
        CHESSPIECE_MOOSEGOOSE =
        {
            "看起来像真的一样傻。",
        },
        CHESSPIECE_DRAGONFLY = "我想……我想我懂艺术。",
		CHESSPIECE_MINOTAUR = "噗，我从来都不需要监护人。结果我很好。",
        CHESSPIECE_BUTTERFLY = "看起来不错，不是吗？",
        CHESSPIECE_ANCHOR = "它看起来很重。",
        CHESSPIECE_MOON = "我想这很好。",
        CHESSPIECE_CARRAT = "现在我能想到的就是烤胡萝卜。",
        CHESSPIECE_MALBATROSS = "她是一只非常强壮的老鸟。",
        CHESSPIECE_CRABKING = "这些宝藏值得吗？",
        CHESSPIECE_TOADSTOOL = "你在看什么？",
        CHESSPIECE_STALKER = "你现在不那么强硬了，是吗？",
        CHESSPIECE_KLAUS = "哈哈，你现在抓不到我。",
        CHESSPIECE_BEEQUEEN = "从她的毒刺中取出了毒刺。",
        CHESSPIECE_ANTLION = "不能像那样摇晃任何东西。",
        CHESSPIECE_BEEFALO = "嘿，他们得到了他好的一面！",
		CHESSPIECE_KITCOON = "这些更容易找到。",
		CHESSPIECE_CATCOON = "呐呐呐。",
        CHESSPIECE_GUARDIANPHASE3 = "呃，我很高兴再也看不到那东西了。",
		CHESSPIECE_EYEOFTERROR = "哈哈，你的灵魂是我的！",
        CHESSPIECE_TWINSOFTERROR = "现在他们将永远在一起",

        CHESSJUNK1 = "死马匹。",
        CHESSJUNK2 = "死去的牧师。",
        CHESSJUNK3 = "死气沉沉的城堡。",
		CHESTER = "他太模糊了！",
		CHESTER_EYEBONE =
		{
			GENERIC = "盯着看是不礼貌的。",
			WAITING = "至少它不再看着我了。",
		},
		COOKEDMANDRAKE = "可怜的小家伙。",
		COOKEDMEAT = "未腌制的肉……太好了",
		COOKEDMONSTERMEAT = "还是很恶心。",
		COOKEDSMALLMEAT = "需要很多开胃菜才能在这里生存！",
		COOKPOT =
		{
			COOKING_LONG = "这需要一段时间。",
			COOKING_SHORT = "快做好了！",
			DONE = "嗯！可以吃了！",
			EMPTY = "一看就觉得饿。",
			BURNT = "锅烧糊了。",
		},
		CORN = "一种甜蔬菜，好吃！",
		CORN_COOKED = "哦，这只在着火时会爆炸！",
		CORN_SEEDS = "一些种子。",
        CANARY =
		{
			GENERIC = "如果它成功了，我就离开这里。",
			HELD = "你还在呼吸吗？只是检查一下。",
		},
        CANARY_POISONED = "嗯，你感觉还好吗？",

		CRITTERLAB = "里面有可爱的东西吗？？",
        CRITTER_GLOMLING = "哦，我可以把你那张恶心的小脸挤扁！",
        CRITTER_DRAGONLING = "我们是为彼此而生的。",
		CRITTER_LAMB = "看看那些令人毛骨悚然的小眼睛。啊。",
        CRITTER_PUPPY = "哈，你甚至不知道自己很臭。",
        CRITTER_KITTEN = "你是完美的暖腿猫。",
        CRITTER_PERDLING = "我可以把你吃掉。",
		CRITTER_LUNARMOTHLING = "她喜欢火焰！",

		CROW =
		{
			GENERIC = "我想它在等我死。",
			HELD = "你现在不太聪明，是吗？",
		},
		CUTGRASS = "割草，准备燃烧。或者制作。",
		CUTREEDS = "割芦苇，准备燃烧。或者制作。",
		CUTSTONE = "完美的方形，最大限度的享受。",
		DEADLYFEAST = "火没能治愈这道菜的恶心。", --unimplemented
		DEER =
		{
			GENERIC = "我希望大家不要再为那件臭东西讨好了！",
			ANTLER = "别以为这角让你特别，鹿。",
		},
        DEER_ANTLER = "这是一只又大又奇怪的鹿角。",
        DEER_GEMMED = "比这里的大多数动物闻起来稍微好一点。",
		DEERCLOPS = "天哪！",
		DEERCLOPS_EYEBALL = "别盯着我看！",
		EYEBRELLAHAT =	"防止雨水进入你的眼睛和其他人的眼睛。",
		DEPLETED_GRASS =
		{
			GENERIC = "多可怜的一块……草啊？",
		},
        GOGGLESHAT = "多好看啊！",
        DESERTHAT = "不是很时髦。",
--fallback to speech_wilson.lua 		DEVTOOL = "It smells of bacon!",
--fallback to speech_wilson.lua 		DEVTOOL_NODEV = "I'm not strong enough to wield it.",
		DIRTPILE = "谁会在森林里留下泥土？",
		DIVININGROD =
		{
			COLD = "它发出了一些声音。", --singleplayer
			GENERIC = "里面全是电子垃圾。", --singleplayer
			HOT = "嘎！别再嘟嘟了！", --singleplayer
			WARM = "这东西越来越吵了。", --singleplayer
			WARMER = "必须靠近！", --singleplayer
		},
		DIVININGRODBASE =
		{
			GENERIC = "我不知道这是怎么回事。看起来不像是火热的东西。", --singleplayer
			READY = "只需要用钥匙解锁。不幸的是，不能开火。", --singleplayer
			UNLOCKED = "它现在在呼啸！", --singleplayer
		},
		DIVININGRODSTART = "我会从中有所收获。", --singleplayer
		DRAGONFLY = "哦，别再拖了。",
		ARMORDRAGONFLY = "另一种生物。",
		DRAGON_SCALES = "对于天平来说，它们的重量不多。",
		DRAGONFLYCHEST = "胸膛不怕火。",
		DRAGONFLYFURNACE =
		{
			HAMMERED = "这的确是一个外观。",
			GENERIC = "让我们重新打开它！", --no gems
			NORMAL = "在那里再放一颗宝石！", --one gem
			HIGH = "我想我爱它。.", --two gems
		},

        HUTCH = "你的角度是什么？",
        HUTCH_FISHBOWL =
        {
            GENERIC = "太湿了，烧不着。",
            WAITING = "还是太湿了，烧不着。",
        },
		LAVASPIT =
		{
			HOT = "最酷的口水！",
			COOL = "真的很酷，流口水。",
		},
		LAVA_POND = "对！是的！",
		LAVAE = "为什么我们不能成为朋友？",
		LAVAE_COCOON = "哦，它失去了火热的个性。",
		LAVAE_PET =
		{
			STARVING = "我能看到她的肋骨！",
			HUNGRY = "我想她想要一些灼伤。",
			CONTENT = "我自己的小燃烧器。",
			GENERIC = "她……完美。",
		},
		LAVAE_EGG =
		{
			GENERIC = "从里面传来一阵微弱的暖意。",
		},
		LAVAE_EGG_CRACKED =
		{
			COLD = "有点冷。",
			COMFY = "那个蛋看起来很高兴。",
		},
		LAVAE_TOOTH = "我希望她不会咬人。",

		DRAGONFRUIT = "多奇怪的水果啊。",
		DRAGONFRUIT_COOKED = "水果还是很奇怪。",
		DRAGONFRUIT_SEEDS = "这是一粒种子。",
		DRAGONPIE = "龙果很饱。",
		DRUMSTICK = "整天敲鼓！",
		DRUMSTICK_COOKED = "Emmm..满足饥饿，还是击鼓？",
		DUG_BERRYBUSH = "怎么了，没有泥土吗？",
		DUG_BERRYBUSH_JUICY = "怎么了，没有泥土吗？",
		DUG_GRASS = "怎么了，没有泥土吗？",
		DUG_MARSH_BUSH = "怎么了，没有泥土吗？",
		DUG_SAPLING = "怎么了，没有泥土吗？",
		DURIAN = "多奇怪的水果啊。",
		DURIAN_COOKED = "水果还是很奇怪。",
		DURIAN_SEEDS = "一些种子。",
		EARMUFFSHAT = "闻起来像兔子屁股。",
		EGGPLANT = "绝对不是鸟。",
		EGGPLANT_COOKED = "用火烤的茄子味道更好。",
		EGGPLANT_SEEDS = "一些种子。",

		ENDTABLE =
		{
			BURNT = "好吧，好吧，我的手错了！",
			GENERIC = "只是一束哑花。",
			EMPTY = "我告诉你，那东西下面有只怪兽手！",
			WILTED = "这些需要更换。",
			FRESHLIGHT = "有点光真好。",
			OLDLIGHT = "我们很快就要被蒙在鼓里了。", -- will be wilted soon, light radius will be very small at this point
		},
		DECIDUOUSTREE =
		{
			BURNING = "多浪费木头啊。",
			BURNT = "我觉得我本可以阻止这一切。",
			CHOPPED = "拿着，自然！",
			POISON = "我偷了那些白桦看起来很不高兴！",
			GENERIC = "都是树叶。大多数时候。",
		},
		ACORN = "嘿，树籽。",
        ACORN_SAPLING = "你很快就会变成一棵真正的树。",
		ACORN_COOKED = "看来你终究不会变成一棵树。",
		BIRCHNUTDRAKE = "一个疯子。",
		EVERGREEN =
		{
			BURNING = "真是浪费木头。",
			BURNT = "我觉得我本可以阻止这种情况。",
			CHOPPED = "拿着，大自然！",
			GENERIC = "都是松树。",
		},
		EVERGREEN_SPARSE =
		{
			BURNING = "真是浪费木头。",
			BURNT = "我觉得我本可以阻止这种情况。",
			CHOPPED = "拿着，大自然！",
			GENERIC = "这棵悲伤的树没有球果。",
		},
		TWIGGYTREE =
		{
			BURNING = "真是浪费木头。",
			BURNT = "我觉得我本可以阻止这种情况。",
			CHOPPED = "拿着，大自然！",
			GENERIC = "树枝太多了。",
			DISEASED = "看起来很恶心。比平常更恶心。", --unimplemented
		},
		TWIGGY_NUT_SAPLING = "它不需要任何帮助就可以成长。",
        TWIGGY_OLD = "那棵树看起来很弱。",
		TWIGGY_NUT = "里面有一棵木棍状的树想要出去。",
		EYEPLANT = "我想我被监视了。",
		INSPECTSELF = "我还完好无损吗？",
		FARMPLOT =
		{
			GENERIC = "哎，这是一堆土。",
			GROWING = "快点，脏兮兮的。喂我！",
			NEEDSFERTILIZER = "这东西需要肥料。",
			BURNT = "这是一个很好的结局。",
		},
		FEATHERHAT = "凤凰重生！",
		FEATHER_CROW = "黑羽毛.",
		FEATHER_ROBIN = "红色的羽毛。",
		FEATHER_ROBIN_WINTER = "白色的羽毛。",
		FEATHER_CANARY = "黄色的羽毛。",
		FEATHERPENCIL = "哈哈！好痒！",
        COOKBOOK = "现在我永远不会忘记一个食谱！",
		FEM_PUPPET = "她看起来吓得半死。", --single player
		FIREFLIES =
		{
			GENERIC = "我希望他们没有逃跑！",
			HELD = "它们让我的口袋闪闪发光！",
		},
		FIREHOUND = "我其实有点喜欢那个。",
		FIREPIT =
		{
			EMBERS = "我应该在火熄灭之前把东西放在火上。",
			GENERIC = "当然可以打败黑暗。",
			HIGH = "幸好它被控制住了！",
			LOW = "火势有点小了",
			NORMAL = "又好又舒服。",
			OUT = "至少我可以重新点燃。",
		},
		COLDFIREPIT =
		{
			EMBERS = "我应该在火熄灭之前把东西放在火上。",
			GENERIC = "当然可以打败黑暗。",
			HIGH = "幸好它被控制住了！",
			LOW = "火势有点小了。",
			NORMAL = "又好又舒服。",
			OUT = "至少我可以重新点燃。",
		},
		FIRESTAFF = "那是我最喜欢的玩具。",
		FIRESUPPRESSOR =
		{
			ON = "这在打雪仗时会派上用场。",
			OFF = "没在工作。",
			LOWFUEL = "燃料不足。",
		},

		FISH = "滑滑的鱼！",
		FISHINGROD = "用鱼钩、鱼线和伸卡球寻找答案。",
		FISHSTICKS = "你看到的就是你得到的。鱼条。",
		FISHTACOS = "方便的玉米卷夹。",
		FISH_COOKED = "薄而潮湿。美味的",
		FLINT = "啊哈，我找到了一些燧石！",
		FLOWER =
		{
            GENERIC = "我没有时间浪费在花上。",
            ROSE = "鲜红的花瓣！",
        },
        FLOWER_WITHERED = "看起来是很好的引燃物。",
		FLOWERHAT = "花环。可惜这不是一个燃烧的光环。",
		FLOWER_EVIL = "闻起来很难闻。",
		FOLIAGE = "柔软且多叶。",
		FOOTBALLHAT = "运动很难。",
        FOSSIL_PIECE = "只不过是些肮脏的旧骨头！",
        FOSSIL_STALKER =
        {
			GENERIC = "需要更大的旧位。",
			FUNNY = "这看起来太荒谬了。",
			COMPLETE = "看起来还可以。",
        },
        STALKER = "我带你回来是为了揍你！",
        STALKER_ATRIUM = "只是骨头和影子。",
        STALKER_MINION = "哎呀，它都快死了。",
        THURIBLE = "闻起来像烧焦的头发！",
        ATRIUM_OVERGROWTH = "它是用另一种语言写的。",
		FROG =
		{
			DEAD = "跳得太远了。",
			GENERIC = "攻击！粘舌头！",
			SLEEPING = "健忘的两栖动物。",
		},
		FROGGLEBUNWICH = "如果你闭上眼睛，就更容易把它拿下来。",
		FROGLEGS = "它仍然时不时地抽搐。奇怪。",
		FROGLEGS_COOKED = "尝起来像鸡肉。",
		FRUITMEDLEY = "好吃，水果！",
		FURTUFT = "黑、白、毛茸茸的到处都是！",
		GEARS = "这些必须让他们运转起来。",
		GHOST = "你不能杀死已经死了的东西。",
		GOLDENAXE = "当你有一把金斧的时候，生活是好的.",
		GOLDENPICKAXE = "最好的鹤嘴锄。",
		GOLDENPITCHFORK = "我们可以用这个做些花哨的叉子。",
		GOLDENSHOVEL = "我们要挖很多洞。",
		GOLDNUGGET = "我们应该把钱花在什么上？？",
		GRASS =
		{
			BARREN = "它需要施肥。",
			WITHERED = "干得好。",
			BURNING = "火哇！",
			GENERIC = "是草。",
			PICKED = "草茬有点没用。",
			DISEASED = "烧死疾病！", --unimplemented
			DISEASING = "你闻到了。", --unimplemented
		},
		GRASSGEKKO =
		{
			GENERIC = "呃.",
			DISEASED = "呃呃！", --unimplemented
		},
		GREEN_CAP = "没趣",
		GREEN_CAP_COOKED = "它被火改变了！",
		GREEN_MUSHROOM =
		{
			GENERIC = "愚蠢的蘑菇。",
			INGROUND = "嘿！你！上来！",
			PICKED = "也许有一天它会回来。",
		},
		GUNPOWDER = "看起来像胡椒。",
		HAMBAT = "这似乎不卫生。",
		HAMMER = "停止！是时候去砸东西！",
		HEALINGSALVE = "刺痛意味着它起作用了。",
		HEATROCK =
		{
			FROZEN = "比冰还冷。",
			COLD = "那是一块冰冷的石头。",
			GENERIC = "我可以控制它的温度。",
			WARM = "对一块石头来说，它非常温暖和可爱！",
			HOT = "又好又热！",
		},
		HOME = "一定有人住在这里.",
		HOMESIGN =
		{
			GENERIC = "上面写着 \"You are here\".",
            UNWRITTEN = "该符号当前为空。",
			BURNT = "\"不要玩火柴\"",
		},
		ARROWSIGN_POST =
		{
			GENERIC = "上面写着 \"Thataway\".",
            UNWRITTEN = "该符号当前为空。",
			BURNT = "\"不要玩火柴\"",
		},
		ARROWSIGN_PANEL =
		{
			GENERIC = "上面写着 \"Thataway\".",
            UNWRITTEN = "该符号当前为空。",
			BURNT = "\"不要玩火柴\"",
		},
		HONEY = "又甜又好吃！",
		HONEYCOMB = "它是蜡质的。",
		HONEYHAM = "火腿和蜂蜜很相配。",
		HONEYNUGGETS = "蜂蜜包裹的小吃。",
		HORN = "我能听到里面那些毛茸茸的野兽的声音。",
		HOUND = "真是个混蛋！",
		HOUNDCORPSE =
		{
			GENERIC = "那么……现在我们该怎么处理它？",
			BURNING = "解决任何问题的最佳方法。",
			REVIVING = "烧掉它！",
		},
		HOUNDBONE = "令人恶心",
		HOUNDMOUND = "哦，我不喜欢这个样子。",
		ICEBOX = "我完全支持让制作的食物保鲜更长时间。",
		ICEHAT = "这真是一种情绪抑制剂。",
		ICEHOUND = "令人不快的寒冷的",
		INSANITYROCK =
		{
			ACTIVE = "我看到什么了吗？",
			INACTIVE = "我想知道这是怎么回事。",
		},
		JAMMYPRESERVES = "砰，砰，砰！谢谢你，女士。",

		KABOBS = "棒上的食物！",
		KILLERBEE =
		{
			GENERIC = "我喜欢那只蜜蜂的翅膀。",
			HELD = "噗！",
		},
		KNIGHT = "像一匹小马！",
		KOALEFANT_SUMMER = "我们会成为好朋友！",
		KOALEFANT_WINTER = "他看起来很温暖。。。",
		KRAMPUS = "退后，你这个大混蛋！",
		KRAMPUS_SACK = "今年假期来得早！",
		LEIF = "那是从哪里来的？！",
		LEIF_SPARSE = "那是从哪里来的？！",
		LIGHTFLIER = "真奇怪，拿着一个让我的口袋更轻了！",
		LIGHTNING_ROD =
		{
			CHARGED = "它看起来非常耀眼！",
			GENERIC = "所有闪电都在这里！",
		},
		LIGHTNINGGOAT =
		{
			GENERIC = "蹦蹦跳跳的山羊。",
			CHARGED = "你疯了！",
		},
		LIGHTNINGGOATHORN = "当我把闪电放在耳边时，我听到了闪电的声音。",
		GOATMILK = "电模糊了。讨厌.",
		LITTLE_WALRUS = "他看起来很好吃。",
		LIVINGLOG = "看起来很沮丧。",
		LOG =
		{
			BURNING = "燃烧，木头，燃烧！",
			GENERIC = "那是一块木头。",
		},
		LUCY = "我们可以成为好朋友，你和我。",
		LUREPLANT = "多么鲜艳的植物啊。",
		LUREPLANTBULB = "恶心，肉太多了！",
		MALE_PUPPET = "他看起来吓得半死。", --single player

		MANDRAKE_ACTIVE = "这太可怕了！",
		MANDRAKE_PLANTED = "那不是正常的植物。",
		MANDRAKE = "为什么这种植物有脸？",

        MANDRAKESOUP = "脸洗不掉！！",
        MANDRAKE_COOKED = "会面不得不停止。",
        MAPSCROLL = "上面什么都没有？",
        MARBLE = "太重了！",
        MARBLEBEAN = "我想我们只是。。。种植它？在泥土里？",
        MARBLEBEAN_SAPLING = "这毫无意义！",
        MARBLESHRUB = "什么样的灌木丛不会燃烧？！",
        MARBLEPILLAR = "我不知道其他的是否都烧掉了。",
        MARBLETREE = "我希望它不会落在我身上。",
        MARSH_BUSH =
        {
			BURNT = "烧得太快了。",
            BURNING = "它很快就会消失！",
            GENERIC = "看起来很锋利。",
            PICKED = "那些刺很疼！",
        },
        BURNT_MARSH_BUSH = "全都烧掉了。",
        MARSH_PLANT = "都是植物性的。",
        MARSH_TREE =
        {
             BURNING = "现在特别危险！",
            BURNT = "我希望它还在燃烧。",
            CHOPPED = "你现在没那么尖了吧？",
            GENERIC = "看起来很危险！",
        },
        MAXWELL = "他太傲慢了。",--single player
        MAXWELLHEAD = "他当然喜欢说话。",--removed
        MAXWELLLIGHT = "这些都不好玩。他们点燃自己。",--single player
        MAXWELLLOCK = "只需要一把钥匙。",--single player
        MAXWELLTHRONE = "看起来很粘.",--single player
        MEAT = "用火可以把它烧得更好！",
        MEATBALLS = "将肉制成球状并用火加以改良。",
        MEATRACK =
        {
            DONE = "准备好了！",
            DRYING = "来吧，肉，已经烘干了！",
            DRYINGINRAIN = "忘了雨！擦干！",
            GENERIC = "我想挂一些肉！",
            BURNT = "架子干了。",
            DONE_NOTMEAT = "准备好了！",
            DRYING_NOTMEAT = "烘干这些东西需要多长时间？",
            DRYINGINRAIN_NOTMEAT = "忘了雨！擦干！",
        },
        MEAT_DRIED = "耐嚼，但令人满意。",
        MERM = "哇，身上都是粘液。",
        MERMHEAD =
        {
            GENERIC = "这就是你这么臭得到的！",
            BURNT = "双重倒霉！",
        },
        MERMHOUSE =
        {
            GENERIC = "没人会在乎它是否被烧毁。",
            BURNT = "这是真的，没人在乎。",
        },
        MINERHAT = "一盏方便我们头部的灯。",
        MONKEY = "开你玩笑！我可以剪掉这个便便。",
        MONKEYBARREL = "你听到什么了吗？",
        MONSTERLASAGNA = "不用了，谢谢。",
        FLOWERSALAD = "我宁愿要一碗火焰。",
        ICECREAM = "好吧，有时候冷的事情没关系。",
        WATERMELONICLE = "这正是炎热夏日的必备品。",
        TRAILMIX = "嘎吱嘎吱嘎吱。",
        HOTCHILI = "这就是我喜欢的热度！",
        GUACAMOLE = "天哪，莫利，真好吃！",
        MONSTERMEAT = "不用了，谢谢",
        MONSTERMEAT_DRIED = "它很干，闻起来很奇怪。",
        MOOSE = "那到底是什么。。。",
        MOOSE_NESTING_GROUND = "闻起来像鸟屁股！",
        MOOSEEGG = "太大了！",
        MOSSLING = "它的羽毛磨损了。",
        FEATHERFAN = "我不知道。。。它可能会发出一些。。。",
        MINIFAN = "没有乐趣，让我锻炼来保持凉爽！",
        GOOSE_FEATHER = "如此依偎！",
        STAFF_TORNADO = "总是旋转！旋转着走向毁灭！",
        MOSQUITO =
        {
            GENERIC = "真烦人！",
            HELD = "把那张嘴离我远点！",
        },
        MOSQUITOSACK = "血液必须在闷热而粘稠的洋流中起泡。",
        MOUND =
        {
            DUG = "比我好。",
            GENERIC = "我敢打赌，里面全是死东西。",
        },
        NIGHTLIGHT = "就像火一样，但是紫色！",
        NIGHTMAREFUEL = "哇，还是很暖和！",
        NIGHTSWORD = "就像梦一样，可以伤害真实的事物！",
        NITRE = "里面有微小的爆炸。",
        ONEMANBAND = "我也会做烟火表演！",
        OASISLAKE =
		{
			GENERIC = "这是一堆水。",
			EMPTY = "这是一堆土。",
		},
        PANDORASCHEST = "有点俗气。",
        PANFLUTE = "音乐很无聊。",
        PAPYRUS = "就像纸一样。",
        WAXPAPER = "我们在蜂蜡上擦了一串纸。",
        PENGUIN = "走开，小舞者们。",
        PERD = "坏鸟！远离那些美味的浆果！",
        PEROGIES = "好吃的东西。",
        PETALS = "愚蠢的花。它们几乎没用。",
        PETALS_EVIL = "呃，它们很粘。",
        PHLEGM = "这是一个大鼻涕！",
        PICKAXE = "非常尖锐。",
        PIGGYBACK = "这是一个用屁股做的背包！",
        PIGHEAD =
        {
            GENERIC = "我想我没问题。",
            BURNT = "我想情况可能会变得更糟。",
        },
        PIGHOUSE =
        {
            FULL = "猪在里面做事。",
            GENERIC = "这些猪的建筑品味令人怀疑。",
            LIGHTSOUT = "你这个混蛋！让我进去！",
            BURNT = "装修得不错！",
        },
        PIGKING = "噗嗤，真是个懒虫。",
        PIGMAN =
        {
            DEAD = "我想知道它们味道如何。",
            FOLLOWER = "哎呀。它在跟踪我。",
            GENERIC = "啊。它们很香。",
            GUARD = "他不是我的老板！",
            WEREPIG = "加油，小猪！",
        },
        PIGSKIN = "哈哈。猪屁股。",
        PIGTENT = "闻起来很难闻！",
        PIGTORCH = "这些猪当然知道如何玩得开心。",
        PINECONE = "嘿，树籽。",
        PINECONE_SAPLING = "你很快就会变成一棵真正的树。",
        LUMPY_SAPLING = "我应该在那东西变得丑陋之前把它烧掉。",
        PITCHFORK = "它有三个尖刺。",
        PLANTMEAT = "哎哟，都黏糊糊的。",
        PLANTMEAT_COOKED = "闻起来有点臭。",
        PLANT_NORMAL =
        {
            GENERIC = "如果有必要，我会吃的。",
            GROWING = "快点，你这愚蠢的植物！",
            READY = "哦，孩子。蔬菜",
            WITHERED = "它应该有裂缝吗？它又干又脆。好火种！这有很多部分？",
        },
        POMEGRANATE = "它应该有这么多部件吗？",
        POMEGRANATE_COOKED = "火总是让事情变得更好。",
        POMEGRANATE_SEEDS = "一些种子。",
        POND = "这个池塘绝对不会着火。真无聊。",
        POOP = "肮脏的但是很有用。",
        FERTILIZER = "一桶脏东西。",
        PUMPKIN = "我想知道如果我开枪会发生什么。",
        PUMPKINCOOKIE = "饼干！！！",
        PUMPKIN_COOKED = "外面的火势很好。",
        PUMPKIN_LANTERN = "里面的火太神奇了！",
        PUMPKIN_SEEDS = "一些种子。",
        PURPLEAMULET = "科学走得太远了吗？",
        PURPLEGEM = "奇怪！",
        RABBIT =
        {
            GENERIC = "他看起来很好吃。",
            HELD = "他就在我想要的地方！",
        },
        RABBITHOLE =
        {
            GENERIC = "愚蠢的兔子,出来让我吃了你。",
            SPRING = "愚蠢的兔子一定被困在下面了。",
        },
        RAINOMETER =
        {
            GENERIC = "它测量云雨量。",
            BURNT = "拿着，雨！",
        },
        RAINCOAT = "下雨有它就行了。",
        RAINHAT = "任何能让水远离的东西。",
        RATATOUILLE = "蔬菜这么多蔬菜。",
        RAZOR = "这是干什么用的？",
        REDGEM = "太漂亮了",
        RED_CAP = "我喜欢这个颜色。",
        RED_CAP_COOKED = "它被火改变了！",
        RED_MUSHROOM =
        {
            GENERIC = "漂亮！",
            INGROUND = "嘿你上来！",
            PICKED = "也许有一天它会回来。",
        },
        REEDS =
        {
            BURNING = "那些烧得很快！",
            GENERIC = "这是一堆可燃烧的芦苇。",
            PICKED = "只是芦苇。",
        },
        RELIC = "旧家具。",
        RUINS_RUBBLE = "这可能会被解决。",
        RUBBLE = "破家具。",
        RESEARCHLAB =
        {
            GENERIC = "就连我也不知道一切。。。然而",
            BURNT = "现在没法从中学习。",
        },
        RESEARCHLAB2 =
        {
            GENERIC = "就连我也不知道一切。。。然而",
            BURNT = "现在没法从中学习。",
        },
        RESEARCHLAB3 =
        {
            GENERIC = "它放射出一种黑暗而强大的能量。",
            BURNT = "现在它是黑暗的，不是很强大。",
        },
        RESEARCHLAB4 =
        {
            GENERIC = "我可以像大锅一样使用这顶帽子！",
            BURNT = "加倍努力，加倍努力。。。哦烧了。",
        },
        RESURRECTIONSTATUE =
        {
            GENERIC = "这是我们的保险单。",
            BURNT = "我们的政策被取消了。",
        },
        RESURRECTIONSTONE = "等我准备好了再碰它。",
       ROBIN =
        {
            GENERIC = "这意味着冬天已经过去了吗？",
            HELD = "他喜欢我的口袋。",
        },
        ROBIN_WINTER =
        {
            GENERIC = "生活在冰冻的荒地里。",
            HELD = "太柔软了。",
        },
        ROBOT_PUPPET = "他们被困住了！", --single player
        ROCK_LIGHT =
        {
            GENERIC = "里面很热，等着出去！",--removed
            OUT = "啊，已经冷却了.",--removed
            LOW = "熔岩正在冷却。",--removed
            NORMAL = "又好又舒服。",--removed
        },
        CAVEIN_BOULDER =
        {
            GENERIC = "我们把它砸碎吧。",
            RAISED = "我不能上去！",
        },
        ROCK = "就像一块石头。",
        PETRIFIED_TREE = "全是石头，没有树皮。",
        ROCK_PETRIFIED_TREE = "全是石头，没有树皮。",
        ROCK_PETRIFIED_TREE_OLD = "全是石头，没有树皮。",
        ROCK_ICE =
        {
            GENERIC = "冰是有用的。",
            MELTED = "水坑",
        },
        ROCK_ICE_MELTED = "水坑",
        ICE = "寒冷.",
        ROCKS = "再次收集这些有什么意义？",
        ROOK = "它像一座堡垒！",
        ROPE = "我们应该绑什么？？！",
        ROTTENEGG = "呃！为什么？为什么？！",
        ROYAL_JELLY = "太甜了！",
        JELLYBEAN = "没有什么比一把果冻豆更好的了。",
        SADDLE_BASIC = "太不舒服了。",
        SADDLE_RACE = "值得吗？我认为这是值得的。",
        SADDLE_WAR = "我要把一些村庄夷为平地！",
        SADDLEHORN = "我打赌马鞍下一定很臭。",
        SALTLICK = "这是一大块含脂盐。",
        BRUSH = "闻起来像烧焦的头发。",
		SANITYROCK =
		{
			ACTIVE = "我想知道这些标记是什么意思。",
			INACTIVE = "它去哪儿了？",
		},
		SAPLING =
		{
			BURNING = "太聪明了！",
			WITHERED = "我想是热坏了。",
			GENERIC = "选择它是值得的。",
			PICKED = "可怜的跛脚小树。",
			DISEASED = "也许它需要一些鸡汤？", --removed
			DISEASING = "你闻到了。", --removed
		},
   		SCARECROW =
   		{
			GENERIC = "哈他以为自己是人！",
			BURNING = "是个火人。",
			BURNT = "只是烧了稻草。",
   		},
   		SCULPTINGTABLE=
   		{
			EMPTY = "我一直想上陶艺课！",
			BLOCK = "我要刻一个石头屁股。",
			SCULPTURE = "我想这也很好。",
			BURNT = "哈哈！",
   		},
        SCULPTURE_KNIGHTHEAD = "太好了，现在我们激怒了一些大理石犯罪头目！",
		SCULPTURE_KNIGHTBODY =
		{
			COVERED = "我猜这是一座大理石雕像。",
			UNCOVERED = "那东西看起来很可怕。",
			FINISHED = "他甚至没有说 \"谢谢你\".",
			READY = "哇！它在蠕动！",
		},
        SCULPTURE_BISHOPHEAD = "我总觉得这不应该发生。",
		SCULPTURE_BISHOPBODY =
		{
			COVERED = "不可燃。不感兴趣。",
			UNCOVERED = "曲柄连转都不转！",
			FINISHED = "Humpty Dumpty又在一起了。",
			READY = "哇！它在蠕动！",
		},
        SCULPTURE_ROOKNOSE = "哈，摔成碎片。新手犯的错误。",
		SCULPTURE_ROOKBODY =
		{
			COVERED = "在我看来就像一堆瓦砾。",
			UNCOVERED = "多么令人毛骨悚然的垃圾！",
			FINISHED = "我更习惯于破坏东西，而不是修复它们。",
			READY = "哇！它在蠕动！",
		},
        GARGOYLE_HOUND = "看这个又大又笨的草坪装饰品！",
        GARGOYLE_WEREPIG = "至少它不再有味道了。",
		SEEDS = "耕作很无聊。",
		SEEDS_COOKED = "现在不适合耕种。",
		SEWING_KIT = "但毁灭要有趣得多！",
		SEWING_TAPE = "至少这附近有什么东西能把它团结起来。",
		SHOVEL = "不适合打架。",
		SILK = "嗯。平整的.",
		SKELETON = "我希望你至少在荣耀的火焰中离去。",
		SCORCHED_SKELETON = "哇！",
		SKULLCHEST = "哦，鬼！", --removed
		SMALLBIRD =
		{
			GENERIC = "虽然不是凤凰，但还是很可爱。我想是吧。",
			HUNGRY = "你饿了吗？",
			STARVING = "好吧，好吧！我明白了，你饿了。",
			SLEEPING = "它现在睡着了。",
		},
		SMALLMEAT = "再来几杯就可以做一顿饭了！",
		SMALLMEAT_DRIED = "耐嚼，但令人满意。",
		SPAT = "我不喜欢你的脸！",
		SPEAR = "我更喜欢亚里！",
		SPEAR_WATHGRITHR = "感觉很刺痛。",
		WATHGRITHRHAT = "里面写着一个名字。。。 \"W\", 呃...",
		SPIDER =
		{
			DEAD = "安息……",
			GENERIC = "摆动然后死去。",
			SLEEPING = "我可以带走他。",
		},
		SPIDERDEN = "那太恶心了。",
		SPIDEREGGSACK = "成吨的恶心小蜘蛛。",
		SPIDERGLAND = "哎哟，又黏又臭！",
		SPIDERHAT = "谁是你妈妈！",
		SPIDERQUEEN = "我要把它砍掉！",
		SPIDER_WARRIOR =
		{
			DEAD = "安息吧。。。",
			GENERIC = "你害怕我吗？",
			SLEEPING = "也许我应该让那一个单独呆着。",
		},
		SPOILED_FOOD = "嗯...",
        STAGEHAND =
        {
			AWAKE = "我告诉过你我们应该烧了它！",
			HIDING = "一张奇怪的桌子在外面干什么？",
        },
        STATUE_MARBLE =
        {
            GENERIC = "我想这是一座不错的雕像。",
            TYPE1 = "是的，如果我是她，我也会把这件事掩盖起来。",
            TYPE2 = "她今天还没戴上面具。",
            TYPE3 = "火盆会更好。", --bird bath type statue
        },
		STATUEHARP = "这么漂亮的雕像。如果它出了什么事，那就太可惜了。",
		STATUEMAXWELL = "一个大石头书呆子。",
		STEELWOOL = "粗糙的金属纤维。",
		STINGER = "它很小！",
		STRAWHAT = "稻草做的帽子。想想看，这可能是火种。",
		STUFFEDEGGPLANT = "它仍然不是一只鸟，但它确实像一只鸟一样被塞满了！",
		SWEATERVEST = "它又痒又合身。",
		REFLECTIVEVEST = "背心穿得太深了。",
		HAWAIIANSHIRT = "肯定是爷爷的风格。",
		TAFFY = "糖果",
		TALLBIRD = "我觉得它不想成为朋友。",
		TALLBIRDEGG = "它会孵化吗？",
		TALLBIRDEGG_COOKED = "美味又营养。",
		TALLBIRDEGG_CRACKED =
		{
			COLD = "是在颤抖还是我？",
			GENERIC = "看起来它正在孵化！",
			HOT = "鸡蛋应该出汗吗？",
			LONG = "我感觉这需要一段时间……",
			SHORT = "现在随时都可以孵化。",
		},
		TALLBIRDNEST =
		{
			GENERIC = "那真是个蛋！",
			PICKED = "鸟巢是空的。",
		},
		TEENBIRD =
		{
			GENERIC = "我觉得他能理解。",
			HUNGRY = "他确实吃了很多。",
			STARVING = "别看我！自己拿食物。",
			SLEEPING = "你所做的就是吃和睡。",
		},
		TELEPORTATO_BASE =
		{
			ACTIVE = "有了它，我一定能穿越时空！", --single player
			GENERIC = "这似乎是与另一个世界的联系！", --single player
			LOCKED = "仍然缺少一些东西。", --single player
			PARTIAL = "很快，这项发明就会完成！", --single player
		},
		TELEPORTATO_BOX = "这可能会控制整个宇宙的极性。", --single player
		TELEPORTATO_CRANK = "足够坚韧，可以处理最激烈的实验。", --single player
		TELEPORTATO_POTATO = "这个金属土豆包含巨大而可怕的力量……", --single player
		TELEPORTATO_RING = "一个可以聚焦维度能量的环。", --single player
		TELESTAFF = "使用起来相当匆忙。",
		TENT =
		{
			GENERIC = "我拿到了童子军的所有徽章。",
			BURNT = "嗯，我的徽章还在。",
		},
		SIESTAHUT =
		{
			GENERIC = "他们教我们如何在童子军中制作这些。",
			BURNT = "现在不会提供太多阴影。",
		},
		TENTACLE = "一点也不可爱。",
		TENTACLESPIKE = "它又尖又粘。",
		TENTACLESPOTS = "呃",
		TENTACLE_PILLAR = "它在颤动。",
        TENTACLE_PILLAR_HOLE = "多臭啊！下次点一根火柴！",
		TENTACLE_PILLAR_ARM = "哇，他们想要拥抱！",
		TENTACLE_GARDEN = "我听到轻微的挖掘声。",
		TOPHAT = "我穿上那件衣服会看起来像个淑女！",
		TORCH = "有什么东西可以阻挡夜晚。",
		TRANSISTOR = "电气嘟嘟，嘟嘟。",
		TRAP = "我把它织得很紧。",
		TRAP_TEETH = "这是一个令人讨厌的惊喜。",
		TRAP_TEETH_MAXWELL = "我知道到底是什么样的混蛋让这东西到处乱放！", --single player
		TREASURECHEST =
		{
			GENERIC = "这是我的箱子。",
			BURNT = "烧得很好。",
		},
		TREASURECHEST_TRAP = "肮脏的把戏！",
		SACRED_CHEST =
		{
			GENERIC = "非常非常旧的箱子。",
			LOCKED = "我觉得这是在评判我。",
		},
		TREECLUMP = "移......动。", --removed

		
		TRINKET_1 = "如果我们有额外的创造力，我们仍然可以玩这些。", --Melted Marbles
		TRINKET_2 = "无声乐器。", --Fake Kazoo
		TRINKET_3 = "它不会解开的！", --Gord's Knot
		TRINKET_4 = "它在看着我们。", --Gnome
		TRINKET_5 = "耶，一个新玩具！", --Toy Rocketship
		TRINKET_6 = "也许我会找到这些东西的用处。", --Frazzled Wires
		TRINKET_7 = "另一个玩具！", --Ball and Cup
		TRINKET_8 = "我想念洗澡玩具。", --Rubber Bung
		TRINKET_9 = "他们都不相配！", --Mismatched Buttons
		TRINKET_10 = "就像爷爷穿的一样！", --Dentures
		TRINKET_11 = "哔哔！", --Lying Robot
		TRINKET_12 = "感觉像皮革一样。", --Dessicated Tentacle
		TRINKET_13 = "它在看着我们。", --Gnomette
		TRINKET_14 = "我想要一些热可可。", --Leaky Teacup
		TRINKET_15 = "我不知道怎么玩这个游戏。", --Pawn
		TRINKET_16 = "我不知道怎么玩这个游戏。", --Pawn
		TRINKET_17 = "虫子。虫子。虫子。哈哈哈！", --Bent Spork
		TRINKET_18 = "我喜欢玩具", --Trojan Horse
		TRINKET_19 = "这个玩具不太好用。", --Unbalanced Top
		TRINKET_20 = "我能用这个挖土吗？", --Backscratcher
		TRINKET_21 = "妈妈有一个。", --Egg Beater
		TRINKET_22 = "有点像我们的织带！", --Frayed Yarn
		TRINKET_23 = "我们要吹吗？", --Shoehorn
		TRINKET_24 = "还没有饼干！", --Lucky Cat Jar
		TRINKET_25 = "真臭。", --Air Unfreshener
		TRINKET_26 = "你是我们的杯子！", --Potato Cup
		TRINKET_27 = "这太愚蠢了。", --Coat Hanger
		TRINKET_28 = "也许麦克斯韦尔会教我们怎么玩。", --Rook
        TRINKET_29 = "也许麦克斯韦尔会教我们怎么玩。", --Rook
        TRINKET_30 = "如果我不知道这些规则，我就不能遵守它们。", --Knight
        TRINKET_31 = "如果我不知道这些规则，我就不能遵守它们。", --Knight
        TRINKET_32 = "它没有弹性。有什么意义？", --Cubic Zirconia Ball
        TRINKET_33 = "这是我们手指的朋友！！", --Spider Ring
        TRINKET_34 = "猴子可能需要这个。", --Monkey Paw
        TRINKET_35 = "我有点想喝剩下的东西，但他不让我喝。", --Empty Elixir
        TRINKET_36 = "我已经有了，谢谢。", --Faux fangs
        TRINKET_37 = "也许我应该在有人受伤之前把这个藏起来。", --Broken Stake
        TRINKET_38 = "哈哈！所有东西看起来都很小！", -- Binoculars Griftlands trinket
        TRINKET_39 = "那太无聊了。", -- Lone Glove Griftlands trinket
        TRINKET_40 = "哈哈，它看起来像蜗牛壳。", -- Snail Scale Griftlands trinket
        TRINKET_41 = "哈哈！奇怪！", -- Goop Canister Hot Lava trinket
        TRINKET_42 = "整洁！！", -- Toy Cobra Hot Lava trinket
        TRINKET_43= "来吧，小鳄鱼！让我们冒险吧！", -- Crocodile Toy Hot Lava trinket
        TRINKET_44 = "这株植物真漂亮！", -- Broken Terrarium ONI trinket
        TRINKET_45 = "它没有任何好的频道。", -- Odd Radio ONI trinket
        TRINKET_46 = "这是干什么用的？", -- Hairdryer ONI trinket

        -- The numbers align with the trinket numbers above.
        LOST_TOY_1  = "我们认为这些可能属于其他人。",
        LOST_TOY_2  = "我们认为这些可能属于其他人。",
        LOST_TOY_7  = "我们认为这些可能属于其他人。",
        LOST_TOY_10 = "我们认为这些可能属于其他人。",
        LOST_TOY_11 = "我们认为这些可能属于其他人。",
        LOST_TOY_14 = "我们认为这些可能属于其他人。",
        LOST_TOY_18 = "我们认为这些可能属于其他人。",
        LOST_TOY_19 = "我们认为这些可能属于其他人。",
        LOST_TOY_42 = "我们认为这些可能属于其他人。",
        LOST_TOY_43 = "我们认为这些可能属于其他人。",

        HALLOWEENCANDY_1 = "哦，温迪！我用你换你的巧克力猪！",
        HALLOWEENCANDY_2 = "哈哈，真奇怪！",
        HALLOWEENCANDY_3 = "哈哈，那不是糖果！",
        HALLOWEENCANDY_4 = "我们对此并不完全满意。",
        HALLOWEENCANDY_5 = "我忘了什么是好东西的味道！",
        HALLOWEENCANDY_6 = "不比我们在这里吃的其他东西更糟糕！",
        HALLOWEENCANDY_7 = "哦，威克女士！我给你留了这些！",
        HALLOWEENCANDY_8 = "糖果！糖果！糖果！",
        HALLOWEENCANDY_9 = "粘虫，好吃虫！",
        HALLOWEENCANDY_10 = "糖果！糖果！糖果！",
        HALLOWEENCANDY_11 = "嗯！甜蜜的复仇！。",
        HALLOWEENCANDY_12 = "蠕动，但令人满意。", --ONI meal lice candy
        HALLOWEENCANDY_13 = "我非常喜欢这些。", --Griftlands themed candy
        HALLOWEENCANDY_14 = "天哪，太辣了。", --Hot Lava pepper candy
        CANDYBAG = "请客，请客，请客！",

		HALLOWEEN_ORNAMENT_1 = "哦，太可怕了，我应该装饰一下！",
		HALLOWEEN_ORNAMENT_2 = "天哪，这看起来几乎是真的。",
		HALLOWEEN_ORNAMENT_3 = "哦，这不是真的。我们把它挂在什么地方吧。",
		HALLOWEEN_ORNAMENT_4 = "我们把它挂在某个地方过万圣节吧！",
		HALLOWEEN_ORNAMENT_5 = "我应该把这家伙放在树上！",
		HALLOWEEN_ORNAMENT_6 = "如果我把它放在树上，它看起来几乎是真的。",

		HALLOWEENPOTION_DRINKS_WEAK = "它只有一点点功效。",
		HALLOWEENPOTION_DRINKS_POTENT = "它相当强大。",
        HALLOWEENPOTION_BRAVERY = "让我们觉得自己又大又强壮！",
		HALLOWEENPOTION_MOON = "我应该喝吗？不，可能不会。",
		HALLOWEENPOTION_FIRE_FX = "太棒了！就像鞭炮一样。",
		MADSCIENCE_LAB = "哇，看看它的泡沫。",
		LIVINGTREE_ROOT = "我应该把它种在某个地方。",
		LIVINGTREE_SAPLING = "这是一个怪物小孩。像我一样！",

        DRAGONHEADHAT = "前面有点吓人。",
        DRAGONBODYHAT = "我不确定我是否想再添一个肚子。",
        DRAGONTAILHAT = "我喜欢尾巴！",
        PERDSHRINE =
        {
            GENERIC = "我想给它点东西！",
            EMPTY = "罐子是空的。",
            BURNT = "那根本不行。",
        },
        REDLANTERN = "我们自己的个人夜灯！",
        LUCKY_GOLDNUGGET = "太亮了！",
        FIRECRACKERS = "别担心，女士，我们会小心的。",
        PERDFAN = "太大了！！",
        REDPOUCH = "我真幸运！",
        WARGSHRINE =
        {
            GENERIC = "看起来好多了！",
            EMPTY = "我需要在里面放个手电筒。",
            BURNING = "这就是我们应该做的，对吗？", --for willow to override
            BURNT = "我可能误解了。",
        },
        CLAYWARG =
        {
        	GENERIC = "你的眼睛是怎么做到的？！",
        	STATUE = "有人雕刻了这个东西吗？",
        },
        CLAYHOUND =
        {
        	GENERIC = "这只狗冷得要命！",
        	STATUE = "嗯，这是岩石的奇怪形状。",
        },
        HOUNDWHISTLE = "嘿嘿，留下来。",
        CHESSPIECE_CLAYHOUND = "看起来很友好。",
        CHESSPIECE_CLAYWARG = "现在看起来没那么难。",

		PIGSHRINE =
		{
            GENERIC = "我的神殿在哪里？",
            EMPTY = "需要肉。",
            BURNT = "我喜欢。",
		},
		PIG_TOKEN = "它可能值点钱。",
		PIG_COIN = "终于有人来做我的脏活了。",
		YOTP_FOOD1 = "我要把它全吃了！",
		YOTP_FOOD2 = "不，我要把它喂给什么东西。",
		YOTP_FOOD3 = "填饱肚子的小吃。",

		PIGELITE1 = "都洗干净了。", --BLUE
		PIGELITE2 = "你，我喜欢。", --RED
		PIGELITE3 = "吃土！", --WHITE
		PIGELITE4 = "当然喜欢使用这些标志。", --GREEN

		PIGELITEFIGHTER1 = "全部清洗完毕。", --BLUE
		PIGELITEFIGHTER2 = "你，我喜欢。", --RED
		PIGELITEFIGHTER3 = "吃泥土！", --WHITE
		PIGELITEFIGHTER4 = "当然喜欢使用这些标志。", --GREEN

		CARRAT_GHOSTRACER = "这是一只看起来很奇怪的Carrat.",

        YOTC_CARRAT_RACE_START = "我的肯定会赢。",
        YOTC_CARRAT_RACE_CHECKPOINT = "查看此检查点！",
        YOTC_CARRAT_RACE_FINISH =
        {
            GENERIC = "它实际上更像是一个终点圆，而不是一条线。",
            BURNT = "现在更像是这样了。",
            I_WON = "噗，好像我会赢一样。",
            SOMEONE_ELSE_WON = "{winner}很幸运，我赢了下一个。",
        },

		YOTC_CARRAT_RACE_START_ITEM = "真是一场秀。",
        YOTC_CARRAT_RACE_CHECKPOINT_ITEM = "这是检查结果。",
		YOTC_CARRAT_RACE_FINISH_ITEM = "让我看看，哪里是我获胜的好地方？",

		YOTC_SEEDPACKET = "只是一堆种子。",
		YOTC_SEEDPACKET_RARE = "哦，哇，特别的种子，多么令人兴奋。",

		MINIBOATLANTERN = "海洋可能需要更多的光线。",

        YOTC_CARRATSHRINE =
        {
            GENERIC = "为什么老鼠有神龛而我没有？",
            EMPTY = "让我猜猜，我得给你点东西。",
            BURNT = "没有遗憾。",
        },

        YOTC_CARRAT_GYM_DIRECTION =
        {
            GENERIC = "这应该很有趣。",
            RAT = "头晕了吗？",
            BURNT = "烧伤好的人都好。",
        },
        YOTC_CARRAT_GYM_SPEED =
        {
            GENERIC = "我需要让我的Carrat跟上速度。",
            RAT = "看那些小腿，快！",
            BURNT = "烧伤好的人都好。",
        },
        YOTC_CARRAT_GYM_REACTION =
        {
            GENERIC = "当然，为什么不。",
            RAT = "哈！我可以看一整天。",
            BURNT = "烧伤好的人都好。",
        },
        YOTC_CARRAT_GYM_STAMINA =
        {
            GENERIC = "看！它有一根小跳绳！",
            RAT = "继续，拿浆果！",
            BURNT = "烧伤好的人都好。",
        },

        YOTC_CARRAT_GYM_DIRECTION_ITEM = "一堆健身房形状的潜在火种。",
        YOTC_CARRAT_GYM_SPEED_ITEM = "一堆健身房形状的潜在火种。",
        YOTC_CARRAT_GYM_STAMINA_ITEM = "一堆健身房形状的潜在火种。",
        YOTC_CARRAT_GYM_REACTION_ITEM = "一堆健身房形状的潜在火种。",

        YOTC_CARRAT_SCALE_ITEM = "一堆漂亮的鳞状潜在火种。",
        YOTC_CARRAT_SCALE =
        {
            GENERIC = "我的卡拉特不太合适！我是说真的。",
            CARRAT = "嗯，我看得更好。",
            CARRAT_GOOD = "现在我们在说话！",
            BURNT = "哈！很好。",
        },

        YOTB_BEEFALOSHRINE =
        {
            GENERIC = "有鞭炮吗？",
            EMPTY = "我想我应该给它点东西。",
            BURNT = "那不好……",
        },

        BEEFALO_GROOMER =
        {
            GENERIC = "来吧，比法洛，该化妆了！",
            OCCUPIED = "老实说，我做的任何事都会有进步。",
            BURNT = "嘿，那很有趣。",
        },
        BEEFALO_GROOMER_ITEM = "呃。。。为什么每件事都要做这么多工作？",

		BISHOP_CHARGE_HIT = "喔噢！",
		TRUNKVEST_SUMMER = "太胖了！",
		TRUNKVEST_WINTER = "冬季生存装备",
		TRUNK_COOKED = "它看起来还不是完全可以吃的。",
		TRUNK_SUMMER = "嗯，他的一部分仍然很可爱。",
		TRUNK_WINTER = "它又软又粘！",
		TUMBLEWEED = "谁知道风滚草捡到了什么。",
		TURKEYDINNER = "一顿烧鸟的盛宴！",
		TWIGS = "一束小树枝",
		UMBRELLA = "我喜欢这个颜色！",
		GRASS_UMBRELLA = "尽可能漂亮！",
		UNIMPLEMENTED = "它还没有完成。但我敢打赌它仍在燃烧",
		WAFFLES = "嗨，华夫饼干！",
		WALL_HAY =
		{
			GENERIC = "这将阻止各种事情发生！",
			BURNT = "它没能把火扑灭。",
		},
		WALL_HAY_ITEM = "这似乎是个坏主意。",
		WALL_STONE = "呃，我想没关系。",
		WALL_STONE_ITEM = "这些东西特别重。",
		WALL_RUINS = "他们会怒气冲冲，喘着粗气！",
		WALL_RUINS_ITEM = "这些能放进我的口袋吗？",
		WALL_WOOD =
		{
			GENERIC = "尖头！",
			BURNT = "烧焦了！",
		},
		WALL_WOOD_ITEM = "我讨厌躲起来。",
		WALL_MOONROCK = "暂时安全。",
		WALL_MOONROCK_ITEM = "我想我可以拿着它。",
		FENCE = "我不是在画它。",
        FENCE_ITEM = "没有必要把它留在地上。",
        FENCE_GATE = "我想我们可以用它来写东西。",
        FENCE_GATE_ITEM = "没有必要把它留在地上",
		WALRUS = "别跟着我！",
		WALRUSHAT = "我有点喜欢它的外观。",
		WALRUS_CAMP =
		{
			EMPTY = "我不进去。恶心！",
			GENERIC = "为什么每个人的房子都比我好？",
		},
		WALRUS_TUSK = "不，不，不。",
		WARDROBE =
		{
			GENERIC = "它掌握着黑暗的、被禁止的秘密……",
            BURNING = "着火了！着火了！！",
			BURNT = "啊，火烧灭了。",
		},
		WARG = "你是个大混蛋！",
		WASPHIVE = "一个满是孔洞的锥体。",
		WATERBALLOON = "嘘！嘘！",
		WATERMELON = "粘甜的。",
		WATERMELON_COOKED = "多汁且甜蜜。",
		WATERMELONHAT = "嗯，这是这种水果的一种用途。",
		WAXWELLJOURNAL = "会成为一个很棒的睡前故事……适合做噩梦！",
		WETGOOP = "我从来没有声称自己擅长烹饪！",
        WHIP = "这意味着我现在是老板了。",
		WINTERHAT = "温度不够我喜欢。",
		WINTEROMETER =
		{
			GENERIC = "注意温度可能是明智的。",
			BURNT = "外面不可能这么热！",
		},

        WINTER_TREE =
        {
            BURNT = "祝大家冬季大餐愉快",
            BURNING = "现在我们在庆祝！",
            CANDECORATE = "看起来很棒！",
            YOUNG = "有点小。",
        },
		WINTER_TREESTAND =
		{
			GENERIC = "我们要种树吗？",
            BURNT = "祝大家冬季大餐愉快。",
		},
        WINTER_ORNAMENT = "漂亮 漂亮！哇！",
        WINTER_ORNAMENTLIGHT = "没有光，树是不完整的。",
        WINTER_ORNAMENTBOSS = "哇，太亮了！太棒了！",
		WINTER_ORNAMENTFORGE = "我应该在篝火上烤这个。",
		WINTER_ORNAMENTGORGE = "嗯，看起来有点……像山羊！",

        WINTER_FOOD1 = "老实说，谁不先吃脑袋？", --gingerbread cookie
        WINTER_FOOD2 = "考虑到这一点，看起来还不错！", --sugar cookie
        WINTER_FOOD3 = "给我两个，我就能给你一个MacTusk的印象。", --candy cane
        WINTER_FOOD4 = "还有谁能感觉到邪恶的恶臭吗？", --fruitcake
        WINTER_FOOD5 = "一根用来吃的木头，不是用来燃烧的。", --yule log cake
        WINTER_FOOD6 = "我要把脸塞满！！", --plum pudding
        WINTER_FOOD7 = "当然比雨水好！", --apple cider
        WINTER_FOOD8 = "我只喜欢烫的时候。", --hot cocoa
        WINTER_FOOD9 = "谁知道鸟屁股里的东西会这么好吃？", --eggnog

		WINTERSFEASTOVEN =
		{
			GENERIC = "哦，别告诉我我是要做饭的人……",
			COOKING = "呃，这是最无聊的部分。",
			ALMOST_DONE_COOKING = "差不多做完了吗！？",
			DISH_READY = "终于！",
		},
		BERRYSAUCE = "这是最好的部分",
		BIBINGKA = "柔软且海绵状。",
		CABBAGEROLLS = "是的，我可以吃这些。",
		FESTIVEFISH = "真是太喜庆了！",
		GRAVY = "耶！倒在肉汁上！",
		LATKES = "不要在酸奶油上撇奶油！",
		LUTEFISK = "它看起来真的很好吃。",
		MULLEDDRINK = "它让你从内到外感到温暖。",
		PANETTONE = "我只是饿了，还是所有东西看起来都特别好吃？",
		PAVLOVA = "它看起来很精致，我只想把它弄脏。",
		PICKLEDHERRING = "怎么闻起来这么香？",
		POLISHCOOKIE = "是的，我会再吃十个。",
		PUMPKINPIE = "是的，我正在吃这整件东西。",
		ROASTTURKEY = "多么大的火鸡腿啊！",
		STUFFING = "从火鸡里出来，塞进我的肚子里！",
		SWEETPOTATO = "我不介意。",
		TAMALES = "如果我吃得更多，我会开始感觉有点沙哑。",
		TOURTIERE = "到我的馅饼洞里去！",

		TABLE_WINTERS_FEAST =
		{
			GENERIC = "我们有客人吗？",
			HAS_FOOD = "有足够的食物给每个人吗",
			WRONG_TYPE = "不是这个季节。",
			BURNT = "现在我真的感受到了节日的气氛！",
		},

		GINGERBREADWARG = "甜点不应该吃人！",
		GINGERBREADHOUSE = "我们吃吧！",
		GINGERBREADPIG = "嘿，快回来！",
		CRUMBS = "哈哈，那个小家伙正在失去他的角色。",
		WINTERSFEASTFUEL = "本季的精神！",

        KLAUS = "实际上，一块煤真的很有用！",
        KLAUS_SACK = "没有什么能让锁说 \"打开我\" 比如",
		KLAUSSACKKEY = "哈！我可不想被那东西揍！",
		WORMHOLE =
		{
			GENERIC = "用棍子戳它！",
			OPEN = "我们开始了！",
		},
		WORMHOLE_LIMITED = "哎呀，这撑不了多久。",
		ACCOMPLISHMENT_SHRINE = "我讨厌那支箭", --single player
		LIVINGTREE = "它可能还活着。",
		ICESTAFF = "无聊...",
		REVIVER = "我以为会更黑。",
		SHADOWHEART = "哦，哇！谁会碰它？！",
         ATRIUM_RUBBLE =
        {
			LINE_1 = "它描绘了一个古老的文明。人们看起来又饿又害怕。",
			LINE_2 = "这台平板电脑太旧了，看不出来。",
			LINE_3 = "黑暗的东西笼罩着这座城市及其人民。",
			LINE_4 = "人们正在蜕皮。他们的内心看起来不同。",
			LINE_5 = "它展示了一座巨大的、技术先进的城市。",
		},
        ATRIUM_STATUE = "它似乎并不完全真实。",
        ATRIUM_LIGHT =
        {
			ON = "一道真正令人不安的光。",
			OFF = "一定有什么东西给它供电。",
		},
        ATRIUM_GATE =
        {
			ON = "恢复工作状态。",
			OFF = "基本部件仍然完好无损。",
			CHARGING = "它正在获得动力。",
			DESTABILIZING = "网关正在失稳。",
			COOLDOWN = "恢复需要时间。我也是。",
        },
        ATRIUM_KEY = "有力量从中散发出来。",
		LIFEINJECTOR = "你不敢把它塞到我身上！",
		SKELETON_PLAYER =
		{
			MALE = "哦，不，%s！%s一定是真的伤害了他！",
			FEMALE = "哦，不，%s！%s一定是真的伤害了她！",
			ROBOT = "哦，不，%s！%s一定是真的伤害了他们！",
			DEFAULT = "哦，不，%s！%s一定是真的伤害了他们！",
		},
--fallback to speech_wilson.lua 		HUMANMEAT = "Flesh is flesh. Where do I draw the line?",
--fallback to speech_wilson.lua 		HUMANMEAT_COOKED = "Cooked nice and pink, but still morally gray.",
--fallback to speech_wilson.lua 		HUMANMEAT_DRIED = "Letting it dry makes it not come from a human, right?",
		ROCK_MOON = "对我来说只是另一块石头。",
		MOONROCKNUGGET = "对我来说只是另一块石头。",
		MOONROCKCRATER = "太好了。一块有洞的岩石。",
		MOONROCKSEED = "太棒了，这是一个可以自己漂浮的球！",

        REDMOONEYE = "它能看见，而且能被看见好几英里！",
        PURPLEMOONEYE = "某种奇怪的岩石。",
        GREENMOONEYE = "一块大而哑的石头。",
        ORANGEMOONEYE = "这是一块石头。啊！",
        YELLOWMOONEYE = "另一块石头！",
        BLUEMOONEYE = "那不是眼球！是石头！",

        --Arena Event
        LAVAARENA_BOARLORD = "噗，我打赌他甚至不会战斗。",
        BOARRIOR = "他看起来很憔悴",
        BOARON = "把鼻子留给你自己！",
        PEGHOOK = "它有一个武器化的屁股！",
        TRAILS = "你不能推我。",
        TURTILLUS = "嘿！我怎么能摆出这样的姿势用这么多盔甲打你呢？",
        SNAPPER = "天哪，他的鳄鱼皮是什么？",
		RHINODRILL = "噗，不管是什么犀牛兄弟。",
		BEETLETAUR = "我敢打赌，你觉得穿上这身盔甲很安全。",

        LAVAARENA_PORTAL =
        {
            ON = "该走了。",
            GENERIC = "这比我们回家的大门好多了！",
        },
        LAVAARENA_KEYHOLE = "里面没有钥匙。",
		LAVAARENA_KEYHOLE_FULL = "看起来不错。",
        LAVAARENA_BATTLESTANDARD = "杀死那面旗帜！",
        LAVAARENA_SPAWNER = "混蛋出来了。",

        HEALINGSTAFF = "我可以试一下。",
        FIREBALLSTAFF = "它从上面召唤流星。",
        HAMMER_MJOLNIR = "那武器看起来很无聊。",
        SPEAR_GUNGNIR = "我不想用它。",
        BLOWDART_LAVA = "现在你死定了！",
        BLOWDART_LAVA2 = "哦，火力！",
        LAVAARENA_LUCY = "那是伍迪的斧头。",
        WEBBER_SPIDER_MINION = "那只蜘蛛太小了！",
        BOOK_FOSSIL = "对我来说就像火种。",
		LAVAARENA_BERNIE = "伯尼，你永远在我身边。",
		SPEAR_LANCE = "看起来很笨重。",
		BOOK_ELEMENTAL = "对于一本书来说，看起来很有趣。",
		LAVAARENA_ELEMENTAL = "哇！我喜欢！",

   		LAVAARENA_ARMORLIGHT = "这件盔甲不太好。",
		LAVAARENA_ARMORLIGHTSPEED = "它几乎什么都不做。",
		LAVAARENA_ARMORMEDIUM = "这件盔甲可以阻止一两次打击。",
		LAVAARENA_ARMORMEDIUMDAMAGER = "适合拍马屁。",
		LAVAARENA_ARMORMEDIUMRECHARGER = "我可以更频繁地用它做整洁的事情。",
		LAVAARENA_ARMORHEAVY = "那件盔甲看起来很安全。",
		LAVAARENA_ARMOREXTRAHEAVY = "没有什么能通过它的！",

		LAVAARENA_FEATHERCROWNHAT = "这是一个羽毛王冠！",
        LAVAARENA_HEALINGFLOWERHAT = "这是一个很棒的花圈！",
        LAVAARENA_LIGHTDAMAGERHAT = "太尖了！",
        LAVAARENA_STRONGDAMAGERHAT = "如果我想打东西，我会穿它。",
        LAVAARENA_TIARAFLOWERPETALSHAT = "配备了匹配的工作人员！",
        LAVAARENA_EYECIRCLETHAT = "哦，给我！",
        LAVAARENA_RECHARGERHAT = "哦，我想要它！",
        LAVAARENA_HEALINGGARLANDHAT = "穿上它会让你感觉好一点。",
        LAVAARENA_CROWNDAMAGERHAT = "权利！",

		LAVAARENA_ARMOR_HP = "呜呼！我应该穿上。",

		LAVAARENA_FIREBOMB = "火！火！火！",
		LAVAARENA_HEAVYBLADE = "我不可能用这个",

        --Quagmire
        QUAGMIRE_ALTAR =
        {
        	GENERIC = "别看。向上",
        	FULL = "我不知道所有的食物都去哪儿了。可能是某个恶心的地方。",
    	},
		QUAGMIRE_ALTAR_STATUE1 = "哈哈！看看这尊笨山羊雕像。",
		QUAGMIRE_PARK_FOUNTAIN = "没有水的喷泉。也许这是个比喻？",

        QUAGMIRE_HOE = "你是说我得工作？",

        QUAGMIRE_TURNIP = "哈哈，真恶心，我讨厌萝卜。",
        QUAGMIRE_TURNIP_COOKED = "拿着，萝卜。",
        QUAGMIRE_TURNIP_SEEDS = "这只是一堆种子。",

        QUAGMIRE_GARLIC = "这只是几瓣大蒜。",
        QUAGMIRE_GARLIC_COOKED = "火使它更好。",
        QUAGMIRE_GARLIC_SEEDS = "这只是一堆种子。",

        QUAGMIRE_ONION = "它是如此的球状。",
        QUAGMIRE_ONION_COOKED = "烘焙。我最喜欢的烹饪方法。",
        QUAGMIRE_ONION_SEEDS = "这只是一堆种子。",

        QUAGMIRE_POTATO = "我们在那堆垃圾里种的。",
        QUAGMIRE_POTATO_COOKED = "烹饪就是把东西粘在火里。",
        QUAGMIRE_POTATO_SEEDS = "这只是一堆种子。",

        QUAGMIRE_TOMATO = "切这些东西很痛苦。",
        QUAGMIRE_TOMATO_COOKED = "只需要在火上烤几分钟就可以了。",
        QUAGMIRE_TOMATO_SEEDS = "这只是一堆种子。",

        QUAGMIRE_FLOUR = "你能吃面粉吗？",
        QUAGMIRE_WHEAT = "你到底怎么吃这个？",
        QUAGMIRE_WHEAT_SEEDS = "这只是一堆种子。",
        --NOTE: raw/cooked carrot uses regular carrot strings
        QUAGMIRE_CARROT_SEEDS = "这只是一堆种子。",

        QUAGMIRE_ROTTEN_CROP = "那只在地里呆得太久了。",

		QUAGMIRE_SALMON = "看看它，像那样扑腾。",
		QUAGMIRE_SALMON_COOKED = "准备好吃饭了。",
		QUAGMIRE_CRABMEAT = "这里没有仿制品。",
		QUAGMIRE_CRABMEAT_COOKED = "我打赌它很好吃。.",
		QUAGMIRE_SUGARWOODTREE =
		{
			GENERIC = "里面全是美味的汁液。",
			STUMP = "现在有点没用了。",
			TAPPED_EMPTY = "这要花很长时间！",
			TAPPED_READY = "准备好了！",
			TAPPED_BUGS = "愚蠢的虫子",
			WOUNDED = "你看起来不那么热，树。",
		},
		QUAGMIRE_SPOTSPICE_SHRUB =
		{
			GENERIC = "闻起来有点胡椒味。",
			PICKED = "这不是在增长。",
		},
		QUAGMIRE_SPOTSPICE_SPRIG = "这是一片胡椒灌木。",
		QUAGMIRE_SPOTSPICE_GROUND = "香料……生活的真正香料。",
		QUAGMIRE_SAPBUCKET = "现在我们可以把树液从树上取出来了。",
		QUAGMIRE_SAP = "嗯！纯糖！",
		QUAGMIRE_SALT_RACK =
		{
			READY = "我得把盐挖出来。",
			GENERIC = "生长得更快，盐晶体！",
		},

		QUAGMIRE_POND_SALT = "哎哟！尝起来像大海。",
		QUAGMIRE_SALT_RACK_ITEM = "我可以用它来买些食盐。",

		QUAGMIRE_SAFE =
		{
			GENERIC = "哈！破解了它。",
			LOCKED = "我打不开。",
		},

		QUAGMIRE_KEY = "酷！我想知道它解锁了什么？",
		QUAGMIRE_KEY_PARK = "我想去公园。",
        QUAGMIRE_PORTAL_KEY = "泥潭门",


		QUAGMIRE_MUSHROOMSTUMP =
		{
			GENERIC = "它们太可怕了，几乎都很可爱。",
			PICKED = "嘿！再给我一些蘑菇！",
		},
		QUAGMIRE_MUSHROOMS = "完全是生的。火可以解决它！",
        QUAGMIRE_MEALINGSTONE = "我可以用它把东西砸碎。",
		QUAGMIRE_PEBBLECRAB = "别担心，我不会踢你的。",


		QUAGMIRE_RUBBLE_CARRIAGE = "我希望我能坐在里面。",
        QUAGMIRE_RUBBLE_CLOCK = "它还能告诉你正确的时间吗？",
        QUAGMIRE_RUBBLE_CATHEDRAL = "我连修都修不好。",
        QUAGMIRE_RUBBLE_PUBDOOR = "它再也走不到任何地方了。",
        QUAGMIRE_RUBBLE_ROOF = "太糟糕了。",
        QUAGMIRE_RUBBLE_CLOCKTOWER = "我觉得那个钟不工作了",
        QUAGMIRE_RUBBLE_BIKE = "啊……它坏了。",
        QUAGMIRE_RUBBLE_HOUSE =
        {
            "我想知道这里发生了什么事？",
            "大家都去哪儿了？",
            "看来大家都走了",
        },
        QUAGMIRE_RUBBLE_CHIMNEY = "没有壁炉的烟囱是什么？",
        QUAGMIRE_RUBBLE_CHIMNEY2 = "哇，这不好！",
        QUAGMIRE_MERMHOUSE = "我想这就是这里附近的村庄。",
        QUAGMIRE_SWAMPIG_HOUSE = "这只是要求被烧毁。",
        QUAGMIRE_SWAMPIG_HOUSE_RUBBLE = "嘿，猪！你的房子被炸毁了！",
        QUAGMIRE_SWAMPIGELDER =
        {
            GENERIC = "他们和我们家的猪没什么不同。",
            SLEEPING = "它在小睡。",
        },
        QUAGMIRE_SWAMPIG = "不是最漂亮的脸。",

        QUAGMIRE_PORTAL = "我会一直在门户中跳跃，直到找到回家的路。",
        QUAGMIRE_SALTROCK = "我舔了一个。不得不。",
        QUAGMIRE_SALT = "我所有的食物都需要一撮或两撮。",
        --food--
        QUAGMIRE_FOOD_BURNT = "我觉得很好。",
        QUAGMIRE_FOOD =
        {
        	GENERIC = "也许上面那东西会吃掉它。",
            MISMATCH = "我觉得那只小虫子想要不同的东西。",
            MATCH = "这应该让那东西闭嘴一段时间。",
            MATCH_BUT_SNACK = "这不会让它闭嘴太久。",
        },

        QUAGMIRE_FERN = "我可以从中挑选。",
        QUAGMIRE_FOLIAGE_COOKED = "把这个留给专业人士。",
        QUAGMIRE_COIN1 = "哇，一枚硬币。噗。",
        QUAGMIRE_COIN2 = "我可能可以用这个买到好东西。",
        QUAGMIRE_COIN3 = "我很富有！",
        QUAGMIRE_COIN4 = "我猜那东西喜欢我们给它的东西。",
        QUAGMIRE_GOATMILK = "什么？我们需要牛奶。",
        QUAGMIRE_SYRUP = "嗯。。。",
        QUAGMIRE_SAP_SPOILED = "这太蠢了。",
        QUAGMIRE_SEEDPACKET = "噢……在我种植它们之前，我不知道它们是什么。",

        QUAGMIRE_POT = "这个罐子能装更多的原料。",
        QUAGMIRE_POT_SMALL = "我们开始做饭吧！",
        QUAGMIRE_POT_SYRUP = "我需要让这锅变甜。",
        QUAGMIRE_POT_HANGER = "它挂断了。",
        QUAGMIRE_POT_HANGER_ITEM = "用于悬挂式烹饪。",
        QUAGMIRE_GRILL = "现在我只需要一个后院就可以把它放进去了。",
        QUAGMIRE_GRILL_ITEM = "我得就这件事问别人。",
        QUAGMIRE_GRILL_SMALL = "烧烤！",
        QUAGMIRE_GRILL_SMALL_ITEM = "用于烤小肉。",
        QUAGMIRE_OVEN = "现在我们在做饭。",
        QUAGMIRE_OVEN_ITEM = "我等不及要用了！",
        QUAGMIRE_CASSEROLEDISH = "花俏！",
        QUAGMIRE_CASSEROLEDISH_SMALL = "有点小。",
        QUAGMIRE_PLATE_SILVER = "哦，看看谁现在很漂亮！",
        QUAGMIRE_BOWL_SILVER = "现在我不用用手了。",
--fallback to speech_wilson.lua         QUAGMIRE_CRATE = "Kitchen stuff.",

        QUAGMIRE_MERM_CART1 = "他们有玩具吗？", --sammy's wagon
        QUAGMIRE_MERM_CART2 = "这里面都是好东西。", --pipton's cart
        QUAGMIRE_PARK_ANGEL = "全部。",
        QUAGMIRE_PARK_ANGEL2 = "丑陋。",
        QUAGMIRE_PARK_URN = "火葬是唯一的方式。",
        QUAGMIRE_PARK_OBELISK = "这是一座纪念碑之类的东西。",
        QUAGMIRE_PARK_GATE =
        {
            GENERIC = "甚至不必融化锁。",
            LOCKED = "锁上了。我想我们需要一把钥匙。",
        },
        QUAGMIRE_PARKSPIKE = "看起来很锋利。",
        QUAGMIRE_CRABTRAP = "那会让那些螃蟹看到的。",
        QUAGMIRE_TRADER_MERM = "嘿，迪亚给我买了什么？",
        QUAGMIRE_TRADER_MERM2 = "帽子不错，你也卖吗？",

        QUAGMIRE_GOATMUM = "她的眼睛把我吓了出来。",
        QUAGMIRE_GOATKID = "他什么都吃。",
        QUAGMIRE_PIGEON =
        {
            DEAD = "它死了。",
            GENERIC = "我没有面包屑给你。",
            SLEEPING = "它在小睡。",
        },
        QUAGMIRE_LAMP_POST = "这是城市里的那种灯。",

        QUAGMIRE_BEEFALO = "别紧张，爷爷。",
        QUAGMIRE_SLAUGHTERTOOL = "我不想用这个。",

        QUAGMIRE_SAPLING = "需要很长时间才能长回来。",
        QUAGMIRE_BERRYBUSH = "啊……现在所有的浆果都不见了。",

        QUAGMIRE_ALTAR_STATUE2 = "这附近有很多山羊雕像。",
        QUAGMIRE_ALTAR_QUEEN = "哇，她看起来很漂亮",
        QUAGMIRE_ALTAR_BOLLARD = "这足够好了。",
        QUAGMIRE_ALTAR_IVY = "常春藤到处生长。",

        QUAGMIRE_LAMP_SHORT = "我们几乎和这盏灯一样高。",


        --v2 Winona
        WINONA_CATAPULT =
        {
        	GENERIC = "它会扔大石头。",
        	OFF = "这东西开着吗？",
        	BURNING = "嘿嘿！",
        	BURNT = "嗯，这有点娱乐。",
        },
        WINONA_SPOTLIGHT =
        {
        	GENERIC = "多么巧妙的想法！",
        	OFF = "这东西开着吗？",
        	BURNING = "嘿嘿！",
        	BURNT = "嗯，这有点娱乐。",
        },
        WINONA_BATTERY_LOW =
        {
        	GENERIC = "这是威诺娜的垃圾。",
        	LOWPOWER = "它已经走到了尽头。",
        	OFF = "哦，它坏了",
        	BURNING = "嘿嘿！",
        	BURNT = "嗯，这有点娱乐。",
        },
        WINONA_BATTERY_HIGH =
        {
        	GENERIC = "更多威诺娜的古怪垃圾。",
        	LOWPOWER = "它已经走到了尽头。",
        	OFF = "哦，它坏了。",
        	BURNING = "嘿嘿！",
        	BURNT = "嗯，这有点娱乐。",
        },

        --Wormwood
        COMPOSTWRAP = "太恶心了！",
        ARMOR_BRAMBLE = "我想是艾草做的。",
        TRAP_BRAMBLE = "它的刺非常锋利。",

        BOATFRAGMENT03 = "好吧，就是这样。",
        BOATFRAGMENT04 = "好吧，就是这样。",
        BOATFRAGMENT05 = "好吧，就是这样。",
		BOAT_LEAK = "我应该在我们沉没之前把它修好。",
        MAST = "我们可以爬上去吗？",
        SEASTACK = "这只是一块大而无聊的海岩。",
        FISHINGNET = "我喜欢扔东西来抓其他东西！", --unimplemented
        ANTCHOVIES = "它们尝起来非常咸而且恶心。", --unimplemented
        STEERINGWHEEL = "看看我转得有多快！！",
        ANCHOR = "放下它比把它拉起来有趣多了。",
        BOATPATCH = "修理东西很无聊，但很有必要。",
        DRIFTWOOD_TREE =
        {
            BURNING = "那浮木在燃烧！",
            BURNT = "嗯，那很有趣。",
            CHOPPED = "可能还有值得挖掘的东西。",
            GENERIC = "这棵树看起来非常奇怪。",
        },

        DRIFTWOOD_LOG = "非常适合燃烧。",

        MOON_TREE =
        {
            BURNING = "树在燃烧！",
            BURNT = "我感觉没有我想的那么糟。",
            CHOPPED = "它不会再长了。",
            GENERIC = "多漂亮的树啊！",
        },
		MOON_TREE_BLOSSOM = "它从月亮树上掉下来。",

        MOONBUTTERFLY =
        {
        	GENERIC = "嘿，回来！",
        	HELD = "抓住你了。",
        },
		MOONBUTTERFLYWINGS = "它们是从一只死蝴蝶身上掉下来的，恶心。",
        MOONBUTTERFLY_SAPLING = "只是一棵未被烧毁的小树。",
        ROCK_AVOCADO_FRUIT = "我打赌它成熟后味道会很好。",
        ROCK_AVOCADO_FRUIT_RIPE = "它成熟了！",
        ROCK_AVOCADO_FRUIT_RIPE_COOKED = "它现在真的软得可以吃了。",
        ROCK_AVOCADO_FRUIT_SPROUT = "它有一只小胳膊。",
        ROCK_AVOCADO_BUSH =
        {
        	BARREN = "它不会再有果实了。",
			WITHERED = "噗，外面几乎都不热。",
			GENERIC = "这是某种水果灌木。",
			PICKED = "已经有人拿了水果。",
			DISEASED = "呃，闻起来了！！", --unimplemented
            DISEASING = "我觉得它生病了。", --unimplemented
			BURNING = "是的！",
		},
        DEAD_SEA_BONES = "恶心！如果我是意外踩到它的呢？",
        HOTSPRING =
        {
        	GENERIC = "非常温暖！",
        	BOMBED = "扔炸弹很有趣",
        	GLASS = "我们应该把它砸碎吗？",
			EMPTY = "我只能等待它再次装满。",
        },
        MOONGLASS = "非常锋利。",
        MOONGLASS_CHARGED = "我应该在能量消失之前将其用于科学研究",
        MOONGLASS_ROCK = "那是一大块玻璃！",
        BATHBOMB = "我还是不想洗澡。",
        TRAP_STARFISH =
        {
            GENERIC = "海星通常有这么多牙齿吗？",
            CLOSED = "天哪，这太粗鲁了！",
        },
        DUG_TRAP_STARFISH = "我就知道我不喜欢你。",
        SPIDER_MOON =
        {
        	GENERIC = "我一定要杀了那东西。",
        	SLEEPING = "现在是杀死它的最佳时机。",
        	DEAD = "我们应该烧掉它。只是为了确定。",
        },
        MOONSPIDERDEN = "我希望它燃烧起来。",
		FRUITDRAGON =
		{
			GENERIC = "它们很可爱。",
			RIPE = "嗯……烤龙舌兰。",
			SLEEPING = "晚安，小家伙。",
		},
        PUFFIN =
        {
            GENERIC = "一只鸟！我想知道它是否好吃。",
            HELD = "哈哈，我抓到你了。",
            SLEEPING = "我打赌我现在可以偷偷溜上去。",
        },

		MOONGLASSAXE = "月亮讨厌树木。",
		GLASSCUTTER = "哈哈，这东西可能会把你的胳膊弄下来！",

        ICEBERG =
        {
            GENERIC = "冰太多了。", --unimplemented
            MELTED = "它看起来很融化", --unimplemented
        },
        ICEBERG_MELTED = "它看起来很融化。", --unimplemented

        MINIFLARE = "我等不及点燃它了！",

		MOON_FISSURE =
		{
			GENERIC = "呃，我觉得它在对我耳语。",
			NOLIGHT = "嗯哼，也许我们可以把东西塞进里面。",
		},
        MOON_ALTAR =
        {
            MOON_ALTAR_WIP = "我发誓，差不多完成了。",
            GENERIC = "整装待发感觉好吗？",
        },

        MOON_ALTAR_IDOL = "好吧，让我带你回家。",
        MOON_ALTAR_GLASS = "是的，我当然会把你拖到那边。",
        MOON_ALTAR_SEED = "你想去哪里？",

        MOON_ALTAR_ROCK_IDOL = "内心有东西在呼唤我。",
        MOON_ALTAR_ROCK_GLASS = "里面有东西在呼唤我。",
        MOON_ALTAR_ROCK_SEED = "里面有东西在呼唤我。",

        MOON_ALTAR_CROWN = "你知道，如果你不那么重的话，这会容易得多。",
        MOON_ALTAR_COSMIC = "为什么我觉得我们还没有结束？",

        MOON_ALTAR_ASTRAL = "又在一起了。",
        MOON_ALTAR_ICON = "好的，好的，我们开始吧。",
        MOON_ALTAR_WARD = "你说得对，我真的是帮助你的最佳人选。",

        SEAFARING_PROTOTYPER =
        {
            GENERIC = "乏味的书呆子。",
            BURNT = "嘿嘿，哎呀。",
        },
        BOAT_ITEM = "这是船的一部分。",
        STEERINGWHEEL_ITEM = "没有它就不能航行。",
        ANCHOR_ITEM = "哦，让我们做一个锚。",
        MAST_ITEM = "如果你没有帆\"帆\" 就不能称之为帆船",
        MUTATEDHOUND =
        {
        	DEAD = "很好的解脱。",
        	GENERIC = "恶心！那是什么？！",
        	SLEEPING = "我能看到它在呼吸。",
        },

        MUTATED_PENGUIN =
        {
			DEAD = "呃，它死了。",
			GENERIC = "停下来。",
			SLEEPING = "我不想吵醒它。",
		},
        CARRAT =
        {
        	DEAD = "呃，它死了",
        	GENERIC = "我想烤了它。",
        	HELD = "它一直在蠕动。",
        	SLEEPING = "它在打鼾。",
        },

		BULLKELP_PLANT =
        {
            GENERIC = "我打赌我们可以吃。",
            PICKED = "没什么可以带走的。",
        },
		BULLKELP_ROOT = "哈哈！这东西太棒了。",
        KELPHAT = "恶心，感觉像鼻涕。",
		KELP = "嘿！谁敢让我生吃？",
		KELP_COOKED = "太好了，现在我不用咀嚼了。",
		KELP_DRIED = "还不错。",

		GESTALT = "感觉他们在我脑海里说话！",
        GESTALT_GUARD = "他们确实讨厌那些暗影怪物。",

		COOKIECUTTER = "嘿！你在看什么？！",
		COOKIECUTTERSHELL = "哈，我偷了它的房子。",
		COOKIECUTTERHAT = "符合我多刺的性格。",
		SALTSTACK =
		{
			GENERIC = "呵呵。那是。。。奇怪的。",
			MINED_OUT = "有人已经把盐都弄到手了。",
			GROWING = "嘿，它又长回来了！",
		},
		SALTROCK = "多奇怪的石头啊。",
		SALTBOX = "这会让我的东西暂时不腐烂。",

		TACKLESTATION = "真恶心，它看起来满是虫子。",
		TACKLESKETCH = "谁还会看钓鱼杂志？呃，除了我现在……",

        MALBATROSS = "嗯……好鸟？",
        MALBATROSS_FEATHER = "哈！那东西毕竟只是一根羽毛。",
        MALBATROSS_BEAK = "讨厌。",
        MAST_MALBATROSS_ITEM = "你真的可以用任何东西做一个帆",
        MAST_MALBATROSS = "展开我的翅膀，扬帆远航！",
		MALBATROSS_FEATHERED_WEAVE = "这太费劲了",

        GNARWAIL =
        {
            GENERIC = "天哪，看看那东西的鼻子！",
            BROKENHORN = "没有你的号角，你就不那么坚强了，是吗？",
            FOLLOWER = "是的，没错！你现在为我工作！",
            BROKENHORN_FOLLOWER = "哈！你没有喇叭看起来有点傻",
        },
        GNARWAIL_HORN = "哈哈，酷！",

        WALKINGPLANK = "那么，我们要让谁走呢？",
        OAR = "划船太蠢了。我们为什么不用帆呢？",
		OAR_DRIFTWOOD = "呃，轮到别人划船了吗？",

		OCEANFISHINGROD = "现在是轮盘交易！",
		OCEANFISHINGBOBBER_NONE = "一个浮标可能会提高其准确性。",
        OCEANFISHINGBOBBER_BALL = "鱼会有一个球。",
        OCEANFISHINGBOBBER_OVAL = "这次那些鱼不会让我溜走的！",
		OCEANFISHINGBOBBER_CROW = "我宁愿吃鱼也不吃乌鸦",
		OCEANFISHINGBOBBER_ROBIN = "希望它不会吸引任何红鲱鱼。",
		OCEANFISHINGBOBBER_ROBIN_WINTER = "雪鸟羽毛帮助我保持寒冷。",
		OCEANFISHINGBOBBER_CANARY = "向我的小朋友问好！",
		OCEANFISHINGBOBBER_GOOSE = "你要倒下了，鱼！",
		OCEANFISHINGBOBBER_MALBATROSS = "哪里有羽毛笔，哪里就有办法。",

		OCEANFISHINGLURE_SPINNER_RED = "一些小鱼可能会觉得这很诱人！",
		OCEANFISHINGLURE_SPINNER_GREEN = "一些小鱼可能会觉得这很诱人！",
		OCEANFISHINGLURE_SPINNER_BLUE = "一些小鱼可能会觉得这很诱人！",
		OCEANFISHINGLURE_SPOON_RED = "一些小鱼可能会觉得这很诱人！",
		OCEANFISHINGLURE_SPOON_GREEN = "一些小鱼可能会觉得这很诱人！",
		OCEANFISHINGLURE_SPOON_BLUE = "一些小鱼可能会觉得这很诱人！",
		OCEANFISHINGLURE_HERMIT_RAIN = "浸泡自己可能会帮助我像鱼一样思考……",
		OCEANFISHINGLURE_HERMIT_SNOW = "打中它们的鱼不会下雪！",
		OCEANFISHINGLURE_HERMIT_DROWSY = "我的大脑被一层厚厚的硬科学保护着！",
		OCEANFISHINGLURE_HERMIT_HEAVY = "这感觉有点笨手笨脚。",

		OCEANFISH_SMALL_1 = "只是一条笨小鱼。",
		OCEANFISH_SMALL_2 = "这是什么——？它太小了！",
		OCEANFISH_SMALL_3 = "嘿！我还以为你会成为一条大鱼呢！",
		OCEANFISH_SMALL_4 = "在我看来更像虾。",
		OCEANFISH_SMALL_5 = "奇怪……",
		OCEANFISH_SMALL_6 = "我感觉它会成为很好的火种。",
		OCEANFISH_SMALL_7 = "你额上长了什么东西。",
		OCEANFISH_SMALL_8 = "真可悲……一只火虫同伴被迫在水下生活！",
        OCEANFISH_SMALL_9 = "嘿！朝别人吐口水！",

		OCEANFISH_MEDIUM_1 = "E哦，那东西看起来很恶心！",
		OCEANFISH_MEDIUM_2 = "别那样看着我！",
		OCEANFISH_MEDIUM_3 = "这有什么好好玩的？",
		OCEANFISH_MEDIUM_4 = "哈！我不怕一点儿坏运气。",
		OCEANFISH_MEDIUM_5 = "什么…这…是什么？",
		OCEANFISH_MEDIUM_6 = "对于生活在水里的东西来说，这有点漂亮。",
		OCEANFISH_MEDIUM_7 = "对于生活在水里的东西来说，这有点漂亮。",
		OCEANFISH_MEDIUM_8 = "我感觉有人舔它！",
        OCEANFISH_MEDIUM_9 = "又是一条愚蠢的鱼。",

		PONDFISH = "滑鱼！",
		PONDEEL = "我不喜欢它给我的表情！",

		FISHMEAT = "曾经是鱼，现在是食物。",
        FISHMEAT_COOKED = "烤至完美。",
        FISHMEAT_SMALL = "只不过是一种快速的鱼味小吃。",
        FISHMEAT_SMALL_COOKED = "鱼与火相得益彰。",
		SPOILED_FISH = "恶心。",

		FISH_BOX = "我们刚才……在船上打了个洞吗？",
        POCKET_SCALE = "嘿，现在我可以称我的鱼了……我不在乎。",

		TACKLECONTAINER = "我通常喜欢我的东西处于有组织的混乱状态。",
		SUPERTACKLECONTAINER = "我打赌我可以在里面塞进更多的东西",

		TROPHYSCALE_FISH =
		{
			GENERIC = "谁在乎称量一些哑鱼？",
			HAS_ITEM = "重量： {weight}\n捕获 by: {owner}",
			HAS_ITEM_HEAVY = "重量： {weight}\n捕获 by: {owner}\n它是怎么放进去的？",
			BURNING = "嘿……我不确定这是否管用。",
			BURNT = "很好。",
			OWNER = "重量： {weight}\n捕获 by: {owner}\n噗，这并不难。",
			OWNER_HEAVY = "重量： {weight}\n捕获 by: {owner}\n阅读并哭泣！",
		},

		OCEANFISHABLEFLOTSAM = "只是一大块恶心的东西。",

		CALIFORNIAROLL = "哦，太好了。鱼卷在海藻里。",
		SEAFOODGUMBO = "这是什么？",
		SURFNTURF = "非常适合那些拿不定主意的人。",

        WOBSTER_SHELLER = "真是一个胡思乱想的摇摆者。",
        WOBSTER_DEN = "这是一块有抖动的岩石。",
        WOBSTER_SHELLER_DEAD = "你应该好好做饭。",
        WOBSTER_SHELLER_DEAD_COOKED = "我等不及要吃了你。",

        LOBSTERBISQUE = "我要把这整件东西都吃了！",
        LOBSTERDINNER = "好吃！",

        WOBSTER_MOONGLASS = "味道还是一样的，对吗？对…？",
        MOONGLASS_WOBSTER_DEN = "我们应该试着把它们抽出来。",

		TRIDENT = "是小的三倍！",

		WINCH =
		{
			GENERIC = "它只适用于从海底抓取垃圾。",
			RETRIEVING_ITEM = "快点……",
			HOLDING_ITEM = "我没那么感兴趣。",
		},

        HERMITHOUSE = {
            GENERIC = "真是垃圾场。",
            BUILTUP = "我从来都不需要家，但我想有些人需要。",
        },

        SHELL_CLUSTER = "只是一堆贝壳。",
        --
		SINGINGSHELL_OCTAVE3 =
		{
			GENERIC = "呃，它在发出噪音！",
		},
		SINGINGSHELL_OCTAVE4 =
		{
			GENERIC = "那些东西把我吓坏了。",
		},
		SINGINGSHELL_OCTAVE5 =
		{
			GENERIC = "不用了，谢谢。",
        },

        CHUM = "呃，鱼吃了那些恶心的东西？",

        SUNKENCHEST =
        {
            GENERIC = "真正的宝藏是我们一路上发现的宝藏。",
            LOCKED = "噢，来吧！",
        },

        HERMIT_BUNDLE = " 我很乐意帮助老太太！",
        HERMIT_BUNDLE_SHELLS = "我喜欢叮叮当当的贝壳。",

        RESKIN_TOOL = "哦，是的，我会玩得很开心。",
        MOON_FISSURE_PLUGGED = "哦，所以她就是这样让那些虫子远离的。",


		----------------------- ROT STRINGS GO ABOVE HERE ------------------

		-- Walter
        WOBYBIG =
        {
            "她只是个很容易上当的人",
            "她只是个很容易上当的人",
        },
        WOBYSMALL =
        {
            "她是一只又臭又怪的小狗。我喜欢她！",
            "她是一只又臭又怪的小狗。我喜欢她！",
        },
		WALTERHAT = "好吧，那我不是\"参加\" 女侦察兵，而是 \"撞击\" 女侦察兵。",
		SLINGSHOT = "到处都是窗户的祸根。",
		SLINGSHOTAMMO_ROCK = "需要抛投的子弹。",
		SLINGSHOTAMMO_MARBLE = "需要抛投的子弹。",
		SLINGSHOTAMMO_THULECITE = "需要抛投的子弹。",
        SLINGSHOTAMMO_GOLD = "需要抛投的子弹。",
        SLINGSHOTAMMO_SLOW = "需要抛投的子弹。",
        SLINGSHOTAMMO_FREEZE = "需要抛投的子弹。",
		SLINGSHOTAMMO_POOP = "扫射弹",
        PORTABLETENT = "这是一个好的、结实的帐篷",
        PORTABLETENT_ITEM = "这需要一些调整",

        -- Wigfrid
        BATTLESONG_DURABILITY = "嘿，看，花式火种！",
        BATTLESONG_HEALTHGAIN = "嘿，看，花式火种！",
        BATTLESONG_SANITYGAIN = "嘿，看，花式火种！",
        BATTLESONG_SANITYAURA = "嘿，看，花式火种！",
        BATTLESONG_FIRERESISTANCE = "嘿，看，花式火种！",
        BATTLESONG_INSTANT_TAUNT = "嘿，好吧，我在用这个",
        BATTLESONG_INSTANT_PANIC = "我不在乎无聊的词。",

        -- Webber
        MUTATOR_WARRIOR = "给威尔逊一个，我相信他会尝试的！嘿嘿。",
        MUTATOR_DROPPER = "哇，有腿伸出来了！",
        MUTATOR_HIDER = "给威尔逊一个，我相信他会尝试的！嘿嘿。",
        MUTATOR_SPITTER = "哇，有腿伸出来了！",
        MUTATOR_MOON = "给威尔逊一个，我相信他一定会尝试的！嘿嘿。",
        MUTATOR_HEALER = "哇，有腿伸出来了！",
        SPIDER_WHISTLE = "嗯，我不会把那东西放在我脸附近的任何地方。",
        SPIDERDEN_BEDAZZLER = "他当然有创造力，不是吗？",
        SPIDER_HEALER = "哎呀，真臭！",
        SPIDER_REPELLENT = "它可能不起作用，但至少会发出噪音！",
        SPIDER_HEALER_ITEM = "哇，全是黏糊糊的！",

		-- Wendy
		GHOSTLYELIXIR_SLOWREGEN = "我不相信恐怖女孩做的小瓶子。",
		GHOSTLYELIXIR_FASTREGEN = "我不相信恐怖女孩做的小瓶子。",
		GHOSTLYELIXIR_SHIELD = "我不相信恐怖女孩做的小瓶子。",
		GHOSTLYELIXIR_ATTACK = "我不相信恐怖女孩做的小瓶子。",
		GHOSTLYELIXIR_SPEED = "我不相信恐怖女孩做的小瓶子。",
		GHOSTLYELIXIR_RETALIATION = "我不相信恐怖女孩做的小瓶子。",
		SISTURN =
		{
			GENERIC = "火葬会更有趣。",
			SOME_FLOWERS = "我会为小房子找到更多的花！",
			LOTS_OF_FLOWERS = "我想它有点漂亮……",
		},

        --Wortox
--fallback to speech_wilson.lua         WORTOX_SOUL = "only_used_by_wortox", --only wortox can inspect souls

        PORTABLECOOKPOT_ITEM =
        {
            GENERIC = "只是个笨蛋。",
            DONE = "很好，我们吃吧！",

			COOKING_LONG = "啊，这太费时了！",
			COOKING_SHORT = "加油，做你自己的事！",
			EMPTY = "愚蠢的空罐子。",
        },

        PORTABLEBLENDER_ITEM = "稍微摇晃一下。",
        PORTABLESPICER_ITEM =
        {
            GENERIC = "所有这些工作都是值得的。",
            DONE = "所有这些工作都是为了一点点香料？",
        },
        SPICEPACK = "I我相信沃利不会介意我借这个。",
        SPICE_GARLIC = "膀臭。",
        SPICE_SUGAR = "就像喝糖果一样。",
        SPICE_CHILI = "我喜欢它让我的嘴着火的方式。",
        SPICE_SALT = "人们说我很咸。",
        MONSTERTARTARE = "恶心！",
        FRESHFRUITCREPES = "哦~啦啦~",
        FROGFISHBOWL = "哇，那是一吨青蛙。",
        POTATOTORNADO = "哇，我不知道土豆是那种形状的！",
        DRAGONCHILISALAD = "我等不及要吃了。",
        GLOWBERRYMOUSSE = "这肯定会进我的嘴里。",
        VOLTGOATJELLY = "嘿，军阀！我能吃这个吗？",
        NIGHTMAREPIE = "我肯定他不会介意我偷一小口。",
        BONESOUP = "我真的会吸一口！",
        MASHEDPOTATOES = "我喜欢土豆泥。",
        POTATOSOUFFLE = "我的东西从来不会这样出来！",
        MOQUECA = "看起来太好了！",
        GAZPACHO = "我更喜欢热菜。",
        ASPARAGUSSOUP = "闻起来像味道。",
        VEGSTINGER = "你能用芹菜当吸管吗？",
        BANANAPOP = "这是燃烧的反面。",
        CEVICHE = "还是黏糊糊的",
        SALSA = "嘿，这太棒了！",
        PEPPERPOPPER = "我的嘴着火了",

        TURNIP = "哈哈，我讨厌萝卜。",
        TURNIP_COOKED = "拿着，萝卜",
        TURNIP_SEEDS = "这只是一堆种子。",

        GARLIC = "只是几瓣大蒜。",
        GARLIC_COOKED = "火让它更好。",
        GARLIC_SEEDS = "这只是一堆种子。",

        ONION = "它是如此的球状。",
        ONION_COOKED = "烘焙。我最喜欢的烹饪方法。",
        ONION_SEEDS = "这只是一堆种子。",

        POTATO = "我们在那恶心的垃圾堆里种的",
        POTATO_COOKED = "烹饪就是把东西粘在火里。",
        POTATO_SEEDS = "这只是一堆种子。",

        TOMATO = "切这些东西很痛苦。",
        TOMATO_COOKED = "只需要在火上烤几分钟。",
        TOMATO_SEEDS = "这只是一堆种子。",

        ASPARAGUS = "一种蔬菜。",
        ASPARAGUS_COOKED = "你现在不那么嚼了吧？",
        ASPARAGUS_SEEDS = "这可以做一些食物。",

        PEPPER = "很好。这些是辣的。",
        PEPPER_COOKED = "蔬菜的第一条规则：火让它更好。",
        PEPPER_SEEDS = "这只是一堆种子。",

        WEREITEM_BEAVER = "看起来就像你，伍迪先生！",
        WEREITEM_GOOSE = "伍迪先生，你没事吧？",
        WEREITEM_MOOSE = "你能做一个没有肉的玩具吗？",

        MERMHAT = "哎呀，谁会想要那样的脸？",
        MERMTHRONE =
        {
            GENERIC = "大坐垫看起来非常诱人。",
            BURNT = "我做了吗？很难跟踪。",
        },
        MERMTHRONE_CONSTRUCTION =
        {
            GENERIC = "这些东西是干什么用的？",
            BURNT = "哈哈哈——！呃，我是说，哦，不……",
        },
        MERMHOUSE_CRAFTED =
        {
            GENERIC = "这是鱼人的家！",
            BURNT = "我感觉有点不舒服。",
        },

        MERMWATCHTOWER_REGULAR = "他们似乎很高兴找到了国王。",
        MERMWATCHTOWER_NOKING = "没有皇家卫队的皇家卫队。",
        MERMKING = "你应该是重要的还是什么的？",
        MERMGUARD = "我不知道它在往哪个方向看。",
        MERM_PRINCE = "是什么让那个家伙如此特别？",

        SQUID = "没有什么可以替代好的火炬。",

		GHOSTFLOWER = "太好了。又是一朵诡异的花。",
        SMALLGHOST = "你在看什么，小古怪？",

        CRABKING =
        {
            GENERIC = "他看起来不太高兴……",
            INERT = "我想它可能需要一些闪闪发光的东西。",
        },
		CRABKING_CLAW = "别用爪子抓我的船！",

		MESSAGEBOTTLE = "嘿！这是一瓶紧急火种！",
		MESSAGEBOTTLEEMPTY = "只是一个无聊的旧瓶子。",

        MEATRACK_HERMIT =
        {
            DONE = "嘿，女士，你的肉干准备好了！",
            DRYING = "来吧，肉，已经烘干了！",
            DRYINGINRAIN = "忘了雨！擦干！",
            GENERIC = "也许我会在离开之前留下一些肉……",
            BURNT = "架子干了。",
            DONE_NOTMEAT = "准备好了！",
            DRYING_NOTMEAT = "烘干这些东西需要多长时间？",
            DRYINGINRAIN_NOTMEAT = "忘了雨！擦干！",
        },
        BEEBOX_HERMIT =
        {
            READY = "如果我偷一点蜂蜜，她不会生气的，对吧？",
            FULLHONEY = "如果我偷一点蜂蜜，她不会生气的，对吧？",
            GENERIC = "哇，她的蜜蜂和她一样友好。",
            NOHONEY = "这里没什么可看的。",
            SOMEHONEY = "耐心。",
            BURNT = "把你熏了！",
        },

        HERMITCRAB = "嘿，我有点喜欢她。",

        HERMIT_PEARL = "别担心，跟我在一起很安全！",
        HERMIT_CRACKED_PEARL = "哦天……",

        -- DSEAS
        WATERPLANT = "只是一朵又大又哑的花。",
        WATERPLANT_BOMB = "好吧，很抱歉我叫你哑巴！",
        WATERPLANT_BABY = "现在它很小，但会变大。",
        WATERPLANT_PLANTER = "我真的想种植更多这些东西吗？",

        SHARK = "嗯……好鱼吗？",

        MASTUPGRADE_LAMP_ITEM = "我有很多好主意。",
        MASTUPGRADE_LIGHTNINGROD_ITEM = "这就是闪电的方向。",

        WATERPUMP = "嘿……里面是鱼吗？",

        BARNACLE = "呃，它是从水里来的。",
        BARNACLE_COOKED = "火让它变得更好。",

        BARNACLEPITA = "食藤壶者",
        BARNACLESUSHI = "我仍然可以看到藤壶藏在下面。",
        BARNACLINGUINE = "我不介意。",
        BARNACLESTUFFEDFISHHEAD = "你知道，我觉得我毕竟没那么饿。",

        LEAFLOAF = "呃，它应该是绿色的吗？",
        LEAFYMEATBURGER = "这个汉堡对其他人来说味道奇怪吗？",
        LEAFYMEATSOUFFLE = "什么样的怪物会把甜点和蔬菜结合起来？",
        MEATYSALAD = "等等……这些叶子是什么？",

        -- GROTTO

		MOLEBAT = "哈哈，真恶心！我刚看到它通过鼻子吃东西！",
        MOLEBATHILL = "呃，它是在自己的鼻子里睡觉吗？",

        BATNOSE = "呃喔。。。",
        BATNOSE_COOKED = "这应该会让它更好吗？",
        BATNOSEHAT = "那是真的帽子吗？",

        MUSHGNOME = "哎呀，到处都是孢子！",

        SPORE_MOON = "好的，我明白了！我会离开的！",

        MOON_CAP = "多奇怪的蘑菇。",
        MOON_CAP_COOKED = "再一次，火让它变得更好。",

        MUSHTREE_MOON = "这棵蘑菇树显然比其他树都奇怪。",

        LIGHTFLIER = "真奇怪，随身携带一件会让我的口袋更轻！",

        GROTTO_POOL_BIG = "啊，这整个地方又潮湿又恶心！我讨厌它！",
        GROTTO_POOL_SMALL = "啊，这整个地方又潮湿又恶心！我讨厌它！",

        DUSTMOTH = "他们一整天都在打扫？多么无聊的生活。",

        DUSTMOTHDEN = "不是我试过什么",

        ARCHIVE_LOCKBOX = "太好了。我们打开了神秘的东西，得到了另一个神秘的东西。",
       ARCHIVE_CENTIPEDE = "金属虫很生气。",
        ARCHIVE_CENTIPEDE_HUSK = "是一大堆垃圾。",

        ARCHIVE_COOKPOT =
        {
            COOKING_LONG = "这需要一段时间。",
            COOKING_SHORT = "快做好了！",
            DONE = "嗯！可以吃了！",
            EMPTY = "让我们把这只旧陶器掸掉，好吗？",
            BURNT = "锅烧熟了。",
        },

        ARCHIVE_MOON_STATUE = "哈！沃尔夫冈可以独自搬大石头！",
        ARCHIVE_RUNE_STATUE =
        {
            LINE_1 = "这是一尊漂亮的雕像，但上面满是涂鸦。",
            LINE_2 = "非常花哨。",
            LINE_3 = "这是一尊漂亮的雕像，但上面满是涂鸦。",
            LINE_4 = "非常花哨。",
            LINE_5 = "这是一尊漂亮的雕像，但上面满是涂鸦。",
        },

        ARCHIVE_RESONATOR = {
            GENERIC = "指路！",
            IDLE = "我想没什么可找的了。",
        },

        ARCHIVE_RESONATOR_ITEM = "它自己嗡嗡作响。",

        ARCHIVE_LOCKBOX_DISPENCER = {
          POWEROFF = "看起来好像坏了。",
          GENERIC =  "呃，我觉得一个谜团要来了……",
        },

        ARCHIVE_SECURITY_DESK = {
            POWEROFF = "不管是什么，它都不工作。",
            GENERIC = "是的，这看起来并不可疑。",
        },

        ARCHIVE_SECURITY_PULSE = "嘿！回来！",

        ARCHIVE_SWITCH = {
            VALID = "我肯定没有人会介意我借一颗宝石。",
            GEMS = "这里少了一些东西。",
        },

        ARCHIVE_PORTAL = {
            POWEROFF = "另一个门户？你不认为…？",
            GENERIC = "应该知道这不会那么容易。",
        },

        WALL_STONE_2 = "呃，我想没关系。",
        WALL_RUINS_2 = "他们会怒气冲冲，喘着粗气！",

        REFINED_DUST = "太好了。我该怎么处理这些东西？",
        DUSTMERINGUE = "是的，我觉得我没那么饿。",

        SHROOMCAKE = "蛋糕的蛋糕，递给我。",

        NIGHTMAREGROWTH = "那可能不是……太好了……",

        TURFCRAFTINGSTATION = "我想我需要换个环境。",

        MOON_ALTAR_LINK = "噢，来吧！这是什么？！",

        -- FARMING
        COMPOSTINGBIN =
        {
            GENERIC = "呃，我们为什么有这个？",
            WET = "都湿透了。",
            DRY = "应该这么干吗？",
            BALANCED = "我想它看起来还好吧？为了一堆烂土？",
            BURNT = "很好",
        },
        COMPOST = "不，我很好。",
        SOIL_AMENDER =
		{
			GENERIC = "恶心",
			STALE = "是的，那里发生了很多事情。",
			SPOILED = "希望它能像臭一样好用。",
		},

		SOIL_AMENDER_FERMENTED = "是的，植物真的喜欢这种东西吗？",

        WATERINGCAN =
        {
            GENERIC = "呃，谁把水放在这里的？！",
            EMPTY = "更像是这样。",
        },
        PREMIUMWATERINGCAN =
        {
            GENERIC = "哈，看起来很蠢",
            EMPTY = "令人安心地干燥。",
        },

		FARM_PLOW = "是的，打那块地！",
		FARM_PLOW_ITEM = "我想我最好找个地方来种些农作物。",
		FARM_HOE = "农业是一项繁重的工作……",
		GOLDEN_FARM_HOE = "花俏的锄头适合播种！",
		NUTRIENTSGOGGLESHAT = "哇，我一直想要污垢视觉……从来没有人说过。",
		PLANTREGISTRYHAT = "不，我不想让我的脑袋里满是植物书呆子的事实！",

        FARM_SOIL_DEBRIS = "离开这里！",

		FIRENETTLES = "你说这是杂草是什么意思？对我来说似乎是一种进步！",
		FORGETMELOTS = "还有一些哑花。",
		SWEETTEA = "它有什么了不起的？它只是叶汁。",
		TILLWEED = "愚蠢的杂草。",
		TILLWEEDSALVE = "我想杂草对某些东西有好处。",
        WEED_IVY = "都是刺。",
        IVY_SNARE = "离开这里，你这个蠢货",

		TROPHYSCALE_OVERSIZEDVEGGIES =
		{
			GENERIC = "我过去常在集市上看到这些！",
			HAS_ITEM = "重量： {weight}\n在日期： {day}\n令人兴奋。",
			HAS_ITEM_HEAVY = "重量： {weight}\n在日期：{day}\n啊哈！ 确实非常强大！",
            HAS_ITEM_LIGHT = "嘿，这东西坏了吗？它甚至没有显示重量！",
			BURNING = "嗯，做什么了？",
			BURNT = "哦，已经结束了吗？",
        },

        CARROT_OVERSIZED = "一个大的老胡萝卜",
        CORN_OVERSIZED = "让我们把这东西烧掉！",
        PUMPKIN_OVERSIZED = "我可以把最大的蜡烛插进去！太棒了！",
        EGGPLANT_OVERSIZED = "我该怎么处理这些茄子？！",
        DURIAN_OVERSIZED = "当然，这是长得很好的……",
        POMEGRANATE_OVERSIZED = "我打赌里面看起来超级恶心！",
        DRAGONFRUIT_OVERSIZED = "我希望这是一个喷火的龙果。",
        WATERMELON_OVERSIZED = "啊，水太多了！",
        TOMATO_OVERSIZED = "呃，现在切起来会更难……",
        POTATO_OVERSIZED = "让我们烤这个东西吧！",
        ASPARAGUS_OVERSIZED = "我有一种感觉，这将是很长一段时间的芦笋剩菜……",
        ONION_OVERSIZED = "我得弄清楚我该怎么处理这些洋葱……",
        GARLIC_OVERSIZED = "我敢打赌，如果我把整个东西都吃了，我的呼吸一定会很好闻。",
        PEPPER_OVERSIZED = "这是很多辣的东西！",

        VEGGIE_OVERSIZED_ROTTEN = "一大堆臭糊糊。",

		FARM_PLANT =
		{
			GENERIC = "愚蠢的植物。",
			SEED = "呃，这要花很长时间。",
			GROWING = "已经快了！",
			FULL = "花了足够长的时间。",
			ROTTEN = "是的……我不吃这个",
			FULL_OVERSIZED = "这看起来有点不自然。",
			ROTTEN_OVERSIZED = "一大堆臭糊糊。",
			FULL_WEED = "等等，那应该是什么蔬菜？",

			BURNING = "呵呵~",
		},

        FRUITFLY = "滚开，你们这些蠢虫子！",
        LORDFRUITFLY = "你以为你能闯进来把花园搞得一团糟吗？那是我的工作！",
        FRIENDLYFRUITFLY = "嘿，这个真的很有用！",
        FRUITFLYFRUIT = "现在是我下命令了！对果蝇，但仍然如此。",

	    SEEDPOUCH = "我已经厌倦了把松散的种子放在口袋里。",

		-- Crow Carnival
		CARNIVAL_HOST = "我喜欢他。",
		CARNIVAL_CROWKID = "我想知道他们一直躲在哪里",
		CARNIVAL_GAMETOKEN = "这是什么，鸟钱？",
		CARNIVAL_PRIZETICKET =
		{
			GENERIC = "嘿，引火",
			GENERIC_SMALLSTACK = "也许现在我们可以去领奖了！",
			GENERIC_LARGESTACK = "幸好我们有额外的胳膊来拿这些票！",
		},

		CARNIVALGAME_FEEDCHICKS_NEST = "通往无处可去的小门。",
		CARNIVALGAME_FEEDCHICKS_STATION =
		{
			GENERIC = "我以前从未真正去过狂欢节。我要给它点什么吗？",
			PLAYING = "嘿，这看起来真的很有趣。",
		},
		CARNIVALGAME_FEEDCHICKS_KIT = "噢，来吧，我得自己设置吗？",
		CARNIVALGAME_FEEDCHICKS_FOOD = "我不需要先把它们咀嚼掉，是吗？",

		CARNIVALGAME_MEMORY_KIT = "噢，拜托，我得自己设置吗？",
		CARNIVALGAME_MEMORY_STATION =
		{
			GENERIC = "我以前从未真正去过狂欢节。我要给它点什么吗？",
			PLAYING = "脑力劳动太多了，这一个会被点燃。",
		},
		CARNIVALGAME_MEMORY_CARD =
		{
			GENERIC = "没有特别之处的小门。",
			PLAYING = "是的，就是那个！",
		},

		CARNIVALGAME_HERDING_KIT = "哦，来吧，我得自己安排一下吗？",
		CARNIVALGAME_HERDING_STATION =
		{
			GENERIC = "我以前从未真正去过狂欢节。我要给它点什么吗？",
			PLAYING = "跑鸡蛋，跑！",
		},
		CARNIVALGAME_HERDING_CHICK = "嘿！回来！",

		CARNIVAL_PRIZEBOOTH_KIT = "呃，还有一件事要做。",
		CARNIVAL_PRIZEBOOTH =
		{
			GENERIC = "噢，奖品！",
		},

		CARNIVALCANNON_KIT = "嘿嘿，这会很有趣。",
		CARNIVALCANNON =
		{
			GENERIC = "让我们活跃一点吧！",
			COOLDOWN = "我只希望它有一个更猛烈的爆炸。",
		},

		CARNIVAL_PLAZA_KIT = "将成为鸟类的好树。",
		CARNIVAL_PLAZA =
		{
			GENERIC = "嗯，它周围的地面看起来有点空……",
			LEVEL_2 = "我觉得那些奇怪的鸟喜欢这些装饰品。",
			LEVEL_3 = "好吧，我厌倦了装饰。继续吧。",
		},

		CARNIVALDECOR_EGGRIDE_KIT = "其他人能帮我组装吗？",
		CARNIVALDECOR_EGGRIDE = "我可以看几个小时。",

		CARNIVALDECOR_LAMP_KIT = "其他人能帮我组装吗？",
		CARNIVALDECOR_LAMP = "它能发光。",
		CARNIVALDECOR_PLANT_KIT = "其他人能帮我组装吗？",
		CARNIVALDECOR_PLANT = "我猜这棵树从来没有长过。",

		CARNIVALDECOR_FIGURE =
		{
			RARE = "哇，这不常见！",
			UNCOMMON = "如果我收集了足够多的这些，我就能生一堆很好的篝火。",
			GENERIC = "啊，太可爱了！",
		},
		CARNIVALDECOR_FIGURE_KIT = "盒子里有什么？",

        CARNIVAL_BALL = "快想想，麦克斯韦！", --unimplemented
		CARNIVAL_SEEDPACKET = "啊，鸟食。",
		CARNIVALFOOD_CORNTEA = "它一直卡在我的牙齿里。",

        CARNIVAL_VEST_A = "火红的，我真喜欢！",
        CARNIVAL_VEST_B = "就像戴上了我自己的遮阳树。",
        CARNIVAL_VEST_C = "微风。",

        -- YOTB
        YOTB_SEWINGMACHINE = "我从来都不喜欢缝纫。",
        YOTB_SEWINGMACHINE_ITEM = "多好的一堆火柴啊！",
        YOTB_STAGE = "你觉得你能评判我吗？！",
        YOTB_POST =  "这是一个获得beefalo的好地方。",
        YOTB_STAGE_ITEM = "啊，太多了……",
        YOTB_POST_ITEM =  "我最好把它设置好。",

        YOTB_PATTERN_FRAGMENT_1 = "看来我必须把其中的一些放在一起，才能做出有价值的东西。",
        YOTB_PATTERN_FRAGMENT_2 = "看来我必须把其中的一些放在一起，才能做出有价值的东西。",
        YOTB_PATTERN_FRAGMENT_3 = "看来我必须把其中的一些放在一起，才能做出有价值的东西。",

        YOTB_BEEFALO_DOLL_WAR = {
            GENERIC = "你和伯尼会相处得很好！",
            YOTB = "嘿，法官！看一看！",
        },
        YOTB_BEEFALO_DOLL_DOLL = {
            GENERIC = "你和伯尼会相处得很好！",
            YOTB = "嘿，法官！看一看！",
        },
        YOTB_BEEFALO_DOLL_FESTIVE = {
            GENERIC = "你和伯尼会相处得很好！",
            YOTB = "嘿，法官！看一看！",
        },
        YOTB_BEEFALO_DOLL_NATURE = {
            GENERIC = "你和伯尼会相处得很好！",
            YOTB = "嘿，法官！看一看！",
        },
        YOTB_BEEFALO_DOLL_ROBOT = {
            GENERIC = "你和伯尼会相处得很好！",
            YOTB = "嘿，法官！看一看！",
        },
        YOTB_BEEFALO_DOLL_ICE = {
            GENERIC = "你和伯尼会相处得很好！",
            YOTB = "嘿，法官！看一看！",
        },
        YOTB_BEEFALO_DOLL_FORMAL = {
            GENERIC = "你和伯尼会相处得很好！",
            YOTB = "嘿，法官！看一看！",
        },
        YOTB_BEEFALO_DOLL_VICTORIAN = {
            GENERIC = "你和伯尼会相处得很好！",
            YOTB = "嘿，法官！看一看！",
        },
        YOTB_BEEFALO_DOLL_BEAST = {
            GENERIC = "你和伯尼会相处得很好！",
            YOTB = "嘿，法官！看一看！",
        },

        WAR_BLUEPRINT = "哦，看起来很危险！",
        DOLL_BLUEPRINT = "啊，我的比法罗会很可怕很可爱",
        FESTIVE_BLUEPRINT = "在我称之为节日之前，它需要更多的 \"鞭炮\"。",
        ROBOT_BLUEPRINT = "呃，这真的是一种缝纫模式吗？",
        NATURE_BLUEPRINT = "一旦花干了，它们就会成为很好的引火物。",
        FORMAL_BLUEPRINT = "呃，看起来很闷，很得体。",
        VICTORIAN_BLUEPRINT = "哈！这看起来会很搞笑！",
        ICE_BLUEPRINT = "比法罗难道没有毛茸茸的冬衣吗？",
        BEAST_BLUEPRINT = "我的比法罗已经是一只幸运的野兽了。他会成为我的朋友！",

        BEEF_BELL = "哇，交朋友很容易！",
		
		-- YOT Catcoon
		KITCOONDEN = 
		{
			GENERIC = "你必须非常小才能放进去。",
            BURNT = "不！！！",
			PLAYING_HIDEANDSEEK = "现在他们会在哪里……",
			PLAYING_HIDEANDSEEK_TIME_ALMOST_UP = "剩下的时间不多了！他们在哪里？！",
		},

		KITCOONDEN_KIT = "整个工具包和堆。",

		TICOON = 
		{
			GENERIC = "他看起来好像知道自己在做什么！",
			ABANDONED = "我相信我能自己找到它们。",
			SUCCESS = "嘿，他找到了！",
			LOST_TRACK = "其他人先找到了。",
			NEARBY = "看起来附近有东西。",
			TRACKING = "我应该跟随他的领导。",
			TRACKING_NOT_MINE = "他在为别人带路。",
			NOTHING_TO_TRACK = "看起来没有什么东西要找了",
			TARGET_TOO_FAR_AWAY = "它们可能太远了，他无法嗅出。",
		},
		
		YOT_CATCOONSHRINE =
        {
            GENERIC = "制作什么……",
            EMPTY = "也许它想要一根羽毛来玩……",
            BURNT = "闻起来像烧焦的毛皮",
        },

		KITCOON_FOREST = "你不是最可爱的小猫吗？",
		KITCOON_SAVANNA = "你不是最可爱的小猫吗？",
		KITCOON_MARSH = "我必须收集更多……",
		KITCOON_DECIDUOUS = "你不是最可爱的小猫吗？",
		KITCOON_GRASS = "你不是最可爱的小猫吗？",
		KITCOON_ROCKY = "我必须收集更多……",
		KITCOON_DESERT = "我必须收集更多……",
		KITCOON_MOON = "我必须收集更多……",
		KITCOON_YOT = "我必须收集更多……",

        -- Moon Storm
        ALTERGUARDIAN_PHASE1 = {
            GENERIC = "呃，我就知道我们不该搞那些愚蠢的科学垃圾。",
            DEAD = "嘿，拿着月亮，或者别的什么！",
        },
        ALTERGUARDIAN_PHASE2 = {
            GENERIC = "你觉得自己很坚强吗？！",
            DEAD = "那一次肯定能拿到。",
        },
        ALTERGUARDIAN_PHASE2SPIKE = "啊，把这些东西从我的路上拿开！",
        ALTERGUARDIAN_PHASE3 = "很漂亮，但燃烧时会更漂亮！",
        ALTERGUARDIAN_PHASE3TRAP = "嘿，这只是在玩脏东西！",
        ALTERGUARDIAN_PHASE3DEADORB = "嘿，老家伙？你可能不想那么近……",
        ALTERGUARDIAN_PHASE3DEAD = "我猜终于完成了。",

        ALTERGUARDIANHAT = "这让我的大脑内部非常嘈杂……",
        ALTERGUARDIANHATSHARD = "把那东西拆开真是太难了。",

        MOONSTORM_GLASS = {
            GENERIC = "嘿，我能看到我的倒影！",
            INFUSED = "里面好像有点火。"
        },

        MOONSTORM_STATIC = "别被击中，老兄。",
        MOONSTORM_STATIC_ITEM = "它噼啪作响，几乎像火一样。",
        MOONSTORM_SPARK = "我要碰它。",

        BIRD_MUTANT = "它看起来想咬我一口。",
        BIRD_MUTANT_SPITTER = "哦，是吗？！两个人可以玩那个游戏……托伊！",

        WAGSTAFF_NPC = "呃，老年人似乎总是需要帮助。",
        ALTERGUARDIAN_CONTAINED = "那台奇怪的机器是什么？",

        WAGSTAFF_TOOL_1 = "我感觉这是属于那个老家伙的。",
        WAGSTAFF_TOOL_2 = "呃，那个老家伙就不能自己拿吗？",
        WAGSTAFF_TOOL_3 = "是的，那看起来像是一个WhadayaCallit！还是一个Whatchamahoosit……",
        WAGSTAFF_TOOL_4 = "我找到了一个工具！也许就是他要找的那个？",
        WAGSTAFF_TOOL_5 = "看起来像是一些奇怪的科学垃圾。也许这就是老家伙在寻找的东西？",

        MOONSTORM_GOGGLESHAT = "至少我会在没有人能看到我的暴风雨中穿着它。",

        MOON_DEVICE = {
            GENERIC = "太好了！那它有什么用？",
            CONSTRUCTION1 = "嗯？为什么那个老家伙不能自己建造这个东西？",
            CONSTRUCTION2 = "我想我可以把它剪掉，然后处理完，但现在我有点好奇……",
        },

		-- Wanda
        POCKETWATCH_HEAL = {
			GENERIC = "为什么要担心过去或未来？最终都会付之一炬。",
			RECHARGING = "现在没什么用。",
		},

        POCKETWATCH_REVIVE = {
			GENERIC = "为什么要担心过去或未来？最终都会付之一炬。",
			RECHARGING = "现在没什么用。",
		},

        POCKETWATCH_WARP = {
			GENERIC = "为什么要担心过去或未来？最终都会付之一炬。",
			RECHARGING = "现在没什么用。",
		},

        POCKETWATCH_RECALL = {
			GENERIC = "为什么要担心过去或未来？最终都会付之一炬。",
			RECHARGING = "现在没什么用。",
--fallback to speech_wilson.lua 			UNMARKED = "only_used_by_wanda",
--fallback to speech_wilson.lua 			MARKED_SAMESHARD = "only_used_by_wanda",
--fallback to speech_wilson.lua 			MARKED_DIFFERENTSHARD = "only_used_by_wanda",
		},

        POCKETWATCH_PORTAL = {
			GENERIC = "为什么要担心过去或未来？最终都会付之一炬。",
			RECHARGING = "现在没什么用。",
--fallback to speech_wilson.lua 			UNMARKED = "only_used_by_wanda unmarked",
--fallback to speech_wilson.lua 			MARKED_SAMESHARD = "only_used_by_wanda same shard",
--fallback to speech_wilson.lua 			MARKED_DIFFERENTSHARD = "only_used_by_wanda other shard",
		},

        POCKETWATCH_WEAPON = {
			GENERIC = "看起来很危险。我想试试！",
--fallback to speech_wilson.lua 			DEPLETED = "only_used_by_wanda",
		},

        POCKETWATCH_PARTS = "一些奇怪的时钟垃圾。",
        POCKETWATCH_DISMANTLER = "一堆小工具。",

        POCKETWATCH_PORTAL_ENTRANCE = 
		{
			GENERIC = "我真的要跳进我看到的任何旧门户吗？是的！",
			DIFFERENTSHARD = "我真的要跳进我看到的任何旧门户吗？是的！",
		},
        POCKETWATCH_PORTAL_EXIT = "看着其他人倒地很有趣。",

        -- Waterlog
        WATERTREE_PILLAR = "树越大。",
        OCEANTREE = "我觉得这些树有点迷路了。",
        OCEANTREENUT = "呃，还是湿的。",
        WATERTREE_ROOT = "是大树根。",

        OCEANTREE_PILLAR = "嘿，这会阻止太阳燃烧东西！",
        
        OCEANVINE = "哦，看，一根很长的灯芯！",
        FIG = "看起来像老年人的水果。",
        FIG_COOKED = "像往常一样，火让它变得更好。",

        SPIDER_WATER = "离开水，我可以割断你！",
        MUTATOR_WATER = "给威尔逊一个，我相信他一定会尝试的！嘿嘿。",
        OCEANVINE_COCOON = "看看它就挂在那里！",
        OCEANVINE_COCOON_BURNT = "火是一种快速的重新装饰器。",

        GRASSGATOR = "如果他不打扰我，我就不会打扰他。",

        TREEGROWTHSOLUTION = "呃，树胶。。。",

        FIGATONI = "我不会拒绝一盘意大利面。",
        FIGKABAB = "当我吃完食物后，我可以烧了棍子！",
        KOALEFIG_TRUNK = "甜而有弹性。",
        FROGNEWTON = "所有这些无花果几乎掩盖了青蛙的味道。",
		
		 -- The Terrorarium
        TERRARIUM = {
            GENERIC = "小树是怎么进去的？",
            CRIMSON = "我对这件事有种不好的感觉……",
            ENABLED = "我在彩虹的另一边吗？！",
			WAITING_FOR_DARK = "在等什么？",
			COOLDOWN = "之后需要冷却。",
			SPAWN_DISABLED = "我现在不应该再被窥探的眼睛打扰了。",
        },

        TERRARIUMCHEST = 
		{
			GENERIC = "看起来像正常的胸部，没有闪光。",
			BURNT = "被烧成尘土。",
			SHIMMER = "这似乎有点不合适……",
		},

		EYEMASKHAT = "丑陋。",

        EYEOFTERROR = "来吧！我把你砍倒！",
        EYEOFTERROR_MINI = "我开始有了自我意识。",
        EYEOFTERROR_MINI_GROUNDED = "我想它就要孵化了……",

        FROZENBANANADAIQUIRI = "哦，真冷。",
        BUNNYSTEW = "它从里到外变暖。",
        MILKYWHITES = "不，谢谢。",

        CRITTER_EYEOFTERROR = "嘿，今天看起来不错！",

        SHIELDOFTERROR ="至少它上面没有眼屎。",
        TWINOFTERROR1 = "机器人！机器人……",
        TWINOFTERROR2 = "机器人！机器人……",
		
		-- Year of the Catcoon
        CATTOY_MOUSE = "有轮子的老鼠。。",
        KITCOON_NAMETAG = "我应该想出一些名字！",

		KITCOONDECOR1 =
        {
            GENERIC = "这不是一只真正的鸟，但工具包不知道这一点。",
            BURNT = "燃烧",
        },
		KITCOONDECOR2 =
        {
            GENERIC = "那些装备很容易分心。我又在干什么？",
            BURNT = "它燃烧起来了。",
        },

		KITCOONDECOR1_KIT = "看起来需要一些装配。",
		KITCOONDECOR2_KIT = "看起来建造起来并不难。",
    
        -- WX78
        WX78MODULE_MAXHEALTH = "嘿，机器人，你什么时候安装喷火器？",
        WX78MODULE_MAXSANITY1 = "嘿，机器人，你什么时候安装喷火器？",
        WX78MODULE_MAXSANITY = "嘿，机器人，你什么时候安装喷火器？",
        WX78MODULE_MOVESPEED = "嘿，机器人，你什么时候安装喷火器？",
        WX78MODULE_MOVESPEED2 = "嘿，机器人，你什么时候安装喷火器？",
        WX78MODULE_HEAT = "嘿，机器人，你什么时候安装喷火器？",
        WX78MODULE_NIGHTVISION = "嘿，机器人，你什么时候安装喷火器？",
        WX78MODULE_COLD = "嘿，机器人，你什么时候安装喷火器？",
        WX78MODULE_TASER = "嘿，机器人，你什么时候安装喷火器？",
        WX78MODULE_LIGHT = "嘿，机器人，你什么时候安装喷火器？",
        WX78MODULE_MAXHUNGER1 = "嘿，机器人，你什么时候安装喷火器？",
        WX78MODULE_MAXHUNGER = "嘿，机器人，你什么时候安装喷火器？",
        WX78MODULE_MUSIC = "嘿，机器人，你什么时候安装喷火器？",
        WX78MODULE_BEE = "嘿，机器人，你什么时候安装喷火器？",
        WX78MODULE_MAXHEALTH2 = "嘿，机器人，你什么时候安装喷火器？",

        WX78_SCANNER =
        {
            GENERIC ="我无法决定它是可爱还是令人毛骨悚然。",
            HUNTING = "我无法决定它是可爱还是令人毛骨悚然。",
            SCANNING = "我无法决定它是可爱还是令人毛骨悚然。",
        },

        WX78_SCANNER_ITEM = "呵呵。。。如果我在上面画胡子，你觉得WX会生气吗？",
        WX78_SCANNER_SUCCEEDED = "你还在等什么，拍拍脑袋？",

        WX78_MODULEREMOVER = "让我试试。。。别动，WX！",

        SCANDATA = "嗯哼？",

        -- Pirates
        BOAT_ROTATOR = "呵呵，让我们看看我们能以多快的速度旋转而不生病！",
        BOAT_ROTATOR_KIT = "菲林，我会把愚蠢的方向舵放在愚蠢的船上。",
        BOAT_BUMPER_KELP = "哎呀，太粘了！",
        BOAT_BUMPER_KELP_KIT = "我想建造一些保险杠比下沉要好。",
        BOAT_BUMPER_SHELL = "嗯，没有什么比贝壳更坚固的了。",
        BOAT_BUMPER_SHELL_KIT = "我想建造一些保险杠比下沉要好。",
        BOAT_CANNON = {
            GENERIC = "未加载？炮弹？",
            AMMOLOADED = "航海唯一有趣的部分是开火。",
        },
        BOAT_CANNON_KIT = "如果我建造它，我就可以开火。",
        CANNONBALL_ROCK_ITEM = "好的，但我仍然认为火球会更好。",

        OCEAN_TRAWLER = {
            GENERIC = "它为我完成了所有工作！",
            LOWERED = "我打赌它现在捕到了很多鱼。",
            CAUGHT = "一个不错的收获",
            ESCAPED = "你不应该逃脱！",
            FIXED = "应该这样做。",
        },
        OCEAN_TRAWLER_KIT = "也许我可以贿赂其中一个孩子为我建造它。",

        BOAT_MAGNET =
        {
            GENERIC = "太好了，现在我有一个大的哑磁铁。",
            ACTIVATED = "好的，我想它工作正常。",
        },
        BOAT_MAGNET_KIT = "威尔逊！我怎么能把这些垃圾放在一起？！",

        BOAT_MAGNET_BEACON =
        {
            GENERIC = "这将吸引附近的强磁铁。",
            ACTIVATED = "我想这意味着它正在工作。",
        },
        DOCK_KIT = "我需要为我的船建造码头的一切。",
        DOCK_WOODPOSTS_ITEM = "啊哈！我以为丢了什么东西。",

        MONKEYHUT = "啊，从来没有人让我进入他们的树堡。",
        POWDER_MONKEY = "嘿！别碰我的东西！",
        PRIME_MATE = "我不喜欢他挥动桨的方式。",
        LIGHTCRAB = "里面好像有点火在燃烧。",
        CUTLESS = "至少可以做很好的木柴。",
        CURSED_MONKEY_TOKEN = "上面是真的牙齿吗？哈哈，酷。",
        OAR_MONKEY = "嘿，也许划船毕竟很有趣！",
        BANANABUSH = "那灌木丛是香蕉！",
        DUG_BANANABUSH = "那灌木丛是香蕉！",
        PALMCONETREE = "一种松树，用于棕榈树。",
        PALMCONE_SEED = "树的起源。",
        PALMCONE_SAPLING = "它有一天会成为一棵树的远大梦想。",
        PALMCONE_SCALE = "如果树上有脚趾甲，我想它们会是这样的。",
        MONKEYTAIL = "它太柔软了。而且很模糊。",
        DUG_MONKEYTAIL = "它太柔软了。而且很模糊。",

        MONKEY_MEDIUMHAT = "我拿走了那只笨猴子的帽子。",
        MONKEY_SMALLHAT = "有点痒……",
        POLLY_ROGERSHAT = "现在很时尚。",
        POLLY_ROGERS = "想给我带点东西吗？",

        MONKEYISLAND_PORTAL = "嗯，我应该担心吗？",
        MONKEYISLAND_PORTAL_DEBRIS = "到处都是这些金属垃圾是怎么回事？",
        MONKEYQUEEN = "掌握看起来很容易。",
        MONKEYPILLAR = "社区真正的支柱。",
        PIRATE_FLAG_POLE = "喂！",

        BLACKFLAG = "看起来已经烧焦了。",
        PIRATE_STASH = "宝贝！嘿，我很擅长这个。",
        STASH_MAP = "哈！那些笨猴子留下了一张通往他们宝藏的地图！",


        BANANAJUICE = "我……喜欢。",

        FENCE_ROTATOR = "Enguard! Re-post!",

        CHARLIE_STAGE_POST = "这是一个设置！感觉太……舞台化了。",
        CHARLIE_LECTURN = "有人在演戏吗？",

        CHARLIE_HECKLER = "他们来这里只是为了刺激戏剧。",

        PLAYBILL_THE_DOLL = "\"作者C.W.\"",
        STATUEHARP_HEDGESPAWNER = "花长了，但没有头。",
        HEDGEHOUND = "这是圈套！",
        HEDGEHOUND_BUSH = "这是灌木。",

        MASK_DOLLHAT = "这是一个娃娃面具。",
        MASK_DOLLBROKENHAT = "这是一个破娃娃面具。",
        MASK_DOLLREPAIREDHAT = "它曾经是一个娃娃面具。",
        MASK_BLACKSMITHHAT = "这是一个铁匠面具。",
        MASK_MIRRORHAT = "这是一个面具，但看起来像一面镜子。",
        MASK_QUEENHAT = "这是女王面具。",
        MASK_KINGHAT = "这是国王面具。",
        MASK_TREEHAT = "这是树面具",
        MASK_FOOLHAT = "这是傻瓜的面具。",

        COSTUME_DOLL_BODY = "这是一件娃娃服装。",
        COSTUME_QUEEN_BODY = "这是女王的服装。",
        COSTUME_KING_BODY = "这是国王的服装。",
        COSTUME_BLACKSMITH_BODY = "这是一件铁匠服装。",
        COSTUME_MIRROR_BODY = "这是一件服装。",
        COSTUME_TREE_BODY = "这是一件树装。",
        COSTUME_FOOL_BODY = "这是傻瓜的服装。",

        STAGEUSHER =
        {
            STANDING = "把手放在自己身上，好吗？",
            SITTING = "这里有点奇怪，但我无法确定。",
        },
        SEWING_MANNEQUIN =
        {
            GENERIC = "盛装打扮，无处可去。",
            BURNT = "全部烧毁，无处可去。",
        },
    },

    DESCRIBE_GENERIC = "我不知道那是什么！",
    DESCRIBE_TOODARK = "我需要更多的光！",
	DESCRIBE_SMOLDERING = "快着火了。",

    DESCRIBE_PLANTHAPPY = "看起来。。。好的",
    DESCRIBE_PLANTVERYSTRESSED = "有些事让我很难过。",
    DESCRIBE_PLANTSTRESSED = "我猜有不止一件事困扰着它。",
    DESCRIBE_PLANTSTRESSORKILLJOYS = "我真的要再给花园除草吗？",
    DESCRIBE_PLANTSTRESSORFAMILY = "发生了什么？别告诉我这很孤独？",
    DESCRIBE_PLANTSTRESSOROVERCROWDING = "这些植物可能需要更多的私人空间。",
    DESCRIBE_PLANTSTRESSORSEASON = "我猜它不喜欢这种天气。",
    DESCRIBE_PLANTSTRESSORMOISTURE = "看起来又香又脆！",
    DESCRIBE_PLANTSTRESSORNUTRIENTS = "威克伯顿女士总是喋喋不休地谈论土壤中的营养物质。也许它需要这样。",
    DESCRIBE_PLANTSTRESSORHAPPINESS = "你想从我这里得到什么？！",

    EAT_FOOD =
    {
        TALLBIRDEGG_CRACKED = "啊~松脆。",
		WINTERSFEASTFUEL = "还有人闻到营火的味道吗？",
    },
}
