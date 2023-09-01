require "behaviours/chaseandattack"
require "behaviours/leash"
require "behaviours/wander"
require "behaviours/doaction"
--[[
local MIN_FOLLOW_DIST = 2
local MAX_FOLLOW_DIST = 15
local TARGET_FOLLOW_DIST = 5
local START_FACE_DIST = 14
]]
local MIN_FOLLOW_DIST = 2
local MAX_FOLLOW_DIST = 7
local TARGET_FOLLOW_DIST = 5
local START_FACE_DIST = 14

local DragonflyBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function DragonflyBrain:SetLeader(userid)
    _leader = userid
end

local function GetLeader(inst)
    return inst.components.follower.leader
end


function DragonflyBrain:OnStart()
    local root =
        PriorityNode(
        {
			Follow(self.inst, GetLeader, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST),
            ChaseAndAttack(self.inst),
            Wander(self.inst)
        }, .25)
    self.bt = BT(self.inst, root)
end

return DragonflyBrain
