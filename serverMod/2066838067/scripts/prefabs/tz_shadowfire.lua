

local function MakeTzShadowFx(name,sace)
local assets =
{
    Asset("ANIM", "anim/shadow_channeler.zip"),
    Asset("ANIM", "anim/tz_shadowfire.zip"),
}
local function OnAppear(inst)
    inst:RemoveEventCallback("animover", OnAppear)
    inst.AnimState:PlayAnimation("idle", true)
end
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("tz_shadowfire")
    inst.AnimState:SetBuild("tz_shadowfire")
	inst.AnimState:PlayAnimation("appear")
    inst.AnimState:SetMultColour(1, 1, 1, 1)
	inst.Transform:SetScale(sace, sace, sace)
    inst:AddTag("FX")
    inst:AddTag("notarget")
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst.persists = false
    inst:ListenForEvent("animover", OnAppear)
    return inst
end

return Prefab(name, fn, assets)
end
return MakeTzShadowFx("tz_shadowfire",0.9),
	   MakeTzShadowFx("tz_shadowfirefx",0.5)