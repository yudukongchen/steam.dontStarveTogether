local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local Widget = require "widgets/widget"
local Text = require "widgets/text"
local asa_language = TUNING.ASAKIRI_MOD_LANGUAGES == "chinese" and true or false

local AsaPanel = Class(Widget, function(self, owner)
    Widget._ctor(self, "AsaPanel", owner)
	self.owner = owner
	
	local sks = owner.asa_skills:value()	--降维技能表
	sks = json.decode(sks)
	
	self.close = self:AddChild(ImageButton("images/global.xml", "square.tex"))	--抄的落尘的退出背景按钮
	self.close.image:SetVRegPoint(ANCHOR_MIDDLE)
	self.close.image:SetHRegPoint(ANCHOR_MIDDLE)
	self.close.image:SetVAnchor(ANCHOR_MIDDLE)
	self.close.image:SetHAnchor(ANCHOR_MIDDLE)
	self.close.image:SetScaleMode(SCALEMODE_FILLSCREEN)
	self.close.image:SetTint(0,0,0,0.4)
	self.close:MoveToBack()
	self.close:SetOnClick(function()
		owner.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/panel1", nil, 0.1)
		self.base:MoveTo(Vector3(0,0,0),Vector3(0,-600,0),0.2)
		self.inst:DoTaskInTime(0.2,function()
			self:Hide()
		end)
	end)

	self.root = self:AddChild(Widget("root"))	--关键！这一段决定了根目录里所有UI都按比例缩放！
	self.root:SetScaleMode(SCALEMODE_PROPORTIONAL)
	self.root:SetHAnchor(ANCHOR_MIDDLE)
	self.root:SetVAnchor(ANCHOR_MIDDLE)
	self.root:SetPosition(0, 0)
	
	self.base = self.root:AddChild(Image("images/hud/asa_panel.xml", "base.tex"))
	
	-- local w, h = TheSim:GetScreenSize()
	-- local res_scale = math.min(w / 1920, h / 1080)
	
	local xpoint = -138
	local ypoint = 27
	local radii = 70
	local angle = 40
	local iscale = 0.31
	
	
	--图标圆底
	self.base.circle0 = self.base:AddChild(Image("images/hud/asa_panel.xml", "circle.tex"))
	self.base.circle0:SetPosition(xpoint,ypoint)
	
	self.base.circle1 = {}
	self.base.circle2 = {}
	self.base.circle3 = {}
	
	self.base.circle4 = self.base:AddChild(Image("images/hud/asa_panel.xml", "circle.tex"))
	self.base.circle4:SetPosition(xpoint, ypoint + 1.3*radii)
	
	self.base.circle5 = self.base:AddChild(Image("images/hud/asa_panel.xml", "circle.tex"))
	self.base.circle5:SetPosition(xpoint + radii*math.cos((angle-60)*DEGREES), ypoint + radii*math.sin((angle-90)*DEGREES) +20)
	
	self.base.circle6 = self.base:AddChild(Image("images/hud/asa_panel.xml", "circle.tex"))
	self.base.circle6:SetPosition(xpoint + radii*math.cos((240-angle)*DEGREES), ypoint + radii*math.sin((270-angle)*DEGREES) +20)
	
	local circle1 = self.base.circle1
	local circle2 = self.base.circle2
	local circle3 = self.base.circle3
	
	for i = 1, 3 do
		circle1[i] = self.base:AddChild(Image("images/hud/asa_panel.xml", "circle.tex"))
		circle1[i]:SetPosition(xpoint, ypoint - radii*i)
	end
	
	for i = 1, 3 do
		circle2[i] = self.base:AddChild(Image("images/hud/asa_panel.xml", "circle.tex"))
		circle2[i]:SetPosition(xpoint + radii*i*math.cos((180 - angle)*DEGREES), ypoint + radii*i*math.sin((180 - angle)*DEGREES))
	end
	
	for i = 1, 3 do
		circle3[i] = self.base:AddChild(Image("images/hud/asa_panel.xml", "circle.tex"))
		circle3[i]:SetPosition(xpoint + radii*i*math.cos(angle*DEGREES), ypoint + radii*i*math.sin(angle*DEGREES))
	end
	
	--高亮圆底
	
	self.base.bcircle0 = self.base:AddChild(Image("images/hud/asa_panel.xml", "circle_on.tex"))
	self.base.bcircle0:SetPosition(xpoint,ypoint)
	if owner.asa_maxpw:value() == 0 then
		self.base.bcircle0:Hide()
	else
		self.base.bcircle0:Show()
	end
	
	self.base.bcircle1 = {}
	self.base.bcircle2 = {}
	self.base.bcircle3 = {}
	
	self.base.bcircle4 = self.base:AddChild(Image("images/hud/asa_panel.xml", "circle_on.tex"))
	self.base.bcircle4:SetPosition(xpoint, ypoint + 1.3*radii)
	if sks[10] == 0 then
		self.base.bcircle4:Hide()
	else
		self.base.bcircle4:Show()
	end
	
	self.base.bcircle5 = self.base:AddChild(Image("images/hud/asa_panel.xml", "circle_on.tex"))
	self.base.bcircle5:SetPosition(xpoint + radii*math.cos((angle-60)*DEGREES), ypoint + radii*math.sin((angle-90)*DEGREES) +20)
	if sks[11] == 0 then
		self.base.bcircle5:Hide()
	else
		self.base.bcircle5:Show()
	end
	
	self.base.bcircle6 = self.base:AddChild(Image("images/hud/asa_panel.xml", "circle_on.tex"))
	self.base.bcircle6:SetPosition(xpoint + radii*math.cos((240-angle)*DEGREES), ypoint + radii*math.sin((270-angle)*DEGREES) +20)
	if sks[12] == 0 then
		self.base.bcircle6:Hide()
	else
		self.base.bcircle6:Show()
	end
	
	local bcircle1 = self.base.bcircle1
	local bcircle2 = self.base.bcircle2
	local bcircle3 = self.base.bcircle3
	
	for i = 1, 3 do
		bcircle1[i] = self.base:AddChild(Image("images/hud/asa_panel.xml", "circle_on.tex"))
		bcircle1[i]:SetPosition(xpoint, ypoint - radii*i)
		if sks[i] == 0 then
			self.base.bcircle1[i]:Hide()
		else
			self.base.bcircle1[i]:Show()
		end
	end
	
	for i = 1, 3 do
		bcircle2[i] = self.base:AddChild(Image("images/hud/asa_panel.xml", "circle_on.tex"))
		bcircle2[i]:SetPosition(xpoint + radii*i*math.cos((180 - angle)*DEGREES), ypoint + radii*i*math.sin((180 - angle)*DEGREES))
		if sks[i+3] == 0 then
			self.base.bcircle2[i]:Hide()
		else
			self.base.bcircle2[i]:Show()
		end
	end
	
	for i = 1, 3 do
		bcircle3[i] = self.base:AddChild(Image("images/hud/asa_panel.xml", "circle_on.tex"))
		bcircle3[i]:SetPosition(xpoint + radii*i*math.cos(angle*DEGREES), ypoint + radii*i*math.sin(angle*DEGREES))
		if sks[i+6] == 0 then
			self.base.bcircle3[i]:Hide()
		else
			self.base.bcircle3[i]:Show()
		end
	end
	
	--图标
	self.base.skill0 = self.base:AddChild(Image("images/hud/asa_panel.xml", "skill0.tex"))
	self.base.skill0:SetPosition(xpoint,ypoint)
	self.base.skill0:SetScale(0.35)
	
	self.base.skill4 = self.base:AddChild(Image("images/hud/asa_panel.xml", "skill4.tex"))
	self.base.skill4:SetPosition(xpoint, ypoint + 1.3*radii)
	self.base.skill4:SetScale(iscale)
	
	self.base.skill5 = self.base:AddChild(Image("images/hud/asa_panel.xml", "skill5.tex"))
	self.base.skill5:SetPosition(xpoint + radii*math.cos((angle-60)*DEGREES), ypoint + radii*math.sin((angle-90)*DEGREES) +20)
	self.base.skill5:SetScale(iscale)
	
	self.base.skill6 = self.base:AddChild(Image("images/hud/asa_panel.xml", "skill6.tex"))
	self.base.skill6:SetPosition(xpoint + radii*math.cos((240-angle)*DEGREES), ypoint + radii*math.sin((270-angle)*DEGREES) +20)
	self.base.skill6:SetScale(iscale)
	
	self.base.skill1 = {}
	self.base.skill2 = {}
	self.base.skill3 = {}
	
	local skill1 = self.base.skill1
	local skill2 = self.base.skill2
	local skill3 = self.base.skill3
	
	for i = 1, 3 do
		skill1[i] = self.base:AddChild(Image("images/hud/asa_panel.xml", "skill1_"..i..".tex"))
		skill1[i]:SetPosition(xpoint, ypoint - radii*i)
		skill1[i]:SetScale(iscale)
	end
	
	for i = 1, 3 do
		skill2[i] = self.base:AddChild(Image("images/hud/asa_panel.xml", "skill2_"..i..".tex"))
		skill2[i]:SetPosition(xpoint + radii*i*math.cos((180 - angle)*DEGREES), ypoint + radii*i*math.sin((180 - angle)*DEGREES))
		skill2[i]:SetScale(iscale)
	end
	
	for i = 1, 3 do
		skill3[i] = self.base:AddChild(Image("images/hud/asa_panel.xml", "skill3_"..i..".tex"))
		skill3[i]:SetPosition(xpoint + radii*i*math.cos(angle*DEGREES), ypoint + radii*i*math.sin(angle*DEGREES))
		skill3[i]:SetScale(iscale)
	end
	
	--名字
	self.base.name = {}
	local name = self.base.name
	
	for i = 1, 12 do
		if asa_language then
			name[i] = self.base:AddChild(Image("images/hud/asa_panel.xml", "name"..i..".tex"))
		else
			name[i] = self.base:AddChild(Image("images/hud/asa_panel_explain_en.xml", "name_"..i..".tex"))
		end
		-- name[i] = self.base:AddChild(Image("images/hud/asa_panel.xml", "name"..i..".tex"))
		name[i]:SetPosition(250, 190)
		name[i]:SetScale(0.8)
		name[i]:Hide()
	end
	
	--解释文字
	self.base.explain = {}
	local explain = self.base.explain
	
	for i = 1, 12 do
		if asa_language then
			explain[i] = self.base:AddChild(Image("images/hud/asa_panel_explain.xml", "explain"..i..".tex"))
		else
			explain[i] = self.base:AddChild(Image("images/hud/asa_panel_explain_en.xml", "explain_"..i..".tex"))
		end
		explain[i]:SetPosition(250, 50)
		if i == 6 then
			explain[i]:SetScale(0.705)
		else
			explain[i]:SetScale(0.7)
		end
		explain[i]:Hide()
	end
	
	--技能按钮
	local chosen = nil
	
	self.base.btn1 = {}
	self.base.btn2 = {}
	self.base.btn3 = {}
	
	self.base.btn4 = self.base:AddChild(ImageButton("images/hud/asa_panel.xml", "circle.tex"))
	self.base.btn4:SetPosition(xpoint, ypoint + 1.3*radii)
	self.base.btn4.image:SetTint(0,0,0,0.01)
	self.base.btn4:SetOnClick(function()
		for i = 1, 12 do
			name[i]:Hide()
			explain[i]:Hide()
		end
		name[10]:Show()
		explain[10]:Show()
		--选择技能判断执行方案
		chosen = 10
		if sks[10] == 0 then --关闭状态
			if sks[4] == 1 and sks[7] == 1 then --满足前置条件
				if owner.asa_skp:value() >= 1 then --有点数
					self.base.learn1:Show() --可以学习
					self.base.learn2:Hide()
				else
					self.base.learn1:Hide() --没点数则不能
					self.base.learn2:Hide()
				end
			else
				self.base.learn1:Hide() --不满足则不能
				self.base.learn2:Hide()
			end
		else --开启状态
			self.base.learn1:Hide() --可退点
			self.base.learn2:Show()
		end
	end)
	
	self.base.btn5 = self.base:AddChild(ImageButton("images/hud/asa_panel.xml", "circle.tex"))
	self.base.btn5:SetPosition(xpoint + radii*math.cos((angle-60)*DEGREES), ypoint + radii*math.sin((angle-90)*DEGREES) +20)
	self.base.btn5.image:SetTint(0,0,0,0.01)
	self.base.btn5:SetOnClick(function()
		for i = 1, 12 do
			name[i]:Hide()
			explain[i]:Hide()
		end
		name[11]:Show()
		explain[11]:Show()
		chosen = 11
		if sks[11] == 0 then --关闭状态
			if sks[1] == 1 and sks[7] == 1 then --满足前置条件
				if owner.asa_skp:value() >= 1 then --有点数
					self.base.learn1:Show() --可以学习
					self.base.learn2:Hide()
				else
					self.base.learn1:Hide() --没点数则不能
					self.base.learn2:Hide()
				end
			else
				self.base.learn1:Hide() --不满足则不能
				self.base.learn2:Hide()
			end
		else --开启状态
			self.base.learn1:Hide() --可退点
			self.base.learn2:Show()
		end
	end)
	
	self.base.btn6 = self.base:AddChild(ImageButton("images/hud/asa_panel.xml", "circle.tex"))
	self.base.btn6:SetPosition(xpoint + radii*math.cos((240-angle)*DEGREES), ypoint + radii*math.sin((270-angle)*DEGREES) +20)
	self.base.btn6.image:SetTint(0,0,0,0.01)
	self.base.btn6:SetOnClick(function()
		for i = 1, 12 do
			name[i]:Hide()
			explain[i]:Hide()
		end
		name[12]:Show()
		explain[12]:Show()
		chosen = 12
		if sks[12] == 0 then --关闭状态
			if sks[1] == 1 and sks[4] == 1 then --满足前置条件
				if owner.asa_skp:value() >= 1 then --有点数
					self.base.learn1:Show() --可以学习
					self.base.learn2:Hide()
				else
					self.base.learn1:Hide() --没点数则不能
					self.base.learn2:Hide()
				end
			else
				self.base.learn1:Hide() --不满足则不能
				self.base.learn2:Hide()
			end
		else --开启状态
			self.base.learn1:Hide() --可退点
			self.base.learn2:Show()
		end
	end)
	
	local btn1 = self.base.btn1
	local btn2 = self.base.btn2
	local btn3 = self.base.btn3
	
	for i = 1, 3 do
		btn1[i] = self.base:AddChild(ImageButton("images/hud/asa_panel.xml", "circle.tex"))
		btn1[i]:SetPosition(xpoint, ypoint - radii*i)
		btn1[i].image:SetTint(0,0,0,0.01)
		btn1[i]:SetOnClick(function()
			for i = 1, 12 do
				name[i]:Hide()
				explain[i]:Hide()
			end
			name[i]:Show()
			explain[i]:Show()
			--选择技能判断执行方案
			chosen = i
			if i < 3 then
				if i == 1 then
					if sks[i] == 0 then
						if owner.asa_skp:value() >= 1 then
							self.base.learn1:Show()
							self.base.learn2:Hide()
						else
							self.base.learn1:Hide()
							self.base.learn2:Hide()
						end
					else
						self.base.learn1:Hide()
						self.base.learn2:Show()
					end
				else
					if sks[i] == 0 then --关闭状态
						if sks[i-1] == 1 then --满足前置条件
							if owner.asa_skp:value() >= 2 then --有2点数
								self.base.learn1:Show() --可以学习
								self.base.learn2:Hide()
							else
								self.base.learn1:Hide() --没点数则不能
								self.base.learn2:Hide()
							end
						else
							self.base.learn1:Hide() --不满足则不能
							self.base.learn2:Hide()
						end
					else --开启状态
						self.base.learn1:Hide() --可退点
						self.base.learn2:Show()
					end
				end
			else
				if sks[i] == 0 then --关闭状态
					if sks[i-1] == 1 then --满足前置条件
						if owner.asa_skp:value() >= 3 then --有3点数
							self.base.learn1:Show() --可以学习
							self.base.learn2:Hide()
						else
							self.base.learn1:Hide() --没点数则不能
							self.base.learn2:Hide()
						end
					else
						self.base.learn1:Hide() --不满足则不能
						self.base.learn2:Hide()
					end
				else --开启状态
					self.base.learn1:Hide()
					self.base.learn2:Show() --可退点
				end
			end
		end)
	end
	
	for i = 1, 3 do
		btn2[i] = self.base:AddChild(ImageButton("images/hud/asa_panel.xml", "circle.tex"))
		btn2[i]:SetPosition(xpoint + radii*i*math.cos((180 - angle)*DEGREES), ypoint + radii*i*math.sin((180 - angle)*DEGREES))
		btn2[i].image:SetTint(0,0,0,0.01)
		btn2[i]:SetOnClick(function()
			for i = 1, 12 do
				name[i]:Hide()
				explain[i]:Hide()
			end
			local j = i+3
			name[j]:Show()
			explain[j]:Show()
			--选择技能判断执行方案
			chosen = j
			if j < 6 then --不是末位
				if j == 4 then --首位不需要前置
					if sks[j] == 0 then --关闭状态
						if owner.asa_skp:value() >= 1 then --有点就行
							self.base.learn1:Show()
							self.base.learn2:Hide()
						else
							self.base.learn1:Hide() --没点数则不能
							self.base.learn2:Hide()
						end
					else --开启状态
						self.base.learn1:Hide()
						self.base.learn2:Show()--可退点
					end
				else --中位
					if sks[j] == 0 then --关闭状态
						if sks[j-1] == 1 then --满足前置条件
							if owner.asa_skp:value() >= 2 then --有2点数
								self.base.learn1:Show() --可以学习
								self.base.learn2:Hide()
							else
								self.base.learn1:Hide() --没点数则不能
								self.base.learn2:Hide()
							end
						else
							self.base.learn1:Hide() --不满足则不能
							self.base.learn2:Hide()
						end
					else --开启状态
						self.base.learn1:Hide()
						self.base.learn2:Show() --可退点
					end
				end
			else --末位
				if sks[j] == 0 then --关闭状态
					if sks[j-1] == 1 then --满足前置条件
						if owner.asa_skp:value() >= 3 then --有3点数
							self.base.learn1:Show() --可以学习
							self.base.learn2:Hide()
						else
							self.base.learn1:Hide() --没点数则不能
							self.base.learn2:Hide()
						end
					else
						self.base.learn1:Hide() --不满足则不能
						self.base.learn2:Hide()
					end
				else --开启状态
					self.base.learn1:Hide()
					self.base.learn2:Show() --可退点
				end
			end
		end)
	end
	
	for i = 1, 3 do
		btn3[i] = self.base:AddChild(ImageButton("images/hud/asa_panel.xml", "circle.tex"))
		btn3[i]:SetPosition(xpoint + radii*i*math.cos(angle*DEGREES), ypoint + radii*i*math.sin(angle*DEGREES))
		btn3[i].image:SetTint(0,0,0,0.01)
		btn3[i]:SetOnClick(function()
			for i = 1, 12 do
				name[i]:Hide()
				explain[i]:Hide()
			end
			local j = i+6
			name[j]:Show()
			explain[j]:Show()
			--选择技能判断执行方案
			chosen = j
			if j < 9 then --不是末位
				if j == 7 then --首位不需要前置
					if sks[j] == 0 then --关闭状态
						if owner.asa_skp:value() >= 1 then --有点就行
							self.base.learn1:Show()
							self.base.learn2:Hide()
						else
							self.base.learn1:Hide() --没点数则不能
							self.base.learn2:Hide()
						end
					else --开启状态
						self.base.learn1:Hide()
						self.base.learn2:Show()--可退点
					end
				else --中位
					if sks[j] == 0 then --关闭状态
						if sks[j-1] == 1 then --满足前置条件
							if owner.asa_skp:value() >= 2 then --有2点数
								self.base.learn1:Show() --可以学习
								self.base.learn2:Hide()
							else
								self.base.learn1:Hide() --没点数则不能
								self.base.learn2:Hide()
							end
						else
							self.base.learn1:Hide() --不满足则不能
							self.base.learn2:Hide()
						end
					else --开启状态
						self.base.learn1:Hide()
						self.base.learn2:Show() --可退点
					end
				end
			else --末位
				if sks[j] == 0 then --关闭状态
					if sks[j-1] == 1 then --满足前置条件
						if owner.asa_skp:value() >= 3 then --有3点数
							self.base.learn1:Show() --可以学习
							self.base.learn2:Hide()
						else
							self.base.learn1:Hide() --没点数则不能
							self.base.learn2:Hide()
						end
					else
						self.base.learn1:Hide() --不满足则不能
						self.base.learn2:Hide()
					end
				else --开启状态
					self.base.learn1:Hide()
					self.base.learn2:Show() --可退点
				end
			end
		end)
	end
	
	--学习按钮
	self.base.learn0 = self.base:AddChild(Image("images/hud/asa_panel.xml", "learn0.tex"))
	self.base.learn0:SetPosition(295, -200)
	self.base.learn0:SetScale(0.6)
	
	if asa_language then
		self.base.learn1 = self.base:AddChild(ImageButton("images/hud/asa_panel.xml", "learn1.tex"))
	else
		self.base.learn1 = self.base:AddChild(ImageButton("images/hud/asa_panel.xml", "learn1_en.tex"))
	end
	self.base.learn1:SetPosition(295, -200)
	self.base.learn1:SetScale(0.6)
	self.base.learn1:Hide()
	self.base.learn1:SetOnClick(function()
		self.owner.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/equip")
		self.base.learn1:Hide()
		--圆圈高亮
		if chosen >= 10 then
			if chosen == 10 then
				self.base.bcircle4:Show()
			elseif chosen == 11 then
				self.base.bcircle5:Show()
			elseif chosen == 12 then
				self.base.bcircle6:Show()
			end
		elseif chosen >= 7 then
			bcircle3[chosen-6]:Show()
		elseif chosen >= 4 then
			bcircle2[chosen-3]:Show()
		else
			bcircle1[chosen]:Show()
		end

		local amount = owner.asa_skp:value()
		if chosen == 3 or chosen == 6 or chosen == 9 then --终结技
			amount = amount - 3
		elseif chosen == 2 or chosen == 5 or chosen == 8 then --二阶技
			amount = amount - 2
		else
			amount = amount - 1
		end
		sks[chosen] = 1 --终于学到技能，才怪，只是刷新一下本地列表而已
		SendModRPCToServer(MOD_RPC.asakiri.SkillChange, chosen, 1) --这才终于学到技能
		SendModRPCToServer(MOD_RPC.asakiri.SkpChange, amount)

		self.inst:DoTaskInTime(0.2, function()	--延迟
			self.base.learn2:Show() --可退点
		end)
	end)
	
	if asa_language then
		self.base.learn2 = self.base:AddChild(ImageButton("images/hud/asa_panel.xml", "learn2.tex"))
	else
		self.base.learn2 = self.base:AddChild(ImageButton("images/hud/asa_panel.xml", "learn2_en.tex"))
	end
	self.base.learn2:SetPosition(295, -200)
	self.base.learn2:SetScale(0.6)
	self.base.learn2:Hide()
	self.base.learn2:SetOnClick(function()
		self.owner.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/unequip")
		self.base.learn2:Hide()
		--圆圈高亮
		if chosen >= 10 then
			if chosen == 10 then
				self.base.bcircle4:Hide()
			elseif chosen == 11 then
				self.base.bcircle5:Hide()
			elseif chosen == 12 then
				self.base.bcircle6:Hide()
			end
		elseif chosen >= 7 then
			bcircle3[chosen-6]:Hide()
		elseif chosen >= 4 then
			bcircle2[chosen-3]:Hide()
		else
			bcircle1[chosen]:Hide()
		end
		
		sks[chosen] = 0 --终于退掉技能，才怪，只是刷新一下本地列表而已
		SendModRPCToServer(MOD_RPC.asakiri.SkillChange, chosen, 0) --这才终于退掉技能
		
		if chosen == 1 then --本技能已经善后，现在只要给牵连技能擦屁股！
			if sks[chosen+1] == 1 then
				bcircle1[2]:Hide()
				sks[chosen+1] = 0
				SendModRPCToServer(MOD_RPC.asakiri.SkillChange, chosen+1, 0) --这才终于退掉技能
				if sks[chosen+2] == 1 then
					bcircle1[3]:Hide()
					sks[chosen+2] = 0
					SendModRPCToServer(MOD_RPC.asakiri.SkillChange, chosen+2, 0) --这才终于退掉技能
				end
			end
			if sks[11] == 1 then --组合技
				self.base.bcircle5:Hide()
				sks[11] = 0
				SendModRPCToServer(MOD_RPC.asakiri.SkillChange, 11, 0) --这才终于退掉技能
			end
			if sks[12] == 1 then --组合技
				self.base.bcircle6:Hide()
				sks[12] = 0
				SendModRPCToServer(MOD_RPC.asakiri.SkillChange, 12, 0) --这才终于退掉技能
			end
		elseif chosen == 4 then
			if sks[chosen+1] == 1 then
				bcircle2[2]:Hide()
				sks[chosen+1] = 0
				SendModRPCToServer(MOD_RPC.asakiri.SkillChange, chosen+1, 0) --这才终于退掉技能
				if sks[chosen+2] == 1 then
					bcircle2[3]:Hide()
					sks[chosen+2] = 0
					SendModRPCToServer(MOD_RPC.asakiri.SkillChange, chosen+2, 0) --这才终于退掉技能
				end
			end
			if sks[10] == 1 then --组合技
				self.base.bcircle4:Hide()
				sks[10] = 0
				SendModRPCToServer(MOD_RPC.asakiri.SkillChange, 10, 0) --这才终于退掉技能
			end
			if sks[12] == 1 then --组合技
				self.base.bcircle6:Hide()
				sks[12] = 0
				SendModRPCToServer(MOD_RPC.asakiri.SkillChange, 12, 0) --这才终于退掉技能
			end
		elseif chosen == 7 then
			if sks[chosen+1] == 1 then
				bcircle3[2]:Hide()
				sks[chosen+1] = 0
				SendModRPCToServer(MOD_RPC.asakiri.SkillChange, chosen+1, 0) --这才终于退掉技能
				if sks[chosen+2] == 1 then
					bcircle3[3]:Hide()
					sks[chosen+2] = 0
					SendModRPCToServer(MOD_RPC.asakiri.SkillChange, chosen+2, 0) --这才终于退掉技能
				end
			end
			if sks[10] == 1 then --组合技
				self.base.bcircle4:Hide()
				sks[10] = 0
				SendModRPCToServer(MOD_RPC.asakiri.SkillChange, 10, 0) --这才终于退掉技能
			end
			if sks[11] == 1 then --组合技
				self.base.bcircle5:Hide()
				sks[11] = 0
				SendModRPCToServer(MOD_RPC.asakiri.SkillChange, 11, 0) --这才终于退掉技能
			end
		elseif chosen == 2 then
			if sks[chosen+1] == 1 then
				bcircle1[3]:Hide()
				sks[chosen+1] = 0
				SendModRPCToServer(MOD_RPC.asakiri.SkillChange, chosen+1, 0) --这才终于退掉技能
			end
		elseif chosen == 5 then
			if sks[chosen+1] == 1 then
				bcircle2[3]:Hide()
				sks[chosen+1] = 0
				SendModRPCToServer(MOD_RPC.asakiri.SkillChange, chosen+1, 0) --这才终于退掉技能
			end
		elseif chosen == 8 then
			if sks[chosen+1] == 1 then
				bcircle3[3]:Hide()
				sks[chosen+1] = 0
				SendModRPCToServer(MOD_RPC.asakiri.SkillChange, chosen+1, 0) --这才终于退掉技能
			end
		end

		self.inst:DoTaskInTime(0.5, function()
			sks = owner.asa_skills:value()
			sks = json.decode(sks)
			local usedpt = 0
			for i,v in ipairs(sks) do --分情况计算消耗量
				if v == 1 then
					if i == 3 or i == 6 or i == 9 then
						usedpt = usedpt + 3
					elseif i == 2 or i == 5 or i == 8 then
						usedpt = usedpt + 2
					else
						usedpt = usedpt + 1
					end
				end
			end

			local skp = owner.asa_skp:value()
			local amount = owner.asa_maxpw:value() - usedpt
			SendModRPCToServer(MOD_RPC.asakiri.SkillUndoPenalty, amount - skp)
			SendModRPCToServer(MOD_RPC.asakiri.SkpChange, amount)
			self.base.learn1:Show() --可加点
		end)
	end)

	--技能点指示器
	self.tippt = self.base:AddChild(Text(NUMBERFONT, 26, ""))
	self.tippt:SetPosition(360, 232)
	--self.tippt:SetColour(0.2, 0.6, 1, 1)

	self.inst:ListenForEvent("AsaSkP",function()
		self.tippt:SetString("SKP:"..owner.asa_skp:value())
	end, owner)
end)

return AsaPanel