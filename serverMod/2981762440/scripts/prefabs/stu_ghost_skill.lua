local assets =
{
    
    Asset( "ANIM", "anim/stu_b_skin.zip" ),
    Asset( "ANIM", "anim/ghost_stutrans_build.zip" ),
    Asset( "ANIM", "anim/ghost_stutrans_skin_build.zip" )
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddLight()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("ghost_stutrans_build")               
    inst.AnimState:SetBuild("ghost_stutrans_build")
    inst.AnimState:PlayAnimation("idle", true) 

    inst.AnimState:SetBloomEffectHandle("shaders/anim_bloom_ghost.ksh")
    inst.AnimState:SetLightOverride(TUNING.GHOST_LIGHT_OVERRIDE)

    inst.Light:SetFalloff(0.55)  --衰减
    inst.Light:SetIntensity(.7) --亮度
    inst.Light:SetRadius(2)     --半径
    inst.Light:Enable(true)
    inst.Light:SetColour(180/255, 195/255, 225/255)

    inst.SoundEmitter:PlaySound("dontstarve/ghost/ghost_howl_LP", "howl")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

return Prefab("stu_ghost_skill", fn, assets)
