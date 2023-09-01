local function onname(self,name)
    if name ~= nil then
        self.inst:AddTag("haselongname")
        self.inst.AnimState:PlayAnimation("idle2")
        self.inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_elong_aohorn.xml"
        self.inst.components.inventoryitem:ChangeImageName("tz_elong_aohorn")
    else
        self.inst:RemoveTag("haselongname")
    end
end

local aowu_elong = Class(function(self, inst)
    self.inst = inst

    self.pet = nil
    self.name = nil
    self.savedpet = nil

    self.onspawnfn = nil
    self.ondespawnfn = nil

    self._deathpet = function()
        self.inst.persists = false
        self.inst:DoTaskInTime(1.2,self.inst.Remove)
    end
    self._onremovepet = function(pet)
        if self.pet ~= nil then
            self.pet = nil
        end
    end
end,
nil,
{
    name = onname,
}
)

function aowu_elong:SetName(name)
    self.name = name
    if self.inst.components.named then
        self.inst.components.named:SetName(self.inst:GetBasicDisplayName().."•"..name)
    end
end

function aowu_elong:SetOnSpawnFn(fn)
    self.onspawnfn = fn
end

function aowu_elong:SetOnDespawnFn(fn)
    self.ondespawnfn = fn
end


function aowu_elong:IsFull()
    return self.pet ~= nil
end

function aowu_elong:GetPet()
    return self.pet
end

local function LinkPet(self, pet)
    self.pet = pet
    self.inst:ListenForEvent("onremove", self._onremovepet, pet)
    self.inst:ListenForEvent("death", self._deathpet, pet)
    pet.persists = false

    if self.inst.components.leader ~= nil then
        self.inst.components.leader:AddFollower(pet)
    end
end

local function getpos(doer)
    local theta = math.random() * 2 * PI
    local pt = doer:GetPosition()
    local radius = 2
    local offset = FindWalkableOffset(pt, theta, radius, 6, true)
    if offset ~= nil then
        pt.x = pt.x + offset.x
        pt.z = pt.z + offset.z
    end
    return pt
end

function aowu_elong:SpawnPet(prefaboverride,doer)
    local petprefab = prefaboverride
    if petprefab == nil then
        return nil
    end

    local pet = SpawnPrefab(petprefab)
    if pet ~= nil then
        LinkPet(self, pet)
        if self.name ~= nil and pet.components.named then
            pet.components.named:SetName(self.name)
        end
        local x,y,z = getpos(doer):Get() 
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

function aowu_elong:SpawnSavedPet(doer)
    local pet = SpawnSaveRecord(self.savedpet)
    if pet ~= nil then
        LinkPet(self, pet)
        local x,y,z = getpos(doer):Get() 
        if pet.Physics ~= nil then
            pet.Physics:Teleport(x, y, z)
        elseif pet.Transform ~= nil then
            pet.Transform:SetPosition(x, y, z)
        end
        if self.onspawnfn ~= nil then
            self.onspawnfn(self.inst, pet)
        end
        self.savedpet = nil
    end
end

function aowu_elong:DoDespawnPet()
    if self.pet ~= nil then
        self.savedpet = self.pet:GetSaveRecord()
        if self.ondespawnfn ~= nil then
            self.ondespawnfn(self.inst, self.pet)
        else
            self.pet:Remove()
        end
    end
end

function aowu_elong:DespawnPet()
    if self.pet ~= nil then
        if self.ondespawnfn ~= nil then
            self.ondespawnfn(self.inst, self.pet)
        else
            self.pet:Remove()
        end
    end
end

function aowu_elong:OnSave()
    local pet  = nil
    if self.pet ~= nil then
        pet = self.pet:GetSaveRecord()
    end

    return {pet = pet ,name = self.name ,savedpet = self.savedpet}
end

function aowu_elong:OnLoad(data)
    if data ~= nil then
        if data.name then
            self.name = data.name
        end
        if data.savedpet then
            self.savedpet = data.savedpet
        end

        if data.pet then
            self.inst:DoTaskInTime(0.1,function()
                local pet = SpawnSaveRecord(data.pet)
                if pet ~= nil then
                    LinkPet(self, pet)
                    if self.onspawnfn ~= nil then
                        self.onspawnfn(self.inst, pet)
                    end
                end
            end)
        end
    end
end

function aowu_elong:OnRemoveFromEntity()
    if self.pet then
        self.inst:RemoveEventCallback("onremove", self._onremovepet, self.pet)
        self.inst:RemoveEventCallback("death", self._deathpet, self.pet)
    end
end

aowu_elong.OnRemoveEntity = aowu_elong.DespawnPet

return aowu_elong
