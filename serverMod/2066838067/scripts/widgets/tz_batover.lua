local UIAnim = require "widgets/uianim"
local easing = require "easing"
local Widget = require "widgets/widget"

local BatOver = Class(Widget, function(self, owner)
	Widget._ctor(self, "tz_bat")
    self.owner = owner
    self:SetClickable(false)
    self.soundlevel = 0
    self.sounddelay = 0
end)

function BatOver:TriggerBats()
    self.soundlevel = 3.5
    self.sounddelay = 0
    self:StartUpdating()
end

function BatOver:OnUpdate(dt)
    if self.sounddelay > dt then
        self.sounddelay = self.sounddelay - dt
    elseif self.soundlevel > 0 then
		if not (self.soundlevel < 2 and self.soundlevel > 1.1) then
			TheFocalPoint.SoundEmitter:PlaySound("dontstarve/creatures/bat/flap", nil, 1)
		end
        if self.soundlevel > .05 then
            self.soundlevel = self.soundlevel - .05
            self.sounddelay = math.random(3, 4) * FRAMES
        else
            self.soundlevel = 0
            self.sounddelay = 0
			self:StopUpdating()
        end
    end
end

return BatOver
