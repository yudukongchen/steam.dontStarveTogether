local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    -- inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    -- inst.entity:AddLight()
    -- inst.entity:AddFollower()

    inst.Transform:SetFourFaced()

    inst.AnimState:SetBank("wilson")
    inst.AnimState:SetBuild("nanashi_mumei")
    inst.AnimState:PlayAnimation("run_loop")
    -- inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetFinalOffset(3)
    inst.AnimState:SetSortOrder(-2)
    inst.AnimState:SetMultColour(0,0,0,0.5)
    local scale = 1
    inst.AnimState:SetScale(scale,scale,scale)

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()
    inst.persist = false
    
    if not TheWorld.ismastersim then
        return inst
    end
    local percent = 1
    inst:DoTaskInTime(0,function ()
        if inst._owner then
            inst.Transform:SetRotation(inst._owner.Transform:GetRotation())
            if inst._owner.AnimState:IsCurrentAnimation("run_loop") then
                inst.AnimState:PlayAnimation("run_loop",true)
                inst.AnimState:SetTime(inst.AnimState:GetCurrentAnimationTime())
            end
        elseif not inst._owner then
            inst:Remove()
        end
    end)
    inst:DoPeriodicTask(0.1,function ()
        if inst._owner then
            percent = percent - 0.1
            inst.AnimState:SetMultColour(0,0,0,percent*0.5)
            if not percent or percent == 0 or percent < 0 then
                inst:Remove()
            end
        else
            inst:Remove()
        end
    end)
    
    return inst
end

return Prefab("nanashi_mumei_shadow", fn)