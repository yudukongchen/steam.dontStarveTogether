
local function BloodoverPostConstruct(self)
    local  OldUpdateState = self.UpdateState
    if OldUpdateState and self.owner and self.owner:HasTag("ningen")then
        local owner = self.owner
        local function _UpdateState()
            self:UpdateState()
        end
        function self:UpdateState()
            if (self.owner.IsFreezing ~= nil and self.owner:IsFreezing()) or
                (self.owner.IsOverheating ~= nil and self.owner:IsOverheating()) or
                (self.owner.replica.hunger ~= nil and self.owner.replica.hunger:IsStarving()) or
                self.owner:HasTag("ningenisdried") then
                self:TurnOn()
            else
                self:TurnOff()
            end
        end
        self.inst:ListenForEvent("startdrying", _UpdateState, owner)
        self.inst:ListenForEvent("stopdrying", _UpdateState, owner)
    end
end

AddClassPostConstruct("widgets/bloodover", BloodoverPostConstruct)

local function HealthbadgePostConstruct(self)
    local  OldUpdate = self.OnUpdate
    if OldUpdate and self.owner and self.owner:HasTag("ningen") then
        function self:OnUpdate(dt)
            if GLOBAL.TheNet:IsServerPaused() then return end

            local down
            if (self.owner.IsFreezing ~= nil and self.owner:IsFreezing()) or
                (self.owner.replica.health ~= nil and self.owner.replica.health:IsTakingFireDamageFull()) or
                (self.owner.replica.hunger ~= nil and self.owner.replica.hunger:IsStarving()) or
                GLOBAL.next(self.corrosives) ~= nil or self.owner:HasTag("ningenisdried") then
                down = "_most"
            elseif self.owner.IsOverheating ~= nil and self.owner:IsOverheating() then
                down = self.owner:HasTag("heatresistant") and "_more" or "_most"
            end

            local up = down == nil and
                (
                    (   (self.owner.player_classified ~= nil and self.owner.player_classified.issleephealing:value()) or
                        GLOBAL.next(self.hots) ~= nil or
                        (self.owner.replica.inventory ~= nil and self.owner.replica.inventory:EquipHasTag("regen"))
                    ) or
                    (self.owner:HasDebuff("wintersfeastbuff"))
                ) and
                self.owner.replica.health ~= nil and self.owner.replica.health:IsHurt()

            local anim =
                (down ~= nil and ("arrow_loop_decrease"..down)) or
                (not up and "neutral") or
                (GLOBAL.next(self.hots) ~= nil and "arrow_loop_increase_most") or
                "arrow_loop_increase"

            if self.arrowdir ~= anim then
                self.arrowdir = anim
                self.sanityarrow:GetAnimState():PlayAnimation(anim, true)
            end
        end
    end
end

AddClassPostConstruct("widgets/healthbadge", HealthbadgePostConstruct)