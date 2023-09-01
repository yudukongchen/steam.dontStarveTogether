local Krm_Packer = Class(function(self, inst)
	self.inst = inst
	self.canpackfn = nil
	self.package = nil
	self.name = nil
end)

function Krm_Packer:HasPackage()
	return self.package ~= nil
end

function Krm_Packer:DefaultCanPackTest(target)  --目标待改
	return target
		and target:IsValid()
		and not target:IsInLimbo()
		and not target.prefab:find("hermithouse")
		and not (
			target:HasTag("teleportato")
			--or target:HasTag("irreplaceable")
			or target:HasTag("player")
			or target:HasTag("nonpackable")
			or target:HasTag("companion")
			or target:HasTag("character")
			or target.prefab =="beequeenhive"
			or target.prefab =="cave_entrance"
			or target.prefab =="cave_entrance_ruins"
			or target.prefab =="cave_entrance_open"
			or target.prefab == "multiplayer_portal"
			or target.prefab == "plant_normal"
		)
end

function Krm_Packer:CanPack(target)
	return self.inst:IsValid()
		and not self:HasPackage()
		and self:DefaultCanPackTest(target)
end

function Krm_Packer:Pack(target)
	if target and target.prefab ~= "myhouse" then
	self.package = {
		prefab1 = target:GetSaveRecord(),
	}

    if target.components.teleporter and target.components.teleporter.targetTeleporter then
        self.package.prefab2 = target.components.teleporter.targetTeleporter:GetSaveRecord()
        target.components.teleporter.targetTeleporter:Remove()
    end
	target:Remove()

    elseif target and target.prefab == "myhouse" then
    	 self.package = target
         target:Hide()
         target.Physics:SetActive(false)
    end	
	return true
end

function Krm_Packer:Unpack(pos)
	inGamePlay = false
    if self.package ~= nil and self.package.prefab == "myhouse" then 
    	self.package:Show()
    	self.package.Physics:SetActive(true)
    	if self.package.Physics ~= nil then
			self.package.Physics:Teleport(pos:Get())
		else				
			self.package.Transform:SetPosition(pos:Get())
		end

	elseif self.package ~= nil and self.package.prefab1 ~= nil then
		local target = SpawnSaveRecord(self.package.prefab1)
		if target ~= nil and target:IsValid() then
			if target.Physics ~= nil then
				target.Physics:Teleport(pos:Get())
			else				
				target.Transform:SetPosition(pos:Get())
			end
			if target.components.inventoryitem ~= nil then
				target.components.inventoryitem:OnDropped(true, .5)
			end
			--SpawnPrefab("miao_packbox_fx").Transform:SetPosition( pos:Get() )
		end
        if self.package.prefab2 then
            local prefab2 = SpawnSaveRecord(self.package.prefab2)
            if prefab2 and target.components.teleporter and prefab2.components.teleporter then
            	print("3")	
                prefab2.components.teleporter:Target(target)
                target.components.teleporter:Target(prefab2)
            end
        end
	else
		--self
	end
	self.package = nil
	inGamePlay = true
end

function Krm_Packer:OnSave()
	if self.package then
		return {package = self.package,name = self.name }
	end
end

function Krm_Packer:OnLoad(data)
	if data then
		if  data.package then
			self.package = data.package
		end
		if  data.name then
			self.name = data.name
		end
	end
end

return Krm_Packer
