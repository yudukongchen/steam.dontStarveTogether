local assets = {
    Asset("ANIM", "anim/tz_book_surpassing.zip"),
}

local brain = require "brains/tz_book_surpassingbrain"
-- local x,y,z = ThePlayer:GetPosition():Get() ThePlayer.components.petleash:SpawnPetAt(x,y,z,"tz_book_surpassing")

local speed_v0 = 0.25
-- local speed_max = 6
-- local speed_min = 0.5
-- local accelerate = 1
-- local dt = FRAMES
-- local range_to_far = 8
-- local range_to_close = 6

-- local function AcceleratedLocomote(inst,data)
--     local is_moving = inst.sg:HasStateTag("moving")
--     if not inst.LastIsMoving and is_moving and not inst.AccelerateTask then 
        
--     elseif inst.LastIsMoving and not is_moving then 
--         if inst.AccelerateTask then 
--             inst.AccelerateTask:Cancel()
--             inst.AccelerateTask = nil 
--         end 
--         inst.components.locomotor.walkspeed = speed_v0
--         inst.components.locomotor.runspeed = speed_v0
--     end

--     inst.LastIsMoving = is_moving
-- end
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeGhostPhysics(inst, .5, .5)

    inst.AnimState:SetBloomEffectHandle("shaders/anim_bloom_ghost.ksh")

    inst.AnimState:SetBank("tz_book_surpassing")
    inst.AnimState:SetBuild("tz_book_surpassing")
    inst.AnimState:PlayAnimation("book_loop", true)
    --inst.AnimState:SetMultColour(1,1,1,.6)

    inst:AddTag("flying")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.LastIsMoving = false

    inst:SetBrain(brain)

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = speed_v0
    inst.components.locomotor.runspeed = speed_v0

    inst:SetStateGraph("SGtz_book_surpassing")

    inst:AddComponent("inspectable")

    inst:AddComponent("follower")

    inst.SpawnFxTaskA = inst:DoPeriodicTask(1,function()
        SpawnAt("tz_book_surpassing_fx",inst).AnimState:PlayAnimation("fire_a_fx")
    end)

    inst.SpawnFxTaskB = inst:DoPeriodicTask(0.8,function()
        SpawnAt("tz_book_surpassing_fx",inst).AnimState:PlayAnimation("fire_b_fx")
    end)

    inst.SpawnFxTaskC = inst:DoPeriodicTask(0.6,function()
        SpawnAt("tz_book_surpassing_fx",inst).AnimState:PlayAnimation("fire_c_fx")
    end)

    ------------------

    -- inst:ListenForEvent("locomote",AcceleratedLocomote)
    inst.AccelerateTask = inst:DoPeriodicTask(0,function()
        if inst.components.locomotor.dest then 
            local dest_range = (inst:GetPosition() - Vector3(inst.components.locomotor.dest:GetPoint())):Length()
            -- inst.TargetSpeedMultiplier = math.clamp(1,(dest_range-1) * 3,25)
            inst.TargetSpeedMultiplier = dest_range < 5.5 and 1 or 25
            local current_speed_mult = inst.components.locomotor:GetExternalSpeedMultiplier(inst,"AccelerateTask") or 1
            local set_speed_mult = current_speed_mult
            if current_speed_mult < inst.TargetSpeedMultiplier then 
                set_speed_mult = set_speed_mult + 1
                set_speed_mult = math.min(set_speed_mult,inst.TargetSpeedMultiplier)
            else 
                set_speed_mult = set_speed_mult - 1
                set_speed_mult = math.max(set_speed_mult,inst.TargetSpeedMultiplier)
            end

            inst.components.locomotor:SetExternalSpeedMultiplier(inst,"AccelerateTask",set_speed_mult)
        else
            -- inst.components.locomotor.walkspeed = speed_v0
            -- inst.components.locomotor.runspeed = speed_v0
            inst.components.locomotor:SetExternalSpeedMultiplier(inst,"AccelerateTask",1)
        end 
    end)

    return inst
end

local function fxfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOBLOCK")
    inst:AddTag("NOCLICK")

    local anims = {
        "fire_a_fx","fire_b_fx","fire_c_fx"
    }

    inst.AnimState:SetBank("tz_book_surpassing")
    inst.AnimState:SetBuild("tz_book_surpassing")
    inst.AnimState:PlayAnimation(anims[math.random(1,#anims)])

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    inst:ListenForEvent("animover",inst.Remove)

    return inst
end

return Prefab("tz_book_surpassing", fn, assets),Prefab("tz_book_surpassing_fx",fxfn,assets)