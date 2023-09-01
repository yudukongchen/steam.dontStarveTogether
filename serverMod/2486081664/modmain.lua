GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})
GLOBAL.require "prefabutil"

local Prefabs = GLOBAL.Prefabs

local BIRD_NEVER_STARVE = GetModConfigData("bird_never_starve")
local BIRD_NEVER_SLEEP = GetModConfigData("bird_never_sleep")
local BIRD_ACCEPT_COOKED_EGG = GetModConfigData("bird_accept_cooked_egg")
local BIRD_DROP_MORE_SEEDS = GetModConfigData("bird_drop_more_seeds")

local invalid_foods =
{
    "bird_egg",
    "rottenegg",
	-- "bird_egg_cooked",
    -- "monstermeat",
    -- "cookedmonstermeat",
    -- "monstermeat_dried",
}

local function GetBird(inst)
    return (inst.components.occupiable and inst.components.occupiable:GetOccupant()) or nil
end

local function NeverSleep(inst)
    return false
end

local function ShouldAcceptItem(inst, item)
    local seed_name = string.lower(item.prefab .. "_seeds")

    local can_accept = item.components.edible
        and (Prefabs[seed_name] 
        or item.prefab == "seeds"
        or string.match(item.prefab, "_seeds")
        or item.components.edible.foodtype == FOODTYPE.MEAT)

    if table.contains(invalid_foods, item.prefab) then
        can_accept = false
    end

    return can_accept
end

local function DigestFood(inst, food)
    if food.components.edible.foodtype == FOODTYPE.MEAT then
        --If the food is meat:
            --Spawn an egg.
        if inst.components.occupiable and inst.components.occupiable:GetOccupant() and inst.components.occupiable:GetOccupant():HasTag("bird_mutant") then
            inst.components.lootdropper:SpawnLootPrefab("rottenegg")
        else
            inst.components.lootdropper:SpawnLootPrefab("bird_egg")
        end
    else
        if inst.components.occupiable and inst.components.occupiable:GetOccupant() and inst.components.occupiable:GetOccupant():HasTag("bird_mutant") then
            inst.components.lootdropper:SpawnLootPrefab("spoiled_food")

        else
            local seed_name = string.lower(food.prefab .. "_seeds")
            if Prefabs[seed_name] ~= nil then
				--If the food has a relavent seed type:
				--Spawn 1 or 2 of those seeds.
				local num_seeds = math.random(2)
				for k = 1, num_seeds do
					inst.components.lootdropper:SpawnLootPrefab(seed_name)
				end
				--Spawn regular seeds on a 50% chance.
				if math.random() < 0.5 then
					inst.components.lootdropper:SpawnLootPrefab("seeds")
				end
            else
                --Otherwise...
                    --Spawn a poop 1/3 times.
                if math.random() < 0.33 then
                    local loot = inst.components.lootdropper:SpawnLootPrefab("guano")
                    loot.Transform:SetScale(.33, .33, .33)
                end
            end
        end
    end

    --Refill bird stomach.
    local bird = GetBird(inst)
    if bird and bird:IsValid() and bird.components.perishable then
        bird.components.perishable:SetPercent(1)
    end
end

local function OnGetItem(inst, giver, item)
    --If you're sleeping, wake up.
    if inst.components.sleeper and inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end

    if item.components.edible ~= nil and
        (   item.components.edible.foodtype == FOODTYPE.MEAT
            or item.prefab == "seeds"
            or string.match(item.prefab, "_seeds")
            or Prefabs[string.lower(item.prefab .. "_seeds")] ~= nil
        ) then
        --If the item is edible...
        --Play some animations (peck, peck, peck, hop, idle)
        inst.AnimState:PlayAnimation("peck")
        inst.AnimState:PushAnimation("peck")
        inst.AnimState:PushAnimation("peck")
        inst.AnimState:PushAnimation("hop")
		inst.AnimState:PushAnimation("idle"..inst.CAGE_STATE, true)
        --Digest Food in 60 frames.
        inst:DoTaskInTime(60 * FRAMES, DigestFood, item)
    end
end

AddPrefabPostInit("birdcage", function(inst)
    local bird = GetBird(inst)
			
	--Bird Already in the cage
	if bird and bird.components.perishable and BIRD_NEVER_STARVE and not GLOBAL.TheWorld:HasTag("cave") then
		bird.components.perishable:StopPerishing()
	end
	
	if bird and bird.components.sleeper and BIRD_NEVER_SLEEP then
			bird.components.sleeper:SetSleepTest(NeverSleep)
	end
		
	if inst.components.occupiable then
		--Cage is empty now, set onoccupied
		oldOnOccupied = inst.components.occupiable.onoccupied
		inst.components.occupiable.onoccupied = function (_inst, _bird)
		    oldOnOccupied(_inst, _bird)
			if BIRD_NEVER_STARVE and not GLOBAL.TheWorld:HasTag("cave") then
				_bird.components.perishable:StopPerishing()
			end
			if BIRD_NEVER_SLEEP then
			    if _inst.components.sleeper then
					_inst.components.sleeper:SetSleepTest(NeverSleep)
				end
				if _bird and _bird.components and _bird.components.sleeper then
					_bird.components.sleeper:SetSleepTest(NeverSleep)
				end
			end
		end
	end

	if inst.components.trader then
		if BIRD_ACCEPT_COOKED_EGG then
			inst.components.trader:SetAcceptTest(ShouldAcceptItem)
		end
		if BIRD_DROP_MORE_SEEDS then
			inst.components.trader.onaccept = OnGetItem
		end
	end
end)