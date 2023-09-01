local assets =
{
	Asset("ANIM", "anim/tz_sama.zip"),
}

local brain = require("brains/tz_samabrain")

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()
    inst.entity:AddDynamicShadow()
    inst.AnimState:SetBank("ghost")
    inst.AnimState:SetBuild("tz_sama")
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:SetBloomEffectHandle("shaders/anim_bloom_ghost.ksh")
    inst.AnimState:SetLightOverride(TUNING.GHOST_LIGHT_OVERRIDE)
    inst.AnimState:SetMultColour(0,0,0,0.5)
	inst.DynamicShadow:SetSize(2, .75)
    inst:AddTag("character")
    inst:AddTag("scarytoprey")
    inst:AddTag("boy")
    inst:AddTag("ghost")
    inst:AddTag("noauradamage")
    inst:AddTag("notraptrigger")
    inst:AddTag("NOBLOCK")
	inst:AddTag("tz_sama")


    MakeGhostPhysics(inst, 1, .5)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	inst.persists = false

    inst:SetBrain(brain)

    inst:AddComponent("locomotor") 
    inst.components.locomotor.walkspeed = 5
    inst.components.locomotor.runspeed = 6
	
    inst:AddComponent("samaaura")
    inst.components.samaaura.aura = 13 
	
    inst:SetStateGraph("SGtz_sama")

    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")

    inst:AddComponent("follower")
    inst.components.follower:KeepLeaderOnAttacked()
    inst.components.follower.keepdeadleader = true

    return inst
end

return Prefab("tz_sama", fn, assets)
