local Widget = require "widgets/widget"
local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"
local Text = require "widgets/text"
local Image = require "widgets/image"

local tz_rskill = require "widgets/tz_rskill"
local tz_gskill = require "widgets/tz_gskill"

local function IsHUDScreen()
	local s = TheFrontEnd:GetActiveScreen()
	if s then
		if s:IsEditing() then
			return false
		elseif type(s.name)  == "string" and s.name == "HUD" then
			return true
		end
	end
	return false
end

local tz_skillui = Class(Widget, function(self, owner)
	Widget._ctor(self, "tz_skillui")
	self.owner = owner
	self.handler = {}
	self.bg = self:AddChild(Widget("tz_skilluibg"))
	
	self.handler["key_z"] = TheInput:AddKeyDownHandler(KEY_P, function()
        if not IsHUDScreen() then return end
        if self.inst:IsValid() then
            SendModRPCToServer(MOD_RPC["tz_skill"]["Z"])
        end
	end)
	self.handler["key_g"] = TheInput:AddKeyDownHandler(TUNING.TZSAN.GRSKKEY, function()
        if not IsHUDScreen() then return end
		if self.Gcd then return end
					
		if owner:IsValid() then
			if self.gskill ~= nil then 
				if not self.gskill.cd then
					SendModRPCToServer(MOD_RPC["tz_skill"]["G"])
					self.Gcd =  true
					self.inst:DoTaskInTime(1, function() self.Gcd = false end)
				elseif self.owner.components.talker then
					self.owner.components.talker:Say("技能冷却中")
				end
			end
        end
	end)
	self.handler["key_r"] = TheInput:AddKeyDownHandler(TUNING.TZSAN.LLSKKEY, function()
        if not IsHUDScreen() then return end
		if self.Rcd then return end
		if owner:IsValid() then
			if self.rskill ~= nil then
				if not self.rskill.cd then
					SendModRPCToServer(MOD_RPC["tz_skill"]["R"])
					self.Rcd =  true
					self.inst:DoTaskInTime(1, function() self.Rcd = false end)
				elseif self.owner.components.talker then
					self.owner.components.talker:Say("技能冷却中")
				end				
			end
        end
	end)	
	self.handler["key_alt"] = TheInput:AddKeyDownHandler(KEY_LALT, function()
        if not IsHUDScreen() then 
			return 
		end
		if owner:IsValid() then
			SendModRPCToServer(MOD_RPC["tz_skill"]["Alt"])
		end
	end)

	self.handler["key_f2"] = TheInput:AddKeyDownHandler(KEY_F2, function()--KEY_F2
        if not IsHUDScreen() then 
			return 
		end
		if owner:IsValid() then
			SendModRPCToServer(MOD_RPC["tz_skill"]["f2"])
		end
	end)
	self.handler["key_j"] = TheInput:AddKeyDownHandler(KEY_J, function()--KEY_J
        if not IsHUDScreen() then 
			return 
		end
		if owner:IsValid() and owner.replica.inventory and owner.replica.inventory:EquipHasTag("tz_fhbm") then
			SendModRPCToServer(MOD_RPC["tz_skill"]["j"])
		end
	end)

	self.handler["92"] = TheInput:AddKeyDownHandler(KEY_BACKSLASH, function()--KEY_J
        if not IsHUDScreen() then 
			return 
		end
		if owner:IsValid() and owner.replica.inventory and owner.replica.inventory:EquipHasTag("tz_fh_ht_map") then
			if owner and owner.HUD then
            	if not owner.HUD:IsMapScreenOpen() then
					owner.HUD:CloseCrafting()
					owner.HUD:CloseSpellWheel()
                	if owner.HUD:IsControllerInventoryOpen() then
                	    owner.HUD:CloseControllerInventory()
                	end
           	 	end
				owner.HUD.controls:ToggleMap()
				owner.tz_fh_ht_map =  true
			end
		end
	end)

	self.inst:ListenForEvent("onremove", function()
		for k,v in pairs(self.handler) do
			v:Remove()
		end
	end)
	
	self.inst:ListenForEvent("tzsamamaxdirty", function()
		local maxsama = self.owner._tzsamamax:value() or 100
		if maxsama >= 250 and not self.gskill then
			self.gskill = self.bg:AddChild(tz_gskill(self.owner))
			self.gskill:SetPosition(-150,20,0) --G技能
			self.gskill:Start()
		end
	end, self.owner)
	
	self.inst:ListenForEvent("tz_xx_leveldrity", function()
		local maxlevel = self.owner.tz_xx_level:value() or 0
		if maxlevel > 9 and not self.rskill then
			self.rskill = self.bg:AddChild(tz_rskill(self.owner))
			self.rskill:SetPosition(0,20,0) --R技能
			self.rskill:Start()
		end
	end, self.owner)
end)

return tz_skillui