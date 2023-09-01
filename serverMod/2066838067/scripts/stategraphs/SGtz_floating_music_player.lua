--特殊攻击
AddStategraphPostInit("wilson", function(sg)
    local old_ATTACK = sg.actionhandlers[ACTIONS.ATTACK].deststate
    sg.actionhandlers[ACTIONS.ATTACK].deststate = function(inst, action)
		local weapon = inst.components.combat:GetWeapon()
		local isriding = inst.replica.rider:IsRiding()
		if weapon and not isriding then 
			if  weapon:HasTag("tz_floating_music_weapon") then 
				return "tz_floating_music_atk"
			elseif	weapon:HasTag("tz_fh_you") then 
				inst.sg.mem.localchainattack = not action.forced or nil
				return "tz_you_attack"
			end 
		end 
        return old_ATTACK(inst, action)
    end
end)
AddStategraphPostInit("wilson_client", function(sg)
    local old_ATTACK = sg.actionhandlers[ACTIONS.ATTACK].deststate
    sg.actionhandlers[ACTIONS.ATTACK].deststate = function(inst, action)
		local weapon = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		local isriding = inst.replica.rider:IsRiding()
		if weapon and not isriding then 
			if weapon:HasTag("tz_floating_music_weapon") then 
				return "tz_floating_music_atk"
			elseif	weapon:HasTag("tz_fh_you") then 
				inst.sg.mem.localchainattack = not action.forced or nil
				return "tz_you_attack"
			end 
		end 
        return old_ATTACK(inst, action)
    end
end)

AddStategraphPostInit("wilson", function(sg)
	local old_CASTAOE = sg.actionhandlers[ACTIONS.CASTAOE].deststate
    sg.actionhandlers[ACTIONS.CASTAOE].deststate = function(inst, action)
		local weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		if weapon  then 
			if  weapon:HasTag("tz_floating_music_weapon") then 
				return "tz_floating_music_atk_aoe"
			end 
		end 
		return old_CASTAOE(inst, action)
	end
end)


AddStategraphPostInit("wilson_client", function(sg)
	local old_CASTAOE = sg.actionhandlers[ACTIONS.CASTAOE].deststate
    sg.actionhandlers[ACTIONS.CASTAOE].deststate = function(inst, action)
		local weapon = inst.replica.combat:GetWeapon()
		if weapon  then 
			if  weapon:HasTag("tz_floating_music_weapon") then 
				return "tz_floating_music_atk_aoe"
			end 
		end 
		return old_CASTAOE(inst, action)
	end
end)

AddStategraphPostInit("wilson", function(sg)
	local old_attacked = sg.events["attacked"].fn 
	sg.events["attacked"].fn = function(inst,data)
		if not inst.components.health:IsDead() then
			--if inst:HasTag("icey_exectuer") or inst.sg:HasStateTag("icey_skill_soul_torrent") then 
			if inst.sg:HasStateTag("tz_floating_music_atk_aoe") then 
				return 
			end
		end

		return old_attacked(inst,data)
	end 
end)

local TIME_GET_GUITAR = 15 * FRAMES

local function CheckTargetTooFar(inst,target)
	if target and target:IsValid() and not inst:IsNear(target,20) then 
		--print("Is near 20?",inst:IsNear(target,20))
		inst.sg:GoToState("idle")
		return true
	end
end 

AddStategraphState("wilson", 
	State{
		name = "tz_floating_music_idle",
        tags = { "idle","canrotate"},
		onenter = function(inst)
			inst.components.locomotor:Stop()
			inst.components.locomotor:Clear()
			
			inst.AnimState:PlayAnimation("customanim_start",false)
			inst.AnimState:PushAnimation("customanim_normal",true)
		end,
		
		timeline =
		{
			
		},

		events =
		{
			EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
		},
	}
)

AddStategraphState("wilson_client", 
	State{
		name = "tz_floating_music_idle",
        tags = { "idle","canrotate"},
		onenter = function(inst)
			inst.components.locomotor:Stop()
			inst.components.locomotor:Clear()
			
			inst.AnimState:PlayAnimation("customanim_start",false)
			inst.AnimState:PushAnimation("customanim_normal",true)
		end,
		
		timeline =
		{
			
		},

		events =
		{
			EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
		},
	}
)

local function pipafx(inst)
	if inst.pipafx ~= nil then
		return
	end
    local fx = SpawnPrefab("tz_pipaxingfx")
	if fx then
		inst.pipafx = fx
		fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
		if fx.SetOwner then
			fx.SetOwner(fx,inst)
		end
	end
end

AddStategraphState("wilson", 
	State{
		name = "tz_floating_music_atk",
        tags = { "attack", "notalking", "autopredict" },
		onenter = function(inst)
			local target = nil 
			inst.components.locomotor:Stop()
			
			inst.AnimState:PlayAnimation("give")
			inst.AnimState:PushAnimation("customanim_start",false)
			inst.AnimState:PushAnimation("customanim_normal",true)
			
			inst.components.combat:StartAttack()
			
			if inst.bufferedaction ~= nil and inst.bufferedaction.target ~= nil and inst.bufferedaction.target:IsValid() then
                inst.sg.statemem.target = inst.bufferedaction.target
                inst.components.combat:SetTarget(inst.sg.statemem.target)
                inst:ForceFacePoint(inst.sg.statemem.target.Transform:GetWorldPosition())
				target = inst.sg.statemem.target
            end

            if target ~= nil and target:IsValid() then
                inst.sg.statemem.target = target
                inst:ForceFacePoint(target.Transform:GetWorldPosition())
				inst.sg.statemem.targetpos = target:GetPosition()
            end			
			
			inst.sg.statemem.reticulearc_inst = inst:SpawnChild("tz_floating_music_reticulearc")
			inst.sg.statemem.reticulearc_target = target:SpawnChild("tz_floating_music_reticulearc")
			
			inst.components.combat:SetTarget(target)
			
            --inst.sg:SetTimeout(30 * FRAMES)
			inst.sg.statemem.last_music_atk_time = GetTime() 
			inst.sg.statemem.weapon = inst.components.combat:GetWeapon()
			--inst.sg.statemem.music_atk_pulse = inst:SpawnChild("tz_floating_music_pulseatk_white")
		end,
		
		onupdate = function(inst)
            local target = inst.sg.statemem.target
			if target and target:IsValid() and target.components.health and not target.components.health:IsDead() then 
				
				
				if CheckTargetTooFar(inst,target) then
					return 
				end 
				if inst.sg.timeinstate >= 0 and GetTime() - inst.sg.statemem.last_music_atk_time >= 0.8 then
					local weapon = inst.sg.statemem.weapon
					inst.sg.statemem.last_music_atk_time = GetTime() 
					
					--DoSleepAttack
					--first_full_item == "orangegem" and not is_aoe_attack and math.random() <= 0.01
					local fx = SpawnAt("tz_floating_music_fallatk",target:GetPosition())
					fx:SetOwner(inst)
					
					if weapon.FirstFullItem and weapon.FirstFullItem == "orangegem" and math.random() <= 0.01 then 
						if weapon.StarLevel ~= nil and weapon.StarLevel >= 5 then
							if inst.pipafx == nil then
								inst:DoTaskInTime(1,pipafx)
							end
						end
						fx.Transform:SetScale(4,4,4)
						fx:DoTaskInTime(0.3,fx.DoSleepAttack,target)
						fx:DoTaskInTime(0.3,function()
							local pules = SpawnAt("tz_floating_music_pulseatk_black_ground",fx:GetPosition())
							pules.Transform:SetScale(5,5,5)
						end)
					else
						if weapon.StarLevel ~= nil and weapon.StarLevel >= 5 then
							if inst.pipafx == nil then
								inst:DoTaskInTime(1,pipafx)
							end
						end
						fx:Hide()
						fx:DoTaskInTime(0,fx.DoAttack,0.33)
						SpawnAt("tz_floating_music_fx_atk",target:GetPosition())
						SpawnAt("tz_floating_music_pulseatk_black",target:GetPosition()+Vector3(0,1,0))
					end
					
					
				end
			else
				inst.AnimState:PlayAnimation("item_in")
				inst.sg:GoToState("idle",true)
			end
        end,
		
		timeline =
		{
			TimeEvent(TIME_GET_GUITAR, function(inst)
                --inst.SoundEmitter:PlaySound("dontstarve/common/teleportato/teleportato_pulled")
				inst.AnimState:Show("ARM_carry")
				inst.AnimState:Hide("ARM_normal")
				local weapon = inst.sg.statemem.weapon
				if weapon and weapon:IsValid() then 
					weapon:EnableVisibleMinion(false)
				end
				--[[if weapon.FirstFullItem then 
					inst.sg.statemem.wormlightfx = inst:SpawnChild("tz_floating_music_wormlight_fx")
				end--]]
				inst.SoundEmitter:PlaySound("tz_floating_music/bgm/normal","music_atk")
            end),
		},

		events =
		{
			EventHandler("equip", function(inst)
                inst.sg:GoToState("idle")
            end),
			EventHandler("unequip", function(inst)
                inst.sg:GoToState("idle")
            end),
		},

		onexit = function(inst)
			inst.components.combat:SetTarget(nil)
			local weapon = inst.sg.statemem.weapon
			if weapon and weapon:IsValid() then 
				weapon:EnableVisibleMinion(true)
			end
			local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			if equip == nil or equip == weapon then 
				inst.AnimState:Hide("ARM_carry")
				inst.AnimState:Show("ARM_normal")
			end 
			
			if inst.sg.statemem.wormlightfx and inst.sg.statemem.wormlightfx:IsValid() then
				inst.sg.statemem.wormlightfx:Remove()
			end 
			inst.sg.statemem.last_music_atk_time = nil
			inst.sg.statemem.weapon = nil  
			inst.sg.statemem.wormlightfx = nil 
			if inst.sg.statemem.reticulearc_inst and inst.sg.statemem.reticulearc_inst:IsValid() then 
				inst.sg.statemem.reticulearc_inst:KillFX()
			end 
			inst.sg.statemem.reticulearc_inst = nil 
			
			if inst.sg.statemem.reticulearc_target and inst.sg.statemem.reticulearc_target:IsValid() then 
				inst.sg.statemem.reticulearc_target:KillFX()
			end 
			inst.sg.statemem.reticulearc_target = nil 

			
			inst.SoundEmitter:KillSound("music_atk")

			--[[if inst.sg.statemem.music_atk_pulse and inst.sg.statemem.music_atk_pulse:IsValid() then 
				inst.sg.statemem.music_atk_pulse:Remove()
			end
--			inst.sg.statemem.music_atk_pulse = nil --]]
		end,
			
	}
)

AddStategraphState("wilson_client", 
	State{
		name = "tz_floating_music_atk",
        tags = { "attack", "notalking"},
		onenter = function(inst)
			inst.components.locomotor:Stop()
			
			inst.AnimState:PlayAnimation("give")
			inst.AnimState:PushAnimation("customanim_start",false)
			inst.AnimState:PushAnimation("customanim_normal",true)
			
			local buffaction = inst:GetBufferedAction()
            if buffaction ~= nil then
                inst:PerformPreviewBufferedAction()

                if buffaction.target ~= nil and buffaction.target:IsValid() then
                    inst:FacePoint(buffaction.target:GetPosition())
                    inst.sg.statemem.attacktarget = buffaction.target
                end
            end
			
			inst.sg.statemem.weapon =  inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			
			inst.replica.combat:StartAttack()
		end,
		
		onupdate = function(inst)
            local target = inst.sg.statemem.attacktarget
			local current_weapon = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			if CheckTargetTooFar(inst,target) then
				return 
			end 
			if not (target and target:IsValid() and target.replica.health and not target.replica.health:IsDead())
			or  (inst.sg.statemem.weapon ~= current_weapon) then 
				--CheckTargetTooFar(inst,target)
				inst.AnimState:PlayAnimation("item_in")
				inst.sg:GoToState("idle",true)
			end 
        end,
		
		timeline =
		{
			TimeEvent(TIME_GET_GUITAR, function(inst)
                --inst.SoundEmitter:PlaySound("dontstarve/common/teleportato/teleportato_pulled")
				inst.AnimState:Show("ARM_carry")
				inst.AnimState:Hide("ARM_normal")
            end),
		},

		onexit = function(inst)
			inst:ClearBufferedAction()
			inst.replica.combat:SetTarget(nil)
			local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			if equip == nil or equip == inst.sg.statemem.weapon then 
				inst.AnimState:Hide("ARM_carry")
				inst.AnimState:Show("ARM_normal")
			end 
			inst.sg.statemem.weapon = nil 
		end,
			
	}
)
--[[
ThePlayer.apingpipa:set_local(0)
 ThePlayer.apingpipa:set(2)
 
 ThePlayer.apingbianshen:set(2)
]]

--都听我的
local function tingwode(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
    for i, v in ipairs(TheSim:FindEntities(x, 0, z, 32, {"player", }, { "playerghost", "INLIMBO", })) do
        if v and v:IsValid() and v.apingpipa ~= nil  and v ~= inst then
			v.apingpipa:set_local(0)
			v.apingpipa:set(2)
        end
    end
end

AddStategraphState("wilson", 
	State{
		name = "tz_floating_music_atk_aoe",
        tags = { "attack", "notalking", "abouttoattack", "autopredict","tz_floating_music_atk_aoe" },
		onenter = function(inst)
			inst.components.locomotor:Stop()
			inst.AnimState:PlayAnimation("give")
			inst.AnimState:PushAnimation("customanim_start",false)
			inst.AnimState:PushAnimation("customanim_loop",true)
			
			
			inst.sg.statemem.tanzou_fx_time = GetTime() 
			inst.sg.statemem.shouchitexiao_0_fx_time = GetTime() 
			inst.sg.statemem.shouchitexiao_1_fx_time = GetTime() 
			inst.sg.statemem.last_music_atk_time = GetTime() 
			local weapon = inst.components.combat:GetWeapon()
			inst.sg.statemem.weapon = weapon
			
			inst.apingpipa:set_local(0)
			inst.apingpipa:set(1)
			tingwode(inst)
			if weapon ~= nil and weapon.StarLevel ~= nil and weapon.StarLevel >= 5 then
				if inst.pipafx == nil then
					inst:DoTaskInTime(1,pipafx)
				end
			end
		end,
		
		onupdate = function(inst)
			local weapon = inst.sg.statemem.weapon
			if inst.sg.timeinstate >= 0.8 and GetTime() - inst.sg.statemem.tanzou_fx_time >= 0.3 then
				local fx = inst:SpawnChild("tz_floating_music_pulseatk_white")
				fx.Transform:SetPosition(0,0.5,0)
				inst.sg.statemem.tanzou_fx_time = GetTime() 
			end 
			
			if inst.sg.timeinstate >= 0.8 and GetTime() - inst.sg.statemem.shouchitexiao_0_fx_time >= 0.8 then
				inst:SpawnChild("tz_floating_music_fx_hand").AnimState:PlayAnimation("shouchitexiao_0")
				inst.sg.statemem.shouchitexiao_0_fx_time = GetTime() 
			end 
			
			if inst.sg.timeinstate >= 1.1 and GetTime() - inst.sg.statemem.shouchitexiao_1_fx_time >= 0.6 then
				inst:SpawnChild("tz_floating_music_fx_hand").AnimState:PlayAnimation("shouchitexiao_1")
				inst.sg.statemem.shouchitexiao_1_fx_time = GetTime() 
			end 
			
			if weapon.FirstFullItem ~= "purplegem" and inst.sg.timeinstate >= 1.0 and GetTime() - inst.sg.statemem.last_music_atk_time >= 0.3 then
				inst.sg.statemem.last_music_atk_time = GetTime() 
				local pos = inst:GetPosition()
				local rad = 12 * math.random() 
				local rota = math.random() * 2 * PI
				local offset = Vector3(rad * math.cos(rota),0,rad * math.sin(rota))
				local fx = SpawnAt("tz_floating_music_fallatk",pos+offset)
				fx.Transform:SetScale(4,4,4)
				fx:SetOwner(inst)
				fx:DoTaskInTime(0.3,fx.DoAttack,7,75 + 5*weapon.StarLevel,weapon.FirstFullItem == "orangegem")
				fx:DoTaskInTime(0.3,function()
					local pules = SpawnAt("tz_floating_music_pulseatk_black_ground",fx:GetPosition())
					pules.Transform:SetScale(5,5,5)
				end)

			elseif inst.sg.timeinstate >= 8.5 then 
				if weapon.FirstFullItem == "purplegem" then 
					TheWorld:PushEvent("ms_forceprecipitation", true)
				end
				inst.AnimState:PlayAnimation("item_in")
				inst.sg:GoToState("idle",true)
			end
        end,
		
		timeline =
		{
			TimeEvent(17 * FRAMES, function(inst)
				local weapon = inst.sg.statemem.weapon
				if weapon.FirstFullItem == "purplegem" then 
					return 
				end 
				
				local light = inst:SpawnChild("nightstickfire")
				
				light.Light:SetIntensity(.9)
				light.Light:SetColour(252 / 255, 251 / 255, 237 / 255)
				light.Light:SetFalloff(.6)
				light.Light:SetRadius(12)
				light.Light:Enable(true)
				
				inst.sg.statemem.aoe_light = light
				inst.sg.statemem.trible_fx = {} 
				local rad = 6
				
				inst.sg.statemem.stagelight_thread = inst:StartThread(function()
					 
					for rota = 0,PI *  4/3,PI * 2/3 do 
						local pos = inst:GetPosition()
						local offset = Vector3(rad * math.cos(rota),0,rad * math.sin(rota))
						local fx = SpawnAt("tz_floating_music_stagelight",pos+offset)
						--[[fx:DoTaskInTime(0.3,function()
							fx:SpawnChild("tz_floating_music_pulseatk_black_ground")
						end)--]]
						table.insert(inst.sg.statemem.trible_fx,fx)
						Sleep(25 * FRAMES * math.random())
					end
				end)
				
				inst.sg.statemem.music_shield_0 = inst:SpawnChild("tz_floating_music_shield_0")
				inst.sg.statemem.music_shield_1 = inst:SpawnChild("tz_floating_music_shield_1")
				inst.sg.statemem.music_shield_1.AnimState:SetFinalOffset(-1)
				inst.sg.statemem.music_shield_0:ListenForEvent("death",function()
					inst.sg.statemem.music_shield_1:KillFX()
				end)
				inst.components.combat.redirectdamagefn = function(inst, attacker, damage, weapon, stimuli)
					local shield = inst.sg.statemem.music_shield_0  
					return (shield and shield:IsValid()) and shield
				end
			end),
			
			TimeEvent(83 * FRAMES, function(inst)
				if inst.components.talker then 
					inst.components.talker:Say("陷入疯狂吧！")
				end
			end),
			
			--[[TimeEvent(33 * FRAMES, function(inst)
			
				for i = 1,2 do 
					if math.random() <= 0.5 then 
						local rad = 18
						local rota = PI * 2 * math.random() 
						local offset = Vector3(rad * math.cos(rota),0,rad * math.sin(rota))
						local fx = SpawnAt("tz_floating_music_fallatk",inst:GetPosition()+offset)
						fx:DoTaskInTime(0.3,function()
							fx:SpawnChild("tz_floating_music_pulseatk_black")
						end)
					end 
				end 
			end),--]]
			TimeEvent(TIME_GET_GUITAR, function(inst)
                --inst.SoundEmitter:PlaySound("dontstarve/common/teleportato/teleportato_pulled")
				inst.AnimState:Show("ARM_carry")
				inst.AnimState:Hide("ARM_normal")
				inst:PerformBufferedAction()
				local weapon = inst.sg.statemem.weapon
				if weapon and weapon:IsValid() then 
					weapon:EnableVisibleMinion(false)
				end
				inst.SoundEmitter:PlaySound("tz_floating_music/bgm/skill","music_atk_aoe")
            end),
		},

		events =
		{
			EventHandler("equip", function(inst)
                inst.sg:GoToState("idle")
            end),
			EventHandler("unequip", function(inst)
                inst.sg:GoToState("idle")
            end),
		},
		
		--[[ontimeout = function(inst)
			local weapon = inst.sg.statemem.weapon
			if weapon.FirstFullItem == "purplegem" then 
				
				
			end
		end,--]]

		onexit = function(inst)			
			local weapon = inst.sg.statemem.weapon
			if weapon and weapon:IsValid() then 
				weapon:EnableVisibleMinion(true)
			end
			local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			if equip == nil or equip == weapon then 
				inst.AnimState:Hide("ARM_carry")
				inst.AnimState:Show("ARM_normal")
			end 

			inst.AnimState:Hide("ARM_carry")
			inst.AnimState:Show("ARM_normal")
			
			inst.sg.statemem.weapon = nil 
			
			if inst.sg.statemem.aoe_light and inst.sg.statemem.aoe_light:IsValid() then 
				inst.sg.statemem.aoe_light:Remove()
			end
			inst.sg.statemem.aoe_light = nil 
			
			if inst.sg.statemem.trible_fx then 
				for k,v in pairs(inst.sg.statemem.trible_fx) do 
					if v and v:IsValid() then 
						v:KillFX()
					end
				end
			end
			inst.sg.statemem.trible_fx = nil 
			
			inst.sg.statemem.tanzou_fx_time = nil 
			inst.sg.statemem.shouchitexiao_0_fx_time = nil 
			inst.sg.statemem.shouchitexiao_1_fx_time = nil 
			
			if inst.sg.statemem.music_shield_0 and inst.sg.statemem.music_shield_0:IsValid() then 
				inst.sg.statemem.music_shield_0:KillFX()
			end
			inst.sg.statemem.music_shield_0 = nil 
			
			if inst.sg.statemem.music_shield_1 and inst.sg.statemem.music_shield_1:IsValid() then 
				inst.sg.statemem.music_shield_1:KillFX()
			end
			inst.sg.statemem.music_shield_1 = nil 
			
			if inst.sg.statemem.stagelight_thread then 
				KillThread(inst.sg.statemem.stagelight_thread)
			end
			inst.sg.statemem.stagelight_thread = nil 
			
			inst.components.combat.redirectdamagefn = nil 
			
			inst.sg.statemem.last_music_atk_time = nil 
			
			
			
			inst.SoundEmitter:KillSound("music_atk_aoe")
		end,
			
	}
)

AddStategraphState("wilson_client", 
	State{
		name = "tz_floating_music_atk_aoe",
        tags = { "attack", "notalking", "abouttoattack", "autopredict","tz_floating_music_atk_aoe" },
		onenter = function(inst)
			inst.components.locomotor:Stop()
			inst.AnimState:PlayAnimation("give")
			inst.AnimState:PushAnimation("customanim_start",false)
			inst.AnimState:PushAnimation("customanim_loop",true)
			inst.sg:SetTimeout(8.5)			
			
			inst.sg.statemem.weapon = inst.replica.combat:GetWeapon()
			inst:PerformPreviewBufferedAction()

		end,
		
		ontimeout = function(inst)
			inst.AnimState:PlayAnimation("item_in")
			inst.sg:GoToState("idle",true)
		end,
		
		onupdate = function(inst)
            
        end,
		
		timeline =
		{
			TimeEvent(TIME_GET_GUITAR, function(inst)
                --inst.SoundEmitter:PlaySound("dontstarve/common/teleportato/teleportato_pulled")
				inst.AnimState:Show("ARM_carry")
				inst.AnimState:Hide("ARM_normal")
            end),
		},

		events =
		{
			EventHandler("equip", function(inst)
                inst.sg:GoToState("idle")
            end),
			EventHandler("unequip", function(inst)
                inst.sg:GoToState("idle")
            end),
		},

		onexit = function(inst)
			inst:ClearBufferedAction()
			local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			if equip == nil or equip == inst.sg.statemem.weapon then 
				inst.AnimState:Hide("ARM_carry")
				inst.AnimState:Show("ARM_normal")
			end 
			inst.sg.statemem.weapon = nil 
		end,
			
	}
)