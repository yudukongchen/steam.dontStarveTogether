local Screen = require "widgets/screen"
local Widget = require "widgets/widget"
local Text = require "widgets/text"
local ImageButton = require "widgets/imagebutton"
local TEMPLATES = require "widgets/redux/templates"
local ScrollableList = require "widgets/scrollablelist"
local UIAnim = require "widgets/uianim"

local TZTeleScreen =
    Class(
    Screen,
    function(self, owner, attach)
        Screen._ctor(self, "TZTeleScreen")
        self.owner = owner
        self.attach = attach
        self.isopen = false
        self._scrnw, self._scrnh = TheSim:GetScreenSize()
        self:SetScaleMode(SCALEMODE_PROPORTIONAL)
        self:SetMaxPropUpscale(MAX_HUD_SCALE)
        self:SetPosition(0, 0, 0)
        self:SetVAnchor(ANCHOR_MIDDLE)
        self:SetHAnchor(ANCHOR_MIDDLE)
        self.closefn = self.attach:DoPeriodicTask(0.1,function(inst,ui) 
            if ui.attach and ui.attach:GetDistanceSqToInst(ui.owner) > 9 then
                ui:OnCancel()
            end
        end,nil,self)
        self.scalingroot = self:AddChild(Widget("travelablewidgetscalingroot"))
        self.scalingroot:SetScale(TheFrontEnd:GetHUDScale())
       
        self.inst:ListenForEvent(
            "continuefrompause",
            function()
                if self.isopen then
                    self.scalingroot:SetScale(TheFrontEnd:GetHUDScale())
                end
            end,
            TheWorld
        )
        self.inst:ListenForEvent(
            "refreshhudsize",
            function(hud, scale)
                if self.isopen then
                    self.scalingroot:SetScale(scale)
                end
            end,
            owner.HUD.inst
        )

        self.root = self.scalingroot:AddChild(TEMPLATES.ScreenRoot("root"))
        if self.attach.replica.inventoryitem then
            self.root:SetPosition(400,-200, 0)      --道具
        else
            self.root:SetPosition(0,0, 0)           --建筑
        end
        -- secretly this thing is a modal Screen, it just LOOKS like a widget
        self.black = self.root:AddChild(Image("images/global.xml", "square.tex"))
        self.black:SetVRegPoint(ANCHOR_MIDDLE)
        self.black:SetHRegPoint(ANCHOR_MIDDLE)
        self.black:SetVAnchor(ANCHOR_MIDDLE)
        self.black:SetHAnchor(ANCHOR_MIDDLE)
        self.black:SetScaleMode(SCALEMODE_FILLSCREEN)
        self.black:SetTint(0, 0, 0, 0)
        self.black.OnMouseButton = function()
            self:OnCancel()
        end

        self.destspanel = self.root:AddChild(UIAnim())--Image("images/tzui/ui.xml", "back.tex")
        self.uianim = self.destspanel:GetAnimState()
        self.uianim:SetBank("tzui_back")
        self.uianim:SetBuild("tzui_back")
        self.uianim:PlayAnimation("open")
        self.uianim:PushAnimation("idle")
        self.destspanel:SetPosition(0, 0)
        self.destspanel:SetScale(0.75,0.75,0.75)
        self.inst:DoTaskInTime(0.2,function() self:LoadDests() end)
        --self:LoadDests()
        --self:Show()
        self.isopen = true
    end
)

function TZTeleScreen:LoadDests()
    if not self.cancelbutton then
        self.cancelbutton =
            self.destspanel:AddChild(
            TEMPLATES.StandardButton(
                function()
                    self:OnCancel()
                end,
                "关闭",
                {80, 30}
            )
        )
        self.cancelbutton.text:SetSize(25)
        self.cancelbutton:SetPosition(0, -150)
    end   
    if not  self.attach then
        self:OnCancel()
        return
    end
    local info_pack = self.attach.replica.taizhen_teleport and self.attach.replica.taizhen_teleport:GetDestInfos()
    self.dest_infos = {}
    for i, v in ipairs(string.split(info_pack, "\n")) do
        local elements = string.split(v, "\t")
        if elements[1] == tostring(i) then
            local info = {}
            info.index = i
            info.name = elements[2]
            if info.name == "~nil" then
                info.name = nil
            end
            info.cost_hunger = tonumber(elements[3]) or -1
            info.cost_sanity = tonumber(elements[4]) or -1
            table.insert(self.dest_infos, info)
        else
            print("data error:\n", info_pack)
            self.isopen = true
            self:OnCancel()
            return
        end
    end
    
    self:RefreshDests()
end

function TZTeleScreen:RefreshDests()
    self.destwidgets = {}
    for i, v in ipairs(self.dest_infos) do
        local data = {
            index = i,
            info = v
        }

        table.insert(self.destwidgets, data)
    end

    local function ScrollWidgetsCtor(context, index)
        local widget = Widget("widget-" .. index)

        widget:SetOnGainFocus(
            function()
                self.dests_scroll_list:OnWidgetFocus(widget)
            end
        )
        widget.destitem = widget:AddChild(self:DestListItem())
        local dest = widget.destitem
        widget.focus_forward = dest
        return widget
    end

    local function ApplyDataToWidget(context, widget, data, index)
        widget.data = data
        widget.destitem:Hide()
        if not data then
            widget.focus_forward = nil
            return
        end

        widget.focus_forward = widget.destitem
        widget.destitem:Show()

        local dest = widget.destitem

        dest:SetInfo(data.info)
    end

    if not self.dests_scroll_list then
        self.dests_scroll_list =
            self.destspanel:AddChild(
            TEMPLATES.ScrollingGrid(
                self.destwidgets,
                {
                    context = {},
                    widget_width = 210,
                    widget_height = 50,
                    num_visible_rows = 5,
                    num_columns = 1,
                    item_ctor_fn = ScrollWidgetsCtor,
                    apply_fn = ApplyDataToWidget,
                    scrollbar_offset = 10,
                    scrollbar_height_offset = -40,
                    peek_percent = 0, -- may init with few clientmods, but have many servermods.
                    allow_bottom_empty_row = true -- it's hidden anyway
                }
            )
        )
        self.dests_scroll_list.up_button:Hide()
        self.dests_scroll_list.down_button:Hide()
        self.dests_scroll_list.scroll_bar_line:SetTexture("images/tzui/ui.xml","gundong.tex","gundong.tex")
        self.dests_scroll_list.scroll_bar_line:ScaleToSize(40,300)
        self.dests_scroll_list.scroll_bar:SetTextures("images/tzui/ui.xml","button.tex")
        self.dests_scroll_list.scroll_bar:SetScale(1,1,1)
        self.dests_scroll_list.position_marker:SetTextures("images/tzui/ui.xml","button.tex","button.tex","button.tex","button2.tex","button.tex")
        self.dests_scroll_list.position_marker.image:SetTexture("images/tzui/ui.xml","button.tex")
        self.dests_scroll_list.position_marker:SetScale(1,1,1)
        self.dests_scroll_list:SetPosition(-15, 20)
        self.dests_scroll_list:SetFocusChangeDir(MOVE_DOWN, self.cancelbutton)
        self.cancelbutton:SetFocusChangeDir(MOVE_UP, self.dests_scroll_list)
    end
end

function TZTeleScreen:DestListItem()
    local dest = Widget("destination")

    local item_width, item_height = 200, 60
    dest.backing =
        dest:AddChild(ImageButton("images/tzui/ui.xml","dest.tex","dest1.tex","dest.tex","dest1.tex","dest1.tex",{1,0.8,0.8}))
    dest.backing.move_on_click = true

    dest.name = dest:AddChild(Text(BODYTEXTFONT, 35))
    dest.name:SetVAlign(ANCHOR_MIDDLE)
    dest.name:SetHAlign(ANCHOR_MIDDLE)
    dest.name:SetPosition(-0,0, 0)
    dest.name:SetRegionSize(150, 30)

    local cost_py = -15
    local cost_font = UIFONT
    local cost_fontsize = 17

    dest.status = dest:AddChild(Text(cost_font, cost_fontsize))
    dest.status:SetVAlign(ANCHOR_MIDDLE)
    dest.status:SetHAlign(ANCHOR_LEFT)
    dest.status:SetPosition(100, cost_py, 0)
    dest.status:SetRegionSize(100, 30)

    dest.SetInfo = function(_, info)
        if info.name and info.name ~= "" then
            dest.name:SetString(info.name)
            dest.name:SetColour(1, 1, 1, 1)
        else
            dest.name:SetString("未知")
            dest.name:SetColour(1, 1, 0, 0.6)
        end

        if info.cost_hunger <= 0  then
            dest.backing:SetOnClick(nil)
            if info.cost_hunger < 0  then
                dest.name:SetColour(1, 0, 0, 0.4)
            else
                dest.name:SetColour(0, 1, 0, 0.6)
            end
        else
            dest.backing:SetOnClick(
                function()
                    self:Travel(info.index)
                end
            )
        end
    end

    dest.focus_forward = dest.backing
    return dest
end

function TZTeleScreen:Travel(index)
    if not self.isopen then
        return
    end

    local a = self.attach.replica.taizhen_teleport
    if a then
        a:Travel(self.owner, index)
    end

    self.owner.HUD:CloseTZTeleScreen()
end

function TZTeleScreen:OnCancel()
    if not self.isopen then
        return
    end

    local a = self.attach.replica.taizhen_teleport
    if a then
        a:Travel(self.owner, nil)
    end

    self.owner.HUD:CloseTZTeleScreen()
end

function TZTeleScreen:OnControl(control, down)
    if TZTeleScreen._base.OnControl(self, control, down) then
        return true
    end

    if not down then
        if control == CONTROL_OPEN_DEBUG_CONSOLE then
            return true
        elseif control == CONTROL_CANCEL then
            self:OnCancel()
        end
    end
end

function TZTeleScreen:OnRawKey(key, down)
	if TZTeleScreen._base.OnRawKey(self, key, down) then return true end
end


function TZTeleScreen:Close()
    if self.isopen then
        self.attach = nil
        self.black:Kill()
        self.isopen = false
        self.closefn:Cancel()
        self.destspanel:KillAllChildren()
        self.uianim:PlayAnimation("close")
        self.closefn = nil
        self.inst:DoTaskInTime(
            .3,
            function()
                self:Kill()
            end
        )
    end
end
return TZTeleScreen
