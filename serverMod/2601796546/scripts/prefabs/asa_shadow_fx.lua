local assets = {
	Asset("ANIM", "anim/asakiri.zip"),
}

local function shadowfn()
	local inst = CreateEntity()
	inst.entity:AddNetwork()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()

	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst:AddTag('NOBLOCK')

	inst.AnimState:SetBank("wilson")
	inst.AnimState:SetBuild("asakiri")
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:OverrideSymbol("swap_object", "swap_asa_blade", "swap_asa_blade")
	inst.AnimState:Show("ARM_carry")
	inst.AnimState:Hide("ARM_normal")
	
	inst.AnimState:SetSortOrder(-1)
	
	inst.Transform:SetFourFaced()
	inst.persists = false
	inst:DoTaskInTime(0.14, function()
		inst:Remove()
	end)
	--inst:ListenForEvent("animover", inst.Remove)
	--MakeCharacterPhysics(inst, 75, .5)
	inst.persists = false
	
	return inst
end

return Prefab("asa_shadow_fx", shadowfn)
	
