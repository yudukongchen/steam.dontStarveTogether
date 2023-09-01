local easing = require('easing')

local function OnSwim(inst)
    if inst._ningen_swimmer:value() then
        -- if inst.components.locomotor then
        --     inst.components.locomotor:SetAllowPlatformHopping(true)
        -- end
        if not inst.components.amphibiouscreature then
            inst:AddComponent('amphibiouscreature')
            inst.components.amphibiouscreature:SetBanks('wilson', 'wilson')
            local x, y, z = inst.Transform:GetWorldPosition()
            inst.components.amphibiouscreature.in_water = not TheWorld.Map:IsVisualGroundAtPoint(x, 0, z)
        end
    else
        -- if inst.components.locomotor and inst:HasTag("swimming") and inst:HasTag("jump_swim") then
        --     inst.components.locomotor:SetAllowPlatformHopping(false)
        -- end
        if inst.components.amphibiouscreature then
            inst:RemoveComponent('amphibiouscreature')
        end
    end
end
----------------------------------------------------------------------------------------------------
local function DoSanityUpdate(inst)
    if inst.components.moisture and inst.components.sanity then
        local multiplier = inst.components.moisture:GetMoisture() / inst.components.moisture:GetMaxMoisture()
        local totalDapperness = 0
        for k, v in pairs(inst.components.inventory.equipslots) do
            if v.components.equippable ~= nil then
                totalDapperness = totalDapperness + math.abs(v.components.equippable:GetDapperness(inst))
            -- print(tostring(v.prefab).." : "..tostring(totalDapperness))
            end
        end
        local moisture_delta =
            easing.inSine(
            inst.components.moisture:GetMoisture(),
            0,
            TUNING.MOISTURE_SANITY_PENALTY_MAX,
            inst.components.moisture:GetMaxMoisture()
        )

        --贴贴有理智回复
        local n = 0
        local x, y, z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, 3)
        for k, j in pairs(ents) do
            if j.components.debuffable and j.components.debuffable:HasDebuff('buff_ningen_mucus') then
                if j:HasTag('player') then
                    n = n + 2
                else
                    n = n + 1
                end
            end
        end
        local tieDapperness = 0.2 * n

        local ningenDapperness =
            totalDapperness + (multiplier * (TUNING.NINGEN_WET_SANITY / 100)) + math.abs(moisture_delta) + tieDapperness

        inst.components.sanity.dapperness = ningenDapperness
    else
        if inst.components.sanity and inst.components.sanity.dapperness ~= 0 then
            inst.components.sanity.dapperness = 0
        end
    end
end

local function ningen_moisture_update(self, dt)
    -- if self.forceddrymodifiers:Get() then
    --     --can still get here even if we're not in the update list
    --     --i.e. LongUpdate or OnUpdate called explicitly
    --     return
    -- end

    local sleepingbagdryingrate = self:GetSleepingBagDryingRate()
    if sleepingbagdryingrate ~= nil then
        self.rate = -sleepingbagdryingrate
    else
        local moisturerate = self:GetMoistureRate()
        local dryingrate = self:GetDryingRate(moisturerate)
        local equippedmoisturerate = self:GetEquippedMoistureRate(dryingrate)
        local secreterate = self.inst.onsecretemucus and 3 or 1

        local swimRate = 0
        if TheWorld.state.israining then
            swimRate = TUNING.NINGEN_SWIM_RATE / 40
        end
        if self.inst:HasTag('swimming') then
            swimRate = TUNING.NINGEN_SWIM_RATE / 10
        end
        self.rate = moisturerate + equippedmoisturerate + swimRate - (dryingrate * secreterate)
    end
    self.ratescale =
        (self.rate > .3 and RATE_SCALE.INCREASE_HIGH) or (self.rate > .15 and RATE_SCALE.INCREASE_MED) or
        (self.rate > .001 and RATE_SCALE.INCREASE_LOW) or
        (self.rate < -3 and RATE_SCALE.DECREASE_HIGH) or
        (self.rate < -1.5 and RATE_SCALE.DECREASE_MED) or
        (self.rate < -.001 and RATE_SCALE.DECREASE_LOW) or
        RATE_SCALE.NEUTRAL

    self:DoDelta(self.rate * dt)
end

local ZERO_DISTANCE = 10
local ZERO_DISTSQ = ZERO_DISTANCE * ZERO_DISTANCE
local UPDATE_SPAWNLIGHT_ONEOF_TAGS = {'HASHEATER', 'spawnlight'}
local UPDATE_NOSPAWNLIGHT_MUST_TAGS = {'HASHEATER'}

local function ningen_temperature_update(self, dt, applyhealthdelta)
    self.externalheaterpower = 0
    self.delta = 0
    self.rate = 0

    if
        self.settemp ~= nil or self.inst.is_teleporting or
            (self.inst.components.health ~= nil and self.inst.components.health:IsInvincible())
     then
        return
    end

    -- Can override range, e.g. in special containers
    local mintemp = self.mintemp
    local maxtemp = self.maxtemp
    local ambient_temperature = TheWorld.state.temperature

    local owner = self.inst.components.inventoryitem ~= nil and self.inst.components.inventoryitem.owner or nil
    if owner ~= nil and owner:HasTag('fridge') and not owner:HasTag('nocool') then
        -- Inside a fridge, excluding icepack ("nocool")
        -- Don't cool it below freezing unless ambient temperature is below freezing
        mintemp = math.max(mintemp, math.min(0, ambient_temperature))
        self.rate = owner:HasTag('lowcool') and -.5 * TUNING.WARM_DEGREES_PER_SEC or -TUNING.WARM_DEGREES_PER_SEC
    else
        --print(self.delta + self.current, "after insulation")
        --print(self.rate, "final rate\n\n")
        -- Prepare to figure out the temperature where we are standing
        local x, y, z = self.inst.Transform:GetWorldPosition()
        local ents =
            self.usespawnlight and
            TheSim:FindEntities(x, y, z, ZERO_DISTANCE, nil, self.ignoreheatertags, UPDATE_SPAWNLIGHT_ONEOF_TAGS) or
            TheSim:FindEntities(x, y, z, ZERO_DISTANCE, UPDATE_NOSPAWNLIGHT_MUST_TAGS, self.ignoreheatertags)
        if self.usespawnlight and #ents > 0 then
            for i, v in ipairs(ents) do
                if v.components.heater == nil and v:HasTag('spawnlight') then
                    ambient_temperature = math.clamp(ambient_temperature, 10, TUNING.OVERHEAT_TEMP - 20)
                    table.remove(ents, i)
                    break
                end
            end
        end

        --print(ambient_temperature, "ambient_temperature")
        if self.sheltered_level > 1 then
            ambient_temperature = math.min(ambient_temperature, self.overheattemp - 5)
        end

        ambient_temperature = ambient_temperature
        self.delta = (ambient_temperature + self.totalmodifiers + self:GetMoisturePenalty() * .2) - self.current
        --print(self.delta + self.current, "initial target")

        if self.inst.components.inventory ~= nil then
            for k, v in pairs(self.inst.components.inventory.equipslots) do
                if v.components.heater ~= nil then
                    local heat = v.components.heater:GetEquippedHeat()
                    if
                        heat ~= nil and
                            ((heat > self.current and v.components.heater:IsExothermic()) or
                                (heat < self.current and v.components.heater:IsEndothermic()))
                     then
                        self.delta = self.delta + heat - self.current
                    end
                end
            end
            for k, v in pairs(self.inst.components.inventory.itemslots) do
                if v.components.heater ~= nil then
                    local heat, carriedmult = v.components.heater:GetCarriedHeat()
                    if
                        heat ~= nil and
                            ((heat > self.current and v.components.heater:IsExothermic()) or
                                (heat < self.current and v.components.heater:IsEndothermic()))
                     then
                        self.delta = self.delta + (heat - self.current) * carriedmult
                    end
                end
            end
            local overflow = self.inst.components.inventory:GetOverflowContainer()
            if overflow ~= nil then
                for k, v in pairs(overflow.slots) do
                    if v.components.heater ~= nil then
                        local heat, carriedmult = v.components.heater:GetCarriedHeat()
                        if
                            heat ~= nil and
                                ((heat > self.current and v.components.heater:IsExothermic()) or
                                    (heat < self.current and v.components.heater:IsEndothermic()))
                         then
                            self.delta = self.delta + (heat - self.current) * carriedmult
                        end
                    end
                end
            end
        end

        --print(self.delta + self.current, "after carried/equipped")

        -- Recently eaten temperatured food is inherently equipped heat/cold
        if
            self.bellytemperaturedelta ~= nil and
                ((self.bellytemperaturedelta > 0 and self.current < TUNING.HOT_FOOD_WARMING_THRESHOLD) or
                    (self.bellytemperaturedelta < 0 and self.current > TUNING.COLD_FOOD_CHILLING_THRESHOLD))
         then
            self.delta = self.delta + self.bellytemperaturedelta
        end

        --print(self.delta + self.current, "after belly")

        -- If very hot (basically only when have overheating screen effect showing) and under shelter, cool slightly
        if self.sheltered and self.current > TUNING.TREE_SHADE_COOLING_THRESHOLD then
            self.delta = self.delta - (self.current - TUNING.TREE_SHADE_COOLER)
        end

        --print(self.delta + self.current, "after shelter")

        for i, v in ipairs(ents) do
            if
                v ~= self.inst and not v:IsInLimbo() and v.components.heater ~= nil and
                    (v.components.heater:IsExothermic() or v.components.heater:IsEndothermic())
             then
                local heat = v.components.heater:GetHeat(self.inst)
                if heat ~= nil then
                    -- This produces a gentle falloff from 1 to zero.
                    local heatfactor = 1 - self.inst:GetDistanceSqToInst(v) / ZERO_DISTSQ
                    if self.inst:GetIsWet() then
                        heatfactor = heatfactor * TUNING.WET_HEAT_FACTOR_PENALTY
                    end

                    if v.components.heater:IsExothermic() then
                        -- heating heatfactor is relative to 0 (freezing)
                        local warmingtemp = heat * heatfactor
                        if warmingtemp > self.current then
                            self.delta = self.delta + warmingtemp - self.current
                        end
                        self.externalheaterpower = self.externalheaterpower + warmingtemp
                    else --if v.components.heater:IsEndothermic() then
                        -- cooling heatfactor is relative to overheattemp
                        local coolingtemp = (heat - self.overheattemp) * heatfactor + self.overheattemp
                        if coolingtemp < self.current then
                            self.delta = self.delta + coolingtemp - self.current
                        end
                    end
                end
            end
        end

        --print(self.delta + self.current, "after heaters")

        -- Winter insulation only affects you when it's cold out, summer insulation only helps when it's warm
        if ambient_temperature >= TUNING.STARTING_TEMP then
            -- it's cold out
            -- it's warm out
            if self.delta > 0 then
                -- If the player is heating up, defend using insulation.
                local winterInsulation, summerInsulation = self:GetInsulation()
                self.rate = math.min(self.delta, TUNING.SEG_TIME / (TUNING.SEG_TIME + summerInsulation))
            else
                -- If they are cooling, do it at full speed, and faster if they're overheated
                self.rate =
                    math.max(
                    self.delta,
                    self.current >= self.overheattemp and -TUNING.THAW_DEGREES_PER_SEC or -TUNING.WARM_DEGREES_PER_SEC
                )
            end
        elseif self.delta < 0 then
            -- If the player is cooling, defend using insulation.
            local winterInsulation, summerInsulation = self:GetInsulation()
            self.rate = math.max(self.delta, -TUNING.SEG_TIME / (TUNING.SEG_TIME + winterInsulation))
        else
            -- If they are heating up, do it at full speed, and faster if they're freezing
            self.rate =
                math.min(self.delta, self.current <= 0 and TUNING.THAW_DEGREES_PER_SEC or TUNING.WARM_DEGREES_PER_SEC)
        end
    end

    if self.inst:HasTag('swimming') then
        self.rate = -5
    end

    if self.current < 0 then
        self.rate = 10
    elseif self.current + self.rate * dt <= 0 then
        self.rate = 0
    end

    self:SetTemperature(math.clamp(self.current + self.rate * dt, mintemp, maxtemp))

    --applyhealthdelta nil defaults to true
    if applyhealthdelta ~= false and self.inst.components.health ~= nil then
        if self.current < 0 then
            self.inst.components.health:DoDelta(-self.hurtrate * dt, true, 'cold')
        elseif self.current > self.overheattemp then
            self.inst.components.health:DoDelta(-(self.overheathurtrate or self.hurtrate) * dt, true, 'hot')
        end
    end

    self.inst.components.hunger.burnratemodifiers:SetModifier(
        self.inst,
        math.clamp(1.0 + (25.0 - self.current) / 12.5, 1.0, 2.0),
        'ningen_temperature'
    )
end

local function eatfn(inst, food)
    if food.prefab == 'ice' then
        inst.components.moisture:DoDelta(2)
    else
        local item = SpawnPrefab('spoiled_food')
        item.Transform:SetPosition(inst.Transform:GetWorldPosition())
        item.components.inventoryitem:OnDropped(true)
        inst.sg:GoToState('refuseeat')
    end
end

local function onattackother(inst, data)
    local weapon = inst.components.combat:GetWeapon()
    local target = data.target
    if weapon == nil then
        if
            target.components.combat and target.components.combat.target ~= inst and not target:HasTag('equipmentmodel') and
                not target:HasTag('wall') and
                target.prefab ~= 'lureplant'
         then
            if target.prefab == 'hutch' or target.prefab == 'chester' then
                inst.components.hunger:DoDelta(1)
                inst.components.health:DoDelta(0.25)
            else
                inst.components.hunger:DoDelta(4)
                inst.components.health:DoDelta(1)
            end
        end
    end
end

local function onhitother(inst, data)
    if data.target ~= nil and inst.onsecretemucus == true then
        inst.onsecretemucus = false
        inst:RemoveTag('notarget')
        if inst.components.talker then
            inst.components.talker:Say('信息素停止分泌')
        end
        if inst.heartfx ~= nil then
            inst.heartfx:Remove()
            inst.heartfx = nil
        end
        inst._secrete_attackcd = false
        inst:DoTaskInTime(
            5,
            function()
                inst._secrete_attackcd = true
            end
        )
    end
end

local function OnMurdered(inst, data)
    local victim = data.victim
    local stackmult = data.stackmult
    if victim ~= nil and not inst.components.health:IsDead() then
        inst.components.hunger:DoDelta(4 * stackmult)
        inst.components.health:DoDelta(1 * stackmult)
    end
end

local function onequip(inst, data)
    if data.item then
        if inst:HasTag('on_parasitizing') then
            inst.components.inventory:DropItem(data.item)
        end
    end
end

local function GetDowningDamgeTunings(inst)
    return TUNING.DROWNING_DAMAGE_NINGEN
end

local BEAVERVISION_COLOURCUBES = {
    day = 'images/colour_cubes/beaver_vision_cc.tex',
    dusk = 'images/colour_cubes/beaver_vision_cc.tex',
    night = 'images/colour_cubes/beaver_vision_cc.tex',
    full_moon = 'images/colour_cubes/beaver_vision_cc.tex'
}

local function nightvision_onworldstateupdate(inst)
    if inst.components.playervision ~= nil then
        if TheWorld.state.isnight and not TheWorld.state.isfullmoon then
            inst.components.playervision:ForceNightVision(true)
            inst.components.playervision:SetCustomCCTable(BEAVERVISION_COLOURCUBES)
        else
            inst.components.playervision:ForceNightVision(false)
            inst.components.playervision:SetCustomCCTable(nil)
        end
    end
end

local function nightvision_activate(inst)
    if TheWorld ~= nil then
        if TheWorld:HasTag('cave') then
            if inst.components.playervision ~= nil then
                inst.components.playervision:ForceNightVision(true)
                inst.components.playervision:SetCustomCCTable(BEAVERVISION_COLOURCUBES)
            end
        else
            inst:WatchWorldState('isnight', nightvision_onworldstateupdate)
            inst:WatchWorldState('isfullmoon', nightvision_onworldstateupdate)
            nightvision_onworldstateupdate(inst)
        end
    end
end

local MakePlayerCharacter = require 'prefabs/player_common'

local assets = {
    Asset('ANIM', 'anim/ningen.zip'),
    Asset('ANIM', 'anim/ghost_ningen_build.zip'),
    Asset('ANIM', 'anim/ningen_swim.zip'),
    Asset('SCRIPT', 'scripts/prefabs/player_common.lua')
}

-- Your character's stats
TUNING.NINGEN_HEALTH = 150
TUNING.NINGEN_HUNGER = 150
TUNING.NINGEN_SANITY = 200

-- Custom starting inventory
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.NINGEN = {'ice', 'ice', 'ice', 'ice', 'ice'}

local start_inv = {'ice', 'ice', 'ice', 'ice', 'ice'}
for k, v in pairs(TUNING.GAMEMODE_STARTING_ITEMS) do
    start_inv[string.lower(k)] = v.NINGEN
end
local prefabs = FlattenTree(start_inv, true)

local function WhetherOnWater(inst)
    if TheWorld:HasTag('cave') then
        return
    end
    local x, y, z = inst.Transform:GetWorldPosition()
    if not TheWorld.Map:IsVisualGroundAtPoint(x, 0, z) and TheWorld.Map:GetPlatformAtPoint(x, z) == nil then
        if inst.components.locomotor then
        -- inst.components.locomotor:SetAllowPlatformHopping(false)
        end
        if not TheWorld.ismastersim then
            return
        end
        inst:AddTag('swimming')
        inst:AddTag('jump_swim')
        if not inst:HasTag('playerghost') then
            inst.components.skinner:SetSkinMode('swimming_skin')
        end
        if not inst.floater1 and not inst.floater2 then
            inst.floater1 = inst:SpawnChild('ne_float_fx_front2')
            inst.floater2 = inst:SpawnChild('ne_float_fx_back2')
            inst.floater1.Transform:SetPosition(0, .6, 0)
            inst.floater2.Transform:SetPosition(0, .6, 0)
        else
            inst.floater1:Show()
            inst.floater2:Show()
        end
    else
        inst:RemoveTag('swimming')
        inst:RemoveTag('jump_swim')
        if inst.floater1 or inst.floater2 then
            inst.floater1:Hide()
            inst.floater2:Hide()
        end
    end
end

local function onbecamehuman(inst)
    inst.components.locomotor:SetExternalSpeedMultiplier(inst, 'ningen_speed_mod', 1.2)
    nightvision_activate(inst)
    inst:DoTaskInTime(
        0,
        function()
            if inst.components.moisture then
                inst.components.moisture:SetPercent(1.0)
            end
        end
    )
    inst:DoTaskInTime(1.0, WhetherOnWater)
end

local function onbecameghost(inst)
    inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, 'dryness')
    inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, 'ningen_speed_mod')
    if inst.floater1 or inst.floater2 then
        inst.floater1:Hide()
        inst.floater2:Hide()
    end
    if inst._ningen_swimmer:value() then
        inst._ningen_swimmer:set(false)
        if inst.components.amphibiouscreature then
            inst:RemoveComponent('amphibiouscreature')
        end
    end
end

local function onload(inst, data)
    inst:ListenForEvent('ms_respawnedfromghost', onbecamehuman)
    inst:ListenForEvent('ms_becameghost', onbecameghost)
    nightvision_activate(inst)
    inst.floater1 = nil
    inst.floater2 = nil
    if inst:HasTag('playerghost') then
        onbecameghost(inst)
    else
        onbecamehuman(inst)
    end
    inst:AddTag('jump_swim')
end

local function onnewspawn(inst)
    inst:ListenForEvent('ms_respawnedfromghost', onbecamehuman)
    inst:ListenForEvent('ms_becameghost', onbecameghost)
    nightvision_activate(inst)
    inst.floater1 = nil
    inst.floater2 = nil
    if inst:HasTag('playerghost') then
        onbecameghost(inst)
    else
        onbecamehuman(inst)
    end
    inst:DoTaskInTime(
        0,
        function()
            if inst.components.moisture then
                inst.components.moisture:SetPercent(1.0)
            end
        end
    )
    inst:AddTag('jump_swim')
end

local common_postinit = function(inst)
    -- Minimap icon
    inst.MiniMapEntity:SetIcon('ningen.tex')
    inst:AddTag('ningen')
    inst:AddTag('wet')
    inst:AddTag('stronggrip')
    inst._ningen_swimmer = net_bool(inst.GUID, 'ningen._ningen_swimmer', '_ningen_swimmer_dirty')
    inst._ningen_swimmer:set(true)
    inst:ListenForEvent('sanitydelta', DoSanityUpdate)
    inst:ListenForEvent('playeractivated', OnSwim)
    OnSwim(inst)
    inst:ListenForEvent(
        '_ningen_swimmer_dirty',
        function()
            OnSwim(inst)
        end
    )
    inst.hop_cooldown = true
    inst:DoTaskInTime(0, WhetherOnWater)
    nightvision_activate(inst)
end
-- -----------------------------------------------
local master_postinit = function(inst)
    inst.starting_inventory = start_inv[TheNet:GetServerGameMode()] or start_inv.default

    inst:AddComponent('ningen_moisture')
    inst:AddComponent('ningen_parasitize')
    inst:AddComponent('killerwhalefriend')

    inst.soundsname = 'wendy'

    inst.components.health:SetMaxHealth(TUNING.NINGEN_HEALTH)
    inst.components.hunger:SetMax(TUNING.NINGEN_HUNGER)
    inst.components.sanity:SetMax(TUNING.NINGEN_SANITY)

    inst.components.combat.damagemultiplier = 1
    inst.components.moisture.no_moisture_penalty = true

    inst.components.hunger.hungerrate = 1 * TUNING.WILSON_HUNGER_RATE

    inst.components.moisture.OnUpdate = ningen_moisture_update
    inst.components.temperature.mintemp = 5
    inst.components.temperature.OnUpdate = ningen_temperature_update
    -- inst.components.locomotor.OnUpdate = ningen_locomotor_update

    if inst.components.eater ~= nil then
        inst.components.eater:SetAbsorptionModifiers(0, 0, 0)
        inst.components.eater:SetOnEatFn(eatfn)
    end

    inst.OnLoad = onload
    inst.OnNewSpawn = onnewspawn

    inst.onsecretemucus = false
    inst._ningen_swim_key_cooldown = true
    if inst.components.drownable then
        inst.components.drownable.enabled = false
        inst.components.drownable:SetCustomTuningsFn(GetDowningDamgeTunings)
    end

    inst:ListenForEvent('onattackother', onattackother)
    inst:ListenForEvent('onhitother', onhitother)
    inst:ListenForEvent('murdered', OnMurdered)
    inst:ListenForEvent('equip', onequip)

    inst:DoPeriodicTask(
        1,
        function()
            if inst.components.hunger:GetPercent() > 0.7 then
                inst.components.health:DoDelta(0.2, true)
            end

            --信息素
            if inst.onsecretemucus == false then
                return
            end

            local x, y, z = inst.Transform:GetWorldPosition()
            local range = 20
            local ents =
                TheSim:FindEntities(
                x,
                y,
                z,
                range,
                {'_combat'},
                {'ningen', 'chess', 'playerghost', 'FX', 'DECOR', 'INLIMBO', 'wall'}
            )

            if #ents == 0 then
                return
            end

            for i, v in ipairs(ents) do
                if v.prefab == 'gnarwail' and v.components.follower.leader == nil then
                    inst.components.leader:AddFollower(v)
                    if v.components.combat and v.components.combat.target and v.components.combat.target == inst then
                        v.components.combat:SetTarget(nil)
                    end
                end

                if v and v.components and v.components.health and v.components.health.currenthealth > 0 then
                    if not v.components.debuffable then
                        v:AddComponent('debuffable')
                    end
                    v.components.debuffable:AddDebuff('buff_ningen_mucus', 'buff_ningen_mucus')
                end
                if v:HasTag('player') then
                    v.components.sanity:DoDelta(0.2, true)
                end
            end
            -- print(inst.sg)
            -- print("now_pos",inst.Transform:GetWorldPosition())
            -- print("locomotor",inst.components.locomotor.wantstomoveforward)
            -- print(inst.components.amphibiouscreature.in_water)
        end
    )
end

return MakePlayerCharacter('ningen', prefabs, assets, common_postinit, master_postinit, prefabs)
