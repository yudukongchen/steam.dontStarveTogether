local assets =
{
    Asset("ANIM", "anim/nanashi_mumei_lantern.zip"),

    Asset( "IMAGE", "images/inventoryimages/nanashi_mumei_lantern.tex" ),
    Asset( "ATLAS", "images/inventoryimages/nanashi_mumei_lantern.xml" ),

    
    Asset( "IMAGE", "images/inventoryimages/nanashi_mumei_lantern_off.tex" ),
    Asset( "ATLAS", "images/inventoryimages/nanashi_mumei_lantern_off.xml" ),
}

local function DoTurnOffSound(inst, owner)
    inst._soundtask = nil
    (owner ~= nil and owner:IsValid() and owner.SoundEmitter or inst.SoundEmitter):PlaySound("dontstarve/wilson/lantern_off")
end

local function PlayTurnOffSound(inst)
    if inst._soundtask == nil and inst:GetTimeAlive() > 0 then
        inst._soundtask = inst:DoTaskInTime(0, DoTurnOffSound, inst.components.inventoryitem.owner)
    end
end

local function PlayTurnOnSound(inst)
    if inst._soundtask ~= nil then
        inst._soundtask:Cancel()
        inst._soundtask = nil
    elseif not POPULATING then
        inst._light.SoundEmitter:PlaySound("dontstarve/wilson/lantern_on")
    end
end

local function fuelupdate(inst)
    if inst._light ~= nil then
        local fuelpercent = inst.components.fueled:GetPercent()
        inst._light.Light:SetIntensity(Lerp(.4, .6, fuelpercent))
        -- ORIGINAL SIZE
        -- inst._light.Light:SetRadius(Lerp(3, 5, fuelpercent))
        inst._light.Light:SetRadius(Lerp(2.5, 4, fuelpercent))
        inst._light.Light:SetFalloff(.9)

        local owner = inst.components.inventoryitem.owner

        if owner and not inst.glow then
            inst.glow = owner:SpawnChild("nanashi_mumei_lantern_glow")
            inst.glow.Follower:FollowSymbol(owner.GUID,"swap_body", 0, 0, 0)
        end
    end
end

local function onremovelight(light)
    light._lantern._light = nil
end

local function stoptrackingowner(inst)
    if inst._owner ~= nil then
        inst:RemoveEventCallback("equip", inst._onownerequip, inst._owner)
        inst._owner = nil
    end
end



local function turnon(inst)
    if not inst.components.fueled:IsEmpty() and not inst._light then
        inst.components.fueled:StartConsuming()

        local owner = inst.components.inventoryitem.owner

        if inst._light == nil then
            inst._light = SpawnPrefab("lanternlight")
            inst._light._lantern = inst
            inst:ListenForEvent("onremove", onremovelight, inst._light)
            fuelupdate(inst)
            PlayTurnOnSound(inst)
        end

        if owner and not inst.glow then
            inst.glow = owner:SpawnChild("nanashi_mumei_lantern_glow")
            inst.glow.Follower:FollowSymbol(owner.GUID,"swap_body", 0, 0, 0)
        end

        -- if inst.glow then
        --     inst.glow:DoPeriodicTask(0,function ()
        --         inst.glow.Transform:SetRotation(owner.Transform:GetRotation())
        --     end)
        -- end
        inst._light.entity:SetParent((owner or inst).entity)
        if owner then
            owner.AnimState:OverrideSymbol("swap_body", "nanashi_mumei_lantern", "swap_body")
        end
        inst.AnimState:PlayAnimation("idle_on")

        inst.components.machine.ison = true
        -- inst.components.inventoryitem:ChangeImageName((inst:GetSkinName() or "lantern").."_lit")
        inst:PushEvent("lantern_on")
    end
end

local function turnoff(inst)
    stoptrackingowner(inst)

    inst.components.fueled:StopConsuming()

    if inst._light ~= nil then
        inst._light:Remove()
        PlayTurnOffSound(inst)
    end

    if inst.glow then
        inst.glow:Remove()
    end

    inst.AnimState:PlayAnimation("idle_off")
    -- inst:DoTaskInTime(0,function ()
    --     local owner = inst.components.inventoryitem.owner
    --     if owner then
    --         owner.AnimState:OverrideSymbol("swap_body", "nanashi_mumei_lantern", "swap_body_off")
    --     end
    -- end)

    inst.components.inventoryitem.imagename = "nanashi_mumei_lantern_off"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/nanashi_mumei_lantern_off.xml"
    inst.components.machine.ison = false
    -- inst.components.inventoryitem:ChangeImageName(inst:GetSkinName()) --nil if no skin
    inst:PushEvent("lantern_off")
end

local function starttrackingowner(inst, owner)
    if owner ~= inst._owner then
        stoptrackingowner(inst)
        if owner ~= nil and owner.components.inventory ~= nil then
            inst._owner = owner
            inst:ListenForEvent("equip", inst._onownerequip, owner)
        end
    end
end

local function OnRemove(inst)
    if inst._light ~= nil then
        inst._light:Remove()
    end
    if inst._soundtask ~= nil then
        inst._soundtask:Cancel()
    end
end

local function ondropped(inst)
    turnoff(inst)
    turnon(inst)
end

local function onequip(inst, owner)

	owner.AnimState:OverrideSymbol("swap_body", "nanashi_mumei_lantern", "swap_body")
    inst._check_time = inst:DoPeriodicTask(0.1,function ()
        if not inst.components.fueled:IsEmpty() then
            if TheWorld.state.isnight or TheWorld:HasTag("cave") then
                turnon(inst)
            else
                turnoff(inst)
            end
        end
    end)

    -- if not inst.components.fueled:IsEmpty() then
    --     turnon(inst)
    -- end
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")

    if inst.glow then
        inst.glow:Remove()
    end

    if inst.components.machine.ison then
        starttrackingowner(inst, owner)
    end

    if inst._check_time then
        inst._check_time:Cancel()
        inst._check_time = nil
    end
end

local function nofuel(inst)
    if inst.components.equippable:IsEquipped() and inst.components.inventoryitem.owner ~= nil then
        local data =
        {
            prefab = inst.prefab,
            equipslot = inst.components.equippable.equipslot,
        }
        turnoff(inst)
        inst.components.inventoryitem.owner:PushEvent("torchranout", data)
    else
        turnoff(inst)
    end
end

local function ontakefuel(inst)
    if inst.components.equippable:IsEquipped() then
        turnon(inst)
    end
end


local function fn()
    local inst = CreateEntity()

    inst.entity:AddSoundEmitter()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("nanashi_mumei_lantern")
    inst.AnimState:SetBuild("nanashi_mumei_lantern")
    inst.AnimState:PlayAnimation("idle_on")
    inst:AddTag("light")

    MakeInventoryFloatable(inst, "small", 0.2, 0.80)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetOnDroppedFn(ondropped)
    inst.components.inventoryitem:SetOnPutInInventoryFn(turnoff)
    inst.components.inventoryitem.imagename = "nanashi_mumei_lantern"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/nanashi_mumei_lantern.xml"


    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY

    inst:AddComponent("fueled")

    inst:AddComponent("machine")
    inst.components.machine.turnonfn = turnon
    inst.components.machine.turnofffn = turnoff
    inst.components.machine.cooldowntime = 0

    inst.components.fueled.fueltype = TUNING.NANASHI_MUMEI_LANTERN_FUELTYPE
    inst.components.fueled:InitializeFuelLevel(TUNING.NANASHI_MUMEI_LANTERN_LIGHTTIME)
    inst.components.fueled:SetDepletedFn(nofuel)
    inst.components.fueled:SetUpdateFn(fuelupdate)
    inst.components.fueled:SetTakeFuelFn(ontakefuel)
    inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)
    inst.components.fueled.accepting = true


    inst._light = nil

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    MakeHauntableLaunch(inst)
    inst.OnRemoveEntity = OnRemove

    inst._onownerequip = function(owner, data)
        -- if data.item ~= inst and
        --     (   data.eslot == EQUIPSLOTS.HANDS or
        --         (data.eslot == EQUIPSLOTS.BODY and data.item:HasTag("heavy"))
        --     ) then
        --     turnoff(inst)
        -- end
    end

    return inst
end

return Prefab("nanashi_mumei_lantern", fn, assets)
