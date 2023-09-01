require("constants")
local Text = require "widgets/text"
local Widget = require "widgets/widget"
local UIAnim = require "widgets/uianim"
local TEMPLATES = require "widgets/redux/templates"
local ImageButton = require "widgets/imagebutton"
local Image = require "widgets/image"
local Spinner = require "widgets/spinner"
local bookutil = require("widgets/tz_read_book")

local xiaoshuomulu = {
    {
        name = "日常的魔法原理前传\n—太真篇—",
        author = "阿平君",
        image = "bookback1.tex",
        authorui = "tz_writer_apingjun",
        zj = {
            {
                zjname = "第一章",
                text = require("tz_books/qianzhuan1"),
            },
            {
                zjname = "第二章",
                text = require("tz_books/qianzhuan2"),
            },
            {
                zjname = "第三章",
                text = require("tz_books/qianzhuan3"),
            },
        },
    },
    {
        name = "日常的魔法原理",
        author = "阿平君",
        image = "bookback1.tex",
        authorui = "tz_writer_apingjun",
    },
    {
        name = "最强暗影魔法师竟是\n我宠物",
        author = "阿平从小就很可爱",
        authorui = "tz_writer_apcxjhka",
    },
    {
        name = "暗灵",
        author = "文",
        authorui = "tz_writer_wen",
    },
    {
        name = "寄存于笔的思念",
        author = "这个是德",
        authorui = "tz_writer_zgsd",
    },
    {
        name = "太真:新王朝",
        author = "Mr.Eureka",
        authorui = "tz_writer_mr.eureka",
    },
    {
        name = "闲庭信步集",
        author = "Royian",
        authorui = "tz_writer_royian",
    },
}
--2日常的魔法原理
xiaoshuomulu[2].zj = {}
xiaoshuomulu[2].zj[1] = 
{
    zjname = "序章",
    text = require("tz_books/richangmofa_xu"),
}
for k = 1,19 do 
    xiaoshuomulu[2].zj[k+1] = 
    {
        zjname = "第"..k.."章",
         text = require("tz_books/richangmofa"..k),
    }
end

--3 魔法师
xiaoshuomulu[3].zj = {}
for k = 1,7 do 
    xiaoshuomulu[3].zj[k] = 
    {
        zjname = "第"..k.."章",
         text = require("tz_books/mofashi"..k),
    }
end
--4 暗灵
xiaoshuomulu[4].zj = {}
for k = 1,26 do 
    xiaoshuomulu[4].zj[k] = 
    {
        zjname = "第"..k.."章",
         text = require("tz_books/anling"..k),
    }
end
xiaoshuomulu[4].zj[27] = 
{
    zjname = "番外1",
     text = require("tz_books/anlingfanwai1"),
}
xiaoshuomulu[4].zj[28] = 
{
    zjname = "番外2",
     text = require("tz_books/anlingfanwai2"),
}
---==============
--5 寄存于笔的思念
xiaoshuomulu[5].zj = {}
xiaoshuomulu[5].zj[1] = {
    zjname = "前言",
    text = require("tz_books/sinian_qian"),
}
xiaoshuomulu[5].zj[2] = {
    zjname = "序章",
    text = require("tz_books/sinian_xu"),
}
for k = 1,9 do 
    xiaoshuomulu[5].zj[k+2] = 
    {
        zjname = "第"..k.."章",
         text = require("tz_books/sinian"..k),
    }
end
--6 太真:新王朝
xiaoshuomulu[6].zj = {}
xiaoshuomulu[6].zj[1] = {
    zjname = "引子",
    text = require("tz_books/wangchao_yin"),
}
xiaoshuomulu[6].zj[2] = {
    zjname = "序章",
    text = require("tz_books/wangchao_xu"),
}
for k = 1,1 do 
    xiaoshuomulu[6].zj[k+2] = 
    {
        zjname = "第"..k.."章",
         text = require("tz_books/wangchao"..k),
    }
end
----==
--7 朝闲庭信步集
xiaoshuomulu[7].zj = {}
xiaoshuomulu[7].zj[1] = {
    zjname = "序章",
    text = require("tz_books/xianting_xu"),
}
for k = 1,2 do 
    xiaoshuomulu[7].zj[k+1] = 
    {
        zjname = "第"..k.."章",
         text = require("tz_books/xianting"..k),
    }
end

local taizhen_xiaoshuo = Class(Widget, function(self, owner)
    Widget._ctor(self, "taizhen_xiaoshuo")
    self.owner = owner

	self.root = self:AddChild(Widget("root"))
	self.root:SetScaleMode(SCALEMODE_PROPORTIONAL)
    self.root:SetHAnchor(ANCHOR_MIDDLE)
    self.root:SetVAnchor(ANCHOR_MIDDLE)
	self.root:SetPosition(0, 0)

    self.mulubg =  self.root:AddChild(Image("images/taizhen_xiaoshuoui.xml", "image-0.tex"))
    self.mulubg:SetPosition(-400, 80)
    self.mulubg:SetScale(0.6)

    self.currentmuluname = nil--xiaoshuomulu[1].name
    self.mulu = self.root:AddChild(self:CreatMuLu(xiaoshuomulu))
    self.mulu:SetPosition(-390, 74)

    self.zhangjie = self.root:AddChild(self:CreatZhangJie())
    self.zhangjie:SetPosition(-280, 74)
    self.zhangjie:MoveToBack()

    --self.zhangjie:SetItemsData(xiaoshuomulu[1].zj or {})

	local scr_w, scr_h = TheSim:GetScreenSize()
	self.out_pos = Vector3(0, scr_h, 0)
	self.in_pos = Vector3(0, 0, 0)

    self.close_button = self.root:AddChild(ImageButton("images/taizhen_xiaoshuoui.xml", "image-4.tex"))
    self.close_button.focus_scale = {1.05, 1.05, 1.05}

    self.close_button:SetPosition(-310, 240)
    self.close_button:SetOnClick(function()
        self:Close()
    end)
    self.inst:ListenForEvent("muluchange", function()
        local x,y,z = self.close_button:GetPositionXYZ()
        if x < -210 then
            self.close_button:SetPosition(-210, 240)
        end
    end)
    self.inst:ListenForEvent("zhangjiechange", function()
        local x,y,z = self.close_button:GetPositionXYZ()
        if x < 370 then
            self.close_button:SetPosition(370, 240)
        end
    end)
end)

function taizhen_xiaoshuo:CreatMuLu(data)
    local cell_size = 60
    local row_w = 180
    local row_h = 58
    local row_spacing = 6
    local function ScrollWidgetsCtor(context, index)
        local w = Widget("mulu-cell-".. index)
		w:SetScale(0.6)
        w.index = index
		w.cell_root = w:AddChild(ImageButton("images/taizhen_xiaoshuoui.xml", "image.tex"))
        w.cell_root.focus_scale = {1.05, 1.05, 1.05}
        w.focus_forward = w.cell_root

        w.fengmian = w.cell_root:AddChild(Image())

		w.name = w.cell_root:AddChild(Text(NEWFONT, 34,nil,{0,0,0,1}))
        w.name:SetVAlign(ANCHOR_TOP)
        w.name:SetRegionSize(200, 60)
        w.name:SetPosition(-16, 0)

        w.author = w.cell_root:AddChild(Text(NEWFONT, 26,nil,{0,0,0,1}))
        w.author:SetPosition(-30, -40)
        w.author:SetHAlign(ANCHOR_LEFT)
        w.author:SetRegionSize(200, 25)

        w.cell_root.inst:ListenForEvent("muluchange", function()
            if w.name:GetString() == self.currentmuluname then
                w.cell_root.image:SetTint(0.7, 0.7, 0.7, 0.7)
                w.fengmian:SetTint(0.7, 0.7, 0.7, 0.7)
            else
                w.cell_root.image:SetTint(1, 1, 1, 1)
                w.fengmian:SetTint(1, 1, 1, 1)
            end        
        end,self.inst)
		return w
    end
    local function ScrollWidgetSetData(context, widget, data, index)
		if data ~= nil then
            if data.name then
                widget.name:SetString(data.name)
                widget.cell_root:SetOnClick(function()
                    if self.currentmuluname == data.name then
                    else
                        self:ShowAuthor(data.authorui)
                        self.currentmuluname = data.name
                        self.inst:PushEvent("muluchange")
                        self.zhangjie:SetItemsData(data.zj or {})
                    end
                end)
                if widget.name:GetString() == self.currentmuluname then
                    widget.cell_root.image:SetTint(0.7, 0.7, 0.7, 0.7)
                    widget.fengmian:SetTint(0.7, 0.7, 0.7, 0.7)
                else
                    widget.cell_root.image:SetTint(1, 1, 1, 1)
                    widget.fengmian:SetTint(1, 1, 1, 1)
                end
            end
            if data.image then
                widget.fengmian:SetTexture("images/taizhen_xiaoshuoui.xml", data.image)
                widget.fengmian:Show()
            else
                widget.fengmian:Hide()
            end
            if data.author then
                widget.author:SetString("作者: "..data.author)
            end
            widget.cell_root:Show()
			widget:Enable()
		else
			widget:Disable()
			widget.cell_root:Hide()
		end
		widget.data = data
    end

	local grid = TEMPLATES.ScrollingGrid(
        data,
        {
            context = {},
            widget_width  = row_w+row_spacing,
            widget_height = row_h+row_spacing,
			peek_percent     = 0.5,
            num_visible_rows = 4.65,
            num_columns      = 1,
            item_ctor_fn = ScrollWidgetsCtor,
            apply_fn     = ScrollWidgetSetData,
            scrollbar_offset = -120,
            scrollbar_height_offset = 0
        })
    grid.up_button:Hide()
    grid.down_button:Hide()
    grid.scroll_bar_line:Hide()
    grid.position_marker:Hide()
	return grid    
end

function taizhen_xiaoshuo:CreatZhangJie(data)
    local cell_size = 60
    local row_w = 200
    local row_h = 40
    local row_spacing = 6
    local function ScrollWidgetsCtor(context, index)
        local w = Widget("zhengjie-cell-".. index)
		w:SetScale(0.6)
        w.index = index
		w.cell_root = w:AddChild(ImageButton("images/taizhen_xiaoshuoui.xml", "image-1.tex"))
        w.cell_root.focus_scale = {1.05, 1.05, 1.05}
        w.cell_root:SetPosition(0, 0)
        w.focus_forward = w.cell_root
		w.name = w.cell_root:AddChild(Text(NEWFONT, 34,nil,{0,0,0,1}))
        w.name:SetPosition(18, 0)
        w.cell_root.inst:ListenForEvent("zhangjiechange", function()
            if self.currentmuluname..w.name:GetString() == self.zhangjiename then
                local x,y,z = w.cell_root:GetPositionXYZ()
                if x ~= 100 then
                    w.cell_root:MoveTo({x=0,y=0,z=0}, {x=100,y=0,z=0}, 0.5)
                end
            else
                local x,y,z = w.cell_root:GetPositionXYZ()
                if x ~= 0 then
                    w.cell_root:MoveTo({x=x,y=0,z=0}, {x=0,y=0,z=0}, 0.5)
                end
            end        
        end,self.inst)
		return w
    end
    local function ScrollWidgetSetData(context, widget, data, index)
		if data ~= nil then
            if data.zjname then
                widget.name:SetString(data.zjname)
                if self.currentmuluname..widget.name:GetString() == self.zhangjiename then
                    widget.cell_root:SetPosition(100, 0)
                else
                    widget.cell_root:SetPosition(0, 0)
                end 
                widget.cell_root:SetOnClick(function()
                    if self.zhangjiename == self.currentmuluname..data.zjname then
                    else
                        self.zhangjiename = self.currentmuluname..data.zjname
                        self.inst:PushEvent("zhangjiechange")
                        if data.text then
                            if self.bookui then
                                self.bookui.XiaoShuo = data.text
                                self.bookui:SetCode( 1 )
                            else
                                self.bookui = self.root:AddChild(bookutil(data.text))
                                self.bookui:MoveToBack()
                                self.bookui:LoadSet()
                            end
                        end
                    end
                end)
            end
            widget.cell_root:Show()
			widget:Enable()
		else
			widget:Disable()
			widget.cell_root:Hide()
		end
		widget.data = data
    end
	local grid = TEMPLATES.ScrollingGrid(
        {},
        {
            context = {},
            widget_width  = row_w+row_spacing,
            widget_height = row_h+row_spacing,
			peek_percent     = 0.5,
            num_visible_rows = 6.5,
            num_columns      = 1,
            item_ctor_fn = ScrollWidgetsCtor,
            apply_fn     = ScrollWidgetSetData,
            scrollbar_offset = 0,
            scrollbar_height_offset = 0
        })
    grid.up_button:Hide()
    grid.down_button:Hide()
    grid.scroll_bar_line:Hide()
    grid.position_marker:Hide()
    return grid
end

function taizhen_xiaoshuo:ShowAuthor(author)
    if author ~= nil and self.authorui ~= nil and self.authorui:GetAnimState():GetBuild() == author then
        return
    end
    if self.authorui then
        local x,y,z = self.authorui:GetPositionXYZ()
        local scr_w, scr_h = TheSim:GetScreenSize()
        local out_pos = Vector3(x+500, y, z)
        local in_pos = Vector3(x, y, z)
        local doremove = self.authorui
        self.authorui = nil
        doremove:MoveTo(in_pos, out_pos, .33, function() doremove:Kill() end)
    end
    if author ~= nil then
        self.authorui = self.root:AddChild(UIAnim())
        self.authorui:SetScale(0.6)
        self.authorui:GetAnimState():SetBank(author)
        self.authorui:GetAnimState():SetBuild(author)
        self.authorui:GetAnimState():PlayAnimation("goin")
        self.authorui:GetAnimState():PushAnimation("loop")
        self.authorui:SetPosition(500, 0)
    end
end

function taizhen_xiaoshuo:Start()
    if self.wanttoshow then
        return
    end
    self.mulu:SetItemsData(xiaoshuomulu)
    self:Show()
    self.wanttoshow = true
    self.root:MoveTo(self.out_pos, self.in_pos, .33, function() self.wanttoshow = false end)
end

function taizhen_xiaoshuo:Close()
    if self.wanttohide then
        return
    end
    self.wanttohide = true
    self.root:MoveTo(self.in_pos, self.out_pos, .33, function() 
        self.wanttohide = false 
        if self.bookui then
            self.bookui:Kill()
            self.bookui = nil
        end
        self.close_button:SetPosition(-310, 240)
        self.currentmuluname = nil
        self.zhangjiename = nil
        self.zhangjie:SetItemsData({})
        self:Hide() 
    end)
end

function taizhen_xiaoshuo:OnGainFocus()
	taizhen_xiaoshuo._base.OnGainFocus(self)
	TheCamera:SetControllable(false)
end

function taizhen_xiaoshuo:OnLoseFocus()
	taizhen_xiaoshuo._base.OnLoseFocus(self)
	TheCamera:SetControllable(true)
end

return taizhen_xiaoshuo
