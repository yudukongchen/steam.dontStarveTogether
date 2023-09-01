local assets =
{
    Asset("ANIM", "anim/coldfire.zip"),
    Asset("SOUND", "sound/common.fsb"),
}

local prefabs =
{
    "firefx_light",
}

local heats = { -40 }
local lightColour = { 0, 183 / 255, 1 }

local function GetHeatFn(inst)
    return heats[inst.components.firefx.level] or -20
end

local firelevels =
{
    { anim = "level4", sound = "dontstarve_DLC001/common/coldfire", radius = 5, intensity = .8, falloff = .33, colour = lightColour, soundintensity = 1 },
}

local function OnAnimOver(inst)
    if inst and inst.time <4 then
        inst.AnimState:PlayAnimation("level4")
    elseif inst and inst.time <6 then
        inst.AnimState:PlayAnimation("level4")
    elseif inst.time<8 then
        inst.AnimState:PlayAnimation("level3")
    else
        inst:Remove()
    end
    inst.time = inst.time+1  --很蠢的哦。
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetBank("coldfire_fire")
    inst.AnimState:SetBuild("coldfire_fire")
    inst.AnimState:PlayAnimation("level4")
    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetFinalOffset(-1)

    inst:AddTag("FX")
    inst:AddTag("transmitfire")

    --HASHEATER (from heater component) added to pristine state for optimization
    inst:AddTag("HASHEATER")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("firefx")  
    inst.components.firefx.levels = firelevels
    inst.components.firefx:SetLevel(4, true)
    inst.components.firefx.usedayparamforsound = true

    inst:AddComponent("heater")   
    inst.components.heater.heatfn = GetHeatFn
    inst.components.heater:SetThermics(false, true)

    inst.time = 0

    inst:ListenForEvent("animover", OnAnimOver)

    return inst
end

return Prefab("transmitbluefire", fn, assets, prefabs)