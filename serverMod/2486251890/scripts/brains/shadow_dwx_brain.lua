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

local Shadow_Dwx_Brain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
    --self.reanimatetime = nil
end)

local SEE_DIST = 30

local MIN_FOLLOW_LEADER = 0
local MAX_FOLLOW_LEADER = 10
local TARGET_FOLLOW_LEADER = 7

-----------搜索周围砍树的距离
local SEE_TREE_DIST = 15
local KEEP_CHOPPING_DIST = 10

local KEEP_WORKING_DIST = 14
local SEE_WORK_DIST = 10
--------------风筝敌人
local KITING_DIST = 3
local STOP_KITING_DIST = 5

local RUN_AWAY_DIST = 5
local STOP_RUN_AWAY_DIST = 8
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
local TOWORK_CANT_TAGS = { "fire", "smolder", "event_trigger", "INLIMBO", "NOCLICK" }
local function FindEntityToWorkAction(inst, action, addtltags)
    local leader = GetLeader(inst)
    local target = inst.sg.statemem.target or nil

    if leader ~= nil and ( (target ~= nil and target.components.workable and target.components.workable:CanBeWorked() and target.components.workable:GetWorkAction() == ACTIONS.CHOP) or (leader.sg and leader.sg:HasStateTag("chopping")))  then
        --Keep existing target?
        if target ~= nil and
            target:IsValid() and
            not (target:IsInLimbo() or
                target:HasTag("NOCLICK") or
                target:HasTag("event_trigger")) and
            target:IsOnValidGround() and
            target.components.workable ~= nil and
            target.components.workable:CanBeWorked() and
            target.components.workable:GetWorkAction() == action and
            not (target.components.burnable ~= nil
                and (target.components.burnable:IsBurning() or
                    target.components.burnable:IsSmoldering())) and
            target.entity:IsVisible() and
            target:IsNear(leader, KEEP_WORKING_DIST) then
                
            if addtltags ~= nil then
                for i, v in ipairs(addtltags) do
                    if target:HasTag(v) then
                        return BufferedAction(inst, target, action)
                    end
                end
            else
                return BufferedAction(inst, target, action)
            end
        end

        --Find new target
        target = FindEntity(leader, SEE_WORK_DIST, nil, { action.id.."_workable" }, TOWORK_CANT_TAGS, addtltags)
        return target ~= nil and BufferedAction(inst, target, action) or nil
    end
end
---------------
--风筝敌人
local function ShouldRunAway(target)
    return not (target.components.health ~= nil and target.components.health:IsDead())
        and (not target:HasTag("shadowcreature") or (target.components.combat ~= nil and target.components.combat:HasTarget()))
end

local function ShouldKite(target, inst)
    return inst.components.combat:TargetIs(target)
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

local function GetWanderPoint(inst)
    local target = GetLeader(inst) or inst:GetNearestPlayer(true)
    return target ~= nil and target:GetPosition() or nil
end

local function ShouldStandStill(inst)
    return inst:HasTag("pet_hound") and not TheWorld.state.isday and not GetLeader(inst) and not inst.components.combat:HasTarget()
end

local function GetClayLeaderLeashPos(inst)
    local leader = GetLeader(inst)
    if leader == nil or inst.leader_offset == nil then
        return
    end
    local x, y, z = leader.Transform:GetWorldPosition()
    return Vector3(x + inst.leader_offset.x, 0, z + inst.leader_offset.z)
end

local function FaceFormation(inst)
    if inst.sg:HasStateTag("canrotate") then
        local leader = GetLeader(inst)
        if leader ~= nil then
            inst.Transform:SetRotation(leader.Transform:GetRotation())
        end
    end
end

local excludes = { "INLIMBO","burnt","oldfish_farmer","oldfish_farmhome","insect", "playerghost","animal","player","spider" }

local prefabName = {
    "berries"
    ,"berries_juicy"
    ,"cutgrass"
    , "twigs"
    ,"bird_egg"
    ,"seeds"
    ,"poop"
    , "honey"
    ,"pinecone"
    ,"log"
    ,"blue_cap"
    , "green_cap"
    ,"red_cap"
    ,"drumstick"
    ,"spoiled_food"
    ,"carrot"
    ,"watermelon"
    ,"boards"
    ,"dragonfruit"
    ,"corn"
    ,"froglegs"
    ,"livinglog"
    ,"guano"
    ,"bird_egg"
    ,"rottenegg"
    ,"charcoal"
    ,"twiggy_nut"
    ,"acorn"
    ,"eggplant"
    ,"durian"
    ,"pumpkin"
    ,"dug_sapling"
    ,"dug_berrybush"
    ,"dug_berrybush2"
    ,"dug_berrybush_juicy"
    ,"dug_grass"
    ,"dug_marsh_bush"
    ,"dug_rock_avocado_bush"
    ,"dug_sapling_moon"
    ,"meat"
    ,"monstermeat"
    ,"pomegranate"
    ,"fertilizer"
    ,"nitre"
    ,"flint"
    ,"rocks"
    ,"marble"
    ,"marblebean"
    ,"goldnugget"
    ,"peach"
    ,"smallmeat"
    ,"smallmeat_dried"
    ,"meat_dried"
    ,"monstermeat_dried"
    ,"fish"
    ,"ice"
    ,"tomato"
    ,"potato"
    ,"onion"
    ,"garlic"
    ,"pepper"
    ,"asparagus"
    ,"cave_banana"
    ,"cactus_meat"
    ,"cactus_flower"
    ,"kelp"
    ,"eel"
    ,"batwing"
    ,"butter"
    ,"goatmilk"
    ,"wormlight"
    ,"wormlight_lesser"
    ,"cutlichen"
    ,"hambat"
    ,"rock_avocado_fruit_ripe"
    ,"rock_avocado_fruit_ripe_cooked"
    ,"rock_avocado_fruit_sprout"
    ,"houndstooth"
    ,"pigskin"
}

local function IsPrefab(item, inst)
    for i,v in ipairs(prefabName) do
        if v == item.prefab then
            return true
        end
    end

    if item.prefab ~= nil then
        local result = string.find(item.prefab, "seeds")
        if result ~= nil then
            return true
        end
    end

    return false
end

local function HasBerry(item, inst)
    if item.components.dryer then
        return item:HasTag("dried")

    elseif item.components.harvestable
            and item.components.harvestable:CanBeHarvested()
            and (item:HasTag("beebox") or item:HasTag("mushroom_farm")) then
        return true

    elseif item.components.crop ~= nil then
        if item.components.crop:IsReadyForHarvest() or item:HasTag("withered") then
            return true
        end
    else
        if item.components.pickable ~= nil then
            return item.components.pickable.canbepicked
                    and (item.components.pickable.product == "berries"
                    or item.components.pickable.product == "berries_juicy"
                    or item.components.pickable.product == "rock_avocado_fruit"
                    or item.components.pickable.product == "cutgrass"
                    or item.components.pickable.product == "cactus_meat"
                    or item.components.pickable.product == "twigs")
           end
     end
end

local function pickUpAction(inst)
    local leader = inst.components.follower.leader or nil
    if inst.prefab ~= "shadow_ly" then return end
    if inst.components.inventory and inst.components.inventory:IsFull() or leader == nil then
        return
    end

    local target = FindEntity(inst, SEE_BUSH_DIST, IsPrefab, nil, excludes)
    if inst.pickbrain and  target and leader and leader:IsNear(target, SEE_BUSH_DIST) then
            return target ~= nil and BufferedAction(inst, target, ACTIONS.PICKUP) or nil
    end    
end

local function PickBerriesAction(inst)
    local leader = inst.components.follower.leader or nil
    if inst.prefab ~= "shadow_ly" then return end
    if inst.components.inventory and inst.components.inventory:IsFull() then
        return
    end

    local target = FindEntity(inst, SEE_BUSH_DIST, HasBerry, nil , excludes)
    if inst.pickbrain and  target and leader and leader:IsNear(target, SEE_BUSH_DIST)  then  --nd inst.home and inst.home:IsValid() and inst.home:IsNear(target, SEE_BUSH_DIST)

        if target:HasTag("dried") then
            return BufferedAction(inst, target, ACTIONS.HARVEST)

        elseif target:HasTag("beebox") and target.components.harvestable.produce >= 6 then
            return BufferedAction(inst, target, ACTIONS.HARVEST)

        elseif target.components.crop ~= nil then
            if target.components.crop:IsReadyForHarvest() or target:HasTag("withered") then
                return BufferedAction(inst, target, ACTIONS.HARVEST)
            end

        elseif target:HasTag("mushroom_farm") and target.components.harvestable.produce >= 4 then
            return BufferedAction(inst, target, ACTIONS.HARVEST)
        elseif  target.components.pickable then

            return BufferedAction(inst, target, ACTIONS.PICK)
        end
    end
end

function Shadow_Dwx_Brain:OnStart()
    local root = PriorityNode(
        {
              
            WhileNode(function() return not self.inst.sg:HasStateTag("jumping") end, "NotJumpingBehaviour",
                PriorityNode({
                    WhileNode(function() return GetLeader(self.inst) == nil end, "NoLeader", AttackWall(self.inst)),


                   -- WhileNode(function() return self.inst:HasTag("pet_hound") end, "Is Pet", ChaseAndAttack(self.inst, 10)),
                   -- WhileNode(function() return not self.inst:HasTag("pet_hound") and GetHome(self.inst) ~= nil end, "No Pet Has Home", ChaseAndAttack(self.inst, 10, 20)),
                  --  WhileNode(function() return not self.inst:HasTag("pet_hound") and GetHome(self.inst) == nil end, "Not Pet", ChaseAndAttack(self.inst, 100)),
---------------------风筝敌人相关
                   -- if self.inst == "shadow_ly" 
                        WhileNode(function() return self.inst.prefab == "shadow_ly" and self.inst.components.combat:GetCooldown() > .5 and ShouldKite(self.inst.components.combat.target, self.inst) end, "Dodge",
                            RunAway(self.inst, { fn = ShouldKite, tags = { "_combat", "_health" }, notags = { "INLIMBO" } }, KITING_DIST, STOP_KITING_DIST)),
                 -- end      
                        ChaseAndAttack(self.inst),

                        DoAction(self.inst, PickBerriesAction, "Pick Thing", true),
                        --DoAction(self.inst, pickUpAction, "pick up", true),

---------------------砍树相关
                IfNode(function() return self.inst.prefab == "shadow_ly" end, "Keep Chopping",
                    DoAction(self.inst, function() return FindEntityToWorkAction(self.inst, ACTIONS.CHOP) end)),
-------
                    Leash(self.inst, GetNoLeaderLeashPos, HOUSE_MAX_DIST, HOUSE_RETURN_DIST),

                    Follow(self.inst, GetLeader, MIN_FOLLOW_LEADER, TARGET_FOLLOW_LEADER, MAX_FOLLOW_LEADER),
                    FaceEntity(self.inst, GetLeader, GetLeader),

                    StandStill(self.inst, ShouldStandStill),

                    --Wander(self.inst, GetWanderPoint, 20),
                }, .25)
            ),
        }, .25 )

    self.bt = BT(self.inst, root)
end

return Shadow_Dwx_Brain
