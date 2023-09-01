local MakePlayerCharacter = require "prefabs/player_common"
local cooking = require("cooking")
local cooking_ingredients = cooking.ingredients

local assets = {         
         Asset( "ANIM", "anim/yuki.zip" ),
         Asset( "ANIM", "anim/ghost_yuki_build.zip" ),
         Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
}

local prefabs = {
   "nfx"
}

local function equipscoutstuff(inst) 
    local scoutcap = SpawnPrefab("shadowly_weapon")
    inst.components.inventory:Equip(scoutcap)
end

local function sanityfn(inst)
    if TheWorld.state.isday then
          return -0.12
    end

    return 0
end

local function OnHealthDelta(inst, data)
       print(data.oldpercent)
       print(data.newpercent)

       if inst.components.health.currenthealth <= 1 and not inst:HasTag("groggy") then
                  if inst.groggytask then
                          inst.groggytask:Cancel()
                          inst.groggytask = nil
                  end 

                  inst:AddTag("groggy")
                  inst.components.locomotor.walkspeed = TUNING.WILSON_WALK_SPEED*0.7
                  inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED*0.7

                  inst.components.combat.canattack = false

                  inst.groggytask = inst:DoTaskInTime(5, function(inst)
                              inst:RemoveTag("groggy")

                              inst.components.combat.canattack = true

                              inst.components.locomotor.walkspeed = TUNING.WILSON_WALK_SPEED
                              inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED

                            if inst.groggytask then
                                    inst.groggytask:Cancel()
                                    inst.groggytask = nil
                          end                               
                  end)  
       end  
end

local function OnAttackfn(inst, data)
       if inst.level > 1 and math.random() <= 0.2 and data.target then
             inst:SetStateGraph("SGsxy_shadow")
             inst.sg:GoToState("attack_shadow", data.target)
     end         
end

local function OnKilledOther(inst, data)
    local target = data.victim or nil

    if inst.level == 1 and target and target.components.health and target.components.health.maxhealth
          and target.components.health.maxhealth >= 3000 then 
                  inst.level = inst.level + 1    
     end 
end 


local function oneat(inst, food)
                if food and food:HasTag("monstermeat") and food.components.edible.sanityvalue then
                        inst.components.sanity:DoDelta(food.components.edible.sanityvalue, nil, food.prefab)
          end 

        if food and food.components.edible.foodtype == FOODTYPE.MEAT and food:HasTag("cookable") and not food:HasTag("preparedfood") then --吃烤过的或者是煮熟的不加相关数值
                        if cooking_ingredients[food.prefab] then --首先获取肉的相关表
                               for k, v in pairs(cooking_ingredients[food.prefab]) do --获取一下肉的系数
                                      --print("cooking_ingredients[food.prefab]格式是: "..type(v))
                                         if v["meat"] and type(v["meat"]) == "number" and v["meat"] >= 1 then  --肉的系数大于等于1
                                                 inst.gxb = inst.gxb + 20
                                               --print("肉的系数为"..v["meat"])

                                           else  --肉的系数小于1
                                                --print("tag不存在")
                                                inst.gxb = inst.gxb + 10
                                    end      
                              end     
                       end

                       if inst.gxb_max and inst.gxb_max < 1000 then
                             inst.gxb_max = inst.gxb_max + 1
                             inst._gxb_max:set(inst.gxb_max)
                             inst:PushEvent("levelup")
                      end       

                      if inst.gxb >= inst.gxb_max then
                            inst.gxb = inst.gxb_max
                 end

                 inst._gxb:set(inst.gxb)

              local fx = SpawnPrefab("attune_in_fx")
                    fx.entity:SetParent(inst.entity)                   
       end            
end

local function onsave(inst, data)  --保存等级
    data.gxb = inst.gxb > 0 and inst.gxb or nil
    data.gxb_max = inst.gxb_max > 0 and inst.gxb_max or nil

    data.level = inst.level or 1
    data.tunshi = inst.tunshi 
end  
    
local function onpreload(inst, data)
      if data and data.gxb then
             inst.gxb = data.gxb
             inst._gxb:set(inst.gxb)
      end

      if data and data.gxb_max then
          inst.gxb_max = data.gxb_max
          inst._gxb_max:set(inst.gxb_max)
      end

      if data and data.level then
             inst.level = data.level
      end

      if data and data.tunshi then
          inst:AddTag("tunshi") 
          inst.tunshi = data.tunshi
      end  
end  


-- This initializes for both the server and client. Tags can be added here.
local common_postinit = function(inst)
	inst.MiniMapEntity:SetIcon( "sxy.tex" )

	  inst:AddTag("sxy")
    inst:AddTag("yuki_builder")
      --inst:AddTag("spiderwhisperer")

	  inst.soundsname = "wendy" 

    inst._gxb = net_shortint(inst.GUID, "inst._gxb", "inst._gxb")
    inst._gxb_max = net_shortint(inst.GUID, "inst._gxb_max", "inst._gxb_max")
    inst._gxb_max:set(300)

    inst:DoPeriodicTask(0.25, function() -- <夜视
         if inst:HasTag("夜视") then  --inst.replica.inventory:EquipHasTag("helena_amulet2") and 
               --print("夜视")
               inst.components.playervision:ForceNightVision(true)
               inst.components.playervision:SetCustomCCTable("images/colour_cubes/beaver_vision_cc.tex")
         else
               --print("取消夜视")
               inst.components.playervision:ForceNightVision(false)
               inst.components.playervision:SetCustomCCTable(nil)
         end 
     end)
end

-- This initializes for the server only. Components are added here.
local master_postinit = function(inst)
    inst.OnNewSpawn = equipscoutstuff

    inst.gxb = 0
    inst.gxb_max = 300

    inst.level = 1
    inst.tunshi = false

    inst.Transform:SetScale(1.1, 1.1, 1.1)

	  inst.components.health:SetMaxHealth(TUNING.SXY_HEALTH)
    inst.components.hunger:SetMax(TUNING.SXY_HUNGER)
    inst.components.sanity:SetMax(TUNING.SXY_SANITY)

    inst.components.sanity.night_drain_mult = 0
    inst.components.sanity.custom_rate_fn = sanityfn

    inst:ListenForEvent("healthdelta", OnHealthDelta)
   -- inst:ListenForEvent("onattackother", OnAttackfn)
    inst:ListenForEvent("killed", OnKilledOther)

    if inst.components.eater then
          inst.components.eater:SetOnEatFn(oneat)
          inst.components.eater.strongstomach = true
    end 

    if inst.components.timer == nil then
           inst:AddComponent("timer")
    end 
          
    inst:ListenForEvent("timerdone", function(inst, data)
           if data.name == "HunLuan" then
                  inst:RemoveTag("混乱技能cd")              
          end

          if data.name == "ShouldSpawn" then
                 print("召唤cd结束")
                 inst:RemoveTag("ShouldSpawn_CD")
         end   
    end) 

    inst:DoTaskInTime(0, function(inst)
              local Buff_NoDead = inst.components.timer ~= nil and (inst.components.timer:GetTimeLeft("HunLuan") or 0) or nil
              local Buff_ShouldSpawn = inst.components.timer ~= nil and (inst.components.timer:GetTimeLeft("ShouldSpawn") or 0) or nil

               if (Buff_NoDead ~= nil and Buff_NoDead > 0) then
                      inst:AddTag("混乱技能cd")
            end

               if (Buff_ShouldSpawn ~= nil and Buff_ShouldSpawn > 0) then
                      inst:AddTag("ShouldSpawn_CD")
            end         
    end)

             local _getHealth = inst.components.health.DoDelta
                   inst.components.health.DoDelta = function(self, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
                        local maxh = inst.components.health.maxhealth 
                        local curh = inst.components.health.currenthealth
                        local curhun = inst.components.hunger.current                     
                        local kx = maxh - curh
                        --local causes = nil
                        --if cause then
                              --causes = SpawnPrefab(cause)
                        --end 

                        --if causes and causes.components.healer then
                                  --amount = amount
                                  --causes:Remove()
                                  --causes = nil 

                        if curh + amount <= 0 and inst.gxb > 0 then 
                                    amount = 0
                                    print("不死")
                                    inst.components.health:SetCurrentHealth(1) 

                        elseif cause and cause == "shadowatk" then 
                                    amount = amount 
                                    print("执行回血") 

                        elseif amount > 0 and kx >= 1 and curhun > 0 and inst.gxb > 0 then  --已损失的生命值大于等于1才会触发
                                if amount >= inst.gxb and inst.gxb <= curhun*0.5 then  --如果回复的血量大于当前骨细胞,且小于, 并且小于人物当前饥饿值*0.5，才能正常回血  

                                         amount = inst.gxb  --剩余多少骨细胞回复多少血
                                         inst.gxb = 0 --骨细胞直接清零
                                         inst._gxb:set(0) 

                                  elseif amount < inst.gxb and curhun >= amount*0.5 then --如果回复的血量小于当前骨细胞,并且小于人物当前饥饿值*0.5，才能正常回血 
                                            if amount > kx then --要是回复的血量大于缺少的血量，那就只回复缺少的血量
                                                 inst.gxb = inst.gxb - kx
                                                       
                                            else 
                                                 inst.gxb = inst.gxb - amount --正常回血，骨细胞减少回复的血量数值    
                                            end

                                             inst._gxb:set(inst.gxb)
                                   else
                                     amount = 0                                                               
                            end
                               elseif amount > 0 and (inst.gxb < 1 or curhun < 1) then --骨细胞
                                    amount = 0
                     end         
               return _getHealth(self, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb) 
         end

         local _calcDamage = inst.components.combat.CalcDamage
                    inst.components.combat.CalcDamage = function(target, weapon, multiplier)
                      local damage = _calcDamage(target, weapon, multiplier)                      
                         if inst.level == 2 then
                                damage = damage * 1.1

                        elseif inst.level == 3 then 
                            damage = damage * 1.25
                       end   
                         
               return damage
       end

    inst.SpawnTask = inst:DoPeriodicTask(2.5, function(inst)
            if inst:HasTag("ShouldSpawn") then
                    if inst.gxb >= 30 then
                           inst.gxb = inst.gxb - 30 


                          local shadowfollower = SpawnPrefab("shadow_ly2")
                          shadowfollower.components.health:SetMaxHealth(200)
                          inst.components.leader:AddFollower(shadowfollower)

                          if inst.components.combat.target then
                                  shadowfollower.components.combat:SetTarget(inst.components.combat.target)
                          end        
                          shadowfollower.components.follower.leader = inst
                          shadowfollower.Transform:SetPosition(inst.Transform:GetWorldPosition()) 
                  end      
           end    
    end)    

    inst.RengeTask = inst:DoPeriodicTask(1, function(inst)
       inst._gxb:set(inst.gxb)

       local del = 2

       if inst.level == 2 then
              del = 3

       elseif inst.level == 3 then
              del = 4
       end 

       if not inst:HasTag("playerghost") and  inst.components.health:GetPercent() < 1 and inst.gxb > 0 then  --and inst.KxTask == nil
                 local suns = inst.components.health and (inst.components.health.maxhealth - inst.components.health.currenthealth) or 0
              
                 if inst.gxb >= del and suns >= del then 
                        inst.components.health:DoDelta(del, true)

                           elseif inst.gxb < del and inst.gxb < suns then  --当前细胞小于3，并且细胞数量小于已失去的血量
                                    print("3_2") 
                                    inst.components.health:DoDelta(inst.gxb, true) --剩余的细胞全用来回血 

                           elseif suns < del and inst.gxb >= suns then
                                    print("3_3") 
                                    inst.components.health:DoDelta(suns, true)                                              
                       end
              end           
      end)

    inst.OnSave = onsave
    inst.OnPreLoad = onpreload  
end

return MakePlayerCharacter("sxy", prefabs, assets, common_postinit, master_postinit)
