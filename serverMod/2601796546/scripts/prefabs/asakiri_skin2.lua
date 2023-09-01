local assets =
{
	Asset( "ANIM", "anim/asakiri_skin2.zip" ),
	Asset( "ANIM", "anim/ghost_asakiri_build.zip" ),
}

local skins =
{
	normal_skin = "asakiri_skin2",
	ghost_skin = "ghost_asakiri_build",
}

local base_prefab = "asakiri"

local tags = {"BASE", "CHARACTER"}

return CreatePrefabSkin("asakiri_skin2",
{
	base_prefab = base_prefab, 
	skins = skins, 
	assets = assets,
	skin_tags = tags,
	
	build_name_override = "asakiri_skin2",
	rarity = "T2",
})