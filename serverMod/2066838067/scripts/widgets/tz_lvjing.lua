local Widget = require "widgets/widget"
local UIAnim = require "widgets/uianim"


local function fire(owner,self)
	if owner._bianshen ~= nil and  owner._bianshen:value() == true then
		self:Show()
	else
		self:Hide()
	end
end	

local tz_lvjing = Class(Widget, function(self, owner)
    self.owner = owner
    Widget._ctor(self, "tz_lvjing")
    self:SetClickable(false)

    self.bg2 = self:AddChild(Image("images/hud/tz_lvjing.xml", "tz_lvjing.tex"))
    self.bg2:SetVRegPoint(ANCHOR_MIDDLE)
    self.bg2:SetHRegPoint(ANCHOR_MIDDLE)
    self.bg2:SetVAnchor(ANCHOR_MIDDLE)
    self.bg2:SetHAnchor(ANCHOR_MIDDLE)
    self.bg2:SetScaleMode(SCALEMODE_FILLSCREEN)

    fire(owner,self)
	self.inst:ListenForEvent("tz_bianshendirty", function(inst)
		fire(owner,self)
	end,owner)
end)

return tz_lvjing
