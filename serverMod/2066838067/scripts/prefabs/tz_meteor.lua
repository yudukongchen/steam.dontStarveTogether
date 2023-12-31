local assets = {
  Asset("ANIM", "anim/lavaarena_firestaff_meteor.zip"),
}

local assets_splash = {
  Asset("ANIM", "anim/lavaarena_fire_fx.zip"),
}

local prefabs =
{
  "lavaarena_meteor_splash",
}
local prefabs_splash =
{
    "lavaarena_meteor_splashbase",
    "lavaarena_meteor_splashhit",
}

local function fn() 
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    
	inst.AnimState:SetBank("lavaarena_firestaff_meteor")
	inst.AnimState:SetBuild("lavaarena_firestaff_meteor")
	inst.AnimState:PlayAnimation("crash")
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	inst.AnimState:SetMultColour(0,0,0,0.5)
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst:AddTag("notarget")	

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst.persists = false

    return inst
end
local function splashfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("lavaarena_fire_fx")
	inst.AnimState:SetBuild("lavaarena_fire_fx")
	inst.AnimState:PlayAnimation("firestaff_ult")
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	inst.AnimState:SetFinalOffset(1)
	inst.AnimState:SetMultColour(0,0,0,0.5)
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.persists = false
	inst:ListenForEvent("animover", inst.Remove)
	return inst
end
local function splashbasefn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("lavaarena_fire_fx")
	inst.AnimState:SetBuild("lavaarena_fire_fx")
	inst.AnimState:PlayAnimation("firestaff_ult_projection")
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)
	inst.AnimState:SetMultColour(0,0,0,0.5)
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst:AddTag("notarget")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.persists = false
	inst:ListenForEvent("animover", inst.Remove)
  return inst
end
local function splashhitfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("lavaarena_fire_fx")
	inst.AnimState:SetBuild("lavaarena_fire_fx")
	inst.AnimState:PlayAnimation("firestaff_ult_hit")
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	inst.AnimState:SetFinalOffset(1)
	inst.AnimState:SetScale(.5, .5)
	inst.AnimState:SetMultColour(0,0,0,0.5)
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst:AddTag("notarget")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	inst.persists = false
	inst:ListenForEvent("animover", inst.Remove)
	return inst
end
return Prefab("tz_meteor", fn, assets, prefabs),
       Prefab("tz_meteor_splash", splashfn, assets_splash, prefabs_splash),
       Prefab("tz_meteor_splashbase", splashbasefn, assets_splash),
       Prefab("tz_meteor_splashhit", splashhitfn, assets_splash)
