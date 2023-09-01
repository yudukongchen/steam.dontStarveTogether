local Widget = require "widgets/widget"
local UIAnim = require "widgets/uianim"
local easing = require("easing")

local cd = 180

local tz_rskill = Class(Widget, function(self, owner)
	Widget._ctor(self, "tz_rskill")
    self.owner = owner
	self.ap = self:AddChild(Widget("ap"))
	
    self.anim = self.ap:AddChild(UIAnim())
    self.anim:GetAnimState():SetBank("tz_skill_ui")
    self.anim:GetAnimState():SetBuild("tz_skill_ui")
	self.anim:GetAnimState():PlayAnimation("skill_B_loop")

    self.cdanim = self.anim:AddChild(UIAnim())
    self.cdanim:GetAnimState():SetBank("tz_skill_cd")
    self.cdanim:GetAnimState():SetBuild("tz_skill_cd")
	self.cdanim:SetPosition(0,172,0)
	self.cdanim:SetScale(1.15,1.15,1.15)

    self.kuang = self.anim:AddChild(UIAnim())
    self.kuang:GetAnimState():SetBank("tz_skill_ui")
    self.kuang:GetAnimState():SetBuild("tz_skill_ui")
	self.kuang:GetAnimState():PlayAnimation("R_loop")
	
	
	self.string = self.anim:AddChild(Image("images/tzxx/tz_wu.xml", "skill-9.tex"))
	self.string:SetPosition(250,500,0)  --R按钮的坐标
	self.string:Hide()
	self.string:SetScale(1.5)	--R按钮的大小
	
	self.anim.OnGainFocus = function()
		self.string:Show()
	end
	self.anim.OnLoseFocus = function()
		self.string:Hide()
	end
	
	self.cd = false
	self.starttime = 0
	self.maxcd = cd
	
	self.owner:ListenForEvent( "tz_xx_skilldrity", function(...)
		if self.owner.tz_xx_skill ~= nil and self.owner.tz_xx_skill:value() == 2 then
			self.starttime = 0
			self.cd = true
			self:StartUpdating()
		end
	end)
end)

function tz_rskill:Start()
	self.anim:GetAnimState():PlayAnimation("skill_B_pre")
	self.anim:GetAnimState():PushAnimation("skill_B_loop")
	self.kuang:GetAnimState():PlayAnimation("R_pre")
	self.kuang:GetAnimState():PushAnimation("R_loop")	
end
function tz_rskill:SetCdPercent(percent)
    if percent < 1 then
        self.cdanim:GetAnimState():SetPercent("do", percent)
    else
        if not self.cdanim:GetAnimState():IsCurrentAnimation("finash") then
            self.cdanim:GetAnimState():PlayAnimation("finash")
        end
		self.cd = false
        self:StopUpdating()
    end
end

function tz_rskill:OnUpdate(dt)
	self.starttime = self.starttime + dt
    self:SetCdPercent(self.starttime / self.maxcd)
end
return tz_rskill
