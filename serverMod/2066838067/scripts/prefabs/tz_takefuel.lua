local assets =
{
    Asset("ANIM", "anim/tz_takefuel.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("NOCLICK")
    inst:AddTag("FX")

    inst.AnimState:SetBank("atrium_gate")
	--inst.AnimState:SetBank("tz_takefuel")
    inst.AnimState:SetBuild("tz_takefuel")
    inst.AnimState:PlayAnimation("overload_pulse")
    inst.AnimState:SetFinalOffset(3)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    inst:ListenForEvent("animover", inst.Remove)

    return inst
end

return Prefab("tz_takefuel", fn, assets)
