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
    local scoutcap = SpawnPrefab("broken_sword")
    inst.components.inventory:Equip(scoutcap)

          if inst.follower == nil then
                    inst.follower = SpawnPrefab("shadow_ly")

                    inst.follower.components.follower.leader = inst
                    inst.follower.Transform:SetPosition(inst.Transform:GetWorldPosition())

                    inst.components.leader:AddFollower(inst.follower)
                    inst:ListenForEvent("death", function()
                                  inst.follower = nil    
                                  inst.components.timer:StartTimer("CanSpawnFollower", 480*3)
                    end, inst.follower)
      end
end

local function applyupgrades(inst)
        if inst.components.health then

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
                      end       

                      if inst.gxb >= inst.gxb_max then
                            inst.gxb = inst.gxb_max
                 end

                 inst._gxb:set(inst.gxb)

              local fx = SpawnPrefab("attune_in_fx")
                    fx.entity:SetParent(inst.entity)                   
       end            
end

local function OnKilledOther(inst, data)
     if data.victim  then
     if (data.victim.prefab == "mole" or data.victim.prefab == "bat") and inst.buff1 == false and math.random() >= 0.98 then
          inst.buff1 = true
          inst._buff1:set(true)
          TheNet:Announce("已获得夜视基因!")

     elseif data.victim.prefab == "lightninggoat" and data.victim.charged and inst.buff2 == false and math.random() >= 0.9 then 
          inst.buff2 = true
          inst._buff2:set(true)
          TheNet:Announce("已获得闪电羊基因!")

     elseif data.victim.prefab == "crabking" and inst.buff3 == false then 
          inst.buff3 = true
          inst._buff3:set(true)
          TheNet:Announce("已获得帝王蟹基因基因!")                    
     end  
     end 

     if data.victim and data.victim.components.health then

                  if inst.gxb_max and inst.gxb_max < 1000 then
                        inst.gxb_max = inst.gxb_max + 1
                        inst._gxb_max:set(inst.gxb_max)
                end 

               if data.victim.prefab == "warg" and inst.CanBeHound == false then  --杀死座狼解锁变身技能
                        inst.CanBeHound = true

                        if inst._CanBeHound:value() == false then
                              inst._CanBeHound:set(true)
                        end        

                            
                            local fx = SpawnPrefab("wathgrithr_spirit")
                                  fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
              end

                if data.victim.prefab == "spiderqueen" and inst.CanSpawnChild == false then  --杀死座狼解锁变身技能
                        inst.CanSpawnChild = true

                        if inst._CanSpawnChild:value() and inst._CanSpawnChild:value() == false then
                                inst._CanSpawnChild:set(true)
                        end           
                            
                            local fx = SpawnPrefab("slurper_respawn")
                                  fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
              end             
       end 
end

local function MakeStronger(inst, level)
    local health_percent = inst.components.health:GetPercent()
             inst.level = level

            if level == 1 or level == 2 then
                   inst.sg:GoToState("powerup_wurt")
            end    

            if level >= 0 and level < 2 then
                  inst.components.combat:SetDefaultDamage(60)

                  inst.components.health:StartRegen(5, 2)
                  inst.components.health:SetMaxHealth(1000)
                  inst.components.health:SetPercent(health_percent)

            elseif level >= 2 then
                  inst.components.combat:SetDefaultDamage(75)

                  inst.components.health:StartRegen(10, 2)
                  inst.components.health:SetMaxHealth(1500)
                  inst.components.health:SetPercent(health_percent)                  
          end
end

local function onsave(inst, data)  --保存等级

    data.gxb = inst.gxb > 0 and inst.gxb or nil
    data.gxb_max = inst.gxb_max > 0 and inst.gxb_max or nil
    data.CanBeHound = inst.CanBeHound or false
    data.CanSpawnChild = inst.CanSpawnChild or false
    data.nodead = inst.nodead or false
    data.folllevel = inst.follower and inst.follower.level
    data.follower = inst.follower ~= nil and inst.follower:GetSaveRecord() or nil

    data.buff1 = inst.buff1 or false
    data.buff2 = inst.buff2 or false
    data.buff3 = inst.buff3 or false    
    --if inst.follower then
          --inst.follower:Remove()
    --end  
end  
    
local function onpreload(inst, data)
     if data then         
         if data.buff1 then
              inst.buff1 = true
              inst._buff1:set(true)
         end 

         if data.buff2 then
              inst.buff2 = true
              inst._buff2:set(true)
         end 

         if data.buff3 then
              inst.buff3 = true
              inst._buff3:set(true)
         end 

     	   if data.gxb then
                   inst.gxb = data.gxb
                   inst._gxb:set(inst.gxb)
                   applyupgrades(inst)
          end

           if data.gxb_max then
                 inst.gxb_max = data.gxb_max
                 inst._gxb_max:set(inst.gxb_max)
           end	

           if data.CanBeHound then
                   inst.CanBeHound = data.CanBeHound
                   inst._CanBeHound:set(true)
           end

           if data.CanSpawnChild then
                   inst.CanSpawnChild = data.CanSpawnChild
                   inst._CanSpawnChild:set(true)
           end

           if data.nodead then
                  inst.nodead = data.nodead
            end 

             if data.folllevel then
                   inst.folllevel = data.folllevel                    
            end 

          if data.follower ~= nil and inst.follower == nil then
                      inst.follower = SpawnSaveRecord(data.follower)
                      MakeStronger(inst.follower, inst.folllevel)
                      inst.follower.components.follower.leader = inst 
                      inst.components.leader:AddFollower(inst.follower) 
                      inst:ListenForEvent("death", function()
                                  inst.follower = nil    
                                  inst.components.timer:StartTimer("CanSpawnFollower", 480*3)
                      end, inst.follower)                             
          end
     end
end  


local function reticule_target_function(inst)
    return Vector3(ThePlayer.entity:LocalToWorldSpace(3.5, 0.001, 0))
end

local function GetPointSpecialActions(inst, pos, useitem, right)
    local px, py, pz = pos:Get()
    if right and useitem == nil and inst._buff3:value() == true and inst.replica.sanity and inst.replica.sanity:GetCurrent() >= 10 then  
        return { ACTIONS.CASTSPELL_ON_WATER }
    end
    return {}
end

local function OnSetOwner(inst)
    if inst.components.playeractionpicker ~= nil then
        inst.components.playeractionpicker.pointspecialactionsfn = GetPointSpecialActions
    end
end

-- This initializes for both the server and client. Tags can be added here.
local common_postinit = function(inst)
	inst.MiniMapEntity:SetIcon( "yuki.tex" )

	  inst:AddTag("yuki")
	  inst:AddTag("ly")
    inst:AddTag("yuki_builder")
      --inst:AddTag("spiderwhisperer")

	  inst.soundsname = "willow"

	  inst._gxb = net_shortint(inst.GUID, "inst._gxb", "inst._gxb")
    inst._gxb_max = net_shortint(inst.GUID, "inst._gxb_max", "inst._gxb_max")
    inst._gxb_max:set(300)

    inst._CanBeHound = net_bool(inst.GUID, "inst.CanBeHound", "inst.CanBeHound")
    inst._CanBeHound:set(false)

    inst._CanSpawnChild = net_bool(inst.GUID, "inst.CanSpawnChild", "inst.CanSpawnChild")
    inst._CanSpawnChild:set(false)

    inst._buff1 = net_bool(inst.GUID, "ly_buff1", "buff1_dirty")
    inst._buff1:set(false) 

    inst._buff1_open = net_bool(inst.GUID, "ly_buff1_open", "buff1_open_dirty")
    inst._buff1_open:set(false) 
    inst:ListenForEvent("buff1_open_dirty", function(inst)
        if inst.components.playervision and inst._buff1_open:value() == true then
             inst.components.playervision:ForceNightVision(true)
             inst.components.playervision:SetCustomCCTable("images/colour_cubes/beaver_vision_cc.tex")

        elseif inst.components.playervision then
             inst.components.playervision:ForceNightVision(false)
             inst.components.playervision:SetCustomCCTable(nil)
        end  
    end)

    inst._buff2 = net_bool(inst.GUID, "ly_buff2", "buff2_dirty")
    inst._buff2:set(false)

    inst._buff3 = net_bool(inst.GUID, "ly_buff3", "buff3_dirty")
    inst._buff3:set(false) 

    inst:AddComponent("reticule")
    inst.components.reticule.targetfn = reticule_target_function
    inst.components.reticule.ease = true
    inst.components.reticule.ispassableatallpoints = true

    inst:ListenForEvent("setowner", OnSetOwner)                   
end

-- This initializes for the server only. Components are added here.
local master_postinit = function(inst)

    inst.gxb = 0
    inst.gxb_max = 300

    inst.spidernum = 2
    inst.spider_warriorrnum = 2
    inst.wormnum = 1

    inst.SpawnNum = 0
    inst.SpawnMax = 0

    inst.spawn = false

    inst.CanBeHound = false
    inst.CanSpawnChild = false

    inst.folllevel = 0
    inst.follower = nil

    inst.nodead = false

    inst.buff1 = false
    inst.buff2 = false
    inst.buff3 = false  

    inst.OnNewSpawn = equipscoutstuff

    inst.Transform:SetScale(1.1, 1.1, 1.1)

	  inst.components.health:SetMaxHealth(TUNING.YUKI_HEALTH)
    inst.components.hunger:SetMax(TUNING.YUKI_HUNGER)
    inst.components.sanity:SetMax(TUNING.YUKI_SANITY)

    inst.components.sanity.night_drain_mult = 1.2
    inst.components.sanity.neg_aura_mult = 1.2

    inst.components.health.fire_damage_scale = 0
    --inst.components.health.canheal = false

    if inst.components.burnable then
          inst.components.burnable:SetBurnTime(0)
          inst.components.burnable.nocharring = false
    end
     
    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", function(inst, data)
         if data.name == "SpiderSpawn_Cd" then
               inst.components.talker:Say("CD结束")

         elseif data.name == "CanSpawnFollower" then
               inst.components.talker:Say("可以召唤了")

         elseif data.name == "NoDead" then
               inst.nodead = false
               inst.components.talker:Say("不灭之躯结束。。")
               inst.components.timer:StartTimer("NoDead_Cd", 480) 

          elseif data.name == "NoDead_Cd" then
               inst:RemoveTag("NoDead_Cd")
               inst.components.talker:Say("不灭之躯可以使用")                 
        end 
    end) 

	  inst.components.temperature.inherentinsulation = TUNING.INSULATION_LARGE  --180秒耐寒

    inst:DoTaskInTime(0, function(inst)
              local Buff_NoDead = inst.components.timer ~= nil and (inst.components.timer:GetTimeLeft("NoDead") or 0) or nil
              local Buff_NoDead_Cd = inst.components.timer ~= nil and (inst.components.timer:GetTimeLeft("NoDead_Cd") or 0) or nil

               if (Buff_NoDead ~= nil and Buff_NoDead > 0) or (Buff_NoDead_Cd ~= nil and Buff_NoDead_Cd > 0) then
                      inst:AddTag("NoDead_Cd")
            end
    end)

    inst.RengeTask = inst:DoPeriodicTask(1, function(inst)
       if inst.buff2 and inst.components.debuffable and not inst.components.debuffable:HasDebuff("buff_electricattack") then
           inst:AddDebuff("buff_electricattack", "buff_electricattack")
       end 

       local Buff_Cd = inst.components.timer ~= nil and (inst.components.timer:GetTimeLeft("HoundAtk") or 0) or nil
       if Buff_Cd and Buff_Cd > 0 then
              inst:AddTag("houndatkcd")
       else
              inst:RemoveTag("houndatkcd")    
       end 

       inst._gxb:set(inst.gxb)
    	 if not inst:HasTag("playerghost") and  inst.components.health:GetPercent() < 1 and inst.gxb > 0 then  --and inst.KxTask == nil
                 local suns = inst.components.health and (inst.components.health.maxhealth - inst.components.health.currenthealth) or 0
              
            if not inst.nodead then
                 if inst.gxb >= TUNING.LY_HEALDEL and suns >= TUNING.LY_HEALDEL then 
                        --print("3_1") 
                        inst.components.health:DoDelta(TUNING.LY_HEALDEL, true)

                           elseif inst.gxb < TUNING.LY_HEALDEL and inst.gxb < suns then  --当前细胞小于3，并且细胞数量小于已失去的血量
                                    --print("3_2") 
                         	          inst.components.health:DoDelta(inst.gxb, true) --剩余的细胞全用来回血 

                           elseif suns < TUNING.LY_HEALDEL and inst.gxb >= suns then
                                    --print("3_3") 
                         	          inst.components.health:DoDelta(suns, true)                      	          	          
                   end

                   elseif inst.nodead then
                       if inst.gxb >= TUNING.LY_HEALDEL*2 and suns >= TUNING.LY_HEALDEL*2 then 
                        --print("6_1")  
                        inst.components.health:DoDelta(TUNING.LY_HEALDEL*2, true)

                           elseif inst.gxb < TUNING.LY_HEALDEL*2 and inst.gxb < suns then  --当前细胞小于3，并且细胞数量小于已失去的血量
                                    --print("6_2")
                                    inst.components.health:DoDelta(inst.gxb, true) --剩余的细胞全用来回血 

                           elseif suns < TUNING.LY_HEALDEL*2 and inst.gxb >= suns then
                                    --print("6_3") 
                                    inst.components.health:DoDelta(suns, true)                                              
                    end
               end
          end           
    end)  

      inst.GxbTask = inst:DoPeriodicTask(60, function(inst)
    	     local Isweapon = inst.components.inventory ~= nil and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil
                if inst.gxb >= 1 and not (Isweapon and Isweapon:HasTag("waterproofer")) and TheWorld.components.worldstate.data.isday then
                       inst.gxb = inst.gxb - 1
                       inst._gxb:set(inst.gxb)
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

                        if inst.nodead and curh + amount <= 0 and inst.gxb > 0 then 
                                    amount = 0
                                    inst.components.health:SetCurrentHealth(1)    

                        elseif amount > 0 and kx >= 1 and (curhun > 0 or inst.nodead) and inst.gxb > 0 then  --已损失的生命值大于等于1才会触发
                                if amount >= inst.gxb and (inst.gxb <= curhun*0.5 or inst.nodead) then  --如果回复的血量大于当前骨细胞,且小于, 并且小于人物当前饥饿值*0.5，才能正常回血  

                                         amount = inst.gxb  --剩余多少骨细胞回复多少血
                                         inst.gxb = 0 --骨细胞直接清零
                                         inst._gxb:set(0)

                                      if not inst.nodead then
                                         inst.components.hunger:DoDelta(-(amount*0.5))
                                     end    

                                  elseif amount < inst.gxb and (curhun >= amount*0.5 or inst.nodead) then --如果回复的血量小于当前骨细胞,并且小于人物当前饥饿值*0.5，才能正常回血 
                                            if amount > kx then --要是回复的血量大于缺少的血量，那就只回复缺少的血量
                                                 inst.gxb = inst.gxb - kx

                                                 if not inst.nodead then
                                                       inst.components.hunger:DoDelta(-(kx*0.5)) 
                                                end                                                        
                                            else 
                                                 inst.gxb = inst.gxb - amount --正常回血，骨细胞减少回复的血量数值

                                                 if not inst.nodead then 
                                                      inst.components.hunger:DoDelta(-(amount*0.5)) 
                                                end      
                                            end

                                             inst._gxb:set(inst.gxb)
                                else
                                     amount = 0                                                               
                            end
                               elseif amount > 0 and (inst.gxb < 1 or curhun < 1) and not inst.nodead then --骨细胞
                                    amount = 0
                     end         
               return _getHealth(self, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb) 
         end 

	    inst:ListenForEvent("killed", OnKilledOther)

	    if inst.components.eater then
             inst.components.eater:SetOnEatFn(oneat)
             inst.components.eater.strongstomach = true
      end 

	    inst.OnSave = onsave
      inst.OnLoad = onpreload
end

return MakePlayerCharacter("yuki", prefabs, assets, common_postinit, master_postinit)
