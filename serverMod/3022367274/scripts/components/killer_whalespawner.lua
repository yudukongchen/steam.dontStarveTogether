return Class(
    function(self, inst)
        assert(TheWorld.ismastersim, 'Killer_whalelSpawner should not exist on client')

        self.inst = inst

        local _scheduledtasks = {}
        local _kws = {}

        local function TestKillerwhaleSpawnPoint(x, y, z)
            local tile_at_spawnpoint = TheWorld.Map:GetTileAtPoint(x, y, z)
            return TheWorld.Map:IsOceanAtPoint(x, y, z) and
                (tile_at_spawnpoint == WORLD_TILES.OCEAN_SWELL or tile_at_spawnpoint == WORLD_TILES.OCEAN_ROUGH) and
                not TheWorld.Map:GetPlatformAtPoint(x, z)
        end

        local function SpawnFollowerKillerwhale(x, y, z, leader)
            local killer_whale = SpawnPrefab('killer_whale')
            killer_whale.Transform:SetPosition(x, y, z)
            killer_whale.components.amphibiouscreature:OnEnterOcean()
            killer_whale.sg:GoToState('eat_pst')
            killer_whale.components.follower:SetLeader(leader)
        end

        local function SpawnGroup(leader)
            if not leader or not leader:IsValid() then
                return
            end
            -- print("start spawn killerwhale group")
            local x, y, z = leader.Transform:GetWorldPosition()
            local theta = math.random() * 2 * PI / 3
            local maxnum = 4
            for r = 5, 10, 5 do
                for ntheta = theta, 2 * PI, 2 * PI / 3 do
                    if math.random() < .4 and maxnum > 0 then
                        local dx = x + r * math.cos(ntheta)
                        local dz = z + r * math.sin(ntheta)
                        if TestKillerwhaleSpawnPoint(dx, y, dz) then
                            self.inst:DoTaskInTime(
                                math.random(),
                                function()
                                    SpawnFollowerKillerwhale(dx, y, dz, leader)
                                end
                            )
                            maxnum = maxnum - 1
                        end
                    end
                end
            end
        end

        local function testforkiller_whale(spawnpoint)
            local spawn_x = spawnpoint.x
            local spawn_z = spawnpoint.z
            local killer_whale = SpawnPrefab('killer_whale')
            killer_whale.killer_whale_size = 1.8 + .2 * math.random()
            killer_whale.Transform:SetPosition(spawn_x, 0, spawn_z)
            killer_whale.components.amphibiouscreature:OnEnterOcean()
            killer_whale.sg:GoToState('eat_pst')
            killer_whale:DoTaskInTime(
                0.1,
                function()
                    killer_whale.components.killer_whalecharacteristics:Add(STRINGS.KILLER_WHALEC.TOULING)
                end
            )
            SpawnGroup(killer_whale)
            self.inst.components.timer:StartTimer('spawn_killerwhale', 10)
        end

        local function SpawnSchoolForPlayer(player, reschedule)
            if self:ShouldSpawnANewSchoolForPlayer(player) then
                local spawnpoint = self:GetSpawnPoint(player:GetPosition())
                if spawnpoint ~= nil then
                    self:SpawnSchool(spawnpoint)
                end
            end

            _scheduledtasks[player] = nil
            reschedule(player)
        end

        local function ScheduleSpawn(player)
            if _scheduledtasks[player] == nil then
                _scheduledtasks[player] =
                    player:DoTaskInTime(GetRandomMinMax(10, 300), SpawnSchoolForPlayer, ScheduleSpawn)
            end
        end

        local function CancelSpawn(player)
            if _scheduledtasks[player] ~= nil then
                _scheduledtasks[player]:Cancel()
                _scheduledtasks[player] = nil
            end
        end

        local function OnPlayerJoined(src, player)
            ScheduleSpawn(player)
        end

        local function OnPlayerLeft(src, player)
            CancelSpawn(player)
        end

        --Initialize variables
        for i, v in ipairs(AllPlayers) do
            ScheduleSpawn(v)
        end

        local function StopTrackingKW(ent)
            self.inst:RemoveEventCallback('onremove', StopTrackingKW, ent)
            if _kws[ent] ~= nil then
                _kws[ent] = nil
            end
        end

        local function StartTrackingKW(inst, data)
            local ent = data.target
            if ent then
                if not _kws[ent] then
                    _kws[ent] = true
                    self.inst:ListenForEvent('onremove', StopTrackingKW, ent)
                end
            end
        end

        --Register events
        inst:ListenForEvent('ms_playerjoined', OnPlayerJoined, TheWorld)
        inst:ListenForEvent('ms_playerleft', OnPlayerLeft, TheWorld)
        inst:ListenForEvent('kw_spawned', StartTrackingKW)

        function self:ShouldSpawnANewSchoolForPlayer(player)
            local judge = true
            if _kws then
                local pos = Vector3(player.Transform:GetWorldPosition())
                for _, v in pairs(_kws) do
                    if _:IsValid() and pos:DistSq(Vector3(_.Transform:GetWorldPosition())) < 90000 then
                        judge = false
                        break
                    end
                end
            end
            if not self.inst.components.timer:TimerExists('spawn_killerwhale') then
                return judge
            end
        end

        function self:GetSpawnPoint(pt)
            local function TestSpawnPoint(offset)
                local x, y, z = (pt + offset):Get()
                return TestKillerwhaleSpawnPoint(x, y, z)
            end
            local theta = math.random() * 2 * PI
            local resultoffset =
                FindValidPositionByFan(theta, 20 + math.random() * 4, 8, TestSpawnPoint) or
                FindValidPositionByFan(theta, 25 + math.random() * 4, 12, TestSpawnPoint) or
                FindValidPositionByFan(theta, 30 + math.random() * 4, 16, TestSpawnPoint) or
                nil
            if resultoffset ~= nil then
                return pt + resultoffset
            end
        end

        function self:SpawnSchool(spawnpoint)
            if spawnpoint == nil then
                return
            end
            testforkiller_whale(spawnpoint)
        end

        function self:OnSave()
            return {}
        end

        function self:OnLoad(data)
        end
    end
)
