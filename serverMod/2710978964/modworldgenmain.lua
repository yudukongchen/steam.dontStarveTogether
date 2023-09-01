GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

local no_oceanfished = rawget(GLOBAL,"NO_OCEANFISHED")
--不要执行其他内容
if no_oceanfished then return end --lua文件本身可以看作一个函数，那么有个返回值很正常吧

--[[
客户端ui界面大部分是借鉴熔炉mod https://steamcommunity.com/sharedfiles/filedetails/?id=1938752683 
但直接抄也会有问题，就是预设加载问题，这部分是本人从报错的一步步看源码，一点点测试得到的。
]]
local map_max = GetModConfigData("minmap") or 0

if rawget(GLOBAL,"WorldSim") and map_max > 0 then
    local idx = getmetatable(WorldSim).__index
    local SetWorldSize_ = idx.SetWorldSize
    local ConvertToTileMap_ = idx.ConvertToTileMap
    idx.SetWorldSize = function(self,a,b) SetWorldSize_(self,map_max,map_max) end --没有啥用的
    idx.ConvertToTileMap = function(self,x) ConvertToTileMap_(self,map_max) end --设置地图大小,单位一地皮
end

require("map/network")
require("util")
require("gamemodes")


--将原本的世界的设置挪到其他文件中 方便查看及其屏蔽掉世界设置
--加载世界设置
modimport("worldgen.lua")


--------------------------------------------------------------
-- 客户端 前端ui
-- 向全局表中设置MODENV属性(值为表)设置为本文件的env 这里是抄的 
_G.rawset(_G, "MODENV", env)

local Profile = require("playerprofile") --设置

local IsTheFrontEnd = rawget(_G, "TheFrontEnd")

local ModsTab = require("widgets/redux/modstab")
local WorldSettingsTab = require("widgets/redux/worldsettings/worldsettingstab")
local _OnConfirmEnable = ModsTab.OnConfirmEnable
local _Cancel = ModsTab.Cancel
local _Refresh = WorldSettingsTab.Refresh

local function Reset(modname)
	local screen = TheFrontEnd:GetActiveScreen()
	if screen and screen.server_settings_tab then
		local fancy_name = modname and KnownModIndex:GetModFancyName(modname) or nil		
		--如果有人禁用了我们的mod或卸载了所有mod（无）。
		if modname == nil or fancy_name == modinfo.name then
			-- 更改回默认的模式 即生存
			screen.server_settings_tab.game_mode.spinner:Enable()
			screen.server_settings_tab.game_mode.spinner:SetOptions(GetGameModesSpinnerData(ModManager:GetEnabledServerModNames()))
			screen.server_settings_tab.game_mode.spinner:SetSelectedIndex(1)
			screen.server_settings_tab.game_mode.spinner:Changed()

	        for i, v in pairs(screen.world_tabs[1].worldsettings_widgets) do
            	v:LoadPreset() --重新载入预设
	        end
			-- 重新打开洞穴选项
			screen.world_tabs[2].isnewshard = true
	        -- screen.world_tabs[2].autoaddcaves.checked = true --开启 自动添加洞穴的默认按钮
	        -- screen.world_tabs[2].autoaddcaves:Refresh()
			-- screen.world_tabs[2]:AddMultiLevel()--添加预设面板
			-- screen.world_tabs[2]:Refresh() --刷新这个还是别了，执行的是覆盖方法
		end
	end	
end

--卸下mod时会执行
ModsTab.OnConfirmEnable = function(self, restart, modname)
	Reset(modname)
	_OnConfirmEnable(self, restart, modname)
end	

-- 返回退出创建世界时执行
ModsTab.Cancel = function(self)
	Reset()
	_Cancel(self)
end

-- 刷新时，有问题，会解锁存档的世界生存选项。我也没办法，暂时不能找到客户端读取有这个mod的存档时，洞穴依旧可以添加，而导致崩
WorldSettingsTab.Refresh = function(self)
	-- 不让客户端显示添加洞穴
	-- self.isnewshard = self.location_index == 1 and true or false
	if self.location_index == 2 then --是洞穴
		self.isnewshard = false
	end
	return _Refresh(self)
end

--设置mod关闭时执行
local old_FrontendUnloadMod = ModManager.FrontendUnloadMod   
ModManager.FrontendUnloadMod = function(self, modname)
	old_FrontendUnloadMod(self, modname)
	local CurrentScreen = TheFrontEnd:GetActiveScreen()    
	if CurrentScreen and CurrentScreen.server_settings_tab then
		local fancy_name = modname and KnownModIndex:GetModFancyName(modname) or nil
		--如果有人禁用了我们的mod或卸载了所有mod（无）。
		if modname == nil or fancy_name == modinfo.name then	
			--恢复原来的
			ModsTab.OnConfirmEnable = _OnConfirmEnable
			ModsTab.Cancel = _Cancel
			ModManager.FrontendUnloadMod = old_FrontendUnloadMod 
			WorldSettingsTab.Refresh = _Refresh
		end
	end
end


if IsTheFrontEnd then
	local CurrentScreen = TheFrontEnd:GetActiveScreen() --获取活动屏幕 ServerSlotScreen存档界面 ServerCreationScreen具体档/新档
    --server_settings_tab 服务器设置选项卡 game_mode游戏模式  enabled启用
	if CurrentScreen and CurrentScreen.server_settings_tab and CurrentScreen.server_settings_tab.game_mode.spinner.enabled then
		-- print("界面名称 ServerCreationScreen",CurrentScreen.name)
                                                            --从mod中添加模式，并设置ui设置选项数据
		CurrentScreen.server_settings_tab.game_mode.spinner:SetOptions(GetGameModesSpinnerData(ModManager:GetEnabledServerModNames()))
                                                            --选定，有就会选定
		CurrentScreen.server_settings_tab.game_mode.spinner:SetSelected("OceanFishing")
                                                            --改变
        CurrentScreen.server_settings_tab.game_mode.spinner:Changed()
        													--锁定值	
        CurrentScreen.server_settings_tab.game_mode.spinner:Disable()
        -- 主是显示
        --world_tabs第几个世界的设置(最多支持2个) worldsettings_widgets世界设置(1世界选项、2世界生成) settingslist设置列表 scroll_list滚动列表 widgets_to_update网格表 opt_spinner选择器
		local scroll_list = CurrentScreen.world_tabs[1].worldsettings_widgets[2].settingslist.scroll_list
		-- 设置生物群落
		scroll_list.widgets_to_update[10].opt_spinner.spinner:SetSelected("cs_sz2")
		scroll_list.widgets_to_update[10].opt_spinner.spinner:Changed()		
		-- 设置出生点
		scroll_list.widgets_to_update[11].opt_spinner.spinner:SetSelected("cs_sl")
		scroll_list.widgets_to_update[11].opt_spinner.spinner:Changed()

        -- 重新加载一次预设
        for i, v in pairs(CurrentScreen.world_tabs[1].worldsettings_widgets) do
        	v:LoadPreset() -- 重新载入预设
        end

        --洞穴设置
        CurrentScreen.world_tabs[2]:RemoveMultiLevel()--删除预设面板
        CurrentScreen.world_tabs[2].isnewshard = false --关闭显示洞穴设置
        CurrentScreen.world_tabs[2].autoaddcaves.checked = false --关闭 自动添加洞穴的默认按钮 希望有用
        -- CurrentScreen.world_tabs[2].autoaddcaves:Refresh() --标签按钮的刷新，显然没有必要
        Profile:SetAutoCavesEnabled(false) --执行的指令 不需要洞穴。
        CurrentScreen.world_tabs[2]:Refresh()--刷新
    end
end