require "behaviours/standstill"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/panic"
require "behaviours/follow"
require "behaviours/chaseandattack"

local MIN_FOLLOW_DIST = 1
local TARGET_FOLLOW_DIST = 12
local MAX_FOLLOW_DIST = 5

local nl_doctorbrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function FindFoodAction(inst)
    local target = FindEntity(inst, 30, function(item) return inst.components.eater:CanEat(item) and item:IsOnPassablePoint(true) end)
    return target ~= nil and BufferedAction(inst, target, ACTIONS.EAT) or nil
end

local function GetLeader(inst)
    return inst.components.follower.leader
end

local function distcount(inst)
    if inst.components.follower ~= nil and inst.components.follower.leader == nil then
        return false
    end
    local x,y,z = inst.components.follower.leader.Transform:GetWorldPosition()
    local dis = inst:GetDistanceSqToPoint(x,y,z)
    if inst.components.combat.target then
        return dis > TARGET_FOLLOW_DIST * TARGET_FOLLOW_DIST + 40
    else
        return dis > MAX_FOLLOW_DIST * MAX_FOLLOW_DIST + 20
    end
end

function nl_doctorbrain:OnStart()
    local root = PriorityNode(
    {
        WhileNode(function()
			return self.inst.components.health:GetPercent() < 0.3
		end, "runaway",
		ChattyNode(self.inst, { "你不要过来啊啊啊啊啊啊" }, RunAway(self.inst, "scarytoprey", 6, 36))),
      
        WhileNode(function()
			return self.inst.components.combat.target == nil or not self.inst.components.combat:InCooldown()
		end, "chase",
		ChattyNode(self.inst, { "求你了，让我咬一口嘛" }, ChaseAndAttack(self.inst, 50, 16))),

        WhileNode(function() return self.inst.components.combat.target and self.inst.components.combat:InCooldown() end, "walkA",
		RunAway(self.inst, function() return self.inst.components.combat.target end, 3, 6)),

        WhileNode(function() 
            local judge = distcount(self.inst)
            return judge 
        end, "Follow",
        Follow(self.inst, GetLeader, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST)),

        WhileNode(function()
            return self.inst.components.follower ~= nil and self.inst.components.follower.leader == nil
		end, "findfood",
		ChattyNode(self.inst, { "发现好吃的" }, DoAction(self.inst, FindFoodAction, "eat food", true))),

        WhileNode(function()
            return true end, "wander",
            Wander(self.inst, nil, nil,{
                minwalktime =  2,
                randwalktime = 1.5,
                minwaittime = 3,
                randwaittime = 4
            })),
    }, .25)

    self.bt = BT(self.inst, root)
end

return nl_doctorbrain
