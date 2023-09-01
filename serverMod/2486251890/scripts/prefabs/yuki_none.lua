local assets =
{
	Asset( "ANIM", "anim/yuki.zip" ),
	Asset( "ANIM", "anim/ghost_yuki_build.zip" ),
}

local skins =
{
	normal_skin = "yuki",
	ghost_skin = "ghost_yuki_build",
}

local base_prefab = "yuki"

local tags = {"BASE" ,"ESCTEMPLATE", "CHARACTER"}

return CreatePrefabSkin("yuki_none",
{
	base_prefab = base_prefab, 
	skins = skins, 
	assets = assets,
	skin_tags = tags,
	
	build_name_override = "yuki",
	rarity = "Character",
})