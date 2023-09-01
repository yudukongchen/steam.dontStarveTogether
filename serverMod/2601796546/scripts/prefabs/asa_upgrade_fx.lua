local assets =
{
    Asset("ANIM", "anim/upgrade_fx.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	inst.entity:SetPristine()
    inst.entity:AddLight()
	
	inst.Light:SetIntensity(.3)
    inst.Light:SetColour(100 / 255, 200 / 255, 255 / 255)
    inst.Light:SetFalloff(.8)
    inst.Light:SetRadius(1)
    inst.Light:Enable(true)
	
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst:AddTag("upgrade_fx")
	inst.AnimState:SetBank("upgrade_fx")
    inst.AnimState:SetBuild("upgrade_fx")
	inst.AnimState:PlayAnimation("idle")
	
	inst.AnimState:SetLightOverride(0.8)
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	local s = 5
	inst.AnimState:SetScale(s,s,s)
	
	inst.AnimState:SetSortOrder(3)
	
	inst.persists = false
	inst:ListenForEvent("animover", inst.Remove)
	
    return inst
end

return Prefab("asa_upgrade_fx", fn, assets)
