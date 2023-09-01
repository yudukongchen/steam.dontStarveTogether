local assets =
{
    Asset("ANIM", "anim/maqiyaduo.zip"),
    Asset("ATLAS", "images/maqiyaduo.xml"),
    Asset("IMAGE", "images/maqiyaduo.tex"),
}

local function OnEat(inst, eater)
    if eater:HasTag("player") and eater.components.timer:TimerExists("maqiyaduo_timer") then
        eater.components.timer:SetTimeLeft("maqiyaduo_timer", 100)
    elseif eater:HasTag("player") then
        eater.components.timer:StartTimer("maqiyaduo_timer", 100)
        eater.components.locomotor:SetExternalSpeedMultiplier(eater, "maqiyaduo", 1.1)
    end
    if eater:HasTag("player") and eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() then
        eater.components.debuffable:AddDebuff("sweettea_buff", "sweettea_buff")
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    -- inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("maqiyaduo")
    inst.AnimState:SetBuild("maqiyaduo")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.GOODIES
    inst.components.edible.hungervalue = 20
    inst.components.edible.sanityvalue = 10
    inst.components.edible.healthvalue = 20
    inst.components.edible:SetOnEatenFn(OnEat)

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED) -- 10天
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/maqiyaduo.xml"
    inst.components.inventoryitem.imagename = "maqiyaduo"

    return inst
end

return Prefab("maqiyaduo", fn, assets)