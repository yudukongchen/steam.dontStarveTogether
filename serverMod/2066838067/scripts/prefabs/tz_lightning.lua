local assets =
{
    Asset("ANIM", "anim/tz_lightning.zip"),
}
local function StartFX(inst)
    if TheNet:IsDedicated() then
        return
    end
    inst.SoundEmitter:PlaySound("dontstarve/rain/thunder_close")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()

    inst:AddTag("FX")
    inst.Transform:SetScale(2, 2, 2)

    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetLightOverride(1)
    inst.AnimState:SetBank("lightning")
    inst.AnimState:SetBuild("tz_lightning")
    inst.AnimState:PlayAnimation("anim")
    inst.entity:SetCanSleep(false)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false
    inst:DoTaskInTime(1, inst.Remove)
    inst:DoTaskInTime(0, StartFX)
    inst:ListenForEvent("animover", inst.Remove)

    return inst
end

return Prefab("tz_lightning", fn, assets)