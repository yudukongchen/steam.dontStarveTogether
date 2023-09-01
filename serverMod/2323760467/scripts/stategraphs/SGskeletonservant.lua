require("stategraphs/commonstates")

local actionhandlers =
{    
    ActionHandler(ACTIONS.CHOP, 
        function(inst)
            if not inst.sg:HasStateTag("prechop") then 
                if inst.sg:HasStateTag("chopping") then
                    return "chop"
                else
                    return "chop_start"
                end
            end 
        end),
    ActionHandler(ACTIONS.MINE, 
        function(inst) 
            if not inst.sg:HasStateTag("premine") then 
                if inst.sg:HasStateTag("mining") then
                    return "mine"
                else
                    return "mine_start"
                end
            end 
        end),
	ActionHandler(ACTIONS.HACK, 
        function(inst) 
            if not inst.sg:HasStateTag("prehack") then 
                if inst.sg:HasStateTag("hacking") then
                    return "hack"
                else
                    return "hack_start"
                end
            end 
        end),
	ActionHandler(ACTIONS.DIG, 
        function(inst) 
            if not inst.sg:HasStateTag("predig") then 
                if inst.sg:HasStateTag("digging") then
                    return "dig"
                else
                    return "dig_start"
                end
            end 
        end),	
	ActionHandler(ACTIONS.PICKUP, "pickup"),
	ActionHandler(ACTIONS.PICK, "pickup"),
}

local events = 
{
    CommonHandlers.OnAttacked(),
    CommonHandlers.OnDeath(),
    CommonHandlers.OnAttack(),
	CommonHandlers.OnFreeze(),
	EventHandler("locomote", function(inst) 
        if not inst.sg:HasStateTag("busy") then   
            local is_moving = inst.sg:HasStateTag("moving")
            local wants_to_move = inst.components.locomotor:WantsToMoveForward()
            if not inst.sg:HasStateTag("attack") and is_moving ~= wants_to_move then
                if wants_to_move then
                    inst.sg:GoToState("run_start")
                else
                    inst.sg:GoToState("idle")
                end
            end
        end
    end),
	EventHandler("doattack", function(inst, data)
		if inst.components.health and not inst.components.health:IsDead() and (inst.sg:HasStateTag("hit") or not inst.sg:HasStateTag("busy")) then
			local altattackchance = math.random(1,10)
			if altattackchance <= 3 then
				inst.sg:GoToState("attack3")
			elseif altattackchance > 3 and altattackchance <= 6 then
				inst.sg:GoToState("attack2")
			elseif altattackchance > 6 then
				inst.sg:GoToState("attack")
			end
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
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "run_start",
        tags = {"moving", "running", "canrotate"},
        
        onenter = function(inst)
			inst.components.locomotor:RunForward()
            inst.AnimState:PlayAnimation("run_pre")
            inst.sg.mem.foosteps = 0
        end,

        onupdate = function(inst)
            inst.components.locomotor:RunForward()
        end,

        events=
        {   
            EventHandler("animover", function(inst) inst.sg:GoToState("run") end ),        
        },
        
        timeline=
        {        
            TimeEvent(4*FRAMES, function(inst)
            end),
        },        
        
    },

    State{
        
        name = "funnyidle",
        tags = {"idle", "canrotate"},
        onenter = function(inst)
        
			
			if inst.components.temperature:GetCurrent() < 5 then
				inst.AnimState:PlayAnimation("idle_shiver_pre")
				inst.AnimState:PushAnimation("idle_shiver_loop")
				inst.AnimState:PushAnimation("idle_shiver_pst", false)
			elseif inst.components.hunger:GetPercent() < TUNING.HUNGRY_THRESH then
                inst.AnimState:PlayAnimation("hungry")
                inst.SoundEmitter:PlaySound("dontstarve/rabbit/beardscream")    
            else
                inst.AnimState:PlayAnimation("idle_inaction")
            end
        end,

        events=
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end ),
        },
        
    },
    

    State{
        name = "run",
        tags = {"moving", "running", "canrotate"},
        
        onenter = function(inst) 
            inst.components.locomotor:RunForward()
            inst.AnimState:PlayAnimation("run_loop")
            
        end,
        
        onupdate = function(inst)
            inst.components.locomotor:RunForward()
        end,
      
        events=
        {   
            EventHandler("animover", function(inst) inst.sg:GoToState("run") end ),        
        },
    },
    
    State{
    
        name = "run_stop",
        tags = {"canrotate", "idle"},
        
        onenter = function(inst) 
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("run_pst")
        end,
        
        events=
        {   
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),        
        },
        
    },
	
	State
	{
        name = "talk",
        tags = {"idle", "talking", "busy"},
        
        onenter = function(inst, noanim)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("dial_loop", true)
            inst.SoundEmitter:PlaySound("dontstarve/characters/wilson/talk_LP", "talk")
        end,
        
        onexit = function(inst)
            inst.SoundEmitter:KillSound("talk")
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    }, 	
	
	State
	{
        name = "happy",
        tags = {"idle", "talking", "busy"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("staff") 
			inst.SoundEmitter:PlaySound("dontstarve/characters/wilson/talk_LP", "talk")
        end,
		
		   onexit = function(inst)
            inst.SoundEmitter:KillSound("talk")
        end,
		
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
	
	State
	{
        name = "attack",
        tags = {"attack", "busy"},
        
        onenter = function(inst)
			inst.equipfn(inst, inst.items["SWORD"])
			if inst.fire then
				inst.fire:Remove()
				inst.fire = nil
			end
			--local comboend math.random(1,2)
			--if comboend == 1 then
				inst.components.combat:StartAttack()
			--end
            inst.Physics:Stop()
			inst.AnimState:PlayAnimation("atk")
			inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
        end,
        
        timeline=
        {
            TimeEvent(13*FRAMES, function(inst) inst.components.combat:DoAttack() end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },	
	
    State
	{
        name = "attack2",
        tags = {"attack", "busy"},
        onenter = function(inst)
			inst.equipfn(inst, inst.items["SWORD"])
			if inst.fire then
				inst.fire:Remove()
				inst.fire = nil
			end
			local comboend math.random(1,4)
			if comboend == 1 then
				inst.components.combat:StartAttack()
			end
            --inst.Physics:Stop()
            inst.AnimState:PlayAnimation("pickaxe_loop")
			inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
        end,

        timeline=
        {
            TimeEvent(9*FRAMES, function(inst) 
                inst.components.combat:DoAttack()
				inst.components.combat:DoAttack()
                inst.sg:RemoveStateTag("premine") 
            end),           
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },       
    },
	
	State
	{ 
		name = "attack3",
        tags = {"attack", "busy"},
		
        onenter = function(inst)
			inst.equipfn(inst, inst.items["SWORD"])
			if inst.fire then
				inst.fire:Remove()
				inst.fire = nil
			end
			local comboend math.random(1,8)
			if comboend == 1 then
				inst.components.combat:StartAttack()
			end
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("chop_pre")  
			--inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")		
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("attack3end") end),
        },
    },
    
    State
	{
        name = "attack3end",
        tags = {"attack", "busy"},
        onenter = function(inst)
            inst.AnimState:PlayAnimation("chop_loop")
			inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
        end,

        timeline=
        {
            TimeEvent(5*FRAMES, function(inst) 
				inst.components.combat:DoAttack()
            end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) 
				local restart math.random(1,2)
				if restart == 1 then
					inst.sg:GoToState("attack3") 
				else
					inst.sg:GoToState("idle") 
				end
			end),
        },       
    },
	
	State
	{
        name = "death",
        tags = {"busy"},
        onenter = function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/wilson/death") 
            inst.AnimState:PlayAnimation("death")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)            
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))            
        end,
    },
   
    State{
        name = "hit",
        tags = {"busy"},
        
        onenter = function(inst)
            inst:InterruptBufferedAction()
            inst.SoundEmitter:PlaySound("dontstarve/wilson/hit")        
            inst.AnimState:PlayAnimation("hit")    
            inst.Physics:Stop()            
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
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
            inst:InterruptBufferedAction()
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

        State{ name = "chop_start",
        tags = {"prechop", "chopping", "working"},
        onenter = function(inst)
            inst.equipfn(inst, inst.items["AXE"])
			if inst.fire then
				inst.fire:Remove()
				inst.fire = nil
			end
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("chop_pre")

        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("chop") end),
        },
    },
    
    State{
        name = "chop",
        tags = {"prechop", "chopping", "working"},
        onenter = function(inst)
            inst.AnimState:PlayAnimation("chop_loop")        
        end,

        timeline=
        {
            TimeEvent(5*FRAMES, function(inst) 
                    inst:PerformBufferedAction() 
            end),

            TimeEvent(9*FRAMES, function(inst)
                    inst.sg:RemoveStateTag("prechop")
            end),

            TimeEvent(16*FRAMES, function(inst) 
                inst.sg:RemoveStateTag("chopping")
            end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) 
                inst.sg:GoToState("idle")
            end ),            
        },        
    },
    
State{
        name = "frozen",
        tags = {"busy", "frozen"},
        
        onenter = function(inst)
            if inst.components.locomotor then
                inst.components.locomotor:StopMoving()
            end
            inst.AnimState:PlayAnimation("idle_shiver_loop")
            inst.SoundEmitter:PlaySound("dontstarve/common/freezecreature")
            inst.AnimState:OverrideSymbol("swap_frozen", "frozen", "frozen")
        end,
        
        onexit = function(inst)
            inst.AnimState:ClearOverrideSymbol("swap_frozen")
        end,
        
        events=
        {   
            EventHandler("onthaw", function(inst) inst.sg:GoToState("thaw") end ),        
        },
    },

State{
        name = "thaw",
        tags = {"busy", "thawing"},
        
        onenter = function(inst) 
            if inst.components.locomotor then
                inst.components.locomotor:StopMoving()
            end
            inst.AnimState:PlayAnimation("idle_inaction_sanity", true)
            inst.SoundEmitter:PlaySound("dontstarve/common/freezethaw", "thawing")
            inst.AnimState:OverrideSymbol("swap_frozen", "frozen", "frozen")
        end,
        
        onexit = function(inst)
            inst.SoundEmitter:KillSound("thawing")
            inst.AnimState:ClearOverrideSymbol("swap_frozen")
        end,

        events =
        {   
            EventHandler("unfreeze", function(inst)
                if inst.sg.sg.states.hit then
                    inst.sg:GoToState("hit")
                else
                    inst.sg:GoToState("idle")
                end
            end ),
        },
    },

    State{ 
        name = "mine_start",
        tags = {"premine", "working"},
        onenter = function(inst)
            inst.equipfn(inst, inst.items["PICK"])
			if inst.fire then
				inst.fire:Remove()
				inst.fire = nil
			end
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("pickaxe_pre")
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("mine") end),
        },
    },	
	
    State{
        name = "mine",
        tags = {"premine", "mining", "working"},
        onenter = function(inst)
            inst.AnimState:PlayAnimation("pickaxe_loop")
        end,

        timeline=
        {
            TimeEvent(9*FRAMES, function(inst) 
                inst:PerformBufferedAction() 
                inst.sg:RemoveStateTag("premine") 
                inst.SoundEmitter:PlaySound("dontstarve/wilson/use_pick_rock")
            end),           
        },
        
        events=
        {
            EventHandler("animover", function(inst) 
                inst.AnimState:PlayAnimation("pickaxe_pst") 
                inst.sg:GoToState("idle", true)
            end ),            
        },        
    },
	
	State{ name = "hack_start",
        tags = {"prehack", "hacking", "working"},
        onenter = function(inst)
			inst.equipfn(inst, inst.items["MACHETTE"])
			if inst.fire then
				inst.fire:Remove()
				inst.fire = nil
			end
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("chop_pre")
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("hack") end),
        },
    },
    
    State{
        name = "hack",
        tags = {"prehack", "hacking", "working"},
        onenter = function(inst)
            inst.sg.statemem.action = inst:GetBufferedAction()
            inst.AnimState:PlayAnimation("chop_loop")            
        end,
        
        timeline=
        {
                       
            TimeEvent(5*FRAMES, function(inst) 
                inst:PerformBufferedAction() 
            end),


            TimeEvent(9*FRAMES, function(inst)
                inst.sg:RemoveStateTag("prehack")
            end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) 
                inst.sg:GoToState("idle", true)
            end ),
            
        },        
    },
	
	State
	{ 
		name = "dig_start",
        tags = {"predig", "working"},
        onenter = function(inst)
			inst.equipfn(inst, inst.items["SHOVEL"])
			if inst.fire then
				inst.fire:Remove()
				inst.fire = nil
			end
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("shovel_pre")
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("dig") end),
        },
    },
    
    State
	{
        name = "dig",
        tags = {"predig", "digging", "working"},
        onenter = function(inst)
            inst.AnimState:PlayAnimation("shovel_loop")
			inst.sg.statemem.action = inst:GetBufferedAction()
        end,

        timeline=
        {
            TimeEvent(15*FRAMES, function(inst) 
                inst:PerformBufferedAction() 
                inst.sg:RemoveStateTag("predig") 
                inst.SoundEmitter:PlaySound("dontstarve/wilson/dig")
                
            end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) 
                inst.AnimState:PlayAnimation("shovel_pst") 
                inst.sg:GoToState("idle", true)
            end ),
            
        },        
    },   
	
	State
	{
        name = "pickup",
        tags = {"doing", "busy"},
        
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("pickup")
--            inst.sg:SetTimeout(6*FRAMES)
            inst:PerformBufferedAction()   
        end,
        timeline=
        {
            TimeEvent(4*FRAMES, function( inst )
                inst.sg:RemoveStateTag("busy")
            end),
            TimeEvent(10*FRAMES, function( inst )
                inst.sg:RemoveStateTag("doing")
                inst.sg:AddStateTag("idle")
            end),
        },
--      ontimeout = function(inst)
--          inst:PerformBufferedAction()   
--      end,
        events=
        {
            EventHandler("animover", function(inst) if inst.AnimState:AnimDone() then inst.sg:GoToState("idle") end end ),
        },
    },
	
	State
	{
		name = "frozen",
		tags = {"busy"},
		
        onenter = function(inst)
            inst.AnimState:PlayAnimation("frozen")
            inst.Physics:Stop()
        end,
    },	
}

CommonStates.AddWalkStates(states,
{
	walktimeline = {
		TimeEvent(0*FRAMES, PlayFootstep ),
		TimeEvent(12*FRAMES, PlayFootstep ),
	},
})
CommonStates.AddRunStates(states,
{
	runtimeline = {
		TimeEvent(0*FRAMES, PlayFootstep ),
		TimeEvent(10*FRAMES, PlayFootstep ),
	},
})


CommonStates.AddFrozenStates(states)

return StateGraph("skeletonservant", states, events, "idle", actionhandlers)