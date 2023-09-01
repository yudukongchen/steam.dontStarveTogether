require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/tz_elong_box.zip"),
    Asset("ANIM", "anim/ui_chest_3x3.zip"),
}

local prefabs =
{
    "collapse_small",
}

local function onopen(inst)
    inst.AnimState:PlayAnimation("open_pre")
	inst.AnimState:PushAnimation("open_loop")
    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/hutch/open")
end

local function onclose(inst)
    inst.AnimState:PlayAnimation("open_pst")
	inst.AnimState:PushAnimation("close_loop")
    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/hutch/close")
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
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/hutch/hit")
    inst.components.container:DropEverything()
    inst.AnimState:PushAnimation("close_loop", true)
    inst.components.container:Close()
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("set")
    inst.AnimState:PushAnimation("close_loop")
    inst.SoundEmitter:PlaySound("saltydog/common/saltbox/place")
end

local function lighon(inst,on)
	if on then
		if not inst.lighton then
			inst.Light:Enable(true)
			inst.AnimState:OverrideSymbol("bone", "tz_elong_box", "lightbone")
			inst.lighton = true
		end
	elseif inst.lighton then
		inst.Light:Enable(false)
		inst.AnimState:ClearOverrideSymbol("bone")
		inst.lighton = false
	end
end

local function CheckForLight(inst)
	local item = inst.components.container:GetItemInSlot(1)
	if item  and item.prefab == "fireflies" then
		lighon(inst,true)
	else
		lighon(inst,false)
	end
end


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()
    inst.entity:AddLight()

    inst.MiniMapEntity:SetIcon("tz_elong_box_map.tex")

    inst:AddTag("structure")

    inst.AnimState:SetBank("tz_elong_box")
    inst.AnimState:SetBuild("tz_elong_box")
    inst.AnimState:PlayAnimation("close_loop",true)

    inst.Light:SetFalloff(0.9) --削减
    inst.Light:SetIntensity(.8) --强度
    inst.Light:SetRadius(7) --大小
    inst.Light:SetColour(237/255, 237/255, 209/255) --颜色
    inst.Light:Enable(false)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.lighton = false
    inst:AddComponent("inspectable")
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("tz_elong_box")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose
    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true

	inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(0)

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit) 

    inst:ListenForEvent("onbuilt", onbuilt)

    inst:ListenForEvent("itemget", CheckForLight)
    inst:ListenForEvent("itemlose", CheckForLight)
	
	inst:DoTaskInTime(0,CheckForLight)
    AddHauntableDropItemOrWork(inst)

    return inst
end

return Prefab("tz_elong_box", fn, assets, prefabs),
    MakePlacer("tz_elong_box_placer", "tz_elong_box", "tz_elong_box", "close_loop")