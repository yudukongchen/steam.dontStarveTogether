local GHOSTVISION_COLOURCUBES =
{
    day = "images/colour_cubes/ghost_cc.tex",
    dusk = "images/colour_cubes/ghost_cc.tex",
    night = "images/colour_cubes/ghost_cc.tex",
    full_moon = "images/colour_cubes/ghost_cc.tex",
}

local function SetNightVision(inst)

    if inst._nanashi_mumei_killer:value() then
        inst.components.playervision:ForceNightVision(true)
        inst.components.playervision:SetCustomCCTable(GHOSTVISION_COLOURCUBES)
    elseif not inst._nanashi_mumei_killer:value() then
        inst.components.playervision:ForceNightVision(false)
        inst.components.playervision:SetCustomCCTable(nil)
    end
end

return SetNightVision
