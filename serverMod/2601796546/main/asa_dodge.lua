--闪避

AddStategraphState("wilson",
	State{
        name = "asa_dodge",
        tags = { "busy", "doing", "nopredict", "canrotate"},

        onenter = function(inst)
			if inst.components.asa_power.pw > 0 then
				inst:AddTag("asa_bolt")
			end
			inst:AddTag("NOCLICK")
			if inst.recovertask then	--清零恢复计数器，并重新计算
				inst.recovertask:Cancel()
				inst.recovertask = nil
			end
			local sks = inst.asa_skills:value()	--降维技能表
			sks = json.decode(sks)
			if sks[2] ~= 0 then
				inst.Physics:ClearCollisionMask()
				inst.Physics:CollidesWith(COLLISION.WORLD)
			end
			inst.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/dodge",nil,0.7)
            inst.components.locomotor:Stop()
			--inst.components.locomotor:Clear()
			inst.AnimState:PlayAnimation("asa_dodge")
			local extra = inst.components.asa_power:GetPercent()*4
			local extra2 = sks[2] ~= 0 and 2 or 0
			inst.Physics:SetMotorVelOverride(22+extra+extra2, 0, 0)
			local t = 0
			inst.shadowtask = inst:DoPeriodicTask(0.12,function()
				t = t + 0.12
				local fx = SpawnPrefab("asa_shadow_fx")
				fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
				fx.Transform:SetRotation(inst.Transform:GetRotation())
				fx.AnimState:SetMultColour(t+0.1, 2*t+0.3, 1, 4*t)
				fx.AnimState:PlayAnimation("asa_dodge")
				--fx.AnimState:SetAddColour(0, 1, 1, 2*t)
				--inst:DoTaskInTime(0.05,function()
				--	fx.AnimState:SetAddColour(0, 0, 0, 0)
				--
				--end)
				fx.AnimState:SetTime(t)
				if sks[11] ~= 0 then
					local weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
					local pos = inst:GetPosition()
					local ents = TheSim:FindEntities(pos.x,pos.y,pos.z,1.4,{"_combat", }, { "playerghost", "INLIMBO", "player","companion","wall" })
					for k,v in pairs(ents)do
						if v and v.components.health and not v.components.health:IsDead() then
							local defence =	v.components.combat and v.components.combat.externaldamagetakenmultipliers and 1 - v.components.combat.externaldamagetakenmultipliers:Get() or 0	--适配加强防御，破甲率67%
							local extra = (1 - defence/3) / (1 - defence)
							local damage = inst.components.combat:CalcDamage(v, weapon, 1/2)
							v.components.combat:GetAttacked(inst, damage * extra, weapon, nil)
						end
					end
				end
			end)
			if inst.components.health and not inst.components.health:IsDead() then
				inst.asa_invincible:set(true)
			end
        end,
		
		timeline = {
			TimeEvent(1 * FRAMES, function(inst)
				if  inst.components.asa_power.pw > 0 and inst.bolttask == nil then
					inst.components.locomotor:SetExternalSpeedMultiplier(inst, "asakiri_bolt", 2.4)
					inst.bolttask = inst:DoPeriodicTask(1,function()
						inst.components.asa_power:DoDelta(-1)
					end, 2.5)
				end
			end),
			TimeEvent(5 * FRAMES, function(inst)
				if inst.recovertask then	--清零恢复计数器，并重新计算
					inst.recovertask:Cancel()
					inst.recovertask = nil
				end
				inst.sg:RemoveStateTag("nopredict")
				local sks = inst.asa_skills:value()	--降维技能表
				sks = json.decode(sks)

				inst.recovertask = inst:DoTaskInTime(5 * FRAMES, function()
					inst.Physics:ClearMotorVelOverride()
					if inst.shadowtask then
						inst.shadowtask:Cancel()
						inst.shadowtask = nil
					end

					if sks[2] ~= 0 then
						if inst.dodgetask then	--清零无敌穿透计数器，并重新计算
							inst.dodgetask:Cancel()
							inst.dodgetask = nil
						end
						local extratime = inst.asa_pw:value() >= 5 and 5 or inst.asa_pw:value()
						inst.dodgetask = inst:DoTaskInTime(extratime * FRAMES,function()
							ChangeToCharacterPhysics(inst)
							if inst.components.health then
								inst.asa_invincible:set(false)
							end
						end)
					else
						if inst.components.health then
							inst.asa_invincible:set(false)
						end
					end
				end)
			end),
			TimeEvent(9 * FRAMES, function(inst)
				--inst.Physics:ClearMotorVelOverride()
				--if  inst.components.asa_power.pw > 0 and inst.bolttask == nil then
				--	inst.components.locomotor:SetExternalSpeedMultiplier(inst, "asakiri_bolt", 2.5)
				--	inst.bolttask = inst:DoPeriodicTask(1,function()
				--		inst.components.asa_power:DoDelta(-1)
				--	end)
				--end
				--inst.Physics:SetMotorVelOverride(8, 0, 0)
				inst.sg:RemoveStateTag("busy")
			end),
		},
		
        events =
        {
            EventHandler("animover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.sg:GoToState("idle")
				end
            end),
        },
		
        onexit = function(inst)
			if inst.shadowtask then
				inst.shadowtask:Cancel()
				inst.shadowtask = nil
			end
			inst:RemoveTag("NOCLICK")
			inst:PushEvent("dodgeend")
		end
    }
)

AddStategraphState("wilson_client", State{
	name = "asa_dodge",
	tags = { "busy", "doing", "canrotate" },
	onenter = function(inst)
		inst.components.locomotor:Stop()
		inst:ClearBufferedAction()
		inst.AnimState:PlayAnimation("asa_dodge")
		
	end,
	timeline = {
		TimeEvent(12 * FRAMES, function(inst)
			inst.sg:RemoveStateTag("busy")
			inst.sg:RemoveStateTag("nomorph")
		end),
	},
	ontimeout = function(inst)
		inst.sg:GoToState("idle")
	end
}
)

--local ASA_DODGE = GLOBAL.Action({ priority=99, instant=true, ghost_valid=false, mount_valid=false, encumbered_valid=true, distance = 666 })
--ASA_DODGE.id = "ASA_DODGE"
--ASA_DODGE.str = GLOBAL.STRINGS.ASA_DODGE
--ASA_DODGE.fn = function(act,pos)
--	local inst = act.doer
--	local sks = inst.asa_skills:value()	--降维技能表
--	sks = json.decode(sks)
--
--	if inst.asa_pw:value() >= 1 then
--		if inst.poweruse:value() == true then
--			inst.poweruse:set(false)
--		else
--			inst.poweruse:set(true)
--		end
--		if inst.maxskill:value() == 0 then
--			if sks[2] ~= 0 then
--				local pos = inst:GetPosition() --闪避制造斩击机会
--				local ents = TheSim:FindEntities(pos.x,pos.y,pos.z,2,{"_combat", }, { "playerghost", "INLIMBO", "player","companion","wall" })
--				for k,v in pairs(ents)do
--					if v and v.components.health and not v.components.health:IsDead() and v.components.combat and v.components.combat.target == inst then
--						v:AddTag("asa_zan")
--						inst:DoTaskInTime(0,function()
--							v.AnimState:SetAddColour(0, 0.3, 0.4, 0.3)
--							v.zanlabel = SpawnPrefab("zan_label")
--							v.zanlabel.AnimState:PlayAnimation("idle_short")
--							v.zanlabel.entity:SetParent(v.entity)
--							if v:HasTag("epic") then
--								if v.components.health.maxhealth > 3000 then
--									v.zanlabel.AnimState:SetScale(1.3,1.3,1.3)
--								else
--									v.zanlabel.AnimState:SetScale(1.2,1.2,1.2)
--								end
--
--							elseif v:HasTag("largecreature") or v.components.health.maxhealth > 400 then
--								v.zanlabel.AnimState:SetScale(1.1,1.1,1.1)
--							end
--						end)
--						inst:DoTaskInTime(1,function()
--							v.AnimState:SetAddColour(0,0,0,0)
--							v:RemoveTag("asa_zan")
--						end)
--					end
--				end
--				inst.components.asa_power:DoDelta(-1)
--			else
--				inst.components.asa_power:DoDelta(-2)
--			end
--		end
--		local pos = act:GetActionPoint()
--		inst:FacePoint(pos:Get())
--		inst.sg:GoToState("asa_dodge")
--	return true
--	end
--end
--AddAction(ASA_DODGE)
--
--AddComponentAction("POINT", "equippable", function(inst, doer, pos, actions, right)
--    if right and inst:HasTag("asa_blade")
--	and not doer:HasTag("playerghost") and not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding())
--	and doer:HasTag("asakiri")
--	and doer.asa_pw and doer.asa_pw:value() >= 1
--	then
--		local dsq = doer:GetDistanceSqToPoint(pos:Get())
--		local sks = doer.asa_skills:value()	--降维技能表
--		sks = json.decode(sks)
--		if dsq < 180 and sks[1] ~= 0 then --距离合适，技能已点，避开冲刺目标
--			table.insert(actions, GLOBAL.ACTIONS.ASA_DODGE)
--		end
--    end
--end)