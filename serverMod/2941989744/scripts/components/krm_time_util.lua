-- util functions for time magic

local KrmIsImmune = nil

function KrmIsImmune(inst)
	if not (inst and inst:IsValid()) then  -- Invalid, just ignore it
		return true
	end
    if inst.krmVar_is_precipitation then -- rain, snow, ash, ...
        return false
    end
    return
       inst:HasTag("INLIMBO")
    or inst.prefab == "krm"
    or inst:HasTag('krmTag_ignoretimemagic')
    or inst:HasTag('krmTag_ignoretimemagic_temp')
    or inst:HasTag('krmTag_ignoretimemagic')

    or inst:HasTag('kurumi') --我的人物免疫时停
	or inst:HasTag('ray') --我的人物免疫时停
    or (inst.replica.inventory and inst.replica.inventory:Has('krm_fhbm',1)) --身上有这个物品免疫试听
    or (inst.replica.container and inst.replica.container:Has('krm_fhbm',1)) --容器有这个物品免疫试听
    or (inst.replica.inventory and inst.replica.inventory:Has('thurible',1)) --身上有这个物品免疫试听
    or (inst.replica.container and inst.replica.container:Has('thurible',1)) --容器有这个物品免疫试听
    or (inst.components.container and inst.components.container.opener ~= nil and KrmIsImmune(inst.components.container.opener))
    or (inst.entity:GetParent() ~= nil and KrmIsImmune(inst.entity:GetParent()))
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
        inst:AddTag("krmTag_livecorpse")
    end
end

local function OnHealthDelta(inst)
    -- called after add "NOCLICK" tag
    if inst:HasTag("krmTag_livecorpse") and inst:HasTag("NOCLICK") then
        inst:RemoveTag("NOCLICK")
        inst:AddTag("krmTag_NOCLICK")
    end
end

local function Start(inst, client)
    -- inst:IsValid()

	if inst.krm_timemagic_onstart then
        inst:krm_timemagic_onstart(client)
    end

    inst:AddTag('krmTag_pause')

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
            inst.krm_vels = {inst.Physics:GetVelocity()}
            inst.krm_mvels = {inst.Physics:GetMotorVel()}
            inst.krm_tempstop = true
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

    if inst.krm_timemagic_onstop then
        inst:krm_timemagic_onstop(client)
    end
    
    inst:RemoveTag('krmTag_pause')
    inst:PushEvent("krmevt_timemagic_stop")
    if inst.AnimState and inst.components.floater then
        if inst.components.floater:IsFloating() then
            inst.AnimState:SetFloatParams(-0.05, 1.0, inst.components.floater.bob_percent)
        end
    end

    if inst.sg then
        -- 该函数应该在操作userdata后再调用
        if inst:HasTag("INLIMBO") or client then
            -- 下方返回，不操作userdata，直接调用
            inst.sg:krm_TimeMagic_OnStop()
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
        elseif inst.krm_tempstop then
            inst.krm_tempstop = nil
            inst.krm_vels = inst.krm_vels and inst.Physics:SetVel(unpack(inst.krm_vels))
            inst.krm_mvels = inst.krm_mvels and inst.Physics:SetMotorVel(unpack(inst.krm_mvels))
        elseif inst.Physics:GetMass() ~= 0 or inst.Physics:GetMotorVel() ~= 0 then
            inst.Physics:SetActive(true)
        end
    end

    -- SG 
    if inst.sg then
        inst.sg:krm_TimeMagic_OnStop()
    end

    inst:RemoveEventCallback("death", OnDeath)
    inst:RemoveEventCallback("healthdelta", OnHealthDelta)
    if inst:HasTag("krmTag_livecorpse") then
        if inst:HasTag("krmTag_NOCLICK") then
            inst:RemoveTag("NOCLICK")
            inst:RemoveTag("krmTag_NOCLICK")
        end
        inst:RemoveTag("krmTag_livecorpse")
    end
end

local function Update(inst, dt)
    -- inst:IsValid()

    if inst.pendingtasks then
        for k in pairs(inst.pendingtasks or {})do
            if k.krm_isstatic == nil then
                k:AddTick()
            end
        end
    end
   
    if inst.sg then
        inst.sg:AddTick(dt)
    end
    if inst.Physics and inst.krm_tempstop then
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
    IsImmune = KrmIsImmune,
    Start   = Start,
    Stop    = Stop,
    Update  = Update,
}
