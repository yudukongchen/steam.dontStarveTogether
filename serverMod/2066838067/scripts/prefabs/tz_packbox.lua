
local assets =
{
	Asset("ANIM", "anim/tz_packbox.zip"),
	Asset("ANIM", "anim/tz_packbox_full.zip"),
	Asset("ATLAS", "images/inventoryimages/tz_packbox.xml"),
	Asset("IMAGE", "images/inventoryimages/tz_packbox.tex"),
	Asset("ATLAS", "images/inventoryimages/tz_packbox_full.xml"),
	Asset("IMAGE", "images/inventoryimages/tz_packbox_full.tex"),
}
local function ondeploy(inst, pt, deployer)
	if inst.components.tzpacker then
		inst.components.tzpacker:Unpackbulid(pt)
		inst:Remove()
		if deployer and deployer.components.inventory then
		local tz_packbox =SpawnPrefab("tz_packbox")
        deployer.components.inventory:GiveItem(tz_packbox)
		end
	end
end	

local function get_name(inst)
	return #inst._name:value() > 0 and "Packaged "..inst._name:value() or STRINGS.TZDABAOWEIZHI
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	
    inst.AnimState:SetBank("tz_packbox")
    inst.AnimState:SetBuild("tz_packbox")
    inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("tz_packbox")
	
    inst.entity:SetPristine()

	if not TheWorld.ismastersim  then
		return inst
    end
	
    inst:AddComponent("inspectable")
    inst:AddComponent("tz_packbox")
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "tz_packbox"	
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_packbox.xml"
	
	MakeMediumBurnable(inst)
    MakeMediumPropagator(inst)
    return inst
end

local function fullfn()
	local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("tz_packbox_full")
    inst.AnimState:SetBuild("tz_packbox_full")
    inst.AnimState:PlayAnimation("idle")
	inst:AddTag("tz_packbox_full")	
	inst:AddTag("nonpackable")
	inst._name = net_string(inst.GUID, "packbox_full_name")
	inst.displaynamefn = get_name
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	inst:AddComponent("inspectable")

	inst:AddComponent("tzpacker")	
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_packbox_full.xml"

	MakeHauntableLaunchAndSmash(inst)

	
    return inst
end	
local function buildfullfn()
	local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("tz_packbox_full")
    inst.AnimState:SetBuild("tz_packbox_full")
    inst.AnimState:PlayAnimation("idle")
	inst:AddTag("tz_packbox_buildfull")	
	inst:AddTag("nonpackable")
	inst._name = net_string(inst.GUID, "packbox_buildfull_name")
	inst.displaynamefn = get_name
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	inst:AddComponent("inspectable")

	inst:AddComponent("tzpacker")	
	inst:AddComponent("deployable")
	inst.components.deployable.ondeploy = ondeploy
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "tz_packbox_full"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_packbox_full.xml"

	MakeHauntableLaunchAndSmash(inst)
	
    return inst
end	
	
return Prefab("tz_packbox", fn, assets),
	Prefab("tz_packbox_full", fullfn, assets),
	Prefab("tz_packbox_buildfull", buildfullfn, assets),
	MakePlacer("tz_packbox_buildfull_placer", "tz_packbox_full", "tz_packbox_full", "place")
