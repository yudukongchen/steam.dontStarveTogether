
local function SetMumeiNightBuff(inst) 
    if TheWorld.state.isnight or TheWorld:HasTag("cave") then
        if inst.components.locomotor then
            inst.components.locomotor:SetExternalSpeedMultiplier(inst, "nanashi_mumei_night_owl_speed_mod", 
                                                                 1.0 + TUNING.NANASHI_MUMEI_NIGHT_OWL_MS_BONUS)
        end
        if inst.components.workmultiplier then
            inst.components.workmultiplier:AddMultiplier(ACTIONS.CHOP, 1.0 + TUNING.NANASHI_MUMEI_NIGHT_OWL_WORK_EFF_BONUS, inst)
            inst.components.workmultiplier:AddMultiplier(ACTIONS.MINE, 1.0 + TUNING.NANASHI_MUMEI_NIGHT_OWL_WORK_EFF_BONUS, inst)
            inst.components.workmultiplier:AddMultiplier(ACTIONS.HAMMER, 1.0 + TUNING.NANASHI_MUMEI_NIGHT_OWL_WORK_EFF_BONUS, inst)
        end
    elseif TheWorld.state.isdusk then
        if inst.components.locomotor then
            inst.components.locomotor:SetExternalSpeedMultiplier(inst, "nanashi_mumei_night_owl_speed_mod", 
                                                                 1.0 + (TUNING.NANASHI_MUMEI_NIGHT_OWL_MS_BONUS / 2.0))
        end
        if inst.components.workmultiplier then
            inst.components.workmultiplier:AddMultiplier(ACTIONS.CHOP, 1.0 + (TUNING.NANASHI_MUMEI_NIGHT_OWL_WORK_EFF_BONUS / 2.0), inst)
            inst.components.workmultiplier:AddMultiplier(ACTIONS.MINE, 1.0 + (TUNING.NANASHI_MUMEI_NIGHT_OWL_WORK_EFF_BONUS / 2.0), inst)
            inst.components.workmultiplier:AddMultiplier(ACTIONS.HAMMER, 1.0 + (TUNING.NANASHI_MUMEI_NIGHT_OWL_WORK_EFF_BONUS / 2.0), inst)
        end
    else -- * Day
        if inst.components.locomotor then
            inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "nanashi_mumei_night_owl_speed_mod")
        end
        if inst.components.workmultiplier then
            inst.components.workmultiplier:RemoveMultiplier(ACTIONS.CHOP, inst)
            inst.components.workmultiplier:RemoveMultiplier(ACTIONS.MINE, inst)
            inst.components.workmultiplier:RemoveMultiplier(ACTIONS.HAMMER, inst)
        end
    end
    
end

local function UpdateMumeiTimeOfDay(inst)
    inst:DoPeriodicTask(1, SetMumeiNightBuff)
end

return UpdateMumeiTimeOfDay