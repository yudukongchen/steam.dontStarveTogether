require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/jinkela_machine.zip"),
    Asset("IMAGE", "images/inventoryimages/jinkela_machine.tex"),
    Asset("ATLAS", "images/inventoryimages/jinkela_machine.xml"),
}

local prefabs =
{
    "jinkela_ash"
}

---------------------------------

local function onburnt(inst)
    DefaultBurntStructureFn(inst)
end

local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    inst.SoundEmitter:KillSound("firesuppressor_idle")
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end

local function onhit(inst, worker)
    local num = inst.jinkela_ash_num
    if not inst:HasTag("burnt") then
        if num == 0 then
            inst.AnimState:PlayAnimation("hit")
            inst.AnimState:PushAnimation("idle")
        elseif num > 0 and num <=5 then
            inst.AnimState:PlayAnimation("hit_five")
            inst.AnimState:PushAnimation("idle_five")
        elseif num > 5 and num <=10 then
            inst.AnimState:PlayAnimation("hit_ten")
            inst.AnimState:PushAnimation("idle_ten")
        elseif num > 10 and num <=15 then
            inst.AnimState:PlayAnimation("hit_fiveteen")
            inst.AnimState:PushAnimation("idle_fiveteen")
        elseif num > 15 then
            inst.AnimState:PlayAnimation("hit_twenty")
            inst.AnimState:PushAnimation("idle_twenty")
        end
    end
end

local function onsave(inst, data)
    data.num = inst.jinkela_ash_num
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end 
end

local function onload(inst, data)
    if data ~= nil then
        inst.jinkela_ash_num = data.num
        local num = inst.jinkela_ash_num
        if num == 0 then
            inst.AnimState:PlayAnimation("idle",true)
        elseif num <= 5 then
            inst.AnimState:PlayAnimation("idle_five",true)
        elseif num <= 10 then
            inst.AnimState:PlayAnimation("idle_ten",true)
        elseif num <= 15 then
            inst.AnimState:PlayAnimation("idle_fiveteen",true)
        else
            inst.AnimState:PlayAnimation("idle_twenty",true)
        end
        if data.burnt and inst.components.burnable ~= nil and inst.components.burnable.onburnt ~= nil then
            inst.components.burnable.onburnt(inst)
        end
    end
end

local function onbuilt(inst)
    --inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/firesupressor_craft")
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle", true)
end
---------------------------------

local MAX_ITEM_NUM = TUNING.EA_MAX_ACCEPT_ITEM_NUM or 20

-- local function shouldacceptitem(inst,item,giver)
--     if inst.jinkela_ash_num >= MAX_ITEM_NUM then
--         if giver and giver.components.talker then
--             giver.components.talker:Say(STRINGS.JINKELA_IS_MAX)
--         end
--         return false
--     end
--     return true
-- end

local function onproduce(inst)
    local item = inst.components.container:GetItemInSlot(1)
    if item then
        local item_num = item.components.stackable and item.components.stackable.stacksize or 1
        item_num = inst.jinkela_ash_num + item_num > MAX_ITEM_NUM and MAX_ITEM_NUM - inst.jinkela_ash_num or item_num
        inst:DoTaskInTime(5 * FRAMES, function()
            inst.jinkela_ash_num = inst.jinkela_ash_num + item_num
            for i =1, item_num do
                local delete = inst.components.container:RemoveItem(item)
                delete:Remove()
                inst.components.harvestable:Grow()
            end
            local num = inst.jinkela_ash_num
            if num <= MAX_ITEM_NUM/4 then
                inst.AnimState:PlayAnimation("idle_five",true)
            elseif num <= MAX_ITEM_NUM/2 then
                inst.AnimState:PlayAnimation("idle_ten",true)
            elseif num <= 3*MAX_ITEM_NUM/4 then
                inst.AnimState:PlayAnimation("idle_fiveteen",true)
            else
                inst.AnimState:PlayAnimation("idle_twenty",true)
            end
        end)
    end
end

local function onharvest(inst, picker, produce)
    if not inst:HasTag("burnt") then
        inst.jinkela_ash_num = 0
        inst.AnimState:PlayAnimation("idle",true)
    end
end

local function updatelevel(inst)
    if not inst:HasTag("burnt") then end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()
    inst.entity:AddLightWatcher()

    MakeObstaclePhysics(inst, .5)

    inst.MiniMapEntity:SetIcon("jinkela_machine_mini.tex")  --小地图图标

    inst.AnimState:SetBank("jinkela_machine")
    inst.AnimState:SetBuild("jinkela_machine")
    inst.AnimState:PlayAnimation("idle")

    inst.onproduce = onproduce
    inst.isvalid = net_bool(inst.GUID,"seedisvalid")
    inst.isvalid:set(false)

    inst:AddTag("structure")

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

    inst.jinkela_ash_num = 0
    --2021.10.31 改为使用容器组件，方便一次接受一组物品
    -- inst:AddComponent("trader")
    -- inst.components.trader:SetAcceptTest(shouldacceptitem)
    -- inst.components.trader.onaccept = ongetitem
    -- inst.components.trader.acceptnontradable = true

    inst:AddComponent("container")
    inst.components.container:WidgetSetup( "jinkela_machine")
    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true

    
    inst:AddComponent("harvestable")
    inst.components.harvestable:SetUp("jinkela_ash", MAX_ITEM_NUM, nil, onharvest, updatelevel)
    
    ----------------------------------------

    MakeMediumBurnable(inst, nil, nil, true)
    MakeMediumPropagator(inst)
    inst.components.burnable:SetOnBurntFn(onburnt)
    --MakeSnowCovered(inst)

    inst:ListenForEvent("onbuilt", onbuilt)

    inst.OnSave = onsave
    inst.OnLoad = onload

    return inst
end

return Prefab("jinkela_machine", fn, assets, prefabs),
    MakePlacer("jinkela_machine_placer", "jinkela_machine", "jinkela_machine", "idle")
    --name：perfab名，约定为原prefab名——placer,
    --bank,build,anim,
    --onground：取值true或false，是否设置为紧贴地面,
    --snap：取值true或false，无用，设置为nil即可,
    --metersnap：取值true或false，与围墙有关，一般建筑物用不上，设置为nil即可,
    --scale,
    --fixedcameraoffset：固定偏移,
    --facing：设置有几个面,
    --postinit_fn：特殊处理
