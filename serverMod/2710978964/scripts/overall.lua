-- 换皮肤
GLOBAL.SetSpellCB = function (target,player)
    if not target:IsValid() then return false end
    player = player or target.components.inventorytarget.owner
    local target_types = {}
    if PREFAB_SKINS[target.prefab] ~= nil then
        for _,target_type in pairs(PREFAB_SKINS[target.prefab]) do
            if TheInventory:CheckClientOwnership(player.userid, target_type) then
                table.insert(target_types,target_type)
            end
        end
    end
    if #target_types<=0 then
        return false
    end
    TheSim:ReskinEntity( target.GUID, target.skinname, target_types[math.random(#target_types)], nil, player.userid ) --玩家有的随机物品皮肤
end

------------------------------
-- 随机函数
local function RandomWeight(weight_table)
    local totalchance = 0
    local number = 1
    local next = nil
    -- 计算权重表所有项的权重和
    for m, n in pairs(weight_table) do
        totalchance = totalchance + n.chance
    end

    while number > 0 do
        local next_chance = math.random()*totalchance 
        for m, n in pairs(weight_table) do
            next_chance = next_chance - n.chance
            if next_chance <= 0 then
                next = n
                break
            end
        end
        if next ~= nil then
            number = number - 1
        end
    end
    return next
end

GLOBAL.WeightRandom = WeightRandom or RandomWeight -- 可以自定义 权重方法。 用于重置权重表后，选择奖励的方法。


-- 返回指定数量 不可重复的随机项集
function table.randomnorepeat(t, need)
    local value = {}
    if #t <= need then
        return t
    end
    shuffleArray(t)
    for i = 1, need do
        table.insert(value, t[i])
    end
    return value
end
-- 返回指定数量 可重复的随机项集
function table.randomrepea(t, need)
    local value = {}
    for i = 1, need do
        table.insert(value, t[math.random(#t)])
    end
    return value
end

function table.length(t)
    local r = 0
    for _,v in pairs(t) do
        r = r + 1
    end
    return r
end

-------------------------------------
-- 控制台指令
-- GLOBAL.o_dug = function ()
--     GLOBAL.O_DUG = true
-- end

------------------------------------------------
-- 落石所需

local SMASHABLE_TAGS = { "smashable", "quakedebris", "_combat" }
local NON_SMASHABLE_TAGS = { "INLIMBO", "playerghost", "irreplaceable", "outofreach" }
local HEAVY_SMASHABLE_TAGS = { "smashable", "quakedebris", "_combat", "_inventoryitem", "NPC_workable" }
local HEAVY_NON_SMASHABLE_TAGS = { "INLIMBO", "playerghost", "irreplaceable", "caveindebris", "outofreach" }

local function UpdateShadowSize(shadow, height)
    local scaleFactor = Lerp(.5, 1.5, height / 35)
    shadow.Transform:SetScale(scaleFactor, scaleFactor, scaleFactor)
end

local function BreakDebris(debris)
    local x, y, z = debris.Transform:GetWorldPosition()
    SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(x, 0, z)
    debris:Remove()
end 

local function GetSpawnPoint(pt, rad, minrad)
    local theta = math.random() * 2 * PI
    local radius = math.random() * (rad or TUNING.FROG_RAIN_SPAWN_RADIUS)

    minrad = minrad ~= nil and minrad > 0 and minrad * minrad or nil

    local result_offset = FindValidPositionByFan(theta, radius, 12, function(offset)
        local x = pt.x + offset.x
        local z = pt.z + offset.z
        return TheWorld.Map:IsAboveGroundAtPoint(x, 0, z)
            and (minrad == nil or offset.x * offset.x + offset.z * offset.z >= minrad)
            and not TheWorld.Map:IsPointNearHole(Vector3(x, 0, z))
    end)

    return result_offset ~= nil and pt + result_offset or nil
end

local function GroundDetectionUpdate(debris, override_density, mass)
    local x, y, z = debris.Transform:GetWorldPosition()
    if y <= .2 then
        if not debris:IsOnPassablePoint(false,true) then --不是陆地或船只
            debris:PushEvent("detachchild")
            debris:Remove()
        else
            local softbounce = false
            if debris:HasTag("heavy") then --是重的
                local ents = TheSim:FindEntities(x, 0, z, 2, nil, HEAVY_NON_SMASHABLE_TAGS, HEAVY_SMASHABLE_TAGS)
                for i, v in ipairs(ents) do
                    if v ~= debris and v:IsValid() and not v:IsInLimbo() then
                        softbounce = true --软反弹
                        if v:HasTag("quakedebris") then --是地震残骸
                            local vx, vy, vz = v.Transform:GetWorldPosition()
                            SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(vx, 0, vz)
                            v:Remove()
                        elseif v.components.workable ~= nil then
                            if v.sg == nil or not v.sg:HasStateTag("busy") then
                                local work_action = v.components.workable:GetWorkAction()
                                if (    (work_action == nil and v:HasTag("NPC_workable")) or
                                        (work_action ~= nil and HEAVY_WORK_ACTIONS[work_action.id]) ) and
                                    (work_action ~= ACTIONS.DIG
                                    or (v.components.spawner == nil and
                                        v.components.childspawner == nil)) then
                                    v.components.workable:Destroy(debris)
                                end
                            end
                        elseif v.components.combat ~= nil then
                            v.components.combat:GetAttacked(debris, 30, nil) --受到攻击 30点hp
                        elseif v.components.inventoryitem ~= nil then
                            if v.components.mine ~= nil then --矿
                                v.components.mine:Deactivate()
                            end
                            Launch(v, debris, TUNING.LAUNCH_SPEED_SMALL)
                        end
                    end
                end
            else 
                local ents = TheSim:FindEntities(x, 0, z, 2, nil, NON_SMASHABLE_TAGS, SMASHABLE_TAGS)
                for i, v in ipairs(ents) do
                    if v ~= debris and v:IsValid() and not v:IsInLimbo() then
                        softbounce = true
                        if v:HasTag("quakedebris") then
                            local vx, vy, vz = v.Transform:GetWorldPosition()
                            SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(vx, 0, vz)
                            v:Remove()
                        elseif v.components.combat ~= nil and not (v:HasTag("epic") or v:HasTag("wall")) then
                            v.components.combat:GetAttacked(debris, 20, nil)
                        end
                    end
                end
            end

            debris.Physics:SetDamping(.9)

            if softbounce then
                local speed = 3.2 + math.random()
                local angle = math.random() * 2 * PI
                debris.Physics:SetMotorVel(0, 0, 0)
                debris.Physics:SetVel(
                    speed * math.cos(angle),
                    speed * 2.3,
                    speed * math.sin(angle)
                )
            end

            debris.shadow:Remove()
            debris.shadow = nil

            debris.updatetask:Cancel()
            debris.updatetask = nil

            local density = math.random()
            if density <= override_density then
                debris.persists = true
                debris.entity:SetCanSleep(true)
                debris:RestartBrain()

                debris.Physics:SetMass(mass)
                -- debris.Physics:SetDamping(5)
                -- 清醒
                if debris.components.sleeper then
                    debris.components.sleeper:WakeUp()
                end
                if debris._restorepickup then
                    debris._restorepickup = nil
                    if debris.components.inventoryitem ~= nil then
                        debris.components.inventoryitem.canbepickedup = true
                    end
                end
                debris:PushEvent("stopfalling")
            elseif debris:GetTimeAlive() < 1.5 then
                --第一次反弹
                debris:DoTaskInTime(softbounce and .4 or .6, BreakDebris)
            else
                --我们错过了第一次反弹的机会，所以这次立即破发
                BreakDebris(debris)
            end
        end
    elseif debris:GetTimeAlive() < 3 then
        if y < 2 then
            debris.Physics:SetMotorVel(0, 0, 0)
        end
        UpdateShadowSize(debris.shadow, y)
    elseif debris:IsInLimbo() then --从场景这移除了 但保持它 恢复原状态
        debris.persists = true
        debris.entity:SetCanSleep(true)
        debris.shadow:Remove()
        debris.shadow = nil
        debris.updatetask:Cancel()
        debris.updatetask = nil
        if debris._restorepickup then
            debris._restorepickup = nil
            if debris.components.inventoryitem ~= nil then
                debris.components.inventoryitem.canbepickedup = true
            end
        end
        debris:PushEvent("stopfalling")
    elseif debris.prefab == "mole" or debris.prefab == "rabbit" or debris.prefab == "carrat" then
        debris:PushEvent("detachchild")
        debris:Remove()
    else
        BreakDebris(debris)
    end
end

local function SpawnDebris(spawn_point, loot)
    local prefab = loot.item
    local Mass = 0
    if prefab ~= nil then
        local debris = SpawnPrefab(prefab)
        if debris ~= nil then
            debris.entity:SetCanSleep(false)
            debris.persists = false

            debris:StopBrain()

            if (prefab == "rabbit" or prefab == "mole" or prefab == "carrat") and debris.sg ~= nil then
                debris.sg:GoToState("fall")
            end
            if debris.components.inventoryitem ~= nil and debris.components.inventoryitem.canbepickedup then
                debris.components.inventoryitem.canbepickedup = false
                debris._restorepickup = true
            end
            if math.random() < .5 then
                debris.Transform:SetRotation(180)
            end
            if debris.Physics then
                -- 设置质量，建筑为0，默认 1 物品
                Mass = debris.Physics:GetMass() 
                debris.Physics:SetMass(1)
                debris.Physics:Teleport(spawn_point.x, 35, spawn_point.z)
                debris.Physics:SetDamping(0)
                debris.Physics:SetMotorVel(0,-30+math.random()*10,0)
            end
            -- 设置睡眠
            if debris.components.sleeper then
                debris.components.sleeper:GoToSleep(3)
            end
            debris.shadow = SpawnPrefab("warningshadow")
            debris.shadow:ListenForEvent("onremove", function(debris) debris.shadow:Remove() end, debris)
            debris.shadow.Transform:SetPosition(spawn_point.x, 0, spawn_point.z)
            UpdateShadowSize(debris.shadow, 35)

            debris.updatetask = debris:DoPeriodicTask(FRAMES, GroundDetectionUpdate, nil, loot.chance, Mass)
            debris:PushEvent("startfalling")
        end
        return debris
    end
end
local function DoDropForPlayer(player, reschedulefn, dt, loots, need, rad, minrad)
    local px, py, pz = player.Transform:GetWorldPosition()
    local char_pos = Vector3(px, py, pz)
    local spawn_point = GetSpawnPoint(char_pos, rad, minrad)
    local loot = WeightRandom(loots)
    if spawn_point ~= nil then
        SpawnDebris(spawn_point, loot)
    end
    reschedulefn(player, dt, loots, need-1, rad, minrad)
end

GLOBAL.SpawnDebrisLoots = function(player, dt, loots, need, rad, minrad)
    if need <= 0 then return end
    if player.droptask ~= nil then
        player.droptask:Cancel()
    end
    player.droptask = player:DoTaskInTime(dt+math.random()*0.1, DoDropForPlayer, SpawnDebrisLoots, dt, loots, need, rad, minrad)
end


local function SpawnGrow(spawn_point, loot)
    local prefab = loot.item
    local Mass = 0
    if prefab ~= nil then
        local debris = SpawnPrefab(prefab)
        if debris ~= nil then
            if math.random() < .5 then
                debris.Transform:SetRotation(180)
            end
            -- 设置睡眠
            if debris.components.sleeper and not loot.sleeper then
                debris.components.sleeper:GoToSleep(3)
            end

            debris.Transform:SetPosition(spawn_point.x, 0, spawn_point.z)

            if loot.fn ~= nil and type(loot.fn) == "function" then
                loot.fn(debris, spawn_point.x, 0, spawn_point.z)
            end
        end
        return debris
    end
end
local function DoGrowForPlayer(player, reschedulefn, dt, loots, need, rad, minrad)
    local px, py, pz = player.Transform:GetWorldPosition()
    local char_pos = Vector3(px, py, pz)
    local spawn_point = GetSpawnPoint(char_pos, rad, minrad)
    local loot = WeightRandom(loots)
    if spawn_point ~= nil then
        SpawnGrow(spawn_point, loot)
    end
    reschedulefn(player, dt, loots, need-1, rad, minrad)
end

GLOBAL.SpawnGrowTheGround = function(player, dt, loots, need, rad, minrad)
    if need <= 0 then return end
    if player.growtask ~= nil then
        player.growtask:Cancel()
    end
    player.growtask = player:DoTaskInTime(dt+math.random()*0.1, DoGrowForPlayer, SpawnGrowTheGround, dt, loots, need, rad, minrad)
end


--------------------------------
-- 天体英雄的环型激光
local BASE_NUM_ANGULAR_STEPS = 10
local SWEEP_ANGULAR_LENGTH = 30
local BASE_SWEEP_DISTANCE = 8
local MIN_SWEEP_DISTANCE = 3
local SECOND_BLAST_TIME = 22*FRAMES
GLOBAL.SpawnSweep = function(inst, target_pos)
    local gx, gy, gz = inst.Transform:GetWorldPosition()

    local angle = nil
    local dist = nil
    local angle_step_dir = 1
    local x_dir = 1

    if target_pos == nil then
        angle = DEGREES * (inst.Transform:GetRotation() + (SWEEP_ANGULAR_LENGTH/2))
        dist = BASE_SWEEP_DISTANCE
        x_dir = -1
        angle_step_dir = -1
    else
        angle = math.atan2(gz - target_pos.z, gx - target_pos.x) - (SWEEP_ANGULAR_LENGTH * DEGREES/2)
        dist = math.max(math.sqrt(inst:GetDistanceSqToPoint(target_pos:Get())), MIN_SWEEP_DISTANCE)
    end

    local num_angle_steps = BASE_NUM_ANGULAR_STEPS + RoundBiasedDown((math.abs(dist) - BASE_SWEEP_DISTANCE) / 2)
    local angle_step = (SWEEP_ANGULAR_LENGTH / num_angle_steps) * DEGREES

    local targets, skiptoss = {}, {}
    local sbtargets, sbskiptoss = {}, {}
    local x, z = nil, nil
    local delay = nil

    local i = -1
    while i < num_angle_steps do
        i = i + 1
        delay = math.max(0, i - 1)*FRAMES

        x = gx - (x_dir * dist * math.cos(angle))
        z = gz - dist * math.sin(angle)
        angle = angle + (angle_step_dir * angle_step)

        local first = (i == 0)
        local x1, z1 = x, z
        inst:DoTaskInTime(delay, function(inst2)
            local fx = SpawnPrefab("alterguardian_laser")
            fx.Transform:SetPosition(x1, 0, z1)
            fx:Trigger(0, targets, skiptoss)
        end)

        inst:DoTaskInTime(delay + SECOND_BLAST_TIME, function(inst2)
            local fx = SpawnPrefab("alterguardian_laser")
            fx.Transform:SetPosition(x1, 0, z1)
            fx:Trigger(0, sbtargets, sbskiptoss, true)
        end)
    end

    inst:DoTaskInTime(i*FRAMES, function(inst2)
        local fx = SpawnPrefab("alterguardian_laser")
        fx.Transform:SetPosition(x, 0, z)
        fx:Trigger(0, targets, skiptoss)
    end)

    inst:DoTaskInTime((i+1)*FRAMES, function(inst2)
        local fx = SpawnPrefab("alterguardian_laser")
        fx.Transform:SetPosition(x, 0, z)
        fx:Trigger(0, targets, skiptoss)
    end)
end


-- 添加岛屿 参数 布局名称、是否忽略已有同名岛
GLOBAL.of_spawnlayout = function(name, ignore)
    local obj_layout = require("map/object_layout")
    local entities = {}
    local map_width, map_height = TheWorld.Map:GetSize()
    local add_fn = {
        fn=function(prefab, points_x, points_y, current_pos_idx, entitiesOut, width, height, prefab_list, prefab_data, rand_offset)
        print("adding, ", prefab, points_x[current_pos_idx], points_y[current_pos_idx])
            local x = (points_x[current_pos_idx] - width/2.0)*TILE_SCALE
            local y = (points_y[current_pos_idx] - height/2.0)*TILE_SCALE
            x = math.floor(x*100)/100.0
            y = math.floor(y*100)/100.0
            SpawnPrefab(prefab).Transform:SetPosition(x, 0, y)
        end,
        args={entitiesOut=entities, width=map_width, height=map_height, rand_offset = false, debug_prefab_list=nil}
    }
    local function AddSquareTopology(topology, left, top, size, room_id, tags)
        print("  添加节点",room_id)
        local index = #topology.ids + 1
        topology.ids[index] = room_id
        topology.story_depths[index] = 0

        local node = {}
        node.area = size * size
        node.c = 1 -- colour index
        node.cent = {left + (size / 2), top + (size / 2)}
        node.neighbours = {}
        node.poly = { {left, top},
                      {left + size, top},
                      {left + size, top + size},
                      {left, top + size}
                    }
        node.tags  = tags
        node.type = NODE_TYPE.Default
        node.x = node.cent[1]
        node.y = node.cent[2]

        node.validedges = {}

        topology.nodes[index] = node
    end
    -- 判断节点名称是否已经有了
    local function topology_room(name)
        local roomid = "StaticLayoutIsland:"..name
        for k, v in pairs(TheWorld.topology.ids) do -- 可以直接换成 table.contains
            if v == roomid then
                return k
            end
        end
        return
    end
    local function is_ocean(_left, _top, tile_size)
        for x = 0, tile_size do
            for y = 0, tile_size do
                local tile = TheWorld.Map:GetTile(_left + x, _top + y)
                if tile < GROUND.OCEAN_COASTAL or tile > GROUND.OCEAN_WATERLOG then
                    return false
                end
            end
        end
        return true
    end
    local function getdt()
        local layout = obj_layout.LayoutForDefinition(name)
        if not ignore and topology_room(name) then print("存在该房间") return end
        if layout == nil then print("找不到目标地形："..name) return end
        local tile_size = #layout.ground
        local candidtates = {}
        local topology_delta = 1
        local num_steps = math.floor((map_width - tile_size) / tile_size) --向下取整,比如世界宽100地皮,布局10*10地皮, 90/10 = 9
        for x = 0, num_steps do
            for y = 0, num_steps do
                local left = 8 + (x > 0 and ((x * math.floor(map_width / num_steps)) - tile_size - 16) or 0) -- 大概是限制距离地图边界
                local top  = 8 + (y > 0 and ((y * math.floor(map_height / num_steps)) - tile_size - 16) or 0)
                if is_ocean(left, top, tile_size) then -- 目标区域全部地皮是否满足条件
                    table.insert(candidtates, {top = top, left = left})
                end
            end
        end
        print("  有" ..tostring(#candidtates) .. "区域，符合条件")
        if #candidtates > 0 then
            local world_size = (tile_size + (topology_delta*2))*4

            shuffleArray(candidtates) -- 洗牌打乱
            for _, candidtate in ipairs(candidtates) do
                local top, left = candidtates[1].top, candidtates[1].left
                local world_top, world_left = (left-topology_delta)*4 - (map_width * 0.5 * 4), (top-topology_delta)*4 - (map_height * 0.5 * 4)


                -- 替换地皮,物品
                obj_layout.Place({left, top}, name, add_fn, nil, TheWorld.Map)

                -- 添加节点
                if layout.add_topology ~= nil then
                    local room_id = layout.add_topology.room_id or "StaticLayoutIsland:"..name
                    AddSquareTopology(TheWorld.topology, world_top, world_left, world_size,not ignore and room_id or (room_id..#TheWorld.topology.ids), layout.add_topology.tags)
                end

                return true

            end
        end
    end

    if getdt() then
        TheNet:Announce("生成了全新岛屿")
        return
    end
    TheNet:Announce("已存在或未找到合适位置生成新岛屿")
end

--------------------------------
-- debug
GLOBAL.getval = function(fn, path)
    local val = fn
    for entry in path:gmatch("[^%.]+") do -- 正则: 取一个或多个任意字符的补集
        local i=1
        while true do
            local name, value = GLOBAL.debug.getupvalue(val, i) -- 此函数返回函数 val 的第 i 个上值的名字和值。 如果该函数没有那个上值，返回 nil 。 值为任意类型
            if name == entry then 
                val = value
                break
            elseif name == nil then -- 到最后，也没有找到
                return
            end
            i=i+1
        end
    end
    return val
end
GLOBAL.setval = function(fn, path, new)
    local val = fn
    local prev = nil
    local i
    for entry in path:gmatch("[^%.]+") do
        i = 1
        prev = val
        while true do
            local name, value = GLOBAL.debug.getupvalue(val, i)
            -- print("参数", name or "nil")
            if name == entry then
                val = value
                break
            elseif name == nil then
                return
            end
            i=i+1
        end
    end

    GLOBAL.debug.setupvalue(prev, i ,new) -- 这个函数将 new 设为函数 prev 的第 i 个上值。 如果函数没有那个上值，返回 nil 否则，返回该上值的名字。 
end