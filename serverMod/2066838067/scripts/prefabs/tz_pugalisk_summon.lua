local TzEntity = require("util.tz_entity")

local function PlaceholderFn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    

    inst:AddTag("NOCLICK")


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("timer")

    inst:ListenForEvent("timerdone",function(inst,data)
        if data.name == "summon" then

            SpawnAt("tz_python_summon_fallen",inst):DoLand()
        end
    end)

    return inst
end

return TzEntity.CreateNormalInventoryItem({
    prefabname = "tz_python_summon_rocket",

    assets = {
        Asset("ANIM","anim/tz_python_summon_rocket.zip"),

        Asset("ATLAS", "images/inventoryimages/tz_python_summon_rocket.xml"),
        Asset("IMAGE", "images/inventoryimages/tz_python_summon_rocket.tex"),
    },

    bank = "tz_python_summon_rocket",
    build = "tz_python_summon_rocket",
    anim = "idle",

    clientfn = function(inst)
        
    end,

    serverfn = function(inst)
        inst.launching = false 

        inst:AddComponent("tz_python_summon_rocket")
        inst.components.tz_python_summon_rocket:SetOnLaunch(function()
            if not inst.launching then
                inst.launching = true 
                inst.persists = false 
                inst.AnimState:PlayAnimation("fly")

                local fx = SpawnPrefab("pugalisk_summon_rocket_fire_vfx")
                fx.entity:SetParent(inst.entity)
                fx.entity:AddFollower()
                fx.Follower:FollowSymbol(inst.GUID,"body",0,0,0)

                inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_fuse_LP", "hiss")

                inst:ListenForEvent("animover",function()
                    print("Spawn placeholder")
                    local holder = SpawnAt("tz_python_summon_placeholder",inst)
                    holder.components.timer:StartTimer("summon",TUNING.TZ_PUGALISK_CONFIG.SUMMON_FALLEN_TIME)
                    inst:Remove()
                end)
            end
            
        end)
    end,
}),
Prefab("tz_python_summon_placeholder",PlaceholderFn),
TzEntity.CreateNormalEntity({
    prefabname = "tz_python_summon_fallen",

    bank = "tz_python_summon_fallen",
    build = "tz_python_summon_fallen",
    anim = "idle",

    tags = {"structure"},

    clientfn = function(inst)
        inst.Transform:SetScale(2,2,2)

        MakeObstaclePhysics(inst,1.6)
    end,

    serverfn = function(inst)
        inst.attack_cnt = 0 

        inst:AddComponent("inspectable")

        inst:AddComponent("combat")
        inst.components.combat:SetDefaultDamage(75)

        inst:AddComponent("health")
        inst.components.health:SetMaxHealth(100)
        inst.components.health:SetMinHealth(1)

        inst:AddComponent("groundpounder")
        inst.components.groundpounder.destroyer = true
        inst.components.groundpounder.damageRings = 2
        inst.components.groundpounder.destructionRings = 2
        inst.components.groundpounder.platformPushingRings = 2
        inst.components.groundpounder.numRings = 3

        inst:AddComponent("lootdropper")

        inst.DoLand = function(inst)
            inst.components.health:SetInvincible(true)

            inst.AnimState:PlayAnimation("join")
            inst.AnimState:PushAnimation("idle",true)

            inst:DoTaskInTime(0.64,function()
                inst.components.health:SetInvincible(false)

                inst.components.groundpounder:GroundPound()

                ShakeAllCameras(CAMERASHAKE.FULL, .2, .04, .4, inst, 40)

                TheNet:Announce("和平的愿望已经得到回应。")
            end)
        end

        inst:ListenForEvent("healthdelta",function()
            if inst.components.health:GetPercent() < 1 then
                inst.components.health:SetPercent(1)
            end
        end)

        inst:ListenForEvent("attacked",function()
            inst.attack_cnt = inst.attack_cnt + 1

            if inst.attack_cnt >= TUNING.TZ_PUGALISK_CONFIG.SUMMON_FALLEN_HIT_COUNT then
                local python = SpawnAt("tz_pugalisk",inst)
                python.sg:GoToState("spawn")
                python.components.talker:Say("盖亚，正义已至，束手就擒吧！")

                SpawnAt("collapse_big",inst)
                inst.components.lootdropper:SpawnLootPrefab("tz_pugalisk_crystal")
                inst:Remove()
            end
        end)
    end,
})
