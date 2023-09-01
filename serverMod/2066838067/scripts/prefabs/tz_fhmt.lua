local TzEntity = require("util/tz_entity")
local TzWeaponSkill = require("util/tz_weaponskill")
local TzFh = require("util/tz_fh")

local assets = {
    Asset("ANIM", "anim/tz_fhmt.zip"),
    Asset("IMAGE", "images/inventoryimages/tz_fhmt.tex"),
    Asset("ATLAS", "images/inventoryimages/tz_fhmt.xml")
}

local function night(inst, isnight)
	if isnight then
		if inst._fxaa == nil then
			inst._fxaa = SpawnPrefab("nightstickfire") --minerhatlight
			inst._fxaa.Light:SetRadius(8)
			inst._fxaa.entity:SetParent(inst.entity)
			inst._fxaa.Transform:SetPosition(0, 0, 0)
		end
	elseif inst._fxaa ~= nil then
		inst._fxaa:Remove()
		inst._fxaa = nil
	end
end

					
local function OnEaten(inst, eater)
	if eater:HasTag("player") then
		eater:AddDebuff("tz_fhmt_buff", "tz_fhmt_buff")
		-- eater:AddDebuff("buff_electricattack", "buff_electricattack")
		-- eater:AddDebuff("buff_moistureimmunity", "buff_moistureimmunity")
		inst.components.fueled:DoDelta(307)
	end
end

local function onbecamehuman(inst)
	if inst.components.freezable and inst.components.freezable.tzsAddColdness == nil then
		inst.components.freezable.tzsAddColdness = inst.components.freezable.AddColdness
		function inst.components.freezable:AddColdness(...)end
	end
end

local priority = 2
local function OnAttached(inst, target)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) 
   
   target:AddTag("moistureimmunity")
    if target.components.moisture ~= nil then
        target.components.moisture:ForceDry(true, inst)
        target.components.moisture:SetWaterproofInventory(true)
    end
	
	if target.components.electricattacks == nil then
        target:AddComponent("electricattacks")
    end
    target.components.electricattacks:AddSource(inst)
    if inst._onattackother == nil then
        inst._onattackother = function(attacker, data)
            if data.weapon ~= nil then
                if data.projectile == nil then
                    --in combat, this is when we're just launching a projectile, so don't do FX yet
                    if data.weapon.components.projectile ~= nil then
                        return
                    elseif data.weapon.components.complexprojectile ~= nil then
                        return
                    elseif data.weapon.components.weapon:CanRangedAttack() then
                        return
                    end
                end
                if data.weapon.components.weapon ~= nil and data.weapon.components.weapon.stimuli == "electric" then
                    --weapon already has electric stimuli, so probably does its own FX
                    return
                end
            end
            if data.target ~= nil and data.target:IsValid() and attacker:IsValid() then
                SpawnPrefab("electrichitsparks"):AlignToTarget(data.target, data.projectile ~= nil and data.projectile:IsValid() and data.projectile or attacker, true)
            end
        end
        inst:ListenForEvent("onattackother", inst._onattackother, target)
    end
    SpawnPrefab("electricchargedfx"):SetTarget(target)
	
	-- inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman,target)
	onbecamehuman(target)
	
	inst.fire_damage_scale = target.components.health.fire_damage_scale
	target.components.health.fire_damage_scale = 0
	
	target.components.locomotor:SetExternalSpeedMultiplier(inst, "tz_fhmt_buff", 1.25)
	
	target.components.combat.externaldamagemultipliers:SetModifier("tz_fhmt_buff", 1.25)
	
    target.tzs_fhmt_buff = true

end

local function OnExtended(inst, target)
    inst.components.timer:StopTimer("buffover")
    inst.components.timer:StartTimer("buffover", TUNING.TOTAL_DAY_TIME)
    
	SpawnPrefab("electricchargedfx"):SetTarget(target)
end

local function OnDetached(inst, target)
	target:RemoveTag("moistureimmunity")
    if target.components.moisture ~= nil then
        target.components.moisture:ForceDry(false, inst)
        target.components.moisture:SetWaterproofInventory(false)
    end
	
	if target.components.electricattacks ~= nil then
        target.components.electricattacks:RemoveSource(inst)
    end
    if inst._onattackother ~= nil then
        inst:RemoveEventCallback("onattackother", inst._onattackother, target)
        inst._onattackother = nil
    end
	
	if target.components.freezable and target.components.freezable.tzsAddColdness ~= nil then
		target.components.freezable.AddColdness = target.components.freezable.tzsAddColdness
	end
	-- inst:RemoveEventCallback("ms_respawnedfromghost", onbecamehuman,target)
	
	target.components.health.fire_damage_scale = inst.fire_damage_scale or 1
	
	target.components.locomotor:RemoveExternalSpeedMultiplier(inst)
	
	target.components.combat.externaldamagemultipliers:RemoveModifier("tz_fhmt_buff")
	
	target.tzs_fhmt_buff = false

    inst:Remove()
end
local function OnTimerDone(inst, data)
    if data.name == "buffover" then
        inst.components.debuff:Stop()
    end
end
local function fn()
        local inst = CreateEntity()
        if not TheWorld.ismastersim then
            inst:DoTaskInTime(0, inst.Remove)
            return inst
        end
        inst.entity:AddTransform()

        inst.entity:Hide()
        inst.persists = false
        inst:AddTag("CLASSIFIED")

        inst:AddComponent("debuff")
        inst.components.debuff:SetAttachedFn(OnAttached)
        inst.components.debuff:SetDetachedFn(OnDetached)
        inst.components.debuff:SetExtendedFn(OnExtended)
        inst.components.debuff.keepondespawn = true

        inst:AddComponent("timer")
        inst.components.timer:StartTimer("buffover", TUNING.TOTAL_DAY_TIME)
        inst:ListenForEvent("timerdone", OnTimerDone)

        return inst
end

return TzEntity.CreateNormalInventoryItem({
    assets = assets,
    prefabname = "tz_fhmt",
    tags = {"tz_fhmt","tz_fanhao"},
    bank = "tz_fhmt",
    build = "tz_fhmt",
    anim = "idle",
    loop_anim = true,
	
	-- inventoryitem_data = {
		-- imagename = "tz_fhym",
		-- atlasname = "tz_fhym",
	-- },

    clientfn = function(inst)
        TzFh.AddFhLevel(inst,true)
        TzFh.AddOwnerName(inst)
    end,
    serverfn = function(inst)
        TzFh.MakeWhiteList(inst)
        TzFh.AddFueledComponent(inst)
        TzFh.SetReturnSpiritualism(inst)
		
		-- inst:AddComponent("edible")
		-- inst.components.edible.foodtype = FOODTYPE.GENERIC --FOODTYPE.GOODIES
		-- inst.components.edible.healthvalue = 25
		-- inst.components.edible.hungervalue = 25
		-- inst.components.edible.sanityvalue = 25
		-- inst.components.edible:SetOnEatenFn(OnEaten)

		inst:WatchWorldState("isnight", night)
		night(inst, TheWorld.state.isnight)
        
    end,
}),Prefab("tz_fhmt_buff", fn)
