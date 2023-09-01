local attack_dist = {
	["tentacle"] = math.sqrt( 4/4 ),
	["wasphive"] = math.sqrt( 10/4 )
}
local function is_in_attack_dist(inst)
	local is_in = false
	for k,v in pairs(attack_dist) do
		if inst.prefab == k then
			is_in = true
			break
		end
	end
	return is_in
end


local function player_cost_sanity(player, inst)
	--精神值过低保护
	local sense_min_sanity = player.sense_min_sanity
	player.task_sanity_cancel_sense = player:DoPeriodicTask(1, function(player)
		if player.components.sanity and player.components.sanity.current < sense_min_sanity then
			cancel_sense_fn(player)
			if player.components.talker then
				player.components.talker:Say("精神值低于"..sense_min_sanity.."点，退出感知")
			end
		end
	end, 0)
	--消耗精神
	player.sense_sanity_cost = inst.sense_sanity_cost
	player.task_sense_sanity_cost = player:DoPeriodicTask(5, function(player)
		if player.components.sanity then
			player.components.sanity:DoDelta(-player.sense_sanity_cost)
		end
	end, 0)
end
local function start_sense_fn(player, inst)
	player_cost_sanity(player, inst)

	player.sensed_object = {}
	local sensed_object_position = 0
	player.sense_distance = inst.sense_distance
	player.task_sense_object = player:DoPeriodicTask(0.3, function(player)
		local sense_distance = player.sense_distance
		local sense_distance_sq = sense_distance * sense_distance

		--插入感知目标和光圈
		local x, y, z = player.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, sense_distance)
		for k, v in pairs(ents) do
			if is_in_attack_dist(v)
			and not v.components.health:IsDead() and v:IsValid()
			and v._red_ring == nil then
				v._red_ring = SpawnPrefab("reticuleaoehostiletarget")
				v._red_ring.Transform:SetPosition( v.Transform:GetWorldPosition() )
				local atk_dist = attack_dist[v.prefab]
				v._red_ring.Transform:SetScale(atk_dist, atk_dist, atk_dist)
				
				sensed_object_position = sensed_object_position + 1
				table.insert(player.sensed_object, sensed_object_position, v)
			end
		end

		--动态插入、删除感知目标和光圈
		for k, v in pairs(player.sensed_object) do
			--感知目标死亡或非法
			if v.components.health:IsDead() or not v:IsValid()
			and v._red_ring ~= nil then
				v._red_ring:Remove()
				v._red_ring = nil
				table.remove(player.sensed_object, k)
				sensed_object_position = sensed_object_position - 1
			end
			--脱离感知距离
			if not v.components.health:IsDead() and v:IsValid()
			and v:GetDistanceSqToPoint(player.Transform:GetWorldPosition()) > sense_distance_sq
			and v._red_ring ~= nil then
				v._red_ring:Remove()
				v._red_ring = nil
				table.remove(player.sensed_object, k)
				sensed_object_position = sensed_object_position - 1
			end
		end
	end, 0)

	if player.components.talker then
		player.components.talker:Say("【危险感知】 - 启动")
	end
end
function cancel_sense_fn(player)
	--取消消耗精神
	player.task_sanity_cancel_sense:Cancel()
	player.task_sense_sanity_cost:Cancel()

	--取消动态刷新
	player.task_sense_object:Cancel()
	--清空红圈
	for k, v in pairs(player.sensed_object) do
		if v._red_ring ~= nil then
			v._red_ring:Remove()
			v._red_ring = nil
		end
	end
	
	if player.components.talker then
		player.components.talker:Say("【危险感知】 - 关闭")
	end
	player.is_sensed = 0
end
local function sense_fn(player, inst)
	if player.is_sensed == nil then
		player.is_sensed = 0
	end

	player.sense_min_sanity = inst.sense_min_sanity
	local sense_min_sanity = player.sense_min_sanity
	if player.is_sensed == 0 then
		if player.components.sanity and player.components.sanity.current >= sense_min_sanity then
			player.is_sensed = 1
			start_sense_fn(player, inst)
		elseif player.components.talker then
			player.components.talker:Say("精神值低于"..sense_min_sanity.."点，无法开启感知")
		end
	elseif player.is_sensed == 1 then
		cancel_sense_fn(player)
	end
end


local this_modname = TUNING.THIS_MODNAME
AddModRPCHandler(this_modname, "ifh_sense", function(player)
	local on_head = player.components.inventory and player.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
	if not (on_head and on_head.prefab == "ice_flowerhat") then return end

	if not player:HasTag("playerghost") then
		sense_fn(player, on_head)
	end
end)

