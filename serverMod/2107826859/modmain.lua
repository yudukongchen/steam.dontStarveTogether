-- show firefighter range
local tonumber = GLOBAL.tonumber

Assets = {
    Asset("ANIM", "anim/firefighter_range.zip"),
}
PrefabFiles = {
	"lightningrod",
	"range",
}

local show_time =  tonumber(GetModConfigData("Show Range Duration"))
GLOBAL.TUNING.SHOW_RANGE_TIME = show_time

function IceFlingOnRemove(inst)
	local pos = GLOBAL.Point(inst.Transform:GetWorldPosition())
	local range_indicators = GLOBAL.TheSim:FindEntities(pos.x,pos.y,pos.z, 4, {"range_indicator"})
	for i,v in ipairs(range_indicators) do
		if v:IsValid() then
			v:Remove()
		end
	end
end

local function IceFlingOnShow(inst)
	local pos = GLOBAL.Point(inst.Transform:GetWorldPosition())
	local range_indicators_client = TheSim:FindEntities(pos.x,pos.y,pos.z, 2, {"range_indicator"})
	if #range_indicators_client < 1 then
		local range = GLOBAL.SpawnPrefab("range_indicator")
		range.Transform:SetPosition(pos.x, pos.y, pos.z)
	end
end

local controller = GLOBAL.require "components/playercontroller"
local old_OnLeftClick = controller.OnLeftClick

function controller:OnLeftClick(down,...)
	if (not down) and self:UsingMouse() and self:IsEnabled() and not GLOBAL.TheInput:GetHUDEntityUnderMouse() then
		local item = GLOBAL.TheInput:GetWorldEntityUnderMouse()
		if item then
			if item.prefab == "firesuppressor" or item.prefab == "dummyflingo" then
				GLOBAL.TUNING.MACHIN = "firesuppressor"
			elseif item.prefab == "winona_catapult" then
				GLOBAL.TUNING.MACHIN = "winona_catapult"
			elseif item.prefab == "lightning_rod" then
				GLOBAL.TUNING.MACHIN = "lightning_rod"
			else
				GLOBAL.TUNING.MACHIN = 0
			end

			if ((item:HasTag("hasemergencymode") and item.prefab == "firesuppressor")
				or (item:HasTag("catapult") and item.prefab == "winona_catapult")
				or (item:HasTag("lightningrod") and item.prefab == "lightning_rod")
				or item.prefab == "dummyflingo")
			then
				IceFlingOnShow(item)
			end
		end
	end
	return old_OnLeftClick(self,down,...)
end



function IceFlingPostInit(inst)
	-- if inst and inst.components.inspectable then
	-- 	inst.components.inspectable.getstatus = getstatus_mod
	-- end
	inst:ListenForEvent("onremove", IceFlingOnRemove)
end

AddPrefabPostInit("firesuppressor", IceFlingPostInit)
AddPrefabPostInit("winona_catapult", IceFlingPostInit)
AddPrefabPostInit("lightning_rod", IceFlingPostInit)
AddPrefabPostInit("dummyflingo", IceFlingPostInit)