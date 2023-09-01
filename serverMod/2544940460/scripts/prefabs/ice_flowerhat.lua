local assets=
{
	Asset("ANIM", "anim/ice_flowerhat.zip"),
	Asset("ATLAS", "images/inventoryimages/ice_flowerhat.xml"),
}

--多倍暴击
local function update_multiple_name(inst)
	inst.multiple_name = "采收暴击次数上限："..inst.multiple_pick.." \n"
	inst.components.named:SetName(inst.double_name..
		inst.multiple_name)
end
local function OnGetItemFromPlayer(inst, giver, item)
	if item and item.prefab == "glommerwings" then
		if inst.multiple_pick < inst.max_multiple_pick then
			inst.multiple_pick = inst.multiple_pick + 1
			update_multiple_name(inst)
		else
			giver.components.talker:Say("采收暴击次数已达上限！")
			giver.components.inventory:GiveItem(SpawnPrefab("glommerwings"))
		end
	end
end
local function AcceptTest(inst, item)
    return item.prefab == "glommerwings"
end
local function OnRefuseItem(inst, giver, item)
	local max_multiple_pick = inst.max_multiple_pick
	if item then
		local str1 = "给予格罗姆翅膀，提升采收暴击的次数上限。 \n"
		local str2 = "初始上限为2，最大上限为"..max_multiple_pick.."。 \n"
		giver.components.talker:Say(str1..str2)
	end
end
local function onpreload(inst, data)
	if data then
		if data.multiple_pick then
			inst.multiple_pick = data.multiple_pick
		end
		if data.double_name then
			inst.double_name = data.double_name
		end
	end
end
local function onsave(inst, data)
	data.multiple_pick = inst.multiple_pick
	data.double_name = inst.double_name
end

local cannot_double_pick = {
	["statueglommer"] = true,
	["archive_switch"] = true,--华丽基座
}
local function pick_for_pickable_once_before(picker, data)
	if data.object ~= nil and data.object.components.pickable ~= nil and data.object.components.pickable.product ~= nil 
	and not cannot_double_pick[data.object.prefab] then
		local item = SpawnPrefab(data.object.components.pickable.product)
		if item.components.stackable then
			item.components.stackable:SetStackSize(data.object.components.pickable.numtoharvest)
		end
		picker.components.inventory:GiveItem(item, nil, data.object:GetPosition())

		if (data.object.prefab == "cactus" or data.object.prefab == "oasis_cactus" ) and data.object.has_flower then
			local item2 = SpawnPrefab("cactus_flower")
			picker.components.inventory:GiveItem(item2, nil, data.object:GetPosition())
		end
	end
end
local function pick_for_crop_once_before(picker, data)
	if data.object ~= nil and data.object.components.pickable ~= nil 
	and data.object.components.pickable.use_lootdropper_for_product ~= nil then
        local loot = {}
		for _, prefab in ipairs(data.object.components.lootdropper:GenerateLoot()) do
			table.insert(loot, data.object.components.lootdropper:SpawnLootPrefab(prefab))
		end
        for i, item in ipairs(loot) do
			if item.components.inventoryitem ~= nil then
                picker.components.inventory:GiveItem(item, nil, data.object:GetPosition())
			end
        end
	end
end
local function onpick(picker, data)
	local inst = ( picker ~= nil and picker.components.inventory ~= nil and picker.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) ) or nil
	if inst ~= nil and inst.prefab == "ice_flowerhat" then
		inst.components.ifhexperience:Pick_exp_up(picker, data)

		local pick_probability = inst.components.ifhexperience.pick_probability
		math.randomseed(os.time())
		if math.random() <= pick_probability then
			for count = 2, inst.multiple_pick_enable and inst.multiple_pick or 2 do
				pick_for_pickable_once_before(picker, data)
				pick_for_crop_once_before(picker, data)
			end
		end
	end
end

local function keep_recover_health_fn(owner)
	local max_health = owner.components.health.maxhealth
	local total_recover_health = max_health * 0.3
	local recover_health_duration = 2
	local health_increase_duration = 1
	local recover_health_count = recover_health_duration / health_increase_duration
	local recover_health_per_count = total_recover_health / recover_health_count

	owner.recover_health_task = owner:DoPeriodicTask(health_increase_duration, function(owner)
		if not owner.components.health:IsDead() then
			owner.components.health:DoDelta( recover_health_per_count, nil, nil, nil, nil, true)
		end
	end, 0)
	owner.recover_health_task_cancel = owner:DoTaskInTime(recover_health_duration-0.1, function(owner)
		owner.recover_health_task:Cancel()
		owner.is_recover_health = 0
	end)
end
local function recover_health_fn(owner)
	if owner.is_recover_health == 0 then
		owner.is_recover_health = 1
		keep_recover_health_fn(owner)
	elseif owner.is_recover_health == 1 then
		--do nothing
	end
end
local function keep_quicken_speed_fn(owner)
	local speed_ratiomult = 0.7
	local quicken_speed_duration = 2
	local speed_reduce_duration = 0.5
	local quicken_speed_count = quicken_speed_duration/speed_reduce_duration
	local time_count = 0

	owner.quicken_speed_task = owner:DoPeriodicTask(speed_reduce_duration, function(owner)
		time_count = time_count + 1
		speed_ratiomult = speed_ratiomult * ( (quicken_speed_count+1-time_count) / quicken_speed_count )

		if owner.components.locomotor ~= nil then
			owner.components.locomotor.walkspeed = owner.normal_walkspeed * (1+speed_ratiomult)
			owner.components.locomotor.runspeed = owner.normal_runspeed * (1+speed_ratiomult)
		end
	end, 0)
	owner.quicken_speed_task_cancel = owner:DoTaskInTime(quicken_speed_duration-0.1, function(owner)
		owner.quicken_speed_task:Cancel()

		owner.components.locomotor.walkspeed = owner.normal_walkspeed
		owner.components.locomotor.runspeed = owner.normal_runspeed
		owner.is_quicken_speed = 0
	end)
end
local function quicken_speed_fn(owner)
	if owner.is_quicken_speed == 0 then
		owner.normal_walkspeed = owner.components.locomotor.walkspeed
		owner.normal_runspeed = owner.components.locomotor.runspeed

		owner.is_quicken_speed = 1
		keep_quicken_speed_fn(owner)
	elseif owner.is_quicken_speed == 1 then
		--do nothing
	end
end
local function OnAttacked(owner, data)
	if owner.is_recover_health == nil then
		owner.is_recover_health = 0
	end
	recover_health_fn(owner)

	if owner.is_quicken_speed == nil then
		owner.is_quicken_speed = 0
	end
	quicken_speed_fn(owner)

	owner:RemoveEventCallback("attacked", OnAttacked)
	local inst = owner and owner.components.inventory ~= nil and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) or nil
	if inst ~= nil and inst.prefab == "ice_flowerhat" then
		if inst.components.cooldown.onchargedfn ~= nil then
	        inst.components.cooldown:StartCharging()
	    end
	end
end
local function OnChargedFn(inst)
	local owner = inst.components.inventoryitem.owner or nil
	if owner == nil then return end
	owner:ListenForEvent("attacked", OnAttacked)
end
local function changgexing_on(inst)
	inst.components.cooldown.onchargedfn = OnChargedFn
	inst.components.cooldown:StartCharging( inst.components.cooldown:GetTimeToCharged() )
end
local function changgexing_off(inst, owner)
	inst.components.cooldown.onchargedfn = nil
	owner:RemoveEventCallback("attacked", OnAttacked)
end

local function owner_cost(owner, cure_cost)
	if owner.components.talker ~= nil then
		owner.components.talker:Say("以吾之命，大治愈术，现！")
	end

	local cure_cost_fx = SpawnPrefab("winters_feast_food_depleted")
	cure_cost_fx.entity:SetParent(owner.entity)
	cure_cost_fx.Transform:SetScale( 1.5, 1.5, 1.5 )

	owner.components.health:DoDelta( -cure_cost, nil, nil, nil, nil, true)
end
local function cure_object(v, cure_cost)
	if v.cure_task ~= nil then
		v.cure_task:Cancel()
		v.cure_task = nil
	end
	if v.cure_task_cancel ~= nil then
		v.cure_task_cancel:Cancel()
		v.cure_task_cancel = nil
	end

	v.cure_task = v:DoPeriodicTask(1, function(v)
		if not v.components.health:IsDead() then
			local cure_fx = SpawnPrefab("farm_plant_happy")
			cure_fx.entity:SetParent(v.entity)
			cure_fx.Transform:SetScale( 1.5, 1.5, 1.5 )
			
			v.components.health:DoDelta( cure_cost, nil, nil, nil, nil, true)
		end
	end, 0)
	v.cure_task_cancel = v:DoTaskInTime(3-0.1, function(v)
		v.cure_task:Cancel()
	end)
end
local function cure_other(owner, cure_cost)
	owner_cost(owner, cure_cost)
	
	local pos = Vector3(owner.Transform:GetWorldPosition())
	local cure_radius = 15
	owner:AddTag("curer")
	local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, cure_radius)
	for k,v in pairs(ents) do
		if not v:HasTag("curer")
		and v:HasTag("player") and not v:HasTag("playerghost") then
			cure_object(v, cure_cost)
		end
	end
	owner:RemoveTag("curer")
end
local function stopusing_ifh(inst)
	inst:DoTaskInTime(10, function(inst)
		inst.components.useableitem:StopUsingItem()
	end)
end
local function ifh_onuse(inst)
    local owner = inst.components.inventoryitem.owner
    if owner then
    	local cure_cost = inst.cure_cost
    	local current_health = owner.components.health.currenthealth
    	if current_health - cure_cost > 0 then
	    	cure_other(owner, cure_cost)
	    	stopusing_ifh(inst)
		else
			if owner.components.talker ~= nil then
				owner.components.talker:Say("生命值不足"..cure_cost..", 无法使用治愈！")
			end
			inst:DoTaskInTime(1, function(inst)
				inst.components.useableitem:StopUsingItem()
			end)
		end
    end
end
local function check_and_use(inst, owner)
	local cure_cost = inst.cure_cost
	owner.cure_leader_task = owner:DoPeriodicTask(1, function(owner)
		if owner.components.follower ~= nil and owner.components.follower.leader ~= nil 
		and owner.components.follower.leader:HasTag("player") and not owner.components.follower.leader:HasTag("playerghost") 
		and not ( owner.components.sleeper and owner.components.sleeper:IsAsleep() ) then
			local leader = owner.components.follower.leader
			if leader.components.health.currenthealth < (leader.components.health.maxhealth - cure_cost*3)
			or leader.components.health.currenthealth < 30 then
				if inst.components.useableitem:CanInteract() then
					inst.components.useableitem:StartUsingItem()
				end
			end
		end
	end, 0)
end

--发光
local function light_on(inst)
	if inst._light == nil or not inst._light:IsValid() then
		inst._light = SpawnPrefab("ice_flowerhat_light")
	end
	local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
	if owner ~= nil then
		inst._light.entity:SetParent(owner.entity)
	else
		inst._light.entity:SetParent(inst.entity)
	end
end
local function light_off(inst)
	if inst._light ~= nil and inst._light:IsValid() then
		inst._light:Remove()
	end
	inst._light = nil
end
local function ifh_onremove(inst)
    if inst._light ~= nil and inst._light:IsValid() then
        inst._light:Remove()
    end
end
local function updatelight(inst, phase)
    if phase == "day" then
		inst:DoTaskInTime(2, light_off)
    elseif phase == "dusk" then
    	light_off(inst)
    elseif phase == "night" then
    	local owner = inst.components.inventoryitem.owner
    	if not owner then
    		light_on(inst)
    	else
			local on_head = owner and owner.components.inventory and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
			if on_head and on_head.prefab == "ice_flowerhat" then
				light_on(inst)
			end
		end
    end
end
local function onputininventory(inst)
	light_off(inst)
end
local function ondropped(inst)
	if  TheWorld.state.phase == "night" then
		light_on(inst)
	end
end

--知冷知热
local function set_winter_large(inst)
	if not inst.components.insulator then
		inst:AddComponent("insulator")
	end
    inst.components.insulator:SetInsulation(TUNING.INSULATION_LARGE)
    inst.components.insulator:SetWinter()
end
local function set_winter_medium(inst)
	if not inst.components.insulator then
		inst:AddComponent("insulator")
	end
    inst.components.insulator:SetInsulation(TUNING.INSULATION_MED)
    inst.components.insulator:SetWinter()
end
local function set_summer_medium(inst)
	if not inst.components.insulator then
		inst:AddComponent("insulator")
	end
    inst.components.insulator:SetInsulation(TUNING.INSULATION_MED)
    inst.components.insulator:SetSummer()
end
local function set_summer_large(inst)
	if not inst.components.insulator then
		inst:AddComponent("insulator")
	end
    inst.components.insulator:SetInsulation(TUNING.INSULATION_LARGE)
    inst.components.insulator:SetSummer()
end
local function change_back_for_temperature(inst)
	inst:RemoveComponent("insulator")
end
local function monitor_temperature(inst)
	inst.monitor_temperature_task = inst:DoPeriodicTask(0.5, function(inst)
		local owner = inst.components.inventoryitem.owner
		local owner_temp = owner.components.temperature:GetCurrent()
		if owner_temp <= 10 then
			set_winter_large(inst)
		elseif owner_temp <= 20 then
			set_winter_medium(inst)
		elseif owner_temp >= 60 then
			set_summer_large(inst)
		elseif owner_temp >= 50 then
			set_summer_medium(inst)
		else
			change_back_for_temperature(inst)
		end
	end, 0)
end
local function stop_monitor_temperature(inst)
	inst.monitor_temperature_task:Cancel()
	change_back_for_temperature(inst)
end

--知地知月
local function set_lunacy(inst)
	local dapperness = inst.components.equippable.dapperness
	if dapperness > 0 then
		inst.components.equippable.dapperness = -3 * dapperness
	end
end
local function change_back_for_continent(inst)
	local dapperness = inst.components.equippable.dapperness
	if dapperness < 0 then
		inst.components.equippable.dapperness = -1/3 * dapperness
	end
end
local function monitor_continent(inst)
	inst.monitor_continent_task = inst:DoPeriodicTask(0.5, function(inst)
		local owner = inst.components.inventoryitem.owner
		if owner.components.sanity and owner.components.sanity.mode == SANITY_MODE_LUNACY then
			set_lunacy(inst)
		elseif owner.components.sanity and owner.components.sanity.mode == SANITY_MODE_INSANITY then
			change_back_for_continent(inst)
		end
	end, 0)
end
local function stop_monitor_continent(inst)
	inst.monitor_continent_task:Cancel()
	change_back_for_continent(inst)
end

require("skill/ifh_sense")--引用cancel_sense_fn
local pigbrain_modified = require("brains/pigbrain_modified_for_iceflowerhat")
local pigbrain = require("brains/pigbrain")
local bunnymanbrain_modified = require("brains/bunnymanbrain_modified_for_iceflowerhat")
local bunnymanbrain = require("brains/bunnymanbrain")
local function OnEquip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_hat", "ice_flowerhat", "ice_flowerhat")
	owner.AnimState:Show("HAT")
	owner.AnimState:Hide("HAIR_HAT")
	owner.AnimState:Show("HAIR_NOHAT")
	owner.AnimState:Show("HAIR")
	if owner:HasTag("player") then
		owner.AnimState:Show("HEAD")
		owner.AnimState:Hide("HEAD_HAT")
	end
	owner.DynamicShadow:SetSize(1.7, 1)

	--耐久
	if inst.components.fueled ~= nil then
		inst.components.fueled:StartConsuming()
	end
	--采收暴击
	local double_pick_enable = inst.double_pick_enable
	if double_pick_enable == true then
		owner:ListenForEvent("picksomething", onpick)
	end

	--饥饿速率
	local hunger_modifier_enable = inst.hunger_modifier_enable
	local hunger_modifier_ratio = inst.hunger_modifier_ratio
	if hunger_modifier_enable == true and owner.components.hunger ~= nil then
        owner.components.hunger.burnratemodifiers:SetModifier(inst, 1-hunger_modifier_ratio)
	end
	--生命上限
	local largen_maxhealth_enable = inst.largen_maxhealth_enable
	local largen_maxhealth_value = inst.largen_maxhealth_value
	if largen_maxhealth_enable == true then
		owner.normal_maxhealth = owner.components.health.maxhealth
        owner.components.health.maxhealth = owner.normal_maxhealth + largen_maxhealth_value
        owner.components.health:ForceUpdateHUD(true)
	end
	--生命吸收
	local damage_absorb_enable = inst.damage_absorb_enable
	local damage_absorb_ratio = inst.damage_absorb_ratio
	local absorb_ratio_mult = (damage_absorb_enable and damage_absorb_ratio) or 0
	owner.components.health.absorb = owner.components.health.absorb + absorb_ratio_mult
	--长歌行
	local changgexing_enable = inst.changgexing_enable
	if changgexing_enable == true then
		changgexing_on(inst)
	end
	--治愈
	local cure_enable = inst.cure_enable
	if cure_enable == true then
		if not owner:HasTag("player") and owner:HasTag("pig") then--bunnyman hastag("pig")
			if inst.components.fueled ~= nil then
				inst.components.fueled:StopConsuming()
			end

			owner.old_name = owner.components.named.name
			owner.components.named:SetName(owner.old_name.."牧师")

			if not owner:HasTag("manrabbit") then
				owner:SetBrain(pigbrain_modified)
			else
				owner:SetBrain(bunnymanbrain_modified)
			end

			check_and_use(inst, owner)
		end
	end

	--发光
	local light_enable = inst.light_enable
	if light_enable == true and TheWorld.state.phase == "night" then
		light_on(inst)
	end
	--知冷知热
	monitor_temperature(inst)
	--知地知月
	monitor_continent(inst)

	--管理标签
	local remove_scarytoprey = inst.remove_scarytoprey
	if remove_scarytoprey == true then
		if owner:HasTag("scarytoprey") then
			owner:RemoveTag("scarytoprey")
		else
			owner.without_scarytoprey = true
		end
	end
	local add_beefalo = inst.add_beefalo
	if add_beefalo == true then
		if not owner:HasTag("beefalo") then
			owner:AddTag("beefalo")
		else
			owner.with_beefalo = true
		end
	end
	local add_eyeplant = inst.add_eyeplant
	if add_eyeplant == true then
		if not owner:HasTag("ifh_eyeplant") then
			owner:AddTag("ifh_eyeplant")
		else
			owner.with_eyeplant = true
		end
	end
	local add_springbee = inst.add_springbee
	if add_springbee == true then
		if not owner:HasTag("ifh_springbee") then
			owner:AddTag("ifh_springbee")
		else
			owner.with_springbee = true
		end
	end
	local add_waterplant = inst.add_waterplant
	if add_waterplant == true then
		if not owner:HasTag("ifh_waterplant") then
			owner:AddTag("ifh_waterplant")
		else
			owner.with_waterplant = true
		end
	end
	local add_beebox = inst.add_beebox
	if add_beebox == true then
		if not owner:HasTag("ifh_beebox") then
			owner:AddTag("ifh_beebox")
		else
			owner.with_beebox = true
		end
	end
	--暴食手杖特效
	local cane_victorian_fx = inst.cane_victorian_fx
	if cane_victorian_fx == true then
		if inst._vfx_fx_inst == nil then
			inst._vfx_fx_inst = SpawnPrefab("cane_victorian_fx")
			inst._vfx_fx_inst.entity:AddFollower()
		end
		inst._vfx_fx_inst.entity:SetParent(owner.entity)
		inst._vfx_fx_inst.Follower:FollowSymbol(owner.GUID, "swap_object", 0, inst.vfx_fx_offset or 0, 0)
	end

	--感知
	if owner.is_sensed == 1 then
		cancel_sense_fn(owner)
	end
end
local function OnUnequip(inst, owner)
    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAT_HAIR")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")
	if owner:HasTag("player") then
		owner.AnimState:Show("HEAD")
		owner.AnimState:Hide("HEAD_HAT")
	end
	owner.DynamicShadow:SetSize(1.3, 0.6)
	
	--耐久
	if inst.components.fueled ~= nil then
		inst.components.fueled:StopConsuming()
	end
	--采收暴击
	local double_pick_enable = inst.double_pick_enable
	if double_pick_enable == true then
		owner:RemoveEventCallback("picksomething", onpick)
	end
	
	--解饿速率
	local hunger_modifier_enable = inst.hunger_modifier_enable
	if hunger_modifier_enable == true and owner.components.hunger ~= nil then
        owner.components.hunger.burnratemodifiers:RemoveModifier(inst)
	end
	--生命上限
	local largen_maxhealth_enable = inst.largen_maxhealth_enable
	if largen_maxhealth_enable == true then
        owner.components.health.maxhealth = owner.normal_maxhealth
        owner.components.health:ForceUpdateHUD(true)
	end
	--生命吸收
	local damage_absorb_enable = inst.damage_absorb_enable
	local damage_absorb_ratio = inst.damage_absorb_ratio
	local absorb_ratio_mult = (damage_absorb_enable and damage_absorb_ratio) or 0
	owner.components.health.absorb = owner.components.health.absorb - absorb_ratio_mult
	--长歌行
	local changgexing_enable = inst.changgexing_enable
	if changgexing_enable == true then
		changgexing_off(inst, owner)
	end
	--治愈
	local cure_enable = inst.cure_enable
	if cure_enable == true then
		if not owner:HasTag("player") and owner:HasTag("pig") then--bunnyman hastag("pig")
			owner.components.named:SetName(owner.old_name)

			if not owner:HasTag("manrabbit") then
				owner:SetBrain(pigbrain)
			else
				owner:SetBrain(bunnymanbrain)
			end
			
			owner.cure_leader_task:Cancel()
		end
	end

	--发光
	local light_enable = inst.light_enable
	if light_enable == true then
		light_off(inst)
	end
	--知冷知热
	stop_monitor_temperature(inst)
	--知地知月
	stop_monitor_continent(inst)

	--管理标签
	local remove_scarytoprey = inst.remove_scarytoprey
	if remove_scarytoprey == true then
		if owner.without_scarytoprey == true then
			--not to add
		else
			if not owner:HasTag("scarytoprey") then
				owner:AddTag("scarytoprey")
			end
		end
	end
	local add_beefalo = inst.add_beefalo
	if add_beefalo == true then
		if owner.with_beefalo == true then
			--not to remove
		else
			if owner:HasTag("beefalo") then
				owner:RemoveTag("beefalo")
			end
		end
	end
	local add_eyeplant = inst.add_eyeplant
	if add_eyeplant == true then
		if owner.with_eyeplant == true then
			--not to remove
		else
			if owner:HasTag("ifh_eyeplant") then
				owner:RemoveTag("ifh_eyeplant")
			end
		end
	end
	local add_springbee = inst.add_springbee
	if add_springbee == true then
		if owner.with_springbee == true then
			--not to remove
		else
			if owner:HasTag("ifh_springbee") then
				owner:RemoveTag("ifh_springbee")
			end
		end
	end
	local add_waterplant = inst.add_waterplant
	if add_waterplant == true then
		if owner.with_waterplant == true then
			--not to remove
		else
			if owner:HasTag("ifh_waterplant") then
				owner:RemoveTag("ifh_waterplant")
			end
		end
	end
	local add_beebox = inst.add_beebox
	if add_beebox == true then
		if owner.with_beebox == true then
			--not to remove
		else
			if owner:HasTag("ifh_beebox") then
				owner:RemoveTag("ifh_beebox")
			end
		end
	end
	--暴食手杖特效
	local cane_victorian_fx = inst.cane_victorian_fx
	if cane_victorian_fx == true then
		if inst._vfx_fx_inst ~= nil then
			inst._vfx_fx_inst:Remove()
			inst._vfx_fx_inst = nil
		end
	end
end


local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	MakeInventoryPhysics(inst)
	
	inst.entity:AddAnimState()
	inst.AnimState:SetBank("ice_flowerhat")
	inst.AnimState:SetBuild("ice_flowerhat")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("open_top_hat")
	local need_repair = TUNING.IFH_NEED_REPAIR
	if need_repair == false then
		inst:AddTag("hide_percentage")
	end
	
	inst.entity:AddNetwork()
	inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end


	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/ice_flowerhat.xml"
	inst.components.inventoryitem:SetOnDroppedFn(light_off)
	inst:AddComponent("inspectable")

	local recover_sanity = TUNING.IFH_RECOVER_SANITY
	local cane_enable = TUNING.IFH_CANE_ENABLE
	local cane_speedmult = TUNING.IFH_CANE_SPEEDMULT
	inst:AddComponent("equippable")
	inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
	inst.components.equippable.dapperness = recover_sanity/54
	inst.components.equippable.walkspeedmult = ( cane_enable and (1+cane_speedmult) ) or 1
	
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)

	if need_repair == true then
		inst:AddComponent("fueled")
		inst.components.fueled.fueltype = FUELTYPE.USAGE
		inst.components.fueled:InitializeFuelLevel(TUNING.WALRUSHAT_PERISHTIME)
		inst.components.fueled:SetDepletedFn(inst.Remove)
	end
	
	--采收暴击相关
	inst.double_name = ""
	inst.multiple_name = ""

	inst.double_pick_enable = TUNING.IFH_DOUBLE_PICK_ENABLE
	local double_pick_enable = inst.double_pick_enable
	if double_pick_enable == true then
		inst:AddComponent("ifhexperience")
		inst.components.ifhexperience:Test(inst)

	    inst:AddComponent("named")
		local pick_level = inst.components.ifhexperience.pick_level
		local pick_probability = inst.components.ifhexperience.pick_probability
		inst.components.ifhexperience:Set_ifh_name(pick_level, pick_probability)
	end
	--多倍暴击
	inst.multiple_pick_enable = TUNING.IFH_MULTIPLE_PICK_ENABLE
	local multiple_pick_enable = inst.multiple_pick_enable
	inst.multiple_pick = 2
	inst.max_multiple_pick = TUNING.IFH_MAX_MULTIPLE_PICK
	if double_pick_enable == true and multiple_pick_enable == true then
		inst:AddComponent("trader")
		inst.components.trader:SetAcceptTest(AcceptTest)
		inst.components.trader.onrefuse = OnRefuseItem
		inst.components.trader.onaccept = OnGetItemFromPlayer
		inst:ListenForEvent("equipped",OnGetItemFromPlayer)

		update_multiple_name(inst)
	end
	

	--存活相关
	inst.changgexing_enable = TUNING.IFH_CHANGGEXING_ENABLE
	local changgexing_enable = inst.changgexing_enable
	if changgexing_enable == true then
		inst:AddComponent("cooldown")
		inst.components.cooldown.cooldown_duration = 10
	end

	inst.cure_enable = TUNING.IFH_CURE_ENABLE
	local cure_enable = inst.cure_enable
	if cure_enable == true then
		inst:AddComponent("useableitem")
		inst.components.useableitem:SetOnUseFn(ifh_onuse)
		inst.cure_cost = 30
	end
	inst:AddComponent("tradable")
	
	local revive_enable = TUNING.IFH_REVIVE_ENABLE
	if revive_enable == true then
		inst:AddComponent("hauntable")
		inst.components.hauntable:SetHauntValue(TUNING.HAUNT_INSTANT_REZ)
	else
		MakeHauntableLaunch(inst)
	end

	--装备后效果相关
	inst._light = nil
	inst.OnRemoveEntity = ifh_onremove


	--存活相关
	inst.hunger_modifier_enable = TUNING.IFH_HUNGER_MODIFIER_ENABLE
	inst.hunger_modifier_ratio = TUNING.IFH_HUNGER_MODIFIER_RATIO

	inst.largen_maxhealth_enable = TUNING.IFH_LARGEN_MAXHEALTH_ENABLE
	inst.largen_maxhealth_value = TUNING.IFH_LARGEN_MAXHEALTH_VALUE

	inst.damage_absorb_enable = TUNING.IFH_DAMAGE_ABSORB_ENABLE
	inst.damage_absorb_ratio = TUNING.IFH_DAMAGE_ABSORB_RATIO

	--装备后效果相关
	inst:AddComponent("follower")
	--发光
	inst.light_enable = TUNING.IFH_LIGHT_ENABLE
	local light_enable = inst.light_enable
	if light_enable == true then
		inst._light = nil
		inst.OnRemoveEntity = ifh_onremove
		updatelight(inst, TheWorld.state.phase)
		inst:WatchWorldState("phase", updatelight)
	    inst:ListenForEvent("onputininventory", onputininventory)
	    inst:ListenForEvent("ondropped", ondropped)
	end
	--防雨
	local waterproof_enable = TUNING.IFH_WATERPROOF_ENABLE
	local waterproof_ratio = TUNING.IFH_WATERPROOF_RATIO
	if waterproof_enable == true then
		inst:AddComponent("waterproofer")
    	inst.components.waterproofer:SetEffectiveness(waterproof_ratio)
	end

	inst.remove_scarytoprey = TUNING.IFH_REMOVE_SCARYTOPREY
	inst.add_beefalo = TUNING.IFH_ADD_BEEFALO
	inst.add_eyeplant = TUNING.IFH_ADD_EYEPLANT
	inst.add_springbee = TUNING.IFH_ADD_SPRINGBEE
	inst.add_waterplant = TUNING.IFH_ADD_WATERPLANT
	inst.add_beebox = TUNING.IFH_ADD_BEEBOX

	inst.cane_victorian_fx = TUNING.IFH_CANE_VICTORIAN_FX_ENABLE

	--多倍暴击
	inst.OnSave = onsave
	inst.OnPreLoad = onpreload

	----主动技能相关
	--感知
	inst.sense_distance = TUNING.IFH_SENSE_DISTANCE
	inst.sense_sanity_cost = TUNING.IFH_SENSE_SANITY_COST
	inst.sense_min_sanity = 50

	--抗拒冰环
	inst.icering_cost_sanity = TUNING.IFH_ICERING_COST_SANITY
	inst.icering_min_sanity = 30
	inst.icering_cd_time = TUNING.IFH_ICERING_CD_TIME

	return inst
end
local function ice_flowerhat_lightfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()		
    inst.entity:AddNetwork()	

    inst:AddTag("FX")	

    local light_intensity = TUNING.IFH_LIGHT_INTENSITY
    local light_radius = TUNING.IFH_LIGHT_RADIUS
	inst.Light:SetIntensity(light_intensity)
	inst.Light:SetRadius(light_radius)

	inst.Light:Enable(true)
	inst.Light:SetFalloff(1)
	inst.Light:SetColour(255/255, 255/255, 204/255)


    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
    inst.persists = false	

    return inst
end

return  Prefab("common/inventory/ice_flowerhat", fn, assets),
		Prefab("ice_flowerhat_light", ice_flowerhat_lightfn)

