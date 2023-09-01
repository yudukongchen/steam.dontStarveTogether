local assets =
{
    Asset("ANIM", "anim/kangbaolan.zip"),
    Asset("ATLAS", "images/kangbaolan.xml"),
    Asset("IMAGE", "images/kangbaolan.tex"),
}

local function OnEat(inst, eater)
    if eater:HasTag("player") and eater.components.timer:TimerExists("yishinongsuo_timer") then
        eater.components.timer:SetTimeLeft("yishinongsuo_timer", 300)
    elseif eater:HasTag("player") then
        eater.components.timer:StartTimer("yishinongsuo_timer", 300)
        eater.components.locomotor:SetExternalSpeedMultiplier(eater, "yishinongsuo", 1.1)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    -- inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("kangbaolan")
    inst.AnimState:SetBuild("kangbaolan")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.GOODIES
    inst.components.edible.hungervalue = 20
    inst.components.edible.sanityvalue = 20
    inst.components.edible.healthvalue = 10
    inst.components.edible.temperaturedelta = TUNING.COLD_FOOD_BONUS_TEMP
    inst.components.edible.temperatureduration = TUNING.FOOD_TEMP_LONG
    inst.components.edible:SetOnEatenFn(OnEat)

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED) -- 10天
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/kangbaolan.xml"
    inst.components.inventoryitem.imagename = "kangbaolan"

    return inst
end

return Prefab("kangbaolan", fn, assets)