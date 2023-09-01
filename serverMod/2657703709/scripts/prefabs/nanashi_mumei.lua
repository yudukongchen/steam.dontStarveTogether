local MakePlayerCharacter = require "prefabs/player_common"
local HiddenArmor = require "modifications.nanashi_mumei_hidden_armor"
local UpdateMumeiTimeOfDay = require "modifications.nanashi_mumei_night_owl"
local TerrorBonusDamage = require "modifications.nanashi_mumei_terror_bonusdamagefn"
local SanityRateFn = require "modifications.nanashi_mumei_sanity_custom_rate"
local brain = require "brains/nanashi_mumei_brain"
local killer_mode = require "modifications.nanashi_mumei_killer"

local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
}

local start_inv = {}
for k, v in pairs(TUNING.GAMEMODE_STARTING_ITEMS) do
    start_inv[string.lower(k)] = v.NANASHI_MUMEI
end
local prefabs = FlattenTree(start_inv, true)

-- When the character is revived from human
local function onbecamehuman(inst)
	-- Set speed when not a ghost (optional)
	inst.components.locomotor:SetExternalSpeedMultiplier(inst, "nanashi_mumei_speed_mod", 1 * TUNING.NANASHI_MUMEI_MS)
	if inst.ghost_lantern_mum then
		inst.ghost_lantern_mum:Remove()
		inst.ghost_lantern_mum = nil
	end
end

local function onbecameghost(inst)
	-- Remove speed modifier when becoming a ghost
   inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "nanashi_mumei_speed_mod")
   inst.ghost_lantern_mum = inst:SpawnChild("firefx_light")
   inst.ghost_lantern_mum.Light:SetRadius(2.5)
   inst.ghost_lantern_mum.Light:SetFalloff(0.5)
   inst.ghost_lantern_mum.Light:SetIntensity(0.7)
   inst.ghost_lantern_mum.Light:SetColour(235/255, 201/255, 110/255)
   inst.ghost_lantern_mum.Light:Enable(true)
end

-- When loading or spawning the character
local function onload(inst)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    inst:ListenForEvent("ms_becameghost", onbecameghost)

    if inst:HasTag("playerghost") then
        onbecameghost(inst)
    else
        onbecamehuman(inst)
    end
end

local function OnReroll(inst)
    for _, v in pairs(inst.components.petleash:GetPets()) do
		if v:HasTag("nanashi_mumei_friend") then
			if v.components.container then
				v.components.container:DropEverything()
				inst.components.petleash:DespawnPet(v)
			end
		end
    end
end
-- This initializes for both the server and client. Tags can be added here.
local common_postinit = function(inst) 
	-- Minimap icon
	inst.MiniMapEntity:SetIcon( "nanashi_mumei.tex" )

	HiddenArmor(inst)
	UpdateMumeiTimeOfDay(inst)
	TerrorBonusDamage(inst)
	killer_mode(inst)
	inst:SetBrain(brain)
	inst:DoTaskInTime(0,function (inst)
		inst:StopBrain()
	end)

	inst:AddTag("nanashi_mumei")
end

-- This initializes for the server only. Components are added here.
local master_postinit = function(inst)

	inst:ListenForEvent("ms_playerreroll", OnReroll)

	-- Set starting inventory
    inst.starting_inventory = start_inv[TheNet:GetServerGameMode()] or start_inv.default
	
	-- choose which sounds this character will play
	inst.soundsname = TUNING.NANASHI_MUMEI_VOICE1
	
	if inst.soundsname == "wathgrithr" or inst.soundsname == "webber" then
		inst.talker_path_override = "dontstarve_DLC001/characters/"
	end
	
	-- Stats	
	inst.components.health:SetMaxHealth(TUNING.NANASHI_MUMEI_HEALTH)
	inst.components.hunger:SetMax(TUNING.NANASHI_MUMEI_HUNGER)
	inst.components.sanity:SetMax(TUNING.NANASHI_MUMEI_SANITY)

	-- Day and Night Sanity Drain swap
	if TUNING.NANASHI_MUMEI_REVERSE_DAY_NIGHT_SANITY_DRAIN then
		inst.components.sanity:SetLightDrainImmune(true)
	end
	inst.components.sanity.custom_rate_fn = SanityRateFn

	-- Hunger bonus from berries
	local berries = {"berries","berries_cooked","berries_juicy","berries_juicy_cooked","wormlight","wormlight_lesser"}
	for _, v in pairs(berries) do
		inst.components.foodaffinity:AddPrefabAffinity(v, TUNING.NANASHI_MUMEI_BERRY_BONUS_HUNGER_GAIN)
	end

	--Disables Sanity Aura
	if TUNING.NANASHI_MUMEI_AURA == 1 then
		inst.components.sanity:SetFullAuraImmunity(true)
	elseif TUNING.NANASHI_MUMEI_AURA == 2 then
		inst.components.sanity.neg_aura_modifiers:SetModifier(inst,0)
	end

	-- Damage multiplier (optional)
    inst.components.combat.damagemultiplier = 1 * TUNING.NANASHI_MUMEI_DPS
	
	-- Hunger rate (optional)
	inst.components.hunger.hungerrate = 1 * TUNING.NANASHI_MUMEI_HUNGER_RATE  * TUNING.WILSON_HUNGER_RATE
	

	inst.OnLoad = onload
    inst.OnNewSpawn = onload
end

return MakePlayerCharacter("nanashi_mumei", prefabs, assets, common_postinit, master_postinit, prefabs)
