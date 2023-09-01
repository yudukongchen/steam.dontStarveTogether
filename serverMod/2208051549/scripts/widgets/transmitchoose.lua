local Widget = require "widgets/widget"
local Image = require "widgets/image"
local Text = require "widgets/text"
local ImageButton = require "widgets/imagebutton"
local UIAnimButton = require "widgets/uianimbutton"
local UIAnim = require "widgets/uianim"

local transmitchoose = Class(Widget, function(self, owner)  
	Widget._ctor(self, "transmitchoose")
	self.owner = owner
	self.choice = self:AddChild(Widget("choice")) 	
    self.lmimage = self.choice:AddChild(ImageButton(("images/hud/QM_UI01.xml"),("csplayer.tex"), 
    ("csplayer_halfshadow.tex"), ("csplayer_disabled.tex"), 
    ("csplayer_halfshadow.tex"), ("csplayer_disabled.tex"), {1,1}, {0,0}))     --青木整合工具，NB！
    self.lmimage:SetOnClick(function()
        self:Hide()
        SendModRPCToServer( MOD_RPC["diting"]["changenetvar_1"])
        end)
    self.lmimage:SetPosition(60, 0, 0)
	self.lmimage:SetScale(0.7,0.7,0.7)
	self.lmimage:SetHoverText("选择人类(?)",{bg=false})   --悬停文字。bg为文字背景框。
    self.lmimage.hovertext:SetScale(1.5,1.5)    --文字大小
    
    self.lmimage2 = self.choice:AddChild(ImageButton(("images/hud/QM_UI02.xml"),("csfirepit.tex"), 
    ("csfirepit_disabled.tex"), ("csfirepit_halfshadow.tex"), 
    ("csfirepit_disabled.tex"), ("csfirepit_halfshadow.tex"), {1,1}, {0,0}))     
    self.lmimage2:SetOnClick(function()
        self:Hide()
        SendModRPCToServer( MOD_RPC["diting"]["changenetvar_2"])
        end)
    self.lmimage2:SetPosition(-50, 0, 0)
	self.lmimage2:SetScale(0.7,0.7,0.7)
	self.lmimage2:SetHoverText("选择营火",{bg=false})   
    self.lmimage2.hovertext:SetScale(1.5,1.5)   
end)

local function changenetvar_1(inst)
    if inst._csplayer:value() == false then
        inst._csplayer:set(true)
    end
    if inst._csfirepit:value() == true then
        inst._csfirepit:set(false)
    end
end

local function changenetvar_2(inst)
    if inst._csfirepit:value() == false then
        inst._csfirepit:set(true)
    end
    if inst._csplayer:value() == true then
        inst._csplayer:set(false)
    end
end

AddModRPCHandler("diting", "changenetvar_1", changenetvar_1)
AddModRPCHandler("diting", "changenetvar_2", changenetvar_2)

return transmitchoose