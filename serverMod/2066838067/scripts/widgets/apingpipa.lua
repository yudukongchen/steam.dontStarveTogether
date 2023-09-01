local Widget = require "widgets/widget"
local UIAnim = require "widgets/uianim"
local easing = require("easing")

local apingpipa = Class(Widget, function(self, owner)
	Widget._ctor(self, "apingpipa")
    self.owner = owner
	self.ap = self:AddChild(Widget("ap"))
	self:SetClickable(false)
    self.anim = self.ap:AddChild(UIAnim())
    self.anim:GetAnimState():SetBank("tz_floating_texie")
    self.anim:GetAnimState():SetBuild("tz_floating_texiao")
	self.anim:Hide()

    self.anim1 = self.ap:AddChild(UIAnim())
    self.anim1:GetAnimState():SetBank("tz_avatar_texie")
    self.anim1:GetAnimState():SetBuild("tz_avatar_texie")
	self.anim1:SetScale(0.85) --变身的特写大小大小
	self.anim1:Hide()
	
	self.owner:ListenForEvent( "apingpipadrity", function(...)
		if self.owner.apingpipa ~= nil and self.owner.apingpipa:value() == 1 then
			self.anim:Show()
			self.anim:GetAnimState():PlayAnimation("ui_master_pre")
			self.anim:GetAnimState():PushAnimation("ui_master_loop")
			self.anim:GetAnimState():PushAnimation("ui_master_pst",false)
		end
	end)
	self.anim.inst:ListenForEvent("animqueueover", function(...)
		if self.anim:GetAnimState():IsCurrentAnimation("ui_master_pst") then
			self.anim:Hide()
		end
	end)
	
	self.owner:ListenForEvent( "apingbianshendrity", function(...)
		if self.owner.apingbianshen ~= nil and self.owner.apingbianshen:value() == 1 then
			self.anim1:Show()
			self.anim1:GetAnimState():PlayAnimation("ui_master_pre")
			self.anim1:GetAnimState():PushAnimation("ui_master_loop")
			self.anim1:GetAnimState():PushAnimation("ui_master_pst",false)
		end
	end)
	self.anim1.inst:ListenForEvent("animqueueover", function(...)
		if self.anim1:GetAnimState():IsCurrentAnimation("ui_master_pst") then
			self.anim1:Hide()
		end
	end)	
	
end)
return apingpipa
