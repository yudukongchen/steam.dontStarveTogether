--弹反

--感谢花花和风铃草各位大佬！
local upvaluehelper = require "components/asa_upvaluehelper"

--反斩sg
AddStategraphState("wilson",
	State{
        name = "asa_zan",
        tags = { "idle", "nodangle","doing", "nomorph", "canrotate"},

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
			inst.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/zan1")
			inst.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/zan2")
			if inst.maxskill:value() == 1 then
				inst.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/upgrade2",nil,0.6)
			end
			if math.random() < 0.33 then --1
				if not inst.AnimState:IsCurrentAnimation("asa_zan1") then
					inst.AnimState:PlayAnimation("asa_zan1")
				else
					if math.random() < 0.5 then
						inst.AnimState:PlayAnimation("asa_zan2")
					else
						inst.AnimState:PlayAnimation("asa_zan3")
					end
				end
			elseif math.random() < 0.67 then --2
				if not inst.AnimState:IsCurrentAnimation("asa_zan2") then
					inst.AnimState:PlayAnimation("asa_zan2")
				else
					if math.random() < 0.5 then
						inst.AnimState:PlayAnimation("asa_zan1")
					else
						inst.AnimState:PlayAnimation("asa_zan3")
					end
				end
			else --3
				if not inst.AnimState:IsCurrentAnimation("asa_zan3") then
					inst.AnimState:PlayAnimation("asa_zan3")
				else
					if math.random() < 0.5 then
						inst.AnimState:PlayAnimation("asa_zan1")
					else
						inst.AnimState:PlayAnimation("asa_zan2")
					end
				end
			end
		end,
		
		-- timeline = {
			-- TimeEvent(1 * FRAMES, function(inst)
				-- inst.sg:RemoveStateTag("busy")
			-- end),
		-- },
		
        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() and not inst.components.health:IsDead() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    }
)

AddStategraphState("wilson_client",
	State{
        name = "asa_zan",
        tags = { "idle","doing", "canrotate"},

        onenter = function(inst)
            --inst.components.locomotor:StopMoving()
			--inst.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/equip")
            if math.random() < 0.33 then --1
				if not inst.AnimState:IsCurrentAnimation("asa_zan1") then
					inst.AnimState:PlayAnimation("asa_zan1")
				else
					if math.random() < 0.5 then
						inst.AnimState:PlayAnimation("asa_zan2")
					else
						inst.AnimState:PlayAnimation("asa_zan3")
					end
				end
			elseif math.random() < 0.67 then --2
				if not inst.AnimState:IsCurrentAnimation("asa_zan2") then
					inst.AnimState:PlayAnimation("asa_zan2")
				else
					if math.random() < 0.5 then
						inst.AnimState:PlayAnimation("asa_zan1")
					else
						inst.AnimState:PlayAnimation("asa_zan3")
					end
				end
			else --3
				if not inst.AnimState:IsCurrentAnimation("asa_zan3") then
					inst.AnimState:PlayAnimation("asa_zan3")
				else
					if math.random() < 0.5 then
						inst.AnimState:PlayAnimation("asa_zan1")
					else
						inst.AnimState:PlayAnimation("asa_zan2")
					end
				end
			end
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() and not inst.replica.health:IsDead() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    }
)

--反斩动作，有两种，标签和本体
local ASA_ZAN1 = GLOBAL.Action({ priority=99, instant=true, ghost_valid=false, mount_valid=false, encumbered_valid=true, distance = 666 })
ASA_ZAN1.id = "ASA_ZAN1"
ASA_ZAN1.str = GLOBAL.STRINGS.ASA_CUT
ASA_ZAN1.fn = function(act)
	local owner = act.target.entity:GetParent() or nil
	local doer = act.doer
	if owner then
		if not (doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) and doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS):HasTag("asa_blade")) then
			if doer.asa_blade2:value() then
				local w = SpawnPrefab("asa_blade2_item")
				doer.components.inventory:Equip(w)
			else
				local w = SpawnPrefab("asa_blade")
				doer.components.inventory:Equip(w)
			end
		end
		
		if owner.components.combat then
			local weapon = doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			local defence =	owner.components.combat.externaldamagetakenmultipliers and 1 - owner.components.combat.externaldamagetakenmultipliers:Get() or 0	--适配加强防御，破甲率67%
			local extra = (1 - defence/3) / (1 - defence)
			
			if inst.maxskill:value() == 1 then
				local damage2 = doer.components.combat:CalcDamage(owner, weapon, 7/6)
				owner.components.combat:GetAttacked(doer, damage2 * extra, weapon, nil)
			else
				local damage1 = doer.components.combat:CalcDamage(owner, weapon, 1)
				owner.components.combat:GetAttacked(doer, damage1 * extra, weapon, nil)
			end
		end
		doer:ShakeCamera(CAMERASHAKE.VERTICAL, 0.1, 0.02, 0.3, 1)
		SpawnPrefab("zan_light").Transform:SetPosition(owner.Transform:GetWorldPosition())
		local pos = owner:GetPosition()
		doer:ForceFacePoint(pos:Get())
		if not doer.components.health:IsDead() then
		    doer.sg:GoToState("asa_zan",pos.x,0,pos.z)
		end
	end
	return true
end
AddAction(ASA_ZAN1)

local ASA_ZAN2 = GLOBAL.Action({ priority = 99 , canforce=true, instant=true, ghost_valid=false, mount_valid=false, encumbered_valid=true, distance = 666 })
ASA_ZAN2.id = "ASA_ZAN2"
ASA_ZAN2.str = GLOBAL.STRINGS.ASA_CUT
ASA_ZAN2.fn = function(act)
	local owner = act.target
	local doer = act.doer
	if owner then
		if not (doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) and doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS):HasTag("asa_blade")) then
			if doer.asa_blade2:value() then
				local w = SpawnPrefab("asa_blade2_item")
				doer.components.inventory:Equip(w)
			else
				local w = SpawnPrefab("asa_blade")
				doer.components.inventory:Equip(w)
			end
		end
		
		if owner.components.combat then
			local weapon = doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			local defence =	owner.components.combat.externaldamagetakenmultipliers and 1 - owner.components.combat.externaldamagetakenmultipliers:Get() or 0	--适配加强防御，破甲率67%
			local extra = (1 - defence/3) / (1 - defence)
			
			if doer.maxskill:value() == 1 then
				local damage2 = doer.components.combat:CalcDamage(owner, weapon, 7/6)
				owner.components.combat:GetAttacked(doer, damage2 * extra, weapon, nil)
			else
				local damage1 = doer.components.combat:CalcDamage(owner, weapon, 1)
				owner.components.combat:GetAttacked(doer, damage1 * extra, weapon, nil)
			end
		end
		doer:ShakeCamera(CAMERASHAKE.VERTICAL, 0.1, 0.02, 0.3, 1)
		SpawnPrefab("zan_light").Transform:SetPosition(owner.Transform:GetWorldPosition())
		local pos = owner:GetPosition()
		doer:ForceFacePoint(pos:Get())
		if not doer.components.health:IsDead() then
            doer.sg:GoToState("asa_zan",pos.x,0,pos.z)
        end
	end
	return true
end
AddAction(ASA_ZAN2)

--反斩动作点击判定

AddComponentAction("SCENE", "asa_zanlabel", function(inst, doer, actions)
    if doer:HasTag("asakiri") and not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding()) then
		local target = inst.entity:GetParent() or nil
		if target and
		--doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) and doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).prefab == "asa_blade" and
		(target and target:GetDistanceSqToInst(doer) < 60)
		--and doer.replica.asa_power:Get() > 0
		then
			table.insert(actions, GLOBAL.ACTIONS.ASA_ZAN1)
		end
    end
end)

AddComponentAction("SCENE", "combat", function(inst, doer, actions)
    if doer:HasTag("asakiri") and not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding()) then
		-- 搜索脚下拥有斩标签且为父子
		local pos = inst:GetPosition()
		local ents = TheSim:FindEntities(pos.x,pos.y,pos.z,0)
		local zanable = false
		for k,v in pairs (ents) do
			if v.prefab == "zan_label" and v.entity:GetParent() == inst then
				zanable = true
				break
			end
		end
		-- 这里让沙袋作为测试
		if inst and inst:GetDistanceSqToInst(doer) < 60 and (zanable or inst.prefab == "dummytarget" or (doer.maxskill and doer.maxskill:value() == 1 and not inst:HasTag("player")))
		then
			table.insert(actions, GLOBAL.ACTIONS.ASA_ZAN2)
		end
    end
end)

--格挡

local function IsWeaponEquipped(inst, weapon)
    return weapon ~= nil
        and weapon.components.equippable ~= nil
        and weapon.components.equippable:IsEquipped()
        and weapon.components.inventoryitem ~= nil
        and weapon.components.inventoryitem:IsHeldBy(inst)
end

local function DoTalkSound(inst)
    if inst.talksoundoverride ~= nil then
        inst.SoundEmitter:PlaySound(inst.talksoundoverride, "talk")
        return true
    elseif not inst:HasTag("mime") then
        inst.SoundEmitter:PlaySound((inst.talker_path_override or "dontstarve/characters/")..(inst.soundsname or inst.prefab).."/talk_LP", "talk")
        return true
    end
end

local function StopTalkSound(inst, instant)
    if not instant and inst.endtalksound ~= nil and inst.SoundEmitter:PlayingSound("talk") then
        inst.SoundEmitter:PlaySound(inst.endtalksound)
    end
    inst.SoundEmitter:KillSound("talk")
end

local function GetUnequipState(inst, data)
    return (inst:HasTag("wereplayer") and "item_in")
        or (data.eslot ~= EQUIPSLOTS.HANDS and "item_hat")
        or (not data.slip and "item_in")
        or (data.item ~= nil and data.item:IsValid() and "tool_slip")
        or "toolbroke"
        , data.item
end

AddStategraphState('wilson',
    State{
        name = "asa_parry_pre",
        tags = { "preparrying", "busy", "nomorph" },

        onenter = function(inst)
			inst.asaparry:set(true)
			if inst.powertask then
				inst.powertask:Cancel()
				inst.powertask = nil
			end
			if inst.maxskill:value() == 0 then
				if inst.components.asa_power.maxpw == 1 then
					inst.powertask = inst:DoPeriodicTask(1,function()
						inst.components.asa_power:DoDelta(-1)
                        --inst.poweruse:set(true)
					end, 1)
				else
					inst.powertask = inst:DoPeriodicTask(1,function()
						inst.components.asa_power:DoDelta(-1)
                        --inst.poweruse:set(true)
					end)
				end
			end
			inst:PushEvent("asa_parry")
			-- inst.cdtask = inst:DoPeriodicTask(0.1,function()
				-- inst.components.asa_power.cd = inst.components.asa_power.maxcd
			-- end)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("parry_pre")
            inst.AnimState:PushAnimation("parry_loop", true)
            inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())

            local function oncombatparry(inst, data)
                inst.sg:AddStateTag("parrying")
                if data ~= nil then
                    if data.direction ~= nil then
                        inst.Transform:SetRotation(data.direction)
                    end
                    inst.sg.statemem.parrytime = data.duration
                    inst.sg.statemem.item = data.weapon
                    if data.weapon ~= nil then
                        inst.components.combat.redirectdamagefn = function(inst, attacker, damage, weapon, stimuli)
                            return IsWeaponEquipped(inst, data.weapon)
                                and data.weapon.components.asa_parry ~= nil
								and data.weapon.components.asa_parry:TryParry(inst, attacker, damage, weapon, stimuli)
                                and data.weapon
                                or nil
                        end
                    end
                end
            end
            inst:ListenForEvent("asa_combat_parry", oncombatparry)
			local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) 
			if equip ~= nil and equip.components.asa_parry ~= nil then
				local direction = inst.Transform:GetRotation()
				inst:PushEvent("asa_combat_parry",{duration = 100, weapon = equip ,direction = direction})
			end
            inst:RemoveEventCallback("asa_combat_parry", oncombatparry)
        end,

        events =
        {
            EventHandler("ontalk", function(inst)
                if inst.sg.statemem.talktask ~= nil then
                    inst.sg.statemem.talktask:Cancel()
                    inst.sg.statemem.talktask = nil
                    StopTalkSound(inst, true)
                end
                if DoTalkSound(inst) then
                    inst.sg.statemem.talktask =
                        inst:DoTaskInTime(1.5 + math.random() * .5,
                            function()
                                inst.sg.statemem.talktask = nil
                                StopTalkSound(inst)
                            end)
                end
            end),
            EventHandler("donetalking", function(inst)
                if inst.sg.statemem.talktalk ~= nil then
                    inst.sg.statemem.talktask:Cancel()
                    inst.sg.statemem.talktask = nil
                    StopTalkSound(inst)
                end
            end),
            EventHandler("unequip", function(inst, data)
                inst.sg:GoToState(GetUnequipState(inst, data))
            end),
			
			EventHandler("asa_powerdown", function(inst, data)
				if inst.powertask then
					inst.powertask:Cancel()
					inst.powertask = nil
				end
            end),
        },

        ontimeout = function(inst)
            if not inst.components.health:IsDead() then
                if inst.sg:HasStateTag("parrying") then
                    inst.sg.statemem.parrying = true
                    local talktask = inst.sg.statemem.talktask
                    inst.sg.statemem.talktask = nil
                    inst.sg:GoToState("asa_parry_idle", { duration = inst.sg.statemem.parrytime, pauseframes = 30, talktask = talktask })
                else
                    inst.AnimState:PlayAnimation("parry_pst")
                    inst.sg:GoToState("idle")
                end
            end
        end,

        onexit = function(inst)
			if inst.attackertask then
				inst.attackertask = nil
			end
            if inst.sg.statemem.talktask ~= nil then
                inst.sg.statemem.talktask:Cancel()
                inst.sg.statemem.talktask = nil
                StopTalkSound(inst)
            end
            if not inst.sg.statemem.parrying then
                inst.components.combat.redirectdamagefn = nil
            end
        end,
    }
)

AddStategraphState('wilson_client',
    State{
        name = "asa_parry_pre",
        tags = { "preparrying", "busy"},
		
        onenter = function(inst)
			inst:PushEvent("asa_parry")
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("parry_pre")
            inst.AnimState:PushAnimation("parry_loop", true)

            inst:PerformPreviewBufferedAction()
            inst.sg:SetTimeout(TIMEOUT)
        end,

        onupdate = function(inst)
            if inst:HasTag("busy") then
                if inst.entity:FlattenMovementPrediction() and not inst.replica.health:IsDead() then
                    inst.sg:GoToState("idle", "noanim")
                end
            elseif inst.bufferedaction == nil then
                inst.AnimState:PlayAnimation("parry_pst")
                if not inst.replica.health:IsDead() then
                    inst.sg:GoToState("idle")
                end
            end
        end,

        ontimeout = function(inst)
            inst:ClearBufferedAction()
            inst.AnimState:PlayAnimation("parry_pst")
            if not inst.replica.health:IsDead() then
                inst.sg:GoToState("idle")
            end
        end,
		
		onexit = function(inst)
        end,
    }
)

AddStategraphState('wilson',
    State{
        name = "asa_parry_idle",
        tags = { "notalking", "parrying", "nomorph", "nopredict"},

        onenter = function(inst, data)
			if inst.powertask then
				inst.powertask:Cancel()
				inst.powertask = nil
			end
			
			if inst.maxskill:value() == 0 then
				if inst.components.asa_power.maxpw == 1 then
					inst.powertask = inst:DoPeriodicTask(1,function()
						inst.components.asa_power:DoDelta(-1)
                        --inst.poweruse:set(true)
					end, 1)
				else
					inst.powertask = inst:DoPeriodicTask(1,function()
						inst.components.asa_power:DoDelta(-1)
                        --inst.poweruse:set(true)
					end)
				end
			end
			
            inst.components.locomotor:Stop()

            if not inst.AnimState:IsCurrentAnimation("parry_loop") then
                inst.AnimState:PushAnimation("parry_loop", true)
            end

            inst.sg.statemem.talktask = data ~= nil and data.talktask or nil

            if data ~= nil and (data.pauseframes or 0) > 0 then
                inst.sg:AddStateTag("busy")
                inst.sg:AddStateTag("pausepredict")

                if inst.components.playercontroller ~= nil then
                    inst.components.playercontroller:RemotePausePrediction(data.pauseframes <= 7 and data.pauseframes or nil)
                end
                inst.sg:SetTimeout(data.pauseframes * FRAMES)
            else
                inst.sg:AddStateTag("idle")
            end
        end,

        ontimeout = function(inst)
            inst.sg:RemoveStateTag("busy")
            inst.sg:RemoveStateTag("pausepredict")
            inst.sg:AddStateTag("idle")
        end,

        events =
        {
            EventHandler("ontalk", function(inst)
                if inst.sg.statemem.talktask ~= nil then
                    inst.sg.statemem.talktask:Cancel()
                    inst.sg.statemem.talktask = nil
                    StopTalkSound(inst, true)
                end
                if DoTalkSound(inst) then
                    inst.sg.statemem.talktask =
                        inst:DoTaskInTime(1.5 + math.random() * .5,
                            function()
                                inst.sg.statemem.talktask = nil
                                StopTalkSound(inst)
                            end)
                end
            end),
            EventHandler("donetalking", function(inst)
                if inst.sg.statemem.talktalk ~= nil then
                    inst.sg.statemem.talktask:Cancel()
                    inst.sg.statemem.talktask = nil
                    StopTalkSound(inst)
                end
            end),
            EventHandler("unequip", function(inst, data)
                if not inst.sg:HasStateTag("idle") and not inst.components.health:IsDead() then
                    inst.sg:GoToState(GetUnequipState(inst, data))
                end
            end),
			EventHandler("asa_powerdown", function(inst, data)
                if inst.components.asa_power.pw <= 0 then
					if inst.powertask then
						inst.powertask:Cancel()
						inst.powertask = nil
					end
                end
            end),
        },

        onexit = function(inst)
			-- if inst.cdtask then
				-- inst.cdtask:Cancel()
				-- inst.cdtask = nil
			-- end
            if inst.sg.statemem.task ~= nil then
                inst.sg.statemem.task:Cancel()
                inst.sg.statemem.task = nil
            end
            if inst.sg.statemem.talktask ~= nil then
                inst.sg.statemem.talktask:Cancel()
                inst.sg.statemem.talktask = nil
                StopTalkSound(inst)
            end
            if not inst.sg.statemem.parrying then
                inst.components.combat.redirectdamagefn = nil
            end
        end,
    }
)

AddStategraphState("wilson",
	State{
        name = "asa_parry_pst",
        tags = { "idle" },

        onenter = function(inst)
			inst.asaparry:set(false)
			if inst.powertask then
				inst.powertask:Cancel()
				inst.powertask = nil
			end
			local sks = inst.asa_skills:value()	--降维技能表
			sks = json.decode(sks)
			
			local danger = nil
			local pos = inst:GetPosition()
			local ents = TheSim:FindEntities(pos.x,pos.y,pos.z,5,{"_combat", }, { "playerghost", "INLIMBO", "player","companion","wall" })
			for k,v in pairs(ents) do
				if v.components.combat and v.components.combat.target == inst then
					danger = true
					break
				end
			end
			if sks[12] ~= 0 and inst.components.asa_power.pw <= 1 and danger then
				inst.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/dodge",nil,0.7)
				if inst.components.health then
					inst.asa_invincible:set(true)
				end
				inst:DoTaskInTime(1,function()
				if inst.components.health then
					inst.asa_invincible:set(false)
					end
				end)
				local position = inst:GetPosition()
				local test_fn = function(offset)
					local x = position.x + offset.x
					local z = position.z + offset.z
					return TheWorld.Map:IsAboveGroundAtPoint(x,0,z)
				end
				
				local start_angle = inst.Transform:GetRotation() * DEGREES + 180
				while start_angle > 180 do
					start_angle = start_angle - 360
				end
				local offset = FindValidPositionByFan(start_angle, 6, 7, test_fn)
				local pos = inst:GetPosition()
				if offset then
					--幻影特效
					local fx = SpawnPrefab("asa_shadow_fx")
					fx.Transform:SetPosition(pos.x, 0, pos.z)
					fx.Transform:SetRotation(inst.Transform:GetRotation())
					fx.AnimState:PlayAnimation("parry_loop")
					fx.AnimState:SetAddColour(0, 0.6, 1, 1)
					--脱离战斗
					inst.Transform:SetPosition(pos.x + offset.x, 0, pos.z+ offset.z)
					inst:DoTaskInTime(0.2,function()
						inst.AnimState:PlayAnimation("parry_pst",false)
						if inst.AnimState:AnimDone() and not inst.components.health:IsDead() then
							inst.sg:GoToState("idle")
						end
					end)
				end
			else
				inst.AnimState:PlayAnimation("parry_pst",false)
			end
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() and not inst.components.health:IsDead() then
					inst.sg:GoToState("idle")
                end
            end),
        },
    }
)

AddStategraphState("wilson_client",
	State{
        name = "asa_parry_pst",
        tags = { "idle" },

        onenter = function(inst)
			inst.asaparry:set(false)
            inst.AnimState:PlayAnimation("parry_pst",false)
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() and not inst.replica.health:IsDead() then
					inst.sg:GoToState("idle")
					
                end
            end),
        },
    }
)


local function StartParry(player, x, z)
	player.asaparry:set(true)
	player:ForceFacePoint(x,0,z)
	-- if not player.maxskill:value() then
		-- player.components.asa_power:DoDelta(-1)
	-- end
	if player.sg and not player.components.health:IsDead() then
		player.sg:GoToState("asa_parry_pre", Point(x,0,z))
	end
end

local function StopParry(player)
	player.asaparry:set(false)
    if player.sg and not player.components.health:IsDead() then
        player.sg:GoToState("asa_parry_pst")
    end
end

local function StopMinus(player)    
    if player.powertask then
		player.powertask:Cancel()
		player.powertask = nil
	end
end

local function DodgeButton(player)
    --print("闪避键")
    if player.sg and player.sg:HasStateTag("moving") then
        local sks = player.asa_skills:value()	--降维技能表
        sks = json.decode(sks)

        if player.asa_pw:value() >= 1 then
            --if player.poweruse:value() == true then
            --    player.poweruse:set(false)
            --else
            --    player.poweruse:set(true)
            --end
            if player.maxskill:value() == 0 then
                if sks[2] ~= 0 then
                    local pos = player:GetPosition() --闪避制造斩击机会
                    local ents = TheSim:FindEntities(pos.x,pos.y,pos.z,2,{"_combat", }, { "playerghost", "INLIMBO", "player","companion","wall" })
                    for k,v in pairs(ents)do
                        if v and v.components.health and not v.components.health:IsDead() and v.components.combat and v.components.combat.target == player then
                            v:AddTag("asa_zan")
                            player:DoTaskInTime(0,function()
                                v.AnimState:SetAddColour(0, 0.3, 0.4, 0.3)
                                v.zanlabel = SpawnPrefab("zan_label")
                                v.zanlabel.AnimState:PlayAnimation("idle_short")
                                v.zanlabel.entity:SetParent(v.entity)
                                if v:HasTag("epic") then
                                    if v.components.health.maxhealth > 3000 then
                                        v.zanlabel.AnimState:SetScale(1.3,1.3,1.3)
                                    else
                                        v.zanlabel.AnimState:SetScale(1.2,1.2,1.2)
                                    end

                                elseif v:HasTag("largecreature") or v.components.health.maxhealth > 400 then
                                    v.zanlabel.AnimState:SetScale(1.1,1.1,1.1)
                                end
                            end)
                            player:DoTaskInTime(1,function()
                                v.AnimState:SetAddColour(0,0,0,0)
                                v:RemoveTag("asa_zan")
                            end)
                        end
                    end
                    player.components.asa_power:DoDelta(-1)
                else
                    player.components.asa_power:DoDelta(-2)
                end
            end
            player.sg:GoToState("asa_dodge")
            return true
        end
    end
end

local function DisBolt(player)
    player.components.locomotor:RemoveExternalSpeedMultiplier(player, "asakiri_bolt")
    if player.bolttask then
        player.bolttask:Cancel()
        player.bolttask = nil
    end
    if player.boltfx then
        player.boltfx:Cancel()
        player.boltfx = nil
    end
    player:RemoveTag("asa_bolt")
end

AddModRPCHandler("asakiri", "ASAPARRY", StartParry)
AddModRPCHandler("asakiri", "DISASAPARRY", StopParry)
AddModRPCHandler("asakiri", "DISMINUS", StopMinus)
AddModRPCHandler("asakiri", "DODGEBUTTON", DodgeButton)
AddModRPCHandler("asakiri", "DISBOLT", DisBolt)


AddComponentPostInit("playercontroller", function(self, inst)
    local oldOnRightClick = self.OnRightClick
    function self:OnRightClick(down)
		if inst:HasTag("asakiri") and not inst.replica.health:IsDead() then
			local x, y, z = TheSim:ProjectScreenPos(TheSim:GetPosition())
			local dsq = distsq(Vector3(x,y,z), inst:GetPosition())
			local parry = inst.asaparry:value()
			local zero = inst.asa_pw and inst.asa_pw:value() <= 0 and true or nil
			local ride = inst.replica.rider ~= nil and inst.replica.rider:IsRiding() and true or nil
			local qinglu = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) and inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS):HasTag("asa_blade")
			local sks = inst.asa_skills:value()	--降维技能表
			sks = json.decode(sks)
			local canparry = sks[4] ~= 0 and true or nil
            if down then
				if  self:IsControlPressed(CONTROL_FORCE_ATTACK) and qinglu and canparry and not zero and not parry and not ride then
					inst:ForceFacePoint(x,0,z)
					if ThePlayer.sg then
						ThePlayer.sg:GoToState("asa_parry_pre", Point(x,0,z))
					end
					SendModRPCToServer(MOD_RPC.asakiri.ASAPARRY, x ,z)
					return
				end
            elseif not down then
				if ThePlayer.powertask then --?
					ThePlayer.powertask:Cancel()
					ThePlayer.powertask = nil
				end
				SendModRPCToServer(MOD_RPC.asakiri.DISMINUS)
				if parry then
					SendModRPCToServer(MOD_RPC.asakiri.DISASAPARRY)
					if parry then
						if ThePlayer.sg then
							ThePlayer.sg:GoToState("asa_parry_pst")
						end
					end
					return
				end
            end
        end
        return oldOnRightClick(self, down)
	end

    local oldOnControl = self.OnControl
    function self:OnControl(control, down)
        --print("节点0")
        if control == CONTROL_FORCE_INSPECT then
            --print("节点1")
            if self:IsControlPressed(CONTROL_FORCE_INSPECT) then
                if inst:HasTag("asakiri") then
                    local sks = inst.asa_skills:value()	--降维技能表
                    sks = json.decode(sks)
                    if sks[1] ~= 0 and inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                            and inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS):HasTag("asa_blade")
                            and not inst.replica.health:IsDead() and not inst.replica.inventory:IsHeavyLifting()
                    then
                        --print("节点2")
                        --触发
                        --inst.poweruse:set(true)
                        SendModRPCToServer(MOD_RPC.asakiri.DODGEBUTTON)
                        return
                    end
                end
             elseif not self:IsControlPressed(CONTROL_FORCE_INSPECT) then
                --inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "asakiri_bolt")
                SendModRPCToServer(MOD_RPC.asakiri.DISBOLT)
                if inst.boltfx then
                    inst.boltfx:Cancel()
                    inst.boltfx = nil
                end
            end
        else
            --inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "asakiri_bolt")
            --SendModRPCToServer(MOD_RPC.asakiri.DISBOLT)
        return oldOnControl(self, control, down)
        end
    end
end)

--屏蔽斩目标的平A
AddComponentPostInit("playeractionpicker", function(self)
	local oldGetEquippedItemActions = self.GetEquippedItemActions
	function self:GetEquippedItemActions(target, useitem, right)
		if self.inst:HasTag("asakiri") and useitem:HasTag("asa_blade") and not right then
			if target.prefab == "dummytarget" or self.inst.maxskill:value() == 1 then
				return
			end
			local zanable = FindEntity(target,0, nil ,{"zan_label"})
			if zanable then
				return
			end
		end
		return oldGetEquippedItemActions(self, target, useitem, right)
	end
	
	--屏蔽优先级最高的敌对判定！感谢花花提供的hook工具！
	local TargetIsHostile = upvaluehelper.Get(self.GetLeftClickActions,"TargetIsHostile")
	if TargetIsHostile ~= nil then
		local oldTargetIsHostile = TargetIsHostile
		local function NewTargetIsHostile(inst, target)
			if inst:HasTag("asakiri") then
				local zanable = FindEntity(target,0, nil ,{"zan_label"})
				if zanable or inst.maxskill:value() == 1 then
					return
				end
			end
			return oldTargetIsHostile(inst, target)
		end
		upvaluehelper.Set(self.GetLeftClickActions,"TargetIsHostile",NewTargetIsHostile)
	end
end)

