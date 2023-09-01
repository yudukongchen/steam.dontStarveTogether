local Widget = require "widgets/widget"
local UIAnim = require "widgets/uianim"

local HuanYingTeXie = Class(Widget, function(self, owner)
	Widget._ctor(self, "HuanYingTeXie")
    self.owner = owner
	self:SetClickable(false)

    self.anim = self:AddChild(UIAnim())
    self.anim:GetAnimState():SetBank("tz_huanying_texie")
    self.anim:GetAnimState():SetBuild("tz_huanying_texie")
  	self.anim:SetScale(0.6,0.6)

	self:Hide()

	self.anim.inst:ListenForEvent("animqueueover", function(...)
		if self.anim:GetAnimState():IsCurrentAnimation("ui_master_pst") or self.anim:GetAnimState():IsCurrentAnimation("ui_cave_pst") then
			self:Hide()
		end
	end)
end)

function HuanYingTeXie:Play(ptype)

	ptype = ptype or "master"
	if ptype == "master" then 
		--left corner
		self:SetHAnchor(ANCHOR_LEFT)
		self:SetVAnchor(ANCHOR_BOTTOM)
	elseif ptype == "cave" then 
		--right corner
		self:SetHAnchor(ANCHOR_RIGHT)
		self:SetVAnchor(ANCHOR_BOTTOM)
	end

	local name = "ui_"..ptype
	self:Show()
	self.anim:GetAnimState():PlayAnimation(name.."_pre")
	self.anim:GetAnimState():PushAnimation(name.."_loop",false)
	self.anim:GetAnimState():PushAnimation(name.."_pst",false)
end
return HuanYingTeXie
