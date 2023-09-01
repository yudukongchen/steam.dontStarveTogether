local SPARKLE_TEXTURE = "fx/smoke.tex" --resolvefilepath("fx/ly_lightningsheet.tex") 

local ADD_SHADER = "shaders/vfx_particle_add.ksh"

local COLOUR_ENVELOPE_NAME = "tz_fanta_blade_stream_vfx_colourenvelope"
local SCALE_ENVELOPE_NAME = "tz_fanta_blade_stream_vfx_scaleenvelope"


local assets =
{
    Asset("IMAGE", SPARKLE_TEXTURE),
    Asset("SHADER", ADD_SHADER),
}

--------------------------------------------------------------------------

local function IntColour(r, g, b, a)
    return { r / 255, g / 255, b / 255, a / 255 }
end

local function InitEnvelope()
    -- local envs = {}
    -- table.insert(envs, { 0, IntColour(25, 40, 170, 255) })
    -- table.insert(envs, { 0.75, IntColour(0, 40, 170, 125) })
    -- table.insert(envs, { 1, IntColour(0, 40, 170, 0) })
    local envs = {}
    local t = 0
    local step = .15
    while t + step + .01 < 1 do
        table.insert(envs, { t, IntColour(255, 255, 150, 255) })
        t = t + step
        table.insert(envs, { t, IntColour(255, 255, 150, 0) })
        t = t + .01
    end
    table.insert(envs, { 1, IntColour(255, 255, 150, 0) })

    EnvelopeManager:AddColourEnvelope(COLOUR_ENVELOPE_NAME, envs)

    local sparkle_max_scale = 0.45
    EnvelopeManager:AddVector2Envelope(
        SCALE_ENVELOPE_NAME,
        {
            { 0,    { sparkle_max_scale, sparkle_max_scale } },
            -- { 0.8,    { sparkle_max_scale * .5, sparkle_max_scale * .5 } },
            { 1,    { sparkle_max_scale * .5, sparkle_max_scale * .5 } },
        }
    )

    InitEnvelope = nil
    IntColour = nil
end

--------------------------------------------------------------------------
local MAX_LIFETIME = 0.66

local function emit_hop_fn(inst, sphere_emitter)
    local effect = inst.VFXEffect
    -- local mypos = inst:GetPosition()
    --pos_tab = pos_tab or {Vector3(0,0,0)}
    local parent = inst.entity:GetParent()
    local roa = parent.Transform:GetRotation() * DEGREES

    for i=0,1,1/inst.NUM:value() do 
        local current_height = inst.HIEGHT:value() * i
        local param = inst.TAIL_LENGTH:value() / (inst.HIEGHT:value() * inst.HIEGHT:value())
        local current_length = param * current_height * current_height
        local offset = Vector3(current_length * math.cos(roa + PI),current_height,-current_length * math.sin(roa + PI))

        local vx, vy, vz = .012 * UnitRand(), 0, .012 * UnitRand()
        local lifetime = MAX_LIFETIME * (.7 + UnitRand() * .3) * (inst.HIEGHT:value() - offset.y) / inst.HIEGHT:value()
        local px, py, pz = sphere_emitter()

        local angle = math.random() * 360    
        local uv_offset = math.random(0, 3) * .25
        local ang_vel = (UnitRand() - 1) * 5
        effect:AddRotatingParticleUV(
            0,
            lifetime,           -- lifetime
            px + offset.x, py + offset.y , pz + offset.z,         -- position
            vx, vy, vz,         -- velocity
            angle, ang_vel,     -- angle, angular_velocity
            uv_offset, 0        -- uv offset
        )
    end
end

local function emit_multithrust_fn(inst, sphere_emitter)
    local effect = inst.VFXEffect
    for i=0,1,1/inst.NUM:value() do
        local vx, vy, vz = .012 * UnitRand(), 0, .012 * UnitRand()
        local lifetime = 0.1 + MAX_LIFETIME * (.7 + UnitRand() * .3)
        local px, py, pz = sphere_emitter()

        local angle = math.random() * 360    
        local uv_offset = math.random(0, 3) * .25
        local ang_vel = (UnitRand() - 1) * 5
        effect:AddRotatingParticleUV(
            0,
            lifetime,           -- lifetime
            px, py + inst.HIEGHT:value(), pz,         -- position
            vx, vy, vz,         -- velocity
            angle, ang_vel,     -- angle, angular_velocity
            uv_offset, 0        -- uv offset
        )
    end
end

local function emit_followfx_fn(inst, sphere_emitter)
    local effect = inst.VFXEffect
    for i=0,1,1/inst.NUM:value() do
        local vx, vy, vz = .012 * UnitRand(), 0, .012 * UnitRand()
        local lifetime = MAX_LIFETIME * (.7 + UnitRand() * .3)
        local px, py, pz = sphere_emitter()

        local angle = math.random() * 360    
        local uv_offset = math.random(0, 3) * .25
        local ang_vel = (UnitRand() - 1) * 5
        effect:AddRotatingParticleUV(
            0,
            lifetime,           -- lifetime
            px, py + inst.HIEGHT:value(), pz,         -- position
            vx, vy, vz,         -- velocity
            angle, ang_vel,     -- angle, angular_velocity
            uv_offset, 0        -- uv offset
        )
    end
end


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.entity:SetPristine()

    inst.HIEGHT = net_float(inst.GUID, "inst.HIEGHT") 
    inst.TAIL_LENGTH = net_float(inst.GUID, "inst.TAIL_LENGTH") 
    inst.NUM = net_ushortint(inst.GUID, "inst.NUM") 
    inst.TYPE = net_string(inst.GUID, "inst.TYPE")

    inst.HIEGHT:set(2.5)
    inst.TAIL_LENGTH:set(1)
    inst.NUM:set(30)
    inst.TYPE:set("hop")

    inst.persists = false

    --Dedicated server does not need to spawn local particle fx
    if TheNet:IsDedicated() then
        return inst
    elseif InitEnvelope ~= nil then
        InitEnvelope()
    end

    local effect = inst.entity:AddVFXEffect()
    effect:InitEmitters(1)

    --SPARKLE
    effect:SetRenderResources(0, SPARKLE_TEXTURE, ADD_SHADER)
    effect:SetRotationStatus(0, true)
    effect:SetUVFrameSize(0, .25, 1)
    effect:SetMaxNumParticles(0, 512)
    effect:SetMaxLifetime(0, MAX_LIFETIME + 3)
    effect:SetColourEnvelope(0, COLOUR_ENVELOPE_NAME)
    effect:SetScaleEnvelope(0, SCALE_ENVELOPE_NAME)
    effect:SetBlendMode(0, BLENDMODE.Additive)
    effect:EnableBloomPass(0, true)
    effect:SetSortOrder(0, 0)
    effect:SetSortOffset(0, 2)

    local tick_time = TheSim:GetTickTime()
    local sparkle_desired_pps_low = 10
    local sparkle_desired_pps_high = 20
    local low_per_tick = sparkle_desired_pps_low * tick_time
    local high_per_tick = sparkle_desired_pps_high * tick_time
    local num_to_emit = 0
    local sphere_emitter = CreateSphereEmitter(.0001)
    inst.last_pos = inst:GetPosition()

    EmitterManager:AddEmitter(inst, nil, function()
        local dist_moved = inst:GetPosition() - inst.last_pos
        local move = dist_moved:Length()
        move = math.clamp(move*6, 0, 1)

        local per_tick = Lerp(low_per_tick, high_per_tick, move)

        inst.last_pos = inst:GetPosition()


        num_to_emit = num_to_emit + per_tick * 3
        while num_to_emit > 1 do
            if inst.TYPE:value() == "hop" then 
                emit_hop_fn(inst,sphere_emitter)
            elseif inst.TYPE:value() == "multithrust" then 
                emit_multithrust_fn(inst,sphere_emitter)
            elseif inst.TYPE:value() == "followfx" then 
                emit_followfx_fn(inst,sphere_emitter)
            end
            num_to_emit = num_to_emit - 1
        end
    end)

    return inst
end

return Prefab("tz_fanta_blade_stream_vfx", fn, assets)

