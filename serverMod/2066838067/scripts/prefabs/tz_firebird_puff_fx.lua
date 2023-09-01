local assets =
{
    Asset("ANIM", "anim/tz_firebird.zip"),
}

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.AnimState:SetBank("tz_firebird")
    inst.AnimState:SetBuild("tz_firebird")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
    --inst.AnimState:SetLayer( LAYER_BACKGROUND )
    inst.AnimState:SetFinalOffset(10)

    inst.AnimState:SetMultColour(0, 0, 0, 1)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst:ListenForEvent("animover", inst.Remove)

    return inst
end

return Prefab("tz_firebird_puff_fx", fn, assets)
