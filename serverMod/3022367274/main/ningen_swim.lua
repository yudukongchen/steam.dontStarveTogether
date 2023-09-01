setmetatable(
    env,
    {
        __index = function(t, k)
            return GLOBAL.rawget(GLOBAL, k)
        end
    }
)

local jumpdur = 20

-- Floaters aka Ripple effects
local function AddFloaters(inst)
    if not inst.floater1 and not inst.floater2 then
        inst.floater1 = inst:SpawnChild('ne_float_fx_front2')
        inst.floater2 = inst:SpawnChild('ne_float_fx_back2')
        inst.floater1.Transform:SetPosition(0, .6, 0)
        inst.floater2.Transform:SetPosition(0, .6, 0)
    else
        inst.floater1:Show()
        inst.floater2:Show()
    end
end

-- Adds things to the player after initialization
AddPlayerPostInit(
    function(inst)
        if inst.prefab == 'ningen' then
            inst:ListenForEvent('addRippleFx', AddFloaters)
        end
    end
)

AddModRPCHandler(
    'NingEn',
    'NingEnHop',
    function(inst, _x, _z)
        if not inst.sg:HasStateTag('jumping') then
            inst:PushEvent('onhop', {x = _x, z = _z})
        end
    end
)

local function UpdateEmbarkingPos(inst, dt)
    if inst.last_embark_x and inst.last_embark_z then
        inst.components.locomotor:SetAllowPlatformHopping(true)
        local embark_x, embark_z = inst.last_embark_x, inst.last_embark_z

        local my_x, my_y, my_z = inst.Transform:GetWorldPosition()
        local delta_x, delta_z = embark_x - my_x, embark_z - my_z
        local delta_dist = VecUtil_Length(delta_x, delta_z)
        local travel_dist = inst.components.embarker.embark_speed * dt

        if delta_dist < travel_dist then
            inst:PushEvent('done_ningen_movement')
            inst.Physics:TeleportRespectingInterpolation(embark_x, 0, embark_z)
        else
            inst.Physics:SetMotorVel(inst.components.embarker.embark_speed, 0, 0)
        end

        if not TheWorld.ismastersim then
            SendModRPCToServer(MOD_RPC['NingEn']['NingEnHop'], inst.last_embark_x, inst.last_embark_z)
        end
    end
end

local function OnWater(inst)
    return inst:HasTag('swimming') and inst:HasTag('jump_swim')
end

local function ClearFloaters(inst)
    if inst.floater1 or inst.floater2 then
        inst.floater1:Hide()
        inst.floater2:Hide()
    end
end

local function AddRipple(inst)
    if OnWater(inst) and TheWorld.ismastersim then
        local wake = SpawnPrefab('wake_small')
        local rotation = inst.Transform:GetRotation()

        local theta = rotation * DEGREES
        local offset = Vector3(math.cos(theta), 0, -math.sin(theta))
        local pos = Vector3(inst.Transform:GetWorldPosition()) + offset
        wake.Transform:SetPosition(pos.x, pos.y + .6, pos.z)
        wake.Transform:SetScale(1.2, 1.2, 1.2)

        wake.Transform:SetRotation(rotation - 90)
        inst.SoundEmitter:PlaySound('turnoftides/common/together/water/splash/jump_small', nil, .25)
    end
end

local function SpawnFX(inst, fx)
    local x, y, z = inst.Transform:GetWorldPosition()
    SpawnPrefab(fx).Transform:SetPosition(x, y + .6 - 0.1, z)
end

local function Onenter_or_exitocean(inst)
    if inst:HasTag('playerghost') then
        inst.AnimState:SetBuild('ghost_ningen_build')
        inst.AnimState:SetBank('ghost')
        ClearFloaters(inst)
    else
        if inst.components.skinner and inst:HasTag('jump_swim') then
            inst.components.skinner:SetSkinMode('swimming_skin')
        elseif inst.components.skinner then
            inst.components.skinner:SetSkinMode('normal_skin')
        end
    end
end

--NingEn states, Changes ningen's animation on water
local function NingEnStates(sg)
    local dismount = sg.states['mount']
    if dismount then
        local old_dismount_onenter = dismount.onenter
        dismount.onenter = function(inst, ...)
            if inst:HasTag('ningen') then
                inst:PushEvent('ningenMount')
                old_dismount_onenter(inst, ...)
            else
                old_dismount_onenter(inst, ...)
            end
        end
    end
    local mine = sg.states['mine']
    if mine then
        local old_mine_onenter = mine.onenter
        mine.onenter = function(inst, ...)
            if inst:HasTag('ningen') and OnWater(inst) then
                if inst.components.skinner then
                    inst.components.skinner:SetSkinMode('normal_skin')
                end
                ClearFloaters(inst)
                old_mine_onenter(inst, ...)
            else
                old_mine_onenter(inst, ...)
            end
        end
    end
    local idle = sg.states['idle']
    if idle then
        local old_idle_onenter = idle.onenter
        idle.onenter = function(inst, ...)
            if inst:HasTag('ningen') and OnWater(inst) then
                inst:PushEvent('addRippleFx')
                if inst.components.skinner then
                    inst.components.skinner:SetSkinMode('swimming_skin')
                end
                inst.DynamicShadow:Enable(false)
                old_idle_onenter(inst, ...)
            else
                -- ClearFloaters(inst)
                old_idle_onenter(inst, ...)
            end
        end
    end

    local strum = sg.states['play_strum']
    if strum then
        local old_strum = strum.onenter
        strum.onenter = function(inst, ...)
            if inst:HasTag('ningen') and OnWater(inst) then
                inst:DoTaskInTime(
                    0.3,
                    function()
                        if inst.components.skinner then
                            inst.components.skinner:SetSkinMode('normal_skin')
                        end
                        SpawnFX(inst, 'splash')
                        ClearFloaters(inst)
                    end
                )
                old_strum(inst, ...)
                inst:DoTaskInTime(
                    0.7,
                    function()
                        if inst.components.skinner then
                            inst.components.skinner:SetSkinMode('swimming_skin')
                        end
                        SpawnFX(inst, 'splash_green_small')
                        inst:PushEvent('addRippleFx')
                    end
                )
            else
                old_strum(inst, ...)
            end
        end
    end

    local run_start = sg.states['run_start']
    if run_start then
        local old_run_start_onenter = run_start.onenter
        run_start.onenter = function(inst, ...)
            if inst:HasTag('ningen') and OnWater(inst) then
                inst.components.locomotor:RunForward()
                inst.AnimState:PlayAnimation('careful_walk_pre')
                inst.sg.mem.footsteps = 0
                inst:PushEvent('addRippleFx')
            else
                old_run_start_onenter(inst, ...)
                ClearFloaters(inst)
            end
        end
    end

    local run = sg.states['run']
    if run then
        local old_run_onenter = run.onenter

        run.onenter = function(inst, ...)
            if inst:HasTag('ningen') and OnWater(inst) then
                inst.components.locomotor:RunForward()
                if not inst.AnimState:IsCurrentAnimation('careful_walk') then
                    inst.AnimState:PlayAnimation('careful_walk', true)
                end
                inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())
                AddRipple(inst)
                inst:PushEvent('addRippleFx')
            else
                old_run_onenter(inst, ...)
            end
        end
    end

    local run_stop = sg.states['run_stop']
    if run_stop then
        local old_run_stop_onenter = run_stop.onenter
        run_stop.onenter = function(inst, ...)
            if inst:HasTag('ningen') and OnWater(inst) then
                inst.components.locomotor:Stop()
                inst.AnimState:PlayAnimation('careful_walk_pst')
                inst:PushEvent('addRippleFx')
            else
                old_run_stop_onenter(inst, ...)
            end
        end
    end

    local hop_pre = sg.states['hop_pre']
    if hop_pre then
        local old_hop_pre_onenter = hop_pre.onenter
        hop_pre.onenter = function(inst, ...)
            if inst:HasTag('ningen') then
                -- print("hop_pre")
                if TheWorld.ismastersim and inst:HasTag('swimming') and inst:HasTag('jump_swim') then
                    SpawnFX(inst, 'splash_green')
                end
                inst:RemoveTag('insomniac')
                inst:RemoveTag('jump_swim')
                inst:RemoveTag('swimming')
                Onenter_or_exitocean(inst)
                if inst.components.locomotor then
                    inst.components.locomotor:SetExternalSpeedMultiplier(inst, 'ningen_swim_speed', 1.0)
                end
                ClearFloaters(inst)
                inst.DynamicShadow:Enable(true)
                inst.components.locomotor:SetAllowPlatformHopping(true)
                -------------------------------------------------------------------------------------------------------
                local embark_x, embark_z = inst.components.embarker:GetEmbarkPosition()
                inst:ForceFacePoint(embark_x, 0, embark_z)
                inst.sg.statemem.not_interrupted = true
                inst.sg:GoToState('hop_loop', inst.sg.statemem.queued_post_land_state)
            else
                old_hop_pre_onenter(inst, ...)
            end
        end
    end

    local onhop = sg.events['onhop']
    if onhop then
        local old_onhop_fn = onhop.fn
        onhop.fn = function(inst, data, ...)
            if
                inst:HasTag('ningen') and inst._ningen_swimmer:value() and
                    (inst.components.embarker and not inst.components.embarker:HasDestination())
             then
                if TheWorld:HasTag('cave') then
                    return
                end
                if
                    (inst.components.health == nil or not inst.components.health:IsDead()) and
                        (inst.sg:HasStateTag('moving') or inst.sg:HasStateTag('idle'))
                 then
                    if not inst.sg:HasStateTag('jumping') then
                        inst.sg:GoToState('ningen_hop_pre', data)
                    end
                elseif inst.components.embarker then
                    inst.components.embarker:Cancel()
                end
            else
                return old_onhop_fn(inst, data, ...)
            end
        end
    end
end

local function NingEnPreHop()
    local hopState =
        State {
        name = 'ningen_hop_pre',
        tags = {'doing', 'nointerrupt', 'busy', 'jumping', 'nomorph', 'nosleep'},
        onenter = function(inst, data)
            inst:AddTag('jump_swim')
            if data then
                inst.last_embark_x, inst.last_embark_z = data.x, data.z
                inst:ForceFacePoint(data.x, 0, data.z)
            else
                inst.last_embark_x, inst.last_embark_z = nil, nil
            end
            local x, y, z = inst.Transform:GetWorldPosition()
            inst._onplatform_ = (TheWorld.Map:GetPlatformAtPoint(x, z) ~= nil)
            ClearFloaters(inst)
            if inst.components.skinner then
                inst.components.skinner:SetSkinMode('normal_skin')
            end
            inst.components.locomotor:Stop()
            inst.sg.statemem.swimming = inst:HasTag('swimming')
            inst.AnimState:PlayAnimation('jump', false)
            inst.AnimState:PushAnimation('jump_loop', false)
            inst.DynamicShadow:Enable(true)
            inst.sg.statemem.collisionmask = inst.Physics:GetCollisionMask()
            inst.Physics:SetCollisionMask(COLLISION.GROUND)
            if not TheWorld.ismastersim then
                inst.Physics:SetLocalCollisionMask(COLLISION.GROUND)
            end

            inst.sg:SetTimeout(jumpdur * FRAMES)

            if inst.components.embarker:HasDestination() then
                inst.components.embarker:StartMoving()
            end
        end,
        onupdate = function(inst, dt)
            if not inst.components.embarker:HasDestination() then
                UpdateEmbarkingPos(inst, dt)
            end
            if inst.components.embarker:HasDestination() then
                if inst.sg.statemem.embarked then
                    inst.components.embarker:Embark()
                    inst.sg:GoToState(
                        'ningen_hop_post',
                        {land_in_water = false, collisionmask = inst.sg.statemem.collisionmask}
                    )
                end
            elseif inst.sg.statemem.swimming == TheWorld.Map:IsVisualGroundAtPoint(inst.Transform:GetWorldPosition()) then
                if inst.sg.statemem.ningen_jump then
                    inst.components.locomotor:FinishHopping()
                    local x, y, z = inst.Transform:GetWorldPosition()
                    inst.sg:GoToState(
                        'ningen_hop_post',
                        {
                            land_in_water = (not TheWorld.Map:IsVisualGroundAtPoint(x, y, z) and
                                TheWorld.Map:GetPlatformAtPoint(x, z) == nil),
                            collisionmask = inst.sg.statemem.collisionmask
                        }
                    )
                end
            end
        end,
        timeline = {
            TimeEvent(
                0,
                function(inst)
                    if inst:HasTag('swimming') and TheWorld.ismastersim then
                        SpawnFX(inst, 'splash_green')
                        ClearFloaters(inst)
                    end
                end
            )
        },
        ontimeout = function(inst)
            inst.sg.statemem.timeout = true
            inst.components.locomotor:FinishHopping()
            inst.components.embarker:Cancel()
            local x, y, z = inst.Transform:GetWorldPosition()
            inst.sg:GoToState(
                'ningen_hop_post',
                {
                    land_in_water = (not TheWorld.Map:IsVisualGroundAtPoint(x, y, z) and
                        TheWorld.Map:GetPlatformAtPoint(x, z) == nil),
                    collisionmask = inst.sg.statemem.collisionmask
                }
            )
        end,
        events = {
            EventHandler(
                'done_embark_movement',
                function(inst)
                    inst.sg.statemem.embarked = true
                end
            ),
            EventHandler(
                'done_ningen_movement',
                function(inst)
                    inst.sg.statemem.ningen_jump = true
                end
            )
            -- EventHandler("animover", function(inst)

            -- end),
        },
        onexit = function(inst)
            if not (inst.sg.statemem.embarked or inst.sg.statemem.ningen_jump) then
                inst.components.embarker:Cancel()
                inst.components.locomotor:FinishHopping()
            end
            inst.Physics:ClearLocalCollisionMask()
            if inst.sg.statemem.collisionmask ~= nil then
                inst.Physics:SetCollisionMask(inst.sg.statemem.collisionmask)
            end
            if inst.components.locomotor.isrunning then
                inst:PushEvent('locomote')
            end
        end
    }
    return hopState
end

local function NingEnPostHop()
    local state =
        State {
        name = 'ningen_hop_post',
        tags = {'busy', 'jumping', 'nopredict'},
        onenter = function(inst, data)
            inst.Physics:Stop()
            inst.sg.statemem.collisionmask = data.collisionmask and data.collisionmask or nil
            if data.land_in_water then
                inst:AddTag('insomniac')
                inst:AddTag('swimming')
                Onenter_or_exitocean(inst)
                if inst.components.locomotor then
                    inst.components.locomotor:SetExternalSpeedMultiplier(inst, 'ningen_swim_speed', 1.2)
                end
                inst.DynamicShadow:Enable(false)
                if inst.components.leader and inst.components.leader:CountFollowers('killer_whale') > 0 then
                    for k, v in pairs(inst.components.leader.followers) do
                        if k:HasTag('killer_whale') then
                            k.components.timer:StopTimer('masteronland')
                        end
                    end
                end
            else
                inst:RemoveTag('insomniac')
                inst:RemoveTag('jump_swim')
                inst:RemoveTag('swimming')
                Onenter_or_exitocean(inst)
                if inst.components.locomotor then
                    inst.components.locomotor:SetExternalSpeedMultiplier(inst, 'ningen_swim_speed', 1.0)
                end
                ClearFloaters(inst)
                inst.DynamicShadow:Enable(true)
                if inst.components.leader and inst.components.leader:CountFollowers('killer_whale') > 0 then
                    for k, v in pairs(inst.components.leader.followers) do
                        if k:HasTag('killer_whale') then
                            k.components.timer:StartTimer('masteronland', 20)
                        end
                    end
                end
            end
            inst.AnimState:PlayAnimation('boat_jump_pst', false)
            inst.sg:SetTimeout(4 * FRAMES)
        end,
        timeline = {
            TimeEvent(
                5 * FRAMES,
                function(inst)
                    if inst:HasTag('swimming') and TheWorld.ismastersim then
                        SpawnFX(inst, 'splash_green')
                        inst:PushEvent('addRippleFx')
                    end
                end
            )
        },
        ontimeout = function(inst)
            inst.sg.statemem.timeout = true
        end,
        events = {
            EventHandler(
                'animover',
                function(inst)
                    if inst.AnimState:AnimDone() then
                        inst.sg:GoToState('hop_pst_complete')
                    end
                end
            )
        },
        onexit = function(inst)
        end
    }
    return state
end

-- Server
AddStategraphPostInit(
    'wilson',
    function(sg)
        NingEnStates(sg)
    end
)

AddStategraphState('wilson', NingEnPreHop())

AddStategraphState('wilson', NingEnPostHop())

-- Client
AddStategraphPostInit(
    'wilson_client',
    function(sg)
        NingEnStates(sg)
    end
)

AddStategraphState('wilson_client', NingEnPreHop())

AddStategraphState('wilson_client', NingEnPostHop())
