require("stategraphs/commonstates")

local function DoSwarmAttack(inst)
    inst.components.combat:SetDefaultDamage(20)
    inst.components.combat:DoAreaAttack(inst, 6, nil, nil, nil, { "INLIMBO", "notarget", "invisible", "noattack", "flight", "playerghost", "player", "glommer", "chester", "shadow_ly", "shadow_ly2" })
end

local function DoSwarmFX(inst)
    local fx = SpawnPrefab("shadow_bishop_fx")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx.Transform:SetScale(inst.Transform:GetScale())
    --fx.AnimState:SetMultColour(inst.AnimState:GetMultColour())
end

local actionhandlers =
{    

    ActionHandler(ACTIONS.PICK, "dolongaction"),
    ActionHandler(ACTIONS.PICKUP, "doshortaction"),
    ActionHandler(ACTIONS.HARVEST, "dolongaction"),

    ActionHandler(ACTIONS.CHOP,
        function(inst)
            if not inst.sg:HasStateTag("prechop") then
                return inst.sg:HasStateTag("chopping")
                    and "chop"
                    or "chop_start"
            end
        end),
    ActionHandler(ACTIONS.MINE, 
        function(inst) 
            if not inst.sg:HasStateTag("premine") then
                return inst.sg:HasStateTag("mining")
                    and "mine"
                    or "mine_start"
            end
        end),
    ActionHandler(ACTIONS.DIG,
        function(inst)
            if not inst.sg:HasStateTag("predig") then
                return inst.sg:HasStateTag("digging")
                    and "dig"
                    or "dig_start"
            end
        end),
}

local events =
{
    CommonHandlers.OnLocomote(true, false),
    CommonHandlers.OnAttacked(),
    CommonHandlers.OnDeath(),
   -- CommonHandlers.OnAttack(),

    EventHandler("doattack", function(inst)   --可以进行普通攻击时，收到这个事件
        --local age = inst.components.age and inst.components.age:GetAgeInDays() or 0  inst))))

        if not inst.sg:HasStateTag("busy") and inst.components.health ~= nil and not inst.components.health:IsDead() then
            if inst.level >= 1 and math.random() <= 0.2 and inst.prefab == "shadow_ly" then
                   inst.sg:GoToState("attack_shadow", inst.components.combat.target)  --DebugSpawn"shadow_ly".sg:GoToState("attack_shadow", GetPlayer())
            else 
                inst.sg:GoToState("attack", inst.components.combat.target)
            end
        end
    end),

    EventHandler("dance", function(inst)
        if not (inst.sg:HasStateTag("dancing") or inst.sg:HasStateTag("busy")) then
            inst.sg:GoToState("dance")
        end
    end),
}

local states =
{
    State{
        name = "idle",
        tags = {"idle", "canrotate"},

        onenter = function(inst, pushanim)
            inst.Physics:Stop() 

            if inst.prefab == "shadow_ly" then
                  inst.AnimState:PlayAnimation("idle_loop", true)
            else           
                  inst.AnimState:PlayAnimation("idle_groggy_pre")
                  inst.AnimState:PushAnimation("idle_groggy", true)
            end      
        end,
    },

    State{
        name = "powerup_wurt",
        tags = { "busy", "pausepredict", "nomorph" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("powerup")
            inst.SoundEmitter:PlaySound("dontstarve/characters/wolfgang/grow_medtolrg")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                    inst.sg:GoToState("idle")
            end),
        },
    },    


    State{
        name = "doshortaction",
        tags = { "doing", "busy", "nodangle" },

        onenter = function(inst)
            inst.sg:SetTimeout(0.35)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("pickup")
            inst.AnimState:PushAnimation("pickup_pst", false)
        end,

        timeline =
        {
            TimeEvent(3 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
            end),
        },

        ontimeout = function(inst)
            inst:PerformBufferedAction()
        end,

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            inst:ClearBufferedAction()
        end,
    },

    State{
        name = "dolongaction",
        tags = { "doing", "busy", "nodangle" },

        onenter = function(inst)
            inst.sg:SetTimeout(1)
            inst.components.locomotor:Stop()
            inst.SoundEmitter:PlaySound("dontstarve/wilson/make_trap", "make")
            inst.AnimState:PlayAnimation("build_pre")
            inst.AnimState:PushAnimation("build_loop", true)
        end,

        timeline =
        {
            TimeEvent(4 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
            end),
        },

        ontimeout = function(inst)
            inst.SoundEmitter:KillSound("make")
            inst.AnimState:PlayAnimation("build_pst")
            inst:PerformBufferedAction()
        end,

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            inst.SoundEmitter:KillSound("make")
            inst:ClearBufferedAction()
        end,
    },

    State{
        name = "portal_jumpout",
        tags = { "busy", "nopredict", "nomorph", "noattack", "nointerrupt" },

        onenter = function(inst, dest)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("wortox_portal_jumpout")

            inst.sg:SetTimeout(14 * FRAMES)
            inst.components.health:SetInvincible(true)
        end,

        timeline =
        {
            TimeEvent(FRAMES, function(inst)
                  local fx = SpawnPrefab("wortox_portal_jumpout_fx")
                  fx.Transform:SetPosition(inst.Transform:GetWorldPosition())

                  inst.SoundEmitter:PlaySound("dontstarve/characters/wortox/soul/hop_out")
            end),

            TimeEvent(7 * FRAMES, function(inst)
                inst.components.health:SetInvincible(false)
                inst.sg:RemoveStateTag("noattack")
                inst.SoundEmitter:PlaySound("dontstarve/movement/bodyfall_dirt")
            end),
        },

        ontimeout = function(inst)
            inst.sg:GoToState("idle", true)
        end,

        onexit = function(inst)
            inst.components.health:SetInvincible(false)
        end,
    },

    State{
        name = "run_start",
        tags = {"moving", "running", "canrotate"},

        onenter = function(inst)
            inst.components.locomotor:RunForward()

             if inst.prefab == "shadow_ly" then
                    inst.AnimState:PlayAnimation("run_pre")
             else    
                    inst.AnimState:PlayAnimation("idle_walk_pre")
             end             
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("run")
                end
            end),
        },
    },

    State{
        name = "run",
        tags = {"moving", "running", "canrotate"},

        onenter = function(inst)
            inst.components.locomotor:RunForward()

            if inst.prefab == "shadow_ly" and not inst.AnimState:IsCurrentAnimation("run_loop") then 
                   inst.AnimState:PlayAnimation("run_loop", true)

            elseif inst.prefab ~= "shadow_ly" then   
                   inst.AnimState:PlayAnimation("idle_walk", true)
            end 

            inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("run")
        end,
    },

    State{
        name = "run_stop",
        tags = {"canrotate", "idle"},

        onenter = function(inst)
            inst.Physics:Stop()

            if inst.prefab == "shadow_ly" then
                 inst.AnimState:PlayAnimation("run_pst")
            else    
                 inst.AnimState:PlayAnimation("idle_walk_pst")
            end               
        end,
    },

    State{
        name = "attack",
        tags = {"attack", "notalking", "abouttoattack", "busy"},

        onenter = function(inst)
            inst.sg.statemem.target = inst.components.combat.target
            inst.components.combat:StartAttack()
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("atk")
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_nightsword")

            if inst.components.combat.target ~= nil and inst.components.combat.target:IsValid() then
                inst:FacePoint(inst.components.combat.target.Transform:GetWorldPosition())
            end
        end,

        timeline =
        {
            TimeEvent(8*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) inst.sg:RemoveStateTag("abouttoattack") end),
            TimeEvent(12*FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
            end),
            TimeEvent(13*FRAMES, function(inst)
                inst.sg:RemoveStateTag("attack")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },

    State{
        name = "attack_shadow",
        tags = { "attack", "busy", "shadowatk" },

        onenter = function(inst, target)
            if target ~= nil and target:IsValid() then
                inst.sg.statemem.target = target
                inst.sg.statemem.targetpos = target:GetPosition()
            end
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.Transform:SetScale(1.5, 1.5, 1.5)

            DoSwarmFX(inst)

            inst.AnimState:SetBank("shadow_bishop")
            inst.AnimState:SetBuild("shadow_bishop")
            inst.AnimState:PlayAnimation("atk_side_pre")
        end,

        onupdate = function(inst)
            if inst.sg.statemem.target ~= nil then
                if inst.sg.statemem.target:IsValid() then
                    inst.sg.statemem.targetpos = inst.sg.statemem.target:GetPosition()
                else
                    inst.sg.statemem.target = nil
                end
            end
        end,

        timeline =
        {
            TimeEvent(8 * FRAMES, function(inst)
                inst.sg:AddStateTag("noattack")
                inst.components.health:SetInvincible(true)
                inst.SoundEmitter:PlaySound("dontstarve/sanity/bishop/attack_1", "attack")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg.statemem.attack = true
                    inst.sg:GoToState("attack_shadow_loop", { target = inst.sg.statemem.target, targetpos = inst.sg.statemem.targetpos })
                end
            end),
        },

        onexit = function(inst)
              if inst.level == 1 then
                      inst.components.combat:SetDefaultDamage(60)

                 elseif inst.level == 2 then
                      inst.components.combat:SetDefaultDamage(75)
             end

            if not inst.sg.statemem.attack then
                inst.components.health:SetInvincible(false)
                inst.SoundEmitter:KillSound("attack")
            end
        end,
    },

    State{
        name = "attack_shadow_loop",
        tags = { "attack", "busy", "noattack", "shadowatk" },

        onenter = function(inst, data)
            inst.components.health:SetInvincible(true)
            if data.targetpos ~= nil then
                inst.Physics:Teleport(data.targetpos:Get())
                if data.target ~= nil and data.target:IsValid() then
                    local scale = inst.Transform:GetScale()
                    inst.sg.statemem.speed = 2 / scale
                    inst.sg.statemem.target = data.target
                    if inst:IsNear(data.target, .5) then
                        inst.Physics:Stop()
                    else
                        inst:ForceFacePoint(data.target.Transform:GetWorldPosition())
                        inst.Physics:SetMotorVel(inst.sg.statemem.speed, 0, 0)
                    end
                end
            end
            inst.AnimState:PlayAnimation("atk_side_loop_pre")

            inst.sg.statemem.task = inst:DoPeriodicTask(TUNING.SHADOW_BISHOP.ATTACK_TICK, DoSwarmAttack, TUNING.SHADOW_BISHOP.ATTACK_START_TICK)
            inst.sg.statemem.fxtask = inst:DoPeriodicTask(1.2, DoSwarmFX, .5)

            inst.sg:SetTimeout(130 * FRAMES)
        end,

        onupdate = function(inst)
            if inst.sg.statemem.target ~= nil then
                if not inst.sg.statemem.target:IsValid() then
                    inst.sg.statemem.target = nil
                elseif inst:IsNear(inst.sg.statemem.target, .5) then
                    inst.Physics:Stop()
                else
                    inst:ForceFacePoint(inst.sg.statemem.target.Transform:GetWorldPosition())
                    inst.Physics:SetMotorVel(inst.sg.statemem.speed, 0, 0)
                end
            end
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() and inst.AnimState:IsCurrentAnimation("atk_side_loop_pre") then
                    --V2C: 1) we don't push this anim coz it might make the pre anim loop on clients
                    --     2) we loop this anim and use timeout so that it looks smoother on clients
                    inst.AnimState:PlayAnimation("atk_side_loop", true)
                end
            end),
        },

        ontimeout = function(inst)
            inst.sg.statemem.attack = true
            inst.sg:GoToState("attack_shadow_loop_pst", inst.sg.statemem.target)
        end,

        onexit = function(inst)
            inst.sg.statemem.task:Cancel()
            inst.sg.statemem.fxtask:Cancel() 

              if inst.level == 1 then
                      inst.components.combat:SetDefaultDamage(60)

                 elseif inst.level == 2 then
                      inst.components.combat:SetDefaultDamage(75)
             end

            if not inst.sg.statemem.attack then
                inst.components.health:SetInvincible(false)
                inst.SoundEmitter:KillSound("attack")
            end
        end,
    },

    State{
        name = "attack_shadow_loop_pst",
        tags = { "attack", "busy", "noattack", "shadowatk" },

        onenter = function(inst, target)
            inst.sg.statemem.target = target
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("atk_side_loop_pst")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    local pos = inst.sg.statemem.target ~= nil and inst.sg.statemem.target:IsValid() and inst.sg.statemem.target:GetPosition() or inst:GetPosition()
                    local bestoffset = nil
                    local minplayerdistsq = math.huge
                    for i = 1, 4 do
                        local offset = FindWalkableOffset(pos, math.random() * 2 * PI, 8 + math.random() * 2, 4, false, true)
                        if offset ~= nil then
                            local player, distsq = FindClosestPlayerInRange(pos.x + offset.x, 0, pos.z + offset.z, 6, true)
                            if player == nil then
                                bestoffset = offset
                                break
                            elseif distsq < minplayerdistsq then
                                bestoffset = offset
                                minplayerdistsq = distsq
                            end
                        end
                    end
                    if bestoffset ~= nil then
                        inst.Physics:Teleport(pos.x + bestoffset.x, 0, pos.z + bestoffset.z)
                    end
                    inst.sg.statemem.attack = true
                    inst.sg:GoToState("portal_jumpout")
                end
            end),
        },

        onexit = function(inst)
            inst.AnimState:SetBank("wilson")
            inst.AnimState:SetBuild("ly_follower")
            inst.Transform:SetScale(1, 1, 1)
            inst.components.health:SetInvincible(false)

              if inst.level == 1 then
                      inst.components.combat:SetDefaultDamage(60)

                 elseif inst.level == 2 then
                      inst.components.combat:SetDefaultDamage(75)
             end 

            inst.SoundEmitter:KillSound("attack")
        end,
    },

    State{
        name = "attack_shadow_pst",
        tags = { "attack", "busy", "noattack", "shadowatk" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("atk_side_pst")
        end,

        timeline =
        {
            TimeEvent(21 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("noattack")
                inst.sg:RemoveStateTag("busy")
                inst.components.health:SetInvincible(false)
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                     inst.sg:GoToState("portal_jumpout")
                end
            end),
        },

        onexit = function(inst)
            inst.AnimState:SetBank("wilson")
            inst.AnimState:SetBuild("ly_follower")
            inst.Transform:SetScale(1, 1, 1)
            inst.components.health:SetInvincible(false)

              if inst.level == 1 then
                      inst.components.combat:SetDefaultDamage(60)

                 elseif inst.level == 2 then
                      inst.components.combat:SetDefaultDamage(75)
             end                  
        end,
    },

    State{
        name = "death",
        tags = {"busy"},

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:Hide("swap_arm_carry")
            inst.AnimState:PlayAnimation("death")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    local x, y, z = inst.Transform:GetWorldPosition()
                    SpawnPrefab("shadow_despawn").Transform:SetPosition(x, y, z)
                    SpawnPrefab("statue_transition_2").Transform:SetPosition(x, y, z)
                    inst:Remove()
                end
            end),
        },
    },

    State{
        name = "hit",
        tags = {"busy"},

        onenter = function(inst)
            inst:ClearBufferedAction()
            inst.AnimState:PlayAnimation("hit")
            inst.Physics:Stop()
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        timeline =
        {
            TimeEvent(3*FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
            end),
        },
    },

    State{
        name = "stunned",
        tags = {"busy", "canrotate"},

        onenter = function(inst)
            inst:ClearBufferedAction()
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("idle_sanity_pre")
            inst.AnimState:PushAnimation("idle_sanity_loop", true)
            inst.sg:SetTimeout(5)
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("idle")
        end,
    },

    State{
        name = "chop_start",
        tags = {"prechop", "working"},

        onenter = function(inst)
            local buffaction = inst:GetBufferedAction()
            inst.sg.statemem.target = buffaction ~= nil and buffaction.target or nil

            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("chop_pre")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("chop")
                end
            end),
        },
    },

    State{
        name = "chop",
        tags = {"prechop", "chopping", "working"},

        onenter = function(inst)
            local buffaction = inst:GetBufferedAction()
            inst.sg.statemem.target = buffaction ~= nil and buffaction.target or nil

            inst.AnimState:PlayAnimation("chop_loop")
        end,

        timeline =
        {
            TimeEvent(2 * FRAMES, function(inst)
                inst:PerformBufferedAction()
            end),

            --NOTE: This is one frame off from SGwilson's since it was
            --      too slow when coupled with our brain update period
            TimeEvent(13 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("prechop")
            end),

            TimeEvent(16*FRAMES, function(inst)
                inst.sg:RemoveStateTag("chopping")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },

    State{
        name = "mine_start",
        tags = {"premine", "working"},

        onenter = function(inst)
            local buffaction = inst:GetBufferedAction()
            inst.sg.statemem.target = buffaction ~= nil and buffaction.target or nil

            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("pickaxe_pre")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("mine")
                end
            end),
        },
    },

    State{
        name = "mine",
        tags = {"premine", "mining", "working"},

        onenter = function(inst)
            local buffaction = inst:GetBufferedAction()
            inst.sg.statemem.target = buffaction ~= nil and buffaction.target or nil

            inst.AnimState:PlayAnimation("pickaxe_loop")
        end,

        timeline =
        {
            TimeEvent(7 * FRAMES, function(inst)
                local buffaction = inst:GetBufferedAction()
                if buffaction ~= nil then
                    local target = buffaction.target
                    if target ~= nil and target:IsValid() then
                        if target.Transform ~= nil then
                            SpawnPrefab("mining_fx").Transform:SetPosition(target.Transform:GetWorldPosition())
                        end
                        inst.SoundEmitter:PlaySound(target:HasTag("frozen") and "dontstarve_DLC001/common/iceboulder_hit" or "dontstarve/wilson/use_pick_rock")
                    end
                    inst:PerformBufferedAction()
                end
            end),

            TimeEvent(14 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("premine")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst) 
                if inst.AnimState:AnimDone() then
                    inst.AnimState:PlayAnimation("pickaxe_pst") 
                    inst.sg:GoToState("idle", true)
                end
            end),
        },
    },

    State{
        name = "dig_start",
        tags = {"predig", "working"},

        onenter = function(inst)
            local buffaction = inst:GetBufferedAction()
            inst.sg.statemem.target = buffaction ~= nil and buffaction.target or nil

            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("shovel_pre")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("dig")
                end
            end),
        },
    },

    State{
        name = "dig",
        tags = {"predig", "digging", "working"},

        onenter = function(inst)
            local buffaction = inst:GetBufferedAction()
            inst.sg.statemem.target = buffaction ~= nil and buffaction.target or nil

            inst.AnimState:PlayAnimation("shovel_loop")
        end,

        timeline =
        {
            TimeEvent(15 * FRAMES, function(inst)
                inst:PerformBufferedAction()
                inst.SoundEmitter:PlaySound("dontstarve/wilson/dig")
            end),

            TimeEvent(35 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("predig")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.AnimState:PlayAnimation("shovel_pst")
                    inst.sg:GoToState("idle", true)
                end
            end),
        },
    },

    State{
        name = "dance",
        tags = {"idle", "dancing"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst:ClearBufferedAction()
            if inst.AnimState:IsCurrentAnimation("run_pst") then
                inst.AnimState:PushAnimation("emoteXL_pre_dance0")
            else
                inst.AnimState:PlayAnimation("emoteXL_pre_dance0")
            end
            inst.AnimState:PushAnimation("emoteXL_loop_dance0", true)
        end,
    },

    State{
        name = "jumpout",
        tags = { "busy", "canrotate", "jumping" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("jumpout")
            inst.Physics:SetMotorVel(4, 0, 0)
            inst.Physics:ClearCollisionMask()
            inst.Physics:CollidesWith(COLLISION.GROUND)
        end,

        timeline =
        {
            TimeEvent(10 * FRAMES, function(inst)
                inst.Physics:SetMotorVel(3, 0, 0)
            end),
            TimeEvent(15 * FRAMES, function(inst)
                inst.Physics:SetMotorVel(2, 0, 0)
            end),
            TimeEvent(15.2 * FRAMES, function(inst)
                inst.sg.statemem.physicson = true
                inst.Physics:ClearCollisionMask()
                inst.Physics:CollidesWith(COLLISION.WORLD)
                inst.Physics:CollidesWith(COLLISION.CHARACTERS)
                inst.Physics:CollidesWith(COLLISION.GIANTS)
            end),
            TimeEvent(17 * FRAMES, function(inst)
                inst.Physics:SetMotorVel(1, 0, 0)
            end),
            TimeEvent(18 * FRAMES, function(inst)
                inst.Physics:Stop()
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if not inst.sg.statemem.physicson then
                inst.Physics:ClearCollisionMask()
                inst.Physics:CollidesWith(COLLISION.WORLD)
                inst.Physics:CollidesWith(COLLISION.CHARACTERS)
                inst.Physics:CollidesWith(COLLISION.GIANTS)
            end
        end,
    },
}

return StateGraph("lyfollower", states, events, "portal_jumpout", actionhandlers)
