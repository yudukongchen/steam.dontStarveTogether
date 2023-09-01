GLOBAL.setmetatable(
	env,
	{
		__index = function(t, k)
			return GLOBAL.rawget(GLOBAL, k)
		end
	}
)
local dropmoon = GetModConfigData("孢子掉落")
local shufu = GetModConfigData("冬暖夏凉")
local jiesulv = GetModConfigData("饥饿速率")
local sanzhi = GetModConfigData("发光阈值")
local aoe = GetModConfigData("AOE伤害")
local dustproof = GetModConfigData("防尘")
local nophysics = GetModConfigData("是否开启碰撞体积和水上行走")
local fangyu = GetModConfigData("防御值")
local milk = GetModConfigData("牛奶帽功能")
local bird = GetModConfigData("羽毛帽功能")
local band = GetModConfigData("独奏乐器功能")
local baoxian = GetModConfigData("保鲜功能")
local speed = GetModConfigData("移速")
local notarget = GetModConfigData("无法选中")
local fangshui = GetModConfigData("防水")
local freezed = GetModConfigData("受攻击冰冻敌人")
local diukuang = GetModConfigData("铥矿护盾")
local yingwu = GetModConfigData("鹦鹉帽")
local chuanzhang = GetModConfigData("船长帽")
local haidao = GetModConfigData("海盗")
TUNING.SANITY_BECOME_ENLIGHTENED_THRESH = sanzhi
--[[local function ShouldNotDrown(owner)
    if owner.components.drownable ~= nil then
        if      owner.components.drownable.enabled ~= false then
                owner.components.drownable.enabled = false
                owner.Physics:ClearCollisionMask()
                owner.Physics:CollidesWith(COLLISION.GROUND)
                owner.Physics:CollidesWith(COLLISION.OBSTACLES)
                owner.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
                owner.Physics:CollidesWith(COLLISION.CHARACTERS)
                owner.Physics:CollidesWith(COLLISION.GIANTS)
                owner.Physics:Teleport(owner.Transform:GetWorldPosition())
        end
    end
end

local function ShouldDrown(owner)
    if owner.components.drownable ~= nil then
        if owner.components.drownable.enabled == false then
            owner.components.drownable.enabled = true
            if not owner:HasTag("playerghost") then
                owner.Physics:ClearCollisionMask()
                owner.Physics:CollidesWith(COLLISION.WORLD)
                owner.Physics:CollidesWith(COLLISION.OBSTACLES)
                owner.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
                owner.Physics:CollidesWith(COLLISION.CHARACTERS)
                owner.Physics:CollidesWith(COLLISION.GIANTS)
                owner.Physics:Teleport(owner.Transform:GetWorldPosition())
            end
        end
    end
end
--]]
local function  ruinshat_fxanim(inst)
    inst._fx.AnimState:PlayAnimation("hit")
    inst._fx.AnimState:PushAnimation("idle_loop")
end

local function ruinshat_oncooldown(inst)
    inst._task = nil
end

local function ruinshat_unproc(inst)
    if inst:HasTag("forcefield") then
        inst:RemoveTag("forcefield")
        if inst._fx ~= nil then
            inst._fx:kill_fx()
            inst._fx = nil
        end
        inst:RemoveEventCallback("armordamaged", ruinshat_fxanim)

        inst.components.armor:SetAbsorption(fangyu)
        inst.components.armor.ontakedamage = nil

        if inst._task ~= nil then
            inst._task:Cancel()
        end
        inst._task = inst:DoTaskInTime(TUNING.ARMOR_RUINSHAT_COOLDOWN, ruinshat_oncooldown)
    end
end

local function ruinshat_proc(inst, owner)--铥矿保护
    inst:AddTag("forcefield")
    if inst._fx ~= nil then
        inst._fx:kill_fx()
    end
    inst._fx = SpawnPrefab("forcefieldfx")
    inst._fx.entity:SetParent(owner.entity)
    inst._fx.Transform:SetPosition(0, 0.2, 0)
    inst:ListenForEvent("armordamaged", ruinshat_fxanim)

    inst.components.armor:SetAbsorption(TUNING.FULL_ABSORPTION)
    inst.components.armor.ontakedamage = function(inst, damage_amount)
        if owner ~= nil and owner.components.sanity ~= nil then
            owner.components.sanity:DoDelta(-damage_amount * TUNING.ARMOR_RUINSHAT_DMG_AS_SANITY, false)
        end
    end

    if inst._task ~= nil then
        inst._task:Cancel()
    end
    inst._task = inst:DoTaskInTime(TUNING.ARMOR_RUINSHAT_DURATION, ruinshat_unproc)
end

local function tryproc(inst, owner, data)
    if inst._task == nil and
        not data.redirected and
        math.random() < TUNING.ARMOR_RUINSHAT_PROC_CHANCE then
        ruinshat_proc(inst, owner)
    end
end

local function ruins_onremove(inst)
    if inst._fx ~= nil then
        inst._fx:kill_fx()
        inst._fx = nil
    end
end

local validfn = function(ent,owner)--aoe攻击不攻击阿比盖尔、墙等
    if ent:HasTag("INLIMBO") or ent:HasTag ("companion") or ent:HasTag ("wall") or ent:HasTag("abigail") or ent:HasTag ("shadowminion")
      or (ent.components.follower ~= nil and ent.components.follower.leader == owner)  then
        return false
    else
        return true
    end
end
local function aoeattack(inst, owner)--aoe攻击
	if owner.components.combat ~= nil then
        owner.components.combat:EnableAreaDamage(true)
        if owner.components.combat.areahitrange==nil then
            owner.components.combat:SetAreaDamage(5,1,validfn )
        end
    end
end

local function sporedrop(inst)--释放孢子
    if dropmoon == true then
        local a = math.random(4)
        local b ={"spore_tall","spore_small","spore_medium","spore_moon"}
        --[[if a == 1 then
            inst.components.periodicspawner:SetPrefab("spore_tall")
            inst.components.floater:SetSize("med")
            inst.components.floater:SetScale(0.7)
            print("2")
        elseif a == 2 then
            inst.components.periodicspawner:SetPrefab("spore_small")
            inst.components.floater:SetSize("med")
            print("3")
        elseif a == 3 then
            inst.components.periodicspawner:SetPrefab("spore_medium")
            inst.components.floater:SetSize("med")
            inst.components.floater:SetScale(0.95)
            print("4")
        elseif a == 4 then
            inst.components.periodicspawner:SetPrefab("spore_moon")
            inst.components.floater:SetSize("med")
            print("5")
        end--]]
        return b[a]
   end
end
local function band_disable(inst)
    if inst.updatetask then
        inst.updatetask:Cancel()
        inst.updatetask = nil
    end
    --local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
    --owner.components.leader:RemoveFollowersByTag("pig")
end

local banddt = 1
local FOLLOWER_ONEOF_TAGS = {"pig", "merm", "farm_plant"}
local FOLLOWER_CANT_TAGS = {"werepig", "player"}

local function band_update( inst )--独奏乐器
    local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
    if owner and owner.components.leader then
        local x,y,z = owner.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x,y,z, TUNING.ONEMANBAND_RANGE, nil, FOLLOWER_CANT_TAGS, FOLLOWER_ONEOF_TAGS)
        for k,v in pairs(ents) do
            if v.components.follower and not v.components.follower.leader and not owner.components.leader:IsFollower(v) and owner.components.leader.numfollowers < 30 then
                if v:HasTag("merm") then
                    if v:HasTag("mermguard") then
                        if owner:HasTag("merm") and not owner:HasTag("mermdisguise") then
                            owner.components.leader:AddFollower(v)
                        end
                    else
                        if owner:HasTag("merm") or (TheWorld.components.mermkingmanager and TheWorld.components.mermkingmanager:HasKing()) then
                            owner.components.leader:AddFollower(v)
                        end
                    end
                else
                    owner.components.leader:AddFollower(v)
                end
			elseif v.components.farmplanttendable ~= nil then
				v.components.farmplanttendable:TendTo(owner)
			end
        end

        for k,v in pairs(owner.components.leader.followers) do
            if k.components.follower then
                if k:HasTag("pig") then
                    k.components.follower:AddLoyaltyTime(3)

                elseif k:HasTag("merm") then
                    if k:HasTag("mermguard") then
                        if owner:HasTag("merm") and not owner:HasTag("mermdisguise") then
                            k.components.follower:AddLoyaltyTime(3)
                        end
                    else
                        if owner:HasTag("merm") or (TheWorld.components.mermkingmanager and TheWorld.components.mermkingmanager:HasKing()) then
                            k.components.follower:AddLoyaltyTime(3)
                        end
                    end
                end
            end
        end
   --[[else -- This is for haunted one man band
        local x,y,z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x,y,z, TUNING.ONEMANBAND_RANGE, HAUNTEDFOLLOWER_MUST_TAGS, FOLLOWER_CANT_TAGS)
        for k,v in pairs(ents) do
            if v.components.follower and not v.components.follower.leader  and not inst.components.leader:IsFollower(v) and inst.components.leader.numfollowers < 10 then
                inst.components.leader:AddFollower(v)
                --owner.components.sanity:DoDelta(-TUNING.SANITY_MED)
            end
        end

        for k,v in pairs(inst.components.leader.followers) do
            if k:HasTag("pig") and k.components.follower then
                k.components.follower:AddLoyaltyTime(3)
            end
        end--]]
    end
end

local function band_enable(inst)
    inst.updatetask = inst:DoPeriodicTask(banddt, band_update, 1)
end

local function  kybaoxian(inst,owner)--可以保鲜
    if inst.components.inventory ~= nil then
        for k,v in pairs(inst.components.inventory.itemslots) do
            if v.components.perishable ~= nil then
                v.components.perishable:StopPerishing()
            end
        end
    elseif owner.components.inventory ~= nil then
    for k,v in pairs(owner.components.inventory.itemslots) do
        if v.components.perishable ~= nil then
            v.components.perishable:StopPerishing()
        end
    end
    end
end

local function bkybaoxian(inst,owner)--不可以保鲜
    if inst.components.inventory ~= nil then
        for k,v in pairs(inst.components.inventory.itemslots) do
            if v.components.perishable ~= nil then
                v.components.perishable:StartPerishing()
            end
        end
    elseif owner.components.inventory ~= nil then
    for k,v in pairs(owner.components.inventory.itemslots) do
        if v.components.perishable ~= nil then
            v.components.perishable:StartPerishing()
        end
    end
    end
end

local function bingdong(owner,data) --受到攻击时冰冻
    if data and data.attacker and data.attacker.components.burnable ~= nil then
        if data.attacker.components.burnable:IsBurning() then
            data.attacker.components.burnable:Extinguish()
        elseif data.attacker.components.burnable:IsSmoldering() then
            data.attacker.components.burnable:SmotherSmolder()
        end
    end

    if data and data.attacker and data.attacker.components.freezable ~= nil then
        data.attacker.components.freezable:AddColdness(10)
        data.attacker.components.freezable:SpawnShatterFX()
    end
end


local function test_polly_spawn(inst)
    if not inst.polly and not inst.components.spawner:IsSpawnPending() then
        inst.components.spawner:ReleaseChild()
    end
end

local function pollyremoved(inst)
    inst:RemoveEventCallback("onremoved", pollyremoved ,inst.polly)
    inst.polly = nil        
end

local function getpollyspawnlocation(inst)
    local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner or inst
    local pos = Vector3(owner.Transform:GetWorldPosition())
    local offset = nil
    local count = 0
    while offset == nil and count < 12 do
        offset = FindWalkableOffset(pos, math.random()*2*PI, math.random() * 5, 12, false, false, nil, false, true)
        count = count + 1
    end

    if offset then
        return pos.x+offset.x,15,pos.z+offset.z
    end
end

local function polly_rogers_onoccupied(inst,child)
    inst.polly = nil
    child.components.follower:StopFollowing()
end

local function polly_rogers_onvacate(inst, child)

    if not inst.worn then
        inst.components.spawner:GoHome(child)
        return
    end
           
    local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner or nil
    if owner then
        child.sg:GoToState("glide")
        child.Transform:SetRotation(math.random() * 180)
        child.components.locomotor:StopMoving()
        child.hat = inst
        inst:ListenForEvent("onremoved", pollyremoved ,inst.polly)
    end
end


local function new_on_equip(inst,owner)
    if yingwu == true then
        inst:DoTaskInTime(0,function()
            inst.worn = true
            test_polly_spawn(inst)

            inst.polly = inst.components.spawner.child
            if inst.polly then
                inst.polly.components.follower:SetLeader(owner)
                inst.polly.components.health:SetInvincible(true)
                inst.polly.flyaway = nil
            end
        end)
    end

    if haidao == true then
        owner:AddTag("master_crewman")
    end

    if chuanzhang == true then
        owner:AddTag("boat_health_buffer")
    end

    if notarget == true then 
        owner:AddTag("NOTARGET")
    end
    if baoxian == true then
       owner:ListenForEvent("itemget",kybaoxian)
    end
    if band == true then
        band_enable(inst)
    end
    if bird == true then
        local attractor = owner.components.birdattractor
        if attractor then
            attractor.spawnmodifier:SetModifier(inst, TUNING.BIRD_SPAWN_MAXDELTA_FEATHERHAT, "maxbirds")
            attractor.spawnmodifier:SetModifier(inst, TUNING.BIRD_SPAWN_DELAYDELTA_FEATHERHAT.MIN, "mindelay")
            attractor.spawnmodifier:SetModifier(inst, TUNING.BIRD_SPAWN_DELAYDELTA_FEATHERHAT.MAX, "maxdelay")

            local birdspawner = TheWorld.components.birdspawner
            if birdspawner ~= nil then
                birdspawner:ToggleUpdate(true)
            end
        end
    end
    if milk == true then
        owner:PushEvent("learncookbookstats", inst.prefab)
        owner:AddDebuff("hungerregenbuff", "hungerregenbuff")
    end

    if diukuang == true then
        inst.onattach(owner)
    end

    owner:AddTag("moonsporeprevent")
    if dropmoon == true then
       inst.components.periodicspawner:Start()
    end
   if nophysics == true then--水上行走
    if owner.Physics then
        RemovePhysicsColliders(owner)
    end
   end
    if owner.components.drownable then
        owner.components.drownable.enabled = false
    end
    if owner.components.hunger ~= nil then
        owner.components.hunger.burnratemodifiers:SetModifier(inst, jiesulv)
    end
    --ShouldNotDrown(owner)
    if aoe == true then
    aoeattack(inst, owner)
    end
    if freezed == true then --受攻击冰冻
        inst:ListenForEvent("blocked", bingdong, owner)
        inst:ListenForEvent("attacked", bingdong, owner)
    end
end

local function new_on_unequip(inst,owner)
    if yingwu == true then
        inst.worn = nil
        if inst.pollytask then
            inst.pollytask:Cancel()
            inst.pollytask = nil
        end

        if inst.polly then
            inst.polly.flyaway = true
            inst.polly:PushEvent("flyaway")
        end
    end

    if haidao == true and owner:HasTag("master_crewman") then
        owner:RemoveTag("master_crewman")
    end

    if chuanzhang == true and owner:HasTag("boat_health_buffer") then
        owner:RemoveTag("boat_health_buffer")
    end

    if owner:HasTag("NOTARGET") then
        owner:RemoveTag("NOTARGET")
    end
    if baoxian == true then
        owner:RemoveEventCallback("itemget",kybaoxian)
        bkybaoxian(inst,owner)
    end
    if band == true then
        band_disable(inst)
    end
    if bird == true then
        local attractor = owner.components.birdattractor
        if attractor then
            attractor.spawnmodifier:RemoveModifier(inst)

            local birdspawner = TheWorld.components.birdspawner
            if birdspawner ~= nil then
                birdspawner:ToggleUpdate(true)
            end
        end
    end
    if milk == true then
        owner:RemoveDebuff("hungerregenbuff")
        if owner.components.foodmemory ~= nil then
            owner.components.foodmemory:RememberFood("hungerregenbuff")
        end
    end
    if diukuang == true then
        inst.ondetach()
    end

    owner:RemoveTag("moonsporeprevent")
    if dropmoon == true then
       inst.components.periodicspawner:Stop()
    end
  if nophysics == true then
    if owner.Physics then
        ChangeToCharacterPhysics(owner)
    end
  end
    if owner.components.drownable ~=nil then
        owner.components.drownable.enabled = true
    end
     if owner.components.hunger ~= nil then
        owner.components.hunger.burnratemodifiers:RemoveModifier(inst)
    end
    --ShouldDrown(owner)
    if aoe == true then
      if owner.components.combat ~= nil then
        owner.components.combat:EnableAreaDamage(false)
      end
    end
    if freezed == true then 
        inst:RemoveEventCallback("blocked", bingdong, owner)
        inst:RemoveEventCallback("attacked", bingdong, owner)
    end
end

local function insulatorstate(inst)--冬暖夏凉
    if inst.components.insulator ~= nil then
        inst:RemoveComponent("insulator")
    end
    if TheWorld.state.iswinter then
        inst:AddComponent("insulator")
        inst.components.insulator:SetWinter()
        inst.components.insulator:SetInsulation(240)
    elseif TheWorld.state.issummer then
        inst:AddComponent("insulator")
        inst.components.insulator:SetSummer()
        inst.components.insulator:SetInsulation(240)
    end
end

local function ItemTradeTest(inst, item)
    if item == nil then
        return false
    elseif item.prefab ~= "opalpreciousgem" then
        return false
    end
    return true
end

local function OnGivenItem(inst, giver, item)
    c_give("alterguardianhatshard",1)
end

AddPrefabPostInit("alterguardianhat",
function(inst)
		if inst and inst.components and inst.components.equippable then
            inst.components.equippable.walkspeedmult = speed
            inst.components.equippable.insulated = true
            local old_on_equip = inst.components.equippable.onequipfn
            inst.components.equippable:SetOnEquip(
				function(_inst, _owner)
					new_on_equip(_inst, _owner)
					old_on_equip(_inst, _owner)
                end
            )
            local old_on_unequip = inst.components.equippable.onunequipfn
			inst.components.equippable:SetOnUnequip(
				function(_inst, _owner)
					old_on_unequip(_inst, _owner)
					new_on_unequip(_inst, _owner)
				end
            )
        end
    insulatorstate(inst)
    sporedrop(inst)
    inst:AddTag("dustresistance")
    inst:AddComponent("armor")
    inst.components.armor:InitIndestructible(fangyu)
	inst:AddTag("hide_percentage")

    if fangshui == false then 
        if inst.components.waterproofer ~= nil then
            inst:RemoveComponent("waterproofer")
        end
    end
    if fangshui == true then 
        if inst.components.waterproofer == nil then 
            inst:AddComponent("waterproofer")
            inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_ABSOLUTE)
        end
    end

    if yingwu == true then
        inst:AddComponent("spawner")
        inst.components.spawner:Configure("polly_rogers", TUNING.POLLY_ROGERS_SPAWN_TIME)
        inst.components.spawner.onvacate = polly_rogers_onvacate
        inst.components.spawner.onoccupied = polly_rogers_onoccupied
        inst.components.spawner.overridespawnlocation = getpollyspawnlocation
        inst.components.spawner:CancelSpawning()
    end

    inst:AddComponent("periodicspawner")
    inst.components.periodicspawner:SetRandomTimes(10, 1, true)
    inst.components.periodicspawner:SetPrefab(sporedrop)

    inst:AddComponent("trader")
    inst.components.trader:SetAbleToAcceptTest(ItemTradeTest)
    inst.components.trader.onaccept = OnGivenItem

    if diukuang == true then
    inst.OnRemoveEntity = ruins_onremove
    inst._fx = nil
        inst._task = nil
        inst._owner = nil
        inst.procfn = function(owner, data) tryproc(inst, owner, data) end
        inst.onattach = function(owner)
            if inst._owner ~= nil then
                inst:RemoveEventCallback("attacked", inst.procfn, inst._owner)
                inst:RemoveEventCallback("onremove", inst.ondetach, inst._owner)
            end
            inst:ListenForEvent("attacked", inst.procfn, owner)
            inst:ListenForEvent("onremove", inst.ondetach, owner)
            inst._owner = owner
            inst._fx = nil
        end
        inst.ondetach = function()
            ruinshat_unproc(inst)
            if inst._owner ~= nil then
                inst:RemoveEventCallback("attacked", inst.procfn, inst._owner)
                inst:RemoveEventCallback("onremove", inst.ondetach, inst._owner)
                inst._owner = nil
                inst._fx = nil
            end
        end
    end

    if shufu == true then
        inst:WatchWorldState("isday", insulatorstate)
    elseif shufu == false then
        inst:StopWatchingWorldState("isday", insulatorstate)
        if inst.components.insulator ~= nil then
           inst:RemoveComponent("insulator")
        end
    end

end
)
if nophysics == true then
 AddComponentPostInit("drownable", function(drownable,inst)--水上漂
	local oldShouldDrownFn=drownable.ShouldDrown
	drownable.ShouldDrown=function (self)
	if self.inst:HasTag("moonsporeprevent") and self.inst:HasTag("player")  then--有标签不会落水
    return false
	end
	if oldShouldDrownFn then
	return oldShouldDrownFn(self)
	end
	    return self.enabled
        and self:IsOverWater()
        and (self.inst.components.health == nil or not self.inst.components.health:IsInvincible())
	end
 end)
end

if dustproof == true then--防尘
    AddPlayerPostInit(
        function(player)
            player.last_tag = nil
            player:ListenForEvent("changearea",
            function(inst,data)
                if TheWorld.ismastersim then
                    local hat = player.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
                    if hat and hat:HasTag("dustresistance") then
                        local indust =
                        (TheWorld.components.sandstorms and TheWorld.components.sandstorms:IsInSandstorm(player))or
                        (TheWorld.net.components.moonstorms and TheWorld.net.components.moonstorms:IsInMoonstorm(player))
                        local tag = false
                        if indust then
                            hat:AddTag("goggles")
                            tag = true
                        else
                            hat:RemoveTag("goggles")
                        end
                        if player.last_tag == nil or tag ~= player.last_tag then
                            player:PushEvent("unequip", {item = hat, eslot = EQUIPSLOTS.HEAD})
							player:PushEvent("equip", {item = hat, eslot = EQUIPSLOTS.HEAD})
							player.last_tag = tag
                        end
                    end
                end
            end)
        end
    )
end