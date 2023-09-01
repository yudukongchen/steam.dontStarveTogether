GLOBAL.setmetatable(env,{__index = function(t, k)return GLOBAL.rawget(GLOBAL, k) end})
local Moisture = require("components/moisture")
--local easing = require("easing")
AddComponentPostInit("moisture",function(self)
	local GetMoistureRate = self.GetMoistureRate
	function self:GetMoistureRate()
		if not TheWorld.state.israining then
			return 0
		end
		local x, y, z = self.inst.Transform:GetWorldPosition()
		local entsgai =
			TheSim:FindEntities(x,y,z,24,{"lostumbrella_gai"},{"FX", "NOCLICK", "DECOR", "INLIMBO", "stump", "burnt"})
		local ents =
			TheSim:FindEntities(x,y,z,10,{"lostumbrella"},{"FX", "NOCLICK", "DECOR", "INLIMBO", "stump", "burnt"})
		if #entsgai > 0 then
			return 0
		end
		if #ents > 0 then
			return 0
		end
		return GetMoistureRate(self)
	end
end)