
local TechTree = require("techtree")
table.insert(TechTree.AVAILABLE_TECH, "TZ_EVIL_TEACHER")
for k,v in pairs(TUNING.PROTOTYPER_TREES) do
    v.TZ_EVIL_TEACHER = 0
end
TUNING.PROTOTYPER_TREES.TZ_EVIL_TEACHER_ONE = TechTree.Create({TZ_EVIL_TEACHER = 2})
TUNING.PROTOTYPER_TREES.TZ_EVIL_TEACHER_TWO = TechTree.Create({TZ_EVIL_TEACHER = 4})
TUNING.PROTOTYPER_TREES.TZ_EVIL_TEACHER_THREE = TechTree.Create({TZ_EVIL_TEACHER = 6})
STRINGS.ACTIONS.OPEN_CRAFTING.TZ_EVIL_TEACHER = "使用"
STRINGS.ACTIONS.OPEN_CRAFTING.TZ_EVIL_TEACHER_SUPER = "使用"
STRINGS.UI.CRAFTING_STATION_FILTERS.TZ_EVIL_TEACHER = "邪心教义"
STRINGS.UI.CRAFTING_FILTERS.TZ_EVIL_TEACHER = "邪心教义"
STRINGS.UI.CRAFTING.NEEDSTZ_EVIL_TEACHER_ONE = STRINGS.NAMES.TZ_EVIL_TEACHER..STRINGS.ACTIONS.OPEN_CRAFTING.TZ_EVIL_TEACHER
STRINGS.UI.CRAFTING.NEEDSTZ_EVIL_TEACHER_TWO = STRINGS.NAMES.TZ_EVIL_TEACHER..STRINGS.ACTIONS.OPEN_CRAFTING.TZ_EVIL_TEACHER
STRINGS.UI.CRAFTING.NEEDSTZ_EVIL_TEACHER_THREE = STRINGS.NAMES.TZ_EVIL_TEACHER_SUPER..STRINGS.ACTIONS.OPEN_CRAFTING.TZ_EVIL_TEACHER
TECH.NONE.TZ_EVIL_TEACHER_ONE = 0
TECH.TZ_EVIL_TEACHER_ONE = {TZ_EVIL_TEACHER = 2}
TECH.TZ_EVIL_TEACHER_TWO = {TZ_EVIL_TEACHER = 4}
TECH.TZ_EVIL_TEACHER_THREE = {TZ_EVIL_TEACHER = 6}
AddPrototyperDef("tz_evil_teacher", {
	icon_atlas = "images/hud/evil_doctrine.xml",
	icon_image = "evil_doctrine.tex",
	is_crafting_station = true,
	action_str = "TZ_EVIL_TEACHER",
	filter_text = STRINGS.UI.CRAFTING_STATION_FILTERS.TZ_EVIL_TEACHER
})
AddPrototyperDef("tz_evil_teacher_super", {
	icon_atlas = "images/hud/evil_doctrine.xml",
	icon_image = "evil_doctrine.tex",
	is_crafting_station = true,
	action_str = "TZ_EVIL_TEACHER",
	filter_text = STRINGS.UI.CRAFTING_STATION_FILTERS.TZ_EVIL_TEACHER
})

AddPrototyperDef("tz_swordcemetery", {
	icon_atlas = CRAFTING_ICONS_ATLAS, 
	icon_image = "station_crafting_table.tex",	
	is_crafting_station = true,									
	filter_text = STRINGS.UI.CRAFTING_STATION_FILTERS.ANCIENT
})
AddPrototyperDef("tz_truthbasketball", {
	icon_atlas = CRAFTING_ICONS_ATLAS, 
	is_crafting_station = true,
	icon_image = "station_crafting_table.tex",								
	filter_text = STRINGS.UI.CRAFTING_STATION_FILTERS.ANCIENT
})
AddSimPostInit(function()
	for i, v in pairs(AllRecipes) do
		if v.level.TZ_EVIL_TEACHER == nil then
			v.level.TZ_EVIL_TEACHER = 0
		end
	end
end)
