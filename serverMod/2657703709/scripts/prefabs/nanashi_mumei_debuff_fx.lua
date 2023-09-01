local assets =
{
    Asset("ANIM", "anim/nanashi_mumei_debuff.zip"),
}
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    -- inst.entity:AddLight()

    inst.AnimState:SetBank("nanashi_mumei_debuff")
    inst.AnimState:SetBuild("nanashi_mumei_debuff")
    inst.AnimState:PlayAnimation("spawn")
    inst.AnimState:PushAnimation("idle",true)
    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetFinalOffset(3)
    inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.BillBoard)
    inst.AnimState:SetLayer(LAYER_WORLD)
    local scale = 1
    inst.AnimState:SetScale(scale,scale,scale)
    local transparency = 0.5
    inst.AnimState:SetMultColour(transparency,transparency,transparency,transparency)
    inst.Transform:SetPosition(0,5,0)

    
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()
    inst.eyes = inst:SpawnChild("nanashi_mumei_debuff_fx_eyes")
    if not TheWorld.ismastersim then
        return inst
    end

    inst.persist = false

    return inst
end

local function fn2()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    -- inst.entity:AddLight()

    inst.AnimState:SetBank("nanashi_mumei_debuff")
    inst.AnimState:SetBuild("nanashi_mumei_debuff")
    inst.AnimState:PlayAnimation("spawn_eyes")
    inst.AnimState:PushAnimation("idle_eyes")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetFinalOffset(3)
    inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.BillBoard)
    inst.AnimState:SetLayer(LAYER_WORLD)
    local scale = 1
    inst.AnimState:SetScale(scale,scale,scale)


    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()
    
    if not TheWorld.ismastersim then
        return inst
    end
    inst.persist = false

    return inst
end

return Prefab("nanashi_mumei_debuff_fx", fn,assets)
,Prefab("nanashi_mumei_debuff_fx_eyes", fn2)