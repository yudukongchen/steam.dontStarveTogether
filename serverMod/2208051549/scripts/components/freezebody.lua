
-----------------------------------------------
local function FastFireFighting(inst)
    local x,y,z = inst.Transform:GetWorldPosition()
    local TheFire = TheSim:FindEntities(x, y, z, 6, {"campfire"or"firepit"},{"blueflame"})
    local Smolder = TheSim:FindEntities(x, y, z, 3, {"smolder"},{})
    local Onburning = TheSim:FindEntities(x, y, z, 2, {"fire"},{"campfire","firepit","weapon","nightlight"})
    local TheColdFire = TheSim:FindEntities(x, y, z, 6, {"campfire"or"firepit","blueflame"},{})
    if #TheFire~=0 and not inst.components.health:IsDead() or inst:HasTag("playerghost") then   --靠近火以约五倍的速度熄灭。
        for k, v in pairs(TheFire) do
              v.components.fueled.rate = 6
        end     
    end
    if #TheColdFire~=0 and not inst.components.health:IsDead() or inst:HasTag("playerghost") then   --靠近冰火竟然可以自动加燃料
        for k, v in pairs(TheColdFire) do
              v.components.fueled.rate = -3
        end     
    end
    if #Smolder~=0 and not inst.components.health:IsDead() or inst:HasTag("playerghost") then --兽型灭烟器
        for k, v in pairs(Smolder) do
            -- v:RemoveTag("smolder")  没用呐
            v.components.burnable:StopSmoldering(-1)   --（-1为热百分比，具体效果不清楚）
        end     
    end 
    if #Onburning~=0 and not inst.components.health:IsDead() or inst:HasTag("playerghost") then   --兽型灭火器，想要点火并不容易……
        for k, v in pairs(Onburning) do
            v.components.burnable:Extinguish(v, -1, nil)
        end     
    end
end
--------上方功能性过程函数---------


--------------------
local freezebody = Class(function (self, inst)
    self.inst = inst

end)

function freezebody:setfiredown()
    if self.periodic == nil then
        self.periodic = self.inst:DoPeriodicTask(1, FastFireFighting)
    end
end

function freezebody:closefiredown()
    if self.periodic ~= nil then
        self.periodic:Cancel()
    end
    self.periodic = nil
end

function freezebody:BodyOn(inst)
    if self.inst.components.heater == nil then self.inst:AddComponent("heater") end
    self.inst.components.heater.heat = -100
    self.inst.components.heater:SetThermics(false, true)
    --inst.components.temperature:CannotOverHeated()  这就不必了。
    if not self.inst:HasTag("HASHEATER") then self.inst:AddTag("HASHEATER") end
    --厨师袋的保鲜效果。但对于冰块无效，若要改进，可能要改进整个perishable文件。
    if not self.inst:HasTag("foodpreserver") then self.inst:AddTag("foodpreserver") end
    self:setfiredown()

end

function freezebody:BodyOff(inst)
    if self.inst.components.heater then
        self.inst:RemoveComponent("heater")
    end
    --这个heater模块懒得移除。。。尝试直接调整吸热放热是否有效   --直接移除 。
    --inst.components.heater.heat = 0
    --inst.components.heater:SetThermics(false, false)
    --inst.components.temperature:RecoverOverHeated()
    if self.inst:HasTag("HASHEATER") then self.inst:RemoveTag("HASHEATER") end
    if self.inst:HasTag("foodpreserver") then self.inst:RemoveTag("foodpreserver") end
    self:closefiredown()
end

function freezebody:OnRemoveFromEntity()
    self.inst.components.freezebody:BodyOff(self.inst)
end

return freezebody