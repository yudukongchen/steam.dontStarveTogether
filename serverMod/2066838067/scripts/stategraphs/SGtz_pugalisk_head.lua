require("stategraphs/commonstates")

local pu = require ("prefabs/tz_pugalisk_util")

local actionhandlers = {

}

local SHAKE_DIST = 40

local function dogroundpound(inst)
    -- inst.components.groundpounder:GroundPound()
    ShakeAllCameras(CAMERASHAKE.FULL, .2, .02, .25, inst, SHAKE_DIST)
end

local function SpawnSoundRing(inst)
    local beam = SpawnPrefab("tz_python_ring_fx")
    local pt = Vector3(inst.Transform:GetWorldPosition())
    local angle = inst.Transform:GetRotation() * DEGREES
    local radius = 4 
    local offset = Vector3(radius * math.cos( angle ), 0, -radius * math.sin( angle ))
    local newpt = pt+offset

    beam.host = inst

    beam.Transform:SetPosition(newpt.x,newpt.y,newpt.z)
    
    beam.Transform:SetRotation(inst.Transform:GetRotation())

    beam.Physics:SetMotorVel(33,0,0)

    inst.SoundEmitter:PlaySound("dontstarve/creatures/lava_arena/trails/taunt")

    return beam
end


local events=
{
    EventHandler("tail_should_exit", function(inst) 
        inst:AddTag("should_exit")
        inst.sg:GoToState("tail_exit") 
    end),


    EventHandler("attacked", function(inst,data)         
        if inst.sg:HasStateTag("idle") and not inst:HasTag("tail") and not data.redirected then 
            inst.sg:GoToState("hit")
        end        
    end),

    EventHandler("doattack", function(inst, data)         
        if not inst.components.health:IsDead() then
            if inst:HasTag("tail") then

            else 
                inst.sg:GoToState("attack", data.target) 
            end
            
        end
    end),

    EventHandler("death", function(inst) 
        if inst:HasTag("tail") then
            inst.sg:GoToState("tail_exit")
        else
            for k = 1, math.random(3) do
                if math.random() <= (1 - inst.loot_decrease_percent) then
                    inst.components.lootdropper:SpawnLootPrefab("tz_pugalisk_crystal",inst:GetPosition())
                end 
            end
            local atrium_key = inst.components.lootdropper:SpawnLootPrefab("atrium_key",inst:GetPosition())

            
            if inst.sg:HasStateTag("underground") then
                inst.sg:GoToState("death_underground") 
            else
                inst.sg:GoToState("death") 
            end
        end
    end),

    EventHandler("backup", function(inst) 
        if not inst.sg:HasStateTag("backup") and not inst.components.health:IsDead() then
            inst.sg:GoToState("backup") 
        end
    end),

    EventHandler("premove", function(inst) 
        if not inst.sg:HasStateTag("backup") and not inst.components.health:IsDead() and  not inst.sg:HasStateTag("busy") then
            inst.sg:GoToState("startmove") 
        end
    end),

    EventHandler("emerge", function(inst) 
        if not inst.components.health:IsDead() then
            inst.sg:GoToState("emerge") 
        end
    end),    
  
    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),
   
}

local function GetFaceVector(inst,add)
	local angle = (inst.Transform:GetRotation() + 90 + (add or 0)) * DEGREES
	local sinangle = math.sin(angle)
	local cosangle = math.cos(angle)

	return Vector3(sinangle,0,cosangle)
end 

local function LaunchFantaBlade(inst,spawn_pos,target_pos,anim_type,speed)
    local proj = SpawnAt("tz_jianqi",spawn_pos)
    proj.caster = inst
    proj.anim_type = anim_type
    proj.NO_TAGS = {"tz_pugalisk"}
    proj.damage = 187.5
    proj.modify_scale = 2.25
    proj:Launch(inst,target_pos,speed)
end

local states=
{
    State{
        name = "death_underground",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.AnimState:PlayAnimation("death_underground")            
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)
              
        end,

        events=
        {
            EventHandler("animover", function(inst)
                if not inst:HasTag("tail") then
                    -- local corpse = SpawnPrefab("pugalisk_corpse")
                    -- local pt = Vector3(inst.Transform:GetWorldPosition())
                    -- corpse.Transform:SetPosition(pt.x,pt.y,pt.z)
                    inst:Remove()
                end
            end),
        }, 
    },

    State{
        name = "death",
        tags = {"busy"},
        
        onenter = function(inst)
           -- inst.SoundEmitter:PlaySound(SoundPath(inst, "die"))
            if inst:HasTag("tail") then
                inst.AnimState:PlayAnimation("tail_idle_pst")
                inst.AnimState:PushAnimation("dirt_collapse_slow", false)
                
            else
                inst.AnimState:PlayAnimation("death")
            end
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)            
        end,

        timeline=
        {
            TimeEvent(20*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/pugalisk/death") end),
        },

        events=
        {
            EventHandler("animover", function(inst)
                if not inst:HasTag("tail") then
                    -- local corpse = SpawnPrefab("pugalisk_corpse")
                    -- local pt = Vector3(inst.Transform:GetWorldPosition())
                    -- corpse.Transform:SetPosition(pt.x,pt.y,pt.z)
                    inst:Remove()
                end
            end),
        }, 
    },    
        
    State{
        name = "idle",
        tags = {"idle", "canrotate"},
        
        onenter = function(inst, start_anim)
            inst.Physics:Stop()
            if inst:HasTag("tail") then
                if start_anim then
                    inst.AnimState:PlayAnimation(start_anim)
                    inst.AnimState:PushAnimation("tail_idle_loop", true)
                else
                    inst.AnimState:PlayAnimation("tail_idle_loop", true)
                end
            else
                if start_anim then
                    inst.AnimState:PlayAnimation(start_anim)
                    inst.AnimState:PushAnimation("head_idle_loop", true)
                else
                    inst.AnimState:PlayAnimation("head_idle_loop", true)
                end
            end
        end,

        onupdate = function(inst)

            if not inst:HasTag("tail") then
                
                if inst.wantstotaunt then
                    inst.sg:GoToState("toung")
                end  

                if inst.wantstopremove then
                    inst.wantstopremove = nil
                    inst:PushEvent("premove")
                end
            end

            if inst:HasTag("tail") and inst:HasTag("should_exit") then
                inst.sg:GoToState("tail_exit")
            end
        end,        
    

        events=
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")  
            end),
        },        
    },   


    State{
        name = "hit",
        tags = {"canrotate"},

        onenter = function(inst, start_anim)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("hit")
        end,

        timeline=
        {
            TimeEvent(2*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/pugalisk/hit") end),
        },

        events=
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")  
            end),
        
        },        
    },


    State{
        name = "toung",
        tags = {"canrotate", "busy"},

        onenter = function(inst, start_anim)
            print("TAUNT")
            assert(not inst:HasTag("tail"))
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
            inst.wantstotaunt = nil
        end,

        timeline=
        {
            TimeEvent(15*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/pugalisk/taunt") end),
        },

        events=
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")  
            end),
        },        
    },   

    State{
        name = "emerge_taunt",
        tags = {"busy"},

        onenter = function(inst, start_anim)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("emerge_taunt")
            inst.wantstotaunt = nil
        end,

        timeline=
        {
            TimeEvent(1*FRAMES, function(inst)                     
                    -- inst.components.groundpounder.numRings = 3

                    dogroundpound(inst)

                    -- inst.components.groundpounder.numRings = 2
                    ---inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/pugalisk/taunt")
                    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/volcano/volcano_erupt")            

                end),
            TimeEvent(15*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/pugalisk/taunt") end),
            TimeEvent(15*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/pugalisk/attack") end),
        },

        events=
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")  
            end),
        },        
    },   



    State{
        name = "dirt_collapse",
        tags = {"busy"},

        onenter = function(inst, start_anim)
            inst.Physics:Stop()            
            inst.AnimState:PlayAnimation("dirt_collapse", false)            
        end,

        events=
        {
            EventHandler("animover", function(inst)
                inst:Remove()  
            end),
        },    
    },

    State{
        name = "tail_exit",
        tags = {"busy"},

        onenter = function(inst, start_anim)
            inst.Physics:Stop()            
            inst.AnimState:PlayAnimation("tail_idle_pst")            
        end,

        events=
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("dirt_collapse")
            end),
        },    
    },

    State{
        name = "tail_ready",
        tags = {"busy"},

        onenter = function(inst, start_anim)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("tail_idle_pre")
        end,

        events=
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")                
            end),
        },    
    },

    State{
        name = "sound_attack",
        tags = {"busy","canrotate"},

        onenter = function(inst,data)   
            data = data or {}
            inst.AnimState:SetBank("tz_python_test_2")
            inst.AnimState:PlayAnimation("soundattack")
            
            inst.sg.statemem.target = data.target 
            inst.sg.statemem.can_multi_cast = data.can_multi_cast 
            inst.sg.statemem.ready_to_cast_another = false 
            -- inst.sg.statemem.hitted_table = {}
            inst:ForceFacePoint(data.target:GetPosition():Get())

            SpawnAt("pugalisk_sound_attack_warn_fx",inst):ForceFacePoint(data.target:GetPosition():Get())
        end,

        timeline = {
            TimeEvent(1, function(inst) 
                inst.sg.statemem.beam = SpawnSoundRing(inst)
                inst.sg.statemem.beam:ListenForEvent("onremove",function(beam)
                    for entity,_ in pairs(beam.hitted_table) do
                        inst.sg.statemem.ready_to_cast_another = true  
                        break
                    end
                end)
            end),

            TimeEvent(1.2, function(inst) 
                SpawnSoundRing(inst).task:Cancel()
            end),
        },

        events=
        {
            -- EventHandler("onhitother", function(inst,data)           
            --     if inst.sg.statemem.can_multi_cast then
            --         inst.sg.statemem.ready_to_cast_another = true  
            --     end

                

            -- end),

            EventHandler("animover", function(inst,data)    
                -- print("Exit sound_attack,ready_to_cast_another:",inst.sg.statemem.ready_to_cast_another)     
                
                if inst.sg.statemem.beam and inst.sg.statemem.beam:IsValid() then
                    for entity,_ in pairs(inst.sg.statemem.beam.hitted_table) do
                        inst.sg.statemem.ready_to_cast_another = true  
                    end
                end
                
                if inst.sg.statemem.can_multi_cast and inst.sg.statemem.ready_to_cast_another then
                    local target = inst:PickSoundAttackTarget()
                    -- print("...and Target is",target)
                    if target then
                        inst.sg:GoToState("sound_attack",{
                            target = target,
                            can_multi_cast = inst.sg.statemem.can_multi_cast,
                        })
                    else 
                        inst.sg:GoToState("idle")
                    end
                else 
                    inst.sg:GoToState("idle")
                end
            end),
        },    

        onexit = function(inst)
            inst.AnimState:SetBank("giant_snake")
        end,
    },

    State{
        name = "roar",
        tags = {"busy"},

        onenter = function(inst,data)
            inst.AnimState:SetBank("tz_python_test_2")            

            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("summon_meteor_pre")

            inst.sg.statemem.data = data
        end,  

        onexit = function(inst)
            inst.AnimState:SetBank("giant_snake")
        end,

        events=
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("roar_loop",inst.sg.statemem.data)        
            end),
        },    
    },
    
    State{
        name = "roar_loop",
        tags = {"busy"},

        onenter = function(inst,data)
            inst.AnimState:SetBank("tz_python_test_2")            

            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("summon_meteor_loop",true)

            inst.sg.statemem.roar_cnt = data.roar_cnt

            local lightfx = SpawnPrefab("nightstickfire")
            lightfx.entity:SetParent(inst.entity)
            lightfx.entity:AddFollower()
            lightfx.Follower:FollowSymbol(inst.GUID, "nose_01", 0, -110, 0)      

            inst.sg.statemem.lightfx = lightfx

            inst:EnableRoar(TUNING.TZ_PUGALISK_CONFIG.ROAR_PERIOD,function()
                inst:DoTaskInTime(2 * FRAMES,function()
                    local x,y,z = inst:GetPosition():Get()
                    for k,v in pairs(TheSim:FindEntities(x,y,z,TUNING.TZ_PUGALISK_CONFIG.ROAR_RANGE,{"_combat","_health"},{"INLIMBO","tz_pugalisk","tz_pugalisk_token"})) do
                        if inst.components.combat:CanTarget(v) then
                            v.components.combat:GetAttacked(inst,TUNING.TZ_PUGALISK_CONFIG.ROAR_DAMAGE)
                        end
                    end
                end)
                inst.sg.statemem.roar_cnt = inst.sg.statemem.roar_cnt - 1

                if inst.sg.statemem.roar_cnt <= 0 then
                    inst.sg:GoToState("idle","summon_meteor_pst")
                end
            end)
        end,  

        onexit = function(inst)
            inst.AnimState:SetBank("giant_snake")
            inst:EnableRoar(false)
            if inst.sg.statemem.lightfx then
                inst.sg.statemem.lightfx:Remove()
            end
        end,
    },

    State{
        name = "meteor_summon",
        tags = {"busy"},

        onenter = function(inst,data)
            inst.AnimState:SetBank("tz_python_test_2")            

            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("summon_meteor_pre")
            inst.AnimState:PushAnimation("summon_meteor_loop",true)

            inst.sg:SetTimeout(TUNING.TZ_PUGALISK_CONFIG.METEOR_CAST_DURATION)

            inst.sg.statemem.damage_resolved = 0
            inst.sg.statemem.damage_resolved_max = data.damage_resolved_max or 200
            inst.sg.statemem.summon_task = inst:DoPeriodicTask(data.summon_period or 0.5,function()
                local valid_targets = {}
                for _,v in pairs(AllPlayers) do
                    if v and v:IsValid() and inst.components.combat:CanTarget(v) and v:IsNear(inst,TUNING.TZ_PUGALISK_CONFIG.METEOR_TARGET_RANGE) then
                        table.insert(valid_targets,v)
                    end
                end

                for _,v in pairs(valid_targets) do
                    inst:DoTaskInTime(GetRandomMinMax(0,0.1),function()
                        inst:LaunchMeteor(
                            data.is_big_meteor and "tz_pugalisk_meteor_huge" or "tz_pugalisk_meteor",
                            v:GetPosition()
                        )
                    end)
                end
            end)

            inst:EnableRoar(0.25)
        end,  

        ontimeout = function(inst)
            inst.sg:GoToState("idle","summon_meteor_pst")       
        end,

        onexit = function(inst)
            inst.AnimState:SetBank("giant_snake")

            if inst.sg.statemem.summon_task then
                inst.sg.statemem.summon_task:Cancel()
            end

            inst:EnableRoar(false)
        end,

        events=
        {
            EventHandler("attacked", function(inst,data)
                if data.attacker.prefab:find("meteor") then
                    return 
                end
                inst.sg.statemem.damage_resolved = inst.sg.statemem.damage_resolved + (data.damage or 0)
                if inst.sg.statemem.damage_resolved >= inst.sg.statemem.damage_resolved_max then
                    inst.sg:GoToState("stun")
                end
            end),
        },    
    },

    State{
        name = "laser_shoot",
        tags = {"busy"},

        onenter = function(inst,data)
            inst.Physics:Stop()

            inst:ForceFacePoint(data.pos:Get())

            inst.AnimState:SetBank("tz_python_test_2")            
            inst.AnimState:PlayAnimation("lasershoot")

            inst.sg.statemem.warn_fx = SpawnAt("pugalisk_lasershoot_warn_fx",inst)
            inst.sg.statemem.warn_fx:ForceFacePoint(data.pos:Get())

            
            inst.sg.statemem.pos = data.pos 
            inst.sg.statemem.start_lenght = 3
            inst.sg.statemem.cur_lenght = inst.sg.statemem.start_lenght
            inst.sg.statemem.lenght = data.length

            inst.sg.statemem.cur_duration = 0
            inst.sg.statemem.duration = data.duration
            
            
        end,  

        timeline = {
            TimeEvent(0.584,function(inst)
                inst.sg.statemem.attack_thread = inst:StartThread(function()
                    local delta_vec = (inst.sg.statemem.pos - inst:GetPosition()):GetNormalized()
                    local delta_length = inst.sg.statemem.lenght - inst.sg.statemem.start_lenght
    
                    while inst.sg.statemem.cur_lenght <= inst.sg.statemem.lenght do
                        local spawn_pos = inst:GetPosition() + delta_vec * inst.sg.statemem.cur_lenght
    
                        inst.sg.statemem.cur_lenght = inst.sg.statemem.start_lenght + delta_length * inst.sg.statemem.cur_duration / inst.sg.statemem.duration
                        inst.sg.statemem.cur_duration = inst.sg.statemem.cur_duration + FRAMES
    
                        SpawnAt("explode_firecrackers",spawn_pos)
    
                        Sleep(0)
                    end
                end)
            end),
        },


        onexit = function(inst)
            inst.AnimState:SetBank("giant_snake")
            if inst.sg.statemem.attack_thread then
                KillThread(inst.sg.statemem.attack_thread)
            end
        end,

        events=
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },    
    },

    State{
        name = "emerge",
        tags = {"busy"},

        onenter = function(inst, start_anim)
            inst.emerged = true
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("head_idle_pre")
        end,

        events=
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")                
            end),
        },    
    },

    State{
        name = "stun",
        tags = {"busy","stun"},

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:SetBank("tz_python_action_stun")
            inst.AnimState:PlayAnimation("sad")

            
        end,

        timeline = {
            TimeEvent(0.594,function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/lava_arena/trails/taunt")
            end),

            TimeEvent(2,function(inst)
                -- inst.sg.statemem.stun_fx = SpawnPrefab("tz_stunned_fx")
                -- inst.sg.statemem.stun_fx.AnimState:SetScale(2,2,2)
                -- inst.sg.statemem.stun_fx.Follower:FollowSymbol(inst.GUID,"skull01",150,70,0)
            end),

            TimeEvent(1.9,function(inst)
                ShakeAllCameras(CAMERASHAKE.FULL, .2, .02, .25, inst, SHAKE_DIST)
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/groundpound")
            end),

            TimeEvent(2.3,function(inst)
                ShakeAllCameras(CAMERASHAKE.FULL, .2, .02, .25, inst, SHAKE_DIST)
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/groundpound")
            end),

            TimeEvent(10.383,function(inst)
                if inst.sg.statemem.stun_fx then
                    inst.sg.statemem.stun_fx:Remove()
                    inst.sg.statemem.stun_fx = nil 
                end
            end)
        },

        events=
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")                
            end),
        },    

        onexit = function(inst)
            inst.AnimState:SetBank("giant_snake")
            if inst.sg.statemem.stun_fx then
                inst.sg.statemem.stun_fx:Remove()
            end
        end,
    },

    State{
        name = "spawn",
        tags = {"busy"},

        onenter = function(inst, start_anim)
            inst.emerged = true
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("head_idle_pre")
        end,

        events=
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("roar",{
                    roar_cnt = TUNING.TZ_PUGALISK_CONFIG.ROAR_COUNT,
                })          
            end),
        },    
    },

    

    State{
        name = "underground",
        tags = {"underground","invisible"},

        onenter = function(inst, start_anim)
            inst:Hide()
            inst.Physics:SetActive(false)
            inst.AnimState:PlayAnimation("head_idle_pre")
        end,

        onexit = function(inst)
            inst:Show()
            inst.Physics:SetActive(true)
            inst.movecommited = nil
        end,        
  
    },


    State{
        name = "startmove",
        tags = {"busy","backup"},

        onenter = function(inst, start_anim)
            inst:PushEvent("startmove")   
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("head_idle_pst")
        end,

        events=
        {
            EventHandler("animover", function(inst)
                local pos = Vector3(inst.Transform:GetWorldPosition())
                inst.components.tz_pugalisk_multibody:SpawnBody(inst.angle,0.3,pos)
                inst.sg:GoToState("underground")
            end),
        },    
    },

    State{
        name = "backup",
        tags = {"busy","backup"},

        onenter = function(inst, start_anim)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("head_idle_pst")
        end,

        events=
        {
            EventHandler("animover", function(inst)
                local hole = SpawnPrefab("tz_pugalisk_body")  
                hole:AddTag("exithole")    
                hole.Physics:SetActive(false)
                hole.Transform:SetPosition(inst.Transform:GetWorldPosition())
                hole.AnimState:PlayAnimation("dirt_collapse", false)
                hole:ListenForEvent("animover", function(inst, data)
                       hole:Remove()
                    end)                                    
                inst:DoTaskInTime(0.75, function() 
                    pu.recoverfrombadangle(inst) 
                    inst.movecommited = false

                    dogroundpound(inst)

                    inst.sg:GoToState("emerge")
                end)       
                inst.movecommited = true         
                inst.sg:GoToState("underground")

            end),
        },    
    },
    
    State{
        name = "hole",
        tags = {"busy"},

        onenter = function(inst, start_anim)
            inst.AnimState:SetBank("giant_snake")
            -- inst.AnimState:SetBuild("python_test")
            inst.AnimState:SetBuild("tz_python_test_2")
            

            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("dirt_static")
        end,  
    },   

    State{
        name = "attack",
        tags = {"attack", "canrotate", "busy",},
        
        onenter = function(inst, target)
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("atk")
            inst.sg.statemem.target = target
        end,
        
        timeline =
        {
            TimeEvent(3*FRAMES, function(inst)  
                inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/pugalisk/attack") 
            end),

            TimeEvent(6*FRAMES, function(inst)  
                inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/pugalisk/attack_pre") 
            end),

            TimeEvent(17*FRAMES, function(inst) 
                inst.components.combat:DoAttack(inst.sg.statemem.target) 
            end),

            TimeEvent(18*FRAMES, function(inst)  
                inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/pugalisk/bite") 
            end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },    
     
    State{
        name = "attack_tail",
        tags = {"attack", "canrotate", "busy",},
        
        onenter = function(inst, target_pos)
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("tail_smack")

            inst:ForceFacePoint(target_pos:Get())
        end,
        
        timeline =
        {
            TimeEvent(7*FRAMES, function(inst)  
                inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/pugalisk/tail_attack") 
            end),

            TimeEvent(8*FRAMES, function(inst) 
                local mypos = inst:GetPosition()

                local half_angle = 60 * 2/3
                for angle = -half_angle,half_angle,half_angle * 2 /4 do
                    local face_vec = GetFaceVector(inst,angle)
                    LaunchFantaBlade(inst,mypos + face_vec,mypos + face_vec * 28,"e",20)
                end
            end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },    
}

CommonStates.AddSleepStates(states,
{
	starttimeline = {
		TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("fallAsleep") end ),
	},
	sleeptimeline = 
	{
		TimeEvent(35*FRAMES, function(inst) inst.SoundEmitter:PlaySound("sleeping") end ),
	},
	waketimeline = {
		TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("wakeUp") end ),
	},
})
CommonStates.AddFrozenStates(states)

return StateGraph("SGpugalisk_head", states, events, "idle", actionhandlers)

