local assets =
{
	Asset( "ANIM", "anim/diting.zip" ),
	Asset( "ANIM", "anim/diting_godmeghost.zip" ),
	Asset( "ANIM", "anim/ghost_diting_build.zip" ),
}

local skins =
{
	normal_skin = "diting",
	ghost_skin = "ghost_diting_build",
}

local skins_char =
{
	normal_skin = "diting_godmeghost",
	ghost_skin = "ghost_diting_build",
}

local tags = {"BASE" ,"ESCTEMPLATE", "CHARACTER"}

return CreatePrefabSkin("diting_none",
{
	base_prefab = "diting", 
	rarity = "Character",		
	skins = skins, 
	assets = assets,
	skin_tags = tags,
	build_name_override = "diting",
}),

CreatePrefabSkin("diting_godmeghost_none",
{
	base_prefab = "diting", 
	rarity = "HeirloomElegant",		
	skins = skins_char,  
	assets = assets,
	bigportrait = {symbol = "diting_godmeghost_none.tex", build = "bigportraits/diting_godmeghost_none.xml"},	
	skin_tags = tags,
	build_name_override = "diting_godmeghost",
})