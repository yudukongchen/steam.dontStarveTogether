local Widget = require "widgets/widget"
local UIAnim = require "widgets/uianim"
local easing = require("easing")
local Text = require "widgets/text"

local tz_elonghealthui = Class(Widget, function(self, owner)
	Widget._ctor(self, "tz_elonghealthui")
    self.owner = owner
	self.ap = self:AddChild(Widget())
	self:SetClickable(false)

    self.anim = self.ap:AddChild(UIAnim())
    self.anim:GetAnimState():SetBank("tz_aoaolong_ui")
    self.anim:GetAnimState():SetBuild("tz_aoaolong_ui")

	self.name = self.anim:AddChild(Text(BODYTEXTFONT, 26))
	self.name:SetString("嗷嗷嗷嗷嗷")
    self.name:SetHAlign(ANCHOR_LEFT)
    self.name:SetRegionSize(300, 30)
	self.name:SetPosition(195, 18)
    self.name:Hide()

	self.maxhp = self.anim:AddChild(Text(BODYTEXTFONT, 25))
	self.maxhp:SetString("/ "..TUNING.TZ_ELONGMAXHEALTH)
	self.maxhp:SetPosition(124, -20)
    self.maxhp:Hide()

	self.currenthp = self.anim:AddChild(Text(BODYTEXTFONT, 41))
	self.currenthp:SetString("2000")
    self.currenthp:SetHAlign(ANCHOR_RIGHT)
    self.currenthp:SetRegionSize(100, 30)
	self.currenthp:SetPosition(52, -14)
    self.currenthp:Hide()

	self.owner:ListenForEvent("elengridingdrity", function(...)
		if self.owner.ellong_riding ~= nil and self.owner.ellong_riding:value() then
			self:Show()
			self.anim:GetAnimState():PlayAnimation("show_pre")
            local time =self.anim:GetAnimState():GetCurrentAnimationLength()+0.1
			self.anim:GetAnimState():PushAnimation("show_loop",false)
            self.inst:DoTaskInTime(time,function()
                if self.anim:GetAnimState():IsCurrentAnimation("show_loop") then
                    self.maxhp:Show()
                    self.currenthp:Show()
                    self.name:Show()
                end
            end)
        else
            self.anim:GetAnimState():PlayAnimation("show_pst")
            self.name:Hide()
            self.maxhp:Hide()
            self.currenthp:Hide()
		end
	end)
	self.anim.inst:ListenForEvent("animover", function(...)
		if self.anim:GetAnimState():IsCurrentAnimation("show_pst") then
			self:Hide()           
		end
	end)
	self.owner:ListenForEvent( "elongnamedrity", function(...)
		if self.owner.elong_name ~= nil then
            self.name:SetString(self.owner.elong_name:value())
		end
	end)
	self.owner:ListenForEvent( "elonghealthdrity", function(...)
		if self.owner.elong_health ~= nil then
            self.currenthp:SetString(""..self.owner.elong_health:value())
		end
	end)

    self:Hide()
end)

return tz_elonghealthui
