
AddMinimapAtlas("images/map_icons/tz_elong.xml")
AddMinimapAtlas("images/map_icons/tz_elong_horn.xml")
TUNING.TZ_ELONGMAXHEALTH = 2000
STRINGS.NAMES.TZ_ELONG_HORN = "饿龙召唤之笛"
STRINGS.RECIPE_DESC.TZ_ELONG_HORN = "嗷呜！"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TZ_ELONG_HORN = "召唤一只拉轰的嗷呜！"
STRINGS.NAMES.TZ_ELONG = "饿龙"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TZ_ELONG = "饿龙"

local oldPlayFootstep=GLOBAL.PlayFootstep
GLOBAL.PlayFootstep=function(inst, ...)
	if inst.ellong_riding ~= nil and inst.ellong_riding:value() then
        inst.SoundEmitter:PlaySoundWithParams("dontstarve/creatures/together/hutch/land_hit")
		return
	end
	return oldPlayFootstep(inst, ...)
end
AddPlayerPostInit(function(inst)
	inst.elong_health = net_ushortint(inst.GUID, "tz.elonghealth", "elonghealthdrity")
	inst.elong_name = net_string(inst.GUID, "tz.elongname", "elongnamedrity")
	inst.ellong_riding = net_bool(inst.GUID, "tz.ellongriding", "elengridingdrity")

    if not TheWorld.ismastersim then
        return
    end
	inst:ListenForEvent("mounted",function(inst,data)
		if data and data.target and  data.target:HasTag("elong") then
            if inst.AnimState then
                inst.AnimState:SetBank("tz_elong")
				inst.AnimState:PlayAnimation(inst.sg.statemem.heavy and "heavy_mount" or "mount")   -- SetBank 完记得刷新一下动画
            end
            if inst.DynamicShadow then
                inst.DynamicShadow:SetSize(3, 2)
            end
            inst.elong_health:set(data.target.components.health.currenthealth)
            inst.elong_name:set(data.target:GetBasicDisplayName())
            inst.ellong_riding:set(true)
            inst:AddTag("elongriding")	
            inst.components.combat:SetRange(TUNING.DEFAULT_ATTACK_RANGE+1)
		end
	end)
	inst:ListenForEvent("dismounted",function(inst,data)
		if data and data.target and  data.target:HasTag("elong") then
            inst.ellong_riding:set(false)
            inst:RemoveTag("elongriding")
            inst.components.combat:SetRange(TUNING.DEFAULT_ATTACK_RANGE)
		end
	end)
end)


local tz_elongnameui = require("widgets/tz_elongnameui")
local tz_elonghealthui = require("widgets/tz_elonghealthui")
local function elongui(self)
	self.tz_elongnameui = self:AddChild(tz_elongnameui(self.owner))
	self.tz_elongnameui:SetVAnchor(ANCHOR_MIDDLE)
	self.tz_elongnameui:SetHAnchor(ANCHOR_MIDDLE)
	self.tz_elongnameui:Hide()

	self.tz_elonghealthui = self:AddChild(tz_elonghealthui(self.owner))	
	self.tz_elonghealthui:SetPosition(-300, -100)
end
AddClassPostConstruct("widgets/statusdisplays", elongui)

local  TZ_ELONG = Action({ priority=1 })
TZ_ELONG.id = "TZ_ELONG"
TZ_ELONG.strfn = function(act)
    local target = act.invobject or act.target
    return target and target:HasTag("haselongname") and "USE" or "NAME"
end
TZ_ELONG.fn = function(act)
    local obj = act.invobject or act.target
    if obj and act.doer  then
        if not obj:HasTag("haselongname") then
			act.doer.elong_horn = obj
			SendModRPCToClient(CLIENT_MOD_RPC["tzelongclientdprc"]["tzelongclientdprc"],act.doer.userid)
			return true
		elseif obj.components.aowu_elong then
			local pet = obj.components.aowu_elong.pet
			if pet then
				if pet.components.rideable:IsBeingRidden() then
					return false
				end
				obj.components.aowu_elong:DoDespawnPet()
			elseif obj.components.aowu_elong.savedpet ~= nil then
				obj.components.aowu_elong:SpawnSavedPet(act.doer)
			else
				obj.components.aowu_elong:SpawnPet("tz_elong",act.doer)
			end
			return true
		end
    end
end
AddAction(TZ_ELONG)

AddComponentAction("INVENTORY", "aowu_elong" , function(inst, doer, actions)
    table.insert(actions, ACTIONS.TZ_ELONG)
end)

AddStategraphActionHandler("wilson",ActionHandler(ACTIONS.TZ_ELONG, 
function(inst, action)
    local target = action.target or action.invobject
    if target and target:HasTag("haselongname") then
		return "elongplay"
	end
	return "doshortaction"
end))

AddStategraphActionHandler("wilson_client",ActionHandler(ACTIONS.TZ_ELONG,
function(inst, action)
	local target = action.target or action.invobject
	if target and target:HasTag("haselongname") then
		return "play_horn"
	end
	return "doshortaction"
end))

STRINGS.ACTIONS.TZ_ELONG = {
    NAME = "命名",
    USE = "召唤",
}

AddStategraphState('wilson',
    State{
        name = "elongplay",
        tags = { "doing", "playing" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("action_uniqueitem_pre")
            inst.AnimState:PushAnimation("horn", false)
            inst.AnimState:OverrideSymbol("horn01", "tz_elong_horn", "horn01")
            inst.AnimState:Show("ARM_normal")
            inst.components.inventory:ReturnActiveActionItem(inst.bufferedaction ~= nil and inst.bufferedaction.invobject or nil)
        end,

        timeline =
        {
            TimeEvent(21 * FRAMES, function(inst)
                if inst:PerformBufferedAction() then
                    inst.SoundEmitter:PlaySound("dontstarve/common/horn_beefalo")
                else
                    inst.AnimState:SetTime(48 * FRAMES)
                end
            end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
                inst.AnimState:Show("ARM_carry")
                inst.AnimState:Hide("ARM_normal")
            end
        end,
	}
)

local function checkstring(val) return type(val) == "string" end
local function checknumber(val) return type(val) == "number" end
AddModRPCHandler( "tzelongrpc", "tzelongrpc", function(inst,num,value)
    if not checknumber(num) then
        return
    end
	if num == 1  and checkstring(value) and inst.elong_horn ~= nil and inst.elong_horn:IsValid() then
		inst.elong_horn.components.aowu_elong:SetName(value)
    elseif num == 2 and inst.ellong_riding ~= nil and inst.ellong_riding:value() then
        if not inst.components.health:IsDead() and inst.sg then
            inst.sg:GoToState("idle")
        end
	end
end)
AddClientModRPCHandler( "tzelongclientdprc", "tzelongclientdprc", function(...)
	if ThePlayer ~= nil then
		ThePlayer:PushEvent("openelongui")
	end
end)

local idridingelong = function(inst)
	local mount = inst.components.rider ~= nil and inst.components.rider:GetMount()
	return mount ~= nil and  mount:HasTag("elong")
end
AddStategraphPostInit("wilson", function(sg)
    local old_emote = sg.events['emote'] and sg.events['emote'].fn
    sg.events['emote'] = EventHandler('emote', function(inst,data,...)
        if idridingelong(inst)  then
			return
        end     
        return old_emote(inst,data,...)
    end)
end)


local function DoToolWork(act)
	if not act.target:IsValid() then
		return false
	end
	local workaction = act.target.components.workable:GetWorkAction()
    if act.target.components.workable ~= nil and
        act.target.components.workable:CanBeWorked() then
        act.target.components.workable:WorkedBy(act.doer,3)
        return true
    end
    return false
end


local  TZ_ELONG_CHOP = Action({distance =2.5,priority=1,mount_valid = true})
TZ_ELONG_CHOP.id = "TZ_ELONG_CHOP"
TZ_ELONG_CHOP.str = "破坏"
TZ_ELONG_CHOP.fn = function(act)
	return DoToolWork(act)
end
AddAction(TZ_ELONG_CHOP)

AddComponentAction("SCENE", "workable" , function(inst, doer, actions, right)
	if doer:HasTag("elongriding") and (inst:HasTag("CHOP_workable") or inst:HasTag("MINE_workable")) then
    	table.insert(actions, ACTIONS.TZ_ELONG_CHOP)
	end
end)
AddStategraphActionHandler("wilson",ActionHandler(ACTIONS.TZ_ELONG_CHOP, "tz_elong_chop"))
AddStategraphActionHandler("wilson_client",ActionHandler(ACTIONS.TZ_ELONG_CHOP, "tz_elong_chop"))

AddStategraphState('wilson',
    State{
        name = "tz_elong_chop",
        tags = { "prechop", "chopping", "working" },
        onenter = function(inst)
			inst.components.locomotor:Stop()
            inst.sg.statemem.action = inst:GetBufferedAction()
			inst.AnimState:PlayAnimation("atk_pre")
			inst.AnimState:PushAnimation("atk", false)
        end,

        timeline =
        {
            TimeEvent(12 * FRAMES, function(inst)
				inst:PerformBufferedAction()
                if inst.sg.statemem.action ~= nil then
                    local target = inst.sg.statemem.action.target
                    if target ~= nil and target:IsValid() and not target:HasTag("CHOP_workable") then
                        local frozen = target:HasTag("frozen")
                        local moonglass = target:HasTag("moonglass")
                        if target.Transform ~= nil then
                            local mine_fx = (frozen and "mining_ice_fx") or (moonglass and "mining_moonglass_fx") or "mining_fx"
                            SpawnPrefab(mine_fx).Transform:SetPosition(target.Transform:GetWorldPosition())
                        end
                        inst.SoundEmitter:PlaySound((frozen and "dontstarve_DLC001/common/iceboulder_hit") or (moonglass and "turnoftides/common/together/moon_glass/mine") or "dontstarve/wilson/use_pick_rock")
                    end
                end
            end),
            TimeEvent(16 * FRAMES, function(inst)
				inst.sg:RemoveStateTag("chopping")
            end),
        },
        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
	}
)

AddStategraphState('wilson_client',
    State{
        name = "tz_elong_chop",
        tags = { "prechop", "chopping", "working" },
        onenter = function(inst)
			inst.components.locomotor:Stop()
			inst.AnimState:PlayAnimation("atk_pre")
			inst.AnimState:PushAnimation("atk", false)
			inst:PerformPreviewBufferedAction()
            inst.sg:SetTimeout(2)
        end,
        onupdate = function(inst)
            if inst:HasTag("working") then
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

local ChatInputScreen = require "screens/chatinputscreen"
local old = ChatInputScreen.Run
function ChatInputScreen:Run(...)
    local chat_string = self.chat_edit:GetString()
    chat_string = chat_string ~= nil and chat_string:match("^%s*(.-%S)%s*$") or ""
    if chat_string == "elong" then
        SendModRPCToServer( MOD_RPC["tzelongrpc"]["tzelongrpc"],2)
       return
    end
    return old(self,...)
end