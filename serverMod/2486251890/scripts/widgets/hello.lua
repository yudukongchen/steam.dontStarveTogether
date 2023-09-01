local Widget = require "widgets/widget"
local UIAnim = require "widgets/uianim"
local Text = require "widgets/text"
local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"

local Hello = Class(Badge, function(self, owner)
	Badge._ctor(self, "hello", owner)

     self.text = self:AddChild(Text(BODYTEXTFONT, 30,"")) --添加一个文本变量，接收Text实例。
     self.text:SetScale(1.2, 1.2, 1.2)
     self.text:SetPosition(0, -550)
     --self.text:Hide()  --数字显示

     --self:SetScale(2.2)  --数字越大ui越小？？？.

	 self:StartUpdating()
end)

function Hello:OnUpdate(dt)
    local owner = self.owner or nil    

    if owner and owner._gxb:value() then
        if owner:HasTag("ly") then 
            self.text:SetString("IPS干细胞: "..owner._gxb:value())
        else
            self.text:SetString("血族能量: "..owner._gxb:value())
        end        
    end
end

return Hello