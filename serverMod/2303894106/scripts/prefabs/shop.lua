require "prefabutil"
require "goods_list"
require "products_list"

local assets =
{
    Asset("ANIM", "anim/shop.zip"),
    Asset("IMAGE", "images/inventoryimages/shop.tex"),
    Asset("ATLAS", "images/inventoryimages/shop.xml"),
    Asset("ATLAS", "images/numberfonts.xml"),
    Asset("IMAGE", "images/numberfonts.tex"),
    Asset("ATLAS_BUILD", "images/numberfonts.xml", 64),
}

local prefabs =
{
    "fx_shoplight",
    "fx_shopnote",
}
---------------------------------
local IconPos = {   --替换图标贴图的位置
    product1 = "P_SIGN_A",
    product2 = "P_SIGN_B",
    product3 = "P_SIGN_C",
    goods1 = "G_SIGN_A",
    goods2 = "G_SIGN_B",
    goods3 = "G_SIGN_C",
}
local NumPos = {    --替换数字贴图的位置
    product1 = "P_NUM_A",
    product2 = "P_NUM_B",
    product3 = "P_NUM_C",
    goods1 = "G_NUM_A",
    goods2 = "G_NUM_B",
    goods3 = "G_NUM_C",
}

local function GetIcon(prefab)
    local ent = SpawnPrefab(prefab)
    if ent == nil or not ent.components.inventoryitem then
        return
    end

    local atlas, bgimage, bgatlas
    local image = FunctionOrValue(ent.drawimageoverride, ent) or (#(ent.components.inventoryitem.imagename or "") > 0 and ent.components.inventoryitem.imagename) or ent.prefab or nil
    if image ~= nil then
        atlas = ent.drawatlasoverride or (#(ent.components.inventoryitem.atlasname or "") > 0 and ent.components.inventoryitem.atlasname) or nil
        if ent.inv_image_bg ~= nil and ent.inv_image_bg.image ~= nil and ent.inv_image_bg.image:len() > 4 and ent.inv_image_bg.image:sub(-4):lower() == ".tex" then
            bgimage = ent.inv_image_bg.image:sub(1, -5)
            bgatlas = ent.inv_image_bg.atlas ~= GetInventoryItemAtlas(ent.inv_image_bg.image) and ent.inv_image_bg.atlas or nil
        end
    end
    ent:Remove()
    return image, atlas, bgimage, bgatlas
end

local function DrawIcon(inst, prefab, pos)
    if prefab then
        local image, atlas, bgimage, bgatlas = GetIcon(prefab)
        if image ~= nil and IconPos[pos]then
            inst.AnimState:OverrideSymbol(IconPos[pos], atlas or GetInventoryItemAtlas(image..".tex"), image..".tex")
        elseif IconPos[pos] then
            inst.AnimState:ClearOverrideSymbol(IconPos[pos])
        end
    end
end

local function ChangeGoods(inst)
    for i = 1, 3, 1 do      --随机生成货物
        local prob = math.floor(math.random(1,100))
        local probb = 1
        if prob <= 5 then
            probb = math.floor(math.random(1,12))
            inst.goods[i] = list_blueprint[probb]    --特殊蓝图 5%
            inst.goods[i].num = 1
        elseif prob <= 10 then
            probb = math.floor(math.random(1,74))
            inst.goods[i] = list_precious[probb]     --珍贵物品 5%
            inst.goods[i].num = 1
        elseif prob <= 40 then
            probb = math.floor(math.random(1,84))
            inst.goods[i] = list_resource[probb]     --基础资源 30%
            inst.goods[i].num = math.floor(math.random(3,10))
        elseif prob <= 70 then
            probb = math.floor(math.random(1,55))
            inst.goods[i] = list_cloth[probb]    --衣服 30%
            inst.goods[i].num = math.floor(math.random(1,2))
        else
            probb = math.floor(math.random(1,71))
            inst.goods[i] = list_smithing[probb]     --打造物品 30%
            inst.goods[i].num = math.floor(math.random(1,3))
        end
    end
    if inst.goods[1] and inst.goods[2] and inst.goods[3]then        --生成所需产品的总价值
        local need_price_1 = math.ceil(math.random(math.ceil(inst.goods[1].price*1.2), math.ceil(inst.goods[1].price*1.3)))*inst.goods[1].num*(TUNING.EA_PRICE_COEFFICIENT or 1)  --需要的产品价值在1.2到1.3倍货物价值
        local need_price_2 = math.ceil(math.random(math.ceil(inst.goods[2].price*1.2), math.ceil(inst.goods[2].price*1.3)))*inst.goods[2].num*(TUNING.EA_PRICE_COEFFICIENT or 1)
        local need_price_3 = math.ceil(math.random(math.ceil(inst.goods[3].price*0.6), math.ceil(inst.goods[3].price*0.8)))*inst.goods[3].num*(TUNING.EA_PRICE_COEFFICIENT or 1)  --第三条是打折栏，价格更便宜
        local products_list_1, products_list_2, products_list_3 = {},{},{}
        for k,v in ipairs(list_products) do   --将单个产品价值小于所需价值2倍以下的插入所需产品表
            if v.price <= need_price_1*2 and v.price*80 >= need_price_1 then
                table.insert(products_list_1,v)
            end
            if v.price <= need_price_2*2 and v.price*80 >= need_price_2 then
                table.insert(products_list_2,v)
            end
            if v.price <= need_price_3*3 and v.price*80 >= need_price_3 then
                table.insert(products_list_3,v)
            end
        end
        --product1
        local prob = math.floor(math.random(1, #products_list_1))  --在所需产品表中随机刷新一种产品
        inst.products[1] = products_list_1[prob]
        inst.products[1].num = math.ceil(need_price_1 / inst.products[1].price)
        --product2
        local count = 0
        local last_prob_a = prob
        while prob == last_prob_a do        --尽量避免出现所需产品相同的情况
            prob = math.floor(math.random(1, #products_list_2))
            count = count + 1
            if count > 9 then
                break
            end
            if #products_list_2 <= 1 then
                break
            elseif #products_list_2 == 2 then
                inst.products[2] = products_list_2[prob+1] or products_list_2[prob-1]
                break
            end
            inst.products[2] = products_list_2[prob]
        end
        inst.products[2].num = math.ceil(need_price_2 / inst.products[2].price)
        --product3
        local last_prob_b = prob
        count = 0
        while prob == last_prob_a or prob == last_prob_b do
            prob = math.floor(math.random(1, #products_list_3))
            count = count + 1
            if count > 9 then
                break
            end
            if #products_list_3 <= 1 then
                break
            elseif #products_list_3 == 2 then
                inst.products[3] = products_list_3[prob+1] or products_list_3[prob-1]
                break
            end
            inst.products[3] = products_list_3[prob]
        end
        inst.products[3].num = math.ceil(need_price_3 / inst.products[3].price)
    end

    for i = 1, 3, 1 do      --画图标
        DrawIcon(inst, inst.goods[i].name, "goods"..i)
        DrawIcon(inst, inst.products[i].name, "product"..i)
        inst.AnimState:OverrideSymbol(NumPos["goods"..i], resolvefilepath("images/numberfonts.xml"), inst.goods[i].num..".tex")
        inst.AnimState:OverrideSymbol(NumPos["product"..i], resolvefilepath("images/numberfonts.xml"), inst.products[i].num..".tex")
        --print(inst.goods[i].num..".tex")
        --print(inst.products[i].num..".tex")
    end
    --print("Changed!")     --print
end
---------------------------------

local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    inst.SoundEmitter:KillSound("firesuppressor_idle")
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    local note = inst.note
    local light = inst.light
    inst:Remove()
    if note then
        note.AnimState:PlayAnimation("delete")
        note:DoTaskInTime(0.6,function ()
            if note ~= nil then
                note:Remove()
            end
        end)
    end
    if light then
        light:Remove()
    end
end

local function onhit(inst, worker)
    --[[if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle")
    end]]--
end

local function onsave(inst, data)
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end
    data.goods = inst.goods
    data.products = inst.products
    data.refresh_rate = inst.refresh_rate
    if inst.light ~= nil then
        data.light = true
    else
        data.light = false
    end
end

local function onload(inst, data)
    if data ~= nil then
        if data.burnt and inst.components.burnable ~= nil and inst.components.burnable.onburnt ~= nil then
            inst.components.burnable.onburnt(inst)
        end
        if data.refresh_rate then
            inst.refresh_rate = data.refresh_rate
        end
        
        if data.light then
            local x, y, z = inst.Transform:GetWorldPosition()
            for k,v in pairs(TheSim:FindEntities(x, y, z, 1)) do
                if v.prefab == "fx_shoplight" then
                    if inst.light == nil then
                        inst.light = v
                    end
                end
            end
        else
            local x, y, z = inst.Transform:GetWorldPosition()
            for k,v in pairs(TheSim:FindEntities(x, y, z, 0.5)) do
                if v.prefab == "fx_shoplight" then
                    v:Remove()
                end
            end
        end

        if data.goods then
            inst.goods = data.goods
            for i = 1, 3, 1 do      --画图标
                DrawIcon(inst, inst.goods[i].name, "goods"..i)
                inst.AnimState:OverrideSymbol(NumPos["goods"..i], resolvefilepath("images/numberfonts.xml"), inst.goods[i].num..".tex")
            end
        end
        if data.products then
            inst.products = data.products
            for i = 1, 3, 1 do      --画图标
                DrawIcon(inst, inst.products[i].name, "product"..i)
                inst.AnimState:OverrideSymbol(NumPos["product"..i], resolvefilepath("images/numberfonts.xml"), inst.products[i].num..".tex")
            end
        end
    end
end

local function onbuilt(inst)
    --inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/firesupressor_craft")
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle", true)
    ChangeGoods(inst)
    if not TheWorld.state.isday then
        inst.light = SpawnPrefab("fx_shoplight")
        local x,y,z = inst.Transform:GetWorldPosition()
        inst.light.Transform:SetPosition(x,y,z)
    end
end
---------------------------------


local function shouldacceptitem(inst,item,giver)
    local number = 0
    local anything = 0
    if (item.prefab == "bundle" or item.prefab == "gift") and item.components.unwrappable then
        local items_in_bundle = item.components.unwrappable.itemdata    --获取打包的物品
        for k,v in pairs(inst.products) do
            number = 0      --检测每条规则前，将计数清零
            if v.name then      --没有规则的那一条不需要检测
                for i,it in pairs(items_in_bundle) do       --遍历包裹里的物品
                    local itt = SpawnPrefab(it.prefab, it.skinname, it.skin_id)     --生成包裹里的物品
                    itt:SetPersistData(it.data)
                    if it.prefab == v.name then     --如果包裹里的物品和所需要的物品相同
                        if itt.components.stackable then    --如果包裹里的物品可堆叠
                            number = number + itt.components.stackable.stacksize     --计数加 堆叠的数量
                        else
                            number = number + 1     --如果不可堆叠，计数加一
                        end
                    end
                    itt:Remove()        --移除刚刚生成的包裹里的物品的实体
                end
                if number ~= 0 and number >= v.num then     --遍历完包裹里的物品，得到最终数量，判断是否可以接收
                    return true
                end
                if number ~= 0 then     --表示装有正确的物品，但是数量不够
                    anything = number
                end
            end
        end     --检测完所有规则，仍然没有接受到需要的物品，表示接受失败
        if giver and giver.components.talker then
            if anything == 0 then     --收到的包裹里没正确的物品
                giver.components.talker:Say(STRINGS.WRONG_ITEM)
            else        --收到的包裹里的物品数量不够
                giver.components.talker:Say(STRINGS.NOT_ENOUGH)
            end
        end
    else        --收到的不是包裹
        if giver and giver.components.talker then
            giver.components.talker:Say(STRINGS.GIVE_ME_BUNDLE)
        end
    end
    return false
end

local function ongetitem(inst,giver,item)
    local prod = nil    --要给的物品
    local prod_num = 0      --收到的物品的数量，用来判断给哪个物品
    local number = 1        --要给的数量
    local items_in_bundle = item.components.unwrappable.itemdata    --获取收到包裹里的物品
      
    for k,v in pairs(inst.products) do      --和shouldacceptitem()方法一样，检测触发了哪条规则，该给哪个物品
        for i,it in pairs(items_in_bundle) do       --遍历包裹里的物品
            if it.prefab == v.name then     --如果包裹里的物品和所需物品相同,那么统计其数量
                local itt = SpawnPrefab(it.prefab, it.skinname, it.skin_id)     --获取物品个数,在有两条所需产品相同的交换规则且均满足条件时，只执行第一条规则
                itt:SetPersistData(it.data)
                if itt.components.stackable then
                    prod_num = prod_num + itt.components.stackable.stacksize
                else
                    prod_num = prod_num + 1
                end
                itt:Remove()
            end
        end
        if prod_num ~= 0 and prod_num >= v.num then     --如果数量不为0，且不少于所需数量，那么就决定是它了，设定要给的物品，跳出循环
            prod = SpawnPrefab(inst.goods[k].name)      --设定要给的物品
            number = inst.goods[k].num or 1             --设定要给的数量
            if prod.components.stackable then           --如果要给的物品可堆叠，设定其堆叠数量为要给的数量
                prod.components.stackable.stacksize = inst.goods[k].num or 1
            end
            inst.products[k] = {name = nil, price = nil, num = 0}       --以下6行，清空该条规则
            inst.goods[k] = {name = nil, price = nil, num = 0}
            inst.AnimState:ClearOverrideSymbol(IconPos["product"..k])
            inst.AnimState:ClearOverrideSymbol(IconPos["goods"..k])
            inst.AnimState:ClearOverrideSymbol(NumPos["product"..k])
            inst.AnimState:ClearOverrideSymbol(NumPos["goods"..k])
            break       --已经找到了，跳出循环
        end
    end

    inst.AnimState:PlayAnimation("work")        --播放动画
    inst.AnimState:PushAnimation("idle")
    if inst.light then
        inst.light.AnimState:PlayAnimation("work")
        inst.light.AnimState:PushAnimation("idle")
    end
    inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_science_gift_recieve")
    inst:DoTaskInTime(0.9,function ()     --给物品
        if prod and prod.components.inventoryitem and giver and giver.components.inventory then     --如果物品可以放入物品栏
            if not prod.components.stackable then       --如果物品不能堆叠，则给予number次该物品
                local prod_prefab = prod.prefab     --不能将prod给予多次，因为prod是实体，只有一个;先存储prod的prefab用于之后生成实体
                prod:Remove()
                for i = 1, number, 1 do
                    giver.components.inventory:GiveItem(SpawnPrefab(prod_prefab), nil, inst:GetPosition())
                end
            else        --如果物品可堆叠,直接给一次就可以了
                giver.components.inventory:GiveItem(prod, nil, inst:GetPosition())
            end
        elseif prod then        --如果物品不可以放入物品栏，则直接掉落
            if not prod.components.stackable then
                local prod_prefab = prod.prefab
                prod:Remove()
                for i = 1, number, 1 do
                    inst.components.lootdropper:FlingItem(SpawnPrefab(prod_prefab), inst:GetPosition())
                end
            else inst.components.lootdropper:FlingItem(prod, inst:GetPosition())
            end
        end
        if item.prefab == "bundle" and giver and giver.components.inventory then      --如果给的是蜡纸包裹，返还蜡纸
            giver.components.inventory:GiveItem(SpawnPrefab("waxpaper"))
        end
    end)
end


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()
    inst.entity:AddLightWatcher()

    MakeObstaclePhysics(inst, 1.2)

    inst.MiniMapEntity:SetIcon("shop_mini.tex")  --小地图图标

    inst.AnimState:SetBank("shop")
    inst.AnimState:SetBuild("shop")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("structure")
    --inst:AddTag("trader")

    --MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    ----------------------------------------
    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(shouldacceptitem)
    inst.components.trader.onaccept = ongetitem
    inst.components.trader.acceptnontradable = true
    
    ----------------------------------------
    inst.goods = {}     --存储货物数据{name,price,num}
    inst.products = {}  --存储所需产品数据{name,price,num}

    inst.note = nil
    inst.refresh_rate = (TUNING.EA_REFRESH_FREQUENCY or 2)
    inst:ListenForEvent("ms_cyclecomplete",function ()
        inst.refresh_rate = inst.refresh_rate - 1       --倒计时减一天
        if inst.refresh_rate == 1 and inst.note == nil then      --如果还剩一天，生成提示旗帜
            inst.note = SpawnPrefab("fx_shopnote")
            local x,y,z = inst.Transform:GetWorldPosition()
            inst.note.Transform:SetPosition(x,y,z)
            inst.note.shop = inst           --旗帜与shop的绑定在旗帜中存储与读取
            for k,v in pairs(TheSim:FindEntities(x, y, z, 1)) do
                local x1,y1,z1 = v.Transform:GetWorldPosition()
                --print(v.prefab..".x:"..x1.." z:"..z1)         --print
            end
        end
        if inst.refresh_rate <= 0 then      --如果过了X天，则更新货物
            ChangeGoods(inst)
            inst.refresh_rate = (TUNING.EA_REFRESH_FREQUENCY or 2)
            if inst.note ~= nil then        --移除提示旗帜
                inst.note.AnimState:PlayAnimation("delete")
                inst:DoTaskInTime(0.6,function ()
                    if inst.note ~= nil then
                        inst.note:Remove()
                        inst.note = nil
                    end
                end)
            end
        end
    end,
    TheWorld)       --每过两天，更新货物和交换物(默认2天，可设置刷新频率)


    ----------------------------------------
    inst.light = nil
    inst:ListenForEvent("phasechanged",function (_theworld, phase)
        if phase ~= "day" and inst.light == nil then      --夜晚亮灯
            inst.light = SpawnPrefab("fx_shoplight")
            local x,y,z = inst.Transform:GetWorldPosition()
            inst.light.Transform:SetPosition(x,y,z)
        end
        if phase == "day" then        ----天亮熄灯
            if inst.light ~= nil then
                inst.light.AnimState:PlayAnimation("delete")
                inst:DoTaskInTime(0.9,function ()
                    if inst.light ~= nil then
                        inst.light:Remove()
                        inst.light = nil
                    end
                end)
            end
        end
    end,
    TheWorld)

    --MakeMediumBurnable(inst, nil, nil, true)
    --MakeMediumPropagator(inst)
    --inst.components.burnable:SetOnBurntFn(onburnt)
    --MakeSnowCovered(inst)

    inst:ListenForEvent("onbuilt", onbuilt)

    inst.OnSave = onsave
    inst.OnLoad = onload

    return inst
end

return Prefab("shop", fn, assets, prefabs),
    MakePlacer("shop_placer", "shop", "shop", "idle")