local assets =
{
    Asset("ANIM", "anim/tz_doubles.zip"),
	Asset("ATLAS", "images/inventoryimages/tz_doubles.xml"),
	Asset("IMAGE", "images/inventoryimages/tz_doubles.tex"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBuild("tz_doubles")
    inst.AnimState:SetBank("tz_doubles")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)
    inst.entity:SetPristine()
    
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst:AddComponent("tz_doubles")
	
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_doubles.xml"
    
	MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)
    MakeHauntableLaunchAndIgnite(inst)  
	
	return inst
end

return Prefab("tz_doubles", fn, assets)
