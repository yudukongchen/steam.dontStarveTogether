setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})
GLOBAL.NL_VEGGIES = {}
-- 添加新植物
AddSimPostInit(function()
    if VEGGIES ~= nil then
        for k, v in pairs(NL_VEGGIES) do
            VEGGIES[k] = v
        end
    end
end)

local function AddMyVeggie(name, hg, san, hp, ptime, chg, csan, chp, cptime, chance)
    NL_VEGGIES[name] = {
		hunger = hg,
		sanity = san,
        health = hp,
        perishtime = ptime,
        float_settings = {"small", 0.2, 0.9},

        cooked_health = chp,
        cooked_hunger = chg,
        cooked_sanity = csan,
        cooked_perishtime = cptime,
        cooked_float_settings = {"small", 0.2, 1},

        seed_weight = chance,
    }
end

AddMyVeggie("nl_cc114514", 12.5, -5, -10, 30*16*114514, 12.5, 0, 5, 30*16*5, 0)
AddMyVeggie("nl_ccguo", 12.5, -5, -10, 30*16*114514, 12.5, 0, 5, 30*16*5, TUNING.SEED_CHANCE_COMMON)


local function Like(a, b, c, d)
    return {spring = a, summer = b, autumn = c, winter = d}
end

local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS

local function AddMorePlant(name, bank, drink, cons, rest, like, weight, fireportect, perishdrop)
    PLANT_DEFS[name] = {
        --贴图与动画(通道来自于官方)

		build ="farm_plant_" .. name,
        bank = bank or ("farm_plant_" .. name),

        --生长时间（官方原时间，原版每个植物都一样，为了契合官方作物，只有直接搬了）
        grow_time = PLANT_DEFS.eggplant.grow_time,
        --需水量
        moisture = {drink_rate = drink,	min_percent = TUNING.FARM_PLANT_DROUGHT_TOLERANCE},
        --喜好季节
        good_seasons = like,
        --需肥类型
        nutrient_consumption = cons,
        --生成的肥料
        nutrient_restoration = rest,
        --不高兴？
        max_killjoys_tolerance = TUNING.FARM_PLANT_KILLJOY_TOLERANCE,
        --怎么可能是随机种子！
        is_randomseed = false,
        --是否防火
        fireproof = fireportect,
        --重量范围
        weight_data	= weight,
        --音效照抄！
        sounds = PLANT_DEFS.pepper.sounds,
        --作物 代码名称
        prefab = "farm_plant_" .. name,
        --产物 代码名称
        product = name,
        --巨型产物 代码名称
        product_oversized = name .. "_oversized",
        --种子 代码名称
        seed = name .. "_seeds",
        --标签
        plant_type_tag = "farm_plant_" .. name,
        --巨型产物腐烂后的收获物
        loot_oversized_rot = perishdrop,
        --家族化所需数量：4
        family_min_count = TUNING.FARM_PLANT_SAME_FAMILY_MIN,
        --家族化检索距离：4
        family_check_dist = TUNING.FARM_PLANT_SAME_FAMILY_RADIUS,
        --状态的net(如果你的植物状态超过了7个阶段 换别的net)
        stage_netvar = PLANT_DEFS.pepper.stage_netvar,
        --界面相关，我得用自己的画面来标注箭头数量
        plantregistrywidget = "widgets/redux/farmplantpage",
        plantregistrysummarywidget = "widgets/redux/farmplantsummarywidget",
        --图鉴里玩家的庆祝动作
        pictureframeanim = PLANT_DEFS.pepper.pictureframeanim,
        --图鉴信息(hidden 表示这个阶段不显示)
        plantregistryinfo = PLANT_DEFS.pepper.plantregistryinfo,

        is_nl_farmplant = true,
    }
end

local S = TUNING.FARM_PLANT_CONSUME_NUTRIENT_LOW
local M = TUNING.FARM_PLANT_CONSUME_NUTRIENT_MED
local L = TUNING.FARM_PLANT_CONSUME_NUTRIENT_HIGH

-- 自定义作物
AddMorePlant("nl_ccguo", "farm_plant_tomato", TUNING.FARM_PLANT_DRINK_HIGH,
        {S, 0, S}, {nil, true, nil}, Like(true, nil, true, nil), { 328.14,455.31,.22},false,
	{})

AddMorePlant("nl_cc114514", "farm_plant_tomato", TUNING.FARM_PLANT_DRINK_HIGH,
    {S, 0, S}, {nil, true, nil}, Like(true, nil, true, nil), { 328.14,455.31,.22},false,
{})
