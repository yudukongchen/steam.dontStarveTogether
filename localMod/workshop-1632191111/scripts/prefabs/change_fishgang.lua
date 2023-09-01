require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/change_fishgang.zip"),
    Asset("ANIM", "anim/ui_chest_3x3.zip"),
	
	Asset( "IMAGE", "images/inventoryimages/change_fishgang.tex" ),
	Asset( "ATLAS", "images/inventoryimages/change_fishgang.xml" ),
}

local prefabs =
{
    "collapse_small",
}

local containers = require("containers")
local widgetsetup_old = containers.widgetsetup

local change_fishgang =
{
    widget =
    {
        slotpos =
        {
            Vector3(0,0,0), 
        },
        animbank = "ui_bundle_2x2",
        animbuild = "ui_bundle_2x2",
        pos = Vector3(200, 0, 0),
        side_align_tip = 120,
    },
    type = "cooker",
}

function change_fishgang.itemtestfn(container, item, slot)
    if item:HasTag("icebox_valid") then
        return true
    end
	
	if not string.find(item.prefab,"fish") or string.find(item.prefab,"cooked") then 
		return false
	end 

    --Perishable
    if not (item:HasTag("fresh") or item:HasTag("stale") or item:HasTag("spoiled")) then
        return false
    end

    --Edible
    for k, v in pairs(FOODTYPE) do
        if item:HasTag("edible_"..v) then
            return true
        end
    end

    return false
end


function containers.widgetsetup(container, prefab, data, ...)
	if container.inst.prefab == "change_fishgang" or prefab == "change_fishgang" then
		for k, v in pairs(change_fishgang) do
            container[k] = v
        end
        container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
        return
	end
    return widgetsetup_old(container, prefab, data, ...)
end

local function onopen(inst)
    --inst.AnimState:PlayAnimation("open")
    inst.SoundEmitter:PlaySound("dontstarve/common/icebox_open")
end

local function onclose(inst)
    --inst.AnimState:PlayAnimation("close")
    inst.SoundEmitter:PlaySound("dontstarve/common/icebox_close")
end

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    inst.components.container:DropEverything()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end

local function onhit(inst, worker)
    --inst.AnimState:PlayAnimation("hit")
    inst.components.container:DropEverything()
    --inst.AnimState:PushAnimation("closed", false)
    inst.components.container:Close()
end

local function onbuilt(inst)
    --inst.AnimState:PlayAnimation("place")
    --inst.AnimState:PushAnimation("closed", false)
    inst.SoundEmitter:PlaySound("dontstarve/common/icebox_craft")
end

local function FreshFish(inst)
	for k,v in pairs(inst.components.container.slots) do 
		if v and v:IsValid() and v.components.perishable then 
			v.components.perishable:ReducePercent(-0.1)
		end
	end
end 

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("icebox.png")

    inst:AddTag("fridge")
    inst:AddTag("structure")

    inst.AnimState:SetBank("change_fishgang")
    inst.AnimState:SetBuild("change_fishgang")
    inst.AnimState:PlayAnimation("idle")

    inst.SoundEmitter:PlaySound("dontstarve/common/ice_box_LP", "idlesound")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("change_fishgang",change_fishgang)
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(2)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit) 

    inst:ListenForEvent("onbuilt", onbuilt)
	inst:DoPeriodicTask(1,FreshFish)
    MakeSnowCovered(inst)

    AddHauntableDropItemOrWork(inst)

    return inst
end

return Prefab("change_fishgang", fn, assets, prefabs),
    MakePlacer("change_fishgang_placer", "change_fishgang", "change_fishgang", "idle")
