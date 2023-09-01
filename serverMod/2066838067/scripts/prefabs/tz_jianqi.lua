local assets = {
	Asset("ANIM", "anim/tz_jianqi.zip"),
}

local function UpdatePing(inst, s0, s1, t0, duration, multcolour, addcolour)
    if next(multcolour) == nil then
        multcolour[1], multcolour[2], multcolour[3], multcolour[4] = inst.AnimState:GetMultColour()
    end
    if next(addcolour) == nil then
        addcolour[1], addcolour[2], addcolour[3], addcolour[4] = inst.AnimState:GetAddColour()
    end
    local t = GetTime() - t0
    local k = 1 - math.max(0, t - 0.1) / duration
    k = 1 - k * k
    local s = Lerp(s0, s1, k)
    local c = Lerp(1, 0, k)
    inst.Transform:SetScale(s, s, s)
    inst.AnimState:SetMultColour(c * multcolour[1], c * multcolour[2], c * multcolour[3], c * multcolour[4])

    k = math.min(0.3, t) / 0.3
    c = math.max(0, 1 - k * k)
    inst.AnimState:SetAddColour(c * addcolour[1], c * addcolour[2], c * addcolour[3], c * addcolour[4])
end

local function FadeOut(inst,duration,startscale,adds)
    if inst.fadetask then 
        inst.fadetask:Cancel()
        inst.fadetask = nil 
    end
    duration = duration or 0.4
    startscale = startscale or 1
    adds = adds or 0
    
    inst.fadetask = inst:DoPeriodicTask(0, UpdatePing, nil, startscale, startscale + adds, GetTime(),duration, {}, {})
    inst:DoTaskInTime(duration,inst.Remove) 
end 

local function fn()
	local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.entity:AddAnimState()

    inst.Transform:SetEightFaced()

    MakeInventoryPhysics(inst)
    -- RemovePhysicsColliders(inst)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.GROUND)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)

    inst:AddTag("NOCLICK")
    inst:AddTag("FX")
    inst:AddTag("NOBLOCK")


    inst.AnimState:SetBank("tz_jianqi")
    inst.AnimState:SetBuild("tz_jianqi")
    -- inst.AnimState:PlayAnimation("tz_jianqi_a")
    inst.AnimState:SetMultColour(1,1,1,0.75)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.anim_type = "a"
    inst.hitted_target = {}
    inst.modify_scale = 1

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(20)

    inst.Launch = function(inst,attacker,tar_pos,speed)
        
        inst.attacker = attacker
        inst:ForceFacePoint(tar_pos:Get())
        inst.AnimState:PlayAnimation("tz_jianqi_"..inst.anim_type,inst.anim_type == "e")
        

        if inst.anim_type == "e" then 
            inst.SoundEmitter:PlaySound("dontstarve/birds/takeoff_canary")
           
            inst.Physics:SetMotorVel(speed,0,0)
            inst:DoPeriodicTask(0,function()
                if inst:IsOnOcean() then 
                    SpawnAt("crab_king_waterspout",inst).Transform:SetScale(1 * inst.modify_scale,0.5 * inst.modify_scale,1 * inst.modify_scale)
                else
                    local dirt = SpawnAt("tz_jianqi_dirt",inst)
                    dirt.AnimState:SetTime(12 * FRAMES)
                    dirt.Transform:SetScale(inst.modify_scale * 0.6,inst.modify_scale * 0.6,inst.modify_scale * 0.6)
                end 
            end)
            inst.Transform:SetScale(1.5 * inst.modify_scale,1.5 * inst.modify_scale,1.5 * inst.modify_scale)
            inst:DoTaskInTime(1.8,FadeOut,nil,1.5)
        else
            -- inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_nightsword")
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
            inst.Transform:SetScale(1.25 * inst.modify_scale,1.25 * inst.modify_scale,1.25 * inst.modify_scale)
            inst:ListenForEvent("animover",inst.Remove)
        end

        inst:DoPeriodicTask(0,function()
            local x,y,z = inst:GetPosition():Get()
            for k,v in pairs(TheSim:FindEntities(x,y,z,2.5,{"_combat"},inst.NO_TAGS)) do 
                if not (inst.attacker and inst.attacker:IsValid()) then
                    inst.attacker = inst 
                end

                if not inst.hitted_target[v] and inst.attacker.components.combat:CanTarget(v) and not inst.attacker.components.combat:IsAlly(v) then 
                    inst.hitted_target[v] = true
                    
                    if inst.damage then
                        v.components.combat:GetAttacked(inst.attacker,inst.damage)
                    elseif inst.attacker.components.combat then 
                        inst.attacker.components.combat.ignorehitrange = true
                        inst.attacker.components.combat:DoAttack(v,nil,inst.caster or inst,nil,inst.anim_type == "e" and 3 or 1.2)
                        inst.attacker.components.combat.ignorehitrange = false
                    end

                    -- local fx = v:SpawnChild("tz_fanta_blade_hit_vfx")
                    -- fx.Transform:SetPosition(0,1,0)
                    -- fx:set_replica_pos(x,y,z)

                    SpawnAt("tz_killknife_fx",v:GetPosition()+Vector3(0,1,0)).Transform:SetScale(2 * inst.modify_scale,2 * inst.modify_scale,2 * inst.modify_scale)

                    inst:DoTaskInTime(0.25,function()
                        inst.hitted_target[v] = nil 
                    end)
                    -- if v:HasTag("wall") and inst.anim_type == "e" then 
                    --     inst:Remove()
                    --     break
                    -- end
                end

            end
        end)


    end

    -- inst:AddComponent("complexprojectile")
    -- inst.components.complexprojectile:SetOnHit(OnProjectileHit)
    -- inst.components.complexprojectile:SetOnLaunch(OnLaunch)
    -- inst.components.complexprojectile:SetHorizontalSpeed(20)
    -- inst.components.complexprojectile.onupdatefn = function(inst,dt)
    --     dt = dt or FRAMES

    --     local self = inst.components.complexprojectile
    --     local x,y,z = inst:GetPosition():Get()

    --     self.flying_time = (self.flying_time or 0) + dt 
    --     inst.Physics:SetMotorVel(inst.components.complexprojectile.horizontalSpeed,0,0)

    --     for k,v in pairs(TheSim:FindEntities(x,y,z,1,{"_combat"})) do 
    --         if self.attacker.components.combat:CanTarget(v) and not self.attacker.components.combat:IsAlly(v) then 
    --             self:Hit(v)
    --             break
    --         end
    --     end

    --     if self.flying_time >= 6 then 
    --         self:Hit()
    --     end

    --     return true
    -- end

    return inst

end

local function dirtfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    
    inst.AnimState:SetBank("mole_fx")
    inst.AnimState:SetBuild("mole_move_fx")
    inst.AnimState:PlayAnimation("move")

    inst.Transform:SetScale(0.6,0.6,0.6)
    
    -- inst.Transform:SetFourFaced()
    
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    
    inst.persists = false

    inst:ListenForEvent("animover",inst.Remove)
    

    return inst
end 

return Prefab("tz_jianqi",fn,assets),Prefab("tz_jianqi_dirt",dirtfn,assets)