local assets =
{
    Asset("ANIM", "anim/kafeibush.zip"),
    Asset("ATLAS", "images/dug_kafeibush.xml"),
    Asset("IMAGE", "images/dug_kafeibush.tex"),
}

local function OnDeploy(inst, pt, deployer)
    local kafeibush = SpawnPrefab("kafeibush")
    if kafeibush then
        kafeibush.Transform:SetPosition(pt:Get())
        kafeibush.AnimState:PlayAnimation("dead_to_idle")
        kafeibush.components.pickable:OnTransplant()
        inst.components.stackable:Get():Remove()
        if deployer and deployer.SoundEmitter then
            deployer.SoundEmitter:PlaySound("dontstarve/common/plant")
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    -- inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst:AddTag("deployedplant")

    inst.AnimState:SetBank("kafeibush")
    inst.AnimState:SetBuild("kafeibush")
    inst.AnimState:PlayAnimation("dropped")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/dug_kafeibush.xml"
    inst.components.inventoryitem.imagename = "dug_kafeibush"

    inst:AddComponent("deployable")
    inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
    inst.components.deployable.ondeploy = OnDeploy

    MakeMediumBurnable(inst, TUNING.LARGE_BURNTIME)
    MakeSmallPropagator(inst)
    MakeHauntableLaunchAndIgnite(inst)

    return inst
end

return Prefab("dug_kafeibush", fn, assets),
    MakePlacer( "dug_kafeibush_placer", "kafeibush", "kafeibush", "idle")