local assets =
{
    Asset("ANIM", "anim/pangballoons_empty.zip"),
    Asset("SOUND", "sound/pengull.fsb"),
	Asset( "IMAGE", "images/inventoryimages/pangballoons_empty.tex" ),
	Asset( "ATLAS", "images/inventoryimages/pangballoons_empty.xml" ),
}

local prefabs =
{
    "pangbaixiong",
    --"mosquitosack",
    --"waterballoon_splash",
}

local function dodecay(inst)  --腐烂
    if inst.components.lootdropper == nil then
        inst:AddComponent("lootdropper")
    end
    inst.components.lootdropper:SpawnLootPrefab("mosquitosack") --蚊子血袋
    inst.components.lootdropper:SpawnLootPrefab("mosquitosack")
    SpawnPrefab("small_puff").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end

local function startdecay(inst)  --开始腐烂
    if inst._decaytask == nil then
        inst._decaytask = inst:DoTaskInTime(TUNING.BALLOON_PILE_DECAY_TIME, dodecay)
        inst._decaystart = GetTime()
    end
end

local function stopdecay(inst)  --停止腐烂
    if inst._decaytask ~= nil then
        inst._decaytask:Cancel()
        inst._decaytask = nil
        inst._decaystart = nil
    end
end

local function onsave(inst, data)  --save
    if inst._decaystart ~= nil then
        local time = GetTime() - inst._decaystart
        if time > 0 then
            data.decaytime = time
        end
    end
end    

local function onload(inst, data)  --load
    if inst._decaytask ~= nil and data ~= nil and data.decaytime ~= nil then
        local remaining = math.max(0, TUNING.BALLOON_PILE_DECAY_TIME - data.decaytime)
        inst._decaytask:Cancel()
        inst._decaytask = inst:DoTaskInTime(remaining, dodecay)
        inst._decaystart = GetTime() + remaining - TUNING.BALLOON_PILE_DECAY_TIME
    end
end

local function onbuilt(inst, builder)
    SpawnPrefab("waterballoon_splash").Transform:SetPosition(inst.Transform:GetWorldPosition())--稚嫩真？
    if builder.components.moisture ~= nil then
        builder.components.moisture:DoDelta(20)
    end
end

local function OnHaunt(inst)
    if inst.components.balloonmaker ~= nil and math.random() <= TUNING.HAUNT_CHANCE_OFTEN then
        inst.components.balloonmaker:MakeBalloon(inst.Transform:GetWorldPosition())
        return true
    end
    return false
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst:AddTag("cattoy")

    inst.AnimState:SetBank("pangballoons_empty")
    inst.AnimState:SetBuild("pangballoons_empty")
    inst.AnimState:PlayAnimation("idle")
    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1})
    --inst.MiniMapEntity:SetIcon("balloons_empty.png")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    --inst._decaytask = nil
    --inst._decaystart = nil

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/pangballoons_empty.xml"
    -----------------------------------

    inst:AddComponent("inspectable")

    inst:AddComponent("qiqiuballoonmaker")
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(5)
    inst.components.finiteuses:SetUses(5)

    inst.components.finiteuses:SetOnFinished(inst.Remove)
    --inst:AddComponent("hauntable")
    --inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    --inst.components.hauntable:SetOnHauntFn(OnHaunt)

    --startdecay(inst)

    --inst:ListenForEvent("onputininventory", stopdecay)
    --inst:ListenForEvent("ondropped", startdecay)

    --inst.OnBuiltFn = onbuilt
    --inst.OnLoad = onload
    --inst.OnSave = onsave

    return inst
end

return Prefab("pangballoons_empty", fn, assets, prefabs)
