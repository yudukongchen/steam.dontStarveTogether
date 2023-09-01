
GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

AddStategraphState('wilson',

    State{
        name = "transfiguration",
        tags = { "busy", "pausepredict", "nomorph", "nodangle" },
        onenter = function(inst)
            inst.components.health:SetInvincible(true) 

            if inst.components.playercontroller ~= nil then
                 inst.components.playercontroller:EnableMapControls(false)
                 inst.components.playercontroller:Enable(false)
           end

            inst.AnimState:OverrideSymbol("shadow_hands", "shadow_skinchangefx", "shadow_hands")
            inst.AnimState:OverrideSymbol("shadow_ball", "shadow_skinchangefx", "shadow_ball")
            inst.AnimState:OverrideSymbol("splode", "shadow_skinchangefx", "splode")        
            inst.AnimState:PlayAnimation("skin_change")

            if inst.components.playercontroller ~= nil then
                    inst.components.playercontroller:RemotePausePrediction()
            end

            inst:ShowHUD(false)
            inst:SetCameraDistance(14)
        end,

        timeline =
        {
            TimeEvent(42 * FRAMES, function(inst)

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
            inst.components.health:SetInvincible(false)                  
            inst.AnimState:OverrideSymbol("shadow_hands", "shadow_hands", "shadow_hands")

            inst:ShowHUD(true)

            inst:SetCameraDistance()

            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:EnableMapControls(true)
                inst.components.playercontroller:Enable(true)
            end

            inst.components.inventory:Show()

            inst:ShowActions(true)
            if not inst.sg.statemem.isclosingwardrobe then
                inst.sg.statemem.isclosingwardrobe = true
                inst:PushEvent("ms_closewardrobe")
            end
        end,
    }
)

local TRANSFIGURATION = Action({ mount_valid = false })
      TRANSFIGURATION.id = "TRANSFIGURATION"    --这个操作的id  EQUIPSLOTS.BACK or EQUIPSLOTS.BODY  GetPlayer().sg:GoToState("cast_net_retrieving")
      TRANSFIGURATION.str = "不灭之躯"   
      TRANSFIGURATION.fn = function(act) --这个操作执行时进行的功能函数 
                act.doer.nodead = true
                act.doer:AddTag("NoDead_Cd")
               -- act.doer.sg:GoToState("transfiguration")
                act.doer.components.timer:StartTimer("NoDead", 60)
                              
                return true --我把具体操作加进sg中了，不再在动作这里执行
      end

AddAction(TRANSFIGURATION) --向游戏注册一个动作

AddStategraphActionHandler("wilson",ActionHandler(ACTIONS.TRANSFIGURATION, "dolongaction"))
AddStategraphActionHandler("wilson_client",ActionHandler(ACTIONS.TRANSFIGURATION, "dolongaction"))
--[[
AddComponentAction("SCENE", "inventory" , function(inst, doer, actions, right)
    if right and (inst == ThePlayer or TheWorld.ismastersim) and inst == doer and doer.prefab == "yuki" then
		    if doer._CanBeHound ~= nil and doer._CanBeHound:value() == true and inst._CanSpawnChild ~= nil and inst._CanSpawnChild:value() == true and inst._gxb_max:value() and inst._gxb_max:value() >= 500
               and not inst:HasTag("NoDead_Cd") and inst.replica.inventory and inst.replica.inventory:GetActiveItem() == nil                 
			       and not (inst.replica.rider and inst.replica.rider:IsRiding()) then
			             table.insert(actions, ACTIONS.TRANSFIGURATION)
		       end
	    end 
end)
]]

if TUNING.LY_KEY7 == false then
AddComponentAction("SCENE", "health" , function(inst, doer, actions, right)
    if right and doer:HasTag("ly") and not doer:HasTag("houndatkcd") and doer._CanBeHound:value() == true
            and doer.replica.combat:CanTarget(inst) then   
              table.insert(actions, ACTIONS.HOUNDATK)
    end 
end)
end

local function HoundAtk(inst, target)
  if inst.CanBeHound then
        local Buff_Cd = inst.components.timer ~= nil and (inst.components.timer:GetTimeLeft("HoundAtk") or 0) or nil

         if inst.components.hunger and inst.components.hunger.current >= 5 and Buff_Cd <= 0 and target then  --and inst.components.playercontroller:IsEnabled()
              local hound = SpawnPrefab("hound_fx")              
              local pt = Vector3(inst.Transform:GetWorldPosition())
              local nottags = {'FX', 'NOCLICK', 'INLIMBO', 'playerghost', 'wall', "companion", "abigail", "shadow_ly"}

                    if not TheNet:GetPVPEnabled() then
                         table.insert(nottags, "player")
                end              

              local hound = SpawnPrefab("hound_fx")

              inst:AddTag("hound_yuki")
              inst.components.hunger:DoDelta(-5)
              inst.components.timer:StartTimer("HoundAtk", 10)
              hound.Transform:SetPosition(inst.Transform:GetWorldPosition()) 
              --hound.Transform:SetRotation(inst.Transform:GetRotation())
              hound:ForceFacePoint(target:GetPosition():Get())

              hound:ListenForEvent("animqueueover", function()
                        local fx = SpawnPrefab("sand_puff")                                     
                           hound:Remove()

                           if fx.Transform then
                                  fx.Transform:SetScale(2, 2, 2)
                                  fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
                           end                            
              end)

              hound.SoundEmitter:PlaySound("dontstarve/creatures/hound/attack")              

           inst:DoTaskInTime(0.5, function()
                    target.components.combat:GetAttacked(inst, 200)
                                       if target.components.health and target.components.health:IsDead() and target.components.health.maxhealth and not target:HasTag("chess") and not target:HasTag("shadowcreature") and not target:HasTag("shadow") and not target:HasTag("shadowchesspiece") then

                                               if target.components.lootdropper then
                                                      target.components.lootdropper.DropLoot = function(self, pt) end
                                              end          

                                                   inst.gxb = inst.gxb + (target.components.health.maxhealth*0.1)
                                                   print(target.components.health.maxhealth*0.1)
                                                         if inst.gxb >= inst.gxb_max then
                                                             inst.gxb = inst.gxb_max
                                                    end             
                                             inst._gxb:set(inst.gxb) --ui更新
                                        end      
                        --break                                                                      
           end)
            --  elseif inst.components.hunger and inst.components.hunger.current < 5 and inst.components.playercontroller:IsEnabled()  then
                  -- inst.components.talker:Say("我好饿!")
            end

           -- else
               -- inst.components.talker:Say("未掌握该能力!")         
      end          
end

local HOUNDATK = Action({ priority = 10, distance = 3, mount_valid = false })
      HOUNDATK.id = "HOUNDATK"    --这个操作的id 
      HOUNDATK.str = "狼口"   
      HOUNDATK.fn = function(act) --这个操作执行时进行的功能函数
             if act.doer and act.target then 
                   HoundAtk(act.doer, act.target)
                --SendModRPCToServer(MOD_RPC[modname]["HoundAtk"], act.target)  
             end
                             
             return true --我把具体操作加进sg中了，不再在动作这里执行
      end

AddAction(HOUNDATK) --向游戏注册一个动作

AddStategraphActionHandler("wilson",ActionHandler(ACTIONS.HOUNDATK, "doshortaction"))
AddStategraphActionHandler("wilson_client",ActionHandler(ACTIONS.HOUNDATK, "doshortaction"))


