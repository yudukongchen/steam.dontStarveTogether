---------------------------------------------
-- messagebottlemanager -- 使得瓶子可以查看其他岛屿
AddComponentPostInit("messagebottlemanager",function(self)
    self.lands = nil
    -- 希望有兼容效果
    if self.player_lands == nil then
        self.player_lands = {} -- 记录玩家查看过的岛屿
        local old_UseMessageBottle = self.UseMessageBottle
        self.UseMessageBottle = function(self, bottle, doer, is_not_from_hermit)
            if self.player_lands[doer.userid] == nil then
                self.player_lands[doer.userid] = {}
            end
            --每使用瓶中信都会随机打乱
            for k,i in pairs(self.lands and shuffleArray(self.lands) or {}) do 
                if table.reverselookup(self.player_lands[doer.userid],i) == nil then
                    table.insert(self.player_lands[doer.userid],i)
                    local node = TheWorld.topology.nodes[i]
                    -- local x,z = TheWorld.Map:GetRandomPointsForSite(node.x, node.y, node.poly, 1) --本来想随机一点的 出bug 就不要啦
                    -- return Vector3(x,0,z), "REVEAL_OTHER_ISLANDS"
                    return Vector3(node.x, 0, node.y), "REVEAL_OTHER_ISLANDS"
                end
            end
            return old_UseMessageBottle(self, bottle, doer, is_not_from_hermit)
        end

        local old_Save = self.OnSave
        local old_Load = self.OnLoad

        self.OnSave = function(self)
            local data = old_Save(self) or {}

            if next(self.player_lands) ~= nil then
                data.player_lands = self.player_lands
            end

            return data        
        end

        self.OnLoad = function(self,data)
            old_Load(self,data)
            if data ~= nil then
                if data.player_lands ~= nil and next(data.player_lands) ~= nil then
                    for k, v in pairs(data.player_lands) do
                        self.player_lands[k] = v
                    end
                end            
            end 
        end
    end
end)

---------------------------------------------
-- alterguardian_phase3dead 被击败的天体英雄
-- 清理当前世界上召唤天体英雄的组件，防止数量太多
AddPrefabPostInit("alterguardian_phase3dead", function(inst)
    inst:DoTaskInTime(0,function(inst)
        TheWorld:PushEvent("onremove_alterguardian")
    end)
end)
local phase3dead = {
    "moon_altar_ward",
    "moon_altar_seed",
    "moon_altar_idol",
    "moon_altar_icon",
    "moon_altar_glass",
    "moon_altar_crown",
    "moonrockseed",
}
for k,i in pairs(phase3dead) do
    AddPrefabPostInit(i,function(inst)
        inst:ListenForEvent("onremove_alterguardian",function(word)
            inst:Remove()
        end,TheWorld)
    end)
end

-- 启迪陷阱 不要月亮碎片
AddPrefabPostInit("alterguardian_phase3trap",function(inst)
    if inst.components.lootdropper then
        inst.components.lootdropper:SetLoot({})
        -- inst.components.lootdropper.ifnotchanceloot = nil
        inst.components.lootdropper.chanceloottable = nil
    end
end)

---------------------------------------------
-- 修改麦斯威尔的犬牙陷阱
AddPrefabPostInit("trap_teeth_maxwell", function(inst)
    if TheWorld.ismastersim then --判断是不是主机
        if inst.components.mine then
            inst.components.mine:SetRadius(1.5)
            inst.components.mine:SetTestTimeFn(function()return 0.75 end)
        end
    end
end)

AddComponentPostInit("mine",function(self) 
    local mine_test_fn = function(dude, inst)
        return not (dude.components.health ~= nil and
                    dude.components.health:IsDead())
            and dude.components.combat:CanBeAttacked(inst)
    end
    local mine_test_tags = { "monster", "character", "animal" }
    -- See entityreplica.lua
    local mine_must_tags = { "_combat" }
    local function MineTest(inst, self)
        if self.radius ~= nil then
            local notags = { "notraptrigger", "flying", "ghost", "playerghost", "spawnprotection"}
            table.insert(notags, self.alignment) -- 移除它,默认alignment 忽略玩家

            local target = FindEntity(inst, self.radius, mine_test_fn, mine_must_tags, notags, mine_test_tags)
            if target ~= nil then
                self:Explode(target)
            end
        end
    end
    self.StartTesting = function(self)
        if self.testtask ~= nil then
            self.testtask:Cancel()
        end
        local next_test_time = self.testtimefn ~= nil and self.testtimefn(self.inst) or (1 + math.random())
        self.testtask = self.inst:DoPeriodicTask(next_test_time, MineTest, 0, self)  --只要重置了就直接开始搜索     
    end
end)

---------------------------------------------
-- 修改骨架
local ATRIUM_RANGE = 8.5
local function ActiveStargate(gate)
    return gate:IsWaitingForStalker()
end
local STARGET_TAGS = { "stargate" }
local function OnAccept(inst, giver, item)
    if item.prefab == "shadowheart" then
        local stalker
        if TheWorld.state.isnight then
            stalker = SpawnPrefab("stalker_forest")
        else
            local stargate = FindEntity(inst, ATRIUM_RANGE, ActiveStargate, STARGET_TAGS) -- 查找大门
            if stargate ~= nil then
                stalker = SpawnPrefab("stalker_atrium")
                stalker.components.entitytracker:TrackEntity("stargate", stargate)
                stargate:TrackStalker(stalker) -- 跟踪者
            else
                stalker = SpawnPrefab("stalker")
            end
        end

        local x, y, z = inst.Transform:GetWorldPosition()
        local rot = inst.Transform:GetRotation()
        inst:Remove()

        stalker.Transform:SetPosition(x, y, z)
        stalker.Transform:SetRotation(rot)
        stalker.sg:GoToState("resurrect")

        giver.components.sanity:DoDelta(TUNING.REVIVE_SHADOW_SANITY_PENALTY)
    end
end

AddPrefabPostInit("fossil_stalker", function(inst)
    if TheWorld.ismastersim and not TheWorld:HasTag("cave") then --是服务器且不是洞穴
        if inst.components.trader then
            inst.components.trader:SetAbleToAcceptTest(function(...) return true end)
            inst.components.trader.onaccept = OnAccept
        end
    end
end)

------------------------------
-- 船身组件
AddComponentPostInit("hull", function(self, inst)
    local AttachEntityToBoat_ = self.AttachEntityToBoat 
    self.AttachEntityToBoat = function(self, obj, offset_x, offset_z, parent_to_boat)
        -- 仅删除着火点
        if obj.prefab == "burnable_locator_medium" then
            obj:Remove()
        else
            AttachEntityToBoat_(self, obj, offset_x, offset_z, parent_to_boat)
        end
    end
end)

------------------------------
--世界组件
--防止钓其 蘑菇精 在水面上时，生成月亮孢子 导致调用的方法没有检查组件
AddComponentPostInit("flotsamgenerator",function(self)
    local old_SpawnFlotsam = self.SpawnFlotsam
    self.SpawnFlotsam = function(self,spawnpoint,prefab,notrealflotsam)
        if not prefab then --不想复制私有方法到这里，那么记录原方法，遇到让它去调用
            return old_SpawnFlotsam(self,spawnpoint,prefab,notrealflotsam)
        end

        if prefab == nil then
            return
        end

        local flotsam = SpawnPrefab(prefab)
        if math.random() < .5 then
            flotsam.Transform:SetRotation(180)
        end
        if flotsam.Physics then --判断一下是否存在物理
            flotsam.Physics:Teleport(spawnpoint:Get())
        end

        self:setinsttoflotsam(flotsam, nil, notrealflotsam)

        return flotsam
    end 

end)

--藏宝 
--更改宝藏点生成机制 防止地少卡循环而崩溃
AddComponentPostInit("piratespawner",function(self)
    self.FindStashLocation = function(self)
        local locationOK = false
        local pt = Vector3(0,0,0)
        local offset = Vector3(0,0,0)
        local i = 1
        while locationOK == false or i < 10 do
            local ids = {}
            for node, i in pairs(TheWorld.topology.nodes)do
                local ct = TheWorld.topology.nodes[node].cent
                if TheWorld.Map:IsVisualGroundAtPoint(ct[1], 0, ct[2]) then --在陆地上
                    table.insert(ids,node)
                end
            end
            if #ids == 0 then
                break
            end
            local randnode =  TheWorld.topology.nodes[ids[math.random(1,#ids)]]
            pt = Vector3(randnode.cent[1],0,randnode.cent[2])
            local theta = math.random()* 2 * PI
            local radius = 4 
            offset = Vector3(radius * math.cos( theta ), 0, -radius * math.sin( theta ))

            while  TheWorld.Map:IsVisualGroundAtPoint(pt.x, 0, pt.z) == true do
                pt = pt + offset
            end
            --原本检查 这个点10地皮范围内玩家是否存在
            local players = FindPlayersInRange( pt.x, pt.y, pt.z, 3*4, true ) 
            if #players == 0  then
                locationOK = true
            end
            i = i+1
        end
        if not locationOK then --附近岸边找一个点
            local dest_x, dest_y, dest_z = FindRandomPointOnShoreFromOcean(pt.x, pt.y, pt.z)
            if dest_x then
                offset.x,offset.y,offset.z = dest_x, dest_y, dest_z
            end
        end
        return pt - (offset *2)
    end 

end)

----------------------------------------
-- 致命亮茄 钓起了或T出来被冰冻会因为没有 back 而报错
local function spawnback(inst)
    local back = SpawnPrefab("lunarthrall_plant_back")
    --back.Transform:SetPosition(inst.Transform:GetWorldPosition())
    back.AnimState:SetFinalOffset(-1)
    inst.back = back
    table.insert(inst.highlightchildren, back)
    back:ListenForEvent("onremove", function() back:Remove() end, inst)

    back:ListenForEvent("death", function()
        local self = inst.components.burnable
        if self ~= nil and self:IsBurning() and not self.nocharring then
            back.AnimState:SetMultColour(.2, .2, .2, 1)
        end
    end, inst)

    if math.random() < 0.5 then
        inst.AnimState:SetScale(-1,1)
        back.AnimState:SetScale(-1,1)
    end
    local color = .6 + math.random() * .4
    inst.tintcolor = color
    inst.AnimState:SetMultColour(color, color, color, 1)
    back.AnimState:SetMultColour(color, color, color, 1)
    inst:AddChild(back)

    inst.components.colouradder:AttachChild(back)
end
AddPrefabPostInit("lunarthrall_plant", function(inst)
    --加载时执行
    inst.OnLoadPostPass = function(inst)
        if inst.components.entitytracker:GetEntity("targetplant") then
            inst:infest(inst.components.entitytracker:GetEntity("targetplant"),true)
        else
            spawnback(inst)
        end      
    end
    inst:DoTaskInTime(0,function(inst)
        if not inst.components.entitytracker:GetEntity("targetplant") and inst.back == nil then
            spawnback(inst)
        end
    end)
end)

-----------------------------------------------------
if Bobbers then
    -----------------------------------------------------
    -- 更改浮标描述。
    local bobbers ={
        twigs = "可以作为浮标, 可禁止钓起道具物品",
        oceanfishingbobber_ball = "可以作为浮标, 可禁止钓起特殊事件",
        oceanfishingbobber_oval = "可以作为浮标, 可禁止钓起穿戴类",
        trinket_8 = "可以作为浮标, 可双倍钓起",
        oceanfishingbobber_robin = "可以作为浮标, 可禁止钓起食材类",
        oceanfishingbobber_canary = "可以作为浮标, 可禁止钓起移植类",
        oceanfishingbobber_crow = "可以作为浮标, 可禁止钓起生物类",
        oceanfishingbobber_robin_winter = "可以作为浮标, 可禁止钓起建筑类",
        oceanfishingbobber_goose = "可以作为浮标, 可禁止钓起基础材料",
        oceanfishingbobber_malbatross = "可以作为浮标,可禁止钓起巨型生物类",
    }
    for name, desc in pairs(bobbers) do
        AddPrefabPostInit(name, function(inst)
            if inst.components.inspectable then
                inst.components.inspectable.description = desc
            end 
        end)
    end
    -----------------------------------------------------
    -- 容器 按索引消耗物品 钓竿渔具可堆叠时 仅消耗一个
    AddComponentPostInit("container",function(self)
        self.ConsumeByKey = function(self, index, amount)
            local item = self.slots[index]
            if item == nil or (amount and amount < 0) then return 0 end --不存在物品

            if item.components.stackable == nil then
                self:RemoveItem(item):Remove()
                return 1
            elseif item.components.stackable.stacksize > amount then
                item.components.stackable:SetStackSize(item.components.stackable.stacksize - amount)
                return amount
            else
                amount = item.components.stackable.stacksize
                self:RemoveItem(item, true):Remove()
                return amount
            end

            return 0   
        end
    end)
end

----
--[[
"crabking_spawner", --帝王蟹刷新点
"dragonfly_spawner", --龙蝇刷新点
"antlion_spawner", --蚁狮刷新点
"beequeenhive", --蜂后
]]


AddPrefabPostInit("crabking",function(inst)
    -- 注册死亡时事件 是帝王蟹刷新点的 触发生成地形
    inst:ListenForEvent("death",function(inst)
        if inst.components.homeseeker then
            local home = inst.components.homeseeker.home
            if home ~= nil and home:IsValid() and home.prefab == "crabking_spawner" then
                of_spawnlayout("NineGrid")
            end
        end
    end)
end)

-------------------------------------
-- 小妾和星空 可以跨海岸线
AddPrefabPostInit("chester",function(inst)
    inst:DoTaskInTime(0,function(inst)
        inst.Physics:ClearCollisionMask()                           --Physics物理 清除碰撞遮罩
        --与 地面、障碍物、小型障碍物、人物、boss碰撞，但不与海洋陆地界限碰撞
        inst.Physics:SetCollisionMask(COLLISION.GROUND,COLLISION.OBSTACLES, COLLISION.SMALLOBSTACLES, COLLISION.CHARACTERS,COLLISION.GIANTS)
    end)
    -- 防溺水
    if inst.components and inst.components.drownable then
        inst.components.drownable.enabled = false
    end 
end)
AddPrefabPostInit("hutch",function(inst)
    inst:DoTaskInTime(0,function(inst)
        inst.Physics:ClearCollisionMask()                           --Physics物理 清除碰撞遮罩
        --与 地面、障碍物、小型障碍物、人物、boss碰撞，但不与海洋陆地界限碰撞
        inst.Physics:SetCollisionMask(COLLISION.GROUND,COLLISION.OBSTACLES, COLLISION.SMALLOBSTACLES, COLLISION.CHARACTERS,COLLISION.GIANTS)
    end)
    -- 防溺水
    if inst.components and inst.components.drownable then
        inst.components.drownable.enabled = false
    end 
end)

---------------------------------------
-- 守护者暗影触手 防止其攻击暗影生物(攻击了织影者，看不见的手设置攻击目标为它。它然后检查攻击目标时没有sg 会崩)
-- 选择攻击目标时，忽略暗影生物
AddPrefabPostInit("bigshadowtentacle",function(inst)
    if inst.components and inst.components.combat then
        inst.components.combat:SetRetargetFunction(0.5, function(inst)
            return FindEntity(
                inst,
                TUNING.TENTACLE_ATTACK_DIST,
                function(guy)
                    return guy.prefab ~= inst.prefab
                        and guy.entity:IsVisible()
                        and not guy.components.health:IsDead()
                        and (guy.components.combat.target == inst or
                            guy:HasTag("character") or
                            guy:HasTag("monster") or
                            guy:HasTag("animal"))
                        and (guy:HasTag("player") or (guy.sg and not guy.sg:HasStateTag("hiding")) )
                end,
                { "_combat", "_health" },
                { "minotaur", "shadowcreature"})--忽略暗影生物
        end)
    end 
end)


---------------------------------
-- 修改三boss
-- hook 修改蚁狮 OnInit方法不使用Despawn方法
AddPrefabPostInit("antlion",function(inst)
    local function OnInit(inst)
        inst.inittask = nil
        --沙尘暴改变了
        inst.onsandstormchanged = function(src, data)
            -- if data.stormtype == STORM_TYPES.SANDSTORM and not data.setting then
            --     Despawn(inst)
            --     print("ms_stormchanged事件触发，执行到这里了")
            -- end
        end
        inst:ListenForEvent("ms_stormchanged", inst.onsandstormchanged, TheWorld) --监听风暴变化 改为就是变了也没有
        -- if not (TheWorld.components.sandstorms ~= nil and TheWorld.components.sandstorms:IsSandstormActive()) then
        --     Despawn(inst)
        --     print("执行到这里了")
        -- end
    end
    if inst.StopCombat then
        print("暂停战斗方法")
        setval(inst.StopCombat,"OnInit",OnInit)
    end
    if inst.inittask then
        inst.inittask:Cancel()
        inst.inittask = inst:DoTaskInTime(0, OnInit)
    end
end)
-- 更改鹿鸭 使其非春天生成出来后脱离仇恨就立马飞走
AddPrefabPostInit("world",function(inst)
    inst:DoTaskInTime(0,function(inst)
        if GLOBAL.Prefabs["moose"] then
            setval(GLOBAL.Prefabs["moose"].fn, "OnSpringChange", function() end)
        end
    end)
end)
--更改邪天翁 使其能够在陆地上不飞走
local brain = require("brains/malbatrossbrain")
setval(brain.OnStart, "ShouldLeaveLand", function() end)