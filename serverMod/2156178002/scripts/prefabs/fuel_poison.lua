local assets=
{ 
    Asset("ANIM", "anim/fuel_poison.zip"),

    Asset("ATLAS", "images/inventoryimages/fuel_poison.xml"),
    Asset("IMAGE", "images/inventoryimages/fuel_poison.tex"),
}

 local function fn(Sim) 
    local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	
    MakeInventoryPhysics(inst)
	
    inst.AnimState:SetBank("fuel_poison")
    inst.AnimState:SetBuild("fuel_poison")
    inst.AnimState:PlayAnimation("idle")
	
    inst:AddTag("fuel_poison")
	
	MakeInventoryFloatable(inst, "small", 0.05)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inventoryitem")
    inst:AddComponent("inspectable")
	inst:AddComponent("stackable")
	
	MakeHauntableLaunch(inst)

    inst.components.inventoryitem.imagename = "fuel_poison"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fuel_poison.xml"
	
	-- inst:AddComponent("tradable")
	
    return inst
end

return  Prefab("common/inventory/fuel_poison", fn, assets)