--基础API和拔刀闪击

--钢铁意志，从不缴械
AddComponentPostInit("inventory", function(self, inst)
	local OldUnequip = self.Unequip
	function self:Unequip(equipslot, slip)
		if self.inst:HasTag("asakiri") and self.equipslots[equipslot] and self.equipslots[equipslot]:HasTag("asa_blade") and slip then
			return
		end
		return OldUnequip(self, equipslot, slip)
	end
	
	local OldDropItem = self.DropItem
	function self:DropItem(item, wholestack, randomdir, pos)
		if self.inst:HasTag("asakiri") and item and item:HasTag("asa_blade") then
			return
		end
		return OldDropItem(self, item, wholestack, randomdir, pos)
	end
	
end)

--我跑我有型

local function asa_run(self)
	local run = self.states.run
	if run then
		local old_enter = run.onenter
		function run.onenter(inst, ...)
			if old_enter then
				old_enter(inst, ...)
			end
			if inst:HasTag("asakiri")
			and not inst.sg.statemem.riding
			and not inst.sg.statemem.sandstorm
			and not inst.sg.statemem.groggy
			and not inst.sg.statemem.careful then
				if inst:HasTag("asa_bolt") then
					if not inst.AnimState:IsCurrentAnimation("asa_bolt") then
						inst.AnimState:PlayAnimation("asa_bolt", true)
					end
					inst:DoTaskInTime(0.2,function()
						if inst.boltfx == nil and inst:HasTag("asa_bolt") then
							inst.boltfx = inst:DoPeriodicTask(0.21,function()
								local x,y,z = inst.Transform:GetWorldPosition()
								local fx = SpawnPrefab("winona_battery_sparks")
								fx.Transform:SetPosition(x - 0.5 + math.random(), y,z - 0.5 + math.random())
								fx.Transform:SetRotation(inst.Transform:GetRotation() + 90)
								inst.SoundEmitter:PlaySound("moonstorm/creatures/boss/alterguardian1/step", nil, 0.4 + math.random()/3)
							end)
						end
					end)
				else
					if inst.boltfx then
						inst.boltfx:Cancel()
						inst.boltfx = nil
					end
					if inst:HasTag("asa_equipped")  then
						if not inst.AnimState:IsCurrentAnimation("asa_run_loop") then
							inst.AnimState:PlayAnimation("asa_run_loop", true)
						end
					else
						if not inst.AnimState:IsCurrentAnimation("asa_run2_loop") then
							inst.AnimState:PlayAnimation("asa_run2_loop", true)
						end
					end

				end
				inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength() + 0.01)
			end
		end
	end
	local run_start = self.states.run_start
	if run_start then
		local old_enter = run_start.onenter
		function run_start.onenter(inst, ...)
			if old_enter then
				old_enter(inst, ...)
			end
			if inst:HasTag("asakiri")
			and not inst.sg.statemem.riding
			and not inst.sg.statemem.sandstorm
			and not inst.sg.statemem.groggy
			and not inst.sg.statemem.careful then
				if inst:HasTag("asa_equipped") then
					inst.AnimState:PlayAnimation("asa_run_pre")
				else
					inst.AnimState:PlayAnimation("asa_run2_pre")
				end
			end
		end
	end
	local run_stop = self.states.run_stop
	if run_stop then
		local old_enter = run_stop.onenter
		function run_stop.onenter(inst, ...)
			if old_enter then
				old_enter(inst, ...)
			end
			if inst:HasTag("asakiri") then
				if inst.boltfx then
					inst.boltfx:Cancel()
					inst.boltfx = nil
				end
			end
			if inst:HasTag("asakiri")
			and not inst.sg.statemem.riding
			and not inst.sg.statemem.sandstorm
			and not inst.sg.statemem.groggy
			and not inst.sg.statemem.careful then
				if inst:HasTag("asa_equipped") then
					inst.AnimState:PlayAnimation("asa_run_pst")
				else
					inst.AnimState:PlayAnimation("asa_run2_pst")
				end
			end
		end
	end
end

AddStategraphPostInit("wilson", function(sg)
	asa_run(sg)
end)
AddStategraphPostInit("wilson_client", function(sg)
	asa_run(sg)
end)

AddStategraphPostInit("wilson", function(sg)
	local oldOnAttacked = sg.events["attacked"].fn
	sg.events["attacked"] = EventHandler("attacked", function(inst, data, ...)
		if inst:HasTag("asakiri") and inst.maxskill:value() == 2 or inst:HasTag("asa_shielded") then
			return
		end
		return oldOnAttacked(inst,data,...)
	end)
	asa_run(sg)
end)

--多角度平A

local function asa_atk(self)
	local atk = self.states.attack
	if atk then
		local old_enter = atk.onenter
		function atk.onenter(inst, ...)
			if old_enter then
				old_enter(inst, ...)
			end
			if inst:HasTag("asakiri") and inst:HasTag("asa_equipped") then
				inst.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/atk1")
				if math.random() > 0.65 then
					inst.AnimState:PlayAnimation("asa_atk1_pre")
					inst.AnimState:PushAnimation("asa_atk1",false)
				elseif math.random() > 0.3 then
					inst.AnimState:PlayAnimation("asa_atk2_pre")
					inst.AnimState:PushAnimation("asa_atk2",false)
				end
			end
		end
	end
end
AddStategraphPostInit("wilson", function(sg)
	asa_atk(sg)
end)
AddStategraphPostInit("wilson_client", function(sg)
	asa_atk(sg)
end)

--拔刀，入鞘

AddStategraphState("wilson",
	State{
        name = "asa_arm",
        tags = { "idle", "nodangle" },

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
			inst.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/equip")
			if inst.asa_blade2:value() then
				inst.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/equip2")
			end
            inst.AnimState:PlayAnimation("asa_equip")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    }
)

AddStategraphState("wilson_client",
	State{
        name = "asa_arm",
        tags = { "idle", "nodangle" },

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
			inst.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/equip")
            inst.AnimState:PlayAnimation("asa_equip")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    }
)

AddStategraphState("wilson",
	State{
        name = "asa_disarm",
        tags = { "idle", "nodangle"},

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("asa_unequip",false)
			inst.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/unequip")
			--inst.sg.statemem.action = inst.bufferedaction
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    --inst:PerformBufferedAction()
					inst.sg:GoToState("idle")
					
                end
            end),
        },

        onexit = function(inst)
            --inst:ClearBufferedAction()
			if inst:HasTag("asa_equipped1") then
				inst:RemoveTag("asa_equipped1")
			end
			inst.components.inventory:Unequip(EQUIPSLOTS.HANDS)
        end,
    }
)

AddStategraphState("wilson_client",
	State{
        name = "asa_disarm",
        tags = { "idle", "nodangle" },

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("asa_unequip",false)
			--inst.AnimState:PushAnimation("item_in",false)
			--inst.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/unequip")
			--inst:PerformPreviewBufferedAction()
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
					inst.sg:GoToState("idle")
                end
            end),
        },

        -- onexit = function(inst)
            -- inst:ClearBufferedAction()
        -- end,
    }
)

local function asa_arm(self)
	local arm = self.states.item_out
	if arm then
		local old_enter = arm.onenter
		function arm.onenter(inst, ...)
			if old_enter then
				old_enter(inst, ...)
			end
			if inst:HasTag("asakiri") and inst.components.inventory:EquipHasTag("asa_blade") then
				inst.sg:GoToState("asa_arm")
				--inst:PerformBufferedAction()
			end
		end
	end
end

AddStategraphPostInit("wilson", function(sg)
	asa_arm(sg)
end)

local ASA_EQUIP = GLOBAL.Action({priority=98, instant=true, ghost_valid=false, mount_valid=false, encumbered_valid=true })
ASA_EQUIP.id = "ASA_EQUIP"
ASA_EQUIP.str = GLOBAL.STRINGS.ASA_EQUIP
ASA_EQUIP.fn = function(act)
	if act.doer.asa_blade2:value() then
		local w = SpawnPrefab("asa_blade2_item")
		act.doer.components.inventory:Equip(w)
	else
		local w = SpawnPrefab("asa_blade")
		act.doer.components.inventory:Equip(w)
	end
	act.doer.customidleanim = "asa_wipe"
	return true
end
AddAction(ASA_EQUIP)

local ASA_UNEQUIP = GLOBAL.Action({ priority=99, instant=true, ghost_valid=false, mount_valid=false, encumbered_valid=true })
ASA_UNEQUIP.id = "ASA_UNEQUIP"
ASA_UNEQUIP.str = GLOBAL.STRINGS.ASA_UNEQUIP
ASA_UNEQUIP.fn = function(act)
	--act.doer.components.inventory:Unequip(EQUIPSLOTS.HANDS)
	--act.doer.customidleanim = nil
	act.doer.sg:GoToState("asa_disarm")
	return true
end
AddAction(ASA_UNEQUIP)

AddComponentAction("SCENE", "asa_equip", function(inst, doer, actions, right)
    if right and (inst == ThePlayer or TheWorld.ismastersim) and inst == doer
	and not inst:HasTag("playerghost") and not (inst.replica.rider ~= nil and inst.replica.rider:IsRiding())
	and not (inst.AnimState:IsCurrentAnimation("asa_run_pre")
			or inst.AnimState:IsCurrentAnimation("asa_run_loop")
			or inst.AnimState:IsCurrentAnimation("asa_run_pst"))
	and not (inst.components.mk_flyer and inst.components.mk_flyer._isflying:value())
			then
		if inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) and inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS):HasTag("asa_blade")
		and not inst.AnimState:IsCurrentAnimation("asa_unequip") then
			if not inst:HasTag("asa_avoid") then
				table.insert(actions, GLOBAL.ACTIONS.ASA_UNEQUIP)
			end
		else
			table.insert(actions, GLOBAL.ACTIONS.ASA_EQUIP)
		end
    end
end)

--闪击

AddStategraphState("wilson",
	State{
        name = "asa_dash",
        tags = { "idle", "nodangle","dash" },

        onenter = function(inst)
            --inst.components.locomotor:StopMoving()
			inst.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/lunge1")
            inst.AnimState:PlayAnimation("lunge_pst")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    }
)


local BEAVERVISION_COLOURCUBES =
{
    day = "images/colour_cubes/snow_cc.tex",
    dusk = "images/colour_cubes/snow_cc.tex",
    night = "images/colour_cubes/snow_cc.tex",
    full_moon = "images/colour_cubes/snow_cc.tex",
}

AddStategraphState("wilson_client",
	State{
        name = "asa_dash",
        tags = { "idle", "nodangle", "dash" },

        onenter = function(inst)
			inst.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/lunge1")
            inst.AnimState:PlayAnimation("lunge_pst")
			
			inst:PerformPreviewBufferedAction()
			--inst.sg:SetTimeout(2)
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
		
		ontimeout = function(inst)
			inst:DoTaskInTime(0.25,function()
				ThePlayer.components.playervision:SetCustomCCTable(nil)
			end)
			inst.sg:GoToState("idle")
		end
    }
)


local ASA_DASH = GLOBAL.Action({ priority=98, instant=true, ghost_valid=false, mount_valid=false, encumbered_valid=true, distance = 666 })
ASA_DASH.id = "ASA_DASH"
ASA_DASH.str = GLOBAL.STRINGS.ASA_DASH
ASA_DASH.fn = function(act)
	local inst = act.doer
	local target = act.target
	
	local sks = inst.asa_skills:value()	--降维技能表
	sks = json.decode(sks)
	local pw = inst.components.asa_power:Get()
	--反复横跳，触发光环
	if inst.poweruse:value() == true then
		inst.poweruse:set(false)
	else
		inst.poweruse:set(true)
	end
	if inst.maxskill:value() == 0 then
		inst.components.asa_power:DoDelta(-6)
	end
	local x, y, z = inst.Transform:GetWorldPosition()
	local x1, y1, z1 = target.Transform:GetWorldPosition()
	local x2 = (9 * x1 + x)/10
	local y2 = (9 * y1 + y)/10
	local z2 = (9 * z1 + z)/10
	local pw1 = pw >= 6 and 6 or pw
	
	local weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	local damage = pw1 * inst.components.combat:CalcDamage(target, weapon, 2/3)	--加上BUFF
	
	inst.Transform:SetPosition(x2,y2,z2)
	for i=1,5,1 do
		if i == 5 then
			local fx = SpawnPrefab("electrichitsparks")
			fx.Transform:SetPosition(x1,y1,z1)
		else
			--追随尾电
			local fx = SpawnPrefab("asa_lightning")
			fx.Transform:SetPosition( x+(x1-x)*i/5 , y+(y1-y)*i/5+0.5 , z+(z1-z)*i/5 )
			fx.Transform:SetScale((i+math.random())/5,(i+math.random())/5,(i+math.random())/5)
			fx:FacePoint(x1,y1,z1)
			fx.AnimState:SetTime(math.random(0,7) * FRAMES)
			--尾电伤害
			local pos = fx:GetPosition()
			local ents1 = TheSim:FindEntities(pos.x,pos.y,pos.z,i*0.5,{"_combat", }, { "abigail", "playerghost", "INLIMBO", "player","companion","wall" })
			for k,v in pairs(ents1)do
				if v and v.components.health and not v.components.health:IsDead() then
					v.components.combat:GetAttacked(inst,damage/6,nil,nil)
				end
			end
		end
	end
	
	local defence =	target.components.combat.externaldamagetakenmultipliers and 1 - target.components.combat.externaldamagetakenmultipliers:Get() or 0	--适配加强防御，破甲率67%
	local extra = (1 - defence/3) / (1 - defence)
	--造成伤害，无害小动物仅仅只受到1/4
	if target.components.combat then
		if target:HasTag("smallcreature") and not target:HasTag("hostile") then
			target.components.combat:GetAttacked(inst,damage * extra/4,nil,nil)
		else
			target.components.combat:GetAttacked(inst,damage * extra,nil,nil)
			if target:HasTag("asa_zan") then
				target.components.combat:GetAttacked(inst,68 * extra,nil,nil)
				target:RemoveTag("asa_zan")
				target.AnimState:SetAddColour(0, 0, 0, 0)
			end
		end
	end
	inst.sg:GoToState("asa_dash")
	ShakeAllCameras(CAMERASHAKE.VERTICAL, 0.3, 0.06, 1.5, inst, 0.2)
	
	if sks[10] ~= 0 then	--重锤，短暂无敌，锤头可是硬的！还有冲击波！
		if inst.components.health then
			inst.asa_invincible:set(true)
		end
		inst:DoTaskInTime(1.2,function()
			if inst.components.health then
			inst.asa_invincible:set(false)
		end
		end)
		local pos1 = target:GetPosition()
		local ents = TheSim:FindEntities(pos1.x,pos1.y,pos1.z,2,{"_combat", }, { "abigail", "playerghost", "INLIMBO", "player","companion","wall" })
		for k,v in pairs(ents)do
			if v and v.components.health and not v.components.health:IsDead() then
				v.components.combat:GetAttacked(inst,damage/4 + 25)	--三级满能量可以把蜘蛛打残
			end
		end
	end
	if sks[8] ~= 0 and pw1 >= 3 then --击晕斩需要前置技能条件震击，且能量充足（大于3）
		if target.sg ~= nil and target.sg:HasState("hit")	
		and target.components.health ~= nil and not target.components.health:IsDead()
		and not target.sg:HasStateTag("transform")
		and not target.sg:HasStateTag("nointerrupt") 
		and not target.sg:HasStateTag("frozen")
		or (target.prefab == "spiderqueen" and target.components.health ~= nil and not target.components.health:IsDead())
		
		then
			-- 屏幕蓝光
			inst._zanvision:set(inst._zanvision:value() + 1)
			inst:DoTaskInTime(1,function()
				inst._zanvision:set(inst._zanvision:value() - 1)
			end)
			inst.components.playervision:SetCustomCCTable(BEAVERVISION_COLOURCUBES)
			target:AddTag("asa_zan")
			-- 一些过滤
			inst:AddTag("asa_avoid")
			inst:AddTag("NOCLICK")
			target.AnimState:SetAddColour(0, 0.3, 0.4, 0.3)
			-- 关键的斩字
			inst:DoTaskInTime(0.1,function()
				target.zanlabel = SpawnPrefab("zan_label")
				target.zanlabel.AnimState:PlayAnimation("idle_short")
				target.zanlabel.entity:SetParent(target.entity)
				if target:HasTag("epic") then
					if target.components.health.maxhealth > 3000 then
						target.zanlabel.AnimState:SetScale(1.3,1.3,1.3)
					else 
						target.zanlabel.AnimState:SetScale(1.2,1.2,1.2)
					end
					
				elseif target:HasTag("largecreature") or target.components.health.maxhealth > 400 then
					target.zanlabel.AnimState:SetScale(1.1,1.1,1.1)
				end
			end)
			-- 连续僵直
			inst:DoTaskInTime(0.3,function()
				if target.sg ~= nil and target.sg:HasState("hit")
				and target.components.health ~= nil and not target.components.health:IsDead()
				and not target.sg:HasStateTag("transform")
				and not target.sg:HasStateTag("nointerrupt")
				and not target.sg:HasStateTag("frozen")
				and not target.sg:HasStateTag("hiding")--石虾缩壳
				then
					target.sg:GoToState("hit")
				end
			end)
			
			inst:DoTaskInTime(0.6,function()
				if target.sg ~= nil and target.sg:HasState("hit")
				and target.components.health ~= nil and not target.components.health:IsDead()
				and not target.sg:HasStateTag("transform")
				and not target.sg:HasStateTag("nointerrupt")
				and not target.sg:HasStateTag("frozen")
				and not target.sg:HasStateTag("hiding")--石虾缩壳
				then
					target.sg:GoToState("hit")
				end
			end)
			
			if target:HasTag("epic") then --巨型生物更快恢复
				inst:DoTaskInTime(0.9,function()
					target.AnimState:SetAddColour(0, 0, 0, 0)
					target:RemoveTag("asa_zan")
					if target.sg ~= nil and target.sg:HasState("hit")
					and target.components.health ~= nil and not target.components.health:IsDead()
					and not target.sg:HasStateTag("transform")
					and not target.sg:HasStateTag("nointerrupt")
					and not target.sg:HasStateTag("frozen")
					and not target.sg:HasStateTag("hiding")
					then
						target.sg:GoToState("hit")
					end
				end)
			else
				inst:DoTaskInTime(0.9,function()
					if target.sg ~= nil and target.sg:HasState("hit")
					and target.components.health ~= nil and not target.components.health:IsDead()
					and not target.sg:HasStateTag("transform")
					and not target.sg:HasStateTag("nointerrupt")
					and not target.sg:HasStateTag("frozen")
					and not target.sg:HasStateTag("hiding")
					then
						target.sg:GoToState("hit")
					end
				end)
				inst:DoTaskInTime(1.2,function()
					target.AnimState:SetAddColour(0, 0, 0, 0)
					target:RemoveTag("asa_zan")
					if target.sg ~= nil and target.sg:HasState("hit")
					and target.components.health ~= nil and not target.components.health:IsDead()
					and not target.sg:HasStateTag("transform")
					and not target.sg:HasStateTag("nointerrupt")
					and not target.sg:HasStateTag("frozen")
					and not target.sg:HasStateTag("hiding")
					then
						target.sg:GoToState("hit")
					end
				end)
			end
			-- 人物恢复常态，去掉过滤标签
			inst:DoTaskInTime(1.4,function()
				inst:RemoveTag("asa_avoid")
				inst:RemoveTag("NOCLICK")
			end)
		end
	else	--无震击，普通屏幕蓝光
		inst._zanvision:set(inst._zanvision:value() + 1)
		inst:DoTaskInTime(0.15,function()
			inst._zanvision:set(inst._zanvision:value() - 1)
		end)
	end
	return true
end
AddAction(ASA_DASH)

AddComponentAction("SCENE", "health", function(inst, doer, actions, right)
    if right and inst:HasTag("_combat") and not inst:HasTag("companion") and not inst:HasTag("playerghost") and not inst:HasTag("player") and doer:HasTag("asakiri") and not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding())
	and doer.replica.asa_power:Get() >= 1 and doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) and doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS):HasTag("asa_blade")
	and not (doer:HasTag("asa_avoid") and inst:GetDistanceSqToInst(doer) < 90)
	then
		local sks = doer.asa_skills:value()	--降维技能表
		sks = json.decode(sks)
		local hp = inst:GetPosition()
		local pt = doer:GetPosition()
		local dsq = distsq(hp, pt)
		if dsq <= 180 and dsq > 4 and sks[7] ~= 0 then --距离合适，技能已点
			if inst:HasTag("shadowcreature") then
				if doer.replica.combat:CanTarget(inst) then
					--print(1)
					table.insert(actions, GLOBAL.ACTIONS.ASA_DASH)
				end
			else
				--print(2)
				table.insert(actions, GLOBAL.ACTIONS.ASA_DASH)
			end
		end
    end
end)

