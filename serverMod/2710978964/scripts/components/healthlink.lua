-----------------------------
-- 【单向生命链接状态】
-- 单向生命链接其他玩家, 简称：指向
-- 一个玩家可以被多人指向, 但只能指向另一个玩家
-- 已经指向了一个玩家, 那么无法被玩家指向
-- 被指向玩家,生命值变化时,反馈给发出指向的玩家, 反过来并不影响
-- 玩家死亡或离开时,断开全部指向
-- 单向生命链接状态结束方法,只有玩家死亡或等待结束


-----------------------------
local LINKTIME = 60 -- 持续时间

--检查表中是否存在
local function Inspect(inst,target)
    local self = inst.components.healthlink
    return self.list[target.userid] == nil
end

local function FindClosestPlayerInRange(inst, isalive)
    local closestPlayer = {}
    for i, v in ipairs(AllPlayers) do
        if (isalive == nil or isalive ~= IsEntityDeadOrGhost(v)) and
            v.entity:IsVisible() and Inspect(inst,v) and v.userid ~= inst.userid then --目标不是自己 且目标没有链接自己
            table.insert(closestPlayer,v)
        end
    end
    return closestPlayer
end

local HealthLink = Class(function(self,inst)
	self.inst = inst
    self.list = {}
    -- 目标角色
    self.target = nil
    self:AllEvent()
end)

function HealthLink:AllEvent()
    -- 监听新增加链接目标的事件
    self.inst:ListenForEvent("addnewplayer_healthlink",function(inst,player) 
        -- print("新增加受自己影响玩家",player)
        if player ~= nil and self.list[player.userid] == nil then
            self.list[player.userid] = player
        end
        if self.of_fx == nil then --没有特效说明 没有被链接或链接别人
            self:GetColour()
            self.inst.components.healthlink:SpawnFX()
        end
    end)
    -- 监听删除链接目标的事件
    self.inst:ListenForEvent("deleteplayer_healthlink",function(inst,player)
        -- print("移除受自己影响玩家",player,self.list[player.userid]) 
        if player ~= nil and self.list[player.userid] ~= nil then
            self.list[player.userid] = nil
        end
        if table.length(self.list) == 0 then
            self:StopTimer()
        end
    end)
    --如果是来自链接的 生命变化
    self.inst:ListenForEvent("healthdelta",function(inst,data)
        if data.cause ~= "healthlink" then -- and data.afflicter.userid ~= inst.userid  允许自己伤害自己
            for k,v in pairs(self.list) do
                if v ~= nil and v:IsValid() and
                not v:HasTag("playerghost") and
                v.components.health ~= nil and
                not v.components.health:IsDead() then -- 存在且存活
                    v.components.health:DoDelta(data.amount,nil,"healthlink",nil, inst)
                end
            end
        end
    end)
    -- 如果自己死亡 断开链接 结束任务
    self.inst:ListenForEvent("death", function(inst,data) 
        self:StopTimer()
        for k,v in pairs(self.list) do
            v:PushEvent("deleteplayer_healthlink",self.inst)
        end
        self.list = {} --应该可以没有, 按要求是已经全部要
    end)
    self.inst:ListenForEvent("onremove", function(inst)
        self:StopTimer()
        for k,v in pairs(self.list) do
            v:PushEvent("deleteplayer_healthlink",self.inst)
        end    
        self.list = {} 
    end)
end

function HealthLink:GetColour()
    if self.colour == nil then
        self.colour = {
            r = math.random(1,255)/255,
            p = math.random(1,255)/255,
            c = math.random(1,255)/255,
        }   
    end
    return self.colour
end

function HealthLink:SpawnFX()
    self.of_fx = SpawnPrefab("of_reticule")
    self.of_fx.AnimState:SetMultColour(self.colour.r, self.colour.p, self.colour.c, 1)
    self.of_fx.entity:SetParent(self.inst.entity) 
end
function HealthLink:DeleTimer()
    if self.timer ~= nil then
        self.timer:Cancel() --停用
        self.timer = nil
    end
end
function HealthLink:StopTimer()
    if self.target then
        self.target:PushEvent("deleteplayer_healthlink",self.inst)
        self.target = nil
    end
    --移除特效
    if self.of_fx then
        self.of_fx:Remove()
        self.of_fx = nil
    end
    self.colour = nil
end

function HealthLink:AddTarget(target,time)
    --清除掉
    self:DeleTimer()
    self:StopTimer()
    if target == nil then --说明需要重新找一个目标
        self:LockPlayer()
        return
    end
    self.target = target
    self.target:PushEvent("addnewplayer_healthlink",self.inst)
    self.timer = self.inst:DoTaskInTime(time or LINKTIME, function(inst)
        self:StopTimer()
    end)
    if self.of_fx == nil then
        --生成特效
        self.colour = self.target.components.healthlink:GetColour()
        self:SpawnFX()
    end
end
function HealthLink:LockPlayer()
    local players = FindClosestPlayerInRange(self.inst, true)
    if #players > 0 then
        self:AddTarget(players[math.random(#players)])
        return
    end
    -- print("没有目标链接")
end

-----------------保存加载-----------------------
-- function HealthLink:OnSave()
--     local time = self.timer and GetTaskRemaining(self.timer) or 0
--     -- print("保存,剩余时间",time)
--     return { time = time}
-- end

-- function HealthLink:OnLoad(data)
--     -- print("加载数据",data.time)
--     -- 重新加入游戏，应该被人链接才对
--     self.inst:DoTaskInTime(1,function()
--         self:AddTarget(nil,data.time)
--     end)
-- end
-- -- 变猴子也继承
-- function HealthLink:TransferComponent(newinst)
--     local data = self:OnSave()
--     if data then
--         local newcomponent = newinst.components.healthlink
--         if not newcomponent then
--             newinst:AddComponent("healthlink")
--             newcomponent = newinst.components.healthlink
--         end
--         newcomponent:OnLoad(data)
--     end
-- end

return HealthLink