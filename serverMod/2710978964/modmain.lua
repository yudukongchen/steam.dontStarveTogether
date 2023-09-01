GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})
PrefabFiles = {
    "fishingsurprised", -- 钓起事件时的特效物品
    "artificial_atrium_gate", -- 钓起织影者的伪·大门
}

--测试模式
-- _G.CHEATS_ENABLED = true 
-- 是否是服务器
local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()
TUNING.ANTLION_DEAGGRO_DIST = 20 --超过4地皮多一点 蚁狮丢失仇恨
local pullup = GetModConfigData("pullup") or false --钓起物品
if IsServer then
    --------------------------模组设置-------------------------------
    GLOBAL.gambling_dog = GetModConfigData("no_crafting") or false
    GLOBAL.setsleeper = GetModConfigData("sleeper") or false
    GLOBAL.suffering = GetModConfigData("suffering") or false --受难模式
    GLOBAL.build = GetModConfigData("build") or false --钓起建筑
    GLOBAL.Bobbers = GetModConfigData("bobbers") or false --浮标影响概率
    GLOBAL.Gift_OF = GetModConfigData("gift") or false --开局礼物
    GLOBAL.Lightning = GetModConfigData("lightning") or false --闪电
    GLOBAL.RegularCleaning = GetModConfigData("regularcleaning") or -1 --定期清理
    TUNING.ATRIUM_GATE_COOLDOWN = (GetModConfigData("atriumgate") or 20) * TUNING.TOTAL_DAY_TIME

    if gambling_dog then
        modimport("scripts/gambling.lua")
    end

    ----------------------------------
    -- 加载受难模式
    if suffering then
        modimport("scripts/suffering.lua") 
        table.insert(PrefabFiles,"springlamp")
    end
    --------------------------------------------------------

    -- 覆盖本mod已设置的钓起物表
    HARVEST = HARVEST or nil
    -- 本mod, 钓起执行的方法
    TUNING.OCEANFISHINGROD_E = TUNING.OCEANFISHINGROD_E or {}
    TUNING.OCEANFISHINGROD_E.oceanfishingrod = require("event_table")
    TUNING.OCEANFISHINGROD_E.prefab_events = require("prefab_event_table")

    --[[ 
    --钓起后执行方法, 也可以不用, 直接写在下面 的 event 里
    TUNING.OCEANFISHINGROD_E = TUNING.OCEANFISHINGROD_E or {}
    TUNING.OCEANFISHINGROD_E.xxxx = { -- xxxx是自己命名，确保其他mod不同, 与下面的应该要保持一致
        funxxx = function(inst, player) --参数是: 物品 钓起玩家
        end
    }
    --设置额外钓起的内容
    TUNING.OCEANFISHINGROD_R = TUNING.OCEANFISHINGROD_R or {}
    TUNING.OCEANFISHINGROD_R.xxxx = { -- xxxx是自己命名，确保唯一性
        {
            chance = 1, -- 权重, 必填
            item = "log" or {"log"}, -- 名称,如果是物品,则为预制体名称, 必填, 通常名称不应该重复。
            name = "", -- 命名, 用于宣告, announce无需添加此项也会宣告。
            eventF = function(inst, player) end, -- 钓起时执行事件。
            eventA = function(inst, player) end, -- 钓起后执行事件。
            build = true, -- 钓起时是建筑, true 是建筑, 默认是物品。
            sleeper = true, -- 钓起时睡眠, true 是不睡觉, 默认睡眠。
            hatred = true, -- 钓起时仇恨玩家, true 是不仇恨, 默认仇恨。
            announce = true, -- 钓起时进行宣告, true 是宣告, 默认不宣告。
        },
        default = { -- 项参数默认值。 可有可无, 其他项对应参数为空时, 为其他项添加对应参数的默认值。
            build = ,
            sleeper = ,
            hatred = ,
            announce = ,
        }
    } 
    -- 说明:
    -- build, 即使是建筑, 不添加, 将视为物品一样被钓起, 生物也视为物品。
    -- sleeper hatred, 钓起物是生物才要添加。
    -- 事件也归为物品, 利用了 fishingsurprised 特效物品, 要执行的方法放到 eventF 或 eventA 里。
    --]]
    ---------------【公共方法】-----------------------------
    -- 大部分的其他设置
    modimport("scripts/overall.lua")
    -- 加载自动清理    
    modimport("scripts/clean.lua")
    ---------------【修改其他物品或组件】-----------------------------
    -- 大部分的其他设置
    modimport("scripts/modify/all_modify.lua")

    -- 相对多内容或者代码量大的会单独放一个文件里。
    -- 设置世界
    modimport("scripts/modify/world_modify.lua")

    -- 设置月兽相关内容
    modimport("scripts/modify/moonbeastspawner_modify.lua")

    -- 设置海钓竿
    modimport("scripts/modify/setoceanfishingrod.lua")

end

if pullup then
    --加载注册【钓东西】动作
    modimport("scripts/modify/pullup.lua")
end
-------------修改提示内容-------------------------------------------------------------------------------
local MOD_TIPS = {
    CS_TIPS1 = "不仅仅有初始岛屿，出海探险吧。岛屿很多，使用瓶子信可以查看。",
    CS_TIPS2 = "玩家绑定的海钓竿没了，可以捡起另一个，会自动绑定到新海钓竿。",
    CS_TIPS3 = "正常钓鱼，不会钓起随机物品，食物缺乏钓海鱼吧。",
    CS_TIPS4 = "别在家附近钓，可能会拆家的。",
    CS_TIPS5 = "随生存时间增加，钓到boss和建筑概率会提高。前3天不会钓到boss，放心。",
    CS_TIPS6 = "化石碎片机制更改了，白天是洞穴里的【复活的骨架】",
    CS_TIPS7 = "敲掉被击败的天体英雄，会自动清理掉之前存在的召唤天体英雄的组件。",
    CS_TIPS8 = "注意月圆月黑，是独立的掉落列表。",
    CS_TIPS9 = "阅读mod代码，可以自定义地图和扩展掉落物。",
    CS_TIPS10 = "船不会着火，但会被其他方法摧毁。有些钓起事件，躲船上比较安全。",
    CS_TIPS11 = "钓到一定数量，是会奖励黄金的。",
    CS_TIPS12 = "钓起了事件，沉着冷静面对。有的时候需要静如处子，有时候需要动如脱兔。",
    CS_TIPS13 = "开启了mod设置中【浮标可影响钓起内容】，海钓竿可以接受堆叠的物品，浮标们有特殊效果，检查它。\n【树枝】也是浮标。",
    CS_TIPS14 = "注意看mod设置的描述。",
    CS_TIPS15 = "发现了具有龙蝇的岛吗?小心流星。\n夏天在这里记得带上你的帽子。",
    CS_TIPS16 = "开启了清理了，前期可以利用背包来存放物品。地面上尽量别留物品。物品是一堆一堆清理。",
    CS_TIPS17 = "这个海钓世界里，存在着一个隐藏岛屿。开启方法藏在月儿弯主人所爱之人身上。",
    CS_TIPS18 = "猪哥：在天上的时候，走着到另一个岛了。",
    CS_TIPS19 = "遇到了饥饿值无了，脚下的食物别乱吃，可得留给队友^_^。",
    CS_TIPS20 = "秘密就是。。。",
}
STRINGS.UI.LOADING_SCREEN_OTHER_TIPS = STRINGS.UI.LOADING_SCREEN_OTHER_TIPS or {}
for k,v in pairs(MOD_TIPS) do
    STRINGS.UI.LOADING_SCREEN_OTHER_TIPS[k] = v
end

local tipcategorystartweights =
{
    CONTROLS = 0,
    SURVIVAL = 0,
    LORE = 0,
    LOADING_SCREEN = 0,
    OTHER = 0.2,
}

SetLoadingTipCategoryWeights(LOADING_SCREEN_TIP_CATEGORY_WEIGHTS_START, tipcategorystartweights)

local tipcategoryendweights =
{
    CONTROLS = 0,
    SURVIVAL = 0,
    LORE = 0,
    LOADING_SCREEN = 0,
    OTHER = 0.5,
}
SetLoadingTipCategoryWeights(LOADING_SCREEN_TIP_CATEGORY_WEIGHTS_END, tipcategoryendweights)

GLOBAL.TheLoadingTips = require("loadingtipsdata")()
GLOBAL.TheLoadingTips.loadingtipweights = GLOBAL.TheLoadingTips:CalculateLoadingTipWeights()
GLOBAL.TheLoadingTips.categoryweights = GLOBAL.TheLoadingTips:CalculateCategoryWeights()
GLOBAL.TheLoadingTips:Load()

-----------------------------------
-- 对玩家进行更改
AddPlayerPostInit(function(inst)
    -- inst.fishnumber = net_ushortint(inst.GUID, "fishnumber") --钓鱼次数 后续可能有用

    if TheWorld.ismastersim then --仅服务器添加
        inst:AddComponent("modnewbuff") --作用自身的buff组件
        inst:AddComponent("healthlink") --单向生命链接
        inst:AddComponent("bindingoceanfishingrod") --绑定海钓竿
    end  
    if inst.components.oldager then --单向生命链接可以作用到旺达身上了
        inst.components.oldager:AddValidHealingCause("healthlink") -- 可以作用到旺达身上
    end 
end)
--夜晚变月圆月黑让客户端也发生变化
AddPrefabPostInit("forest_network", function(inst)
    --主客端都改变
    inst.of_moon = net_string(inst.GUID, "worldstate.of_isfullmoon","of_isfullmoon")
    inst:ListenForEvent("of_isfullmoon",function(inst)
        if inst.of_moon:value() == "full" then
            TheWorld:PushEvent("moonphasechanged2", {moonphase = "full", waxing = true})
        elseif inst.of_moon:value() == "new" then
            TheWorld:PushEvent("moonphasechanged2", {moonphase = "new", waxing = true})
        end
    end)  
    inst:AddComponent("nightmareclock") --添加梦魇时钟
end)
--------------------------------------------------------------------------------------
-- 以下测试时使用的代码

-- 测试用代码,目的是使角色无视海岸限制,可以水上行走
-- AddPlayerPostInit(function(inst)
--     if inst.components.drownable ~= nil then
--         inst.components.drownable.enabled = false                   --关闭溺水
--         inst.Physics:ClearCollisionMask()                           --Physics物理 清除碰撞遮罩
--         inst.Physics:CollidesWith(COLLISION.GROUND)                 --与地面碰撞
--         inst.Physics:CollidesWith(COLLISION.OBSTACLES)              --与障碍物碰撞
--         inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)         --与小型障碍物碰撞
--         inst.Physics:CollidesWith(COLLISION.CHARACTERS)             --与人物碰撞
--         inst.Physics:CollidesWith(COLLISION.GIANTS)                 --与巨人(有boss)碰撞
--     end
--     --[[
--     inst:DoTaskInTime(1,function(inst)
--         -- TheWorld.Map:RebuildLayer(GROUND.DIRT,TheWorld.Map:GetTileCoordsAtPoint(inst.Transform:GetWorldPosition()))
--         -- local a,b,c = ThePlayer.Transform:GetWorldPosition()
--         local x, y = TheWorld.Map:GetTileCoordsAtPoint(0, 30, 0)
--         local oldType = TheWorld.Map:GetTileAtPoint(0, 30, 0)
--         TheWorld.Map:SetTile(x, y,GROUND.DIRT)
--         -- TheWorld.Map:RebuildLayer(oldType, x, y)
--         TheWorld.Map:RebuildLayer(GROUND.DIRT, x, y)
--         TheWorld.minimap.MiniMap:RebuildLayer(GROUND.DIRT, x, y)
--     end)
--     ]]
    
-- --[[    inst:DoTaskInTime(2,function()  -- 查看节点坐标，显示在地图
--         if inst.player_classified ~= nil then
--             for k,i in pairs(TheWorld.topology.lands) do --TheWorld.topology.nodes
--                 local node = TheWorld.topology.nodes[i]
--                 local x,z = node.x,node.y -- math.random(1,800) * (math.random() > 0.5 and -1 or 1),math.random(1,800) * (math.random() > 0.5 and -1 or 1)
--                 inst.player_classified.revealmapspot_worldx:set(x) --揭示世界的地图
--                 inst.player_classified.revealmapspot_worldz:set(z)
--                 inst.player_classified.revealmapspotevent:push() --显示pot事件的地图

--                 inst:DoStaticTaskInTime(4*1/30, function()
--                     inst.player_classified.MapExplorer:RevealArea(x, 0, z, true, true) --地图浏览器 显露区域
--                 end)
--             end  
--         end
--     end)--]]
-- end)



-- shadowrift_portal 裂缝

--TheShard:IsPlayer()   -- 返回是否为 代理玩家  【服务端false  主机true】


-- AddPrefabPostInit("world",function(inst)
--     inst:DoTaskInTime(0, function(inst)
--         for k,v in pairs(TheWorld.topology.nodes) do
--             local moom = SpawnPrefab("moonbase")
--             moom.Transform:SetPosition(v.x,0,v.y)
--             moom.persists=false
--             print("----------------")
--             print("区域",v.area, TheWorld.topology.ids[k])
--             print("中心点",v.cent[1],v.cent[2])
--             for k1,v1 in pairs(v.poly) do
--                 local moom2 = SpawnPrefab("homesign")
--                 moom2.Transform:SetPosition(v1[1],0,v1[2])
--                 moom2.persists=false
--                 print("多边形",k1,v1[1],v1[2])
--             end
--             for k1,v1 in pairs(v.validedges) do
--                 print("有效边",k1,v1)
--             end
--         end
--         for k,v in pairs(TheWorld.topology.edges) do
--             print("边",k,v.n1,v.n2)
--         end
--     end)
-- end)
