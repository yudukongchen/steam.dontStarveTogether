local assets =
{
    Asset("ANIM", "anim/zan_label.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	--inst.entity:AddLight()
	
    
	inst:AddTag("FX")
	inst:AddTag("zan_label")
	inst.AnimState:SetBank("zan_label")
    inst.AnimState:SetBuild("zan_label")
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetLightOverride(0.8)
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	local s = 1
	inst.AnimState:SetScale(s,s,s)
	
	inst.AnimState:SetSortOrder(3)
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.entity:SetPristine()
	inst:AddComponent("asa_zanlabel")
	
	inst.persists = false
	inst:ListenForEvent("animover", function()
		inst:Remove()
	end)
    return inst
end

return Prefab("zan_label", fn, assets)
