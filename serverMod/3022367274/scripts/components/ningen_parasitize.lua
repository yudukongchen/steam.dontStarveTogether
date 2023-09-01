local function check(inst, self, period)
    self:OnUpdate(period)
end

local Ningen_parasite =
    Class(
    function(self, inst)
        self.inst = inst
        self.parasitifer = nil
        self.fx = nil
        local period = 1
        self.inst:ListenForEvent(
            'parasitifer_death',
            function()
                self:Leave()
                if inst.on_parasitifer_move then
                    inst.on_parasitifer_move:Cancel()
                end
            end
        )
        self.inst:DoPeriodicTask(period, check, nil, self, period)
        self.inst:ListenForEvent(
            'death',
            function()
                self:Leave()
            end
        )
    end,
    nil,
    {}
)
function Ningen_parasite:OnUpdate(dt)
    local tar = self.parasitifer
    if tar and not tar.components.health:IsDead() then
        tar.components.health:DoDelta(-1 * dt, true, '寄生', nil, nil, true)
        self.inst.components.health:DoDelta(0.5 * dt, true)
        self.inst.components.hunger:DoDelta(2 * dt, true)
    end
end

function Ningen_parasite:SetTarget(tar)
    SpawnPrefab('waterplant_destroy').Transform:SetPosition(self.inst.Transform:GetWorldPosition())
    self.inst:AddTag('on_parasitizing')
    self.parasitifer = tar
end

function Ningen_parasite:Leave()
    self.inst:RemoveTag('on_parasitizing')
    if not self.inst.components.health:IsDead() then
        self.inst.sg:GoToState('idle')
    end
    if self.parasitifer and self.parasitifer:IsValid() then
        self.parasitifer.components.can_be_parasitized_by_ningen:LostTarget()
        self.inst:DoTaskInTime(
            FRAMES,
            function()
                local fx = SpawnPrefab('waterplant_destroy')
                fx.entity:SetParent(self.inst.entity)
            end
        )
    end
    if self.fx then
        self.fx:Remove()
        self.fx = nil
    end
    self.parasitifer = nil
end

return Ningen_parasite
