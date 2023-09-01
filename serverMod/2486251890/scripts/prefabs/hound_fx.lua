local assets =
{ 
}

local function fn()   --设置苔藓花环的光源hound", "
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.Transform:SetFourFaced()

    inst.AnimState:SetBank("hound")
    inst.AnimState:SetBuild("hound_ocean")
    inst.AnimState:PlayAnimation("atk_pre")
    inst.AnimState:PushAnimation("atk", false)

   -- inst.Transform:SetScale(0.9, 0.9, 0.9)

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
          return inst
    end

    --inst:AddComponent("combat")

    inst.persists = false

    return inst
end

return Prefab("hound_fx", fn, assets)
       