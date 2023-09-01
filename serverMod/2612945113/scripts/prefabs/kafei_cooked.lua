local assets =
{
    Asset("ANIM", "anim/shukafei.zip"),
    Asset("ATLAS", "images/kafei_cooked.xml"),
    Asset("IMAGE", "images/kafei_cooked.tex"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    -- inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("shukafei")
    inst.AnimState:SetBuild("shukafei")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.GOODIES
    inst.components.edible.hungervalue = 10
    inst.components.edible.healthvalue = -10
    inst.components.edible.sanityvalue = -5

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/kafei_cooked.xml"
    inst.components.inventoryitem.imagename = "kafei_cooked"

    return inst
end

return Prefab("kafei_cooked", fn, assets)