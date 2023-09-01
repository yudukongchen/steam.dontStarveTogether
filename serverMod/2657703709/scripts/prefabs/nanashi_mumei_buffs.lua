
-------------------------------------------------------------------------
---------------------- Attach and dettach functions ---------------------
-------------------------------------------------------------------------

local buff_fx_inteval = 0.7
local debuff_fx_inteval = 2
local offset = 3.5
local scale = 1.5
local fx_scale = 1.0


local function PushColour(inst, r, g, b, a)
    r = r/255
    g = g/255
    b = b/255
    if inst.components.colouradder ~= nil then
        inst.components.colouradder:PushColour("mumei_terror", r, g, b, a)
    else
        inst.AnimState:SetAddColour(r, g, b, a)
    end
end

local function PopColour(inst)
    if inst.components.colouradder ~= nil then
        inst.components.colouradder:PopColour("mumei_terror")
    else
        inst.AnimState:SetAddColour(0, 0, 0, 0)
    end
end

local function nanashi_mumei_terror_debuff_attach(inst, target)
    -- if target.SoundEmitter ~= nil then
    --     target.SoundEmitter:PlaySound("dontstarve/wilson/hit")
    -- end
    if target.components.combat ~= nil 
    and (TheWorld.state.isdusk or TheWorld.state.isnight or TheWorld:HasTag("cave"))
    then
        local atk_debuff_multi = TUNING.NANASHI_MUMEI_TERROR_ATK_DEBUFF_MULTI
        if TheWorld.state.isdusk then
            atk_debuff_multi = 1 + ((1.0 - TUNING.NANASHI_MUMEI_TERROR_ATK_DEBUFF_MULTI) / 2.0)
        end

        target:AddTag("nanashi_mumei_terror_atk_debuff")
        if not inst.terror_fx then
            inst.terror_fx = target:SpawnChild("nanashi_mumei_debuff_fx")
        end
        target.components.combat.externaldamagemultipliers:SetModifier(inst, atk_debuff_multi, "nanashi_mumei_terror_dmg_debuff_mod")
        if target.components.locomotor then
            target.components.locomotor:SetExternalSpeedMultiplier(inst, "nanashi_mumei_terror_speed_debuff_mod", 1 * TUNING.NANASHI_MUMEI_TERROR_MOVESPEED_MULTI)  
        end

        target.SoundEmitter:PlaySound("dontstarve/characters/wendy/small_ghost/joy") 
        PushColour(target,0, 4, 64,0.2)
    end
    
end

local function nanashi_mumei_terror_debuff_detach(inst, target)

    target:RemoveTag("nanashi_mumei_terror_atk_debuff")
    if inst.terror_fx then
        inst.terror_fx:Remove()
    end
    if target.components.combat ~= nil then
        target.components.combat.externaldamagemultipliers:RemoveModifier(inst, "nanashi_mumei_terror_dmg_debuff_mod")
    end
    if target.components.locomotor then
        target.components.locomotor:RemoveExternalSpeedMultiplier(inst, "nanashi_mumei_terror_speed_debuff_mod")
    end
    PopColour(target)
end
-------------------------------------------------------------------------
----------------------- Prefab building functions -----------------------
-------------------------------------------------------------------------

local function OnTimerDone(inst, data)
    if data.name == "buffover" then
        inst.components.debuff:Stop()
    end
end

local function MakeBuff(name, onattachedfn, onextendedfn, ondetachedfn, duration, priority, prefabs) -- prefabs is table of special effect (fx) names
    local function OnAttached(inst, target)
        inst.entity:SetParent(target.entity)
        inst.Transform:SetPosition(0, 0, 0) --in case of loading
        inst:ListenForEvent("death", function()
            inst.components.debuff:Stop()
        end, target)

        target:PushEvent("mumeibuffattached", { buff = "ANNOUNCE_ATTACH_BUFF_"..string.upper(name), priority = priority })
        if onattachedfn ~= nil then
            onattachedfn(inst, target)
        end
    end

    local function OnExtended(inst, target)
        inst.components.timer:StopTimer("buffover")
        inst.components.timer:StartTimer("buffover", duration)

        target:PushEvent("mumeibuffattached", { buff = "ANNOUNCE_ATTACH_BUFF_"..string.upper(name), priority = priority })
        if onextendedfn ~= nil then
            onextendedfn(inst, target)
        end
    end

    local function OnDetached(inst, target)
        if ondetachedfn ~= nil then
            ondetachedfn(inst, target)
        end

        target:PushEvent("mumeibuffdetached", { buff = "ANNOUNCE_DETACH_BUFF_"..string.upper(name), priority = priority })
        inst:Remove()
    end

    local function fn()
        local inst = CreateEntity()

        if not TheWorld.ismastersim then
            --Not meant for client!
            inst:DoTaskInTime(0, inst.Remove)
            return inst
        end

        inst.entity:AddTransform()

        --[[Non-networked entity]]
        --inst.entity:SetCanSleep(false)
        inst.entity:Hide()
        inst.persists = false

        inst:AddTag("CLASSIFIED")

        inst:AddComponent("debuff")
        inst.components.debuff:SetAttachedFn(OnAttached)
        inst.components.debuff:SetDetachedFn(OnDetached)
        inst.components.debuff:SetExtendedFn(OnExtended)
        inst.components.debuff.keepondespawn = true

        inst:AddComponent("timer")
        inst.components.timer:StartTimer("buffover", duration)
        inst:ListenForEvent("timerdone", OnTimerDone)

        return inst
    end

    return Prefab("buff_"..name, fn, nil, prefabs)
end

return MakeBuff("nanashi_mumei_terror_debuff_effect", nanashi_mumei_terror_debuff_attach, nil, nanashi_mumei_terror_debuff_detach, TUNING.NANASHI_MUMEI_TERROR_DEBUFF_DURATION, 1)