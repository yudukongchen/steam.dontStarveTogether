GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})
PrefabFiles = {
	"gembeans",
	"gem_crystal_clusters",
}

Assets = {	
}

local map_icons= {
    "blue", "green","orange","purple","red","yellow","opalprecious",
}

TUNING.GEMCRYSTAL_COST = GetModConfigData("gemcost")
TUNING.GEMCRYSTAL_time = GetModConfigData("growtime")*480
local locale_code = LOC.GetLocaleCode()
local L = locale_code ~= "zh" and locale_code ~= "zhr"

local zhongwen = L and 
{
	blue = "Blue ",green = "Green ",orange = "Orange ",purple = "Purple ",
	red = "Red ",yellow = "Yellow ",opalprecious = "Opal "
}
or 
{
	blue = "蓝",green = "绿",orange = "橙",purple = "紫",
	red = "红",yellow = "黄",opalprecious = "彩"
}
for k,v in pairs(map_icons) do
	table.insert(Assets, Asset( "IMAGE", "images/minimap/gem_crystal_cluster_"..v..".tex" )) 
    table.insert(Assets, Asset( "ATLAS", "images/minimap/gem_crystal_cluster_"..v..".xml" ))
	AddMinimapAtlas("images/minimap/gem_crystal_cluster_"..v..'.xml')

	if L  then
		STRINGS.NAMES[string.upper("gembean_"..v)]= zhongwen[v].."Crystal Seed"
		STRINGS.RECIPE_DESC[string.upper("gembean_"..v)] = "Precious and Special"
		STRINGS.CHARACTERS.GENERIC.DESCRIBE[string.upper("gembean_"..v)] = "Precious and Special"
	else
		STRINGS.NAMES[string.upper("gembean_"..v)]= zhongwen[v].."色水晶籽"
		STRINGS.RECIPE_DESC[string.upper("gembean_"..v)] = "是很贵重的东西！"
		STRINGS.CHARACTERS.GENERIC.DESCRIBE[string.upper("gembean_"..v)] = "是很贵重的东西！"
	end
	if L  then
		STRINGS.NAMES[string.upper("gem_crystal_cluster_"..v)]= zhongwen[v].."Gem Crystal Cluster"
		STRINGS.CHARACTERS.GENERIC.DESCRIBE[string.upper("gem_crystal_cluster_"..v)] = "So Beautiful!"
	else
		STRINGS.NAMES[string.upper("gem_crystal_cluster_"..v)]= zhongwen[v].."色水晶簇"
		STRINGS.CHARACTERS.GENERIC.DESCRIBE[string.upper("gem_crystal_cluster_"..v)] = "真是美丽呢！"
	end

	AddRecipe("gembean_"..v,
	{Ingredient("ice", 40),Ingredient(v.."gem", TUNING.GEMCRYSTAL_COST),Ingredient("moonglass", 10)},
	RECIPETABS.REFINE, TECH.CELESTIAL_THREE,
	nil, nil, true, nil, nil,
	"images/inventoryimages/gembean_"..v..".xml")
end