
local function MakeCD(name, tag)
    local assets =
    {
		Asset("ANIM", "anim/tz_cd.zip"),
		Asset( "IMAGE", "images/inventoryimages/"..name..".tex" ),
		Asset( "ATLAS", "images/inventoryimages/"..name..".xml" ),	
    }
	local prefabs ={}

	local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("tz_cd")
    inst.AnimState:SetBuild("tz_cd")
    inst.AnimState:PlayAnimation(name)
    
	inst:AddTag("tz_cd")
    inst:AddTag(tag)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("tradable")

    --inst:AddComponent("stackable")
    --inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = name
    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"

    return inst
	end
    return Prefab(name, fn, assets, prefabs)
end
return	MakeCD("tz_cd1","tz_cd1"),
		MakeCD("tz_cd2","tz_cd2"),
		MakeCD("tz_cd3","tz_cd3")