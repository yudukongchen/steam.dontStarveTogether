local assets =
{
    Asset("ANIM", "anim/fire.zip"),
    Asset("SOUND", "sound/common.fsb"),
}

local prefabs =
{
    "firefx_light",
}

local heats = { 220 }

local function GetHeatFn(inst)
    return heats[inst.components.firefx.level] or 20
end

local firelevels =
{
    {anim="level4", sound="dontstarve/common/forestfire", radius=6, intensity=.9, falloff=.2, colour = {255/255,190/255,121/255}, soundintensity=1},
}

local function OnAnimOver(inst)
    if inst and inst.time <8 then
        inst.AnimState:PlayAnimation("level4")
    elseif inst and inst.time <10 then
        inst.AnimState:PlayAnimation("level4")
    elseif inst.time<13 then
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
    inst.AnimState:SetBank("fire")
    inst.AnimState:SetBuild("fire")
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

    inst:AddComponent("firefx")  --这个组件自动添加光亮，燃烧范围……（我懒得画特效了）。
    inst.components.firefx.levels = firelevels
   -- inst.SoundEmitter:PlayingSound("fire")
    inst.components.firefx:SetLevel(4, true)

    inst:AddComponent("heater")   --火的温度和点燃是分开的，温度高而没有火的标签似乎不能点燃东西。
    inst.components.heater.heatfn = GetHeatFn

    inst.time = 0

    inst:ListenForEvent("animover", OnAnimOver)

    return inst
end

return Prefab("transmitfire", fn, assets, prefabs)