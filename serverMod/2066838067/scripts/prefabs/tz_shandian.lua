local assets =
{
    Asset("ANIM", "anim/tz_shandian.zip"),
}


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()
	inst.entity:AddFollower()

    inst.AnimState:SetBank("tz_shandian")
    inst.AnimState:SetBuild("tz_shandian")
    inst.AnimState:PlayAnimation("crackle_loop",true)
    inst:AddTag("FX")
	--inst.AnimState:SetSortOrder(0.5)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst.persists = false
    return inst
end

local function fxfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("tz_shandian")
    inst.AnimState:SetBuild("tz_shandian")
    inst.AnimState:PlayAnimation("crackle_loop")
    inst:AddTag("FX")


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst.persists = false
	inst:ListenForEvent("animover", inst.Remove)
    return inst
end

return Prefab("tz_shandian", fn, assets),
	Prefab("tz_shandian_fx", fxfn)