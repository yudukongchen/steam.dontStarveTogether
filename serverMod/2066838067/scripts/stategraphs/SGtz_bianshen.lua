local function EventPostInit(self)
    local old_fn = self.actionhandlers[ACTIONS.ATTACK].deststate
    self.actionhandlers[ACTIONS.ATTACK].deststate = function(inst, action)
        
        local isdead = inst.replica.health and inst.replica.health:IsDead()
        local item = inst.replica.inventory and inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        local target = action.target
        local _combat = inst.components.combat or inst.replica.combat
        local isriding = inst.replica.rider:IsRiding()

        if isdead or isriding or item or not (target and target:IsValid() and _combat) then
            return old_fn(inst, action)
        end

		if inst:HasTag("taizhen") and inst._bianshen:value() == true then
			return "tz_speiaclattak"
		end

        return old_fn(inst, action)
    end
end
AddStategraphPostInit('wilson', EventPostInit)
AddStategraphPostInit('wilson_client', EventPostInit)

AddClassPostConstruct( "components/combat_replica", function(self, inst)
	local old_GetAttackRangeWithWeapon = self.GetAttackRangeWithWeapon
	function self:GetAttackRangeWithWeapon(...)
		if self.inst._bianshen ~= nil and self.inst._bianshen:value() then
            if self.inst.components.combat ~= nil then
                return self.inst.components.combat:GetAttackRange()
            end
            local weapon = self:GetWeapon()
            return weapon ~= nil
                and math.max(0, self._attackrange:value() + weapon.replica.inventoryitem:AttackRange())
                or 4
		end
		return old_GetAttackRangeWithWeapon(self,...)
	end
end)

AddComponentPostInit("combat", function(self) 
	local old_GetAttackRange = self.GetAttackRange
	function self:GetAttackRange(...)
		if self.inst._bianshen ~= nil and self.inst._bianshen:value() then
            local weapon = self:GetWeapon()
            return weapon ~= nil
                and math.max(0, self.attackrange + (weapon.components.weapon.attackrange or 0))
                or 4
		end
		return old_GetAttackRange(self,...)
	end
end)

AddStategraphState('wilson_client', State{
    name = "tz_speiaclattak",
    tags = { "attack", "notalking", "abouttoattack" },

    onenter = function(inst)
		inst.AnimState:AddOverrideBuild("taizhen_avatar_attack")
        local cooldown = 0
        if inst.replica.combat ~= nil then
            inst.replica.combat:StartAttack()
            cooldown = inst.replica.combat:MinAttackPeriod() + .5 * FRAMES
        end
        inst.components.locomotor:Stop()
        inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh",nil,.5)
        if inst.atk_2 == true then
            inst.AnimState:PlayAnimation("atk_2_werewilba")
            inst.atk_2 = nil
        else
            inst.AnimState:PlayAnimation("atk_werewilba")
			inst.atk_2 = true
        end

        cooldown = 15 * FRAMES

        local buffaction = inst:GetBufferedAction()
        if buffaction ~= nil then
            inst:PerformPreviewBufferedAction()

            if buffaction.target ~= nil and buffaction.target:IsValid() then
                inst:FacePoint(buffaction.target:GetPosition())
                inst.sg.statemem.attacktarget = buffaction.target
            end
        end

        if cooldown > 0 then
            inst.sg:SetTimeout(cooldown)
        end
        inst.AnimState:SetDeltaTimeMultiplier(1.25)
    end,

    timeline =
    {
        TimeEvent(6 * FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
            inst:ClearBufferedAction()
            inst.sg:RemoveStateTag("abouttoattack")
        end),
    },

    ontimeout = function(inst)
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")
		inst.AnimState:ClearOverrideBuild("taizhen_avatar_attack")
    end,
    events =
    {
        EventHandler("animover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },
    onexit = function(inst)
        inst.AnimState:SetDeltaTimeMultiplier(1)
        if inst.sg:HasStateTag("abouttoattack") and inst.replica.combat ~= nil then
            inst.replica.combat:CancelAttack()
        end
    end,
})

local function isinrange(inst,target,jiajiao,dis)
    local ang = inst.Transform:GetRotation()
    local x,y,z = target.Transform:GetWorldPosition()
    local angle = inst:GetAngleToPoint( x,0,z )
    local drot = math.abs( ang - angle )
    while drot > 180 do
        drot = math.abs(drot - 360)
    end
    return drot < jiajiao and inst:GetDistanceSqToPoint(x,y,z) < dis* dis
end

AddStategraphState('wilson', State{
    name = "tz_speiaclattak",
    tags = { "attack", "notalking", "abouttoattack", "autopredict" },

    onenter = function(inst)
		inst.AnimState:AddOverrideBuild("taizhen_avatar_attack")
        local buffaction = inst:GetBufferedAction()
        local target = buffaction ~= nil and buffaction.target or nil
        inst.components.combat:SetTarget(target)
        inst.components.combat:StartAttack()
        inst.components.locomotor:Stop()
        local cooldown = inst.components.combat.min_attack_period + .5 * FRAMES
        
        inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh",nil,.5)
        if inst.atk_2 == true then
            inst.AnimState:PlayAnimation("atk_2_werewilba")
			inst.atk_2 = nil
        else
            inst.AnimState:PlayAnimation("atk_werewilba")
			inst.atk_2 = true
        end

        cooldown = 12 * FRAMES
        inst.sg:SetTimeout(cooldown)

        if target ~= nil then
            inst.components.combat:BattleCry()
            if target:IsValid() then
                inst:FacePoint(target:GetPosition())
                inst.sg.statemem.attacktarget = target
            end
        end
        inst.AnimState:SetDeltaTimeMultiplier(1.25)
    end,
    timeline =
    {
        TimeEvent(6.5 * FRAMES, function(inst)
            --计算sama的倍率 0.0015
            local rate = inst.components.tzsama and inst.components.tzsama.max*0.0015 or 0
            --print("当前撒嘛倍率",rate)
            inst.sg.statemem.rate =  rate 
            inst.sg.statemem.attackfx = SpawnPrefab("tz_firebird_puff_fx")
            inst.sg.statemem.attackfx.Transform:SetScale(0.6+rate, 0.6+rate, 0.6+rate) --当前动画的大小1 + 倍率
            local x,y,z = inst.Transform:GetWorldPosition()
            inst.sg.statemem.attackfx.Transform:SetPosition(x,y,z)
            inst.sg.statemem.attackfx.Transform:SetRotation(inst.Transform:GetRotation() - 90 )
        end),
        TimeEvent(8 * FRAMES, function(inst)
            inst.sg.statemem.attackfx_over = true
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
            local damagerange = 4*(1+inst.sg.statemem.rate*1.9) --伤害范围 默认是4
            inst.ghosthsnd_samaskilladd = 0
            inst.components.combat:SetAreaDamage(damagerange, 1,function(target,inst) 
                return isinrange(inst,target,45, damagerange ) and not target:HasTag("companion")
            end)
            inst:PerformBufferedAction()
			if inst.sg.statemem.attacktarget ~= nil and  inst.sg.statemem.attacktarget:IsValid() then
                local target = inst.sg.statemem.attacktarget
                local fx = SpawnPrefab("tz_zhua_attack")
                if fx ~= nil then
                     local x, y, z = target.Transform:GetWorldPosition()	
                    fx.Transform:SetPosition(x, y+1, z)
                    if inst.atk_2 then
                        fx.AnimState:PlayAnimation("attack_B")
                    end
                    if target:HasTag("largecreature") then
                        fx.Transform:SetScale(3,3,3)
                    elseif target:HasTag("smallcreature") then
                        fx.Transform:SetScale(1,1,1)
                    else
                        fx.Transform:SetScale(2,2,2)
                    end
                end
            end
            inst.components.combat:SetAreaDamage(nil)
            inst.ghosthsnd_samaskilladd = nil
			--这里
            inst.sg:RemoveStateTag("abouttoattack")
        end),
    },

    ontimeout = function(inst)
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")
    end,

    events =
    {
        EventHandler("animover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)
        if not inst.sg.statemem.attackfx_over and inst.sg.statemem.attackfx and inst.sg.statemem.attackfx:IsValid() then
            inst.sg.statemem.attackfx:Remove()
        end
        inst.AnimState:SetDeltaTimeMultiplier(1)
        inst.components.combat:SetTarget(nil)
        if inst.sg:HasStateTag("abouttoattack") then
            inst.components.combat:CancelAttack()
        end
		inst.AnimState:ClearOverrideBuild("taizhen_avatar_attack")
    end,
})

--[[
local function GetSandstormLevel(inst)
    if inst.GetSandstormLevel ~= nil then
        return inst:GetSandstormLevel()
    elseif inst.GetStormLevel ~= nil then
        return inst:GetStormLevel()
    end
    return 0
end

local function ConfigureRunState(inst)
    if inst.components.rider:IsRiding() then
        inst.sg.statemem.riding = true
        inst.sg.statemem.groggy = (inst:HasTag("groggy") or inst:HasTag("bajieele"))
        inst.sg:AddStateTag("nodangle")
    elseif inst.components.inventory:IsHeavyLifting() then
        inst.sg.statemem.heavy = true
    elseif inst:HasTag("wereplayer") then
        inst.sg.statemem.iswere = true
        if inst:HasTag("weremoose") then
            if inst:HasTag("groggy") then
                inst.sg.statemem.moosegroggy = true
            else
                inst.sg.statemem.moose = true
            end
        elseif inst:HasTag("weregoose") then
            if inst:HasTag("groggy") then
                inst.sg.statemem.goosegroggy = true
            else
                inst.sg.statemem.goose = true
            end
        elseif inst:HasTag("groggy") then
            inst.sg.statemem.groggy = true
        else
            inst.sg.statemem.normal = true
        end
    elseif GetSandstormLevel(inst) >= TUNING.SANDSTORM_FULL_LEVEL and not inst.components.playervision:HasGoggleVision() then
        inst.sg.statemem.sandstorm = true
    elseif (inst:HasTag("groggy") or inst:HasTag("bajieele")) then
        inst.sg.statemem.groggy = true
    elseif inst:IsCarefulWalking() then
        inst.sg.statemem.careful = true
    else
        inst.sg.statemem.normal = true
    end
end

local function ConfigureRunState_Client(inst)
    if inst.replica.rider ~= nil and inst.replica.rider:IsRiding() then
        inst.sg.statemem.riding = true
        inst.sg.statemem.groggy = inst:HasTag("groggy")
    elseif inst.replica.inventory:IsHeavyLifting() then
        inst.sg.statemem.heavy = true
    elseif inst:HasTag("wereplayer") then
        inst.sg.statemem.iswere = true
        if inst:HasTag("weremoose") then
            if inst:HasTag("groggy") then
                inst.sg.statemem.moosegroggy = true
            else
                inst.sg.statemem.moose = true
            end
        elseif inst:HasTag("weregoose") then
            if inst:HasTag("groggy") then
                inst.sg.statemem.goosegroggy = true
            else
                inst.sg.statemem.goose = true
            end
        elseif inst:HasTag("groggy") then
            inst.sg.statemem.groggy = true
        else
            inst.sg.statemem.normal = true
        end
    elseif GetSandstormLevel(inst) >= TUNING.SANDSTORM_FULL_LEVEL and not inst.components.playervision:HasGoggleVision() then
        inst.sg.statemem.sandstorm = true
    elseif inst:HasTag("groggy") then
        inst.sg.statemem.groggy = true
    elseif inst:IsCarefulWalking() then
        inst.sg.statemem.careful = true
    else
        inst.sg.statemem.normal = true
    end
end

local function GetRunStateAnim(inst)
    return (inst.sg.statemem.heavy and "heavy_walk")
        or (inst.sg.statemem.sandstorm and "sand_walk")
        or ((inst.sg.statemem.groggy or inst.sg.statemem.moosegroggy or inst.sg.statemem.goosegroggy) and "idle_walk")
        or (inst.sg.statemem.careful and "careful_walk")
        or "run"
end

AddStategraphPostInit("wilson", function(sg)
	local run = sg.states["run"]
	if run ~= nil then
		local old_runonenter = run.onenter
		run.onenter = function(inst,...)
			if inst:HasTag("taizhen") and 
                if 
                elseif inst._bianshen:value() == true then
				    ConfigureRunState(inst)
				    inst.components.locomotor:RunForward()
				    local anim = GetRunStateAnim(inst)
				    if anim == "run" then
					   local item = inst.replica.inventory and inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
					   anim = item ~= nil and "swap_move_loop" or "move_loop"
				    end
				    if not inst.AnimState:IsCurrentAnimation(anim) then
					   inst.AnimState:PlayAnimation(anim, true)
				    end
				    inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength() + .5 * FRAMES)
                end
			else
				old_runonenter(inst,...)
			end
		end
	end
	
	local run_start = sg.states["run_start"]
	if run_start ~= nil then
		local old_run_startonenter = run_start.onenter
		run_start.onenter = function(inst,...)
			if inst:HasTag("taizhen") and inst._bianshen:value() == true then
				ConfigureRunState(inst)
				inst.components.locomotor:RunForward()
				local run = GetRunStateAnim(inst)
				if run == "run" then
					local item = inst.replica.inventory and inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
					run = item ~= nil and "swap_move" or "move"
				end
				inst.AnimState:PlayAnimation(run.."_pre")
				inst.sg.mem.footsteps = (inst.sg.statemem.goose or inst.sg.statemem.goosegroggy) and 4 or 0
			else
				old_run_startonenter(inst,...)
			end
		end
	end	
	
	local run_stop = sg.states["run_stop"]
	if run_stop ~= nil then
		local old_run_stoponenter = run_stop.onenter
		run_stop.onenter = function(inst,...)
			if inst:HasTag("taizhen") and inst._bianshen:value() == true then
				ConfigureRunState(inst)
				inst.components.locomotor:Stop()
				local run = GetRunStateAnim(inst)
				if run == "run" then
					local item = inst.replica.inventory and inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
					run = item ~= nil and "swap_move" or "move"
				end
				inst.AnimState:PlayAnimation(run.."_pst")
			else
				old_run_stoponenter(inst,...)
			end
		end
	end	
end)
AddStategraphPostInit("wilson_client", function(sg)
	local run = sg.states["run"]
	if run ~= nil then
		local old_runonenter = run.onenter
		run.onenter = function(inst,...)
			if inst:HasTag("taizhen") and inst._bianshen:value() == true then
				ConfigureRunState_Client(inst)
				inst.components.locomotor:RunForward()
				local anim = GetRunStateAnim(inst)
				if anim == "run" then
					local item = inst.replica.inventory and inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
					anim = item ~= nil and "swap_move_loop" or "move_loop"
				end
				if not inst.AnimState:IsCurrentAnimation(anim) then
					inst.AnimState:PlayAnimation(anim, true)
				end
				inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength() + .5 * FRAMES)
			else
				old_runonenter(inst,...)
			end
		end
	end
	
	local run_start = sg.states["run_start"]
	if run_start ~= nil then
		local old_run_startonenter = run_start.onenter
		run_start.onenter = function(inst,...)
			if inst:HasTag("taizhen") and inst._bianshen:value() == true then
				ConfigureRunState_Client(inst)
				inst.components.locomotor:RunForward()
				local run = GetRunStateAnim(inst)
				if run == "run" then
					local item = inst.replica.inventory and inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
					run = item ~= nil and "swap_move" or "move"
				end
				inst.AnimState:PlayAnimation(run.."_pre")
				inst.sg.mem.footsteps = (inst.sg.statemem.goose or inst.sg.statemem.goosegroggy) and 4 or 0
			else
				old_run_startonenter(inst,...)
			end
		end
	end	
	
	local run_stop = sg.states["run_stop"]
	if run_stop ~= nil then
		local old_run_stoponenter = run_stop.onenter
		run_stop.onenter = function(inst,...)
			if inst:HasTag("taizhen") and inst._bianshen:value() == true then
				ConfigureRunState_Client(inst)
				inst.components.locomotor:Stop()
				local run = GetRunStateAnim(inst)
				if run == "run" then
					local item = inst.replica.inventory and inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
					run = item ~= nil and "swap_move" or "move"
				end
				inst.AnimState:PlayAnimation(run.."_pst")
			else
				old_run_stoponenter(inst,...)
			end
		end
	end	
end)]]

local IsFlying = function(inst) 
    -- Ly note:Ban hua hua say modify it.
    -- if inst.components.rider and inst.components.rider:IsRiding() then
    if inst.replica.rider and inst.replica.rider:IsRiding() then
        return true
    elseif inst.components.mk_flyer and inst.components.mk_flyer:IsFlying() then
        return true
    end
    return false
end
local function AddPlayerSgPostInit(fn)
    AddStategraphPostInit('wilson', fn)
    AddStategraphPostInit('wilson_client', fn)
end

AddPlayerSgPostInit(function(self)
	local run = self.states.run 
	if run then
		local old_enter = run.onenter
		function run.onenter(inst, ...)
			if old_enter then 
				old_enter(inst, ...)
			end
			if inst:HasTag("taizhen") and not IsFlying(inst) then
                local anim = nil
                if inst:HasTag("tz_fanhao_rider") and inst.replica.inventory:EquipHasTag("tz_fanhao") then
                    anim = "fh_run_loop"
                elseif inst._bianshen and inst._bianshen:value() then
                    anim = "swap_move_loop"
                end
				if anim ~= nil and not inst.AnimState:IsCurrentAnimation(anim) then
					inst.AnimState:PlayAnimation(anim, true)
				end
				inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength() + 0.01)
			end
		end
	end

	local run_start = self.states.run_start 
	if run_start then
		local old_enter = run_start.onenter
		function run_start.onenter(inst, ...)
			if old_enter then 
				old_enter(inst, ...)
			end
			if inst:HasTag("taizhen") and not IsFlying(inst) then
                local anim = nil
                if inst:HasTag("tz_fanhao_rider") and inst.replica.inventory:EquipHasTag("tz_fanhao") then
                    anim = "fh_run_pre"
                elseif inst._bianshen and inst._bianshen:value() then
                    anim = "swap_move_pre"
                end
				if anim ~= nil and not inst.AnimState:IsCurrentAnimation(anim) then
					inst.AnimState:PlayAnimation(anim, true)
				end
				inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength() + 0.01)
			end
		end
	end

	local run_stop = self.states.run_stop 
	if run_stop then
		local old_enter = run_stop.onenter
		function run_stop.onenter(inst, ...)
			if old_enter then 
				old_enter(inst, ...)
			end
			if inst:HasTag("taizhen") and not IsFlying(inst) then
                local anim = nil
                if inst:HasTag("tz_fanhao_rider") and inst.replica.inventory:EquipHasTag("tz_fanhao") then
                    anim = "fh_run_pst"
                elseif inst._bianshen and inst._bianshen:value() then
                    anim = "swap_move_pst"
                end
				if anim ~= nil and not inst.AnimState:IsCurrentAnimation(anim) then
					inst.AnimState:PlayAnimation(anim, true)
				end
				inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength() + 0.01)
			end
		end
	end

    local idle = self.states["idle"]
    if idle then
        local old_onenter = idle.onenter
        idle.onenter = function(inst, pushanim)
			if inst:HasTag("tz_fanhao_rider") and not IsFlying(inst) and inst.replica.inventory:EquipHasTag("tz_fanhao") then
                inst.sg:GoToState("tz_fanhao_idle", pushanim)
                return
			end
            return old_onenter(inst, pushanim)
        end
    end
end)

AddStategraphState(
    "wilson",
    State {
        name = "tz_fanhao_idle",
        tags = {"idle", "canrotate"},
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
            if inst.components.drownable ~= nil and inst.components.drownable:ShouldDrown() then
                print("为什么啊？？")
                inst.sg:GoToState("sink_fast")
                return
            end
            local equippedArmor = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
            if equippedArmor ~= nil and equippedArmor:HasTag("band") then
                inst.sg:GoToState("enter_onemanband", pushanim)
                return
            end
            inst.AnimState:PlayAnimation("fh_idle_loop",true)
        end,
    }
)

AddStategraphState(
    "wilson_client",
    State {
        name = "tz_fanhao_idle",
        tags = {"idle", "canrotate", "under_ground"},
        onenter = function(inst, pushanim)
            inst.entity:SetIsPredictingMovement(false)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()

            if pushanim == "cancel" then
                return
            elseif inst:HasTag("nopredict") or inst:HasTag("pausepredict") then
                inst:ClearBufferedAction()
                return
            elseif pushanim == "noanim" then
                inst.sg:SetTimeout(TIMEOUT)
                return
            end
            inst.AnimState:PlayAnimation("fh_idle_loop", true)
        end,
        ontimeout = function(inst)
            if inst.bufferedaction ~= nil and inst.bufferedaction.ispreviewing then
                inst:ClearBufferedAction()
            end
        end,
        onexit = function(inst)
            inst.entity:SetIsPredictingMovement(true)
        end
    }
)

local function newdeath(sg)
    local old_death = sg.events['death'].fn
    sg.events['death'] = EventHandler('death', function(inst,data,...)
		if inst.apingfuhuo ~= nil and inst.apingfuhuo:value() then
			if inst.sleepingbag ~= nil and (inst.sg:HasStateTag("bedroll") or inst.sg:HasStateTag("tent")) then
				inst.sleepingbag.components.sleepingbag:DoWakeUp()
				inst.sleepingbag = nil
			end
			inst.sg:GoToState("tz_death")
		else
			old_death(inst,data,...)
		end
    end)
end

AddStategraphPostInit("wilson", newdeath)

local ex_fns = require "prefabs/player_common_extensions"
local old_Ghost  = ex_fns.OnRespawnFromGhost
local ConfigurePlayerLocomotor  = ex_fns.ConfigurePlayerLocomotor
local ConfigurePlayerActions  = ex_fns.ConfigurePlayerActions
local ConfigureGhostLocomotor  = ex_fns.ConfigureGhostLocomotor
local ConfigureGhostActions  = ex_fns.ConfigureGhostActions

local function CommonPlayerDeath(inst)
    inst.player_classified.MapExplorer:EnableUpdate(false)

    inst:RemoveComponent("burnable")

    inst.components.freezable:Reset()
    inst:RemoveComponent("freezable")
    inst:RemoveComponent("propagator")

    inst:RemoveComponent("grogginess")

    inst.components.moisture:ForceDry(true, inst)

    inst.components.sheltered:Stop()

    inst.components.debuffable:Enable(false)

    if inst.components.revivablecorpse == nil then
        inst.components.age:PauseAging()
    end

    inst.components.health:SetInvincible(true)
    inst.components.health.canheal = false

    if not GetGameModeProperty("no_sanity") then
        inst.components.sanity:SetPercent(.5, true)
    end
    inst.components.sanity.ignore = true

    if not GetGameModeProperty("no_hunger") then
        inst.components.hunger:SetPercent(2 / 3, true)
    end
    inst.components.hunger:Pause()

    if not GetGameModeProperty("no_temperature") then
        inst.components.temperature:SetTemp(TUNING.STARTING_TEMP)
    end
    inst.components.frostybreather:Disable()
end

local function OnMakePlayerGhost(inst,data)
    if inst:HasTag("playerghost") then
        return
    end
    local x, y, z = inst.Transform:GetWorldPosition()

    if data ~= nil and data.skeleton and TheSim:HasPlayerSkeletons() then
        local skel = SpawnPrefab("skeleton_player")
        if skel ~= nil then
            skel.Transform:SetPosition(x, y, z)
            skel:SetSkeletonDescription(inst.prefab, inst:GetDisplayName(), inst.deathcause, inst.deathpkname)
            skel:SetSkeletonAvatarData(inst.deathclientobj)
        end
    end
    if data ~= nil and data.loading then
        inst.loading_ghost = true
    else
        local announcement_string = GetNewDeathAnnouncementString(inst, inst.deathcause, inst.deathpkname, inst.deathbypet)
        if announcement_string ~= "" then
            TheNet:AnnounceDeath(announcement_string, inst.entity)
        end
        SpawnPrefab("die_fx").Transform:SetPosition(x, y, z)
    end

    --inst.AnimState:SetBank("ghost")

    --inst.components.skinner:SetSkinMode("ghost_skin")

    --inst.components.bloomer:PushBloom("playerghostbloom", "shaders/anim_bloom_ghost.ksh", 100)
    --inst.AnimState:SetLightOverride(TUNING.GHOST_LIGHT_OVERRIDE)

    --inst:SetStateGraph("SGwilsonghost")

    CommonPlayerDeath(inst)
    inst.Physics:Teleport(x, y, z)

    inst:AddTag("playerghost")
    inst.Network:AddUserFlag(USERFLAGS.IS_GHOST)

    inst.components.health:SetCurrentHealth(TUNING.RESURRECT_HEALTH)
    inst.components.health:ForceUpdateHUD(true)

    if inst.components.playercontroller ~= nil then
        inst.components.playercontroller:Enable(true)
    end
    inst.player_classified:SetGhostMode(true)

    ConfigureGhostLocomotor(inst)
    ConfigureGhostActions(inst)

    inst:PushEvent("ms_becameghost")

    if inst.loading_ghost then
        inst.loading_ghost = nil
        inst.components.inventory:Close()
    else
        inst.player_classified:AddMorgueRecord()
        SerializeUserSession(inst)
    end
end

local function CommonActualRez(inst)
    inst.player_classified.MapExplorer:EnableUpdate(true)

    if inst.components.revivablecorpse ~= nil then
        inst.components.inventory:Show()
    else
        inst.components.inventory:Open()
        inst.components.age:ResumeAging()
    end

    inst.components.health.canheal = true
    if not GetGameModeProperty("no_hunger") then
        inst.components.hunger:Resume()
    end
    if not GetGameModeProperty("no_temperature") then
        inst.components.temperature:SetTemp() --nil param will resume temp
    end
    inst.components.frostybreather:Enable()

    MakeMediumBurnableCharacter(inst, "torso")
    inst.components.burnable:SetBurnTime(TUNING.PLAYER_BURN_TIME)
    inst.components.burnable.nocharring = true

    MakeLargeFreezableCharacter(inst, "torso")
    inst.components.freezable:SetResistance(4)
    inst.components.freezable:SetDefaultWearOffTime(TUNING.PLAYER_FREEZE_WEAR_OFF_TIME)

    inst:AddComponent("grogginess")
    inst.components.grogginess:SetResistance(3)
    inst.components.grogginess:SetKnockOutTest(ShouldKnockout)

    inst.components.moisture:ForceDry(false, inst)

    inst.components.sheltered:Start()

    inst.components.debuffable:Enable(true)

    inst.components.sanity.ignore = GetGameModeProperty("no_sanity")

    ConfigurePlayerLocomotor(inst)
    ConfigurePlayerActions(inst)

    if inst.rezsource ~= nil then
        local announcement_string = GetNewRezAnnouncementString(inst, inst.rezsource)
        if announcement_string ~= "" then
            TheNet:AnnounceResurrect(announcement_string, inst.entity)
        end
        inst.rezsource = nil
    end
    inst.remoterezsource = nil
end

AddStategraphState('wilson', State{
        name = "tz_rebirth",
        tags = { "busy", "noattack", "nopredict", "nomorph" },

        onenter = function(inst)
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(false)
            end
            inst.AnimState:PlayAnimation("death2_idle")
           
			inst.components.health:SetInvincible(true)
            inst:ShowHUD(false)
            inst:SetCameraDistance(14)
        end,

        timeline =
        {
            TimeEvent(2, function(inst)
                inst.AnimState:PlayAnimation("corpse_revive")
			end),
        },
        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() and inst.AnimState:IsCurrentAnimation("corpse_revive") then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            inst:ShowHUD(true)
            inst:SetCameraDistance()
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(true)
            end
            inst.components.health:SetInvincible(false)
            SerializeUserSession(inst)
        end,
	}
)

local function ClearStatusAilments(inst)
    if inst.components.freezable ~= nil and inst.components.freezable:IsFrozen() then
        inst.components.freezable:Unfreeze()
    end
    if inst.components.pinnable ~= nil and inst.components.pinnable:IsStuck() then
        inst.components.pinnable:Unstick()
    end
end
local function ForceStopHeavyLifting(inst)
    if inst.components.inventory:IsHeavyLifting() then
        inst.components.inventory:DropItem(
            inst.components.inventory:Unequip(EQUIPSLOTS.BODY),
            true,
            true
        )
    end
end

local function DoGooseRunFX(inst)
    if inst.components.drownable ~= nil and inst.components.drownable:IsOverWater() then
        SpawnPrefab("weregoose_splash").entity:SetParent(inst.entity)
    else
        SpawnPrefab("weregoose_feathers"..tostring(math.random(3))).entity:SetParent(inst.entity)
    end
end

AddStategraphState('wilson', State{
        name = "tz_corpse",
        tags = { "busy", "dead", "noattack", "nopredict", "nomorph", "nodangle" },

        onenter = function(inst, fromload)
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(false)
            end
			OnMakePlayerGhost(inst,nil)
            inst:ShowActions(false)
            inst.components.health:SetInvincible(true)

            inst.AnimState:PlayAnimation("death2_idle")
			inst.sg:SetTimeout(1)
        end,
        ontimeout = function(inst)
			if inst.apingfuhuo ~= nil and inst.apingfuhuo:value() == true then
				inst:PushEvent("respawnfromghost", { source = nil })
			end
        end,
        onexit = function(inst)
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(true)
            end
            inst:ShowActions(true)
            inst.components.health:SetInvincible(false)
        end,
    }
)

AddStategraphState('wilson', State{
        name = "tz_death",
        tags = { "busy", "dead", "pausepredict", "nomorph" },

        onenter = function(inst)
            assert(inst.deathcause ~= nil, "Entered death state without cause.")
            ClearStatusAilments(inst)
            ForceStopHeavyLifting(inst)

            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
            inst:ClearBufferedAction()

            if inst.components.rider:IsRiding() then
                DoMountSound(inst, inst.components.rider:GetMount(), "yell")
                inst.AnimState:PlayAnimation("fall_off")
                inst.sg:AddStateTag("dismounting")
            else
                if not inst:HasTag("wereplayer") then
                    inst.SoundEmitter:PlaySound("dontstarve/wilson/death")
                elseif inst:HasTag("beaver") then
                    inst.sg.statemem.beaver = true
                elseif inst:HasTag("weremoose") then
                    inst.sg.statemem.moose = true
                else
                    inst.sg.statemem.goose = true
                end

                if inst.deathsoundoverride ~= nil then
                    inst.SoundEmitter:PlaySound(inst.deathsoundoverride)
                elseif not inst:HasTag("mime") then
                    inst.SoundEmitter:PlaySound((inst.talker_path_override or "dontstarve/characters/")..(inst.soundsname or inst.prefab).."/death_voice")
                end

                if HUMAN_MEAT_ENABLED then
                    inst.components.inventory:GiveItem(SpawnPrefab("humanmeat")) -- Drop some player meat!
                end
                if inst.apingfuhuo ~= nil and inst.apingfuhuo:value() == true then
                    inst.AnimState:PlayAnimation("death2")
                else
                    inst.components.inventory:DropEverything(true)
                    inst.AnimState:PlayAnimation("death")
                end

                inst.AnimState:Hide("swap_arm_carry")
            end

            inst.components.burnable:Extinguish()

            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:RemotePausePrediction()
                inst.components.playercontroller:Enable(false)
            end

            inst.sg:ClearBufferedEvents()
        end,

        timeline =
        {
            TimeEvent(15 * FRAMES, function(inst)
                if inst.sg.statemem.beaver then
                    inst.SoundEmitter:PlaySound("dontstarve/movement/bodyfall_dirt")
                elseif inst.sg.statemem.goose then
                    inst.SoundEmitter:PlaySound("dontstarve/movement/bodyfall_dirt")
                    DoGooseRunFX(inst)
                end
            end),
            TimeEvent(20 * FRAMES, function(inst)
                if inst.sg.statemem.moose then
                    inst.SoundEmitter:PlaySound("dontstarve/movement/bodyfall_dirt")
                end
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    if inst.sg:HasStateTag("dismounting") then
                        inst.sg:RemoveStateTag("dismounting")
                        inst.components.rider:ActualDismount()

                        inst.SoundEmitter:PlaySound("dontstarve/wilson/death")

                        if not inst:HasTag("mime") then
                            inst.SoundEmitter:PlaySound((inst.talker_path_override or "dontstarve/characters/")..(inst.soundsname or inst.prefab).."/death_voice")
                        end

                        if HUMAN_MEAT_ENABLED then
                            inst.components.inventory:GiveItem(SpawnPrefab("humanmeat")) -- Drop some player meat!
                        end
                        if inst.apingfuhuo ~= nil and inst.apingfuhuo:value() == true then
                            inst.AnimState:PlayAnimation("death2")
                        else
                            inst.components.inventory:DropEverything(true)
                            inst.AnimState:PlayAnimation("death")
                        end
                        inst.AnimState:Hide("swap_arm_carry")
                    elseif inst.apingfuhuo ~= nil and inst.apingfuhuo:value() == true then
                        inst.sg:GoToState("tz_corpse")
                    else
                        inst:PushEvent(inst.ghostenabled and "makeplayerghost" or "playerdied", { skeleton = TheWorld.Map:IsPassableAtPoint(inst.Transform:GetWorldPosition()) })
                    end
                end
            end),
        },
    }
)

local function DoActualRez(inst, source, item)
    local x, y, z = inst.Transform:GetWorldPosition()
	SpawnPrefab("lavaarena_player_revive_from_corpse_fx").entity:SetParent(inst.entity)

	inst.Physics:Teleport(x, y, z)
	
    inst.sg:GoToState("tz_rebirth")

    inst.player_classified:SetGhostMode(false)

    CommonActualRez(inst, source, item)

    inst:RemoveTag("playerghost")
    inst.Network:RemoveUserFlag(USERFLAGS.IS_GHOST)

    inst:PushEvent("ms_respawnedfromghost")
end

local function OnRespawnFromGhost(inst, data)
    if not inst:HasTag("playerghost") then
        return
    end
    inst.deathclientobj = nil
    inst.deathcause = nil
    inst.deathpkname = nil
    inst.deathbypet = nil
    inst:ShowHUD(false)
    if inst.components.playercontroller ~= nil then
        inst.components.playercontroller:Enable(false)
    end
    if inst.components.talker ~= nil then
        inst.components.talker:ShutUp()
    end
    inst.sg:AddStateTag("busy")

	inst:DoTaskInTime(0, DoActualRez )
    inst.rezsource = "转生布偶"
    inst.remoterezsource =
        data ~= nil and
        data.source ~= nil and
        data.source.components.attunable ~= nil and
        data.source.components.attunable:GetAttunableTag() == "remoteresurrector"
end

ex_fns.OnRespawnFromGhost = function(inst,data)
	if inst.apingfuhuo ~= nil and inst.apingfuhuo:value() == true then
		inst.apingfuhuo:set(false)
		OnRespawnFromGhost(inst,data)
	else
		old_Ghost(inst,data)
	end
end
