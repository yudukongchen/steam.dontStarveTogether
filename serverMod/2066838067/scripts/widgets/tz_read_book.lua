
local Text = require "widgets/text"
local TextButton = require "widgets/textbutton"
local Widget = require "widgets/widget"
local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"

local function istbl(val) return type(val) == 'table' end
local function isstr(val) return type(val) == 'string' end
local function isnum(val) return type(val) == 'number' end
-------------------------------------------------------
local ASS = {
	MaxW = 700,
	MaxH = 400,
	DIBU = { "images/global.xml", "square.tex" },					-- 内框底布
	DIBU_COLOR = { 175 / 255, 188 / 255, 157 / 255, 0.01 },						-- 内框底布颜色
	HUABU = { "images/maze.xml", "grass_1.tex" },		-- 滑动底布

	MOTEXT_COLOR = { 0,0,0,1 },							-- 默认字体颜色 【测试用】

	List_COLOR = {										--预制一部分背景底布的调色
		{175 / 255, 188 / 255, 157 / 255, 0.5},
		{148 / 255, 235 / 255, 148 / 255, 0.5},
		{143 / 255, 142 / 255, 153 / 255, 0.5},
		{241 / 255, 238 / 255, 195 / 255, 0.5},
		{96 / 255, 143 / 255, 184 / 255, 0.5},
		{184 / 255, 84 / 255, 25 / 255, 0.5},
	},

	TiaoSe01 = { "images/global.xml", "square.tex" },

	ZiHao = {40, 35, 30, 25, 20},								--预制几种字号，字体大小

	MuLu_DIBU = { "images/global.xml", "square.tex" },			-- 目录栏的底框
	MuLu_AN = { "images/global_redux.xml", "button_carny_long_normal.tex" },			-- 目录栏内的按钮图样
}

local function SetButtonSize(self, w, h)
	self:ForceImageSize(w,h)
	self.focus_scale = nil
	self.normal_scale = nil
	self.clickoffset = Vector3(0,0,0)
	return self
end

local ZhangStr = "第%d章"

----------------------------- 关联类 ----------------------------
local MuLu = Class(Widget, function(self, maxnum, suzhu)					-- 目录 类
	Widget._ctor(self, "MuLu")
	
	local anw, anh = 120, 70									-- 设置目录栏内的按钮大小尺寸， 目录栏底框也会相应换算加 宽 加 长
	self.SuZhu = suzhu
	self.DIBU = self:AddChild(Image( unpack(ASS.MuLu_DIBU) ))
	self.DIBU:SetSize(anw + 20, ASS.MaxH)
	self.DIBU:SetTint( unpack({ 1,1,1,1 }) )

	self.index = 1
	self.SizeU = 7
	self.Len = maxnum
	self.ALLMULU = {}
	
	local anw, anh = 120, 70
	for i=0, self.SizeU - 1 do
		local bun = self:AddChild( ImageButton( unpack(ASS.MuLu_AN) ) )
		SetButtonSize(bun, anw, anh)
		bun:SetText(ZhangStr:format(i+1))
		self.ALLMULU[i+1] = bun
		local y = ASS.MaxH * 0.5 - anh * 0.5 - i * anh - 10 - ( i * 14 )
		bun:SetPosition(0, y)
		bun.Index = i + 1
		bun:SetOnClick(function() self.SuZhu:SetCode( bun.Index ) end)
	end
end)

function MuLu:SetCode(num)
	self.index = math.clamp( math.floor( num or 1 ), 1, self.Len - self.SizeU + 1)
	for i=1, self.SizeU do
		local bun = self.ALLMULU[i]
		bun.Index = self.index + ( i - 1 )
		bun:SetText(ZhangStr:format( bun.Index ))
	end
end

function MuLu:OnControl(control, down, force)
	if MuLu._base.OnControl(self, control, down) then return true end
	if down and (self.focus or force) then
		local old_index = self.index
		if control == CONTROL_SCROLLBACK then
			self.index = math.clamp( self.index - 1, 1, self.Len - self.SizeU + 1)
		elseif control == CONTROL_SCROLLFWD then
			self.index = math.clamp( self.index + 1, 1, self.Len - self.SizeU + 1)
		end
		if self.index ~= old_index then
			self:SetCode(self.index)
		end
	end
end

----------*********************************
local HuanKuai = Class(Widget, function(self, suzhu, maxw, maxh)		-- 隐型的滑动屏
	Widget._ctor(self, "HuanKuai")
	self.SuZhu = suzhu
	self.DIBU = self:AddChild(Image( unpack(ASS.DIBU) ))
	self.DIBU:SetSize(maxw, maxh)
	self.DIBU:SetTint( 0,0,0,0 )
	self.pt = nil
	self.oldtime = 0
end)

function HuanKuai:OnControl(control, down, force)
	if down and (self.focus or force) then
		local num = 0
		if control == CONTROL_SCROLLBACK then
			num = -200
		elseif control == CONTROL_SCROLLFWD then
			num = 200
		end
		if num ~= 0 then
			self.SuZhu:HuaDong( num )
			return true
		end
	end
	if control == CONTROL_ACCEPT then
		if down then
			if self.SuZhu.An == nil then
				self.SuZhu.An = true
				self.oldpos = TheInput:GetScreenPosition()
				self.offpos = self.oldpos
				self.oldtime = GetTime()
				self.SuZhu:StopUpdating()
				self:StartUpdating()
			end
		else
			self:StopUpdating()
			self.SuZhu.An = nil
			if GetTime() - self.oldtime <= 0.35 then
				local num = math.clamp(GetTime() - self.oldtime, 0.1, 1)
				local newpos = TheInput:GetScreenPosition()
				self.SuZhu:HuaDong( ( newpos.y - self.offpos.y ) / ( num * 2 ) )
			end
			self.oldpos = nil
		end
	end
end

function HuanKuai:OnLoseFocus()
	HuanKuai._base.OnLoseFocus(self)
	self:OnControl(CONTROL_ACCEPT, false)
end

function HuanKuai:OnUpdate( dt )
	if self.oldpos then
		local newpos = TheInput:GetScreenPosition()
		if self.oldpos and newpos.y ~= self.oldpos.y then
			self.SuZhu:HuaDong( ( newpos.y - self.oldpos.y ), true )
			self.oldpos = newpos
		end
	end
end
-----------------------------------------------------------------
local QM_XiaoShuo = Class(Widget, function(self, xiaoshuo)
	Widget._ctor(self, "QM_XiaoShuo")
	self.XiaoShuo = xiaoshuo
	self.Xindex = 0
	--self:SetVAnchor(0)
	--self:SetHAnchor(0)
	self.From = self:AddChild(Widget( "From" ))
	self.From:MoveToBack()
	self.FormEnt = self.From:AddChild(Widget( "FormEnt" ))
	
	--self.FormEnt:SetVAnchor(0)
	--self.FormEnt:SetHAnchor(0)
	self:SetScale(0.8)
	self:SetPosition(80, 70)

	--新加背景
	self.beijing = self:AddChild(Image("images/taizhen_xiaoshuoui.xml", "image-2.tex"))
	self.beijing:SetSize(846, 524)
	self.beijing:SetTint( unpack({ 1,1,1,1 }) )
	self.beijing:MoveToBack()
	self.beijing:SetPosition(0, -4)
	
	self.ALLWEN = {}				-- 所有文章的UI实体缓存表
	
	self.DIBU = self.From:AddChild(Image( unpack(ASS.DIBU) ))
	self.DIBU:SetSize(ASS.MaxW, ASS.MaxH)
	self.DIBU:SetTint( unpack(ASS.DIBU_COLOR) )
	self.basecolour = 1
	self.From:SetScissor(-ASS.MaxW * .5, -ASS.MaxH * .5, ASS.MaxW, ASS.MaxH)
	
	self.FontSize = 35
	
	self.JianGe = 10
	self.UVGE = 20
	self.OnUpTime = 0
	
	self.MAXW = ASS.MaxW - self.UVGE * 2
	self.Min_MAXH = ASS.MaxH * 0.5
	self.Cm = 0
	self.Max_MAXH = 0
	
	self.FormEnt:MoveToFront()
	
	self.HuaBan = self.From:AddChild(HuanKuai( self, ASS.MaxW, ASS.MaxH ))

	self:Int()
	self:SetCode( 1 )
end)

function QM_XiaoShuo:Int()		-- 创建一些附属的按钮 【背景调色】 【字体尺寸】
	self.TiaoSe_T = {}
	local ts_size = 32
	for i,v in ipairs(ASS.List_COLOR) do
		local x = ts_size * 0.5 - ( i - 1 ) * ts_size - ( i - 1 ) * 10
		local buan = self:AddChild( ImageButton( unpack(ASS.TiaoSe01) ) )
		SetButtonSize(buan, ts_size, ts_size)
		buan:SetImageNormalColour(v)
		buan:SetImageFocusColour(v)
		buan:SetPosition(ASS.MaxW * 0.5 - 32 + x -30, ASS.MaxH * 0.5 + 30)
		buan:SetOnClick(function() 
			if i == 1 then
				self.DIBU:SetTint( unpack(ASS.DIBU_COLOR) ) 
			else
				self.DIBU:SetTint( unpack(v) ) 
			end
			self.basecolour = i
			TheSim:SetPersistentString("tzbookset",string.format("return Vector3(%f,%f,%f)",self.FontSize,self.basecolour,0),false)
		end)
		self.TiaoSe_T[i] = buan
	end
	
	for i,v in ipairs(ASS.ZiHao) do			-- 字号
		local x = ts_size * 0.5 - ( i - 1 ) * ts_size - ( i - 1 ) * 10
		local buan = self:AddChild( TextButton( "字" ) )
		buan:SetTextSize(v)
		buan:SetColour({148 / 255, 235 / 255, 148 / 255, 1})
		buan:SetPosition(ASS.MaxW * 0.5 - 32 + x -430, ASS.MaxH * 0.5 + 30)
		buan:SetOnClick(function()
			self.FontSize = v
			TheSim:SetPersistentString("tzbookset",string.format("return Vector3(%f,%f,%f)",self.FontSize,self.basecolour,0),false)
			self:SetCode( self.Xindex )
		end)
		buan:SetText("字")
	end
	
	-- 目录
	self.MuLu = self:AddChild(MuLu(#self.XiaoShuo, self))
	self.MuLu:SetPosition(-ASS.MaxW * 0.5 - 150, 0)
	self.MuLu:Hide()
end

function QM_XiaoShuo:LoadSet()
	TheSim:GetPersistentString("tzbookset",function(load_success, str) 
		if load_success and str then
			local fn = loadstring(str)
            if type(fn) == "function" then
                local pos = fn()
				if pos.x then
					self.FontSize = tonumber(pos.x)
					self:SetCode( self.Xindex or 1)
				end
				if pos.y then
					local i = tonumber(pos.y)
					if i == 1 then
						self.DIBU:SetTint( unpack(ASS.DIBU_COLOR) ) 
					else
						self.DIBU:SetTint( unpack(ASS.List_COLOR[i]) ) 
					end
					self.basecolour = i
				end
            end
		end
	end)
end

--[[
function QM_XiaoShuo:OnGainFocus()
	QM_XiaoShuo._base.OnGainFocus(self)
	TheCamera:SetControllable(false)
end

function QM_XiaoShuo:OnLoseFocus()
	QM_XiaoShuo._base.OnLoseFocus(self)
	TheCamera:SetControllable(true)
end]]

function QM_XiaoShuo:NextStr( op )
	op = op or 1
	self.Xindex = self.Xindex + ( op or 1 )
	if self.Xindex > #self.XiaoShuo then
		self.Xindex = #self.XiaoShuo
		return
	end
	if self.XiaoShuo[self.Xindex] == nil then
		self.Xindex = 1
	end
	
	local StrT = self.XiaoShuo[self.Xindex]
	
	if StrT and next(StrT) then
		if self.ALLWEN[self.Xindex] then
			return
		end
		local ent = self.FormEnt:AddChild(Widget( "ent" ))
		if op > 0 then
			ent:SetPosition(0, -self.Max_MAXH)
		end
		ent.ALLTEXT = {}
		ent.MAXH = self.JianGe
		for i,v in ipairs(StrT) do
			local str = v
			while str and #str > 0 do
				local newstr = str
				local len = -1
				local text = ent:AddChild(Text(NEWFONT, self.FontSize, tostring(newstr), ASS.MOTEXT_COLOR))
				while text.inst.TextWidget:GetRegionSize() > self.MAXW do
					len = len - 1
					newstr = str:utf8sub(1, len)
					text.inst.TextWidget:SetString(newstr)
				end
				table.insert(ent.ALLTEXT, text)
				local w, h = text.inst.TextWidget:GetRegionSize()
				text:SetHAlign(ANCHOR_LEFT)
				text:SetRegionSize( self.MAXW, h )
				text:SetPosition(0, -ent.MAXH - h * 0.5, 1)
				ent.MAXH = ent.MAXH + h
				if str ~= newstr then
					str = str:utf8sub(len + 1, -1)
				else
					str = nil
				end
			end
			ent.MAXH = ent.MAXH + self.JianGe
		end
		
		if op >= 0 then
			self.Max_MAXH = self.Max_MAXH + ent.MAXH
		elseif op < 0 then
			ent:SetPosition(0, -self.Min_MAXH + ent.MAXH + ASS.MaxH * 0.5)
			self.Min_MAXH = self.Min_MAXH - ent.MAXH
		end
		
		--local xx = ent:AddChild(Image( unpack(ASS.DIBU) )) --章节分界线
		--xx:SetSize(ASS.MaxW, 10)
		--xx:SetPosition(0, -ent.MAXH)
		--xx:SetTint( 255,0,0, 1 )
		--xx:MoveToBack()
		
		self.ALLWEN[self.Xindex] = ent

		for k,v in pairs(self.ALLWEN) do
			if math.abs( self.Xindex - k ) > 2 then
				if k < self.Xindex then
					self.Min_MAXH = self.Min_MAXH + self.ALLWEN[k].MAXH
				else
					self.Max_MAXH = self.Max_MAXH - self.ALLWEN[k].MAXH
				end
				self.ALLWEN[k]:Kill()
				self.ALLWEN[k] = nil
			end
		end

		self.MuLu:SetCode(self.Xindex - math.floor( self.MuLu.SizeU * 0.5 ))

		self.From:SetScissor(-ASS.MaxW * .5, -ASS.MaxH * .5, ASS.MaxW, ASS.MaxH)
	end
end

function QM_XiaoShuo:SetCode( num )		-- 设置章节
	self:StopUpdating()
	num = num or -100
	for k,v in pairs(self.ALLWEN) do
		self.ALLWEN[k]:Kill()
		self.ALLWEN[k] = nil
	end

	self.Xindex = math.clamp(math.floor(num), 1, #self.XiaoShuo)
	self.Min_MAXH = ASS.MaxH * 0.5
	self.Max_MAXH = 0
	self:NextStr( 0 )
	self.FormEnt:SetPosition(0, self.Min_MAXH)
end


function QM_XiaoShuo:HuaDong( dt, bool )		-- 滑动公式
	dt = dt or 1
	if self.Xindex then
		self.OnUpTime = 1
		self.Cm = dt
		if not self.An and not bool and dt ~= 0 then
			self:StartUpdating()
		elseif bool and dt ~= 0 then
			self:UpYe( dt )
		end
	end
end

-- DEBUG
-- print( ThePlayer.HUD.controls.XiaoShuo.FormEnt:GetPosition() )
-- ThePlayer.HUD.controls.XiaoShuo:SetCode( 100 )
-- ThePlayer.HUD.controls.XiaoShuo:Hide()

function QM_XiaoShuo:UpYe(dt)
	local x,y = self.FormEnt:GetPosition():Get()
	self.FormEnt:SetPosition(0, y + dt)
	x,y = self.FormEnt:GetPosition():Get()
	local downY = self.Max_MAXH - ASS.MaxH * 0.5
	if y < self.Min_MAXH then
		self:NextStr( -1 )
		if y < self.Min_MAXH then
			self:StopUpdating()
			self.FormEnt:SetPosition(0, self.Min_MAXH)
		end
	elseif y > downY then
		self:NextStr( 1 )
		if y > downY then
			self:StopUpdating()
			self.FormEnt:SetPosition(0, downY)
		end
	end
end


function QM_XiaoShuo:OnUpdate( dt )
	if not self.An then
		local z = self.Cm * 0.05
		self:UpYe( z )
		self.Cm = self.Cm - z
	end
	if self.An or math.abs(self.Cm) < 0.05 then
		self:UpYe( self.Cm )
		self.Cm = 0
		self:StopUpdating()
	end
end









return QM_XiaoShuo