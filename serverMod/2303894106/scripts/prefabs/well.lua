local assets =
{
    Asset("ANIM", "anim/well.zip"),
    Asset("IMAGE", "images/inventoryimages/well.tex"),
    Asset("ATLAS", "images/inventoryimages/well.xml"),
}

local prefabs =
{

}


local function onhammered(inst, worker)
    inst.SoundEmitter:KillSound("firesuppressor_idle")
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end

local function onhit()
    
end

local function OnSave(inst, data)
    data.plants = inst.plants
end

local function OnLoad(inst, data)
    if data ~= nil and data.plants ~= nil and inst.plants == nil and inst.task ~= nil then
        inst.plants = data.plants
    end
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle", true)
end



local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1.5)

    inst.AnimState:SetBuild("well")
    inst.AnimState:SetBank("well")
    inst.AnimState:PlayAnimation("idle", true)


    inst.MiniMapEntity:SetIcon("well_mini.tex")  --小地图图标

    -- From watersource component
    inst:AddTag("watersource")
    inst:AddTag("antlion_sinkhole_blocker")
    inst:AddTag("birdblocker")

    inst:AddTag("well")

    inst.no_wet_prefix = true

    inst:SetDeployExtraSpacing(2)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(6)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    --------------------------------------

    -- inst:AddComponent("fishable")
    -- inst.components.fishable:SetRespawnTime(TUNING.FISH_RESPAWN_TIME)
    -- inst.components.fishable:AddFish("pondfish")

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    inst:AddComponent("watersource")

    inst:ListenForEvent("onbuilt", onbuilt)
    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end


return Prefab("well", fn, assets, prefabs),
    MakePlacer("well_placer", "well", "well", "idle")