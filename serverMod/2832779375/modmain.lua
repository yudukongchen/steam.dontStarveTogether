GLOBAL.setmetatable(env, {__index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end})

--[[
    local x,y,z = GetPlayer().Transform:GetWorldPosition() local ents = TheSim:FindEntities(x,y,z, 4) for i,v in ipairs(ents) do print(v.prefab) end
    print(DebugSpawn"我的物品":GetDebugString())
    TheWorld > sim > game > player
    ThePlayer.Physics:Teleport(0,0,0)
]]

PrefabFiles = {
    "py_place",
    "py_herds",
}

local MOD_NAME = "SOME_MODIFICATIONS"
local IS_SERVER = TheNet:GetIsServer()
local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS
local portable_foods = require("preparedfoods_warly")
local FISH_DATA = require("prefabs/oceanfishdef")
local stackable_replica = require("components/stackable_replica")

if GetModConfigData("tree_stop") then
    local _trees = {"evergreen", "twiggytree", "evergreen_sparse", "deciduoustree", "moon_tree", "marbleshrub", "palmconetree", "oceantree"}
    AddClassPostConstruct("components/growable", function(self)
        local _DoGrowth = self.DoGrowth
        function self:DoGrowth()
            if table.contains(_trees, self.inst.prefab) and self:GetStage() == 3 then
                return
            end
            return _DoGrowth(self)
        end
    end)
end

if GetModConfigData("ice_salt_box_no_spoiled") then
    TUNING.PERISH_FRIDGE_MULT = 0
    TUNING.PERISH_SALTBOX_MULT = 0
end

if GetModConfigData("no_pick_eater") then
    local _eater_characters = {"wathgrithr", "wurt", "warly"}
    for _, v in pairs(_eater_characters) do
        AddPrefabPostInit(v, function(inst)
            if not TheWorld.ismastersim then
                return inst
            end
            if inst.components.eater then
                inst:RemoveComponent("eater")
                inst:AddComponent("eater")
            end
        end)
    end

    AddPrefabPostInit("warly", function(inst)
        if not TheWorld.ismastersim then
            return inst
        end

        if inst.components.eater then
            table.removearrayvalue(inst.components.eater.preferseating, "preparedfood")
            table.removearrayvalue(inst.components.eater.preferseating, "pre-preparedfood")
        end
    end)
end

if GetModConfigData("super_attack_speed") then
    TUNING.WILSON_ATTACK_PERIOD = 0.2
    AddStategraphPostInit("wilson", function(sg)
        local _attack_onenter = sg.states["attack"].onenter
        sg.states["attack"].onenter = function(inst)
            _attack_onenter(inst)

            inst.sg:SetTimeout(0.2 + 0.5 * FRAMES)
        end

        table.insert(sg.states["attack"].timeline, 1, TimeEvent(4 * FRAMES, function(inst)
            if not (inst.sg.statemem.isbeaver or
                    inst.sg.statemem.ismoose or
                    -- inst.sg.statemem.iswhip or
                    -- inst.sg.statemem.ispocketwatch or
                    inst.sg.statemem.isbook) and
                inst.sg.statemem.projectiledelay == nil then
                inst:PerformBufferedAction()
                inst.sg:RemoveStateTag("abouttoattack")
            end
        end))

        --------------------------------------------------------------------------

        local _slingshot_shoot_onenter = sg.states["slingshot_shoot"].onenter
        sg.states["slingshot_shoot"].onenter = function(inst)
            _slingshot_shoot_onenter(inst)

            inst.sg:SetTimeout(0.2 + 0.5 * FRAMES)
        end
        table.insert(sg.states["slingshot_shoot"].timeline, 1, TimeEvent(2 * FRAMES, function(inst)
            if inst.sg.statemem.chained then
                local buffaction = inst:GetBufferedAction()
                local target = buffaction ~= nil and buffaction.target or nil
                if not (target ~= nil and target:IsValid() and inst.components.combat:CanTarget(target)) then
                    inst:ClearBufferedAction()
                    inst.sg:GoToState("idle")
                end
            end
        end))
        table.insert(sg.states["slingshot_shoot"].timeline, 2, TimeEvent(3 * FRAMES, function(inst)
            if inst.sg.statemem.chained then
                inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/stretch")
            end
        end))
        table.insert(sg.states["slingshot_shoot"].timeline, 3, TimeEvent(4 * FRAMES, function(inst)
            if inst.sg.statemem.chained then
                local buffaction = inst:GetBufferedAction()
                local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                if equip ~= nil and equip.components.weapon ~= nil and equip.components.weapon.projectile ~= nil then
                    local target = buffaction ~= nil and buffaction.target or nil
                    if target ~= nil and target:IsValid() and inst.components.combat:CanTarget(target) then
                        inst.sg.statemem.abouttoattack = false
                        inst:PerformBufferedAction()
                        inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/shoot")
                    else
                        inst:ClearBufferedAction()
                        inst.sg:GoToState("idle")
                    end
                else -- out of ammo
                    inst:ClearBufferedAction()
                    inst.components.talker:Say(GetString(inst, "ANNOUNCE_SLINGHSOT_OUT_OF_AMMO"))
                    inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/no_ammo")
                end
            end
        end))
    end)
    AddStategraphPostInit("wilson_client", function(sg)
        local _attack_onenter = sg.states["attack"].onenter
        sg.states["attack"].onenter = function(inst)
            _attack_onenter(inst)

            inst.sg:SetTimeout(0.2 + 0.5 * FRAMES)
        end

        table.insert(sg.states["attack"].timeline, 1, TimeEvent(4 * FRAMES, function(inst)
            if not (inst.sg.statemem.isbeaver or
                    inst.sg.statemem.ismoose or
                    -- inst.sg.statemem.iswhip or
                    -- inst.sg.statemem.ispocketwatch or
                    inst.sg.statemem.isbook) and
                inst.sg.statemem.projectiledelay == nil then
                inst:ClearBufferedAction()
                inst.sg:RemoveStateTag("abouttoattack")
            end
        end))
    end)
end

if GetModConfigData("magic_marble") then
    AddPrefabPostInit("marbleshrub", function(inst)
        inst:AddTag("tree")
        if not TheWorld.ismastersim then
            return inst
        end
    end)
end

if GetModConfigData("no_stump") then
    local _trees = {
        evergreen = 1,
        deciduoustree = 1,
        twiggytree = 1,
        evergreen_sparse = 1,
        marsh_tree = 1,
        mushtree_tall = 1,
        mushtree_medium = 1,
        mushtree_small = 1,
        mushtree_moon = 1,
        moon_tree = 2,
        palmconetree = 2,
    }

    for k, v in pairs(_trees) do
        AddPrefabPostInit(k, function(inst)
            if not TheWorld.ismastersim then
                return inst
            end

            if inst.components.workable then
                local _onfinish = inst.components.workable.onfinish
                inst.components.workable.onfinish = function(inst, worker)
                    if _onfinish then
                        _onfinish(inst, worker)
                    end
                    for i = 1, v do
                        inst.components.lootdropper:SpawnLootPrefab("log", inst:GetPosition())
                    end
                    inst:Remove()
                end
            end
        end)
    end
end

if GetModConfigData("cookpot_enhance") then
    for k,recipe in pairs (portable_foods) do
        AddCookerRecipe("cookpot", recipe)
        AddCookerRecipe("archive_cookpot", recipe)
    end
    local IsModCookingProduct_old = GLOBAL.IsModCookingProduct
    GLOBAL.IsModCookingProduct = function(cooker, name)
        if portable_foods[name] ~= nil then
            return false
        end
        if IsModCookingProduct_old ~= nil then
            return IsModCookingProduct_old(cooker, name)
        end
        return false
    end
end

if GetModConfigData("quick_work") then
    AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.PICK, "doshortaction"))
	AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.HARVEST, "doshortaction"))
    AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.COOK, "doshortaction"))
	AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.REPAIR, "doshortaction"))
	AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.HEAL, "doshortaction"))
	AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.SHAVE, "doshortaction"))
    AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.BUILD, "doshortaction"))
	AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.TAKEITEM, "doshortaction"))
	AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.FEED, "doshortaction"))
    AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.PET, "doshortaction"))
	AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.DRAW, "doshortaction"))
	AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.SEW, "doshortaction"))
	AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.SMOTHER, "doshortaction"))
	AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.MANUALEXTINGUISH, "doshortaction"))
	AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.TEACH, "doshortaction"))
	AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.UPGRADE, "doshortaction"))
	AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.MURDER, "doshortaction"))
	AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.UNWRAP, "doshortaction"))
	AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.BRUSH, "doshortaction"))
	AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.ACTIVATE, "doshortaction"))
	AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.FILL, "doshortaction"))
end

if GetModConfigData("one_axe") then
    TUNING.EVERGREEN_CHOPS_SMALL = 1
	TUNING.EVERGREEN_CHOPS_NORMAL = 1
	TUNING.EVERGREEN_CHOPS_TALL = 1
	TUNING.DECIDUOUS_CHOPS_SMALL = 1
	TUNING.DECIDUOUS_CHOPS_NORMAL = 1
	TUNING.DECIDUOUS_CHOPS_TALL = 1
	TUNING.DECIDUOUS_CHOPS_MONSTER = 1
	TUNING.TOADSTOOL_MUSHROOMSPROUT_CHOPS = 1
	TUNING.TOADSTOOL_DARK_MUSHROOMSPROUT_CHOPS = 1
	TUNING.MUSHTREE_CHOPS_SMALL = 1
	TUNING.MUSHTREE_CHOPS_MEDIUM = 1
	TUNING.MUSHTREE_CHOPS_TALL = 1
    TUNING.MOON_TREE_CHOPS_SMALL = 1
    TUNING.MOON_TREE_CHOPS_NORMAL = 1
    TUNING.MOON_TREE_CHOPS_TALL = 1
	TUNING.WINTER_TREE_CHOP_SMALL = 1
	TUNING.WINTER_TREE_CHOP_NORMAL = 1
	TUNING.WINTER_TREE_CHOP_TALL = 1
    TUNING.PALMCONETREE_CHOPS_SMALL = 1
    TUNING.PALMCONETREE_CHOPS_NORMAL = 1
    TUNING.PALMCONETREE_CHOPS_TALL = 1
	local function one_chop(inst)
        if not TheWorld.ismastersim then
            return inst
        end
		if inst.components.workable then
			inst.components.workable:SetWorkLeft(1)
		end
	end
	AddPrefabPostInit("marsh_tree", one_chop)
	AddPrefabPostInit("cave_banana_tree", one_chop)
	AddPrefabPostInit("livingtree", one_chop)
end

if GetModConfigData("one_mine") then
	TUNING.ROCKS_MINE = 1
	TUNING.ROCKS_MINE_MED = 1
	TUNING.ROCKS_MINE_LOW = 1

    TUNING.ICE_MINE = 1
	TUNING.SCULPTURE_COVERED_WORK = 1

	TUNING.MARBLETREE_MINE = 1
	TUNING.MARBLEPILLAR_MINE = 1
	TUNING.MARBLESHRUB_MINE_SMALL = 1
	TUNING.MARBLESHRUB_MINE_NORMAL = 1
	TUNING.MARBLESHRUB_MINE_TALL = 1

	TUNING.PETRIFIED_TREE_SMALL = 1
	TUNING.PETRIFIED_TREE_NORMAL = 1
	TUNING.PETRIFIED_TREE_TALL = 1

	TUNING.SPILAGMITE_SPAWNER = 1
	TUNING.SPILAGMITE_ROCK = 1

    TUNING.GARGOYLE_MINE = 1
    TUNING.GARGOYLE_MINE_LOW = 1

	TUNING.CAVEIN_BOULDER_MINE = 1
end

if GetModConfigData("one_second_fishrod") then
    AddPrefabPostInit("fishingrod", function(inst)
        if not TheWorld.ismastersim then
            return inst
        end
        if inst.components.fishingrod then
			inst.components.fishingrod:SetWaitTimes(0, 0)
		end
    end)
end

if GetModConfigData("more_containers") then
    local function more_containerfn(inst)
        if inst.SoundEmitter == nil then
            inst.entity:AddSoundEmitter()
        end

        if not TheWorld.ismastersim then
            inst.OnEntityReplicated = function(inst) inst.replica.container:WidgetSetup("treasurechest") end
            return inst
        end

        if inst.components.container == nil then
            inst:AddComponent("container")
            inst.components.container:WidgetSetup("treasurechest")
            inst.components.container.onopenfn = function(inst) inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open") end
            inst.components.container.onclosefn = function(inst) inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close") end
            inst.components.container.skipclosesnd = true
            inst.components.container.skipopensnd = true
        end

        if inst.components.preserver == nil then
            inst:AddComponent("preserver")
            inst.components.preserver:SetPerishRateMultiplier(0)
        end

        if inst.components.fueled then
            local old_depleted = inst.components.fueled.depleted
            inst.components.fueled.depleted = function(inst)
                if inst.components.container then
                    inst.components.container:DropEverything()
                end
                if old_depleted~=nil then
                    old_depleted(inst)
                end
            end
        end
    end
    AddPrefabPostInit("minerhat", more_containerfn)
    AddPrefabPostInit("molehat", more_containerfn)
    AddPrefabPostInit("heatrock", more_containerfn)
end

if GetModConfigData("worldtime_faster") then
    AddModRPCHandler(MOD_NAME, "timescale", function(player, timeScale)
        local currentTimeScale = TheSim:GetTimeScale()
        currentTimeScale = currentTimeScale + timeScale
        if currentTimeScale <= 0 then
            currentTimeScale = 1
        end
        if currentTimeScale > 10 then
            currentTimeScale = 10
        end
        TheSim:SetTimeScale(currentTimeScale)
        TheNet:Announce("当前世界时间流速为: x" .. currentTimeScale)
    end)
    TheInput:AddKeyHandler(function(key, down)
        if down then
            if key == 91 then -- [
                SendModRPCToServer(MOD_RPC[MOD_NAME]["timescale"], -1)
            elseif key == 93 then -- ]
                SendModRPCToServer(MOD_RPC[MOD_NAME]["timescale"], 1)
            end
        end
    end)
end

local function unlimituses_postinitfn(inst)
    if not TheWorld.ismastersim then
        return inst
    end

    if inst.components.finiteuses then
        inst:RemoveComponent("finiteuses")
    end
    if inst.components.fueled then
        inst:RemoveComponent("fueled")
    end
end
if GetModConfigData("unlimituses_tentaclespike") then
    AddPrefabPostInit("tentaclespike", unlimituses_postinitfn)
end
if GetModConfigData("unlimituses_heatrock") then
    AddPrefabPostInit("heatrock", function(inst)
        if not TheWorld.ismastersim then
            return inst
        end
        inst:ListenForEvent("percentusedchange", function(inst, data)
            local percent = data.percent
            if percent < 1 then
                inst.components.fueled:SetPercent(1.0)
            end
        end)
    end)
end
if GetModConfigData("unlimituses_molehat") then
    AddPrefabPostInit("molehat", unlimituses_postinitfn)
end

if GetModConfigData("oceanfish_no_season") then
    local SCHOOL_WEIGHTS = FISH_DATA.school

    --[[
        oceanfish_small_6: 落叶比目鱼
        oceanfish_medium_8: 冰鲷鱼
        oceanfish_small_7: 花鳍鲔鱼
        oceanfish_small_8: 炽热太阳鱼
    ]]
    SCHOOL_WEIGHTS[SEASONS.AUTUMN][GROUND.OCEAN_SWELL].oceanfish_small_6 = 4
    SCHOOL_WEIGHTS[SEASONS.AUTUMN][GROUND.OCEAN_WATERLOG].oceanfish_small_6 = 4
    SCHOOL_WEIGHTS[SEASONS.AUTUMN][GROUND.OCEAN_SWELL].oceanfish_medium_8 = 4
    SCHOOL_WEIGHTS[SEASONS.AUTUMN][GROUND.OCEAN_COASTAL].oceanfish_small_7 = 4
    SCHOOL_WEIGHTS[SEASONS.AUTUMN][GROUND.OCEAN_WATERLOG].oceanfish_small_7 = 4
    SCHOOL_WEIGHTS[SEASONS.AUTUMN][GROUND.OCEAN_SWELL].oceanfish_small_8 = 4

    SCHOOL_WEIGHTS[SEASONS.WINTER][GROUND.OCEAN_SWELL].oceanfish_small_6 = 4
    SCHOOL_WEIGHTS[SEASONS.WINTER][GROUND.OCEAN_WATERLOG].oceanfish_small_6 = 4
    SCHOOL_WEIGHTS[SEASONS.WINTER][GROUND.OCEAN_SWELL].oceanfish_medium_8 = 4
    SCHOOL_WEIGHTS[SEASONS.WINTER][GROUND.OCEAN_COASTAL].oceanfish_small_7 = 4
    SCHOOL_WEIGHTS[SEASONS.WINTER][GROUND.OCEAN_WATERLOG].oceanfish_small_7 = 4
    SCHOOL_WEIGHTS[SEASONS.WINTER][GROUND.OCEAN_SWELL].oceanfish_small_8 = 4

    SCHOOL_WEIGHTS[SEASONS.SPRING][GROUND.OCEAN_SWELL].oceanfish_small_6 = 4
    SCHOOL_WEIGHTS[SEASONS.SPRING][GROUND.OCEAN_WATERLOG].oceanfish_small_6 = 4
    SCHOOL_WEIGHTS[SEASONS.SPRING][GROUND.OCEAN_SWELL].oceanfish_medium_8 = 4
    SCHOOL_WEIGHTS[SEASONS.SPRING][GROUND.OCEAN_COASTAL].oceanfish_small_7 = 4
    SCHOOL_WEIGHTS[SEASONS.SPRING][GROUND.OCEAN_WATERLOG].oceanfish_small_7 = 4
    SCHOOL_WEIGHTS[SEASONS.SPRING][GROUND.OCEAN_SWELL].oceanfish_small_8 = 4

    SCHOOL_WEIGHTS[SEASONS.SUMMER][GROUND.OCEAN_SWELL].oceanfish_small_6 = 4
    SCHOOL_WEIGHTS[SEASONS.SUMMER][GROUND.OCEAN_WATERLOG].oceanfish_small_6 = 4
    SCHOOL_WEIGHTS[SEASONS.SUMMER][GROUND.OCEAN_SWELL].oceanfish_medium_8 = 4
    SCHOOL_WEIGHTS[SEASONS.SUMMER][GROUND.OCEAN_COASTAL].oceanfish_small_7 = 4
    SCHOOL_WEIGHTS[SEASONS.SUMMER][GROUND.OCEAN_WATERLOG].oceanfish_small_7 = 4
    SCHOOL_WEIGHTS[SEASONS.SUMMER][GROUND.OCEAN_SWELL].oceanfish_small_8 = 4

    AddPrefabPostInit("spoiled_food", function(inst)
        if not TheWorld.ismastersim then
            return inst
        end
        if inst.components ~= nil and inst.components.oceanfishingtackle ~= nil then
            inst.components.oceanfishingtackle:SetupLure({
                build = "oceanfishing_lure_mis",
                symbol = "hook_spoiledfood",
                single_use = false,
                lure_data = {
                    charm = 0.9,
                    reel_charm = 0.9,
                    radius = 8.0,
                    style = "rot",
                    timeofday = {
                        day = 5,
                        dusk = 5,
                        night = 5
                    },
                    dist_max = 2
                }
            })
        end
    end)
end

if GetModConfigData("oceanfish_into_inventory") then
    AddPrefabPostInit("oceanfishingrod", function(inst)
        if not TheWorld.ismastersim then
            return inst
        end

        if inst.components.oceanfishingrod then
            local old_ondonefishing = inst.components.oceanfishingrod.ondonefishing
            inst.components.oceanfishingrod.ondonefishing = function(inst, reason, lose_tackle, fisher, target)
                old_ondonefishing(inst, reason, lose_tackle, fisher, target)

                if reason == "success" and fisher and target and target:HasTag("oceanfish") and fisher.components.inventory then
                    inst:DoTaskInTime(0.8, function(inst)
                        local _fish_inv = SpawnPrefab(target.prefab .. "_inv")
                        if _fish_inv then
                            fisher.components.inventory:GiveItem(_fish_inv, nil, target:GetPosition())
                            target:Remove()
                        end
                    end)
                end
            end
        end
    end)
end

local became_winona = GetModConfigData("became_winona")
local became_wormwood = GetModConfigData("became_wormwood")
local became_wickerbottom = GetModConfigData("became_wickerbottom")
local became_wathgrithr = GetModConfigData("became_wathgrithr")
local became_wanda = GetModConfigData("became_wanda")
local became_wortox = GetModConfigData("became_wortox")
local became_warly = GetModConfigData("became_warly")
local became_walter = GetModConfigData("became_walter")
AddPlayerPostInit(function(inst)
    local function IsValidVictim(victim)
        return victim ~= nil
            and not ((victim:HasTag("prey") and not victim:HasTag("hostile")) or
                    victim:HasTag("veggie") or
                    victim:HasTag("structure") or
                    victim:HasTag("wall") or
                    victim:HasTag("balloon") or
                    victim:HasTag("groundspike") or
                    victim:HasTag("smashable") or
                    victim:HasTag("companion"))
            and victim.components.health ~= nil
            and victim.components.combat ~= nil
    end

    if became_winona then
        inst:AddTag("handyperson")
        inst:AddTag("fastbuilder")
        -- inst:AddTag("hungrybuilder")
    end
    if became_wormwood then
        inst:AddTag("plantkin")
    end
    if became_wickerbottom then
        inst:AddTag("bookbuilder")
        inst:AddTag("reader")
    end
    if became_wathgrithr then
        inst:AddTag("valkyrie")
        -- inst:AddTag("battlesinger")
    end
    if became_wanda then
        inst:AddTag("clockmaker")
        inst:AddTag("pocketwatchcaster")
    end
    if became_warly then
        inst:AddTag("masterchef")
        inst:AddTag("professionalchef")
        inst:AddTag("expertchef")
    end
    if became_walter and inst.prefab ~= "wolfgang" then
        inst:AddTag("slingshot_sharpshooter")
        inst:AddTag("efficient_sleeper")
        inst:AddTag("nowormholesanityloss")
        inst:AddTag("pebblemaker")
    end

    -----------------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    -----------------------------------------------------------------------------------------

    if became_wickerbottom then
        if not inst.components.reader then
            inst:AddComponent("reader")
        end
        inst.components.builder.science_bonus = 1
    end
    if became_wathgrithr then
        if not inst.components.battleborn then
            inst:AddComponent("battleborn")
            inst.components.battleborn:SetBattlebornBonus(TUNING.WATHGRITHR_BATTLEBORN_BONUS)
            inst.components.battleborn:SetSanityEnabled(true)
            inst.components.battleborn:SetHealthEnabled(true)
            inst.components.battleborn:SetValidVictimFn(IsValidVictim)
        end

        inst.components.combat.damagemultiplier = TUNING.WATHGRITHR_DAMAGE_MULT
        inst.components.health:SetAbsorptionAmount(TUNING.WATHGRITHR_ABSORPTION)

    end
end)

if GetModConfigData("auto_drop_rock_avocado_fruit") then
    AddClassPostConstruct("components/growable", function(self)
        local old_SetStage = self.SetStage
        function self:SetStage(stage)
            if self.inst.prefab == "rock_avocado_bush" and stage == 4 then
                self.inst.components.lootdropper:SpawnLootPrefab("rock_avocado_fruit", self.inst:GetPosition())
                self.inst.components.lootdropper:SpawnLootPrefab("rock_avocado_fruit", self.inst:GetPosition())
                self.inst.components.lootdropper:SpawnLootPrefab("rock_avocado_fruit", self.inst:GetPosition())

                if self.inst.components.pickable then
                    self.inst.components.pickable.makeemptyfn(self.inst)
                    self.inst.components.pickable:ConsumeCycles(1)
                    self.inst:DoTaskInTime(FRAMES, function(inst)
                        self.inst.components.pickable.onpickedfn(self.inst)
                    end)
                end
            else
                old_SetStage(self, stage)
            end
        end
    end)
end

if GetModConfigData("reed_shoval") then
    AddPrefabPostInit("reeds", function(inst)
        if not TheWorld.ismastersim then
            return inst
        end

        if not inst.components.lootdropper then
            inst:AddComponent("lootdropper")
        end
        if not inst.components.workable then
            inst:AddComponent("workable")
			inst.components.workable:SetWorkAction(ACTIONS.DIG)
			inst.components.workable:SetWorkLeft(1)
			inst.components.workable:SetOnFinishCallback(function(inst, worker)
                if inst.components.pickable ~= nil and inst.components.lootdropper ~= nil then
                    if inst.components.pickable:CanBePicked() then
                        inst.components.lootdropper:SpawnLootPrefab(inst.components.pickable.product, inst:GetPosition())
                    end

                    inst.components.lootdropper:SpawnLootPrefab("dug_monkeytail", inst:GetPosition())
                end
                inst:Remove()
            end)
        end
    end)
end

if GetModConfigData("banana_shoval") then
    AddPrefabPostInit("cave_banana_tree", function(inst)
        if not TheWorld.ismastersim then
            return inst
        end

        if not inst.components.lootdropper then
            inst:AddComponent("lootdropper")
        end
        inst.components.workable:SetWorkAction(ACTIONS.DIG)
        inst.components.workable:SetWorkLeft(1)
        inst.components.workable:SetOnFinishCallback(function(inst, worker)
            if inst.components.pickable ~= nil and inst.components.lootdropper ~= nil then
                if inst.components.pickable:CanBePicked() then
                    inst.components.lootdropper:SpawnLootPrefab(inst.components.pickable.product, inst:GetPosition())
                end

                inst.components.lootdropper:SpawnLootPrefab("dug_bananabush", inst:GetPosition())
            end
            inst:Remove()
        end)
    end)
end

if GetModConfigData("krampus_sack") then
    AddPrefabPostInit("krampus", function(inst)
        if not TheWorld.ismastersim then
            return inst
        end
        SetSharedLootTable( 'krampus',
        {
            {'monstermeat',  1.0},
            {'charcoal',     1.0},
            {'charcoal',     1.0},
            {'krampus_sack', 1.0},
        })
    end)
end

if GetModConfigData("lightninggoathorn") then
    AddPrefabPostInit("lightninggoat", function(inst)
        if not TheWorld.ismastersim then
            return inst
        end
        SetSharedLootTable( 'lightninggoat',
        {
            {'meat',              1.00},
            {'meat',              1.00},
            {'lightninggoathorn', 1.00},
        })
    end)
end

if GetModConfigData("farm_high_stress") then
    local veggieprefabs = {}
    local veggie_oversizedprefabs = {}
    for veggie, data in pairs(PLANT_DEFS) do
        if veggie ~= "randomseed" then
            table.insert(veggieprefabs, data.prefab)
            table.insert(veggie_oversizedprefabs, veggie .. "_oversized")
            AddPrefabPostInit("farm_plant_"..veggie, function(inst)
                if not TheWorld.ismastersim then
                    return inst
                end

                inst:DoTaskInTime(FRAMES, function(inst)
                    inst.force_oversized = true
                end)
            end)
            AddPrefabPostInit(veggie.."_oversized", function(inst)
                -- inst.Physics:SetActive(false)

                if not TheWorld.ismastersim then
                    return inst
                end
                if inst.components.perishable then
                    inst:RemoveComponent("perishable")
                end
            end)
        end
    end
    AddClassPostConstruct("components/growable", function(self)
        local _DoGrowth = self.DoGrowth
        function self:DoGrowth()
            if table.contains(veggieprefabs, self.inst.prefab) and self:GetStage() == 5 then
                return
            end
            return _DoGrowth(self)
        end
    end)
end

if GetModConfigData("niubility_gardening") then
    TUNING.BOOK_GARDENING_MAX_TARGETS = 999
end

if GetModConfigData("hoe_9x9") then
    AddComponentPostInit("farmtiller", function(self, inst)
        local _Till = self.Till
        -- 3x3耕地，代码来自musha
        function self:Till(pt, doer)
            if self.inst.prefab == "farm_hoe" or self.inst.prefab == "golden_farm_hoe" then
                local NewX, Newy, Newz = TheWorld.Map:GetTileCenterPoint(pt.x, pt.y, pt.z)

                local ents = TheWorld.Map:GetEntitiesOnTileAtPoint(NewX, 0, Newz)
                for _, ent in ipairs(ents) do
                    if ent ~= inst and ent:HasTag("soil") then
                        ent:PushEvent("collapsesoil")
                    elseif ent:HasTag("antlion_sinkhole") then -- 这段逻辑貌似没效
                        if ent.remainingrepairs then
                            for i = 1, ent.remainingrepairs do
                                ent:PushEvent("timerdone", {
                                    name = "nextrepair"
                                })
                            end
                        else
                            ent.remainingrepairs = 1
                            ent:PushEvent("timerdone", { name = "nextrepair" })
                        end
                    end
                end

                local TILLSOIL_IGNORE_TAGS = {"NOBLOCK", "player", "FX", "INLIMBO", "DECOR", "WALKABLEPLATFORM", "soil", "medal_farm_plow"}
                for i = 0, 2 do
                    for k = 0, 2 do
                        local loction_x = NewX + 1.3 * i - 1.3
                        local loction_z = Newz + 1.3 * k - 1.3
                        if TheWorld.Map:IsDeployPointClear(Vector3(loction_x, 0, loction_z), nil, GetFarmTillSpacing(), nil,
                            nil, nil, TILLSOIL_IGNORE_TAGS) then
                            SpawnPrefab("farm_soil").Transform:SetPosition(loction_x, 0, loction_z)
                        end
                    end
                end
                return true
            else
                return _Till(self, pt, doer)
            end
        end
    end)
end

if GetModConfigData("koalefant_tooth") then
    local function dropTooth(inst)
        if not TheWorld.ismastersim then
            return inst
        end
        if inst.components.lootdropper then
            inst.components.lootdropper:AddChanceLoot("walrus_tusk", 1)
        end
    end
    AddPrefabPostInit("koalefant_summer", dropTooth)
    AddPrefabPostInit("koalefant_winter", dropTooth)
end

if GetModConfigData("onday_beefalo") then
    TUNING.BEEFALO_MIN_DOMESTICATED_OBEDIENCE.ORNERY = 0.9
    TUNING.BEEFALO_DOMESTICATION_LOSE_DOMESTICATION = 0

    -- TUNING.BEEFALO_DOMESTICATION_OVERFEED_DOMESTICATION = 0
    -- TUNING.BEEFALO_DOMESTICATION_ATTACKED_BY_PLAYER_DOMESTICATION = 0
    -- TUNING.BEEFALO_DOMESTICATION_ATTACKED_DOMESTICATION = 1
    TUNING.BEEFALO_DOMESTICATION_BRUSHED_DOMESTICATION = 0.99

end

if GetModConfigData("niubility_wolfgang") then
    AddClassPostConstruct("components/mightiness", function(self, inst)
        function self:DoDec(...)
            return
        end
    end)
end

if GetModConfigData("fishrod_onwater") then
    AddPrefabPostInit("oceanfishingrod", function(inst)
        local function becameking(inst, owner)
            if owner.components.drownable ~= nil then
                if owner.components.drownable.enabled == false then
                    owner.Physics:ClearCollisionMask()
                    owner.Physics:CollidesWith(COLLISION.GROUND)
                    owner.Physics:CollidesWith(COLLISION.OBSTACLES)
                    owner.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
                    owner.Physics:CollidesWith(COLLISION.CHARACTERS)
                    owner.Physics:CollidesWith(COLLISION.GIANTS)
                elseif owner.components.drownable.enabled == true then
                    if not owner:HasTag("playerghost") then
                        owner.Physics:ClearCollisionMask()
                        owner.Physics:CollidesWith(COLLISION.WORLD)
                        owner.Physics:CollidesWith(COLLISION.OBSTACLES)
                        owner.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
                        owner.Physics:CollidesWith(COLLISION.CHARACTERS)
                        owner.Physics:CollidesWith(COLLISION.GIANTS)
                    end
                end
            end
        end

        if not TheWorld.ismastersim then
            return inst
        end

        if inst.components.equippable then
            local _onequip = inst.components.equippable.onequipfn
            inst.components.equippable:SetOnEquip(function(inst, owner)
                _onequip(inst, owner)

                if owner and owner.components.drownable then
                    owner.components.drownable.enabled = false
                    becameking(inst, owner)
                end
            end)

            local _onunequip = inst.components.equippable.onunequipfn
            inst.components.equippable:SetOnUnequip(function(inst, owner)
                _onunequip(inst, owner)

                if owner and owner.components.drownable then
                    owner.components.drownable.enabled = true
                    becameking(inst, owner)
                end
            end)
        end

    end)
end

if GetModConfigData("niubility_hambat") then
    AddPrefabPostInit("hambat", function(inst)
        if not TheWorld.ismastersim then
            return inst
        end
        if inst.components.equippable then
            local _onequip = inst.components.equippable.onequipfn
            inst.components.equippable:SetOnEquip(function(inst, owner)
                _onequip(inst, owner)
                if inst.components.weapon then
                    inst.components.weapon:SetDamage(TUNING.HAMBAT_DAMAGE)
                end
            end)

            local _onunequip = inst.components.equippable.onunequipfn
            inst.components.equippable:SetOnUnequip(function(inst, owner)
                _onunequip(inst, owner)
                if inst.components.weapon then
                    inst.components.weapon:SetDamage(TUNING.HAMBAT_DAMAGE)
                end
            end)
        end

        if inst.components.weapon then
            inst.components.weapon:SetOnAttack(function() end)
        end
    end)
end

if GetModConfigData("notafraid_cold") then
    local notafraid_cold_plants = {"grass", "sapling", "berrybush", "berrybush2", "berrybush_juicy"}
    for _,v in pairs(notafraid_cold_plants) do
        AddPrefabPostInit(v, function(inst)
            if not TheWorld.ismastersim then
                return inst
            end

            if inst.components.pickable then
                inst:DoTaskInTime(1, function(inst)
                    if inst.components.pickable.paused then
                        inst.components.pickable:Resume()
                    end
                end)
            end
            if inst.components.witherable then
                inst.components.witherable.wither_temp = 110
            end
        end)
    end
    AddClassPostConstruct("components/pickable", function(self)
        local old_Pause = self.Pause
        function self:Pause()
            old_Pause(self)
            if table.contains(notafraid_cold_plants, self.inst.prefab) then
                self:Resume()
            end
        end
    end)
end

if GetModConfigData("drop_stack") then
    local STACK_RADIUS = 20
    local function FindEntities(x, y, z)
        return TheSim:FindEntities(x, y, z, STACK_RADIUS, {"_stackable"},
        {"INLIMBO", "NOCLICK", "lootpump_oncatch", "lootpump_onflight"})
    end
    local function Put(inst, item)
        if item ~= inst and item.prefab == inst.prefab and item.skinname == inst.skinname then
            SpawnPrefab("sand_puff").Transform:SetPosition(item.Transform:GetWorldPosition())
            inst.components.stackable:Put(item)
        end
    end
    AddComponentPostInit("stackable", function(Stackable)
        local Get = Stackable.Get
        function Stackable:Get(...)
            local instance = Get(self, ...)
            if instance.xt_stack_task then
                instance.xt_stack_task:Cancel()
                instance.xt_stack_task = nil
            end
            return instance
        end
    end)
    AddPrefabPostInitAny(function(inst)
        if not TheWorld.ismastersim then
            return inst
        end
        if inst:HasTag("smallcreature") or inst:HasTag("heavy") or inst:HasTag("trap") or inst:HasTag("NET_workable") then
            return
        end
        if inst.components.stackable == nil or inst:IsInLimbo() or inst:HasTag("NOCLICK") then return end
        inst.xt_stack_task = inst:DoTaskInTime(.5, function()
            if inst.components.stackable == nil or inst:IsInLimbo() or inst:HasTag("NOCLICK") then return end
            if inst:IsValid() and not inst.components.stackable:IsFull() then
                for _, item in ipairs(FindEntities(inst.Transform:GetWorldPosition())) do
                    if item:IsValid() and not item.components.stackable:IsFull() then Put(inst, item) end
                end
            end
        end)
    end)
end

if GetModConfigData("_99stack") then
    local _no_stackable = {"shadowheart", "minotaurhorn", "eyeturret_item", "tallbirdegg", "tallbirdegg_cracked", "lavae_egg", "lavae_egg_cracked"}
    for k, v in pairs(FISH_DATA.fish) do
        table.insert(_no_stackable, k.."_inv")
    end

    table.insert(_no_stackable, "spider")
    table.insert(_no_stackable, "spider_warrior")
    table.insert(_no_stackable, "spider_hider")
    table.insert(_no_stackable, "spider_spitter")
    table.insert(_no_stackable, "spider_dropper")
    table.insert(_no_stackable, "spider_moon")
    table.insert(_no_stackable, "spider_healer")
    table.insert(_no_stackable, "spider_water")

    table.insert(_no_stackable, "pondeel")
    table.insert(_no_stackable, "pondfish")

    table.insert(_no_stackable, "deer_antler1")
    table.insert(_no_stackable, "deer_antler2")
    table.insert(_no_stackable, "deer_antler3")

    -- table.insert(_no_stackable, "glommerflower")
    table.insert(_no_stackable, "glommerwings")

    for _, v in pairs(_no_stackable) do
        AddPrefabPostInit(v, function(inst)
            if not TheWorld.ismastersim then
                return inst
            end

            if not inst.components.stackable then
                inst:AddComponent("stackable")
            end
        end)
    end
end

if GetModConfigData("_99stack1") then
    local _MAX_STACKSIZE = 99

    TUNING.STACK_SIZE_LARGEITEM = _MAX_STACKSIZE
    TUNING.STACK_SIZE_MEDITEM = _MAX_STACKSIZE
    TUNING.STACK_SIZE_SMALLITEM = _MAX_STACKSIZE
    TUNING.STACK_SIZE_TINYITEM = _MAX_STACKSIZE

    TUNING.WORTOX_MAX_SOULS = _MAX_STACKSIZE

    stackable_replica._ctor = function(self, inst)
        self._stacksize = net_byte(inst.GUID, "stackable._stacksize", "stacksizedirty")
        self._maxsize = _MAX_STACKSIZE
    end

    function stackable_replica:SetMaxSize(maxsize)
        self._maxsize = _MAX_STACKSIZE
    end
    function stackable_replica:MaxSize(maxsize)
        return self._maxsize
    end
end

if GetModConfigData("krampus_sack_fresh") then
    AddPrefabPostInit("krampus_sack", function(inst)
        if not TheWorld.ismastersim then
            return inst
        end

        if not inst.components.preserver then
            inst:AddComponent("preserver")
	        inst.components.preserver:SetPerishRateMultiplier(0)
        end
    end)
end

if GetModConfigData("explode_rockavocade") then
    AddPrefabPostInit("gunpowder", function(inst)
        if not TheWorld.ismastersim then
            return inst
        end

        if inst.components.explosive then
	        local old_onexplodefn = inst.components.explosive.onexplodefn
            inst.components.explosive.onexplodefn = function(inst)
                old_onexplodefn(inst)

                local x, y, z = inst.Transform:GetWorldPosition()
                local ents = TheSim:FindEntities(x, y, z, inst.components.explosive.explosiverange, nil, {"INLIMBO"})
                for k, v in pairs(ents) do
                    if v.prefab == "rock_avocado_fruit" then
                        if v.components.workable ~= nil and v.components.workable:CanBeWorked() then
                            for i = 1, math.ceil(v.components.stackable.stacksize/10) do
                                v.components.workable:WorkedBy(inst, 10)
                            end
                        end
                    end
                end
            end
        end
    end)
end

if GetModConfigData("cane_projectile") then
    AddPrefabPostInit("cane", function(inst)
        local function onattack(inst, attacker, target, skipsanity)
            if not target:IsValid() then
                --target killed or removed in combat damage phase
                return
            end

            if target.components.combat ~= nil then
                target.components.combat:SuggestTarget(attacker)
            end
        end

        inst:AddTag("fishingrod")
        inst:AddTag("tool")
        inst:AddTag("weapon")
        inst:AddTag("rangedweapon")

        if not TheWorld.ismastersim then
            return inst
        end

        if inst.components.weapon then
            inst.components.weapon:SetDamage(TUNING.CANE_DAMAGE)
            inst.components.weapon:SetRange(8, 10)
            inst.components.weapon:SetOnAttack(onattack)
            inst.components.weapon:SetProjectile("ice_projectile")
        end

        inst:AddComponent("tool")
        inst.components.tool:SetAction(ACTIONS.CHOP, 1)
        inst.components.tool:SetAction(ACTIONS.MINE, 1)
        -- inst.components.tool:SetAction(ACTIONS.DIG, 1)
        inst.components.tool:SetAction(ACTIONS.NET)

        inst.components.equippable.walkspeedmult = 1.4

        if not inst.components.fishingrod then
            inst:AddComponent("fishingrod")
            inst.components.fishingrod:SetWaitTimes(0, 0)
            inst.components.fishingrod:SetStrainTimes(0, 5)
        end
    end)
end

if GetModConfigData("hambat_aoe") then
    AddPrefabPostInit("hambat", function(inst)
        if not TheWorld.ismastersim then
            return inst
        end
        if inst.components.weapon then
            local exclude_tags = { "INLIMBO", "companion", "wall", "abigail", "shadowminion" }
            inst.components.weapon.onattack = function(inst, attacker, target)
                local x2, y2, z2 = target.Transform:GetWorldPosition()
                local ents = TheSim:FindEntities(x2, y2, z2, 4, { "_combat" }, exclude_tags)
                for i, ent in ipairs(ents) do
                    if ent ~= target and ent ~= attacker and attacker.components.combat:IsValidTarget(ent) and
                        (attacker.components.leader ~= nil and not attacker.components.leader:IsFollower(ent)) then
                            attacker:PushEvent("onareaattackother", { target = ent, weapon = inst, stimuli = nil })
                            ent.components.combat:GetAttacked(attacker, TUNING.HAMBAT_DAMAGE, inst, nil)
                    end
                end
            end
        end
    end)
end

-- if GetModConfigData("origin_healthbar") then
--     AddPrefabPostInitAny(function(inst)
--         if not TheWorld.ismastersim then
--             return inst
--         end
--         if inst.components.health and (inst:HasTag("epic") or inst:HasTag("monster")) then
--             if not inst.components.healthbar and not inst:HasTag("player") then
--                 inst:AddComponent("healthbar")
--                 inst.components.healthbar:Enable(false)
--             end
--         end
--     end)

--     AddClassPostConstruct("components/combat", function(self)
--         local old_SetTarget = self.SetTarget
--         function self:SetTarget(target)
--             if self.inst.components.healthbar then
--                 if target == nil then
--                     self.inst.components.healthbar:Enable(false)
--                 else
--                     self.inst.components.healthbar:Enable(true)
--                 end
--             end
--             return old_SetTarget(self, target)
--         end

--         local old_DropTarget = self.DropTarget
--         function self:DropTarget(hasnexttarget)
--             if self.target and self.inst.components.healthbar then
--                 self.inst.components.healthbar:Enable(false)
--             end
--             return old_DropTarget(self, hasnexttarget)
--         end
--     end)
-- end

if GetModConfigData("niubility_abigail") then
    TUNING.ABIGAIL_DAMAGE =
    {
        day = 40,
        dusk = 40,
        night = 40,
    }
    TUNING.ABIGAIL_SPEED = 5 * 2
    AddPrefabPostInit("abigail", function(inst)
        if not TheWorld.ismastersim then
            return inst
        end

        if inst.components.health then
            inst.components.health.regen.amount = 30
        end
    end)
end

if GetModConfigData("niubility_wanda") then

    TUNING.WANDA_SHADOW_DAMAGE_NORMAL = TUNING.WANDA_SHADOW_DAMAGE_OLD
    TUNING.WANDA_SHADOW_DAMAGE_YOUNG = TUNING.WANDA_SHADOW_DAMAGE_OLD

    AddPrefabPostInit("wanda", function(inst)
        if not TheWorld.ismastersim then
            return inst
        end
        if inst.components.health then
            inst.components.health:SetMaxHealth(TUNING.WILSON_HEALTH)
            inst.components.health.redirect = nil
            inst.components.health.canheal = true
        end

        if inst.components.combat then
            inst.components.combat.onhitotherfn = function(inst, target, damage, stimuli, weapon, damageresolved)
                if weapon ~= nil and target ~= nil and target:IsValid() and weapon:IsValid() and weapon:HasTag("shadow_item") then
                    local fx_prefab = weapon:HasTag("pocketwatch") and "wanda_attack_pocketwatch_old_fx" or "wanda_attack_shadowweapon_old_fx"
                            or nil

                    if fx_prefab ~= nil then
                        local fx = SpawnPrefab(fx_prefab)

                        local x, y, z = target.Transform:GetWorldPosition()
                        local radius = target:GetPhysicsRadius(.5)
                        local angle = (inst.Transform:GetRotation() - 90) * DEGREES
                        fx.Transform:SetPosition(x + math.sin(angle) * radius, 0, z + math.cos(angle) * radius)
                    end
                end
            end
        end
    end)
end

if GetModConfigData("wormwood_foodhealth") then
    AddPrefabPostInit("wormwood", function(inst)
        if not TheWorld.ismastersim then
            return inst
        end

        if inst.components.eater ~= nil then
            inst.components.eater:SetAbsorptionModifiers(1, 1, 1)
        end
    end)
end

if GetModConfigData("wortox_nofooddebuff") then
    AddPrefabPostInit("wortox", function(inst)
        if not TheWorld.ismastersim then
            return inst
        end

        if inst.components.eater ~= nil then
            inst.components.eater:SetAbsorptionModifiers(1, 1, 1)
        end
    end)
end

if GetModConfigData("auto_fuel") then
    local _auto_fuel = {
        pocketwatch_weapon = {type = "equippable", threshold = 0.75, fuel = "nightmarefuel"},
        yellowamulet = {type = "equippable", threshold = 0.6, fuel = "nightmarefuel"},
        armorskeleton = {type = "equippable", threshold = 0.7, fuel = "nightmarefuel", timeout = 0.5},
        minerhat = {type = "equippable", threshold = 0.7, fuel = "lightbulb"},
        molehat = {type = "equippable", threshold = 0.8, fuel = "lightbulb"},
    }

    AddPrefabPostInit("molehat", function(inst)
        if not TheWorld.ismastersim then
            return inst
        end
        if inst.components.fueled then
            inst.components.fueled.fueltype = FUELTYPE.CAVE
        end
    end)

    for k, v in pairs(_auto_fuel) do
        AddPrefabPostInit(k, function(inst)
            if not TheWorld.ismastersim then
                return inst
            end

            if inst.components.fueled then
                inst:ListenForEvent("percentusedchange", function(inst, data)
                    local percent = data.percent
                    if percent < v.threshold then
                        if v.type == "equippable" then
                            local owner = inst.components.inventoryitem.owner
                            if owner then
                                local fuel = owner.components.inventory:FindItem(function(item)
                                    return item.prefab == v.fuel
                                end)
                                if fuel then
                                    if v.timeout then
                                        inst:DoTaskInTime(v.timeout, function(inst)
                                        end)
                                    else
                                        inst.components.fueled:TakeFuelItem(fuel.components.stackable:Get(), owner)
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        end)
    end
end

if GetModConfigData("oceantreenut_landplant") then
    AddPrefabPostInit("oceantreenut", function(inst)
        local function ondeploy(inst, pt, deployer)
            local sapling = SpawnPrefab("oceantree")
            sapling.Transform:SetPosition(pt.x, pt.y, pt.z)
            sapling.SoundEmitter:PlaySound("dontstarve/wilson/plant_tree")
            inst:Remove()
        end

        if not TheWorld.ismastersim then
            return inst
        end

        inst:RemoveTag("heavy")

        if inst.components.inventoryitem then
            inst.components.inventoryitem.cangoincontainer = true
        end
        if inst.components.equippable then
            inst:RemoveComponent("equippable")
        end

        inst:AddComponent("deployable")
        inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
        inst.components.deployable.ondeploy = ondeploy
    end)
end

if GetModConfigData("one_celestial_task") then
    AddPrefabPostInit("moonstorm_static", function(inst)
        if not TheWorld.ismastersim then
            return inst
        end

        inst:DoTaskInTime(1, function(inst)
            local _finished = inst.finished
            inst.finished = function(inst)
                local pt = inst:GetPosition()
                _finished(inst)
                inst:ListenForEvent("animover", function()
                    local item1 = SpawnPrefab("moonstorm_static_item")
                    local item2 = SpawnPrefab("moonstorm_static_item")
                    item1.Transform:SetPosition(pt.x, pt.y, pt.z)
                    item2.Transform:SetPosition(pt.x, pt.y, pt.z)
                end)
            end
        end)
    end)
end

if GetModConfigData("nibility_alterguardianhat") then
    TUNING.SANITY_BECOME_ENLIGHTENED_THRESH = 0
    AddPrefabPostInit("alterguardianhat", function(inst)
        inst:AddTag("waterproofer")
        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("waterproofer")
        inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_ABSOLUTE)

        inst:AddComponent("insulator")
        inst.components.insulator:SetInsulation(TUNING.INSULATION_LARGE)
        inst.components.insulator:SetSummer()

        if inst.components.equippable then
            inst.components.equippable.insulated = true

            local _onequip = inst.components.equippable.onequipfn
            inst.components.equippable:SetOnEquip(function(inst, owner)
                _onequip(inst, owner)

                if owner and owner:HasTag("player") then
                    owner.components.health.externalabsorbmodifiers:SetModifier(inst, 0.7)
                end

                if inst.components.container ~= nil then
                    inst.components.container:Close(owner)
                end
            end)

            local _onunequip = inst.components.equippable.onunequipfn
            inst.components.equippable:SetOnUnequip(function(inst, owner)
                _onunequip(inst, owner)

                if owner and owner:HasTag("player") then
                    owner.components.health.externalabsorbmodifiers:RemoveModifier(inst)
                end
            end)
        end
    end)
end

if GetModConfigData("magic_craft_ancient") then
    AddRecipe2("slingshotammo_thulecite",		{Ingredient("thulecite_pieces", 1), Ingredient("nightmarefuel", 1)}, 							TECH.MAGIC_TWO,		{builder_tag="pebblemaker", numtogive = 10, no_deconstruction=true, nounlock=true}, {"MAGIC"})

    AddRecipe2("thulecite",						{Ingredient("thulecite_pieces", 6)},																	TECH.MAGIC_TWO,			{nounlock=true}, {"MAGIC"})
    AddRecipe2("wall_ruins_item",					{Ingredient("thulecite", 1)},																			TECH.MAGIC_TWO,			{nounlock=true, numtogive=6}, {"MAGIC"})
    AddRecipe2("nightmare_timepiece",				{Ingredient("thulecite", 2), Ingredient("nightmarefuel", 2)},											TECH.MAGIC_TWO,			{nounlock=true}, {"MAGIC"})
    AddRecipe2("orangeamulet",						{Ingredient("thulecite", 2), Ingredient("nightmarefuel", 3), Ingredient("orangegem", 1)},				TECH.MAGIC_TWO,			{nounlock=true}, {"MAGIC"})
    AddRecipe2("yellowamulet",						{Ingredient("thulecite", 2), Ingredient("nightmarefuel", 3), Ingredient("yellowgem", 1)},				TECH.MAGIC_TWO,			{nounlock=true}, {"MAGIC"})
    AddRecipe2("greenamulet",						{Ingredient("thulecite", 2), Ingredient("nightmarefuel", 3), Ingredient("greengem", 1)},				TECH.MAGIC_TWO,			{nounlock=true}, {"MAGIC"})
    AddRecipe2("orangestaff",						{Ingredient("nightmarefuel", 2), Ingredient("cane", 1), Ingredient("orangegem", 2)},					TECH.MAGIC_TWO,			{nounlock=true}, {"MAGIC"})
    AddRecipe2("yellowstaff",						{Ingredient("nightmarefuel", 4), Ingredient("livinglog", 2), Ingredient("yellowgem", 2)},				TECH.MAGIC_TWO,			{nounlock=true}, {"MAGIC"})
    AddRecipe2("greenstaff",						{Ingredient("nightmarefuel", 4), Ingredient("livinglog", 2), Ingredient("greengem", 2)},				TECH.MAGIC_TWO,			{nounlock=true}, {"MAGIC"})
    AddRecipe2("multitool_axe_pickaxe",			{Ingredient("goldenaxe", 1), Ingredient("goldenpickaxe", 1), Ingredient("thulecite", 2)},				TECH.MAGIC_TWO,			{nounlock=true}, {"MAGIC"})
    AddRecipe2("nutrientsgoggleshat",				{Ingredient("plantregistryhat", 1), Ingredient("thulecite_pieces", 4), Ingredient("purplegem", 1)},		TECH.MAGIC_TWO,			{nounlock=true}, {"MAGIC"})
    AddRecipe2("ruinshat",							{Ingredient("thulecite", 4), Ingredient("nightmarefuel", 4)},											TECH.MAGIC_TWO,			{nounlock=true}, {"MAGIC"})
    AddRecipe2("armorruins",						{Ingredient("thulecite", 6), Ingredient("nightmarefuel", 4)},											TECH.MAGIC_TWO,			{nounlock=true}, {"MAGIC"})
    AddRecipe2("ruins_bat",						{Ingredient("livinglog", 3), Ingredient("thulecite", 4), Ingredient("nightmarefuel", 4)},				TECH.MAGIC_TWO,			{nounlock=true}, {"MAGIC"})
    AddRecipe2("eyeturret_item",					{Ingredient("deerclops_eyeball", 1), Ingredient("minotaurhorn", 1), Ingredient("thulecite", 5)}, 		TECH.MAGIC_TWO,			{nounlock=true}, {"MAGIC"})
end

if GetModConfigData("alchemy") then
    AddRecipe2("rocks", {Ingredient("goldnugget",1)}, TECH.MAGIC_TWO, {}, {"REFINE"})
    AddRecipe2("flint", {Ingredient("goldnugget",2)}, TECH.MAGIC_TWO, {}, {"REFINE"})
    AddRecipe2("nitre", {Ingredient("goldnugget",4)}, TECH.MAGIC_TWO, {}, {"REFINE"})

    AddRecipe2("moonrocknugget", {Ingredient("goldnugget",4)}, TECH.MAGIC_TWO, {}, {"REFINE"})
    AddRecipe2("moonglass", {Ingredient("goldnugget",4)}, TECH.MAGIC_TWO, {}, {"REFINE"})

    AddRecipe2("redgem", {Ingredient("goldnugget",10)}, TECH.MAGIC_TWO, {}, {"REFINE"})
    AddRecipe2("bluegem", {Ingredient("goldnugget",10)}, TECH.MAGIC_TWO, {}, {"REFINE"})

    AddRecipe2("greengem", {Ingredient("purplegem",2)}, TECH.MAGIC_TWO, {}, {"REFINE"})
    AddRecipe2("orangegem", {Ingredient("purplegem",2)}, TECH.MAGIC_TWO, {}, {"REFINE"})
    AddRecipe2("yellowgem", {Ingredient("purplegem",2)}, TECH.MAGIC_TWO, {}, {"REFINE"})

    AddRecipe2("opalpreciousgem", {Ingredient("greengem",1),Ingredient("orangegem",1),Ingredient("yellowgem",1)}, TECH.MAGIC_TWO, {}, {"REFINE"})
end

if GetModConfigData("messagebottleempty") then
    AddRecipe2("messagebottleempty", {Ingredient("moonglass",1)}, TECH.SCIENCE_TWO, {}, {"REFINE"})
end

local function _py_breed(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:AddComponent("knownlocations")
    inst:AddComponent("herdmember")
    inst.components.herdmember:SetHerdPrefab("py_"..inst.prefab.."herd")
end
if GetModConfigData("koalefant_breed") then
    AddPrefabPostInit("koalefant_winter", _py_breed)
    AddPrefabPostInit("koalefant_summer", _py_breed)
end

if GetModConfigData("spat_breed") then
    AddPrefabPostInit("spat", _py_breed)
end

if GetModConfigData("bearger_breed") then
    AddPrefabPostInit("bearger", _py_breed)
end

if GetModConfigData("deerclops_breed") then
    AddPrefabPostInit("deerclops", _py_breed)
    AddPrefabPostInit("deerclops", function(inst)
        if not TheWorld.ismastersim then
            return inst
        end

        inst:DoTaskInTime(FRAMES, function(inst)
            inst:StopWatchingWorldState("stopwinter")
            inst.WantsToLeave = function() return false end
        end)
    end)
end

if GetModConfigData("stronggrip") then
    AddPlayerPostInit(function(inst)
        inst:AddTag("stronggrip")
    end)
end

if GetModConfigData("hermitcrab_refuse_nobody") then
    TUNING.HERMITCRAB.HEAVY_FISH_THRESHHOLD = 0
end

if GetModConfigData("more_fossil_piece") then
    AddPrefabPostInit("stalagmite_full", function(inst)
        if not TheWorld.ismastersim then
            return inst
        end
        SetSharedLootTable( 'full_rock',
        {
            {'rocks',       1.00},
            {'rocks',       1.00},
            {'rocks',       1.00},
            {'goldnugget',  1.00},
            {'flint',       1.00},
            {'fossil_piece',1.00},
            {'goldnugget',  0.25},
            {'flint',       0.60},
            {'bluegem',     0.05},
            {'redgem',      0.05},
        })
    end)
    AddPrefabPostInit("stalagmite_med", function(inst)
        if not TheWorld.ismastersim then
            return inst
        end
        SetSharedLootTable( 'med_rock',
        {
            {'rocks',       1.00},
            {'rocks',       1.00},
            {'flint',       1.00},
            {'goldnugget',  0.50},
            {'fossil_piece',1.00},
            {'flint',       0.60},
        })
    end)
    AddPrefabPostInit("stalagmite_low", function(inst)
        if not TheWorld.ismastersim then
            return inst
        end
        SetSharedLootTable( 'low_rock',
        {
            {'rocks',       1.00},
            {'flint',       1.00},
            {'goldnugget',  0.50},
            {'fossil_piece',1.00},
            {'flint',       0.30},
        })
    end)
    AddPrefabPostInit("stalagmite", function(inst)
        if not TheWorld.ismastersim then
            return inst
        end
        SetSharedLootTable( 'full_rock',
        {
            {'rocks',       1.00},
            {'rocks',       1.00},
            {'rocks',       1.00},
            {'goldnugget',  1.00},
            {'flint',       1.00},
            {'fossil_piece',1.00},
            {'goldnugget',  0.25},
            {'flint',       0.60},
            {'bluegem',     0.05},
            {'redgem',      0.05},
        })
    end)

    AddPrefabPostInit("stalagmite_tall_full", function(inst)
        if not TheWorld.ismastersim then
            return inst
        end
        SetSharedLootTable('stalagmite_tall_full_rock',
        {
            {'rocks',       1.00},
            {'rocks',       1.00},
            {'goldnugget',  1.00},
            {'flint',       1.00},
            {'fossil_piece',1.00},
            {'goldnugget',  0.25},
            {'flint',       0.60},
            {'redgem',      0.05},
            {'log',         0.05},
        })
    end)
    AddPrefabPostInit("stalagmite_tall_med", function(inst)
        if not TheWorld.ismastersim then
            return inst
        end
        SetSharedLootTable( 'stalagmite_tall_med_rock',
        {
            {'rocks',       1.00},
            {'rocks',       1.00},
            {'flint',       1.00},
            {'fossil_piece',1.00},
            {'goldnugget',  0.15},
            {'flint',       0.60},
        })
    end)
    AddPrefabPostInit("stalagmite_tall_low", function(inst)
        if not TheWorld.ismastersim then
            return inst
        end
        SetSharedLootTable( 'stalagmite_tall_low_rock',
        {
            {'rocks',       1.00},
            {'flint',       1.00},
            {'fossil_piece',1.00},
            {'goldnugget',  0.15},
            {'flint',       0.30},
        })
    end)
    AddPrefabPostInit("stalagmite_tall", function(inst)
        if not TheWorld.ismastersim then
            return inst
        end
        SetSharedLootTable( 'stalagmite_tall_full_rock',
        {
            {'rocks',       1.00},
            {'rocks',       1.00},
            {'goldnugget',  1.00},
            {'flint',       1.00},
            {'fossil_piece',1.00},
            {'goldnugget',  0.25},
            {'flint',       0.60},
            {'redgem',      0.05},
            {'log',         0.05},
        })
    end)
end

if GetModConfigData("reasonable_bundle") then
    AddPrefabPostInit("bundle", function(inst)
        if not TheWorld.ismastersim then
            return inst
        end
        if inst.components.unwrappable then
            local old_onunwrappedfn = inst.components.unwrappable.onunwrappedfn
            inst.components.unwrappable.onunwrappedfn = function(inst, pos, doer)
                if old_onunwrappedfn~=nil then
                    old_onunwrappedfn(inst, pos, doer)
                end
                SpawnPrefab("rope").Transform:SetPosition(pos:Get())
            end
        end
    end)
end

if GetModConfigData("deepocean_deploy_dockkit") then
    AddPrefabPostInit("dock_kit", function(inst)
        local function New_CLIENT_CanDeployDockKit(inst, pt, mouseover, deployer, rotation)
            local tile = TheWorld.Map:GetTileAtPoint(pt.x, 0, pt.z)
            -- if (tile == WORLD_TILES.OCEAN_COASTAL_SHORE or tile == WORLD_TILES.OCEAN_COASTAL) then
            if (tile >= 201 and tile <= 247) then
                local tx, ty = TheWorld.Map:GetTileCoordsAtPoint(pt.x, 0, pt.z)
                local found_adjacent_safetile = false
                for x_off = -1, 1, 1 do
                    for y_off = -1, 1, 1 do
                        if (x_off ~= 0 or y_off ~= 0) and IsLandTile(TheWorld.Map:GetTile(tx + x_off, ty + y_off)) then
                            found_adjacent_safetile = true
                            break
                        end
                    end

                    if found_adjacent_safetile then break end
                end

                if found_adjacent_safetile then
                    local center_pt = Vector3(TheWorld.Map:GetTileCenterPoint(tx, ty))
                    return found_adjacent_safetile and TheWorld.Map:CanDeployDockAtPoint(center_pt, inst, mouseover)
                end
            end

            return false
        end
        -- local old_custom_candeploy_fn = inst._custom_candeploy_fn
        inst._custom_candeploy_fn = New_CLIENT_CanDeployDockKit
    end)
end

if GetModConfigData("staffcoldlight_grow_farmplants") then
    AddPrefabPostInit("staffcoldlight", function(inst)
        inst:AddTag("daylight")
    end)
end

if GetModConfigData("merm_pigking_gold") then
    AddPrefabPostInit("pigking", function(inst)
        if not TheWorld.ismastersim then
            return inst
        end
        if inst.components.trader then
            local old_test = inst.components.trader.test
            inst.components.trader.test = function(inst, item, giver)
                local hat = giver.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
                if giver:HasTag("merm") and hat and hat.prefab == "footballhat" then
                    local is_event_item = IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS) and item.components.tradable.halloweencandyvalue and item.components.tradable.halloweencandyvalue > 0
                    return item.components.tradable.goldvalue > 0 or is_event_item or item.prefab == "pig_token"
                else
                    if old_test ~= nil then
                        return old_test(inst, item, giver)
                    end
                end
            end
        end
    end)
end

if GetModConfigData("dumbbells_autopickup") then
    AddClassPostConstruct("components/complexprojectile", function(self)
        local old_Hit = self.Hit
        function self:Hit(target)
            if old_Hit then
                old_Hit(self, target)
            end

            if self.inst:HasTag("dumbbell") and self.attacker then
                self.inst:DoTaskInTime(0.2, function(inst)
                    if self.attacker.components.inventory then
                        if self.attacker.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) ~= nil then
                            self.attacker.components.inventory:GiveItem(inst, nil, inst:GetPosition())
                        else
                            self.attacker.components.inventory:Equip(inst)
                        end
                    end
                end)
            end
        end
    end)
end














