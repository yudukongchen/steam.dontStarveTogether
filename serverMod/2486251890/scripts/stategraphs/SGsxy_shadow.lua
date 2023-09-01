require("stategraphs/commonstates")

local function DoSwarmAttack(inst)
    inst.components.combat:SetDefaultDamage(20)
    inst.components.health:DoDelta(5, nil, "shadowatk", true, inst, true) 
    inst.components.combat:DoAreaAttack(inst, 6, nil, nil, nil, { "INLIMBO", "notarget", "invisible", "noattack", "flight", "playerghost", "player", "glommer", "chester", "shadow_ly", "shadow_ly2" })
end

local function DoSwarmFX(inst)
    local fx = SpawnPrefab("shadow_bishop_fx")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx.Transform:SetScale(inst.Transform:GetScale())
end

local actionhandlers =
{    

}

local events =
{

}

local states =
{
    State{
        name = "portal_jumpout",
        tags = { "busy", "nopredict", "nomorph", "noattack", "nointerrupt" },

        onenter = function(inst, dest)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("wortox_portal_jumpout")

            inst.sg:SetTimeout(14 * FRAMES)
        end,

        timeline =
        {
            TimeEvent(FRAMES, function(inst)
                  local fx = SpawnPrefab("wortox_portal_jumpout_fx")
                  fx.Transform:SetPosition(inst.Transform:GetWorldPosition())

                  inst.SoundEmitter:PlaySound("dontstarve/characters/wortox/soul/hop_out")
            end),

            TimeEvent(7 * FRAMES, function(inst)
                inst.components.health:SetInvincible(false)
                inst.sg:RemoveStateTag("noattack")
                inst.SoundEmitter:PlaySound("dontstarve/movement/bodyfall_dirt")
            end),
        },

        ontimeout = function(inst)
            inst.sg:GoToState("idle", true)
        end,

        onexit = function(inst)
            inst.components.health:SetInvincible(false)
        end,
    },

    State{
        name = "attack_shadow",
        tags = { "attack", "busy", "shadowatk" },

        onenter = function(inst, target)
            if target ~= nil and target:IsValid() then
                inst.sg.statemem.target = target
                inst.sg.statemem.targetpos = target:GetPosition()
            end
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.Transform:SetScale(1.5, 1.5, 1.5)

            DoSwarmFX(inst)

            inst.AnimState:SetBank("shadow_bishop")
            inst.AnimState:SetBuild("shadow_bishop")
            inst.AnimState:PlayAnimation("atk_side_pre")
        end,

        onupdate = function(inst)
            if inst.sg.statemem.target ~= nil then
                if inst.sg.statemem.target:IsValid() then
                    inst.sg.statemem.targetpos = inst.sg.statemem.target:GetPosition()
                else
                    inst.sg.statemem.target = nil
                end
            end
        end,

        timeline =
        {
            TimeEvent(8 * FRAMES, function(inst)
                inst.sg:AddStateTag("noattack")
                inst.components.health:SetInvincible(true)
                inst.SoundEmitter:PlaySound("dontstarve/sanity/bishop/attack_1", "attack")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg.statemem.attack = true
                    inst.sg:GoToState("attack_shadow_loop", { target = inst.sg.statemem.target, targetpos = inst.sg.statemem.targetpos })
                end
            end),
        },

        onexit = function(inst)
            if not inst.sg.statemem.attack then
                inst.SoundEmitter:KillSound("attack")
            end

            inst.components.health:SetInvincible(false)
        end,
    },

    State{
        name = "attack_shadow_loop",
        tags = { "attack", "busy", "noattack", "shadowatk" },

        onenter = function(inst, data)
            inst.components.health:SetInvincible(true)
            if data.targetpos ~= nil then
                inst.Physics:Teleport(data.targetpos:Get())
                if data.target ~= nil and data.target:IsValid() then
                    local scale = inst.Transform:GetScale()
                    inst.sg.statemem.speed = 2 / scale
                    inst.sg.statemem.target = data.target
                    if inst:IsNear(data.target, .5) then
                        inst.Physics:Stop()
                    else
                        inst:ForceFacePoint(data.target.Transform:GetWorldPosition())
                        inst.Physics:SetMotorVel(inst.sg.statemem.speed, 0, 0)
                    end
                end
            end
            inst.AnimState:PlayAnimation("atk_side_loop_pre")

            inst.sg.statemem.task = inst:DoPeriodicTask(TUNING.SHADOW_BISHOP.ATTACK_TICK, DoSwarmAttack, TUNING.SHADOW_BISHOP.ATTACK_START_TICK)
            inst.sg.statemem.fxtask = inst:DoPeriodicTask(1.2, DoSwarmFX, .5)

            inst.sg:SetTimeout(130 * FRAMES)
        end,

        onupdate = function(inst)
            if inst.sg.statemem.target ~= nil then
                if not inst.sg.statemem.target:IsValid() then
                    inst.sg.statemem.target = nil
                elseif inst:IsNear(inst.sg.statemem.target, .5) then
                    inst.Physics:Stop()
                else
                    inst:ForceFacePoint(inst.sg.statemem.target.Transform:GetWorldPosition())
                    inst.Physics:SetMotorVel(inst.sg.statemem.speed, 0, 0)
                end
            end
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() and inst.AnimState:IsCurrentAnimation("atk_side_loop_pre") then
                    inst.AnimState:PlayAnimation("atk_side_loop", true)
                end
            end),
        },

        ontimeout = function(inst)
            inst.sg.statemem.attack = true
            inst.sg:GoToState("attack_shadow_loop_pst", inst.sg.statemem.target)
        end,

        onexit = function(inst)
            inst.sg.statemem.task:Cancel()
            inst.sg.statemem.fxtask:Cancel() 

            inst.components.health:SetInvincible(false)
            print("取消无敌")

            if not inst.sg.statemem.attack then
                inst.SoundEmitter:KillSound("attack")
            end
        end,
    },

    State{
        name = "attack_shadow_loop_pst",
        tags = { "attack", "busy", "noattack", "shadowatk" },

        onenter = function(inst, target)
            inst.sg.statemem.target = target
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("atk_side_loop_pst")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    local pos = inst.sg.statemem.target ~= nil and inst.sg.statemem.target:IsValid() and inst.sg.statemem.target:GetPosition() or inst:GetPosition()
                    local bestoffset = nil
                    local minplayerdistsq = math.huge
                    for i = 1, 4 do
                        local offset = FindWalkableOffset(pos, math.random() * 2 * PI, 8 + math.random() * 2, 4, false, true)
                        if offset ~= nil then
                            local player, distsq = FindClosestPlayerInRange(pos.x + offset.x, 0, pos.z + offset.z, 6, true)
                            if player == nil then
                                bestoffset = offset
                                break
                            elseif distsq < minplayerdistsq then
                                bestoffset = offset
                                minplayerdistsq = distsq
                            end
                        end
                    end
                    if bestoffset ~= nil then
                        inst.Physics:Teleport(pos.x + bestoffset.x, 0, pos.z + bestoffset.z)
                    end
                    inst.sg.statemem.attack = true
                    inst.sg:GoToState("portal_jumpout")
                end
            end),
        },

        onexit = function(inst)
            inst.AnimState:SetBank("wilson")
            inst.AnimState:SetBuild("ly_follower")
            inst.Transform:SetScale(1, 1, 1)
            inst.components.health:SetInvincible(false)
            inst.SoundEmitter:KillSound("attack")

            inst:SetStateGraph("SGwilson")
            print("取消无敌")
        end,
    },

    State{
        name = "jumpout",
        tags = { "busy", "canrotate", "jumping" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("jumpout")
            inst.Physics:SetMotorVel(4, 0, 0)
            inst.Physics:ClearCollisionMask()
            inst.Physics:CollidesWith(COLLISION.GROUND)
            inst.components.health:SetInvincible(false)
        end,

        timeline =
        {
            TimeEvent(10 * FRAMES, function(inst)
                inst.Physics:SetMotorVel(3, 0, 0)
            end),
            TimeEvent(15 * FRAMES, function(inst)
                inst.Physics:SetMotorVel(2, 0, 0)
            end),
            TimeEvent(15.2 * FRAMES, function(inst)
                inst.sg.statemem.physicson = true
                inst.Physics:ClearCollisionMask()
                inst.Physics:CollidesWith(COLLISION.WORLD)
                inst.Physics:CollidesWith(COLLISION.CHARACTERS)
                inst.Physics:CollidesWith(COLLISION.GIANTS)
            end),
            TimeEvent(17 * FRAMES, function(inst)
                inst.Physics:SetMotorVel(1, 0, 0)
            end),
            TimeEvent(18 * FRAMES, function(inst)
                inst.Physics:Stop()
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if not inst.sg.statemem.physicson then
                inst.Physics:ClearCollisionMask()
                inst.Physics:CollidesWith(COLLISION.WORLD)
                inst.Physics:CollidesWith(COLLISION.CHARACTERS)
                inst.Physics:CollidesWith(COLLISION.GIANTS)
            end
            inst:SetStateGraph("SGwilson")
            inst.components.health:SetInvincible(false)
        end,
    },
}

return StateGraph("SGsxy_shadow", states, events, "portal_jumpout", actionhandlers)
