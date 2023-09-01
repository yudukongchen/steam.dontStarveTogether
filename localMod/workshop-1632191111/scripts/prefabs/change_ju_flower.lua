require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/change_ju_flower.zip"),
	
	Asset( "IMAGE", "images/inventoryimages/change_ju_flower_picked.tex" ),
	Asset( "ATLAS", "images/inventoryimages/change_ju_flower_picked.xml" ),
}

local prefabs =
{
    "collapse_small",
}


local function onhammered(inst)
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("pot")
    inst.components.lootdropper:DropLoot()
    inst:Remove()
end

local function onpickedfn(inst, picker)
    inst.AnimState:PlayAnimation("empty")
end

local function onregenfn(inst)
    inst.AnimState:PlayAnimation("full")
end

local function makeemptyfn(inst)
    inst.AnimState:PlayAnimation("empty")
end

local function makebarrenfn(inst, wasempty)
	inst.AnimState:PlayAnimation("empty")
end

local function onbuilt(inst)
   --[[ inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("closed", false)
    inst.SoundEmitter:PlaySound("dontstarve/common/chest_craft")--]]
	inst.components.pickable:MakeEmpty()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("change_ju_flower")
    inst.AnimState:SetBuild("change_ju_flower")
	inst.AnimState:PlayAnimation("full")
    inst.AnimState:SetRayTestOnBB(true)
	
	inst.Transform:SetScale(0.8,0.8,0.8)

    inst:AddTag("cavedweller")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    MakeHauntableWork(inst)

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(onhammered)

    inst:AddComponent("lootdropper")
	
	inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/harvest_sticks"
    inst.components.pickable:SetUp("change_ju_flower_picked", 480*3,3)--TUNING.SAPLING_REGROW_TIME)
    inst.components.pickable.onregenfn = onregenfn
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makeemptyfn = makeemptyfn
    --inst.components.pickable.ontransplantfn = ontransplantfn
    inst.components.pickable.makebarrenfn = makebarrenfn
	
	inst:ListenForEvent("onbuilt", onbuilt)
	

    return inst
end

local function pickedfn()
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("change_ju_flower")
    inst.AnimState:SetBuild("change_ju_flower")
    inst.AnimState:PlayAnimation("picked")

    inst:AddTag("cattoy")
    inst:AddTag("renewable")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -----------------
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "change_ju_flower_picked"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/change_ju_flower_picked.xml"
	
	
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    inst:AddComponent("tradable")

    -----------------
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.VEGGIE
    inst.components.edible.healthvalue = 1
    inst.components.edible.hungervalue = 1
	inst.components.edible.sanityvalue = 1

    ---------------------
    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)
    MakeHauntableLaunchAndIgnite(inst)

    inst:AddComponent("inspectable")


    return inst
	
end

return Prefab("change_ju_flower", fn, assets, prefabs),
	Prefab("change_ju_flower_picked", pickedfn, assets, prefabs),
    MakePlacer("change_ju_flower_placer", "change_ju_flower", "change_ju_flower", "full",nil,nil,nil,0.8)
