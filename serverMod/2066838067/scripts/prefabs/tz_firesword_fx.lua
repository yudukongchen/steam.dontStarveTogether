local assets =
{
    Asset("ANIM", "anim/dragonfly_ground_fx.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("dragonfly_ground_fx")
    inst.AnimState:SetBuild("dragonfly_ground_fx")
    inst.AnimState:PlayAnimation("idle")
	--inst.AnimState:SetMultColour(0,191,255,0.2)
    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst.persists = false
	inst:ListenForEvent("animover", inst.Remove)
    return inst
end

return Prefab("tz_firesword_fx", fn, assets)