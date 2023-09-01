local recipe_help = true
--人物皮肤API
local characterskins = {}
local skincharacters = {}
--人物过滤
local SKIN_AFFINITY_INFO = require("skin_affinity_info")
function MakeCharacterSkin(base, skinname, data)
    data.type = nil

    --标记一下是拥有皮肤的人物
    if not skincharacters[base] then
        skincharacters[base] = true
    end
    characterskins[skinname] = data
    data.base_prefab = base
    data.rarity = data.rarity or "Loyal"    --默认珍惜度
    data.build_name_override = data.build_name_override or skinname

    --不存在的珍惜度 自动注册字符串
    if not STRINGS.UI.RARITY[data.rarity] then
        STRINGS.UI.RARITY[data.rarity] = data.rarity
        SKIN_RARITY_COLORS[data.rarity] = data.raritycorlor or { 0.635, 0.769, 0.435, 1 }
        RARITY_ORDER[data.rarity] = data.rarityorder or -1
    end

    --注册到字符串
    STRINGS.SKIN_NAMES[skinname] = data.name or skinname
    STRINGS.SKIN_DESCRIPTIONS[skinname] = data.des or ""
    STRINGS.SKIN_QUOTES[skinname] = data.quotes or ""

    --注册到皮肤列表
    if not PREFAB_SKINS[base] then
        PREFAB_SKINS[base] = {}
    end
    table.insert(PREFAB_SKINS[base], skinname)
    if not SKIN_AFFINITY_INFO[base] then
        SKIN_AFFINITY_INFO[base] = {}
    end
    table.insert(SKIN_AFFINITY_INFO[base], skinname)

    --创建皮肤预制物
    local prefab_skin = CreatePrefabSkin(skinname, data)
    if data.clear_fn then
        prefab_skin.clear_fn = data.clear_fn
    end
    prefab_skin.type = "base"
    RegisterPrefabs(prefab_skin)    --注册并加载皮肤的prefab
    TheSim:LoadPrefabs({ skinname })

    return prefab_skin
end

--物品皮肤
local itemskins = {}
local itembaseimage = {}
function MakeItemSkinDefaultImage (base, atlas, image)
    itembaseimage[base] = { atlas, (image or base) .. ".tex", "default.tex" }
end
function MakeItemSkin(base, skinname, data)
    data.type = nil
    itemskins[skinname] = data
    data.base_prefab = base
    data.rarity = data.rarity or "Loyal"    --默认珍惜度
    data.build_name_override = data.build_name_override or skinname

    --不存在的珍惜度 自动注册字符串
    if not STRINGS.UI.RARITY[data.rarity] then
        STRINGS.UI.RARITY[data.rarity] = data.rarity
        SKIN_RARITY_COLORS[data.rarity] = data.raritycorlor or { 0.635, 0.769, 0.435, 1 }
        RARITY_ORDER[data.rarity] = data.rarityorder or -1
    end

    --注册到字符串
    STRINGS.SKIN_NAMES[skinname] = data.name or skinname
    STRINGS.SKIN_DESCRIPTIONS[skinname] = data.des or ""

    --注册到皮肤列表
    if not PREFAB_SKINS[base] then
        PREFAB_SKINS[base] = {}
    end
    table.insert(PREFAB_SKINS[base], skinname)
    if not PREFAB_SKINS_IDS[base] then
        PREFAB_SKINS_IDS[base] = {}
    end
    local index = 1
    for k, v in pairs(PREFAB_SKINS_IDS[base]) do
        index = index + 1
    end
    PREFAB_SKINS_IDS[base][skinname] = index

    --创建皮肤预制物
    data.skininit_fn = data.init_fn or nil
    data.skinclear_fn = data.clear_fn or nil
    data.init_fn = function(i)
        basic_skininit_fn(i, skinname)
    end
    data.clear_fn = function(i)
        basic_skinclear_fn(i, skinname)
    end
    if data.skinpostfn then
        data.skinpostfn(data)   --给一个玩家改init_fn的接口
    end
    local prefab_skin = CreatePrefabSkin(skinname, data)
    if data.clear_fn then
        prefab_skin.clear_fn = data.clear_fn
    end
    prefab_skin.type = "item"
    RegisterPrefabs(prefab_skin)    --注册并加载皮肤的prefab
    TheSim:LoadPrefabs({ skinname })

    return prefab_skin
end

--皮肤权限hook
local mt = getmetatable(TheInventory)
--检查所有权
local oldCheckOwnership = TheInventory.CheckOwnership
mt.__index.CheckOwnership = function(i, name, ...)
    --print(i,name,...)
    if type(name) == "string" and (characterskins[name] or itemskins[name]) then
        if characterskins[name] and characterskins[name].checkfn then
            return characterskins[name].checkfn(i, name, ...)
        elseif itemskins[name] and itemskins[name].checkfn then
            return itemskins[name].checkfn(i, name, ...)
        else
            return true
        end
    else
        return oldCheckOwnership(i, name, ...)
    end
end

--查看所有权获取最新信息
local oldCheckOwnershipGetLatest = TheInventory.CheckOwnershipGetLatest
mt.__index.CheckOwnershipGetLatest = function(i, name, ...)
    --print(i,name,...)
    if type(name) == "string" and (characterskins[name] or itemskins[name]) then
        if characterskins[name] and characterskins[name].checkfn then
            return characterskins[name].checkfn(i, name, ...)
        elseif itemskins[name] and itemskins[name].checkfn then
            return itemskins[name].checkfn(i, name, ...)
        else
            return true, 0
        end
    else
        return oldCheckOwnershipGetLatest(i, name, ...)
    end
end

--检查客户所有权
local oldCheckClientOwnership = TheInventory.CheckClientOwnership
mt.__index.CheckClientOwnership = function(i, userid, name, ...)
    if type(name) == "string" and (characterskins[name] or itemskins[name]) then
        if characterskins[name] and characterskins[name].checkclientfn then
            return characterskins[name].checkclientfn(i, userid, name, ...)
        elseif itemskins[name] and itemskins[name].checkclientfn then
            return itemskins[name].checkclientfn(i, userid, name, ...)
        else
            return true
        end
    else
        return oldCheckClientOwnership(i, userid, name, ...)
    end
end

--异常数组
local oldExceptionArrays = GLOBAL.ExceptionArrays
GLOBAL.ExceptionArrays = function(ta, tb, ...)
    local need
    for i = 1, 100, 1 do
        local data = debug.getinfo(i, "S")
        if data then
            if data.source and data.source:match("^scripts/networking.lua") then
                need = true
            end
        else
            break
        end
    end
    if need then
        local newt = oldExceptionArrays(ta, tb, ...)
        for k, v in pairs(skincharacters) do
            table.insert(newt, k)        --偷渡
        end
        return newt
    else
        return oldExceptionArrays(ta, tb, ...)
    end
end

--默认角色皮肤
local oldIsDefaultCharacterSkin = IsDefaultCharacterSkin
GLOBAL.IsDefaultCharacterSkin = function(item, ...)
    if item and characterskins[item] then
        if characterskins[item].checkfn then
            return characterskins[item].checkfn(nil, item)
        else
            return true
        end
    else
        return oldIsDefaultCharacterSkin(item, ...)
    end
end

--骗过皮肤面板，让他以为我们是官方人物
AddClassPostConstruct("widgets/widget", function(self)
    if self.name == "LoadoutSelect" then
        --加载LoadoutSelect之前
        for k, v in pairs(skincharacters) do
            if not table.contains(DST_CHARACTERLIST, k) then
                table.insert(DST_CHARACTERLIST, k)
            end
        end
    elseif self.name == "LoadoutRoot" then
        --已经判断完have_base_option了  可以删了 哈哈
        for k, v in pairs(skincharacters) do
            if table.contains(DST_CHARACTERLIST, k) then
                RemoveByValue(DST_CHARACTERLIST, k)
            end
        end
    end
end)

----游戏模式
--AddSimPostInit(function()
--    if not TheNet:IsOnlineMode() then
--        local net = getmetatable(GLOBAL.TheNet)
--        net.__index.IsOnlineMode = function(n, ...)
--            return true
--        end
--    end
--end)

----人物皮肤的init_fn和clear_fn
AddComponentPostInit("skinner", function(self)
    local oldfn = self.SetSkinName
    if oldfn then
        function self.SetSkinName(s, skinname, ...)
            local old = s.skin_name
            local new = skinname
            if characterskins[old] and characterskins[old].clear_fn then
                characterskins[old].clear_fn(s.inst, old)
            end
            if characterskins[new] and characterskins[new].init_fn then
                characterskins[new].init_fn(s.inst, new)
            end
            oldfn(s, skinname, ...)
        end
    end
end)

--配方弹出
AddClassPostConstruct("widgets/recipepopup", function(self)
    local oldfn = self.GetSkinOptions
    function self.GetSkinOptions(s, ...)
        local ret = oldfn(s, ...)
        if ret then
            if ret[1] and ret[1].image then
                if s.recipe and s.recipe.product and itembaseimage[s.recipe.product] then
                    --存在则覆盖
                    ret[1].image = itembaseimage[s.recipe.product]
                end
            end
            for k, v in pairs(s.skins_list) do
                if ret[k + 1] and ret[k + 1].image and v and v.item and itemskins[v.item] and (itemskins[v.item].atlas or itemskins[v.item].image) then
                    local image = itemskins[v.item].image or v.item .. ".tex"
                    if image:sub(-4) ~= ".tex" then
                        image = image .. ".tex"
                    end
                    local atlas = itemskins[v.item].atlas or GetInventoryItemAtlas(image)
                    ret[k + 1].image = { atlas, image, "default.tex" }
                end
            end
        end
        return ret
    end
end)

--这是全局函数 所以可以放后面 在执行前定义好就行
function basic_skininit_fn(inst, skinname)
    if inst.components.placer == nil and not TheWorld.ismastersim then
        return
    end
    local data = itemskins[skinname]
    if not data then
        return
    end
    if data.bank then
        inst.AnimState:SetBank(data.bank)
    end
    inst.AnimState:SetBuild(data.build or skinname)
    if data.anim then
        inst.AnimState:PlayAnimation(data.anim)
    end
    if inst.components.inventoryitem then
        inst.components.inventoryitem.atlasname = data.atlas or ("images/inventoryimages/" .. skinname .. ".xml")
        inst.components.inventoryitem:ChangeImageName(data.image or skinname)
    end
    if data.skininit_fn then
        data.skininit_fn(inst, skinname)
    end
end
function basic_skinclear_fn(inst, skinname)
    --默认认为 build 和prefab同名 不对的话自己改
    local prefab = inst.prefab or ""
    local data = itemskins[skinname]
    if not data then
        return
    end
    if data.basebank then
        inst.AnimState:SetBank(data.basebank)
    end
    if data.baseanim then
        inst.AnimState:PlayAnimation(data.baseanim)
    end
    inst.AnimState:SetBuild(data.basebuild or prefab)
    if inst.components.inventoryitem then
        if itembaseimage[prefab] then
            inst.components.inventoryitem.atlasname = itembaseimage[prefab][1]
            local imagename = itembaseimage[prefab][2]
            imagename = imagename:sub(1, -5)
            inst.components.inventoryitem:ChangeImageName(imagename)
        else
            inst.components.inventoryitem.atlasname = GetInventoryItemAtlas(prefab .. ".tex")
            inst.components.inventoryitem:ChangeImageName(prefab)
        end
    end
    if itemskins[skinname].skinclear_fn then
        itemskins[skinname].skinclear_fn(inst, skinname)
    end
end
local oldSpawnPrefab = SpawnPrefab
GLOBAL.SpawnPrefab = function(prefab, skin, skinid, userid, ...)
    if itemskins[skin] then
        skinid = 0
    end
    return oldSpawnPrefab(prefab, skin, skinid, userid, ...)
end
local oldReskinEntity = Sim.ReskinEntity
Sim.ReskinEntity = function(sim, guid, oldskin, newskin, skinid, userid, ...)
    local inst = Ents[guid]
    if oldskin and itemskins[oldskin] then
        itemskins[oldskin].clear_fn(inst) --清除旧皮肤的
    end
    local r = oldReskinEntity(sim, guid, oldskin, newskin, skinid, userid, ...)
    if newskin and itemskins[newskin] then
        itemskins[newskin].init_fn(inst)
        inst.skinname = newskin
        inst.skin_id = 0
    end
    return r
end
if recipe_help then
    AddSimPostInit(function()
        for k, v in pairs(AllRecipes) do
            if v.product ~= v.name and PREFAB_SKINS[v.product] then
                PREFAB_SKINS[v.name] = PREFAB_SKINS[v.product]
                PREFAB_SKINS_IDS[v.name] = PREFAB_SKINS_IDS[v.product]
            end
        end
    end)
end
function GetSkin(name)
    return characterskins[name] or itemskins[name] or nil
end

--创建皮肤
if GetModConfigData("Language") == "chinese" then
    MakeCharacterSkin("asakiri","asakiri_none",{
        name = "寻觅者",--皮肤名字
        des = "最初。",--皮肤的描述
        quotes = "这个世界，还有我的容身之所吗",--选人界面的皮肤描述
        build_name_override = "asakiri",
        rarity = "T1",--品质描述
        raritycorlor = {120/255, 120/255, 160/255,1},--品质颜色
        skins = {normal_skin = "asakiri", ghost_skin = "ghost_asakiri_build"},
        skin_tags = {"BASE", "ASAKIRI", "CHARACTER"},
    })

    MakeCharacterSkin("asakiri","asakiri_skin1",{
        name = "复仇者",--皮肤名字
        des = "曾经。",--皮肤的描述
        quotes = "Let's dance.",--选人界面的皮肤描述
        rarity = "T2",--品质描述
        raritycorlor = {120/255, 220/255, 255/255,1},--品质颜色
        skins = {normal_skin = "asakiri_skin1", ghost_skin = "ghost_asakiri_build"},
        skin_tags = {"ASAKIRI"},
    })

    MakeCharacterSkin("asakiri","asakiri_skin2",{
        name = "绯红",--皮肤名字
        des = "得不到的永远在骚动。",--皮肤的描述
        quotes = "诱惑，抑或是深渊。",--选人界面的皮肤描述
        rarity = "T2",--品质描述
        raritycorlor = {120/255, 220/255, 255/255,1},--品质颜色
        skins = {normal_skin = "asakiri_skin2", ghost_skin = "ghost_asakiri_build"},
        skin_tags = {"ASAKIRI"},
    })

    MakeCharacterSkin("asakiri","asakiri_skin3",{
        name = "彼岸花",--皮肤名字
        des = "爱恨离合，皆过眼云烟矣。",--皮肤的描述
        quotes = "黄泉之路，由我来引渡。",--选人界面的皮肤描述
        rarity = "T3",--品质描述
        raritycorlor = {255/255, 120/255, 120/255,1},--品质颜色
        skins = {normal_skin = "asakiri_skin3", ghost_skin = "ghost_asakiri_build"},
        skin_tags = {"ASAKIRI"},
    })
else
    MakeCharacterSkin("asakiri","asakiri_none",{
        name = "Seeker",--皮肤名字
        des = "At first.",--皮肤的描述
        quotes = "Is there anywhere for me to rest?",--选人界面的皮肤描述
        build_name_override = "asakiri",
        rarity = "T1",--品质描述
        raritycorlor = {120/255, 120/255, 160/255,1},--品质颜色
        skins = {normal_skin = "asakiri", ghost_skin = "ghost_asakiri_build"},
        skin_tags = {"BASE", "ASAKIRI", "CHARACTER"},
    })

    MakeCharacterSkin("asakiri","asakiri_skin1",{
        name = "Revenger",--皮肤名字
        des = "Used to be.",--皮肤的描述
        quotes = "Let's dance.",--选人界面的皮肤描述
        rarity = "T2",--品质描述
        raritycorlor = {120/255, 220/255, 255/255,1},--品质颜色
        skins = {normal_skin = "asakiri_skin1", ghost_skin = "ghost_asakiri_build"},
        skin_tags = {"ASAKIRI"},
    })

    MakeCharacterSkin("asakiri","asakiri_skin2",{
        name = "Crimson",--皮肤名字
        des = "Those aren't yours arouse something.",--皮肤的描述
        quotes = "Temptation or destruction?",--选人界面的皮肤描述
        rarity = "T2",--品质描述
        raritycorlor = {120/255, 220/255, 255/255,1},--品质颜色
        skins = {normal_skin = "asakiri_skin2", ghost_skin = "ghost_asakiri_build"},
        skin_tags = {"ASAKIRI"},
    })

    MakeCharacterSkin("asakiri","asakiri_skin3",{
        name = "Deliverer",--皮肤名字
        des = "Nothing but some illusions.",--皮肤的描述
        quotes = "I'll put out your misery.",--选人界面的皮肤描述
        rarity = "T3",--品质描述
        raritycorlor = {255/255, 120/255, 120/255,1},--品质颜色
        skins = {normal_skin = "asakiri_skin3", ghost_skin = "ghost_asakiri_build"},
        skin_tags = {"ASAKIRI"},
    })
end