require "prefabutil"
local assets = {
    Asset("ANIM", "anim/tz_truthbasketball.zip"),


    Asset("IMAGE", "images/inventoryimages/tz_truthbasketball.tex"),
    Asset("ATLAS", "images/inventoryimages/tz_truthbasketball.xml"),
}
local playeranims = {}
for k = 1,8 do
    local name = string.format("tz_video_a%02d", k)
    table.insert(assets, Asset("ANIM", "anim/"..name..".zip"))
    table.insert(playeranims,name)
end

local prefabs = {
    "collapse_small"
}

local function onhammered(inst, worker)
    if inst.has_key then
        inst.components.lootdropper:SpawnLootPrefab("atrium_key")
    end
    for k = 1,5 do 
        inst.components.lootdropper:SpawnLootPrefab("thulecite")
    end
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function onhit(inst, worker)
end

local function onbuilt(inst)
    if inst.kunkunfx then
        inst.kunkunfx:TurnOff()
        inst:DoTaskInTime(2.5,function()
            inst.kunkunfx:TurnOn()
        end)
    end
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("active_pre",false)
    inst.AnimState:PushAnimation("active_loop")
    inst.SoundEmitter:PlaySound("tz_truthbasketballsound/tz_truthbasketballsound/build")
end

local function onturnon(inst)
end

local function onturnoff(inst)
end

local sounds = {"place","build"}
local function onactivate(inst, doer, recipe)
    if recipe and recipe.atlas and recipe.image then
        inst.AnimState:OverrideSymbol("image", resolvefilepath(recipe.atlas), recipe.image)
    else
        inst.AnimState:ClearOverrideSymbol("image")   
    end
    inst.sound_num = (inst.sound_num or 2)%#sounds + 1
    inst.SoundEmitter:PlaySound("tz_truthbasketballsound/tz_truthbasketballsound/"..sounds[inst.sound_num])
    inst.AnimState:PlayAnimation("dobuild")
    inst.AnimState:PushAnimation("active_loop")    
end

local TechTree = require("techtree")

local function ItemTradeTest(inst, item)
    return not inst.has_key and item.prefab == "atrium_key"
end

local function OnKeyGiven(inst, giver)
    inst.components.trader:Disable()
    inst.SoundEmitter:PlaySound("tz_truthbasketballsound/tz_truthbasketballsound/build")
    inst.AnimState:PlayAnimation("active_pre")
    inst.AnimState:PushAnimation("active_loop")
    inst:DoTaskInTime(1.5,function()
        if inst.kunkunfx then
            inst.kunkunfx:TurnOn()
        end
        inst.has_key = true
        inst.components.pickable.caninteractwith = true
        inst.components.pickable:SetUp("atrium_key")
        if not inst.components.prototyper then
            inst:AddComponent("prototyper")
            inst.components.prototyper.onturnon = onturnon
            inst.components.prototyper.onturnoff = onturnoff
            inst.components.prototyper.onactivate = onactivate
            inst.components.prototyper.trees = TechTree.Create({
                ANCIENT = 4,
                MAGIC = 3,
                SCIENCE = 2,
                SEAFARING = 2,
            })
        end
    end)
end

local function OnKeyTaken(inst)
    if inst.kunkunfx then
        inst.kunkunfx:TurnOff()
    end
    inst.components.pickable.caninteractwith = false
    inst.AnimState:PlayAnimation("take_key")
    inst.AnimState:PushAnimation("unactive_loop")
    inst:DoTaskInTime(0.6,function()
        inst.components.trader:Enable()
        if inst.components.prototyper then
            inst:RemoveComponent("prototyper")
        end
        inst.has_key = false
    end)
end

local function OnLoad(inst, data)
    if data ~= nil then
        if data.has_key ~= nil then
            inst.has_key = data.has_key
            if inst.has_key == false then
                inst.components.trader:Enable()
                if inst.components.prototyper then
                    inst:RemoveComponent("prototyper")
                end    
                inst.AnimState:PlayAnimation("unactive_loop",true)
                if inst.kunkunfx then
                    inst.kunkunfx:TurnOff()
                end   
            else
                inst:DoTaskInTime(0.3,function()
                    if inst.kunkunfx then
                        inst.kunkunfx:TurnOff()
                    end  
                    inst.AnimState:PlayAnimation("active_loop",true)
                    if inst.kunkunfx then
                        inst.kunkunfx:TurnOn()
                    end                 
                end)
            end
        end
    end
end

local function OnSave(inst, data)
    data.has_key = inst.has_key
end
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("tz_truthbasketball.tex")
    MakeObstaclePhysics(inst, 2.2, 2)
    inst:AddTag("structure")
    inst.AnimState:SetBank("tz_truthbasketball")
    inst.AnimState:SetBuild("tz_truthbasketball")
    inst.AnimState:PlayAnimation("active_loop",true)

    inst:AddTag("gemsocket")
    inst:AddTag("giftmachine")
    --inst:AddTag("structure")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.has_key = true

    inst:AddComponent("inspectable")

    inst:AddComponent("prototyper")
    inst.components.prototyper.onturnon = onturnon
    inst.components.prototyper.onturnoff = onturnoff
    inst.components.prototyper.onactivate = onactivate
    inst.components.prototyper.trees = TechTree.Create({
        ANCIENT = 4, --远古4
        MAGIC = 3,--魔法3
        SCIENCE = 2, --科学2
        SEAFARING = 2,--划船2
    })
    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(5)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:AddComponent("pickable")
    inst.components.pickable.caninteractwith = true
    inst.components.pickable.onpickedfn = OnKeyTaken
    inst.components.pickable:SetUp("atrium_key")

    inst:AddComponent("trader")
    inst.components.trader:Disable()
    inst.components.trader:SetAbleToAcceptTest(ItemTradeTest)
    inst.components.trader.deleteitemonaccept = true
    inst.components.trader.onaccept = OnKeyGiven

    inst.kunkunfx = inst:SpawnChild("tz_truthbasketball_fx")
    inst.kunkunfx:TurnOn()
    inst:ListenForEvent("onbuilt", onbuilt)
    MakeSnowCovered(inst)
    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

local function doplay(inst)
    if playeranims[inst.num] then
        inst.AnimState:SetBank(playeranims[inst.num])
        inst.AnimState:SetBuild(playeranims[inst.num])
        inst.AnimState:PlayAnimation("idle")
    end
end
local function turnon(inst)
    inst.num = 1
    inst:Show()
    inst.inplaying = true
    doplay(inst)
    inst.SoundEmitter:KillSound("jinitaimei")
    inst.SoundEmitter:PlaySound("tz_truthbasketballsound/tz_truthbasketballsound/gif", "jinitaimei")
end
local function turnoff(inst)
    inst.SoundEmitter:KillSound("jinitaimei")
    inst:Hide()
    inst.inplaying = false
    inst.num = 1
end
--ThePlayer.SoundEmitter:PlaySound("tz_truthbasketballsound/tz_truthbasketballsound/build")
local function fxfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.entity:SetPristine()
    inst:AddTag("fx")

    if not TheWorld.ismastersim then
        return inst
    end
    inst.persists = false
    inst.num = 1
    inst.inplaying = false
    inst.TurnOn = turnon
    inst.TurnOff = turnoff
    inst:ListenForEvent("animover", function()
        if inst.inplaying then
            if inst.num == #playeranims then
                turnon(inst)
            else
                inst.num = inst.num%#playeranims + 1
                doplay(inst)
            end
        end
    end)
    return inst
end
return Prefab("tz_truthbasketball", fn, assets, prefabs),
    Prefab("tz_truthbasketball_fx", fxfn),
    MakePlacer("tz_truthbasketball_placer", "tz_truthbasketball", "tz_truthbasketball", "active_loop")
