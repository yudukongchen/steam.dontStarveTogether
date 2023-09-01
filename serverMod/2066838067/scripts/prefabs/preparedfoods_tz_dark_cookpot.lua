local prefabs =
{
    "spoiled_food",
}

local cooking = require("cooking")
local preparedfoods = require("preparedfoods")
local preparedfoods_warly = require("preparedfoods_warly")
local TzDarkCookpotUtil = require("tz_darkcookpot_util")


local target_foods = {
    "baconeggs",
    "powcake",
    "butterflymuffin",
    "mandrakesoup",
    "flowersalad",
    "hotchili",
    "turkeydinner",
    "bonestew",
    "meatballs",
    "dragonpie",
    "taffy",
    "frogglebunwich",
    "perogies",
    "fruitmedley",
    "icecream",
    "jammypreserves",
    "ratatouille",
    "stuffedeggplant",
    "trailmix",
    "monsterlasagna",
    "guacamole",
    "unagi",
    "kabobs",
    "waffles",
    "fishsticks",
    "pumpkincookie",
    "honeynuggets",
    "honeyham",
    "fishtacos",
    "watermelonicle",

    "bananapop",

    "vegstinger",                 --"蔬菜鸡尾酒"           ->             "猩红鸡尾酒"
    "mashedpotatoes",             --"奶油土豆泥"           ->           "舌尖上的土豆泥"
    "potatotornado",              --"烤面筋"             ->              "异界素鸡"
    "asparagussoup",              --"芦笋汤"             ->              "愿者上钩"
    "ceviche",                    --"酸橘汁腌鱼"           ->               "共生鱼"
    "salsa",                      --"沙拉"              ->              "玛丽苏酱"
    "pepperpopper",               --"辣椒炒肉"            ->            "上头辣椒炒肉"
    "freshfruitcrepes",           --"水果饼"             ->               "毒蝎饼"
    "monstertartare",             --"怪物蛋糕"            ->              "深渊之芯"
    "bonesoup",                   --"队友汤"             ->              "入骨相思"
    "moqueca",                    --"鱼汤"              ->             "合家欢乐汤"
    "frogfishbowl",               --"鲑鱼汤"             ->              "碧蟾送鱼"
    "gazpacho",                   --"冰芦笋汤"            ->              "幽冥冻笋"
    "potatosouffle",              --"土豆酥"             ->               "黄金糕"
    "glowberrymousse",            --"发光慕斯"            ->             "蓝色史莱姆"
    "dragonchilisalad",           --"辣龙椒沙拉"           ->               "火龙酿"
    "nightmarepie",               --"恐怖国王饼"           ->            "撒嘛坂町教诲"
    "voltgoatjelly",              --"伏特果冻"            ->              "增幅电冻"
    "barnaclestuffedfishhead",    --"酿鱼头"             ->             "仰望星空酿"
    "barnaclesushi",              --"藤壶寿司"            ->             "藤壶握手斯"
    "barnaclinguine",             --"藤壶扁面条"           ->             "高山流水面"
    "barnaclepita",               --"藤壶皮塔饼"           ->             "活泼藤壶饼"
    "leafymeatburger",            --"素汉堡"             ->              "高数汉堡"
    "leafymeatsouffle",           --"果冻沙拉"            ->              "眼花沙拉"
    "meatysalad",                 --"蔬菜派"             ->             "聚焦蔬菜羹"
    "leafloaf",                   --"绿叶肉饼"            ->             "另眼相看饼"
}

-- 单独拎出来的testfn覆盖，比如肉丸必须覆盖 因为tags.inedible 噩梦燃料也有
local food_testfn_override = {
    meatballs_darkvision = function(cooker, names, tags) 
        return tags.meat and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 2
    end,
    perogies_darkvision = function(cooker, names, tags) 
        return tags.egg and tags.meat and tags.veggie and tags.veggie >= 0.5 
        and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 2
    end,
    honeyham_darkvision = function(cooker, names, tags)
        return names.honey and tags.meat and tags.meat > 1.5 
        and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 2
    end,
    honeynuggets_darkvision = function(cooker, names, tags)
        return names.honey and tags.meat and tags.meat <= 1.5 
        and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 2
    end,
    bonestew_darkvision = function(cooker, names, tags)
        return tags.meat and tags.meat >= 3 
        and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 2
    end,
    ratatouille_darkvision = function(cooker, names, tags)
        return not tags.meat and tags.veggie and tags.veggie >= 0.5 
        and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 1
    end,
    jammypreserves_darkvision = function( cooker, names, tags )
        return tags.fruit and not tags.meat and not tags.veggie 
        and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 1
    end,

    monsterlasagna_darkvision = function(cooker, names, tags)
        return tags.monster and tags.monster >= 2 
        and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 2
    end,

    flowersalad_darkvision = function(cooker, names, tags)
        return names.cactus_flower and tags.veggie and tags.veggie >= 2 and not tags.meat and not tags.egg and not tags.sweetener and not tags.fruit 
        and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 1
    end,

    icecream_darkvision = function(cooker, names, tags)
        return tags.frozen and tags.dairy and tags.sweetener and not tags.meat and not tags.veggie and not tags.egg 
        and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 1
    end,

    jellybean_darkvision = function(cooker, names, tags)
        return names.royal_jelly and not tags.monster 
        and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 1
    end,

    mashedpotatoes_darkvision = function(cooker, names, tags)
        return ((names.potato and names.potato > 1) or (names.potato_cooked and names.potato_cooked > 1) or (names.potato and names.potato_cooked)) and (names.garlic or names.garlic_cooked) and not tags.meat 
        and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 1
    end,

    asparagussoup_darkvision = function(cooker, names, tags)
        return (names.asparagus or names.asparagus_cooked) and tags.veggie and tags.veggie > 2 and not tags.meat 
        and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 1
    end,

    vegstinger_darkvision = function(cooker, names, tags)
        return (names.asparagus or names.asparagus_cooked or names.tomato or names.tomato_cooked) and tags.veggie and tags.veggie > 2 and tags.frozen and not tags.meat and not tags.egg 
        and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 1
    end,

    ceviche_darkvision = function(cooker, names, tags)
        return tags.fish and tags.fish >= 2 and tags.frozen and not tags.egg
        and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 2
    end,

    salsa_darkvision = function(cooker, names, tags)
        return (names.tomato or names.tomato_cooked) and (names.onion or names.onion_cooked) and not tags.meat and not tags.egg 
        and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 1
    end,

    pepperpopper_darkvision = function(cooker, names, tags)
        return (names.pepper or names.pepper_cooked) and tags.meat and tags.meat <= 1.5 
        and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 1
    end,

    sweettea_darkvision = function(cooker, names, tags)
        return names.forgetmelots and tags.sweetener and tags.frozen and not tags.monster and not tags.veggie and not tags.meat and not tags.fish and not tags.egg and not tags.fat and not tags.dairy 
        and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 1
    end,

    kabobs_darkvision = function(cooker, names, tags)
        return tags.meat and names.twigs and (not tags.monster or tags.monster <= 1) 
        and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 2
    end,

    fishsticks_darkvision = function(cooker, names, tags) 
        return tags.fish and names.twigs 
        and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 2
    end,
}

local pst_foods = {}

for k,v in pairs(target_foods) do 
    local target_table = preparedfoods[v] or preparedfoods_warly[v]
    if not target_table then 
        print("[MakePreparedFood-TzDarkCookpot]:Error,Failed to found "..v)
    else
        -- 该烹饪锅可以制作所有官方食物的“暗影版”（我会画一套贴图，下称“强化料理”），统一配方规则为：
        -- 1）蔬菜类料理，必须有1噩梦燃料；
        -- 2）肉类料理，必须有2噩梦燃料；
        -- 3）完成后的料理拥有对应原本官方料理3倍的保鲜度，额外+15点精神值；
        local pst_name = v.."_darkvision"
        local target_table_copy = deepcopy(target_table)  --深拷贝不影响原表
        target_table_copy.name = pst_name
        target_table_copy.overridebuild = "cook_pot_food_tz_darkvision"
        local old_test = target_table_copy.test
        target_table_copy.test = food_testfn_override[pst_name] or function(cooker, names, tags,...) --但是函数不能深拷贝，正好重新写一个
            -- 强化素菜必须至少1个噩梦燃料
            if target_table_copy.foodtype ~= FOODTYPE.MEAT and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 1 then 
                return old_test(cooker, names, tags,...)
            end

            -- 强化肉菜必须至少2个噩梦燃料
            if target_table_copy.foodtype == FOODTYPE.MEAT and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 2 then 
                return old_test(cooker, names, tags,...)
            end

            return false
        end
        -- print("[MakePreparedFood-TzDarkCookpot] testfns:original and copy and new:",target_table.test,old_test,target_table_copy.test)
        if target_table_copy.perishtime then 
            target_table_copy.perishtime = target_table_copy.perishtime * 3
        end 
        target_table_copy.sanity = (target_table_copy.sanity or 0) + 15
        target_table_copy.priority = (target_table_copy.priority or 0) + 1
        pst_foods[pst_name] = target_table_copy
    end
end

-- 可以被使用普通方法增加食谱的食物写在这里，比如融合料理
local normal_prepared_foods = {
    meatballs_tyrant = {
        test = function(cooker, names, tags) 
            local meatballs_cnt = 0
            for k,v in pairs(names) do 
                if k == "meatballs" or k == "meatballs_darkvision" then 
                    meatballs_cnt = meatballs_cnt + v
                end
            end
            return meatballs_cnt >= 1 
                and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 3
                and tags.inedible and tags.inedible >= 6
        end,
        foodtype = FOODTYPE.MEAT,
        hunger = 100,
        sanity = 10,
        health = 20,
        perishtime = TUNING.TOTAL_DAY_TIME * 25,
        cooktime = 30 / TUNING.BASE_COOK_TIME,  -- cooktime * TUNING.BASE_COOK_TIME * timemult = turth_cooktime
    },

    fuhua_nine_zhou = {
        test = function(cooker, names, tags) 
            local not_meat_cnt = 0
            for k,v in pairs(names) do 
                if k == "red_cap" or k == "blue_cap" or k == "green_cap" 
                or k == "red_cap_cooked" or k == "blue_cap_cooked" or k == "green_cap_cooked" then 
                    return false -- if has 蘑菇 then failed
                end

                if tags.meat then
                    return false
                end

                local recipe = cooking.GetRecipe(cooker,k)
                local foodtype = recipe and recipe.foodtype or nil 
                if foodtype ~= FOODTYPE.MEAT and k ~= "nightmarefuel" and k ~= "nightmarefuel_spirit" then 
                    not_meat_cnt = not_meat_cnt + 1
                end
            end
            return not_meat_cnt >= 7 and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 3
        end,
        foodtype = FOODTYPE.VEGGIE,
        hunger = 75,
        sanity = 75,
        health = 75,
        perishtime = TUNING.TOTAL_DAY_TIME * 25,
        cooktime = 30 / TUNING.BASE_COOK_TIME,
        priority = 15,
        oneatenfn = function(inst, eater)
            if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
                not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                not eater:HasTag("playerghost") then
                eater.components.debuffable:AddDebuff("fuhua_nine_zhou_buff", "fuhua_nine_zhou_buff")
            end
        end,
        condition = {
            name = "fuhua_nine_zhou_buff",
            duration = 480,
            attach = function(inst,target)
                inst._target_unfreeze = function()
                    target:DoTaskInTime(0,function()
                        target.components.freezable:Unfreeze()
                    end)
                end
                inst._on_target_eat = function(player,data)
                    local food = data.food
                    local health = math.max(0,food.components.edible:GetHealth(player)) * 0.75
                    local hunger = math.max(0,food.components.edible:GetHunger(player)) * 0.75
                    local sanity = math.max(0,food.components.edible:GetSanity(player)) * 0.75

                    if player.components.health then
                        player.components.health:DoDelta(health)
                    end

                    if player.components.hunger then
                        player.components.hunger:DoDelta(hunger)
                    end

                    if player.components.sanity then
                        player.components.sanity:DoDelta(sanity)
                    end
                    
                    
                    
                end

                if target.components.locomotor then
                    -- target.components.locomotor:SetExternalSpeedMultiplier(inst,inst.prefab,2.25)
                    target.components.locomotor:SetExternalSpeedMultiplier(inst,inst.prefab,1.67)
                end
                
                if target.components.combat then
                    -- target.components.combat.externaldamagemultipliers:SetModifier(inst,1.75,inst.prefab)
                    target.components.combat.externaldamagemultipliers:SetModifier(inst,1.67,inst.prefab)
                    target.components.combat.externaldamagetakenmultipliers:SetModifier(inst,0.25,inst.prefab)
                end
                
                if target.components.health then
                    target.components.health.externalfiredamagemultipliers:SetModifier(inst,0,inst.prefab)
                end
                
                inst.temperature_set_task = inst:DoPeriodicTask(1,function()
                    if target.components.temperature then
                        local cur_temp = target.components.temperature:GetCurrent()
                        if cur_temp < 5 then 
                            target.components.temperature:DoDelta(1)
                        elseif cur_temp > 37 then 
                            target.components.temperature:DoDelta(-1)
                        end
                    end
                end)

                inst.status_heal_task = inst:DoPeriodicTask(1,function()
                    if target.components.health and target.replica.health then 
                        target.components.health:DoDelta(7.5 / 60,true)
                    end 

                    if target.components.hunger and target.replica.hunger then 
                        target.components.hunger:DoDelta(7.5 / 60,true)
                    end 

                    if target.components.sanity and target.replica.sanity then 
                        target.components.sanity:DoDelta(7.5 / 60,true)
                    end 
                end)

                inst:ListenForEvent("freeze",inst._target_unfreeze,target)
                inst:ListenForEvent("oneat",inst._on_target_eat,target)
            end,
            extend = function(inst,target)
                inst.components.timer:StopTimer("regenover")
                inst.components.timer:StartTimer("regenover", inst.duration)
            end,
            detach = function(inst,target)
                if target.components.locomotor then
                    target.components.locomotor:RemoveExternalSpeedMultiplier(inst,inst.prefab)
                end
                
                if target.components.combat then
                    target.components.combat.externaldamagemultipliers:RemoveModifier(inst,inst.prefab)
                    target.components.combat.externaldamagetakenmultipliers:RemoveModifier(inst,inst.prefab)
                end
                
                if target.components.health then
                    target.components.health.externalfiredamagemultipliers:RemoveModifier(inst,inst.prefab)
                end 
                inst:RemoveEventCallback("freeze",inst._target_unfreeze,target)
                inst:RemoveEventCallback("oneat",inst._on_target_eat,target)
                inst:Remove()
            end,
        },
    },

    nightmarefuel_spirit = {
        test = function(cooker, names, tags) 
            return TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 10
        end,
        foodtype = FOODTYPE.GENERIC,
        hunger = 0,
        sanity = 15,
        health = 0,
        stacksize = 10,
        -- perishtime = TUNING.TOTAL_DAY_TIME * 35,
        cooktime = 480 / TUNING.BASE_COOK_TIME,
        oneatenfn = function(inst, eater)
            if eater:HasTag("taizhen") then 
                eater.components.sanity:DoDelta(15)
            end
        end,

        ignore_darkpot_time_bonus_add = true,
        ignore_darkpot_time_bonus_sub = true,
    },

    sweet_ci_circle = {
        test = function(cooker, names, tags) 
            return tags.fish and names.bee and names.eel and tags.veggie
                and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 2
        end,
        foodtype = FOODTYPE.MEAT,
        hunger = 65,
        sanity = 15,
        health = 80,
        perishtime = TUNING.TOTAL_DAY_TIME * 35,
        cooktime = 30 / TUNING.BASE_COOK_TIME,
    },

    deadly_sweet_heart = {
        test = function(cooker, names, tags) 
            return not tags.meat and tags.sweetener and tags.sweetener >= 2 and names.killerbee
                and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 1
        end,
        foodtype = FOODTYPE.MEAT,
        hunger = 15,
        sanity = 5,
        health = 30,
        perishtime = TUNING.TOTAL_DAY_TIME * 50,
        cooktime = 15 / TUNING.BASE_COOK_TIME,
        oneatenfn = function(inst, eater)
            if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
                not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                not eater:HasTag("playerghost") then
                if math.random() <= 0.25 then 
                    eater.components.debuffable:AddDebuff("deadly_sweet_heart_buff", "deadly_sweet_heart_buff")
                else
                    eater.components.health:DoDelta(-30)
                end
            end
        end,
        condition = {
            name = "deadly_sweet_heart_buff",
            duration = 480,
            attach = function(inst,target)
                if target.components.combat then
                    target.components.combat.externaldamagemultipliers:SetModifier(inst,1.5,inst.prefab)
                end
                
                if target.components.locomotor then
                    target.components.locomotor:SetExternalSpeedMultiplier(inst,inst.prefab,1.33)
                end
                
            end,
            extend = function(inst,target)
                inst.components.timer:StopTimer("regenover")
                inst.components.timer:StartTimer("regenover", inst.duration)
            end,
            detach =  function(inst,target)
                if target.components.locomotor then
                    target.components.locomotor:RemoveExternalSpeedMultiplier(inst,inst.prefab)
                end
                
                if target.components.combat then
                    target.components.combat.externaldamagemultipliers:RemoveModifier(inst,inst.prefab)
                end
                
            end,
        },
    },
    devil_fire_mountain = {
        test = function(cooker, names, tags) 
            return tags.veggie and names.pepper and names.pepper >= 2 and names.tomato 
                and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 1
        end,
        foodtype = FOODTYPE.VEGGIE,
        hunger = 15,
        sanity = 15,
        health = 5,
        perishtime = TUNING.TOTAL_DAY_TIME * 40,
        cooktime = 20 / TUNING.BASE_COOK_TIME,

        -- temperature = TUNING.HOT_FOOD_WARMING_THRESHOLD,
        -- temperatureduration = 480,
        oneatenfn = function(inst, eater)
            if eater:HasTag("player") then 
                eater.components.burnable.burntime = 240
                eater.components.burnable:Ignite(nil, inst)
                eater:DoTaskInTime(1, function() 
                    eater.components.burnable.burntime = TUNING.PLAYER_BURN_TIME
                end )
            end 
        end,
    },

    yan_fish = {
        test = function(cooker, names, tags) 
            return tags.fish and tags.inedible and tags.inedible >= 3
            and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 1
        end,
        foodtype = FOODTYPE.VEGGIE,
        hunger = 17.5,
        sanity = 5,
        health = 30,
        perishtime = TUNING.TOTAL_DAY_TIME * 55,
        cooktime = 15 / TUNING.BASE_COOK_TIME,
    },
    
    blood_beast_zhen = {
        test = function(cooker, names, tags) 
            return names.mosquito and names.honey and names.honey >= 2 and tags.inedible
            and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 2
        end,
        foodtype = FOODTYPE.MEAT,
        hunger = 15,
        sanity = 5,
        health = 55,
        perishtime = TUNING.TOTAL_DAY_TIME * 35,
        cooktime = 30 / TUNING.BASE_COOK_TIME,
    },

    nightmare_tangyuan = {
        test = function(cooker, names, tags) 
            return tags.monster and names.potato and tags.inedible and tags.inedible >= 2
            and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 1
        end,
        foodtype = FOODTYPE.VEGGIE,
        hunger = 20,
        sanity = -10,
        health = -3,
        perishtime = TUNING.TOTAL_DAY_TIME * 30,
        cooktime = 15 / TUNING.BASE_COOK_TIME,
        oneatenfn = function(inst, eater)
            if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
                not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                not eater:HasTag("playerghost") then
                    eater.components.debuffable:AddDebuff("nightmare_tangyuan_buff", "nightmare_tangyuan_buff")
            end
        end,

        condition = {
            name = "nightmare_tangyuan_buff",
            duration = 480,
            attach = function(inst,target)
                target.components.sanity.neg_aura_modifiers:SetModifier(inst,-1,inst.prefab)
                inst.fx = target:SpawnChild("nightmare_tangyuan_fx")
                inst.fx:SetTarget(target)
            end,
            extend = function(inst,target)
                inst.components.timer:StopTimer("regenover")
                inst.components.timer:StartTimer("regenover", inst.duration)
            end,
            detach =  function(inst,target)
                target.components.sanity.neg_aura_modifiers:RemoveModifier(inst,inst.prefab)
                if inst.fx and inst.fx:IsValid() then 
                    inst.fx:RemoveAmplifyFX()
                end
            end,
        },
    },

    kanlu_mountain_fuhuo_festival = {
        test = function(cooker, names, tags) 
            return names.crow and names.crow >= 4 and names.reviver
            and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 2
        end,
        foodtype = FOODTYPE.MEAT,
        hunger = 99,
        sanity = 99,
        health = 99,
        perishtime = TUNING.TOTAL_DAY_TIME * 30,
        cooktime = 50 / TUNING.BASE_COOK_TIME,
        oneatenfn = function(inst, eater)
            local x,y,z = eater:GetPosition():Get()
            for k,v in pairs(TheSim:FindEntities(x,y,z,18,{"playerghost"})) do 
                v:PushEvent("respawnfromghost", { source = inst, user = eater })
                v:DoTaskInTime(1.5,function()
                    v.components.health:SetPercent(1)
                    v.components.sanity:SetPercent(1)
                    v.components.hunger:SetPercent(1)
                end)
            end
        end,
    },

    dinner_in_plate = {
        test = function(cooker, names, tags) 
            local meat_cnt = 0
            for name,cnt in pairs(names) do 
                if table.contains(TzDarkCookpotUtil.creatureTypeA,name) then 
                    meat_cnt = meat_cnt + cnt
                end
            end
            meat_cnt = meat_cnt + (tags.meat or 0)
            return meat_cnt >= 2 
                and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 2
                and tags.veggie and tags.veggie >= 2
        end,
        foodtype = FOODTYPE.MEAT,
        hunger = 0,
        sanity = 15,
        health = 0,
        perishtime = TUNING.TOTAL_DAY_TIME * 30,
        cooktime = 30 / TUNING.BASE_COOK_TIME,  -- cooktime * TUNING.BASE_COOK_TIME * timemult = turth_cooktime
        oneatenfn = function(inst, eater)
            if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
                not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                not eater:HasTag("playerghost") then
                    eater.components.debuffable:AddDebuff("dinner_in_plate_buff", "dinner_in_plate_buff")
            end
        end,
        condition = {
            name = "dinner_in_plate_buff",
            duration = 45,
            attach = function(inst,target)
                inst.task = inst:DoPeriodicTask(3,function()
                    if target.components.hunger then 
                        target.components.hunger:DoDelta(15,true)
                    end
                end)
            end,
            extend = function(inst,target)
                inst.components.timer:StopTimer("regenover")
                inst.components.timer:StartTimer("regenover", inst.duration)
            end,
            detach =  function(inst,target)
                if inst.task then 
                    inst.task:Cancel()
                    inst.task = nil
                end 
            end,
        },
    },

    wetgoop_ghost = {
        test = function(cooker, names, tags) return true end,
        priority = -1.9,
        health=0,
        hunger=0,
        perishtime = TUNING.TOTAL_DAY_TIME * 30,
        sanity = 0,
        cooktime = 5 / TUNING.BASE_COOK_TIME,
        ignore_darkpot_time_bonus_add = true,
        ignore_darkpot_time_bonus_sub = true,
    },

    grandma_star_ice_happy = {
        test = function(cooker, names, tags) 
            return names.honey and tags.frozen and tags.frozen >= 3
            and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 1
        end,
        foodtype = FOODTYPE.GENERIC,
        hunger = 10,
        sanity = 5,
        health = 30,
        perishtime = TUNING.TOTAL_DAY_TIME * 20,
        cooktime = 10 / TUNING.BASE_COOK_TIME,
        tags = {"frozen"},
    },

    smart_fox_wu = {
        test = function(cooker, names, tags) 
            local food_can_eat = 0
            for name,cnt in pairs(names) do 
                if name ~= "nightmarefuel" and name ~= "nightmarefuel_spirit" then 
                    local ingredients = cooking.ingredients[name]
                    if not (ingredients and ingredients.tags.inedible) then 
                        food_can_eat = food_can_eat + 1
                    end 
                end
            end
            return food_can_eat > 0 and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 5
        end,
        foodtype = FOODTYPE.MEAT,
        hunger = 15,
        sanity = 60,
        health = 5,
        perishtime = TUNING.TOTAL_DAY_TIME * 45,
        cooktime = 35 / TUNING.BASE_COOK_TIME,
    },

    shadow_throne = {
        test = function(cooker, names, tags) 
            return TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 4
        end,
        foodtype = FOODTYPE.GENERIC,
        hunger = 100,
        sanity = 0,
        health = 0,
        perishtime = TUNING.TOTAL_DAY_TIME * 40,
        cooktime = 45 / TUNING.BASE_COOK_TIME,
        oneatenfn = function(inst,eater)
            if eater.components.sanity ~= nil and eater.components.hunger ~= nil then
                local sanity_percent = eater.components.sanity:GetPercent()
                local hunger_percent = eater.components.hunger:GetPercent()
                --Use DoDelta so that we don't bypass invincibility
                --and to make sure we get the correct HUD triggers.
                eater.components.sanity:DoDelta(hunger_percent * eater.components.sanity.max - eater.components.sanity.current)
                eater.components.hunger:DoDelta(sanity_percent * eater.components.hunger.max - eater.components.hunger.current)
                if eater.SoundEmitter then 
                    eater.SoundEmitter:PlaySound("dontstarve/cave/nightmare_warning")
                end
                for i=1,5 do 
                    local pos = eater:GetPosition()
                    local name = math.random() <= 0.5 and "nightmarebeak" or "crawlingnightmare"
                    local roa = PI * 2 * math.random()
                    local offset = Vector3(math.cos(roa),0,math.sin(roa)) * math.random(5,17)
                    SpawnAt(name,pos+offset)
                end
            end
        end,
    },

    hungry_party = {
        test = function(cooker, names, tags) 

            return tags.meat and tags.meat >= 4
            and tags.veggie and tags.veggie >= 1
            and tags.inedible and tags.inedible >= 2
             and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 3
        end,
        foodtype = FOODTYPE.MEAT,
        hunger = 300,
        sanity = 25,
        health = 30,
        perishtime = TUNING.TOTAL_DAY_TIME * 20,
        cooktime = 40 / TUNING.BASE_COOK_TIME,
        -- priority = 11,

        oneatenfn = function(inst, eater)
            if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
                not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                not eater:HasTag("playerghost") then
                    eater.components.debuffable:AddDebuff("hungry_party_buff", "hungry_party_buff")
            end
        end,

        condition = {
            name = "hungry_party_buff",
            duration = 960,
            attach = function(inst,target)
                target.components.hunger.burnratemodifiers:SetModifier(inst,0.5,inst.prefab)
            end,
            extend = function(inst,target)
                inst.components.timer:StopTimer("regenover")
                inst.components.timer:StartTimer("regenover", inst.duration)
            end,
            detach =  function(inst,target)
                target.components.hunger.burnratemodifiers:RemoveModifier(inst,inst.prefab)
            end,
        },
    },

    elder_veggie = {
        test = function(cooker, names, tags) 
            return tags.veggie and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 3 
                and tags.inedible and tags.inedible >= 6 and not tags.meat
        end,
        foodtype = FOODTYPE.VEGGIE,
        hunger = 75,
        sanity = 25,
        health = 15,
        perishtime = TUNING.TOTAL_DAY_TIME * 25,
        cooktime = 20 / TUNING.BASE_COOK_TIME,
    },

    fanta_house_on_the_sea = {
        test = function(cooker, names, tags) 
            return tags.meat and tags.meat >= 3 and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 3 
                and tags.inedible and tags.inedible >= 4
        end,
        foodtype = FOODTYPE.MEAT,
        hunger = 150,
        sanity = 25,
        health = 15,
        perishtime = TUNING.TOTAL_DAY_TIME * 25,
        cooktime = 35 / TUNING.BASE_COOK_TIME,
        priority = 6,

    },

    zhuang_yuan_master_cake = {
        test = function(cooker, names, tags) 
            return names.freshfruitcrepes and names.waffles 
                and tags.veggie and tags.veggie >= 2 
                and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 3 
                and tags.inedible and tags.inedible >= 3
        end,
        foodtype = FOODTYPE.VEGGIE,
        hunger = 150,
        sanity = 30,
        health = 100,
        perishtime = TUNING.TOTAL_DAY_TIME * 30,
        cooktime = 50 / TUNING.BASE_COOK_TIME,
        oneatenfn = function(inst, eater)
            if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
                not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                not eater:HasTag("playerghost") then
                    eater.components.debuffable:AddDebuff("zhuang_yuan_master_cake_buff", "zhuang_yuan_master_cake_buff")
            end
        end,    
        -- 食用后大范围内作物生长加速，持续1440秒；
        -- TODO：劳资不会写
        condition = {
            name = "zhuang_yuan_master_cake_buff",
            duration = 1140,
            attach = function(inst,target)
                target.components.hunger.burnratemodifiers:SetModifier(inst,0,inst.prefab)
                inst.task = inst:DoPeriodicTask(0,function()
                    local rate = target.components.sanity and target.components.sanity.rate
                    if rate and rate < 0 then 
                        target.components.sanity:DoDelta(-rate * FRAMES,true)
                    end
                end)
            end,
            extend = function(inst,target)
                inst.components.timer:StopTimer("regenover")
                inst.components.timer:StartTimer("regenover", inst.duration)
            end,
            detach =  function(inst,target)
                target.components.hunger.burnratemodifiers:RemoveModifier(inst,inst.prefab)
                if inst.task then 
                    inst.task:Cancel()
                    inst.task = nil 
                end 
            end,
        },
    },

    deep_sleep_soup = {
        test = function(cooker, names, tags) 
            return tags.meat and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 3 
                and tags.inedible and tags.inedible >= 6
        end,
        foodtype = FOODTYPE.MEAT,
        hunger = 65,
        sanity = 5,
        health = -10,
        perishtime = TUNING.TOTAL_DAY_TIME * 35,
        cooktime = 30 / TUNING.BASE_COOK_TIME,
        priority = 6,
    },

    ghost_holly_dai = {
        test = function(cooker, names, tags) 
            return (names.kelp or names.kelp_cooked or names.kelp_dried) and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 1 
                and tags.frozen and tags.frozen >= 3
        end,
        foodtype = FOODTYPE.VEGGIE,
        hunger = 4,
        sanity = 4,
        health = 4,
        perishtime = TUNING.TOTAL_DAY_TIME * 25,
        cooktime = 10 / TUNING.BASE_COOK_TIME,
        tags = {"frozen"},
        oneatenfn = function(inst,eater)
            if eater.components.inventory ~= nil and
                not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                not eater:HasTag("playerghost") then
                    local old_dropfn = eater.components.inventory.DropEverything
                    eater.components.inventory.DropEverything = function() end 
                    eater.components.health:SetPercent(0,true,inst.prefab)
                    eater:DoTaskInTime(0,function()
                        eater.components.inventory.DropEverything = old_dropfn
                    end)
                    -- eater.components.inventory.DropEverything = old_dropfn
                    if eater.components.resurrect_ticker then 
                        eater.components.resurrect_ticker:Resurrect(60)
                    end
            end
        end,
        -- condition = {
        --     name = "ghost_holly_dai_buff",
        --     duration = 60,
        --     attach = function(inst,target)
        --         inst._revive_fn = function() inst.components.debuff:Stop()  end
        --         inst:ListenForEvent("respawnfromghost",inst._revive_fn,target)
        --     end,
        --     extend = function(inst,target)
        --         inst.components.timer:StopTimer("regenover")
        --         inst.components.timer:StartTimer("regenover", inst.duration)
        --     end,
        --     detach =  function(inst,target)
        --         inst:RemoveEventCallback("respawnfromghost",inst._revive_fn,target)
        --         target:PushEvent("respawnfromghost")
        --     end,
        -- },
    },

    dragon_fenix_pan = {
        test = function(cooker, names, tags)
            local birds = 0
            for name,cnt in pairs(names) do 
                if table.contains(TzDarkCookpotUtil.creatureTypeBird,name) then 
                    birds = birds + cnt 
                end
            end 

            local type_a_num = 0
            for name,cnt in pairs(names) do 
                if table.contains(TzDarkCookpotUtil.creatureTypeA,name) then 
                    type_a_num = type_a_num + cnt 
                end
            end 

            return birds >= 2 and 
            (names.pepper or names.pepper_cooked) and 
            TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 2 and 
            (type_a_num + (tags.meat or 0)) >= 1
        end,
        foodtype = FOODTYPE.MEAT,
        hunger = 75,
        sanity = 5,
        health = 25,
        perishtime = TUNING.TOTAL_DAY_TIME * 45,
        cooktime = 50 / TUNING.BASE_COOK_TIME,
        oneatenfn = function(inst,eater)
            if eater.components.moisture then 
                if eater.components.moisture:GetMoisturePercent() > 0 then 
                    eater.components.moisture:SetPercent(0)
                else
                    eater.components.moisture:DoDelta(100)
                end
            end
        end,
    },

    wanshen_night = {
        test = function(cooker, names, tags) 
            local spore_num = 0
            for name,cnt in pairs(names) do 
                if table.contains(TzDarkCookpotUtil.creatureTypeSpore,name) then 
                    spore_num = spore_num + cnt
                end
            end
            return spore_num >= 3 and (names.pumpkin or names.pumpkin_cooked) and TzDarkCookpotUtil.GetNightmarefuelCnt(names) >= 1 
        end,
        foodtype = FOODTYPE.VEGGIE,
        hunger = 25,
        sanity = 15,
        health = 5,
        perishtime = TUNING.TOTAL_DAY_TIME * 20,
        cooktime = 10 / TUNING.BASE_COOK_TIME,
        clientfn = function(inst)
            inst.entity:AddLight()

            inst.Light:SetFalloff(0.5)
            inst.Light:SetIntensity(0.8)
            inst.Light:SetRadius(8)
            inst.Light:SetColour(200/255, 100/255, 170/255)
            inst.Light:Enable(false)

            inst._light_enabled = net_bool(inst.GUID,"inst._light_enabled","light_enabled_dirty")

            if not TheNet:IsDedicated() then 
                inst:ListenForEvent("light_enabled_dirty",function()
                    inst.Light:Enable(inst._light_enabled:value())
                end)
            end

            inst.AnimState:SetHaunted(true)
        end,
        serverfn = function(inst)
            inst.components.inventoryitem:SetOnDroppedFn(function()
                inst.Light:Enable(true)
                inst._light_enabled:set(true)
            end)
            inst.components.inventoryitem:SetOnPutInInventoryFn(function()
                inst.Light:Enable(false)
                inst._light_enabled:set(false)
            end)
            
        end,
    },
}
for k, v in pairs(normal_prepared_foods) do
    v.name = k
    v.weight = v.weight or 1
    v.priority = v.priority or 5
    v.overridebuild = "cook_pot_food_tz_darkvision"
    -- v.cookbook_category = "cookpot"
    -- v.stacksize = 1,
end

local function MakePreparedFood(data)
	local foodassets = 
	{
		Asset("ANIM", "anim/cook_pot_food.zip"),
		-- Asset("INV_IMAGE", data.name),
        Asset("ATLAS", "images/inventoryimages/"..data.name..".xml"), 
	}

    local desc_ui_path = "images/tzui/darkvision_food_desc/"..data.name..".xml"
    local has_path = softresolvefilepath(desc_ui_path) ~= nil 
    if has_path then 
        table.insert(foodassets, Asset("ATLAS", desc_ui_path))
    else
        print("[MakePreparedFood-Darkvision]Warning,could not find "..desc_ui_path)
    end

	if data.overridebuild then
        table.insert(foodassets, Asset("ANIM", "anim/"..data.overridebuild..".zip"))
	end

	local spicename = data.spice ~= nil and string.lower(data.spice) or nil
    if spicename ~= nil then
        table.insert(foodassets, Asset("ANIM", "anim/spices.zip"))
        table.insert(foodassets, Asset("ANIM", "anim/plate_food.zip"))
        table.insert(foodassets, Asset("INV_IMAGE", spicename.."_over"))
    end

    local foodprefabs = prefabs
    if data.prefabs ~= nil then
        foodprefabs = shallowcopy(prefabs)
        for i, v in ipairs(data.prefabs) do
            if not table.contains(foodprefabs, v) then
                table.insert(foodprefabs, v)
            end
        end
    end

    local function DisplayNameFn(inst)
        return subfmt(STRINGS.NAMES[data.spice.."_FOOD"], { food = STRINGS.NAMES[string.upper(data.basename)] })
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

		local food_symbol_build = nil
        if spicename ~= nil then
            inst.AnimState:SetBuild("plate_food")
            inst.AnimState:SetBank("plate_food")
            inst.AnimState:OverrideSymbol("swap_garnish", "spices", spicename)

            inst:AddTag("spicedfood")

            inst.inv_image_bg = { image = (data.basename or data.name)..".tex" }
            inst.inv_image_bg.atlas = GetInventoryItemAtlas(inst.inv_image_bg.image)

			food_symbol_build = data.overridebuild or "cook_pot_food"
        else
			inst.AnimState:SetBuild(data.overridebuild or "cook_pot_food")
			inst.AnimState:SetBank("cook_pot_food")
        end

        inst.AnimState:PlayAnimation("idle")
        inst.AnimState:OverrideSymbol("swap_food", data.overridebuild or "cook_pot_food", data.basename or data.name)

        inst:AddTag("preparedfood")
        if data.tags ~= nil then
            for i,v in pairs(data.tags) do
                inst:AddTag(v)
            end
        end

        if data.basename ~= nil then
            inst:SetPrefabNameOverride(data.basename)
            if data.spice ~= nil then
                inst.displaynamefn = DisplayNameFn
            end
        end

        if data.floater ~= nil then
            MakeInventoryFloatable(inst, data.floater[1], data.floater[2], data.floater[3])
        else
            MakeInventoryFloatable(inst)
        end

        if data.clientfn then 
            data.clientfn(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

		inst.food_symbol_build = food_symbol_build or data.overridebuild

        inst:AddComponent("edible")
        inst.components.edible.healthvalue = data.health
        inst.components.edible.hungervalue = data.hunger
        inst.components.edible.foodtype = data.foodtype or FOODTYPE.GENERIC
        inst.components.edible.secondaryfoodtype = data.secondaryfoodtype or nil
        inst.components.edible.sanityvalue = data.sanity or 0
        inst.components.edible.temperaturedelta = data.temperature or 0
        inst.components.edible.temperatureduration = data.temperatureduration or 0
        inst.components.edible.nochill = data.nochill or nil
        inst.components.edible.spice = data.spice
        inst.components.edible:SetOnEatenFn(data.oneatenfn)

        inst:AddComponent("inspectable")
        inst.wet_prefix = data.wet_prefix

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = "images/inventoryimages/"..data.name..".xml"  

        if spicename ~= nil then
            inst.components.inventoryitem:ChangeImageName(spicename.."_over")
        elseif data.basename ~= nil then
            inst.components.inventoryitem:ChangeImageName(data.basename)
        end

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        if data.perishtime ~= nil and data.perishtime > 0 then
            inst:AddComponent("perishable")
            inst.components.perishable:SetPerishTime(data.perishtime)
            inst.components.perishable:StartPerishing()
            inst.components.perishable.onperishreplacement = "spoiled_food"
        end

        MakeSmallBurnable(inst)
        MakeSmallPropagator(inst)
        MakeHauntableLaunchAndPerish(inst)
        ---------------------

        inst:AddComponent("bait")

        ------------------------------------------------
        inst:AddComponent("tradable")

        if data.serverfn then 
            data.serverfn(inst)
        end

        ------------------------------------------------

        return inst
    end

    return Prefab(data.name, fn, foodassets, foodprefabs)
end

local prefs = {}

for k,v in pairs(pst_foods) do 
    v.cookbook_atlas = "images/inventoryimages/"..v.name..".xml"
    table.insert(prefs, MakePreparedFood(v))
    AddCookerRecipe("tz_dark_cookpot", v,cooking.IsModCookerFood(k)) 
end

for k,v in pairs(normal_prepared_foods) do 
    v.cookbook_atlas = "images/inventoryimages/"..v.name..".xml"
    v.tz_fused_food = true
    table.insert(prefs, MakePreparedFood(v))
    AddCookerRecipe("tz_dark_cookpot", v,cooking.IsModCookerFood(k)) 
    

    local condition = v.condition
    if condition then 

        local old_condition_attach = condition.attach or function(me,other) end
        local old_condition_detach = condition.detach or function(me,other) end

        condition.attach = function(me,other)
            old_condition_attach(me,other)
            other:AddChild(me)
        end
        condition.detach = function(me,other)
            old_condition_detach(me,other)
            me:Remove()
        end
        local function entity_fn()
            local inst = CreateEntity()
            inst.entity:AddTransform()
            inst.entity:AddNetwork()

            inst:AddTag("CLASSIFIED")
            inst:AddTag("NOCLICK")
            inst:AddTag("NOBLOCK")

            inst.duration = condition.duration

            if condition.clientfn then 
                condition.clientfn(inst)
            end


            inst.entity:SetPristine()
            if not TheWorld.ismastersim then
                return inst
            end

            inst.persists = false

            inst:AddComponent("debuff")
            inst.components.debuff:SetAttachedFn(condition.attach)
            inst.components.debuff:SetDetachedFn(condition.detach)
            inst.components.debuff:SetExtendedFn(condition.extend)
            inst.components.debuff.keepondespawn = true

            inst:AddComponent("timer")
            inst.components.timer:StartTimer("buffover", condition.duration)
            inst:ListenForEvent("timerdone", function(inst, data)
                if data.name == "buffover" then
                    inst.components.debuff:Stop()
                end 
            end)

            inst:Hide()

            if condition.serverfn then 
                condition.serverfn(inst)
            end

            return inst
        end
        table.insert(prefs, Prefab(condition.name,entity_fn))
    end
end

STRINGS.NAMES.BACONEGGS_DARKVISION = "恐惧双拼"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BACONEGGS_DARKVISION = "这是恐惧双拼！"

STRINGS.NAMES.POWCAKE_DARKVISION = "巫毒卷"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.POWCAKE_DARKVISION = "这是巫毒卷！"

STRINGS.NAMES.BUTTERFLYMUFFIN_DARKVISION = "玛莉亚"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BUTTERFLYMUFFIN_DARKVISION = "这是玛莉亚！"

STRINGS.NAMES.MANDRAKESOUP_DARKVISION = "神奇魔力粥"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MANDRAKESOUP_DARKVISION = "这是神奇魔力粥！"

STRINGS.NAMES.FLOWERSALAD_DARKVISION = "不详利爪"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FLOWERSALAD_DARKVISION = "这是不详利爪！"

STRINGS.NAMES.HOTCHILI_DARKVISION = "锁骨炖肉"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HOTCHILI_DARKVISION = "这是锁骨炖肉！"

STRINGS.NAMES.TURKEYDINNER_DARKVISION = "挚友盆骨大餐"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TURKEYDINNER_DARKVISION = "这是挚友盆骨大餐！"

STRINGS.NAMES.BONESTEW_DARKVISION = "梦魇汤"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BONESTEW_DARKVISION = "这是梦魇汤！"

STRINGS.NAMES.MEATBALLS_DARKVISION = "邪恶肉丸"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MEATBALLS_DARKVISION = "这是邪恶肉丸！"

STRINGS.NAMES.DRAGONPIE_DARKVISION = "跳肉派"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DRAGONPIE_DARKVISION = "这是跳肉派！"

STRINGS.NAMES.TAFFY_DARKVISION = "失心糖"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TAFFY_DARKVISION = "这是失心糖！"

STRINGS.NAMES.FROGGLEBUNWICH_DARKVISION = "暴食汉堡"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FROGGLEBUNWICH_DARKVISION = "这是暴食汉堡！"

STRINGS.NAMES.PEROGIES_DARKVISION = "恶灵叉烧包"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PEROGIES_DARKVISION = "这是恶灵叉烧包！"

STRINGS.NAMES.FRUITMEDLEY_DARKVISION = "诚惶杯"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FRUITMEDLEY_DARKVISION = "这是诚惶杯！"

STRINGS.NAMES.ICECREAM_DARKVISION = "欢乐冰淇淋"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ICECREAM_DARKVISION = "这是欢乐冰淇淋！"

STRINGS.NAMES.JAMMYPRESERVES_DARKVISION = "眼球草子酱"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.JAMMYPRESERVES_DARKVISION = "这是眼球草子酱！"

STRINGS.NAMES.RATATOUILLE_DARKVISION = "凉拌海蜷草"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.RATATOUILLE_DARKVISION = "这是凉拌海蜷草！"

STRINGS.NAMES.STUFFEDEGGPLANT_DARKVISION = "肉酱茄子"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.STUFFEDEGGPLANT_DARKVISION = "这是肉酱茄子！"

STRINGS.NAMES.TRAILMIX_DARKVISION = "装着美梦的袋子"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TRAILMIX_DARKVISION = "这是装着美梦的袋子！"

STRINGS.NAMES.MONSTERLASAGNA_DARKVISION = "深渊多叠"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MONSTERLASAGNA_DARKVISION = "这是深渊多叠！"

STRINGS.NAMES.GUACAMOLE_DARKVISION = "恐吓肉汤"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GUACAMOLE_DARKVISION = "这是恐吓肉汤！"

STRINGS.NAMES.UNAGI_DARKVISION = "蘸血寿司"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.UNAGI_DARKVISION = "这是蘸血寿司！"

STRINGS.NAMES.KABOBS_DARKVISION = "骨肉相连"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.KABOBS_DARKVISION = "这是骨肉相连！"

STRINGS.NAMES.WAFFLES_DARKVISION = "幽魂烤饼"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.WAFFLES_DARKVISION = "这是幽魂烤饼！"

STRINGS.NAMES.FISHSTICKS_DARKVISION = "灵魂酥肉卷"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FISHSTICKS_DARKVISION = "这是灵魂酥肉卷！"

STRINGS.NAMES.PUMPKINCOOKIE_DARKVISION = "噩梦饼"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PUMPKINCOOKIE_DARKVISION = "这是噩梦饼！"

STRINGS.NAMES.HONEYNUGGETS_DARKVISION = "心肝宝贝"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HONEYNUGGETS_DARKVISION = "这是心肝宝贝！"

STRINGS.NAMES.HONEYHAM_DARKVISION = "鲜血蹄髈"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HONEYHAM_DARKVISION = "这是鲜血蹄髈！"

STRINGS.NAMES.FISHTACOS_DARKVISION = "兄弟同生共死"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FISHTACOS_DARKVISION = "这是兄弟同生共死！"

STRINGS.NAMES.WATERMELONICLE_DARKVISION = "冷冻幼年灵魂"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.WATERMELONICLE_DARKVISION = "这是冷冻幼年灵魂！"

STRINGS.NAMES.BANANAPOP_DARKVISION = "死斗香蕉"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BANANAPOP_DARKVISION = "这是死斗香蕉！"

-----------------------------------------------

STRINGS.NAMES.VEGSTINGER_DARKVISION = "猩红鸡尾酒"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.VEGSTINGER_DARKVISION = "这是猩红鸡尾酒！"
        
STRINGS.NAMES.MASHEDPOTATOES_DARKVISION = "舌尖上的土豆泥"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MASHEDPOTATOES_DARKVISION = "这是舌尖上的土豆泥！"
        
STRINGS.NAMES.POTATOTORNADO_DARKVISION = "异界素鸡"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.POTATOTORNADO_DARKVISION = "这是异界素鸡！"
        
STRINGS.NAMES.ASPARAGUSSOUP_DARKVISION = "愿者上钩"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ASPARAGUSSOUP_DARKVISION = "这是愿者上钩！"
        
STRINGS.NAMES.CEVICHE_DARKVISION = "共生鱼"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CEVICHE_DARKVISION = "这是共生鱼！"
        
STRINGS.NAMES.SALSA_DARKVISION = "玛丽苏酱"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SALSA_DARKVISION = "这是玛丽苏酱！"
        
STRINGS.NAMES.PEPPERPOPPER_DARKVISION = "上头辣椒炒肉"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PEPPERPOPPER_DARKVISION = "这是上头辣椒炒肉！"
        
STRINGS.NAMES.FRESHFRUITCREPES_DARKVISION = "毒蝎饼"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FRESHFRUITCREPES_DARKVISION = "这是毒蝎饼！"
        
STRINGS.NAMES.MONSTERTARTARE_DARKVISION = "深渊之芯"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MONSTERTARTARE_DARKVISION = "这是深渊之芯！"
        
STRINGS.NAMES.BONESOUP_DARKVISION = "入骨相思"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BONESOUP_DARKVISION = "这是入骨相思！"
        
STRINGS.NAMES.MOQUECA_DARKVISION = "合家欢乐汤"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MOQUECA_DARKVISION = "这是合家欢乐汤！"
        
STRINGS.NAMES.FROGFISHBOWL_DARKVISION = "碧蟾送鱼"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FROGFISHBOWL_DARKVISION = "这是碧蟾送鱼！"
        
STRINGS.NAMES.GAZPACHO_DARKVISION = "幽冥冻笋"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GAZPACHO_DARKVISION = "这是幽冥冻笋！"
        
STRINGS.NAMES.POTATOSOUFFLE_DARKVISION = "黄金糕"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.POTATOSOUFFLE_DARKVISION = "这是黄金糕！"
        
STRINGS.NAMES.GLOWBERRYMOUSSE_DARKVISION = "蓝色史莱姆"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GLOWBERRYMOUSSE_DARKVISION = "这是蓝色史莱姆！"
        
STRINGS.NAMES.DRAGONCHILISALAD_DARKVISION = "火龙酿"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DRAGONCHILISALAD_DARKVISION = "这是火龙酿！"
        
STRINGS.NAMES.NIGHTMAREPIE_DARKVISION = "撒嘛坂町教诲"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.NIGHTMAREPIE_DARKVISION = "这是撒嘛坂町教诲！"
        
STRINGS.NAMES.VOLTGOATJELLY_DARKVISION = "增幅电冻"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.VOLTGOATJELLY_DARKVISION = "这是增幅电冻！"
        
STRINGS.NAMES.BARNACLESTUFFEDFISHHEAD_DARKVISION = "仰望星空酿"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BARNACLESTUFFEDFISHHEAD_DARKVISION = "这是仰望星空酿！"
        
STRINGS.NAMES.BARNACLESUSHI_DARKVISION = "藤壶握手斯"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BARNACLESUSHI_DARKVISION = "这是藤壶握手斯！"
        
STRINGS.NAMES.BARNACLINGUINE_DARKVISION = "高山流水面"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BARNACLINGUINE_DARKVISION = "这是高山流水面！"
        
STRINGS.NAMES.BARNACLEPITA_DARKVISION = "活泼藤壶饼"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BARNACLEPITA_DARKVISION = "这是活泼藤壶饼！"
        
STRINGS.NAMES.LEAFYMEATBURGER_DARKVISION = "高数汉堡"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LEAFYMEATBURGER_DARKVISION = "这是高数汉堡！"
        
STRINGS.NAMES.LEAFYMEATSOUFFLE_DARKVISION = "眼花沙拉"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LEAFYMEATSOUFFLE_DARKVISION = "这是眼花沙拉！"
        
STRINGS.NAMES.MEATYSALAD_DARKVISION = "聚焦蔬菜羹"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MEATYSALAD_DARKVISION = "这是聚焦蔬菜羹！"
        
STRINGS.NAMES.LEAFLOAF_DARKVISION = "另眼相看饼"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LEAFLOAF_DARKVISION = "这是另眼相看饼！"

-----------------------------------------------------------------------------------------

STRINGS.NAMES.DINNER_IN_PLATE = "盘中餐"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DINNER_IN_PLATE = "这是盘中餐！"
        
STRINGS.NAMES.NIGHTMAREFUEL_SPIRIT = "精炼的噩梦燃料"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.NIGHTMAREFUEL_SPIRIT = "这是精炼的噩梦燃料！"
        
STRINGS.NAMES.SWEET_CI_CIRCLE = "甜蜜刺身卷"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SWEET_CI_CIRCLE = "这是甜蜜刺身卷！"
        
STRINGS.NAMES.DEADLY_SWEET_HEART = "致命甜心"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DEADLY_SWEET_HEART = "这是致命甜心！"
        
STRINGS.NAMES.DEVIL_FIRE_MOUNTAIN = "恶魔火焰山"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DEVIL_FIRE_MOUNTAIN = "这是恶魔火焰山！"
        
STRINGS.NAMES.GHOST_HOLLY_DAI = "幽灵圣代"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GHOST_HOLLY_DAI = "这是幽灵圣代！"
        
STRINGS.NAMES.WETGOOP_GHOST = "幽灵"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.WETGOOP_GHOST = "这是幽灵！"
        
STRINGS.NAMES.YAN_FISH = "腌鱼"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.YAN_FISH = "这是腌鱼！"
        
STRINGS.NAMES.BLOOD_BEAST_ZHEN = "血腥胸针"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BLOOD_BEAST_ZHEN = "这是血腥胸针！"
        
STRINGS.NAMES.SMART_FOX_WU = "灵狐坞"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SMART_FOX_WU = "这是灵狐坞！"
        
STRINGS.NAMES.NIGHTMARE_TANGYUAN = "梦魇汤圆"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.NIGHTMARE_TANGYUAN = "这是梦魇汤圆！"
        
STRINGS.NAMES.KANLU_MOUNTAIN_FUHUO_FESTIVAL = "砍麗山的复活节"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.KANLU_MOUNTAIN_FUHUO_FESTIVAL = "这是砍麗山的复活节！"
        
STRINGS.NAMES.HUNGRY_PARTY = "饥饿派对"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HUNGRY_PARTY = "这是饥饿派对！"
        
STRINGS.NAMES.ELDER_VEGGIE = "老年菜"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ELDER_VEGGIE = "这是老年菜！"
        
STRINGS.NAMES.FUHUA_NINE_ZHOU = "浮华九州"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FUHUA_NINE_ZHOU = "这是浮华九州！"
        
STRINGS.NAMES.DRAGON_FENIX_PAN = "龙凤锅"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DRAGON_FENIX_PAN = "这是龙凤锅！"
        
STRINGS.NAMES.GRANDMA_STAR_ICE_HAPPY = "老太婆星冰乐"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GRANDMA_STAR_ICE_HAPPY = "这是老太婆星冰乐！"
        
STRINGS.NAMES.SHADOW_THRONE = "暗影王座"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SHADOW_THRONE = "这是暗影王座！"
        
STRINGS.NAMES.FANTA_HOUSE_ON_THE_SEA = "海市蜃楼"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FANTA_HOUSE_ON_THE_SEA = "这是海市蜃楼！"
        
STRINGS.NAMES.WANSHEN_NIGHT = "万圣夜"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.WANSHEN_NIGHT = "这是万圣夜！"
        
STRINGS.NAMES.MEATBALLS_TYRANT = "暴君肉丸"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MEATBALLS_TYRANT = "这是暴君肉丸！"
        
STRINGS.NAMES.ZHUANG_YUAN_MASTER_CAKE = "庄园主蛋糕"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ZHUANG_YUAN_MASTER_CAKE = "这是庄园主蛋糕！"
        
STRINGS.NAMES.DEEP_SLEEP_SOUP = "长眠汤"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DEEP_SLEEP_SOUP = "这是长眠汤！"

return unpack(prefs)