local assets =
{
    Asset("ANIM", "anim/shadow_ly_ls.zip"),
    Asset("ATLAS", "images/inventoryimages/shadow_ly_ls.xml")
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddDynamicShadow()    
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.DynamicShadow:SetSize(1.3, 1.3)

    inst:AddTag("shadow_ly_ls")

    inst.AnimState:SetBank("shadow_ly_ls")
    inst.AnimState:SetBuild("shadow_ly_ls")
    inst.AnimState:PlayAnimation("idle", true)

    MakeInventoryFloatable(inst, "small")
  
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    -----------------

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "shadow_ly_ls"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/shadow_ly_ls.xml"
              
    inst:AddComponent("tradable")

    inst:AddComponent("inspectable")

    return inst
end

return Prefab("shadow_ly_ls", fn, assets)

