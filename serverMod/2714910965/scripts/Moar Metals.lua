local _G = GLOBAL
local string = _G.STRINGS
local name = string.NAMES
local charDesc = string.CHARACTERS
local recipeDesc = string.CHARACTERS
local STRINGS = GLOBAL.STRINGS

name.ORE_IRON = "铁矿石"
name.ROCK_IRON = "锈迹斑斑的巨石"
name.AXE_IRON = "铁斧"   
name.ARMOR_IRON = "铁质胸甲"
name.PICKAXE_IRON = "铁镐"
name.HELMET_IRON = "铁质头盔"
name.SHOVEL_IRON = "铁铲"
name.HAMMER_IRON = "铁锤"
name.SPEAR_IRON = "铁质长矛"
name.PLATE_IRON = "铁板"											
name.ORE_COBALT = "钴矿石"			
name.ROCK_COBALT = "蓝色巨石"		
name.AXE_COBALT = "钴斧"			
name.ARMOR_COBALT = "钴质胸板"	
name.PICKAXE_COBALT = "钴镐"	
name.HELMET_COBALT = "钴质头盔"	
name.SHOVEL_COBALT = "钴铲"	
name.HAMMER_COBALT = "钴锤"		
name.SPEAR_COBALT = "钴质长矛"			
name.PLATE_COBALT = "钴板"		

STRINGS.RECIPE_DESC.AXE_IRON = "铁质斧,21伤害,144耐久"  
STRINGS.RECIPE_DESC.ARMOR_IRON = "铁质胸板,84%减伤,1080护甲值"
STRINGS.RECIPE_DESC.PICKAXE_IRON = "铁质镐,21伤害,144耐久"
STRINGS.RECIPE_DESC.HELMET_IRON = "铁质头盔,48%减伤,540护甲值,35%防水"
STRINGS.RECIPE_DESC.SHOVEL_IRON = "铁质铲,21伤害,144耐久"
STRINGS.RECIPE_DESC.HAMMER_IRON = "铁质锤,21伤害,144耐久"
STRINGS.RECIPE_DESC.SPEAR_IRON = "铁质长矛,42伤害,120耐久"
STRINGS.RECIPE_DESC.PLATE_IRON = "制造铁质装备的合成材料"												
STRINGS.RECIPE_DESC.AXE_COBALT = "钴质斧,22.8伤害,169耐久"			
STRINGS.RECIPE_DESC.ARMOR_COBALT = "钴质胸板,91%减伤,1170护甲值"	
STRINGS.RECIPE_DESC.PICKAXE_COBALT = "钴质镐,22.8伤害,169耐久"	
STRINGS.RECIPE_DESC.HELMET_COBALT = "钴质头盔,52%减伤,585护甲值,35%防水"	
STRINGS.RECIPE_DESC.SHOVEL_COBALT = "钴质铲,22.8伤害,169耐久"	
STRINGS.RECIPE_DESC.HAMMER_COBALT = "钴质锤,22.8伤害,169耐久"		
STRINGS.RECIPE_DESC.SPEAR_COBALT = "钴质长矛,45.5伤害,130耐久"			
STRINGS.RECIPE_DESC.PLATE_COBALT = "制造钴质装备的合成材料"			


--[[RECIPE DESCRIPTIONS]]

recipeDesc.AXE_IRON = "With this axe any tree can be chopped down!"
recipeDesc.ARMOR_IRON = "Cold and strong!"
recipeDesc.PICKAXE_IRON = "It can destruct any boulder on your way!"
recipeDesc.HELMET_IRON = "Harder than your head. Don't try to check it, ok?"
recipeDesc.SHOVEL_IRON = "It's an iron shovel."
recipeDesc.HAMMER_IRON = "Now you can crush and smash everything(not)!"
recipeDesc.SPEAR_IRON = "Don't touch the spearhead! It's very sharp."
recipeDesc.PLATE_IRON = "Flatter than Earth."

--[[CHARACTER DESCRIPTIONS]]

--{{ORES}}
charDesc.GENERIC.DESCRIBE.ORE_IRON = "That's not a gold..."
charDesc.WX78.DESCRIBE.ORE_IRON="I made from that?"
charDesc.WICKERBOTTOM.DESCRIBE.ORE_IRON = "That's stronger than gold, but cheaper..."
charDesc.WENDY.DESCRIBE.ORE_IRON = "It's harder than all the other rocks!"
charDesc.WOLFGANG.DESCRIBE.ORE_IRON = "Hard materials for a hard mans!"
charDesc.WILLOW.DESCRIBE.ORE_IRON = "Time to create something dangerous with it"

charDesc.GENERIC.DESCRIBE.ORE_COBALT = "It's so c-c-cold-d..."

--{{BOULDERS}}
charDesc.GENERIC.DESCRIBE.ROCK_IRON = "Is it better than gold?"
charDesc.WX78.DESCRIBE.ROCK_IRON="HARD ROCK CONTAINS METAL...IRON"
charDesc.WICKERBOTTOM.DESCRIBE.ROCK_IRON = "Where have I seen this kind of boulders before..?"
charDesc.WENDY.DESCRIBE.ROCK_IRON = "Let's smash it into pieces!"
charDesc.WOLFGANG.DESCRIBE.ROCK_IRON = "I stronger, than it!"
charDesc.WILLOW.DESCRIBE.ROCK_IRON = "These look kind of funny"

charDesc.GENERIC.DESCRIBE.ROCK_COBALT = "This boulder are colder, than other."

--{{AXES}}
charDesc.GENERIC.DESCRIBE.AXE_IRON ="Woodie would have liked it" 
charDesc.WX78.DESCRIBE.AXE_IRON="Initializing FORESTCUTTER.BAT..."
charDesc.WICKERBOTTOM.DESCRIBE.AXE_IRON = "Not Environmentally Friendly"
charDesc.WENDY.DESCRIBE.AXE_IRON = "Everything dies eventually. Even Trees."
charDesc.WOLFGANG.DESCRIBE.AXE_IRON = "Wood is WEAK, I am MIGHTY!"
charDesc.WILLOW.DESCRIBE.AXE_IRON = "Where do Trees go when they die? ON THE FIRE!"
charDesc.WOODIE.DESCRIBE.AXE_IRON = "Pfff... I have Lucy! She are the best!"

--{{ARMORS}}
charDesc.GENERIC.DESCRIBE.ARMOR_IRON ="Wow, that's so tough!"
charDesc.WX78.DESCRIBE.ARMOR_IRON="I made from iron and not needing this!"
charDesc.WICKERBOTTOM.DESCRIBE.ARMOR_IRON = "A hard chestplate in medieval style."
charDesc.WENDY.DESCRIBE.ARMOR_IRON = "Cold deep inside, like Abigail."
charDesc.WOLFGANG.DESCRIBE.ARMOR_IRON = "Stay Safe, Stay Cool, Stay MIGHTY!"
charDesc.WILLOW.DESCRIBE.ARMOR_IRON = "Safe AND Cold, That's no fun!"

charDesc.GENERIC.DESCRIBE.ARMOR_COBALT = "Please, give me something warm."

--{{PICKAXES}}
charDesc.GENERIC.DESCRIBE.PICKAXE_IRON ="I WILL DESTRUCT ANY STONES ON MY WAY!!!"

charDesc.GENERIC.DESCRIBE.PICKAXE_COBALT = "Pickaxe."
--{{HELMETS}}
charDesc.GENERIC.DESCRIBE.HELMET_IRON ="Good hat"

charDesc.GENERIC.DESCRIBE.HELMET_COBALT ="Very cold hat"
--{{SHOVELS}}
charDesc.GENERIC.DESCRIBE.SHOVEL_IRON = "Iron shovel. It's all."

charDesc.GENERIC.DESCRIBE.SHOVEL_COBALT = "Shovel"
--{{SPEARS}}
charDesc.GENERIC.DESCRIBE.SPEAR_IRON = "So sharp!"

charDesc.GENERIC.DESCRIBE.SPEAR_COBALT = "Spear"
--{{PLATES}}
charDesc.GENERIC.DESCRIBE.PLATE_IRON = "Flat as autor's jokes."

charDesc.GENERIC.DESCRIBE.PLATE_COBALT = "Flat and cold."