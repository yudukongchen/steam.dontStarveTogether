local assets = {
    Asset("ANIM", "anim/kurumi.zip"),
    Asset("ANIM", "anim/kurumi1.zip"),
    Asset("ANIM", "anim/kurumi2.zip"),
    Asset("ANIM", "anim/kurumi3.zip"),
    Asset("ANIM", "anim/ghost_kurumi_build.zip")
}

local skins = {
    normal_skin = "kurumi",
    ghost_skin = "ghost_kurumi_build"
}
local base_prefab = "kurumi"
local tags = { "BASE", "KURUMI", "CHARACTER" }

return CreatePrefabSkin("kurumi_none", {
    base_prefab = base_prefab,
    skins = skins,
    assets = assets,
    skin_tags = tags,
    build_name_override = "kurumi",
    rarity = "Character"
})