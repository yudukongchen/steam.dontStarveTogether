local TzEntity = require("util.tz_entity")
local TzDebuffUtil = require("tz_debuff_util")

-- c_spawn("wilson")
-- SpawnPrefab("tz_pugalisk_cursed_mark_light_fx"):AttachPlayer(ThePlayer)
-- SpawnPrefab("tz_pugalisk_cursed_mark_light_fx"):AttachPlayer(c_select())
-- ThePlayer.components.debuffable:RemoveDebuff("tz_pugalisk_cursed_mark_debuff")


return TzEntity.CreateNormalFx({
    prefabname = "tz_pugalisk_cursed_mark_light_fx",
    assets = {
        Asset("ANIM","anim/tz_pugalisk_cursed_mark.zip"),
    },

    bank = "tz_pugalisk_cursed_mark",
    build = "tz_pugalisk_cursed_mark",
    animover_remove = false,


    clientfn = function(inst)
        inst.AnimState:SetFinalOffset(2)
    end,

    serverfn = function(inst)
        inst.TrySealDelay = function(inst)
            if inst.task then
                inst.task:Cancel()
            end
        
            inst.task = inst:DoTaskInTime(GetRandomMinMax(3,6),function()
                local target = inst.target

                if not target.isfeilong then
                    inst.AnimState:PlayAnimation("light_pst")
                    inst.task = nil 
                else 
                    inst:TrySealDelay()
                end
            end)
        end

        inst.AttachPlayer = function(inst,target)
            inst.target = target
            inst.entity:SetParent(target.entity)

            inst.AnimState:PlayAnimation("light_pre")
            inst.AnimState:PushAnimation("light_loop",true)

            inst:DoTaskInTime(GetRandomMinMax(3,6),function()
                inst.AnimState:PlayAnimation("light_pst")
            end)

            inst:ListenForEvent("death",function()
                inst:Remove()
            end,inst.target)

            inst:ListenForEvent("onremove",function()
                inst:Remove()
            end,inst.target)
        end

        inst:ListenForEvent("animover",function()
            -- print(inst,"animover",inst.AnimState:IsCurrentAnimation("light_pst"),inst.target)
            if inst.AnimState:IsCurrentAnimation("light_pst") and inst.target then
                if inst.target.sg
                    and inst.target.components.health 
                    and not inst.target.components.health:IsInvincible()
                    and not IsEntityDeadOrGhost(inst.target)
                    and not inst.target.sg:HasStateTag("dead")
                    and not inst.target.isfeilong then

                    inst.target.components.debuffable:AddDebuff("tz_pugalisk_cursed_mark_debuff","tz_pugalisk_cursed_mark_debuff")
                end
                
                inst:Remove()
            end
        end)
    end,
}),
TzEntity.CreateNormalEntity({
    prefabname = "tz_pugalisk_cursed_mark_seal_fx",
    assets = {
        Asset("ANIM","anim/tz_pugalisk_cursed_mark.zip"),
    },

    bank = "tz_pugalisk_cursed_mark",
    build = "tz_pugalisk_cursed_mark",

    clientfn = function(inst)
        -- MakeObstaclePhysics(inst,2,7)

        inst.AnimState:PlayAnimation("stand_pre")
        inst.AnimState:PushAnimation("stand_loop",true)

        inst.AnimState:SetFinalOffset(1)
    end,

    serverfn = function(inst)
        inst:AddComponent("combat")

        inst:AddComponent("health")
        inst.components.health:SetMaxHealth(9999)
        inst.components.health:SetMinHealth(9999 - 0.00001)

        inst:ListenForEvent("healthdelta",function()
            if not inst.components.health:IsDead() and inst.components.health:IsHurt() then
                inst.components.health:SetPercent(1,true)
            end
        end)
    end
}),
TzDebuffUtil.CreateTzDebuff({
    prefab = "tz_pugalisk_cursed_mark_debuff",

    OnAttached = function(inst,target)
        target.sg:GoToState("tz_pugalisk_curse_sealed")

        inst.sealfx = target:SpawnChild("tz_pugalisk_cursed_mark_seal_fx")
        inst._on_fx_attacked = function(fx,data)
            local attacker = data.attacker 
            if attacker then
                if attacker:HasTag("epic") then
                    target:DoTaskInTime(3,function()
                        SpawnPrefab("tz_pugalisk_cursed_mark_light_fx"):AttachPlayer(target)
                    end)
                    inst.components.debuff:Stop()
                else 
                    inst.hit_cnt = inst.hit_cnt - 1
                    if inst.hit_cnt <= 0 then
                        inst.components.debuff:Stop()
                    end
                end
                
            end
            target.SoundEmitter:PlaySound("dontstarve/creatures/lava_arena/trails/hide_pre",nil,0.5)
        end
        inst._on_player_attacked = function(player,data)
            local attacker = data.attacker 
            if attacker then
                if attacker:HasTag("epic") then
                    player:DoTaskInTime(3,function()
                        SpawnPrefab("tz_pugalisk_cursed_mark_light_fx"):AttachPlayer(player)
                    end)
                    inst.components.debuff:Stop()
                else 
                    inst.hit_cnt = inst.hit_cnt - 1
                    if inst.hit_cnt <= 0 then
                        inst.components.debuff:Stop()
                    end
                end
            end
            target.SoundEmitter:PlaySound("dontstarve/creatures/lava_arena/trails/hide_pre",nil,0.5)
        end

        inst:ListenForEvent("attacked",inst._on_fx_attacked,inst.sealfx)
        inst:ListenForEvent("attacked",inst._on_player_attacked,target)
    end,

    OnExtended = function(inst,target)
        if target.sg and target.sg.currentstate.name ~= "tz_pugalisk_curse_sealed" then
            target.sg:GoToState("tz_pugalisk_curse_sealed")
        end
    end,

    OnDetached = function(inst,target)
        if target.sg and target.sg.currentstate.name == "tz_pugalisk_curse_sealed" then
            target.sg:GoToState("hit")
        end
        if inst.sealfx and inst.sealfx:IsValid() then
            inst.sealfx:Remove()
        end
    end,

    ServerFn = function(inst)
        inst.hit_cnt = TUNING.TZ_PUGALISK_CONFIG.CURSE_MARK_SG_HIT_BREAK_CNT

        inst.OnSave = function(inst,data)
            data.hit_cnt = inst.hit_cnt
        end

        inst.OnLoad = function(inst,data)
            if data ~= nil then
                if data.hit_cnt ~= nil then
                    inst.hit_cnt = data.hit_cnt
                end
            end
            print(inst,"OnLoad inst.hit_cnt =",inst.hit_cnt)
        end
    end,

    duration = TUNING.TZ_PUGALISK_CONFIG.CURSE_MARK_SG_DURATION,

    keepondespawn = true,
})