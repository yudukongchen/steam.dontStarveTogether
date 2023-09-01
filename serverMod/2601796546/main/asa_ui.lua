--HUD显示

-- AddClassPostConstruct("widgets/crafttabs", function(self)
    
-- end)

-- --技能面板
-- AddPopup("ASASKILLPANEL")
-- POPUPS.ASASKILLPANEL.fn = function(inst, show)
    -- if inst.HUD then
        -- if not show then
            -- inst.HUD:ClosePanel()
        -- elseif not inst.HUD:OpenPanel() then
            -- POPUPS.ASASKILLPANEL:Close(inst)
        -- end
    -- end
-- end

---各类UI添加
local Asa_Pw = require("widgets/asa_ui")
local asa_maxvision = require "widgets/asa_maxvision"
local asa_zanvision = require "widgets/asa_zanvision"
local AsaPanel = require "widgets/asapanel"
AddClassPostConstruct("screens/playerhud", function(self)
	function self:OpenAsaBar()
		if not self.asapwbar then
			if self.owner and self.owner:HasTag("asakiri") then
				self.asapwbar = self:AddChild(Asa_Pw(self.owner))
			end
		else
			self.asapwbar:Show()
		end
	end
	
	function self:CloseAsaBar()
		if self.owner:IsValid() then
			if self.asapwbar then
				self.asapwbar:Hide()
			end
		end
	end
	
	function self:OpenPanel()
		if not self.asapanel and self.owner:HasTag("asakiri") then
			self.asapanel = self:AddChild(AsaPanel(self.owner))
			local pos1 = Vector3(0, -400, 0)
			local repos = Vector3(0,0,0)
			self.asapanel.base:MoveTo(pos1, repos, 0.35)
		else
			self.asapanel:Show()
			local pos1 = Vector3(0, -400, 0)
			local repos = Vector3(0,0,0)
			self.asapanel.base:MoveTo(pos1, repos, 0.35)
		end
	end
	
    function self:ClosePanel()
		if self.owner:IsValid() then
			self.asapanel:Hide()
		end
	end
	
	local old_CreateOverlays = self.CreateOverlays
	function self:CreateOverlays(owner)
		old_CreateOverlays(self,owner)
		self.asa_zanvision = self.overlayroot:AddChild(asa_zanvision(owner))
		self.asa_maxvision = self.overlayroot:AddChild(asa_maxvision(owner))
		if owner:HasTag("asakiri") then
			owner:ListenForEvent("AsaBar", function()
				owner.HUD:OpenAsaBar()
			end)
		end
	end
end)

