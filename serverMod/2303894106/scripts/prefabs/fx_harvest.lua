local assets =
{
    Asset("ANIM", "anim/fx_harvest.zip"),
}


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.Transform:SetEightFaced()
    
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("fx_harvest")
    inst.AnimState:SetBuild("fx_harvest")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:ListenForEvent("animover",function(inst) inst:Remove() end)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("fx_harvest", fn, assets)