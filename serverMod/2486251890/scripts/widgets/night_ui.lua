local Widget = require "widgets/widget"
local Text = require "widgets/text"
local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"

local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"  --图片按钮类

local Night_Ui = Class(Badge, function(self, owner)
	  Badge._ctor(self, "", owner)

    self.uimain = self.underNumber:AddChild(ImageButton("images/avatars/avatar_yuki.xml", "avatar_yuki.tex"))
    --self.uimain:SetScale(0.7, 0.7, 0.7)
    self.uimain:SetPosition(-50, 0)
    self.uimain:SetClickable(true)
    self.uimain:SetImageNormalColour(1, 1, 1, 0.4)

    self.uimain:SetOnClick(function()
        if owner and owner._buff1_open:value() == true then
             self.uimain:SetImageNormalColour(1, 1, 1, 0.4)
             SendModRPCToServer(MOD_RPC["buff1"]["buff1"]) 

        elseif owner and owner._buff1_open:value() == false then
             self.uimain:SetImageNormalColour(1, 1, 1, 1)
             SendModRPCToServer(MOD_RPC["buff1"]["buff1"], true) 
        end   
    end)  

	  self:StartUpdating()
end)

function Night_Ui:OnUpdate(dt)
	  local owner = self.owner or nil
    if owner and owner._buff1:value() then 
        self:Show()
    else
        self:Hide()                                    
    end
end

return Night_Ui