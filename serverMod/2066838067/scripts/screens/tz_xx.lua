local Screen = require "widgets/screen"
local Widget = require "widgets/widget"
local UIAnim = require "widgets/uianim"
local UIAnimButton = require "widgets/uianimbutton"
local Text = require "widgets/text"

local skillpos = { --10个技能的图片的坐标
	{911,625},
	{845,542},
	{787,451},
	{785,253},
	{847,168},
	{930,78},
	{1016,216},
	{1098,353},
	{1010,456},
	{921,348},
}

local skill2 = {
	{"摸摸:","每一点该项属性对人物的提升：减伤+0.5%、食用食物回复效率+1%、饥饿度上限+2"},
	{"嗷呜:","每一点该项属性对人物的提升：生命值上限+1、对攻击闪避几率+0.5%、撒麻值回复+1/min"},
	{"影子舞:","每一点该项属性对人物的提升：攻击吸血+0.1%、脑力值上限+1"},
	{"摇尾巴:","每一点该项属性对人物的提升：攻击吸收精神+0.1%、伤害倍率+2%"},
}

--右边九个技能图标的坐标和大小
local skillimages= {
	{320,327,1}, --坐标和大小
	{190,205,1}, --坐标和大小
	{462,217,1}, --坐标和大小
	{530,20,1}, --坐标和大小
	{455,-175,1}, --坐标和大小
	{330,-315,1}, --坐标和大小 340,-320,1
	{185,-170,1}, --坐标和大小 185,-170,1
	{125,15,1}, --坐标和大小 125,15,1
	{330,20,1.5}, --坐标和大小			
}		
		
local tz_xx = Class(Screen, function(self, owner)
	Screen._ctor(self, "tz_xx")
    self.owner = owner
	self.root = self:AddChild(Widget("ROOT"))
	
	self.root:SetScale(0.8) --整体界面的大小
	--self.ui:SetScaleMode(SCALEMODE_PROPORTIONAL)
	self.ui = self.root:AddChild(Image("images/tzxx/tzxx_back.xml", "background.tex"))
	self.ui:SetPosition(0,0)	
	
	--嗷嗷修仙图标
	self.title = self.ui:AddChild(Image("images/tzxx/tzxx_back.xml", "bigname.tex"))
	self.title:SetPosition(0,490)
	
	--esc图标
	self.esc = self.ui:AddChild(Image("images/tzxx/tzxx_back.xml", "esc.tex"))
	self.esc:SetPosition(550,424)
	
	if owner.tz_xx ~= nil then

		local level = owner.tz_xx:value()[1] --等级
		local jieduan = owner.tz_xx:value()[2] --阶段	
		
		if level > 0 then
		--等级的图标
		self.level = self.ui:AddChild(Image("images/tzxx/tzxx_back.xml", "level-"..(level > 9  and 9 or level)..".tex"))
		self.level:SetPosition(-113,180)
		
		--等级进度 9个小图标
		for k =1,9 do 
			local tex = level > k and "tishi-1.tex" or "tishi-2.tex"
			local image = self.level:AddChild(Image("images/tzxx/tzxx_back.xml", tex))
			image:SetPosition(-130+k*23,135)
		end
				
		--小胡天图标
		self.xht = self.ui:AddChild(Image("images/tzxx/tzxx_xht.xml", "renwu-"..(level > 9  and 9 or level)..".tex"))
		self.xht:SetPosition(-565,-265)

		--武功秘籍图标
		self.miji = self.ui:AddChild(Image("images/tzxx/tzxx_ren.xml", "people-"..(level > 9  and 9 or level)..".tex"))
		self.miji:SetPosition(-375,180)
		
		--四个能力值的坐标
		self.skill2 ={}
		for k =1 ,4 do
			self.skill2[k] = self.ui:AddChild(Text(UIFONT, 45))
			self.skill2[k]:SetPosition(-180+(k%2 == 0 and 0 or 125) ,50-46*(math.ceil(k/2) -1))
			self.skill2[k]:SetColour(178/255,206/255,156/255,1)
			self.skill2[k]:SetString(skill2[k][1].."  "..owner.tz_xx:value()[(2+k)])
			self.skill2[k]:SetHoverText(skill2[k][2])
		end
		self.skill3 = {}

		if level > 9 then --满级任务的说明
		
			self.skill3.back = self.ui:AddChild(Image("images/tzxx/tzxx_back.xml", "beijing.tex"))
			self.skill3.back:SetPosition(-150 ,-120-2*75)
				
			local renwutext = self.skill3.back:AddChild(Text(UIFONT, 38))
			renwutext:SetHAlign(ANCHOR_LEFT)
			renwutext:SetRegionSize(470,100)
			renwutext:SetString("已达到种族上限，获得晋升仙灵资格")				
		else
			local renwu = jieduan > 9 and TUNING.TZXX[level].task2 or TUNING.TZXX[level].task1
			for k =1 ,4 do
				self.skill3[k] = self.ui:AddChild(Image("images/tzxx/tzxx_back.xml", "beijing.tex"))
				self.skill3[k]:SetPosition(-150+(k%2 ~= 0 and 0 or 100) ,-120-(k-1)*75)
			
				local renwutext = self.skill3[k]:AddChild(Text(UIFONT, 38))
				local needmax = jieduan > 9 and renwu[k].num or (renwu[k].num + (jieduan-1)*10)
				local current = owner.tz_xx:value()[(6+k)]
				renwutext:SetHAlign(ANCHOR_LEFT)
				renwutext:SetRegionSize(470,100)
				renwutext:SetString(renwu[k].ms..needmax.."次：".."("..current.."/"..needmax..")")			
			end
		end
		
		--右边的技能介绍
		self.unlock = {}
		for k =1,9 do 
			if level > k then
				local skillimage = self.ui:AddChild(Image("images/tzxx/tz_wu.xml", "image-"..k..".tex"))
				skillimage:SetPosition(skillimages[k][1],skillimages[k][2])
				skillimage:SetScale(skillimages[k][3])
				self.unlock[k] = skillimage
			else
				local skillimage = self.ui:AddChild(Image("images/tzxx/tz_wu.xml", "image-10.tex"))
				skillimage:SetPosition(skillimages[k][1],skillimages[k][2])	
				skillimage:SetScale(skillimages[k][3])				
			end
		end	
			for k,v in ipairs(self.unlock) do
				v.string = self.ui:AddChild(Image("images/tzxx/tz_wu.xml", "skill-"..k..".tex"))
				local x,y = v:GetPosition():Get()
				v.string:SetPosition(x+250,y,0)
				v.string:Hide()
				v.string:SetScale(1.3)
				v.OnGainFocus = function()
					v.string:Show()
				end
				v.OnLoseFocus = function()
					v.string:Hide()
				end
			end		
		end
		
	end
	--任务说明背景
	local scr_w, scr_h = TheSim:GetScreenSize()
	self.out_pos = Vector3(scr_w/2, scr_h*2, 0) --一开始的坐标
	self.in_pos = Vector3(scr_w/2, scr_h/2, 0) --最终的坐标	
	self:Start()
end)

function tz_xx:Start()
    self:MoveTo(self.out_pos, self.in_pos, .33, function() self.settled = true end)
end

function tz_xx:Close()
    self:MoveTo(self.in_pos, self.out_pos, .33, function() TheFrontEnd:PopScreen() end)
end

function tz_xx:OnControl(control, down)
    if tz_xx._base.OnControl(self, control, down) then return true end

    if not down and  control == CONTROL_CANCEL then
        self:Close()
        return true
    end
    return true
end

return tz_xx
