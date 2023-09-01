local prefabs =
{
    "shadow_despawn",
    "statue_transition_2",
    "nightmarefuel",
}

local weapons =
{
    "spear", 
    "hambat",
    "nightstick",
    "whip",
    "trident",
    "nightsword",
    "batbat"
}

local shadowbuild =
{
    "wilson",
    "wendy",
    "wx78",
    "willow",
    "woodie",
    "wolfgang",
    "wickerbottom",
    "webber",
    "wathgrithr",
    "waxwell"
}

local speech =
{
    "死吧！ 劣等生物",
    "我将吞噬你的灵魂，弱小者"
}

local brain = require "brains/shadow_dwx_brain"

local function OnAttacked(inst, data)
      if data.attacker ~= nil and not data.attacker:HasTag("player")then
             inst.components.combat:SetTarget(data.attacker)
      end
end

local function OnKilled(inst, data)
         local nottags = {'FX', 'NOCLICK', 'INLIMBO', 'playerghost', 'wall', "companion", "abigail", "player", "yuki_friend", "yuki_child", "glommer", "chester", "shadow_ly", "shadow_ly2"}
         local pt = Vector3(inst.Transform:GetWorldPosition())
         local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 15, {"_combat"}, nottags)
                 for k, v in pairs(ents) do 
                       if not inst.components.combat:CanTarget(v) and not inst.components.combat:IsAlly(v) then --如果周围没有可攻击的        
                             for i, u in pairs(inst.components.leader.followers) do
                                   if u.prefab == "shadow_ly2" and u.comopnents.health:Kill() then
                                            u.comopnents.health:Kill()
                                 end
                          end
                 end
         end
end

local function CalcSanityAura(inst, observer)
      return 1/6
end

local RETARGET_MUST_TAGS = { "_combat" }
local RETARGET_CANT_TAGS = { "wall", "dwx_friend", "player", "INLIMBO", "bee", "glommer", "chester", "playerghost" }
local function retargetfn(inst)
    local leader = inst.components.follower:GetLeader()
    return leader ~= nil
        and FindEntity(
            leader,
            TUNING.SHADOWWAXWELL_TARGET_DIST,
            function(guy)
                return guy ~= inst
                    and (guy.components.combat:TargetIs(leader) or
                        guy.components.combat:TargetIs(inst))
                    and inst.components.combat:CanTarget(guy)
            end,
            RETARGET_MUST_TAGS, -- see entityreplica.lua
            RETARGET_CANT_TAGS
        )
        or nil
end

local function keeptargetfn(inst, target)
    return inst.components.follower:IsNearLeader(14)
        and inst.components.combat:CanTarget(target)
		and target.components.minigame_participator == nil
end

local function OnHitOther(inst, data)
      if inst.components.health and not inst.components.health:IsDead() then
               inst.components.health:DoDelta(15, nil, (inst.nameoverride or inst.prefab), true, inst, true)        
      end

          if math.random() <= 0.33 then 
                inst.components.talker:Say((speech[math.random(#speech)]))           
      end        
end

local function nokeeptargetfn(inst)
    return false
end

local function noncombatantfn(inst)
    inst.components.combat:SetKeepTargetFunction(nokeeptargetfn)
end

local function MakeStronger(inst, level)
    local health_percent = inst.components.health:GetPercent()

            if level == 1 or level == 2 then
                   inst.sg:GoToState("powerup_wurt")
            end    

            if level >= 0 and level < 2 then
                  inst.components.combat:SetDefaultDamage(60)

                  inst.components.health:StartRegen(5, 2)
                  inst.components.health:SetMaxHealth(1000)
                  inst.components.health:SetPercent(health_percent)

            elseif level >= 2 then
                  --inst.components.trader.enabled = false
                  inst.components.combat:SetDefaultDamage(75)

                  inst.components.health:StartRegen(10, 2)
                  inst.components.health:SetMaxHealth(1500)
                  inst.components.health:SetPercent(health_percent)                  
          end
end

local function CanTakeItem(inst, ammo, giver)
      return (ammo.prefab == "shadow_ly_ls" and inst.components.follower.leader and inst.components.follower.leader == giver and inst.level < 2)
          or (ammo.components.equippable and ammo.components.equippable.equipslot == EQUIPSLOTS.HEAD)
end

local function OnGetItemFromPlayer(inst, giver, item)
    if item and item.components.equippable and item.components.equippable.equipslot == EQUIPSLOTS.HEAD then
        local current = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)

        if current ~= nil then
            inst.components.inventory:DropItem(current)
        end
        inst.components.inventory:Equip(SpawnPrefab(item.prefab))    
        --inst.AnimState:Show("hat")
        --inst.AnimState:OverrideSymbol("swap_hat", "hat_yuki", "swap_hat")
     else 
           inst.level = inst.level + 1

           if giver.folllevel and giver.folllevel < 2 then
                     giver.folllevel = giver.folllevel + 1
           end 
           MakeStronger(inst, inst.level)
     end      
end 

local function MakeMinion(prefab, tool, hat, master_postinit)
    local assets =
    {
        Asset("ANIM", "anim/ly_follower.zip"),   
        Asset("ANIM", "anim/swap_shadowly_weapon.zip"),
        Asset("SOUND", "sound/maxwell.fsb"),
        Asset("ANIM", "anim/"..tool..".zip"),
    }

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()
        inst.entity:AddDynamicShadow()
        inst.DynamicShadow:SetSize(1.3, .6)

        MakeCharacterPhysics(inst, 75, .5)

        inst.Transform:SetFourFaced(inst)
        --inst.MiniMapEntity:SetIcon("hat_yuki.tex")

        inst.AnimState:SetBank("wilson")

      if prefab == "shadow_ly" then
           inst.AnimState:SetBuild("ly_follower")
      else
           inst:AddTag("shadow_ly2")
           --inst.AnimState:SetMultColour(.6, .6, .3, 0.6)
           inst.AnimState:SetBuild((shadowbuild[math.random(#shadowbuild)]))
      end 

        --inst.AnimState:PlayAnimation("idle")

        --inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

        if tool ~= nil then
            inst.AnimState:OverrideSymbol("swap_object", tool, tool)
            inst.AnimState:Hide("ARM_normal")
        else
            inst.AnimState:Hide("ARM_carry")
        end
--[[
        if hat ~= nil then
            inst.AnimState:OverrideSymbol("swap_hat", hat, "swap_hat")
            inst.AnimState:Hide("HAIR_NOHAT")
            inst.AnimState:Hide("HAIR")
        else
            inst.AnimState:Hide("HAT")
            inst.AnimState:Hide("HAIR_HAT")
        end
]]
        inst:AddTag("shadow_ly")
        inst:AddTag("yuki_friend")
        --inst:AddTag("shadowminion")
        inst:AddTag("scarytoprey")
        --inst:AddTag("NOBLOCK")

        inst:AddComponent("talker")
        inst.components.talker.fontsize = 35
        inst.components.talker.font = TALKINGFONT
        inst.components.talker.colour = Vector3(133/255, 140/255, 167/255)
        inst.components.talker.offset = Vector3(0, -400, 0)
        inst.components.talker:MakeChatter()

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.level = 0
        inst.GetAge = MakeStronger 

        inst:AddComponent("locomotor")
        inst:AddComponent("inventory")

        if prefab == "shadow_ly" then
              inst.pickbrain = false
              inst.components.locomotor.runspeed = 6

        else
              inst.components.inventory.dropondeath = false

                   if inst.components.inventory ~= nil and not inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
                          local weapon = SpawnPrefab((weapons[math.random(#weapons)]))
                          inst.components.inventory:Equip(weapon)                         
                end 
--[[
                    inst:ListenForEvent("unequip", function(inst, data) 
                           inst.components.inventory:Equip(data.item)            
                 end) 
]]
                    inst:ListenForEvent("dropitem", function(inst, data)
                           inst.components.inventory:Equip(data.item)            
                 end)               

              inst.components.locomotor.runspeed = 4
        end

	      inst.components.locomotor:SetTriggersCreep(false)
        inst.components.locomotor.pathcaps = { ignorecreep = true }

        inst:AddComponent("health")
        inst.components.health:SetMaxHealth(600)
        inst.components.health.nofadeout = true
        inst.components.health:StartRegen(1, 2)

    if prefab == "shadow_ly" then

        inst:AddComponent("trader")
        inst.components.trader.deleteitemonaccept = true
        inst.components.trader:SetAcceptTest(CanTakeItem)
        inst.components.trader.onaccept = OnGetItemFromPlayer
        --inst.components.trader.enabled = true

        --inst:AddComponent("age")

        inst:AddComponent("leader")

        inst:AddComponent("inspectable")

        inst:AddComponent("sanityaura") 
        inst.components.sanityaura.aurafn = CalcSanityAura
    end    

        inst:AddComponent("combat")
        inst.components.combat.hiteffectsymbol = "torso"
        inst.components.combat:SetRange(2)
        inst.components.combat:SetDefaultDamage(30)
        inst.components.combat:SetAttackPeriod(1)
        inst.components.combat:SetRetargetFunction(1, retargetfn) --Look for leader's target.
        inst.components.combat:SetKeepTargetFunction(keeptargetfn) --Keep attacking while leader is near.

              local _OldSuggestTarget = inst.components.combat.SuggestTarget
                    inst.components.combat.SuggestTarget = function(self, target)
                             if self.target == nil and target ~= nil and (target:HasTag("player") or target:HasTag("glommer") or target:HasTag("chester")) then
                                 return false
                        else
                             return _OldSuggestTarget(self, target)
                    end
               end

              local _OldSetTarget = inst.components.combat.SetTarget
                    inst.components.combat.SetTarget = function(self, target)
                          if target and (target:HasTag("player") or target:HasTag("glommer") or target:HasTag("chester")) then
                                 self:DropTarget(target ~= nil)
                                 self:EngageTarget(target)
                        else
                             return _OldSetTarget(self, target)
                    end
               end 

        inst:AddComponent("follower")
        inst.components.follower:KeepLeaderOnAttacked()
        inst.components.follower.keepdeadleader = true
        inst.components.follower.keepleaderduringminigame = true    

        inst:SetBrain(brain)
        inst:SetStateGraph("SGlyfollower")      

        inst:ListenForEvent("attacked", OnAttacked)

    if prefab == "shadow_ly" then 
        inst.components.combat:SetAttackPeriod(2)
        --inst:ListenForEvent("loseloyalty", inst.Remove)

        inst:DoPeriodicTask(0.5, function(inst)
              if inst.components.follower.leader == nil then
                        inst:Remove()
              end   
        end)  
--[[
        inst:ListenForEvent("killed", OnKilled)

        inst:WatchWorldState("cycles", function(inst)
               local age = inst.components.age and inst.components.age:GetAgeInDays() or 0
                  MakeStronger(inst, age)
        end)
]]
        inst:ListenForEvent("onhitother", OnHitOther)
      --  inst:ListenForEvent("onattackother", OnAtkOther)
--[[
        inst:DoTaskInTime(0, function(inst)
                  local age = inst.components.age and inst.components.age:GetAgeInDays() or 0
                  MakeStronger(inst, age)
        end)
]] 
        inst.SpawnTask = inst:DoPeriodicTask(10, function(inst)
            local spawnnum = 0

            local nottags = {'FX', 'NOCLICK', 'INLIMBO', 'playerghost', 'wall', "companion", "abigail", "player", "yuki_friend", "yuki_child", "glommer", "chester", "shadow_ly", "shadow_ly2"}
            local pt = Vector3(inst.Transform:GetWorldPosition())
            local targets = TheSim:FindEntities(pt.x, pt.y, pt.z, 15, nil, nottags)
--[[
                            for k, v in pairs(targets) do
                                        if v and v.components.combat then
                                            print(v)
                                       else
                                        print("没有")     
                                    end
                                    print("5678")
                           end
]]
                 if inst.components.health and inst.components.health.currenthealth <= 1000 and inst.level >= 2 and inst.components.combat.target and inst.components.leader:CountFollowers("shadow_ly2") < 6 then 
                          if inst.components.leader:CountFollowers("shadow_ly2") == 5 then
                                  spawnnum = 0
                         else
                               spawnnum = 1
                      end

                      inst.components.talker:Say("以女王之名，降临！")    

                      for i = 0, spawnnum do             
                          local shadowfollower = SpawnPrefab("shadow_ly2")

                          inst.components.leader:AddFollower(shadowfollower)
                          shadowfollower.components.combat:SetTarget(inst.components.combat.target)
                          shadowfollower.components.follower.leader = inst
                          shadowfollower.Transform:SetPosition(inst.Transform:GetWorldPosition())
                   end

                     elseif inst.level >= 2 and inst.components.leader:CountFollowers("shadow_ly2") > 0 and inst.components.combat.target == nil and not inst.sg:HasStateTag("attack") then   --未处于战斗状态
                          for i, u in pairs(targets) do
                              if u == nil or (u and u.components.combat == nil) then --如果周围没有可攻击的  then 
                              	    print("没攻击目标")
                                    for k, v in pairs(inst.components.leader.followers) do
                                         if k.prefab == "shadow_ly2" and k.components.health and k.components.combat.target == nil and not k.sg:HasStateTag("attack") then
                                                k.components.health:Kill()
                                end
                           end
                       end
                  end                             
              end          
        end)
    end           

        inst.persists = false 

        return inst
    end

    return Prefab(prefab, fn, assets, prefabs)
end
--------------------------------------------------------------------------

return MakeMinion("shadow_ly", "swap_shadowly_weapon", nil), --c_findnext("shadow_ly", 50).components.follower.leader = GetPlayer()
       MakeMinion("shadow_ly2", "swap_shadowly_weapon", nil)


