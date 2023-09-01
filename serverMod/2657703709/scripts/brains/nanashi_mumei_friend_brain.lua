require "behaviours/wander"
require "behaviours/doaction"
require "behaviours/chaseandattack"
require "behaviours/standstill"

local TARGET_FOLLOW_DIST = 4
local MAX_FOLLOW_DIST = 10
local WORK_RANGE = 20 

local NO_TAGS = { "FX", "NOCLICK", "DECOR", "INLIMBO", "burnt" }

local PICKABLE_FOODS =
{
    berries = true,
    berries_juicy = true,
    cave_banana = false,
    carrot = false,
    red_cap = false,
    blue_cap = false,
    green_cap = false,
}


local function PickBerries(inst)

    if inst.sg:HasStateTag("busy")
        or (inst.components.inventory ~= nil and
            inst.components.inventory:IsFull()) then
        return
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, WORK_RANGE, nil, NO_TAGS)
    local targets = {}
    local allowed_item = {"berries","berries_juicy","wormlight","wormlight_lesser"}

    --Gather all targets in one pass
    for i, item in ipairs(ents) do
        if item:IsValid() and item:IsOnValidGround() then
            if item.components.pickable ~= nil then -- ADDING THIS BACK. I Want them to pick up carrots
                if targets.pickable == nil and
                    item.components.pickable.caninteractwith and
                    item.components.pickable:CanBePicked() and
                    PICKABLE_FOODS[item.components.pickable.product] then
                    targets.pickable = item
                end
            else
                for _, value in pairs(allowed_item) do
                    if item.prefab == value then
                        targets.pickup = item
                        break
                    end
                end
            end
        end
    end

    --Pick action by priority on all gathered targets
    if targets.pickup ~= nil then
        return BufferedAction(inst, targets.pickup, ACTIONS.FRIEND_PICKUP)
    elseif targets.pickable  then
        return BufferedAction(inst, targets.pickable, ACTIONS.FRIEND_PICKUP)
    end
end

local FriendBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function FriendBrain:OnStart()

    local root = PriorityNode(
    {
        WhileNode( function() return self.inst.components.follower.leader end, "Has Owner",
            PriorityNode{
                IfNode(function() return TUNING.NANASHI_MUMEI_FRIEND_PICKUP end, "StarGathering",
                DoAction(self.inst, PickBerries, "PickBerries",true,2)),
                Follow(self.inst, function() return self.inst.components.follower.leader end, 0, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST),
            }),
        StandStill(self.inst),
    }, .25)

    self.bt = BT(self.inst, root)

end

return FriendBrain
