

local assets = ZxGetPrefabAnimAsset("zxflowerbush")


local function onHammered(inst)
    local fx = SpawnPrefab("petals")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end


local function fn()
    local inst = CreateEntity()
    
    inst.entity:AddTransform()
    inst.entity:AddAnimState() 
    inst.entity:AddMiniMapEntity()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:AddTag("flower")
    inst:AddTag("structure")

    MakeObstaclePhysics(inst, .2)

    --- 默认用酢浆草
    inst.AnimState:SetBank("zxoxalis") 
    inst.AnimState:SetBuild("zxoxalis")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()
    
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("zxskinable")
    inst.components.zxskinable:SetInitSkinId(1001)

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
    inst.components.workable:SetOnFinishCallback(onHammered)

    MakeMediumBurnable(inst)
    MakeSmallPropagator(inst)

    return inst
end

return Prefab("zxflowerbush", fn, assets, nil),
MakePlacer("zxflowerbush_placer", "zxoxalis", "zxoxalis", "idle")