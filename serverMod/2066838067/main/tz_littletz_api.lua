local APIAssets = {
	Asset("ANIM", "anim/tz_UI_people.zip"),
	Asset("ANIM", "anim/tz_UI_talk.zip"),
}

for k,v in pairs(APIAssets) do
	table.insert(Assets, v)
end


local json = require("json")
local TzLittleTz = require "widgets/tz_littletz"
local Text = require "widgets/text"
local config_saved_path = "mod_config_data/tz_littletz_config"
AddClassPostConstruct("widgets/controls", function(self)
	if self.owner:HasTag("taizhen") then 
		self.TzLittleTz = self:AddChild(TzLittleTz(self.owner))
		self.TzLittleTz:SetVAnchor(ANCHOR_BOTTOM)
		self.TzLittleTz:SetHAnchor(ANCHOR_RIGHT)

		self.TzLittleTz:SetPosition(-70,-10)
		self.TzLittleTz:MoveToFront()

		TheSim:GetPersistentString(config_saved_path,function(load_success, str)
			if load_success then

				local config = json.decode(str)
				if config.shown then
					self.TzLittleTz:Show()
				else
					self.TzLittleTz:Hide()
				end
			else 
				self.TzLittleTz:Show()
			end
		end)

		-- ThePlayer.HUD.controls.test_font:SetFont()
		-- self.test_font = self:AddChild(Text(DEFAULTFONT, 42))

		-- self.test_font:SetHAnchor(ANCHOR_MIDDLE)
		-- self.test_font:SetVAnchor(ANCHOR_MIDDLE)

		-- self.test_font:SetString("我是一只小太真，\nLepLipo frog !!!")

		-- self.test_font2 = self:AddChild(Text(DEFAULTFONT, 66))

		-- self.test_font2:SetHAnchor(ANCHOR_MIDDLE)
		-- self.test_font2:SetVAnchor(ANCHOR_MIDDLE)

		-- self.test_font2:SetString("我是一只小太真，\nLepLipo frog !!!")

		-- self.test_font2:SetPosition(0,300)
	end 
end) 

TheInput:AddKeyDownHandler(KEY_F9,function()
	if not TheNet:IsDedicated() then 
		if rawget(GLOBAL,"ThePlayer") and ThePlayer:IsValid() then
			if ThePlayer.HUD.controls.TzLittleTz then 
				if ThePlayer.HUD.controls.TzLittleTz:IsVisible() then 
					ThePlayer.HUD.controls.TzLittleTz:Hide()
				else
					ThePlayer.HUD.controls.TzLittleTz:Show()
				end
				
				TheSim:GetPersistentString(config_saved_path,function(load_success, str)

					local saved_config = {
						shown = true,
						lie_down = true,
					}

					if load_success then
						saved_config = json.decode(str)
					end

					saved_config.shown = ThePlayer.HUD.controls.TzLittleTz.shown 
					saved_config.lie_down = true 
					
					TheSim:SetPersistentString(config_saved_path,
											json.encode(saved_config),
											false)
				end)
				
			end 
		end
	end
end)

-- SendModRPCToClient(CLIENT_MOD_RPC["tz_littletz"]["dotalk"],ThePlayer.userid,"image-10")
AddClientModRPCHandler("tz_littletz","dotalk",function(override_image,cd,no_anim)
	if ThePlayer and ThePlayer:IsValid() 
	and ThePlayer.HUD and ThePlayer.HUD.controls and ThePlayer.HUD.controls.TzLittleTz
	and ThePlayer.HUD.controls.TzLittleTz:IsVisible() then 
		ThePlayer.HUD.controls.TzLittleTz:DoTalk(override_image,cd,no_anim)
	end
end)

AddPlayerPostInit(function(inst)
	if not TheWorld.ismastersim then 
		return inst
	end 

	if inst:HasTag("taizhen") then 
		inst:DoTaskInTime(3,function()
			if inst.components.age:GetAge() <= 10 then 
				SendModRPCToClient(CLIENT_MOD_RPC["tz_littletz"]["dotalk"],inst.userid,"image-13")
				inst:DoTaskInTime(3.866,function()
					SendModRPCToClient(CLIENT_MOD_RPC["tz_littletz"]["dotalk"],inst.userid,"image-14")
				end)
			else
				SendModRPCToClient(CLIENT_MOD_RPC["tz_littletz"]["dotalk"],inst.userid,"image-16")
			end
		end)

		inst:ListenForEvent("tzsamadelta",function(inst,data)
			local old_val = data.oldpercent * inst.components.tzsama.max
			local new_val = data.newpercent * inst.components.tzsama.max
			if new_val < 50 and old_val >= 50 then 
				SendModRPCToClient(CLIENT_MOD_RPC["tz_littletz"]["dotalk"],inst.userid,"image-0")
			end
		end)

		inst:ListenForEvent("houndwarning",function(inst,warn_level)
			if warn_level == HOUNDWARNINGTYPE.LVL1 
				or warn_level == HOUNDWARNINGTYPE.LVL2 
				or warn_level == HOUNDWARNINGTYPE.LVL3 
				or warn_level == HOUNDWARNINGTYPE.LVL4 then
				SendModRPCToClient(CLIENT_MOD_RPC["tz_littletz"]["dotalk"],inst.userid,"image-1",12)
	        elseif warn_level == HOUNDWARNINGTYPE.LVL1_WORM 
	        	or warn_level == HOUNDWARNINGTYPE.LVL2_WORM 
	        	or warn_level == HOUNDWARNINGTYPE.LVL3_WORM 
	        	or warn_level == HOUNDWARNINGTYPE.LVL4_WORM then
	        	SendModRPCToClient(CLIENT_MOD_RPC["tz_littletz"]["dotalk"],inst.userid,"image-2",12)
	        end
	        print("houndwarning",warn_level)
		end)
	end
end)

for i=1,4 do 
	AddPrefabPostInit("beargerwarning_lvl"..tostring(i),function(inst)
		if not TheNet:IsDedicated() and rawget(GLOBAL,"ThePlayer") and ThePlayer:IsValid() and ThePlayer.HUD and ThePlayer.HUD.controls and ThePlayer.HUD.controls.TzLittleTz then
			ThePlayer.HUD.controls.TzLittleTz:DoTalk("image-5",15)
		end
	end)

	AddPrefabPostInit("deerclopswarning_lvl"..tostring(i),function(inst)
		if not TheNet:IsDedicated() and rawget(GLOBAL,"ThePlayer") and ThePlayer:IsValid() and ThePlayer.HUD and ThePlayer.HUD.controls and ThePlayer.HUD.controls.TzLittleTz then
			ThePlayer.HUD.controls.TzLittleTz:DoTalk("image-6",15)
		end
	end)
end

AddComponentPostInit("sinkholespawner",function(self)
	local old_DoTargetWarning = self.DoTargetWarning
	self.DoTargetWarning = function(self,targetinfo,...)
		if targetinfo.warnings ~= nil and ((targetinfo.warnings or 0) % 4 == 0) and targetinfo.player ~= nil and targetinfo.player:IsValid() then
			if not TheWorld:HasTag("cave") then 
				SendModRPCToClient(CLIENT_MOD_RPC["tz_littletz"]["dotalk"],targetinfo.player.userid,"image-8",10)
			else
           		SendModRPCToClient(CLIENT_MOD_RPC["tz_littletz"]["dotalk"],targetinfo.player.userid,"image-10",10)
           	end 
        end
		return old_DoTargetWarning(self,targetinfo,...)
	end
end)

AddPrefabPostInit("cave",function(inst)
	if not TheWorld.ismastersim then 
		return inst
	end 

	inst:ListenForEvent("warnquake",function()
		for k,v in pairs(AllPlayers) do 
			SendModRPCToClient(CLIENT_MOD_RPC["tz_littletz"]["dotalk"],v.userid,"image-11",8)
		end
	end)

	inst:ListenForEvent("resetruins",function()
		for k,v in pairs(AllPlayers) do 
			SendModRPCToClient(CLIENT_MOD_RPC["tz_littletz"]["dotalk"],v.userid,"image-15")
		end
	end)
end)

-- ThePlayer.HUD.controls.test_font:SetFont(TITLEFONT)
-- CHATFONT	true	
-- CHATFONT_OUTLINE	true	
-- SMALLNUMBERFONT	true	
-- NEWFONT_OUTLINE	true	
-- FALLBACK_FONT_FULL_OUTLINE	true	
-- TALKINGFONT_HERMIT	true	
-- FALLBACK_FONT_OUTLINE	true	
-- TITLEFONT	true	
-- TALKINGFONT_TRADEIN	true	
-- NUMBERFONT	true	
-- DIALOGFONT	true	
-- NEWFONT_SMALL	true	
-- CODEFONT	true	
-- FALLBACK_FONT_FULL	true	
-- HEADERFONT	true	
-- NEWFONT	true	
-- FALLBACK_FONT	true	
-- NEWFONT_OUTLINE_SMALL	true	
-- TALKINGFONT	true	
-- DEFAULTFONT	true	
-- UIFONT	true	
-- BODYTEXTFONT	true	
-- TALKINGFONT_WORMWOOD	true	
-- BUTTONFONT	true	