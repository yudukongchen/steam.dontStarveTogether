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
						
function DarkSpellAttack(inst, attacker)
	if inst.components.health and not inst.components.health:IsDead() then
		inst.SoundEmitter:PlaySound("dontstarve/sanity/creature1/attack")
		SpawnPrefab("statue_transition").Transform:SetPosition(inst:GetPosition():Get())
		SpawnPrefab("statue_transition_2").Transform:SetPosition(inst:GetPosition():Get())
		inst.components.combat:GetAttacked(attacker, 20)
	end
end

function IceSpellAttack(inst, attacker)
	if inst.components.health and not inst.components.health:IsDead() then
		inst.components.combat:GetAttacked(attacker, 25)
		if inst.components.freezable then
			inst.components.freezable:AddColdness(5)
			inst.components.freezable:SpawnShatterFX()
		end
	end
end

function FireSpellAttack(inst, attacker)
	if inst.components.health and not inst.components.health:IsDead() then
		inst.components.combat:GetAttacked(attacker, 80)
		if inst.components.burnable and not inst.components.burnable:IsBurning() then         
			inst.components.freezable:Unfreeze()                      
			inst.components.burnable:Ignite(true)
		end
	end
end

local function GetFloorSpawnPoint(inst)
	local pt = Vector3(inst.Transform:GetWorldPosition())
	local theta = math.random() * 2 * PI
	local radius = 13
	local offset = FindWalkableOffset(pt, theta, radius, 12, true)
--	if IsDLCEnabled(CAPY_DLC) then
    if true then
		if offset then
			local pos = pt + offset
--			local ground = GetWorld()
--			local tile = GROUND.GRASS
--			if ground and ground.Map then
--				tile = GetWorld().Map:GetTileAtPoint(pos:Get())
--			end
--			local onWater = ground.Map:IsWater(tile)
--			if not onWater then 
--				return pos
--			end 
            local pos = pt + offset
            if TheWorld.Map:IsPassableAtPoint(pos.x, pos.y, pos.z) then return pos end
		end
	else
		if offset then
			local pos = pt + offset
--			local ground = GetWorld()
            local ground = TheWorld
			local tile = GROUND.GRASS
			if ground and ground.Map then
--				tile = GetWorld().Map:GetTileAtPoint(pos:Get())
                tile = TheWorld.Map:GetTileAtPoint(pos:Get())
			end
			return pos
		end
	end
end

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
				inst.sg:GoToState("spell")
			elseif altattackchance > 3 and altattackchance <= 6 then
				inst.sg:GoToState("attack_res")
			elseif altattackchance > 6 then
				inst.sg:GoToState("attack")
			end
		end
	end),	
	EventHandler("attacked", function(inst, data)
		if not (inst.icemagic or inst.firemagic) then
			inst.sg:GoToState("teleport")
		else
			inst.sg:GoToState("hit")	
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
        name = "attack",
        tags = {"attack", "busy"},
        
        onenter = function(inst)
			inst.components.combat:StartAttack()
            inst.Physics:Stop()
			inst.AnimState:PlayAnimation("atk")
			inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
        end,
        
        timeline=
        {
            TimeEvent(4*FRAMES, function(inst) inst.components.combat:DoAttack() end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
	
	State
	{
        name = "attack_res",
        tags = {"attack", "busy"},
        
        onenter = function(inst)
			--inst.components.combat:StartAttack()
            inst.Physics:Stop()
			inst.AnimState:PlayAnimation("atk")
			inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
        end,
        
        timeline=
        {
            TimeEvent(4*FRAMES, function(inst) inst.components.combat:DoAttack() end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
	
	State
	{
        name = "spell",
        tags = {"attack", "busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
			inst.AnimState:PlayAnimation("staff")
            inst.stafffx = SpawnPrefab("staffcastfx")            
            local pos = inst:GetPosition()
            inst.stafffx.Transform:SetPosition(pos.x, pos.y, pos.z)
			local colour
			if not (inst.icemagic or inst.firemagic) then
				colour = {104/255,40/255,121/255}
			elseif inst.icemagic then
				colour = {0,0,255}
			elseif inst.firemagic then
				colour = {255,0,0}
			end
            inst.stafffx.Transform:SetRotation(inst.Transform:GetRotation())
            inst.stafffx.AnimState:SetMultColour(colour[1], colour[2], colour[3], 1)
			inst.SoundEmitter:PlaySound("dontstarve/common/staffteleport")
			inst.components.health:SetInvincible(true)
        end,
        
        timeline=
        {
            TimeEvent(35*FRAMES, function(inst) 
				local pt = inst:GetPosition()
				local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 10)
				for k,v in pairs(ents) do
--					if v.components.combat and v ~= inst and not (v:HasTag("companion") or v:HasTag("summonedbyplayer") or v:HasTag("player") or v:HasTag("structure") or v:HasTag("bird") or (v.components.follower and v.components.follower.leader == GetPlayer())) then	
                    if v.components.combat and v ~= inst and not (v:HasTag("companion") or v:HasTag("summonedbyplayer") or v:HasTag("player") or v:HasTag("structure") or v:HasTag("wall") or v:HasTag("bird") or (v.components.follower and v.components.follower.leader and v.components.follower.leader:HasTag("player"))) then
						if not (inst.icemagic or inst.firemagic) then		 
							v:DoTaskInTime(1*FRAMES, function() DarkSpellAttack(v, inst) end)
							v:DoTaskInTime(35*FRAMES, function() DarkSpellAttack(v, inst) end)
							v:DoTaskInTime(70*FRAMES, function() DarkSpellAttack(v, inst) end)
							v:DoTaskInTime(105*FRAMES, function() DarkSpellAttack(v, inst) end)
							v:DoTaskInTime(140*FRAMES, function() DarkSpellAttack(v, inst) end)
						elseif inst.icemagic then
							IceSpellAttack(v, inst)
						elseif inst.firemagic then
							FireSpellAttack(v, inst)
						end
					end
				end	
--				if (IsDLCEnabled(CAPY_DLC) or IsDLCEnabled(REIGN_OF_GIANTS)) then
                if true then
					if inst.icemagic then
						inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/ice_large")            
						inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/swipe")
						local icefxx = math.random(12,24)
						for k = 1, icefxx do
							local angle = math.random() * 2 * PI
							local prefab = "icespike_fx_"..math.random(1,4)
							local fx = SpawnPrefab(prefab)
							local rad = math.random(1,5)
							local pt = Vector3(inst.Transform:GetWorldPosition())
							if fx then						
								local offset = Vector3(rad*math.cos(angle), 0, rad*math.sin(angle))
								fx.Transform:SetPosition((pt + offset):Get())
							end	
						end
					elseif inst.firemagic then		
						SpawnPrefab("firering_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
						SpawnPrefab("firesplash_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
					end
				end			
			end),
        },	
		
		onexit = function(inst)
			inst.components.health:SetInvincible(false)
        end,
		
		events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
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
   
    State
	{
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
	
	State
	{
		name = "teleport",
        tags = {"busy", "hit"},

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("jump")
            inst.components.health:SetInvincible(true)
    		--inst:AddTag("shadow")
    		--inst:AddTag("shadowcreature")
        end,
        
        onexit = function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/sanity/creature2/dissappear")
        end,     

        events=
        {
			EventHandler("animover", function(inst)
				SpawnPrefab("statue_transition").Transform:SetPosition(inst:GetPosition():Get())
				SpawnPrefab("statue_transition_2").Transform:SetPosition(inst:GetPosition():Get())
				SpawnPrefab("crow").Transform:SetPosition(inst:GetPosition():Get())
				SpawnPrefab("crow").Transform:SetPosition(inst:GetPosition():Get())
				SpawnPrefab("crow").Transform:SetPosition(inst:GetPosition():Get())
--				if GetWorld().Map then
                if TheWorld.Map then
					local max_tries = 8
					for k = 1,max_tries do
						local pt = Vector3(inst.Transform:GetWorldPosition())
						local spawn_pt = GetFloorSpawnPoint(inst)
						if spawn_pt then
							inst.Physics:Teleport(spawn_pt:Get())
							break
						end
					end
                end				
				inst.sg:GoToState("appear")               
			end),			
        },
    },

    State
	{
        name = "appear",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.AnimState:PlayAnimation("powerup")
            inst.Physics:Stop()
			SpawnPrefab("statue_transition").Transform:SetPosition(inst:GetPosition():Get())
			SpawnPrefab("statue_transition_2").Transform:SetPosition(inst:GetPosition():Get())
			SpawnPrefab("crow").Transform:SetPosition(inst:GetPosition():Get())
			SpawnPrefab("crow").Transform:SetPosition(inst:GetPosition():Get())
			SpawnPrefab("crow").Transform:SetPosition(inst:GetPosition():Get())
			SpawnPrefab("crow").Transform:SetPosition(inst:GetPosition():Get())
			SpawnPrefab("crow").Transform:SetPosition(inst:GetPosition():Get())
			inst.SoundEmitter:PlaySound("dontstarve/sanity/creature2/appear")
            inst.components.health:SetInvincible(true)
    		--inst:AddTag("shadow")
    		--inst:AddTag("shadowcreature")
        end,
        
        onexit = function(inst)
            inst.components.health:SetInvincible(false)
			SpawnPrefab("statue_transition_2").Transform:SetPosition(inst:GetPosition():Get())
			inst.SoundEmitter:PlaySound("dontstarve/sanity/creature2/dissappear")
    		--inst:RemoveTag("shadow")
    		--inst:RemoveTag("shadowcreature")
        end,
        
        events = 
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end)
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
            
            -- TimeEvent(14*FRAMES, function(inst)
            --     if  inst.sg.statemem.action and 
            --         inst.sg.statemem.action.target and 
            --         inst.sg.statemem.action.target:IsActionValid(inst.sg.statemem.action.action) and 
            --         inst.sg.statemem.action.target.components.workable then
            --             inst:ClearBufferedAction()
            --             inst:PushBufferedAction(inst.sg.statemem.action)
            --     end
            -- end),            
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
            
            --TimeEvent(14*FRAMES, function(inst)
            --        if (TheInput:IsMouseDown(MOUSEBUTTON_LEFT) or TheInput:IsControlPressed(CONTROL_ACTION) or TheInput:IsControlPressed(CONTROL_CONTROLLER_ACTION)) and 
            --        inst.sg.statemem.action and 
            --        inst.sg.statemem.action:IsValid() and 
            --        inst.sg.statemem.action.target and 
            --        inst.sg.statemem.action.target:IsActionValid(inst.sg.statemem.action.action) and 
            --        inst.sg.statemem.action.target.components.hackable then
            --            inst:ClearBufferedAction()
            --            inst:PushBufferedAction(inst.sg.statemem.action)
            --    end
            --end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) 
                --inst.AnimState:PlayAnimation("chop_pst") 
                inst.sg:GoToState("idle", true)
            end ),
            
        },        
    },
	
	State{ 
		name = "dig_start",
        tags = {"predig", "working"},
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("shovel_pre")
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("dig") end),
        },
    },
    
    State{
        name = "dig",
        tags = {"predig", "digging", "working"},
        onenter = function(inst)
            inst.AnimState:PlayAnimation("shovel_loop")
			inst.sg.statemem.action = inst:GetBufferedAction()
        end,

        timeline=
        {
            TimeEvent(15*FRAMES, function(inst) 
--[[                if inst.sg.statemem.action and inst.sg.statemem.action.target then
					local fx = SpawnPrefab("shovel_dirt")
					fx.Transform:SetPosition( inst.sg.statemem.action.target.Transform:GetWorldPosition() )
				end
--]]                
                inst:PerformBufferedAction() 
                inst.sg:RemoveStateTag("predig") 
                inst.SoundEmitter:PlaySound("dontstarve/wilson/dig")
                
            end),
            
           -- TimeEvent(35*FRAMES, function(inst)
			--	if (TheInput:IsMouseDown(MOUSEBUTTON_RIGHT) or
			--	   TheInput:IsControlPressed(CONTROL_ACTION)  or TheInput:IsControlPressed(CONTROL_CONTROLLER_ACTION)) and 
			--		inst.sg.statemem.action and 
			--		inst.sg.statemem.action.target and 
			--		inst.sg.statemem.action.target:IsActionValid(inst.sg.statemem.action.action, true) and
			--		inst.sg.statemem.action.target.components.workable then
			--			inst:ClearBufferedAction()
			--			inst:PushBufferedAction(inst.sg.statemem.action)
			--	end
           -- end),
            
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
            inst.sg:SetTimeout(6*FRAMES)
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
        ontimeout = function(inst)
            inst:PerformBufferedAction()   
        end,
        events=
        {
            EventHandler("animover", function(inst) if inst.AnimState:AnimDone() then inst.sg:GoToState("idle") end end ),
        },
    },
	
	State{
		name = "frozen",
		tags = {"busy"},
		
        onenter = function(inst)
            inst.AnimState:PlayAnimation("frozen")
            inst.Physics:Stop()
            --inst.components.highlight:SetAddColour(Vector3(82/255, 115/255, 124/255))
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

return StateGraph("skeletonmage", states, events, "idle", actionhandlers)