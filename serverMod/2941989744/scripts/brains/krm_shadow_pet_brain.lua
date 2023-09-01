require "behaviours/wander"
require "behaviours/chaseandattack"
require "behaviours/panic"
require "behaviours/attackwall"
require "behaviours/minperiod"
require "behaviours/leash"
require "behaviours/faceentity"
require "behaviours/doaction"
require "behaviours/standstill"
require "behaviours/runaway"
    
local Krm_Shadow_Pet_Brain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local SEE_DIST = 30

local MIN_FOLLOW_LEADER = 0
local MAX_FOLLOW_LEADER = 10
local TARGET_FOLLOW_LEADER = 7

--------------风筝敌人
local KITING_DIST = 2
local STOP_KITING_DIST = 5
--------------------
local LEASH_RETURN_DIST = 10
local LEASH_MAX_DIST = 40

local HOUSE_MAX_DIST = 40
local HOUSE_RETURN_DIST = 50

local SIT_BOY_DIST = 10
local SEE_BUSH_DIST = 24

local function GetLeader(inst)
    return inst.components.follower ~= nil and inst.components.follower.leader or nil
end

local function GetHome(inst)
    return inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
end

local function GetHomePos(inst)
    local home = GetHome(inst)
    return home ~= nil and home:GetPosition() or nil
end

local function GetNoLeaderLeashPos(inst)
    return GetLeader(inst) == nil and GetHomePos(inst) or nil
end

local function ShouldStandStill(inst)
    return not GetLeader(inst) and (inst.components.combat == nil or (inst.components.combat and not inst.components.combat:HasTarget()))
end

function Krm_Shadow_Pet_Brain:OnStart()
    local root = PriorityNode(
        {
            WhileNode(function() return not self.inst.sg:HasStateTag("temp_invincible") end, "NotJumpingBehaviour",
                PriorityNode({  
                    ChaseAndAttack(self.inst),
                    Follow(self.inst, GetLeader, MIN_FOLLOW_LEADER, TARGET_FOLLOW_LEADER, MAX_FOLLOW_LEADER),
                    FaceEntity(self.inst, GetLeader, GetLeader),

                    StandStill(self.inst, ShouldStandStill),
                }, .25)
            ),
        }, .25 )

    self.bt = BT(self.inst, root)
end

return Krm_Shadow_Pet_Brain
