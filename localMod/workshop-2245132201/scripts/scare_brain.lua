GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

local BrainCommon = require "brains/braincommon"

local function ScareBrain(self)
  local CanScared = BrainCommon.PanicWhenScared(self.inst, .3)
  table.insert(self.bt.root.children, 1, CanScared)
end

---給牛，獵犬和青蛙添加害怕的腦子
AddBrainPostInit("frogbrain", ScareBrain)
AddBrainPostInit("houndbrain", ScareBrain)
AddBrainPostInit("beefalobrain", ScareBrain)
AddBrainPostInit("beebrain", ScareBrain)
AddBrainPostInit("killerbeebrain", ScareBrain)
AddBrainPostInit("krampusbrain", ScareBrain)
AddBrainPostInit("tallbirdbrain", ScareBrain)
AddBrainPostInit("walrusbrain", ScareBrain)
AddBrainPostInit("catcoonbrain", ScareBrain)