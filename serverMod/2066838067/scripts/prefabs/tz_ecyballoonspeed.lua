
local BALLOONS = require "prefabs/balloons_common"
local easing = require("easing")

local assets =
{
    Asset("ANIM", "anim/balloon.zip"),
    Asset("ANIM", "anim/balloon_shapes.zip"),

    Asset("ANIM", "anim/balloon2.zip"), 
    Asset("ANIM", "anim/balloon_shapes2.zip"),

    Asset("ANIM", "anim/balloon_shapes_speed.zip"),

    Asset("ANIM", "anim/tz_ecyballoonspeed.zip"),

    Asset("IMAGE", "images/inventoryimages/tz_ecyballoonspeed.tex"),
    Asset("ATLAS", "images/inventoryimages/tz_ecyballoonspeed.xml"),
    Asset("IMAGE", "images/inventoryimages/tz_ecyballoonspeed_bilibili.tex"),
    Asset("ATLAS", "images/inventoryimages/tz_ecyballoonspeed_bilibili.xml"),
    Asset("IMAGE", "images/inventoryimages/tz_ecyballoonspeed_hmbb.tex"),
    Asset("ATLAS", "images/inventoryimages/tz_ecyballoonspeed_hmbb.xml"),

    Asset("SCRIPT", "scripts/prefabs/balloons_common.lua"),
    Asset("INV_IMAGE", "balloonspeed"),
    Asset("INV_IMAGE", "balloonspeed3"),
    Asset("INV_IMAGE", "balloonspeed2"),
    Asset("INV_IMAGE", "balloonspeed1"),
}

local prefabs =
{
    "balloon_held_child", -- used in balloons_common.OnEquip_Hand
	"balloon_mapicon",
	"globalmapicon",
}

local balloon_speeds = TUNING.BALLOON_SPEEDS

local pickup_time = 1.5

local function updatemotorvel(inst, xvel, yvel, zvel, t0)
    local x, y, z = inst.Transform:GetWorldPosition()
    if y >= 35 then
        inst:Remove()
        return
    end
    local time = GetTime() - t0

	if time >= pickup_time and inst.persists then
		BALLOONS.DeactiveBalloon(inst)
	end

    if time >= 15 then
        inst:Remove()
        return
    elseif time < pickup_time then
        local scale = easing.inQuad(time, 1, -1, pickup_time)
        inst.DynamicShadow:SetSize(scale, .5 * scale)
    else
        inst.DynamicShadow:Enable(false)
    end
    local hthrottle = easing.inQuad(math.clamp(time - 1, 0, 3), 0, 1, 3)
    yvel = easing.inQuad(math.min(time, 3), 1, yvel - 1, 3)
    inst.Physics:SetMotorVel(xvel * hthrottle, yvel, zvel * hthrottle)
end

local function flyoff(inst)
    local xvel = math.random() * 2 - 1
    local yvel = 5
    local zvel = math.random() * 2 - 1

	if not inst.components.fueled:IsEmpty() then
	    inst.Physics:ClearCollisionMask()

		inst.flyawaytask = inst:DoPeriodicTask(FRAMES, updatemotorvel, nil, xvel, yvel, zvel, GetTime())

		local map_icon = SpawnPrefab("balloon_mapicon")
		map_icon.Transform:SetPosition(inst.Transform:GetWorldPosition())
	else
		inst.flyawaytask = nil
	end
end

local function OnDropped(inst)
	inst.AnimState:PlayAnimation("idle", true)

	if inst.flyawaytask == nil and not inst.components.fueled:IsEmpty() then
		inst.flyawaytask = inst:DoTaskInTime(0.2, flyoff)
	end
end

local function OnPickup(inst)
	if inst.flyawaytask ~= nil then
		inst.flyawaytask:Cancel()
		inst.flyawaytask = nil
	end
end

local function SetHeliumLevel(inst, level)
	inst.balloon_num = Clamp(level, 1, #balloon_speeds)

    local skin_build = inst:GetSkinBuild() or "none"

	if not POPULATING and not inst:IsInLimbo() and not inst.components.poppable.popped then
		inst.AnimState:PlayAnimation("deflate")
		inst.AnimState:PushAnimation("idle", true)

        inst:DoTaskInTime(13*FRAMES, function() inst.AnimState:OverrideSymbol("swap_balloon", "tz_ecyballoonspeed", skin_build) end)
	else
        inst.AnimState:OverrideSymbol("swap_balloon", "tz_ecyballoonspeed", skin_build)
	end

	inst.components.equippable.walkspeedmult = balloon_speeds[inst.balloon_num] or balloon_speeds[1]
end

local function onfuelsectionchange(newsection, oldsection, inst)
	SetHeliumLevel(inst, newsection + 1) -- bring it back to a 1-based number
end

local function DisplayNameFn(inst)
	return inst:HasTag("fueldepleted") and STRINGS.NAMES.BALLOON or nil
end

local function getstatus(inst)
	return inst.components.fueled:IsEmpty() and "DEFLATED"
		or nil
end

local function TurnOff(inst)
	if	inst then
        inst.Physics:SetMass(10)

        if inst.flyawaytask == nil and not inst.components.fueled:IsEmpty() then
            inst.flyawaytask = inst:DoTaskInTime(0.2, flyoff)
        end
        inst.components.inventoryitem.canbepickedup = false
	end
end

local function TurnOn(inst)
	if	inst then
        if inst.flyawaytask ~= nil then
            inst.flyawaytask:Cancel()
            inst.flyawaytask = nil
        end
        inst.Physics:Stop()
        inst.DynamicShadow:Enable(true)
        inst.Physics:SetMass(100000)
        local x, y, z = inst.Transform:GetWorldPosition()
        if  y > 0 then
            inst.Transform:SetPosition(x, 0, z)
        end
        inst.components.inventoryitem.canbepickedup = false
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddDynamicShadow()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	BALLOONS.MakeFloatingBallonPhysics(inst)

    inst.AnimState:SetBank("balloon2")
    inst.AnimState:SetBuild("balloon2")
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:OverrideSymbol("swap_balloon", "tz_ecyballoonspeed", "none")

    inst.DynamicShadow:SetSize(1, .5)

    inst:AddTag("nopunch")
    inst:AddTag("cattoyairborne")
    inst:AddTag("balloon")
    inst:AddTag("noepicmusic")

    inst.displaynamefn = DisplayNameFn

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.balloon_build = "tz_ecyballoonspeed"

	BALLOONS.MakeBalloonMasterInit(inst, BALLOONS.DoPop_Floating)

    inst.components.inspectable.getstatus = getstatus

	inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
    inst.components.inventoryitem:SetOnPutInInventoryFn(OnPickup)
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_ecyballoonspeed.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(BALLOONS.OnEquip_Hand)
    inst.components.equippable:SetOnUnequip(BALLOONS.OnUnequip_Hand)
    inst.components.equippable.walkspeedmult = balloon_speeds[#balloon_speeds]

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.MAGIC
    inst.components.fueled:InitializeFuelLevel(TUNING.BALLOON_SPEED_DURATION)
	inst.components.fueled:SetSections(#balloon_speeds - 1) -- 0-based: [0, #balloon_speeds)
    inst.components.fueled:SetSectionCallback(onfuelsectionchange)
	inst.components.fueled:StartConsuming()

    BALLOONS.SetRopeShape(inst)

	inst.balloon_num = #balloon_speeds

	OnDropped(inst)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("tz_ecyballoonspeed", fn, assets, prefabs)
