local Widget = require "widgets/widget"
local UIAnim = require "widgets/uianim"
local easing = require("easing")
local Text = require "widgets/text"

local function gettime(time)
	local m = os.time({year=2020,month=1,day=1,sec=time})
	return os.date("%M:%S",m)
end

local function SetCD(inst,self)
	self.num = self.num -1
	if self.num <= 0 then
		if  self.task then
			self.task:Cancel()
			self.task = nil
		end
		self.cd:SetString("00:00")
	else
		self.cd:SetString(gettime(self.num))
	end
end

local tz_pillui = Class(Widget, function(self, owner)
	Widget._ctor(self, "tz_pillui")
    
	self.owner = owner
	self.num = 0
	self.pillui = self:AddChild(Widget("pillui"))
	
	self:SetClickable(false)
	
    self.anim = self.pillui:AddChild(UIAnim())
    self.anim:GetAnimState():SetBank("tz_ui_pills")
    self.anim:GetAnimState():SetBuild("tz_ui_pills")
	self.anim:Hide()
	
	
    self.cd = self.pillui:AddChild(Text(BODYTEXTFONT, 45)) --45是字大小
	self.cd:SetPosition(22,25,0) --字的坐标 x y
	self.cd:SetScale(1,0.9,1)
	self.cd:Hide()
		
	self.inst:ListenForEvent( "apingbighealthtimedrity", function(...)
		if self.owner.apingbighealthtime ~= nil and self.owner.apingbighealthtime:value() > 0 then
			if self.anim.shown then
				self.anim:GetAnimState():PlayAnimation("ui_pills_loop",false)
			else
				self.anim:Show()
				self.anim:GetAnimState():PlayAnimation("ui_pills_pre")
				self.anim:GetAnimState():PushAnimation("ui_pills_loop",false)
			end
			self.cd:Show()
			self.num = self.owner.apingbighealthtime:value() +1
			if self.task then
				self.task:Cancel()
			end
			self.task = self.inst:DoPeriodicTask(1,SetCD,1/30,self)
		else
			self.num =0
			self.cd:Hide()
			self.anim:GetAnimState():PlayAnimation("ui_pills_pst",false)
		end
	end,self.owner)
	self.anim.inst:ListenForEvent("animover", function(...)
		if self.anim:GetAnimState():IsCurrentAnimation("ui_pills_pst") then
			self.anim:Hide()
		end
	end)
end)

return tz_pillui
