
local function ondeploy(inst, pt, deployer)
	if deployer and deployer.SoundEmitter then
		deployer.SoundEmitter:PlaySound("dontstarve/wilson/dig")
	end

	local map = TheWorld.Map
	local original_tile_type = map:GetTileAtPoint(pt:Get())
	local x, y = map:GetTileCoordsAtPoint(pt:Get())
	if x and y then
		map:SetTile(x,y, inst.data.tile)
		map:RebuildLayer( original_tile_type, x, y )
		map:RebuildLayer( inst.data.tile, x, y )
	end

	local minimap = TheWorld.minimap.MiniMap
	minimap:RebuildLayer(original_tile_type, x, y)
	minimap:RebuildLayer(inst.data.tile, x, y)

	inst.components.stackable:Get():Remove()
end


local prefabs =
{
	"gridplacer",
}

local function make_turf(data)
	assert(type(data) == "table")
	assert(type(data.name) == "string")
	if data.anim == nil then
		data.anim = data.name
	end
	assert(type(data.anim) == "string")
	if data.invname == nil then
		data.invname = data.name
	end
	assert(type(data.invname) == "string")
	assert(data.tile ~= nil)
	local GROUND_lookup = table.invert(GROUND)
	assert(GROUND_lookup[data.tile] ~= nil)

	local assets = {
		Asset("ANIM", "anim/tzturfs.zip"),
		Asset("IMAGE", "images/inventoryimages/" .. data.name .. ".tex"),
		Asset("ATLAS", "images/inventoryimages/" .. data.name .. ".xml"),
	}

	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()
	
		MakeInventoryPhysics(inst)
	
		inst:AddTag("groundtile")

        inst.AnimState:SetBank("tzturfs")
        inst.AnimState:SetBuild("tzturfs")
        inst.AnimState:PlayAnimation(data.name)
	
		inst:AddTag("molebait")

		inst.entity:SetPristine()
	
		if not TheWorld.ismastersim then
			return inst
		end
	
		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

		inst:AddComponent("inspectable")
		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.imagename = data.name
		inst.components.inventoryitem.atlasname = "images/inventoryimages/"..data.name..".xml"

		inst.data = data
	
		inst:AddComponent("bait")

		inst:AddComponent("fuel")
		inst.components.fuel.fuelvalue = TUNING.MED_FUEL
		MakeMediumBurnable(inst, TUNING.MED_BURNTIME)
		MakeSmallPropagator(inst)
		MakeHauntableLaunchAndIgnite(inst)

		inst:AddComponent("deployable")
		inst.components.deployable.ondeploy = ondeploy
		inst.components.deployable:SetDeployMode(DEPLOYMODE.TURF)
		inst.components.deployable:SetUseGridPlacer(true)

		---------------------
		return inst
	end

	return Prefab("turf_" .. data.name, fn, assets, prefabs)
end

local turfs = {
	{name = "tzturfa",	tile = GROUND.TZTURFA},
}
local prefabs = {}
for k, v in ipairs(turfs) do
    table.insert(prefabs, make_turf(v))
end

return unpack(prefabs)
