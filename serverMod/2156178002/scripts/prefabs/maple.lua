local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
	Asset( "ANIM", "anim/maple.zip" ),
	Asset( "ANIM", "anim/maple_angel.zip" ),
	Asset( "ANIM", "anim/maple_mecha.zip" ),
	Asset( "ANIM", "anim/maple_mecha_angel.zip" ),
}
local prefabs = {
}

-- Custom starting inventory
local start_inv = {
	"shield",
}

-- When the character is revived from human
local function onbecamehuman(inst)
	-- Set speed when not a ghost (optional)
	inst.components.locomotor:SetExternalSpeedMultiplier(inst, "maple_speed_mod", TUNING.MAPLE_SPEED)
	--inst:DoTaskInTime(5, function() inst:SetStateGraph("SGwilson") end)
end

local function onbecameghost(inst)
	-- Remove speed modifier when becoming a ghost
   inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "maple_speed_mod")
end

-- When loading or spawning the character
local function onload(inst)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    inst:ListenForEvent("ms_becameghost", onbecameghost)

    if inst:HasTag("playerghost") then
        onbecameghost(inst)
    else
		onbecamehuman(inst)
		
		--Black Rose Armor
		if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) == nil then
			inst.components.combat.externaldamagetakenmultipliers:SetModifier("ArmorModifier", 0.2)
			inst:AddTag("BlackRose")
		end
		if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) ~= nil then
			inst.components.combat.externaldamagetakenmultipliers:SetModifier("ArmorModifier", 1)
			inst:RemoveTag("BlackRose")
		end	
		
		inst.AnimState:ClearSymbolExchanges()
		if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) ~= nil then
			if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS):HasTag("theshield") then
				inst.AnimState:SetMultiSymbolExchange("swap_object", "SWAP_FACE")
			end
			if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS):HasTag("thecannon") then
				inst.AnimState:SetMultiSymbolExchange("swap_object", "skirt")
			end
		end	
		--inst:DoTaskInTime(5, function() inst:SetStateGraph("SGwilson") end)
		--inst:DoTaskInTime(1, function() inst:PushEvent("buildmanagement") end)
		inst:PushEvent("buildmanagement")
    end
	
end

-- This initializes for both the server and client. Tags can be added here.
local common_postinit = function(inst) 
	-- Minimap icon
	inst.MiniMapEntity:SetIcon( "maple.tex" )
end

local function onsave(inst, data)

	data.maplebonushealth = inst.maplebonushealth

end

local function onpreload(inst, data)

	inst.maplebonushealth = data.maplebonushealth
	inst.components.health.maxhealth = TUNING.MAPLE_BASE_HEALTH + inst.maplebonushealth

end

local function ApplyBuff(buffData, instToBuff)
	local buffUniqueName = buffData.uniqueName
	
	if instToBuff[buffUniqueName.."Task"] ~= nil then
		buffData.removeFunction(instToBuff)
		instToBuff[buffUniqueName.."Task"]:Cancel()
		instToBuff[buffUniqueName.."Task"] = nil
	end
	
	local buffOnSave = function(self, inst, data)
		if inst[buffUniqueName.."Task"] ~= nil then
			buffData.removeFunction(inst)
			inst[buffUniqueName.."Task"]:Cancel()
			inst[buffUniqueName.."Task"] = nil
		end
	end
	
	if instToBuff.OnSave ~= nil then
		local oldOnSave = instToBuff.OnSave
		instToBuff.OnSave = function(self, inst, data)
			buffOnSave(self, inst, data)
			oldOnSave(self, inst, data)
		end
	else
		instToBuff.OnSave = buffOnSave
	end
	
	buffData.applyFunction(instToBuff)
	instToBuff[buffUniqueName.."Task"] = instToBuff:DoTaskInTime(buffData.duration, function(inst)
		buffData.removeFunction(inst)
		inst[buffUniqueName.."Task"] = nil
	end)
end

local Buffs = {}
local function CreateBuff(uniqueName, duration, applyFunction, removeFunction)
	local newBuff = {}
	newBuff.uniqueName = uniqueName
	newBuff.duration = duration
	newBuff.applyFunction = applyFunction
	newBuff.removeFunction = removeFunction
	Buffs[uniqueName] = newBuff
end

CreateBuff("BuffCeption", 5,
	function(inst)
		inst:AddTag("DontRemovePoison")
	end,
	function(inst)
		inst:RemoveTag("DontRemovePoison")
	end
)
local function DoPoisonDamage(inst)
    inst.components.health:DoDelta(-TUNING.MAPLE_POISON, true, "poison")
end
CreateBuff("PoisonDebuff", 5.1,
	function(inst)
		if inst.poisontask == nil then
			inst.poisontask = inst:DoPeriodicTask(1/2, DoPoisonDamage)
			inst.AnimState:SetMultColour(0.8,0.2,1,1)
		end
		ApplyBuff(Buffs["BuffCeption"], inst)
	end,
	function(inst)
		if not inst:HasTag("DontRemovePoison") then
			if inst.poisontask ~= nil then
				inst.poisontask:Cancel()
				inst.poisontask = nil
				inst.AnimState:SetMultColour(1,1,1,1)
			end
		end
	end
)

CreateBuff("DealLaserDamage", 0.6,
	function(inst)
		inst:AddTag("LaserProtection")
		inst.components.health:DoDelta((-TUNING.MAPLE_LASER_DAMAGE+1))
	end,
	function(inst)
		inst:RemoveTag("LaserProtection")
	end
)


local function SpawnLaser(inst)
    local numsteps = 50
    local x, y, z = inst.Transform:GetWorldPosition()
    local angle = (inst.Transform:GetRotation() + 90) * DEGREES
    local step = .75
    local offset = 2 - step
    local ground = TheWorld.Map
    local targets, skiptoss = {}, {}
    local i = -1
    local noground = false
    local fx, dist, delay, x1, z1
    while i < numsteps do
        i = i + 1
        dist = i * step + offset
        delay = math.max(0, i - 1)
        x1 = x + dist * math.sin(angle)
        z1 = z + dist * math.cos(angle)
        if not ground:IsPassableAtPoint(x1, 0, z1) then
            if i <= 0 then
                return
            end
            noground = true
        end
        fx = SpawnPrefab(i > 0 and "mechacannon_laser" or "deerclops_laserempty")
        fx.caster = inst
        fx.Transform:SetPosition(x1, 0, z1)
        fx:Trigger(delay * FRAMES, targets, skiptoss)
        if i == 0 then
            ShakeAllCameras(CAMERASHAKE.FULL, .7, .02, .6, fx, 30)
        end
        if noground then
            break
        end
    end

    if i < numsteps then
        dist = (i + .5) * step + offset
        x1 = x + dist * math.sin(angle)
        z1 = z + dist * math.cos(angle)
    end
    fx = SpawnPrefab("mechacannon_laser")
    fx.Transform:SetPosition(x1, 0, z1)
    fx:Trigger((delay + 1) * FRAMES, targets, skiptoss)

    fx = SpawnPrefab("mechacannon_laser")
    fx.Transform:SetPosition(x1, 0, z1)
    fx:Trigger((delay + 2) * FRAMES, targets, skiptoss)
end


	--Level Up
local function OnEat(inst, food)
    if food.entity:HasTag("monstermeat") and food.entity:HasTag("cookable") then
	
		if (TUNING.MAPLE_BASE_HEALTH + inst.maplebonushealth) <= (TUNING.MAPLE_MAXIMUM_HEALTH - TUNING.MAPLE_LVLUP) then
			inst.maplebonushealth = inst.maplebonushealth + TUNING.MAPLE_LVLUP
			inst.components.health.maxhealth = TUNING.MAPLE_BASE_HEALTH + inst.maplebonushealth
		elseif (TUNING.MAPLE_BASE_HEALTH + inst.maplebonushealth) < (TUNING.MAPLE_MAXIMUM_HEALTH) then
			inst.maplebonushealth = (TUNING.MAPLE_MAXIMUM_HEALTH - TUNING.MAPLE_BASE_HEALTH)
			inst.components.health.maxhealth = TUNING.MAPLE_BASE_HEALTH + inst.maplebonushealth
		end
	end
end
	
	
local function ReloadShield(inst)
	inst.daily_shield_recharge = 1
	if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) ~= nil then 
		if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS):HasTag("theshield") then
			inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).components.fueled:SetPercent(inst.daily_shield_recharge)
		end
	end
end
	
local function OnBlocked(inst, data) 
--print ("Blocked")
	if inst:HasTag("BlackRose") then
		inst.SoundEmitter:PlaySound("dontstarve/wilson/hit_marble")
	end
	
	-- Maple don't want to get hurt
	if inst.components.health and not inst.components.health:IsDead() then
		local PercentMissingHealth = (100*(1-(inst.components.health.currenthealth/inst.components.health.maxhealth)))
		--print ("PercentMissingHealth", PercentMissingHealth)
		if PercentMissingHealth >= 20 then
			local SanityLoss = (PercentMissingHealth/20)
			--print ("SanityLoss", SanityLoss)
			inst.components.sanity:DoDelta(-SanityLoss, true)
		end
	end
end
	
local function OnAttack(inst, data)
	local mapleisnear = false
	if data.target and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) ~= nil then
		local x,y,z = data.target.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, 18, {"maple"}, nil, nil)
		for i, v in ipairs(ents) do
			mapleisnear = true
		end
		if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS):HasTag("thecannon") then

			if not inst:HasTag("StopLaser") and mapleisnear == true then
				inst:AddTag("StopLaser")
				SpawnLaser(inst)
				inst.SoundEmitter:PlaySound("dontstarve/creatures/bishop/charge")
				inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/laser")
				inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).components.fueled:DoDelta(-TUNING.MAPLE_LASER_AMMO)
				inst:DoTaskInTime(0.7, function() inst:RemoveTag("StopLaser") end)
			end
			if data.target and data.target.components.health and not data.target.components.health:IsDead() then
				if not data.target:HasTag("LaserProtection") then
					ApplyBuff(Buffs["DealLaserDamage"], data.target)
				end
			end
			if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).components.fueled:IsEmpty() then
				--inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS):Remove()
				inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).components.equippable.restrictedtag = "empty_weapon"
				inst:DoTaskInTime(0.7, function() 
				if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) ~= nil then
					if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS):HasTag("thecannon") then
						inst.components.inventory:DropItem(inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)) 
					end
				end
				end)
			end
		end
	end
end


local function itemequip(inst, data)

	--Armor of the Black Rose
	if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) == nil then
		inst.components.combat.externaldamagetakenmultipliers:SetModifier("ArmorModifier", 0.2)
		inst:AddTag("BlackRose")
	end
	if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) ~= nil then
		inst.components.combat.externaldamagetakenmultipliers:SetModifier("ArmorModifier", 1)
		inst:RemoveTag("BlackRose")
	end	

	--Shield protection
	if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) ~= nil and not inst:HasTag("ShieldOn") then
		if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS):HasTag("theshield") then
			inst.components.combat.externaldamagetakenmultipliers:SetModifier("ShieldModifier", TUNING.MAPLE_PROTECTION)
			inst:AddTag("ShieldOn")
		end
	end	
	
	--Cannon attack speed
	inst.components.combat.min_attack_period = 0.4
	if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) ~= nil then
		if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS):HasTag("thecannon") then
			inst.components.combat.min_attack_period = 0.8
		end
	end	

	if inst.components.health and not inst.components.health:IsDead() then
		inst:PushEvent("buildmanagement")
		--if not TUNING.MAPLE_HIDE == 1 then
			--inst:PushEvent("hidethings")
		--end
	end
	
	
end
	
local function itemunequip(inst, data)

	--Armor of the Black Rose
	if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) == nil then
		inst.components.combat.externaldamagetakenmultipliers:SetModifier("ArmorModifier", 0.2)
		inst:AddTag("BlackRose")
	end
	if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) ~= nil then
		inst.components.combat.externaldamagetakenmultipliers:SetModifier("ArmorModifier", 1)
		inst:RemoveTag("BlackRose")
	end
	
	--Shield protection	
	if inst:HasTag("ShieldOn") then
		if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) == nil then
			inst.components.combat.externaldamagetakenmultipliers:SetModifier("ShieldModifier", 1)
			inst:RemoveTag("ShieldOn")
		end
	end
	if inst:HasTag("ShieldOn") then
		if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) ~= nil then
			if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS):HasTag("theshield") then
				inst.components.combat.externaldamagetakenmultipliers:SetModifier("ShieldModifier", 1)
				inst:RemoveTag("ShieldOn")
			end
		end
	end
	
	--Cannon attack speed
	inst.components.combat.min_attack_period = 0.4
	if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) ~= nil then
		if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS):HasTag("thecannon") then
			inst.components.combat.min_attack_period = 0.8
		end
	end	
	
	if inst.components.health and not inst.components.health:IsDead() then
		inst:PushEvent("buildmanagement")
	end
end


local function Oncastaoespell(inst)
	local handitem = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	if handitem ~= nil then
		if handitem:HasTag("themoondagger") then
			if handitem.components.fueled then
				handitem.components.fueled:DoDelta(-10)
				-- if inst.owner.components.fueled.currentfuel <= 10 then
					-- inst.owner:RemoveComponent("aoetargeting")
					-- inst.owner:RemoveComponent("aoespell")
					-- inst.owner:RemoveComponent("reticule_spawner")
				-- end

				if handitem.components.fueled:IsEmpty() then
					--inst.owner:Remove()
					--inst.owner:DoTaskInTime(0.1, function() inst.owner:Remove() end)
					
					handitem.components.equippable.restrictedtag = "empty_weapon"
					handitem.components.inventoryitem.owner.components.inventory:DropItem(handitem.components.inventoryitem.owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS))
				end
			end
		end
	end
end




local function OnPickup(inst, data)	--inst is player, data.item is item
	if data.item:HasTag("theshield") then
		data.item.components.fueled:SetPercent(inst.daily_shield_recharge)
	end
end



local function BuildManagement(inst)
	if inst.components.health and not inst.components.health:IsDead() then
		if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) ~= nil then
			if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD):HasTag("thehalo") then
				if not inst:HasTag("Angel") then
					inst.components.sanityaura.aura = TUNING.SANITYAURA_TINY
					inst.entity:AddLight()
					inst.Light:SetRadius(5.0)
					inst.Light:SetFalloff(0.40)
					inst.Light:SetIntensity(0.99)
					inst.Light:SetColour(255/255,255/255,20/255)
					inst.Light:Enable(true)
				end
				inst:AddTag("Angel")
			else
				inst:RemoveTag("Angel")
				inst.components.sanityaura.aura = 0
				inst.Light:Enable(false)
			end
		else
			inst:RemoveTag("Angel")
			inst.components.sanityaura.aura = 0
			inst.Light:Enable(false)
		end
		
		if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) ~= nil then
			if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS):HasTag("thecannon") then
				inst:AddTag("Mecha")
			else
				inst:RemoveTag("Mecha")
			end
			if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS):HasTag("theshield") then
				inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).components.fueled:SetPercent(inst.daily_shield_recharge)
			end
		else
			inst:RemoveTag("Mecha")
		end

		if inst:HasTag("Angel") and inst:HasTag("Mecha") then
			inst.AnimState:SetBuild("maple_mecha_angel")
			--inst:SetStateGraph("SGmaple")
		elseif inst:HasTag("Angel") then
			inst.AnimState:SetBuild("maple_angel")
			--inst:DoTaskInTime(5, function() inst:SetStateGraph("SGwilson") end)
		elseif inst:HasTag("Mecha") then
			inst.AnimState:SetBuild("maple_mecha")
			--inst:SetStateGraph("SGmaple")
		else
			inst.AnimState:SetBuild("maple")
			--inst:DoTaskInTime(5, function() inst:SetStateGraph("SGwilson") end)
		end
	end
end

-- Angel code start
local onEndAura = function(receiver, applierGUID, AngelAura)
	if not receiver or not receiver:IsValid() then
		return
	end
	if receiver[AngelAura] then
		receiver[AngelAura]:Cancel()
		receiver[AngelAura] = nil
	end
	if receiver.components.combat then
		receiver.components.combat.externaldamagetakenmultipliers:RemoveModifier(applierGUID, "AngelArmor")
	end
end

local onApplyAura = function(receiver, applier)

	if not receiver or not receiver:IsValid() then
		return
	end

	local applierGUID = applier.GUID
	
	local AngelAura = "AngelArmorAura"..applierGUID
	
	if receiver.components.combat then
		receiver.components.combat.externaldamagetakenmultipliers:SetModifier(applierGUID, TUNING.MAPLE_HALO_PROTECTION, "AngelArmor")
	end
	
	local endAngelAura = "endAngelArmorAura"..applierGUID
	
	if receiver[endAngelAura] then
		receiver[endAngelAura]:Cancel()
		receiver[endAngelAura] = nil
	end
	
	receiver[endAngelAura] = receiver:DoTaskInTime(2.0, onEndAura, applierGUID, AngelAura)
end

local applyAuraInRange = function(inst)
	if inst:HasTag("Angel") then

		local x,y,z = inst.Transform:GetWorldPosition()
		
		local ents = TheSim:FindEntities(x, y, z, 5, {"player"}, {"playerghost", "INLIMBO"}, nil)
		
		for i, v in ipairs(ents) do
			onApplyAura(v, inst)
		end
	end
end
-- Angel code end



-- This initializes for the server only. Components are added here.
local master_postinit = function(inst)
    inst:AddTag("maple")

	-- Uncomment if "wathgrithr"(Wigfrid) or "webber" voice is used
    --inst.talker_path_override = "dontstarve_DLC001/characters/"	
	inst.soundsname = "willow"
	
	-- Stats	
	inst.components.health:SetMaxHealth(TUNING.MAPLE_BASE_HEALTH)
	inst.components.hunger:SetMax(TUNING.MAPLE_BASE_HUNGER)
	inst.components.sanity:SetMax(TUNING.MAPLE_BASE_SANITY)
    inst.components.combat.damagemultiplier = 0.5
	inst.components.hunger.hungerrate = 1 * TUNING.WILSON_HUNGER_RATE
	inst.components.locomotor.walkspeed = 1 * TUNING.WILSON_WALK_SPEED
	inst.components.locomotor.runspeed = 1 * TUNING.WILSON_RUN_SPEED
	inst.components.locomotor:SetExternalSpeedMultiplier(inst, "maple_speed_mod", TUNING.MAPLE_SPEED)
	
	inst:ListenForEvent("attacked", function(inst, data) OnBlocked(inst, data) end)
	if TUNING.MAPLE_PROTECTION == 0 then
		inst:ListenForEvent("blocked", function(inst, data) OnBlocked(inst, data) end)
	end
	inst:ListenForEvent("onattackother", function(inst, data) OnAttack(inst, data) end)
	inst:ListenForEvent("equip", function(inst, data) itemequip(inst, data) end)
	inst:ListenForEvent("unequip", function(inst, data) itemunequip(inst, data) end)
	inst:ListenForEvent("buildmanagement", function(inst) BuildManagement(inst) end)
	inst:ListenForEvent("oncastaoespell", function(inst) Oncastaoespell(inst) end)
	inst:ListenForEvent("itemget", OnPickup)
	
	--inst:ListenForEvent("hidethings", function(inst) HideThings(inst) end)
	

	
	
	-- Angel
	inst:AddComponent("sanityaura")
	inst:DoPeriodicTask(0.2, applyAuraInRange)
	
	if inst.maplebonushealth == nil then
		inst.maplebonushealth = 0
	end
	
	inst.components.eater:SetOnEatFn(OnEat)
	if TUNING.MAPLE_EAT then
        inst.components.eater.strongstomach = true
    end
	
	inst.OnSave = onsave
	inst.OnLoad = onload
    inst.OnNewSpawn = onload
	inst.OnPreLoad = onpreload
	
	
	
	
	
	
	if not TheWorld.ismastersim then 
		return inst
	end;	
	
	inst.daily_shield_recharge = 1
	inst:WatchWorldState( "startday", function(inst) ReloadShield(inst) end )
	inst:WatchWorldState( "startcaveday", function(inst) ReloadShield(inst) end )
	ReloadShield(inst)
	
	
	return inst
end

return MakePlayerCharacter("maple", prefabs, assets, common_postinit, master_postinit, start_inv)
