local assets =
{
    Asset("ANIM", "anim/dragonfly_fx.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()
	--deer_fire_burst
    inst.AnimState:SetBank("dragonfly_fx")
    inst.AnimState:SetBuild("dragonfly_fx")
    inst.AnimState:PlayAnimation("taunt")
	--inst.AnimState:SetMultColour(0,191,255,0.2)
    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst.persists = false
    return inst
end

return Prefab("tz_firesword_fx2", fn, assets)