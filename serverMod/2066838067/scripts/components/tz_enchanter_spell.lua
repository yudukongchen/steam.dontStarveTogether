local tz_enchanter_spell = Class(function(self, inst)
	self.inst = inst
	self.spell = nil
end)

function tz_enchanter_spell:CastSpell(doer, target, pos)
    print('........CastSpell')
    if self.spell ~= nil then
        self.spell(self.inst,doer ,target,pos)
    end
end
return tz_enchanter_spell