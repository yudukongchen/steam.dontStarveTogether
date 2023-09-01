require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/tz_drogenbox.zip"),
    Asset("ANIM", "anim/ui_chest_3x3.zip"),
}

----------------------------------------------------------------------
local function onopen(inst)
	inst.AnimState:PlayAnimation("open_pre",true)
    inst.AnimState:PushAnimation("open_loop",false)
    inst.SoundEmitter:PlaySound("dontstarve/common/icebox_open")
end

local function onclose(inst)
	inst.AnimState:PlayAnimation("stand_loop")
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
    inst.AnimState:PlayAnimation("destroy")
    inst.components.container:DropEverything()
    inst.AnimState:PushAnimation("stand_loop", false)
    inst.components.container:Close()
end

local function onbuilt(inst)
    inst.AnimState:PushAnimation("stand_loop",false)
    inst.SoundEmitter:PlaySound("dontstarve/common/icebox_craft")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("tz_drogenbox.tex")

    inst:AddTag("structure")

    inst.AnimState:SetBank("tz_drogenbox")
    inst.AnimState:SetBuild("tz_drogenbox")
    inst.AnimState:PlayAnimation("stand_loop")
	
	inst.Transform:SetScale(1.35, 1.35, 1.35)

    inst.SoundEmitter:PlaySound("dontstarve/common/ice_box_LP", "idlesound")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

	if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst)
            inst.replica.container:WidgetSetup("icebox")
        end
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("icebox")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)--设置工作的动作
    inst.components.workable:SetWorkLeft(2)--能锤几次
    inst.components.workable:SetOnFinishCallback(onhammered)--锤烂了怎么样
    inst.components.workable:SetOnWorkCallback(onhit) --每被锤子锤一下

	inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(TUNING.TZ_CAT_BOX_BAOXIAN)
	
    inst:ListenForEvent("onbuilt", onbuilt)
    MakeSnowCovered(inst)

    AddHauntableDropItemOrWork(inst)

    return inst
end

local function placefn(inst)
	inst.Transform:SetScale(1.35, 1.35, 1.35)
end

return Prefab("tz_drogenbox", fn, assets, prefabs),
    MakePlacer("tz_drogenbox_placer", "tz_drogenbox", "tz_drogenbox", "stand_loop",nil,nil,nil,nil,nil,nil,placefn)
