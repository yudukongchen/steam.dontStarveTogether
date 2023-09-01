local TzEntity = require("util/tz_entity")
local TzDebuffUtil = require("tz_debuff_util")

local SMASHABLE_TAGS = { "_combat", "_inventoryitem", "NPC_workable" }
local SMASHABLE_WORK_ACTIONS = {
    CHOP = true,
    DIG = true,
    HAMMER = true,
    MINE = true,
}
for k, v in pairs(SMASHABLE_WORK_ACTIONS) do
    table.insert(SMASHABLE_TAGS, k.."_workable")
end
local NON_SMASHABLE_TAGS = { "INLIMBO", "playerghost", "meteor_protection","tz_pugalisk","tz_pugalisk_token" }

local function DoAoeFire(source,pos,damage_rad)
    local x, y, z = pos:Get()
    local ents = TheSim:FindEntities(x, y, z, damage_rad, nil, NON_SMASHABLE_TAGS)
    for i, v in ipairs(ents) do
        if v:IsValid() and not v:IsInLimbo() then
            if v.components.burnable and not v.components.burnable.burning then

                v.components.burnable:Ignite(true)
            end
        end
    end
end
-- c_spawn("tz_pugalisk_meteor"):DoStrike()
-- c_spawn("tz_pugalisk_meteor_huge"):DoStrike()
local function DoMeteorStrike(inst,data)
    
    inst.SoundEmitter:PlaySound("dontstarve/common/meteor_impact")

    
    if not inst:IsOnValidGround() then
        -- SpawnAt("splash_ocean",inst)
        local s = 1.5
        if inst.prefab == "tz_pugalisk_meteor_huge" then
            s = 2.5
        end
        
        SpawnAt("crab_king_waterspout",inst).Transform:SetScale(1 * s,1 * s,1 * s)
    else
        local s_brunt = data.burntground_scale
        SpawnAt("burntground",inst).Transform:SetScale(s_brunt,s_brunt,s_brunt)

        -- print("data.fire = ",data.fire)


        local x, y, z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, data.damage_rad, nil, NON_SMASHABLE_TAGS, SMASHABLE_TAGS)
        for i, v in ipairs(ents) do
            if v:IsValid() and not v:IsInLimbo() then
                
                if v.components.combat ~= nil then
                    v.components.combat:GetAttacked(inst, data.damage)
                    if data.fire then
                        if not v.components.debuffable then
                            v:AddComponent("debuffable")
                        end
                        v.components.debuffable:AddDebuff("tz_pugalisk_meteor_fire_debuff","tz_pugalisk_meteor_fire_debuff")
                    end
                elseif v.components.workable ~= nil then
                    if v.components.workable:CanBeWorked() and not (v.sg ~= nil and v.sg:HasStateTag("busy")) then
                        local work_action = v.components.workable:GetWorkAction()
                        --V2C: nil action for NPC_workable (e.g. campfires)
                        if (    (work_action == nil and v:HasTag("NPC_workable")) or
                                (work_action ~= nil and SMASHABLE_WORK_ACTIONS[work_action.id]) ) and
                            (work_action ~= ACTIONS.DIG
                            or (v.components.spawner == nil and
                                v.components.childspawner == nil)) then
                            v.components.workable:WorkedBy(inst,20)
                        end
                    end
                elseif v.components.inventoryitem ~= nil then
                    if v.components.container ~= nil then
                        -- Spill backpack contents, but don't destroy backpack
                        if math.random() <= TUNING.METEOR_SMASH_INVITEM_CHANCE then
                            v.components.container:DropEverything()
                        end
                    elseif v.components.mine ~= nil and not v.components.mine.inactive then
                        -- Always smash things on the periphery so that we don't end up with a ring of flung loot
                        v.components.mine:Deactivate()
                    elseif (inst.peripheral or math.random() <= TUNING.METEOR_SMASH_INVITEM_CHANCE)
                        and not v:HasTag("irreplaceable") then
                        -- Always smash things on the periphery so that we don't end up with a ring of flung loot
                        local vx, vy, vz = v.Transform:GetWorldPosition()
                        SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(vx, 0, vz)
                        v:Remove()
                    end
                    if v:IsValid() then
                        if not v.components.inventoryitem.nobounce then
                            Launch(v, inst, TUNING.LAUNCH_SPEED_SMALL)
                        elseif v.Physics ~= nil and v.Physics:IsActive() then
                            local vx, vy, vz = v.Transform:GetWorldPosition()
                            local dx, dz = vx - x, vz - z
                            local spd = math.sqrt(dx * dx + dz * dz)
                            local angle =
                                spd > 0 and
                                math.atan2(dz / spd, dx / spd) + (math.random() * 20 - 10) * DEGREES or
                                math.random() * 2 * PI
                            spd = 3 + math.random() * 1.5
                            v.Physics:Teleport(vx, 0, vz)
                            v.Physics:SetVel(math.cos(angle) * spd, 0, math.sin(angle) * spd)
                        end
                    end
                end
                
                
            end
        end

        if data.fire then
            TheWorld:DoTaskInTime(0.33,DoAoeFire,inst:GetPosition(),data.damage_rad)
        end
        
    end
end

local function SpawnFireFx(inst)
    local fx = SpawnPrefab("character_fire")
    fx.AnimState:SetAddColour(1,0,0,1)
    inst:AddChild(fx)
    if inst.components.combat and inst.components.combat.hiteffectsymbol then
        fx.entity:AddFollower()
        fx.Follower:FollowSymbol(inst.GUID,inst.components.combat.hiteffectsymbol, 0, 0, 0)
    end
    fx.persists = false
    if fx.components.firefx ~= nil then
        fx.components.firefx:SetLevel(2, true)
        fx.components.firefx:AttachLightTo(inst)
    end

    return fx 
end

return TzEntity.CreateNormalFx({
    prefabname = "tz_pugalisk_meteor",
    assets = {
        Asset("ANIM", "anim/meteor.zip"),
        Asset("ANIM", "anim/warning_shadow.zip"),
        Asset("ANIM", "anim/meteor_shadow.zip"),

        Asset("ANIM", "anim/tz_python_fx.zip"),
    },

    bank = "meteor",
    build = "meteor",

    clientfn = function(inst)
        inst.AnimState:SetLightOverride(1)
        inst.Transform:SetTwoFaced()
        inst.Transform:SetScale(0.7,0.7,0.7)
    end,

    serverfn = function(inst)

        inst.Transform:SetRotation(math.random(360))

        inst.DoStrike = function(inst,data)
            inst.AnimState:PlayAnimation("crash")
            data = data or {}
            data.burntground_scale = data.burntground_scale or 1
            data.damage_rad = data.damage_rad or 2
            data.damage = data.damage or TUNING.TZ_PUGALISK_CONFIG.METEOR_SMALL_DAMAGE

            inst:DoTaskInTime(0.33, function()
                ShakeAllCameras(CAMERASHAKE.FULL, 0.7, 0.02, 0.5, inst, 40)
                DoMeteorStrike(inst,data)
            end)
        end


    end
}),
TzEntity.CreateNormalFx({
    prefabname = "tz_pugalisk_meteor_huge",
    assets = {
        Asset("ANIM", "anim/meteor.zip"),
        Asset("ANIM", "anim/warning_shadow.zip"),
        Asset("ANIM", "anim/meteor_shadow.zip"),

        Asset("ANIM", "anim/tz_python_fx.zip"),
    },

    bank = "tz_python_fx",
    build = "tz_python_fx",

    clientfn = function(inst)
        inst.AnimState:SetLightOverride(1)
        inst.Transform:SetTwoFaced()
        inst.Transform:SetScale(1.5,1.5,1.5)
    end,

    serverfn = function(inst)
        

        inst.Transform:SetRotation(math.random(360))

        inst.DoStrike = function(inst,data)
            inst.AnimState:PlayAnimation("stone_in")
            data = data or {}
            data.burntground_scale = data.burntground_scale or 1.9
            data.damage_rad = data.damage_rad or 3.2
            data.damage = data.damage or TUNING.TZ_PUGALISK_CONFIG.METEOR_SMALL_DAMAGE
            data.fire = true 

            inst:DoTaskInTime(0.4, function()
                ShakeAllCameras(CAMERASHAKE.FULL, 0.8, 0.03, 0.5, inst, 45)
                DoMeteorStrike(inst,data)

                if inst:IsOnValidGround() then
                    local remain = SpawnAt("tz_pugalisk_meteor_remain",inst,{1.5,1.5,1.5})
                    remain.components.timer:StartTimer("releasing_spore",20)
                    remain.components.timer:StartTimer("explode",60)
                    -- c_findnext("tz_pugalisk_meteor_remain").components.timer:StartTimer("explode",3)

                    SpawnAt("firering_fx",inst)
                end

                SpawnAt("firesplash_fx",inst,{1.5,1.5,1.5})

                for roa = 0,2 * PI,2 * PI / 4 do
                    local offset = Vector3(math.cos(roa),0,math.sin(roa)) * 2
                    SpawnAt("firesplash_fx",inst,nil,offset)
                end
            
                inst:DoTaskInTime(0.4,function()
                    for roa = 0,2 * PI,2 * PI / 8 do
                        local offset = Vector3(math.cos(roa),0,math.sin(roa)) * 4
                        SpawnAt("firesplash_fx",inst,nil,offset)
                    end
                end)
            end)
        end

        
    end
}),
TzEntity.CreateNormalEntity({
    prefabname = "tz_pugalisk_meteor_remain",

    assets = {
        Asset("ANIM", "anim/tz_python_fx.zip"),
    },

    bank = "tz_python_fx",
    build = "tz_python_fx",
    anim = "stone_loop",

    tags = {"tz_pugalisk_token","boulder"},

    clientfn = function(inst)
        MakeObstaclePhysics(inst,1)
    end,

    serverfn = function(inst)
        inst.releasing_spore = nil 

        inst.Physics:SetCollisionCallback(function(inst,other)
            if other and other:IsValid() 
                and other:HasTag("player") 
                and not other:HasTag("playerghost") 
                and other.components.debuffable then
                    
                other.components.debuffable:AddDebuff("tz_pugalisk_meteor_fire_debuff","tz_pugalisk_meteor_fire_debuff")
            end
        end)

        inst:AddComponent("timer")

        inst:AddComponent("combat")
        inst.components.combat:SetHurtSound("dontstarve/wilson/use_pick_rock")

        inst:AddComponent("health")
        inst.components.health:SetMaxHealth(TUNING.TZ_PUGALISK_CONFIG.METEOR_REMAIN_HEALTH)

        inst:AddComponent("savedscale")

        inst:ListenForEvent("timerdone",function(inst,data)
            if data.name == "releasing_spore" then 
                inst.releasing_spore = inst:DoPeriodicTask(2,function()
                    inst:ReleaseSporeFn()
                end)
            elseif data.name == "explode" then
                SpawnAt("explode_boomtong",inst)
                SpawnAt("firering_fx",inst,{1.2,1.2,1.2})
                
                local splashnum = 8
                local pos = inst:GetPosition()
                for rota = 0,PI * 2,PI * 2/splashnum  do 
                    local offset = Vector3(math.random()*10*math.cos(rota),0,math.random()*10*math.sin(rota))
                    SpawnAt("firesplash_fx",pos+offset)
                end 

                local x,y,z = inst.Transform:GetWorldPosition()
                local ents = TheSim:FindEntities(x,y,z,12,{"_combat","_health"},NON_SMASHABLE_TAGS)
                for k,v in pairs(ents) do 
                    if not v.components.health:IsDead() then
                        if not v.components.debuffable then
                            v:AddComponent("debuffable")
                        end
                        v.components.debuffable:AddDebuff("tz_pugalisk_meteor_fire_debuff","tz_pugalisk_meteor_fire_debuff")
                        
                        v.components.combat:GetAttacked(inst, 1000)
                    end
                end

                inst:Remove()
            end
        end)

        inst.ReleaseSporeFn = function(inst)
            local x,y,z = inst:GetPosition():Get()
            local other_spores = TheSim:FindEntities(x,y,z,33,{"tz_pugalisk_token","spore","_combat","_health"},{"INLIMBO"})
            
            if #other_spores >= 25 then
                return
            end
            -- TODO:Release spore here
            -- tz_pugalisk_meteor_spore
            local rotate = GetRandomMinMax(0,2 * PI)
            local offset = Vector3(math.cos(rotate),0,math.sin(rotate)) * inst:GetPhysicsRadius(0.5)
            SpawnAt("tz_pugalisk_meteor_spore",inst,nil,offset)
        end

        inst.OnSave = function(inst,data)
            data.releasing_spore = (inst.releasing_spore ~= nil)
        end

        inst.OnLoad = function(inst,data)
            if data ~= nil then
                if data.releasing_spore ~= nil and data.releasing_spore == true then
                    inst.releasing_spore = inst:DoPeriodicTask(2,function()
                        inst:ReleaseSporeFn()
                    end)
                end
            end
        end
    end,
}),
-- ThePlayer.components.debuffable:AddDebuff("tz_pugalisk_meteor_fire_debuff","tz_pugalisk_meteor_fire_debuff")
TzDebuffUtil.CreateTzDebuff({
    prefab = "tz_pugalisk_meteor_fire_debuff",

    OnAttached = function(inst,target)
        local damage_per_second = 15
        local period = 1
        inst.task = inst:DoPeriodicTask(period,function()
            if target.components.health then
                target.components.health:DoFireDamage(damage_per_second * (period + FRAMES), inst, true)
            end
        end)

        inst.firefx = SpawnFireFx(target)
    end,

    OnDetached = function(inst,target)
        if inst.firefx and inst.firefx:IsValid() then
            if inst.firefx.components.firefx ~= nil and inst.firefx.components.firefx:Extinguish() then
                inst.firefx:ListenForEvent("animover", inst.firefx.Remove)
                inst.firefx:DoTaskInTime(inst.firefx.AnimState:GetCurrentAnimationLength() + FRAMES, inst.firefx.Remove)
            else
                inst.firefx:Remove()
            end
            inst.firefx = nil 
        end
    end,

    duration = TUNING.TZ_PUGALISK_CONFIG.METEOR_FIRE_DEBUFF_DURATION,

    keepondespawn = false,
}),
TzEntity.CreateNormalEntity({
    prefabname = "tz_pugalisk_meteor_spore",

    assets = {
        Asset("ANIM", "anim/mushroom_spore.zip"),
        Asset("ANIM", "anim/mushroom_spore_red.zip"),
        Asset("ANIM", "anim/mushroom_spore_blue.zip"),
    },

    bank = "mushroom_spore",
    build = "mushroom_spore_red",
    anim = "flight_cycle",
    loop_anim = true,

    tags = {"tz_pugalisk_token","spore"},

    clientfn = function(inst)
        inst.entity:AddPhysics()
        inst.entity:AddLight()
        inst.entity:AddDynamicShadow()

        inst.DynamicShadow:SetSize(.8, .5)

        inst.Light:SetColour(197/255, 126/255, 126/255)
	    inst.Light:SetIntensity(0.75)
	    inst.Light:SetFalloff(0.5)
	    inst.Light:SetRadius(2)
	    inst.Light:Enable(true)

        -- MakeCharacterPhysics(inst,1,0.5)
        inst.Physics:SetMass(1)
        inst.Physics:SetFriction(0)
        inst.Physics:SetDamping(5)
        inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
        inst.Physics:ClearCollisionMask()
        inst.Physics:CollidesWith((TheWorld.has_ocean and COLLISION.GROUND) or COLLISION.WORLD)
        inst.Physics:CollidesWith(COLLISION.OBSTACLES)
        inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
        inst.Physics:CollidesWith(COLLISION.CHARACTERS)
        inst.Physics:CollidesWith(COLLISION.GIANTS)
        inst.Physics:CollidesWith(COLLISION.FLYERS)
        inst.Physics:SetCapsule(0.5, 1)
    end,

    serverfn = function(inst)
        inst.Physics:SetCollisionCallback(function(inst,other)
            if other and other:IsValid() 
                and other.components.combat 
                and not other:HasTag("tz_pugalisk") 
                and not other:HasTag("tz_pugalisk_token") then

                inst:Explode()
            end
        end)

        inst:AddComponent("inspectable")

        inst:AddComponent("locomotor")
        inst.components.locomotor:EnableGroundSpeedMultiplier(false)
	    inst.components.locomotor:SetTriggersCreep(false)
	    inst.components.locomotor.walkspeed = 4

        inst:AddComponent("combat")

        inst:AddComponent("health")
        inst.components.health:SetMaxHealth(100)


        inst:SetStateGraph("SGspore")

        inst.Explode = function(inst)
            SpawnAt("explode_boomtong",inst,{0.5,0.5,0.5})
            SpawnAt("firering_fx",inst,{0.6,0.6,0.6})
            
            local splashnum = 8
            local pos = inst:GetPosition()
            for rota = 0,PI * 2,PI * 2/splashnum  do 
                local offset = Vector3(math.random()*5*math.cos(rota),0,math.random()*5*math.sin(rota))
                SpawnAt("firesplash_fx",pos,{0.5,0.5,0.5},offset)
            end 

            local x,y,z = inst.Transform:GetWorldPosition()
            local ents = TheSim:FindEntities(x,y,z,6,{"_combat","_health"},NON_SMASHABLE_TAGS)
            for k,v in pairs(ents) do 
                if not v.components.health:IsDead() then
                    if not v.components.debuffable then
                        v:AddComponent("debuffable")
                    end
                    v.components.debuffable:AddDebuff("tz_pugalisk_meteor_fire_debuff","tz_pugalisk_meteor_fire_debuff")
                    
                    v.components.combat:GetAttacked(inst, 500)
                end
            end

            inst:Remove()
        end

        inst:DoPeriodicTask(1,function()
            local x,y,z = inst:GetPosition():Get()
            local target = FindClosestPlayer(x,y,z,true)
            if target then
                local ac = BufferedAction(inst, target, ACTIONS.WALKTO)
                ac.distance = 0
                inst.components.locomotor:GoToEntity(target,ac,false)
            end
        end)

        -- BufferedAction( c_findnext("tz_pugalisk_meteor_spore"), target, ACTIONS.WALKTO)

        inst:ListenForEvent("death",inst.Explode)
    end,
})