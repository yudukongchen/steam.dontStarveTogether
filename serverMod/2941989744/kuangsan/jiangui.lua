GLOBAL.setmetatable(env, { __index = function(t, k)
    return GLOBAL.rawget(GLOBAL, k)
end })

local function cannotattack(inst,tag)
	return inst and inst.replica.inventory and inst.replica.inventory:EquipHasTag(tag or "camael_noattack")
end
AddComponentPostInit("playercontroller", function(self)
	local old_attack = self.DoAttackButton
	function self:DoAttackButton(buffaction,...)
		if cannotattack(self.inst) then
			return
		end
		return old_attack(self,buffaction,...)
	end	
	local old_DoControllerAttackButton = self.DoControllerAttackButton
	function self:DoControllerAttackButton(target,...)
		if cannotattack(self.inst) then
			return
		end
		return old_DoControllerAttackButton(self,target,...)
	end	
end)
AddComponentPostInit("temperature", function(self)
	local old_SetTemperature = self.SetTemperature
	function self:SetTemperature(...)
		if cannotattack(self.inst,"camael") then
			return
		end
		return old_SetTemperature(self,...)
	end
end)

local CAMAEL_BIU = GLOBAL.Action({priority = 99,mount_valid = false,distance =32})
CAMAEL_BIU.id = "CAMAEL_BIU"
CAMAEL_BIU.str = "射击"
CAMAEL_BIU.fn = function(act)
	local target = act.target or nil
	local pos = act:GetActionPoint()
	if pos == nil and target then
		pos = target:GetPosition()
	end
	if pos and act.invobject and act.doer and act.invobject.components.camael_skill  then
		act.invobject.components.camael_skill:DoSkill(act.doer,pos)
		return true
	end	
end
AddAction(CAMAEL_BIU) 
AddComponentAction("EQUIPPED", "camael_skill" , function(inst, doer, target, actions, right) 
	if right and inst:HasTag("skill_on") and (doer ~= target) then
		table.insert(actions, ACTIONS.CAMAEL_BIU)
    end
end)
AddComponentAction("POINT", "camael_skill" , function(inst, doer, pos, actions, right, target) 
	if right and inst:HasTag("skill_on") then
		table.insert(actions, ACTIONS.CAMAEL_BIU)
    end
end)
AddStategraphActionHandler("wilson",ActionHandler(ACTIONS.CAMAEL_BIU, "camael_skill"))
AddStategraphActionHandler("wilson_client",ActionHandler(ACTIONS.CAMAEL_BIU, "camael_skill"))

AddStategraphPostInit("wilson", function(sg)
    sg.states["camael_skill"] = State {
        name = "camael_skill",
        tags = { "attack", "notalking","busy","abouttoattack", "autopredict" },
        onenter = function(inst)
			inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("hand_shoot")
            local buffaction = inst:GetBufferedAction()
            if buffaction then   
                local target = buffaction.target or nil
				local pos = buffaction:GetActionPoint()
				if pos == nil and target then
					pos = target:GetPosition()
				end
				if pos then
					inst:ForceFacePoint(pos:Get())
				end
			end
            inst.sg.statemem.speed = 0
        end,
        onupdate = function(inst,dt)
            if inst.sg.statemem.speed > 0 then
                inst.sg.statemem.speed =  inst.sg.statemem.speed - dt
                inst.Physics:SetMotorVel(-inst.sg.statemem.speed,0,0)
            end
        end,
        timeline = {
            TimeEvent(13 * FRAMES, function(inst)
                inst.sg.statemem.speed = 5 --后座力
            end),
            TimeEvent(17 * FRAMES, function(inst)
                inst.sg.statemem.ispaused = true
                inst.AnimState:Pause()
				inst:PerformBufferedAction()
            end),
            TimeEvent(24 * FRAMES/1, function(inst)
                inst.AnimState:Resume()
                inst.sg.statemem.ispaused = false
            end),
            TimeEvent(28 * FRAMES/1, function(inst)
				inst.sg:RemoveStateTag("busy")
            end)
        },
        onexit = function(inst)
            if inst.sg.statemem.ispaused then
                inst.AnimState:Resume()
            end
        end,
        events = {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        }
    }
end)

AddStategraphPostInit("wilson_client", function(sg)
    sg.states["camael_skill"] = State {
        name = "camael_skill",
		tags = { "attack", "notalking","busy","abouttoattack" },
        onenter = function(inst)
            inst.AnimState:PlayAnimation("hand_shoot")
            inst:PerformPreviewBufferedAction()
            inst.components.locomotor:Stop()
            local buffaction = inst:GetBufferedAction()
            if buffaction then   
                local target = buffaction.target or nil
				local pos = buffaction:GetActionPoint()
				if pos == nil and target then
					pos = target:GetPosition()
				end
				if pos then
					inst:ForceFacePoint(pos:Get())
				end
			end
        end,
        timeline = {
            TimeEvent(13 * FRAMES, function(inst)
                inst.AnimState:Pause()
            end),
            TimeEvent(20 * FRAMES/1, function(inst)
                inst.AnimState:Resume()
            end),
            TimeEvent(24 * FRAMES/1, function(inst)
				inst.sg:RemoveStateTag("busy")
            end)
        },
        onexit = function(inst)
			inst.AnimState:Resume()
        end,
        events = {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end)
        }
    }
end)



