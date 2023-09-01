require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/wander"
require "behaviours/doaction"
require "behaviours/avoidlight"
require "behaviours/panic"
require "behaviours/attackwall"
require "behaviours/useshield"

local BrainCommon = require "brains/braincommon"

local MIN_FOLLOW_DIST = 2
local TARGET_FOLLOW_DIST = 3
local MAX_FOLLOW_DIST = 4

local MAX_WANDER_DIST = 32

local function GetFaceTargetFn(inst)
    return inst.components.follower.leader
end

local function KeepFaceTargetFn(inst, target)
    return inst.components.follower.leader == target
end

local TzBookSurpassingBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function TzBookSurpassingBrain:OnStart()
    local root =
        PriorityNode(
        {
            Follow(self.inst, function() return self.inst.components.follower.leader end, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST),
            IfNode(function() return self.inst.components.follower.leader ~= nil end, "HasLeader",
                FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn )),
            Wander(self.inst, function() return (self.inst.components.follower.leader or self.inst):GetPosition() end, MAX_WANDER_DIST)
        }, 1)
    self.bt = BT(self.inst, root)
end

function TzBookSurpassingBrain:OnInitializationComplete()

end

return TzBookSurpassingBrain
