local PetLeashlostday = Class(function(self, inst)
    self.inst = inst

    self.petprefab = nil
    self.pets = {}
    self.maxpets = 1
    self.numpets = 0
	self.add = 0

    self.onspawnfn = nil
    self.ondespawnfn = nil

    self._onremovepet = function(pet)
        if self.pets[pet] ~= nil then
            self.pets[pet] = nil
            self.numpets = self.numpets - 1
			self.inst:PushEvent("tzpetchange")
        end
		if pet.prefab == "lostchester_gai"then
			if self.inst.components.tzsama then
				self.inst.components.tzsama:DoSpeedDelta(-1)
			end
		end
    end
	if TheWorld.ismastersim then
		self.inst:WatchWorldState( "startday", function() 
			self:CheckUp()
		end)
	end
end)

function PetLeashlostday:CheckUp()
	local today = TheWorld.state.cycles or 1
	local addcycles = math.clamp(math.floor(today/250), 0, 2)
	self.maxpets = 3 + addcycles + self.add
end

function PetLeashlostday:SetAdd(num)
	self.add = num
    self:CheckUp()
end

function PetLeashlostday:SetPetPrefab(prefab)
    self.petprefab = prefab
end

function PetLeashlostday:SetOnSpawnFn(fn)
    self.onspawnfn = fn
end

function PetLeashlostday:SetOnDespawnFn(fn)
    self.ondespawnfn = fn
end

function PetLeashlostday:SetMaxPets(num)
    self.maxpets = num
end

function PetLeashlostday:GetMaxPets()
    return self.maxpets
end

function PetLeashlostday:GetNumPets()
    return self.numpets
end

function PetLeashlostday:IsFull()
    return self.numpets >= self.maxpets
end

function PetLeashlostday:HasPetWithTag(tag)
    for k, v in pairs(self.pets) do
        if v:HasTag(tag) then
            return true
        end
    end
    return false
end

function PetLeashlostday:GetPets()
    return self.pets
end

function PetLeashlostday:IsPet(pet)
    return self.pets[pet] ~= nil
end

local function LinkPet(self, pet)
    self.pets[pet] = pet
    self.numpets = self.numpets + 1
	self.inst:PushEvent("tzpetchange")
    self.inst:ListenForEvent("onremove", self._onremovepet, pet)
    pet.persists = false
	if pet.prefab == "lostchester_gai" then
		pet.num = self.numpets 
		if self.inst.components.tzsama then
			self.inst.components.tzsama:DoSpeedDelta(1)
		end
	end
    if self.inst.components.leader ~= nil then
        self.inst.components.leader:AddFollower(pet)
    end
end

function PetLeashlostday:SpawnPetAt(x, y, z, prefaboverride, skin)
    local petprefab = prefaboverride or self.petprefab
    if self.numpets >= self.maxpets or petprefab == nil then
        return
    end

    local pet = SpawnPrefab(petprefab, skin, nil, self.inst.userid)
    if pet ~= nil then
        LinkPet(self, pet)

        if pet.Physics ~= nil then
            pet.Physics:Teleport(x, y, z)
        elseif pet.Transform ~= nil then
            pet.Transform:SetPosition(x, y, z)
        end

        if self.onspawnfn ~= nil then
            self.onspawnfn(self.inst, pet)
        end
    end
end

function PetLeashlostday:DespawnPet(pet)
    if self.pets[pet] ~= nil then
        if self.ondespawnfn ~= nil then
            self.ondespawnfn(self.inst, pet)
        else
            pet:Remove()
        end
    end
end

function PetLeashlostday:DespawnAllPets()
    local toremove = {}
    for k, v in pairs(self.pets) do
        table.insert(toremove, v)
    end
    for i, v in ipairs(toremove) do
        self:DespawnPet(v)
    end
end

function PetLeashlostday:OnSave()

	local data = {}
	
    if next(self.pets) ~= nil then
        for k, v in pairs(self.pets) do
            local saved--[[, refs]] = v:GetSaveRecord()
            table.insert(data, saved)
        end
	end
	
	return
	{
		add = self.add,
		pets = next(data) ~= nil and data or nil,
	}
end

function PetLeashlostday:OnLoad(data)
    if data ~= nil then
		if data.add ~= nil then
			self.add = data.add
		end
		self:CheckUp()
		if data.pets ~= nil then
			for i, v in ipairs(data.pets) do
				local pet = SpawnSaveRecord(v)
				if pet ~= nil then
					LinkPet(self, pet)

					if self.onspawnfn ~= nil then
						self.onspawnfn(self.inst, pet)
					end
				end
			end
			if self.inst.migrationpets ~= nil then
				for k, v in pairs(self.pets) do
					table.insert(self.inst.migrationpets, v)
				end
			end
		end
	end
end

function PetLeashlostday:OnRemoveFromEntity()
    for k, v in pairs(self.pets) do
        self.inst:RemoveEventCallback("onremove", self._onremovepet, v)
    end
end

PetLeashlostday.OnRemoveEntity = PetLeashlostday.DespawnAllPets

return PetLeashlostday
