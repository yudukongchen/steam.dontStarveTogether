--大招

local Asa_Repel = function(inst, data)
	Asa_Parrying(inst, data.attacker, data.damage)
end

local function StartMax(player)
	local sks = player.asa_skills:value()	--降维技能表
	sks = json.decode(sks)
	
	player:ShakeCamera(CAMERASHAKE.VERTICAL, 0.3, 0.03, 0.8, 1)	--特效音效安排
	player.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/max")
	player.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/upgrade1")
	
	
	if sks[9] ~= 0 then	--大招1，无限斩
		player:AddTag("NOCLICK")
		player.AnimState:SetAddColour(0.6,0,0,0.2)
		local fx = SpawnPrefab("asa_max_fx")
		fx.Transform:SetPosition(player.Transform:GetWorldPosition())
		player.maxskill:set(1)
		player.AnimState:OverrideSymbol("zan", "zan2", "zan2") --替换刀光
		
	elseif sks[6] ~= 0 then	--大招2，震撼止戈
		player.AnimState:SetAddColour(0.6,0.4,0,0.2)
		local fx = SpawnPrefab("firering_fx")
		fx.Transform:SetScale(1.5,1.5,1.5)
		fx.Transform:SetPosition(player.Transform:GetWorldPosition())
		player.maxskill:set(2)
		-- player:AddTag("notarget")
		local pos = player:GetPosition()
		local ents = TheSim:FindEntities(pos.x,pos.y,pos.z,8,{"_health", }, { "playerghost", "INLIMBO", "player","companion","wall" })
		for k,v in pairs(ents) do
			local pos1 = v:GetPosition()
			local dist = v:GetDistanceSqToInst(player)
			if v.sg then
				v.sg:GoToState("hit")
			end
			v:ForceFacePoint(pos.x, 0, pos.z)
			v.Physics:SetMotorVelOverride(-30/math.sqrt(dist), 0, 0)	--退下！
		end
	
	elseif sks[3] ~= 0 then	--大招3，朔风四起
		player.maxskill:set(3)
		player.Physics:ClearCollisionMask()
		player.Physics:CollidesWith(COLLISION.WORLD)
		player.components.locomotor:SetExternalSpeedMultiplier(player, "asakiri_tornado", 3)
		player.tornado = SpawnPrefab("asa_tornado")
		player.tornado.entity:SetParent(player.entity)
		player.tornadotask = player:DoPeriodicTask(0.15,function()
			local weapon = player.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			if player.components.locomotor.isrunning then
				local x,y,z = player.Transform:GetWorldPosition()
				local ents = TheSim:FindEntities(x,y,z,2.5,{"_combat", }, { "playerghost", "INLIMBO", "player","companion","wall" })
				for k,v in pairs(ents) do
					if not (v.components.health and v.components.health:IsDead()) then
						local defence =	v.components.combat and v.components.combat.externaldamagetakenmultipliers and 1 - v.components.combat.externaldamagetakenmultipliers:Get() or 0	--适配加强防御，破甲率67%
						local extra = (1 - defence/3) / (1 - defence)
						local damage = player.components.combat:CalcDamage(v, weapon, 2/3)
						v.components.combat:GetAttacked(player, damage * extra, weapon, nil)
					end
				end
			else
				local x,y,z = player.Transform:GetWorldPosition()
				local ents = TheSim:FindEntities(x,y,z,2.5,{"_combat", }, { "playerghost", "INLIMBO", "player","companion","wall" })
				for k,v in pairs(ents) do
					if not (v.components.health and v.components.health:IsDead()) then
						local defence =	v.components.combat and v.components.combat.externaldamagetakenmultipliers and 1 - v.components.combat.externaldamagetakenmultipliers:Get() or 0	--适配加强防御，破甲率67%
						local extra = (1 - defence/3) / (1 - defence)
						local damage = player.components.combat:CalcDamage(v, weapon, 1/3)
						v.components.combat:GetAttacked(player, damage * extra, weapon, nil)
					end
				end
			end
		end)
		player.windtask = player:DoPeriodicTask(0.2,function()
			if player.components.locomotor.isrunning then
				local x,y,z = player.Transform:GetWorldPosition()
				local fx2 = SpawnPrefab("asa_tornado_light")
				fx2.Transform:SetPosition(x,y,z)
				player:DoTaskInTime(0,function()
					fx2:FacePoint(player.Transform:GetWorldPosition())
				end)
			end
		end)
		player.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/mossling/spin","windsound")
		-- player.windsound = player:DoPeriodicTask(1,function()
			-- player.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/mossling/spin")
		-- end)
	end
end

AddModRPCHandler("asakiri", "MaxSkill1", StartMax)
AddModRPCHandler("asakiri", "MaxFail", function(player)
	player.components.asa_power:DoDelta(-1)
	player.poweruse:set(true)
end)

AddClassPostConstruct("widgets/controls", function(self)
    self.inst:DoTaskInTime(0.1, function()
        TheInput:AddKeyDownHandler(KEY_Z, function()
			if ThePlayer:HasTag("asakiri") and ThePlayer.replica.health and not ThePlayer.replica.health:IsDead() and not ThePlayer:HasTag("playerghost")
			--and ThePlayer.asa_cd:value() == 0
			then
				ThePlayer.asa_cd:set(240)
				local sks = ThePlayer.asa_skills:value()	--降维技能表
				sks = json.decode(sks)
				if (sks[9] ~= 0 or sks[6] ~= 0 or sks[3] ~= 0) and not ThePlayer.asamaxtask and ThePlayer.maxskill:value() == 0 then
					ThePlayer.asamaxtask = ThePlayer:DoTaskInTime(0,function()
						if ThePlayer.asa_pw:value() >= 6 then
							local t = 0
							if not sfx then
								local sfx = ThePlayer.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/max_pre","asa_max_pre")
							end
							ThePlayer.maxcharge = ThePlayer:DoPeriodicTask(1,function()
								t = t + 1
								if t >= 3 and ThePlayer.replica.health and not ThePlayer.replica.health:IsDead() then
									SendModRPCToServer(MOD_RPC.asakiri.MaxSkill1)
									if ThePlayer.maxcharge then
										ThePlayer.maxcharge:Cancel()
										ThePlayer.maxcharge = nil
										t = 0
									end
								end
							end)
						end
					end)
				end
			end
        end)
		
		TheInput:AddKeyUpHandler(KEY_Z, function()
			if ThePlayer:HasTag("asakiri") then
				if not ThePlayer.maxskill:value() then
					ThePlayer.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/discharge")
				end
				if ThePlayer.maxcharge then
					ThePlayer.maxcharge:Cancel()
					ThePlayer.maxcharge = nil
				end
				if ThePlayer.asamaxtask then
					ThePlayer.SoundEmitter:KillSound("asa_max_pre")
					ThePlayer.asamaxtask = nil
				end
				SendModRPCToServer(MOD_RPC.asakiri.MaxFail)
			end
        end)
		
		TheInput:AddKeyDownHandler(KEY_X, function()
			if ThePlayer:HasTag("asakiri") then
				ThePlayer.HUD:CloseAsaBar()
			end
        end)
		
		TheInput:AddKeyUpHandler(KEY_X, function()
			if ThePlayer:HasTag("asakiri") then
				ThePlayer.HUD:OpenAsaBar()
			end
        end)
		
    end)
end)
