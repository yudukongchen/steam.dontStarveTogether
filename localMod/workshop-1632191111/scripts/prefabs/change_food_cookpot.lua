local preparedfoods_change = require("preparedfoods_change")
local cooking = require("cooking")
local function MakeFood(name, str,scale,type, health, hunger, sanity,perishtime,description,oneatfn,extrafn) 
	local assets = { 
		Asset("ANIM", "anim/change_food_cookpot.zip"),     
		Asset("ATLAS", "images/inventoryimages/"..name..".xml"), 
	}  
	local prefabs =  { "spoiled_food", }  
	local function fn(Sim) 
		local inst = CreateEntity() 
		inst.entity:AddTransform() 
		inst.entity:AddAnimState() 
		--inst.entity:AddDynamicShadow() 
		
		--inst.DynamicShadow:SetSize(1.3, .6) 
		
		if TheSim:GetGameID() =="DST" then 
			inst.entity:AddNetwork() 
		end  
		
		MakeInventoryPhysics(inst) 
		MakeSmallBurnable(inst) 
		MakeSmallPropagator(inst)  
		
		inst.AnimState:SetBank("change_food_cookpot") 
		inst.AnimState:SetBuild("change_food_cookpot") 
		inst.AnimState:PlayAnimation(name,true)  
		inst.Transform:SetScale(scale,scale,scale)
		
		inst:AddTag("preparedfood")
		inst:AddTag("preparedfood_change") 
		inst:AddTag("edible_"..type)
		 
		if TheSim:GetGameID()=="DST" then 
			if not TheWorld.ismastersim then 
				return inst 
			end  
			inst.entity:SetPristine() 
		end 
		
		inst:AddComponent("edible") 
		inst.components.edible.foodtype = type 
		inst.components.edible.healthvalue = health 
		inst.components.edible.hungervalue = hunger 
		inst.components.edible.sanityvalue = sanity  
		inst.components.edible:SetOnEatenFn(oneatfn)
		
		
		inst:AddComponent("inspectable") 
		inst.components.inspectable:SetDescription(description or "")
		
		inst:AddComponent("tradable")  
		
		inst:AddComponent("inventoryitem") 
		inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"  
		
		inst:AddComponent("stackable") 
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM  
		
		if perishtime ~= nil then 
			inst:AddComponent("perishable") 
			inst.components.perishable:SetPerishTime(perishtime) 
			inst.components.perishable:StartPerishing() 
			inst.components.perishable.onperishreplacement = "spoiled_food" 
		end  
		
		if extrafn then 
			extrafn(inst) 
		end
		
		return inst 
	end  
	STRINGS.NAMES[string.upper(name)] = str 
	return Prefab(name, fn, assets, prefabs) 
end 

local foods = {}
for k,v in pairs(preparedfoods_change) do 
	table.insert(foods,MakeFood(v.name, v.str,v.scale,v.type, v.health, v.hunger, v.sanity,v.perishtime,v.description,v.oneatfn,v.extrafn))
	if v.othercookpots then 
		for _,cookpot in pairs(v.othercookpots) do 
			AddCookerRecipe(cookpot,v,cooking.IsModCookerFood(k))
		end
	end
	AddCookerRecipe("cookpot",v,cooking.IsModCookerFood(k))
end

return unpack(foods)