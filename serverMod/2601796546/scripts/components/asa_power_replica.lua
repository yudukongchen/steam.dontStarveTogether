local Asa_Power = Class(function(self, inst)
    self.inst = inst

    if TheWorld.ismastersim then
        self.classified = inst.player_classified
    elseif self.classified == nil and inst.player_classified ~= nil then
        self:AttachClassified(inst.player_classified)
    end
end)

--------------------------------------------------------------------------

function Asa_Power:OnRemoveFromEntity()
    if self.classified ~= nil then
        if TheWorld.ismastersim then
            self.classified = nil
        else
            self.inst:RemoveEventCallback("onremove", self.ondetachclassified, self.classified)
            self:DetachClassified()
        end
    end
end

Asa_Power.OnRemoveEntity = Asa_Power.OnRemoveFromEntity

function Asa_Power:AttachClassified(classified)
    self.classified = classified
    self.ondetachclassified = function() self:DetachClassified() end
    self.inst:ListenForEvent("onremove", self.ondetachclassified, classified)
end

function Asa_Power:DetachClassified()
    self.classified = nil
    self.ondetachclassified = nil
end

--------------------------------------------------------------------------

function Asa_Power:Set(amount)
    if self.classified ~= nil then
        self.classified:SetValue("currentpw", amount)
    end
end

function Asa_Power:Get()
    return self.inst.asa_pw:value()
end


function Asa_Power:IsZero()
    if self.inst.components.asa_power ~= nil then
        return self.inst.components.asa_power:IsZero()
    else
        return self.classified ~= nil and self.classified.currentpw:value() <= 0
    end
end

return Asa_Power