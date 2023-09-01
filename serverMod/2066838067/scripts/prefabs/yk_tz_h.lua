local FollowText = require "widgets/followtext"

-- local function setText(inst,amount)
    -- local sign = ""
	-- if amount > 0 then
        -- inst.Label:SetColour(0, 1, 0)
        -- sign = "+"
    -- else
        -- inst.Label:SetColour(1, 0, 0)
    -- end
    -- if math.abs(amount) < 1 then
		-- inst.Label:SetText(sign .. string.format("%.2f", amount))
    -- else
		-- inst.Label:SetText(sign .. string.format("%.1f", amount))
    -- end
-- end

local function DamageDisplay(inst, target)
	inst.nocd = false
	local h = target.components.health.currenthealth
	-- target.components.health.yktz_damagedisplay = false
	inst._amount:set(0)
	-- print(inst._amount:value())
	inst:DoTaskInTime(FRAMES*3, function()
		inst.nocd = true
		-- target.components.health.yktz_damagedisplay = true
		inst._amount:set(target.components.health.currenthealth - h)
	end)
	-- local x,y,z = target.Transform:GetWorldPosition()
	-- y = 1.7225+y
    -- inst.Transform:SetPosition(x, y, z)
    -- local m = 9*FRAMES
    -- local i = 0
	-- local c = 1
    -- inst.dycddtask = inst:DoPeriodicTask(FRAMES, function()
        -- i = i+ FRAMES --0.03333
        -- if i < 0.034 then
			-- target.yktz_cd = false
			-- local amount = target.components.health.currenthealth - h
			-- inst._amount:set(amount)
			-- setText(inst,amount)
		-- elseif i < m then
			-- if i > m/3 then
				-- i = m
			-- end
			-- local size = (1 - math.abs(i / m - 1)) * 15 + 20
			-- inst.Label:SetFontSize(size)
			-- inst._size:set(size)
        -- elseif i < 0.65 then
            -- inst.Transform:SetPosition(x, y, z)
			-- y = y + 0.1
			-- c = c - 0.1
			-- inst.AnimState:SetMultColour(1, 1, 1, c)
		-- else
			-- inst.dycddtask:Cancel()
            -- inst:Remove()
        -- end
    -- end,FRAMES*3)
end

-- local function sizedirty(inst)
	-- inst.Label:SetFontSize(inst._size:value())
-- end
local function amountdirty(inst)
	local amount = inst._amount:value()
	if amount ~= 0 and inst:IsValid() then
		local player = ThePlayer
		local widget
		if player ~= nil and player.HUD ~= nil then
			widget = player.HUD:AddChild(FollowText(NUMBERFONT, 35))
			widget:SetHUD(player.HUD.inst)
		end
		if widget ~= nil then
			-- widget:SetTarget(inst)
			if amount > 0 then
				widget.text:SetColour(0, 1, 0,1)
			else
				widget.text:SetColour(1, 0, 0,1)
			end
			amount = math.abs(amount)
			if amount < 1 then
				widget.text:SetString(string.format("%.2f", amount))
			else
				widget.text:SetString(string.format("%.1f", amount))
			end
			
			--是否大型生物，大型130大小的字体
			widget.text:SetScale(0, 0, 0)
			widget.text:SetSize(inst:HasTag("da") and 130 or 65)
			local i = 0
			local offy = 0
			widget.text:ScaleTo(0, 1.3, 0.3, function() --0-1.3
				widget.text:ScaleTo(1.3, 1, 0.2) --1.3-1
			end)
			function widget:OnUpdate(dt)
				if inst:IsValid() then
					i = i+ dt
					if i > 0.8 then
						offy = offy + 6
						local a = self.text.colour[4]-0.16 --FRAMES/(1-0.8)
						if a < 0 then
							self:Kill()
						else
							self.text:UpdateAlpha(a)
						end
					end
					local x, y
					if inst.AnimState ~= nil then
						x, y = TheSim:GetScreenPos(inst.AnimState:GetSymbolPosition("", self.offset.x, self.offset.y, self.offset.z))
					else
						x, y = TheSim:GetScreenPos(inst.Transform:GetWorldPosition())
					end
					self:SetPosition(x , y+offy , 0)
				end
			end
			
		end
	end
	-- setText(inst,inst._amount:value())
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
	inst.entity:AddNetwork()
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    inst:AddTag("notarget")
    -- inst.entity:AddLabel()
    -- inst.Label:SetFont(NUMBERFONT)
    -- inst.Label:SetFontSize(20)
    -- inst.Label:SetColour(1, 1, 1)
    -- inst.Label:SetText("")
    -- inst.Label:Enable(true)

	
	-- inst._size = net_float(inst.GUID, "_size", "sizedirty")
	-- inst._size:set(20)
	inst._amount = net_float(inst.GUID, "_amount", "amountdirty")
	inst:ListenForEvent("amountdirty", amountdirty)
	-- inst._text = net_string(inst.GUID, "_text", "amountdirty")
	-- inst._text:set("")
	
    inst.persists = false
	if not TheWorld.ismastersim then
		-- inst:ListenForEvent("sizedirty", sizedirty)
		return inst
	end
	inst.DamageDisplay = DamageDisplay
	inst.nocd = true
    return inst
end
return Prefab("yktz_damagedisplay", fn)
