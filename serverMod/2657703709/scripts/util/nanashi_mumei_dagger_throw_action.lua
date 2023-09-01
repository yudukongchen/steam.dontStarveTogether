local action_string = "Throw Dagger"
if TUNING.NANASHI_MUMEI_LANGUAGE == "JP" then
    action_string = "投げる" 
elseif TUNING.NANASHI_MUMEI_LANGUAGE == "CN" then
    action_string = "扔" -- TODO: Waiting for a proper CN translation
end

local State = GLOBAL.State
local TimeEvent = GLOBAL.TimeEvent
local EventHandler = GLOBAL.EventHandler
local FRAMES = GLOBAL.FRAMES





local MUMEIDAGGERTHROW = AddAction("MUMEIDAGGERTHROW", action_string, function(act)
	if act.invobject then
		local pvp = GLOBAL.TheNet:GetPVPEnabled()
		local target = act.target
		if target == nil then
			local entityPairs = GLOBAL.TheSim:FindEntities(act.pos.x, act.pos.y, act.pos.z, 20) 
			for k,v in pairs(entityPairs) do
				if v.replica and v.replica.combat and v.replica.combat:CanBeAttacked(act.doer) and
				act.doer.replica and act.doer.replica.combat and act.doer.replica.combat:CanTarget(v)
				and (not v:HasTag("wall")) and (pvp or ((not pvp)
						and (not (act.doer:HasTag("player") and v:HasTag("player"))))) then
					target = v
					break
				end
			end
		end
		if target then
            local prefab = act.invobject.prefab
            act.invobject.components.nanashi_mumei_throwable:LaunchProjectile(act.doer, target)
            if TUNING.NANASHI_MUMEI_DAGGER_THROW_AUTO_EQUIP then
                local new_dagger = act.doer.components.inventory:FindItem(
                    function(item) return item.prefab == prefab end)
                if new_dagger then
                    act.doer.components.inventory:Equip(new_dagger)
                end
            end
		elseif act.doer.components and act.doer.components.talker then
			local fail_message = "There's nothing to throw it at."
			act.doer.components.talker:Say(fail_message)
		end
		return true
	end
end)
MUMEIDAGGERTHROW.priority = 4
MUMEIDAGGERTHROW.rmb = true
MUMEIDAGGERTHROW.distance = 10
MUMEIDAGGERTHROW.mount_valid = true

local throw_dagger = State({
    name = "mumei_throw_dagger",
    tags = { "attack", "notalking", "abouttoattack", "autopredict" },

    onenter = function(inst)
        local buffaction = inst:GetBufferedAction()
        local target = buffaction ~= nil and buffaction.target or nil
        inst.components.combat:SetTarget(target)
        inst.components.combat:StartAttack()
        inst.components.locomotor:Stop()

        inst.AnimState:PlayAnimation("throw")
        inst.sg:SetTimeout(2)

        if target ~= nil and target:IsValid() then
            inst:FacePoint(target.Transform:GetWorldPosition())
            inst.sg.statemem.attacktarget = target
        elseif buffaction ~= nil and buffaction.pos ~= nil then
            inst:ClearBufferedAction();
        end
    end,

    timeline =
    {
        TimeEvent(7 * FRAMES, function(inst)
            inst:PerformBufferedAction()
            inst.sg:RemoveStateTag("abouttoattack")
        end),
    },

    ontimeout = function(inst)
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")
    end,

    events =
    {
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)
        inst.components.combat:SetTarget(nil)
        if inst.sg:HasStateTag("abouttoattack") then
            inst.components.combat:CancelAttack()
        end
    end,
})
AddStategraphState("wilson", throw_dagger)

local throw_dagger_client = State({
    name = "mumei_throw_dagger",
    tags = { "attack", "notalking", "abouttoattack" },

    onenter = function(inst)
        local buffaction = inst:GetBufferedAction()
        local target = buffaction ~= nil and buffaction.target or nil
        inst.replica.combat:StartAttack()
        inst.components.locomotor:Stop()

        inst.AnimState:PlayAnimation("throw")

        inst.sg:SetTimeout(2)

        if target ~= nil and target:IsValid() then
            inst:FacePoint(target.Transform:GetWorldPosition())
            inst.sg.statemem.attacktarget = target
        elseif buffaction ~= nil and buffaction.pos ~= nil then
            inst:ClearBufferedAction();
            -- inst:FacePoint(buffaction.pos)
        end
        if buffaction ~= nil then
            inst:PerformPreviewBufferedAction()
        end
    end,

    timeline =
    {
        TimeEvent(7 * FRAMES, function(inst)
            inst:ClearBufferedAction()
            inst.sg:RemoveStateTag("abouttoattack")
        end),
    },

    ontimeout = function(inst)
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")
    end,

    events =
    {
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)
        if inst.sg:HasStateTag("abouttoattack") then
            inst.replica.combat:CancelAttack()
        end
    end,
})
AddStategraphState("wilson_client", throw_dagger_client)

AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(MUMEIDAGGERTHROW, function(inst, action)
	if not inst.sg:HasStateTag("attack") then
		return "mumei_throw_dagger"
	end
end))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(MUMEIDAGGERTHROW, function(inst, action)
	if not inst.sg:HasStateTag("attack") then
		return "mumei_throw_dagger"
	end
end))

local function daggerthrow_point(inst, doer, pos, actions, right)
	if right then
		local target = nil
		local pvp = GLOBAL.TheNet:GetPVPEnabled()
		if RANGE_CHECK then
			for k,v in pairs(GLOBAL.TheSim:FindEntities(pos.x, pos.y, pos.z, 2)) do
				if v.replica and v.replica.combat and v.replica.combat:CanBeAttacked(doer) and
				doer.replica and doer.replica.combat and doer.replica.combat:CanTarget(v)
				and (not v:HasTag("wall")) and (pvp or ((not pvp)
						and (not (doer:HasTag("player") and v:HasTag("player")))))
                and (doer.components.playercontroller:IsControlPressed(GLOBAL.CONTROL_FORCE_ATTACK)
                        or not doer.replica.combat:IsAlly(v)) then
					target = v
					break
				end
			end
		end
		if target then
			table.insert(actions, GLOBAL.ACTIONS.MUMEIDAGGERTHROW)
		end
	end
end
AddComponentAction("POINT", "nanashi_mumei_throwable", daggerthrow_point)

local function daggerthrow_target(inst, doer, target, actions, right)
	local pvp = GLOBAL.TheNet:GetPVPEnabled()
	if right and (not target:HasTag("wall"))
		and doer.replica.combat ~= nil
		and doer.replica.combat:CanTarget(target)
		and target.replica.combat:CanBeAttacked(doer)
		and (pvp or ((not pvp)
					and (not (doer:HasTag("player") and target:HasTag("player")))))
        and (doer.components.playercontroller:IsControlPressed(GLOBAL.CONTROL_FORCE_ATTACK)
                or not doer.replica.combat:IsAlly(target)) then
		table.insert(actions, GLOBAL.ACTIONS.MUMEIDAGGERTHROW)
	end
end
AddComponentAction("EQUIPPED", "nanashi_mumei_throwable", daggerthrow_target)