local assets =
{
	Asset( "ANIM", "anim/veneto.zip" ),
	Asset( "ANIM", "anim/ghost_veneto_build.zip" ),
}

local skins =
{
	normal_skin = "veneto",
	ghost_skin = "ghost_veneto_build",
}

local base_prefab = "veneto"

local tags = {"BASE" ,"VENETO", "CHARACTER"}

return CreatePrefabSkin("veneto_none",
{
	base_prefab = base_prefab, 
	skins = skins, 
	assets = assets,
	skin_tags = tags,
	
	build_name_override = "veneto",
	rarity = "Character",
})