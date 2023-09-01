local assets =
{
	Asset( "ANIM", "anim/stu.zip" ),
	Asset( "ANIM", "anim/stu_skin.zip" ),
	Asset( "ANIM", "anim/ghost_stu_build.zip" )	
}

local skins =
{
	normal_skin = "stu",
	ghost_skin = "ghost_stu_build",
}

local skins_char =
{
	normal_skin = "stu_skin",
	ghost_skin = "ghost_stu_build",
}

local base_prefab = "stu"

local tags = {"BASE" ,"stu", "CHARACTER"}

return CreatePrefabSkin("stu_none",  
{ 
	base_prefab = base_prefab, 
	skins = skins, 
	assets = assets,
	skin_tags = tags,
	
	build_name_override = "stu",
	rarity = "Character",
}),

CreatePrefabSkin("stu_skin1_none",  --ThePlayer.components.skinner:SetSkinName("stu_skin1_none")
{
	base_prefab = base_prefab, 	
	skins = skins_char,  
	assets = assets,
	bigportrait = {symbol = "stu_skin1_none.tex", build = "bigportraits/stu_skin1_none.xml"},
	skin_tags = tags,
	build_name_override = "stu_skin",  
	rarity = "Spiffy",
	skip_item_gen = true,
	skip_giftable_gen = true,	
})


