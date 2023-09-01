local assets =
{

    Asset("ANIM", "anim/ly_statue.zip"),
	
	Asset( "IMAGE", "images/inventoryimages/ly_statue.tex" ),
	Asset( "ATLAS", "images/inventoryimages/ly_statue.xml" ),
}

local prefabs =
{
    "marble",
    "rock_break_fx",
}


local SCALE = 1.5

local function OnWorked(inst, worker, workleft)
    if workleft <= 0 then
        local pos = inst:GetPosition()
        SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
        inst.components.lootdropper:DropLoot(pos)
        inst:Remove()
    else
        --[[inst.AnimState:PlayAnimation(
            (workleft < TUNING.MARBLEPILLAR_MINE / 3 and "low") or
            (workleft < TUNING.MARBLEPILLAR_MINE * 2 / 3 and "med") or
            "full"
        )--]]
    end
end

local function OnWorkLoad(inst)
    OnWorked(inst, nil, inst.components.workable.workleft)
end




local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 0.66)

    inst.entity:AddTag("statue")

    inst.AnimState:SetBank("ly_statue")
    inst.AnimState:SetBuild("ly_statue")
    inst.AnimState:PlayAnimation("idle")

	inst.Transform:SetScale(SCALE,SCALE,SCALE)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")
    --inst.components.lootdropper:SetChanceLootTable('statue_marble')
	--inst.components.lootdropper:SetLootSetupFn(lootsetfn)

    inst:AddComponent("inspectable")
    --inst.components.inspectable.getstatus = GetStatus

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(TUNING.MARBLEPILLAR_MINE)
    inst.components.workable:SetOnWorkCallback(OnWorked)
    inst.components.workable:SetOnLoadFn(OnWorkLoad)
    inst.components.workable.savestate = true

    MakeHauntableWork(inst)

    return inst
end


return Prefab("ly_statue", fn, assets, prefabs),
MakePlacer("ly_statue_placer", "ly_statue", "ly_statue", "idle",nil,nil,nil,SCALE)
