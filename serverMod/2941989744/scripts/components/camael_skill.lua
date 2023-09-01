
local function onskill_on(self, skill_on)
    if skill_on then
        self.inst:AddTag("skill_on")
    else
        self.inst:RemoveTag("skill_on")
    end
end

local camael_skill = Class(function(self, inst)
    self.inst = inst
    self.skill_on = false
end,
nil,
{
    skill_on = onskill_on,
})

function camael_skill:SetFn(fn)
    self.onskillfn = fn
end
function camael_skill:DoSkill(doer,pos)
    if self.onskillfn then
        self.onskillfn(self.inst,doer,pos)
    end
end
return camael_skill
