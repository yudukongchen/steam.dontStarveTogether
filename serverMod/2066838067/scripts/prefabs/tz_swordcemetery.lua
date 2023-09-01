require "prefabutil"
local assets =
{
	Asset("ANIM", "anim/tz_swordcemetery.zip"),
	Asset("ANIM", "anim/ui_tz_swordcemetery_1x4.zip"),
	Asset( "IMAGE", "images/inventoryimages/tz_swordcemetery.tex" ),
    Asset( "ATLAS", "images/inventoryimages/tz_swordcemetery.xml" ),
}

local prefabs =
{
    "collapse_small",
	"tz_unknowk",
	"tz_unknowf",
	"sanity_raise",
	"tz_shadowfire",
	"tz_shadowfirefx",
}

local MAX_LIGHT_ON_FRAME = 15
local MAX_LIGHT_OFF_FRAME = 30
local function blueprint(inst)
	if not inst.components.container:IsFull() then 
		return
	end
	if inst.components.container:Has("bluegem", 1) and 
		inst.components.container:Has("ice",1) and
		inst.components.container:Has("walrus_tusk",1) and
		inst.components.container:Has("nightmarefuel",1) then
		inst.components.container:DestroyContents()
		local blueprint1 = SpawnPrefab("tz_unknowf")
		inst.components.container:GiveItem(blueprint1)
		local x, y, z = inst.Transform:GetWorldPosition()
		SpawnPrefab("sanity_raise").Transform:SetPosition(x, y, z)
		inst.SoundEmitter:PlaySound("dontstarve/sanity/shadowrock_up")
	elseif inst.components.container:Has("redgem", 1) and 
		inst.components.container:Has("dragon_scales",1) and
		inst.components.container:Has("ash",1) and
		inst.components.container:Has("nightmarefuel",1) then
		inst.components.container:DestroyContents()
		local blueprint2 = SpawnPrefab("tz_unknowk")
		inst.components.container:GiveItem(blueprint2)
		local x, y, z = inst.Transform:GetWorldPosition()
		SpawnPrefab("sanity_raise").Transform:SetPosition(x, y, z)	
		inst.SoundEmitter:PlaySound("dontstarve/sanity/shadowrock_up")	
	elseif inst.components.container:Has("boneshard", 1) and 
		inst.components.container:Has("minotaurhorn",1) and
		inst.components.container:Has("thurible",1) and
		inst.components.container:Has("nightmarefuel",1) then
		inst.components.container:DestroyContents()
		local blueprint3 = SpawnPrefab("tz_unknowm")
		inst.components.container:GiveItem(blueprint3)
		local x, y, z = inst.Transform:GetWorldPosition()
		SpawnPrefab("sanity_raise").Transform:SetPosition(x, y, z)	
		inst.SoundEmitter:PlaySound("dontstarve/sanity/shadowrock_up")	
	elseif inst.components.container:Has("reviver", 1) and 
		inst.components.container:Has("beardhair",1) and
		inst.components.container:Has("livinglog",1) and
		inst.components.container:Has("nightmarefuel",1) then
		inst.components.container:DestroyContents()
		local blueprint3 = SpawnPrefab("tz_unknown")
		inst.components.container:GiveItem(blueprint3)
		local x, y, z = inst.Transform:GetWorldPosition()
		SpawnPrefab("sanity_raise").Transform:SetPosition(x, y, z)	
		inst.SoundEmitter:PlaySound("dontstarve/sanity/shadowrock_up")			
	end

end

local function onopen(inst)
        --inst.AnimState:PlayAnimation("open")
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
end 

local function onclose(inst)
        --inst.AnimState:PlayAnimation("close")
		blueprint(inst)
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
end

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
    end
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function onhit(inst, worker)
        inst.AnimState:PlayAnimation("hit")
		inst.AnimState:PushAnimation("idle", false)
        if inst.components.container ~= nil then
            inst.components.container:DropEverything()
            inst.components.container:Close()
        end
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle", false)
	inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_lvl2_place")
end
local function OnUpdateLight(inst, dframes)
    local frame = inst._lightframe:value() + dframes
    if frame >= inst._lightmaxframe then
        inst._lightframe:set_local(inst._lightmaxframe)
        inst._lighttask:Cancel()
        inst._lighttask = nil
    else
        inst._lightframe:set_local(frame)
    end

    local k = frame / inst._lightmaxframe

    if inst._islighton:value() then
        inst.Light:SetRadius(2 * k)
    else
        inst.Light:SetRadius(2 * (1 - k))
    end

    if TheWorld.ismastersim then
        inst.Light:Enable(inst._islighton:value() or frame < inst._lightmaxframe)
        --if not inst._islighton:value() then
            --inst.SoundEmitter:KillSound("idlesound")
        --end
    end
end

local function OnLightDirty(inst)
    if inst._lighttask == nil then
        inst._lighttask = inst:DoPeriodicTask(FRAMES, OnUpdateLight, nil, 1)
    end
    inst._lightmaxframe = inst._islighton:value() and MAX_LIGHT_ON_FRAME or MAX_LIGHT_OFF_FRAME
    OnUpdateLight(inst, 0)
end
local function onturnon(inst)
    --if not inst.SoundEmitter:PlayingSound("idlesound") then
    --    inst.SoundEmitter:PlaySound("dontstarve/common/ancienttable_LP", "idlesound")
    --end
    if not inst._islighton:value() then
        inst._islighton:set(true)
        inst._lightframe:set(math.floor((1 - inst._lightframe:value() / MAX_LIGHT_OFF_FRAME) * MAX_LIGHT_ON_FRAME + .5))
        OnLightDirty(inst)
    end
	inst.SoundEmitter:PlaySound("dontstarve/cave/nightmare_spawner_open")
	if inst.fires == nil then
            inst.fires = SpawnPrefab("tz_shadowfire")
            inst.fires.entity:SetParent(inst.entity)
            inst.fires.entity:AddFollower()
            inst.fires.Follower:FollowSymbol(inst.GUID, "image", 286, -230, 0)
	end
	if inst.firefx == nil then
            inst.firefx = SpawnPrefab("tz_shadowfirefx")
            inst.firefx.entity:SetParent(inst.entity)
            inst.firefx.entity:AddFollower()
            inst.firefx.Follower:FollowSymbol(inst.GUID, "image", -268, -500, 0)
	end
end

local function onturnoff(inst)
    if inst._islighton:value() then
        inst._islighton:set(false)
        inst._lightframe:set(math.floor((1 - inst._lightframe:value() / MAX_LIGHT_ON_FRAME) * MAX_LIGHT_OFF_FRAME + .5))
        OnLightDirty(inst)
    end
    if inst.fires ~= nil then
		inst.fires.AnimState:PlayAnimation("disappear")
		inst.fires:ListenForEvent("animover", inst.fires.Remove)
        inst.fires = nil
    end
    if inst.firefx ~= nil then
		inst.firefx.AnimState:PlayAnimation("disappear")
		inst.firefx:ListenForEvent("animover", inst.firefx.Remove)
        inst.firefx = nil
    end
end
local function complete_doonact(inst)
    if inst._activecount > 1 then
        inst._activecount = inst._activecount - 1
    else
        inst._activecount = 0
        --inst.SoundEmitter:KillSound("sound")
    end

    --inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_lvl3_ding")
end

local function onactivate(inst)
    inst._activecount = inst._activecount + 1
    --if not inst.SoundEmitter:PlayingSound("sound") then
    --    inst.SoundEmitter:PlaySound("dontstarve/common/ancienttable_craft", "sound")
    --end

    inst:DoTaskInTime(1.5, complete_doonact)
end
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()
		inst.entity:AddLight()

        inst.MiniMapEntity:SetIcon("tz_swordcemetery.tex")
		MakeObstaclePhysics(inst, 0.8, 1.2)
        inst:AddTag("structure")
		inst.AnimState:SetBank("tz_swordcemetery")
        inst.AnimState:SetBuild("tz_swordcemetery")
        inst.AnimState:PlayAnimation("idle")
		--inst.Transform:SetScale(0.8, 0.8, 0.8)
        MakeSnowCoveredPristine(inst)
		inst.Light:Enable(false)
		inst.Light:SetRadius(0)
		inst.Light:SetFalloff(0.7)
		inst.Light:SetIntensity(.9)
		--inst.Light:SetColour(1, 1, 1)
		inst.Light:SetColour(180 / 255, 195 / 255, 150 / 255)
		inst.Light:EnableClientModulation(true)
		inst._lightframe = net_smallbyte(inst.GUID, "tz_swordcemetery._lightframe", "lightdirty")
		inst._islighton = net_bool(inst.GUID, "tz_swordcemetery._islighton", "lightdirty")
		inst._lightmaxframe = MAX_LIGHT_OFF_FRAME
		inst._lightframe:set(inst._lightmaxframe)
		inst._lighttask = nil
        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
        inst:ListenForEvent("lightdirty", OnLightDirty)
            return inst
        end
		inst._activecount = 0
        inst:AddComponent("inspectable")
		--[[
        inst:AddComponent("container")
        inst.components.container:WidgetSetup("tz_swordcemetery")
        inst.components.container.onopenfn = onopen
        inst.components.container.onclosefn = onclose
		]]
		inst:AddComponent("prototyper")
		inst.components.prototyper.onturnon = onturnon
		inst.components.prototyper.onturnoff = onturnoff
		inst.components.prototyper.onactivate = onactivate
		inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.ANCIENTALTAR_HIGH

        inst:AddComponent("lootdropper")
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(5)
        inst.components.workable:SetOnFinishCallback(onhammered)
        inst.components.workable:SetOnWorkCallback(onhit)

        inst:ListenForEvent("onbuilt", onbuilt)
        MakeSnowCovered(inst)
        return inst
    end
return Prefab( "tz_swordcemetery", fn, assets, prefabs ),
	   MakePlacer("tz_swordcemetery_placer", "tz_swordcemetery", "tz_swordcemetery", "idle")