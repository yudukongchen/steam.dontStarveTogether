local TzFh = require("util/tz_fh")

local function IsHUDScreen()
	local s = TheFrontEnd:GetActiveScreen()
	if s then
		if s:IsEditing() then
			return false
		elseif type(s.name)  == "string" and s.name == "HUD" then
			return true
		end
	end
	return false
end


local fh_fmt = "-- %s\n%s = {\"USER_ID\"},"
GLOBAL.fh_names = function()
    for k,v in pairs(STRINGS.NAMES) do 
        if type(v) == "string" and v:find("番号") then
            print(string.format(fh_fmt,v,k:lower()))
        end
    end
end

local function LockRecipe(self,recname)
    if  table.contains(self.recipes, recname) then
        RemoveByValue(self.recipes, recname)
    end
    self.inst.replica.builder:RemoveRecipe(recname)  
end
local function unlock(inst)
    if inst.prefab == "taizhen" and inst.userid ~= nil and type(inst.userid) == "string" then
        for fh_prefab_name,_ in pairs(TzFh.WHITE_LIST) do
            if TzFh.IsWhiteListOwner(inst,fh_prefab_name) then
                if not inst.components.builder:KnowsRecipe(fh_prefab_name) then
                    inst.components.builder:UnlockRecipe(fh_prefab_name)
                end
            else
                LockRecipe(inst.components.builder,fh_prefab_name)
            end
        end
    end    
end
AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then 
		return inst
	end 
    --inst.Tz_FH_Recipe_UnLockfn = unlock
    inst:ListenForEvent("TzSkinUpdate_Event", unlock)
    inst:DoTaskInTime(5,unlock)
end)


local skillfn = {
    tz_fhbm_skill = function(inst)--  tz_fhbm skills
        if not inst:HasTag("playerghost") and not inst.sg:HasStateTag("dead") 
            and inst.components.health and not inst.components.health:IsDead() then
            local weapon = inst.components.combat:GetWeapon()
            if weapon and weapon.prefab == "tz_fhbm" then
                weapon:TryTrigerSkill(inst,180)
            end
        end
    end,
    tz_fhym_skill =function(inst) ---tz_fhym skills
        if not inst:HasTag("playerghost") and not inst.sg:HasStateTag("dead") 
            and inst.components.health and not inst.components.health:IsDead() then
                
            local weapon = inst.components.combat:GetWeapon()
            if weapon and weapon.prefab == "tz_fhym" then
                weapon:TryTrigerSkill(inst)
            end
        end
    end,
    tz_fhhf_skill = function(inst)--  tz_fh_hf skills
        if not inst:HasTag("playerghost") and not inst.sg:HasStateTag("dead") 
            and inst.components.health and not inst.components.health:IsDead() then
            local weapon = inst.components.combat:GetWeapon()
            if weapon and weapon.prefab == "tz_fh_hf" then
                weapon:TryTrigerSkill(inst)
            end
        end
    end,
}
local checkstring = GLOBAL.checkstring
AddModRPCHandler("tz_hf_rpcs","tz_hf_rpcs",function(inst,str,value1,value2)
    if checkstring(str) and skillfn[str] then
        skillfn[str](inst)
    end
end)

local fh_skill_keys = { --按键和技能
    [KEY_K] = {"tz_fhbm_skill","tz_fhym_skill"},
    [KEY_L] = "tz_fhhf_skill",  
}
for k, v in pairs(fh_skill_keys) do
    TheInput:AddKeyDownHandler(k, function()
        if IsHUDScreen() then
            if type(v) == "table" then
                for k1,v1 in ipairs(v) do
                    SendModRPCToServer(MOD_RPC["tz_hf_rpcs"]["tz_hf_rpcs"],v1)
                end
            else
                SendModRPCToServer(MOD_RPC["tz_hf_rpcs"]["tz_hf_rpcs"],v)
            end
        end
    end)
end

-------------------------------------------------------------------------------------------------
--  tz_fhzlz skills and SG
-------------------------------------------------------------------------------------------------
local function DoTzFhzlzMultithrust(inst)
    inst.components.combat:DoAreaAttack(inst, 3.5, inst.components.combat:GetWeapon(), function(v,inst)
        local myangle = inst:GetRotation()
        local faceguyangle = inst:GetAngleToPoint(v:GetPosition():Get()) 
        local deltaangle = math.abs(myangle - faceguyangle)

        if deltaangle > 180 then 
            deltaangle = 360 - deltaangle
        end

        return deltaangle <= 55 and inst.components.combat:CanTarget(v) and not inst.components.combat:IsAlly(v)
    end, nil, {"INLIMBO"})
end

AddStategraphState("wilson",State{
    name = "tz_fhzlz_multithrust",
    tags = { "aoe", "doing", "busy", "nointerrupt", "nomorph","nopredict" },
    onenter = function(inst)
        inst.Physics:Stop()
        
        inst.AnimState:PlayAnimation("multithrust")
        inst.Transform:SetEightFaced()

        inst.sg:SetTimeout(28 * FRAMES)
    end,
    timeline =
    {
        TimeEvent(7 * FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
            inst:PerformBufferedAction()
            DoTzFhzlzMultithrust(inst)
        end),
        TimeEvent(9 * FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
            DoTzFhzlzMultithrust(inst)
        end),
        TimeEvent(11 * FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
            DoTzFhzlzMultithrust(inst)
        end),

        TimeEvent(15 * FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
            DoTzFhzlzMultithrust(inst)
        end),

        TimeEvent(19 * FRAMES, function(inst)
            inst.sg:RemoveStateTag("abouttoattack")
            inst.sg:RemoveStateTag("attack")
        end),
    },

    ontimeout = function(inst)
        inst.sg:GoToState("idle", true)
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
        inst.Transform:SetFourFaced()
    end,
    
})


-------------------------------------------------------------------------------------------------

AddStategraphState('wilson', State{
    name = "tz_you_attack",
    tags = { "attack", "notalking", "abouttoattack", "autopredict" },

    onenter = function(inst)
        if inst.components.combat:InCooldown() then
            inst.sg:RemoveStateTag("abouttoattack")
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle", true)
            return
        end
        local buffaction = inst:GetBufferedAction()
        local target = buffaction ~= nil and buffaction.target or nil
        local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        inst.components.combat:SetTarget(target)
        inst.components.combat:StartAttack()
        inst.components.locomotor:Stop()

        inst.AnimState:PlayAnimation("tz_you_attack_pre")
        if inst.sg.laststate == inst.sg.currentstate then
            inst.sg.statemem.chained = true
            inst.AnimState:SetTime(5 * FRAMES)
        end
        inst.AnimState:PushAnimation("tz_you_attack", false)

        inst.sg:SetTimeout(math.max((inst.sg.statemem.chained and 14 or 18) * FRAMES, inst.components.combat.min_attack_period + .5 * FRAMES))

        if target ~= nil and target:IsValid() then
            inst:FacePoint(target.Transform:GetWorldPosition())
            inst.sg.statemem.attacktarget = target
        end

        if (equip ~= nil and equip.projectiledelay or 0) > 0 then
            inst.sg.statemem.projectiledelay = (inst.sg.statemem.chained and 9 or 14) * FRAMES - equip.projectiledelay
            if inst.sg.statemem.projectiledelay <= 0 then
                inst.sg.statemem.projectiledelay = nil
            end
        end
    end,

    onupdate = function(inst, dt)
        if (inst.sg.statemem.projectiledelay or 0) > 0 then
            inst.sg.statemem.projectiledelay = inst.sg.statemem.projectiledelay - dt
            if inst.sg.statemem.projectiledelay <= 0 then
                inst:PerformBufferedAction()
                inst.sg:RemoveStateTag("abouttoattack")
            end
        end
    end,

    timeline =
    {
        TimeEvent(8 * FRAMES, function(inst)
            if inst.sg.statemem.chained then
                inst.SoundEmitter:PlaySound("dontstarve/wilson/blowdart_shoot", nil, nil, true)
            end
        end),
        TimeEvent(9 * FRAMES, function(inst)
            if inst.sg.statemem.chained and inst.sg.statemem.projectiledelay == nil then
                inst:PerformBufferedAction()
                inst.sg:RemoveStateTag("abouttoattack")
            end
        end),
        TimeEvent(13 * FRAMES, function(inst)
            if not inst.sg.statemem.chained then
                inst.SoundEmitter:PlaySound("dontstarve/wilson/blowdart_shoot", nil, nil, true)
            end
        end),
        TimeEvent(14 * FRAMES, function(inst)
            if not inst.sg.statemem.chained and inst.sg.statemem.projectiledelay == nil then
                inst:PerformBufferedAction()
                inst.sg:RemoveStateTag("abouttoattack")
            end
        end),
    },

    ontimeout = function(inst)
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")
    end,

    events =
    {
        EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)
        inst.components.combat:SetTarget(nil)
        if inst.sg:HasStateTag("abouttoattack") then
            inst.components.combat:CancelAttack()
        end
    end,
})

AddStategraphState('wilson_client', State{
    name = "tz_you_attack",
    tags = { "attack", "notalking", "abouttoattack" },

    onenter = function(inst)
        local buffaction = inst:GetBufferedAction()
        if inst.replica.combat ~= nil then
            if inst.replica.combat:InCooldown() then
                inst.sg:RemoveStateTag("abouttoattack")
                inst:ClearBufferedAction()
                inst.sg:GoToState("idle", true)
                return
            end
            inst.replica.combat:StartAttack()
            inst.sg:SetTimeout(math.max((inst.sg.statemem.chained and 14 or 28) * FRAMES, inst.replica.combat:MinAttackPeriod() + .5 * FRAMES))
        end
        local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        inst.components.locomotor:Stop()

        inst.AnimState:PlayAnimation("tz_you_attack_pre")
        if inst.sg.laststate == inst.sg.currentstate then
            inst.sg.statemem.chained = true
            inst.AnimState:SetTime(5 * FRAMES)
        end
        inst.AnimState:PushAnimation("tz_you_attack", false)

        if buffaction ~= nil then
            inst:PerformPreviewBufferedAction()

            if buffaction.target ~= nil and buffaction.target:IsValid() then
                inst:FacePoint(buffaction.target:GetPosition())
                inst.sg.statemem.attacktarget = buffaction.target
            end
        end

        if (equip.projectiledelay or 0) > 0 then
            inst.sg.statemem.projectiledelay = (inst.sg.statemem.chained and 9 or 14) * FRAMES - equip.projectiledelay
            if inst.sg.statemem.projectiledelay <= 0 then
                inst.sg.statemem.projectiledelay = nil
            end
        end
    end,

    onupdate = function(inst, dt)
        if (inst.sg.statemem.projectiledelay or 0) > 0 then
            inst.sg.statemem.projectiledelay = inst.sg.statemem.projectiledelay - dt
            if inst.sg.statemem.projectiledelay <= 0 then
                inst:ClearBufferedAction()
                inst.sg:RemoveStateTag("abouttoattack")
            end
        end
    end,

    timeline =
    {
        TimeEvent(8 * FRAMES, function(inst)
            if inst.sg.statemem.chained then
                inst.SoundEmitter:PlaySound("dontstarve/wilson/blowdart_shoot", nil, nil, true)
            end
        end),
        TimeEvent(9 * FRAMES, function(inst)
            if inst.sg.statemem.chained and inst.sg.statemem.projectiledelay == nil then
                inst:ClearBufferedAction()
                inst.sg:RemoveStateTag("abouttoattack")
            end
        end),
        TimeEvent(13 * FRAMES, function(inst)
            if not inst.sg.statemem.chained then
                inst.SoundEmitter:PlaySound("dontstarve/wilson/blowdart_shoot", nil, nil, true)
            end
        end),
        TimeEvent(14 * FRAMES, function(inst)
            if not inst.sg.statemem.chained and inst.sg.statemem.projectiledelay == nil then
                inst:ClearBufferedAction()
                inst.sg:RemoveStateTag("abouttoattack")
            end
        end),
    },

    ontimeout = function(inst)
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")
    end,

    events =
    {
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)
        if inst.sg:HasStateTag("abouttoattack") and inst.replica.combat ~= nil then
            inst.replica.combat:CancelAttack()
        end
    end,
})  

