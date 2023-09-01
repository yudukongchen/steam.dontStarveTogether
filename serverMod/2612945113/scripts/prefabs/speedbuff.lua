local function makebuff_fn(name, speed, time)
    local prefabname = name.."_"..tostring(speed).."_"..tostring(time)
    local function OnTick(inst, target)
        print("333")
        if target.components.locomotor ~= nil and not target:HasTag("playerghost") then
            print("444", prefabname)
            target.components.locomotor:SetExternalSpeedMultiplier(target, prefabname, 1+speed/100)
        else
            inst.components.debuff:Stop()
        end
    end

    local function OnAttached(inst, target)
        print("OnAttached")
        inst.entity:SetParent(target.entity)
        inst.Transform:SetPosition(0, 0, 0) --in case of loading
        OnTick(inst, target)
        -- inst.task = inst:DoPeriodicTask(TUNING.SWEETTEA_TICK_RATE, OnTick, nil, target)
        inst:ListenForEvent("death", function()
            inst.components.debuff:Stop()
        end, target)
    end

    local function OnTimerDone(inst, data)
        print("OnTimerDone")
        if data.name == "regenover" then
            inst.components.debuff:Stop()
            inst.components.locomotor:SetExternalSpeedMultiplier(inst, prefabname, 1)
        end
    end

    local function OnExtended(inst, target)
        print("OnExtended")
        inst.components.timer:StopTimer("regenover")
        inst.components.timer:StartTimer("regenover", time)
        -- inst.task:Cancel()
        -- inst.task = inst:DoPeriodicTask(TUNING.SWEETTEA_TICK_RATE, OnTick, nil, target)
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
        inst.components.debuff:SetDetachedFn(inst.Remove)
        inst.components.debuff:SetExtendedFn(OnExtended)
        inst.components.debuff.keepondespawn = true

        inst:AddComponent("timer")
        inst.components.timer:StartTimer("regenover", time)
        inst:ListenForEvent("timerdone", OnTimerDone)

        return inst
    end
    return Prefab(prefabname, fn)
end

return
    makebuff_fn("speedbuff", 10, 100),
    makebuff_fn("speedbuff", 25, 100),
    makebuff_fn("speedbuff", 10, 300),
    makebuff_fn("speedbuff", 15, 300),
    makebuff_fn("speedbuff", 100, 100)