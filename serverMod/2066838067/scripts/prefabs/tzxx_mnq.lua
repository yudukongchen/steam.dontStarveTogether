local assets =
{
    Asset("ANIM", "anim/tzxx_mnq.zip"),
	Asset("IMAGE", "images/inventoryimages/tzxx_mnq.tex"),
	Asset("ATLAS", "images/inventoryimages/tzxx_mnq.xml"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("tzxx_mnq")
    inst.AnimState:SetBuild("tzxx_mnq")
    inst.AnimState:PlayAnimation("idle")

	inst.Transform:SetScale(1.8, 1.8, 1.8)
	
    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -----------------
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tzxx_mnq.xml"

    inst:AddComponent("tradable")
	
	inst:AddComponent("tzxx_mnq")

    inst:AddComponent("inspectable")

    return inst
end

return Prefab("tzxx_mnq", fn, assets)
