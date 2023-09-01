local assets =
{
	Asset("ANIM", "anim/veneto_paodan.zip"),
	Asset("ATLAS", "images/inventoryimages/veneto_paodan.xml"),
	Asset("IMAGE", "images/inventoryimages/veneto_paodan.tex"),
	Asset("ANIM", "anim/floating_items.zip"),
}

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("veneto_paodan")
	inst.AnimState:SetBuild("veneto_paodan")
	inst.AnimState:PlayAnimation("idle")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable") 

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

	inst:AddComponent("inventoryitem") 
	inst.components.inventoryitem.atlasname = "images/inventoryimages/veneto_paodan.xml" 

	MakeHauntableLaunch(inst)

	return inst

end

return Prefab("common/inventory/veneto_paodan", fn, assets, prefabs)