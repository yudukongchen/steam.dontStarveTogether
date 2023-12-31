local SamaAura = Class(function(self, inst)
    self.inst = inst
    self.aura = 0
    self.aurafn = nil
end)

function SamaAura:GetAura(observer)
    return self.aurafn == nil and self.aura or self.aurafn(self.inst, observer)
end

return SamaAura
