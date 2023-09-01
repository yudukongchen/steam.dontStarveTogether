function BerryLoverBonus(inst, food)
    local berries = {"berries","berries_cooked","berries_juicy","berries_juicy_cooked","wormlight","wormlight_lesser"}
    for _, value in pairs(berries) do
        if food.prefab == value then
            inst.components.hunger:DoDelta(TUNING.NANASHI_MUMEI_BERRY_BONUS_HUNGER_GAIN)
        end
    end
end

-- * Bush Hat sanity bonus is in nanashi_mumei_postinit

return BerryLoverBonus