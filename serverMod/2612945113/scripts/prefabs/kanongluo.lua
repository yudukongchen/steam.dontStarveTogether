local assets =
{
    Asset("ANIM", "anim/kanongluo.zip"),
    Asset("ATLAS", "images/kanongluo.xml"),
    Asset("IMAGE", "images/kanongluo.tex"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    -- inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("kanongluo")
    inst.AnimState:SetBuild("kanongluo")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.GOODIES
    inst.components.edible.hungervalue = 40
    inst.components.edible.sanityvalue = 40
    inst.components.edible.healthvalue = 40

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED) -- 10天
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/kanongluo.xml"
    inst.components.inventoryitem.imagename = "kanongluo"

    return inst
end

return Prefab("kanongluo", fn, assets)