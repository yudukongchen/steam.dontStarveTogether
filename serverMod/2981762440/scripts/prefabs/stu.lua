local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
}

local prefabs = {}

-- 初始物品
local start_inv = {
}

TUNING.STU_HEALTH = (TUNING.STU_MODE == 1 and 100 or 150) * TUNING.STU_HS_SET --* 1.23
TUNING.STU_HUNGER = 150 * TUNING.STU_HS_SET
TUNING.STU_SANITY = (TUNING.STU_MODE == 1 and 120 or 200) * TUNING.STU_HS_SET

local function LoadSkill(inst)
    inst:DoTaskInTime(0, function(inst)
        local Skill_Buff = inst.components.timer ~= nil and (inst.components.timer:GetTimeLeft("Stu_Skill1") or 0) or nil        
        local Skill_Cd = inst.components.timer ~= nil and (inst.components.timer:GetTimeLeft("Stu_Skill1_Cd") or 0) or nil

        local Skill2_Buff = inst.components.timer ~= nil and (inst.components.timer:GetTimeLeft("Stu_Skill2") or 0) or nil        
        local Skill2_Cd = inst.components.timer ~= nil and (inst.components.timer:GetTimeLeft("Stu_Skill2_Cd") or 0) or nil

        local Skill3_Buff = inst.components.timer ~= nil and (inst.components.timer:GetTimeLeft("Stu_Skill3") or 0) or nil        
        local Skill3_Cd = inst.components.timer ~= nil and (inst.components.timer:GetTimeLeft("Stu_Skill3_Cd") or 0) or nil                
        if Skill_Buff ~= nil and Skill_Buff > 0 then
            inst:Skill1(true)
        end

        if Skill2_Buff ~= nil and Skill2_Buff > 0 then
            inst:Skill2(true)
        end

        if Skill3_Buff ~= nil and Skill3_Buff > 0 then
            inst:Skill3(true)
        end

        if Skill_Cd ~= nil and Skill_Cd > 0 then
            inst:AddTag("skill1_cd")
        end

        if Skill2_Cd ~= nil and Skill2_Cd > 0 then
            inst:AddTag("skill2_cd")
        end

        if Skill3_Cd ~= nil and Skill3_Cd > 0 then
            inst:AddTag("skill3_cd")
        end                 
    end)
end

local function HasPacket()
    local val = false
    for k, v in ipairs(AllPlayers) do
    if v.prefab == "skd" and v.components.inventory:Has("skd_new_item1", 1) then
        val = true
    end
    end 

    return val    
end

local function GetStuAmulet1_2_Level()
    local val = false
    for k, v in ipairs(AllPlayers) do
    if v.prefab == "stu" and v.components.inventory:EquipHasTag("stu_amulet1_2") then
        val = true
    end
    end

    return val
end

local function GetStuAmulet1_3_Level()
    local val = false
    for k, v in ipairs(AllPlayers) do
    if v.prefab == "stu" and v.components.inventory:EquipHasTag("stu_amulet1_3") then
        val = true
    end
    end

    return val
end

local function SetMaxSanity(inst)
    local percent = inst._stu_sanity or inst.components.sanity:GetPercent() or 1
    local maxsanity = 0 

    if inst.sp_level == 0 then
        maxsanity = 120

    elseif inst.sp_level == 1 then 
        maxsanity = 160

    else
        maxsanity = 200    
    end	

    if inst.components.inventory:EquipHasTag("stu_amulet1_1") then
        maxsanity = maxsanity + 100

    elseif inst.components.inventory:EquipHasTag("stu_amulet1_2") then 
        maxsanity = maxsanity + 200

    elseif inst.components.inventory:EquipHasTag("stu_amulet1_3") then 
        maxsanity = maxsanity + 300
    end

    inst.components.sanity:SetMax(maxsanity)
    inst.components.sanity:SetPercent(percent)    
end

local function SetSkillMaxHealth(inst)
    local percent = inst._stu_health or inst.components.health:GetPercent() or 1 
    local mult1 = 0 
    local mult2 = 0 
    local maxhealth = 0

    if GetStuAmulet1_3_Level() == true then
        mult1 = 1.33
    elseif GetStuAmulet1_2_Level() == true then
        mult1 = 1.28
    else
        mult1 = 1.23             
    end

    if inst.skill3_level == 0 then
        mult2 = 0.75
    else	
        mult2 = 1
    end	

    if inst.sp_level == 0 then
        maxhealth = 100
    elseif inst.sp_level == 1 then
        maxhealth = 120
    else
        maxhealth = 150                
    end	

    maxhealth = maxhealth * (mult1 + mult2)

    if HasPacket() == true then
        maxhealth = maxhealth + 30
    end 

    if inst.components.inventory:EquipHasTag("stu_amulet2_1") then
        maxhealth = maxhealth + 50

    elseif inst.components.inventory:EquipHasTag("stu_amulet2_2") then 
        maxhealth = maxhealth + 65

    elseif inst.components.inventory:EquipHasTag("stu_amulet2_3") then 
        maxhealth = maxhealth + 90
    end

    inst.components.health:SetMaxHealth(maxhealth)
    inst.components.health:SetPercent(percent)  
end

local function SetMaxHealth(inst)
    local percent = inst._stu_health or inst.components.health:GetPercent() or 1 
    local mult = 0 
    local maxhealth = 0

    if GetStuAmulet1_3_Level() == true then
        mult = 1.33
    elseif GetStuAmulet1_2_Level() == true then
        mult = 1.28
    else
        mult = 1.23             
    end	

    if inst.sp_level == 0 then
        maxhealth = 100
    elseif inst.sp_level == 1 then
        maxhealth = 120
    else
        maxhealth = 150                
    end	
    maxhealth = maxhealth * mult 

    if HasPacket() == true then
        maxhealth = maxhealth + 30
    end 

    if inst.components.inventory:EquipHasTag("stu_amulet2_1") then
        maxhealth = maxhealth + 50

    elseif inst.components.inventory:EquipHasTag("stu_amulet2_2") then 
        maxhealth = maxhealth + 65

    elseif inst.components.inventory:EquipHasTag("stu_amulet2_3") then 
        maxhealth = maxhealth + 90
    end

    --print(maxhealth)        
    inst.components.health:SetMaxHealth(maxhealth)
    inst.components.health:SetPercent(percent)     
end

local function LoadSanWei(inst, kill)
    SetMaxSanity(inst)

    local Skill3_Buff = inst.components.timer ~= nil and (inst.components.timer:GetTimeLeft("Stu_Skill3") or 0) or nil  
    if Skill3_Buff ~= nil and Skill3_Buff > 0 then
        inst:SetSkillMaxHealth()
    else
        inst:SetMaxHealth()    
    end  

    if inst.components.combat.damagemultiplier <= 1.5 then
        inst.components.combat.damagemultiplier = (inst.sp_level == 0 and 1) or (inst.sp_level == 1 and 1.25) or (inst.sp_level >= 2 and 1.5)  
    end    
end   

local function Skill1(inst, val)
    if val then
        inst.components.combat.damagemultiplier = inst.skill1_level == 0 and 2 or 2.5
    else
        inst.components.combat.damagemultiplier = (inst.sp_level == 0 and 1) or (inst.sp_level == 1 and 1.25) or (inst.sp_level >= 2 and 1.5)    
    end
end

local function Skill2(inst, val)
    if val then
        inst.components.combat.damagemultiplier = 3.5
        inst.components.locomotor.runspeed = 8

        if inst.components.sanity:GetPercent() < 0.3 then
            inst.components.sanity:SetPercent(0.3)
        end    
    else
        inst.components.combat.damagemultiplier = (inst.sp_level == 0 and 1) or (inst.sp_level == 1 and 1.25) or (inst.sp_level >= 2 and 1.5) 
        inst.components.locomotor.runspeed = 6       
    end
end

local function OnHitOther2(inst, data)
    if data and data.target then
        inst.components.health:DoDelta(-TUNING.STU_SKILL3_ATK_HEL)
    end    
end

local function Skill3(inst, val)
    if val then
        SetSkillMaxHealth(inst)
        inst.components.combat.damagemultiplier = 3

        local amulet = inst.components.inventory ~= nil and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.NECK or EQUIPSLOTS.BODY) or nil
        inst:ListenForEvent("onhitother", OnHitOther2)
        if inst.Skill3_Task == nil then
        inst.Skill3_Task = inst:DoPeriodicTask(0.33, function(inst)
            if inst.components.health:GetPercent() < 0.5 or inst.components.sanity:GetPercent() < 0.5 then --ThePlayer.components.sanity:SetPercent(0)
                inst.components.combat.damagemultiplier = inst.skill3_level == 0 and 3.5 or 4
            else
                inst.components.combat.damagemultiplier = inst.skill3_level == 0 and 2.5 or 3                 
            end
        end)
        end

    else
        SetMaxHealth(inst)
        if inst.Skill3_Task then
            inst.Skill3_Task:Cancel()
            inst.Skill3_Task = nil
        end    
        inst.components.combat.damagemultiplier = (inst.sp_level == 0 and 1) or (inst.sp_level == 1 and 1.25) or (inst.sp_level >= 2 and 1.5) 

        local amulet = inst.components.inventory ~= nil and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.NECK or EQUIPSLOTS.BODY) or nil        
        inst:RemoveEventCallback("onhitother", OnHitOther2)    
    end
end

local function SpawnFx(inst)    
    if inst.ghost_fx == nil or (inst.ghost_fx and not inst.ghost_fx:IsValid()) then
        inst.ghost_fx = SpawnPrefab("stu_ghost_skill")
        inst.ghost_fx.entity:SetParent(inst.entity)

        if inst.components.skinner and inst.components.skinner.skin_name == "stu_skin1_none" then
            --print("1")
            inst.ghost_fx.AnimState:SetBank("stu_b_skin")
            inst.ghost_fx.AnimState:SetBuild("stu_b_skin")
            inst.ghost_fx.AnimState:PlayAnimation("idle", true)
        --else
           -- print("2")
            --inst.ghost_fx.AnimState:SetBuild("ghost")               
            --inst.ghost_fx.AnimState:SetBuild("ghost_stutrans_build")
            --inst.ghost_fx.AnimState:PlayAnimation("idle", true)        
        end    
    end
end

local function RemoveFx(inst)    
    if inst.ghost_fx ~= nil then
        if inst.ghost_fx:IsValid() then
            inst.ghost_fx:Remove()   
        end
        inst.ghost_fx = nil
    end
end

local function LocoDeBuff(inst, speed)
    if inst.stu_ghost_task == nil then
    --print(speed)

    if inst.components.locomotor then
        inst.components.locomotor:SetExternalSpeedMultiplier(inst, "stu_ghost", speed)

        inst.stu_ghost_task = inst:DoTaskInTime(3, function(inst)
            inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "stu_ghost")
            inst.stu_ghost_task:Cancel()
            inst.stu_ghost_task = nil
        end)       
    end 
    end
end

local function DoGhostAtk(inst)
    local self = inst.components.combat or nil  --ThePlayer.components.sanity:SetPercent(0.1)
    local damageNum = ((inst.components.inventory:EquipHasTag("stu_amulet2_3") and 46) or (inst.components.inventory:EquipHasTag("stu_amulet2_2") and 34.5)
    or (inst.components.inventory:EquipHasTag("stu_amulet2_2") and 23) or 20)
        * (self.damagemultiplier or 1)
        * self.externaldamagemultipliers:Get()
        * TUNING.STU_SKILL_MULT
        + (self.damagebonus or 0)


    local speed = (inst.components.inventory:EquipHasTag("stu_amulet2_3") and 0.4) or (inst.components.inventory:EquipHasTag("stu_amulet2_2") and 0.5)
    or 0.6

    local x, y, z = inst.Transform:GetWorldPosition()
    local exclude_tags = {'FX', 'NOCLICK', 'INLIMBO', 'player'}
    local ents = TheSim:FindEntities(x, y, z, 3, { "_combat" }, exclude_tags) 
    for k, v in ipairs(ents) do
        if v and v.components.combat and inst.replica.combat:CanTarget(v) and not inst.replica.combat:IsAlly(v)
        and v.components.health and not v.components.health:IsDead() then
            --v.components.combat:GetAttacked(inst, damageNum)
        LocoDeBuff(v, speed)    
        v.components.health:DoDelta(-damageNum, nil, inst.prefab, false, nil, true)

        if v.components.health:IsDead() then  --击杀敌人后
            v:PushEvent("killed", { victim = v })  --玩家发出击杀事件

            if v.components.combat ~= nil and v.components.combat.onkilledbyother ~= nil then  --如果怪物有死亡会执行特殊函数的话
                v.components.combat.onkilledbyother(v, inst)  --执行死亡特殊函数
            end
        end  
            v:PushEvent("attacked",{attacker = inst, damage = 0})         
        end    
    end
end

local function OnDeath(inst)
    local Ghost_Skill = inst.components.timer ~= nil and (inst.components.timer:GetTimeLeft("Ghost_Skill") or 0) or nil 
    if Ghost_Skill and Ghost_Skill > 0 then 
        inst.components.timer:StopTimer("Ghost_Skill")
    end

    if inst:HasTag("is_ghosted") then
        inst:RemoveTag("is_ghosted")
    end

    if inst.components.skinner and inst.components.skinner.skin_name == "stu_skin1_none" then
        inst.AnimState:SetBuild("stu_skin")
    else
        inst.AnimState:SetBuild("stu")
    end  

    inst.DynamicShadow:Enable(true)

    if inst.components.stu_swim then
        inst.components.stu_swim.can_swim = false
    end

    if inst.ghost_atk_task then
        inst.ghost_atk_task:Cancel()
        inst.ghost_atk_task = nil
    end  

    RemoveFx(inst)  
end

local function SanDel(inst, data)
    if inst:HasTag("playerghost") or inst.components.health:IsDead() then  --ThePlayer:PushEvent("knockback", { knocker = ThePlayer, radius = 3 })
        return  --ThePlayer:PushEvent("knockedout") ThePlayer.components.sanity:SetPercent(0)
    end  

    local Ghost_Skill = inst.components.timer ~= nil and (inst.components.timer:GetTimeLeft("Ghost_Skill") or 0) or nil 
    if Ghost_Skill and Ghost_Skill > 0 then return end

    if inst.components.sanity:GetPercent() <= 0.05 then  
        --print("1")
        --inst:Hide()
        if not inst:HasTag("is_ghosted") then
            inst:AddTag("is_ghosted")
            inst.SoundEmitter:PlaySound("stu_sound/stu_sound/ghost_skill") 
        end  
        inst.components.inventory:Hide()
        inst:ShowActions(false)
        inst.AnimState:SetBuild("aa")

        inst.components.sanity:SetPercent(1)
        inst.components.health:SetPercent(1)

        inst.DynamicShadow:Enable(false)
        if inst.components.stu_swim then
            inst.components.stu_swim.can_swim = true
        end

        if inst.ghost_atk_task == nil then
            inst.ghost_atk_task = inst:DoPeriodicTask(0.5, DoGhostAtk) 
        end   

        SpawnFx(inst)
        inst.components.timer:StartTimer("Ghost_Skill", 20) 

    else  
        
        if inst:HasTag("is_ghosted") then
            inst:RemoveTag("is_ghosted")
        end
        --print("2")
        --inst:Show()
        inst.components.inventory:Show()
        inst:ShowActions(true)

        if inst.components.skinner and inst.components.skinner.skin_name == "stu_skin1_none" then
        inst.AnimState:SetBuild("stu_skin")
        else
        inst.AnimState:SetBuild("stu")
        end 

        inst.DynamicShadow:Enable(true)

        if inst.components.stu_swim and not inst.components.inventory:EquipHasTag("stu_hat") then
            inst.components.stu_swim.can_swim = false
        end 

        if inst.ghost_atk_task then
            inst.ghost_atk_task:Cancel()
            inst.ghost_atk_task = nil
        end  

        RemoveFx(inst)
        --inst:RemoveEventCallback("death", OnDeath)       
    end       
end

local function OnAnimalDeath(inst, data) 
    if inst.sp_level >= 2 then
        return 
    end 

    if data.afflicter and (data.afflicter:HasTag("player") or (data.afflicter.atk_player_table ~= nil and data.afflicter.atk_player_table[inst] == true))
    and data.inst and data.inst:IsNear(inst, 30) and data.inst.components.health then
    if data.afflicter == inst or (data.inst.atk_player_table ~= nil and data.inst.atk_player_table[inst] == true) then
        if inst.sp_level == 0 and (data.inst.prefab == "dragonfly" or data.inst.prefab == "beequeen") then
            inst.sp_level = 1
            inst._sp_level:set(1)
            LoadSanWei(inst)

        elseif inst.sp_level == 1 and (data.inst.prefab == "daywalker" or data.inst.prefab == "minotaur") then 
            inst.sp_level = 2
            inst._sp_level:set(2)
            LoadSanWei(inst, true)          
        end
  
        if inst.skill1_level == 0 and data.inst.prefab == "crabking" then 
            inst.skill1_level = 1

        elseif inst.skill2_level == 0 and data.inst:HasTag("stalker") then 
            inst.skill2_level = 1

        elseif inst.skill3_level == 0 and (data.inst.prefab == "alterguardian_phase1" or data.inst.prefab == "alterguardian_phase2" or data.inst.prefab == "alterguardian_phase3") then 
            inst.skill3_level = 1                      
        end 
    end    
    end
end

local function OnHitOther(inst, data)
    if data.target then
    if data.target.atk_player_table == nil then
        data.target.atk_player_table = {}
    end
    if data.target.atk_player_table[inst] == nil then
        data.target.atk_player_table[inst] = true
    end    
    end
end

local function onbecamehuman(inst)
	inst.components.locomotor:SetExternalSpeedMultiplier(inst, "stu_speed_mod", 1)
end

local function onbecameghost(inst)
    inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "stu_speed_mod")
end

local function OnSave(inst, data)
    data.sp_level    = inst.sp_level
    data.skill1_level = inst.skill1_level
    data.skill2_level = inst.skill2_level
    data.skill3_level = inst.skill3_level        
    data._stu_health = inst.components.health:GetPercent() or 1
    data._stu_sanity = inst.components.sanity:GetPercent() or 1
end

local function onload(inst, data)
    if data ~= nil then
        if data.skill1_level ~= nil then
            inst.skill1_level = data.skill1_level
        end

        if data.skill2_level ~= nil then
            inst.skill2_level = data.skill2_level
        end

        if data.skill3_level ~= nil then
            inst.skill3_level = data.skill3_level
        end

        if data._stu_health ~= nil then
            inst._stu_health = data._stu_health
        end

        if data._stu_sanity ~= nil then
            inst._stu_sanity = data._stu_sanity
        end

        if data.sp_level ~= nil then
            inst.sp_level = data.sp_level
            inst._sp_level:set(inst.sp_level) 
            --LoadSanWei(inst)
        end                
    end

    inst:DoTaskInTime(0, function()
    	LoadSanWei(inst)
        inst._stu_health = nil
        inst._stu_sanity = nil
    end)    

    inst:DoTaskInTime(0.1, function()
    	LoadSanWei(inst)
        inst._stu_health = nil
        inst._stu_sanity = nil
    end)   

    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    inst:ListenForEvent("ms_becameghost", onbecameghost)

    if inst:HasTag("playerghost") then
        onbecameghost(inst)
    else
        onbecamehuman(inst)
    end

    LoadSkill(inst)
end

local function OnNewSpawn(inst)
    onload(inst)

    inst:DoTaskInTime(0, function(inst)
    if inst.components.skinner and inst.components.skinner.skin_name == "stu_skin1_none" then
    local sword = SpawnPrefab("stu_chainsaw_skin")
    inst.components.inventory:Equip(sword)

    local hat = SpawnPrefab("stu_hat_skin")
    inst.components.inventory:Equip(hat) 
    else
    local sword = SpawnPrefab("stu_chainsaw")
    inst.components.inventory:Equip(sword)

    local hat = SpawnPrefab("stu_hat")
    inst.components.inventory:Equip(hat) 
    end
    end)         
end

local function sanityfn(inst)--, dt)
    local delta = inst.components.moisture.moisture <= 20 and 3/60 or 0
    return -delta
end

local function RemoveAllBuff(inst)
    local toremove = {}
    local self = inst.components.debuffable
    for k, v in pairs(self.debuffs) do
        if v.inst.components.debuff then
            table.insert(toremove, k)
        end
    end

    for i, v in ipairs(toremove) do
        self:RemoveDebuff(v)
    end

    OnDeath(inst)
end

local function OnEat(inst, data)
    if data and data.food then
    if data.food:HasTag("preparedfood") then
        inst.components.sanity:DoDelta(15)
    else
        inst.components.sanity:DoDelta(-5)    
    end    
    end    
end

local common_postinit = function(inst) 
	inst:AddTag("stu")
    inst:AddTag("stronggrip")
	inst.MiniMapEntity:SetIcon( "stu.tex" )

    inst._skill1_Cd = net_shortint(inst.GUID, "inst._skill1_Cd", "inst._skill1_Cd")
    inst._skill2_Cd = net_shortint(inst.GUID, "inst._skill2_Cd", "inst._skill2_Cd")
    inst._skill3_Cd = net_shortint(inst.GUID, "inst._skill3_Cd", "inst._skill3_Cd") 

    inst._skill1_Cd_start = net_bool(inst.GUID, "inst._skill1_Cd_start", "inst._skill1_Cd_start_dirty")
    inst._skill1_Cd_start:set(false)

    inst._skill2_Cd_start = net_bool(inst.GUID, "inst._skill2_Cd_start", "inst._skill2_Cd_start_dirty")
    inst._skill2_Cd_start:set(false)

    inst._skill3_Cd_start = net_bool(inst.GUID, "inst._skill3_Cd_start", "inst._skill3_Cd_start_dirty") 
    inst._skill3_Cd_start:set(false)

    inst._sp_level = net_ushortint(inst.GUID, "inst_sp_level", "sp_level_dirty")
    inst._sp_level:set(TUNING.STU_MODE == 1 and 0 or 2)  
end

local master_postinit = function(inst)
	inst.soundsname = "wendy"

    inst._stu_health = nil
    inst._stu_sanity = nil

    inst.skill1_level = TUNING.STU_MODE == 1 and 0 or 1
    inst.skill2_level = TUNING.STU_MODE == 1 and 0 or 1
    inst.skill3_level = TUNING.STU_MODE == 1 and 0 or 1

    inst.sp_level = TUNING.STU_MODE == 1 and 0 or 2

	--inst.components.health:SetMaxHealth(TUNING.STU_HEALTH)
    --SetMaxHealth(inst)
	inst.components.hunger:SetMax(TUNING.STU_HUNGER)
	inst.components.sanity:SetMax(TUNING.STU_SANITY)
	
    inst.components.combat.damagemultiplier = (inst.sp_level == 0 and 1) or (inst.sp_level == 1 and 1.25) or (inst.sp_level >= 2 and 1.5) 
	
	inst.components.hunger.hungerrate = 1 * TUNING.WILSON_HUNGER_RATE
    inst.components.sanity.night_drain_mult = 0
    inst.components.sanity.neg_aura_mult = 0
    inst.components.sanity.custom_rate_fn = sanityfn

    inst:AddComponent("reader")
	
    inst:ListenForEvent("timerdone", function(inst, data)
        if data.name == "Stu_Skill1" then
            Skill1(inst, false)
            inst.components.talker:Say("1技能效果结束！！")

            local time = inst.skill1_level == 0 and 40 or 35
            inst.components.timer:StartTimer("Stu_Skill1_Cd", time)

        elseif data.name == "Stu_Skill2" then
            Skill2(inst, false)
            inst.components.sanity:SetPercent(0)
            inst.components.talker:Say("2技能效果结束！！")
            inst.components.timer:StartTimer("Stu_Skill2_Cd", 35) 

        elseif data.name == "Stu_Skill3" then
            Skill3(inst, false)
            inst.components.talker:Say("3技能效果结束！！")

            local time = inst.skill3_level == 0 and 35 or 30
            inst.components.timer:StartTimer("Stu_Skill3_Cd", time) 

        elseif data.name == "Stu_Skill1_Cd" then
            inst:RemoveTag("skill1_cd")
            inst.components.talker:Say("1技能CD结束！！")

        elseif data.name == "Stu_Skill2_Cd" then
            inst:RemoveTag("skill2_cd")
            inst.components.talker:Say("2技能CD结束！！") 

        elseif data.name == "Stu_Skill3_Cd" then
            inst:RemoveTag("skill3_cd")
            inst.components.talker:Say("3技能CD结束！！")

        elseif data.name == "Ghost_Skill" and not (inst:HasTag("playerghost") or inst.components.health:IsDead()) then
            inst.components.sanity:SetPercent(1)
            inst.components.health:SetPercent(1) 

            RemoveAllBuff(inst)                                         
        end 
    end)

    inst.SkillCd = inst:DoPeriodicTask(0, function()
        local skill_one_Time = inst.components.timer ~= nil and (inst.components.timer:GetTimeLeft("Stu_Skill1_Cd") or 0) or nil
        local skill_two_Time = inst.components.timer ~= nil and (inst.components.timer:GetTimeLeft("Stu_Skill2_Cd") or 0) or nil
        local skill_three_Time = inst.components.timer ~= nil and (inst.components.timer:GetTimeLeft("Stu_Skill3_Cd") or 0) or nil

        if skill_one_Time then
            inst._skill1_Cd:set(skill_one_Time)  --print(ThePlayer._skill1_Cd:value())
        end 

        if skill_two_Time then 
            inst._skill2_Cd:set(skill_two_Time)
        end

        if skill_three_Time then 
            inst._skill3_Cd:set(skill_three_Time)
        end                            
    end)

    --inst:ListenForEvent("sanitydelta", SanDel)
    inst:DoPeriodicTask(0.1, SanDel)
    inst:ListenForEvent("oneat", OnEat)
    inst:ListenForEvent("death", OnDeath)

    if TUNING.STU_MODE == 1 then
    inst.listenfn = function(listento, data) OnAnimalDeath(inst, data) end
    inst:ListenForEvent("onhitother", OnHitOther)
    inst:ListenForEvent("entity_death", inst.listenfn, TheWorld)
    end

    LoadSkill(inst)

    inst.SetMaxSanity = SetMaxSanity 

    inst.SetMaxHealth = SetMaxHealth
    inst.SetSkillMaxHealth = SetSkillMaxHealth

    inst.Skill1 = Skill1
    inst.Skill2 = Skill2
    inst.Skill3 = Skill3

    inst.OnSave = OnSave
	inst.OnLoad = onload

    inst.OnNewSpawn = OnNewSpawn
end

return MakePlayerCharacter("stu", prefabs, assets, common_postinit, master_postinit, start_inv)
