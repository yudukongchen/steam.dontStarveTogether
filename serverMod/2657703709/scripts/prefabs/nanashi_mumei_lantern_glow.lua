local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    -- inst.entity:AddLight()
    inst.entity:AddFollower()

    inst.Transform:SetFourFaced()

    inst.AnimState:SetBank("nanashi_mumei_lantern")
    inst.AnimState:SetBuild("nanashi_mumei_lantern")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetFinalOffset(3)
    inst.AnimState:SetSortOrder(1)
    -- inst.AnimState:SetMultColour(0.4,0,0.7,0.5)
    local scale = 1
    inst.AnimState:SetScale(scale,scale,scale)
    -- inst.Light:Enable(true)
    -- inst.Light:SetRadius(6)
    -- inst.Light:SetFalloff(0.5)
    -- inst.Light:SetIntensity(0.5)
    -- inst.Light:SetColour(0.6,0,0.5)
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()
    inst.persist = false
    
    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

return Prefab("nanashi_mumei_lantern_glow", fn)