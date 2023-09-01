local assets =
{
    Asset("ANIM", "anim/jinkela_ash.zip"),
    Asset("IMAGE", "images/inventoryimages/jinkela_ash.tex"),
    Asset("ATLAS", "images/inventoryimages/jinkela_ash.xml"),
}


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("jinkela_ash")
    inst.AnimState:SetBuild("jinkela_ash")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst, "small", 0.2, 0.95)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    --inst.components.stackable.maxsize = 40        --为了兼容999堆叠mod去掉了最大堆叠设置

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/jinkela_ash.xml" --物品贴图

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("jinkela_ash", fn, assets)