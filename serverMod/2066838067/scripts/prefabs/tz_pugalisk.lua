local pu = require ("prefabs/tz_pugalisk_util")
local TzEntity = require("util/tz_entity")
local TzDebuffUtil = require("tz_debuff_util")

local assets =
{	
    Asset("ANIM", "anim/tz_python_test_2.zip"),
    Asset("ANIM", "anim/python_test.zip"),
    Asset("ANIM", "anim/tz_python_segment_broken02_build.zip"),    
    Asset("ANIM", "anim/tz_python_segment_broken_build.zip"),    
    Asset("ANIM", "anim/tz_python_segment_build.zip"),                            
    Asset("ANIM", "anim/tz_python_segment_tail02_build.zip"), 
    Asset("ANIM", "anim/tz_python_segment_tail_build.zip"), 

    Asset("ANIM", "anim/tz_python_action_stun.zip"), 

    Asset("ANIM", "anim/tz_python_lightning_warn.zip"),     
    
}


SetSharedLootTable( 'tz_pugalisk',
{
    {'monstermeat',             1.00},
    {'monstermeat',             1.00},
    {'monstermeat',             1.00},
})
 
local SHAKE_DIST = 40

local function teleport_override_fn(inst)
    local ipos = inst:GetPosition()
    return ipos
end

local function CombatRedirectFn(inst, attacker, damage, weapon, stimuli)
    local retarget = nil 
    if inst.prefab == "tz_pugalisk_segment" or inst.prefab == "tz_pugalisk_body" then
        local startpt = inst.startpt or inst 

        
        if startpt.components.tz_pugalisk_segmented and startpt.invulnerable then
            -- Not Take Damage

            inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal",nil,.25)
            inst.SoundEmitter:PlaySound("dontstarve/wilson/hit_metal")

            retarget = pu.SpawnHitFx(inst)
        else 
            -- Head Take Damage
            retarget = inst.host or startpt.host
        end
    elseif inst.prefab == "tz_pugalisk_tail" then
        inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal",nil,.25)
        inst.SoundEmitter:PlaySound("dontstarve/wilson/hit_metal")

        -- Tail never take damage
        retarget = pu.SpawnHitFx(inst)
    end

    if retarget == nil and inst.prefab == "tz_pugalisk" then
        -- local broken_cnt = inst:GetBrokenBodyCount()

        -- if broken_cnt < inst.components.tz_pugalisk_multibody.maxbodies - 1 then
        --     retarget = pu.SpawnHitFx(inst)
        -- end

        -- Ly modified:Head is not invincible now 

    elseif retarget and retarget.prefab == "tz_pugalisk" then
        local broken_cnt = retarget:GetBrokenBodyCount()

        if broken_cnt < retarget.components.tz_pugalisk_multibody.maxbodies - 1 then
            retarget = pu.SpawnHitFx(inst)
        end
    end


    return retarget
end

-- TODO:check infinite damage back
local function GetElecAttackedIfNoEyeUnbrella(attacker,target,damage)
    if target:IsValid() and attacker.components.combat:IsValidTarget(target) then
        local elec_imue = target:HasTag("electricdamageimmune") 
                            or (target.components.inventory and target.components.inventory:IsInsulated())
                            or (target.components.inventory and target.components.inventory:HasItemWithTag("tz_pugalisk_crystal",1))
        if not elec_imue then
            damage = damage or 10
            target.components.combat:GetAttacked(attacker,damage,nil,"electric")
        end
        
        
    end
    
end

local function DoLightningStrike(pos,damage,warning_time)
    if warning_time and warning_time >= 0 then
        local warning = SpawnAt("pugalisk_lightning_warning",pos)
        warning:DoTaskInTime(warning_time,function()
            DoLightningStrike(pos,damage)
            ErodeAway(warning)
        end)
    else 
        local lightning = SpawnAt("pugalisk_lightning_strike",pos)

        -- Spawn a fake lightning for screen flash and shake :)
        local lightning_fake = SpawnAt("lightning",pos)
        lightning_fake:Hide()

        for _,v in pairs(TheSim:FindEntities(pos.x,pos.y,pos.z,1,{"_combat","_health"},{"INLIMBO","tz_pugalisk"})) do
            if v.components.combat:CanBeAttacked(lightning) then
                v.components.combat:GetAttacked(lightning,damage,nil,"electric")
            end
        end

        
        for _, v in pairs(TheSim:FindEntities(pos.x, pos.y, pos.z, 3, nil, {"player","INLIMBO","lightningblocker","tz_pugalisk"})) do
            if v.components.burnable ~= nil then
                v.components.burnable:Ignite()
            end
        end
    end
    
    
end

local function OnAttacked_Common(inst,data)
    -- local host = inst.host or inst
    -- if data.damage >= 20000 then
    --     host.damage_over_20000 = host.damage_over_20000 + 1
    --     host.loot_decrease_percent = 1
    -- elseif data.damage >= 8000 then 
    --     host.damage_over_8000 = host.damage_over_8000 + 1
    --     host.loot_decrease_percent = math.min(host.loot_decrease_percent + 0.01,1)
    -- end

    -- if data.damage >= 8000 then
    --     TheNet:Announce(math.random() < 0.95 and "泰西欧斯的机体已超量损坏" or "泰西欧斯的机体已XYZ损坏")
    -- end

    
    
    if inst.prefab == "tz_pugalisk_segment" or inst.prefab == "tz_pugalisk_body" then
        if data.redirected ~= inst.host then
            GetElecAttackedIfNoEyeUnbrella(inst,data.attacker)
        end
    elseif inst.prefab == "tz_pugalisk_tail" then
        inst.TailShouldAttackCnt = 3 
        GetElecAttackedIfNoEyeUnbrella(inst,data.attacker)
    elseif inst.prefab == "tz_pugalisk" then        
        GetElecAttackedIfNoEyeUnbrella(inst,data.attacker)
    end
end

local function OnAttacked_Head(inst,data)
    -- print(inst,"OnAttacked_Head !!!")
    OnAttacked_Common(inst,data)
    
    -- Refeash sound attack cd when get huge damage
    if data.damage >= inst.components.health.maxhealth * 0.01 then
        inst.LastSoundAttackTime = GetTime() - 999
    end

    if data.damage >= 5000 then
        inst.CrazyFantabBaldeStartTime = GetTime()
    end

    if not data.redirected and not inst.components.health:IsDead() then
        inst:TryRecoverAfterTakeDamage(data.damage)

        -- Ly modified:When head take damage,for every un-broken body,has 25% to do lightning strike to a player
        local body_not_broken = 4 - inst:GetBrokenBodyCount()
        if (inst.LastAttackedAndLightningTime == nil or GetTime() - inst.LastAttackedAndLightningTime > 1) and math.random() <= body_not_broken * 0.25 then
            local x,y,z = inst:GetPosition():Get()
            local player = FindClosestPlayer(x,y,z,true)
    
            if player then
                DoLightningStrike(player:GetPosition(),TUNING.TZ_PUGALISK_CONFIG.PLAYER_LIGHTNING_DAMAGE,1)
                inst.LastAttackedAndLightningTime = GetTime()
            end
        end
    end
end

local function OnAttacked_Segment_And_Body(inst,data)
    local id = 0
    local damage = data.damage
    local startpt = inst.startpt or inst 

    OnAttacked_Common(inst,data)

    if inst.host and not inst.host.components.health:IsDead() then
        if data.redirected ~= inst.host then
            for k,body in pairs(inst.host.components.tz_pugalisk_multibody.bodies) do
                if body == startpt then
                    id = k
                    break 
                end
            end
        
            if id > 0 then
                -- Protected pugalisk from AOE damage
                if inst.host.LastSegmentOrBodyGetAttackTime == nil or 
                    GetTime() - inst.host.LastSegmentOrBodyGetAttackTime > FRAMES then
                    
                    local id_inv = #(inst.host.components.tz_pugalisk_multibody.bodies) - id + 1
                    local break_cnt = inst.host.components.tz_pugalisk_multibody:HandleBodyTakeDamage(id_inv,damage)
                    if break_cnt > 0 then
                        inst.host.CrazyFantabBaldeStartTime = GetTime()
                    end

                    inst.host.LastSegmentOrBodyGetAttackTime = GetTime()
                end
                
            end
        end
    end
  
    
end


-- local function RetargetTailFn(inst)  
--     return FindEntity(inst, 6, function(guy)
--         return (guy:HasTag("character") or guy:HasTag("animal") or guy:HasTag("monster") and not guy:HasTag("tz_pugalisk") and not guy:HasTag("tz_pugalisk_token")) 
--                and inst.components.combat:CanTarget(guy)
--     end, nil, {"FX", "NOCLICK","INLIMBO"})
-- end

local function RetargetFn(inst)  
    return FindEntity(inst, 20, function(guy)
        return (guy:HasTag("character") or guy:HasTag("animal") or guy:HasTag("monster") and not guy:HasTag("tz_pugalisk") and not guy:HasTag("tz_pugalisk_token")) 
               and inst.components.combat:CanTarget(guy)
    end, nil, {"FX", "NOCLICK","INLIMBO"})

end

local function OnHit(inst, attacker)    
    local host = inst
    if inst.host then
        host = inst.host      
    end    

    if attacker and (not inst.target or inst.target:HasTag("player")) then
        if not host:HasTag("tail") then
            if host.delay_retarget_task then
                host.delay_retarget_task:Cancel()
            end

            host.delay_retarget_task = host:DoTaskInTime(5,function()
                host.target = attacker 
                host.components.combat:SetTarget(attacker)
                host.delay_retarget_task = nil 
            end)
        end
        
    end
    
end

local function SpawnSinkHole(pos,attacker,damage)
    local hole = SpawnAt("antlion_sinkhole",pos)
    hole.persists = false 
    hole.check_task = hole:DoPeriodicTask(1,function()
        local body = FindEntity(hole,0.5,function(v)
            return v.prefab == "tz_pugalisk_body" or v.prefab == "tz_pugalisk_tail" or v.prefab == "tz_pugalisk"
        end,nil,{"INLIMBO"})

        if not body then
            hole:PushEvent("startrepair",{num_stages=1,time=TUNING.TZ_PUGALISK_CONFIG.PIT_FADEOUT_TIME})
            hole.check_task:Cancel()
            hole.check_task = nil 
        end
        
    end)

    if attacker and damage and damage >= 0 then
        for _,v in pairs(TheSim:FindEntities(pos.x,pos.y,pos.z,TUNING.TZ_PUGALISK_CONFIG.PIT_HIT_RANGE,{"_combat","_health"},{"INLIMBO","tz_pugalisk"})) do
            if attacker.components.combat:CanTarget(v) then
                v.components.combat:GetAttacked(attacker,damage)
            end
        end
    end

    local ring = SpawnAt("groundpoundring_fx",pos)
    ring.Transform:SetScale(0.5,0.5,0.5)
    
    for roa = 0,2 * PI,2 * PI / 4 do
        local offset = Vector3(math.cos(roa),0,math.sin(roa)) * 2
        SpawnAt("groundpound_fx",pos + offset)
    end

    hole:DoTaskInTime(0.4,function()
        for roa = 0,2 * PI,2 * PI / 8 do
            local offset = Vector3(math.cos(roa),0,math.sin(roa)) * 4
            SpawnAt("groundpound_fx",pos + offset)
        end
    end)

    -- hole.SoundEmitter:PlaySound("")
    hole.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/groundpound")
end

local function TryBreakShip(inst)
	local boat = inst:GetCurrentPlatform()
	if boat ~= nil then
		-- boat:PushEvent("spawnnewboatleak", { 
        --     pt = inst:GetPosition(), 
        --     leak_size = "med_leak", 
        --     playsoundfx = true 
        -- })
        boat.components.health:Kill()
        boat.sg:GoToState("snapping")
        boat.AnimState:SetTime(2.8)
	end
end



local function AddInvincibleForBodyAndSegementAndTail(inst)
    inst.components.health:SetMinHealth(1)
    inst._RevocerWhenHealthDelta = function(inst)
        if inst.components.health:GetPercent() < 1 then
            inst.components.health:SetPercent(1,true)
        end
    end 

    inst:ListenForEvent("healthdelta",inst._RevocerWhenHealthDelta)

    inst.DoRealKill = function(inst)
        inst.components.health:SetMinHealth(0)
        inst:RemoveEventCallback("healthdelta",inst._RevocerWhenHealthDelta)
        inst.components.health:Kill()
    end
end


local function segmentfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    local s = pu.PUGALISK_SCALE_NORMAL
    inst.Transform:SetScale(s,s,s)
    inst.Transform:SetEightFaced()

    inst.AnimState:SetFinalOffset( -10 )
    
    inst.AnimState:SetBank("giant_snake")
    inst.AnimState:SetBuild("tz_python_test_2")
    inst.AnimState:PlayAnimation("test_segment")

    inst:AddTag("tz_pugalisk")
    inst:AddTag("groundpoundimmune")
    inst:AddTag("noteleport")

    pu.AddAmphibious(inst,false)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(0)
    inst.components.combat.hiteffectsymbol = "test_segments"-- "wormmovefx"
    inst.components.combat:SetOnHit(OnHit)    
    inst.components.combat.redirectdamagefn = CombatRedirectFn
    -- inst.components.combat.externaldamagetakenmultipliers:SetModifier(inst, 0.5, "pugalisk_segment_damagetaken_mod")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(9999)
    inst.components.health.destroytime = 5

    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper.lootdropangle = 360
    inst.components.lootdropper.speed = 3 + (math.random()*3)

    inst.AnimState:Hide("broken01")
    inst.AnimState:Hide("broken02")

    inst:AddComponent("teleportedoverride")
    inst.components.teleportedoverride:SetDestPositionFn(teleport_override_fn)

    inst.persists = false

    inst:ListenForEvent("attacked",OnAttacked_Segment_And_Body)

    AddInvincibleForBodyAndSegementAndTail(inst)

    return inst
end

--======================================================================
local itemji = {
	["item_NaiHan01"] = "【耐寒】学习机",
	["item_NaiHan02"] = "【寒气无效】学习机",
	["item_NaiRe01"] = "【耐暑】学习机",
	["item_NaiRe02"] = "【高温无效】学习机",
	
	["item_z_ljs"] = "【咆哮·斩突破】学习机",
	["item_BeiShuiYiZhan"] = "【背水一战】学习机",
	["item_DaWeiWang"] = "【大胃王】学习机",
	["item_JianZhenRouDian"] = "【减震肉垫】学习机",
	["item_JuShouLieShou"] = "【巨兽猎手】学习机",
	["item_ShiShen"] = "【食神】学习机",
	["item_ShuJiAiHaoZhe"] = "【书籍爱好者】学习机",
	["item_SiRenBaoXianGongSi"] = "【私人保险公司】学习机",
	["item_SuoXiang"] = "【锁箱】学习机",
	["item_TeJiChuShi"] = "【特级厨师】学习机",
	["item_WaErJiLi"] = "【瓦尔基里】学习机",
	["item_XueJuRen"] = "【穴局人】学习机",
	["item_GeDang"] = "【完美格挡】学习机",
	["item_ShengYu"] = "【圣域】学习机",
	["item_rdgz"] = "【弱点感知】学习机",
	["item_FanGun"] = "【翻滚回避】学习机",

	["item_killknife_skill"] = "【影子分身斩】学习机",
	["item_fanta_blade"] = "【幻影剑舞】学习机",
	["item_space_jump"] = "【空间跳跃】学习机",
}


-- c_findnext("tz_pugalisk").components.health:SetInvincible(false) c_findnext("tz_pugalisk").components.health:Kill()
local function segment_deathfn(segment)

    segment.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/tz_pugalisk/explode")

    local pt = segment:GetPosition()
    local gem_list = {
        "redgem","bluegem","yellowgem","orangegem","purplegem","greengem"
    }

    local host = segment.host 
    local start_bodt = segment.startpt

    -- if host:IsAllBodyBroken() then
    if segment.vulnerable then 
        for i = 1,math.random(0,3) do
            if math.random() <= (1 - host.loot_decrease_percent) then
                segment.components.lootdropper:SpawnLootPrefab(gem_list[math.random(1,#gem_list)], pt)
            end
            if math.random() <= (0.15 - host.loot_decrease_percent) then
                segment.components.lootdropper:SpawnLootPrefab("tz_pugalisk_crystal", pt)
            end
        end

        if math.random() <= 0.33 then
            segment.components.lootdropper:SpawnLootPrefab(GetRandomKey(itemji), pt)
        end
    end

    
    -- Spawn Scale Fx
    pu.SpawnHitFx(segment,true)
end
local function bodyfn()

    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.Transform:SetSixFaced()
    
    local s = pu.PUGALISK_SCALE_NORMAL
    inst.Transform:SetScale(s,s,s)
    
    MakeObstaclePhysics(inst, 1)

    

    inst.AnimState:SetBank("giant_snake") 
    inst.AnimState:SetBuild("tz_python_test_2")
    inst.AnimState:PlayAnimation("dirt_static")

    inst.AnimState:Hide("broken01")
    inst.AnimState:Hide("broken02")

    inst.AnimState:SetFinalOffset( 0 )

    inst.name = STRINGS.NAMES.TZ_PUGALISK
    inst.invulnerable = true

    ------------------------------------------

    inst:AddTag("epic")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("tz_pugalisk")
    inst:AddTag("scarytoprey")
    inst:AddTag("largecreature")
    inst:AddTag("groundpoundimmune")
    inst:AddTag("noteleport")

    ------------------

    pu.AddAmphibious(inst,true)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(9999)
    inst.components.health.destroytime = 5

    ----------------

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(200)
    inst.components.combat.playerdamagepercent = 0.75
    inst.components.combat.hiteffectsymbol = "hit_target"
    inst.components.combat:SetOnHit(OnHit)
    inst.components.combat.redirectdamagefn = CombatRedirectFn
    -- inst.components.combat.externaldamagetakenmultipliers:SetModifier(inst, 0.2, "pugalisk_body_damagetaken_mod")
    ------------------------------------------

    inst:AddComponent("lootdropper")

    inst:AddComponent("teleportedoverride")
    inst.components.teleportedoverride:SetDestPositionFn(teleport_override_fn)
    ------------------------------------------

    inst:AddComponent("inspectable")
    inst.components.inspectable.nameoverride = "tz_pugalisk"
    ------------------------------------------

    inst:AddComponent("knownlocations")

    ------------------------------------------



    ------------------------------------------

    -- inst:AddComponent("groundpounder")
    -- inst.components.groundpounder.destroyer = true
    -- inst.components.groundpounder.damageRings = 2
    -- inst.components.groundpounder.destructionRings = 1
    -- inst.components.groundpounder.numRings = 2
    -- inst.components.groundpounder.groundpounddamagemult = 30/TUNING.PUGALISK_DAMAGE
    -- inst.components.groundpounder.groundpoundfx= "groundpound_nosound_fx"

    ------------------------------------------
    -- c_spawn("antlion_sinkhole"):PushEvent("startrepair",{num_stages=1,time=5})
    inst:AddComponent("tz_pugalisk_segmented")
    inst.components.tz_pugalisk_segmented.segment_deathfn = segment_deathfn

    inst:ListenForEvent("bodycomplete", function() 
        if inst.exitpt then
            inst.exitpt.AnimState:SetBank("giant_snake")
            inst.exitpt.AnimState:SetBuild("tz_python_test_2")
            inst.exitpt.AnimState:PlayAnimation("dirt_static")  

            inst.exitpt.enable_water = true

            -- SpawnAt("explode_firecrackers",inst.exitpt)
            local sinkhole_pos = inst.exitpt:GetPosition()
            if not TheWorld.Map:IsOceanAtPoint(sinkhole_pos.x, sinkhole_pos.y, sinkhole_pos.z) then
                SpawnSinkHole(sinkhole_pos,inst.host,TUNING.TZ_PUGALISK_CONFIG.PIT_DAMAGE)
            else 
                SpawnAt("crab_king_waterspout",sinkhole_pos).Transform:SetScale(1.8,1,1)
            end
            TryBreakShip(inst.exitpt)
            

            ShakeAllCameras(CAMERASHAKE.FULL, .2, .02, .25, inst, SHAKE_DIST)

            --TheCamera:Shake("VERTICAL", 0.5, 0.05, 0.1)
            inst.exitpt.Physics:SetActive(true)
            -- inst.exitpt.components.groundpounder:GroundPound()   

            inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/tz_pugalisk/emerge","emerge")
            inst.SoundEmitter:SetParameter( "emerge", "start", math.random() )

            if inst.host then   
                inst.host:PushEvent("bodycomplete",
                    { pos=Vector3(inst.exitpt.Transform:GetWorldPosition()), angle = inst.angle }
                )                            
            end                                     
        end
    end) 

    inst:ListenForEvent("bodyfinished", function() 
        if inst.host then  
            inst.host:PushEvent("bodyfinished",{ body=inst })                                                
        end                      
        inst:Remove()               
    end)



    

    inst:ListenForEvent("attacked",OnAttacked_Segment_And_Body)

    AddInvincibleForBodyAndSegementAndTail(inst)

    inst.persists = false

    inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/tz_pugalisk/movement_LP", "speed")
    inst.SoundEmitter:SetParameter("speed", "intensity", 0)


    ------------------------------------------

    return inst
end

--===========================================================

local function tailfn()

    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.Transform:SetSixFaced()
    
    local s = pu.PUGALISK_SCALE_NORMAL
    inst.Transform:SetScale(s,s,s)
    
    MakeObstaclePhysics(inst, 1)

    inst.AnimState:SetBank("giant_snake")
    inst.AnimState:SetBuild("tz_python_test_2") 
    inst.AnimState:PlayAnimation("tail_idle_loop", true)

    inst.AnimState:Hide("broken01")
    inst.AnimState:Hide("broken02")

    inst.AnimState:SetFinalOffset( 0 )

    inst.name = STRINGS.NAMES.TZ_PUGALISK
    inst.invulnerable = true

    ------------------------------------------

    inst:AddTag("tail")
    inst:AddTag("epic")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("tz_pugalisk")
    inst:AddTag("scarytoprey")
    inst:AddTag("largecreature")
    inst:AddTag("groundpoundimmune")
    inst:AddTag("noteleport")

    ------------------------------------------

    pu.AddAmphibious(inst,true)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(9999)
    inst.components.health.destroytime = 5

    ------------------------------------------  

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(100)
    inst.components.combat.playerdamagepercent = 0.5
    inst.components.combat:SetRange(6)
    inst.components.combat.hiteffectsymbol = "hit_target" -- "wormmovefx"
    -- inst.components.combat:SetAttackPeriod(1.5)
    -- inst.components.combat:SetRetargetFunction(0.5, RetargetTailFn)
    inst.components.combat:SetOnHit(OnHit)
    inst.components.combat.redirectdamagefn = CombatRedirectFn

    ------------------------------------------

    inst:AddComponent("locomotor")

    inst:AddComponent("teleportedoverride")
    inst.components.teleportedoverride:SetDestPositionFn(teleport_override_fn)

    ------------------------------------------

    inst:AddComponent("lootdropper")

    ------------------------------------------

    inst:AddComponent("inspectable")
    inst.components.inspectable.nameoverride = "tz_pugalisk"

    ------------------------------------------

    inst.persists = false

    ------------------------------------------
    inst:SetStateGraph("SGtz_pugalisk_head")

    local brain = require "brains/tz_pugalisk_tailbrain"
    inst:SetBrain(brain)    

    inst:ListenForEvent("attacked",OnAttacked_Common)

    AddInvincibleForBodyAndSegementAndTail(inst)

    return inst
end

--===========================================================

local function CalcSanityAura(inst, observer)
    return -TUNING.SANITYAURA_LARGE
end

local function onhostdeath(inst)
    ShakeAllCameras(CAMERASHAKE.FULL, .3, .03, .25, inst, SHAKE_DIST)
    local mb = inst.components.tz_pugalisk_multibody
    for i,body in ipairs(mb.bodies)do
        body:DoRealKill()
    end

    if mb.tail and mb.tail:IsValid() and not mb.tail.components.health:IsDead() then
        mb.tail:DoRealKill()
    end 

    mb:Kill()
end


local function fn()
    local inst = CreateEntity()
    
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.Transform:SetSixFaced()

    MakeObstaclePhysics(inst, 1)

    local s = pu.PUGALISK_SCALE_NORMAL
    inst.Transform:SetScale(s,s,s)


    -- c_findnext("tz_pugalisk").AnimState:SetBuild("tz_python_test")
    inst.AnimState:SetBank("giant_snake")
    inst.AnimState:SetBuild("tz_python_test_2") --"python"
    inst.AnimState:PushAnimation("head_idle_loop", true)

    inst.AnimState:AddOverrideBuild("tz_python_action_stun")

    inst.AnimState:SetFinalOffset( 0 )

    ------------------------------------------

    inst:AddTag("epic")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("tz_pugalisk")
    inst:AddTag("scarytoprey")
    inst:AddTag("largecreature")
    inst:AddTag("groundpoundimmune")    
    inst:AddTag("head")    
    inst:AddTag("noflinch")
    inst:AddTag("noteleport")

    ------------------------------------------  

    inst:AddComponent("talker")
    inst.components.talker.fontsize = 70
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.colour = Vector3(238 / 255, 69 / 255, 105 / 255)
    inst.components.talker.offset = Vector3(0, -600, 0)
    inst.components.talker.symbol = "fossil_chest"

    pu.AddAmphibious(inst,true)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    -- inst.damage_over_8000 = 0
    -- inst.damage_over_20000 = 0
    inst.loot_decrease_percent = 0
    inst.all_damage_taken_multi = 1 --also used in tz_pugalisk_multibody.lua and tz_pugalisk_segmented.lua
    inst.can_start_damage_increase = false
    

    inst.GetBrokenBodyCount = function(inst)
        local broken_cnt = 0

        -- for _,v in pairs(c_findnext("tz_pugalisk").components.tz_pugalisk_multibody.broken_bodies_id_inv) do print(v) end 
        -- c_findnext("tz_pugalisk_body").components.combat:GetAttacked(ThePlayer,99999999999)
        for _,v in pairs(inst.components.tz_pugalisk_multibody.broken_bodies_id_inv) do
            if v < inst.components.tz_pugalisk_multibody.maxbodies then
                broken_cnt = broken_cnt + 1
            end
            
        end

        return broken_cnt
    end

    inst.IsAllBodyBroken = function(inst)
        local broken_cnt = inst:GetBrokenBodyCount()

        return broken_cnt >= inst.components.tz_pugalisk_multibody.maxbodies - 1
    end

    inst.PickSoundAttackTarget = function(inst,forbidens)
        local target = nil 
        forbidens = forbidens or {}
        for _,player in pairs(AllPlayers) do
            if player and player:IsValid() 
                and inst.components.combat:CanTarget(player) 
                and not inst:IsNear(player,TUNING.TZ_PUGALISK_CONFIG.SOUND_CAST_RANGE_MIN) 
                and inst:IsNear(player,TUNING.TZ_PUGALISK_CONFIG.SOUND_CAST_RANGE_MAX)
                and not table.contains(forbidens,player) then
                
                target = player 
                break 
            end
        end

        -- if target == nil then
        --     target = inst.components.combat.target 
        -- end

        return target
    end

    inst.PickMeteorTargets = function(inst)
        local valid_targets = {}
        for _,v in pairs(AllPlayers) do
            if v and v:IsValid() and inst.components.combat:CanTarget(v) and v:IsNear(inst,TUNING.TZ_PUGALISK_CONFIG.METEOR_TARGET_RANGE) then
                table.insert(valid_targets,v)
            end
        end

        return valid_targets
    end

    inst.CanCastSoundAttack = function(inst)
        local SOUND_ATTACK_CD = inst.components.health:GetPercent() < TUNING.TZ_PUGALISK_CONFIG.SOUND_LOW_HEALTH_PERCENT 
            and TUNING.TZ_PUGALISK_CONFIG.SOUND_CD_LOW_HEALTH 
            or TUNING.TZ_PUGALISK_CONFIG.SOUND_CD

        local target = inst:PickSoundAttackTarget()

        -- SOUND_ATTACK_CD = 1


        return target
            and not IsEntityDeadOrGhost(inst) 
            and not inst.sg:HasStateTag("busy")
            and (inst.LastSoundAttackTime == nil or GetTime() - inst.LastSoundAttackTime >= SOUND_ATTACK_CD)
    end


    inst.CanCastRoar = function(inst)
        local ROAR_CD = TUNING.TZ_PUGALISK_CONFIG.ROAR_CD
        local target = inst.components.combat.target 

        return target
            and inst:IsNear(target,TUNING.TZ_PUGALISK_CONFIG.ROAR_TARGET_RANGE)
            and inst.components.combat:CanTarget(target) 
            and not IsEntityDeadOrGhost(inst) 
            and not inst.sg:HasStateTag("busy")
            and (inst.LastRoarTime == nil or GetTime() - inst.LastRoarTime >= ROAR_CD)
    end

    inst.CanCastMeteor = function(inst)
        local METEOR_CD = TUNING.TZ_PUGALISK_CONFIG.METEOR_CD
        local targets = inst:PickMeteorTargets()

        return #targets > 0
            and not IsEntityDeadOrGhost(inst) 
            and not inst.sg:HasStateTag("busy")
            and (inst.LastMeteorTime == nil or GetTime() - inst.LastMeteorTime >= METEOR_CD)
    end

    inst.CanCastLaser = function(inst)
        local LASER_CD = 10
        local target = inst.components.combat.target 

        LASER_CD = 1

        return target
            and inst:IsNear(target,15)
            and inst.components.combat:CanTarget(target) 
            and not IsEntityDeadOrGhost(inst) 
            and not inst.sg:HasStateTag("busy")
            and (inst.LastLaserTime == nil or GetTime() - inst.LastLaserTime >= LASER_CD)
    end

    inst.TryRecoverAfterTakeDamage = function(inst,damage)
        if (inst.LastRecoverTime == nil or GetTime() - inst.LastRecoverTime >= TUNING.TZ_PUGALISK_CONFIG.RECOVER_AFTER_HUGE_DAMAGE_CD)
            and damage >=  TUNING.TZ_PUGALISK_CONFIG.RECOVER_AFTER_HUGE_DAMAGE_THRESHOLD then
            
            inst.components.health:DoDelta(damage,true)

            inst.components.talker:Say("凡人之躯，休伤吾身")

            inst.LastRecoverTime = GetTime()
        end
    end

    inst.EnableRoar = function(inst,period,update_fn)
        if inst.RoarTask then
            inst.RoarTask:Cancel()
            inst.RoarTask = nil 
        end

        if period and period >= 0 then
            inst.RoarTask = inst:DoPeriodicTask(period,function()
                local fx = SpawnPrefab("pugalisk_roar_fx")
                fx.entity:SetParent(inst.entity)
                fx.entity:AddFollower()
                fx.Follower:FollowSymbol(inst.GUID,"mouth01",0,-100,0)
                ShakeAllCameras(CAMERASHAKE.FULL, .2, .04, .4, inst, SHAKE_DIST)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/lava_arena/trails/taunt")

                if update_fn then
                    update_fn(inst)
                end
            end)
        end
    end

    inst.LaunchMeteor = function(inst,prefabname,pos,data)
        local shadow = SpawnAt("meteorwarning",pos)
        if prefabname == "tz_pugalisk_meteor" then
            local s = 1
            local warntime = 1
            shadow.Transform:SetScale(s,s,s)
            shadow:startfn(warntime, .33, 1)
            shadow:DoTaskInTime(warntime,function()
                SpawnAt(prefabname,pos):DoStrike(data)
                shadow:DoTaskInTime(0.33,shadow.Remove)
            end)
        elseif prefabname == "tz_pugalisk_meteor_huge" then
            -- s should be 1.5,but it's too big
            local s = 1.3
            local warntime = 1.3
            shadow.Transform:SetScale(s,s,s)
            shadow:startfn(warntime, .33, 1)
            shadow:DoTaskInTime(warntime,function()
                SpawnAt(prefabname,pos):DoStrike(data)
                shadow:DoTaskInTime(0.4,shadow.Remove)
            end)
        end
    end

    inst.DoRealKill = function(inst)
        inst.components.health:SetMinHealth(0)
        inst.components.health:SetInvincible(false)
        inst.components.health:Kill()
    end

    inst.EntireRemove = function(inst)
        local mb = inst.components.tz_pugalisk_multibody
        for i,body in ipairs(mb.bodies)do
            body.components.tz_pugalisk_segmented:removeAllSegments()
            if body.exitpt and body.exitpt:IsValid() then
                body.exitpt:Remove()
            end
            body:Remove()
        end

        if mb.tail and mb.tail:IsValid() and not mb.tail.components.health:IsDead() then
            mb.tail:Remove()
        end 

        mb:Kill()
        inst:Remove()
    end

    inst.UpdateAllDamageTaken = function(inst)
        inst.components.combat.externaldamagetakenmultipliers:SetModifier(inst,inst.all_damage_taken_multi, "all_damage_taken_multi")

        local mb = inst.components.tz_pugalisk_multibody
        for i,body in ipairs(mb.bodies)do
            body.components.combat.externaldamagetakenmultipliers:SetModifier(inst,inst.all_damage_taken_multi, "all_damage_taken_multi")

            local segted = body.components.tz_pugalisk_segmented
            for k, seg in ipairs(segted.segments)do
                seg.components.combat.externaldamagetakenmultipliers:SetModifier(inst,inst.all_damage_taken_multi, "all_damage_taken_multi")
            end
        end
    end

    inst.StartDamageIncrease = function(inst)
        inst:DoPeriodicTask(60,function()
            inst.all_damage_taken_multi = math.min(inst.all_damage_taken_multi + 0.5 / 100,0.99)
            inst:UpdateAllDamageTaken()
        end)
    end

    inst.OnSave = function(inst,data)
        -- data.loot_decrease_percent = inst.loot_decrease_percent
        -- data.damage_over_8000 = inst.damage_over_8000
        -- data.damage_over_20000 = inst.damage_over_20000
        data.all_damage_taken_multi = inst.all_damage_taken_multi
        data.can_start_damage_increase = inst.can_start_damage_increase
    end

    inst.OnLoad = function(inst,data)
        if data ~= nil then
            -- if data.loot_decrease_percent ~= nil then
            --     inst.loot_decrease_percent = data.loot_decrease_percent
            -- end
            -- if data.damage_over_8000 ~= nil then
            --     inst.damage_over_8000 = data.damage_over_8000
            -- end
            -- if data.damage_over_20000 ~= nil then
            --     inst.damage_over_20000 = data.damage_over_20000
            -- end
            if data.all_damage_taken_multi ~= nil then
                inst.all_damage_taken_multi = data.all_damage_taken_multi
            end
            if data.can_start_damage_increase ~= nil then
                inst.can_start_damage_increase = data.can_start_damage_increase
            end
        end
    end

    

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura

    ------------------------------------------   

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.TZ_PUGALISK_CONFIG.ATTACK_DAMAGE)
    inst.components.combat.playerdamagepercent = 0.75
    inst.components.combat:SetRange(10)
    inst.components.combat.hiteffectsymbol = "hit_target" -- "wormmovefx"
    inst.components.combat:SetAttackPeriod(3)
    inst.components.combat:SetRetargetFunction(0.5, RetargetFn)
    inst.components.combat:SetOnHit(OnHit)
    inst.components.combat.redirectdamagefn = CombatRedirectFn
    -- inst.components.combat.externaldamagetakenmultipliers:SetModifier(inst, TUNING.TZ_PUGALISK_CONFIG.HEAD_DAMAGE_TAKEN_MULT, "pugalisk_head_damagetaken_mod")
    ------------------------------------------

    inst:AddComponent("lootdropper")  

    inst:AddComponent("inspectable")
    inst.components.inspectable.nameoverride = "tz_pugalisk"
    inst.name = STRINGS.NAMES.TZ_PUGALISK
    
    inst:AddComponent("teleportedoverride")
    inst.components.teleportedoverride:SetDestPositionFn(teleport_override_fn)
    ------------------------------------------

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.TZ_PUGALISK_CONFIG.HEALTH)
    inst.components.health.destroytime = 5
    -- inst.components.health:StartRegen(1, 2)

    ------------------------------------------

    inst:AddComponent("knownlocations")
    
    ------------------------------------------
    
    inst:AddComponent("locomotor")

    ------------------------------------------

    inst:AddComponent("timer")

    ------------------------------------------
    -- Escape when drop target for a long time,while there is no player nearby
    inst:AddComponent("tz_creature_escape")
    inst.components.tz_creature_escape.escape_time = 60 * 40
    inst.components.tz_creature_escape.on_escape_fn = function(inst)
        print(inst,"tz_creature_escape on_escape_fn !")
        inst.components.lootdropper:SpawnLootPrefab("atrium_key",inst:GetPosition())
        inst:EntireRemove()
    end
    ------------------------------------------
    
    inst:AddComponent("tz_pugalisk_multibody")    
    inst.components.tz_pugalisk_multibody:Setup(5,"tz_pugalisk_body")   
    inst.components.tz_pugalisk_multibody.broken_damage_threshold = TUNING.TZ_PUGALISK_CONFIG.BODY_ABSORB_DAMAGE_MAX
    
    ------------------------------------------    

    inst:ListenForEvent("bodycomplete", function(inst, data) 
        local pt = pu.findsafelocation( data.pos , data.angle/DEGREES )
        inst.Transform:SetPosition(pt.x,0,pt.z)
        inst:DoTaskInTime(0.75, function() 
    
            -- inst.components.groundpounder:GroundPound()
            -- SpawnAt("explode_firecrackers",inst)
            local sinkhole_pos = inst:GetPosition()
            if not TheWorld.Map:IsOceanAtPoint(sinkhole_pos.x, sinkhole_pos.y, sinkhole_pos.z) then
                SpawnSinkHole(sinkhole_pos,inst.host,TUNING.TZ_PUGALISK_CONFIG.PIT_DAMAGE)
            else 
                SpawnAt("crab_king_waterspout",sinkhole_pos).Transform:SetScale(1.8,1,1)
            end
            TryBreakShip(inst)

            ShakeAllCameras(CAMERASHAKE.FULL, .3, .03, .25, inst, SHAKE_DIST)
            
            inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/tz_pugalisk/emerge","emerge")
            inst.SoundEmitter:SetParameter( "emerge", "start", math.random() )
            
            pu.DetermineAction(inst)
        end)
    end)     
    
    inst:ListenForEvent("bodyfinished", function(inst, data) 
        inst.components.tz_pugalisk_multibody:RemoveBody(data.body)
    end)

    inst:ListenForEvent("death", function(inst, data)       
        -- print(inst,"Death,Damage over 8000:",inst.damage_over_8000,"Damage over 20000:",inst.damage_over_20000) 
        -- print(inst,"loot_decrease_percent:",inst.loot_decrease_percent)
        onhostdeath(inst)        
    end)
    inst:ListenForEvent("attacked",OnAttacked_Head)

    inst:ListenForEvent("startmove",function(inst)
        inst.components.combat.externaldamagetakenmultipliers:SetModifier(inst, TUNING.TZ_PUGALISK_CONFIG.MOVING_DAMAGE_TAKEN_MULT, "pugalisk_head_damagetaken_mod")
    end)

    inst:ListenForEvent("stopmove",function(inst)
        inst.components.combat.externaldamagetakenmultipliers:SetModifier(inst, TUNING.TZ_PUGALISK_CONFIG.HEAD_DAMAGE_TAKEN_MULT, "pugalisk_head_damagetaken_mod")
    end)

    inst:ListenForEvent("timerdone",function(inst,data)
        if data.name == "can_start_damage_increase" then
            print(inst,"60 minutes passed(timerdone),set can_start_damage_increase to true and StartDamageIncrease() !")
            inst.can_start_damage_increase = true 
            inst:StartDamageIncrease()
        end 
    end)

    inst:DoPeriodicTask(TUNING.TZ_PUGALISK_CONFIG.RANDOM_LIGHTNING_PERIOD,function()
        local roa = math.random() * 2 * PI
        local offset = Vector3(math.cos(roa),0,math.sin(roa)) * GetRandomMinMax(5,TUNING.TZ_PUGALISK_CONFIG.RANDOM_LIGHTNING_RANGE)
        DoLightningStrike(inst:GetPosition() + offset,TUNING.TZ_PUGALISK_CONFIG.RANDOM_LIGHTNING_DAMAGE)
    end)

    inst:DoPeriodicTask(TUNING.TZ_PUGALISK_CONFIG.PLAYER_LIGHTNING_PERIOD,function()
        local player = FindClosestPlayerToInst(inst,TUNING.TZ_PUGALISK_CONFIG.PLAYER_LIGHTNING_RANGE,true)

        if player then
            DoLightningStrike(player:GetPosition(),TUNING.TZ_PUGALISK_CONFIG.PLAYER_LIGHTNING_DAMAGE,1)
        end
        
    end)

    inst:DoPeriodicTask(TUNING.TZ_PUGALISK_CONFIG.CURSE_MARK_PERIOD,function()
        if inst.components.health:IsDead() then
            return 
        end
        
        local x,y,z = inst:GetPosition():Get()
        local range = TUNING.TZ_PUGALISK_CONFIG.CURSE_MARK_RANGE
        local players = {}
        for i, v in ipairs(AllPlayers) do
            if not IsEntityDeadOrGhost(v) 
                and v.entity:IsVisible() 
                and v:GetDistanceSqToPoint(x, y, z) < (range * range)
                and not v.components.debuffable:HasDebuff("tz_pugalisk_cursed_mark_debuff") then

                table.insert(players, v)
            end
        end

        
        players = shuffleArray(players)
        for k,v in pairs(players) do
            if k % 4 == 0 then
                -- Do nothing
            else 
                SpawnPrefab("tz_pugalisk_cursed_mark_light_fx"):AttachPlayer(v)
            end
        end
    end)

    -- inst:DoPeriodicTask(1,function()
    --     local broken_cnt = inst:GetBrokenBodyCount()
    --     local is_dead = inst.components.health:IsDead()
    --     local is_hurt = inst.components.health:IsHurt()
    --     if broken_cnt < inst.components.tz_pugalisk_multibody.maxbodies - 1 and is_hurt and not is_dead then
    --         inst.components.health:DoDelta(inst.components.health.maxhealth,true)
    --     end
    -- end)
    -- inst:ListenForEvent("healthdelta",function()
    --     local is_dead = inst.components.health:IsDead()
    --     local is_hurt = inst.components.health:IsHurt()
    --     if inst:IsAllBodyBroken() and is_hurt and not is_dead then
    --         inst.components.health:DoDelta(inst.components.health.maxhealth,true)
    --     end
    -- end)

    -- Ly modified:head is not invincible
    -- inst:DoTaskInTime(0,function()
    --     inst.components.health:SetInvincible(not inst:IsAllBodyBroken())
    -- end)
    -- inst:ListenForEvent("tz_pugalisk_body_break",function()
    --     inst.components.health:SetInvincible(not inst:IsAllBodyBroken())
    -- end)

    inst:DoTaskInTime(0,function()
        if inst.can_start_damage_increase then
            print(inst,"Already can start damage increase,directly StartDamageIncrease()")
            inst:StartDamageIncrease()
        elseif not inst.components.timer:TimerExists("can_start_damage_increase") then
            print(inst,"New spawned,start timer can_start_damage_increase")
            inst.components.timer:StartTimer("can_start_damage_increase",3600)
        end
    end)


    inst:SetStateGraph("SGtz_pugalisk_head")

    local brain = require "brains/tz_pugalisk_headbrain"
    inst:SetBrain(brain)


    return inst
end



return Prefab( "tz_pugalisk", fn, assets),
Prefab( "tz_pugalisk_body", bodyfn, assets),
Prefab( "tz_pugalisk_tail", tailfn, assets),
Prefab( "tz_pugalisk_segment", segmentfn, assets),
TzEntity.CreateNormalFx({
    prefabname = "tz_python_ring_fx",

    assets = {
        Asset("ANIM","anim/tz_python_fx.zip"),
    },

    bank = "tz_python_fx",
    build = "tz_python_fx",
    anim = "ring",

    clientfn = function(inst)
        inst.Transform:SetSixFaced()
        inst.AnimState:SetLightOverride(1)

        MakeInventoryPhysics(inst)
        RemovePhysicsColliders(inst)

        local s = 2.25
        inst.AnimState:SetScale(s,s,s)
    end,

    serverfn = function(inst)
        inst.hitted_table = {}

        inst.task = inst:DoPeriodicTask(0,function()
            local x,y,z = inst:GetPosition():Get()
            local ents = TheSim:FindEntities(x,y,z,3.4,{"_combat","_health"},{"INLIMBO","tz_pugalisk"})

            local attacker = inst.host and inst.host:IsValid() and inst.host

            if attacker then
                for _,v in pairs(ents) do
                    if attacker.components.combat:CanTarget(v)
                    and not v.components.health:IsInvincible()
                    and (inst.hitted_table[v] == nil or GetTime() - inst.hitted_table[v] >= 1)then
                        v.components.combat:GetAttacked(attacker,TUNING.TZ_PUGALISK_CONFIG.SOUND_DAMAGE)
                        v:PushEvent("knockback", { 
                            knocker = attacker, 
                            radius = GetRandomMinMax(20,25) + v:GetPhysicsRadius(.5),
                            strengthmult = 2
                        })
                        if v:HasTag("player") 
                            and v.components.debuffable
                            and v.components.debuffable:IsEnabled() then
                                
                            v.components.debuffable:AddDebuff("tz_pugalisk_weak_debuff", "tz_pugalisk_weak_debuff")
                        end

                        -- if v.components.gr
                        inst.hitted_table[v] = GetTime()
                    end
                end
            end
            
        end)
    end,
}),
TzEntity.CreateNormalFx({
    prefabname = "snake_scales_fx",

    assets = {
        Asset("ANIM", "anim/snake_scales_fx.zip"),
        Asset("ANIM", "anim/tz_pugalisk_scale_hit_fx.zip"),
    },

    bank = "snake_scales_fx",
    build = "tz_pugalisk_scale_hit_fx",
    anim = "idle",
}),
TzEntity.CreateNormalFx({
    prefabname = "pugalisk_lightning_warning",
    assets = {
        Asset("ANIM", "anim/tz_python_lightning_warn.zip"),
    },

    bank = "tz_python_lightning_warn",
    build = "tz_python_lightning_warn",
    anim = "warn",

    animover_remove = false,
    persists = false,

    clientfn = function(inst)
        -- inst.AnimState:SetFinalOffset(3)
        
        inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
        inst.AnimState:SetLayer(LAYER_BACKGROUND)

        if not TheNet:IsDedicated() then
            inst.rotate_fn = function(inst)
                if TheCamera then
                    local pos = inst:GetPosition() + TheCamera:GetRightVec()
                    inst:ForceFacePoint(pos:Get())
                end
            end

            inst:rotate_fn()
            inst:DoPeriodicTask(0,inst.rotate_fn)
        end

        local s = 4.5
        inst.AnimState:SetScale(s,s,s)
    end,

    serverfn = function(inst)

    end
}),
TzEntity.CreateNormalFx({
    prefabname = "pugalisk_lightning_strike",
    assets = {
        Asset("ANIM", "anim/tz_python_lightning_warn.zip"),
    },

    bank = "tz_python_lightning_warn",
    build = "tz_python_lightning_warn",
    anim = "lightning",

    persists = false,

    clientfn = function(inst)
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetLightOverride(1)

        local s = 2
        inst.AnimState:SetScale(s,s,s)
    end,

    serverfn = function(inst)

    end
}),
TzEntity.CreateNormalFx({
    prefabname = "pugalisk_roar_fx",
    assets = {
        Asset("ANIM", "anim/bearger_ring_fx.zip"),
    },

    bank = "bearger_ring_fx",
    build = "bearger_ring_fx",
    anim = "idle",


    clientfn = function(inst)
        inst.AnimState:SetFinalOffset(3)
        inst.AnimState:SetDeltaTimeMultiplier(1.5)

        local fx_scale = 0.5
        inst.AnimState:SetScale(fx_scale,fx_scale,fx_scale)
    end,

    serverfn = function(inst)

    end
}),
TzEntity.CreateNormalFx({
    prefabname = "pugalisk_lasershoot_warn_fx",
    assets = {
        Asset("ANIM", "anim/tz_python_fx.zip"),
    },

    bank = "tz_python_fx",
    build = "tz_python_fx",
    anim = "light",


    clientfn = function(inst)
        inst.AnimState:SetLightOverride(1)

        inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
        inst.AnimState:SetLayer(LAYER_BACKGROUND)
        -- inst.AnimState:SetDeltaTimeMultiplier(1.5)

        local fx_scale = 2
        inst.AnimState:SetScale(fx_scale,fx_scale,fx_scale)
    end,

    serverfn = function(inst)

    end
}),
TzEntity.CreateNormalFx({
    prefabname = "pugalisk_sound_attack_warn_fx",
    assets = {
        Asset("ANIM", "anim/tz_python_fx.zip"),
    },

    bank = "tz_python_fx",
    build = "tz_python_fx",
    anim = "sound",

    animover_remove = false,


    clientfn = function(inst)
        inst.AnimState:SetLightOverride(1)

        inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
        inst.AnimState:SetLayer(LAYER_BACKGROUND)
        -- inst.AnimState:SetDeltaTimeMultiplier(1.5)

        -- local fx_scale = 0.5
        -- inst.AnimState:SetScale(fx_scale,fx_scale,fx_scale)
    end,

    serverfn = function(inst)
        inst:DoTaskInTime(1.3,ErodeAway)
    end
}),
TzDebuffUtil.CreateTzDebuff({
    prefab = "tz_pugalisk_weak_debuff",

    OnAttached = function(inst,target)
        inst.task = inst:DoPeriodicTask(0,function()
            if target.components.grogginess then
                local add_val = target.components.grogginess.decayrate + 0.00001
                target.components.grogginess:AddGrogginess(add_val)
            end
        end)

        if target.components.combat then
            target.components.combat.externaldamagetakenmultipliers:SetModifier(inst,TUNING.TZ_PUGALISK_CONFIG.SOUND_WEAK_DAMAGE_TAKEN_MULT,inst.prefab)
        end
    end,

    OnDetached = function(inst,target)
        if target.components.combat then
            target.components.combat.externaldamagetakenmultipliers:RemoveModifier(inst,inst.prefab)
        end
    end,

    duration = TUNING.TZ_PUGALISK_CONFIG.SOUND_WEAK_DURATION,

    keepondespawn = false,
})

