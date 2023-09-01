-- require("method")
local data = require("event_data")


local function spawnAtGround(name, x,y,z, ignore_ocean)
    if ignore_ocean or TheWorld.Map:IsPassableAtPoint(x, y, z,false,true) then
        local item = SpawnPrefab(name)
        if item then
            item.Transform:SetPosition(x, y, z)
            return item
        end
    end
end

-- 物品位置, 半径, 几等分, 对象表, 将要执行的方法 是否忽略海洋 是否逆时针 最多绘制百分之几的圆 偏转几度 圆心偏离x 圆心偏离z
local function circular(target, r, num, lsit, fn, ignore_ocean, isreverse, angleE, def, _x, _z)
    if target == nil or lsit == nil or #lsit <= 0 then return end 
    local x,y,z = target.Transform:GetWorldPosition()
    local d_x = _x or 0
    local d_z = _z or 0
    for k=1,num do
        local angle = angleE and (k * angleE * 2 * PI / num) or (k * 2 * PI / num) --用弧度求角度, 例 弧度2*PI = 角度360
        if def then angle = angle + def end
        local item = isreverse and 
            spawnAtGround(lsit[math.random(#lsit)], r*math.cos(angle)+x+d_x, 0, r*math.sin(angle)+z+d_z, ignore_ocean) or
            spawnAtGround(lsit[math.random(#lsit)], r*math.sin(angle)+x+d_x, 0, r*math.cos(angle)+z+d_z, ignore_ocean) --利用极坐标画圆
        if item ~= nil and fn ~= nil and type(fn) == "function" then 
            fn(item, target, k)
        end
    end
end

local function Passable(player)
    local x,y,z = player.Transform:GetWorldPosition()
    if TheWorld.Map:IsPassableAtPoint(x,y,z,false,true) then
        return true
    end
end

local function PushEvent(name)
    player:PushEvent("accident", name)
    TheWorld:PushEvent("accident", name)
end
-----------------------------------------------------------------------------------------------------

local function weatherchanged(inst, player)
    if TheWorld.state.israining or TheWorld.state.issnowing then --如果在下雨或者下雪
        TheWorld:PushEvent("ms_forceprecipitation", false)
    else
        TheWorld:PushEvent("ms_forceprecipitation", true)
    end

    -- 宣告
    -- announce(player,"阴晴不定")
    player:PushEvent("accident", "weatherchanged")
end

local function rockcircle(inst, player)
	local items = data.rockcircle
    if TheWorld.state.iswinter then --冬天才能出冰川
        items = {"rock_ice"}
    end
	circular(player,6,10,items)
	-- announce(player, "岩石怪圈")
    player:PushEvent("accident", "rockcircle")
end

local function campfirecircle(inst, player)
	local items = {"campfire","coldfire"}
    if TheWorld.state.iswinter then
        items = {"coldfire"}
    end
	circular(player,2,10,items)
	-- announce(player, "营火晚会")
    player:PushEvent("accident", "campfirecircle")
end

local function monstercircle(inst, player)
    local items = data.monstercircle
    circular(player,4,math.random(4,9),items,function(inst, target)
    	if target ~= nil and inst.components.combat then
    		inst.components.combat:SuggestTarget(target) --仇恨
    	end
	end)
	-- announce(player, "生物怪圈")
    player:PushEvent("accident", "monstercircle")
end
local function maxwellcircle(inst, player)
    circular(player,2,10,{"trap_teeth_maxwell"})
    circular(player,2.5,14,{"trap_teeth_maxwell"})
    player:PushEvent("accident", "maxwellcircle")
end

local function chest(inst, player)
    local prefab = inst.prefab
    local items = nil
    if prefab == "treasurechest" then
        items = data.chest.treasurechest
    elseif prefab == "pandoraschest" then 
        items = data.chest.pandoraschest
    elseif prefab == "dragonflychest" then
        items = data.chest.dragonflychest
    elseif prefab == "minotaurchest" then
        items = data.chest.minotaurchest
    else --其他箱子
        items = data.chest.other
    end
    if inst.components.workable then inst:RemoveComponent("workable") end --不能被敲
    if inst.components.burnable then inst:RemoveComponent("burnable") end --移除燃烧属性   
    inst.persists = false --退出时不会保存
    inst:DoTaskInTime(60, inst.Remove) --到60s清理掉
    -- announce(player, inst:GetDisplayName())
    if items == nil and type(items) ~= "table" and #items <= 0 then return end
    for _,name in pairs(table.randomrepea(items, math.random(3,9))) do
        local giveItem = SpawnPrefab(name)
        if inst.components.container then --箱子容器组件存在，添加到箱子里
            inst.components.container:GiveItem(giveItem)
        end  
    end
    inst.AnimState:OverrideMultColour(1, 0, 0, 1)
    player:PushEvent("accident", "chest")
end

local function lightningTarget(inst, player)  --天雷陷阱方法，10道雷，分布在玩家1-5单位距离范围内(1块地皮大小4*4)
    
    if not Lightning then return end 

    local pt = player:GetPosition() --不要带到其他地方
    player:StartThread(function()  --开启线程
        -- local x,y,z = player.Transform:GetWorldPosition() 
        local num = 10
        for k = 1, num do
            local r = math.random(1, 5)
            local angle = k * 2 * PI / num
            -- local pos = Point(r*math.cos(angle)+x, y, r*math.sin(angle)+z)
            local pos = pt + Vector3(r * math.cos(angle), 0, r * math.sin(angle))
            TheWorld:PushEvent("ms_sendlightningstrike", pos) --触发天雷事件(饥荒自带的降雷),提供坐标
            Sleep(.2 + math.random())
        end
    end)
    player:PushEvent("accident", "lightningTarget")
end

local function celestialfury(inst, player)
    player:StartThread(function()  --开启线程
        local num = 5
        for k = 1, num do 
            for j = 1, 3 do
                local x,y,z = player.Transform:GetWorldPosition()
                local r = math.random(1, 4)
                local angle = j * 2 * PI / 3
                spawnAtGround("alterguardian_phase2spike", r*math.cos(angle)+x,y,r*math.sin(angle)+z)
                Sleep(0.25)
            end
            local x,y,z = player.Transform:GetWorldPosition()
            local r = math.random(1, 4)
            local angle = k * 2 * PI / num
            spawnAtGround("alterguardian_phase3trapprojectile",r*math.cos(angle)+x,y,r*math.sin(angle)+z)
            Sleep(math.random())
        end
    end)
    player:PushEvent("accident", "celestialfury")
end

local function gunpowdercircle(inst, player)
    local arm = SpawnPrefab("armormarble") --替换为大理石甲
    player.components.inventory:Equip(arm)
    local x,y,z = player.Transform:GetWorldPosition()
    local num=4
    for k=1,num do
        local item = spawnAtGround("gunpowder", x,y,z)
        if item then
            item.components.explosive:OnBurnt()
        end
    end
    player:PushEvent("accident", "gunpowdercircle")
end
local function getplayer(inst, player)
    local items = data.getplayer
    inst:DoTaskInTime(180,function(inst) inst:Remove() end)
    if inst.components.health then --设置生命上限, 容易弄死, 好掉落东西
        inst.components.health:SetMaxHealth(10)
    end
    if inst.components.inventory then --放一些东西
        local max = math.random(1,5)
        for k = 1, max do
            inst.components.inventory:GiveItem(SpawnPrefab(items[math.random(#items)]))
        end
    end
    player:PushEvent("accident", "getplayer")
end


local function onAddHun(inst, player) --啜食
    if player.components.modnewbuff then 
        player.components.modnewbuff:StartTimer("OnAddHun",10,0,1,0) -- 持续10秒
    end    
    player:PushEvent("accident", "onAddHun")
end

local function onAddSan(inst, player) --降智
    if player.components.modnewbuff then
        player.components.modnewbuff:StartTimer("OnAddSan",10,0,1,0) -- 持续10秒
    end    
    player:PushEvent("accident", "onAddSan")
end

local function onAddHp(inst, player) --流血
    if player.components.modnewbuff then
        player.components.modnewbuff:StartTimer("OnAddHp",10,0,1,0) -- 持续10秒
    end    
    player:PushEvent("accident", "onAddHp")
end

local shadow_boss = {"shadow_rook","shadow_knight","shadow_bishop"}
local function shadow_level(inst, player) --暗影陷阱 暗影基佬随机等级 
    local shadow = SpawnPrefab(shadow_boss[math.random(#shadow_boss)])
    shadow.Transform:SetPosition(player.Transform:GetWorldPosition())
    shadow:DoTaskInTime(0,function(inst)
        shadow:LevelUp(math.random(3))
    end)
    player:PushEvent("accident", "shadow_level")
end

local function healthlink(inst, player)
    -- print("触发事件的玩家",player)
    if player.components.healthlink == nil then
        player:AddComponent("healthlink")
    end
    player.components.healthlink:AddTarget()

    player:PushEvent("accident", "healthlink")
end

local function caveinobstacle(inst, player) -- 柱！柱！柱！
    -- player:StartThread(function()  --开启线程
    --     for i=1, math.random(4,6) do
    --         player:DoTaskInTime(0.75+math.random()*.5, function(inst)
    --             local x,y,z = inst.Transform:GetWorldPosition()
    --             local item = spawnAtGround("ruins_cavein_obstacle",x+math.random()*2,0,y+math.random()*2, true)
    --             if not item then return end 
    --             item.fall(item,Vector3(inst.Transform:GetWorldPosition()))
    --         end)
    --     end
    -- end)   
    SpawnGrowTheGround(player, 0.45,
        {{chance = 0.5, item = "ruins_cavein_obstacle", fn = function(i,x,y,z) i.fall(i,Vector3(x,y,z)) end}}, 
        math.random(4,6), 2.25)
    player:PushEvent("accident", "caveinobstacle")
end

local function sporecloud(inst, player) -- 多重孢子云
    player:StartThread(function()  --开启线程
        for i=1, math.random(1,3) do
            player:DoTaskInTime(1+(math.random()*2), function(inst)
                local sporecloud = SpawnPrefab("sporecloud")
                sporecloud.Transform:SetPosition(inst.Transform:GetWorldPosition())
            end)
        end
    end)
    player:PushEvent("accident","sporecloud")
end

local NO_REMOVE = {"player","INLIMBO","irreplaceable","shadowcreature","farm_plant","_combat",
                 "locomotor","boat","FX","NOBLOCK","NOCLICK","multiplayer_portal" }
local function removeitems(inst, player) --清理物品
    local x,y,z = player.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x,y,z,10,nil,NO_REMOVE)
    if ents ~= nil then
        for k,v in pairs(ents) do
            v:Remove()
        end
    end
    player:PushEvent("accident", "removeitems")
end

local function hedgehounds(inst, player) --蔷薇陷阱
    circular(player,4,math.random(4,5),{"hedgehound_bush"},function(inst, target)
        if target ~= nil and inst.components.combat then
            inst.components.combat:SuggestTarget(target) --仇恨
        end
    end)
    circular(player,6,math.random(4,6),{"hedgehound"},function(inst, target)
        if target ~= nil and inst.components.combat then
            inst.components.combat:SuggestTarget(target) --仇恨
        end
    end)

    player:PushEvent("accident", "hedgehounds")
end

local taozuan = {
    {"minerhat","sweatervest"}, -- 矿工套
    {"flowerhat","hawaiianshirt","grass_umbrella"}, -- 休闲套
    {"wathgrithrhat","spear_wathgrithr"}, -- 战斗套
    {"kelphat","trident"}, -- 海王套
    {"armor_sanity","nightsword"}, --暗夜套
    {"lunarplanthat","armor_lunarplant"}, --亮茄套
    {"voidclothhat","armor_voidcloth"}, --虚空套
    {"armordreadstone","dreadstonehat"}, --绝望石套
    {"shieldofterror","eyemaskhat"}, --恐怖套
    {"featherhat","hawaiianshirt"}, --夏威夷套
}
local function sewing_mannequin(inst, player) --假人装备
    local gl = math.random()
    if gl < 0.05 then return end --没有装备
    if gl < 0.45 then -- 随机数量随机着装
        local wp = data.sewing_mannequin
        
        local function sj(t)
            local item = spawnAtGround(t[math.random(#t)],0,0,0)
            if item then 
                inst.components.inventory:Equip(item)
            end
        end
        -- 保底一件
        if math.random() > 0.33 then
            sj(wp[2])
        end
        if math.random() > 0.33 then
            sj(wp[3])
        end
        sj(wp[1])

        return 
    end

    for k,v in pairs( taozuan[math.random(#taozuan)] ) do
        local item = spawnAtGround(v,0,0,0)
        if item then 
            inst.components.inventory:Equip(item)
        end
    end

    player:PushEvent("accident", "sewing_mannequin")
end
local function ghost_circle(inst, player) --鬼魂陷阱
    local x, y, z = player.Transform:GetWorldPosition()
    local num = 5
    for k=1,num do
        local angle = k * 2 * PI / num
        local item = spawnAtGround("ghost", 2*math.cos(angle)+x, y, 2*math.sin(angle)+z, true)
        if player ~= nil and item ~= nil then
            item.components.combat:SuggestTarget(player)
        end
    end

    player:PushEvent("accident", "ghost_circle")
end

local function lethargy(inst, player) --昏睡陷阱
    local x, y, z = player.Transform:GetWorldPosition()
    spawnAtGround("spore_small",x,y,z)
    player:StartThread(function()
        local num = 15
        for k=1,num do
            local x,y,z = player.Transform:GetWorldPosition()
            local r = math.random(2, 2)
            local angle = math.random(0,360)--k * 2 * PI / num
            spawnAtGround("gestalt_alterguardian_projectile", r*math.cos(angle)+x, y, r*math.sin(angle)+z)
            Sleep(math.random(20, 100)*0.01)
        end
    end)

    player:PushEvent("accident", "lethargy")
end

local function sanityempty(inst, player) --理智全无
    local arm = SpawnPrefab("purpleamulet") --替换为噩梦护符
    player.components.inventory:Equip(arm)
    player.components.sanity:DoDelta(-50)

    player:PushEvent("accident", "sanityempty")
end
-- 饥饿为0 给个毒火鸡正餐 加血变为扣血
local function turkey(inst, player) --毒计？鸡
    local x, y, z = player.Transform:GetWorldPosition()
    local item = spawnAtGround("turkeydinner",x,y,z)
    if item then item.components.edible.healthvalue = -20 end
    player.components.hunger:DoDelta(-9999)

    player:PushEvent("accident", "turkey")
end

local function dropequip(inst, player) --卸甲归田
    for k,v in pairs(player.components.inventory.equipslots) do
        player.components.inventory:DropItem(v)
    end

    player:PushEvent("accident", "dropequip")
end

-- 随机一样库存中的物品 藏到 宝藏里
local function stashloot(inst, player) --遗失宝藏
    local items = {}
    for k = 1, player.components.inventory.maxslots do --全部遍历一遍，获取存在的物品槽位
        local v = player.components.inventory.itemslots[k] 
        if v ~= nil then
            table.insert(items, v)
        end
    end
    if #items > 0 then --随机一项
        local item = items[math.random(#items)]
        if TheWorld.components.piratespawner then
            TheWorld.components.piratespawner:StashLoot(item)
            TheNet:Announce(player:GetDisplayName().."遗失了 "..(item:GetDisplayName() or item))
        end        
    end
    local x, y, z = player.Transform:GetWorldPosition()
    spawnAtGround("stash_map",x,y,z)

    player:PushEvent("accident", "stashloot")
end

local function seasonchange(inst, player)
    local names = {"spring","summer","autumn","winter"}
    local index = math.random(#names)
    TheWorld:PushEvent("ms_setseason", names[index])

    player:PushEvent("accident", "seasonchange")
end

local function shadowthrall(inst, player)
    local x, y, z = player.Transform:GetWorldPosition()
    local hands = spawnAtGround("shadowthrall_hands", x+6,y,z+6, true)
    local horns =spawnAtGround("shadowthrall_horns", x-3,y,z+5.2, true)
    local wings =spawnAtGround("shadowthrall_wings", x-3,y,z-5.2, true)
    if hands.components.entitytracker ~= nil then
        hands.components.entitytracker:TrackEntity("horns", horns)
        hands.components.entitytracker:TrackEntity("wings", wings)
    end
    if horns.components.entitytracker ~= nil then
        horns.components.entitytracker:TrackEntity("hands", hands)
        horns.components.entitytracker:TrackEntity("wings", wings)
    end
    if wings.components.entitytracker ~= nil then
        wings.components.entitytracker:TrackEntity("hands", hands)
        wings.components.entitytracker:TrackEntity("horns", horns)
    end
    player:PushEvent("accident", "shadowthrall")
end


local function spawnwaves(inst, player, target)
    SpawnAttackWaves(
        target:GetPosition(),
        nil,
        nil,
        6,
        360,
        4,
        nil,
        2,
        nil
    )

    player:PushEvent("accident", "spawnwaves")
end
local function deciduous(inst, player)
    player:StartThread(function()  --开启线程
        circular(player,4,10,{"deciduous_root"},nil,true)
        Sleep(.5 + math.random())
        circular(player,8,18,{"deciduous_root"},nil,true)
        Sleep(.5 + math.random())
        circular(player,4,10,{"deciduous_root"},nil,true)
    end)

    player:PushEvent("accident", "deciduous")
end

local function refusefish(inst, player)
    player:AddTag("refusefish")
    player:DoTaskInTime(30*2, function(player)
        player:RemoveTag("refusefish")
    end)

    player:PushEvent("accident", "refusefish")
end

-- 移形换影 互相交换位置 
local function transformation(inst, player)
    local closestPlayer = {}
    for i, v in ipairs(AllPlayers) do
        if v and v.entity:IsVisible() and v.userid ~= player.userid and Passable(v) then --目标不是自己 且目标没有链接自己
            table.insert(closestPlayer,v)
        end
    end
    if #closestPlayer > 0 then
        local target = closestPlayer[math.random(#closestPlayer)]
        local target_x, target_y, target_z = target.Transform:GetWorldPosition()
        local x, y, z = player.Transform:GetWorldPosition()
        player.Transform:SetPosition(target_x, target_y, target_z)
        target.Transform:SetPosition(x, y, z)
    else
        --还是算了 【没有直接传送到大门】
    end
    player:PushEvent("accident", "transformation")
end

-- 兔吃曼草 背包里兔子吃曼德拉草
local function rabbiteater(inst, player)
    local tz = SpawnPrefab("rabbit")
    tz.Transform:SetPosition(player.Transform:GetWorldPosition())
    local md = SpawnPrefab("mandrake")
    tz.components.eater:Eat(md, player)
    player.components.inventory:GiveItem(tz)
    player:PushEvent("accident", "rabbiteater")
end

--奇怪的雨
local function debrisitems(inst, player)
    SpawnDebrisLoots(player, 0.1, data.debrisitems, math.random(20,35), 20) --5格地皮范围内
    player:PushEvent("accident", "debrisitems")
end

--升天
local function ascension(inst, player)
    local x, y, z = player.Transform:GetWorldPosition()
    player.Transform:SetPosition(x, 35, z)
    if player.components.drownable ~= nil then
        player.components.drownable.enabled = false --关闭溺水
    end
    player.Physics:SetDamping(.99)
    player:AddTag("refusefish") --禁止钓鱼 防止发生奇怪的事情
    player.ascensiontask = player:DoPeriodicTask(FRAMES, function(player) 
        local x, y, z = player.Transform:GetWorldPosition()
        if y <= 0.35 then
            if player.components.drownable ~= nil then --开启溺水
                player.components.drownable.enabled = true
            end
            player.Physics:SetDamping(5)
            player:RemoveTag("refusefish")
            player.ascensiontask:Cancel()
            player.ascensiontask = nil
        else
            if y <= 2 then
                player.Physics:SetMotorVel(0, 0, 0)
            end
        end
    end)
    player:PushEvent("accident", "ascension")
end
-- 大范围冰冻
local function allfreezable(inst, player, target)
    local x, y, z = target.Transform:GetWorldPosition()
    local function onfreeze(inst, v)
        if not v:IsValid() then
            return
        end

        if v.components.burnable ~= nil then
            if v.components.burnable:IsBurning() then--灭火
                v.components.burnable:Extinguish()
            elseif v.components.burnable:IsSmoldering() then
                v.components.burnable:SmotherSmolder()
            end
        end

        if v.components.freezable ~= nil then
            v.components.freezable:AddColdness(10,10) --冻结层数10 冻结时间10s
            v.components.freezable:SpawnShatterFX()
        end
    end
    local ents = TheSim:FindEntities(x, y, z, 4*6, nil, {"crabking_claw","crabking", "shadow", "ghost", "playerghost", "FX", "NOCLICK", "DECOR", "INLIMBO"})
    for i,v in pairs(ents)do
        onfreeze(inst, v)
    end
    local fx = SpawnPrefab("crabking_ring_fx")
    fx.Transform:SetPosition(x, y, z)
    fx.Transform:SetScale(1.5,1.5,1.5)
    player:PushEvent("accident", "allfreezable")
end
-- 蚁狮陷阱
local function sand(inst, player, target)
    circular(player,6,14,{"sandblock"})
    SpawnGrowTheGround(player, 0.2,
        {{chance = 0.5, item = "sandspike"},
        {chance = 0.001, item = "sandblock"}}, 
        math.random(20,35), 6)
    player:PushEvent("accident", "sand")
end
-- 超多的陷阱 最好办法在船上等待一下
local function supermany(inst, player, target)
    SpawnGrowTheGround(player, 0.3,
        {
            {chance = 0.6, item = "sandspike"},--沙刺
            {chance = 0.5, item = "houndfire"},--火
            {chance = 0.3, item = "sandblock"},--沙堡
            {chance = 0.5, item = "sporecloud"},--孢子云
            {chance = 0.5, item = "tornado"},--龙卷风
            {chance = 0.5, item = "deciduous_root"},--桦栗树 鞭子
            {chance = 0.3, item = "fused_shadeling_quickfuse_bomb"},--绝望螨 不分裂
            {chance = 0.5, item = "mushroombomb"}, --炸弹蘑菇
            {chance = 0.6, item = "mushroombomb_dark"}, --悲惨的炸弹蘑菇
            {chance = 0.5, item = "moonspider_spike"}, --月亮蜘蛛钉
            {chance = 0.5, item = "trap_teeth_maxwell"}, --麦斯威尔的犬牙陷阱
            {chance = 0.4, item = "beemine_maxwell"}, --麦斯威尔的蚊子陷阱
            {chance = 0.5, item = "wave_med"}, --海浪
            {chance = 0.3, item = "ruins_cavein_obstacle", fn = function(i,x,y,z) i.fall(i,Vector3(x,y,z)) end}, --块状废墟
            {chance = 0.4, item = "bigshadowtentacle"}, --守护者暗影触手
            {chance = 0.2, item = "shadowmeteor"}, --流星
            {chance = 0.4, item = "fossilspike2"}, --化石骨刺
            {chance = 0.3, item = "fossilspike"}, --化石笼子
            {chance = 0.1, item = "moonstorm_spark"}, --月熠 alterguardian_phase3trapprojectile
            {chance = 0.1, item = "spore_moon"}, --月亮孢子
            {chance = 0.3, item = "alterguardian_phase3trapprojectile"}, --落下的启迪陷阱
            {chance = 0.3, item = "alterguardian_laser", fn = function(i,x,y,z) i:Trigger(0.5) end}, --激光
        }, 
        math.random(15,35), 8)
    player:PushEvent("accident", "supermany")
end

-- 青蛙雨 有概率掉鱼人
local function frograin(inst, player, target)
    SpawnDebrisLoots(player, 0.75, {
        {chance = 5, item = "frog"},--青蛙
        {chance = 0.5, item = "merm"},--鱼人
    }, math.random(20,35), 25) --6格地皮范围内
    player:PushEvent("accident", "frograin")
end
-- 相控阵激光 调整为相对好躲避 向后移动 小心船体
local function alterguardian_laser(inst, player, target)
    local al = SpawnPrefab("alterguardian_laser")
    al.Transform:SetPosition(player.Transform:GetWorldPosition())
    al:Trigger(1.25)
    circular(player,4,15,{"alterguardian_laser"},function(inst2,p,i) inst2:Trigger(i*FRAMES) end, true, false, 0.7)
    circular(player,2,10,{"alterguardian_laser"},function(inst2,p,i) inst2:Trigger(i*FRAMES) end, true, true, 0.7, math.random()*360)
    player:PushEvent("accident", "alterguardian_laser")
end
local function mushroombomb(inst, player)
    circular(player,4,math.random(7,11),{"mushroombomb","mushroombomb_dark"},nil,true)

    player:PushEvent("accident", "mushroombomb")
end

local function mushroom(inst, player)
    circular(player,10,math.random(7,11),{"blue_mushroom","green_mushroom","red_mushroom"},nil)

    player:PushEvent("accident", "mushroombomb")
end

-- 骨牢骨刺
local function fossilspike(inst, player, target)
    circular(player,4,8,{"fossilspike"},nil, true)
    circular(player,3.5,15,{"fossilspike2"},function(inst2,p,i) inst2:RestartSpike(i*FRAMES) end, true, false, math.random(45,75)*.01,math.random()*360,math.random(-20,20)*.1,math.random(-20,20)*.1)
    circular(player,1.75,10,{"fossilspike2"},function(inst2,p,i) inst2:RestartSpike(i*FRAMES) end, true, true, math.random(45,75)*.01,math.random()*360,math.random(-10,10)*.1,math.random(-10,10)*.1)
    player:PushEvent("accident", "alterguardian_laser")
end

local function areaaware_abnormal(inst, player, target)
    local x, y, z = player.Transform:GetWorldPosition()
    local node, node_index = TheWorld.Map:FindVisualNodeAtPoint(x, y, z)
    if node == nil then return end
    if node.tags == nil then node.tags = {} end

    local tag = "lunacyarea"
    if TheWorld.state.issummer then --是不是夏天
        tag = "sandstorm"
    end

    if table.contains(node.tags,tag) then
        return 
    end
    local id = TheWorld.topology.ids[node_index]
    if TheWorld.task_maptags == nil then TheWorld.task_maptags = {} end
    if TheWorld.task_maptags[id] ~= nil then TheWorld.task_maptags[id]:Cancel() end
    
    TheWorld.task_maptags[id] = TheWorld:DoTaskInTime(240,function(word)
        TheWorld.task_maptags[id]:Cancel()
        TheWorld.task_maptags[id] = nil
        table.removetablevalue(node.tags,tag)
        player.components.areaaware.current_area = -1
    end)
    --钓起者移动一下下 就可以更新了。至于其他玩家 只能是离开该区域再返回才能起效果
    table.insert(node.tags,tag)
    player.components.areaaware.current_area = -1

    player:PushEvent("accident", "areaaware_abnormal")
end
-- 变大
local function super_big(inst, player, target)
    if player.super_big_task ~= nil then player.super_big_task:Cancel() end
    player.super_big_task = player:DoTaskInTime(60,function(word)
        player.super_big_task:Cancel()
        player.super_big_task = nil
        player.Transform:SetScale(1,1,1)
    end)
    player.Transform:SetScale(2.5,2.5,2.5)
    player:PushEvent("accident", "super_big")
end

-- local must_have_tags = {"player","INLIMBO","DECOR", "boat","FX","NOBLOCK","NOCLICK","playerghost"}
local cant_have_tags = {"player","INLIMBO","DECOR", "boat","FX","NOBLOCK","NOCLICK","playerghost","CLASSIFIED","rotatableobject"}
local TARGET_ONEOF_TAGS = { "animal", "character", "monster", "shadowminion", "smallcreature" }
local function p_combat(inst, player)
    local x, y, z = player.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 4*10, nil, cant_have_tags,TARGET_ONEOF_TAGS) --10地皮范围内
    local h = 0
    local target = nil
    for i, v in ipairs(ents) do
        if v and v.components.health and (v.components.health.currenthealth > h) then --找一下血厚的
            h = v.components.health.currenthealth
            target = v
        end
    end
    if target then
        local pos = target:GetPosition()
        local offset = FindWalkableOffset(pos, 2*PI*math.random(), 2, 8, true, true, nil, false, true)
        if offset ~= nil then --周围能够有位置传送存在
            player.Transform:SetPosition(offset.x + pos.x,0,offset.z + pos.z)
        end
        -- 能战斗就瞄准
        if target.components.combat then
            target.components.combat:SuggestTarget(player)
        end
    end
    player:PushEvent("accident", "p_combat")
end

-- 触手陷阱
local function tentacle_kl(inst, player)
    local items = {"tentacle","bigshadowtentacle"}
    circular(player,4,9,items)

    player:PushEvent("accident", "tentacle_kl")
end

-- 蝙蝠军团 增强的蝙蝠
local function bat_eye(inst, player)
    local items = {"bat"}
    circular(player,4,6,items,function(b,target)
        b:OnIsAcidRaining(true) 
        if target ~= nil and b.components.combat then
            b.components.combat:SuggestTarget(target) --仇恨
        end
    end,true)

    player:PushEvent("accident", "bat_eye")
end

-- 变小
local function super_small(inst, player, target)
    if player.super_big_task ~= nil then player.super_big_task:Cancel() end
    player.super_big_task = player:DoTaskInTime(60,function(word)
        player.super_big_task:Cancel()
        player.super_big_task = nil
        player.Transform:SetScale(1,1,1)
    end)
    player.Transform:SetScale(0.25,0.25,0.25)

    player:PushEvent("accident", "super_small")
end
-- 杂草禁锢
local function weed_imprison(inst, player)
    local x, y, z = player.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 20, nil, {"playerghost","plantkin"},{"player","animal", "character", "monster"}) --5地皮范围内
    if ents~=nil then
        for i, target in ipairs(ents) do
            local islarge = target:HasTag("largecreature")
            local r = target:GetPhysicsRadius(0) + (islarge and 1.4 or .4)
            local num = islarge and 12 or 6
            circular(target,r,num,{"ivy_snare"},function(snare,target)
                snare.target = target
                snare.target_max_dist = r + 1.0
                snare:RestartSnare(.2 + math.random(-1,1) * .2)
                snare:DoTaskInTime(5,function() snare.components.health:Kill() end)
            end)
        end
    end

    player:PushEvent("accident", "weed_imprison")
end
--一拳小超人
local function onefistsuperman(inst, player)
    local function onattackJ(inst, data)
        if data.weapon ~= nil then return end --必须赤手空拳打
        data.target.components.health:DoDelta(-999)
        player:RemoveEventCallback("onattackother", onattackJ)
    end
    player:ListenForEvent("onattackother", onattackJ)

    player:PushEvent("accident", "weed_imprison")
end
--天使赐福
local function angel_blessing(inst, player)
    player.components.health:DoDelta(999)
    player.components.sanity:DoDelta(999)
    player.components.hunger:DoDelta(999)
    player:PushEvent("accident", "weed_imprison")
end
--还你飘飘拳
local function returnonattack(inst, player)
    local function onattackA(inst, data)
        if data.weapon ~= nil then return end --必须赤手空拳打
        data.target.components.health:DoDelta(999)
        player:RemoveEventCallback("onattackother", onattackA)
    end
    player:ListenForEvent("onattackother", onattackA)

    player:PushEvent("accident", "weed_imprison")
end

local function deltapenalty(inst, player)
    -- 获取默认扣除血上限的数据 溺水的时候也是这样
    local tunings = TUNING.DROWNING_DAMAGE[string.upper(player.prefab)] or TUNING.DROWNING_DAMAGE[player:HasTag("player") and "DEFAULT" or "CREATURE"]
    if tunings.HEALTH_PENALTY ~= nil then
        player.components.health:DeltaPenalty(tunings.HEALTH_PENALTY)
    end

    player:PushEvent("accident", "deltapenalty")
end

local function onlifeinjector(inst, player)
    -- 强心针的效果
    if player.components.health ~= nil then
        player.components.health:DeltaPenalty(TUNING.MAX_HEALING_NORMAL)
    end
    player:PushEvent("accident", "onlifeinjector")
end  
local function sanityaura(inst, player)
    if inst.components.sanityaura then return end --存在理智光环 可能是mod角色自动特性 或者 已经钓到过 故不用管
    
    player.sanityaura_task = player:DoTaskInTime(60,function(word)
        player.sanityaura_task:Cancel()
        player.sanityaura_task = nil
        player:RemoveComponent("sanityaura")
        player.AnimState:OverrideMultColour(1, 1, 1, 1)
    end)
    player.AnimState:OverrideMultColour(0.15, 0.15, 0.15, 1)
    player:AddComponent("sanityaura")
    player.components.sanityaura.aurafn = function() return -100/15 end

    player:PushEvent("accident", "sanityaura")
end  
local function research(inst, player)

    if player and player.components.builder then
        player.components.builder:GiveTempTechBonus({SCIENCE = 2, MAGIC = 2, SEAFARING = 2})
    end
    local fx = SpawnPrefab(player.components.rider ~= nil and player.components.rider:IsRiding() and "fx_book_research_station_mount" or "fx_book_research_station")
    fx.Transform:SetPosition(player.Transform:GetWorldPosition())
    fx.Transform:SetRotation(player.Transform:GetRotation())

    player:PushEvent("accident", "research")
end
local function temperature(inst, player)

    if player and player.components.temperature then
        player.components.temperature:SetTemperature(TheWorld.state.temperature)
    end

    player:PushEvent("accident", "temperature")
end


local function mindcontrol(inst, player)
    if player.mindcontrol_task then return end --不希望短时间钓起两次同时影响
    if player.components.debuffable == nil then
        player:AddComponent("debuffable")
    end    
    local tiem = 6
    local function IsCrazyGuy(guy)
        local sanity = guy ~= nil and guy.replica.sanity or nil
        return sanity ~= nil and sanity:GetPercentNetworked() <= (guy:HasTag("dappereffects") and TUNING.DAPPER_BEARDLING_SANITY or TUNING.BEARDLING_SANITY)
    end
    local function control(p) 
        if tiem <= 0 or p.components.health:IsDead() or p:HasTag("playerghost") or not p.entity:IsVisible() then
            p.mindcontrol_task:Cancel()
            p.mindcontrol_task = nil
            p:RemoveDebuff("mindcontroller") 
            return
        end
        p:AddDebuff("mindcontroller", "mindcontroller")
        -- 根据精神大小来调整控制时长 精神值高就减少的快一点
        tiem = tiem - FRAMES*(IsCrazyGuy(p) and 1 or 2) 
    end
    --刷帧控制
    player.mindcontrol_task = player:DoPeriodicTask(FRAMES, control)

    player:PushEvent("accident", "mindcontrol")
end

-------------------------------------------------------------------
-------------------------------------------------------------------
-------------------------------------------------------------------

return {
	weatherchanged = weatherchanged, -- 阴晴不定
	rockcircle = rockcircle, -- 岩石怪圈
	campfirecircle = campfirecircle, -- 营火晚会
	monstercircle = monstercircle, -- 生物怪圈
    maxwellcircle = maxwellcircle, -- 犬牙陷阱圈
    chest = chest, -- 钓到箱子了
    lightningTarget = lightningTarget, -- 天雷陷阱
    celestialfury = celestialfury, -- 天体陷阱
    gunpowdercircle = gunpowdercircle, -- 火药陷阱
    getplayer = getplayer, --钓起个角色
    onAddHun = onAddHun, -- 啜食
    onAddSan = onAddSan, -- 降智
    onAddHp = onAddHp, -- 流血
    shadow_level = shadow_level, -- 暗影陷阱
    healthlink = healthlink, -- 单向生命链接
    caveinobstacle = caveinobstacle, -- 柱！柱！柱！
    sporecloud = sporecloud, -- 多重孢子云
    removeitems = removeitems, --清理物品
    hedgehounds = hedgehounds, --蔷薇陷阱
    sewing_mannequin = sewing_mannequin, --假人装备
    ghost_circle = ghost_circle, --鬼魂陷阱
    lethargy = lethargy, --昏睡陷阱
    sanityempty = sanityempty, --理智全无
    turkey = turkey, --毒计？鸡
    dropequip = dropequip, --卸甲归田
    stashloot = stashloot, --遗失宝藏
    seasonchange = seasonchange, --季节变化
    shadowthrall = shadowthrall, --甘·文·崔
    spawnwaves = spawnwaves, --惊涛波浪
    deciduous = deciduous, --桦树精的愤愤
    refusefish = refusefish, --强制禁鱼期
    rabbiteater = rabbiteater, --兔吃曼草
    transformation = transformation, --移形换影
    debrisitems = debrisitems, --奇怪的雨
    ascension = ascension, --升天
    allfreezable = allfreezable, --大范围冰冻
    sand = sand, --蚁狮陷阱
    supermany = supermany, --超多的陷阱
    frograin = frograin, --青蛙雨
    alterguardian_laser = alterguardian_laser, --相控阵激光
    mushroombomb = mushroombomb, --奇妙蘑菇林
    mushroom = mushroom, --蘑菇丛
    fossilspike = fossilspike, --骨牢骨刺
    areaaware_abnormal = areaaware_abnormal, --区域异常，半天!
    super_big = super_big, --快快变大
    p_combat = p_combat, --别钓了，快战斗
    tentacle_kl = tentacle_kl, --触手陷阱
    bat_eye = bat_eye, --蝙蝠军团
    super_small = super_small, --快快变小
    weed_imprison = weed_imprison, --杂草禁锢
    onefistsuperman = onefistsuperman, --一拳小超人
    angel_blessing = angel_blessing, --天使赐福
    returnonattack = returnonattack, --还你飘飘拳
    deltapenalty = deltapenalty, --加点黑血
    onlifeinjector = onlifeinjector, --注射强心针
    sanityaura = sanityaura, --你不要过来
    research = research, --知识灌入
    temperature = temperature, --体温变气温
    mindcontrol = mindcontrol, --精神控制
}