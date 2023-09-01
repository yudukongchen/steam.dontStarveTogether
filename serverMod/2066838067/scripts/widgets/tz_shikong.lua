local Widget = require "widgets/widget"
local UIAnim = require "widgets/uianim"
local easing = require("easing")
local Text = require "widgets/text"
local ImageButton = require "widgets/imagebutton"
local Image = require "widgets/image"
local UIAnimButton = require "widgets/uianimbutton"

local tz_shikong = Class(Widget, function(self, owner)
	Widget._ctor(self, "tz_shikong")
    
	self.owner = owner
	
	self.root = self:AddChild(Widget("ROOT"))
	self.root:SetVAnchor(ANCHOR_MIDDLE)
	self.root:SetHAnchor(ANCHOR_MIDDLE)
	self.root:SetPosition(-400, -50 ,0)
	self.root:SetScaleMode(SCALEMODE_PROPORTIONAL)
	
	local bg = self.root:AddChild(UIAnim())
    bg:GetAnimState():SetBank("tz_shikong_ui")
    bg:GetAnimState():SetBuild("tz_shikong_ui")
    bg:GetAnimState():PlayAnimation("idle")
	bg:SetScale(0.8)	
	
	self.date = bg:AddChild(Text(TITLEFONT, 30, "0000-00-00"))
	self.date:SetPosition(225, -183, 0)
	
	self.upTime = function()
		TheSim:QueryServer("https://taizhen.online:3369/tz/getTime?kid="..self.owner.userid,function(str, succ, code)
			if succ and code == 200 then
				local re, jso = pcall(json.decode, str)
				if re and type(jso) == "table" then
					if jso.success then
						if jso.data ~= nil then
							self.date:SetString(tostring(jso.data))
						end
					end
					-- self.owner.components.talker:Say(tostring(jso.msg))
					print(jso.msg)
				else
					-- self.owner.components.talker:Say("数据异常")
				end
			else
				-- self.owner.components.talker:Say("连接时空终端异常")
			end
		end, 'GET')
	end
	
	local download = bg:AddChild(UIAnimButton("tz_shikong_ui", "tz_shikong_ui"))
	download.animstate:PlayAnimation("button_a_idle")
	download.animstate:SetDeltaTimeMultiplier(4)
	download:SetPosition(225, 200, 0)
	download:SetScale(0.9)
	download:SetOnClick(function()
		download.animstate:PlayAnimation("button_a_press")
		download.animstate:PushAnimation("button_a_idle")
		SendModRPCToServer(MOD_RPC["tz"]["shikong"],true)
	end)
	
	local upload = bg:AddChild(UIAnimButton("tz_shikong_ui", "tz_shikong_ui"))
	upload.animstate:PlayAnimation("button_b_idle")
	upload.animstate:SetDeltaTimeMultiplier(4)
	upload:SetPosition(225, 80, 0)
	upload:SetScale(0.9)
	upload:SetOnClick(function()
		upload.animstate:PlayAnimation("button_b_press")
		upload.animstate:PushAnimation("button_b_idle")
		SendModRPCToServer(MOD_RPC["tz"]["shikong"],false)
		self.upTime()
	end)
	
	local off = bg:AddChild(UIAnimButton("tz_shikong_ui", "tz_shikong_ui"))
	off.animstate:PlayAnimation("button_c_idle")
	off.animstate:SetDeltaTimeMultiplier(5)
	off:SetPosition(335, 280, 0)
	off:SetOnClick(function()
		off.animstate:PlayAnimation("button_c_press")
		off.animstate:PushAnimation("button_c_idle")
		self:Close()	
	end)
	
	self.inst:DoTaskInTime(1, self.upTime)
	
end)

function tz_shikong:Start()
    self:Show()
	self.root:MoveTo(Vector3(-400,1000,0), Vector3(-400, -50 ,0), .7)
end

function tz_shikong:Close()
    self.root:MoveTo(Vector3(-400, -50 ,0), Vector3(-400,1000,0), .7, function() self:Hide() end)
end

return tz_shikong
