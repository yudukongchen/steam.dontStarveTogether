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

local MAX_FOLLOW_LONGDIST = 10
local TARGET_FOLLOW_LONGDIST = 8

local MAX_FOLLOW_KEXUEDIST = 9
local TARGET_FOLLOW_KEXUEDIST = 6

local MIN_FOLLOW_DIST = 0
local MAX_FOLLOW_DIST = 8
local TARGET_FOLLOW_DIST = 6

local MAX_WANDER_DIST = 3

local MIN_FOLLOW_CLOSE = 0
local TARGET_FOLLOW_CLOSE = 1.5
local MAX_FOLLOW_CLOSE = 4

local AVOID_EXPLOSIVE_DIST = 5

local RUN_AWAY_DIST = 4
local STOP_RUN_AWAY_DIST = 8

local KITING_DIST = 4
local STOP_KITING_DIST = 8

local START_FACE_DIST = 6
local KEEP_FACE_DIST = 8
local function GetFaceTargetFn(inst)
    return inst.components.follower.leader
end

local function KeepFaceTargetFn(inst, target)
    return inst.components.follower.leader == target
end

local function ShouldRunAway(inst,target)
    return inst.components.health ~= nil
	and not (target.components.health ~= nil and target.components.health:IsDead())
   and (not target:HasTag("tzsuicong") or (target.components.combat ~= nil and target.components.combat:HasTarget()))
end


local function ShouldAvoidExplosive(target) 
    return target.components.explosive == nil
        or target.components.burnable == nil
        or target.components.burnable:IsBurning()
end
local function GetLeader(inst)
    return inst.components.follower.leader
end

local function GetLeaderPos(inst)
    return inst.components.follower.leader:GetPosition()
end

local function GetFaceTargetFn(inst)
    local target = FindClosestPlayerToInst(inst, START_FACE_DIST, true)
    return target ~= nil and not target:HasTag("notarget") and target or nil
end

local function IsNearLeader(inst, dist)
    local leader = GetLeader(inst)
    return leader ~= nil and inst:IsNear(leader, dist)
end
local function KeepFaceTargetFn(inst, target)
    return not target:HasTag("notarget") and inst:IsNear(target, KEEP_FACE_DIST)
end
local function ShouldKite(target, inst)
    return inst.components.combat:TargetIs(target)
        and target.components.health ~= nil
        and not target.components.health:IsDead()
end
local function paoapao(inst)
	return inst.prefab == "lostfight" or inst.prefab == "lostfight_gai"
end
local LostdayBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function LostdayBrain:OnStart()
    local root = PriorityNode(
    {
        WhileNode(function() return IsNearLeader(self.inst, 18) end, "Leader In Range",
            PriorityNode({
				
                RunAway(self.inst, { fn = ShouldAvoidExplosive, tags = { "explosive" }, notags = { "INLIMBO" } }, AVOID_EXPLOSIVE_DIST, AVOID_EXPLOSIVE_DIST),
				RunAway(self.inst, { fn = ShouldRunAway, oneoftags = {  "_combat", "_health"  }, notags = { "player", "INLIMBO" ,"companion","glommer","prey","bird"} }, RUN_AWAY_DIST, STOP_RUN_AWAY_DIST),
				IfNode(function() return self.inst.prefab == "lostfight" or self.inst.prefab == "lostfight_gai" end, "Is Duelist",
                    PriorityNode({
                        WhileNode(function() return self.inst.components.combat:GetCooldown() > .5 and ShouldKite(self.inst.components.combat.target, self.inst) end, "Dodge",
                            RunAway(self.inst, { fn = ShouldKite, tags = { "_combat", "_health" }, notags = { "INLIMBO" } }, KITING_DIST, STOP_KITING_DIST)),
                        ChaseAndAttack(self.inst),
                }, .25)),  
        }, .25)),
		RunAway(self.inst, { fn = paoapao, oneoftags = { "tzlostday" }, notags = { "INLIMBO" } }, 1.5, 2),
		IfNode(function() return self.inst.prefab == "lostumbrella"  end, "Follow Closely",
				Follow(self.inst, function() return self.inst.components.follower.leader end, MIN_FOLLOW_CLOSE, TARGET_FOLLOW_CLOSE, MAX_FOLLOW_CLOSE, true)),
		IfNode(function() return self.inst.prefab == "lostumbrella_gai"  end, "Follow no Closely",
				Follow(self.inst, function() return self.inst.components.follower.leader end, MIN_FOLLOW_DIST, 2.5, 5, true)),
		IfNode(function() return self.inst.prefab == "lostchester" or self.inst.prefab == "lostchester_gai" end, "Follow from Long",
				Follow(self.inst, function() return self.inst.components.follower.leader end, MIN_FOLLOW_DIST, TARGET_FOLLOW_LONGDIST, MAX_FOLLOW_LONGDIST, true)),
		IfNode(function() return (self.inst.prefab == "lostfight_gai" or self.inst.prefab == "lostfight") end, "Follow from Science",
				Follow(self.inst, function() return self.inst.components.follower.leader end, MIN_FOLLOW_DIST, TARGET_FOLLOW_KEXUEDIST, MAX_FOLLOW_KEXUEDIST, true)),			
		IfNode(function() return self.inst.prefab == "lostearth" or self.inst.prefab == "lostearth_gai" end, "Follow from Distance",
				Follow(self.inst, function() return self.inst.components.follower.leader end, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST, true)),
		WhileNode(function() return GetLeader(self.inst) ~= nil end, "Has Leader",
			FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn)),
    }, .25)

    self.bt = BT(self.inst, root)
end
return LostdayBrain
