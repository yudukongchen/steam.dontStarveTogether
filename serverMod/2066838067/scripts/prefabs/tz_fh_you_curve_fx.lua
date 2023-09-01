local ANIM_SMOKE_TEXTURE = "fx/animsmoke.tex"
local EMBER_TEXTURE = "fx/spark.tex"
local SPARK_TEXTURE = "fx/sparkle.tex"

local ADD_SHADER = "shaders/vfx_particle_add.ksh"
local REVEAL_SHADER = "shaders/vfx_particle_reveal.ksh"

local COLOUR_ENVELOPE_NAME_EMBER = "nightsword_curve_colourenvelope_ember"
local SCALE_ENVELOPE_NAME_EMBER = "nightsword_curve_scaleenvelope_ember"


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
local EMBER_MAX_LIFETIME = .6
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
        0,
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

    inst.entity:SetPristine()

    inst.persists = false

    --Dedicated server does not need to spawn local particle fx
    if TheNet:IsDedicated() then
        return inst
    elseif InitEnvelope ~= nil then
        InitEnvelope()
    end

    local effect = inst.entity:AddVFXEffect()
    effect:InitEmitters(1)

    effect:SetRenderResources(0, EMBER_TEXTURE, ADD_SHADER)
    effect:SetMaxNumParticles(0, 128)
    effect:SetMaxLifetime(0, EMBER_MAX_LIFETIME)
    effect:SetColourEnvelope(0, COLOUR_ENVELOPE_NAME_EMBER)
    effect:SetScaleEnvelope(0, SCALE_ENVELOPE_NAME_EMBER)
    effect:SetBlendMode(0, BLENDMODE.Additive)
    effect:EnableBloomPass(0, true)
    effect:SetUVFrameSize(0, 0.25, 1)
    effect:SetSortOrder(0, 0)
    effect:SetSortOffset(0, 0)
    effect:SetDragCoefficient(0, .14)
    effect:SetRotateOnVelocity(0, true)
    effect:SetAcceleration(0, 0, -0.3, 0)

    -----------------------------------------------------

    local burst_state = 0

    local ember_sphere_emitter = CreateSphereEmitter(.1)

    EmitterManager:AddEmitter(inst, nil, function()
        local anim_time = 0.14

        if anim_time > 0.13 and burst_state == 0 then
            burst_state = 1 --do burst
        end
        if burst_state == 1 then
            burst_state = 2 --wait for new atk
            local num_to_emit_ember = 25
            local adjust_vec = nil
            local v = nil
            local dir_scale = 0.35
            local direction = 0
            if direction == 0 then
                v = TheCamera:GetRightVec() * dir_scale
            elseif direction == 1 then
                v = TheCamera:GetDownVec() * -dir_scale
            elseif direction == 2 then
                v = TheCamera:GetRightVec() * -dir_scale
            elseif direction == 3 then
                v = TheCamera:GetDownVec() * dir_scale
            end
            if v ~= nil then
                while num_to_emit_ember > 0 do
                    emit_ember_fn(effect, ember_sphere_emitter, adjust_vec, v)
                    num_to_emit_ember = num_to_emit_ember - 1
                end
            else
                --print("Error: Unexpected facing angle for nightsword_curve_fx.", direction)
            end
        end
    end)

    return inst
end

return Prefab("tz_fh_you_curve_fx", fn, assets)
