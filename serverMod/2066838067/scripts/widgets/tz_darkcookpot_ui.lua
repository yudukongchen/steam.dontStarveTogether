local InvSlot = require "widgets/invslot"
local Widget = require "widgets/widget"
local Text = require "widgets/text"
local UIAnim = require "widgets/uianim"
local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local ItemTile = require "widgets/itemtile"

local TzDarkCookpotUtil = require"tz_darkcookpot_util"

local TzDarkCookpotUI = Class(Widget, function(self, owner,cookpot_ent)
    Widget._ctor(self, "TzDarkCookpotUI")
    self.owner = owner
    self.cookpot_ent = cookpot_ent

    self.enable_tips = true
    self.predict_images = {}

    self.predict_label = self:AddChild(Text(FALLBACK_FONT_FULL, 42))
    self.predict_label:SetPosition(400,0,0)
    self.predict_label:Hide()

    self:AddBar("bar_up","bar_first","tip_first",Vector3(350,0,0))
    self:AddBar("bar_middle","bar_second","tip_second",Vector3(-340,0,0))
    self:AddBar("bar_down","bar_third","tip_third",Vector3(350,0,0))

    self.fire = self:AddChild(UIAnim())
    self.fire:GetAnimState():SetBank("tz_dark_cookpot_ui")
    self.fire:GetAnimState():SetBuild("tz_dark_cookpot_ui")
    self.fire:GetAnimState():PlayAnimation("fire",true)
    self.fire:GetAnimState():SetDeltaTimeMultiplier(0.8)
    self.fire:SetScale(0.01,0.01)
    self.fire:Hide()
    self.fire:MoveToBack()

    self._do_predict = function()
        self:Predict()
    end

    self.inst:ListenForEvent("itemget",self._do_predict,cookpot_ent)
    self.inst:ListenForEvent("itemlose",self._do_predict,cookpot_ent)

    self:Predict()

    TUNING.TZPOTUI = self

    TheFocalPoint.SoundEmitter:PlaySound("dontstarve/HUD/craft_open")
end)

TUNING.TZBAR = {
	UP = 90,
	MIDDLE = -75,
	DOWN = 80,
}

local SHAKE_DIST = -15
-- TUNING.TZBAR.UP = 90

function TzDarkCookpotUI:AddBar(bar_name,anim_name,tip_animname,tippos)
	local tip_name = bar_name.."_tip"
	self[bar_name] = self:AddChild(UIAnim())
    self[bar_name]:GetAnimState():SetBank("tz_dark_cookpot_ui")
    self[bar_name]:GetAnimState():SetBuild("tz_dark_cookpot_ui")
    self[bar_name]:GetAnimState():PlayAnimation(anim_name)
    self[bar_name]:SetClickable(true)

    self[tip_name] = self[bar_name]:AddChild(UIAnim())
    self[tip_name]:GetAnimState():SetBank("tz_dark_cookpot_ui")
    self[tip_name]:GetAnimState():SetBuild("tz_dark_cookpot_ui")
    self[tip_name]:GetAnimState():PlayAnimation(tip_animname)
    self[tip_name]:SetPosition(tippos:Get())
    self[tip_name]:SetScale(1.5,1.5,1.5)
    self[tip_name]:Hide()

    self[bar_name]:SetOnGainFocus(function()
        if self.enable_tips then 
    	   self[tip_name]:Show()
        end 
    end)

    self[bar_name]:SetOnLoseFocus(function()
    	self[tip_name]:Hide()
    end)
end

function TzDarkCookpotUI:SlideIn()
	self.bar_up:MoveTo(Vector3(800,175,0),Vector3(TUNING.TZBAR.UP+SHAKE_DIST,175,0),0.278,function()
		self.bar_up:MoveTo(Vector3(TUNING.TZBAR.UP+SHAKE_DIST,175,0),Vector3(TUNING.TZBAR.UP,175,0),0.2)
	end)

	self.bar_middle:MoveTo(Vector3(800,0,0),Vector3(TUNING.TZBAR.MIDDLE+SHAKE_DIST,0,0),0.535,function()
		self.bar_middle:MoveTo(Vector3(TUNING.TZBAR.MIDDLE+SHAKE_DIST,0,0),Vector3(TUNING.TZBAR.MIDDLE,0,0),0.2)
	end)

	self.bar_down:MoveTo(Vector3(800,-175,0),Vector3(TUNING.TZBAR.DOWN+SHAKE_DIST,-175,0),0.7,function()
		self.bar_down:MoveTo(Vector3(TUNING.TZBAR.DOWN+SHAKE_DIST,-175,0),Vector3(TUNING.TZBAR.DOWN,-175,0),0.2)
		self.fire:Show()
		self.fire:ScaleTo(0.01,3.75,0.4)
	end)
end

local function SlideOutSingle(ui,targetPos,time,finishfn)
	ui:CancelMoveTo()
	ui:MoveTo(ui:GetPosition(),targetPos,time,finishfn)
end
function TzDarkCookpotUI:SlideOut()
	-- self:Kill()
    self.enable_tips = false
    self.predict_label:Hide()
    for k,v in pairs(self.predict_images) do 
        v:Hide()
    end
	self.fire:ScaleTo(3.75,0.01,0.3)
	SlideOutSingle(self.bar_up,Vector3(-1500,175,0),0.3)
	SlideOutSingle(self.bar_middle,Vector3(-1750,0,0),0.3)
	SlideOutSingle(self.bar_down,Vector3(-2000,-175,0),0.3,function()
		if self.parent then 
			self.parent:RemoveChild(self)
		end
		self:Kill()
	end)
end

function TzDarkCookpotUI:Predict()
    local products = TzDarkCookpotUtil.PredictRecipe(self.cookpot_ent)
    self.predict_label:SetString(PrintTable(products))

    for k,v in pairs(self.predict_images) do 
        v:Kill()
    end
    self.predict_images = {}


    local items_cnt = 0
    local items_in_container = self.cookpot_ent.replica.container:GetItems()
    for k,v in pairs(items_in_container) do 
        if v ~= nil then 
            items_cnt = items_cnt + 1
        end
    end
    if items_cnt >= 4 then 
        local BASE_DESC_POS = Vector3(50,350,0)
        local DELTA_DESC_POS = Vector3(0,200,0)
        for k,v in pairs(products) do 
            local desc_ui_path = "images/tzui/darkvision_food_desc/"..v..".xml"
            local has_path = softresolvefilepath(desc_ui_path) ~= nil 
            if has_path then 
                local DescImage = self:AddChild(Image(desc_ui_path, v..".tex"))
                DescImage:SetPosition((BASE_DESC_POS + DELTA_DESC_POS * #self.predict_images):Get())
                DescImage:SetScale(1.2,1.2)
                table.insert(self.predict_images,DescImage)
            else

            end
        end
    end 

end


return TzDarkCookpotUI