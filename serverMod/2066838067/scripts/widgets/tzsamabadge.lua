local Widget = require "widgets/widget"
local UIAnim = require "widgets/uianim"
local Text = require "widgets/text"
local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"

local function fire(owner,self)
	if owner._bianshen ~= nil and  owner._bianshen:value() == true then
		self.tzfire:Show()
	else
		self.tzfire:Hide()
	end
end	
local TzsamaBadge = Class(Badge, function(self, owner)
	Badge._ctor(self, "tzsama", owner)
	self.anim:GetAnimState():SetBank("health")

    self.topperanim = self.underNumber:AddChild(UIAnim())
    self.topperanim:GetAnimState():SetBank("status_meter")
    self.topperanim:GetAnimState():SetBuild("status_meter")
    self.topperanim:GetAnimState():PlayAnimation("anim")
    self.topperanim:GetAnimState():SetMultColour(0, 0, 0, 1)
    self.topperanim:SetScale(1, -1, 1)
    self.topperanim:SetClickable(false)
    self.topperanim:GetAnimState():AnimateWhilePaused(false)
    self.topperanim:GetAnimState():SetPercent("anim", 1)

    self.tzsmtz = self.underNumber:AddChild(UIAnim())
    self.tzsmtz:GetAnimState():SetBank("sanity_arrow")
    self.tzsmtz:GetAnimState():SetBuild("sanity_arrow")
    self.tzsmtz:GetAnimState():PlayAnimation("neutral")	
	self.tzsmtz:SetClickable(false)

	self.tzfire = self:AddChild(UIAnim())
    self.tzfire:GetAnimState():SetBank("tz_darkfire")
    self.tzfire:GetAnimState():SetBuild("tz_darkfire")
	self.tzfire:GetAnimState():PlayAnimation("darkfire_loop",true)
	self.tzfire:MoveToBack()
	
	fire(owner,self) 
	self.inst:ListenForEvent("tz_bianshendirty",function(...)
		fire(owner,self)
	end,
	owner)
	self:StartUpdating()
end)
local RATE_SCALE_ANIM =
{
    [RATE_SCALE.INCREASE_HIGH] = "arrow_loop_increase_most",
    [RATE_SCALE.INCREASE_MED] = "arrow_loop_increase_more",
    [RATE_SCALE.INCREASE_LOW] = "arrow_loop_increase",
    [RATE_SCALE.DECREASE_HIGH] = "arrow_loop_decrease_most",
    [RATE_SCALE.DECREASE_MED] = "arrow_loop_decrease_more",
    [RATE_SCALE.DECREASE_LOW] = "arrow_loop_decrease",
}
function TzsamaBadge:OnUpdate(dt)

	local max = self.owner._tzsamamax:value() or 100
	local newpercent = self.owner._tzsamacurrent:value()/max or 1
	self:SetPercent(newpercent, max)

	local death = self.owner._tzsamadeath:value()
	self.topperanim:GetAnimState():SetPercent("anim", 1 - death)

	local anim = "neutral"
	local ratescale = self.owner._tzsamaratescale:value()
        if ratescale == RATE_SCALE.INCREASE_LOW or
            ratescale == RATE_SCALE.INCREASE_MED or
            ratescale == RATE_SCALE.INCREASE_HIGH or
			ratescale == RATE_SCALE.DECREASE_LOW or
            ratescale == RATE_SCALE.DECREASE_MED or
            ratescale == RATE_SCALE.DECREASE_HIGH then
			anim = RATE_SCALE_ANIM[ratescale]
		end

    if self.arrowdir ~= anim then
		self.arrowdir = anim
        self.tzsmtz:GetAnimState():PlayAnimation(anim, true)
    end
end
return TzsamaBadge