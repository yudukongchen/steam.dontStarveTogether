
local function biu(inst)
	if inst.task then
		inst.task:Cancel()
		inst.task = nil
	end
	inst.AnimState:PlayAnimation("people_pst")
	inst:ListenForEvent("animover", inst.Remove)
end

local function Oncheck(inst)
	if inst.owner ~= nil then
		if inst:IsValid() and inst.owner:IsValid() then
			local dis = inst:GetDistanceSqToInst(inst.owner)
			if dis > 4 then
				biu(inst)
			end
		else
			biu(inst)
		end
	else
		biu(inst)
	end
end

local function setowner(inst,owner)
	inst.owner = owner
	inst.task = inst:DoPeriodicTask(0.5, Oncheck)
end

local function onremove(inst)
	if inst.owner ~= nil then
		inst.owner.pipafx = nil
	end
end

local function fxfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:AddAnimState()
    inst:AddTag("FX")
	inst.Transform:SetFourFaced()
	--inst.Transform:SetScale(0.6, 0.6, 0.6)
    
    inst.AnimState:SetBank("tz_floating_texie")
    inst.AnimState:SetBuild("tz_floating_texiao")
    inst.AnimState:PlayAnimation("people_pre")
	inst.AnimState:PushAnimation("people_loop",true)
    --inst.AnimState:SetFinalOffset(-1)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
	inst.SetOwner = setowner
    inst.persists = false
	inst:ListenForEvent("onremove", onremove)
    return inst
end
return Prefab("tz_pipaxingfx", fxfn)
