GLOBAL.require("map/terrain")
modimport("modinfo_TUNING")

local worldgen_enable = TUNING.IFH_WORLDGEN_ENABLE
if worldgen_enable == true then
	AddRoomPreInit("BeeQueenBee",function(room) 
		room.contents.countprefabs.ice_flowerhat = 1
	end)
end
