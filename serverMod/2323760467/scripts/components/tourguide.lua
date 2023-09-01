
local TourGuide = Class(function(self, inst)
    self.inst = inst
    self.touristList = {}
    self.tourists = {}
    self:Setup()
end)


local function getFloorSpawnPoint(inst, dist)
    local pt = Vector3(inst.Transform:GetWorldPosition())
    local theta = math.random() * 2 * PI
--    local radius = 13
    local radius = 8
    local offset = FindWalkableOffset(pt, theta, dist or radius, 12, true)
    if offset then
--        local pos = pt + offset
        local pos = pt + offset
        if TheWorld.Map:IsPassableAtPoint(pos.x, pos.y, pos.z) then return pos end
    end
    return nil
end


local function getherAllTourist(inst)
    for follower,_ in pairs(inst.components.leader.followers) do
        for prefab,_ in pairs(inst.components.tourguide.touristList) do
            if follower.prefab == prefab then
                inst.components.tourguide:GetherNearPlayer(inst, follower, 4)
                follower:PushEvent("hornplayed")        
            end
        end
    end
end


function TourGuide:Setup()
	local inst = self.inst

    inst:ListenForEvent("hornplayed", getherAllTourist)

    -- override inst.OnSave
    local old_OnSave = inst.OnSave
    inst.OnSave = function(inst, data)
        if old_OnSave then old_OnSave(inst, data) end
        inst.components.tourguide:inst_OnSave(inst, data)
    end 

    -- oberride inst.inst.OnLoad
    local old_OnLoad = inst.OnLoad
    inst.OnLoad = function(inst, data)
        if old_OnLoad then old_OnLoad(inst, data) end
        inst.components.tourguide:inst_OnLoad(inst, data)
    end   

    local old_RemoveAllFollowers = inst.components.leader.RemoveAllFollowers
    function inst.components.leader:RemoveAllFollowers()
--        print("---- RemoveAllFollowers()")
        self.inst.components.tourguide:BackupTourists(self.followers)
        old_RemoveAllFollowers(self)
    end
end


function TourGuide:BackupTourists(followers)
--    print("---- TourGuide:BackupTourists()")
    self.tourists = {}
    for follower,valid in pairs(followers) do
        if valid then
            for prefab,_ in pairs(self.touristList) do
                if follower.prefab == prefab then
                    self.tourists[follower] = true
                    break
                end
            end
        end
    end
end


function TourGuide:AddPrefabToList(prefab)
    self.touristList[prefab] = true
end


function TourGuide:SaveTourist(tourist, data)
--    print("---- TourGuide:SaveTourist()")
    if data then
        data.tourists = data.tourists or {}
        local record = tourist:GetSaveRecord() or nil
        table.insert(data.tourists, record)
    end
end


function TourGuide:GetherNearPlayer(inst, tourist, dist)
    if not tourist then return end

    local pos = getFloorSpawnPoint(inst, dist) or Point(inst.Transform:GetWorldPosition())
    tourist.Physics:Teleport(pos.x, pos.y, pos.z) --x,y,z
--    tourist:InterruptBufferedAction()
--    tourist:ClearBufferedAction()
end


function TourGuide:LoadTourist(record)
    local inst = self.inst
    local tourist = SpawnSaveRecord(record) or nil
    if tourist and tourist:IsValid() then
--        local pos = getFloorSpawnPoint(inst) or Point(inst.Transform:GetWorldPosition())
--        tourist.Physics:Teleport(pos.x, pos.y, pos.z) --x,y,z
        self.GetherNearPlayer(inst, tourist)
        inst.components.leader:AddFollower(tourist)
    end
end


function TourGuide:inst_OnSave(inst, data)
--    print("---- TourGuide:inst_OnSave()")
    for tourist,_ in pairs(self.tourists) do
        self:SaveTourist(tourist, data)
--        tourist:Remove() debug
    end
end


function TourGuide:inst_OnLoad(inst, data)
    if data and data.tourists then
        for k,record in pairs(data.tourists) do
--            self:LoadTourist(record)
            inst:DoTaskInTime(0.5, function() self:LoadTourist(record) end)
        end
    end
end

function TourGuide:DespawnAllTourist()
--    print("---- TourGuide:DespawnAllTourist()")
    for tourist,_ in pairs(self.tourists) do
        tourist:Remove()
    end
end

TourGuide.OnRemoveEntity = TourGuide.DespawnAllTourist

return TourGuide
