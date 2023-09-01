local function CreateTzDebuff(data)
    local function WrapedOnAttached(inst,target)
        -- print(inst,"OnAttached",target)
        if data.OnAttached then 
            data.OnAttached(inst,target)
        end
        if data.duration then 
            inst.components.timer:StartTimer("regenover", data.duration)
        end 
        target:AddChild(inst)
        inst.Transform:SetPosition(0,0,0)
    end

    local function WrapedOnDetached(inst,target)
        -- print(inst,"OnDetached",target)
        if data.OnDetached then 
            data.OnDetached(inst,target)
        end
        inst:Remove()
    end

    local function WrapedOnExtended(inst,target)
        -- print(inst,"OnExtended",target)
        if data.OnExtended then 
            data.OnExtended(inst,target)
        end
        if inst.components.timer:TimerExists("regenover") then 
            inst.components.timer:StopTimer("regenover")
            inst.components.timer:StartTimer("regenover", data.duration)
        end
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
        inst:AddTag("NOBLOCK")
        inst:AddTag("NOCLICK")

        inst:AddComponent("debuff")
        inst.components.debuff:SetAttachedFn(WrapedOnAttached)
        inst.components.debuff:SetDetachedFn(WrapedOnDetached)
        inst.components.debuff:SetExtendedFn(WrapedOnExtended)
        inst.components.debuff.keepondisabled = data.keepondisabled
        if data.keepondespawn == nil or data.keepondespawn == true then 
            inst.components.debuff.keepondespawn = true
        else
            inst.components.debuff.keepondespawn = false
        end

        inst:AddComponent("timer")
        
        data.OnTimerDone = data.OnTimerDone or function(self,data)
            if data.name == "regenover" then
                self.components.debuff:Stop()
            end
        end 

        inst:ListenForEvent("timerdone", data.OnTimerDone)

        if data.ServerFn then
            data.ServerFn(inst)
        end
        
        return inst
    end

    return Prefab(data.prefab,fn)
end

return {
    CreateTzDebuff = CreateTzDebuff,
}
