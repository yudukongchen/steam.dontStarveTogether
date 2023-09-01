
    local assets =
    {
        Asset("ANIM", "anim/lostearth.zip"),
        Asset("ANIM", "anim/tz_cc.zip"),
    }
     local bfassets =
    {
        Asset("ANIM", "anim/shadow_bishop.zip"),
    }
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()
		MakeInventoryPhysics(inst)
		RemovePhysicsColliders(inst)
        inst.Transform:SetFourFaced(inst)

        inst.AnimState:SetBank("wilson")
        inst.AnimState:SetBuild("lostearth")
		inst.AnimState:SetPercent("lunge_pre", 1)
        inst.AnimState:SetMultColour(0,0,0,0.5)
		inst.AnimState:Show("ARM_carry")
		inst.AnimState:Hide("ARM_normal")
        inst:AddTag("NOBLOCK")
		inst:AddTag("NOCLICK")
        inst:AddTag("notraptrigger")
        inst:AddTag("noauradamage")
		inst:AddTag("fx")
        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end
		inst.persists = false
		inst:DoTaskInTime(15, function(inst) inst:Remove() end)
        return inst
end
local function Yichu(inst,time)
		
		inst:DoTaskInTime(time, function()
		SpawnPrefab("statue_transition_2").Transform:SetPosition(inst.Transform:GetWorldPosition())
		inst:Remove()
		end)
end

    local function ccfn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()
        inst.entity:AddSoundEmitter()		
		MakeInventoryPhysics(inst)
		RemovePhysicsColliders(inst)
		
        inst.Transform:SetFourFaced(inst)

        inst.AnimState:SetBank("tz_cc")
        inst.AnimState:SetBuild("lostearth")
        inst.AnimState:PlayAnimation("atk")
        inst.AnimState:SetMultColour(0,0,0,0.5)
		inst.AnimState:Show("ARM_carry")
		inst.AnimState:Hide("ARM_normal")
		inst.AnimState:OverrideSymbol("swap_object", "swap_tz_tfsword", "swap_tz_tfsword")
        inst:AddTag("NOBLOCK")
		inst:AddTag("NOCLICK")
        inst:AddTag("notraptrigger")
		inst:AddTag("fx")
        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end
		inst.persists = false
		inst.Yichu = Yichu
        return inst
end
local function PlayRingAnim(proxy,play)
    local inst = CreateEntity()

    inst:AddTag("FX")
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst.Transform:SetFromProxy(proxy.GUID)
    
    inst.AnimState:SetBank("shadow_bishop")
    inst.AnimState:SetBuild("shadow_bishop")
    inst.AnimState:PlayAnimation(play)
	inst.AnimState:SetMultColour(1,1,1,0.5)

    inst:ListenForEvent("animover", inst.Remove)
end
local function makebf(name,play)
	local function bffn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddNetwork()

		inst:AddTag("FX")
		if not TheNet:IsDedicated() then
			inst:DoTaskInTime(0, PlayRingAnim,play)
		end
		inst.entity:SetPristine()
		if not TheWorld.ismastersim then
			return inst
		end
		inst.persists = false
		inst:DoTaskInTime(3, inst.Remove)
		return inst
	end
	return Prefab(name, bffn, bfassets)
end
return Prefab("tz_canying", fn, assets),
		Prefab("tz_cccanying", ccfn, assets),
		makebf("tz_bfon","atk_side_loop_pre"),
		makebf("tz_bfoff","atk_side_loop_pst")



