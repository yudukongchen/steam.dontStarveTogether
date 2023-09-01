local writeables = require "writeables"
-- local oldmakescreen = writeables.makescreen 
-- writeables.makescreen = function(inst,doer,...)
    -- local oldprefab = inst.prefab 
    -- if oldprefab =="tz_teleport" then
        -- inst.prefab = "homesign"
    -- end
    -- local r = oldmakescreen(inst,doer,...)
    -- inst.prefab = oldprefab
    -- if r then
        -- r.edit_text:SetTextLengthLimit(6)
    -- end
    -- return r
-- end
if not writeables.GetLayout("tz_teleport") then
writeables.AddLayout("tz_teleport",writeables.GetLayout("homesign"))
end
local function onhammered(inst, worker)
    inst.AnimState:PlayAnimation("destory")
    inst.AnimState:PushAnimation("idle",true)
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("destory")
    inst.AnimState:PushAnimation("idle",true)
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("set")
    inst.AnimState:PushAnimation("idle",true)
    inst.SoundEmitter:PlaySound("dontstarve/common/icebox_craft")
end

local assets =
{
    Asset("ANIM", "anim/tz_teleport.zip"),
    Asset("ATLAS", "images/inventoryimages/tz_teleport.xml"),
    Asset("IMAGE", "images/inventoryimages/tz_teleport.tex"),
}

    STRINGS.NAMES.TZ_TELEPORT = "时空漩涡枢纽"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.TZ_TELEPORT = [[欢迎使用蜗牛传送基站]]
    STRINGS.RECIPE_DESC.TZ_TELEPORT = [[骑着蜗牛去会见老友！]]
    
local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("tz_teleport.tex")
    inst.entity:AddNetwork()
    inst.entity:SetPristine()
    MakeObstaclePhysics(inst, .7)
    
    inst.AnimState:SetBank("tz_teleport")
    inst.AnimState:SetBuild("tz_teleport")
    inst.AnimState:PlayAnimation("idle")
    inst:AddComponent("talker")
    
    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("inspectable")
    inst:AddComponent("writeable")
    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(8)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit) 
    inst:ListenForEvent("onbuilt", onbuilt)
    inst:AddComponent("taizhen_teleport")
	inst.components.taizhen_teleport.dist_cost = 20
    MakeSnowCoveredPristine(inst)
    inst.AnimState:OverrideSymbol("snow", "tz_teleport", "snow")
    return inst
end

return Prefab("tz_teleport", fn,assets),
    MakePlacer("tz_teleport_placer", "tz_teleport", "tz_teleport", "idle")