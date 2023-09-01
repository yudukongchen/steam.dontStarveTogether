local prefabs = {}

--NOTE BASE OUTFIT

table.insert(prefabs, CreatePrefabSkin("nanashi_mumei_none",
{
	base_prefab = "nanashi_mumei",
	build_name_override = "nanashi_mumei",
	type = "base",
	rarity = "Character",
	rarity_modifier = "CharacterModifier",
	skins = {
		normal_skin = "nanashi_mumei",
		killer_skin = "nanashi_mumei_killer",
		ghost_skin = "ghost_nanashi_mumei_build",
	},
	assets = {
		Asset( "ANIM", "anim/nanashi_mumei.zip" ),
		Asset( "ANIM", "anim/nanashi_mumei_killer.zip" ),
		Asset( "ANIM", "anim/ghost_nanashi_mumei_build.zip" ),
	},
	skin_tags = { "BASE", "nanashi_mumei", },
--	has_leg_boot = true,
	skip_item_gen = true,
	skip_giftable_gen = true,
}))
--NOTE OTHER OUTFITS

-- table.insert(prefabs, CreatePrefabSkin("nanashi_mumei_shadow",
-- {
-- 	base_prefab = "nanashi_mumei",
-- 	build_name_override = "nanashi_mumei_shadow",
-- 	type = "base",
-- 	rarity = "Distinguished",
-- 	rarity_modifier = "Woven",
-- 	skip_item_gen = true,
-- 	skip_giftable_gen = true,
-- 	skin_tags = { "BASE", "nanashi_mumei", },
-- 	skins = {
-- 		normal_skin = "nanashi_mumei_shadow",
-- 		ghost_skin = "ghost_nanashi_mumei_build",
-- 	},

-- 	assets = {
-- 		Asset( "ANIM", "anim/nanashi_mumei_shadow.zip" ),
-- 		Asset( "ANIM", "anim/ghost_nanashi_mumei_build.zip" ),
-- 	},

-- }))
-- table.insert(prefabs, CreatePrefabSkin("nanashi_mumei_victorian",
-- {
-- 	base_prefab = "nanashi_mumei",
-- 	build_name_override = "nanashi_mumei_victorian",
-- 	type = "base",
-- 	rarity = "Distinguished",
-- 	rarity_modifier = "Woven",
-- 	skip_item_gen = true,
-- 	skip_giftable_gen = true,
-- 	skin_tags = { "BASE", "nanashi_mumei",},
-- 	skins = {
-- 		normal_skin = "nanashi_mumei_victorian",
-- 		ghost_skin = "ghost_nanashi_mumei_build",
-- 	},

-- 	assets = {
-- 		Asset( "ANIM", "anim/nanashi_mumei_victorian.zip" ),
-- 		Asset( "ANIM", "anim/ghost_nanashi_mumei_build.zip" ),
-- 	},

-- }))
-- table.insert(prefabs, CreatePrefabSkin("nanashi_mumei_survivor",
-- {
-- 	base_prefab = "nanashi_mumei",
-- 	build_name_override = "nanashi_mumei_survivor",
-- 	type = "base",
-- 	rarity = "Distinguished",
-- 	rarity_modifier = "Woven",
-- 	skip_item_gen = true,
-- 	skip_giftable_gen = true,
-- 	skin_tags = { "BASE", "nanashi_mumei", },
-- 	skins = {
-- 		normal_skin = "nanashi_mumei_survivor",
-- 		ghost_skin = "ghost_nanashi_mumei_build",
-- 	},

-- 	assets = {
-- 		Asset( "ANIM", "anim/nanashi_mumei_survivor.zip" ),
-- 		Asset( "ANIM", "anim/ghost_nanashi_mumei_build.zip" ),
-- 	},

-- }))
--
return unpack(prefabs)