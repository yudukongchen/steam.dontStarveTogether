local Text = require "widgets/text"
local Image = require "widgets/image"
local UIAnim = require "widgets/uianim"
local Screen = require "widgets/screen"
local Widget = require "widgets/widget"
local TextEdit = require "widgets/textedit"

local tz_xin_duihuan = Class(Screen, function(self, owner)
	--------------------------------------------------------------------------------------
	Screen._ctor(self, "星愿祭")
	--------------------------------------------------------------------------------------
	-- self:Hide()
	--------------------------------------------------------------------------------------
	self["显示"] = false
	--------------------------------------------------------------------------------------
	-- self["开启"] = function()
		--------------------------------------------------------------------------------------
		-- self:Show()
		--------------------------------------------------------------------------------------
		self["显示"] = true
		--------------------------------------------------------------------------------------
		--SetAutopaused(true)
		--------------------------------------------------------------------------------------
		TheInput:ClearCachedController()
		--------------------------------------------------------------------------------------
		-- self["背景"]:MoveTo(Vector3(0, 800, 0), Vector3(0, 60, 0), 1)
		--------------------------------------------------------------------------------------
	-- end
	--------------------------------------------------------------------------------------
	self["关闭"] = function()
		--------------------------------------------------------------------------------------
		-- self:Hide()
		--------------------------------------------------------------------------------------
		--SetAutopaused(false)
		--------------------------------------------------------------------------------------
		TheInput:CacheController()
		--------------------------------------------------------------------------------------
		-- TheWorld:PushEvent("continuefrompause")
		--------------------------------------------------------------------------------------
		self["背景"]:MoveTo(Vector3(0, 60, 0), Vector3(0, 800, 0), 1, function()
			self["显示"] = false
			TheFrontEnd:PopScreen(self)
		end)
		--------------------------------------------------------------------------------------
	end
	--------------------------------------------------------------------------------------
	self.OnControl = function(zj, control, down)
		if not down and control == CONTROL_CANCEL then
			self["关闭"]()
			return true
		end
		if Widget.OnControl(self, control, down) then return true end
		return false
	end
	--------------------------------------------------------------------------------------
	-- self["监听"] = function()
		-- TheInput:AddKeyUpHandler(27, function()
			-- if self["显示"] then
				-- self["关闭"]()
			-- end
		-- end)
	-- end
	--------------------------------------------------------------------------------------
	self["根源"] = self:AddChild(Widget("ROOT"))
	self["根源"]:SetHAnchor(ANCHOR_MIDDLE)
	self["根源"]:SetVAnchor(ANCHOR_MIDDLE)
	self["根源"]:SetScaleMode(SCALEMODE_PROPORTIONAL)
	--------------------------------------------------------------------------------------
    self["根源_顶部"] = self:AddChild(Widget("top"))
    self["根源_顶部"]:SetHAnchor(ANCHOR_MIDDLE)
    self["根源_顶部"]:SetVAnchor(ANCHOR_TOP)
    self["根源_顶部"]:SetScaleMode(SCALEMODE_PROPORTIONAL)
    self["根源_顶部"]:SetMaxPropUpscale(MAX_HUD_SCALE)
	--------------------------------------------------------------------------------------
	self["背景"] = self["根源"]:AddChild(Image("images/tz_xin_jm_tp/7.xml", "7.tex"))
	-- self["背景"]:SetPosition(0, 60, 0)--ThePlayer["太真_鑫_界面_兑换"]["背景"]:SetPosition(0, 60 ,0)
    self["背景"]:SetScale(0.8, 0.8, 0.8)--ThePlayer["太真_鑫_界面_兑换"]["背景"]:SetScale(0.8, 0.8, 0.8)
	self["背景"]:MoveTo(Vector3(0, 800, 0), Vector3(0, 60, 0), 1)
	--------------------------------------------------------------------------------------
	self["星愿条"] = self["背景"]:AddChild(Image("images/tz_xin_jm_tp/3.xml", "3.tex"))
	self["星愿条"]:SetPosition(-440, 210, 0)--ThePlayer["太真_鑫_界面_兑换"]["星愿条"]:SetPosition(-440, 210 ,0)
	--------------------------------------------------------------------------------------
	self["输入框"] = self["背景"]:AddChild(Image("images/tz_xin_jm_tp/4.xml", "4.tex"))
	self["输入框"]:SetPosition(-10, -310, 0)--ThePlayer["太真_鑫_界面_兑换"]["输入框"]:SetPosition(-10, -310 ,0)
	--------------------------------------------------------------------------------------
    -- self["输入框背景"] = self["输入框"]:AddChild( Image() )
    -- self["输入框背景"]:SetTexture( "images/textboxes.xml", "textbox2_grey.tex" )
    -- self["输入框背景"]:SetPosition(-23, -5, 0)--ThePlayer["太真_鑫_界面_兑换"]["输入框背景"]:SetPosition(-23, -5 ,0)
    -- self["输入框背景"]:ScaleToSize(310, 70)--ThePlayer["太真_鑫_界面_兑换"]["输入框背景"]:ScaleToSize(310, 70)
	--------------------------------------------------------------------------------------
	self["输入框文本"] = self["输入框"]:AddChild(TextEdit(NEWFONT, 25, ""))
	self["输入框文本"]:SetPosition(-25, -5, 0)--ThePlayer["太真_鑫_界面_兑换"]["输入框文本"]:SetPosition(-25, -5 ,0)
	self["输入框文本"]:SetRegionSize(280, 70)--ThePlayer["太真_鑫_界面_兑换"]["输入框文本"]:SetRegionSize(280, 70)
	self["输入框文本"]:SetHAlign(ANCHOR_LEFT)
	-- self["输入框文本"]:SetFocusedImage( self["输入框背景"], "images/textboxes.xml", "textbox2_grey.tex", "textbox2_gold.tex", "textbox2_gold_greyfill.tex" )
	self["输入框文本"]:SetTextLengthLimit( 254 )
	self["输入框文本"]:SetForceEdit(true)
    
    self["输入框文本"]:SetHelpTextApply('请输入CDK')
    self["输入框文本"]:SetTextPrompt('请输入CDK', UICOLOURS.GREY)
    self["输入框文本"]:SetCharacterFilter("-0123456789QWERTYUPASDFGHJKLZXCVBNMqwertyupasdfghjklzxcvbnm")
        
        
	-- self["输入框文本"]:SetCharacterFilter([[ abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,[]@!()'*+-/?{}" ]])
	--------------------------------------------------------------------------------------
	self["祈愿文本"] = self["背景"]:AddChild(Text(DEFAULTFONT, 36, tz_xin["tz_xin_jhm"]))
	self["祈愿文本"]:SetPosition(175, -260 ,0)--ThePlayer["太真_鑫_界面_兑换"]["祈愿文本"]:SetPosition(175, -300 ,0)
	self["祈愿文本"].SetTint = function(self, r, g, b, a)
		self:SetColour(self.colour[1], self.colour[2], self.colour[3], a)
	end
	self["祈愿文本"]:SetTint(1, 1, 1, 0)
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	self["祈愿按钮"] = self["背景"]:AddChild(Image("images/tz_xin_jm_tp/5.xml", "5.tex"))
	self["祈愿按钮"]:SetPosition(175, -315 ,0)--ThePlayer["太真_鑫_界面_兑换"]["祈愿按钮"]:SetPosition(175, -315 ,0)
	self["祈愿按钮"].OnControl = function(zj, control, down)
		if control == CONTROL_ACCEPT then
			if down then
				self["祈愿按钮"]:SetTexture("images/tz_xin_jm_tp/6.xml", "6.tex")
			else
				self["祈愿按钮"]:SetTexture("images/tz_xin_jm_tp/5.xml", "5.tex")
				if owner then-- SendModRPCToServer(MOD_RPC["太真_鑫"]["解锁道具"], "赤子之心")
                    local cdk = self["输入框文本"]:GetString()
					if cdk then
						local cdk = cdk:upper()
                        if not (cdk:match('^[SB][0-9A-Z\-]+$') and cdk:utf8len() == 23) then
                            TaiZhenPushPopupDialog("太真的温馨提示","请输入正确的卡密")
                            return
                        end
						--local a = TaiZhenPushPopupDialog("太真的温馨提示","正在激活中,请稍后查看结果")
                        TaiZhenUseSkinCDK(cdk,owner.RefreshXingYuanSkin)
					else
                        TaiZhenPushPopupDialog("太真的温馨提示","请输入卡密")
                    end
				end
			end
		end
	end
	--------------------------------------------------------------------------------------
	self["关闭按钮"] = self["背景"]:AddChild(Image("images/tz_xin_jm_tp/1.xml", "1.tex"))
	self["关闭按钮"]:SetPosition(420, 260 ,0)
	self["关闭按钮"].OnControl = function(zj, control, down)
		if control == CONTROL_ACCEPT then
			if down then
				self["关闭按钮"]:SetTexture("images/tz_xin_jm_tp/2.xml", "2.tex")
			else
				self["关闭按钮"]:SetTexture("images/tz_xin_jm_tp/1.xml", "1.tex")
				self["关闭"]()
			end
		end
	end
	--------------------------------------------------------------------------------------
	owner["太真_鑫_界面_兑换"] = self
end)

return tz_xin_duihuan