local assets=
{ 
    Asset("ANIM", "anim/fuel_laser.zip"),

    Asset("ATLAS", "images/inventoryimages/fuel_laser.xml"),
    Asset("IMAGE", "images/inventoryimages/fuel_laser.tex"),
}

 local function fn(Sim) 
    local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	
    MakeInventoryPhysics(inst)
	
    inst.AnimState:SetBank("fuel_laser")
    inst.AnimState:SetBuild("fuel_laser")
    inst.AnimState:PlayAnimation("idle")
	
    inst:AddTag("fuel_laser")
	
	MakeInventoryFloatable(inst, "small", 0.05)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inventoryitem")
    inst:AddComponent("inspectable")
	inst:AddComponent("stackable")
	
	MakeHauntableLaunch(inst)

    inst.components.inventoryitem.imagename = "fuel_laser"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fuel_laser.xml"
	
	-- inst:AddComponent("tradable")
	
    return inst
end

return  Prefab("common/inventory/fuel_laser", fn, assets)