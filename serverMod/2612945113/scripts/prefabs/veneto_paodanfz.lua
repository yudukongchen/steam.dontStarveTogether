local assets = {
	Asset("ANIM",	"anim/veneto_paodan.zip")
	}

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	inst.entity:SetPristine()

	MakeInventoryPhysics(inst)
	RemovePhysicsColliders(inst)

	inst.AnimState:SetBank("pd")
	inst.AnimState:SetBuild("veneto_paodan")
	inst.AnimState:PlayAnimation("pd")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("projectile")
	inst.components.projectile:SetHoming(false)
	inst.components.projectile:SetOnThrownFn(function(inst, owner, target)
		inst.Transform:SetPosition(inst:GetPosition().x, 1, inst:GetPosition().z)
	end)

	inst.persists = false

	return inst
end

return Prefab("veneto_paodanfz", fn, assets)