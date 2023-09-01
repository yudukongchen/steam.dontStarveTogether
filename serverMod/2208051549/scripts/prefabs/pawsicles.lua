local assets =
{
	Asset("ANIM", "anim/pawsicles.zip"),
	Asset("ATLAS", "images/inventoryimages/pawsicles.xml"),
	
	Asset("ATLAS", "images/cookbookimages/pawsicles.xml"),
	Asset("IMAGE", "images/cookbookimages/pawsicles.xml"),
}

local prefabs = 
{
	"spoiled_food",
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	if TheSim:GetGameID() =="DST" then inst.entity:AddNetwork() end
	
	MakeInventoryPhysics(inst)
	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	
	inst.AnimState:SetBank("pawsicles")
	inst.AnimState:SetBuild("pawsicles")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("preparedfood")
	inst:AddTag("pawsicles")

	MakeInventoryFloatable(inst)   --海上漂浮
    inst.components.floater:SetSize("med")
    inst.components.floater:SetVerticalOffset(0.1)
    inst.components.floater:SetScale(0.3)
    
	if TheSim:GetGameID()=="DST" then
		if not TheWorld.ismastersim then
			return inst
		end
		
		inst.entity:SetPristine()
	end
	
	inst:AddComponent("edible")
	inst.components.edible.foodtype = FOODTYPE.VEGGIE
	inst.components.edible.healthvalue = 10
	inst.components.edible.hungervalue = 20
	inst.components.edible.sanityvalue = 20  --神清气爽的小零食。
	inst.components.edible.temperaturedelta = TUNING.COLD_FOOD_BONUS_TEMP
    inst.components.edible.temperatureduration = TUNING.FOOD_TEMP_AVERAGE


	inst:AddComponent("inspectable")
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = 1 --猪王喜欢爪爪冰！

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/pawsicles.xml"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERFAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	inst:AddComponent("bait")
	
	return inst
end

return Prefab( "pawsicles", fn, assets, prefabs )