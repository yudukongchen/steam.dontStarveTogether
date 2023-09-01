require "prefabutil"
require "tuning"

local assets =
{
	Asset("ANIM", "anim/superfarm_soil.zip"),
	Asset("ANIM", "anim/superfarm.zip"),
	Asset("ANIM", "anim/hydroponic_farm_decor.zip"),	
}

local prefabs =
{
    "plant_normal",
    "farmrock",
    "farmrocktall",
    "farmrockflat",
    "stick",
    "stickleft",
    "stickright",
    "burntstick",
    "burntstickleft",
    "burntstickright",
    "signleft",
    "signright",
    "fencepost",
    "fencepostright",
    "burntfencepost",
    "burntfencepostright",
    "collapse_small",
}
    
local function PlotAnimation(inst, data)
	local superfarm = GetClosestInstWithTag("superfarm", inst, 1.95)
	if not superfarm then
	if inst.components.grower ~= nil then
        inst.components.grower:Reset()
    end
	local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
	end
end

local function plot(level)

    return function(Sim)
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
		inst.entity:AddNetwork()
		inst.entity:SetPristine()
		MakeInventoryPhysics(inst)	
        if not TheWorld.ismastersim then
        return inst
        end
		
		inst:AddTag("farmplot_spot")
        inst.level = level
	
		inst.AnimState:SetBank("superfarm_soil")
		inst.AnimState:SetBuild("superfarm_soil")
		inst.AnimState:SetScale(TUNING.SOILSCALE,TUNING.SOILSCALE,TUNING.SOILSCALE)		
		if TheWorld.state.iswinter then
		inst.AnimState:PlayAnimation("full")
        else
		inst.AnimState:PlayAnimation("idle")
		end	
		
        inst:AddComponent("grower")
        inst.components.grower.level = level
        inst.components.grower.onplantfn = function() inst.SoundEmitter:PlaySound("dontstarve/wilson/plant_seeds") end
        inst.components.grower.croppoints = { Vector3(0,0,0) }
		inst.components.grower.growrate = 0.48
        inst.components.grower.cycles_left = 10
		
		inst:AddComponent("lootdropper") 
		inst:DoPeriodicTask(1, PlotAnimation)
		
        return inst
    end
end    

local function gardenrocks()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.persists = false	
    inst.AnimState:SetBank("farm_decor")
    inst.AnimState:SetBuild("farm_decor")
	inst.AnimState:PlayAnimation("2")
    return inst
end

local function onhammered(inst, worker)		
	if inst.components.lootdropper ~= nil then
        inst.components.lootdropper:DropLoot()
    end
	
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
	
	local x, y, z = inst.Transform:GetWorldPosition()
	for k, v in ipairs(TheSim:FindEntities(x, y, z, 3)) do
	if v:HasTag("farmplot_spot") then
	    if v.components.grower ~= nil then
        v.components.grower:Reset()
        end
	local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    v:Remove()
	end
	end
end

local function SetStones(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local num = 48
	local width = 4.6
	local height = 4.6
	local total_edge_length = width*2 + height*2
	local dist_per_item = total_edge_length/num
	local s = 0.85	
	for i = 1, num do
	   	local current_pos = i * dist_per_item		
	   	if current_pos < width then
			local rocks = SpawnPrefab("superfarm_rocks")
			rocks.entity:SetParent(inst.entity)
			rocks.Transform:SetPosition(-width/2.0+current_pos, 0, -height/2.0)
			local anim = rocks.entity:AddAnimState()
			anim:SetScale(s,s,s)
		else
			current_pos = current_pos - width
	   		if current_pos < height then
				local rocks = SpawnPrefab("superfarm_rocks")		
				rocks.entity:SetParent(inst.entity)
				rocks.Transform:SetPosition(width/2.0, 0,-height/2.0+current_pos)
				local anim = rocks.entity:AddAnimState()
			    anim:SetScale(s,s,s)
			else
				current_pos = current_pos - height			
			   	if current_pos < width then
					local rocks = SpawnPrefab("superfarm_rocks")			
					rocks.entity:SetParent(inst.entity)
					rocks.Transform:SetPosition(width/2.0-current_pos, 0, height/2.0)
					local anim = rocks.entity:AddAnimState()
			        anim:SetScale(s,s,s)
				else
					current_pos = current_pos - width
					local rocks = SpawnPrefab("superfarm_rocks")					
					rocks.entity:SetParent(inst.entity)
					rocks.Transform:SetPosition(-width/2.0, 0, height/2.0-current_pos)
					local anim = rocks.entity:AddAnimState()
			        anim:SetScale(s,s,s)
				end
			end
		end
	end
end

local function fillfarm(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local density = 1.35
		for k = -1, 1 do
		for i = -1, 1 do
		SpawnPrefab("farmplot_spot").Transform:SetPosition(x - i * density, 0, z - k * density)
	    end
		end		
end

local function OnBuilt(inst)
	inst:DoTaskInTime(0.1, fillfarm)
    inst.SoundEmitter:PlaySound("dontstarve/common/farm_improved_craft")
end

local function garden_fn(bank)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()	
	inst.entity:AddNetwork()
	inst.entity:SetPristine()
	MakeInventoryPhysics(inst)
	
	inst:AddTag("structure")
	inst:AddTag("superfarm")
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("superfarmmini.tex")
	
	local s=1.36
    inst.AnimState:SetScale(s,s,s)	
    inst.AnimState:SetBank("superfarm")
    inst.AnimState:SetBuild("superfarm")
	if TheWorld.state.iswinter then
	inst.AnimState:PlayAnimation("winter")
    else
    inst.AnimState:PlayAnimation("idle")
	end
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetSortOrder(3)
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)

	inst:ListenForEvent("onbuilt", OnBuilt)
	inst:DoTaskInTime(0, SetStones)
    inst:DoTaskInTime(20, fillfarm)
    return inst
end


return Prefab( "common/objects/farmplot_spot",  plot(3), assets, prefabs),
       Prefab("superfarm_rocks", gardenrocks, assets),
	   Prefab("superfarm", garden_fn, assets, prefabs),
	   MakePlacer("superfarm_placer", "superfarm", "superfarm", "idle", true, true, true, 1.2, nil, nil, nil)