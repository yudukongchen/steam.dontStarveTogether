local MakePlayerCharacter = require "prefabs/player_common"

local assets = {         
         Asset( "ANIM", "anim/chogath.zip" ),
         Asset( "ANIM", "anim/ghost_chogath_build.zip" ),
         Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
}

local prefabs = {
   "nfx"
}

local function LevelUp(inst) 
        local levelnum = 0.8+(inst.level*0.05) --体积 = 0.8+层数*0.05
		if levelnum>TUNING.TJ_MAX then
			levelnum =TUNING.TJ_MAX
		end
        local hunger_percent = inst.components.hunger:GetPercent()
        local health_percent = inst.components.health:GetPercent()

        local fx = SpawnPrefab("sand_puff")
                 if levelnum >= TUNING.TJ_MAX then  
                       fx.Transform:SetScale(TUNING.TJ_MAX, TUNING.TJ_MAX, TUNING.TJ_MAX)  --生成的特效跟随人物体积变大
                 else                          
                       fx.Transform:SetScale(levelnum, levelnum, levelnum)  --生成的特效跟随人物体积变大
                 end     
              fx.Transform:SetPosition(inst.Transform:GetWorldPosition())


        inst._level:set(inst.level) 

        inst.components.health:SetMaxHealth(TUNING.HEALTH + inst.level*5) --提高饥饿和生命最大数值
        inst.components.hunger:SetMax(TUNING.HUNGER + inst.level*5)
		
		inst.components.hunger:SetPercent(hunger_percent+levelnum*30/(TUNING.HUNGER + inst.level*5))
		inst.components.health:SetPercent(health_percent+levelnum*20/(TUNING.HEALTH + inst.level*5))        
		
        inst.components.hunger.hungerrate = levelnum * TUNING.WILSON_HUNGER_RATE
		inst.components.health:StartRegen(inst.level*0.025,1)
        --inst.components.hunger:DoDelta(levelnum*30)

        --inst.components.health:DoDelta(levelnum*20)

        inst.components.sanity:DoDelta(levelnum*10)        

            if levelnum < TUNING.TJ_MAX then
                   if TUNING.KJS_SPEED==false then
                          inst.components.locomotor.walkspeed = TUNING.WILSON_WALK_SPEED/levelnum
                          inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED/levelnum
                   end     
                        inst.Transform:SetScale(levelnum, levelnum, levelnum)
                        inst.DynamicShadow:SetSize(1.3+(levelnum*0.1), 0.6+(levelnum*0.1))

            elseif levelnum >= TUNING.TJ_MAX then  --体积不能大于2
                    if TUNING.KJS_SPEED==false then
                         inst.components.locomotor.walkspeed = TUNING.WILSON_WALK_SPEED / TUNING.TJ_MAX
                         inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED / TUNING.TJ_MAX  
                    end                 
                       inst.Transform:SetScale(TUNING.TJ_MAX, TUNING.TJ_MAX, TUNING.TJ_MAX)
                       inst.DynamicShadow:SetSize(2.6, 1.6)
            end   
		--inst.components.talker:Say(tostring(levelnum))
		--inst.components.talker:Say(tostring(inst.components.locomotor.walkspeed))
		--inst.components.talker:Say(tostring(TUNING.WILSON_WALK_SPEED))
end

local function onsave(inst, data)  --保存等级
    data.level = inst.level > 0 and inst.level or nil
    data.SkillOneUse = inst.SkillOneUse or false
end  
    
local function onpreload(inst, data)
     if data then
          if data.level then
                   inst.level = data.level
                   inst._level:set(inst.level)
                   LevelUp(inst)
           end

           if data.SkillOneUse then
                  inst.SkillOneUse = data.SkillOneUse
                  inst._canuseskill1:set(inst.SkillOneUse)
           end                        
     end
end 

-- This initializes for both the server and client. Tags can be added here.
local common_postinit = function(inst)
	  inst.MiniMapEntity:SetIcon( "chogath.tex" )
	  inst:AddTag("chogath")

	  inst.soundsname = "wolfgang"
    inst._level = net_shortint(inst.GUID, "inst._level", "inst._level")

    inst._canuseskill1 = net_bool(inst.GUID, "inst._canuseskill1", "inst._canuseskill1")
    inst._canuseskill1:set(true) 

    inst._canuseskill2 = net_bool(inst.GUID, "inst._canuseskill2", "inst._canuseskill2")
    inst._canuseskill2:set(true)

    inst._skillone_Cd = net_shortint(inst.GUID, "inst._skillone_Cd", "inst._skillone_Cd")
    inst._skilltwo_Cd = net_shortint(inst.GUID, "inst._skilltwo_Cd", "inst._skilltwo_Cd") 
end

-- This initializes for the server only. Components are added here.
local master_postinit = function(inst)

    inst.level = 0
    inst.levelup = LevelUp

    inst.SkillOneUse = true
    inst.SkillTwOUse = true
  --  inst.OnNewSpawn = equipscoutstuff

    inst.Transform:SetScale(0.8, 0.8, 0.8)

	inst.components.health:SetMaxHealth(TUNING.HEALTH)
    inst.components.hunger:SetMax(TUNING.HUNGER)
    inst.components.sanity:SetMax(150)
     
	inst.components.hunger.hungerrate = 0.8 * TUNING.WILSON_HUNGER_RATE
	
	inst.components.health:StartRegen(0,1)

    inst:AddComponent("epicscare")
    inst.components.epicscare:SetRange(10)--5
	
	if TUNING.KJS_SPEED==false then
        -- 移动速度 (可选)
		inst.components.locomotor.walkspeed = (TUNING.WILSON_WALK_SPEED/0.8)
		--跑步速度
		inst.components.locomotor.runspeed = (TUNING.WILSON_RUN_SPEED/0.8)
    end 	

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", function(inst, data)
           if data.name == "skillone" then
                     inst.SkillOneUse = true
                     inst._canuseskill1:set(true)

           elseif data.name == "skilltwo" then
                     inst.SkillTwOUse = true
                     inst._canuseskill2:set(true)
           end
    end)             	

    inst:DoTaskInTime(0, function(inst)
                 local skill_one_Time = inst.components.timer ~= nil and (inst.components.timer:GetTimeLeft("skillone") or 0) or nil
                 local skill_two_Time = inst.components.timer ~= nil and (inst.components.timer:GetTimeLeft("skilltwo") or 0) or nil

                 if skill_one_Time and skill_one_Time > 0 then
                     inst.SkillOneUse = false
                     inst._canuseskill1:set(false)
             end 

                 if skill_two_Time and skill_two_Time > 0 then
                     inst.SkillTwOUse = false
                     inst._canuseskill2:set(false)
             end 
    end) 

    inst.RengeTask = inst:DoPeriodicTask(4, function(inst)  --每四秒回复层数*0.1的血量
            if not inst:HasTag("playerghost") and inst.level >= 1 and inst.components.health then
                   --inst.components.health:DoDelta(inst.level*0.1)                              
            end           
    end)  

    inst.SkillCd = inst:DoPeriodicTask(0.2, function()
                 local skill_one_Time = inst.components.timer ~= nil and (inst.components.timer:GetTimeLeft("skillone") or 0) or nil
                 local skill_two_Time = inst.components.timer ~= nil and (inst.components.timer:GetTimeLeft("skilltwo") or 0) or nil

                 if skill_one_Time then
                       inst._skillone_Cd:set(skill_one_Time)
             end 

                 if skill_two_Time then 
                       inst._skilltwo_Cd:set(skill_two_Time)
             end                    
    end)      

   
	  inst:ListenForEvent("ms_respawnedfromghost",function(inst)  --人物重生事件
	  	    local levelnum = 0.8+(inst.level*0.05) --体积 = 0.8+层数*0.05

                   if TUNING.KJS_SPEED == false then  --mod设置速度不随体积加快时
                   	     if levelnum < TUNING.TJ_MAX then
                               inst.components.locomotor.walkspeed = TUNING.WILSON_WALK_SPEED/levelnum
                               inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED/levelnum

                              elseif levelnum >= TUNING.TJ_MAX then  --体积不能大于2
                                    inst.components.locomotor.walkspeed = TUNING.WILSON_WALK_SPEED / TUNING.TJ_MAX
                                    inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED / TUNING.TJ_MAX  
                      end
               end       
	  end)	
--[[ 
	   if inst.components.eater then
          inst.components.eater:SetOnEatFn(oneat)
    end 
]]
	  inst.OnSave = onsave
    inst.OnPreLoad = onpreload
end

return MakePlayerCharacter("chogath", prefabs, assets, common_postinit, master_postinit)
