GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})
AddPlayerPostInit(function(self) 							
	self.number = 0
	local function OnLoad(self,data)
		if data then
			self.number = data.loadnumber
			self.addbuff = data.loadaddbuff
		end
	end

	local function OnSave(self,data)
		return
		{
			loadnumber = self.number,
			loadaddbuff = self.addbuff,
		}
	end
	self.addbuff = {}
	self.buffs = self:DoPeriodicTask(1, function(self)
		local x, y, z = self.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x,y,z,10,{"lostumbrella"})
		for k,v in pairs(ents) do
			if v and v.components.health and v.components.locomotor then 
				if v:HasTag("lostumbrella") and v.sign[self] ~= 1 and self.number < 10 then
					if self.number > 10 then
						self.number = self.number - 1
					end
					self.number = self.number + 1
					v.sign[self] = 1
				end
				if self.number ~= 0 then
					self.components.health.externalabsorbmodifiers = SourceModifierList(self, 0.05 * self.number, SourceModifierList.additive)
				end
				if not self.components.temperature then
					self:AddComponent("temperature")
					self.components.temperature.inherentsummerinsulation = TUNING.INSULATION_LARGE
				else
					self.components.temperature.inherentsummerinsulation = TUNING.INSULATION_LARGE
				end
				if self.addbuff[v] == nil then
					if not v.components.health:IsDead() then 
						self.addbuff[v] = v
						if self.fx1 == nil or self.fx == nil then
							self.fx1 = SpawnPrefab("tz_reticuleaoesmall")
							self.fx1.Transform:SetScale( 0.5, 0.5, 0.5)
							self.fx1.entity:SetParent(self.entity)
						
							self.fx = SpawnPrefab("tz_shadowunbrella")
							self.fx.AnimState:PlayAnimation("pre")
							self.fx.Transform:SetScale( 0.5, 0.5, 0.5)
							self.fx.Transform:SetPosition(0,4,0)
							self.fx.entity:SetParent(self.entity)
						end
					end
				end
			end
		end
		for k, v in pairs(self.addbuff) do
			if v and v:IsValid() and v.components.health and v.components.locomotor then 
				--PrintTable(self.fx)
				if v.components.health and v.components.health:IsDead() or v:GetDistanceSqToInst(self) > 200 then
					self.components.health.externalabsorbmodifiers = SourceModifierList(self, 0, SourceModifierList.additive)
					self.components.temperature.inherentsummerinsulation = 0
					self.number = 0
					v.sign[self] = 0
					if self.fx and self.fx1 then
						self.fx.AnimState:PlayAnimation("pst")
					end
					-- self:ListenForEvent("animqueueover", function(inst,data)
						-- inst.fx:DoTaskInTime(0.5,inst.fx.Remove)
					-- end)
					if self.addbuff[v] then
						self.addbuff[v] = nil
						if self.fx1 then	
							self.fx1 = nil
							self.fx = nil
						end
					end
				else
					if self.fx == nil then
						self.fx = SpawnPrefab("tz_shadowunbrella")
						self.fx.Transform:SetScale( 0.5, 0.5, 0.5)
						self.fx.Transform:SetPosition(0,4,0)
						self.fx.entity:SetParent(self.entity)
					end 
					self.fx1 = SpawnPrefab("tz_reticuleaoesmall")
					self.fx1.Transform:SetScale( 0.5, 0.5, 0.5)
					self.fx1.entity:SetParent(self.entity)
				end
			end
		end
	end)
	self.buffs1 = self:DoPeriodicTask(1, function(self)
		local x, y, z = self.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x,y,z,24,{"lostumbrella_gai"})
		for k,v in pairs(ents) do
			if v and v.components.health and v.components.locomotor then 
				if v:HasTag("lostumbrella_gai") and v.sign[self] ~= 1 and self.number < 10 then
					if self.number > 10 then
						self.number = self.number - 1
					end
					self.number = self.number + 2
					v.sign[self] = 1
				end
				if self.number ~= 0 then
					self.components.health.externalabsorbmodifiers = SourceModifierList(self, 0.05 * self.number, SourceModifierList.additive)
				end
				if not self.components.temperature then
					self:AddComponent("temperature")
					self.components.temperature.inherentsummerinsulation = TUNING.INSULATION_LARGE
				else
					self.components.temperature.inherentsummerinsulation = TUNING.INSULATION_LARGE
				end
				if self.addbuff[v] == nil then
					if not self.components.health:IsDead() then 
						self.addbuff[v] = v
						if self.fx1 == nil or self.fx == nil then
							self.fx1 = SpawnPrefab("tz_reticuleaoesmall")
							self.fx1.Transform:SetScale( 0.5, 0.5, 0.5)
							self.fx1.entity:SetParent(self.entity)
						
							self.fx = SpawnPrefab("tz_shadowunbrella")
							self.fx.AnimState:PlayAnimation("pre")
							self.fx.Transform:SetScale( 0.5, 0.5, 0.5)
							self.fx.Transform:SetPosition(0,4,0)
							self.fx.entity:SetParent(self.entity)
						end
					end
				end
			end
		end
		for k, v in pairs(self.addbuff) do
			if v and v:IsValid() and v.components.health and v.components.locomotor then 
				if v.components.health and v.components.health:IsDead() or v:GetDistanceSqToInst(self) > 240 then
					self.components.health.externalabsorbmodifiers = SourceModifierList(self, 0, SourceModifierList.additive)
					self.components.temperature.inherentsummerinsulation = 0
					self.number = 0
					v.sign[self] = 0
					-- Ly modified
					if self.fx and self.fx1 and self.fx.AnimState then
						self.fx.AnimState:PlayAnimation("pst")
					else 
						-- print("Warning:",self.fx,"doesn't have AnimState !")
					end

					if self.addbuff[v] then
						self.addbuff[v] = nil
						if self.fx1 then	
							self.fx1 = nil
							self.fx = nil
						end
					end
				else
					if self.fx == nil then
						self.fx = SpawnPrefab("tz_shadowunbrella")
						self.fx.Transform:SetScale( 0.5, 0.5, 0.5)
						self.fx.Transform:SetPosition(0,4,0)
						self.fx.entity:SetParent(self.entity)
					end
					self.fx1 = SpawnPrefab("tz_reticuleaoesmall")
					self.fx1.Transform:SetScale( 0.5, 0.5, 0.5)
					self.fx1.entity:SetParent(self.entity)
				end
			end
		end
	end)
	self.load = OnLoad
	self.save = OnSave
end)