local function MakeVegStats(seedweight, hunger, health, perish_time, sanity, cooked_hunger, cooked_health, cooked_perish_time, cooked_sanity, id, true_name)
	return 
	{
		health = health,
		hunger = hunger,
		cooked_health = cooked_health,
		cooked_hunger = cooked_hunger,
		seed_weight = seedweight,
		perishtime = perish_time,
		cooked_perishtime = cooked_perish_time,
		sanity = sanity,
		cooked_sanity = cooked_sanity,
		id = id,
		true_name = true_name,
	}
end

local COMMON = 2
local UNCOMMON = 1

EXTRA_VEGGIES = 
{
	aloe = MakeVegStats(COMMON, 9.375, 1, TUNING.PERISH_SUPERFAST, 10, 9.375, 0, TUNING.PERISH_SUPERFAST, 0, 8, "aloe"),
}


local function MakeVeggie(name, has_seeds)

	local assets =
	{	
		Asset("ANIM", "anim/"..name..".zip"),
		Asset("ANIM", "anim/quagmire_seeds.zip"),
		Asset("IMAGE", "images/inventoryimages/aloe.tex"),
		Asset("ATLAS", "images/inventoryimages/aloe.xml"),
		Asset("IMAGE", "images/inventoryimages/aloe_cooked.tex"),
		Asset("ATLAS", "images/inventoryimages/aloe_cooked.xml"),
		Asset("IMAGE", "images/inventoryimages/aloe_seeds.tex"),
		Asset("ATLAS", "images/inventoryimages/aloe_seeds.xml"),
	}

	local assets_cooked = {}

	local assets_seeds = {}
		
	local prefabs =
	{	
		name.."_cooked",
		"spoiled_food",
	}
	
	if has_seeds then
		table.insert(prefabs, name.."_seeds")
	end

	local function fn_seeds()
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()
		inst.entity:SetPristine()
        if not TheWorld.ismastersim then
        return inst
        end	    
		MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("quagmire_seeds")
        inst.AnimState:SetBuild("quagmire_seeds")
        inst.AnimState:SetRayTestOnBB(true)
		inst.AnimState:PlayAnimation("seeds_1")

		inst:AddComponent("edible")
		inst.components.edible.healthvalue 	= TUNING.HEALING_TINY/2
		inst.components.edible.hungervalue 	= TUNING.CALORIES_TINY
		inst.components.edible.foodtype 	= "SEEDS"

        inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

		inst:AddComponent("tradable")
		inst:AddComponent("inspectable")
		inst:AddComponent("inventoryitem")
	    inst.components.inventoryitem.imagename = name.."_seeds"
	    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name.."_seeds.xml"

		inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW)
		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = "spoiled_food"

		inst:AddComponent("cookable")
		inst.components.cookable.product = "seeds_cooked"

		inst:AddComponent("bait")

		inst:AddComponent("plantable")
		inst.components.plantable.growtime = TUNING.SEEDS_GROW_TIME
		inst.components.plantable.product = name

		return inst
	end

	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()
		inst.entity:SetPristine()
        if not TheWorld.ismastersim then
        return inst
        end	    
		MakeInventoryPhysics(inst)

		inst.AnimState:SetBank(name)
		inst.AnimState:SetBuild(name)
		inst.AnimState:PlayAnimation("idle")		

		inst:AddComponent("edible")
		inst.components.edible.healthvalue 	= EXTRA_VEGGIES[name].health
		inst.components.edible.hungervalue 	= EXTRA_VEGGIES[name].hunger
		inst.components.edible.sanityvalue 	= EXTRA_VEGGIES[name].sanity or 0		
		inst.components.edible.foodtype 	= "VEGGIE"

        inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

		inst:AddComponent("tradable")
		inst:AddComponent("inspectable")
		inst:AddComponent("inventoryitem")
	    inst.components.inventoryitem.imagename = name
	    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"

		inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime(EXTRA_VEGGIES[name].perishtime)
		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = "spoiled_food"   

		inst:AddComponent("bait")

		inst:AddComponent("cookable")
		inst.components.cookable.product = name.."_cooked"

	    MakeSmallBurnable(inst)
		MakeSmallPropagator(inst) 

		return inst
	end
	
	local function fn_cooked()
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()
		inst.entity:SetPristine()
        if not TheWorld.ismastersim then
        return inst
        end	    
		MakeInventoryPhysics(inst)
		
		inst.AnimState:SetBank(name)
		inst.AnimState:SetBuild(name)
		inst.AnimState:PlayAnimation("cooked")

		inst:AddComponent("edible")
		inst.components.edible.healthvalue = EXTRA_VEGGIES[name].cooked_health
		inst.components.edible.hungervalue = EXTRA_VEGGIES[name].cooked_hunger
		inst.components.edible.sanityvalue = EXTRA_VEGGIES[name].cooked_sanity or 0
		inst.components.edible.foodtype = "VEGGIE"

        inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

		inst:AddComponent("tradable")
		inst:AddComponent("inspectable")
		inst:AddComponent("inventoryitem")
	    inst.components.inventoryitem.imagename = name.."_cooked"
	    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name.."_cooked.xml"

		inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime(EXTRA_VEGGIES[name].cooked_perishtime)
		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = "spoiled_food"

		inst:AddComponent("bait")

	    MakeSmallBurnable(inst)
		MakeSmallPropagator(inst)

		return inst
	end
	
	local base = Prefab( "common/inventory/"..name, fn, assets, prefabs)
	local cooked = Prefab( "common/inventory/"..name.."_cooked", fn_cooked, assets)
	local seeds = has_seeds and Prefab( "common/inventory/"..name.."_seeds", fn_seeds, assets) or nil
		
	return base, cooked, seeds
end

local prefs = {}
for veggiename,veggiedata in pairs(EXTRA_VEGGIES) do
	local veg, cooked, seeds

	veg, cooked, seeds = MakeVeggie(veggiename, true)

	table.insert(prefs, veg)
	table.insert(prefs, cooked)
	if seeds then
		table.insert(prefs, seeds)
		VEGGIES[veggiename] = veggiedata
	end
end

return unpack(prefs)