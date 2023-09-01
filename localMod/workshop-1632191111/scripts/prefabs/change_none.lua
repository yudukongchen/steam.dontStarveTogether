local assets =
{
	Asset( "ANIM", "anim/change.zip" ),
	Asset( "ANIM", "anim/ghost_change_build.zip" ),
}

local skins =
{
	normal_skin = "change",
	ghost_skin = "ghost_change_build",
}

local base_prefab = "change"

local tags = {"CHANGE", "CHARACTER"}

return CreatePrefabSkin("change_none",
{
	base_prefab = base_prefab, 
	skins = skins, 
	assets = assets,
	tags = tags,
	
	skip_item_gen = true,
	skip_giftable_gen = true,
})