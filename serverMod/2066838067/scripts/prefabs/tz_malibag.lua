require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/tz_malibag.zip"),
    Asset("ANIM", "anim/ui_malibag_2x3.zip"),
	Asset( "IMAGE", "images/inventoryimages/tz_malibag.tex" ),
    Asset( "ATLAS", "images/inventoryimages/tz_malibag.xml" ),
}



local function onopen(inst)
    --inst.AnimState:PlayAnimation("open")
    inst.SoundEmitter:PlaySound("malibag/malibag/open")
end

local function onclose(inst)
    --inst.AnimState:PlayAnimation("close")
    inst.SoundEmitter:PlaySound("malibag/malibag/close")
end
local function ondropped(inst)
    if inst.components.container ~= nil then
        inst.components.container:Close()
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()
	MakeInventoryPhysics(inst)
    inst.MiniMapEntity:SetIcon("tz_malibag.tex")

    inst.AnimState:SetBank("tz_malibag")
    inst.AnimState:SetBuild("tz_malibag")
    inst.AnimState:PlayAnimation("idle")
	inst:AddTag("tz_malibag")
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_malibag.xml"
	
	inst.components.inventoryitem:SetOnDroppedFn(ondropped)
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("tz_malibag")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose

    return inst
end

return Prefab("tz_malibag", fn, assets, prefabs)

