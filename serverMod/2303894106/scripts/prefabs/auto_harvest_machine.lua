require "prefabutil"
require("prefabs/veggies")
local WEED_DEFS = require("prefabs/weed_defs").WEED_DEFS

local assets = {
    Asset("ANIM", "anim/auto_harvest_machine.zip"),
    Asset("IMAGE", "images/inventoryimages/auto_harvest_machine.tex"),
    Asset("ATLAS", "images/inventoryimages/auto_harvest_machine.xml"),
}

local prefabs = {
    "fx_harvest",
    "fx_trans"
}

local WIDTH = 2.2
local LENGTH = 12
if TUNING.IS_NEW_AGRICULTURE then
    LENGTH = 10
end

local function PickUpItem(inst, items)
    if items and type(items) == "table" and #items > 0 then
        inst:DoTaskInTime(1.5, function ()      --修复合并物品mod导致的无法获取到作物, 等待物品合并完毕再移动
            for _, v in ipairs(items) do
				local is_weed = false
				for weed, data in pairs(WEED_DEFS) do
					if data.product == v.prefab then
						is_weed = true
						break
					end
				end
                if not v:IsInLimbo() and v:IsValid() and (is_weed
                or (VEGGIES[v.prefab] or TUNING.EA_LEGION_ITEM[v.prefab] or (v:HasTag("deployedplant") and v:HasTag("cookable") and v.prefab~="acorn"))) then
                    SpawnAt("fx_trans", v:GetPosition())
                    inst.components.container:GiveItem(v)
                end
            end

            inst.AnimState:PlayAnimation("trans", true)
            inst:DoTaskInTime(1, function()
                inst.AnimState:PlayAnimation("idle",true)
            end)
        end)
    end
end

local function HarvestCrop(inst, target)
    if target and target.components.crop or target.components.pickable then
        if target:HasTag("readyforharvest") or (target.components.pickable and target.components.pickable.canbepicked) then
            local x,y,z = target.Transform:GetWorldPosition()
            if target.components.crop then      --旧农场
                target.components.crop:Harvest()
            elseif target.components.pickable and target.components.lootdropper then      --新农场
                target.components.pickable:Pick(inst)
                --如果是巨大蔬菜，锤它
                for k, v in ipairs(TheSim:FindEntities(x, 0, z, 1.2)) do
                    if v.components.workable and v.components.equippable and v.components.lootdropper then
                        v.components.lootdropper:DropLoot()
                        v:Remove()
                    end
                end
            end
        end
    end

    --如果是巨大蔬菜，锤它
    if target and target.components.workable and target.components.equippable and target.components.lootdropper then
        target.components.lootdropper:DropLoot()
        target:Remove()
    end
end

local function CheckForFarm(inst)
    if not inst:HasTag("burnt") then
        local x, y, z = inst.Transform:GetWorldPosition()
        local willharvest = false
        local find_items = {}
        for k, v in ipairs(TheSim:FindEntities(x, 0, z, LENGTH, nil, {"INLIMBO"})) do
            local pos = v:GetPosition()
            if x < pos.x and pos.x <= x+LENGTH and z-WIDTH/2 <= pos.z and pos.z <= z+WIDTH/2 then
                --成熟作物
                if v:HasTag("readyforharvest") or (v.components.pickable and v.components.pickable.canbepicked) then
                    willharvest = true
                    inst:DoTaskInTime(FRAMES * 5, function()
                        HarvestCrop(inst, v)  --收获作物
                    end)
                end
                --巨大作物
                if v.components.workable and v.components.equippable and v.components.lootdropper then
                    willharvest = true
                    inst:DoTaskInTime(FRAMES * 5, function()
                        HarvestCrop(inst, v)    --收获作物
                    end)
                end
                --直接捡起蔬菜和种子
                if VEGGIES[v.prefab] or TUNING.EA_LEGION_ITEM[v.prefab]
                or (v:HasTag("deployedplant") and v:HasTag("cookable") and v.prefab~="acorn") then
                    willharvest = true
                    table.insert(find_items, v)
                end
				--捡起杂草
				for weed, data in pairs(WEED_DEFS) do
					if data.product == v.prefab then
						willharvest = true
						table.insert(find_items, v)
						break
					end
				end
            end
        end

        PickUpItem(inst, find_items)

        if willharvest then
            local fx = SpawnPrefab("fx_harvest")
            fx.Transform:SetPosition(x+0.4,y,z)
            inst.AnimState:PlayAnimation("hit")
            inst.AnimState:PushAnimation("idle",true)
        end
    end
end

---------------------------------

local function onburnt(inst)
    DefaultBurntStructureFn(inst)
end

local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    if not inst:HasTag("burnt") then
        inst.components.container:DropEverything()
    end
    inst.SoundEmitter:KillSound("firesuppressor_idle")
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle",true)
        inst.components.container:Close()
    end
end

local function onsave(inst, data)
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end
end

local function onload(inst, data)
    if data ~= nil then
        if data.burnt and inst.components.burnable ~= nil and inst.components.burnable.onburnt ~= nil then
            inst.components.burnable.onburnt(inst)
        end
    end
end

local function onbuilt(inst)
    --inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/firesupressor_craft")
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle", true)
    inst.SoundEmitter:PlaySound("dontstarve/common/icebox_craft")
end
---------------------------------


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()
    inst.entity:AddLightWatcher()

    inst.Transform:SetEightFaced()

    MakeObstaclePhysics(inst, .5)

    inst.MiniMapEntity:SetIcon("auto_harvest_machine_mini.tex")  --小地图图标

    inst.AnimState:SetBank("auto_harvest_machine")
    inst.AnimState:SetBuild("auto_harvest_machine")
    inst.AnimState:PlayAnimation("idle",true)

    inst:AddTag("fridge")   --冰箱保鲜功能
    inst:AddTag("structure")

    --MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    ----------------------------------------

    inst:AddComponent("container")
    inst.components.container:WidgetSetup( "auto_harvest_machine")
    inst.components.container.onopenfn = function ()
        inst.AnimState:PlayAnimation("trans",true)
    end
    inst.components.container.onclosefn = function ()
        inst.AnimState:PlayAnimation("idle",true)
    end
    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true

    ----------------------------------------
    inst:DoPeriodicTask(2, CheckForFarm)


    MakeMediumBurnable(inst, nil, nil, true)
    MakeMediumPropagator(inst)
    inst.components.burnable:SetOnBurntFn(onburnt)
    --MakeSnowCovered(inst)

    inst:ListenForEvent("onbuilt", onbuilt)

    inst.OnSave = onsave
    inst.OnLoad = onload

    return inst
end

return Prefab("auto_harvest_machine", fn, assets, prefabs),
    MakePlacer("auto_harvest_machine_placer", "auto_harvest_machine", "auto_harvest_machine", "idle", nil, nil, nil, nil, nil, "eight")