--by:う丶青木
--ps:转载请注明来源
require("constants")
require "util"
local Screen = require "widgets/screen"
local Text = require "widgets/text"
local TextButton = require "widgets/textbutton"
local Widget = require "widgets/widget"
local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local UIAnim = require "widgets/uianim"
---------------------------------------------------------------------------


---------------------------------------------------------------------------
local UICC = {
	DB_W = 130,
	DB_H = 150,
	
	INV_W = 45,
	INV_H = 45,
	
	INVY = -70,
	
	TIME0 = 2,
	TIME1 = 0.7,
	TIME2 = FRAMES * 3,
	TIME3 = 0.7,
	TIME4 = 2,
}
local tbl02 = {}
for i=1, 9 do
	tbl02[i] = string.format("button_%d.tex", i)
end

tbl02[#tbl02 + 1] = "button_01.tex"

local text03 = {
	font		=	DEFAULTFONT,
	size		=	15,
	wordwrap	=	true,
	offset_x	=	0,
	offset_y	=	35,
	colour		=	{1,0,0,1},
	bg		=	true,
	bg_atlas	=	"images/frontend.xml",
	bg_texture	=	"scribble_black.tex",
}

local text01 = {
	font		=	DEFAULTFONT,
	size		=	15,
	wordwrap	=	true,
	offset_x	=	0,
	offset_y	=	35,
	colour		=	{ 198 / 255, 227 / 255, 28 / 255, 1 },
	bg		=	true,
	bg_atlas	=	"images/frontend.xml",
	bg_texture	=	"scribble_black.tex",
}

local text02 = {
	font		=	DEFAULTFONT,
	size		=	15,
	wordwrap	=	true,
	offset_x	=	0,
	offset_y	=	35,
	colour		=	{ 69 / 255, 148 / 255, 186 / 255, 1 },
	bg		=	true,
	bg_atlas	=	"images/frontend.xml",
	bg_texture	=	"scribble_black.tex",
}

local JiTbl = {{},{}}
local PaiXu = {}
local jcc
---------------------------------------------------------推屏介绍
local QM_JIANJIE = Class(Widget, function(self, owner)
	Widget._ctor(self, "QM_JIANJIE")
	self.owner = owner
	self.jieshao = self:AddChild( Image("images/QM_UI10.xml", "ljs_z.tex") )
	self.jian = self:AddChild( ImageButton("images/QM_UI10.xml", "lost_1.tex", nil, "lost_2.tex", "lost_2.tex", "lost_2.tex", {1.5,1.5}) )
	self.jian.focus_scale = {1.6, 1.6, 1.6}
	self.jian.normal_scale = {1.5, 1.5, 1.5}
	self.jian.clickoffset = Vector3(0,0,0)
	self.jian:SetPosition(0, -190, 0)
	self.jian:SetOnClick(function()
		if jcc.suzhu ~= nil then
			if ThePlayer.SoundEmitter then
				ThePlayer.SoundEmitter:PlaySound("dontstarve/wilson/backpack_close")
			end
			local item = jcc.suzhu
			item.shu = nil
			SendModRPCToServer(MOD_RPC.QMRPCSK.SK, "YiWang", PaiXu[item], item.zu)
			item.nei:ScaleTo(1, 0, FRAMES * 10, function()
				item.nei:SetClickable(false)
				item.nei.image:SetTint( 0,0,0,0 )
				item.nei.inst.UITransform:SetScale(1,1,1)
			end)
			jcc:Hide()
			jcc = nil
		end
	end)
end)


---------------------------------------------------------备选菜单
local QM_KUOJIAN = Class(Widget, function(self, owner)
	Widget._ctor(self, "QM_KUOJIAN")
	self.owner = owner
	self.db = self:AddChild( Image("images/QM_UI10.xml", "image_01.tex") )
	self.jian = self.db:AddChild( Image("images/QM_UI10.xml", "image_001.tex") )
	self.jian:SetPosition(0,45,0)
	self.nei = self.db:AddChild( ImageButton())--"images/QM_UI10.xml", "image_02.tex") )
	self.nei.clickoffset = Vector3(0,0,0)
	self.nei.focus_scale = {1, 1, 1}
	self.nei.focus_sound = "dontstarve/HUD/click_mouseover"
	self.cc = self:AddChild( QM_JIANJIE(self.owner) )
	self.cc:SetPosition(130, 420, 0)
	self.cc:Hide()
end)

local function GetCor( inv, self )
	local pt = inv:GetWorldPosition()
	local item
	for i=1, 4 do
		local it01 = JiTbl[self.zu][i]
		if it01.timecd == nil then
			local p1 = it01:GetWorldPosition()
			if distsq( pt, p1 ) <= 200 then
				item = it01
				break
			end
		end
	end
	if item ~= nil and item ~= self then
		if item.shu then
			inv:SetClickable(false)
			inv.inst.UITransform:SetScale(0,0,0)
			inv:ScaleTo(0, 1, FRAMES * 10, function()
				inv:SetClickable(true)
			end)
			inv:SetTextures(item.shu[1], item.shu[2])
			inv:SetPosition(0,0,0)
			
			item.shu, self.shu = self.shu, item.shu
			item.nei:SetTextures(item.shu[1], item.shu[2])
			item.cc.jieshao:SetTexture(item.shu[1], item.shu.txt)
			self.cc.jieshao:SetTexture(self.shu[1], self.shu.txt)
		else
			item.shu, self.shu = self.shu, item.shu
			item.nei:SetTextures(item.shu[1], item.shu[2])
			inv.inst.UITransform:SetScale(0,0,0)
			inv.image:SetTint( 0,0,0,0 )
			inv:SetPosition(0,0,0)
			item.nei.image:SetTint( 1,1,1,1 )
			item.nei.inst.UITransform:SetScale(1,1,1)
			item.cc.jieshao:SetTexture(item.shu[1], item.shu.txt)
			item.nei:ScaleTo(0, 1, FRAMES * 10, function()
				item.nei:SetClickable(true)
			end)
		end
		SendModRPCToServer(MOD_RPC.QMRPCSK.SK, "TAB", PaiXu[self], PaiXu[item], self.zu)
		if item.cdui ~= nil then
			item.cdui:MoveToFront()
		end
	else
		inv:MoveTo(inv:GetPosition(), Point(), FRAMES * 3)
		if inv.cdui ~= nil then
			inv.cdui:MoveToFront()
		end
	end
end

function QM_KUOJIAN:OnControl(control, down)
	if self.nei.focus or ( self.cdui == nil or self.cdui.focus ) then
		if control == CONTROL_ACCEPT and ( jcc == nil or not jcc:IsVisible() ) and self.timecd == nil and self.shu then
			TheFrontEnd:LockFocus(true)
			self:MoveToFront()
			self.nei:MoveToFront()
			if down then
				local pos = TheInput:GetScreenPosition()
				local pos1 = self.nei:GetWorldPosition()
				local pos2 = self.nei:GetPosition()
				self.nei.offpos = pos - pos1
				if self.nei.followhandler == nil then
					TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_object")
					self.nei.followhandler = TheInput:AddMoveHandler(function(x, y)
						local scr_w, scr_h = TheSim:GetScreenSize()
						local x,y = math.clamp(x, 32, scr_w - 32), math.clamp(y, 32, scr_h - 32)
						local scale = self.nei:GetScale()
						local pos4 = self.nei:GetPosition()
						local pos1 = self.nei:GetWorldPosition()
						local x1,y1 = (x - pos1.x) * ( 2 - scale.x), (y - pos1.y) * ( 2 - scale.x)
						self.nei:SetPosition(x1 + pos4.x - self.nei.offpos.x, y1 + pos4.y - self.nei.offpos.y)
					end)
				end
			else
				if self.nei.followhandler ~= nil then
					TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_object")
					self.nei.followhandler:Remove()
					self.nei.followhandler = nil
				end
				TheFrontEnd:LockFocus(false)
				GetCor( self.nei, self )
			end
			return true
		end
		if control == CONTROL_SECONDARY and not down and self.shu ~= nil then
			if jcc == nil then
				if ThePlayer.SoundEmitter then
					ThePlayer.SoundEmitter:PlaySound("dontstarve/wilson/backpack_open")
				end
				jcc = self.cc
				jcc.suzhu = self
				jcc:Show()
				return true
			end
			if jcc ~= nil then
				if jcc:IsVisible() then
					if ThePlayer.SoundEmitter then
						ThePlayer.SoundEmitter:PlaySound("dontstarve/wilson/backpack_close")
					end
					jcc:Hide()
				else
					if ThePlayer.SoundEmitter then
						ThePlayer.SoundEmitter:PlaySound("dontstarve/wilson/backpack_open")
					end
					jcc = self.cc
					jcc.suzhu = self
					jcc:Show()
				end
			end
			return true
		end
	end
	if QM_KUOJIAN._base.OnControl(self, control, down) then
		return true
	end
end

function QM_KUOJIAN:DoCD(time)
	if time and self.cdui then
		self.timecd = 0
		self.timemax = time
		self.cdui:MoveToFront()
		self:StartUpdating()
	elseif self.cdui ~= nil then
		self.cdui:GetAnimState():PlayAnimation("finash")
	end
end

function QM_KUOJIAN:OnUpdate(dt)
	if self.cdui ~= nil and self.timecd and self.timecd < self.timemax then
		self.cdui:GetAnimState():SetPercent("do", self.timecd / self.timemax)
		self.timecd = self.timecd + dt
	else
		self.timecd = nil
		self.timemax = nil
		self.cdui:GetAnimState():PlayAnimation("finash")
		self:StopUpdating()
	end
end


function QM_KUOJIAN:SetSk(num, bool, cd)
	if not QMSkTable then
		return
	end
	if jcc ~= nil then
		jcc:Hide()
		jcc = nil
	end
	--TheFrontEnd:GetSound():PlaySound("dontstarve/wilson/backpack_close")
	local tbl = QMSkTable[bool and 2 or 1]
	if num and num > 0 and tbl and tbl[num] then
		TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/get_gold")
		self.shu = { tbl[num].isghosskill and "images/ghostskillui.xml" or "images/QM_UI10.xml", tbl[num].tex .. ".tex", key = tbl[num].key, txt = tbl[num].txt .. ".tex" }
		self.cc.jieshao:SetTexture(tbl[num].isghosskill and "images/ghostskillui.xml" or "images/QM_UI10.xml", self.shu.txt)
		self.nei:SetTextures(self.shu[1], self.shu[2])
		self:DoCD()
		self.nei.inst.UITransform:SetScale(1,1,1)
		self.nei.image:SetTint( 1,1,1,1 )
		self.nei:SetClickable(true)
		self:SetClickable(true)
	else
		self.shu = nil
		self.nei:ScaleTo(1, 0, FRAMES * 10, function()
			self.nei:SetClickable(false)
			self.nei.image:SetTint( 0,0,0,0 )
			self.nei.inst.UITransform:SetScale(1,1,1)
		end)
	end
end

function QM_KUOJIAN:GetData()
	if self.shu then
		return self.shu.key
	end
end
----------------------------------------------------------左下小图标
local QM_GDCS = Class(Widget, function(self, owner, AllCao, AllBCao)
	Widget._ctor(self, "QM_GDCS")
	self.owner = owner
	self.db = self:AddChild( ImageButton("images/QM_UI10.xml", "button_01.tex") )
	self.db02 = self:AddChild( ImageButton("images/QM_UI10.xml", "button_03.tex") )
	self.db02:SetHoverText("收纳", text03)
	self.db:SetHoverText("显示技能位", text01)
	self.db.clickoffset = Vector3(0,0,0)
	self.db02.clickoffset = Vector3(0,0,0)

	local w, h = self.db:GetSize()

	self:SetVAnchor(2)
	self:SetHAnchor(1)
	self:SetPosition(w * 0.5 + 30 - 10, h * 0.5 - 10)
	self.MAXW = w
	self.MAXH = h
	self.zhudong = {}
	self.beidong = {}
	self.POS = {}
	self.TblNum = 1
	self.cd = 0
	
	self.db:SetOnClick(function()
		local p1 = self.db:GetPosition()
		local pt = Point(p1.x, 100, 0)
		if jcc then
			jcc:Hide()
		end
		self.db:SetClickable(false)
		self.db02:SetClickable(false)
		if not self.kai then
			TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/craft_open")
			self.zhu = true
			self.db:MoveTo(p1, pt, UICC.TIME1, function()
				self.db:SetHoverText("切换至\n被动技能", text01)
				self.db:MoveToBack()
			end)
			for i,v in ipairs(self.zhudong) do
				self.inst:DoTaskInTime(( i - 1 ) * UICC.TIME2, function()
					if i == 4 then
						self.db02:Show()
						self.db02:MoveTo(Point(self.POS[4].x, UICC.INVY, 0), Point(self.POS[4].x, 100, 0), UICC.TIME1)
					end
					v:MoveTo(self.POS[i], Point(self.POS[i].x, 30, 0), UICC.TIME1, function()
						if i == 4 then
							self.db:SetClickable(true)
							self.db02:SetClickable(true)
							self.db02:Show()
							self.db02:MoveToBack()
						end
					end)
				end)
			end
		else

			self.db:MoveTo(pt, Point(pt.x, UICC.INVY, 0), UICC.TIME1, function()
				if not self.zhu then
					self.db:SetTextures("images/QM_UI10.xml", "button_01.tex")
					self.db:SetHoverText("切换至\n被动技能", text01)
				else
					self.db:SetTextures("images/QM_UI10.xml", "button_02.tex")
					self.db:SetHoverText("切换至\n主动技能", text02)
				end
				self.db:MoveTo(Point(pt.x, UICC.INVY, 0), pt, UICC.TIME1, function()
					self.db:MoveToBack()
				end)
			end)
			TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/craft_open")
			for i=1, 4 do
				local tc1, tc2 = self.zhudong[i], self.beidong[i]
				self.inst:DoTaskInTime(( i - 1 ) * UICC.TIME2, function()
					if i == 4 then
						self.db02:MoveTo(self.db02:GetPosition(), Point(self.POS[4].x, UICC.INVY, 0), UICC.TIME1, function()
							self.db02:MoveTo(Point(self.POS[4].x, UICC.INVY, 0), Point(self.POS[4].x, 100, 0), UICC.TIME1, function()
								self.db:MoveToBack()
							end)
						end)
					end
					tc1:MoveTo(tc1:GetPosition(), self.POS[i], UICC.TIME1, function()
						if self.zhu then
							tc2:MoveTo(self.POS[i], Point(self.POS[i].x, 30, 0), UICC.TIME1, function()
								if i == 4 then
									self.db:SetClickable(true)
									self.db02:SetClickable(true)
									self.db02:Show()
									self.zhu = not self.zhu
								end
							end)
						end
					end)
					
					tc2:MoveTo(tc2:GetPosition(), self.POS[i], UICC.TIME1, function()
						if not self.zhu then
							tc1:MoveTo(self.POS[i], Point(self.POS[i].x, 30, 0), UICC.TIME1, function()
								if i == 4 then
									self.db:SetClickable(true)
									self.db02:SetClickable(true)
									self.db02:Show()
									self.zhu = not self.zhu
								end
							end)
						end
					end)
					
				end)
			end

		end
		
		self.kai = true
	end)

	for i=1, 4 do
		local inv01 = self:AddChild( QM_KUOJIAN( self.owner ) )
		local inv02 = self:AddChild( QM_KUOJIAN( self.owner ) )
		inv01.cdui = inv01:AddChild( UIAnim() )
		inv01.cdui:SetClickable(true)
		inv01.cdui:GetAnimState():SetBuild("qm_cdui")
		inv01.cdui:GetAnimState():SetBank("qm_skcd")
		inv01.cdui:GetAnimState():PlayAnimation("finash")
		inv02.db:SetTexture("images/QM_UI10.xml", "image_02.tex")
		self.zhudong[i] = inv01
		self.beidong[i] = inv02
		local w0,h0 = inv01.db:GetSize()
		local mow = w * 0.5 + 30 - w0 * 0.5 + ( i - 1 ) * 110
		inv01:SetPosition(mow, -h0)
		inv02:SetPosition(mow, -h0)
		inv01.jian:SetTexture("images/QM_UI10.xml", string.format("bu%02d.tex", i))
		inv02.jian:SetTexture("images/QM_UI10.xml", string.format("bu%02d.tex", i))
		self.POS[i] = Point(mow, -h0, 0 )
		JiTbl[1][i] = inv01
		JiTbl[2][i] = inv02
		inv01.zu = 1
		inv02.zu = 2
		if inv01.shu == nil then
			inv01.nei.image:SetTint( 0,0,0,0 )
		end
		if inv02.shu == nil then
			inv02.nei.image:SetTint( 0,0,0,0 )
		end
		AllCao[i] = inv01
		AllBCao[i] = inv02
		PaiXu[inv01] = i
		PaiXu[inv02] = i
	end
	
	self.db02:SetPosition(self.POS[4].x, 100)
	self.db02:Hide()
	
	self.db02:SetOnClick(function()
		if jcc then
			jcc:Hide()
		end
		self.db:SetClickable(false)
		self.kai = false
		TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/craft_close")
		self.db02:MoveTo(self.db02:GetPosition(), Point(self.POS[4].x, UICC.INVY, 0), UICC.TIME1)
		
		local pt = self.db:GetPosition()
		local num = 0
		for i=4, 1, -1 do
			local tc1, tc2 = self.zhudong[i], self.beidong[i]
			self.inst:DoTaskInTime( num * UICC.TIME2, function()
				tc1:MoveTo(tc1:GetPosition(), self.POS[i], UICC.TIME1)
				tc2:MoveTo(tc2:GetPosition(), self.POS[i], UICC.TIME1)
				if i == 1 then
					self.db:MoveTo(pt, Point(pt.x, 0, 0), UICC.TIME1 * UICC.TIME3, function()
						self.db:SetHoverText("显示技能位", text01)
						self.TblNum = 1
						self:StartUpdating()
					end)
				end
			end)
			num = num + 1	
		end

	end)
	
	self:SetScale(0.7,0.7,0.7)
end)


function QM_GDCS:OnUpdate(dt)
	if self.zhu then
		self.TblNum = 1
		self.cd = 0
		self.zhu = false
		self.db:SetClickable(true)
		self:StopUpdating()
		return
	end
	self.cd = self.cd + dt
	if self.cd >= 0.1 then
		self.db:SetTextures("images/QM_UI10.xml", tbl02[self.TblNum])
		self.TblNum = self.TblNum + 1
		self.cd = 0
		if self.TblNum >= 9 then
			self.TblNum = 1
			self.zhu = true
		end
	end
end

------------------------------------------------------------------------
return {
	QM_GDCS = QM_GDCS,
}
