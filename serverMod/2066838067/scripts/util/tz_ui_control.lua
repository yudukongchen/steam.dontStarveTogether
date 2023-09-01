
local function AddControl(ui,savename)
	function ui.OnControl(rootself, control, down)
		if control == CONTROL_SECONDARY then
			if down then
				if rootself.QM_offpos == nil then
					rootself.QM_offpos = {}
					TheFrontEnd:LockFocus(true)
					rootself.QM_offpos.pt = TheInput:GetScreenPosition()
					local xxx = rootself.QM_offpos.pt - rootself:GetWorldPosition()
					rootself.QM_offpos.offpos = Point( xxx.x, rootself.QM_offpos.pt.y - xxx.y )
					rootself.QM_offpos.pos = rootself:GetPosition()
				end

				if rootself.followhandler == nil then
					rootself.followhandler = TheInput:AddMoveHandler(function(x, y)
						local scr_w, scr_h = TheSim:GetScreenSize()
						local pt = TheInput:GetScreenPosition()
						local pt1 = pt - rootself.QM_offpos.pt
						local x1 = math.clamp( rootself.QM_offpos.pos.x + rootself.QM_offpos.offpos.x + pt.x - rootself.QM_offpos.pt.x , 75 - 10, scr_w - 75)
						local z1 = math.clamp(rootself.QM_offpos.pos.y + pt.y - rootself.QM_offpos.pt.y, -scr_h + 75 + 10 + 75, 10)
						rootself:SetPosition(x1, z1)
						TheSim:SetPersistentString(savename,string.format("return Vector3(%f,%f,%f)",x1,z1,0),false)
					end)
				end
			else
				if rootself.followhandler ~= nil then
					rootself.followhandler:Remove()
					rootself.followhandler = nil
				end
				rootself.QM_offpos = nil
				TheFrontEnd:LockFocus(false)
			end
			return true
		end
		if not down then
			if control == 29 then
				if rootself.onclick then
					rootself.onclick()
				end
				return true
			end
		end
	end
    TheSim:GetPersistentString(savename,function(load_success, str)
        if load_success then
            local fn = loadstring(str)
            if type(fn) == "function" then
                local pos = fn()
                if pos then
				    ui:SetPosition(pos:Get())
                end
            end
        end
    end)
end

local tz_buttons_controls = {}
local show = true
AddClassPostConstruct("widgets/controls", function(self)
    if not (self.owner and self.owner:HasTag("taizhen")) then
        return
    end
    TheSim:GetPersistentString("tz_buttons_controls_save",function(load_success, str) 
        if load_success and str == "hide" then
            show = false
        end
    end)
    ---load 
    self.inst:DoTaskInTime(0.1,function()--延迟一下判定重载状态和等ui加载完毕
        if not show then
            for k, v in pairs(tz_buttons_controls) do
                v:Hide()
            end
        end
    end)

    --f10
    self.tz_buttons_controls_save_handler = TheInput:AddKeyDownHandler(KEY_F10, function() --添加f10控制统一的隐藏和显示
        local needshow = true
        for k,v in pairs(tz_buttons_controls) do
            if v.shown then --只要有一个处于显示 那么本次操作就是全部隐藏 统一管理
                needshow = false
                break
            end
        end
        for k,v in pairs(tz_buttons_controls) do
            if needshow then
                v:Show()
                TheSim:SetPersistentString("tz_buttons_controls_save","show")
            else
                v:Hide()
                TheSim:SetPersistentString("tz_buttons_controls_save","hide",false)
            end
        end
    end)
    self.inst:ListenForEvent("onremove", function()
        if self.tz_buttons_controls_save_handler ~= nil then
            self.tz_buttons_controls_save_handler:Remove()
        end
    end)
end)

function Add_Tz_Ui_Button_Controls(ui,name,addcontrol)--ui 保存的名字 是否可拖动
    if ui and name then
        table.insert(tz_buttons_controls,ui)
        if addcontrol then
            AddControl(ui,name)
        end
    end
end