

local PUGALISK_SCALE_NORMAL = 2.25 
local PUGALISK_SCALE_SMALL = 2 

-- local x,y,z=TheInput:GetWorldPosition():Get() print(TheWorld.Map:IsPassableAtPoint(x,y,z,false,true))
local function findMoveablePosition(position, start_angle, radius, attempts, check_los)

    local test = function(offset)
        local run_point = position+offset

        local is_pure_ocean = TheWorld.Map:IsOceanAtPoint(run_point.x, run_point.y, run_point.z)
        local is_pure_ground = TheWorld.Map:IsPassableAtPoint(run_point.x, run_point.y, run_point.z,false,true)
        local is_ground_or_boat_or_ocean = TheWorld.Map:IsPassableAtPoint(run_point.x, run_point.y, run_point.z,true,false)
        -- local is_passable = TheWorld.Map:IsPassableAtPoint(run_point.x, run_point.y, run_point.z, true, false)
        -- if not is_pure_ocean and not is_pure_ground then
        --     -- print(run_point,"Not passable")
        --     return false
        -- end
        if not is_ground_or_boat_or_ocean then
            return false
        end

        local ents = TheSim:FindEntities(run_point.x,run_point.y,run_point.z, 2, nil,nil,{"tz_pugalisk","pugalisk_avoids"})        
        if #ents > 0 then   
            -- print(run_point,"tz_pugalisk and pugalisk_avoids !!!!")         
            return false
        end

        local ents = TheSim:FindEntities(run_point.x,run_point.y,run_point.z, 6, {"pugalisk_avoids"})
        if #ents > 0 then
            -- print(run_point,"pugalisk_avoids !!!!")        
            return false
        end

        if check_los and not TheWorld.Pathfinder:IsClear(position.x, position.y, position.z,
                                                         run_point.x, run_point.y, run_point.z,
                                                         {ignorewalls = true,ignorecreep = true, allowocean = true}) 
        then

            -- print(run_point,"Not path IsClear !!!!")
            return false
        end

        return true

    end

    return FindValidPositionByFan(start_angle, radius, attempts, test)
end

local function findDirectionToDive(inst,target)
    local pt = inst:GetPosition()
    local angle = math.random()*2*PI
    if target then
        angle = target:GetAngleToPoint(pt.x, pt.y, pt.z) *DEGREES - PI
        print("CALCING ANGLE",angle, target.prefab)
    else
        print("USING RANDOM ANGLE",angle)
    end

    local offset, endangle = findMoveablePosition(pt, angle, 6, 24, true)

    return endangle
end

local function findsafelocation(pt, angle)
    local finalpt = nil   
    local offset = nil
    local range = 6
    while not offset do            
        offset = findMoveablePosition(pt, angle*DEGREES, range, 24, true)        
        range = range + 1
    end
    if offset then
        pt = pt+offset
        finalpt = pt                   
    end
    return finalpt
end

local function getNewBodyPosition(inst,bodies,target)
    local finalpt = nil
    local finalangle = nil

    -- get the new origin point
    if #bodies < 1 then    
        -- this is the first body piece, start at the spawn point
        finalpt = inst:GetPosition()
    else
        -- this is a new body piece. try to put it out front of the last piece. 
        finalpt = findsafelocation( bodies[#bodies].exitpt:GetPosition(), bodies[#bodies].Transform:GetRotation())      
    end
     
    return finalpt           
end

local function DetermineAction(inst)
    -- tested each frame when head to see if the head should start moving
    local target = inst.components.combat.target 
    
    local pt = inst:GetPosition()
    local dist = nil

    -- local rando = math.random()
    -- if rando < 0.0001  then 
    --     inst.wantstotaunt = true
    -- end
    inst.wantstotaunt = false 

    if target then
        dist = inst:GetDistanceSqToInst(target)            
    end

    local may_sound_attack = inst:CanCastSoundAttack()
    local may_roar = inst:CanCastRoar()
    local may_meteor = inst:CanCastMeteor()
    -- local may_laser = inst:CanCastLaser()

    if (dist and dist < 10*10) or may_sound_attack or may_roar or may_meteor then           
        if inst.sg:HasStateTag("underground") then
            inst:PushEvent("emerge")
        end
        inst:PushEvent("stopmove")
    elseif not inst.wantstotaunt then    
                     
        local angle = nil
        inst.movecommited = true
        
        angle = findDirectionToDive(inst,target)


        if angle then
            inst.Transform:SetRotation(angle/DEGREES) 

            inst.angle = angle

            if inst.sg:HasStateTag("underground") then
                local pos = Vector3(inst.Transform:GetWorldPosition())
                inst.components.tz_pugalisk_multibody:SpawnBody(inst.angle,0,pos)
            else
                inst.wantstopremove = true
                --inst:PushEvent("premove")                
            end
        else
            print("COULD NOT GET AN ANGLE FOR THE BODY SEGMENT, BACKING UP THE PUGAKISK UP")                                  
            inst:PushEvent("backup")
        end

        --inst:PushEvent("startmove")   
    end
end

local function recoverfrombadangle(inst)
    local finalpt = findsafelocation( inst:GetPosition(), inst.Transform:GetRotation())  
    inst.Transform:SetPosition(finalpt.x,finalpt.y,finalpt.z)
end

local function SpawnHitFx(inst,no_follow_symbol)
    local s = PUGALISK_SCALE_NORMAL
    if inst.prefab == "tz_pugalisk" then
        local fx = SpawnAt("snake_scales_fx",inst:GetPosition() + Vector3(0,2,0))
        fx.Transform:SetScale(s,s,s)
        return fx 
    elseif inst.prefab == "tz_pugalisk_segment" then
        if no_follow_symbol then
            local fx = SpawnAt("snake_scales_fx",inst:GetPosition())
            fx.Transform:SetScale(s,s,s)
            return fx 
        end
        local fx = SpawnPrefab("snake_scales_fx")
        fx.entity:SetParent(inst.entity)
        fx.entity:AddFollower()
        fx.Follower:FollowSymbol(inst.GUID,"segment_swap",0,0,0)

        return fx 
    elseif inst.prefab == "tz_pugalisk_body" then
        local fx = SpawnAt("snake_scales_fx",inst:GetPosition())
        fx.Transform:SetScale(s,s,s)
        return fx 
    elseif inst.prefab == "tz_pugalisk_tail" then
        local fx = SpawnAt("snake_scales_fx",inst:GetPosition() + Vector3(0,1.5,0))
        fx.Transform:SetScale(s,s,s)
        return fx 
    end 
end

-- local function StartCheckFloat(inst)
--     local function UpdateFn()
--         local pos = inst:GetPosition()
--         local is_pure_ocean = TheWorld.Map:IsOceanAtPoint(pos.x, pos.y, pos.z)
--         if is_pure_ocean and not inst._last_is_pure_ocean then
--             inst:PushEvent("on_landed")
--         elseif not is_pure_ocean and inst._last_is_pure_ocean then
--             inst:PushEvent("on_no_longer_landed")
--         end
--         inst._last_is_pure_ocean = is_pure_ocean
--     end
--     UpdateFn()
--     inst:DoPeriodicTask(0,UpdateFn)
-- end

local function AddAmphibious(inst,floater)
    -- Make floatable
    -----------------------------------------------------------
    if floater then
        inst:AddComponent("floater")
        inst.components.floater:SetSize("large")

        if inst.prefab == "tz_pugalisk" or inst.prefab == "tz_pugalisk_tail" then
            inst.components.floater:SetVerticalOffset(0.5)
        elseif inst.prefab == "tz_pugalisk_body" then
            inst.components.floater:SetVerticalOffset(-0.25)
        end
        

        inst.components.floater:SetScale(0.72)

        local old_OnLandedClient = inst.components.floater.OnLandedClient
        inst.components.floater.OnLandedClient = function (self,...)
            old_OnLandedClient(self,...)
            inst.AnimState:SetFloatParams(0,0,0)
        end
    end
    
    -----------------------------------------------------------


    if not TheWorld.ismastersim then
        return inst
    end


    inst:AddComponent("amphibiouscreature")
    -- inst.components.amphibiouscreature:SetBanks("giant_snake","giant_snake")
    inst.components.amphibiouscreature:SetEnterWaterFn(function()
        inst:PushEvent("on_landed")
        inst.AnimState:HideSymbol("wormmovefx01")
        
    end)
    inst.components.amphibiouscreature:SetExitWaterFn(function()
        inst:PushEvent("on_no_longer_landed")
        inst.AnimState:ShowSymbol("wormmovefx01")
    end)
    local old_OnUpdate = inst.components.amphibiouscreature.OnUpdate
    inst.components.amphibiouscreature.OnUpdate = function(self,...)
        if self.inst.Physics and not self.inst.Physics:IsActive() then
            if self.in_water then
                self:OnExitOcean()
            end
            return 
        end
        old_OnUpdate(self,...)
    end

    inst.components.amphibiouscreature.OnEnterOcean = function(self,...)
        if not self.in_water then
            self.in_water = true
            self.inst:AddTag("swimming")
            if self.enterwaterfn then
                self.enterwaterfn(self.inst)
            end
        end
    end
    
    inst.components.amphibiouscreature.OnExitOcean = function(self,...)
        if self.in_water then
            self.in_water = false
            self.inst:RemoveTag("swimming")
            if self.exitwaterfn then
                self.exitwaterfn(self.inst)
            end
        end
    end
end

return {
    findMoveablePosition = findMoveablePosition,
    findDirectionToDive = findDirectionToDive,
    -- FindValidPositionByFan = FindValidPositionByFan,
    findsafelocation = findsafelocation,
    getNewBodyPosition = getNewBodyPosition,
    -- FindCurrentTarget = FindCurrentTarget,
    DetermineAction = DetermineAction,
    recoverfrombadangle = recoverfrombadangle,

    -- StartCheckFloat = StartCheckFloat,
    AddAmphibious = AddAmphibious,

    SpawnHitFx = SpawnHitFx,
    PUGALISK_SCALE_NORMAL = PUGALISK_SCALE_NORMAL,
    PUGALISK_SCALE_SMALL = PUGALISK_SCALE_SMALL,
}
