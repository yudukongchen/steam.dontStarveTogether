local TzStategraph = require("util/tz_stategraphs")

AddReplicableComponent("tz_weaponcharge")

------------------------------------------------------------------------------------------------------------
AddPrefabPostInit("gunpowder",function(inst)
	if not TheWorld.ismastersim then 
		return inst
	end 

	inst:AddComponent("tradable")
end)
------------------------------------------------------------------------------------------------------------
local SERVER_SG = {}
local CLIENT_SG = {}

table.insert(SERVER_SG,State{
	name = "tz_rpg_charging_pre",
	tags = { "attack","charging_attack", "charging_attack_pre","doing", "busy", "notalking"},

	onenter = function(inst)
		inst.components.locomotor:Stop()

		inst.AnimState:PlayAnimation("xuli_pre")
		inst.AnimState:PushAnimation("xuli_loop")
		inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh")      


		TzStategraph.ServerChargePreEnter(inst)
	end,
	timeline = {
		TimeEvent(FRAMES, function(inst)   
			inst.SoundEmitter:PlaySound("tz_rpg/"..TUNING.TZ_RPG_CONFIG.SOUND_NAME.."/charge")
		end)
	},

	onupdate = function(inst)
		TzStategraph.ServerChargePreUpdate(inst,{
			last_anim = "xuli_loop",
			attack_sg_name = "tz_rpg_charging",
		})
	end,

	events =
	{
		EventHandler("unequip", function(inst)
			inst.sg:GoToState("idle")
		end),
	},
})

table.insert(SERVER_SG,State{
	name = "tz_rpg_charging",
	tags = { "attack","charging_attack", "doing", "busy", "notalking","nopredict" },

	onenter = function(inst,data)
		inst.components.locomotor:Stop()

		
		inst.AnimState:PlayAnimation("houzuoli_pre")
		inst.AnimState:PushAnimation("houzuoli_loop",false)
		inst.AnimState:PushAnimation("houzuoli_pst",false)

		inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")

		if data.complete then 
			inst.sg:AddStateTag("completed_charging_attack")
		end

		inst.sg.statemem.charge_complete = data.complete
	end,
	timeline =
	{
		TimeEvent(FRAMES, function(inst)   
			local bufferedaction = inst:GetBufferedAction()
			local attack_target = bufferedaction ~= nil and bufferedaction.action == ACTIONS.ATTACK and bufferedaction.target or nil

			inst:PerformBufferedAction() 

			if inst.sg.statemem.charge_complete then 
				inst.components.tz_weaponcharge:DoSuperAttack() 
				if attack_target and attack_target:IsValid() and attack_target.components.health and attack_target.components.health:IsDead() then 
					attack_target:PushEvent("knockback", { knocker = inst, radius = GetRandomMinMax(4,5) + attack_target:GetPhysicsRadius(.5)})
				end          	
			end 
			inst.components.tz_weaponcharge:Release()

			inst.sg.statemem.houzuoli_thread = inst:StartThread(function()
				local speed = 6
				while speed > 0 do 
					speed = speed - FRAMES
					inst.Physics:SetMotorVel(-speed,0,0)
					Sleep(0)
				end
			end)
		end),

		TimeEvent(4 * FRAMES, function(inst)
			inst.sg:RemoveStateTag("doing")
			inst.sg:RemoveStateTag("busy")
			inst.sg:RemoveStateTag("attack")
			inst.sg:AddStateTag("idle")
		end),

		TimeEvent(18 * FRAMES, function(inst)
			inst.sg:GoToState("idle", true)
		end),
	},

	events =
	{
		EventHandler("unequip", function(inst)
			inst.sg:GoToState("idle")
		end),
		EventHandler("animover", function(inst)
			if inst.AnimState:AnimDone() then
				inst.sg:GoToState("idle")
			end
		end),
	},

	onexit = function(inst)
		if inst.sg.statemem.houzuoli_thread then 
			KillThread(inst.sg.statemem.houzuoli_thread)
		end 
		inst.Physics:Stop()
	end,
})

table.insert(CLIENT_SG,State{
	name = "tz_rpg_charging_pre",
	tags = { "attack","charging_attack", "charging_attack_pre", "doing", "busy" },

	onenter = function(inst)
		inst.components.locomotor:Stop()
		
		inst.AnimState:PlayAnimation("xuli_pre")
		inst.AnimState:PushAnimation("xuli_loop")

		inst:PerformPreviewBufferedAction()
	end,

	timeline = {

	},

	onupdate = function(inst)
		TzStategraph.ClientChargePreUpdate(inst,{
			last_anim = "xuli_loop",
			attack_sg_name = "tz_rpg_charging",
		})
	end,
})

table.insert(CLIENT_SG,State{
	name = "tz_rpg_charging",
	tags = { "attack","charging_attack", "doing", "busy", "notalking"},

	onenter = function(inst)
		inst.components.locomotor:Stop()

		inst:PerformPreviewBufferedAction()
	end,
	timeline =
	{
		TimeEvent(4 * FRAMES, function(inst)
			inst.sg:RemoveStateTag("doing")
			inst.sg:RemoveStateTag("busy")
			inst.sg:RemoveStateTag("attack")
			inst.sg:AddStateTag("idle")
		end),

		TimeEvent(18 * FRAMES, function(inst)
			inst.sg:GoToState("idle", true)
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
})

for k,v in pairs(SERVER_SG) do 
	AddStategraphState("wilson",v)
end 

for k,v in pairs(CLIENT_SG) do 
	AddStategraphState("wilson_client",v)
end 

----------------------------------------------------------------------------------

local function CanUseCharge(inst)
	local weapon = (inst.components.combat and inst.components.combat:GetWeapon()) or (inst.replica.combat and inst.replica.combat:GetWeapon())
	local is_riding = (inst.components.rider and inst.components.rider:IsRiding()) or (inst.replica.rider and inst.replica.rider:IsRiding())
	return weapon and weapon:HasTag("tz_chargeable_weapon") and not is_riding
end

local function ServerGetChargeSG(inst)
    local weapon = inst.components.combat:GetWeapon()
    local is_riding = inst.components.rider:IsRiding()
    local is_dead = (inst.components.health and inst.components.health:IsDead()) or inst.sg:HasStateTag("dead") or inst:HasTag("playerghost")
    if CanUseCharge(inst) then 
		if weapon:HasTag("tz_rpg") then 
			if weapon:HasTag("tz_rpg_nobattery") then 
        		inst.SoundEmitter:PlaySound("tz_rpg/"..TUNING.TZ_RPG_CONFIG.SOUND_NAME.."/empty_click",nil,nil,true)
				return false
			elseif weapon:HasTag("tz_rpg_overheated") then 
				return false
			elseif weapon:HasTag("usesdepleted") then
				return false
			else 
				return "tz_rpg_charging_pre"
			end 
		end 
    end
end

local function ClientGetChargeSG(inst)
    local weapon = inst.replica.combat:GetWeapon()
    local is_riding = inst.replica.rider:IsRiding()
    local is_dead = inst.replica.health:IsDead()
    if CanUseCharge(inst) then 
        if weapon:HasTag("tz_rpg") then 
			if weapon:HasTag("tz_rpg_nobattery") then 
        		inst.SoundEmitter:PlaySound("tz_rpg/"..TUNING.TZ_RPG_CONFIG.SOUND_NAME.."/empty_click",nil,nil,true)
				return false
			elseif weapon:HasTag("tz_rpg_overheated") then 
				return false
			elseif weapon:HasTag("usesdepleted") then
				return false
			else 
				return "tz_rpg_charging_pre"
			end 
		end 
    end
end


AddStategraphPostInit("wilson", function(sg)
    local old_ATTACK = sg.actionhandlers[ACTIONS.ATTACK].deststate
    sg.actionhandlers[ACTIONS.ATTACK].deststate = function(inst, action,...)
		local sg = ServerGetChargeSG(inst)
		if sg == false then 
			return
		end
        return sg or old_ATTACK(inst, action,...)
    end
end)
AddStategraphPostInit("wilson_client", function(sg)
    local old_ATTACK = sg.actionhandlers[ACTIONS.ATTACK].deststate
    sg.actionhandlers[ACTIONS.ATTACK].deststate = function(inst, action,...)
		local sg = ClientGetChargeSG(inst)
		if sg == false then 
			return
		end
        return sg or old_ATTACK(inst, action,...)
    end
end)

AddStategraphPostInit("wilson", function(sg)
	local old_attacked = sg.events["attacked"].fn 
	sg.events["attacked"].fn = function(inst,data)
		if not inst.components.health:IsDead() then
			if inst.sg:HasStateTag("charging_attack") then 
				return 
			end

		end

		return old_attacked(inst,data)
	end 
end)

AddPlayerPostInit(function( inst )
	if not TheWorld.ismastersim then 
		return inst
	end 

	inst:AddComponent("tz_weaponcharge")
end)

AddModRPCHandler("tz_rpc","tz_weaponcharge_btn",function(inst,control,pressed)
	inst.components.tz_weaponcharge:SetKey(control,pressed)
end)

AddModRPCHandler("tz_rpc","tz_face_point",function(inst,x,y,z,force)
    local buffer = inst:GetBufferedAction()
    if force or (buffer and buffer.action == ACTIONS.TZ_FREE_CHARGE) then 
        inst:ForceFacePoint(x,y,z)
    end 
end)

AddModRPCHandler("tz_rpc","tz_rpg_reload",function(inst)
	local weapon = inst.components.combat and inst.components.combat:GetWeapon()
	if weapon and weapon.components.tz_rpg_battery and not weapon.components.tz_rpg_battery:IsFull() and inst.sg and not inst.sg:HasStateTag("busy") then 
		weapon.components.tz_rpg_battery:StartReload(true)
	end
end)

TheInput:AddKeyDownHandler(KEY_F1,function()
	SendModRPCToServer(MOD_RPC["tz_rpc"]["tz_rpg_reload"])
end)

local atk_btns = {
	CONTROL_PRIMARY,
    CONTROL_SECONDARY,
	CONTROL_ATTACK,
	-- CONTROL_FORCE_ATTACK,
	CONTROL_CONTROLLER_ATTACK,
}

TheInput:AddGeneralControlHandler(function(control, pressed)
	if ThePlayer then
		if table.contains(atk_btns,control) then 
			SendModRPCToServer(MOD_RPC["tz_rpc"]["tz_weaponcharge_btn"],control,pressed)
		end 

		if control == CONTROL_SECONDARY then 
			if ThePlayer._tz_face_point_task then 
				ThePlayer._tz_face_point_task:Cancel()
				ThePlayer._tz_face_point_task = nil 
			end 
			if pressed then 
				ThePlayer._tz_face_point_task = ThePlayer:DoPeriodicTask(0,function()
					local x,y,z = TheInput:GetWorldPosition():Get()
					ThePlayer:ForceFacePoint(x,y,z)
					SendModRPCToServer(MOD_RPC["tz_rpc"]["tz_face_point"],x,y,z,false)
				end)
			end
		end
	end
	
    
end)

------------------------------------------------------------------------------------------------------
--注册动作
AddAction("TZ_FREE_CHARGE","TZ_FREE_CHARGE",function(act) 
    if CanUseCharge(act.doer) then 
        local weapon = act.invobject or act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        local act_pos = act:GetActionPoint()
        if weapon and act.doer.components.tz_weaponcharge then
            act.doer.components.tz_weaponcharge:DoSmallAttack()
            return true
        end
    end
end) 
ACTIONS.TZ_FREE_CHARGE.priority = -1
ACTIONS.TZ_FREE_CHARGE.customarrivecheck = function() return true end
ACTIONS.TZ_FREE_CHARGE.rmb = true
-- ACTIONS.TZ_FREE_CHARGE.strfn = ACTIONS.ATTACK.strfn
-- STRINGS.ACTIONS.TZ_FREE_CHARGE = STRINGS.ACTIONS.ATTACK
STRINGS.ACTIONS.TZ_FREE_CHARGE = "开炮"

AddComponentAction("POINT", "tz_chargeable_weapon", function(inst, doer, pos, actions, right) 
    if right and CanUseCharge(doer) then 
        table.insert(actions, ACTIONS.TZ_FREE_CHARGE)
    end 
end)

AddComponentAction("EQUIPPED", "tz_chargeable_weapon", function(inst, doer, target, actions, right) 
    if right and CanUseCharge(doer) then 
        table.insert(actions, ACTIONS.TZ_FREE_CHARGE)
    end 
end)


AddStategraphActionHandler("wilson",ActionHandler(ACTIONS.TZ_FREE_CHARGE, function(inst)
    return ServerGetChargeSG(inst)
end))
AddStategraphActionHandler("wilson_client",ActionHandler(ACTIONS.TZ_FREE_CHARGE,function(inst)
    return ClientGetChargeSG(inst)
end))
--------------------------------------------------------------------------------------------------------

GLOBAL.TUNING.TZ_RPG_CONFIG = {
	-- SOUND_NAME = "deadcells",
	SOUND_NAME = "official",
}

--------------------------------------------------------------------------------------------------------
-- rpg的制作

AddStategraphPostInit('wilson', function(self)
	local emote = self.states.emote 
	if emote then
		local old_enter = emote.onenter
		emote.onenter = function(inst,data,...)
			if old_enter then 
				old_enter(inst, data ,...)
			end
			if data and data.anim and  type(data.anim) == "table" then
				for i , v in ipairs(data.anim) do
					if v and type(v) == "table" and (table.contains(v,"emote_pre_sit2") or table.contains(v,"emote_pre_sit4")) then
						if inst.components.inventory and inst.components.inventory:EquipHasTag("tz_fhbm") then
							inst.SoundEmitter:PlaySound("tz_fhbmbgm/tz_fhbmbgm/sit", "tz_fhbmbgm_sit")
						end
						break
					end
				end
			end
		end
		local old_onexit = emote.onexit
		emote.onexit = function(inst,...)
			if old_onexit then 
				old_onexit(inst ,...)
			end	
			inst.SoundEmitter:KillSound("tz_fhbmbgm_sit")		
		end
	end
end)