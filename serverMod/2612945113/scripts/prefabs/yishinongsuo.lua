local assets =
{
    Asset("ANIM", "anim/yishinongsuo.zip"),
    Asset("ATLAS", "images/yishinongsuo.xml"),
    Asset("IMAGE", "images/yishinongsuo.tex"),
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

    inst.AnimState:SetBank("yishinongsuo")
    inst.AnimState:SetBuild("yishinongsuo")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.GOODIES
    inst.components.edible.hungervalue = 15
    inst.components.edible.sanityvalue = 15
    inst.components.edible.healthvalue = 20
    inst.components.edible:SetOnEatenFn(OnEat)

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED) -- 10天
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/yishinongsuo.xml"
    inst.components.inventoryitem.imagename = "yishinongsuo"

    return inst
end

return Prefab("yishinongsuo", fn, assets)