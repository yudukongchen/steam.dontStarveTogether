local assets =
{
	Asset("ANIM", "anim/hellhotpot.zip"),
	Asset("ATLAS", "images/inventoryimages/hellhotpot.xml"),
	
	Asset("ATLAS", "images/cookbookimages/hellhotpot.xml"),
	Asset("IMAGE", "images/cookbookimages/hellhotpot.xml"),
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
	
	inst.AnimState:SetBank("hellhotpot")
	inst.AnimState:SetBuild("hellhotpot")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("preparedfood")
	inst:AddTag("hellhotpot")
	
	MakeInventoryFloatable(inst)   --海上漂浮
    inst.components.floater:SetSize("med")
    inst.components.floater:SetVerticalOffset(0.1)
    inst.components.floater:SetScale(0.6)
    
	if TheSim:GetGameID()=="DST" then
		if not TheWorld.ismastersim then
			return inst
		end
		
		inst.entity:SetPristine()
	end
	
	inst:AddComponent("edible")
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible.secondaryfoodtype = FOODTYPE.ROUGHAGE
	inst.components.edible.healthvalue = -10
	inst.components.edible.hungervalue = 100
	inst.components.edible.sanityvalue = -20
	inst.components.edible.temperaturedelta = TUNING.HOT_FOOD_WARMING_THRESHOLD
    inst.components.edible.temperatureduration = TUNING.BUFF_FOOD_TEMP_DURATION*3
	inst.components.edible.spice = true   --我整不了香料！厨师驾驭不了火锅，that's all!  --桥头麻袋

	inst:AddComponent("inspectable")
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = 5

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hellhotpot.xml"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	inst:AddComponent("bait")

	inst:ListenForEvent("oneaten", function(inst,data)
		if data.eater and data.eater.components.talker then 
			data.eater.components.talker:Say("我是谁……我在哪……") 
		end
   end)
	
	return inst
end

return Prefab( "hellhotpot", fn, assets, prefabs )
