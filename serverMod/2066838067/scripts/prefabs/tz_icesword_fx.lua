local assets =
{
    Asset("ANIM", "anim/deer_ice_burst.zip"),
}


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("deer_ice_burst")
    inst.AnimState:SetBuild("deer_ice_burst")
    inst.AnimState:PlayAnimation("loop")
	inst.AnimState:SetMultColour(0,191,255,0.2)
    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst.persists = false

    return inst
end

return Prefab("tz_icesword_fx", fn, assets)