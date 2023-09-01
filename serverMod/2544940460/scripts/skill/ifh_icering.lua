
local function speaker_say(speaker, words)
	local say_words = words or ""
	if speaker and speaker.components.talker then
		speaker.components.talker:Say(say_words)
	end
end
local function calculate_boss_lucy_effect_probabilitymult(target, boss_lucy_effect_resistance, boss_lucy_effect_probabilitymult)
	local lucy_effect_probabilitymult = 0
	local boss_resistance = boss_lucy_effect_resistance or 0
	local boss_probabilitymult = boss_lucy_effect_probabilitymult or 0

	if target and target:HasTag("epic") then
		lucy_effect_probabilitymult = 1 * (1 - boss_resistance) * (1 + boss_probabilitymult)
	else
		lucy_effect_probabilitymult = 1
	end

	return lucy_effect_probabilitymult
end
local function calculate_boss_lucy_effect_probability(target, initial_probability, boss_resistance, boss_probabilitymult)
	local boss_lucy_effect_probabilitymult = calculate_boss_lucy_effect_probabilitymult(target, boss_resistance, boss_probabilitymult)
	local real_probability = initial_probability * boss_lucy_effect_probabilitymult

	return real_probability
end


local function check_death_and_pushevent(player, target)
	if target and target.components.health and target.components.health:IsDead() 
	and player then
		player:PushEvent("killed", { victim = target })
	end
end
local function on_hit_other_target(player, target)
	if not target then return end

	if target:HasTag("sleeper") and target.components.sleeper:IsAsleep() then
		target.components.sleeper:WakeUp()
	end
	if target:HasTag("freezable") and target.components.freezable:IsFrozen() 
	and not target:HasTag("lucy_freezed") then
		target.components.freezable:Unfreeze()
	end
	if target.components.combat then
		target.components.combat:SetTarget(player)
	end
end
local function range_strike_OnHitOther(player, target)
	local range_damage = TUNING.IFH_RANGE_DAMAGE
	local afflicter = player
	local cause = afflicter and (afflicter.nameoverride or afflicter.prefab) or "NIL"

	target.components.health:DoDelta(range_damage, nil, cause, nil, afflicter, false)
	on_hit_other_target(player, target)
	check_death_and_pushevent(player, target)
end

local function keep_freezed_fn(player, target)
	local freeze_duration = TUNING.IFH_ICERING_FREEZE_DURATION

	if not target:HasTag("lucy_freezed") then
		target:AddTag("lucy_freezed")
	end
	target.freezed_task = target:DoPeriodicTask(0.1, function(target)
		if target:HasTag("freezable") and not target.components.freezable:IsFrozen() then
			target.components.freezable:AddColdness(999)
		end
		speaker_say(target, "可恶的人类！孩子被冻...\n")
	end, 0)

	target.freezed_task_cancel = target:DoTaskInTime(freeze_duration, function(target)
		target.freezed_task:Cancel()
		if target:HasTag("lucy_freezed") then
			target:RemoveTag("lucy_freezed")
		end
		if target:HasTag("freezable") and target.components.freezable:IsFrozen() 
		or target:HasTag("hit_lucy_freezed") then
			target.components.freezable:Unfreeze()
		end
		speaker_say(target, "孩子终于解放啦！\n")
		target.is_freezed = 0
	end)
end
local function freeze_fn(player, target)
	if target.components.freezable then
		if target.is_freezed == 0 then
			target.is_freezed = 1
			keep_freezed_fn(player, target)
		elseif target.is_freezed == 1 then
			target.freezed_task:Cancel()
			target.freezed_task_cancel:Cancel()
			keep_freezed_fn(player, target)
		end
	end
end
local function freeze_OnHitOther(player, target)
	local freeze_probability = TUNING.IFH_ICERING_FREEZE_PROBABILITY
	local boss_freeze_resistance = TUNING.IFH_BOSS_FREEZE_RESISTANCE
	local real_freeze_probability = calculate_boss_lucy_effect_probability(target, freeze_probability, boss_freeze_resistance)

	math.randomseed(os.time())
	if math.random() <= real_freeze_probability then
		if target.is_freezed == nil then
			target.is_freezed = 0
		end
		freeze_fn(player, target)
	end
end

local function recover_normal_speed_later(player, target)
	local decelerate_duration = TUNING.IFH_ICERING_DECELERATE_DURATION

	target.decelerate_task_cancel = target:DoTaskInTime( decelerate_duration, function(target)
		if target.components.locomotor then
			target.components.locomotor.walkspeed = target.normal_walkspeed
			target.components.locomotor.runspeed = target.normal_runspeed
		end
		speaker_say(target, "孩子又可以奔跑了！\n")
		target.is_decelerated = 0
	end)
end
local function decelerate_fn(player, target)
	local decelerate_ratio = TUNING.IFH_ICERING_DECELERATE_RATIO

	if target.components.locomotor then
		if target.is_decelerated == 0 then
			target.normal_walkspeed = target.components.locomotor.walkspeed
			target.normal_runspeed = target.components.locomotor.runspeed

			target.components.locomotor.walkspeed = target.normal_walkspeed * (1 - decelerate_ratio)
			target.components.locomotor.runspeed = target.normal_runspeed * (1 - decelerate_ratio)
			speaker_say(target, "可恶的人类！我被减速了！\n")
			target.is_decelerated = 1
			
			recover_normal_speed_later(player, target)
		elseif target.is_decelerated == 1 then
			target.decelerate_task_cancel:Cancel()
			speaker_say(target, "狡猾的人类！我又被减速了！\n")

			recover_normal_speed_later(player, target)
		end
	end
end
local function decelerate_OnHitOther(player, target)
	local decelerate_probability = TUNING.IFH_ICERING_DECELERATE_PROBABILITY
	local boss_decelerate_resistance = TUNING.IFH_BOSS_DECELERATE_RESISTANCE
	local real_decelerate_probability = calculate_boss_lucy_effect_probability(target, decelerate_probability, boss_decelerate_resistance)

	math.randomseed(os.time())
	if math.random() <= real_decelerate_probability then
		if target.is_decelerated == nil then
			target.is_decelerated = 0
		end
		decelerate_fn(player, target)
	end
end


local function icering_cd_enable(player, inst)
	player.icering_cool_down = true

	if player.icering_do == nil then--初始化
		player.icering_do = false
	end
	if player.icering_cool_down_time == nil then--初始化
		player.icering_cool_down_time = 0
	end

	if player.icering_do == true then
		local icering_cool_down_time = player.icering_cool_down_time - player.icering_cool_down_time % 0.01
		speaker_say(player, "【抗拒冰环】冷却中...冷却时间："..icering_cool_down_time.."s")
		player.icering_cool_down = false
	end
end
local function player_cost_sanity(player, inst)
	local icering_min_sanity = inst.icering_min_sanity
	local icering_sanity_cost = inst.icering_cost_sanity

	if player.components.sanity and player.components.sanity.current < icering_min_sanity then--精神值过低保护
		player.icering_do = false

		if player.components.talker then
			player.components.talker:Say("精神值低于"..icering_min_sanity.."点，无法使用冰环")
		end
	elseif player.components.sanity then--消耗精神
		player.components.sanity:DoDelta(-icering_sanity_cost)
		player.icering_do = true

		player.icering_cool_down_time = inst.icering_cd_time
		player.count_cool_down_time_task = player:DoPeriodicTask(0.1, function(player)--冷却计数
			player.icering_cool_down_time = player.icering_cool_down_time - 0.1

			if player.icering_cool_down_time <= 0 then--使用等于无法判定生效
				player.count_cool_down_time_task:Cancel()

				player.icering_do = false
			end
		end, 0)
	end
end
local function not_hit_target(player, target)
	if not (player and target) then return false end

	local not_hit_target = false

	if target:HasTag("player") or target:HasTag("abigail") 
	or target:HasTag("companion") or target:HasTag("glommer")
	or target:HasTag("wall") then
		not_hit_target = true
	end
	if target.components.follower and target.components.follower.leader == player then
		not_hit_target = true
	end

	return not_hit_target
end
local function valid_target(attacker, target)
	if not (attacker and target) then return false end

	local valid_target = false

	if attacker.components.combat and attacker.components.combat:IsValidTarget(target)
	and target.components.health and not target.components.health:IsDead()
	and not target:HasTag("notdrawable")--鼹鼠
	and not ( target.sg and target.sg:HasStateTag("invisible") )then--地下触手
		valid_target = true
	end

	return valid_target
end

local function calculate_vector()
	local icering_distance = TUNING.IFH_ICERING_DISTANCE
	local icering_duratio = TUNING.IFH_ICERING_DURATIO
	local vector = icering_distance / icering_duratio--矢量速度为抗拒冰环的作用半径除以动画播放时间

	return vector
end
local function calculate_opposite_point(player, target)
	local player_x, player_y, player_z = player:GetPosition():Get()
	local target_x, target_y, target_z = target:GetPosition():Get()
	local delta_x = player_x-target_x
	local delta_z = player_z-target_z
	local opposite_point = Vector3(player_x - 2*delta_x, 0, player_z - 2*delta_z )

	return opposite_point
end
local function calculate_initial_distance(player, target)
	local player_x, player_y, player_z = player:GetPosition():Get()
	local target_x, target_y, target_z = target:GetPosition():Get()
	local delta_x = player_x-target_x
	local delta_z = player_z-target_z
	local distance_sq = delta_x*delta_x + delta_z*delta_z
	local initial_distance = math.sqrt( distance_sq )

	return initial_distance
end

local function vector_living_things(player, target)
	local vector = calculate_vector()
	local boss_vector_resistance = TUNING.IFH_BOSS_VECTOR_RESISTANCE
	local real_vector = calculate_boss_lucy_effect_probability(target, vector, boss_vector_resistance)
	local opposite_point = calculate_opposite_point(player, target)

	target.Physics:Stop()
	target:ForceFacePoint(opposite_point)
	target.Physics:SetMotorVel(real_vector, 0, 0)
end
local function force_living_things(player, target)
	local initial_distance = calculate_initial_distance(player, target)
	local vector = calculate_vector()
	local unit_distance_time = 1 / vector
	local start_time = unit_distance_time * initial_distance

	target:DoTaskInTime(start_time, function(target)
		range_strike_OnHitOther(player, target)

	 	if target.components.freezable
	 	and target:HasTag("freezable") and not target.components.freezable:IsFrozen() then
			target.components.freezable:AddColdness(999)
		end

		target:DoTaskInTime(0.01, function(target)
			vector_living_things(player, target)
		end)
	end)

	local icering_duratio = TUNING.IFH_ICERING_DURATIO
	target:DoTaskInTime(icering_duratio, function(target)
		target.Physics:Stop()

		if target.components.freezable
	 	and target:HasTag("freezable") and target.components.freezable:IsFrozen() then
			target.components.freezable:Unfreeze()
		end

		on_hit_other_target(player, target)
		
		freeze_OnHitOther(player, target)
		decelerate_OnHitOther(player, target)
	end)
end

local function vector_non_living_things(player, target)
	local vector = calculate_vector()
	local opposite_point = calculate_opposite_point(player, target)

	target.Physics:Stop()
	target:ForceFacePoint(opposite_point)
	target.Physics:SetMotorVel(vector, 0, 0)
end
local function force_non_living_things(player, target)
	local initial_distance = calculate_initial_distance(player, target)
	local vector = calculate_vector()
	local unit_distance_time = 1 / vector
	local start_time = unit_distance_time * initial_distance

	target:DoTaskInTime(start_time, function(target)
		target.Physics:Stop()

		vector_non_living_things(player, target)
	end)

	local icering_duratio = TUNING.IFH_ICERING_DURATIO
	target:DoTaskInTime(icering_duratio, function(target)
		target.Physics:Stop()
	end)
end


local function icering_fn(player, inst)
	local icering_enable = true
	if icering_enable == false then return end

	icering_cd_enable(player, inst)
	if not player.icering_cool_down then return end

	player_cost_sanity(player, inst)
	if not player.icering_do then return end


	local icering_distance = TUNING.IFH_ICERING_DISTANCE
	local icering_fx = SpawnPrefab("crabking_ring_fx")
	icering_fx.Transform:SetPosition(player.Transform:GetWorldPosition())
	local icering_fx_radius = math.sqrt(icering_distance/12)--一块地皮的宽度为4
	icering_fx.Transform:SetScale( icering_fx_radius, icering_fx_radius, icering_fx_radius )

	local x, y, z = player.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, icering_distance)
	for k, v in pairs(ents) do
		--排除晚上进游戏时自动生成的光--待优化

		if not not_hit_target(player, v) then--排除友方
			if valid_target(player, v) then--对生物
				force_living_things(player, v)
			elseif v.Physics and not v:HasTag("lava") then--对物品--排除岩浆池
				force_non_living_things(player, v)
			end
		end
	end
end


local this_modname = TUNING.THIS_MODNAME
AddModRPCHandler(this_modname, "ifh_icering", function(player)
	local on_head = player.components.inventory and player.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
	if not (on_head and on_head.prefab == "ice_flowerhat") then return end

	if not player:HasTag("playerghost") then
		icering_fn(player, on_head)
	end
end)


