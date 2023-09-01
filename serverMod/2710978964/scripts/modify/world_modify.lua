--[[
世界：
1、记录岛屿 必须是有名称的 StaticLayoutIsland:xxx岛。初始岛没有设置名字
2、修改月亮裂缝的生成位置 每个有记录的岛都有一些点
3、瓶中信管理器添加可查找记录过的岛，
4、玩家进入游戏时给予额外物品。（取消了第一次进入才给的限制）会给个钓鱼竿。（已经更改为每个钓鱼竿都添加绑定组件，但仅包里的一根会绑定，其他未绑定）
]]



---------------------------------------------
--开局赠送 海钓杆\船套装\桨

-- local function IsStart(name)
--     if TheWorld.components.worldstate.data.new_fishing[name] == nil then
--         TheWorld.components.worldstate.data.new_fishing[name] = 0
--         return true
--     end
--     return false
-- end

local function SelectPoint(i)
    local node = TheWorld.topology.nodes[i]
    local t = {}
    -- 一共选10次点，不至于全非陆地。
    for a = 1, 10 do
        local points_x, points_y = TheWorld.Map:GetRandomPointsForSite(node.x, node.y, node.poly, 1)

        for idx, x in pairs(points_x) do
            if TheWorld.Map:IsLandTileAtPoint(x, 0, points_y[idx]) then
                table.insert(t, {x, points_y[idx]}) 
            end
        end 
    end
    return t
end
--为裂缝选择区域
local function SelectArea(t)
    local points = {}
    for _, i in pairs(t) do
        local a_point = SelectPoint(i)
        for i, v in pairs(a_point or {}) do
            table.insert(points, v)
        end
    end
    return points
end

local rift_portal_defs = require("prefabs/rift_portal_defs")
local RIFTPORTAL_FNS = rift_portal_defs.RIFTPORTAL_FNS
local RIFTPORTAL_CONST = rift_portal_defs.RIFTPORTAL_CONST

AddPrefabPostInit("world", function(inst)
    if inst.ismastersim then --判断是不是主机

        inst:AddComponent("daywalkerspawner") -- 添加噩梦猪人boss刷新组件

        -- if inst.components.worldstate and inst.components.worldstate.data and inst.components.worldstate.data.new_fishing == nil then --利用组件保存
        --     inst.components.worldstate.data.new_fishing = {} -- 仅第一次进入游戏
        -- end

        inst:ListenForEvent("ms_playerspawn", function(inst, player)
            local CurrentOnNewSpawn = player.OnNewSpawn or function() return true end -- 记录角色本身开局物品
            player.OnNewSpawn = function(...)
                -- if IsStart(player.userid) then
                player.components.inventory.ignoresound = true
                if Gift_OF then --开局礼物
                    local items = {}
                    local wp = Bobbers and {"boat_item","oar","footballhat","messagebottle","spear","trinket_8"}
                        or {"boat_item","oar","footballhat","messagebottle","spear"}
                    for _,name in pairs(wp) do  --船套装 桨 猪皮帽 瓶中信 长矛 硬化橡胶塞
                        local item = SpawnPrefab(name)
                        SetSpellCB(item, player)
                        table.insert(items, item)
                    end
                    local gift = SpawnPrefab("gift")
                    gift.components.unwrappable:WrapItems(items) --打包物品
                    for i, v in ipairs(items) do --删除生成出来的
                        v:Remove()
                    end
                    player.components.inventory:GiveItem(gift)
                end

                -- end
                -- 赌狗模式 额外赠送火把
                if gambling_dog then
                    player.components.inventory:GiveItem(SpawnPrefab("torch")) --火把
                end
                -- 海钓竿
                local of = SpawnPrefab("oceanfishingrod")
                if of.components.binding == nil then
                    of:AddComponent("binding")
                end
                SetSpellCB(of, player)
                player.components.inventory:GiveItem(of) --海钓杆  

                return CurrentOnNewSpawn(...)
            end
        end)
        inst:DoTaskInTime(0,function()
            -- 记录岛id
            local lands = {}

            for i, id in ipairs(TheWorld.topology.ids) do -- 旧档新添加岛屿, 不会改变顺序
                local str = string.split(id,":")
                if str[1] == "StaticLayoutIsland" then --初始岛不需要节点，也不会记录
                    table.insert(lands,i)
                end
            end 
            
            TheWorld.topology.lands = lands
            if TheWorld.components.messagebottlemanager then 
                TheWorld.components.messagebottlemanager.lands = lands
            end
            
            -- 记录可选裂缝坐标（不会包含初始岛）
            if not TheWorld.lunarrift_portal_points then 
                TheWorld.lunarrift_portal_points = SelectArea(lands)
            end

            RIFTPORTAL_FNS.CreateRiftPortalDefinition("lunarrift_portal", {
                GetNextRiftSpawnLocation = function(_map, rift_def)
                    local points = TheWorld.lunarrift_portal_points or {}
                    shuffleArray(points) --洗牌打乱
                    local function existlunarrift(x,y)  -- 在60范围内存在裂缝
                        for i, v in ipairs(TheSim:FindEntities(x, 0, y, 60, {"lunarrift_portal"})) do
                            return true
                        end
                    end

                    for i, v in ipairs(points) do --可能存在非常差劲的情况, 毕竟岛小
                        if not existlunarrift(v[1], v[2]) then
                            return v[1], v[2]
                        end
                    end

                    -- 可能一个也没有
                end,
                Affinity = RIFTPORTAL_CONST.AFFINITY.LUNAR,
            })
            RIFTPORTAL_FNS.CreateRiftPortalDefinition("shadowrift_portal", {
                GetNextRiftSpawnLocation = function(_map, rift_def)
                    local points = TheWorld.lunarrift_portal_points or {}
                    shuffleArray(points) --洗牌打乱
                    local function existlunarrift(x,y)  -- 在60范围内存在裂缝
                        for i, v in ipairs(TheSim:FindEntities(x, 0, y, 60, {"lunarrift_portal"})) do
                            return true
                        end
                    end

                    for i, v in ipairs(points) do --可能存在非常差劲的情况, 毕竟岛小
                        if not existlunarrift(v[1], v[2]) then
                            return v[1], v[2]
                        end
                    end

                    -- 可能一个也没有
                end,
                Affinity = RIFTPORTAL_CONST.AFFINITY.SHADOW,
            })
        end)    

        -- 添加自动清理
        if RegularCleaning > 0 then
            --注册清理事件
            inst:ListenForEvent("of_clean", function(inst)
                of_clean()
            end)
            --第3天开始清理
            inst:DoPeriodicTask(RegularCleaning*480, function(inst) if TheWorld.state.cycles>3 then inst:PushEvent("of_clean") end end, 15)
            inst:DoPeriodicTask(RegularCleaning*480, function(inst) if TheWorld.state.cycles>3 then TheNet:Announce("15秒后开始清理") end end, 0)
        end 

    end
end)

