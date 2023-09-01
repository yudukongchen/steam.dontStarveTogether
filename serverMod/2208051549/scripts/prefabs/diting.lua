local MakePlayerCharacter = require "prefabs/player_common"


local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
    Asset("ANIM", "anim/stalker_shield.zip"),
	Asset( "ANIM", "anim/ghost_diting_build.zip" ),
	Asset( "ANIM", "anim/diting.zip" ),
    Asset("SOUNDPACKAGE", "sound/ditinglisten.fev"),  --音效
    Asset("SOUND", "sound/ditinglisten.fsb"),

}
local prefabs =
{
    "diting_bloom_fx",
    "freezeocean",
    "wurt_tentacle_warning",
    "diting_bloom_track",
}

-- 初始物品
local start_inv = {
    "littlematch",
    "amulet",  --别死掉了……
}
--彼岸花开 就是把沃姆伍德的代码copy过来而已。 --第一个做的功能。
local PLANTS_RANGE = 1 --花的范围
local MAX_PLANTS = 18  --最大花数量

local MyPLANTFX_TAGS = { "diting_bloom_fx" } --开花的标签吧。
local function MyPlantTick(inst)
    if inst.sg:HasStateTag("ghostbuild") or inst.components.health:IsDead() or not inst.entity:IsVisible() then
        return
    end
    local x, y, z = inst.Transform:GetWorldPosition() --当前坐标吧
    if #TheSim:FindEntities(x, y, z, PLANTS_RANGE, MyPLANTFX_TAGS) < MAX_PLANTS then --如果当前坐标1范围内花数少于MAX
        local map = TheWorld.Map
        local pt = Vector3(0, 0, 0) --我猜这是个坐标型
        local offset = FindValidPositionByFan(  --找到有效的开花地点
            math.random() * 2 * PI,   --相当于offset.x？
            math.random() * PLANTS_RANGE,  --相当于offset.z？
            3,  
            function(offset)
                pt.x = x + offset.x
                pt.z = z + offset.z
                local tile = map:GetTileAtPoint(pt:Get()) --pt即为实体产生的地点
                return tile ~= GROUND.ROCKY
                    and tile ~= GROUND.ROAD
                    and tile ~= GROUND.WOODFLOOR
                    and tile ~= GROUND.CARPET
                    and tile ~= GROUND.IMPASSABLE  
                    and tile ~= GROUND.INVALID     --有时间找找海面
                    and #TheSim:FindEntities(pt.x, 0, pt.z, .5, MyPLANTFX_TAGS) < 3  --FindEntities函数的用法
                    and map:IsDeployPointClear(pt, nil, .5)
                    and not map:IsPointNearHole(pt, .4)
            end
        )
        if offset ~= nil then
            local plant = SpawnPrefab("diting_bloom_fx")
            plant.Transform:SetPosition(x + offset.x, 0, z + offset.z)
            --randomize, favoring ones that haven't been used recently
            local rnd = math.random()
            rnd = table.remove(inst.plantpool, math.clamp(math.ceil(rnd * rnd * #inst.plantpool), 1, #inst.plantpool))
            table.insert(inst.plantpool, rnd)
            plant:SetVariation(rnd)
        end
    end
end
local function MyEnableFullBloom(inst, enable)
    if enable then
        if not inst.myfullbloom then
            inst.myfullbloom = true
            if inst.planttask == nil then
                inst.planttask = inst:DoPeriodicTask(.25, MyPlantTick)
            end
		inst.components.talker:Say(GetString(inst, "ANNOUNCE_BLOOMING"))
		inst.components.locomotor:SetExternalSpeedMultiplier(inst, "diting_speed_mod", 1.2)
        end
    elseif inst.myfullbloom then
        inst.myfullbloom = nil
        if inst.planttask ~= nil then
            inst.planttask:Cancel()
            inst.planttask = nil
        end
		inst.components.locomotor:SetExternalSpeedMultiplier(inst, "diting_speed_mod", 1)
    end
end
local function BloomPeriod(inst,season)
       inst.bloomperiod=season
end
local function Bianhua(inst, bloomtime)  --秋天和春天后10天开花，彼岸花花期。 如果不按四季顺序乱跳季节，可能会出现花期错误。
    if not inst:HasTag("playerghost") and bloomtime <=10 and inst.bloomperiod then 
        MyEnableFullBloom(inst, inst.bloomperiod)                       
    else
        MyEnableFullBloom(inst, false)
    end
end

local function Bodhisattva(inst,data)
    if inst and data then
        if inst.BodhisattvaBlessing == true then
            inst.components.health:SetAbsorptionAmount(0)
          --  local fx = SpawnPrefab("stalker_shield")
          --     fx.entity:SetParent(inst.entity)
          local fx = SpawnPrefab("shadow_shield"..tostring(math.random(1,3)))   --累了累了，没精力了。
             fx.entity:SetParent(inst.entity)
            inst:DoTaskInTime(10,function(inst) 
                inst.BodhisattvaBlessing = true 
                inst.components.health:SetAbsorptionAmount(1)   end)
        end
    end
end

local function WhatEat(inst,food)  --连续吃下三个红宝石，触发无量业火。--实在没有时间继续完善了……
    if food.components.edible and food.components.edible.secondaryfoodtype == FOODTYPE.REDGEM  and not inst.Change then
        inst.components.talker:Say("嘎嘣！")
        inst.level = inst.level+1
    else 
        inst.level=0
    end
	if inst.level == 3 then
	    if not inst.Change then
            inst.Change = true
            inst.components.talker:Say("无量业火")
            local x, y, z = inst.Transform:GetWorldPosition()
            local fx = SpawnPrefab("maxwell smoke")
            SpawnPrefab("statue_transition").Transform:SetPosition(inst:GetPosition():Get())
            inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel") 
            inst.level=0
        end
    end   
	if food.components.edible and food.components.edible.secondaryfoodtype == FOODTYPE.BLUEGEM and not inst.Change then  --解除：吃下一颗蓝宝石。
    inst.components.talker:Say("嘎嘣！") 
    else if inst.Change and food.components.edible.secondaryfoodtype == FOODTYPE.BLUEGEM then
     inst.Change = false
     inst.components.talker:Say("乃穷寒冰") 
     local x, y, z = inst.Transform:GetWorldPosition()
            local fx = SpawnPrefab("maxwell smoke")
            SpawnPrefab("statue_transition").Transform:SetPosition(inst:GetPosition():Get())
        end	
    end
end

local function FastFireFighting(inst)   
    local x,y,z = inst.Transform:GetWorldPosition()
    local TheFire = TheSim:FindEntities(x, y, z, 6, {"campfire"or"firepit"},{"blueflame"})
    local Smolder = TheSim:FindEntities(x, y, z, 3, {"smolder"},{})
    local Onburning = TheSim:FindEntities(x, y, z, 2, {"fire"},{"campfire","firepit","weapon","nightlight"})
    local TheColdFire = TheSim:FindEntities(x, y, z, 6, {"campfire"or"firepit","blueflame"},{})
    if #TheFire~=0 and not inst.components.health:IsDead() or inst:HasTag("playerghost") then   --靠近火以约五倍的速度熄灭。
        for k, v in pairs(TheFire) do
              v.components.fueled.rate = 6
        end     
    end
    if #TheColdFire~=0 and not inst.components.health:IsDead() or inst:HasTag("playerghost") then   --靠近冰火竟然可以自动加燃料
        for k, v in pairs(TheColdFire) do
              v.components.fueled.rate = -3
        end     
    end
    if #Smolder~=0 and not inst.components.health:IsDead() or inst:HasTag("playerghost") then --兽型灭烟器
        for k, v in pairs(Smolder) do
            -- v:RemoveTag("smolder")  没用呐
            v.components.burnable:StopSmoldering(-1)   --（-1为热百分比，具体效果不清楚）
        end     
    end 
    if #Onburning~=0 and not inst.components.health:IsDead() or inst:HasTag("playerghost") then   --兽型灭火器，想要点火并不容易……
        for k, v in pairs(Onburning) do
            v.components.burnable:Extinguish(v, -1, nil)
        end     
    end
end
local function ElectricAttack()
    SpawnPrefab("blowdart_yellow").components.weapon:SetDamage(TUNING.PIPE_DART_DAMAGE*2)
end
local function FrostAttack(inst,data)   --攻击会造成boss冰冻抗性的丢失。
    local target = data.target
        if target == nil then
            return
        end
        if target:HasTag("dragonfly") then
            inst.components.health:DoDelta(1)
            target.components.health:DoDelta(-data.damage*2,false,(data.weapon and data.weapon.prefab or inst),nil,inst) 
            return
        end
            if target:HasTag("FrozenTarget") then
                if target.components.health:GetMaxWithPenalty() > 6000 then
                    inst.components.health:DoDelta(1)
                target.components.health:DoDelta(-data.damage*2,false,(data.weapon and data.weapon.prefab or inst),nil,inst)  --overtime具体含义我不清楚……先设为false吧。
                else
                inst.components.health:DoDelta(math.random(0,1))
                target.components.health:DoDelta(-math.random(data.damage,data.damage*2),false,(data.weapon and data.weapon.prefab or inst),nil,inst)
                end
            end
            if target.components.freezable ~= nil then
               if target.components.freezable.diminishingreturns then
                   target.components.freezable.diminishingreturns = false
                end
            end
            if data.weapon and data.weapon.prefab == "blowdart_pipe" then  --普通吹箭附加冰冻效果，额外随机伤害。
                if target then
                    if target.components and target.components.freezable then 
                             target.components.health:DoDelta(-math.random(30,100),false,(data.weapon and data.weapon.prefab or inst),nil,inst)
                             inst.components.talker:Say("感受彻骨的寒冷！")
                             target.components.freezable:AddColdness(12, 10)
                    end
                end
            elseif data.weapon and data.weapon.prefab == "blowdart_yellow" then --闪电吹箭伤害翻倍，闪电特效，有约5％造成额外9999伤害。
                if target then
                    if target.components then
                        local pos = target:GetPosition()
                        TheWorld:PushEvent("ms_sendlightningstrike", pos)
                        inst.components.talker:Say("天谴！")
                         if math.random(0,100) < 5 then
                            target.components.health:DoDelta(-9999,false,(data.weapon and data.weapon.prefab or inst),nil,inst)
                         end
                    end
                end
            elseif (data.weapon and data.weapon.prefab ~= "blowdart_fire" and data.weapon.prefab ~="torch" and data.weapon.prefab ~="hammer" and data.weapon.pregab ~= "littlematch") --攻击附加减速、冰杖效果。冰冻后的目标7s内不受冰冻影响,标记为易损状态。
                        or  (not data.weapon) then                                                                      --我要敲鼹鼠。
                     if target then
                        if target.components.burnable ~= nil then
                            if target.components.burnable:IsBurning() then
                                target.components.burnable:Extinguish()
                            elseif target.components.burnable:IsSmoldering() then
                                target.components.burnable:SmotherSmolder()
                            end
                        end
                        if target.components.freezable ~= nil then
                            local targetResistance = data.target.components.freezable.resistance
                            target.components.freezable:AddColdness(1)
                            if target.components.freezable:IsFrozen() then
                                local k = math.random()
                                if k<0.3 then
                                    if target.components.lootdropper then
                                        target.components.lootdropper:SpawnLootPrefab("icecake")
                                    end
                                end
                                target.components.freezable.resistance = 99
                                target:AddTag("FrozenTarget")
                                inst.components.health:DoDelta(3)
                                inst.components.sanity:DoDelta(3)
                                target.components.health:DoDelta(-30,false,(data.weapon and data.weapon.prefab or inst),nil,inst)  --目标冰冻时造成额外30点伤害
                                target:DoTaskInTime(7,function(target) 
                                    target.components.freezable.resistance = targetResistance 
                                    target:RemoveTag("FrozenTarget")   end)
                            end
                        else          --算是对深渊蠕虫、暗影生物的补偿吧
                            target.components.health:DoDelta(-40,false,(data.weapon and data.weapon.prefab or inst),nil,inst)
                            inst.components.health:DoDelta(math.random(0,1))
                        end
                        if target._slingshot_speedmulttask ~= nil then
                            target._slingshot_speedmulttask:Cancel()
                        end
                        if target ~= nil and target:IsValid() and target.components.locomotor ~= nil then
                        local debuffkey = "slowdown"  --copy walter XD
                        target._slingshot_speedmulttask = target:DoTaskInTime(TUNING.SLINGSHOT_AMMO_MOVESPEED_DURATION, function(i) i.components.locomotor:RemoveExternalSpeedMultiplier(i, debuffkey) i._slingshot_speedmulttask = nil end)
                        target.components.locomotor:SetExternalSpeedMultiplier(target, debuffkey, TUNING.SLINGSHOT_AMMO_MOVESPEED_MULT)
                        end
                    end
            end
 end
--海上行走
local function recfgphysics(inst,iswinter)   --目前只针对玩家本人。。。
    --这里重修了角色的physic。。。可能死亡复活后得重新载一遍。。。
    local phys=inst.Physics or inst.entity:AddPhysics()
    if iswinter and  not inst:HasTag("playerghost") then
    phys:ClearCollisionMask()                                               
    phys:CollidesWith((TheWorld.has_ocean and COLLISION.GROUND) or COLLISION.WORLD) --海面可行走判定--或许只要这一句就可以了。。。
    phys:CollidesWith(COLLISION.OBSTACLES)
    phys:CollidesWith(COLLISION.SMALLOBSTACLES)
    phys:CollidesWith(COLLISION.CHARACTERS)
    phys:CollidesWith(COLLISION.GIANTS)
    elseif not inst:HasTag("playerghost") then
    phys:ClearCollisionMask()
    phys:CollidesWith(COLLISION.WORLD)
    phys:CollidesWith(COLLISION.OBSTACLES)
    phys:CollidesWith(COLLISION.SMALLOBSTACLES)
    phys:CollidesWith(COLLISION.CHARACTERS)
    phys:CollidesWith(COLLISION.GIANTS)
    end
end


 local function makeplat(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local icelyer = SpawnPrefab("freezeocean")
    if not inst:HasTag("playerghost") then
        if(#TheSim:FindEntities(x, y, z, 2,{"freezeocean"}) < 1 )
        then --脚底没有？，就造一个。。。
            --inst.platform.frozerd=2 --無駄無駄無駄無駄無駄
            --欧拉欧拉欧拉欧拉欧拉
            local map = TheWorld.Map
            local pt = Vector3(0, 0, 0)
            local offset = FindValidPositionByFan(  --找到有效的结冰地点,这是个global函数。
            math.random() * 2 * PI,   --相当于offset.x？
            math.random() * 1,  --相当于offset.z？
            3,  --相当于offset.y  官方一般都设为3
                function(offset)
                    pt.x = x 
                    pt.z = z 
                    local tile = map:GetTileAtPoint(pt:Get())
                    return (tile == GROUND.OCEAN_COASTAL
                        or tile == GROUND.OCEAN_COASTAL_SHORE
                        or tile == GROUND.OCEAN_SWELL
                        or tile == GROUND.OCEAN_ROUGH
                        or tile == GROUND.OCEAN_BRINEPOOL  
                        or tile == GROUND.OCEAN_HAZARDOUS )    --这就是海面。
                        and #TheSim:FindEntities(x, 0, z, 4, {"boat"},{})==0   --船上不产生实体。
                end
            )
            if offset ~= nil then
               icelyer.Transform:SetPosition(x,0,z)
               local rnd = math.random()
               rnd = table.remove(inst.icepool, math.clamp(math.ceil(rnd * rnd * #inst.icepool), 1, #inst.icepool))
               table.insert(inst.icepool, rnd)
               icelyer:SetVariation(rnd)   
            end
           if not inst.sg.statemem.isphysicstoggle then  --解决弃船产生的BUG
            recfgphysics(inst,true)
            end
        end
    end
end

local function Canwalkonsea (inst, iswinter)
    if iswinter then
        if inst.seatask == nil then
          recfgphysics(inst,true)
          inst:RemoveComponent("drownable")
          inst.seatask = inst:DoPeriodicTask(.5, makeplat)
        end
    elseif  inst.seatask ~= nil then
        recfgphysics(inst,false)
        inst.seatask:Cancel()
        inst.seatask = nil
        inst:AddComponent("drownable")
    end
end

local WARNING_MUST_TAGS = {"tentacle", "invisible"}   --wurt
local function UpdateTentacleWarnings(inst)
	local disable = (inst.replica.inventory ~= nil and not inst.replica.inventory:IsVisible())
    
	if not disable then
		local old_warnings = {}
		for t, w in pairs(inst._active_warnings) do
			old_warnings[t] = w
		end

		local x, y, z = inst.Transform:GetWorldPosition()
		local warn_dist = 50
		local tentacles = TheSim:FindEntities(x, y, z, warn_dist, WARNING_MUST_TAGS)
		for i, t in ipairs(tentacles) do
			local p1x, p1y, p1z = inst.Transform:GetWorldPosition()
			local p2x, p2y, p2z = t.Transform:GetWorldPosition()
			local dist = VecUtil_Length(p1x - p2x, p1z - p2z)

			if t.replica.health ~= nil and not t.replica.health:IsDead() then
				if inst._active_warnings[t] == nil then
					local fx = SpawnPrefab("wurt_tentacle_warning")
					fx.entity:SetParent(t.entity)
                    inst._active_warnings[t] = fx
				else
					old_warnings[t] = nil
				end
			end
		end

		for t, w in pairs(old_warnings) do
			inst._active_warnings[t] = nil
			if w:IsValid() then
				ErodeAway(w, 0.5)
			end
		end
	elseif next(inst._active_warnings) ~= nil then
		for t, w in pairs(inst._active_warnings) do
			if w:IsValid() then
				w:Remove()
			end
		end
        inst._active_warnings = {}
	end
end

local function DisableTentacleWarning(inst)  --from wurt
    if  inst._listen:value() == true then
        return
    end
	if inst.tentacle_warning_task ~= nil then
		inst.tentacle_warning_task:Cancel()
		inst.tentacle_warning_task = nil
	end
			
	for t, w in pairs(inst._active_warnings) do
		if w:IsValid() then
			w:Remove()
		end
	end
	inst._active_warnings = {}
end

local function EnableTentacleWarning(inst)
	if inst.player_classified ~= nil then
		if inst.tentacle_warning_task == nil then
            inst.tentacle_warning_task = inst:DoPeriodicTask(1, UpdateTentacleWarnings)
        end
    end
end

local function ListenOn(inst)
    if inst and inst:HasTag("diting") then
        EnableTentacleWarning(inst)
    
    end
end

local function ListenOff(inst)
    if inst and inst:HasTag("diting") then
      inst:DoTaskInTime(10,DisableTentacleWarning)
    end
end

local function LisForEverything(inst)
    if inst and inst:HasTag("diting") then
        if inst._listen:value() == true then
            TheWorld:PushEvent("enabledynamicmusic", false)   --这种应该是独享音乐
            if TheWorld:HasTag("cave") then
                TheFocalPoint.SoundEmitter:PlaySound("ditinglisten/ditinglisten/windcave","loop")   --循环音乐加绰号，才能被杀掉。
             else
                TheFocalPoint.SoundEmitter:PlaySound("ditinglisten/ditinglisten/wind","loop")  --TheFocalPoint，背景音乐。
            end
            ListenOn(inst)  
            --匆忙间做的箭头--
            
        else
            TheWorld:PushEvent("enabledynamicmusic", true)   
            if TheFocalPoint.SoundEmitter:PlayingSound("loop") then
                TheFocalPoint.SoundEmitter:KillSound("loop")
               end
            ListenOff(inst)
        end
    end
end

-- 当人物复活的时候
local function onbecamehuman(inst)
	-- 设置人物的移速（1表示1倍于wilson）
    inst.components.locomotor:SetExternalSpeedMultiplier(inst, "diting_speed_mod", 1)
    if TheWorld.state.isspring or TheWorld.state.isautumn then
        inst.bloomperiod= true
    end
	if (TheWorld.state.isspring or TheWorld.state.isautumn)  --and优先级高于or..
     and TheWorld.state.remainingdaysinseason <=10
	then  
    MyEnableFullBloom(inst, true)
    end
    if TheWorld.state.iswinter then   --增添
        Canwalkonsea(inst, true)
    end
    if inst.components.hunger.current <= 0 or inst.components.temperature.current<=0 then
        inst.BodhisattvaBlessing = false 
        inst.components.health:SetAbsorptionAmount(0)
    end
end
--当人物死亡的时候
local function onbecameghost(inst)
	-- 变成鬼魂的时候移除速度修正
   inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "diting_speed_mod")
   if TheWorld.state.isspring or TheWorld.state.isautumn then
    MyEnableFullBloom(inst, false)
    end
    if TheWorld.state.iswinter then   --增添
        Canwalkonsea(inst, false)
    end
end

-- 重载游戏或者生成一个玩家的时候
local function onload(inst)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    inst:ListenForEvent("ms_becameghost", onbecameghost)
   -- inst.components.talker:Say("调试！")
    inst._listen:set(false)
    inst.listeningcd = false
    if inst:HasTag("playerghost") then
        onbecameghost(inst)
    else
        onbecamehuman(inst)
    end
end

 
--这个函数将在服务器和客户端都会执行 --我是理解不了。QAQ
--一般用于添加小地图标签等动画文件或者需要主客机都执行的组件（少数）
local common_postinit = function(inst) 
	-- Minimap icon
    inst.MiniMapEntity:SetIcon( "diting.tex" )
    inst:AddTag("diting")    --贴错地方真是要命。
    --大地之友---
    inst:AddTag("antlion_sinkhole_blocker") --蚁狮坑堵塞器。。。  --不过并不能阻挡愤怒的蚂蚁狮子，只会让自己脚下干净点。- 3 -
    
    inst._listen = net_bool(inst.GUID, "diting.listen", "listendirty")
    inst:ListenForEvent("listendirty", LisForEverything)
    inst._active_warnings = {}
end

-- 这里的的函数只在主机执行  一般组件之类的都写在这里  --如果客机修改了上面的某些数据，会怎样。 --算了 写完了  以后有兴趣再深入
local master_postinit = function(inst)
	-- 人物音效
   -- inst.soundsname = "willow" --这块日后慢慢来（刍狗）
    inst.soundsname = "diting"
	inst.talker_path_override = 'diting/' 
	
    --极寒体质
    inst:AddComponent("freezebody")
    inst.components.freezebody:BodyOn(inst)
    inst.components.temperature:CannotOverHeated()  --不会过热

	-- 三维	
	inst.components.health:SetMaxHealth(TUNING.DITING_HEALTH)
	inst.components.hunger:SetMax(150)
	inst.components.sanity:SetMax(150)
	
	-- 伤害系数
    inst.components.combat.damagemultiplier = 0.5
    inst.components.health:SetAbsorptionAmount(1)  
	
	-- 饥饿速度
    inst.components.hunger.hungerrate = 1 * TUNING.WILSON_HUNGER_RATE
    inst.components.eater:CanEatGems() --可以吃宝石。
    inst.components.eater:SetOnEatFn(WhatEat)  --吃了什么？
    inst.level= 0   --隐藏等级。
    inst.BodhisattvaBlessing = true   --菩萨保佑！
    
	inst.OnLoad = onload
    inst.OnNewSpawn = onload
    
    -- 花开彼岸
	inst.myfullbloom = nil
	inst.bloomperiod= nil
    inst.planttask = nil 
    inst.seatask = nil
    inst.Change = nil
    inst.tentacle_warning_task = nil
    inst.listeningcd = false
    inst.plantpool = { 1, 2, 3, 4 }
    for i = #inst.plantpool, 1, -1 do
        --randomize in place
        table.insert(inst.plantpool, table.remove(inst.plantpool, math.random(i)))
    end
    inst.icepool = { 1, 2}
    for i = #inst.icepool, 1, -1 do
        table.insert(inst.icepool, table.remove(inst.icepool, math.random(i)))
    end

  --免疫一次伤害，写的真幼稚……
    inst:ListenForEvent("attacked", Bodhisattva)
    inst:ListenForEvent("startstarving",function(inst) inst.BodhisattvaBlessing = false 
        inst.components.health:SetAbsorptionAmount(0) end)
    inst:ListenForEvent("stopstarving",function(inst) inst.BodhisattvaBlessing = true 
        inst.components.health:SetAbsorptionAmount(1) end)
    inst:ListenForEvent("startfreezing",function(inst) inst.BodhisattvaBlessing = false
       -- inst.components.talker:Say("好冷！！！！") 
        inst.components.health:SetAbsorptionAmount(0) end)
    inst:ListenForEvent("stopfreezing",function(inst) inst.BodhisattvaBlessing = true 
      --  inst.components.talker:Say("不冷！！！！")
        inst.components.health:SetAbsorptionAmount(1) end)

	inst:WatchWorldState("isspring", BloomPeriod)  --查看世界状态只在季节转变的时候触发。
	inst:WatchWorldState("isautumn", BloomPeriod)
    inst:WatchWorldState("remainingdaysinseason", Bianhua)
    inst:ListenForEvent("equip",function(inst)
          local tool = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) --火炬约2倍速度消失。
                if tool and tool.prefab == "torch" then
                    tool.components.fueled.rate = 2
                end
            end) 
    inst:ListenForEvent("onhitother",FrostAttack)
    inst:ListenForEvent("onattackother", function(inst,data)
         local weapon = data.weapon
         local target = data.target
         if weapon and weapon.prefab == "blowdart_yellow" then
               weapon.components.weapon:SetDamage(TUNING.YELLOW_DART_DAMAGE*2)
         end
         if weapon and weapon.prefab == "blowdart_fire" then  --废掉火焰吹箭。
            if target.components.burnable then
                inst.components.talker:Say("这玩意儿没用！")
                target.components.burnable = nil
            end
         end
    end)
    inst:WatchWorldState("iswinter",Canwalkonsea)  --海上行走   
   
end

return MakePlayerCharacter("diting", prefabs, assets, common_postinit, master_postinit, start_inv)
