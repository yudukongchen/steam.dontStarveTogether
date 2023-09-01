local  asa_parry = Class(function(self, inst)
	self.inst = inst
end)

local BEAVERVISION_COLOURCUBES =
{
    day = "images/colour_cubes/snow_cc.tex",
    dusk = "images/colour_cubes/snow_cc.tex",
    night = "images/colour_cubes/snow_cc.tex",
    full_moon = "images/colour_cubes/snow_cc.tex",
}
local Asa_Parrying = function(owner, attacker, damage)
	local sks = owner.asa_skills:value()	--降维技能表
	sks = json.decode(sks)
	--反伤和火花
	if attacker.components.combat then
		attacker.components.combat:GetAttacked(owner,damage*0.6,nil,nil)
		local x,y,z = attacker.Transform:GetWorldPosition()
		local x1,y1,z1 = owner.Transform:GetWorldPosition()
		SpawnPrefab("asa_spark").Transform:SetPosition((x+x1*2)/3,(y+y1*2)/3+1,(z+z1*2)/3)
		--音效震动补足
		owner.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/asa_parry")
		owner.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/equip")
		owner:ShakeCamera(CAMERASHAKE.VERTICAL, 0.2+damage/1000, 0.02+damage/10000, 0.6+damage/300, 2)
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
end
function asa_parry:TryParry(owner, attacker, damage, weapon, stimuli)
	if owner ~= nil and attacker ~= nil and damage > 0  then
		local ang = owner.Transform:GetRotation()
		local x,y,z = attacker.Transform:GetWorldPosition()
		local angle = owner:GetAngleToPoint( x,0,z )
		local drot = math.abs( ang - angle )
		local sks = owner.asa_skills:value()	--降维技能表
		sks = json.decode(sks)
		while drot > 180 do
            drot = math.abs(drot - 360)
		end
		if drot < 90 then
			if owner.components.asa_power then
				if owner.components.asa_power.pw > 1 then --铁御，一格也能掌乾坤！注意，首先一秒不开倒计时，一格免疫消耗。
					if damage >= 75 then
						owner.components.asa_power:DoDelta(-2)
					else
						owner.components.asa_power:DoDelta(-1)
					end
				end
				
				--屏蔽远程弹反
				if attacker.components.inventory and attacker.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
				and attacker.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).components.weapon.projectile
				then
					if drot < 60 and owner.sg:HasStateTag("preparrying") then
						local x,y,z = attacker.Transform:GetWorldPosition()
						local x1,y1,z1 = owner.Transform:GetWorldPosition()
						local spark = SpawnPrefab("asa_spark")
						spark.Transform:SetPosition((x+x1*9)/10,(y+y1*9)/10+1,(z+z1*9)/10)
						spark.AnimState:SetScale(1.4,1.8,1.4)
						owner:ShakeCamera(CAMERASHAKE.VERTICAL, 0.2, 0.03, 0.8, 1)
					end
					
					return true
				end
				--弹反判定
				if drot < 60 and owner.sg:HasStateTag("preparrying")
				then
					Asa_Parrying(owner, attacker, damage)
				end
			end
			if owner.components.asa_power:IsZero() then	--铁御，还能撑一会
				owner:DoTaskInTime(0.2,function()
					owner.sg:GoToState("asa_parry_pst")
				end)
            end
			return true
		end
	end
	return false
end

return asa_parry


