local assets =
{
    Asset("ANIM", "anim/tz_zhua_attack.zip"),
}

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
	inst.entity:AddAnimState()

    inst:AddTag("FX")
	inst:AddTag("NOCLICK")

    inst.AnimState:SetBank("tz_zhua_attack")
    inst.AnimState:SetBuild("tz_zhua_attack")
    inst.AnimState:PlayAnimation("attack_A")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false
	inst:ListenForEvent("animover", inst.Remove)
    return inst
end


local function setowner(inst,owner)
	if owner ~= nil then
		local build = owner.AnimState:GetBuild()
		local debugstring = owner.entity:GetDebugString()
		local anim = debugstring:match("anim: .+:(.+) Frame")
		local time = owner.AnimState:GetCurrentAnimationTime()
		if anim ~= nil  and anim ~= "" then
			inst.AnimState:SetBuild(build)
			inst.AnimState:PlayAnimation(anim)
			inst.AnimState:SetTime(time or 0)
			inst.Transform:SetRotation(owner.Transform:GetRotation())
			inst:DoTaskInTime(1.5, ErodeAway)
		else
			inst:Remove()
		end
	else
		inst:Remove()
	end
end

local function fxfn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
	inst.entity:AddAnimState()

    inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst.Transform:SetFourFaced(inst)
    inst.AnimState:SetBank("wilson")
    inst.AnimState:SetBuild("taizhen")
    inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetMultColour(0, 0, 0, .5)
	inst.entity:AddSoundEmitter()
	
	inst.AnimState:Hide("ARM_carry")
    inst.AnimState:Hide("HAT")
    inst.AnimState:Hide("HAIR_HAT")	
	inst.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_despawn")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false
	inst.SetOwner = setowner
    return inst
end

return Prefab("tz_zhua_attack", fn, assets),Prefab("tz_shanbi_fx", fxfn)
