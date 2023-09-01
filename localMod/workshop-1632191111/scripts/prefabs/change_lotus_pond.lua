local assets =
{
    Asset("ANIM", "anim/marsh_tile.zip"),
    Asset("ANIM", "anim/splash.zip"),
	Asset("ANIM", "anim/lotus.zip"),
}

local prefabs =
{
    "marsh_plant",
    "fish",
    "frog",
    "mosquito",
}

local SCALE = 1.2

local function SpawnPlants(inst)
    inst.task = nil

    if inst.plant_ents ~= nil then
        return
    end

    if inst.plants == nil then
        inst.plants = {}
        for i = 1, math.random(2, 4) do
            local theta = math.random() * 2 * PI
            table.insert(inst.plants,
            {
                offset =
                {
                    math.sin(theta) * 2.3 + math.random() * .35,
                    0,
                    math.cos(theta) * 2.5 + math.random() * .35,
                },
            })
        end
    end

    inst.plant_ents = {}

    for i, v in pairs(inst.plants) do
        if type(v.offset) == "table" and #v.offset == 3 then
            local plant = SpawnPrefab(inst.planttype)
            if plant ~= nil then
                plant.entity:SetParent(inst.entity)
                plant.Transform:SetPosition(unpack(v.offset))
                plant.persists = false
                table.insert(inst.plant_ents, plant)
            end
        end
    end
end

local function SpawnLotus(inst)
	if inst.Lotus and inst.Lotus:IsValid() then 
		return 
	end
	local offset = Vector3(0.3*(1 - 2*math.random()),0,0.3*(1 - 2*math.random()))
	local lotus = inst:SpawnChild("change_lotus")
	lotus.Transform:SetPosition(offset:Get())
	lotus.components.pickable:MakeEmpty()
	
	inst.Lotus = lotus
end 

local function OnDestroy(inst)
	if inst.Lotus and inst.Lotus:IsValid() then 
		inst.Lotus:Remove()
	end
	
	inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_big")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end 

local function OnSave(inst, data)
    data.plants = inst.plants
	if inst.Lotus and inst.Lotus:IsValid() then 
		data.Lotus = inst.Lotus:GetSaveRecord()
		data.LotusId = inst.Lotus.GUID
	end 
end

local function OnLoad(inst, data)
    if data ~= nil and data.plants ~= nil and inst.plants == nil and inst.task ~= nil then
        inst.plants = data.plants
    end
	if data and data.Lotus and data.LotusId then 
		local lotus = SpawnSaveRecord(data.Lotus, {data.LotusId})
        if lotus ~= nil then
            --self:TakeOwnership(child)
            --self:GoHome(child)
			inst:AddChild(lotus)
			local offset = Vector3(0.3*(1 - 2*math.random()),0,0.3*(1 - 2*math.random()))
			lotus.Transform:SetPosition(offset:Get())
			inst.Lotus = lotus
			print(inst,"LOAD SUCCESS: Has Saved Lotus,we can spawn right lotus!!!!")
		else
			SpawnLotus(inst)
			print(inst,"ERROR: No Saved Lotus,we must spawn new lotus!!!!")
        end
	end
end

local function commonfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 0.05)

    inst.AnimState:SetBuild("marsh_tile")
    inst.AnimState:SetBank("marsh_tile")
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
	
	inst.Transform:SetScale(SCALE,SCALE,SCALE)

    inst.MiniMapEntity:SetIcon("pond.png")

    inst:AddTag("watersource")
    inst:AddTag("antlion_sinkhole_blocker")
    inst:AddTag("birdblocker")

    inst.no_wet_prefix = true

    inst:SetDeployExtraSpacing(2)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.pondtype = ""
    inst.planttype = "marsh_plant"
	inst.Lotus = nil
	
    inst.frozen = nil
    inst.plants = nil
    inst.plant_ents = nil

    inst:AddComponent("inspectable")
    inst.components.inspectable.nameoverride = "pond"

    inst:AddComponent("fishable")
    inst.components.fishable:SetRespawnTime(TUNING.FISH_RESPAWN_TIME)
	inst.components.fishable:AddFish("eel")

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(OnDestroy)
    --inst.components.workable:SetOnWorkCallback(onhit)
	
    inst.task = inst:DoTaskInTime(0, SpawnPlants)
	
	
	inst:DoTaskInTime(0.1,SpawnLotus)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return Prefab("change_lotus_pond", commonfn, assets, prefabs),
MakePlacer("change_lotus_pond_placer", "marsh_tile", "marsh_tile", "idle",true,nil,nil,SCALE,90,nil,nil,function(inst) 
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
end)
