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

local exclude_tags = { "INLIMBO", "companion", "wall", "abigail", "wall", "player", "INLIMBO" }
local function DoAreaEleAtk(inst)
    local range = 2

    local x, y, z = inst.Transform:GetWorldPosition() 
    local ents = TheSim:FindEntities(x, y, z, range, { "_combat" }, exclude_tags)
    for k, v in pairs(ents) do
        if v and v:IsValid() and v.components.combat and v.components.health and not v.components.health:IsDead() then
              v.components.combat:GetAttacked(inst, 200)
        end            
    end     
end

local function DoSound(inst, sound)
    inst.SoundEmitter:PlaySound(sound)
end

local function TrySplashFX(inst, size)
    local x, y, z = inst.Transform:GetWorldPosition()
    if TheWorld.Map:IsOceanAtPoint(x, 0, z) then
        SpawnPrefab("ocean_splash_"..(size or "med")..tostring(math.random(2))).Transform:SetPosition(x, 0, z)
        return true
    end
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

    EventHandler("doattack", function(inst)   
        if not inst.sg:HasStateTag("busy") and inst.components.health ~= nil and not inst.components.health:IsDead() then   
            inst.sg:GoToState("attack", inst.components.combat.target)              
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
            inst.AnimState:PlayAnimation("idle_loop", true)    
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
            TimeEvent(4 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
            end),

            TimeEvent(6 * FRAMES, function(inst)
                print("捡起来")
                inst:PerformBufferedAction()
            end),          
        },

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
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
        name = "run_start",
        tags = {"moving", "running", "canrotate"},

        onenter = function(inst)
            inst.components.locomotor:RunForward()
            inst.AnimState:PlayAnimation("run_pre")            
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
            inst.AnimState:PlayAnimation("run_loop", true)

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
            inst.AnimState:PlayAnimation("run_pst")               
        end,

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
        name = "punch",
        tags = {"attack", "notalking", "abouttoattack", "busy"},

        onenter = function(inst)
            inst.sg.statemem.target = inst.components.combat.target
            inst.components.combat:StartAttack()
            inst.Physics:Stop()

            inst.AnimState:PlayAnimation("punch")
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh")

            if inst.components.combat.target ~= nil and inst.components.combat.target:IsValid() then
                inst:FacePoint(inst.components.combat.target.Transform:GetWorldPosition())
            end
        end,

        timeline =
        {
            TimeEvent(14*FRAMES, function(inst) 
                inst.components.combat:DoAttack(inst.sg.statemem.target)
                inst.sg:RemoveStateTag("abouttoattack")    
            end),

            TimeEvent(25*FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")  
            end),

            TimeEvent(26*FRAMES, function(inst)
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
        name = "attack",
        tags = {"attack", "notalking", "abouttoattack", "busy"},

        onenter = function(inst)
            inst.sg.statemem.target = inst.components.combat.target
            inst.components.combat:StartAttack()
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("atk")

            inst.AnimState:Show("ARM_carry")
            inst.AnimState:Hide("ARM_normal") 
            inst.AnimState:OverrideSymbol("swap_object", "swap_nightmaresword", "swap_nightmaresword")
            --inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_nightsword")

            if inst.components.combat.target ~= nil and inst.components.combat.target:IsValid() then
                inst:FacePoint(inst.components.combat.target.Transform:GetWorldPosition())
            end
        end,

        timeline =
        {
            TimeEvent(8*FRAMES, function(inst) 
                inst.components.combat:DoAttack(inst.sg.statemem.target)
                inst.sg:RemoveStateTag("abouttoattack")   
            end),

            TimeEvent(10*FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")  
            end),

            TimeEvent(11*FRAMES, function(inst)
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

            inst.AnimState:OverrideSymbol("swap_object", "swap_axe", "swap_axe")
            inst.AnimState:Show("ARM_carry")
            inst.AnimState:Hide("ARM_normal")            
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

            --print(inst.tool.name)

            inst.AnimState:PlayAnimation("chop_loop")
        end,

        timeline =
        {
            TimeEvent(2 * FRAMES, function(inst) 
                inst:PerformBufferedAction()
            end),

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

        onexit = function(inst)
            inst.AnimState:Hide("ARM_carry")
            inst.AnimState:Show("ARM_normal")
        end,
    },

    State{
        name = "mine_start",
        tags = {"premine", "working"},

        onenter = function(inst)
            local buffaction = inst:GetBufferedAction()
            inst.sg.statemem.target = buffaction ~= nil and buffaction.target or nil

            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("pickaxe_pre")

            inst.AnimState:OverrideSymbol("swap_object", "swap_pickaxe", "swap_pickaxe")
            inst.AnimState:Show("ARM_carry")
            inst.AnimState:Hide("ARM_normal") 
           
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

        onexit = function(inst)
            inst.AnimState:Hide("ARM_carry")
            inst.AnimState:Show("ARM_normal")
        end,        
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
        name = "spawn",
        tags = { "busy", "noattack", "temp_invincible" },

        onenter = function(inst, mult)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("minion_spawn")
           -- inst.SoundEmitter:PlaySound("maxwell_rework/shadow_worker/spawn")
            mult = mult or .8 + math.random() * .2
            inst.AnimState:SetDeltaTimeMultiplier(mult)

            mult = 1 / mult
            inst.sg.statemem.tasks =

            {
                inst:DoTaskInTime(0 * FRAMES * mult, DoSound, "maxwell_rework/shadow_worker/spawn"),
                inst:DoTaskInTime(0 * FRAMES * mult, TrySplashFX),
                inst:DoTaskInTime(20 * FRAMES * mult, TrySplashFX),
                inst:DoTaskInTime(44 * FRAMES * mult, TrySplashFX, "small"),
            }
            inst.sg:SetTimeout(70 * FRAMES * mult)
        end,

        ontimeout = function(inst)
            inst.sg:AddStateTag("caninterrupt")
            inst.AnimState:SetDeltaTimeMultiplier(1)
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if not inst.sg.statemem.spawn then
                inst.AnimState:SetDeltaTimeMultiplier(1)
            end
            for i, v in ipairs(inst.sg.statemem.tasks) do
                v:Cancel()
            end
        end,
    },
}

return StateGraph("krm_pet", states, events, "spawn", actionhandlers)
