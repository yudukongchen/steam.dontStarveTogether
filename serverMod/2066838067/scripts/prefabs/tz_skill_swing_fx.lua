local TzEntity = require("util.tz_entity")


return TzEntity.CreateNormalFx({
    prefabname = "tz_skill_swing_fx",

    bank = "tz_skill_swing_fx",
    build = "tz_skill_swing_fx",
    anim = "idle",

    clientfn = function(inst)
        inst.Transform:SetFourFaced()
        inst.AnimState:SetScale(2,2,2)
    end,
})