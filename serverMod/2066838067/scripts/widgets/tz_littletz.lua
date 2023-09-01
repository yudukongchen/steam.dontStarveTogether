local Widget = require "widgets/widget"
local Image = require "widgets/image"
local UIAnim = require "widgets/uianim"
local Text = require "widgets/text"
local easing = require("easing")
local config_saved_path = "mod_config_data/tz_littletz_config"
local json = require("json")


local function spawngouyu(self,gouyu)
	if self.owner.fh_ly_gy  then
		local gus = self.owner.fh_ly_gy:value()
		for k = 1 , 6  do
			if gus[k] then
				local image = gus[k] == 1 and "white" or "black"
				self.gouyu[k]:SetTexture("images/inventoryimages/tz_fh_ly_"..image..".xml", "tz_fh_ly_"..image..".tex" )
				self.gouyu[k]:Show()
			else
				self.gouyu[k]:Hide()
			end
		end
	end	
end
local TzLittleTz = Class(Widget, function(self, owner)
	Widget._ctor(self, "TzLittleTz")

	self.owner = owner

	self.tz = self:AddChild(UIAnim())
	self.tz:GetAnimState():SetBank("tz_UI_people")
	self.tz:GetAnimState():SetBuild("tz_UI_people")
	self.tz:GetAnimState():PlayAnimation("action_b_loop",true)

	self.talk_dialog = self:AddChild(UIAnim())
	self.talk_dialog:GetAnimState():SetBank("tz_UI_talk")
	self.talk_dialog:GetAnimState():SetBuild("tz_UI_talk")
	-- self.talk_dialog:GetAnimState():PlayAnimation("talk_pre")
	self.talk_dialog:SetScale(1.25,1.25)
	self.talk_dialog:SetPosition(-60,70)
	self.talk_dialog:Hide()

	----======================

	self.gouyu = self:AddChild(Widget())
	for k = 1 , 6 do
		self.gouyu[k] = self.gouyu:AddChild(Image())
		self.gouyu[k]:SetPosition(-160+35*k, 170)
		self.gouyu[k]:SetScale(0.6)	
	end

	spawngouyu(self,self.gouyu)
	self.inst:ListenForEvent("fh_ly_gydrity",function()
		spawngouyu(self,self.gouyu)
	end,self.owner)
	----======================

	self.talk_history = {}

	self.inst:WatchWorldState("phase",function()
		local phase = TheWorld.state.phase
		local moonphase = TheWorld.state.moonphase
		if string.find(phase,"dusk") then
			self.dusk_do_e_task = self.inst:DoTaskInTime(30,function()
				self:Yawn()
				self.dusk_do_e_task = nil 
			end)

			-- 月圆
			if moonphase == "full" then 
				self:DoTalk("image-7")
			end
		else
			if self.dusk_do_e_task then 
				self.dusk_do_e_task:Cancel()
				self.dusk_do_e_task = nil 
			end 
			if string.find(phase,"night") then
				if math.random() <= 0.15 then 
					if moonphase == "new" then 
						self:DoTalk("image-9")
					else
						self:DoTalk("image-4")
					end
				else
					self:Yawn()
				end 
			elseif string.find(phase,"day") then 
				self:DoTalk("image-3")
			end 

		end
	end)
end)

function TzLittleTz:OnGainFocus()
	TzLittleTz._base.OnGainFocus(self)

	self.last_gain_focus_time = GetTime()
	self.do_anim_a_task = self.inst:DoTaskInTime(0.5,function()
		if not self:IsTalking() and self:GetAnimPhase() ~= "c" and self:GetAnimPhase() ~= "d" and self:GetAnimPhase() ~= "e"
		and not self.tz:GetAnimState():IsCurrentAnimation("action_b_pst") then 
			self.tz:GetAnimState():PlayAnimation("action_a_pre")
			self.tz:GetAnimState():PushAnimation("action_a_loop",true)
		end 
		self.do_anim_a_task = nil 
	end)
end

function TzLittleTz:OnLoseFocus()
	TzLittleTz._base.OnLoseFocus(self)
	if self.do_anim_a_task then 
		self.do_anim_a_task:Cancel()
		self.do_anim_a_task = nil 
	end 

	if self.tz:GetAnimState():IsCurrentAnimation("action_a_loop") then 
		self.tz:GetAnimState():PlayAnimation("action_a_pst")
		self.tz:GetAnimState():PushAnimation("action_b_loop",true)
	end
end



function TzLittleTz:OnMouseButton(button, down, x, y)
	TzLittleTz._base.OnMouseButton(self,button, down, x, y)
	-- button MOUSEBUTTON_LEFT
	if down then 
		if button == MOUSEBUTTON_LEFT then 
			local lie_down = true 

			if self.tz:GetAnimState():IsCurrentAnimation("action_c_loop") then 
				-- 回来
				-- print("TzLittleTz Get up!")
				self.tz:GetAnimState():PlayAnimation("action_b_pre")
				self.tz:GetAnimState():PushAnimation("action_b_loop",true)
				self:DoTalk("image-12",nil,true)

				lie_down = false 
			elseif self:GetAnimPhase() ~= "c" and self:GetAnimPhase() ~= "d" and self:GetAnimPhase() ~= "e" then 
				-- 抚摸动画
				-- print("TzLittleTz lie down!")

				self.tz:GetAnimState():PlayAnimation("action_b_pst")
				self.tz:GetAnimState():PushAnimation("action_c_loop",true)

				lie_down = true 
			end

			local saved_config = {
				shown = ThePlayer.HUD.controls.TzLittleTz.shown,
				lie_down = lie_down,
			}


			TheSim:SetPersistentString(config_saved_path,
									json.encode(saved_config),
									false)
		elseif button == MOUSEBUTTON_RIGHT then 
			VisitURL("https://wiki.flapi.cn/doku.php?id=02%E8%81%94%E6%9C%BAmod%E5%8C%BA:%E5%A4%AA%E7%9C%9F:0%E9%A6%96%E9%A1%B5")
		end 
	end 
	return true
end

-- ThePlayer.HUD.controls.TzLittleTz:DoTalk("image-0")
function TzLittleTz:DoTalk(img_override,cd,no_anim)
	if self:GetAnimPhase() == "c" or self:GetAnimPhase() == "a" then 
		return 
	end 

	if cd and self.talk_history[img_override] and GetTime() - self.talk_history[img_override] < cd then 
		--print("DoTalk not suit time and cd:",GetTime() - self.talk_history[img_override],cd)
		return
	else
		self.talk_history[img_override] = GetTime()
	end

	if not no_anim then 
		self.tz:GetAnimState():PlayAnimation("action_d")
		self.tz:GetAnimState():PushAnimation("action_b_loop",true)
	end 
	
	if img_override then 
		self.talk_dialog:Show()
		self.talk_dialog:GetAnimState():OverrideSymbol("image-0","tz_UI_talk",img_override)
		self.talk_dialog:GetAnimState():PlayAnimation("talk_pre")
		self.talk_dialog:GetAnimState():PushAnimation("talk_loop",false)
		self.talk_dialog:GetAnimState():PushAnimation("talk_pst",false)

		if self.talk_dialog_hide_task then 
			self.talk_dialog_hide_task:Cancel()
		end 

		self.talk_dialog_hide_task = self.inst:DoTaskInTime(3.866,function()
			self.talk_dialog:Hide()
			self.talk_dialog_hide_task = nil 
		end)
	end 
end

function TzLittleTz:Yawn()
	if not self:IsTalking() and self:GetAnimPhase() ~= "d" and self:GetAnimPhase() ~= "c" and self:GetAnimPhase() ~= "a" then 
		self.tz:GetAnimState():PlayAnimation("action_e")
		self.tz:GetAnimState():PushAnimation("action_b_loop",true)
	end 
end

function TzLittleTz:OnShow()
	TheSim:GetPersistentString(config_saved_path,function(load_success, str)

		local saved_config = {
			shown = true,
			lie_down = true,
		}

		if load_success then
			saved_config = json.decode(str)
		end

		if saved_config.lie_down then
			self.tz:GetAnimState():PlayAnimation("action_c_loop",true)
		else 
			self.tz:GetAnimState():PlayAnimation("action_b_loop",true)
		end
	end)
	
	
end

function TzLittleTz:IsTalking()
	return self:GetAnimPhase() == "d" or self.talk_dialog.shown
end

function TzLittleTz:GetAnimPhase()
	if self.tz:GetAnimState():IsCurrentAnimation("action_a_pre") or 
		self.tz:GetAnimState():IsCurrentAnimation("action_a_loop") or 
		self.tz:GetAnimState():IsCurrentAnimation("action_a_pst") then 
		return "a" --Mouse moving...
	end 

	if self.tz:GetAnimState():IsCurrentAnimation("action_b_pre") or 
		self.tz:GetAnimState():IsCurrentAnimation("action_b_loop") or 
		self.tz:GetAnimState():IsCurrentAnimation("action_b_pst") then 
		return "b" --normal
	end 

	if self.tz:GetAnimState():IsCurrentAnimation("action_c_loop") then 
		return "c" --under
	end 

	if self.tz:GetAnimState():IsCurrentAnimation("action_d") then 
		return "d" --talk
	end 

	if self.tz:GetAnimState():IsCurrentAnimation("action_e") then 
		return "e" --yawm
	end 

end

return TzLittleTz