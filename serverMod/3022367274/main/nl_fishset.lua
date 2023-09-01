setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})
local FISH_DEFS = require("prefabs/oceanfishdef").fish
local SCHOOL_WEIGHTS = require("prefabs/oceanfishdef").school

local SCHOOL_SIZE = {
	TINY = 		{min=1,max=3},
	SMALL = 	{min=2,max=5},
	MEDIUM = 	{min=4,max=6},
	LARGE = 	{min=6,max=10},
}

local SCHOOL_AREA = {
	TINY = 		2,
	SMALL = 	3,
	MEDIUM = 	6,
	LARGE = 	10,
}

local WANDER_DIST = {
	SHORT = 	{min=5,max=15},
	MEDIUM = 	{min=15,max=30},
	LONG = 		{min=20,max=40},
}

local ARRIVE_DIST = {
	CLOSE = 	3,
	MEDIUM = 	8,
	FAR = 		12,
}

local WANDER_DELAY = {
	SHORT = 	{min=0,max=10},
	MEDIUM = 	{min=10,max=30},
	LONG = 		{min=30,max=60},
}

local SEG = 30
local DAY = SEG*16

local SCHOOL_WORLD_TIME = {
	SHORT = 	{min=SEG*8,max=SEG*16},
	MEDIUM = 	{min=DAY,max=DAY*2},
	LONG = 		{min=DAY*2,max=DAY*4},
}

local LOOT = {
	TINY = 			{ "fishmeat_small" },
	SMALL = 		{ "fishmeat_small" },
	SMALL_COOKED = 	{ "fishmeat_small_cooked" },
	MEDIUM = 		{ "fishmeat" },
	LARGE = 		{ "fishmeat" },
	HUGE = 			{ "fishmeat" },
    CORN =			{ "corn" },
    POPCORN =		{ "corn_cooked" },
    ICE =			{ "fishmeat", "ice", "ice" },
    PLANTMEAT =		{ "plantmeat" },
	BONE = 			{ "boneshard", "nightmarefuel"},
}

local PERISH = {
	TINY = 		"fishmeat_small",
	SMALL = 	"fishmeat_small",
	MEDIUM = 	"fishmeat",
	LARGE = 	"fishmeat",
	HUGE = 		"fishmeat",
    CORN =      "corn",
    POPCORN =   "corn_cooked",
	PLANTMEAT = "spoiled_food",
	BONE = "boneshard",
}

local COOKING_PRODUCT = {
	TINY = 		"fishmeat_small_cooked",
	SMALL = 	"fishmeat_small_cooked",
	MEDIUM = 	"fishmeat_cooked",
	LARGE = 	"fishmeat_cooked",
	HUGE = 		"fishmeat_cooked",
    CORN =      "corn_cooked",
	PLANTMEAT = "plantmeat_cooked",
}

local DIET = {
	OMNI = { caneat = { FOODGROUP.OMNI } },--, preferseating = { FOODGROUP.OMNI } },
	VEGGIE = { caneat = { FOODGROUP.VEGETARIAN } },
	MEAT = { caneat = { FOODTYPE.MEAT } },
	WOOD = { caneat = { FOODTYPE.WOOD } },
}

COOKER_INGREDIENT_SMALL = { meat = .5, fish = .5 }
COOKER_INGREDIENT_MEDIUM = { meat = 1, fish = 1 }
COOKER_INGREDIENT_MEDIUM_ICE = { meat = 1, fish = 1, frozen = 1 }

EDIBLE_VALUES_SMALL_MEAT = {health = TUNING.HEALING_TINY, hunger = TUNING.CALORIES_SMALL, sanity = 0, foodtype = FOODTYPE.MEAT}
EDIBLE_VALUES_MEDIUM_MEAT = {health = TUNING.HEALING_MEDSMALL, hunger = TUNING.CALORIES_MED, sanity = 0, foodtype = FOODTYPE.MEAT}
EDIBLE_VALUES_SMALL_VEGGIE = {health = TUNING.HEALING_SMALL, hunger = TUNING.CALORIES_SMALL, sanity = 0, foodtype = FOODTYPE.VEGGIE}
EDIBLE_VALUES_MEDIUM_VEGGIE = {health = TUNING.HEALING_SMALL, hunger = TUNING.CALORIES_MED, sanity = 0, foodtype = FOODTYPE.VEGGIE}
EDIBLE_VALUES_PLANTMEAT = {health = 0, hunger = TUNING.CALORIES_SMALL, sanity = -TUNING.SANITY_SMALL, foodtype = FOODTYPE.MEAT}

-- how long the player has to set the hook before it escapes
local SET_HOOK_TIME_SHORT = { base = 1, var = 0.5 }
local SET_HOOK_TIME_MEDIUM = { base = 2, var = 0.5 }

local BREACH_FX_SMALL = { "ocean_splash_small1", "ocean_splash_small2"}
local BREACH_FX_MEDIUM = { "ocean_splash_med1", "ocean_splash_med2"}

local SHADOW_SMALL = {1, .75}
local SHADOW_MEDIUM = {1.5, 0.75}

local SCHOOL_VERY_COMMON		= 4
local SCHOOL_COMMON				= 2
local SCHOOL_UNCOMMON			= 1
local SCHOOL_RARE				= 0.25

FISH_DEFS['xxx_kujiao']={
	prefab = "xxx_kujiao",
	bank = "oceanfish_medium",
	build = "xxx_kujiao",
	weight_min = 154.32,
	weight_max = 214.97,

	walkspeed = 1.2,
	runspeed = 3.0,
	stamina =
	{
		drain_rate = 0.05,
		recover_rate = 0.1,
		struggle_times	= {low = 2, r_low = 1, high = 6, r_high = 1},
		tired_times		= {low = 3, r_low = 1, high = 2, r_high = 1},
		tiredout_angles = {has_tention = 80, low_tention = 120},
	},

	schoolmin = SCHOOL_SIZE.MEDIUM.min,
	schoolmax = SCHOOL_SIZE.MEDIUM.max,
	schoolrange = SCHOOL_AREA.SMALL,
	schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
	schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

	herdwandermin = WANDER_DIST.MEDIUM.min,
	herdwandermax = WANDER_DIST.MEDIUM.max,
	herdarrivedist = ARRIVE_DIST.MEDIUM,
	herdwanderdelaymin = WANDER_DELAY.SHORT.min,
	herdwanderdelaymax = WANDER_DELAY.SHORT.max,

	set_hook_time = SET_HOOK_TIME_MEDIUM,
	breach_fx = BREACH_FX_MEDIUM,
	loot = LOOT.MEDIUM,
	cooking_product = COOKING_PRODUCT.MEDIUM,
	perish_product = PERISH.MEDIUM,
	fishtype = "meat",

	lures = TUNING.OCEANFISH_LURE_PREFERENCE.OMNI,
	diet = DIET.OMNI,
	cooker_ingredient_value = COOKER_INGREDIENT_MEDIUM,
	edible_values = EDIBLE_VALUES_MEDIUM_MEAT,

	dynamic_shadow = SHADOW_MEDIUM,
}

SCHOOL_WEIGHTS[SEASONS.SPRING][GROUND.OCEAN_COASTAL]['xxx_kujiao'] = SCHOOL_VERY_COMMON
SCHOOL_WEIGHTS[SEASONS.SUMMER][GROUND.OCEAN_COASTAL]['xxx_kujiao'] = SCHOOL_VERY_COMMON
SCHOOL_WEIGHTS[SEASONS.AUTUMN][GROUND.OCEAN_COASTAL]['xxx_kujiao'] = SCHOOL_VERY_COMMON
SCHOOL_WEIGHTS[SEASONS.WINTER][GROUND.OCEAN_COASTAL]['xxx_kujiao'] = SCHOOL_VERY_COMMON

SCHOOL_WEIGHTS[SEASONS.SPRING][GROUND.OCEAN_SWELL]['xxx_kujiao'] = SCHOOL_VERY_COMMON
SCHOOL_WEIGHTS[SEASONS.SUMMER][GROUND.OCEAN_SWELL]['xxx_kujiao'] = SCHOOL_VERY_COMMON
SCHOOL_WEIGHTS[SEASONS.AUTUMN][GROUND.OCEAN_SWELL]['xxx_kujiao'] = SCHOOL_VERY_COMMON
SCHOOL_WEIGHTS[SEASONS.WINTER][GROUND.OCEAN_SWELL]['xxx_kujiao'] = SCHOOL_VERY_COMMON

FISH_DEFS['skeleton_fish']={
	prefab = "skeleton_fish",
	bank = "oceanfish_small",
	build = "skeleton_fish",
	weight_min = 154.32,
	weight_max = 214.97,

	walkspeed = 1.2,
	runspeed = 3.0,
	stamina =
	{
		drain_rate = 0.05,
		recover_rate = 0.1,
		struggle_times	= {low = 2, r_low = 1, high = 6, r_high = 1},
		tired_times		= {low = 3, r_low = 1, high = 2, r_high = 1},
		tiredout_angles = {has_tention = 80, low_tention = 120},
	},

	schoolmin = SCHOOL_SIZE.MEDIUM.min,
	schoolmax = SCHOOL_SIZE.MEDIUM.max,
	schoolrange = SCHOOL_AREA.SMALL,
	schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
	schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

	herdwandermin = WANDER_DIST.MEDIUM.min,
	herdwandermax = WANDER_DIST.MEDIUM.max,
	herdarrivedist = ARRIVE_DIST.MEDIUM,
	herdwanderdelaymin = WANDER_DELAY.SHORT.min,
	herdwanderdelaymax = WANDER_DELAY.SHORT.max,

	set_hook_time = SET_HOOK_TIME_MEDIUM,
	breach_fx = BREACH_FX_MEDIUM,
	loot = LOOT.BONE,
	cooking_product = COOKING_PRODUCT.SMALL,
	perish_product = PERISH.BONE,
	perish_time = TUNING.PERISH_ONE_DAY * 60,
	canteat = true,

	lures = TUNING.OCEANFISH_LURE_PREFERENCE.SMALL_OMNI,
	diet = DIET.WOOD,
	cooker_ingredient_value = COOKER_INGREDIENT_SMALL,
	edible_values = EDIBLE_VALUES_SMALL_MEAT,

	dynamic_shadow = SHADOW_SMALL,
}

SCHOOL_WEIGHTS[SEASONS.SPRING][GROUND.OCEAN_ROUGH]['skeleton_fish'] = SCHOOL_VERY_COMMON
SCHOOL_WEIGHTS[SEASONS.SUMMER][GROUND.OCEAN_ROUGH]['skeleton_fish'] = SCHOOL_VERY_COMMON
SCHOOL_WEIGHTS[SEASONS.AUTUMN][GROUND.OCEAN_ROUGH]['skeleton_fish'] = SCHOOL_VERY_COMMON
SCHOOL_WEIGHTS[SEASONS.WINTER][GROUND.OCEAN_ROUGH]['skeleton_fish'] = SCHOOL_VERY_COMMON

SCHOOL_WEIGHTS[SEASONS.SPRING][GROUND.OCEAN_COASTAL]['skeleton_fish'] = SCHOOL_VERY_COMMON
SCHOOL_WEIGHTS[SEASONS.SUMMER][GROUND.OCEAN_COASTAL]['skeleton_fish'] = SCHOOL_VERY_COMMON
SCHOOL_WEIGHTS[SEASONS.AUTUMN][GROUND.OCEAN_COASTAL]['skeleton_fish'] = SCHOOL_VERY_COMMON
SCHOOL_WEIGHTS[SEASONS.WINTER][GROUND.OCEAN_COASTAL]['skeleton_fish'] = SCHOOL_VERY_COMMON

SCHOOL_WEIGHTS[SEASONS.SPRING][GROUND.OCEAN_SWELL]['skeleton_fish'] = SCHOOL_VERY_COMMON
SCHOOL_WEIGHTS[SEASONS.SUMMER][GROUND.OCEAN_SWELL]['skeleton_fish'] = SCHOOL_VERY_COMMON
SCHOOL_WEIGHTS[SEASONS.AUTUMN][GROUND.OCEAN_SWELL]['skeleton_fish'] = SCHOOL_VERY_COMMON
SCHOOL_WEIGHTS[SEASONS.WINTER][GROUND.OCEAN_SWELL]['skeleton_fish'] = SCHOOL_VERY_COMMON

SCHOOL_WEIGHTS[SEASONS.SPRING][GROUND.OCEAN_ROUGH]['skeleton_fish'] = SCHOOL_VERY_COMMON
SCHOOL_WEIGHTS[SEASONS.SUMMER][GROUND.OCEAN_ROUGH]['skeleton_fish'] = SCHOOL_VERY_COMMON
SCHOOL_WEIGHTS[SEASONS.AUTUMN][GROUND.OCEAN_ROUGH]['skeleton_fish'] = SCHOOL_VERY_COMMON
SCHOOL_WEIGHTS[SEASONS.WINTER][GROUND.OCEAN_ROUGH]['skeleton_fish'] = SCHOOL_VERY_COMMON

FISH_DEFS['armor_shrimp']={
	prefab = "armor_shrimp",
	bank = "oceanfish_small",
	build = "armor_shrimp",
	weight_min = 154.32,
	weight_max = 214.97,

	walkspeed = 1.2,
	runspeed = 3.0,
	stamina =
	{
		drain_rate = 0.05,
		recover_rate = 0.1,
		struggle_times	= {low = 2, r_low = 1, high = 6, r_high = 1},
		tired_times		= {low = 3, r_low = 1, high = 2, r_high = 1},
		tiredout_angles = {has_tention = 80, low_tention = 120},
	},

	schoolmin = SCHOOL_SIZE.MEDIUM.min,
	schoolmax = SCHOOL_SIZE.MEDIUM.max,
	schoolrange = SCHOOL_AREA.SMALL,
	schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
	schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

	herdwandermin = WANDER_DIST.MEDIUM.min,
	herdwandermax = WANDER_DIST.MEDIUM.max,
	herdarrivedist = ARRIVE_DIST.MEDIUM,
	herdwanderdelaymin = WANDER_DELAY.SHORT.min,
	herdwanderdelaymax = WANDER_DELAY.SHORT.max,

	set_hook_time = SET_HOOK_TIME_MEDIUM,
	breach_fx = BREACH_FX_MEDIUM,
	loot = LOOT.SMALL,
	cooking_product = COOKING_PRODUCT.SMALL,
	perish_product = PERISH.SMALL,
	fishtype = "meat",

	lures = TUNING.OCEANFISH_LURE_PREFERENCE.SMALL_OMNI,
	diet = DIET.OMNI,
	cooker_ingredient_value = COOKER_INGREDIENT_SMALL,
	edible_values = EDIBLE_VALUES_SMALL_MEAT,

	dynamic_shadow = SHADOW_SMALL,
}

SCHOOL_WEIGHTS[SEASONS.SPRING][GROUND.OCEAN_ROUGH]['armor_shrimp'] = SCHOOL_VERY_COMMON
SCHOOL_WEIGHTS[SEASONS.SUMMER][GROUND.OCEAN_ROUGH]['armor_shrimp'] = SCHOOL_VERY_COMMON
SCHOOL_WEIGHTS[SEASONS.AUTUMN][GROUND.OCEAN_ROUGH]['armor_shrimp'] = SCHOOL_VERY_COMMON
SCHOOL_WEIGHTS[SEASONS.WINTER][GROUND.OCEAN_ROUGH]['armor_shrimp'] = SCHOOL_VERY_COMMON

SCHOOL_WEIGHTS[SEASONS.SPRING][GROUND.OCEAN_COASTAL]['armor_shrimp'] = SCHOOL_VERY_COMMON
SCHOOL_WEIGHTS[SEASONS.SUMMER][GROUND.OCEAN_COASTAL]['armor_shrimp'] = SCHOOL_VERY_COMMON
SCHOOL_WEIGHTS[SEASONS.AUTUMN][GROUND.OCEAN_COASTAL]['armor_shrimp'] = SCHOOL_VERY_COMMON
SCHOOL_WEIGHTS[SEASONS.WINTER][GROUND.OCEAN_COASTAL]['armor_shrimp'] = SCHOOL_VERY_COMMON

SCHOOL_WEIGHTS[SEASONS.SPRING][GROUND.OCEAN_SWELL]['armor_shrimp'] = SCHOOL_VERY_COMMON
SCHOOL_WEIGHTS[SEASONS.SUMMER][GROUND.OCEAN_SWELL]['armor_shrimp'] = SCHOOL_VERY_COMMON
SCHOOL_WEIGHTS[SEASONS.AUTUMN][GROUND.OCEAN_SWELL]['armor_shrimp'] = SCHOOL_VERY_COMMON
SCHOOL_WEIGHTS[SEASONS.WINTER][GROUND.OCEAN_SWELL]['armor_shrimp'] = SCHOOL_VERY_COMMON

SCHOOL_WEIGHTS[SEASONS.SPRING][GROUND.OCEAN_ROUGH]['armor_shrimp'] = SCHOOL_VERY_COMMON
SCHOOL_WEIGHTS[SEASONS.SUMMER][GROUND.OCEAN_ROUGH]['armor_shrimp'] = SCHOOL_VERY_COMMON
SCHOOL_WEIGHTS[SEASONS.AUTUMN][GROUND.OCEAN_ROUGH]['armor_shrimp'] = SCHOOL_VERY_COMMON
SCHOOL_WEIGHTS[SEASONS.WINTER][GROUND.OCEAN_ROUGH]['armor_shrimp'] = SCHOOL_VERY_COMMON


STRINGS.NAMES.XXX_KUJIAO_INV = "窟鲛"
STRINGS.CHARACTERS.GENERIC.DESCRIBE["XXX_KUJIAO"] = "一条鱼"

STRINGS.NAMES.SKELETON_FISH_INV = "骷髅鱼"
STRINGS.CHARACTERS.GENERIC.DESCRIBE["SKELETON_FISH"] = "一条鱼"

STRINGS.NAMES.ARMOR_SHRIMP_INV = "赤盔虾"
STRINGS.CHARACTERS.GENERIC.DESCRIBE["ARMOR_SHRIMP"] = "一条虾"