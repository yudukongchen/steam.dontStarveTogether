require "behaviours/wander"
require "behaviours/faceentity"
require "behaviours/chaseandattack"
require "behaviours/panic"
require "behaviours/follow"
require "behaviours/attackwall"
require "behaviours/standstill"
require "behaviours/leash"
require "behaviours/runaway"
--flower
local MIN_FOLLOW_DIST = 0
local TARGET_FOLLOW_DIST = 7
local MAX_FOLLOW_DIST = 10

local START_FACE_DIST = 6
local KEEP_FACE_DIST = 8

local KEEP_WORKING_DIST = 14
local SEE_WORK_DIST = 10


local KITING_DIST = 3
local STOP_KITING_DIST = 5

local RUN_AWAY_DIST = 1.5
local STOP_RUN_AWAY_DIST = 2

local AVOID_EXPLOSIVE_DIST = 5


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

local function ShouldAvoidExplosive(target)
    return target.components.explosive == nil
        or target.components.burnable == nil
        or target.components.burnable:IsBurning()
end

local function ShouldRunAway(target)
    return not (target.components.health ~= nil and target.components.health:IsDead())
        and not target.components.combat ~= nil
end

local function ShouldKite(target, inst)
    return inst.components.combat:TargetIs(target)
        and target.components.health ~= nil
        and not target.components.health:IsDead()
end
local function miaomiaomiao(inst)
	for k, v in pairs(AllPlayers) do
		if v.prefab == "taizhen" then
			if not v.components.leader then
				v:AddComponent("leader")
			end
			v.components.leader:AddFollower(inst, true)
			break
		end
	end
end

local function GetWanderPosition(inst)
	if inst.components.follower and inst.components.follower.leader then
		return Point(inst.components.follower.leader.Transform:GetWorldPosition())
	else
		miaomiaomiao(inst)
	end
end

local ShadowTzBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

function ShadowTzBrain:OnStart()
    local root = PriorityNode(
    {
        WhileNode(function() return IsNearLeader(self.inst, 18) end, "Leader In Range",
        PriorityNode({
                RunAway(self.inst, { fn = ShouldAvoidExplosive, tags = { "explosive" }, notags = { "INLIMBO" } }, AVOID_EXPLOSIVE_DIST, AVOID_EXPLOSIVE_DIST),  --±¬Õ¨µÄÅÜ¿ª

                        WhileNode(function() return self.inst.components.combat:GetCooldown() > .5 and ShouldKite(self.inst.components.combat.target, self.inst) end, "Dodge",
                        RunAway(self.inst, { fn = ShouldKite, tags = { "_combat", "_health" }, notags = { "INLIMBO" } }, KITING_DIST, STOP_KITING_DIST)),
                        ChaseAndAttack(self.inst),
		}, .25)),
        RunAway(self.inst, { fn = ShouldRunAway, oneoftags = { "tzshadow" ,"tzsuicong"}, notags = { "player", "INLIMBO" } }, RUN_AWAY_DIST, STOP_RUN_AWAY_DIST),
        RunAway(self.inst, { oneoftags = { "tzxiaoyingguai" }, notags = { "INLIMBO" } }, 1.5, 2),
        Follow(self.inst, GetLeader, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST),
        WhileNode(function() return GetLeader(self.inst) ~= nil end, "Has Leader",
            FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn)),
			Wander(self.inst, GetWanderPosition, 20)
    }, .25)

    self.bt = BT(self.inst, root)
end

return ShadowTzBrain