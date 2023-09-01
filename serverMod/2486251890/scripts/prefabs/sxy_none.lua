local assets =
{
	Asset( "ANIM", "anim/yuki.zip" ),
	Asset( "ANIM", "anim/ghost_yuki_build.zip" ),
}

local skins =
{
	normal_skin = "ly_follower",
	ghost_skin = "ghost_build",
}

local base_prefab = "sxy"

local tags = {"BASE" ,"ESCTEMPLATE", "CHARACTER"}

return CreatePrefabSkin("sxy_none",
{
	base_prefab = base_prefab, 
	skins = skins, 
	assets = assets,
	skin_tags = tags,
	
	build_name_override = "yuki",
	rarity = "Character",
})