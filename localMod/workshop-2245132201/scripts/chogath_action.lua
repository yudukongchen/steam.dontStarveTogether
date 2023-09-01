GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

--======================更改制作物品时的动作
AddStategraphState('wilson',

    State{
        name = "chogath_eat",
        tags = {"doing", "busy"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            
            inst.components.hunger:Pause()
            inst.components.health.invincible = true
                                               
            inst.AnimState:PlayAnimation("eat_pre")
            inst.AnimState:PushAnimation("eat", false)
            inst.SoundEmitter:PlaySound("dontstarve/wilson/eat", "eating")        
        end,
        
        timeline=
        {             
             TimeEvent(40*FRAMES, function(inst)
                    inst.sg:RemoveStateTag("busy")
             end),                            
        },
        
        onexit = function(inst)
              inst.components.hunger:Resume()
              inst.components.health.invincible = false
              inst.SoundEmitter:KillSound("eating")
        end, 

        events=
        {
            EventHandler("animover", function(inst)                 
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end ),
        },
    }  
)


AddStategraphState('wilson_client',

    State{
        name = "chogath_eat",
        tags = {"doing", "busy","nopredict"},
		
        onenter = function(inst)
            inst.components.locomotor:Stop() 
            inst.AnimState:PlayAnimation("eat_pre")
            inst.AnimState:PushAnimation("eat", false)
            inst.SoundEmitter:PlaySound("dontstarve/wilson/eat", "eating")       
        end,
        
        timeline=
        {             
             TimeEvent(40*FRAMES, function(inst)
				   inst.sg:RemoveStateTag("busy")
             end),                                     
        },
      
        onexit = function(inst)
              inst.SoundEmitter:KillSound("eating")
        end,

        events=
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end ),
        },
    }  
)
