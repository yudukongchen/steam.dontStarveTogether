local HOTKEY_HUD = GetModConfigData("KEYBOARD_TOGGLE_HUD")
local HOTKEY_VIEW = GetModConfigData("KEYBOARD_TOGGLE_VIEW")

-- local is_PVPEnabled = GLOBAL.TheNet:GetPVPEnabled()
local is_PVPEnabled = false


local function tweak_camera(camera_data)

	local TheCamera = GLOBAL.TheCamera

	if TheCamera == nil then
		return false
	end

	if camera_data == nil then
		TheCamera:SetDefault()
		return false
	end

	if camera_data[1] ~= nil then
		TheCamera.zoomstep = camera_data[1]
	end

	if camera_data[2] ~= nil then
		TheCamera.distancetarget = camera_data[2]
	end

	if camera_data[3] ~= nil then
		TheCamera.mindist = camera_data[3]
	end

	if camera_data[4] ~= nil then
		TheCamera.maxdist = camera_data[4]
	end

	if camera_data[5]~= nil then
		TheCamera.mindistpitch = camera_data[5]
	end

	if camera_data[6]~= nil then
		TheCamera.maxdistpitch = camera_data[6]
	--camera:SetDistance(math.ceil(mindist*2)-.1)
	end

end

--参数zoomstep, distancetarget, mindist,maxdist, mindistpitch,maxdistpitch

--默认
local data_default_cave = 	{4,25, 15,35, 25,40}
local data_default_forest = {4,30, 15,50, 30,60}
--高空
local data_aerial_cave = 	{12,80, 5,180, 25,90}
local data_aerial_forest = 	{12,80, 5,180, 40,60}
--俯视
local data_vertical_cave = 		{nil,120, nil,nil, 90,nil}
local data_vertical_forest = 	{nil,120, nil,nil, 90,nil}

local data_vertical_cave_1 = 	{nil,25, nil,nil, nil,nil}
local data_vertical_forest_1 =  {nil,30, nil,nil, nil,nil}

local camera_status = 0
local function change_view()

	if is_PVPEnabled then
		return false
	end

	if GLOBAL.ThePlayer == nil or GLOBAL.TheWorld == nil  then
		return false
	end

	local talker = GLOBAL.ThePlayer.components.talker
	local TheWorld = GLOBAL.TheWorld

	if camera_status == 2 then
		--参数camera_data,do_ default_f
		if TheWorld:HasTag("cave") then
			tweak_camera(data_vertical_cave_1)	 --cave maxdistpitch=90默认视角与原来一致  90最高为俯视 mindistpitch=90为全俯视图
		else
			tweak_camera(data_vertical_forest_1)	 --forest mindistpitch=40默认视角与原来一致  mindistpitch=90为全俯视图
		end
		tweak_camera(nil)
		camera_status = 0


		talker:Say("Default View")

	elseif camera_status == 0 then
		if TheWorld:HasTag("cave") then
			tweak_camera(data_aerial_cave)
		else
			tweak_camera(data_aerial_forest) 	--forest
		end
		camera_status = 1
		talker:Say("Aerial View")

	elseif camera_status == 1 then
		if TheWorld:HasTag("cave") then
			tweak_camera(data_vertical_cave)	 --cave maxdistpitch=90默认视角与原来一致  90最高为俯视 mindistpitch=90为全俯视图
		else
			tweak_camera(data_vertical_forest)	 --forest mindistpitch=40默认视角与原来一致  mindistpitch=90为全俯视图
		end
		camera_status = 2
		talker:Say("Vertical View")

	end
end

local function default_view()

	if is_PVPEnabled then
		return false
	end

	if GLOBAL.ThePlayer == nil or GLOBAL.TheWorld == nil  then
		return false
	end

	local talker = GLOBAL.ThePlayer.components.talker
	local TheWorld = GLOBAL.TheWorld

	if  TheWorld:HasTag("cave") then
		--参数camera_data,do_ default_fn
		tweak_camera(nil)	 --cave 游戏默认
	else
		tweak_camera(nil)		 --forest 游戏默认
	end
	camera_status = 0
	talker:Say("Default View")
end

local is_hud_visible = true
local function contral_hud()

	local ThePlayer = GLOBAL.ThePlayer
	
	if ThePlayer == nil then
		return false
	end

	if is_hud_visible == true  then --hide HUD
		ThePlayer.HUD:Hide()
		is_hud_visible = false
	else --show HUD
		ThePlayer.HUD:Show()
		is_hud_visible = true
	end
end

local function key_up()
	local TheCamera = GLOBAL.TheCamera

	if TheCamera == nil then
		return false
	end

	local old_distancetarget = TheCamera.distancetarget
	TheCamera.distancetarget = old_distancetarget + 10
	print(TheCamera.distancetarget)

end

local function key_down()
	local TheCamera = GLOBAL.TheCamera

	if TheCamera == nil then
		return false
	end

	local old_distancetarget = TheCamera.distancetarget

	if old_distancetarget > 10 then
		TheCamera.distancetarget = old_distancetarget - 10
	end
	print(TheCamera.distancetarget)
end

local function key_left()
	local TheCamera = GLOBAL.TheCamera

	if TheCamera == nil then
		return false
	end

	local old_mindistpitch = TheCamera.mindistpitch

	if old_mindistpitch > 10 then
		TheCamera.mindistpitch = old_mindistpitch - 10
	end
	print(TheCamera.mindistpitch)
end

local function key_right()
	local TheCamera = GLOBAL.TheCamera

	if TheCamera == nil then
		return false
	end

	local old_mindistpitch = TheCamera.mindistpitch

	TheCamera.mindistpitch = old_mindistpitch + 10
	print(TheCamera.mindistpitch)
end

GLOBAL.TheInput:AddKeyUpHandler(HOTKEY_HUD, contral_hud)
GLOBAL.TheInput:AddKeyUpHandler(HOTKEY_VIEW, change_view)


--[[
GLOBAL.TheInput:AddKeyUpHandler(HOTKEY_DEFAULT, default_view)
GLOBAL.TheInput:AddKeyUpHandler(273, key_up)
GLOBAL.TheInput:AddKeyUpHandler(274, key_down)
GLOBAL.TheInput:AddKeyUpHandler(276, key_left)
GLOBAL.TheInput:AddKeyUpHandler(275, key_right)
--]]

