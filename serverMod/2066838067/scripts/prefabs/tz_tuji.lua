local assets =
{
    Asset("ANIM", "anim/tz_tuji.zip"),
    Asset("ANIM", "anim/swap_tz_tuji.zip"),
	Asset("IMAGE", "images/inventoryimages/tz_tuji.tex"),
	Asset("ATLAS", "images/inventoryimages/tz_tuji.xml"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("tz_tuji")
    inst.AnimState:SetBuild("tz_tuji")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_tuji.xml"
	
    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = TUNING.DAPPERNESS_LARGE
	
    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("tz_tuji", fn, assets)