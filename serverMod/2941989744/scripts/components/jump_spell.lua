
local function oncanuse(self,canuse)
    if canuse then
        self.inst:AddTag("krm_jumpable")
    else
        self.inst:RemoveTag("krm_jumpable")
    end
end
local  Aoespell = Class(function(self, inst)
	self.inst = inst
	self.spell = nil
    self.canuse = true
end,nil,{
    canuse = oncanuse,
})

function Aoespell:SetSpellFn(fn)
    self.spell = fn
end

function Aoespell:CastSpell(doer, pos)
    if self.spell ~= nil then
        self.spell(self.inst,doer, pos)
	end
end

return Aoespell


