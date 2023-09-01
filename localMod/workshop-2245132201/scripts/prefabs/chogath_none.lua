local assets =
{
	Asset( "ANIM", "anim/chogath.zip" ),
	Asset( "ANIM", "anim/ghost_chogath_build.zip" ),
}

local skins =
{
	normal_skin = "chogath",
	ghost_skin = "ghost_chogath_build",
}

local base_prefab = "chogath"

local tags = {"BASE" ,"ESCTEMPLATE", "CHARACTER"}

return CreatePrefabSkin("chogath_none",
{
	base_prefab = base_prefab, 
	skins = skins, 
	assets = assets,
	skin_tags = tags,
	
	build_name_override = "chogath",
	rarity = "Character",
})