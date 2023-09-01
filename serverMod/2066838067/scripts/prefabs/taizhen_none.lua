local assets = 
{
	Asset( "ANIM", "anim/taizhen.zip" ), 
	Asset( "ANIM", "anim/taizhen_pink.zip" ), 
	Asset( "ANIM", "anim/taizhen_boying.zip" ),
	Asset( "ANIM", "anim/ghost_taizhen_build.zip" ), 
	Asset( "ANIM", "anim/tz_pink_icon.zip" ), 
	Asset( "ANIM", "anim/tz_icon.zip" ), 
	Asset( "ANIM", "anim/tz_ghost_fx.zip" ),
}

local skins = 
{
	normal_skin = "taizhen", 
	ghost_skin = "ghost_taizhen_build", 
}

local pinkskins = {
	normal_skin = "taizhen_pink",
	ghost_skin = "ghost_taizhen_build",
}

local boyingskins = {
	normal_skin = "taizhen_boying",
	ghost_skin = "ghost_taizhen_build",
}

local base_prefab = "taizhen"

local tags = {"BASE","TAIZHEN", "CHARACTER"}
local stags = {"三周年","TAIZHEN", "CHARACTER"}
return CreatePrefabSkin("taizhen_none", 

{
	base_prefab = base_prefab, 
	skins = skins,  
	assets = assets, 
	tags = tags, 
	type = "base",
	build_name_override = "taizhen",
	rarity = "Character",	
}),
CreatePrefabSkin("taizhen_pink_none",
{
	base_prefab = base_prefab, 
	skins = pinkskins, 
	assets = assets,
	tags = stags,
	type = "base",
	rarity = "Elegant",
	build_name_override = "taizhen_pink",
}),

CreatePrefabSkin("taizhen_boying_none",
{
	base_prefab = base_prefab, 
	skins = boyingskins, 
	assets = assets,
	tags = stags,
	type = "base",
	rarity = "Elegant",
	build_name_override = "taizhen_boying",
})
