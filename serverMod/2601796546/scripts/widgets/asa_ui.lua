local Widget = require "widgets/widget"
local UIAnim = require "widgets/uianim"
local Text = require "widgets/text"
local Image = require "widgets/image"
local TextEdit = require "widgets/textedit"
local TextButton = require "widgets/textbutton"
local ImageButton = require "widgets/imagebutton"

--能量HUD
local Asa_Pw = Class(Widget, function(self, owner)
	Widget._ctor(self, "Asa_Pw", owner)
	self.owner = owner
	
	self.root = self:AddChild(Widget("root"))
	self.root:SetScaleMode(SCALEMODE_PROPORTIONAL)
	self.root:SetHAnchor(ANCHOR_MIDDLE)
	self.root:SetVAnchor(ANCHOR_MIDDLE)
	self.root:SetPosition(0, 0)
	
	self.asacd = self.root:AddChild(Widget("Asa_CD"))
	self.asacd:SetPosition(-485,333,0)

	self.asacd.anim = self.asacd:AddChild(UIAnim())
	self.asacd:SetScale(0.7)
	self.asacd.anim:GetAnimState():SetBank("asa_cd")
	self.asacd.anim:GetAnimState():SetBuild("asa_cd")
	self.asacd.anim:GetAnimState():PlayAnimation("anim")
	
	self.asapw = self.root:AddChild(Widget("Asa_Pw"))
	self.asapw:SetPosition(-485,330,0)
	self.asapw:SetScale(0.65)
	
	self.asapw.anim = self.asapw:AddChild(UIAnim())
	self.asapw.anim:GetAnimState():SetBank("asa_power")
	self.asapw.anim:GetAnimState():SetBuild("asa_power")
	
	
	--点击弹出面板
	self.click = self.root:AddChild(ImageButton("images/global.xml", "square.tex"))
	self.click.image:SetTint(0,0,0,0.01)
	self.click:SetScale(0.8)
	self.click:SetPosition(-558,310,0)
	self.click:SetOnClick(function()
		owner.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/panel1", nil, 0.3)
		owner.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/panel0")
		owner.HUD:OpenPanel()
		SendModRPCToServer(MOD_RPC.asakiri.SkillRefresh)
	end)
	
	
	self.tip = self.asapw:AddChild(Text(NUMBERFONT, 34, ""))
	self.tip:SetPosition(5,-7,0)
	
	self.asapw:MoveToBack()
	self:StartUpdating()
	
	self.inst:ListenForEvent("MaxSkill", function() 
		if owner.maxskill and owner.maxskill:value() ~= 0 then
			self.asapw.anim:GetAnimState():SetBank("asa_power2")
			self.asapw.anim:GetAnimState():SetBuild("asa_power2")
		else
			self.asapw.anim:GetAnimState():SetBank("asa_power")
			self.asapw.anim:GetAnimState():SetBuild("asa_power")
		end
	end, owner)
end)
function Asa_Pw:OnUpdate(dt)
	local pw = self.owner.asa_pw:value()
	local pwlimit = self.owner.asa_pwlimit:value()
	local maxpw = self.owner.asa_maxpw:value()
	self.asapw.anim:GetAnimState():SetPercent("anim", pw/pwlimit)
	
	local cd = self.owner.asa_cd:value()
	local maxcd = self.owner.asa_maxcd:value()
	self.asacd.anim:GetAnimState():SetPercent("anim", cd/maxcd)
	
	self.tip:SetString(pw.."/"..maxpw)
end

return Asa_Pw