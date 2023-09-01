
local  Aoespell = Class(function(self, inst)
	self.inst = inst
	self.canuseonpoint = true
	self.spell = nil
end)

function Aoespell:CanCast(doer,  pos)
    return self.canuseonpoint
end

function Aoespell:SetSpellFn(fn)
    self.spell = fn
end
function Aoespell:CastSpell(doer, pos)
    if self.spell ~= nil then
        return self.spell(self.inst,doer, pos)
	end
end
return Aoespell

