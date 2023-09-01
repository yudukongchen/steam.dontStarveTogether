-- util functions for time magic

local IsImmune = nil

function IsImmune(inst)
	if not (inst and inst:IsValid()) then  -- Invalid, just ignore it
		return true
	end
    if inst.taizhenVar_is_precipitation then -- rain, snow, ash, ...
        return false
    end
    return
       inst:HasTag("INLIMBO")
    or inst.prefab == "taizhen"
    or inst:HasTag('taizhenTag_ignoretimemagic')
    or inst:HasTag('taizhenTag_ignoretimemagic_temp')
    or inst:HasTag('taizhenTag_ignoretimemagic')
    or (inst.replica.inventory and inst.replica.inventory:Has('tz_fhbm',1))
    or (inst.replica.container and inst.replica.container:Has('tz_fhbm',1))
    or (inst.components.container and inst.components.container.opener ~= nil and IsImmune(inst.components.container.opener))
    or (inst.entity:GetParent() ~= nil and IsImmune(inst.entity:GetParent()))
end

local function BitAND(a,b) local p,c=1,0 while a>0 and b>0 do local ra,rb=a%2,b%2 if ra+rb>1 then c=c+p end a,b,p=(a-ra)/2,(b-rb)/2,p*2 end return c end

local function CollidesWithPlayer(phy)
    local mask = phy:GetCollisionMask()
    if mask < COLLISION.CHARACTERS then 
        return false
    else
        return BitAND(mask, COLLISION.CHARACTERS) > 0
    end
end

local function IsObstacle(phy)
    return phy:GetCollisionGroup() == COLLISION.OBSTACLES
end

-- 2021.12 new listener for death
local function OnDeath(inst)
    if inst.components.health ~= nil then
        inst:AddTag("taizhenTag_livecorpse")
    end
end

local function OnHealthDelta(inst)
    -- called after add "NOCLICK" tag
    if inst:HasTag("taizhenTag_livecorpse") and inst:HasTag("NOCLICK") then
        inst:RemoveTag("NOCLICK")
        inst:AddTag("taizhenTag_NOCLICK")
    end
end

local function Start(inst, client)
    -- inst:IsValid()

	if inst.tz_timemagic_onstart then
        inst:tz_timemagic_onstart(client)
    end

    inst:AddTag('taizhenTag_pause')

    if inst.AnimState then -- Stop floating
        inst.AnimState:SetFloatParams(0.0, 0.0, 0.0)
    end
    ------------------------------------
    if client then
    	return
    end
    -------------------------------------

    if inst.AnimState then
        inst.AnimState:Pause()
    end
    if inst.Physics then
        local mass = inst.Physics:GetMass()
        if IsObstacle(inst.Physics) then
            -- Ignore OBSTACLES
        elseif not CollidesWithPlayer(inst.Physics) then
            inst.Physics:SetActive(false)
        elseif mass ~= 0 then 
            inst.tz_vels = {inst.Physics:GetVelocity()}
            inst.tz_mvels = {inst.Physics:GetMotorVel()}
            inst.tz_tempstop = true
            inst.Physics:Stop()
        elseif inst.Physics:GetMotorVel() ~= 0 then --质量为0, 但不是障碍物, 如海浪
            inst.Physics:SetActive(false)
        end
    end

    inst:ListenForEvent("death", OnDeath)
    inst:ListenForEvent("healthdelta", OnHealthDelta)

end

local function Stop(inst, client)
    if not inst:IsValid() then
        return
    end

    if inst.tz_timemagic_onstop then
        inst:tz_timemagic_onstop(client)
    end
    
    inst:RemoveTag('taizhenTag_pause')
    inst:PushEvent("taizhenevt_timemagic_stop")
    if inst.AnimState and inst.components.floater then
        if inst.components.floater:IsFloating() then
            inst.AnimState:SetFloatParams(-0.05, 1.0, inst.components.floater.bob_percent)
        end
    end

    if inst.sg then
        -- 该函数应该在操作userdata后再调用
        if inst:HasTag("INLIMBO") or client then
            -- 下方返回，不操作userdata，直接调用
            inst.sg:TZ_TimeMagic_OnStop()
        end
    end
    --------------------------------
    if inst:HasTag("INLIMBO") then
        return
    end

    if client then
    	return
    end
    ---------------------------------

    if inst.AnimState then
        inst.AnimState:Resume()
    end
    
    if inst.Physics then
        if IsObstacle(inst.Physics) then
            -- Ignore OBSTACLES            
        elseif not CollidesWithPlayer(inst.Physics) then
            inst.Physics:SetActive(true)
        elseif inst.tz_tempstop then
            inst.tz_tempstop = nil
            inst.tz_vels = inst.tz_vels and inst.Physics:SetVel(unpack(inst.tz_vels))
            inst.tz_mvels = inst.tz_mvels and inst.Physics:SetMotorVel(unpack(inst.tz_mvels))
        elseif inst.Physics:GetMass() ~= 0 or inst.Physics:GetMotorVel() ~= 0 then
            inst.Physics:SetActive(true)
        end
    end

    -- SG 
    if inst.sg then
        inst.sg:TZ_TimeMagic_OnStop()
    end

    inst:RemoveEventCallback("death", OnDeath)
    inst:RemoveEventCallback("healthdelta", OnHealthDelta)
    if inst:HasTag("taizhenTag_livecorpse") then
        if inst:HasTag("taizhenTag_NOCLICK") then
            inst:RemoveTag("NOCLICK")
            inst:RemoveTag("taizhenTag_NOCLICK")
        end
        inst:RemoveTag("taizhenTag_livecorpse")
    end
end

local function Update(inst, dt)
    -- inst:IsValid()

    if inst.pendingtasks then
        for k in pairs(inst.pendingtasks or {})do
            if k.taizhen_isstatic == nil then
                k:AddTick()
            end
        end
    end
   
    if inst.sg then
        inst.sg:AddTick(dt)
    end
    if inst.Physics and inst.tz_tempstop then
        inst.Physics:Stop()
    end
    if inst.components.timer then
        for k,v in pairs(inst.components.timer.timers)do
            if not v.paused then
                v.end_time = v.end_time + dt
            end
        end
    end
    if inst.components.combat then 
        if inst.components.combat.lastdoattacktime then
            inst.components.combat.lastdoattacktime = inst.components.combat.lastdoattacktime + dt
        end
    end
end

return {
    IsImmune = IsImmune,
    Start   = Start,
    Stop    = Stop,
    Update  = Update,
}
