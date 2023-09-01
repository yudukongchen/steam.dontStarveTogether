require "behaviours/wander"
require "behaviours/faceentity"
require "behaviours/panic"
require "behaviours/follow"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/chaseandattack"

local SkeletonWarriorBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local MIN_FOLLOW_DIST = 0.00001
local TARGET_FOLLOW_DIST = 4
local MAX_FOLLOW_DIST = 5

local START_FACE_DIST = 6
local KEEP_FACE_DIST = 8

local KEEP_WORKING_DIST = 15
local SEE_WORK_DIST = 20

local KEEP_CHOPPING_DIST = 30
local SEE_TREE_DIST = 25

--local KEEP_LEADER_NEAR_DIST = 50
local KEEP_LEADER_NEAR_DIST = 30

local function HasStateTags(inst, tags)
    for k,v in pairs(tags) do
        if inst.sg:HasStateTag(v) then
            return true
        end
    end
end

local function PlayerClose(inst)
	local player = GetClosestInstWithTag("player",inst,6)
	if player then
		return true
	else
		return false
	end
end

local function isPlayerNear(inst)
    return inst.components.follower.leader and inst.components.follower.leader:GetDistanceSqToInst(inst) <= KEEP_LEADER_NEAR_DIST*KEEP_LEADER_NEAR_DIST
end

local function KeepLookingAction(inst)
--    return inst.components.follower.leader and inst.components.follower.leader:GetDistanceSqToInst(inst) <= KEEP_CHOPPING_DIST*KEEP_CHOPPING_DIST
    return isPlayerNear(inst)
end

local function StartChoppingCondition(inst)
--    return inst.components.follower.leader and inst.components.follower.leader.sg:HasStateTag("chopping") and inst.components.followersitcommand and inst.components.followersitcommand:IsCurrentlyStaying() == false
    return isPlayerNear(inst) and inst.components.follower.leader and inst.components.follower.leader.sg:HasStateTag("chopping") and inst.components.followersitcommand and inst.components.followersitcommand:IsCurrentlyStaying() == false
end

local function StartMiningCondition(inst)
--    return inst.components.follower.leader and inst.components.follower.leader.sg:HasStateTag("mining") and inst.components.followersitcommand and inst.components.followersitcommand:IsCurrentlyStaying() == false
    return isPlayerNear(inst) and inst.components.follower.leader and inst.components.follower.leader.sg:HasStateTag("mining") and inst.components.followersitcommand and inst.components.followersitcommand:IsCurrentlyStaying() == false
end

local function StartHackingCondition(inst)
--    return inst.components.follower.leader and inst.components.follower.leader.sg:HasStateTag("hacking") and inst.components.followersitcommand and inst.components.followersitcommand:IsCurrentlyStaying() == false
    return isPlayerNear(inst) and inst.components.follower.leader and inst.components.follower.leader.sg:HasStateTag("hacking") and inst.components.followersitcommand and inst.components.followersitcommand:IsCurrentlyStaying() == false
end

local function StartDiggingCondition(inst)
--    return inst.components.follower.leader and inst.components.follower.leader.sg:HasStateTag("digging") and inst.components.followersitcommand and inst.components.followersitcommand:IsCurrentlyStaying() == false
    return isPlayerNear(inst) and inst.components.follower.leader and inst.components.follower.leader.sg:HasStateTag("digging") and inst.components.followersitcommand and inst.components.followersitcommand:IsCurrentlyStaying() == false
end

local function FindTreeToChopAction(inst)
--    local target = FindEntity(inst, SEE_TREE_DIST, function(item) return item.components.workable and item.components.workable.action == ACTIONS.CHOP and not (item.components.pickable or item.components.childspawner) end)
    local target = isPlayerNear(inst) and FindEntity(inst, SEE_TREE_DIST, function(item) return item.components.workable and item.components.workable.action == ACTIONS.CHOP and not (item.components.pickable or item.components.childspawner) end)
    if target then
        return BufferedAction(inst, target, ACTIONS.CHOP)
    end
end

local function FindRocktoMineAction(inst)
--    local target = FindEntity(inst, SEE_TREE_DIST, function(item) return item.components.workable and item.components.workable.action == ACTIONS.MINE and item.components.workable:CanBeWorked() and not (item.components.pickable or item.components.childspawner) end)
    local target = isPlayerNear(inst) and FindEntity(inst, SEE_TREE_DIST, function(item) return item.components.workable and item.components.workable.action == ACTIONS.MINE and item.components.workable:CanBeWorked() and not (item.components.pickable or item.components.childspawner) end)
    if target then
        return BufferedAction(inst, target, ACTIONS.MINE)
    end
end

local function FindStufftoHackAction(inst)
--    local target = FindEntity(inst, SEE_TREE_DIST, function(item) 
    local target = isPlayerNear(inst) and FindEntity(inst, SEE_TREE_DIST, function(item) 
		return (item.components.workable and item.components.workable.action == ACTIONS.HACK) or (item.components.hackable and item.components.hackable.hacksleft > 0) end)
    if target then
        return BufferedAction(inst, target, ACTIONS.HACK)
    end
end

local function FindStufftoDigAction(inst)
--    local target = FindEntity(inst, SEE_TREE_DIST, function(item) 
    local target = isPlayerNear(inst) and FindEntity(inst, SEE_TREE_DIST, function(item) 
		return (item.components.workable and item.components.workable.action == ACTIONS.DIG and item.components.workable.workleft > 0) and not (item.components.pickable or item.components.spawner or item.components.hackable or item.components.workable.workable == false) end, nil, {"servantignore", "plantedsoil"})
    if target then
        return BufferedAction(inst, target, ACTIONS.DIG)
    end
end

--local function CanPickup(item)
--     local ret = item:IsValid() and
--        item.components.inventoryitem and 
--        not item.components.inventoryitem:IsHeld() and
--        item.components.inventoryitem.canbepickedup and
--		--item:HasTag("piratetreasure") and
--		not PlayerClose(item) and
--        not item.components.inventoryitem.owner and
--        not item.components.container and
--        not item.components.inventory and
--		not item.components.weapon and
--		not item.components.finiteuses and
--		not item.components.fueled and
--		not item.components.tool and
--		not item.components.equippable and
--		not item:HasTag("light") and
--        not item:HasTag("irreplaceable") and
--        not item:HasTag("nosteal") and
--        not item:HasTag("trap")
--        and item:IsOnValidGround()
--    return ret
--end

--local function CanPick(item)
--     local ret = item:IsValid() and
--        item.components.pickable and 
--        item.components.pickable.caninteractwith and
--        item.components.pickable:CanBePicked() and
--        not item:HasTag("flower") and
--        item:IsOnValidGround()
--    return ret
--end

--local function EatFoodAction(inst)
--	local m_pt = inst:GetPosition()
--    local ents = TheSim:FindEntities(m_pt.x, m_pt.y, m_pt.z, 15, nil, {"aquatic", "falling", "FX", "NOCLICK", "DECOR", "INLIMBO", "irreplaceable", "nosteal", "trap"})
--    for _, item in pairs(ents) do
--        if CanPickup(item) and item:GetTimeAlive() < 800 then
--            return BufferedAction(inst, item, ACTIONS.PICKUP)
--		elseif CanPick(item) then
--			return BufferedAction(inst, item, ACTIONS.PICK)
--		end	
--    end
--end

----------------------------------------------
local function GetFaceTargetFn(inst)
    return inst.components.follower.leader
end

local function KeepFaceTargetFn(inst, target)
    return inst.components.follower.leader == target
end

local function GetLeader(inst)
    return inst.components.follower and inst.components.follower.leader
end

local function GetStayPos(inst)
	return inst.components.followersitcommand.locations["currentstaylocation"]
end

local function GetWanderPoint(inst)
	if inst.components.followersitcommand and inst.components.followersitcommand:IsCurrentlyStaying() then
		return GetStayPos(inst)
	else
		local target = GetLeader(inst) or GetPlayer()
   		if target then
        		return target:GetPosition()
    		end
	end
end

local function ShouldGoHome(inst)
    local homePos = inst.components.followersitcommand.locations["currentstaylocation"]
    local myPos = Vector3(inst.Transform:GetWorldPosition() )
    return (homePos and distsq(homePos, myPos) > 5*5)
end

local function GoHomeAction(inst)
    local homePos = inst.components.followersitcommand.locations["currentstaylocation"]
    if homePos then
        return BufferedAction(inst, nil, ACTIONS.WALKTO, nil, homePos, nil, 0.2)
    end
end
----------------------------------------------

function SkeletonWarriorBrain:OnStart()
    local root = PriorityNode(
    {	
		WhileNode( function() return self.inst.components.combat.target == nil or not self.inst.components.combat:InCooldown() end, "AttackMomentarily",
			ChaseAndAttack(self.inst, 12, 20)),		
		WhileNode( function() return self.inst.components.combat.target and self.inst.components.combat:InCooldown() end, "Dodge",
			RunAway(self.inst, function() return self.inst.components.combat.target end, 6, 9)),
		IfNode(function() return StartChoppingCondition(self.inst) end, "chop", 
			WhileNode(function() return KeepLookingAction(self.inst) end, "keep looking",
				LoopNode{ 
						DoAction(self.inst, FindTreeToChopAction )})),					
		IfNode(function() return StartMiningCondition(self.inst) end, "mine", 
			WhileNode(function() return KeepLookingAction(self.inst) end, "keep mining",
				LoopNode{ 
						DoAction(self.inst, FindRocktoMineAction )})),	
		IfNode(function() return StartHackingCondition(self.inst) end, "hack", 
			WhileNode(function() return KeepLookingAction(self.inst) end, "keep hacking",
				LoopNode{ 
						DoAction(self.inst, FindStufftoHackAction )})),	
		IfNode(function() return StartDiggingCondition(self.inst) end, "hack", 
			WhileNode(function() return KeepLookingAction(self.inst) end, "keep hacking",
				LoopNode{ 
						DoAction(self.inst, FindStufftoDigAction )})),
----------------------------------------------
		IfNode(function() 
				if self.inst.components.follower.leader ~= nil and self.inst.components.followersitcommand and self.inst.components.followersitcommand:IsCurrentlyStaying() == false then
					return true
				elseif self.inst.components.follower.leader ~= nil and not self.inst.components.followersitcommand then
					return true
				end
			end, "has leader",	
			Follow(self.inst, GetLeader, 1, 4, 7)),		
		IfNode(function() 
				--if self.inst.components.follower.leader ~= nil and self.inst.components.followersitcommand and self.inst.components.followersitcommand:IsCurrentlyStaying() == true then
				if self.inst.components.followersitcommand and self.inst.components.followersitcommand:IsCurrentlyStaying() == true then
					return true
				end
			end, "has leader",	
			WhileNode(function() return ShouldGoHome(self.inst) end, "ShouldGoHome",
				DoAction(self.inst, GoHomeAction, "Go Home", true ))),  
		IfNode(function() return self.inst.components.follower.leader ~= nil end, "has leader",
			FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn )),
----------------------------------------------
    }, 1)
    self.bt = BT(self.inst, root)    
end

return SkeletonWarriorBrain