local assets =
{
    Asset("ANIM", "anim/tz_evil_teacher_super.zip"),    
    Asset( "IMAGE", "images/inventoryimages/tz_evil_teacher_super.tex" ),
    Asset( "ATLAS", "images/inventoryimages/tz_evil_teacher_super.xml" ),
}

local function tryplaysound(inst, id, sound)
    inst._soundtasks[id] = nil
    if inst.AnimState:IsCurrentAnimation("proximity_pst") then
        inst.SoundEmitter:PlaySound(sound)
    end
end

local function trykillsound(inst, id, sound)
    inst._soundtasks[id] = nil
    if inst.AnimState:IsCurrentAnimation("proximity_pst") then
        inst.SoundEmitter:KillSound(sound)
    end
end

local function queueplaysound(inst, delay, id, sound)
    if inst._soundtasks[id] ~= nil then
        inst._soundtasks[id]:Cancel()
    end
    inst._soundtasks[id] = inst:DoTaskInTime(delay, tryplaysound, id, sound)
end

local function queuekillsound(inst, delay, id, sound)
    if inst._soundtasks[id] ~= nil then
        inst._soundtasks[id]:Cancel()
    end
    inst._soundtasks[id] = inst:DoTaskInTime(delay, trykillsound, id, sound)
end

local function tryqueueclosingsounds(inst, onanimover)
    inst._soundtasks.animover = nil
    if inst.AnimState:IsCurrentAnimation("proximity_pst") then
        inst:RemoveEventCallback("animover", onanimover)
        --Delay one less frame, since this task is delayed one frame already
        queueplaysound(inst, 4 * FRAMES, "close", "dontstarve/common/together/book_maxwell/close")
        queuekillsound(inst, 5 * FRAMES, "killidle", "idlesound")
        queueplaysound(inst, 14 * FRAMES, "drop", "dontstarve/common/together/book_maxwell/drop")
    end
end

local function onanimover(inst)
    if inst._soundtasks.animover ~= nil then
        inst._soundtasks.animover:Cancel()
    end
    inst._soundtasks.animover = inst:DoTaskInTime(FRAMES, tryqueueclosingsounds, onanimover)
end

local function stopclosingsounds(inst)
    inst:RemoveEventCallback("animover", onanimover)
    if next(inst._soundtasks) ~= nil then
        for k, v in pairs(inst._soundtasks) do
            v:Cancel()
        end
        inst._soundtasks = {}
    end
end

local function startclosingsounds(inst)
    stopclosingsounds(inst)
    inst:ListenForEvent("animover", onanimover)
    onanimover(inst)
end

local function onturnon(inst)
    if inst._activetask == nil then
        stopclosingsounds(inst)
        if inst.AnimState:IsCurrentAnimation("proximity_loop") then
            --In case other animations were still in queue
            inst.AnimState:PlayAnimation("proximity_loop", true)
        else
            inst.AnimState:PlayAnimation("proximity_pre")
            inst.AnimState:PushAnimation("proximity_loop", true)
        end
        if not inst.SoundEmitter:PlayingSound("idlesound") then
            inst.SoundEmitter:PlaySound("dontstarve/common/together/book_maxwell/active_LP", "idlesound")
        end
    end
end

local function onturnoff(inst)
    if inst._activetask == nil and not inst.components.inventoryitem:IsHeld() then
        inst.AnimState:PushAnimation("proximity_pst")
        inst.AnimState:PushAnimation("idle", false)
        startclosingsounds(inst)
    end
end

local function doneact(inst)
    inst._activetask = nil
    if inst.components.prototyper.on then
        inst.AnimState:PlayAnimation("proximity_loop", true)
        if not inst.SoundEmitter:PlayingSound("idlesound") then
            inst.SoundEmitter:PlaySound("dontstarve/common/together/book_maxwell/active_LP", "idlesound")
        end
    else
        inst.AnimState:PushAnimation("proximity_pst")
        inst.AnimState:PushAnimation("idle", false)
        startclosingsounds(inst)
    end
end

local function showfx(inst, show)
    if inst.AnimState:IsCurrentAnimation("use") then
        if show then
            inst.AnimState:Show("FX")
        else
            inst.AnimState:Hide("FX")
        end
    end
end

local function onuse(inst, hasfx)
    stopclosingsounds(inst)
    inst.AnimState:PlayAnimation("use")
    inst:DoTaskInTime(0, showfx, hasfx)
    if hasfx then 
        SpawnAt("tz_evil_teacher_super_buildfx",inst)
    end 
    inst.SoundEmitter:PlaySound("dontstarve/common/together/book_maxwell/use")
    if inst._activetask ~= nil then
        inst._activetask:Cancel()
    end
    inst._activetask = inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength(), doneact)
end

local function onactivate(inst)
    onuse(inst, true)
end

local function CheckPet(inst)
    inst.components.petleash:DespawnAllPets()
    local owner = inst.components.inventoryitem:GetGrandOwner()
    if owner and owner:HasTag("player") then 
        local pt = inst:GetPosition()
        local pet = inst.components.petleash:SpawnPetAt(pt.x, 0, pt.z,"tz_book_surpassing")
    end
end

local function onputininventory(inst)
    if inst._activetask ~= nil then
        inst._activetask:Cancel()
        inst._activetask = nil
    end
    stopclosingsounds(inst)
    inst.AnimState:PlayAnimation("idle")
    inst.SoundEmitter:KillSound("idlesound")
    CheckPet(inst)
end

local function ondropped(inst)
    if inst.components.prototyper.on then
        onturnon(inst)
    end
    CheckPet(inst)
end

local function OnHaunt(inst, haunter)
    if inst.components.prototyper.on then
        onuse(inst, false)
    else
        Launch(inst, haunter, TUNING.LAUNCH_SPEED_SMALL)
    end
    inst.components.hauntable.hauntvalue = TUNING.HAUNT_TINY
    return true
end

local function LinkOwner(inst,pet)
    -- local owner = inst.components.equippable:IsEquipped() and inst.components.inventoryitem.owner 
    local owner = inst.components.inventoryitem:GetGrandOwner()
    if owner and owner.components.leader then 
        owner.components.leader:AddFollower(pet)
    end
end
local function OnSpawnPet(inst, pet)
    if pet.components.spawnfader ~= nil then
        pet.components.spawnfader:FadeIn()
    end
    --pet
    LinkOwner(inst,pet)
    SpawnAt("sand_puff",pet)
    SpawnAt("shovel_dirt",pet)
end

local function OnDespawnPet(inst, pet)
    SpawnAt("sand_puff",pet)
    SpawnAt("shovel_dirt",pet)
    pet:Remove()
end



local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("book_maxwell")
    inst.AnimState:SetBuild("tz_evil_teacher_super")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("tz_evil_builder")

    --prototyper (from prototyper component) added to pristine state for optimization
    inst:AddTag("prototyper")
    MakeInventoryFloatable(inst, "med", 0.2, {1.1, 0.5, 1.1})
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst._activetask = nil
    inst._soundtasks = {}

    inst:AddComponent("petleash")
    inst.components.petleash:SetMaxPets(1)
    inst.components.petleash:SetOnSpawnFn(OnSpawnPet)
    inst.components.petleash:SetOnDespawnFn(OnDespawnPet)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_evil_teacher_super.xml"

    inst:AddComponent("prototyper")
    inst.components.prototyper.onturnon = onturnon
    inst.components.prototyper.onturnoff = onturnoff
    inst.components.prototyper.onactivate = onactivate
    inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.TZ_EVIL_TEACHER_THREE

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL

    MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
    MakeSmallPropagator(inst)

    inst:AddComponent("hauntable")
    inst.components.hauntable.cooldown = TUNING.HAUNT_COOLDOWN_SMALL
    inst.components.hauntable:SetOnHauntFn(OnHaunt)

    inst:ListenForEvent("onputininventory", onputininventory)
    inst:ListenForEvent("ondropped", ondropped)

    inst:DoTaskInTime(0,CheckPet)

    inst.OnBuiltFn = function(inst,builder)
        -- print(inst,"OnBuiltFn",builder)
    end

    return inst
end

local function fxfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()


    inst.AnimState:SetBank("tz_evil_teacher_super")
    inst.AnimState:SetBuild("tz_evil_teacher_super")
    inst.AnimState:PlayAnimation("use_background")

    inst:AddTag("NOBLOCK")
    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:ListenForEvent("animover",inst.Remove)

    return inst
end

return Prefab("tz_evil_teacher_super", fn, assets),
    Prefab("tz_evil_teacher_super_buildfx", fxfn, assets)
