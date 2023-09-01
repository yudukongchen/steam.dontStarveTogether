local Widget = require "widgets/widget"
local UIAnim = require "widgets/uianim"
local easing = require("easing")

local listenfx = Class(Widget, function(self, owner)
    self.owner = owner
    Widget._ctor(self, "listenfx")
    if self.owner:HasTag("diting") then
    self.anim = self:AddChild(UIAnim())
    self:SetScaleMode(SCALEMODE_FIXEDPROPORTIONAL)

    self:SetClickable(false)
    self.anim:GetAnimState():SetBank("listen_fx")
    self.anim:GetAnimState():SetBuild("listen_fx")
    self.anim:GetAnimState():PlayAnimation("wave", true)
    self:Hide()   --这些画面是一直存在的啊。
   -- self.anim:GetAnimState():SetMultColour(1, 1, 1, 1)
   --[[ self.owner:ListenForEvent("startwave", function() 
               self:Show()  end, 
               self.owner)
    self.owner:ListenForEvent("stopwave", function() 
               self:Hide()  end, 
               self.owner)
    end]]
    self.owner:ListenForEvent("listendirty", function(inst)
		if inst._listen:value() == true then
			self:Startlisten()
		else
			self:Stoplisten()		
		end
    end)
end
end)

function listenfx:Startlisten()
    self:Show()
end

function listenfx:Stoplisten()
    self:Hide()
end

return listenfx
