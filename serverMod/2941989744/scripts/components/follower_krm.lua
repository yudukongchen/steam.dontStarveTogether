local follower_krm = Class(function(self, inst)
    self.inst = inst
    self.pets = {}
	self.beefalo = {}
end)

local function LinkPet(self, pet,beefalo)
	local x, y, z = self.inst.Transform:GetWorldPosition()
    if pet.Physics ~= nil then
        pet.Physics:Teleport(x, y, z)
    elseif pet.Transform ~= nil then
        pet.Transform:SetPosition(x, y, z)
    end
    if not beefalo and self.inst.components.leader ~= nil then
        self.inst.components.leader:AddFollower(pet)
    end
	if beefalo and self.inst.components.rider and not self.qiniu then
		self.inst.components.rider:Mount(pet, true)
		self.qiniu = true
	end
end

local need = {
	krm_key = true,
	krm_broom = true,
	krm_book = true,
}

local function Container_WithTag(self,tag)
    local containers = {}
    for i = 1, self.numslots do
        local item = self.slots[i]
        if item ~= nil then
            if need[item.prefab] then
                item:RemoveTag(tag)
				if item.components.follower_krm then
					item.components.follower_krm:Active()
				end
            elseif item.components.container ~= nil then
                table.insert(containers, item)
            end
        end
    end
    for i, v in ipairs(containers) do
        Container_WithTag(v.components.container,tag)
    end
end

local function RemoveWithTag(self,tag)
    local containers = {}

    if self.activeitem ~= nil then
        if need[self.activeitem.prefab] then
            self.activeitem:RemoveTag(tag)
			if self.activeitem.components.follower_krm then
				self.activeitem.components.follower_krm:Active()
			end
        elseif self.activeitem.components.container ~= nil then
            table.insert(containers, self.activeitem)
        end
    end

    for k = 1, self.maxslots do
        local v = self.itemslots[k]
        if v ~= nil then
            if need[v.prefab] then
                v:RemoveTag(tag)
				if v.components.follower_krm then
					v.components.follower_krm:Active()
				end
            elseif v.components.container ~= nil then
                table.insert(containers, v)
            end
        end
    end

    for k, v in pairs(self.equipslots) do
        if need[v.prefab] then
            v:RemoveTag(tag)
			if v.components.follower_krm then
				v.components.follower_krm:Active()
			end
        elseif v.components.container ~= nil then
            table.insert(containers, v)
        end
    end
    for i, v in ipairs(containers) do
        Container_WithTag(v.components.container,tag)
    end
end

function follower_krm:Active()
	if self.inst.components.inventory ~= nil then
		RemoveWithTag(self.inst.components.inventory,"irreplaceable")
	end
	if self.inst.components.leader ~= nil then
		self.pets = {}
		for k,v in pairs(self.inst.components.leader.followers) do
			if k and k.persists then
				local saved = k:GetSaveRecord()
				table.insert(self.pets, saved)
				k:Remove()
			end
		end
	end
	-- local x, y, z = self.inst.Transform:GetWorldPosition()
	-- local ents = TheSim:FindEntities(x, y, z, 8, {"beefalo"})
	-- for _,v in pairs(ents) do
		-- if v.components.domesticatable and v.components.rideable and not v.components.rideable:IsBeingRidden()
			-- and not (v.ownerlist ~= nil and v.ownerlist.master ~= nil and v.ownerlist.master ~= self.inst.userid) then
			-- local saved = v:GetSaveRecord()
			-- table.insert(self.pets, saved)	
			-- v:Remove()			
		-- end
	-- end
end

function follower_krm:SaveBeefalo()
	if self.inst.components.rider ~= nil then
		local rider = self.inst.components.rider
		if rider.mount ~= nil  then
			local saved = rider.mount:GetSaveRecord()
			table.insert(self.beefalo, saved)	
			rider.mount:Remove()
		end
	end
	if self.inst.components.leader ~= nil then
		for k,v in pairs(self.inst.components.leader.followers) do
			if k and k.persists then
				local saved = k:GetSaveRecord()
				table.insert(self.beefalo, saved)
				k:Remove()
			end
		end
	end
end

function follower_krm:OnSave()
    if next(self.pets) ~= nil then
        return { pets = self.pets }
	elseif next(self.beefalo) ~= nil then
		return { beefalo = self.beefalo }
    end
end

function follower_krm:OnLoad(data)
    if data ~= nil then
		if data.pets ~= nil then
			self.inst:DoTaskInTime(0.1,function()
				for i, v in ipairs(data.pets) do
					local pet = SpawnSaveRecord(v)
					if pet ~= nil then
						LinkPet(self, pet,false)
					end
				end
			end)
		elseif data.beefalo ~= nil then
			for i, v in ipairs(data.beefalo) do
				local pet = SpawnSaveRecord(v)
				if pet ~= nil then
					self.inst:DoTaskInTime(0.11,function()
						LinkPet(self, pet,true)
					end)
				end
			end		
		end
	end
end

return follower_krm
