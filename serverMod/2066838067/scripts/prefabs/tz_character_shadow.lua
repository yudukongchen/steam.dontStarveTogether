local function UpdatePing(inst, s0, s1, t0, duration, multcolour, addcolour)
    if next(multcolour) == nil then
        multcolour[1], multcolour[2], multcolour[3], multcolour[4] = inst.AnimState:GetMultColour()
    end
    if next(addcolour) == nil then
        addcolour[1], addcolour[2], addcolour[3], addcolour[4] = inst.AnimState:GetAddColour()
    end
    local t = GetTime() - t0
    local k = 1 - math.max(0, t - 0.1) / duration
    k = 1 - k * k
    local s = Lerp(s0, s1, k)
    local c = Lerp(1, 0, k)
    inst.Transform:SetScale(s, s, s)
    inst.AnimState:SetMultColour(c * multcolour[1], c * multcolour[2], c * multcolour[3], c * multcolour[4])

    k = math.min(0.3, t) / 0.3
    c = math.max(0, 1 - k * k)
    inst.AnimState:SetAddColour(c * addcolour[1], c * addcolour[2], c * addcolour[3], c * addcolour[4])
end

local function FadeOut(inst,duration,startscale,adds)
	if inst.fadetask then 
		inst.fadetask:Cancel()
		inst.fadetask = nil 
	end
	duration = duration or 0.4
	startscale = startscale or 1
	adds = adds or 0
	
	inst.fadetask = inst:DoPeriodicTask(0, UpdatePing, nil, startscale, startscale + adds, GetTime(),duration, {}, {})
	inst:DoTaskInTime(duration,inst.Remove) 
end 

local function shadow_fn()
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()
	inst.entity:AddAnimState()

    inst.Transform:SetFourFaced()

    inst.AnimState:OverrideSymbol("swap_object", "swap_tz_fanta_blade_blade", "swap_tz_fanta_blade_blade")
    inst.AnimState:Show("ARM_carry")
    inst.AnimState:Hide("ARM_normal")
	inst.AnimState:Show("HEAD")
	inst.AnimState:Hide("HEAD_HAT")

    inst.AnimState:SetBank("wilson") 
	inst.AnimState:SetBuild("taizhen")
	inst.AnimState:SetMultColour(0.1,0.1,0.1,0)
	inst.AnimState:SetAddColour(0.2,0.2,0.2,1)
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

	inst.AnimState:SetFinalOffset(-1)

	inst:AddTag("FX")
	inst:AddTag("NOCLICK")

	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    inst.FadeOut = FadeOut
	
	
	return inst

end

return Prefab("tz_character_shadow", shadow_fn)