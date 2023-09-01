local messagebottletreasures = require("messagebottletreasures")

local function spawnAtGround(name, x,y,z)
    if TheWorld.Map:IsPassableAtPoint(x, y, z) then
        local item = SpawnPrefab(name)
        if item then
            item.Transform:SetPosition(x, y, z)
            return item
        end
    end
end

-- 物品位置, 半径, 几等分, 对象表, 将要执行的方法
local function circular(target,r,num,lsit,fn)
    if target == nil or lsit == nil or #lsit <= 0 then return end 
    local x,y,z = target.Transform:GetWorldPosition()
    for k=1,num do
        local angle = k * 2 * PI / num
        local item = spawnAtGround(lsit[math.random(#lsit)], r*math.cos(angle)+x, 0, r*math.sin(angle)+z)
        if item ~= nil and fn ~= nil and type(fn) == "function" then 
            fn(item, target, k)
        end
    end 
end


local function bird(inst, player) -- 钓到鸟类
    inst:DoTaskInTime(1,function(inst) --等鸟飞起睡眠它, 超2s就被删了
        inst.components.sleeper:GoToSleep(0)
    end)
end

local function grotto_pool_small(inst, player) -- 钓到了岩石水池
    if inst._waterfall then
        inst._waterfall.Transform:SetPosition(inst.Transform:GetWorldPosition())
    end
    inst.children = nil
end

local function klaus(inst, player)  -- 钓到克劳斯
	-- inst:SpawnDeer() -- 产鹿 钓起后,产鹿也暴怒。 钓起前,原克劳斯位置在海上,无法用海上坐标,所以产鹿坐标设置当前玩家坐标。
    local pos = player:GetPosition()
    local rot = player.Transform:GetRotation()
    local theta = (rot - 90) * DEGREES
    local offset =
        FindWalkableOffset(pos, theta, inst.deer_dist, 5, true, false) or
        FindWalkableOffset(pos, theta, inst.deer_dist * .5, 5, true, false) or
        Vector3(0, 0, 0)

    local deer_red = SpawnPrefab("deer_red")
    deer_red.Transform:SetRotation(rot)
    deer_red.Transform:SetPosition(pos.x + offset.x, 0, pos.z + offset.z)
    local redP = deer_red.Physics:GetCollisionMask()
    deer_red.Physics:SetCollisionMask(COLLISION.GROUND)  
    deer_red:DoTaskInTime(1,function(inst)
    	inst.Physics:SetCollisionMask(redP)  
	end)
    deer_red.components.spawnfader:FadeIn()
    inst.components.commander:AddSoldier(deer_red)


    theta = (rot + 90) * DEGREES
    offset =
        FindWalkableOffset(pos, theta, inst.deer_dist, 5, true, false) or
        FindWalkableOffset(pos, theta, inst.deer_dist * .5, 5, true, false) or
        Vector3(0, 0, 0)

    local deer_blue = SpawnPrefab("deer_blue")
    deer_blue.Transform:SetRotation(rot)
    deer_blue.Transform:SetPosition(pos.x + offset.x, 0, pos.z + offset.z)
    deer_blue.Physics:SetCollisionMask(COLLISION.GROUND)  
    deer_blue:DoTaskInTime(1,function(inst)
    	inst.Physics:SetCollisionMask(redP)  
	end)
    deer_blue.components.spawnfader:FadeIn()
    inst.components.commander:AddSoldier(deer_blue)	

	inst.components.knownlocations:RememberLocation("spawnpoint", player:GetPosition(), false) -- 重新记住玩家位置
	inst.components.spawnfader:FadeIn() -- 渐入效果
end

local function stalker_atrium(inst, player) -- 钓到织影者
    local stargate = SpawnPrefab("artificial_atrium_gate") --添加伪远古大门
    stargate.Transform:SetPosition(player.Transform:GetWorldPosition())
    inst.components.entitytracker:TrackEntity("stargate", stargate)
    stargate:TrackStalker(inst)
    inst.persists = false
end

local function oasislake(inst, player)--钓湖泊时
    inst.Physics:SetMass(0) -- 抛物结束，修改质量为0
    inst:DoTaskInTime(1.5,function(inst)
        if inst.driedup then -- 不可以钓鱼时
            inst.Physics:ClearCollisionMask() -- 清碰撞组
            inst.Physics:CollidesWith(COLLISION.ITEMS)
        else -- 可以钓鱼时
            inst.Physics:CollidesWith(COLLISION.CHARACTERS)
            inst.Physics:CollidesWith(COLLISION.GIANTS)
        end
    end)
end
local function seedpacket(inst, player)
    if inst.components.unwrappable then
        --更改打开的方法 随机不重复的种子
        inst.components.unwrappable:SetOnUnwrappedFn(function(inst, pos, doer)
            if inst.burnt then
                SpawnPrefab("ash").Transform:SetPosition(pos:Get())
            else  
                local seeds = {"seeds","asparagus_seeds","carrot_seeds","corn_seeds","dragonfruit_seeds","durian_seeds","eggplant_seeds","garlic_seeds","onion_seeds","pepper_seeds","pomegranate_seeds","potato_seeds","pumpkin_seeds","tomato_seeds","watermelon_seeds"}
                local loot = table.randomnorepeat(seeds, 4)
                if loot ~= nil then
                    local moisture = inst.components.inventoryitem:GetMoisture()
                    local iswet = inst.components.inventoryitem:IsWet()
                    for i, v in ipairs(loot) do
                        local item = SpawnPrefab(v)
                        if item ~= nil then
                            if item.Physics ~= nil then
                                item.Physics:Teleport(pos:Get())
                            else
                                item.Transform:SetPosition(pos:Get())
                            end
                            if item.components.inventoryitem ~= nil then
                                item.components.inventoryitem:InheritMoisture(moisture, iswet)
                                item.components.inventoryitem:OnDropped(true, .5)
                            end
                        end
                    end
                end
                SpawnPrefab("carnival_seedpacket_unwrap").Transform:SetPosition(pos:Get())
            end      
            if doer ~= nil and doer.SoundEmitter ~= nil then
                doer.SoundEmitter:PlaySound(inst.skin_wrap_sound or "dontstarve/common/together/packaged")
            end
            inst:Remove()    
        end)
    end
end

local function sunkenchest(inst, player)
    local ls = messagebottletreasures.GenerateTreasure(inst:GetPosition(), "sunkenchest") --生成宝藏
    if ls == nil then return end
    if inst.components.container and ls.components.container then --箱子容器组件存在，添加到箱子里
        for _,item in pairs(ls.components.container:GetAllItems()) do
            inst.components.container:GiveItem(item)
        end
    end  
    ls:Remove()
end
local function alterguardian_laser(inst, player)
    inst:Trigger(0.5)
end

local function antlion(inst, player)
    inst:StartCombat(player,"burn")
end

local function gift(inst, player, target, parameter) --parameter可以是方法，表，字符串
    local items = {}
    local loot = nil
    local wp = {
        combat1 = {"armorwood","wathgrithrhat","spear_wathgrithr"}, --战斗套装
        combat2 = {"armorruins","ruinshat","ruins_bat"}, --铥矿套装
        combat3 = {"armor_sanity","nightsword"}, --暗影套装
    }
    if type(parameter) == "function" then
        loot = parameter()
    elseif type(parameter) == "string" then
        loot = wp[parameter] or {"goldnugget","goldnugget","goldnugget","goldnugget"}
    else
        loot = parameter
    end
    for _,name in pairs(table.randomnorepeat(loot,4)) do --4个不可重复项
        local item = SpawnPrefab(name)
        if item then 
            SetSpellCB(item, player) --给随机皮肤
            table.insert(items, item)
        end
    end
    inst.components.unwrappable:WrapItems(items) --打包物品
    for i, v in ipairs(items) do --删除生成出来的
        v:Remove()
    end
end
local function gift_plant(inst, player, target, parameter) --parameter可以是方法，表，字符串
    local items = {}
    local loot = nil
    local wp = {
        tree = {
            pinecone = function() return math.random(1,20) end,
            acorn = function() return math.random(1,15) end,
            livingtree_root = function() return math.random(1,5) end,
        },
        sapling = {
            twiggy_nut = function() return math.random(2,5) end,
            dug_sapling = function() return math.random(1,5) end,
            dug_sapling_moon = function() return math.random(1,5) end,
            dug_marsh_bush = function() return math.random(1,5) end,
        },
        miscellaneous = {
            dug_grass = function() return math.random(2,5) end, 
            bullkelp_root = function() return math.random(1,5) end,
            marblebean = function() return math.random(1,5) end, 
        },
        berrybush = {
            dug_berrybush = function() return math.random(1,5) end, 
            dug_berrybush2 = function() return math.random(1,5) end, 
            dug_berrybush_juicy = function() return math.random(1,5) end, 
        },
    }
    if type(parameter) == "function" then
        loot = parameter()
    elseif type(parameter) == "string" then
        loot = wp[parameter] or {poop = 5, log = 10}
    else
        loot = parameter
    end
    for name,v in pairs(loot) do --4个不可重复项
        local item = SpawnPrefab(name)
        if item then 
            SetSpellCB(item, player) --给随机皮肤
            if item.components.stackable then --设置堆叠数量
                item.components.stackable:SetStackSize(type(v) == "function" and v() or v)
            end
            table.insert(items, item)
        end
    end
    inst.components.unwrappable:WrapItems(items) --打包物品
    for i, v in ipairs(items) do --删除生成出来的
        v:Remove()
    end
end
-------------------------------------------------------------------
-------------------------------------------------------------------

return {
	bird = bird, -- 钓到鸟类
    grotto_pool_small = grotto_pool_small, -- 钓到了岩石水池
	klaus = klaus, -- 钓到克劳斯
    stalker_atrium = stalker_atrium, -- 钓到织影者
    oasislake = oasislake, --钓湖泊时
    seedpacket = seedpacket, --钓到种子包
    sunkenchest = sunkenchest, --钓到沉底宝箱
    antlion = antlion, --钓到蚁狮
    gift = gift, --钓到礼物
    gift_plant = gift_plant, --钓到礼物·可堆叠
}