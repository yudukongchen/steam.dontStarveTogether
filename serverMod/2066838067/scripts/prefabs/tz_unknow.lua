
local function MakeUnknow(name)
    local assets =
    {
		Asset("ANIM", "anim/tz_unknow.zip"),
		Asset( "ATLAS", "images/inventoryimages/"..name..".xml" ),	
    }
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("tz_unknow")
    inst.AnimState:SetBuild("tz_unknow")
    inst.AnimState:PlayAnimation(name)


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
   
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"

    MakeHauntableLaunch(inst)
    return inst
end

return Prefab(name, fn, assets)
end
return	MakeUnknow("tz_unknowf"),
		MakeUnknow("tz_unknowk"),
		MakeUnknow("tz_unknowm"),
		MakeUnknow("tz_unknown")