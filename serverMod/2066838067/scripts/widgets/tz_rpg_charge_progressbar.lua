local Widget = require "widgets/widget"
local Image = require "widgets/image"
local UIAnim = require "widgets/uianim"
local easing = require("easing")

local SCALE = 0.8

local TzRpgChargeProgressbar = Class(Widget, function(self, owner)
	Widget._ctor(self, "TzRpgChargeProgressbar")

	self.owner = owner
	self.percent = 0
	self.enable_super = false

	self.progressbar = self:AddChild(UIAnim())
	self.progressbar:GetAnimState():SetBank("tz_rpg_progressbar")
	self.progressbar:GetAnimState():SetBuild("tz_rpg_progressbar")
	self.progressbar:GetAnimState():PlayAnimation("xuli_loop",true)
	self.progressbar:GetAnimState():HideSymbol("text")

	self.text_powerup = self.progressbar:AddChild(UIAnim())
	self.text_powerup:GetAnimState():SetBank("tz_rpg_progressbar_addition")
	self.text_powerup:GetAnimState():SetBuild("tz_rpg_progressbar_addition")
	self.text_powerup:SetPosition(0,100)

	self.text_maxpower = self.progressbar:AddChild(UIAnim())
	self.text_maxpower:GetAnimState():SetBank("tz_rpg_progressbar_addition")
	self.text_maxpower:GetAnimState():SetBuild("tz_rpg_progressbar_addition")
	self.text_maxpower:SetPosition(0,100)

	self.middle_line = self.progressbar:AddChild(UIAnim())
	self.middle_line:GetAnimState():SetBank("tz_rpg_progressbar_addition")
	self.middle_line:GetAnimState():SetBuild("tz_rpg_progressbar_addition")
	
	self:EnableSuper(false)
end)

function TzRpgChargeProgressbar:EnableSuper(enable)
	self.enable_super = enable
	if enable then 
		self.middle_line:Show()
		self.middle_line:GetAnimState():PlayAnimation("light",true)
		if self.percent >= 0.5 then 
			self.text_powerup:GetAnimState():PlayAnimation("powerup_pre")
			self.text_powerup:GetAnimState():PushAnimation("powerup_loop",true)
		elseif self.percent >= 1.0 then 
			self.text_maxpower:GetAnimState():PlayAnimation("maxpower_pre")
			self.text_maxpower:GetAnimState():PushAnimation("maxpower_loop",true)
		end
	else
		self.text_powerup:Hide()
		self.text_maxpower:Hide()
		self.middle_line:Hide()
	end
end

function TzRpgChargeProgressbar:SetPercent(percent)
	local old_percent = self.percent
	self.percent = percent
	self.progressbar:GetAnimState():SetPercent("xuli_loop",percent)

	if self.enable_super then 
		if old_percent < 0.5 and percent >= 0.5 then 
			self.text_powerup:Show()
			self.text_powerup:GetAnimState():PlayAnimation("powerup_pre")
			self.text_powerup:GetAnimState():PushAnimation("powerup_loop",true)
		elseif old_percent < 1 and percent >= 1 then 
			self.text_powerup:ScaleTo(1,0.01,0.15,function()
				self.text_powerup:Hide()
				self.text_maxpower:Show()
				self.text_maxpower:GetAnimState():PlayAnimation("maxpower_pre")
				self.text_maxpower:GetAnimState():PushAnimation("maxpower_loop",true)
			end)
		end
	end 
end

function TzRpgChargeProgressbar:PopIn()
	self.progressbar:SetScale(SCALE,0.01)
	self.inst:StartThread(function()
		local acc = 3
		local length,height = self.progressbar:GetScale():Get()
		local max_height = length
		while height < max_height do     
			height = math.min(height + acc * FRAMES,max_height)
			self.progressbar:SetScale(length,height)
			if height >= 0.6 then 
				self.progressbar:GetAnimState():ShowSymbol("text")
			end
			Sleep(0)
		end
	end)
end

function TzRpgChargeProgressbar:PopOut()
	local delay = self.enable_super and 0.7 or 0 
	self.inst:DoTaskInTime(delay,function()
		-- self.progressbar:GetAnimState():PlayAnimation("xuli_pst")
		-- self.progressbar.inst:ListenForEvent("animover",function()
		-- 	self:Kill()
		-- end)
		self.progressbar:ScaleTo(SCALE,0.01,0.5,function()
			self:Kill()
		end)
	end)
end

return TzRpgChargeProgressbar