local Widget = require "widgets/widget"
local Image = require "widgets/image"

local asa_maxvision = Class(Widget, function(self, owner)
    self.owner = owner
    Widget._ctor(self, "asa_maxvision")
	self:SetClickable(false)

	self.img = self:AddChild(Image("images/hud/asa_vision2.xml", "asa_vision2.tex"))
	self.img:SetEffect( "shaders/uifade.ksh" )
    self.img:SetHAnchor(ANCHOR_MIDDLE)
    self.img:SetVAnchor(ANCHOR_MIDDLE)
    self.img:SetScaleMode(SCALEMODE_FILLSCREEN)

    self:Hide()
    
    self.inst:ListenForEvent("MaxSkill", function() 
		if self.owner.maxskill and self.owner.maxskill:value() ~= 0 then
			self:Show()
			self.img:SetFadeAlpha(1)
		else
			self.img:SetFadeAlpha(0.8)
			self.inst:DoTaskInTime(0.04,function()
				self.img:SetFadeAlpha(0.6)
			end)
			self.inst:DoTaskInTime(0.08,function()
				self.img:SetFadeAlpha(0.4)
			end)
			self.inst:DoTaskInTime(0.12,function()
				self.img:SetFadeAlpha(0.2)
			end)
			self.inst:DoTaskInTime(0.16,function()
				self:Hide()
			end)
		end
	end, self.owner)
end)

return asa_maxvision