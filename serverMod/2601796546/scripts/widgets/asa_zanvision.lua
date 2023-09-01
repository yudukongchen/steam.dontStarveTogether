local Widget = require "widgets/widget"
local Image = require "widgets/image"


local asa_zanvision = Class(Widget, function(self, owner)
    self.owner = owner
    Widget._ctor(self, "asa_zanvision")
	self:SetClickable(false)

	self.img = self:AddChild(Image("images/hud/asa_vision.xml", "asa_vision.tex"))
	self.img:SetEffect( "shaders/uifade.ksh" )
    self.img:SetHAnchor(ANCHOR_MIDDLE)
    self.img:SetVAnchor(ANCHOR_MIDDLE)
    self.img:SetScaleMode(SCALEMODE_FILLSCREEN)

    self:Hide()
    
    self.inst:ListenForEvent("asa_zanning", function() 
		if self.owner._zanvision and self.owner._zanvision:value() ~= 0 then
			self:Show()
			self.img:SetFadeAlpha(0.8)
		else
			self.img:SetFadeAlpha(0.6)
			self.inst:DoTaskInTime(0.04,function()
				self.img:SetFadeAlpha(0.4)
			end)
			self.inst:DoTaskInTime(0.08,function()
				self.img:SetFadeAlpha(0.2)
			end)
			self.inst:DoTaskInTime(0.12,function()
				self:Hide()
			end)
		end
	end, self.owner)
	
	self.inst:ListenForEvent("ScanVision", function() 
		if self.owner.scanvision and self.owner.scanvision:value() ~= 0 then
			self:Show()
			self.img:SetFadeAlpha(0.8)
		else
			self.img:SetFadeAlpha(0.6)
			self.inst:DoTaskInTime(0.04,function()
				self.img:SetFadeAlpha(0.4)
			end)
			self.inst:DoTaskInTime(0.08,function()
				self.img:SetFadeAlpha(0.2)
			end)
			self.inst:DoTaskInTime(0.12,function()
				self:Hide()
			end)
		end
	end, self.owner)
end)

return asa_zanvision