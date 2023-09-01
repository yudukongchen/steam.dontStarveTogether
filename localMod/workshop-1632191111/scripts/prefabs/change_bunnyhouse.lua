local assets =
{
    Asset("ANIM", "anim/change_bunnyhouse.zip"),
	
	Asset( "IMAGE", "images/inventoryimages/change_bunnyhouse.tex" ),
	Asset( "ATLAS", "images/inventoryimages/change_bunnyhouse.xml" ),
	
	Asset( "IMAGE", "images/inventoryimages/change_bunnyhouse_2.tex" ),
	Asset( "ATLAS", "images/inventoryimages/change_bunnyhouse_2.xml" ),
	
	Asset( "IMAGE", "images/inventoryimages/change_bunnyhouse_grass.tex" ),
	Asset( "ATLAS", "images/inventoryimages/change_bunnyhouse_grass.xml" ),
}

local prefabs =
{
    "rabbit",
    "smallmeat",
}

local SCALE = 2.5

local function keepTwoDecimalPlaces(decimal)-----------------------四舍五入保留两位小数的代码
    decimal = math.floor((decimal * 100)+0.5)*0.01       
    return  decimal 
end

local function CanSpawn(inst)
	return inst.FoodNum > 0 
end

local function dig_up(inst)
    if inst.components.spawner:IsOccupied() and CanSpawn(inst) then
        inst.components.lootdropper:SpawnLootPrefab("rabbit")
    end

    --TheWorld:PushEvent("beginregrowth", inst)
	local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

 

local function startspawning(inst)
    if inst.components.spawner ~= nil then
        inst.components.spawner:SetQueueSpawning(false)
        if not inst.components.spawner:IsSpawnPending() then
            inst.components.spawner:SpawnWithDelay(1)
        end
    end
end

local function stopspawning(inst)
    if inst.components.spawner ~= nil then
		--inst.components.spawner:CancelSpawning()
        inst.components.spawner:SetQueueSpawning(true, 1)
    end
end

local function onoccupied(inst)
	if TheWorld.state.isday and CanSpawn(inst) then
        startspawning(inst)
    end
end


local function OnHaunt(inst)
    return 
        inst.components.spawner ~= nil
        and inst.components.spawner:IsOccupied()
        and inst.components.spawner:ReleaseChild()
end

local function onphasechange(inst)
	local day = TheWorld.state.phase
	--print(inst,"onphasechange",day)	
	if day == "day" and inst.components.spawner ~= nil and inst.components.spawner:IsOccupied() and CanSpawn(inst) then
        startspawning(inst)
		print(inst,"onphasechange startspawning",day)
    else
        stopspawning(inst)
		print(inst,"onphasechange stopspawning",day)
    end
	
end 

--[[local function SpawnGrass(inst)
	if inst.grassnum < inst.grassnum_max then 
		local pos = inst:GetPosition()
		local offset = FindWalkableOffset(pos, math.random(0,360), math.random()*0.5+1.25, 2, true, true) or Vector3(0,0,0)
		local food = SpawnPrefab("change_bunnyhouse_grass")
		food.Transform:SetPosition((pos+offset):Get())
		food:ListenForEvent("onremove",function() 
			if inst and inst:IsValid() then 
				inst.grassnum = inst.grassnum - 1 
				inst.grassnum = math.max(0,inst.grassnum)
			end 
		end)
		inst.grassnum = inst.grassnum + 1
		SpawnPrefab("sand_puff").Transform:SetPosition((pos+offset):Get())
	end
end --]]

---------------------------------------------------------------------------
local function ShouldAcceptItem(inst,item)
	return  item.prefab == "change_bunnyhouse_grass" and inst.FoodNum < inst.MaxFoodNum
end 

local function OnGetItemFromPlayer(inst,giver,item)
	inst.FoodNum = inst.FoodNum + 30 
	inst.FoodNum = math.min(inst.FoodNum,inst.MaxFoodNum)
	inst.FoodNum = math.max(0,inst.FoodNum) 
	
	if TheWorld.state.isday and CanSpawn(inst) then
        startspawning(inst)
    end
end 

local function OnRefuseItem(inst, giver,item)
	if giver.components.talker then 
		if item.prefab == "change_bunnyhouse_grass" then 
			giver.components.talker:Say("食物已经放满了。")
		else
			giver.components.talker:Say("必须放兔子窝的粮草呢。")
		end 
	end
end
---------------------------------------------------------------------------

local function EatGrass(inst)
	inst.FoodNum = inst.FoodNum - 1 
	inst.FoodNum = math.min(inst.FoodNum,inst.MaxFoodNum)
	inst.FoodNum = math.max(0,inst.FoodNum) 
end 

local function descriptionfn(inst,viewer)
	return "剩余食物量："..keepTwoDecimalPlaces((inst.FoodNum / inst.MaxFoodNum ) * 100).."%"
end 

local function OnSave(inst,data)
	data.FoodNum = inst.FoodNum or 0 
	--data.MaxFoodNum = inst.MaxFoodNum 
end 

local function OnLoad(inst,data)
	if data then 
		inst.FoodNum = data.FoodNum or 0 
		--inst.MaxFoodNum = data.MaxFoodNum
	end 
	inst.FoodNum = math.min(inst.FoodNum,inst.MaxFoodNum)
	inst.FoodNum = math.max(0,inst.FoodNum) 
end 

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("cattoy")
	inst:AddTag("trader")

    inst.AnimState:SetBank("change_bunnyhouse")
    inst.AnimState:SetBuild("change_bunnyhouse")
    inst.AnimState:PlayAnimation("idle_house_2")
	
	inst.Transform:SetScale(SCALE,SCALE,SCALE)
	
	MakeObstaclePhysics(inst, .15)


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then

        return inst
    end
	
	--inst.grassnum = 0
	--inst.grassnum_max = 2 
	
	inst.FoodNum = 0 
	inst.MaxFoodNum = 100 
	

    inst:AddComponent("spawner")
    inst.components.spawner:Configure("rabbit", TUNING.RABBIT_RESPAWN_TIME)
    inst.components.spawner:SetOnOccupiedFn(onoccupied)
    inst.components.spawner:SetOnVacateFn(stopspawning)

    inst:AddComponent("lootdropper")
	
	inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetOnFinishCallback(dig_up)
    inst.components.workable:SetWorkLeft(1)


    inst:AddComponent("inspectable")
    inst.components.inspectable.descriptionfn = descriptionfn

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_SMALL)
    inst.components.hauntable:SetOnHauntFn(OnHaunt)
	
	inst.OnSave = OnSave 
	inst.OnLoad = OnLoad

	onphasechange(inst)
	inst:DoPeriodicTask(10,EatGrass)
	inst:WatchWorldState("phase",onphasechange)
	
    return inst
end

local function grassfn()
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    --inst:AddTag("cattoy")
	inst:AddTag("tradable")

    inst.AnimState:SetBank("change_bunnyhouse")
    inst.AnimState:SetBuild("change_bunnyhouse")
    inst.AnimState:PlayAnimation("idle_grass")
	
	inst.Transform:SetScale(0.75,0.75,0.75)


    inst.entity:SetPristine()
    if not TheWorld.ismastersim then

        return inst
    end
	
	inst:AddComponent("bait")
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("tradable")
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "change_bunnyhouse_grass"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/change_bunnyhouse_grass.xml"
	
	inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.VEGGIE
	inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = 0
    inst.components.edible.sanityvalue = 0
	
	--inst.persists = false
	MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
	
	return inst 
end

return Prefab("change_bunnyhouse", fn, assets, prefabs),
MakePlacer("change_bunnyhouse_placer", "change_bunnyhouse", "change_bunnyhouse", "idle_house_2",nil,nil,nil,SCALE),
Prefab("change_bunnyhouse_grass", grassfn, assets)
