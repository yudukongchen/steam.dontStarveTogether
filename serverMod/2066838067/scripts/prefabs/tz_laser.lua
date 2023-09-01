local assets =
{
    Asset("ANIM", "anim/deerclops_laser_hit_sparks_fx.zip"),
}

local assets_scorch =
{
    Asset("ANIM", "anim/burntground.zip"),
}

local assets_trail =
{
    Asset("ANIM", "anim/lavaarena_staff_smoke_fx.zip"),
}

local prefabs =
{
    "tz_laserscorch",
    "tz_lasertrail",
    "tz_laserhit",
}

local LAUNCH_SPEED = .2
local RADIUS = .7

local function SetLightRadius(inst, radius)
    inst.Light:SetRadius(radius)
end

local function DisableLight(inst)
    inst.Light:Enable(false)
end

local function DoDamage(inst, targets, skiptoss)
    inst.task = nil

    inst.AnimState:PlayAnimation("hit_"..tostring(math.random(5)))
    inst:Show()
    inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength() + 2 * FRAMES, inst.Remove)

    inst.Light:Enable(true)
    inst:DoTaskInTime(4 * FRAMES, SetLightRadius, .5)
    inst:DoTaskInTime(5 * FRAMES, DisableLight)

    local x, y, z = inst.Transform:GetWorldPosition()
    SpawnPrefab("tz_laserscorch").Transform:SetPosition(x, 0, z)
    local fx = SpawnPrefab("tz_lasertrail")
    fx.Transform:SetPosition(x, 0, z)
    fx:FastForward(GetRandomMinMax(.3, .7))

    inst.components.combat.ignorehitrange = true
    for i, v in ipairs(TheSim:FindEntities(x, 0, z, RADIUS + 3, nil, { "playerghost", "INLIMBO", "player","companion" , "INLIMBO" }, { "_combat", })) do
        if not targets[v] and v:IsValid() and not v:IsInLimbo() and not (v.components.health ~= nil and v.components.health:IsDead()) then
            local vradius = v:GetPhysicsRadius(.5)
            local range = RADIUS + vradius
            if v:GetDistanceSqToPoint(x, y, z) < range * range then
                local isworkable = false
                if inst.components.combat:CanTarget(v) then
                    targets[v] = true
                    inst.components.combat:DoAttack(v)
                    if v:IsValid() then
                        SpawnPrefab("tz_laserhit"):SetTarget(v)
                    end
                end
            end
        end
    end
    inst.components.combat.ignorehitrange = false
    for i, v in ipairs(TheSim:FindEntities(x, 0, z, RADIUS + 3, { "_inventoryitem" }, { "locomotor", "INLIMBO" })) do
        if not skiptoss[v] then
            local range = RADIUS + v.Physics:GetRadius(.5)
            if v:GetDistanceSqToPoint(x, y, z) < range * range then
                if not v.components.inventoryitem.nobounce and v.Physics ~= nil and v.Physics:IsActive() then
                    targets[v] = true
                    skiptoss[v] = true
                    Launch(v, inst, LAUNCH_SPEED)
                end
            end
        end
    end
end

local function Trigger(inst, delay, targets, skiptoss)
    if inst.task ~= nil then
        inst.task:Cancel()
        if (delay or 0) > 0 then
            inst.task = inst:DoTaskInTime(delay, DoDamage, targets or {}, skiptoss or {})
        else
            DoDamage(inst, targets or {}, skiptoss or {})
        end
    end
end

local function KeepTargetFn()
    return false
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("deerclops_laser_hits_sparks")
    inst.AnimState:SetBuild("deerclops_laser_hit_sparks_fx")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetLightOverride(1)
	inst.AnimState:SetMultColour(0,0,0,1)
    inst.entity:AddLight()
    inst.Light:SetIntensity(.6)
    inst.Light:SetRadius(1)
    inst.Light:SetFalloff(.7)
    inst.Light:SetColour(1, .2, .3)
    inst.Light:Enable(false)

    inst:Hide()

    inst:AddTag("notarget")
    inst:AddTag("hostile")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(50)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)

    inst.task = inst:DoTaskInTime(0, inst.Remove)
    inst.Trigger = Trigger
    inst.persists = false

    return inst
end

local SCORCH_RED_FRAMES = 20
local SCORCH_DELAY_FRAMES = 40
local SCORCH_FADE_FRAMES = 15

local function Scorch_OnFadeDirty(inst)
    if inst._fade:value() > SCORCH_FADE_FRAMES + SCORCH_DELAY_FRAMES then
        local k = (inst._fade:value() - SCORCH_FADE_FRAMES - SCORCH_DELAY_FRAMES) / SCORCH_RED_FRAMES
        inst.AnimState:OverrideMultColour(0, 0, 0, 1)
        --inst.AnimState:SetHighlightColour(k, 0, 0, 0)
		inst.AnimState:SetHighlightColour(0, 0, 0, 1)
    elseif inst._fade:value() >= SCORCH_FADE_FRAMES then
        inst.AnimState:OverrideMultColour(0, 0, 0, 1)
        inst.AnimState:SetHighlightColour()
    else
        local k = inst._fade:value() / SCORCH_FADE_FRAMES
        k = k * k
        --inst.AnimState:OverrideMultColour(k, k, k, k)
		inst.AnimState:OverrideMultColour(0, 0, 0, k)
        inst.AnimState:SetHighlightColour()
    end
end

local function Scorch_OnUpdateFade(inst)
    if inst._fade:value() > 1 then
        inst._fade:set_local(inst._fade:value() - 1)
        Scorch_OnFadeDirty(inst)
    elseif TheWorld.ismastersim then
        inst:Remove()
    elseif inst._fade:value() > 0 then
        inst._fade:set_local(0)
        inst.AnimState:OverrideMultColour(0, 0, 0, 0)
    end
end

local function scorchfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBuild("burntground")
    inst.AnimState:SetBank("burntground")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
	inst.AnimState:SetMultColour(0,0,0,1)

    inst:AddTag("NOCLICK")
    inst:AddTag("FX")

    inst._fade = net_byte(inst.GUID, "tz_laserscorch._fade", "fadedirty")
    inst._fade:set(SCORCH_RED_FRAMES + SCORCH_DELAY_FRAMES + SCORCH_FADE_FRAMES)

    inst:DoPeriodicTask(0, Scorch_OnUpdateFade)
    Scorch_OnFadeDirty(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst:ListenForEvent("fadedirty", Scorch_OnFadeDirty)

        return inst
    end

    inst.Transform:SetRotation(math.random() * 360)
    inst.persists = false

    return inst
end

local function FastForwardTrail(inst, pct)
    if inst._task ~= nil then
        inst._task:Cancel()
    end
    local len = inst.AnimState:GetCurrentAnimationLength()
    pct = math.clamp(pct, 0, 1)
    inst.AnimState:SetTime(len * pct)
    inst._task = inst:DoTaskInTime(len * (1 - pct) + 2 * FRAMES, inst.Remove)
end

local function trailfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.AnimState:SetBank("lavaarena_staff_smoke_fx")
    inst.AnimState:SetBuild("lavaarena_staff_smoke_fx")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetAddColour(0, 0, 0, 1)
    inst.AnimState:SetMultColour(0, 0, 0, 1)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false
    inst._task = inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength() + 2 * FRAMES, inst.Remove)

    inst.FastForward = FastForwardTrail

    return inst
end

local function OnRemoveHit(inst)
    if inst.target ~= nil and inst.target:IsValid() then
        if inst.target.components.colouradder == nil then
            --if inst.target.components.freezable ~= nil then
            --    inst.target.components.freezable:UpdateTint()
            --else
            --    inst.target.AnimState:SetAddColour(0, 0, 0, 0)
            --end
        end
        if inst.target.components.bloomer == nil then
            inst.target.AnimState:ClearBloomEffectHandle()
        end
    end
end

local function UpdateHit(inst, target)
    if target:IsValid() then
        local oldflash = inst.flash
        inst.flash = math.max(0, inst.flash - .075)
        if inst.flash > 0 then
            local c = math.min(1, inst.flash)
            --if target.components.colouradder ~= nil then
            --    target.components.colouradder:PushColour(inst, c, 0, 0, 0)
            --else
            --    target.AnimState:SetAddColour(c, 0, 0, 0)
            --end
            if inst.flash < .3 and oldflash >= .3 then
                if target.components.bloomer ~= nil then
                    target.components.bloomer:PopBloom(inst)
                else
                    target.AnimState:ClearBloomEffectHandle()
                end
            end
            return
        end
    end
    inst:Remove()
end

local function SetTarget(inst, target)
    if inst.inittask ~= nil then
        inst.inittask:Cancel()
        inst.inittask = nil

        inst.target = target
        inst.OnRemoveEntity = OnRemoveHit

        if target.components.bloomer ~= nil then
            target.components.bloomer:PushBloom(inst, "shaders/anim.ksh", -1)
        else
            target.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        end
        inst.flash = .8 + math.random() * .4
        inst:DoPeriodicTask(0, UpdateHit, nil, target)
        UpdateHit(inst, target)
    end
end

local function hitfn()
    local inst = CreateEntity()

    inst:AddTag("CLASSIFIED")
    inst.persists = false

    inst.SetTarget = SetTarget
    inst.inittask = inst:DoTaskInTime(0, inst.Remove)

    return inst
end

return Prefab("tz_laser", fn, assets, prefabs),
    Prefab("tz_laserscorch", scorchfn, assets_scorch),
    Prefab("tz_lasertrail", trailfn, assets_trail),
    Prefab("tz_laserhit", hitfn)
