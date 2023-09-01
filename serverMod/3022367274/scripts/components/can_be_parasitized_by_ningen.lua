local Can_be_parasitized_by_ningen =
    Class(
    function(self, inst)
        self.inst = inst
        self.parasite = nil
        self.inst:ListenForEvent(
            'death',
            function()
                local target = self.parasite
                if target and target:IsValid() then
                    target:PushEvent('parasitifer_death')
                end
            end
        )
        self.inst:ListenForEvent(
            'onremove',
            function()
                local target = self.parasite
                if target and target:IsValid() then
                    target:PushEvent('parasitifer_death')
                end
            end
        )
    end,
    nil,
    {}
)

function Can_be_parasitized_by_ningen:SetTarget(tar)
    if self.parasite == nil then
        self.parasite = tar
        local fx = SpawnPrefab('waterplant_destroy')
        fx.entity:SetParent(self.inst.entity)
        self.inst:AddTag('be_parasitized_by_ningen')
        return true
    end
    return false
end

function Can_be_parasitized_by_ningen:LostTarget()
    local fx = SpawnPrefab('waterplant_destroy')
    fx.entity:SetParent(self.inst.entity)
    self.parasite = nil
    self.inst:RemoveTag('be_parasitized_by_ningen')
end

return Can_be_parasitized_by_ningen
