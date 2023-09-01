local Tz_hyspell = Class(function(self, inst)
	self.inst = inst
	self.spell = nil
end)
function Tz_hyspell:CanCast(doer, target, pos)
    if self.spell == nil then
        return false
    elseif target == nil then
    return 
        TheWorld.Map:IsAboveGroundAtPoint(pos:Get())
        and not TheWorld.Map:IsGroundTargetBlocked(pos)
    else  
	return not target:IsInLimbo()
        or not (target.entity:IsVisible()
        or  (target.components.health ~= nil and target.components.health:IsDead())
        or  (target.sg ~= nil and (
                target.sg.currentstate.name == "death" or
                target.sg:HasStateTag("flight") or
                target.sg:HasStateTag("invisible")
            )))
	end
end
function Tz_hyspell:CastSpell(doer, target, pos)
    if self.spell ~= nil then
        self.spell(self.inst,doer ,target,pos)
    end
end
return Tz_hyspell