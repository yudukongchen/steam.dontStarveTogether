require "behaviours/follow"
require "behaviours/wander"

local TzFhzcMinionBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function TzFhzcMinionBrain:OnStart()
    local root = PriorityNode({
        Follow(self.inst, function() return self.inst.components.follower.leader end,4,5,6, true),
        Wander(self.inst)
    }, .25)

    self.bt = BT(self.inst, root)
end

return TzFhzcMinionBrain
