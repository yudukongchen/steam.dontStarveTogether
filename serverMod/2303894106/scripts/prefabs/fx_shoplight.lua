local assets =
{
    Asset("ANIM", "anim/fx_shoplight.zip"),
}

local function onhammered(inst, worker)
    inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()
    inst.entity:AddAnimState()

    inst.Light:SetIntensity(0.3)
    inst.Light:SetColour(252 / 255, 251 / 255, 237 / 255)
    inst.Light:SetFalloff(0.9)
    inst.Light:SetRadius(3)
    inst.Light:Enable(true)

    inst.AnimState:SetBank("fx_shoplight")
    inst.AnimState:SetBuild("fx_shoplight")
    inst.AnimState:PlayAnimation("build")
    inst.AnimState:PushAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(2)
    inst.components.workable:SetOnFinishCallback(onhammered)

    inst.persists = false

    return inst
end

return Prefab("fx_shoplight", fn, assets)