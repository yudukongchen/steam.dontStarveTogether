local function TerrorBonusDamageFn(inst)
    local bonus_damage = TUNING.NANASHI_MUMEI_NIGHT_OWL_TERROR_BONUS_ATK
    inst:ListenForEvent("newcombattarget",function (inst)
        if inst.components.combat.target:HasTag("nanashi_mumei_terror_atk_debuff") and inst.components.combat then
            if TheWorld.state.isnight or TheWorld:HasTag("cave") then
                bonus_damage = TUNING.NANASHI_MUMEI_NIGHT_OWL_TERROR_BONUS_ATK
            elseif TheWorld.state.isdusk then
                bonus_damage = (TUNING.NANASHI_MUMEI_NIGHT_OWL_TERROR_BONUS_ATK - 1)/2 + 1
            end
            inst.components.combat.externaldamagemultipliers:SetModifier(inst, bonus_damage, "nanashi_mumei_night_owl_terror_bonus_atk")
        end
    end,inst)
    inst:ListenForEvent("droppedtarget",function (inst)
        if inst.components.combat then
            inst.components.combat.externaldamagemultipliers:RemoveModifier(inst, "nanashi_mumei_night_owl_terror_bonus_atk")
        end
    end,inst)
end

return TerrorBonusDamageFn