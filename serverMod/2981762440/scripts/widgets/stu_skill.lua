local Widget = require "widgets/widget"
local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local UIAnim = require "widgets/uianim"
local Text = require "widgets/text"
local easing = require "easing"
 
local Stu_Skill = Class(Widget, function(self, owner)
    Widget._ctor(self, "Stu_Skill")

    self.inst:DoPeriodicTask(0.1, function(inst)
        if owner:HasTag("playerghost") then
            self:Hide()
        else
            self:Show()            
        end 
    end)

    self._onanimover1 = function() self.circular_meter1:Hide() end
    self._onanimover2 = function() self.circular_meter2:Hide() end
    self._onanimover3 = function() self.circular_meter3:Hide() end  
  
    self.image_1 = self:AddChild(ImageButton("images/skill/stu_skill1.xml", "stu_skill1.tex"))
    self.image_1:SetPosition(450, 150, 0)
    self.image_1:SetScale(0.4, 0.4, 0.4)
    self.image_1:SetOnClick(function()
    local in_1_cd = owner and owner:HasTag("skill1_cd") or false       
    if owner and owner:HasTag("stu") and owner.replica.inventory and owner.replica.inventory:EquipHasTag("stu_chainsaw") 
    and not owner:HasTag("playerghost") then
        SendModRPCToServer(MOD_RPC["STU_Skill1"]["STU_Skill1"], in_1_cd)
    end  
    end) 

    self.image_2 = self:AddChild(ImageButton("images/skill/stu_skill2.xml", "stu_skill2.tex"))
    self.image_2:SetPosition(550, 150, 0)
    self.image_2:SetScale(0.4, 0.4, 0.4)
    self.image_2:SetOnClick(function()
    local in_2_cd = owner and owner:HasTag("skill2_cd") or false    
    if owner and owner:HasTag("stu") and owner.replica.inventory and owner.replica.inventory:EquipHasTag("stu_chainsaw") 
    and not owner:HasTag("playerghost") then
        SendModRPCToServer(MOD_RPC["STU_Skill2"]["STU_Skill2"], in_2_cd)
    end  
    end) 

    self.image_3 = self:AddChild(ImageButton("images/skill/stu_skill3.xml", "stu_skill3.tex"))
    self.image_3:SetPosition(650, 150, 0)
    self.image_3:SetScale(0.4, 0.4, 0.4)
    self.image_3:SetOnClick(function()
    local in_3_cd = owner and owner:HasTag("skill3_cd") or false     
    if owner and owner:HasTag("stu") and owner.replica.inventory and owner.replica.inventory:EquipHasTag("stu_chainsaw") 
    and not owner:HasTag("playerghost") then
        SendModRPCToServer(MOD_RPC["STU_Skill3"]["STU_Skill3"], in_3_cd)
    end  
    end) 

    self.circular_meter2 = self:AddChild(UIAnim())
    --self.circular_meter1:SetScale(2, 2, 2)
    self.circular_meter2:SetPosition(550, 150, 0)
    self.circular_meter2:GetAnimState():SetBank( "status_meter_circle")
    self.circular_meter2:GetAnimState():SetBuild("status_meter_circle")
    self.circular_meter2:GetAnimState():SetMultColour(0, 0, 0, 0.6)
    self.circular_meter2:GetAnimState():PlayAnimation("meter", true)
    self.circular_meter2:Hide()

    self.circular_meter3 = self:AddChild(UIAnim())
    --self.circular_meter1:SetScale(2, 2, 2)
    self.circular_meter3:SetPosition(650, 150, 0)
    self.circular_meter3:GetAnimState():SetBank( "status_meter_circle")
    self.circular_meter3:GetAnimState():SetBuild("status_meter_circle")
    self.circular_meter3:GetAnimState():SetMultColour(0, 0, 0, 0.6)
    self.circular_meter3:GetAnimState():PlayAnimation("meter", true)
    self.circular_meter3:Hide()

    self.image_1_text = self:AddChild(Text(BODYTEXTFONT, 40, " ")) 
    self.image_1_text:SetPosition(453, 150, 0)
    self.image_1_text:Hide()    

    self.image_2_text = self:AddChild(Text(BODYTEXTFONT, 40, " ")) 
    self.image_2_text:SetPosition(553, 150, 0)
    self.image_2_text:Hide()   

    self.image_3_text = self:AddChild(Text(BODYTEXTFONT, 40, " ")) 
    self.image_3_text:SetPosition(653, 150, 0)
    self.image_3_text:Hide()  

    self.image_1.OnGainFocus = function() 
        self.image_1_text:Show()  
    end

    self.image_1.OnLoseFocus = function()  
        self.image_1_text:Hide() 
    end 

    self.image_2.OnGainFocus = function() 
        self.image_2_text:Show()  
    end

    self.image_2.OnLoseFocus = function()  
        self.image_2_text:Hide()  
    end 

    self.image_3.OnGainFocus = function()
        self.image_3_text:Show() 
    end

    self.image_3.OnLoseFocus = function()  
        self.image_3_text:Hide()  
    end

    self:StartUpdating()  
end)

function Stu_Skill:OnUpdate(dt)
    if ThePlayer and ThePlayer:HasTag("stu") then 
        self.image_1_text:SetString(ThePlayer._skill1_Cd:value())
        self.image_2_text:SetString(ThePlayer._skill2_Cd:value())
        self.image_3_text:SetString(ThePlayer._skill3_Cd:value())

        if not ThePlayer:HasTag("playerghost") then
            local skill1 = (ThePlayer._sp_level:value() and ThePlayer._sp_level:value() >= 1) or false

            if skill1 == true then
                self.image_2:Show()
            else 
                self.image_2:Hide()               
            end

            local skill2 = (ThePlayer._sp_level:value() and ThePlayer._sp_level:value() >= 2) or false
            if skill2 == true then
                self.image_3:Show()
            else 
                self.image_3:Hide()               
            end                  
        end                  
    end   
end


return Stu_Skill