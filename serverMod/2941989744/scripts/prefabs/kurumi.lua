local KurumiAgeBadge = require "widgets/wandaagebadge"
local MakePlayerCharacter = require "prefabs/player_common"
local BanPick = {
    ["neverfadebush"] = true,
    ["statueglommer"] = true,
    ["plant_certificate"] = true,
    ["medal_wormwood_flower"] = true
}
local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
}

TUNING.KURUMI_OLDAGER = 100
TUNING.KURUMI_HUNGER = 130
TUNING.KURUMI_SANITY = 150
TUNING.CHARACTER_DETAILS_OVERRIDE.kurumi_health = "oldager"
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.KURUMI = { "krm_zafkiel", "krm_gun" }
TUNING.STARTING_ITEM_IMAGE_OVERRIDE.krm_zafkiel = { atlas = "images/inventoryimages/krm_items.xml", image = "krm_zafkiel.tex" }
TUNING.STARTING_ITEM_IMAGE_OVERRIDE.krm_gun = { atlas = "images/inventoryimages/krm_items.xml", image = "krm_gun.tex" }

local prefabs = {}
local start_inv = {
    "krm_gun",
    "krm_zafkiel"
}

local function onbecamehuman(inst)
    inst.components.locomotor:SetExternalSpeedMultiplier(inst, "kurumi_speed_mod", 1.2)
end
local function onbecameghost(inst)
    inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "kurumi_speed_mod")
end

local function onload(inst, data)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    inst:ListenForEvent("ms_becameghost", onbecameghost)

    if inst:HasTag("playerghost") then
        onbecameghost(inst)
    else
        onbecamehuman(inst)
    end

    if data then
        if data.health and data.health.health then
            inst.components.health.currenthealth = data.health.health
        end
        inst.components.health:DoDelta(0)
    end
end

local function OnSpawnPet(inst)
    --print("召唤")
    inst.components.health.disable_penalty = false
    inst.components.health:DeltaPenalty(0.2)
    inst.components.health:DoDelta(25, true, "krm_heal")
    --inst.components.health:SetMaxHealth(TUNING.KURUMI_OLDAGER)
    inst.components.health.disable_penalty = true
end

local function OnLosePet(inst, pet)
    --print("消失")
    inst.components.health.disable_penalty = false
    inst.components.health:DeltaPenalty(-0.2)
    
    --inst.components.health:SetMaxHealth(TUNING.KURUMI_OLDAGER)
    inst.components.health.disable_penalty = true

    if pet and not pet:HasTag("krm_bullent_buff9") then
        inst.components.sanity:DoDelta(-30)
        inst.components.health:DoDelta(0, true, "krm_heal")

    elseif pet and pet:HasTag("krm_bullent_buff9") then
        inst.components.health:DoDelta(65, true, "krm_heal")
    end
end

local function on_show_warp_marker(inst)
	if inst and inst.components.positionalwarp then inst.components.positionalwarp:EnableMarker(true) end
end

local function on_hide_warp_marker(inst)
	if inst and inst.components.positionalwarp then inst.components.positionalwarp:EnableMarker(false) end
end

local function DelayedWarpBackTalker(inst)
    -- if the player starts moving right away then we can skip this
    if inst.sg == nil or inst.sg:HasStateTag("idle") then 
        inst.components.talker:Say(GetString(inst, "ANNOUNCE_POCKETWATCH_RECALL"))
    end 
end

local function OnWarpBack(inst, data)
    if inst.components.positionalwarp ~= nil then
        if data ~= nil and data.reset_warp then
            inst.components.positionalwarp:Reset()
            inst:DoTaskInTime(15 * FRAMES, DelayedWarpBackTalker) 
        else
            inst.components.positionalwarp:GetHistoryPosition(true)
        end
    end
end

local function AddRipple(inst)
    if inst.qq then
    local rotation = inst.Transform:GetRotation()

    local theta = rotation * DEGREES
    local offset = Vector3(math.cos( theta ), 0, -math.sin( theta ))
    local pos = Vector3(inst.Transform:GetWorldPosition()) - offset * 2
    inst.qq.Transform:SetPosition(pos.x, 0, pos.z)
    inst.qq.Transform:SetRotation(inst.Transform:GetRotation())
    end
end

local common_postinit = function(inst)
    inst.MiniMapEntity:SetIcon("kurumi.tex")
    inst:AddTag("kurumi")
    inst:AddTag("pocketwatchcaster")
    -- inst:AddTag("expertchef")
    inst:AddTag("professionalchef")
    inst:AddTag("bookbuilder")
    inst:AddTag("masterchef")
	
--[[
    for i = 1, 1000 do
        inst:AddTag("kurumi"..i)
    end
]]
    if not TheNet:IsDedicated() then
        inst.CreateHealthBadge = KurumiAgeBadge
    end
end

local master_postinit = function(inst)
    inst.dmgmp = 0.8
    inst.soundsname = "willow"
    inst.skeleton_prefab = nil

    inst.pet_buff6 = nil

    inst:AddComponent("reader")
    inst:AddComponent("krm_ability")

    inst:AddComponent("oldager")
    inst.components.oldager:AddValidHealingCause("krm_heal")
	
	
    inst.components.builder.science_bonus = 1      ----科技+1，不然部分书籍无法制造
    --inst:AddComponent("sanityaura")
    --inst.components.sanityaura.aura = 10
--[[
    inst:DoPeriodicTask(0, function(inst)
        AddRipple(inst)
    end) 
]]
    inst:AddComponent("positionalwarp")
    inst.components.positionalwarp:SetWarpBackDist(TUNING.WANDA_WARP_DIST_NORMAL)
    inst:DoTaskInTime(0, function() inst.components.positionalwarp:SetMarker("pocketwatch_warp_marker") end)
    inst:ListenForEvent("show_warp_marker", on_show_warp_marker)
    inst:ListenForEvent("hide_warp_marker", on_hide_warp_marker)
    inst:ListenForEvent("onwarpback", OnWarpBack)

    inst.components.health:SetMaxHealth(TUNING.KURUMI_OLDAGER)
    inst.components.hunger:SetMax(TUNING.KURUMI_HUNGER)
    inst.components.sanity:SetMax(TUNING.KURUMI_SANITY)
    inst.components.health.canheal = false          --不可治愈
    inst.components.health.disable_penalty = true   --去除惩罚 
    inst.components.health.redirect = function(inst, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
        return inst.components.oldager and inst.components.oldager:OnTakeDamage(amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
    end

    inst:AddComponent("krm_pets")
    inst.components.krm_pets:SetMaxPets(3)
    inst.components.krm_pets:SetOnSpawnFn(OnSpawnPet)

    inst.losepet = OnLosePet
    
    inst.components.combat.damagemultiplier = inst.dmgmp

    inst:ListenForEvent("picksomething", function(inst, data)
        local item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if item and item:HasTag("krm_broom") then
            if data.object and data.object.components.pickable and not data.object.components.trader then
                if data.object.plant_def and data.object.components.plantresearchable and data.object.components.pickable.use_lootdropper_for_product then
                    for _, item in ipairs(data.object.components.lootdropper:GenerateLoot()) do
                        item = data.object.components.lootdropper:SpawnLootPrefab(item)
                        if item.components.inventoryitem then
                            inst.components.inventory:GiveItem(item, nil, inst:GetPosition())
                        end
                    end
                elseif data.object.components.pickable.product and not BanPick[data.object.prefab] then
                    local item = SpawnPrefab(data.object.components.pickable.product)
                    if item.components.stackable then
                        item.components.stackable:SetStackSize(data.object.components.pickable.numtoharvest)
                    end
                    inst.components.inventory:GiveItem(item, nil, data.object:GetPosition())
                    if (data.object.prefab == "cactus" or data.object.prefab == "oasis_cactus") and data.object.has_flower then
                        inst.components.inventory:GiveItem(SpawnPrefab("cactus_flower"), nil, data.object:GetPosition())
                    end
                end
            end
        end
    end)
    inst:ListenForEvent("onhitother", function(inst, data)
        local target = data.target
        local weapon = data.weapon
        if data.target:HasTag("") then

        end
    end)
    --[[
    inst:ListenForEvent("equip", function(inst, data)
        local weapon = data.item.components.weapon
        if inst.components.krm_ability.skinkey == "kurumi3" and weapon then
            weapon:SetDamage(weapon.damage / 2)
        end
    end)
    inst:ListenForEvent("unequip", function(inst, data)
        if data.item and data.item.components.weapon then
            if inst.components.krm_ability.skinkey == "kurumi3" then
                data.item.components.weapon:SetDamage(data.item.components.weapon.damage * 2)
            end
        end
    end)
    ]]
    inst:ListenForEvent("killed", function(inst, data)
        if not data.victim:HasTag("monster") and not data.victim:HasTag("krm_pet") then
            inst.components.sanity:DoDelta(-10)
        end
    end)
    inst:ListenForEvent("entity_death", function(src, data)
        if data.inst and data.inst:IsValid() and not inst.components.health:IsDead() and data.inst.components.health and inst:IsNear(data.inst, 20) and not data.inst:HasTag("wall") then
            data.inst:DoTaskInTime(1, function()
                local maxhealth = data.inst.components.health.maxhealth
                local num = math.min(20,math.floor(maxhealth / 10000))
                if num > 0 then
                    SpawnPrefab("krm_crystalfx"):SetInfo(data.inst, num)
                end
                num =  math.min(100,math.floor((maxhealth - (10000 * num)) / 100))
                if num > 0 then
                    SpawnPrefab("krm_dregsfx"):SetInfo(data.inst, num)
                end
            end)
        end
    end, TheWorld)

    inst:DoPeriodicTask(1, function()
    end)

    inst.components.combat.KrmDmgDelta = function(self, amount)
        if self.damagemultiplier then
            self.damagemultiplier = inst.dmgmp + amount
        end
    end

    local oldSetTemperature = inst.components.temperature.SetTemperature
    inst.components.temperature.SetTemperature = function(self, value)
        if inst.components.krm_ability.skinkey == "kurumi3" then
            value = 25
        end
        oldSetTemperature(self, value)
    end

    local oldCalcDamage = inst.components.combat.CalcDamage
    inst.components.combat.CalcDamage = function(self, target, weapon, multiplier)
        local damage = 0
        if target and target:IsValid() then
            damage = oldCalcDamage(self, target, weapon, multiplier)
            if damage > 0 and weapon and weapon:HasTag("krm_gun") and (weapon.bullet ~= nil or target == inst) then
                damage = 0
            end          
            if target:HasTag("shadow") then
                damage = damage * 2
            end
        end
        return damage
    end

    inst.OnLoad = onload
    inst.OnNewSpawn = onload
end

return MakePlayerCharacter("kurumi", prefabs, assets, common_postinit, master_postinit, start_inv)