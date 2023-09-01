local upvaluehelper = require "components/asa_upvaluehelper"

function Asa_Repelling(owner, attacker, damage)
	local sks = owner.asa_skills:value()	--降维技能表
	sks = json.decode(sks)
	--反伤和火花
	attacker.components.combat:GetAttacked(owner,damage*0.6,nil,nil)
	local x,y,z = attacker.Transform:GetWorldPosition()
	local x1,y1,z1 = owner.Transform:GetWorldPosition()
	local fx = SpawnPrefab("asa_spark")
	fx.Transform:SetPosition((x+x1*2)/3,(y+y1*2)/3+1,(z+z1*2)/3)
	fx.Transform:SetScale(0.5,0.5,0.5)
	--音效震动补足
	owner.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/asa_parry")
	owner.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/equip")
	owner:ShakeCamera(CAMERASHAKE.VERTICAL, damage/500, 0.02, 0.3+damage/500, 2)
	--高光时刻！斩！
	if sks[5] ~= 0 and attacker.sg ~= nil and attacker.sg:HasState("hit")	--需要前置技能条件荆棘
			and attacker.components.health ~= nil and not attacker.components.health:IsDead()
			and not attacker.sg:HasStateTag("transform")
			and not attacker.sg:HasStateTag("nointerrupt")
			and not attacker.sg:HasStateTag("frozen")
			or (attacker.prefab == "spiderqueen" and attacker.components.health ~= nil and not attacker.components.health:IsDead())

	then
		--屏幕蓝光
		owner._zanvision:set(owner._zanvision:value() + 1)
		owner:DoTaskInTime(1.4,function()
			owner._zanvision:set(owner._zanvision:value() - 1)
		end)

		attacker:AddTag("asa_zan")
		--一些过滤
		owner:AddTag("asa_avoid")
		owner:AddTag("NOCLICK")
		attacker.AnimState:SetAddColour(0, 0.3, 0.4, 0.3)
		--关键的斩字
		owner:DoTaskInTime(0.1,function()
			attacker.zanlabel = SpawnPrefab("zan_label")
			attacker.zanlabel.entity:SetParent(attacker.entity)
			if attacker:HasTag("epic") then
				if attacker.components.health.maxhealth > 3000 then
					attacker.zanlabel.AnimState:SetScale(1.3,1.3,1.3)
				else
					attacker.zanlabel.AnimState:SetScale(1.2,1.2,1.2)
				end

			elseif attacker:HasTag("largecreature") or attacker.components.health.maxhealth > 400 then
				attacker.zanlabel.AnimState:SetScale(1.1,1.1,1.1)
			end
		end)
		--连续僵直
		owner:DoTaskInTime(0.3,function()
			if attacker.sg ~= nil and attacker.sg:HasState("hit")
					and attacker.components.health ~= nil and not attacker.components.health:IsDead()
					and not attacker.sg:HasStateTag("transform")
					and not attacker.sg:HasStateTag("nointerrupt")
					and not attacker.sg:HasStateTag("frozen")
					and not attacker.sg:HasStateTag("hiding")--石虾缩壳
			then
				attacker.sg:GoToState("hit")
			end
		end)

		owner:DoTaskInTime(0.6,function()
			if attacker.sg ~= nil and attacker.sg:HasState("hit")
					and attacker.components.health ~= nil and not attacker.components.health:IsDead()
					and not attacker.sg:HasStateTag("transform")
					and not attacker.sg:HasStateTag("nointerrupt")
					and not attacker.sg:HasStateTag("frozen")
					and not attacker.sg:HasStateTag("hiding")--石虾缩壳
			then
				attacker.sg:GoToState("hit")
			end
		end)

		owner:DoTaskInTime(0.9,function()
			if attacker.sg ~= nil and attacker.sg:HasState("hit")
					and attacker.components.health ~= nil and not attacker.components.health:IsDead()
					and not attacker.sg:HasStateTag("transform")
					and not attacker.sg:HasStateTag("nointerrupt")
					and not attacker.sg:HasStateTag("frozen")
					and not attacker.sg:HasStateTag("hiding")--石虾缩壳
			then
				attacker.sg:GoToState("hit")
			end
		end)

		if attacker:HasTag("epic") then --巨型生物更快恢复
			owner:DoTaskInTime(1.2,function()
				attacker.AnimState:SetAddColour(0, 0, 0, 0)
				attacker:RemoveTag("asa_zan")
				if attacker.sg ~= nil and attacker.sg:HasState("hit")
						and attacker.components.health ~= nil and not attacker.components.health:IsDead()
						and not attacker.sg:HasStateTag("transform")
						and not attacker.sg:HasStateTag("nointerrupt")
						and not attacker.sg:HasStateTag("frozen")
						and not attacker.sg:HasStateTag("hiding")
				then
					attacker.sg:GoToState("hit")
				end
			end)
		else
			owner:DoTaskInTime(1.2,function()
				if attacker.sg ~= nil and attacker.sg:HasState("hit")
						and attacker.components.health ~= nil and not attacker.components.health:IsDead()
						and not attacker.sg:HasStateTag("transform")
						and not attacker.sg:HasStateTag("nointerrupt")
						and not attacker.sg:HasStateTag("frozen")
						and not attacker.sg:HasStateTag("hiding")
				then
					attacker.sg:GoToState("hit")
				end
			end)
			owner:DoTaskInTime(1.5,function()
				attacker.AnimState:SetAddColour(0, 0, 0, 0)
				attacker:RemoveTag("asa_zan")
				if attacker.sg ~= nil and attacker.sg:HasState("hit")
						and attacker.components.health ~= nil and not attacker.components.health:IsDead()
						and not attacker.sg:HasStateTag("transform")
						and not attacker.sg:HasStateTag("nointerrupt")
						and not attacker.sg:HasStateTag("frozen")
						and not attacker.sg:HasStateTag("hiding")
				then
					attacker.sg:GoToState("hit")
				end
			end)
		end
		--人物恢复常态，去掉过滤标签
		owner:DoTaskInTime(1.8,function()
			owner:RemoveTag("asa_avoid")
			owner:RemoveTag("NOCLICK")
		end)
	end
end

--无法治疗
AddComponentPostInit("healer",function(self)
	local old = self.Heal
	self.Heal = function(self,target)
		if target:HasTag("asakiri") and target.components.health ~= nil  and not target.components.health:IsDead() then
			if target.components.talker then
				target.components.talker:Say("它修复不了我的躯体。")
			end
			return false
		end
		return old(self,target)
	end
end)

--无法打针
AddComponentPostInit("maxhealer",function(self)
	local old = self.Heal
	self.Heal = function(self,target)
		if target:HasTag("asakiri") and target.components.health ~= nil  and not target.components.health:IsDead() then
			return false
		end
		return old(self,target)
	end
end)

AddPlayerPostInit(function(inst)
	if inst.prefab ~= "asakiri" then
		print(1)
		local ASA_BEAVERVISION_COLOURCUBES =
		{
			day = "images/colour_cubes/snow_cc.tex",
			dusk = "images/colour_cubes/snow_cc.tex",
			night = "images/colour_cubes/snow_cc.tex",
			full_moon = "images/colour_cubes/snow_cc.tex",
		}
		
		local function SetBeaverVision(inst, enable)
			local enable = inst.scanvision:value() ~= 0
			if enable then
				--inst.components.playervision:ForceNightVision(true)
				inst.components.playervision:SetCustomCCTable(ASA_BEAVERVISION_COLOURCUBES)
			else
				--inst.components.playervision:ForceNightVision(false)
				inst.components.playervision:SetCustomCCTable(nil)
			end
		end
		
		inst.scanvision = net_tinybyte(inst.GUID, "ScanVision", "ScanVision")	--蓝斩视野
		inst:ListenForEvent("ScanVision", SetBeaverVision)
	end
end)

AddComponentPostInit("combat", function(self, inst)
    local oldGetAttacked = self.GetAttacked
    function self:GetAttacked(attacker, damage, weapon, stimuli, spdamage)
		if self.inst:HasTag("player") then
			if self.inst:HasTag("asakiri") then
				if self.inst.asa_invincible and self.inst.asa_invincible:value() then
					return
				end
				if self.inst.maxskill:value() == 2 then
					Asa_Repelling(inst, attacker, damage)
					damage = 0
				end
			end
			--面甲、无人机减伤
			local inv = self.inst.components.inventory
			if inv then
				if inv:GetEquippedItem(EQUIPSLOTS.HEAD) and inv:GetEquippedItem(EQUIPSLOTS.HEAD):HasTag("asa_vizard") then
					damage = damage * 0.8
				end
				if self.inst:HasTag("asa_shielded") then
					damage = damage * 0.4
					if (inv:GetEquippedItem(EQUIPSLOTS.NECK) and inv:GetEquippedItem(EQUIPSLOTS.NECK):HasTag("asa_shield_drone"))
							or (inv:GetEquippedItem(EQUIPSLOTS.BODY) and inv:GetEquippedItem(EQUIPSLOTS.BODY):HasTag("asa_shield_drone")) then
						local drone = inv:GetEquippedItem(EQUIPSLOTS.NECK) or inv:GetEquippedItem(EQUIPSLOTS.BODY)
						drone.components.fueled:DoDelta(- 1.5 * damage)
						SpawnPrefab("asa_shield_fx"):SetInit(self.inst, attacker)
						self.inst.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/equip2")
					end
				end
			end
		end
        return oldGetAttacked(self, attacker, damage, weapon, stimuli, spdamage)
	end
end)

AddStategraphPostInit('wilson',function(sg)
	local old_broke = sg.events["toolbroke"].fn
    sg.events["toolbroke"] = EventHandler("toolbroke", function(inst, data,...)
		if data.tool:HasTag("asa_axe") then
			return
		end
		return old_broke(inst, data,...)
    end)
end)

--作祟复活
local gamemode = TheNet:GetServerGameMode()
AddComponentPostInit("hauntable",function(self)
	local old_DoHaunt = self.DoHaunt
	function self:DoHaunt(doer,...)
		if doer and doer.prefab == "asakiri" then
			if self.onhaunt ~= nil then
				self.haunted = self.onhaunt(self.inst, doer)
				if self.haunted then
				if doer ~= nil then
						if GetPortalRez(gamemode) and self.hauntvalue == TUNING.HAUNT_INSTANT_REZ and doer:HasTag("playerghost") then 
							doer:PushEvent("respawnfromghost", { source = self.inst })
						end
						if self.inst.prefab == "asa_shop" and doer:HasTag("playerghost") then
							doer:PushEvent("respawnfromghost", { source = self.inst })
						end
					end
					if self.cooldown_on_successful_haunt then
						self.cooldowntimer = self.cooldown or TUNING.HAUNT_COOLDOWN_MEDIUM
						self:StartFX(true)
						self:StartShaderFx()
						self.inst:StartUpdatingComponent(self)
					end
				else
					self.haunted = true
					self.cooldowntimer = self.cooldown or TUNING.HAUNT_COOLDOWN_SMALL
					self:StartFX(true)
					self:StartShaderFx()
					self.inst:StartUpdatingComponent(self)
				end
			end
		else
			old_DoHaunt(self,doer,...)
		end
	end

end)

--死亡不掉落骨架，掉落电子元件，感谢花花妈咪
local ex_fns = require "prefabs/player_common_extensions"
local old_Ghost  = ex_fns.OnMakePlayerGhost

ex_fns.OnMakePlayerGhost = function(inst,data)
	if inst and inst.prefab == "asakiri" then
		if data and data.skeleton then
			data.skeleton = nil
		end
		
		local x, y, z = inst.Transform:GetWorldPosition()
		local trans = SpawnPrefab("transistor")	--掉落电子元件
		if trans ~= nil then
			trans.Transform:SetPosition(x, y, z)
		end
		old_Ghost(inst,data)
	else
		old_Ghost(inst,data)
	end
end

--无法制作复活心
local function builder(self)
	local old_canbuild = self.CanBuild
	function self:CanBuild(recname, ...)
		local recipe = GetValidRecipe(recname)
		if recipe == nil then
			return false
		elseif self.inst.prefab == "asakiri" and recipe.name == "reviver" then
			return false
		end
		return old_canbuild(self,recname, ...)
	end
end
AddComponentPostInit('builder', builder)
AddClassPostConstruct('components/builder_replica', builder)