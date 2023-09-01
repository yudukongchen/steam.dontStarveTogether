local brain = require("brains/tornadobrain")
local assets =
{
    --Asset("ANIM", "anim/tz_firetornado.zip"),
}
local function ontornadolifetime(inst)
    inst.task = nil
    inst.sg:GoToState("despawn")
end

local function SetDuration(inst, duration)
    if inst.task ~= nil then
        inst.task:Cancel()
    end
    inst.task = inst:DoTaskInTime(duration, ontornadolifetime)
end

local function tornado_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetFinalOffset(2)
    inst.AnimState:SetBank("tz_firetornado")
    inst.AnimState:SetBuild("tz_firetornado")
    inst.AnimState:PlayAnimation("tornado_pre")
    inst.AnimState:PushAnimation("tornado_loop")
	--inst.AnimState:SetMultColour(197/255, 126/255, 126/255,1)

    inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tornado", "spinLoop")

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("knownlocations")

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = TUNING.TORNADO_WALK_SPEED * .33
    inst.components.locomotor.runspeed = TUNING.TORNADO_WALK_SPEED

    inst:SetStateGraph("SGtz_firetornado")
    inst:SetBrain(brain)

    inst.WINDSTAFF_CASTER = nil
    inst.persists = false

    inst.SetDuration = SetDuration
    inst:SetDuration(TUNING.TORNADO_LIFETIME)

    return inst
end

return Prefab("tz_firetornado", tornado_fn, assets)