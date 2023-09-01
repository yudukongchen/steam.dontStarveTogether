local assets =
{
    Asset("ANIM", "anim/yidalimian.zip"),
    Asset("ATLAS", "images/yidalimian.xml"),
    Asset("IMAGE", "images/yidalimian.tex"),
}

local function OnEat(inst, eater)
    if eater:HasTag("player") and eater.components.timer:TimerExists("yidalimian_timer") then
        eater.components.timer:SetTimeLeft("yidalimian_timer", 300)
    elseif eater:HasTag("player") then
        eater.components.timer:StartTimer("yidalimian_timer", 300)
        eater.components.locomotor:SetExternalSpeedMultiplier(eater, "yidalimian", 1.05)
        if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
            not (eater.components.health ~= nil and eater.components.health:IsDead()) and
            not eater:HasTag("playerghost") then
            eater.components.debuffable:AddDebuff("buff_workeffectiveness", "buff_workeffectiveness")
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    -- inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("yidalimian")
    inst.AnimState:SetBuild("yidalimian")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.GOODIES
    inst.components.edible.hungervalue = 100
    inst.components.edible.sanityvalue = 35
    inst.components.edible.healthvalue = 70
    inst.components.edible:SetOnEatenFn(OnEat)

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED) -- 10天
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/yidalimian.xml"
    inst.components.inventoryitem.imagename = "yidalimian"

    return inst
end

return Prefab("yidalimian", fn, assets)