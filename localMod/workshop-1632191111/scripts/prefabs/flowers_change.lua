require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/flowers_change.zip"),
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

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("flowers_change")
    inst.AnimState:SetBuild("flowers_change")
	inst.AnimState:PlayAnimation("idle")
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


    return inst
end

return Prefab("flowers_change", fn, assets, prefabs),
    MakePlacer("flowers_change_placer", "flowers_change", "flowers_change", "idle",nil,nil,nil,0.8)
