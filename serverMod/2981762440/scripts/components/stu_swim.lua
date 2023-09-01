local function CanOnWater(inst)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.GROUND)

    if not inst:HasTag("is_ghosted") then
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:CollidesWith(COLLISION.GIANTS)
    end

    inst.components.locomotor.pathcaps = { player = true, ignorecreep = true , allowocean = true}  
end

local function CanNotOnWater(inst)             
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.GROUND)       
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:CollidesWith(COLLISION.GIANTS)
    inst.components.locomotor.pathcaps = { player = true, ignorecreep = true }
end

local function OnWaterRun(inst)
    if inst:HasTag("playerghost") then return end
    local is_running = inst.sg and inst.sg:HasStateTag("running")
    if inst.Physics and inst.components.stu_swim.can_swim == true and not TheWorld:HasTag("cave") then
    if inst.sg and not inst.sg:HasStateTag("jumping") then   
        CanOnWater(inst)
    end    

    if inst.components.drownable and inst.components.drownable:IsOverWater() and not inst:HasTag("is_ghosted") then
        inst.components.moisture:DoDelta(0.5, true)

        if is_running then
            SpawnPrefab("weregoose_splash").entity:SetParent(inst.entity)
        end
    end

    elseif inst.Physics and (inst.components.stu_swim.can_swim == false or TheWorld:HasTag("cave")) then
    if inst.sg and not inst.sg:HasStateTag("jumping") then      
        CanNotOnWater(inst)
    end                      
    end      
end

local Stu_Swim = Class(function(self, inst)
    self.inst = inst
    self.can_swim = false
    self.inst:DoPeriodicTask(0.5, OnWaterRun)
end)

return Stu_Swim

