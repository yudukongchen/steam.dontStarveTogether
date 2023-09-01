--This is from myth！ 

local Widget = require "widgets/widget"
local Image = require "widgets/image"
local Text = require "widgets/text"
local ImageButton = require "widgets/imagebutton"
local UIAnimButton = require "widgets/uianimbutton"

local UIAnim = require "widgets/uianim"

--[[local function IsHUDScreen()  --待学习。
	local defaultscreen = false
	if TheFrontEnd:GetActiveScreen() and TheFrontEnd:GetActiveScreen().name and type(TheFrontEnd:GetActiveScreen().name) == "string" and TheFrontEnd:GetActiveScreen().name == "HUD" then
		defaultscreen = true
	end
	return defaultscreen
end]]

local ditingui = Class(Widget, function(self, owner)  --小部件的名字
	Widget._ctor(self, "ditingui")
	--这表明调用父类的构造函数（此处是Widget，如果继承Text，则应该写Text._ctor），第一个参数是固定的self，后面的参数同这个父类的构造函数的参数，此处写的是Widget的名字。
	--from longfei
	self.owner = owner
	self.wbbg = self:AddChild(Widget("wbbg")) 	--待学习。 就用这个名字吧。
	-- ui移除时干掉监听器                        --借鉴下白骨。white bone!
	--[[self.inst:ListenForEvent("onremove", function()
		if self.handler ~= nil then
			self.handler:Remove()
		end
	end)]]
	
	if self.owner:HasTag("diting") then
		--按键
		--[[self.handler = 
		TheInput:AddKeyDownHandler(KEY_H, function() 
			if not IsHUDScreen() then return end
			self.wbimage.onclick() 
		end)]]
		self.wbimage = self.wbbg:AddChild(UIAnimButton("ditinglisten", "ditinglisten"))   --动画的名字。
		self.wbimage.animstate:PlayAnimation("idle")
		self.wbimage:SetOnClick(function()
			self.wbimage.animstate:PlayAnimation("click")   --动画1
			self.wbimage.animstate:PushAnimation("idle",false)   --动画2  第二个参数有何意味？
			SendModRPCToServer( MOD_RPC["diting"]["listenforeverything"]) --第一个是人物，第二个是触发接口。 --RPC
		end)
	end	
	self.wbimage:SetScale(.28,.28,.28)
	self.wbbg:SetHoverText("听",{bg=false})   --悬停文字。bg为文字背景框。
	self.wbbg.hovertext:SetScale(1.5,1.5)    --文字大小
end)

return ditingui