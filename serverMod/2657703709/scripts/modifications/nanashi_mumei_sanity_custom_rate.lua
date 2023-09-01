local function CustomRate(inst)
    local LIGHT_SANITY_DRAINS =
    {
        [SANITY_MODE_INSANITY] = {
            -- DAY = TUNING.SANITY_DAY_GAIN,
            -- NIGHT_LIGHT = TUNING.SANITY_NIGHT_LIGHT,
            -- NIGHT_DIM = TUNING.SANITY_NIGHT_MID,
            -- NIGHT_DARK = TUNING.SANITY_NIGHT_DARK,
            DAY = TUNING.SANITY_NIGHT_MID,
            NIGHT_LIGHT = TUNING.SANITY_DAY_GAIN,
            NIGHT_DIM = TUNING.SANITY_DAY_GAIN,
            NIGHT_DARK = TUNING.SANITY_DAY_GAIN,
        },
        [SANITY_MODE_LUNACY] = {
            -- DAY = TUNING.SANITY_LUNACY_DAY_GAIN,
            -- NIGHT_LIGHT = TUNING.SANITY_LUNACY_NIGHT_LIGHT,
            -- NIGHT_DIM = TUNING.SANITY_LUNACY_NIGHT_MID,
            -- NIGHT_DARK = TUNING.SANITY_LUNACY_NIGHT_DARK,
            DAY = TUNING.SANITY_LUNACY_NIGHT_MID,
            NIGHT_LIGHT = TUNING.SANITY_LUNACY_DAY_GAIN,
            NIGHT_DIM = TUNING.SANITY_LUNACY_DAY_GAIN,
            NIGHT_DARK = TUNING.SANITY_LUNACY_DAY_GAIN,
        },
    }
    local light_sanity_drain = LIGHT_SANITY_DRAINS[inst.components.sanity.mode]
    local light_delta = 0
    if TheWorld.state.isday and not TheWorld:HasTag("cave") then
        light_delta = light_sanity_drain.DAY
    else
        local lightval = CanEntitySeeInDark(inst) and .9 or inst.LightWatcher:GetLightValue()
        light_delta =
            (   (lightval > TUNING.SANITY_HIGH_LIGHT and light_sanity_drain.NIGHT_LIGHT) or
                (lightval < TUNING.SANITY_LOW_LIGHT and light_sanity_drain.NIGHT_DARK) or
                light_sanity_drain.NIGHT_DIM
            ) 
            -- * inst.components.sanity.night_drain_mult
    end
    if not TUNING.NANASHI_MUMEI_REVERSE_DAY_NIGHT_SANITY_DRAIN then
        light_delta = 0
    end
    -- killer sanity
    local killerdelta = 0
    if inst._nanashi_mumei_killer:value() then
        killerdelta = 2
    end

    if inst.components.sanity and inst.components.sanity:GetPercent() <= 0.05 
    and (inst.components.sanity.inducedinsanity_sources == nil or TUNING.NANASHI_MUMEI_KILLER_AMULET ) then
        inst._nanashi_mumei_killer:set(true)
    elseif inst.components.sanity and inst.components.sanity:GetPercent() >= 0.3 or inst:HasTag("playerghost") then
        inst._nanashi_mumei_killer:set(false)
    end

    return light_delta + killerdelta
end
return CustomRate