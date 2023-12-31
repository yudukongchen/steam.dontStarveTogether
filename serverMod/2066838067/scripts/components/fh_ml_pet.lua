local PetLeash = Class(function(self, inst)
    self.inst = inst

    self.petprefab = nil
    self.pets = {}
    self.maxpets = 99
    self.numpets = 0


    self.onspawnfn = nil
    self.ondespawnfn = nil
    self._onremovepet = function(pet)
        if self.pets[pet] ~= nil then
            self.pets[pet] = nil
            self.numpets = self.numpets - 1
        end
    end
end)

function PetLeash:IsFull()
    return self.numpets >= self.maxpets
end

function PetLeash:SetPetPrefab(prefab)
    self.petprefab = prefab
end

function PetLeash:SetOnSpawnFn(fn)
    self.onspawnfn = fn
end

function PetLeash:SetOnDespawnFn(fn)
    self.ondespawnfn = fn
end

function PetLeash:GetPets()
    return self.pets
end

function PetLeash:RemoveTime() 
    for k, v in pairs(self.pets) do
        if v:IsValid() and v.components.timer then
            v.components.timer:StopTimer("Dead")
        end
    end
end

function PetLeash:StartTimer(time) 
    for k, v in pairs(self.pets) do
        if v:IsValid() and v.components.timer then
            v.components.timer:StartTimer("Dead",time)
        end
    end
end

local function LinkPet(self, pet)
    self.pets[pet] = pet
    self.inst:ListenForEvent("onremove", self._onremovepet, pet)
    pet.persists = false
    self.numpets = self.numpets + 1
    if self.inst.components.leader ~= nil then
        self.inst.components.leader:AddFollower(pet)
    end
end

function PetLeash:SpawnPetAt(x, y, z,prefaboverride)
    local petprefab = prefaboverride or self.petprefab
    if self:IsFull() then
        return 
    end
    local pet = SpawnPrefab(petprefab)
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

    return pet
end

function PetLeash:DespawnPet(pet)
    if self.pets[pet] ~= nil then
        if self.ondespawnfn ~= nil then
            self.ondespawnfn(self.inst, pet)
        else
            pet:Remove()
        end
    end
end

function PetLeash:DespawnAllPets()
    local toremove = {}
    for k, v in pairs(self.pets) do
        table.insert(toremove, v)
    end
    for i, v in ipairs(toremove) do
        self:DespawnPet(v)
    end
end

function PetLeash:OnSave()
    if next(self.pets) ~= nil then
        local data = {}
        for k, v in pairs(self.pets) do
            local saved--[[, refs]] = v:GetSaveRecord()
            table.insert(data, saved)
        end
        return { pets = data }
    end
end

function PetLeash:OnLoad(data)
    if data ~= nil and data.pets ~= nil then
        for i, v in ipairs(data.pets) do
            local pet = SpawnSaveRecord(v)
            if pet ~= nil then
                LinkPet(self, pet)
                if self.onspawnfn ~= nil then
                    self.onspawnfn(self.inst, pet)
                end
            end
        end
    end
end

function PetLeash:OnRemoveFromEntity()
    for k, v in pairs(self.pets) do
        self.inst:RemoveEventCallback("onremove", self._onremovepet, v)
    end
end

PetLeash.OnRemoveEntity = PetLeash.DespawnAllPets

return PetLeash
