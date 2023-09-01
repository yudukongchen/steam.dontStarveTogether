require "prefabutil"

local yurt_assets =
{
    Asset("ANIM", "anim/mini_yurt.zip"),
}

local tipi_assets =
{
    Asset("ANIM", "anim/mini_tipi.zip"),
}

-----------------------------------------------------------------------
--For regular tents

local function PlaySleepLoopSoundTask(inst, stopfn)
    inst.SoundEmitter:PlaySound("dontstarve/common/tent_sleep")
end

local function stopsleepsound(inst)
    if inst.sleep_tasks ~= nil then
        for i, v in ipairs(inst.sleep_tasks) do
            v:Cancel()
        end
        inst.sleep_tasks = nil
    end
end

local function startsleepsound(inst, len)
    stopsleepsound(inst)
    inst.sleep_tasks =
    {
        inst:DoPeriodicTask(len, PlaySleepLoopSoundTask, 33 * FRAMES),
        inst:DoPeriodicTask(len, PlaySleepLoopSoundTask, 47 * FRAMES),
    }
end

-----------------------------------------------------------------------

local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_big")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then
        stopsleepsound(inst)
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle", true)
    end
    if inst.components.sleepingbag ~= nil and inst.components.sleepingbag.sleeper ~= nil then
        inst.components.sleepingbag:DoWakeUp()
    end
end

local function onfinishedsound(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/tent_dis_twirl")
end

local function onfinished(inst)
    if not inst:HasTag("burnt") then
        stopsleepsound(inst)
        inst.AnimState:PlayAnimation("destroy")
        inst:ListenForEvent("animover", inst.Remove)
        inst.SoundEmitter:PlaySound("dontstarve/common/tent_dis_pre")
        inst.persists = false
        inst:DoTaskInTime(16 * FRAMES, onfinishedsound)
    end
end

local function onbuilt_yurt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle", true)
    inst.SoundEmitter:PlaySound("dontstarve/common/tent_craft")
end

local function onbuilt_tipi(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle", true)
    inst.SoundEmitter:PlaySound("dontstarve/common/lean_to_craft")
end

local function onignite(inst)
    inst.components.sleepingbag:DoWakeUp()
end

local function wakeuptest(inst, phase)
    if phase ~= inst.sleep_phase then
        inst.components.sleepingbag:DoWakeUp()
    end
end

local function onwake(inst, sleeper, nostatechange)
    if inst.sleeptask ~= nil then
        inst.sleeptask:Cancel()
        inst.sleeptask = nil
    end

    inst:StopWatchingWorldState("phase", wakeuptest)
    sleeper:RemoveEventCallback("onignite", onignite, inst)

    if not nostatechange then
        if sleeper.sg:HasStateTag("tent") then
            sleeper.sg.statemem.iswaking = true
        end
        sleeper.sg:GoToState("wakeup")
    end

    if inst.sleep_anim ~= nil then
        inst.AnimState:PushAnimation("idle", true)
        stopsleepsound(inst)
    end

    inst.components.finiteuses:Use()
end

local function onsleeptick(inst, sleeper)
    local isstarving = sleeper.components.beaverness ~= nil and sleeper.components.beaverness:IsStarving()

    if sleeper.components.hunger ~= nil then
        sleeper.components.hunger:DoDelta(inst.hunger_tick, true, true)
        isstarving = sleeper.components.hunger:IsStarving()
    end

    if sleeper.components.sanity ~= nil and sleeper.components.sanity:GetPercentWithPenalty() < 1 then
        sleeper.components.sanity:DoDelta(inst.sanity_tick, true)
    end

    if not isstarving and sleeper.components.health ~= nil then
        sleeper.components.health:DoDelta(inst.health_tick * 2, true, inst.prefab, true)
    end

    if sleeper.components.temperature ~= nil then
        if inst.is_cooling then
            if sleeper.components.temperature:GetCurrent() > TUNING.SLEEP_TARGET_TEMP_TENT then
                sleeper.components.temperature:SetTemperature(sleeper.components.temperature:GetCurrent() - TUNING.SLEEP_TEMP_PER_TICK)
            end
        elseif sleeper.components.temperature:GetCurrent() < TUNING.SLEEP_TARGET_TEMP_TENT then
            sleeper.components.temperature:SetTemperature(sleeper.components.temperature:GetCurrent() + TUNING.SLEEP_TEMP_PER_TICK)
        end
    end

    if isstarving then
        inst.components.sleepingbag:DoWakeUp()
    end
end

local function onsleep(inst, sleeper)
    inst:WatchWorldState("phase", wakeuptest)
    sleeper:ListenForEvent("onignite", onignite, inst)

    if inst.sleep_anim ~= nil then
        inst.AnimState:PlayAnimation(inst.sleep_anim, true)
        startsleepsound(inst, inst.AnimState:GetCurrentAnimationLength())
    end

    if inst.sleeptask ~= nil then
        inst.sleeptask:Cancel()
    end
    inst.sleeptask = inst:DoPeriodicTask(TUNING.SLEEP_TICK_PERIOD, onsleeptick, nil, sleeper)
end

local function onsave(inst, data)
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end
end

local function onload(inst, data)
    if data ~= nil and data.burnt then
        inst.components.burnable.onburnt(inst)
    end
end

local function common_fn(bank, build, icon, tag, onbuiltfn)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()
	--Unsure what this does, gravity?  Possibly making tent bounce?
    MakeObstaclePhysics(inst, 1.4)

    inst:AddTag("tent")
    inst:AddTag("structure")
    if tag ~= nil then
        inst:AddTag(tag)
    end

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation("idle", true)

    inst.MiniMapEntity:SetIcon(icon)

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished(onfinished)

    inst:AddComponent("sleepingbag")
    inst.components.sleepingbag.onsleep = onsleep
    inst.components.sleepingbag.onwake = onwake
    --convert wetness delta to drying rate
    inst.components.sleepingbag.dryingrate = math.max(0, -TUNING.SLEEP_WETNESS_PER_TICK / TUNING.SLEEP_TICK_PERIOD)

    MakeSnowCovered(inst)
    inst:ListenForEvent("onbuilt", onbuiltfn)

    MakeLargeBurnable(inst, nil, nil, true)
    MakeMediumPropagator(inst)

    inst.OnSave = onsave 
    inst.OnLoad = onload

    MakeHauntableWork(inst)

    return inst
end

local function mini_yurt()
    local inst = common_fn("mini_yurt", "mini_yurt", "mini_yurt.tex", nil, onbuilt_yurt)

    if not TheWorld.ismastersim then
        return inst
    end

    inst.sleep_phase = "night"
    inst.sleep_anim = "sleep_loop"
    inst.hunger_tick = TUNING.SLEEP_HUNGER_PER_TICK
	inst.sanity_tick = TUNING.SLEEP_SANITY_PER_TICK
	inst.health_tick = TUNING.SLEEP_HEALTH_PER_TICK
    --inst.is_cooling = false
	inst.components.finiteuses:SetMaxUses(TUNING.TENT_USES)
    inst.components.finiteuses:SetUses(TUNING.TENT_USES)
	--Config Settings Tranfer to Constructed Yurt
	if miniatureyurtUses == "low" then
		inst.components.finiteuses:SetMaxUses(15)
		inst.components.finiteuses:SetUses(15)
	elseif miniatureyurtUses == "medium" then
		inst.components.finiteuses:SetMaxUses(30)
		inst.components.finiteuses:SetUses(30)
	elseif miniatureyurtUses == "high" then
		inst.components.finiteuses:SetMaxUses(60)
		inst.components.finiteuses:SetUses(60)
	elseif miniatureyurtUses == "infinite" then
		inst.components.finiteuses:SetMaxUses(1000000)
		inst.components.finiteuses:SetUses(1000000)
	end

	if miniatureyurtSanity == "low" then
		inst.sanity_tick = inst.sanity_tick * 0.5
	elseif miniatureyurtSanity == "medium" then
		inst.sanity_tick = inst.sanity_tick * 1
	elseif miniatureyurtSanity == "high" then
		inst.sanity_tick = inst.sanity_tick * 2
	end

	if miniatureyurtHunger == "low" then
		inst.hunger_tick = inst.hunger_tick * 0.5
	elseif miniatureyurtHunger == "medium" then
		inst.hunger_tick = inst.hunger_tick * 1
	elseif miniatureyurtHunger == "high" then
		inst.hunger_tick = inst.hunger_tick * 2
	end

	if miniatureyurtHealth == "low" then
		inst.health_tick = inst.health_tick * 0.5
	elseif miniatureyurtHealth == "medium" then
		inst.health_tick = inst.health_tick * 1
	elseif miniatureyurtHealth == "high" then
		inst.health_tick = inst.health_tick * 2
	end

    return inst
end

local function mini_tipi()
    local inst = common_fn("mini_tipi", "mini_tipi", "mini_tipi.tex", "siestahut", onbuilt_tipi)
						--(bank, 			build, 		icon, 	  note-> tag, 		onbuiltfn)
						--Note: Somehow Tag plays into the phase check in addition to the inst.sleep_phase.
    if not TheWorld.ismastersim then
        return inst
    end

    inst.sleep_phase = "day"
    --inst.sleep_anim = nil
    inst.hunger_tick = TUNING.SLEEP_HUNGER_PER_TICK
	inst.sanity_tick = TUNING.SLEEP_SANITY_PER_TICK
	inst.health_tick = TUNING.SLEEP_HEALTH_PER_TICK
    inst.is_cooling = true

    inst.components.finiteuses:SetMaxUses(TUNING.SIESTA_CANOPY_USES)
    inst.components.finiteuses:SetUses(TUNING.SIESTA_CANOPY_USES)
	--Config Settings Tranfer to Constructed Tipi
	if miniaturetipiUses == "low" then
		inst.components.finiteuses:SetMaxUses(15)
		inst.components.finiteuses:SetUses(15)
	elseif miniaturetipiUses == "medium" then
		inst.components.finiteuses:SetMaxUses(30)
		inst.components.finiteuses:SetUses(30)
	elseif miniaturetipiUses == "high" then
		inst.components.finiteuses:SetMaxUses(60)
		inst.components.finiteuses:SetUses(60)
	elseif miniaturetipiUses == "infinite" then
		inst.components.finiteuses:SetMaxUses(1000000)
		inst.components.finiteuses:SetUses(1000000)
	end

	if miniaturetipiSanity == "low" then
		inst.sanity_tick = inst.sanity_tick * 0.5
	elseif miniaturetipiSanity == "medium" then
		inst.sanity_tick = inst.sanity_tick * 1
	elseif miniaturetipiSanity == "high" then
		inst.sanity_tick = inst.sanity_tick * 2
	end

	if miniaturetipiHunger == "low" then
		inst.hunger_tick = inst.hunger_tick * 0.5
	elseif miniaturetipiHunger == "medium" then
		inst.hunger_tick = inst.hunger_tick * 1
	elseif miniaturetipiHunger == "high" then
		inst.hunger_tick = inst.hunger_tick * 2
	end

	if miniaturetipiHealth == "low" then
		inst.health_tick = inst.health_tick * 0.5
	elseif miniaturetipiHealth == "medium" then
		inst.health_tick = inst.health_tick * 1
	elseif miniaturetipiHealth == "high" then
		inst.health_tick = inst.health_tick * 2
	end

    return inst
end

STRINGS.NAMES.MINI_YURT = "蒙古包"
STRINGS.RECIPE_DESC.MINI_YURT = "夜晚睡觉，功能类似普通帐篷。"
STRINGS.NAMES.MINI_TIPI	= "蒙古帐篷"
STRINGS.RECIPE_DESC.MINI_TIPI = "白天睡觉，为炎热的夏日制作的小帐篷。"
--Yurt Examination Quotes
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MINI_YURT = "It's big! I can see myself sleeping in this."
STRINGS.CHARACTERS.WILLOW.DESCRIBE.MINI_YURT = "They teach a lot of things in the Girl Scouts."
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.MINI_YURT = "Wolfgang feels more close to home."
STRINGS.CHARACTERS.WENDY.DESCRIBE.MINI_YURT = "Death draws closer as each hour passes."
STRINGS.CHARACTERS.WX78.DESCRIBE.MINI_YURT = "REBOOTING FACILITY"
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.MINI_YURT = "A dwelling used by Nomads."
STRINGS.CHARACTERS.WOODIE.DESCRIBE.MINI_YURT = "It's a warm home. Better than sleeping on the ground."
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.MINI_YURT = "I wish it had more style to it."
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.MINI_YURT = "A home made for a true warrior!"
STRINGS.CHARACTERS.WEBBER.DESCRIBE.MINI_YURT = "We have a lot of resting space now."
--Tipi Examination Quotes
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MINI_TIPI = "A tent with more style to it."
STRINGS.CHARACTERS.WILLOW.DESCRIBE.MINI_TIPI = "They taught us how to make these in Girl Scouts, I think?"
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.MINI_TIPI = "Bigger napping place."
STRINGS.CHARACTERS.WENDY.DESCRIBE.MINI_TIPI = "Passes time to bring death closer."
STRINGS.CHARACTERS.WX78.DESCRIBE.MINI_TIPI = "REBOOTING FACILITY FOR SUMMER"
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.MINI_TIPI = "A dwelling used by Native Americans."
STRINGS.CHARACTERS.WOODIE.DESCRIBE.MINI_TIPI = "That's one sturdy tent."
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.MINI_TIPI = "A bit rustic, but it will work."
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.MINI_TIPI = "True warriörs sleep in these!"
STRINGS.CHARACTERS.WEBBER.DESCRIBE.MINI_TIPI = "It's a tent?"

return

Prefab("mini_yurt", mini_yurt, yurt_assets),
MakePlacer("mini_yurt_placer", "mini_yurt", "mini_yurt", "idle"),
Prefab("mini_tipi", mini_tipi, tipi_assets),
MakePlacer("mini_tipi_placer", "mini_tipi", "mini_tipi", "idle")
