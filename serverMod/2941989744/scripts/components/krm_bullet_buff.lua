local function OnKill(inst, data)
    local self = inst.components.xiaoyin_level or nil  --print(ThePlayer.components.xiaoyin_level.current)
    local victim = data and data.victim
    if victim == nil or (victim and victim:HasTag("wall")) or (victim and victim:HasTag("lb_hound")) or (victim and victim.prefab == "lureplant") then
        return 
    end
    if victim and victim.prefab == "klaus" and victim:IsUnchained() == false then return end

    if self and victim.components.health then
        local del = math.floor(victim.components.health.maxhealth * 0.05)
        self:ExpDel(del) 
    end       
end 

local Krm_Bullet_Buff = Class(function(self, inst)
    self.inst = inst
    self.buff1 = 0

    --self.inst:ListenForEvent("killed", OnKill)
end)
--

function Krm_Bullet_Buff:OnSave()

end

function Krm_Bullet_Buff:OnLoad(data)

end

function Krm_Bullet_Buff:RemoveBuff1_Task()
    if self.inst.krm_bullet_buff_task1 then
        self.inst.krm_bullet_buff_task1:Cancel()
        self.inst.krm_bullet_buff_task1 = nil
    end 
end

function Krm_Bullet_Buff:RemoveBuff1()  --print(ThePlayer.components.krm_bullet_buff.buff1)
    local inst = self.inst               
    self.buff1 = false 
    --print("移除了buff")

    if not inst:HasTag("fastbuilder_new") then
        inst:RemoveTag("fastbuilder")
    else  
        inst:RemoveTag("fastbuilder_new")        
    end

    if not inst:HasTag("expertchef_new") then
        inst:RemoveTag("expertchef")
    else    
        inst:RemoveTag("expertchef_new")        
    end

    if not inst:HasTag("quagmire_fasthands_new") then
        inst:RemoveTag("quagmire_fasthands")
    else    
        inst:RemoveTag("quagmire_fasthands_new")        
    end

    if inst.components.workmultiplier then
        inst.components.workmultiplier:RemoveMultiplier(ACTIONS.CHOP,   inst)
        inst.components.workmultiplier:RemoveMultiplier(ACTIONS.MINE,   inst)
    end    

    if inst.components.locomotor then
        inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "krm_bullet_buff1")
    end

    if inst.components.oldager then
        inst.components.oldager.rate = 1
    end  

    self:RemoveBuff1_Task()    
end

function Krm_Bullet_Buff:GetBuff1(time) 
    --if self.buff1 == true then return end
    print("添加了buff")

    local inst = self.inst
    self.buff1 = true

    if inst:HasTag("fastbuilder") then  --快速制造
        inst:AddTag("fastbuilder_new")
    else
        inst:AddTag("fastbuilder")        
    end 

    if inst:HasTag("expertchef") then  --快速烹饪
        inst:AddTag("expertchef_new")
    else
        inst:AddTag("expertchef")        
    end 

    if inst:HasTag("quagmire_fasthands") then  --快速烹饪
        inst:AddTag("quagmire_fasthands_new")
    else
        inst:AddTag("quagmire_fasthands")        
    end 

    if inst.components.workmultiplier then
        inst.components.workmultiplier:AddMultiplier(ACTIONS.CHOP,  2, inst)
        inst.components.workmultiplier:AddMultiplier(ACTIONS.MINE,  2, inst)
    end

    if inst.components.locomotor then
        inst.components.locomotor:SetExternalSpeedMultiplier(inst, "krm_bullet_buff1", 1.35)
    end

    if inst.components.oldager then
        inst.components.oldager.rate = 2
    end    

    self.inst.krm_bullet_buff_task1 = self.inst:DoTaskInTime(time, function()  --时间结束后取消Buff
        self:RemoveBuff1() 
        self:RemoveBuff1_Task()
    end)  
end

function Krm_Bullet_Buff:OnRemoveFromEntity()
     
end

return Krm_Bullet_Buff

