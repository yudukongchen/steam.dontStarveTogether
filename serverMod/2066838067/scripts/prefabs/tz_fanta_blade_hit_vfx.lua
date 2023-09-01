local ANIM_SMOKE_TEXTURE = "fx/animsmoke.tex"
local EMBER_TEXTURE = "fx/spark.tex"
local SPARK_TEXTURE = "fx/sparkle.tex"

local ADD_SHADER = "shaders/vfx_particle_add.ksh"
local REVEAL_SHADER = "shaders/vfx_particle_reveal.ksh"

local COLOUR_ENVELOPE_NAME_EMBER = "tz_fanta_blade_hit_vfx_colourenvelope_ember"
local SCALE_ENVELOPE_NAME_EMBER = "tz_fanta_blade_hit_vfx_scaleenvelope_ember"
local COLOUR_ENVELOPE_NAME_SPARK = "tz_fanta_blade_hit_vfx_colourenvelope_spark"
local SCALE_ENVELOPE_NAME_SPARK = "tz_fanta_blade_hit_vfx_scaleenvelope_spark"


local assets =
{
    Asset("IMAGE", ANIM_SMOKE_TEXTURE),
    Asset("IMAGE", EMBER_TEXTURE),
    Asset("IMAGE", SPARK_TEXTURE),
    Asset("SHADER", REVEAL_SHADER),
    Asset("SHADER", ADD_SHADER),
}

--------------------------------------------------------------------------

local function IntColour(r, g, b, a)
    return { r / 255, g / 255, b / 255, a / 255 }
end

local function InitEnvelope()

    EnvelopeManager:AddColourEnvelope(
        COLOUR_ENVELOPE_NAME_SPARK,
        {
            { 0,    IntColour(255, 255, 255, 255) },
            { .1,   IntColour(255, 253, 245, 255) },
            { .6,   IntColour(255, 226, 110, 255) },
            { 1,    IntColour(0, 0, 0, 0) },
        }
    )
    local spark_max_scale = 2.25
    EnvelopeManager:AddVector2Envelope(
        SCALE_ENVELOPE_NAME_SPARK,
        {
            { 0,    { spark_max_scale, spark_max_scale } },
            { 0.7,  { spark_max_scale * 0.7, spark_max_scale * 0.7 } },
            { 1,    { spark_max_scale * 0.1, spark_max_scale * 0.1 } },
        }
    )



    EnvelopeManager:AddColourEnvelope(
        COLOUR_ENVELOPE_NAME_EMBER,
        {
            { 0,    IntColour(255, 255, 255, 180) },
            { .2,   IntColour(255, 253, 245, 255) },
            { .6,   IntColour(255, 226, 110, 255) },
            { 1,    IntColour(0, 0, 0, 0) },
        }
    )
    local ember_max_scale = 1.7
    EnvelopeManager:AddVector2Envelope(
        SCALE_ENVELOPE_NAME_EMBER,
        {
            { 0,    { ember_max_scale, ember_max_scale } },
            { 1,    { ember_max_scale * 0.1, ember_max_scale * 0.1 } },
        }
    )

    InitEnvelope = nil
    IntColour = nil
end

--------------------------------------------------------------------------

local SPARK_MAX_LIFETIME = .2
local EMBER_MAX_LIFETIME = .6

local function emit_spark_fn(effect, sphere_emitter, adjust_vec)            
    local lifetime = SPARK_MAX_LIFETIME * (0.7 + math.random() * .3)
    local px, py, pz = sphere_emitter()
    if adjust_vec ~= nil then
        px = px + adjust_vec.x
        py = py + adjust_vec.y
        pz = pz + adjust_vec.z
    end

    local ang_vel = 0
    local angle = math.random() * 360
    local uv_offset = math.random(0, 3) * .25

    effect:AddRotatingParticleUV(
        0,
        lifetime,           -- lifetime
        px, py + .4, pz,    -- position
        0, 0, 0,            -- velocity
        angle, ang_vel,     -- angle, angular_velocity
        uv_offset, 0        -- uv offset
    )
end

local function emit_ember_fn(effect, sphere_emitter, adjust_vec, direction)            
    local sz = 0.18
    local vx, vy, vz = sz * UnitRand(), 3*sz * UnitRand(), sz * UnitRand()
    vx = vx + direction.x
    vy = vy + direction.y
    vz = vz + direction.z
    
    local lifetime = EMBER_MAX_LIFETIME * (0.7 + math.random() * .3)
    local px, py, pz = sphere_emitter()
    if adjust_vec ~= nil then
        px = px + adjust_vec.x
        py = py + adjust_vec.y
        pz = pz + adjust_vec.z
    end
    
    local uv_offset = math.random(0, 3) * .25

    effect:AddParticleUV(
        1,
        lifetime,           -- lifetime
        px, py + .4, pz,    -- position
        vx, vy, vz,          -- velocity
        uv_offset, 0        -- uv offset
    )
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst._attacker_x = net_float(inst.GUID,"inst._attacker_x")
    inst._attacker_y = net_float(inst.GUID,"inst._attacker_y")
    inst._attacker_z = net_float(inst.GUID,"inst._attacker_z")
    inst._can_emit = net_bool(inst.GUID,"inst._can_emit")

    inst.entity:SetPristine()

    inst.set_replica_pos = function(inst,x,y,z)
        inst._attacker_x:set(x)
        inst._attacker_y:set(y)
        inst._attacker_z:set(z)
        inst._can_emit:set(true)
    end

    inst.persists = false

    --Dedicated server does not need to spawn local particle fx
    if TheNet:IsDedicated() then
        return inst
    elseif InitEnvelope ~= nil then
        InitEnvelope()
    end

    local effect = inst.entity:AddVFXEffect()
    effect:InitEmitters(2)

    --Sparkle
    effect:SetRenderResources(0, SPARK_TEXTURE, ADD_SHADER)
    effect:SetMaxNumParticles(0, 6)
    effect:SetRotationStatus(0, true)
    effect:SetMaxLifetime(0, SPARK_MAX_LIFETIME)
    effect:SetColourEnvelope(0, COLOUR_ENVELOPE_NAME_SPARK)
    effect:SetScaleEnvelope(0, SCALE_ENVELOPE_NAME_SPARK)
    effect:SetBlendMode(0, BLENDMODE.Additive)
    effect:EnableBloomPass(0, true)
    effect:SetUVFrameSize(0, 0.25, 1)
    effect:SetSortOrder(0, 1)
    effect:SetSortOffset(0, 1)
    effect:SetDragCoefficient(0, .11)

    --EMBER
    effect:SetRenderResources(1, EMBER_TEXTURE, ADD_SHADER)
    effect:SetMaxNumParticles(1, 128)
    effect:SetMaxLifetime(1, EMBER_MAX_LIFETIME)
    effect:SetColourEnvelope(1, COLOUR_ENVELOPE_NAME_EMBER)
    effect:SetScaleEnvelope(1, SCALE_ENVELOPE_NAME_EMBER)
    effect:SetBlendMode(1, BLENDMODE.Additive)
    effect:EnableBloomPass(1, true)
    effect:SetUVFrameSize(1, 0.25, 1)
    effect:SetSortOrder(1, 0)
    effect:SetSortOffset(1, 0)
    effect:SetDragCoefficient(1, .14)
    effect:SetRotateOnVelocity(1, true)
    effect:SetAcceleration(1, 0, -0.3, 0)

    -----------------------------------------------------

    local smoke_sphere_emitter = CreateSphereEmitter(.3)
    local spark_sphere_emitter = CreateSphereEmitter(.03)
    local ember_sphere_emitter = CreateSphereEmitter(.1)


    local num_to_emit_spark = 25
    local num_to_emit_ember = 20

    EmitterManager:AddEmitter(inst, nil, function()
        if inst._can_emit:value() then 
            local mypos = inst:GetPosition()   
            local attacker_pos = Vector3(inst._attacker_x:value(),inst._attacker_y:value(),inst._attacker_z:value())         
            local vec = mypos - attacker_pos

            local adjust_vec = vec:GetNormalized() * -0.05
            local vel = vec:GetNormalized() * 0.33
                    
            while num_to_emit_spark > 0 do
                emit_spark_fn(effect, spark_sphere_emitter, adjust_vec)
                num_to_emit_spark = num_to_emit_spark - 1
            end

            while num_to_emit_ember > 0 do
                emit_ember_fn(effect, ember_sphere_emitter, adjust_vec, vel)
                num_to_emit_ember = num_to_emit_ember - 1
            end

            inst:Remove()
        end 
    end)

    return inst
end

-- local fx = c_findnext("dummytarget"):SpawnChild("tz_fanta_blade_hit_vfx") fx.Transform:SetPosition(0,1,0) fx:set_replica_pos(ThePlayer:GetPosition():Get())
return Prefab("tz_fanta_blade_hit_vfx", fn, assets)
