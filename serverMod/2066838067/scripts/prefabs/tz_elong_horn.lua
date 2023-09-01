local assets =
{
    Asset("ANIM", "anim/tz_elong_horn.zip"),
	Asset( "IMAGE", "images/inventoryimages/tz_elong_horn.tex" ),
	Asset( "ATLAS", "images/inventoryimages/tz_elong_horn.xml" ),
	Asset( "IMAGE", "images/inventoryimages/tz_elong_aohorn.tex" ),
	Asset( "ATLAS", "images/inventoryimages/tz_elong_aohorn.xml" ),
}

local prefabs =
{

}

local function DoEffects(pet)
    SpawnPrefab(pet:HasTag("flying") and "spawn_fx_small_high" or "spawn_fx_medium").Transform:SetPosition(pet.Transform:GetWorldPosition())
end

local function OnSpawnPet(inst, pet)
    pet:DoTaskInTime(0, DoEffects)
    if pet.components.spawnfader ~= nil then
        pet.components.spawnfader:FadeIn()
    end
end

local function OnDespawnPet(inst, pet)
    local owner = inst.components.inventoryitem:GetGrandOwner()
    if pet.components.rideable:IsBeingRidden() and pet.components.rideable:GetRider() ~= owner then 
        pet.components.rideable:Buck()
        pet:DoTaskInTime(0.5,function()
            DoEffects(pet)
            pet:Remove()
        end)
    else
        DoEffects(pet)
        pet:Remove()
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("tz_elong_horn")
    inst.AnimState:SetBuild("tz_elong_horn")
    inst.AnimState:PlayAnimation("idle1")

    inst.MiniMapEntity:SetIcon("tz_elong_horn.tex")

    MakeInventoryFloatable(inst)

    inst:AddTag("_named")
    inst:AddTag("nobundling")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:RemoveTag("_named")

    inst:AddComponent("named")

    inst:AddComponent("leader")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_elong_horn.xml"

    inst:AddComponent("inspectable")

    --嗷呜
    inst:AddComponent("aowu_elong")
    inst.components.aowu_elong:SetOnSpawnFn(OnSpawnPet)
    inst.components.aowu_elong:SetOnDespawnFn(OnDespawnPet)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("tz_elong_horn", fn, assets, prefabs)
