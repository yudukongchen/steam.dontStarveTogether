local cooking = require("cooking")

local creatureTypeBird = {
    "crow",             --乌鸦
    "robin_winter",     --雪雀        
    "robin",            --红雀
    "canary",           --金丝雀
    "pigeon",           --鸽子
    "quagmire_pigeon",  --暴食的鸽子
    "puffin",           --（海上那些鸟）
}

local creatureTypeA = {
    "crow",             --乌鸦
    "robin_winter",     --雪雀        
    "robin",            --红雀
    "canary",           --金丝雀
    "mole",             --鼹鼠
    "rabbit",           --兔子
    -- "rabbit",                 --雪兔
    "pigeon",           --鸽子
    "quagmire_pigeon",  --暴食的鸽子
    "puffin",           --（海上那些鸟）
}

local creatureTypeB = {
    "bee",              --蜜蜂
    "killerbee",        --杀人蜂
    "mosquito",         --蚊子
    "spore_medium",     --红色发光孢子
    "spore_small",      --绿色发光孢子
    "spore_tall",       --蓝色发光孢子
    "butterfly",        --蝴蝶
}

local creatureTypeSpore = {
    "spore_medium",     --红色发光孢子
    "spore_small",      --绿色发光孢子
    "spore_tall",       --蓝色发光孢子
}

local function GetNightmarefuelCnt(names)
    local cnt = 0
    for name,num in pairs(names) do 
        if name == "nightmarefuel" or name == "nightmarefuel_spirit" then 
            cnt = cnt + num
        end
    end
    return cnt 
end

-- GetIngredientValues这个函数是复制自cooking.lua的
local function GetIngredientValues(prefablist)
    --our naming conventions aren't completely consistent, sadly
    local aliases = {
        cookedsmallmeat = "smallmeat_cooked",
        cookedmonstermeat = "monstermeat_cooked",
        cookedmeat = "meat_cooked",
    }
    local prefabs = {}
    local tags = {}
    for k,v in pairs(prefablist) do
        local name = aliases[v] or v
        prefabs[name] = (prefabs[name] or 0) + 1
        local data = cooking.ingredients[name]
        if data ~= nil then
            for kk, vv in pairs(data.tags) do
                tags[kk] = (tags[kk] or 0) + vv
            end
        end
    end
    return { tags = tags, names = prefabs }
end

local function DarkpotGetItemsInSlot(inst,target_slots)
    local pair_tabs = inst.components.container and inst.components.container.slots or inst.replica.container:GetItems()
    local ret = {}
    for k, v in pairs(pair_tabs) do
        if target_slots == nil or table.contains(target_slots,k) then 
            table.insert(ret,v)
        end 
    end 
    return ret
end

local function CheckReplaceProduct(inst,old_product,old_cooktime,do_print)
    local up_items = DarkpotGetItemsInSlot(inst,inst.up_slots)
    local mid_items = DarkpotGetItemsInSlot(inst,inst.mid_slots)
    local down_items = DarkpotGetItemsInSlot(inst,inst.down_slots)
    local all_items = DarkpotGetItemsInSlot(inst)

    local ingredient_prefabs = {}
    local replace_product = nil 
    local bonus_time = 0

    local nightmarefuel_num = {
        up = 0,
        mid = 0,
        down = 0,
        spirit = 0,
    }   
    local creatureTypeA_num = 0
    for k,v in pairs(all_items) do 
        table.insert(ingredient_prefabs, v.prefab)
        if v.prefab == "nightmarefuel" then 
            if k >= 1 and k <= 3 then 
                nightmarefuel_num.up = nightmarefuel_num.up + 1
            elseif k >= 4 and k <= 7 then 
                nightmarefuel_num.mid = nightmarefuel_num.mid + 1
            elseif k >= 8 and k <= 10 then 
                nightmarefuel_num.down = nightmarefuel_num.down + 1
            end
        end 

        if v.prefab == "nightmarefuel_spirit" then 
            nightmarefuel_num.spirit =  nightmarefuel_num.spirit + 1
        end

        -- 锅中每有1单位A类活物，烹饪时间加5秒
        if table.contains(creatureTypeA,v.prefab) then 
            creatureTypeA_num = creatureTypeA_num + 1
        end
    end

    local old_product_recipe = cooking.GetRecipe(inst.prefab,old_product)
    if not (old_product_recipe and old_product_recipe.ignore_darkpot_time_bonus_add) then 
        bonus_time = nightmarefuel_num.up * 20 
        + nightmarefuel_num.mid * 10 
        + nightmarefuel_num.down * 5  
        + creatureTypeA_num * 5
    end
    if not (old_product_recipe and old_product_recipe.ignore_darkpot_time_bonus_sub) then 
         bonus_time = bonus_time - nightmarefuel_num.spirit * 10
    end
    -- if old_product == "nightmarefuel_spirit" or old_product == "wetgoop_ghost" then 
    --     -- 精炼噩梦燃料不受加成
    --     bonus_time = 0
    -- end


    -- old_cooktime * TUNING.BASE_COOK_TIME 才是真正的烹饪时间!
    old_cooktime = old_cooktime * TUNING.BASE_COOK_TIME 

    if old_cooktime + bonus_time < 20 then 
        for k,v in pairs(up_items) do 
            local du_data = GetIngredientValues({v.prefab})
            if du_data.tags.meat or table.contains(creatureTypeA,v.prefab) then 
                replace_product = "wetgoop"  -- 若1～3号有肉类或A类活物，烹饪时间小于20秒，则输出失败料理
                if do_print then 
                    print("[TzDarkCookpot]:1～3号有肉类或A类活物，烹饪时间小于20秒，输出失败料理")
                end 
                break
            end
        end
    elseif old_cooktime + bonus_time > 20 then 
        for k,v in pairs(down_items) do 
            local du_data = GetIngredientValues({v.prefab})
            if du_data.tags.veggie or table.contains(creatureTypeB,v.prefab) or du_data.tags.frozen then 
                replace_product = "wetgoop"  -- 若8～10号有蔬菜类或料理或B类活物或冰，烹饪时间大于20秒，失败料理
                if do_print then 
                    print("[TzDarkCookpot]:8～10号有蔬菜类或料理或B类活物或冰，烹饪时间大于20秒，失败料理")
                end 
                break
            end
        end
    end

    if old_product == "fuhua_nine_zhou" and old_cooktime + bonus_time >= 20 then 
        replace_product = "wetgoop"  -- 若符华九州的时间大于等于20s，失败料理
        if do_print then 
            print("[TzDarkCookpot]:符华九州的时间大于等于20s，失败料理")
        end 
    end

    if replace_product == "wetgoop" then 
        replace_product = "wetgoop_ghost"
    end


    local final_product = replace_product or old_product
    local final_time = old_cooktime + bonus_time
    local final_product_recipe = cooking.GetRecipe(inst.prefab,final_product)
    if final_product_recipe and final_product_recipe.tz_fused_food then 
        final_time = math.max(15,final_time)
        print("[TzDarkCookpot]:融合料理的烹饪时间至少是15秒")
    end

    if do_print then 
        local slot_items_print = ""
        local container_cmp = inst.components.container or inst.replica.container
        for i=1,container_cmp:GetNumSlots() do 
            local ent = container_cmp:GetItemInSlot(i)
            local in_str = ent and tostring(ent.prefab) or tostring(ent)
            slot_items_print = slot_items_print..tostring(i).."."..in_str..","
        end

        print(string.format([==[[TzDarkCookpot]:
        nightmarefuel_num.up:%d
        nightmarefuel_num.mid:%d
        nightmarefuel_num.down:%d
        nightmarefuel_num.spirit:%d
        creatureTypeA_num:%d
        Old Time:%f
        Bonus Time:%f
        All Time:%f
        Old Product:%s
        replace_product:%s
        item_list:%s]==],nightmarefuel_num.up,nightmarefuel_num.mid,nightmarefuel_num.down,nightmarefuel_num.spirit,creatureTypeA_num,
            old_cooktime,bonus_time,final_time,old_product,tostring(replace_product),slot_items_print))
    end 

    

    return final_product,final_time
end

local function DarkotCalculateRecipe(inst,do_print)
	--[[
    local up_items = DarkpotGetItemsInSlot(inst,inst.up_slots)
    local mid_items = DarkpotGetItemsInSlot(inst,inst.mid_slots)
    local down_items = DarkpotGetItemsInSlot(inst,inst.down_slots)
    local all_items = DarkpotGetItemsInSlot(inst)

    local ingredient_prefabs = {}
    local replace_product = nil 
    local bonus_time = 0

    local nightmarefuel_num = {
        up = 0,
        mid = 0,
        down = 0,
    }   
    local creatureTypeA_num = 0
    for k,v in pairs(all_items) do 
        table.insert(ingredient_prefabs, v.prefab)
        if v.prefab == "nightmarefuel" then 
            if k >= 1 and k <= 3 then 
                nightmarefuel_num.up = nightmarefuel_num.up + 1
            elseif k >= 4 and k <= 7 then 
                nightmarefuel_num.mid = nightmarefuel_num.mid + 1
            elseif k >= 8 and k <= 10 then 
                nightmarefuel_num.down = nightmarefuel_num.down + 1
            end
        end

        -- 锅中每有1单位A类活物，烹饪时间加5秒
        if table.contains(creatureTypeA,v.prefab) then 
            creatureTypeA_num = creatureTypeA_num + 1
        end
    end

    bonus_time = nightmarefuel_num.up * 20 + nightmarefuel_num.mid * 10 + nightmarefuel_num.down * 5  + creatureTypeA_num * 5

    local old_product,old_cooktime = cooking.CalculateRecipe(inst.prefab, ingredient_prefabs)

    old_cooktime * TUNING.BASE_COOK_TIME 才是真正的烹饪时间!
    old_cooktime = old_cooktime * TUNING.BASE_COOK_TIME 
    


    if old_cooktime + bonus_time < 20 then 
        for k,v in pairs(up_items) do 
            local du_data = GetIngredientValues({v.prefab})
            if du_data.tags.meat or table.contains(creatureTypeA,v.prefab) then 
                replace_product = "wetgoop"  -- 若1～3号有肉类或A类活物，烹饪时间小于20秒，则输出失败料理
                if do_print then 
                    print("[TzDarkCookpot]:1～3号有肉类或A类活物，烹饪时间小于20秒，输出失败料理")
                end 
                break
            end
        end
    elseif old_cooktime + bonus_time > 20 then 
        for k,v in pairs(down_items) do 
            local du_data = GetIngredientValues({v.prefab})
            if du_data.tags.veggie or table.contains(creatureTypeB,v.prefab) or du_data.tags.frozen then 
                replace_product = "wetgoop"  -- 若8～10号有蔬菜类或料理或B类活物或冰，烹饪时间大于20秒，失败料理
                if do_print then 
                    print("[TzDarkCookpot]:8～10号有蔬菜类或料理或B类活物或冰，烹饪时间大于20秒，失败料理")
                end 
                break
            end
        end
    end

    if do_print then 
        local slot_items_print = ""
        local container_cmp = inst.components.container or inst.replica.container
        for i=1,container_cmp:GetNumSlots() do 
            local ent = container_cmp:GetItemInSlot(i)
            local in_str = ent and tostring(ent.prefab) or tostring(ent)
            slot_items_print = slot_items_print..tostring(i).."."..in_str..","
        end
	--]]
        --print(string.format([==[[TzDarkCookpot]:
        -- nightmarefuel_num.up:%d
        -- nightmarefuel_num.mid:%d
        -- nightmarefuel_num.down:%d
        -- creatureTypeA_num:%d
        -- Old Time:%f
        -- Bonus Time:%f
        -- All Time:%f
        -- Old Product:%s
        -- replace_product:%s
        -- item_list:%s]==],nightmarefuel_num.up,nightmarefuel_num.mid,nightmarefuel_num.down,creatureTypeA_num,
            -- old_cooktime,bonus_time,old_cooktime + bonus_time,old_product,tostring(replace_product),slot_items_print))
    -- end 

    local all_items = DarkpotGetItemsInSlot(inst)
    local ingredient_prefabs = {}
    for k,v in pairs(all_items) do 
        table.insert(ingredient_prefabs, v.prefab)
    end
    local product,cooktime = cooking.CalculateRecipe(inst.prefab, ingredient_prefabs)
    local new_product,new_cooktime = CheckReplaceProduct(inst,product,cooktime,do_print)

    return new_product,new_cooktime
end

local function PredictRecipe(inst)
    local all_items = DarkpotGetItemsInSlot(inst)
    local all_item_prefabs = {}
    for k,v in pairs(all_items) do 
        table.insert(all_item_prefabs,v.prefab)
    end
    local ingdata = GetIngredientValues(all_item_prefabs)
    local product_datas = GetCandidateRecipes(inst.prefab, ingdata)
    local products = {}
    for k,v in pairs(product_datas) do 
        local old_product,old_cooktime = v.name,v.cooktime
        local new_product,new_cooktime = CheckReplaceProduct(inst,old_product,old_cooktime)
        table.insert(products,new_product)
    end

    return products
    -- local product,co
    -- local all_products = GetCandidateRecipes(inst.prefab, ingdata)
    -- for i=1,#all_products do 
    --     local old_product,old_cooktime = all_products[i],
    --     all_products[i] = CheckReplaceProduct(inst,all_products[i])
    -- end
end



return {
    creatureTypeA = creatureTypeA,
    creatureTypeB = creatureTypeB,
    creatureTypeBird = creatureTypeBird,
    creatureTypeSpore = creatureTypeSpore,
    GetNightmarefuelCnt = GetNightmarefuelCnt,
    DarkpotGetItemsInSlot = DarkpotGetItemsInSlot,
    DarkotCalculateRecipe = DarkotCalculateRecipe,
    CheckReplaceProduct = CheckReplaceProduct,
    PredictRecipe = PredictRecipe,
}