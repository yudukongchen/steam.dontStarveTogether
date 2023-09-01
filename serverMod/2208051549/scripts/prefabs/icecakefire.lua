local assets =
{
    Asset("ANIM", "anim/coldfire.zip"),
    Asset("ANIM", "anim/campfire_fire.zip")
}

local prefabs =
{
    "firefx_light",
}


local lightColour = { 0, 183 / 255, 1 }


local firelevels =
{
    { anim = "level2", nil, radius = 0, intensity = 0, falloff = 0, colour = lightColour, nil }, --掐掉光明
}

local firelevels_change =
{
    {anim="level2", sound="dontstarve/common/forestfire", radius=6, intensity=.9, falloff=.2, colour = {255/255,190/255,121/255}, soundintensity=0.3},
}

local heats = { 220 }

local function GetHeatFn(inst)
    return heats[inst.components.firefx.level] or 20
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
    inst.AnimState:PlayAnimation("level2")
    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetFinalOffset(-1)

    inst:AddTag("FX")
    inst:AddTag("icecakefire")

    --HASHEATER (from heater component) added to pristine state for optimization

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("firefx")  
    inst.components.firefx.levels = firelevels
    inst.components.firefx:SetLevel(2, true)
    inst.components.firefx.usedayparamforsound = false

    return inst
end

local function fn_change()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetBank("campfire_fire")
    inst.AnimState:SetBuild("campfire_fire")
    inst.AnimState:PlayAnimation("level2")
    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetFinalOffset(-1)

    inst:AddTag("FX")
    inst:AddTag("icecakefire_change")

    inst:AddTag("HASHEATER")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("firefx")  
    inst.components.firefx.levels = firelevels_change
    inst.components.firefx:SetLevel(2, true)

    inst:AddComponent("heater")   --火的温度和点燃是分开的，温度高而没有火的标签似乎不能点燃东西。
    inst.components.heater.heatfn = GetHeatFn

    return inst
end

return Prefab("icecakefire", fn, assets, prefabs),
       Prefab("icecakefire_change", fn_change, assets, prefabs)