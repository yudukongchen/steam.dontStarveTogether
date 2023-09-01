local assets =
{
    Asset("ANIM", "anim/yingzi.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("yingzi")
    inst.AnimState:SetBuild("yingzi")
    inst.AnimState:PlayAnimation("loop", true)
    inst.Transform:SetScale(2, 2, 2)
    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst.persists = false
	-- inst:ListenForEvent("animover", inst.Remove)
    return inst
end

return Prefab("tz_shadow_buff", fn, assets)