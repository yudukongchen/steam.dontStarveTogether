-------------------------------------------------------------------------
---------------------- Attach and dettach functions ---------------------
-------------------------------------------------------------------------

local function mucus_attach(inst, target)
    if target.components.combat ~= nil then
        target.components.combat.externaldamagemultipliers:SetModifier(inst, 1.25)
    end

    if target.components.locomotor ~= nil then
        local debuffkey = inst.prefab
        target.components.locomotor:SetExternalSpeedMultiplier(inst, debuffkey, 1.25)
    end

    if target:HasTag('player') then
        if target.components.workmultiplier == nil then
            target:AddComponent('workmultiplier')
        end
        target.components.workmultiplier:AddMultiplier(ACTIONS.CHOP, 1.25, inst)
        target.components.workmultiplier:AddMultiplier(ACTIONS.MINE, 1.25, inst)
        target.components.workmultiplier:AddMultiplier(ACTIONS.HAMMER, 1.25, inst)
    end

    if target.heartfx == nil then
        target.heartfx = SpawnPrefab('ningen_heartfx')
        target.heartfx.entity:SetParent(target.entity)
    end
end

local function mucus_detach(inst, target)
    if target.components.combat ~= nil then
        target.components.combat.externaldamagemultipliers:RemoveModifier(inst)
    end

    if target.components.locomotor ~= nil then
        target.components.locomotor:RemoveExternalSpeedMultiplier(inst)
    end

    if target.components.workmultiplier ~= nil then
        target.components.workmultiplier:RemoveMultiplier(ACTIONS.CHOP, inst)
        target.components.workmultiplier:RemoveMultiplier(ACTIONS.MINE, inst)
        target.components.workmultiplier:RemoveMultiplier(ACTIONS.HAMMER, inst)
    end

    if target.heartfx ~= nil then
        target.heartfx:Remove()
        target.heartfx = nil
    end
end

-------------------------------------------------------------------------
----------------------- Prefab building functions -----------------------
-------------------------------------------------------------------------

local function OnTimerDone(inst, data)
    if data.name == 'buffover' then
        inst.components.debuff:Stop()
    end
end

local function MakeBuff(name, onattachedfn, onextendedfn, ondetachedfn, duration, priority, prefabs)
    local function OnAttached(inst, target)
        inst.entity:SetParent(target.entity)
        inst.Transform:SetPosition(0, 0, 0) --in case of loading
        inst:ListenForEvent(
            'death',
            function()
                inst.components.debuff:Stop()
            end,
            target
        )

        target:PushEvent('ningenbuffattached', {buff = 'buff_' .. name, priority = priority})
        if onattachedfn ~= nil then
            onattachedfn(inst, target)
        end
    end

    local function OnExtended(inst, target)
        inst.components.timer:StopTimer('buffover')
        inst.components.timer:StartTimer('buffover', duration)

        target:PushEvent('ningenbuffattached', {buff = 'buff_' .. name, priority = priority})
        if onextendedfn ~= nil then
            onextendedfn(inst, target)
        end
    end

    local function OnDetached(inst, target)
        if ondetachedfn ~= nil then
            ondetachedfn(inst, target)
        end

        target:PushEvent('ningenbuffdetached', {buff = 'buff_' .. name, priority = priority})
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

        inst:AddTag('CLASSIFIED')

        inst:AddComponent('debuff')
        inst.components.debuff:SetAttachedFn(OnAttached)
        inst.components.debuff:SetDetachedFn(OnDetached)
        inst.components.debuff:SetExtendedFn(OnExtended)
        inst.components.debuff.keepondespawn = true

        inst:AddComponent('timer')
        inst.components.timer:StartTimer('buffover', duration)
        inst:ListenForEvent('timerdone', OnTimerDone)

        return inst
    end

    return Prefab('buff_' .. name, fn, nil, prefabs)
end

return MakeBuff('ningen_mucus', mucus_attach, nil, mucus_detach, 1.5, 1)
