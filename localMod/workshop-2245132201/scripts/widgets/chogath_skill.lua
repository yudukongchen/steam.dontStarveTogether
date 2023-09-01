
-- 首先，在文件的头部写上需要加载的Widget类
local Widget = require "widgets/widget" --Widget，所有widget的祖先类
local Text = require "widgets/text" --Text类，文本处理
local UIAnim = require "widgets/uianim"  --动画类,用于播放动画
local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"  --图片按钮类
local Button = require "widgets/button"  --文本按钮类,用的比较少

local Chocath_skill = Class(Widget, function(self) -- 这里定义了一个Class，第一个参数是父类，第二个参数是构造函数，函数的参数第一个固定为self，后面的参数可以不写，也可以自定义。
    Widget._ctor(self, "Chocath_skill") --这一句必须写在构造函数的第一行，否则会报错。
    --这表明调用父类的构造函数（此处是Widget，如果继承Text，则应该写Text._ctor），第一个参数是固定的self，后面的参数同这个父类的构造函数的参数，此处写的是Widget的名字。
    local owner = ThePlayer
---------------------------------狂暴部分
    self.ui_skill_angry = self:AddChild(Image("images/skill_ui/chocath_level.xml", "chocath_level.tex" ))
    self.ui_skill_angry:SetScale(.3)
    self.ui_skill_angry:SetPosition(-110, 0)

    self.ui_skill_angry_text = self:AddChild(Text(BODYTEXTFONT, 30, " ")) --添加一个文本变量，接收Text实例。
  --  self.ui_skill_angry_text:SetScale(1.1, 1.1, 1.1)
    self.ui_skill_angry_text:SetPosition(-107, 0)
    self.ui_skill_angry_text:Hide()  --数字隐藏
    --self.ui_skill_z_text:SetColour({ 1,0, 0, 1 })  

    self.ui_skill_angry.OnGainFocus = function() --鼠标靠近时
         self.ui_skill_angry_text:Show()  --数字显示
    end

    self.ui_skill_angry.OnLoseFocus = function()  --鼠标远离时
         self.ui_skill_angry_text:Hide()  --数字隐藏
    end 

-----------------------------------狂杀部分
    self.ui_skill_walk = self:AddChild(Image("images/skill_ui/skillone_ui.xml", "skillone_ui.tex"))
    self.ui_skill_walk:SetScale(.3)
    self.ui_skill_walk:SetPosition(-30, 0)
    self.ui_skill_walk:Hide()

    self.ui_skill_walk_shadow = self:AddChild(Image("images/skill_ui/skillone_ui_cd.xml", "skillone_ui_cd.tex"))
    self.ui_skill_walk_shadow:SetScale(.3)
    self.ui_skill_walk_shadow:SetPosition(-30, 0)
    self.ui_skill_walk_shadow:Hide()  

    self.ui_skill_walk_text = self:AddChild(Text(BODYTEXTFONT, 30, " ")) --添加一个文本变量，接收Text实例。
  --  self.ui_skill_angry_text:SetScale(1.1, 1.1, 1.1)
    self.ui_skill_walk_text:SetPosition(-27, 0)
  --  self.ui_skill_walk_text:SetScale(0.9, 0.9, 0.9)
    self.ui_skill_walk_text:Hide()  --数字隐藏    

    self.ui_skill_walk.OnGainFocus = function() --鼠标靠近时
         self.ui_skill_walk_text:Show()  --数字显示
    end

    self.ui_skill_walk.OnLoseFocus = function()  --鼠标远离时
         self.ui_skill_walk_text:Hide()  --数字隐藏
    end 

    self.ui_skill_walk_shadow.OnGainFocus = function() --鼠标靠近时
         self.ui_skill_walk_text:Show()  --数字显示
    end

    self.ui_skill_walk_shadow.OnLoseFocus = function()  --鼠标远离时
         self.ui_skill_walk_text:Hide()  --数字隐藏
    end     
----------------------------------------------
    self.ui_skill_atk = self:AddChild(Image("images/skill_ui/skilltwo_ui.xml", "skilltwo_ui.tex"))
    self.ui_skill_atk:SetScale(.3)
    self.ui_skill_atk:SetPosition(50, 0)

    self.ui_skill_atk_shadow = self:AddChild(Image("images/skill_ui/skilltwo_ui_cd.xml", "skilltwo_ui_cd.tex"))
    self.ui_skill_atk_shadow:SetScale(.3)
    self.ui_skill_atk_shadow:SetPosition(50, 0)
    self.ui_skill_atk_shadow:Hide()    

    self.ui_skill_atk_text = self:AddChild(Text(BODYTEXTFONT, 30, " ")) --添加一个文本变量，接收Text实例。
   -- self.ui_skill_atk_text:SetScale(0.9, 0.9, 0.9)
    self.ui_skill_atk_text:SetPosition(53, 0)
    self.ui_skill_atk_text:Hide()  --数字隐藏
    --self.ui_skill_z_text:SetColour({ 1,0, 0, 1 })  

    self.ui_skill_atk.OnGainFocus = function() --鼠标靠近时
         self.ui_skill_atk_text:Show()  --数字显示
    end

    self.ui_skill_atk.OnLoseFocus = function()  --鼠标远离时
         self.ui_skill_atk_text:Hide()  --数字隐藏
    end

    self.ui_skill_atk_shadow.OnGainFocus = function() --鼠标靠近时
         self.ui_skill_atk_text:Show()  --数字显示
    end

    self.ui_skill_atk_shadow.OnLoseFocus = function()  --鼠标远离时
         self.ui_skill_atk_text:Hide()  --数字隐藏
    end        
-----------------------------------十字斩部分

    if owner.prefab == "chogath" then

  if owner._canuseskill1:value() == false then
            self.ui_skill_walk:Hide()
            self.ui_skill_walk_shadow:Show()            
  else
            self.ui_skill_walk:Show()
            self.ui_skill_walk_shadow:Hide()
  end

  if owner._canuseskill2:value() == false then
            self.ui_skill_atk:Hide()
            self.ui_skill_atk_shadow:Show()            
  else
            self.ui_skill_atk:Show()
            self.ui_skill_atk_shadow:Hide()
  end
      
            self:StartUpdating()  --开始更新s
        else
            self:Hide()
    end     
end)

function Chocath_skill:OnUpdate(dt)
   local owner = ThePlayer
      if owner._canuseskill1:value() == false then
            self.ui_skill_walk:Hide()
            self.ui_skill_walk_shadow:Show()            
      else
            self.ui_skill_walk:Show()
            self.ui_skill_walk_shadow:Hide()
      end

      if owner._canuseskill2:value() == false then
            self.ui_skill_atk:Hide()
            self.ui_skill_atk_shadow:Show()            
      else
            self.ui_skill_atk:Show()
            self.ui_skill_atk_shadow:Hide()
      end

   self.ui_skill_angry_text:SetString("层数:"..owner._level:value())
   self.ui_skill_walk_text:SetString("盛宴:"..owner._skillone_Cd:value())
   self.ui_skill_atk_text:SetString("咆哮:"..owner._skilltwo_Cd:value())
end
--[[
function Hello:OnControl (control, down)
  if control == CONTROL_ACCEPT then
    if down then
      self:StartDrag()
    else
      self:EndDrag()
    end
  end
end

function Hello:SetDragPosition(x, y, z)
  local pos
  if type(x) == "number" then
    pos = Vector3(x, y, z)
  else
    pos = x
  end
  self:SetPosition(pos + self.dragPosDiff)
end

function Hello:StartDrag()
  if not self.followhandler then
    local mousepos = TheInput:GetScreenPosition()
    self.dragPosDiff = self:GetPosition() - mousepos
    self.followhandler = TheInput:AddMoveHandler(function(x,y) self:SetDragPosition(x,y) end)
    self:SetDragPosition(mousepos)
  end
end

function Hello:EndDrag()
  if self.followhandler then
    self.followhandler:Remove()
  end
  self.followhandler = nil
  self.dragPosDiff = nil
end
]]
return Chocath_skill