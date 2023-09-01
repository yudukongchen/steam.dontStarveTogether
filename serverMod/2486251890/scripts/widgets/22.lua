
-- 首先，在文件的头部写上需要加载的Widget类
local Widget = require "widgets/widget" --Widget，所有widget的祖先类
local Text = require "widgets/text" --Text类，文本处理
local UIAnim = require "widgets/uianim"  --动画类,用于播放动画
local ImageButton = require "widgets/imagebutton"  --图片按钮类
local Button = require "widgets/button"  --文本按钮类,用的比较少

local Hello = Class(Widget, function(self) -- 这里定义了一个Class，第一个参数是父类，第二个参数是构造函数，函数的参数第一个固定为self，后面的参数可以不写，也可以自定义。
    Widget._ctor(self, "Hello") --这一句必须写在构造函数的第一行，否则会报错。
    --这表明调用父类的构造函数（此处是Widget，如果继承Text，则应该写Text._ctor），第一个参数是固定的self，后面的参数同这个父类的构造函数的参数，此处写的是Widget的名字。
    local owner = ThePlayer
    --  
    self.text = self:AddChild(Text(BODYTEXTFONT, 30,"")) --添加一个文本变量，接收Text实例。
    self.text:SetScale(1.2, 1.2, 1.2)
	  self.text:Hide()  --数字显示

    if owner.prefab == "yuki" then
         self:StartUpdating()  --开始更新
         self.text:Show()
    end     
end)

function Hello:OnUpdate(dt)
   local owner = ThePlayer
        if owner and owner._gxb:value() then 
                self.text:SetString("IPS干细胞: "..owner._gxb:value())
     end    
end

return Hello
