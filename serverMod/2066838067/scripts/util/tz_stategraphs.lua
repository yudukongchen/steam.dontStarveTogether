local function ServerChargePreEnter(inst)
	local buffaction = inst:GetBufferedAction()
	local target = buffaction ~= nil and buffaction.target or nil
	inst.components.combat:SetTarget(target)
	inst.components.combat:StartAttack()
	inst.components.combat:BattleCry()

	if not inst.components.tz_weaponcharge:IsComplete() then 
		inst.components.tz_weaponcharge:Start()
	end
end

-- data:
-- 	last_anim
-- 	attack_sg_name
local function ServerChargePreUpdate(inst,data)
	local buffaction = inst:GetBufferedAction()
	local target = buffaction ~= nil and buffaction.action == ACTIONS.ATTACK and buffaction.target or nil

	if not inst.sg:HasStateTag("moving") then 
		if target ~= nil and target:IsValid() then
			inst:ForceFacePoint(target.Transform:GetWorldPosition())
		end
	end
	

	if not inst.components.tz_weaponcharge:AtkPressed(buffaction and buffaction.action == ACTIONS.TZ_FREE_CHARGE) 
		and (inst.AnimState:IsCurrentAnimation(data.last_anim)) then 
		local complete = inst.components.tz_weaponcharge:IsComplete()
		inst.sg:GoToState(data.attack_sg_name,{complete = complete})
	end
end

-- data:
-- 	last_anim
-- 	attack_sg_name
local function ClientChargePreUpdate(inst,data)
	local buffaction = inst:GetBufferedAction()
	local target = buffaction ~= nil and buffaction.action == ACTIONS.ATTACK and buffaction.target or nil
	
	if not inst.sg:HasStateTag("moving") then 
		if target ~= nil and target:IsValid() then
			inst:ForceFacePoint(target.Transform:GetWorldPosition())
		else
			inst:ForceFacePoint(TheInput:GetWorldPosition():Get())
		end
	end

	local is_free_charge = buffaction and buffaction.action == ACTIONS.TZ_FREE_CHARGE
	if not inst.replica.tz_weaponcharge:AtkPressed(is_free_charge) 
		and (inst.AnimState:IsCurrentAnimation(data.last_anim)) then 
		inst:PerformPreviewBufferedAction()
		inst.sg:GoToState(data.attack_sg_name)
	end
end


local function ServerAttackEnter(inst)
	local buffaction = inst:GetBufferedAction()
	local target = buffaction ~= nil and buffaction.target or nil
	inst.components.combat:SetTarget(target)
	inst.components.combat:StartAttack()
	inst.components.locomotor:Stop()

	if target ~= nil then
		inst.components.combat:BattleCry()
		if target:IsValid() then
			inst:FacePoint(target:GetPosition())
			inst.sg.statemem.attacktarget = target
		end
	end

	return target
end

local function ClientAttackEnter(inst)
	local buffaction = inst:GetBufferedAction()
	if inst.replica.combat ~= nil then
		if inst.replica.combat:InCooldown() then
			inst.sg:RemoveStateTag("abouttoattack")
			inst:ClearBufferedAction()
			inst.sg:GoToState("idle", true)
			return false
		end
		inst.replica.combat:StartAttack()
	end

	inst.components.locomotor:Stop()

	if buffaction ~= nil then
		inst:PerformPreviewBufferedAction()

		if buffaction.target ~= nil and buffaction.target:IsValid() then
			inst:FacePoint(buffaction.target:GetPosition())
			inst.sg.statemem.attacktarget = buffaction.target
		end

		return buffaction.target
	end
end


return {

	ServerChargePreEnter = ServerChargePreEnter,
	ServerChargePreUpdate = ServerChargePreUpdate,

	ClientChargePreUpdate = ClientChargePreUpdate,

	ServerAttackEnter = ServerAttackEnter,
	ClientAttackEnter = ClientAttackEnter,
}