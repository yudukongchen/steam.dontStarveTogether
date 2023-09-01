local assets =
{
	Asset( "ANIM", "anim/maple.zip" ),
	Asset( "ANIM", "anim/ghost_maple_build.zip" ),
}

local skins =
{
	normal_skin = "maple",
	ghost_skin = "ghost_maple_build",
}

return CreatePrefabSkin("maple_none",
{
	base_prefab = "maple",
	type = "base",
	assets = assets,
	skins = skins, 
	skin_tags = {"MAPLE", "CHARACTER", "BASE"},
	build_name_override = "maple",
	rarity = "Character",
})