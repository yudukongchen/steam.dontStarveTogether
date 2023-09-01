local Skill = Class(function(self, inst)
    self.inst = inst

    self.iscenter = net_bool(inst.GUID, "krm_skill.iscenter", "krm_skill.iscenter")
    self.inst:ListenForEvent("krm_skill.iscenter", function()
        self:OnCenter()
    end)
    self.inst:ListenForEvent("onremove", function(inst)
        TheWorld.components.krm_time_manager:RemoveTimeMagicCenter(inst)
    end)
end)

function Skill:SetIsMagicCenter(val)
    self.iscenter:set_local(val)
    self.iscenter:set(val)
end

function Skill:GetIsMagicCenter(val)
    return self.iscenter:value()
end

function Skill:OnCenter()
    if self:GetIsMagicCenter() then
        TheWorld.components.krm_time_manager:AddTimeMagicCenter(self.inst)
    else
        TheWorld.components.krm_time_manager:RemoveTimeMagicCenter(self.inst)
    end
end

return Skill
