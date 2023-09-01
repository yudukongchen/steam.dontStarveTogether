GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

local function SXY_YS(inst)
   if inst:HasTag("夜视") then
        inst:RemoveTag("夜视")
   else 
        inst:AddTag("夜视")
   end    
end

AddModRPCHandler(modname, "SXY_YS", SXY_YS)

TheInput:AddKeyDownHandler(KEY_Z, function()
local player = ThePlayer
local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
local IsHUDActive = screen and screen.name == "HUD"

      if player.prefab == "sxy" and not player:HasTag("playerghost") and IsHUDActive then
            SendModRPCToServer(MOD_RPC[modname]["SXY_YS"])
      end 
end)

local function ShouldSpawn(inst)
         if inst:HasTag("ShouldSpawn") and inst.level >= 3 then  --取消该技能是进入cd
         	    inst:RemoveTag("ShouldSpawn")
                inst.gxb = inst.gxb + inst.components.leader:CountFollowers("shadow_ly2") * 30

                  for k, v in pairs(inst.components.leader.followers) do
                       if k.prefab == "shadow_ly2" then
                                k.components.health:Kill()
                      end
                end

                inst:AddTag("ShouldSpawn_CD")
                inst.components.timer:StartTimer("ShouldSpawn", 640*3)

         elseif not inst:HasTag("ShouldSpawn") and not inst:HasTag("ShouldSpawn_CD") and inst.gxb >= 30 and inst.level >= 3 then  --启动该技能起码得30以上的细胞数量
                 inst:AddTag("ShouldSpawn")
                 print("之心")

      end    	
end

AddModRPCHandler(modname, "ShouldSpawn", ShouldSpawn)

TheInput:AddKeyDownHandler(KEY_X, function()
local player = ThePlayer
local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
local IsHUDActive = screen and screen.name == "HUD"

      if player.prefab == "sxy" and not player:HasTag("playerghost") and IsHUDActive then
            SendModRPCToServer(MOD_RPC[modname]["ShouldSpawn"])
      end 
end)

local function ShouldShadowAtk(inst, x, y, z)
    local Buff_Cd = inst.components.timer ~= nil and (inst.components.timer:GetTimeLeft("Shadow_Atk") or 0) or nil
    if Buff_Cd and Buff_Cd > 0 then return end

    if inst.components.sanity and inst.components.sanity.current >= 20 and inst.sg ~= nil and not inst.sg:HasStateTag("shadowatk") then
          inst.Transform:SetPosition(x, y, z)
          inst:SetStateGraph("SGsxy_shadow")
          inst.sg:GoToState("attack_shadow")
          inst.components.sanity:DoDelta(-20)
          inst.components.timer:StartTimer("Shadow_Atk", 60)
    end      
end

AddModRPCHandler(modname, "ShouldShadowAtk", ShouldShadowAtk)

TheInput:AddKeyDownHandler(KEY_C, function()
local player = ThePlayer
local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
local IsHUDActive = screen and screen.name == "HUD"
local x, y, z = TheInput:GetWorldPosition():Get()

      if player.prefab == "sxy" and player:HasTag("tunshi") and not player:HasTag("playerghost") and IsHUDActive then
            SendModRPCToServer(MOD_RPC[modname]["ShouldShadowAtk"], x, y, z)
      end 
end)


local function DoAttack(inst)
  local nottags = {'FX', 'NOCLICK', 'INLIMBO', 'playerghost', 'wall', "companion", "player"}  
  local x, y, z = inst.Transform:GetWorldPosition() 
  local ents = TheSim:FindEntities(x, y, z, 12, { "_combat" }, nottags) --8的攻击范围
        for i, ent in ipairs(ents) do
            if ent and inst.components.combat:CanTarget(ent) then
                  inst.components.combat:SetTarget(ent) 
            end
      end 
end

local HUNLUAN = Action({ priority = 20, distance = 10, mount_valid = false })
      HUNLUAN.id = "HUNLUAN"    --这个操作的id  EQUIPSLOTS.BACK or EQUIPSLOTS.BODY  GetPlayer().sg:GoToState("cast_net_retrieving")
      HUNLUAN.str = "混乱"   
      HUNLUAN.fn = function(act) --这个操作执行时进行的功能函数                
                     if act.target and act.target.components.combat then
                             DoAttack(act.target)

                             local fx = SpawnPrefab("shadow_bishop_fx")
                             fx.Transform:SetPosition(act.target.Transform:GetWorldPosition())
                             fx.Transform:SetScale(act.target.Transform:GetScale())

                           if act.doer and act.doer.components.timer then
                           	       act.doer:AddTag("混乱技能cd")
                                   act.doer.components.timer:StartTimer("HunLuan", 60)

                                   act.doer.components.sanity:DoDelta(-10)
                        end
                   end

           return true --我把具体操作加进sg中了，不再在动作这里执行
      end

AddAction(HUNLUAN) --向游戏注册一个动作

AddStategraphActionHandler("wilson",ActionHandler(ACTIONS.HUNLUAN, "doshortaction"))
AddStategraphActionHandler("wilson_client",ActionHandler(ACTIONS.HUNLUAN, "doshortaction"))

AddComponentAction("SCENE", "combat" , function(inst, doer, actions, right)
     if right and not inst:HasTag("player") and doer:HasTag("sxy") and not doer:HasTag("混乱技能cd") 
     	       and doer.replica.sanity:GetCurrent() >= 10 then
             table.insert(actions, ACTIONS.HUNLUAN)        
     end
end)

local EATLS = Action({ priority = 20, distance = 10, mount_valid = false })
      EATLS.id = "EATLS"    --这个操作的id  EQUIPSLOTS.BACK or EQUIPSLOTS.BODY  GetPlayer().sg:GoToState("cast_net_retrieving")
      EATLS.str = "吞噬"   
      EATLS.fn = function(act) --这个操作执行时进行的功能函数                
          local target = act.target or act.invobject
           if act.doer then
                act.doer:AddTag("tunshi")
                act.doer.tunshi = true
           end 

           if act.doer.level == 2 then
                   act.doer.level = 3  
           end
           target:Remove()	

           return true --我把具体操作加进sg中了，不再在动作这里执行
      end

AddAction(EATLS) --向游戏注册一个动作

AddStategraphActionHandler("wilson",ActionHandler(ACTIONS.EATLS, "doshortaction"))
AddStategraphActionHandler("wilson_client",ActionHandler(ACTIONS.EATLS, "doshortaction"))

AddComponentAction("INVENTORY", "tradable" , function(inst, doer, actions)
      if inst:HasTag("shadow_ly_ls") and doer then   
                table.insert(actions, ACTIONS.EATLS)
      end
end)