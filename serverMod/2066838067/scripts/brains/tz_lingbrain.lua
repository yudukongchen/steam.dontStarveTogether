require "behaviours/wander"
require "behaviours/faceentity"
require "behaviours/chaseandattack"
require "behaviours/panic"
require "behaviours/follow"
require "behaviours/attackwall"
require "behaviours/standstill"
require "behaviours/leash"
require "behaviours/runaway"
require "behaviours/chaseandram"

local MIN_FOLLOW_CLOSE = 0
local TARGET_FOLLOW_CLOSE = 1.5
local MAX_FOLLOW_CLOSE = 4

local tz_ling = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function GetLeader(inst)
    return inst.components.follower.leader
end
local function GetFaceTargetFn(inst)
    return inst.components.follower.leader
end

local function KeepFaceTargetFn(inst, target)
    return inst.components.follower.leader == target
end

function tz_ling:OnStart()
    local root = 
    PriorityNode({
		Follow(self.inst, function() return self.inst.components.follower.leader end, MIN_FOLLOW_CLOSE, TARGET_FOLLOW_CLOSE, MAX_FOLLOW_CLOSE, true),
		FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
	},.25)
    self.bt = BT(self.inst, root)
 end
 
return tz_ling