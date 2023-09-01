local assets = {
    Asset('ANIM', 'anim/ningen_parasitize_fx.zip')
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    -- inst.entity:AddFollower()

    inst.AnimState:SetBank('ningen_parasitize_fx')
    inst.AnimState:SetBuild('ningen_parasitize_fx')
    inst.AnimState:PlayAnimation('idle_1')
    inst.AnimState:PushAnimation('idle_2', true)

    inst:AddTag('FX')

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

return Prefab('ningen_parasitize_fx', fn, assets)
