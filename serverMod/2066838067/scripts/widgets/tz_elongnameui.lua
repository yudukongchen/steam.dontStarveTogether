local Widget = require "widgets/widget"
local UIAnim = require "widgets/uianim"
local easing = require("easing")
local Text = require "widgets/text"
local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local TextEdit = require "widgets/textedit"

local tz_elongnameui = Class(Widget, function(self, owner)
	Widget._ctor(self, "tz_elongnameui")
    self.owner = owner
	self.ap = self:AddChild(Widget())

    self.anim1 = self.ap:AddChild(Image("images/tz_elong_nameui.xml", "1.tex"))
	self.anim1:SetScale(1, 1)
	self.anim1:SetPosition(-97, 100)

    self.anim2 = self.ap:AddChild(Image("images/tz_elong_nameui.xml", "2.tex"))
	self.anim2:SetScale(1, 1)
	self.anim2:SetPosition(-50, 48)

	self.anim3 = self.ap:AddChild(ImageButton("images/tz_elong_nameui.xml", "3.tex"))
	self.anim3:SetPosition(124, 100)
	self.anim3:SetOnClick(function() self:Hide() end)

	self.anim4 = self.ap:AddChild(ImageButton("images/tz_elong_nameui.xml", "4.tex"))
	self.anim4:SetPosition(124, 48)
	self.anim4:SetOnClick(function()  
		local msg = self.edit_text:GetString()
		if msg ~= "" then
			SendModRPCToServer( MOD_RPC["tzelongrpc"]["tzelongrpc"],1,msg)
		end
		self:Hide()
	end)

    self.edit_text = self.ap:AddChild(TextEdit(BUTTONFONT, 50, ""))
    self.edit_text:SetColour(1, 1, 1, 1)
    self.edit_text.idle_text_color = {1,1,1,1}
    self.edit_text.edit_text_color = {1,1,1,1}
	self.edit_text:SetEditCursorColour(1,1,1,1)
    self.edit_text:SetForceEdit(true)
    self.edit_text:SetPosition(-38, -10, 0)
    self.edit_text:SetRegionSize(280, 160)
    self.edit_text:SetHAlign(ANCHOR_LEFT)
    self.edit_text:SetVAlign(ANCHOR_TOP)

    self.edit_text:SetTextLengthLimit(16)
    self.edit_text:EnableWordWrap(true)
    self.edit_text:EnableWhitespaceWrap(true)
    self.edit_text:EnableRegionSizeLimit(true)
    self.edit_text:EnableScrollEditWindow(false)

	self.owner:ListenForEvent("openelongui", function(...)
		self.edit_text:SetString("饿龙")
		self:Show()
	end,self.owner)
end)

--不愧是我啊！

return tz_elongnameui
