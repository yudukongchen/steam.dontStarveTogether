require "behaviours/wander"
require "behaviours/faceentity"
require "behaviours/panic"
require "behaviours/follow"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/chaseandattack"

local SkeletonMageBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local MIN_FOLLOW_DIST = 0.00001
local TARGET_FOLLOW_DIST = 4
local MAX_FOLLOW_DIST = 5

local START_FACE_DIST = 6
local KEEP_FACE_DIST = 8

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

function SkeletonMageBrain:OnStart()
    local root = PriorityNode(
    {
		WhileNode( function() return self.inst.components.combat.target == nil or not self.inst.components.combat:InCooldown() end, "AttackMomentarily",
			ChaseAndAttack(self.inst, 12, 20)),		
		WhileNode( function() return self.inst.components.combat.target and self.inst.components.combat:InCooldown() end, "Dodge",
			RunAway(self.inst, function() return self.inst.components.combat.target end, 6, 9)),
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

return SkeletonMageBrain