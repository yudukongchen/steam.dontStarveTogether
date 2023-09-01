local Ingredient = GLOBAL.Ingredient
local TECH = GLOBAL.TECH
local RECIPETABS = GLOBAL.RECIPETABS

-- NOTE Change images and items when you got them 

-- NOTE Custom Crafting Tab
local nanashi_mumei_tab = AddRecipeTab("Nanashi Mumei", 99, "images/inventoryimages/nanashi_mumei_tab.xml", "nanashi_mumei_tab.tex", "nanashi_mumei")

-- NOTE SAMPLE RECIPETABS
if TUNING.NANASHI_MUMEI_DAGGER_RECIPE == 0 then
	AddRecipe("nanashi_mumei_dagger",
    {
        Ingredient("flint", 3),
        Ingredient("goldnugget", 2),
        Ingredient("twigs", 2) ,
    },
	nanashi_mumei_tab, TECH.NONE, nil, nil, nil, 1, "nanashi_mumei", "images/inventoryimages/nanashi_mumei_dagger.xml", 
    "nanashi_mumei_dagger.tex")
end  

if TUNING.NANASHI_MUMEI_LANTERN_RECIPE == 0 then
	AddRecipe("nanashi_mumei_lantern",
    {
        Ingredient("lightbulb", 2),
        Ingredient("goldnugget", 3),
        Ingredient("rope", 2) ,
    },
	nanashi_mumei_tab, TECH.NONE, nil, nil, nil, 1, "nanashi_mumei", "images/inventoryimages/nanashi_mumei_lantern.xml", 
    "nanashi_mumei_lantern.tex")
end
AddRecipe("nanashi_mumei_friend_builder",
	{
		Ingredient("papyrus", 1),
		Ingredient("nightmarefuel", 4),
	},
	nanashi_mumei_tab, TECH.NONE, nil, nil, true, nil, "nanashi_mumei", "images/inventoryimages/nanashi_mumei_friend.xml"
	,  "nanashi_mumei_friend.tex")