require 'behaviours/wander'
require 'behaviours/chaseandattack'
require 'behaviours/panic'
require 'behaviours/attackwall'
require 'behaviours/minperiod'
require 'behaviours/leash'
require 'behaviours/faceentity'
require 'behaviours/doaction'
require 'behaviours/standstill'
require 'behaviours/follow'

local Killer_Whale_Brain =
    Class(
    Brain,
    function(self, inst)
        Brain._ctor(self, inst)
    end
)
local MAX_CHASE_TIME = 20
local MAX_CHASE_DIST = 40
local SEE_DIST = 20

local MIN_FOLLOW_DIST = 2
local TARGET_FOLLOW_DIST = 10
local MAX_FOLLOW_DIST = 25

local SEE_FOOD_DIST = 20

local FLEE_AWAY_DIST = 15
local STOP_FLEE_AWAY_DIST = 20

local WANDER_TIMES = {
    minwalktime = 1,
    randwalktime = 2.5,
    minwaittime = 3,
    randwaittime = 3
}

local function isOnWater(inst)
    return not inst:GetCurrentPlatform() and not TheWorld.Map:IsVisualGroundAtPoint(inst.Transform:GetWorldPosition())
end

local function Attack(inst)
    inst:PushEvent('dobite')
end

local function removefood(inst, target)
    inst:removefood(target)
    inst:RemoveEventCallback('onremoved', inst._removefood, target)
    inst:RemoveEventCallback('onpickup', inst._removefood, target)
    inst._removefood = nil
end

local function isfoodnearby(inst)
    if
        inst.components.hunger:GetPercent() > .7 + (inst:HasTag('killer_whale_tanchi') and .2 or 0) or
            inst.components.timer:TimerExists('gobble_cooldown')
     then
        return nil
    end

    local target =
        FindEntity(
        inst,
        SEE_DIST,
        function(item)
            return inst.components.eater:CanEat(item) and not item:GetCurrentPlatform() and
                not TheWorld.Map:IsVisualGroundAtPoint(item.Transform:GetWorldPosition()) and
                (item.components.edible and item.components.edible:GetHunger() > 0)
        end
    )

    inst.foodtoeat = target
    if target then
        inst._removefood = function()
            removefood(inst, target)
        end
        inst:ListenForEvent('onremoved', inst._removefood, target)
        inst:ListenForEvent('onpickup', inst._removefood, target)

        return BufferedAction(inst, target, ACTIONS.EAT)
    end
end

local function EatFishAction(inst)
    if
        not inst.components.timer:TimerExists('gobble_cooldown') and
            inst.components.hunger:GetPercent() < 0.4 + (inst:HasTag('killer_whale_tanchi') and .2 or 0)
     then
        local target =
            FindEntity(
            inst,
            SEE_FOOD_DIST,
            function(food)
                return TheWorld.Map:IsOceanAtPoint(food.Transform:GetWorldPosition()) and
                    (food:HasTag('oceanfish') or food.prefab == 'puffin')
            end
        )
        -- print("I want to eat",target)
        if target then
            inst.foodtarget = target
        end
    end
    return nil
end

local function naughty(inst)
    if not inst:HasTag('killer_whale_naughty') then
        return nil
    end
    if inst.components.timer:TimerExists('naughty') then
        return
    end
    local target =
        FindEntity(
        inst,
        SEE_FOOD_DIST,
        function(food)
            return TheWorld.Map:IsOceanAtPoint(food.Transform:GetWorldPosition()) and (food:HasTag('oceanfish'))
        end
    )
    if target then
        if
            not inst.components.health:IsDead() and not inst.sg:HasStateTag('attack') and
                not inst.components.timer:TimerExists('naughty') and
                not inst.sg:HasStateTag('busy')
         then
            inst.components.timer:StartTimer('naughty', 45 + 45 * math.random())
            inst.sg:GoToState('naughty_leap', {p = Vector3(target.Transform:GetWorldPosition())})
        end
    end
end

local function GetLeader(inst)
    return inst.components.follower.leader
end

function Killer_Whale_Brain:OnStart()
    local root =
        PriorityNode(
        {
            WhileNode(
                function()
                    return not self.inst.sg:HasStateTag('jumping')
                end,
                'NotJumpingBehaviour',
                PriorityNode(
                    {
                        WhileNode(
                            function()
                                return not isOnWater(self.inst) and
                                    not self.inst.components.timer:TimerExists('getdistance')
                            end,
                            'NOT on water',
                            PriorityNode(
                                {
                                    DoAction(self.inst, Attack, 'attack', true)
                                }
                            )
                        ),
                        --WhileNode(function() return self.inst.components.hauntable and self.inst.components.hauntable.panic end, "PanicHaunted", Panic(self.inst)),
                        WhileNode(
                            function()
                                return isOnWater(self.inst)
                            end,
                            'on water',
                            PriorityNode(
                                {
                                    WhileNode(
                                        function()
                                            return self.inst.components.health.takingfiredamage
                                        end,
                                        'OnFire',
                                        Panic(self.inst)
                                    ),
                                    WhileNode(
                                        function()
                                            return self.inst:HasTag('killer_whale_danxiao') and
                                                self.inst.components.combat.target and
                                                self.inst.components.health:GetPercent() < .5
                                        end,
                                        'Flee',
                                        RunAway(
                                            self.inst,
                                            function()
                                                return self.inst.components.combat.target
                                            end,
                                            FLEE_AWAY_DIST,
                                            STOP_FLEE_AWAY_DIST
                                        )
                                    ),
                                    WhileNode(
                                        function()
                                            local target = self.inst.components.combat.target
                                            return target
                                        end,
                                        'Chase and atk',
                                        ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST)
                                    ),
                                    DoAction(self.inst, isfoodnearby, 'gotofood', true),
                                    DoAction(self.inst, EatFishAction, 'eat fish', true),
                                    DoAction(self.inst, naughty, 'naughty', true),
                                    Follow(self.inst, GetLeader, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST),
                                    WhileNode(
                                        function()
                                            return true
                                        end,
                                        'wander',
                                        Wander(self.inst, nil, nil, WANDER_TIMES)
                                    )
                                }
                            )
                        )
                    },
                    .25
                )
            )
        },
        .25
    )

    self.bt = BT(self.inst, root)
end

return Killer_Whale_Brain
