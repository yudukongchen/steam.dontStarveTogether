local assets =
{
    Asset("ANIM", "anim/lanyao.zip"),
}

local function oneaten(inst, eater)
if eater.components.sanity then
	local heju = eater:DoPeriodicTask(3, function()  eater.components.sanity:DoDelta(5) end)
	heju.limit = 10
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("lanyao")
    inst.AnimState:SetBuild("lanyao")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")
	
	inst:AddComponent("edible")
	inst.components.edible.healthvalue = 0
	inst.components.edible.hungervalue = 5
	inst.components.edible.sanityvalue = 25
    inst.components.edible:SetOnEatenFn(oneaten)

    inst:AddComponent("inventoryitem")
	 inst.components.inventoryitem.atlasname = "images/inventoryimages/lanyao.xml"

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("lanyao", fn, assets)

