local Killerwhalefriend =
    Class(
    function(self, inst)
        self.inst = inst
        self.friend = false
        self.follower = nil
        self.exist = false
        self.whaledata = nil
    end
)

function Killerwhalefriend:makefriend(tar)
    self.inst.components.leader:AddFollower(tar)
    self.friend = true
    self.follower = tar
    self.exist = true
end

function Killerwhalefriend:breakoff(tar)
    tar.components.follower:StopFollowing()
    self.friend = false
    self.follower = nil
    self.exist = false
    tar:DoTaskInTime(
        4,
        function()
            tar.sg:GoToState('leave')
        end
    )
end

function Killerwhalefriend:death()
    self.friend = false
    self.follower = nil
    self.exist = false
end

function Killerwhalefriend:leave(tar)
    self.exist = false
    self.whaledata = tar:GetSaveRecord()

    if tar.leave_event == nil then
        tar.leave_event =
            tar:DoPeriodicTask(
            1.0,
            function()
                if not tar.components.health:IsDead() and not tar.sg:HasStateTag('busy') then
                    tar.leave_event:Cancel()
                    tar.components.amphibiouscreature:OnEnterOcean()
                    tar.sg:GoToState('leave')
                end
            end
        )
    end
end

function Killerwhalefriend:OnSave()
    local references = {}

    local data = {
        friend = self.friend,
        exist = self.exist,
        whaledata = self.whaledata
    }

    -- if self.follower then
    --     print('follower.GUID 是' .. self.follower.GUID)
    --     data.follower = self.follower.GUID
    --     table.insert(references, self.follower.GUID)
    -- end

    return data, references
end

function Killerwhalefriend:OnLoad(data)
    self.friend = data.friend
    self.exist = data.exist
    self.whaledata = data.whaledata
end

-- function Killerwhalefriend:LoadPostPass(newents, savedata)
--     print('savedata 是')
--     print(savedata)
--     print('savedata.follower 是')
--     print(savedata.follower)
--     if savedata ~= nil and savedata.follower ~= nil then
--         local targEnt = newents[savedata.follower]
--         if targEnt ~= nil then
--             self.follower = targEnt.entity
--         end
--     end
-- end

return Killerwhalefriend
