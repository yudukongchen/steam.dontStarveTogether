--[[
--by:小开心
--ps:转载请注明来源
]]

local assets =
{
    Asset("ANIM", "anim/tz_coin.zip"),
    Asset("ATLAS", "images/inventoryimages/tz_coin.xml")
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("tz_coin")
    inst.AnimState:SetBuild("tz_coin")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("tz_coin")
    inst:AddTag("molebait")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("tradable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_coin.xml"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

    inst:AddComponent("bait")

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("tz_coin", fn, assets)
