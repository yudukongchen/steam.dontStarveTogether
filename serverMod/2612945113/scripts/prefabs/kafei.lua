local assets =
{
    Asset("ANIM", "anim/shengkafei.zip"),
    Asset("ATLAS", "images/kafei.xml"),
    Asset("IMAGE", "images/kafei.tex"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    -- inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("shengkafei")
    inst.AnimState:SetBuild("shengkafei")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    inst:AddTag("cookable")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.GOODIES
    inst.components.edible.hungervalue = 5
    inst.components.edible.healthvalue = -10
    inst.components.edible.sanityvalue = -10

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("cookable")
    inst.components.cookable.product = "kafei_cooked"

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/kafei.xml"
    inst.components.inventoryitem.imagename = "kafei"

    return inst
end

return Prefab("kafei", fn, assets)