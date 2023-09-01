require "behaviours/wander"
require "behaviours/faceentity"
require "behaviours/panic"
require "behaviours/follow"

local BrainCommon = require("brains/braincommon")

local MIN_FOLLOW_DIST = 0
local TARGET_FOLLOW_DIST = 7
local MAX_FOLLOW_DIST = 10

local SIT_DOWN_DISTANCE = 10

local PLATFORM_WANDER_DIST = 4
local WANDER_DIST = 12

--- Minigames
local function WatchingMinigame(inst)
	return (inst.components.follower.leader ~= nil and inst.components.follower.leader.components.minigame_participator ~= nil) and inst.components.follower.leader.components.minigame_participator:GetMinigame() or nil
end
local function WatchingMinigame_MinDist(inst)
	local minigame = WatchingMinigame(inst)
	return minigame ~= nil and minigame.components.minigame.watchdist_min or 0
end
local function WatchingMinigame_TargetDist(inst)
	local minigame = WatchingMinigame(inst)
	return minigame ~= nil and minigame.components.minigame.watchdist_target or 0
end
local function WatchingMinigame_MaxDist(inst)
	local minigame = WatchingMinigame(inst)
	return minigame ~= nil and minigame.components.minigame.watchdist_max or 0
end

local function GetFaceTargetFn(inst)
    return inst.components.follower.leader
end

local function KeepFaceTargetFn(inst, target)
    return inst.components.follower.leader == target
end
local WobyBigBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function WobyBigBrain:OnStart()
    local root = PriorityNode(
    {
        WhileNode(function() return self.inst.components.hauntable ~= nil and self.inst.components.hauntable.panic end, "PanicHaunted", Panic(self.inst)),
        -- These two are kept separatly because we have different animations for mounting vs. opening and feeding
        --FaceEntity(self.inst, GetRiderFn, KeepRiderFn),
        --FaceEntity(self.inst, GetWalterInteractionFn, KeepGenericInteractionFn, nil, "sit_alert_tailwag"),

        Follow(self.inst, function() return self.inst.components.follower.leader end,
                     MIN_FOLLOW_DIST, 4, 8, true),
        --FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
    }, .25)

    self.bt = BT(self.inst, root)
end

return WobyBigBrain
