local assets =
{
    Asset("ANIM", "anim/shuangbeiyishi.zip"),
    Asset("ATLAS", "images/shuangbeiyishi.xml"),
    Asset("IMAGE", "images/shuangbeiyishi.tex"),
}

local function OnEat(inst, eater)
    if eater:HasTag("player") and eater.components.timer:TimerExists("shuangbeiyishi_timer") then
        eater.components.timer:SetTimeLeft("shuangbeiyishi_timer", 100)
    elseif eater:HasTag("player") then
        eater.components.timer:StartTimer("shuangbeiyishi_timer", 100)
        eater.components.locomotor:SetExternalSpeedMultiplier(eater, "shuangbeiyishi", 1.15)
        if eater.components.combat ~= nil then
            eater.components.combat.externaldamagemultipliers:SetModifier("shuangbeiyishi", 1.2)
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

    inst.AnimState:SetBank("shuangbeiyishi")
    inst.AnimState:SetBuild("shuangbeiyishi")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.GOODIES
    inst.components.edible.hungervalue = 20
    inst.components.edible.sanityvalue = -10
    inst.components.edible.healthvalue = 30
    inst.components.edible:SetOnEatenFn(OnEat)

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED) -- 10天
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/shuangbeiyishi.xml"
    inst.components.inventoryitem.imagename = "shuangbeiyishi"

    return inst
end

return Prefab("shuangbeiyishi", fn, assets)