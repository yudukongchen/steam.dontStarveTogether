local FollowText = require "widgets/followtext"

local DEFAULT_OFFSET = Vector3(0, -400, 0)

Line = Class(function(self, message, noanim, duration)
    self.message = message
    self.noanim = noanim
	self.duration = duration
end)

local function sayfn(self, script, nobroadcast, colour)
    local player = ThePlayer
    if (not self.disablefollowtext) and self.widget == nil and player ~= nil and player.HUD ~= nil then
        self.widget = player.HUD:AddChild(FollowText(TALKINGFONT_TRADEIN, self.fontsize or 35))
        self.widget:SetHUD(player.HUD.inst)
    end

    if self.widget ~= nil then
        self.widget.symbol = self.symbol
        self.widget:SetOffset(self.offset_fn ~= nil and self.offset_fn(self.inst) or self.offset or DEFAULT_OFFSET)
        self.widget:SetTarget(self.inst)
        if colour ~= nil then
            self.widget.text:SetColour(unpack(colour))
        elseif self.colour ~= nil then
            self.widget.text:SetColour(self.colour.x, self.colour.y, self.colour.z, 1)
        end
    end

    for i, line in ipairs(script) do
		local duration = math.min(line.duration or self.lineduration or TUNING.DEFAULT_TALKER_DURATION, TUNING.MAX_TALKER_DURATION)
        if line.message ~= nil then
            local display_message = GetSpecialCharacterPostProcess(
                        self.inst.prefab,
                        self.mod_str_fn ~= nil and self.mod_str_fn(line.message) or line.message
                    )

            if not nobroadcast then
                TheNet:Talker(line.message, self.inst.entity, duration ~= TUNING.DEFAULT_TALKER_DURATION and duration or nil)
            end

            if self.widget ~= nil then
                self.widget.text:SetString(display_message)
            end

            if self.ontalkfn ~= nil then
                self.ontalkfn(self.inst, { noanim = line.noanim, message=display_message })
            end

            self.inst:PushEvent("ontalk", { noanim = line.noanim })
        elseif self.widget ~= nil then
            self.widget:Hide()
        end
        Sleep(duration)
        if not self.inst:IsValid() or (self.widget ~= nil and not self.widget.inst:IsValid()) then
            return
        end
    end

    if self.widget ~= nil then
        self.widget:Kill()
        self.widget = nil
    end

    if self.donetalkingfn ~= nil then
        self.donetalkingfn(self.inst)
    end

    self.inst:PushEvent("donetalking")
    self.task = nil
end

local function CancelSay(self)
    if self.widget ~= nil then
        self.widget:Kill()
        self.widget = nil
    end

    if self.task ~= nil then
        scheduler:KillTask(self.task)
        self.task = nil

        if self.donetalkingfn ~= nil then
            self.donetalkingfn(self.inst)
        end

        self.inst:PushEvent("donetalking")
    end
end


local function Say(self, script, time, noanim, force, nobroadcast, colour)
    colour = { 150 / 255, 0 / 255, 0 / 255, 1 } -- ! Forced red color text
    -- script = string.upper(script)
    -- end
    if TheWorld.speechdisabled then return nil end
    if TheWorld.ismastersim then
        if not force
            and (self.ignoring ~= nil or
                (self.inst.components.health ~= nil and self.inst.components.health:IsDead() and self.inst.components.revivablecorpse == nil) or
                (self.inst.components.sleeper ~= nil and self.inst.components.sleeper:IsAsleep())) then
            return
        elseif self.ontalk ~= nil then
            self.ontalk(self.inst, script)
        end
    elseif not force then
        if self.inst:HasTag("ignoretalking") then
            return
        elseif self.inst.components.revivablecorpse == nil then
            local health = self.inst.replica.health
            if health ~= nil and health:IsDead() then
                return
            end
        end
    end

    CancelSay(self)
    local lines = type(script) == "string" and { Line(script, noanim, time) } or script
    if lines ~= nil then
        self.task = self.inst:StartThread(function() sayfn(self, lines, nobroadcast, colour) end)
    end
end
return Say