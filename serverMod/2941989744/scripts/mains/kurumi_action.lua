GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})  

local KRM_SHOOT = Action({ priority = 20, distance = 10, mount_valid = false })
      KRM_SHOOT.id = "KRM_SHOOT"
      KRM_SHOOT.str = "射击"   
      KRM_SHOOT.fn = function(act)
        if act.doer and act.target then 
              local weapon = act.doer.components.inventory and act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil
              if weapon and weapon:HasTag("krm_gun") then
                  local bullet = weapon.components.container:GetItemInSlot(1)
                  if bullet then
                      weapon.bullet = bullet.prefab

                      bullet.components.stackable:Get():Remove()
                      weapon.components.weapon:LaunchProjectile(act.doer, act.target)
                  else
                      weapon.bullet = nil
                      weapon.components.weapon:LaunchProjectile(act.doer, act.target)                                            
                  end
              end 
        end 
        return true 
    end

AddComponentAction("SCENE", "inspectable" , function(inst, doer, actions, right)
    if right and doer and doer:HasTag("kurumi") and doer.replica.inventory and doer.replica.inventory:GetActiveItem() == nil
    and not (doer.replica.rider and doer.replica.rider:IsRiding()) then

    --if inst ~= doer --and doer.replica.combat:CanTarget(inst) and not doer.replica.combat:IsAlly(inst)
    if doer.replica.inventory:EquipHasTag("krm_gun") and doer.replica.inventory:EquipHasTag("short_gun") then 
        table.insert(actions, ACTIONS.KRM_SHOOT)
    end
    end  
end)

AddAction(KRM_SHOOT) 
AddStategraphActionHandler("wilson",ActionHandler(ACTIONS.KRM_SHOOT, "krm_gun_atk_right"))
AddStategraphActionHandler("wilson_client",ActionHandler(ACTIONS.KRM_SHOOT, "krm_gun_atk_right"))


local KRM_FEED = Action({ priority = 20,mount_valid = true})
KRM_FEED.id = 'KRM_FEED'
KRM_FEED.str = "喂食"
KRM_FEED.fn = function(act)
    if act.invobject and act.target and act.target.prefab == 'krm_meowbag' and act.target.perishrate < 2 then
        act.target:Eat(act.invobject)
        return true
    end
end
AddAction(KRM_FEED)
AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions)
    if inst and (inst.prefab == "eel" or inst:HasTag("fish") or inst:HasTag("oceanfish")) and target:HasTag("krm_meowbag") then
        table.insert(actions, KRM_FEED)
    end
end)
AddStategraphActionHandler("wilson",ActionHandler(KRM_FEED, "give"))
AddStategraphActionHandler("wilson_client",ActionHandler(KRM_FEED, "give"))


local KRM_JUMP = Action({ priority = 99,distance = 12})
KRM_JUMP.id = 'KRM_JUMP'
KRM_JUMP.str = "重击"
KRM_JUMP.fn = function(act)
    local pos = act:GetActionPoint()
    if pos == nil and act.target then
        pos = act.target:GetPosition()
    end
    if act.invobject ~= nil and act.invobject.components.jump_spell ~= nil then
		act.invobject.components.jump_spell:CastSpell(act.doer, pos)
        return true
    end
end
AddAction(KRM_JUMP)
AddComponentAction("EQUIPPED", "jump_spell", function(inst, doer, target, actions, right)
    if right and inst:HasTag("krm_jumpable") and target and not IsEntityDead(target, true) and target.replica.combat ~= nil and target.replica.combat:CanBeAttacked(doer) then
        table.insert(actions, KRM_JUMP)
    end
end)
AddStategraphActionHandler("wilson",ActionHandler(KRM_JUMP, "krm_jump_start"))
AddStategraphActionHandler("wilson_client",ActionHandler(KRM_JUMP, "krm_jump_start"))

AddStategraphState('wilson',
    State{
        name = "krm_jump_start",
        tags = { "aoe", "doing", "busy", "nointerrupt", "nomorph",},

        onenter = function(inst)
            inst.components.locomotor:Stop()
			inst.AnimState:PlayAnimation("atk_leap_pre")
            local buffaction = inst:GetBufferedAction()
            local target = buffaction ~= nil and buffaction.target or nil
            if target and target:IsValid() then
                inst:ForceFacePoint(target.Transform:GetWorldPosition())
            end
        end,
        timeline =
        {
        },
        events =
        {
            EventHandler("jump_gogogo", function(inst, data)
                inst.sg.statemem.supergtt = true
                inst.sg:GoToState("krm_jump", {
                    data = data,
                })
            end),
            EventHandler("animover", function(inst, data)
                if inst.AnimState:AnimDone() then
                    if inst.AnimState:IsCurrentAnimation("atk_leap_pre") then
                        inst.AnimState:PlayAnimation("atk_leap_lag")
                        inst:PerformBufferedAction()
                    else
                        inst.sg:GoToState("idle")
                    end
                end
            end),
        },
    }
)

AddStategraphState('wilson_client',
    State
    {
        name = "krm_jump_start",
        tags = { "doing", "busy", "nointerrupt"},
        server_states = { "krm_jump_start", "krm_jump" },
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("atk_leap_pre")
            inst.AnimState:PlayAnimation("atk_leap_lag", false)

            inst:PerformPreviewBufferedAction()
            inst.sg:SetTimeout(2)
        end,

        onupdate = function(inst)
			if inst.sg:ServerStateMatches() then
                if inst.entity:FlattenMovementPrediction() then
                    inst.sg:GoToState("idle", "noanim")
                end
            elseif inst.bufferedaction == nil then
                inst.sg:GoToState("idle")
            end
        end,

        ontimeout = function(inst)
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle")
        end,
    }
)

local function ToggleOffPhysics(inst)
    inst.sg.statemem.isphysicstoggle = true
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.GROUND)
end

local function ToggleOnPhysics(inst)
    inst.sg.statemem.isphysicstoggle = nil
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:CollidesWith(COLLISION.GIANTS)
end
local function gettargets(x,y,z,range)
    return TheSim:FindEntities(x, y, z, range, {"_combat","_health"},{"companion","player","INLIMBO","wall", "notarget", "noattack", "flight", "invisible", "playerghost"})
end
AddStategraphState('wilson',
    State{
        name = "krm_jump",
        tags = { "aoe", "doing", "busy", "nointerrupt", "nopredict", "nomorph",},
        onenter = function(inst, data)
            if data then
                data = data.data
                if data ~= nil and
                    data.targetpos ~= nil then
                    ToggleOffPhysics(inst)
                    inst.Transform:SetEightFaced()
                    inst.AnimState:PlayAnimation("atk_leap")
                    inst.SoundEmitter:PlaySound("dontstarve/common/deathpoof")
                    inst.sg.statemem.startingpos = inst:GetPosition()
                    inst.sg.statemem.weapon = data.weapon
                    inst.sg.statemem.targetpos = data.targetpos
                    inst.sg.statemem.flash = 0
                    if inst.sg.statemem.startingpos.x ~= data.targetpos.x or inst.sg.statemem.startingpos.z ~= data.targetpos.z then
                     inst:ForceFacePoint(data.targetpos:Get())
                        inst.Physics:SetMotorVel(math.sqrt(distsq(inst.sg.statemem.startingpos.x, inst.sg.statemem.startingpos.z, data.targetpos.x, data.targetpos.z)) / (12 * FRAMES), 0 ,0)
                    end
                return
                end
            end
            inst.sg:GoToState("idle", true)
        end,
        onupdate = function(inst)
            if inst.sg.statemem.flash > 0 then
                inst.sg.statemem.flash = math.max(0, inst.sg.statemem.flash - .1)
                local c = math.min(1, inst.sg.statemem.flash)
                inst.components.colouradder:PushColour("leap", c, c, 0, 0)
            end
        end,
        timeline =
        {
            TimeEvent(10 * FRAMES, function(inst)
                inst.components.colouradder:PushColour("leap", .1, .1, 0, 0)
            end),
            TimeEvent(11 * FRAMES, function(inst)
                inst.components.colouradder:PushColour("leap", .2, .2, 0, 0)
            end),
            TimeEvent(12 * FRAMES, function(inst)
                inst.components.colouradder:PushColour("leap", .4, .4, 0, 0)
                ToggleOnPhysics(inst)
                inst.Physics:Stop()
                inst.Physics:SetMotorVel(0, 0, 0)
                inst.Physics:Teleport(inst.sg.statemem.targetpos.x, 0, inst.sg.statemem.targetpos.z)
            end),
            TimeEvent(13 * FRAMES, function(inst)
                ShakeAllCameras(CAMERASHAKE.VERTICAL, .7, .015, .8, inst, 20)
                inst.components.bloomer:PushBloom("leap", "shaders/anim.ksh", -2)
                inst.components.colouradder:PushColour("leap", 1, 1, 0, 0)
                inst.sg.statemem.flash = 1.3
                inst.sg:RemoveStateTag("nointerrupt")
                if inst.sg.statemem.weapon:IsValid() then --伤害！
                    --inst.sg.statemem.weapon:DoLeap(inst, inst.sg.statemem.startingpos, inst.sg.statemem.targetpos)
                    local x, y, z = inst.Transform:GetWorldPosition()
                    local fx = SpawnPrefab("groundpoundring_fx")
                    fx.Transform:SetPosition(x,y,z)
                    local ents = gettargets(x,y,z,6)
                    for i,v in pairs(ents) do
                        if v and v:IsValid() and inst:IsValid() and inst:IsNear(v, 6 + (v.Physics and v.Physics:GetRadius() or 0)) 
                            and v.components.health ~=nil and v.components.combat ~= nil  and not v.components.health:IsDead() then
                            local damage = inst.components.combat:CalcDamage(v, inst.sg.statemem.weapon)
                            v.components.combat:GetAttacked(inst,damage)
                        end
                    end
                end
            end),
            TimeEvent(25 * FRAMES, function(inst)
                inst.components.bloomer:PopBloom("leap")
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
            if inst.sg.statemem.isphysicstoggle then
                ToggleOnPhysics(inst)
                inst.Physics:Stop()
                inst.Physics:SetMotorVel(0, 0, 0)
                local x, y, z = inst.Transform:GetWorldPosition()
                if TheWorld.Map:IsPassableAtPoint(x, 0, z) and not TheWorld.Map:IsGroundTargetBlocked(Vector3(x, 0, z)) then
                    inst.Physics:Teleport(x, 0, z)
                else
                    inst.Physics:Teleport(inst.sg.statemem.targetpos.x, 0, inst.sg.statemem.targetpos.z)
                end
            end
            inst.Transform:SetFourFaced()
            inst.components.bloomer:PopBloom("leap")
            inst.components.colouradder:PopColour("leap")
        end,
    }
)

-------========
local  KRM_USE_INVENTORY = Action({ priority=1,mount_valid=true,encumbered_valid = true })
KRM_USE_INVENTORY.id = "KRM_USE_INVENTORY"
KRM_USE_INVENTORY.strfn = function(act)
    local target = act.invobject or act.target
    return target and target.KRM_USE_TYPE or "USE"
end
KRM_USE_INVENTORY.fn = function(act)
    local obj = act.invobject or act.target
    if obj then
        if obj.components.krm_use_inventory  then
            obj.components.krm_use_inventory:OnUse(act.doer)
            return true
        end
    end
end
AddAction(KRM_USE_INVENTORY)
AddComponentAction("INVENTORY", "krm_use_inventory" , function(inst, doer, actions, right)
    if doer and inst:HasTag("canuseininv_krm") and ( not inst.krm_use_needtag or doer:HasTag(inst.krm_use_needtag)) then
        table.insert(actions, ACTIONS.KRM_USE_INVENTORY)
    elseif inst.canuseininventory_krm ~= nil and inst.canuseininventory_krm(inst,doer, right) then
        table.insert(actions, ACTIONS.KRM_USE_INVENTORY)
    end
end)
AddStategraphActionHandler("wilson",ActionHandler(ACTIONS.KRM_USE_INVENTORY, 
    function(inst, action)
        local target = action.target or action.invobject
        if target then
            if target.onusesgname ~= nil then
                return target.onusesgname
            end
		end
		return "give"
    end))

AddStategraphActionHandler("wilson_client",ActionHandler(ACTIONS.KRM_USE_INVENTORY,
    function(inst, action)
        local target = action.target or action.invobject
        if target then
            if target.onusesgname_client ~= nil then
                return target.onusesgname_client
            end
		end
		return "doshortaction"
    end))

    STRINGS.ACTIONS.KRM_USE_INVENTORY = {
        USE = "使用",
        ZHAOJIA = "招架",
    }

local function IsWeaponEquipped(inst, weapon)
    return weapon ~= nil
        and weapon.components.equippable ~= nil
        and weapon.components.equippable:IsEquipped()
        and weapon.components.inventoryitem ~= nil
        and weapon.components.inventoryitem:IsHeldBy(inst)
end
local function StopTalkSound(inst, instant)
    if not instant and inst.endtalksound ~= nil and inst.SoundEmitter:PlayingSound("talk") then
        inst.SoundEmitter:PlaySound(inst.endtalksound)
    end
    inst.SoundEmitter:KillSound("talk")
end

local function CancelTalk_Override(inst, instant)
	if inst.sg.statemem.talktask ~= nil then
		inst.sg.statemem.talktask:Cancel()
		inst.sg.statemem.talktask = nil
		StopTalkSound(inst, instant)
	end
end
local function DoTalkSound(inst)
    if inst.talksoundoverride ~= nil then
        inst.SoundEmitter:PlaySound(inst.talksoundoverride, "talk")
        return true
    elseif not inst:HasTag("mime") then
        inst.SoundEmitter:PlaySound((inst.talker_path_override or "dontstarve/characters/")..(inst.soundsname or inst.prefab).."/talk_LP", "talk")
        return true
    end
end
local function OnTalk_Override(inst)
	CancelTalk_Override(inst, true)
	if DoTalkSound(inst) then
		inst.sg.statemem.talktask = inst:DoTaskInTime(1.5 + math.random() * .5, CancelTalk_Override)
	end
	return true
end

local function OnDoneTalking_Override(inst)
	CancelTalk_Override(inst)
	return true
end
local function GetUnequipState(inst, data)
    return (inst:HasTag("wereplayer") and "item_in")
        or (data.eslot ~= EQUIPSLOTS.HANDS and "item_hat")
        or (not data.slip and "item_in")
        or (data.item ~= nil and data.item:IsValid() and "tool_slip")
        or "toolbroke"
        , data.item
end

AddStategraphState('wilson',
    State{
        name = "krm_parry_pre",
        tags = { "preparrying", "busy", "nomorph" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("parry_pre")
            inst.AnimState:PushAnimation("parry_loop", true)
            inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())

            local function oncombatparry(inst, data)
                inst.sg:AddStateTag("parrying")
                if data ~= nil then
                    if data.direction ~= nil then
                        inst.Transform:SetRotation(data.direction)
                    end
                    inst.sg.statemem.parrytime = data.duration
                    inst.sg.statemem.item = data.weapon
                    if data.weapon ~= nil then
                        inst.components.combat.redirectdamagefn = function(inst, attacker, damage, weapon, stimuli)
                            return IsWeaponEquipped(inst, data.weapon)
                                and data.weapon.components.krm_rake ~= nil
                                and data.weapon.components.krm_rake:TryParry(inst, attacker, damage, weapon, stimuli)
                                and data.weapon
                                or nil
                        end
                    end
                end
            end
            inst:ListenForEvent("krm_combat_parry", oncombatparry)
            local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) 
			if equip ~= nil and equip.components.krm_rake ~= nil then
				local direction = inst.Transform:GetRotation()
				inst:PushEvent("krm_combat_parry",{duration = 999, weapon = equip ,direction = direction})
			end
            inst:PerformBufferedAction()
            inst:RemoveEventCallback("krm_combat_parry", oncombatparry)
        end,
        events =
        {
			EventHandler("ontalk", OnTalk_Override),
			EventHandler("donetalking", OnDoneTalking_Override),
            EventHandler("unequip", function(inst, data)
                inst.sg:GoToState(GetUnequipState(inst, data))
            end),
        },

        ontimeout = function(inst)
            if inst.sg:HasStateTag("parrying") then
                inst.sg.statemem.parrying = true
                local talktask = inst.sg.statemem.talktask
                inst.sg.statemem.talktask = nil
                inst.sg:GoToState("parry_idle", { duration = inst.sg.statemem.parrytime, pauseframes = 30, talktask = talktask })
            else
                inst.AnimState:PlayAnimation("parry_pst")
                inst.sg:GoToState("idle", true)
            end
        end,

        onexit = function(inst)
			CancelTalk_Override(inst)
            if not inst.sg.statemem.parrying then
                inst.components.combat.redirectdamagefn = nil
            end
        end,
    })