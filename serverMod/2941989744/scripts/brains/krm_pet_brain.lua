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
    
local Krm_Pet_Brain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local SEE_DIST = 30

local MIN_FOLLOW_LEADER = 0
local MAX_FOLLOW_LEADER = 10
local TARGET_FOLLOW_LEADER = 7

-----------搜索周围砍树的距离
local SEE_TREE_DIST = 15
local KEEP_CHOPPING_DIST = 16

local KEEP_WORKING_DIST = 14
local SEE_WORK_DIST = 10

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

-------------砍树相关

local function IsDeciduousTreeMonster(guy)
    return guy.monster and guy.prefab == "deciduoustree"
end

local CHOP_MUST_TAGS = { "CHOP_workable" }
local function FindDeciduousTreeMonster(inst)
    return FindEntity(inst, SEE_TREE_DIST / 3, IsDeciduousTreeMonster, CHOP_MUST_TAGS)
end

local function KeepChoppingAction(inst)
    return (inst.tree_target ~= nil or (inst.components.follower.leader ~= nil and inst:IsNear(inst.components.follower.leader, KEEP_CHOPPING_DIST))              
    or FindDeciduousTreeMonster(inst) ~= nil)
end

local function StartChoppingCondition(inst)
    if inst.not_active then
        return inst.tree_target ~= nil
        or (inst.components.follower.leader ~= nil and
            inst.components.follower.leader.sg ~= nil and
            inst.components.follower.leader.sg:HasStateTag("chopping"))
        or FindDeciduousTreeMonster(inst) ~= nil
    end
    return (inst.tree_target ~= nil or inst.components.follower.leader ~= nil or FindDeciduousTreeMonster(inst) ~= nil)             
end

local function FindTreeToChopAction(inst)
    local target = FindEntity(inst, SEE_TREE_DIST, nil, CHOP_MUST_TAGS)
    if target ~= nil and target:IsOnValidGround() then
        if inst.tree_target ~= nil then
            target = inst.tree_target
            inst.tree_target = nil
        else
            target = FindDeciduousTreeMonster(inst) or target
        end
        return BufferedAction(inst, target, ACTIONS.CHOP)
    end
end

----=============================

local MINE_MUST_TAGS = { "MINE_workable" }

local function KeepMineingAction(inst)
    return (inst.tree_target ~= nil or (inst.components.follower.leader ~= nil and inst:IsNear(inst.components.follower.leader, KEEP_CHOPPING_DIST)))                 
end

local function StartMineCondition(inst)
    if inst.not_active then
        return inst.tree_target ~= nil
        or (inst.components.follower.leader ~= nil and
            inst.components.follower.leader.sg ~= nil and
            inst.components.follower.leader.sg:HasStateTag("mining"))
        or FindDeciduousTreeMonster(inst) ~= nil
    end
    return (inst.tree_target ~= nil or inst.components.follower.leader ~= nil)       
end

local function FindRockToMineAction(inst)
    local target = FindEntity(inst, SEE_TREE_DIST, nil, MINE_MUST_TAGS)
    if target ~= nil and target:IsOnValidGround() then
        if inst.tree_target ~= nil then
            target = inst.tree_target
            inst.tree_target = nil
        end
        return BufferedAction(inst, target, ACTIONS.MINE)
    end
end

local function ShouldKite(target, inst)
    return (inst.components.combat == nil or (inst.components.combat and inst.components.combat:TargetIs(target)))
        and target.components.health ~= nil
        and not target.components.health:IsDead()
end
--
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

function Krm_Pet_Brain:OnStart()
    local root = PriorityNode(
        {
            WhileNode(function() return not self.inst.sg:HasStateTag("temp_invincible") end, "NotJumpingBehaviour",
                PriorityNode({
                        --WhileNode(function() return self.inst.components.combat:GetCooldown() > .5 and ShouldKite(self.inst.components.combat.target, self.inst) end, "Dodge",
                        RunAway(self.inst, { fn = ShouldKite, tags = { "_combat", "_health" }, notags = { "INLIMBO" } }, KITING_DIST, STOP_KITING_DIST),     
                        ChaseAndAttack(self.inst),

---------------------砍树相关
            IfThenDoWhileNode(function() return StartChoppingCondition(self.inst) end, function() return KeepChoppingAction(self.inst) end, "chop",
                LoopNode{
                    ChattyNode(self.inst, "CHOP_WOOD",
                        DoAction(self.inst, FindTreeToChopAction ))}),

            IfThenDoWhileNode(function() return StartMineCondition(self.inst) end, function() return KeepMineingAction(self.inst) end, "mine",
                LoopNode{
                    ChattyNode(self.inst, "MINE_ROCK",
                        DoAction(self.inst, FindRockToMineAction ))}),

                    Leash(self.inst, GetNoLeaderLeashPos, HOUSE_MAX_DIST, HOUSE_RETURN_DIST),

                    Follow(self.inst, GetLeader, MIN_FOLLOW_LEADER, TARGET_FOLLOW_LEADER, MAX_FOLLOW_LEADER),
                    FaceEntity(self.inst, GetLeader, GetLeader),

                    StandStill(self.inst, ShouldStandStill),
                }, .25)
            ),
        }, .25 )

    self.bt = BT(self.inst, root)
end

return Krm_Pet_Brain
