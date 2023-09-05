local assets =
{
    Asset("ANIM", "anim/eyao.zip"),
}

local function oneaten(inst, eater)
if eater.components.hunger then
	local heju = eater:DoPeriodicTask(1, function()  eater.components.hunger:DoDelta(.47) end)
	heju.limit = 426
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("eyao")
    inst.AnimState:SetBuild("eyao")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")
	
	inst:AddComponent("edible")
	inst.components.edible.healthvalue = 5
	inst.components.edible.hungervalue = 25
	inst.components.edible.sanityvalue = 5
    inst.components.edible:SetOnEatenFn(oneaten)

    inst:AddComponent("inventoryitem")
	 inst.components.inventoryitem.atlasname = "images/inventoryimages/eyao.xml"

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("eyao", fn, assets)

