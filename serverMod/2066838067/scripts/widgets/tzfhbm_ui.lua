require("constants")
local Text = require "widgets/text"
local Image = require "widgets/image"
local Widget = require "widgets/widget"
local UIAnim = require "widgets/uianim"

local tzfhbm_ui = Class(Widget, function(self, owner)
    Widget._ctor(self, "ItemTile")
    self.owner = owner
    self:SetScale(0.09)
    self:Hide()
    self.rechargtime = 180
    self.rechargeframe = self:AddChild(UIAnim())
    self.rechargeframe:GetAnimState():SetBank("tz_fhbmfxs")
    self.rechargeframe:GetAnimState():SetBuild("tz_fhbmfxs")
    self.rechargeframe:GetAnimState():PlayAnimation("tx2")
    self.rechargeframe:GetAnimState():AnimateWhilePaused(false)

    if self.rechargeframe ~= nil then
        self.inst:ListenForEvent("tzfhbmtime",
            function(owner, data)
                if data.time > 0 then
                    self.rechargtime = data.time
                    self:StartUpdating()
                else
                    self:SetChargePercent(0)
                end
            end, owner)
    end
end)

--ThePlayer:PushEvent("tzfhbmtime",{time = 10})

function tzfhbm_ui:SetChargePercent(percent)
    if percent then
        if percent > 0.0001 then
			if not self.shown then
				self:Show()
			end
            self.rechargeframe:GetAnimState():SetPercent("tx2", percent)
        else
			if self.shown then
				self:Hide()
			end
            self:StopUpdating()
        end
    end
end

function tzfhbm_ui:OnUpdate(dt)
    if TheNet:IsServerPaused() then return end
    self.rechargtime =  math.max(self.rechargtime - dt,0)
    self:SetChargePercent(self.rechargtime/180)
end

return tzfhbm_ui
