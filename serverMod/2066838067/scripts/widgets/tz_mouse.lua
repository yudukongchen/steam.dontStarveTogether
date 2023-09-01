local Widget = require "widgets/widget"
local UIanim = require "widgets/uianim"
local Scale = 0.4 --缩放
local Postion = { x=0, y=0}   --位置
global("themouse")

local tz_mouse = Class(Widget, function(self)
    Widget._ctor(self, "tz_mouse")
    --self.owner = owner
    self.isFE = false
    self:SetClickable(false)
    --self:MakeNonClickable()
    themouse = self
    self.mouse = self:AddChild(UIanim())
    self.anim = self.mouse:GetAnimState()
    self:SetScale(Scale,Scale,Scale)
    self.anim:SetBank("tz_mouse")
    self.anim:SetBuild("tz_mouse")
    self.anim:PlayAnimation("normal",true)
    self:FollowMouseConstrained()
end)

function tz_mouse:OnUpdate()
end
function tz_mouse:to(str)
    self.anim:PlayAnimation(str,true)
end
function tz_mouse:UpdatePosition(x, y)
    if self.TZIsHUDScreen and not self.TZIsHUDScreen() then
        self:Hide()
    else
        self:Show()
    end
    
    if TheInput:IsMouseDown(MOUSEBUTTON_LEFT) or TheInput:IsMouseDown(MOUSEBUTTON_RIGHT) or TheInput:IsMouseDown(MOUSEBUTTON_MIDDLE) then
        self:to("bring")
    elseif TheInput:GetHUDEntityUnderMouse() or TheInput:GetWorldEntityUnderMouse() then
        self:to("sport")
    else
        self:to("normal")
    end
    --TheInputProxy:SetCursorVisible(false)
    self:SetPosition(x+Postion.x,y+Postion.y)
end

function tz_mouse:FollowMouseConstrained()
    if self.followhandler == nil then
        self.followhandler = TheInput:AddMoveHandler(function(x, y) self:UpdatePosition(x, y) end)
        local pos = TheInput:GetScreenPosition()
        self:UpdatePosition(pos.x, pos.y)
    end
end

return tz_mouse
