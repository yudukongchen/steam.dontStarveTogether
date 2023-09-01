 GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

local function HasPacket()
    local val = false
    for k, v in ipairs(AllPlayers) do
    if v.prefab == "skd" and v.components.inventory:Has("skd_new_item1", 1) then
        val = true
    end
    end 

    return val    
end

AddPrefabPostInit("stu", function(inst)
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stu_swim")

    if inst.components.drownable then
    local _shouldDrown = inst.components.drownable.ShouldDrown
    inst.components.drownable.ShouldDrown = function(self) 
        if inst.components.stu_swim and inst.components.stu_swim.can_swim == true then      
            return false
        end
            return _shouldDrown(self)              
        end
    end

    local _calcDamage = inst.components.combat.CalcDamage
    inst.components.combat.CalcDamage = function(self, target, weapon, multiplier) 
    local damage, spdamage = _calcDamage(self, target, weapon, multiplier)
        if target and target:HasTag("epic") then
            damage = damage * 1.2
        end

        if TUNING.SKD_HEALTH then
            print("联动加伤害")
            if HasPacket() then
            print("1.24")
            damage = damage * 1.24
            else
            print("1.16")    
            damage = damage * 1.16
            end 
        end     
        --print(weapon)

        return damage, spdamage
    end 

    local _getAttacked = inst.components.combat.GetAttacked
    inst.components.combat.GetAttacked = function(self, attacker, damage, weapon, stimuli, spdamage)
        if damage > 0 then
        if inst.sp_level == 0 then
            damage = damage * 1.2
            --print("1.2")

        elseif inst.sp_level == 1 then 
            damage = damage * 1.1
            --print("1.1")        
        end     
        end               

        return _getAttacked(self, attacker, damage, weapon, stimuli, spdamage) 
    end

    local _getHealth = inst.components.health.DoDelta
    inst.components.health.DoDelta = function(self, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
        if amount < 0 then

        local mult = (inst.components.inventory:EquipHasTag("stu_amulet1_3") and 0.25)
        or (inst.components.inventory:EquipHasTag("stu_amulet1_2") and 0.33)
        or (inst.components.inventory:EquipHasTag("stu_amulet1_1") and 0.4)
        or 0.5            
        if inst.components.sanity.current >= -(amount*(1 - mult)) then
            --print(mult)
            --print("扣除的精神 = "..amount * (1 - mult))
            inst.components.sanity:DoDelta(amount * (1 - mult))
            amount = amount * mult
            --print("受到的伤害为"..amount)
            --print(amount)
        end 
        end    

        if (self.currenthealth + amount) <= 0 then
            --print("即将死亡")
        local Skill2_Buff = inst.components.timer ~= nil and (inst.components.timer:GetTimeLeft("Stu_Skill2") or 0) or nil   
        if Skill2_Buff ~= nil and Skill2_Buff > 0 then
            --print("触发不死")
            amount = 0
            self.currenthealth = 1
        end
        end     
                                     
        return _getHealth(self, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb) 
    end

    local _getSanity = inst.components.sanity.DoDelta
    inst.components.sanity.DoDelta = function(self, delta, overtime)
        if (self.current + delta) <= self.max * 0.3 then
        local Skill2_Buff = inst.components.timer ~= nil and (inst.components.timer:GetTimeLeft("Stu_Skill2") or 0) or nil   
        if Skill2_Buff ~= nil and Skill2_Buff > 0 then
            delta = 0
            self.current = self.max * 0.3
        end
        end     
                                     
        return _getSanity(self, delta, overtime) 
    end    

    local _OldEat = inst.components.eater.Eat  
    inst.components.eater.Eat = function(self, food, feeder)
        if food and not food:HasTag("preparedfood") and food.components.edible and food.components.edible.sanityvalue > 0 then
            self.sanityabsorption = 0 

            inst.deltask = inst:DoTaskInTime(0, function()
                self.sanityabsorption = 1
                if inst.deltask then
                    inst.deltask:Cancel() 
                    inst.deltask = nil
                end  
            end)                                                                         
        end

        return _OldEat(self, food, feeder) 
    end    
end)         

local Trade_List = {"deerclops_eyeball", "armorwood", "armor_sanity", "armorruins"}
    
for k, v in pairs(Trade_List) do
    AddPrefabPostInit(v, function(inst)
    if not TheWorld.ismastersim then
        return
    end

    if inst.components.tradable == nil then  
        inst:AddComponent("tradable")
    end   
    end)        
end   

local function nohitsg(sg)
    local old_knockback = sg.events['knockback'].fn
    sg.events['knockback'] = EventHandler('knockback', function(inst, data, ...)
        if inst.prefab == "stu" and inst:HasTag("is_ghosted") then
            --print("返回")
            return
        end
  
        old_knockback(inst,data,...)
    end)

    local old_onattacked = sg.events['attacked'].fn
    sg.events['attacked'] = EventHandler('attacked', function(inst, data,...)
        if inst.prefab == "stu" and inst:HasTag("is_ghosted") then
            --print("返回")
            return
        end
  
        old_onattacked(inst,data,...)
    end)    
end

AddStategraphPostInit("wilson", nohitsg)


AddComponentPostInit("moisture", function(self)
    local OldOnUpdate = self.OnUpdate
    function self:OnUpdate(dt, ...)
        if self.inst:HasTag("stu") and self.inst.components.drownable and self.inst.components.drownable:IsOverWater()
        and self.inst.components.stu_swim and self.inst.components.stu_swim.can_swim == true then
            self.ratescale = RATE_SCALE.INCREASE_HIGH
            return          
        end    
        return OldOnUpdate(self, dt, ...)
    end          
end)


AddComponentPostInit("locomotor", function(self)
    local oldGetRunSpeed = self.GetRunSpeed
    function self:GetRunSpeed(...)
        if self.inst:HasTag("is_ghosted") and self.inst.replica.inventory then
            local speed = (self.inst.replica.inventory:EquipHasTag("stu_amulet1_3") and 6)
            or (self.inst.replica.inventory:EquipHasTag("stu_amulet1_2") and 5)
            or (self.inst.replica.inventory:EquipHasTag("stu_amulet1_1") and 4)
            or 3
            return speed
        end
        return oldGetRunSpeed(self, ...)
    end
end)

AddComponentPostInit("locomotor", function(self) 
    local _OldPushAction = self.PushAction
    function self:PushAction(bufferedaction, run, try_instant, ...)     
        if self.inst:HasTag("stu") and self.inst:HasTag("is_ghosted")
        and bufferedaction and bufferedaction.action and bufferedaction.action ~= ACTIONS.WALKTO then
            return 
        end           
        return _OldPushAction(self, bufferedaction, run, try_instant, ...)  
    end
    
    local _OldPreviewAction = self.PreviewAction
    function self:PreviewAction(bufferedaction, run, try_instant, ...)   
        if self.inst:HasTag("stu") and self.inst:HasTag("is_ghosted") 
        and bufferedaction and bufferedaction.action and bufferedaction.action ~= ACTIONS.WALKTO then    
            return 
        end  
        return _OldPreviewAction(self, bufferedaction, run, try_instant, ...)  
    end
end)

local stu_skill = require("widgets/stu_skill")
AddClassPostConstruct("widgets/controls", function(self)
    if self.owner and self.owner:HasTag("stu") then
       self.stu_skill_image = self:AddChild(stu_skill(self.owner))
       self.stu_skill_image:SetVAnchor(2)
       self.stu_skill_image:SetHAnchor(1)
       self.stu_skill_image:SetPosition(0, 0)
       self.stu_skill_image:Show()
    end
end)

