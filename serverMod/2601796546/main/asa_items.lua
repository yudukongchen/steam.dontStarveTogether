--道具相关

local ASA_REPAIR = GLOBAL.Action({priority=98, ghost_valid=false, mount_valid=false, encumbered_valid=true })
ASA_REPAIR.id = "ASA_REPAIR"
ASA_REPAIR.str = GLOBAL.STRINGS.ASA_REPAIR
ASA_REPAIR.fn = function(act)
	
	--act.doer.components.asa_power:MaxDelta(1)
	
	if act.doer.components.health.penalty > 0 then
		act.doer.components.health:DeltaPenalty(-0.25)
	end
	act.doer.components.health:DoDelta(40)
	act.doer.SoundEmitter:PlaySound("dontstarve/characters/wx78/levelup")
	act.invobject.components.finiteuses:Use(1)
	
	return true
end
AddAction(ASA_REPAIR)

local ASA_BOOST = GLOBAL.Action({ priority=99, ghost_valid=false, mount_valid=false, encumbered_valid=true })
ASA_BOOST.id = "ASA_BOOST"
ASA_BOOST.str = GLOBAL.STRINGS.ASA_CHARGE
ASA_BOOST.fn = function(act)
	act.doer.components.asa_power.boost = 30
	act.doer.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/charge")
	act.doer.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/equip")
	if act.invobject.components.stackable.stacksize > 1 then
		act.invobject.components.stackable:SetStackSize(act.invobject.components.stackable.stacksize - 1)
	else
		act.invobject:Remove()
	end
	return true
end
AddAction(ASA_BOOST)

local ASA_ITEMREPAIR = GLOBAL.Action({priority=98, ghost_valid=false, mount_valid=false, encumbered_valid=true })
ASA_ITEMREPAIR.id = "ASA_ITEMREPAIR"
ASA_ITEMREPAIR.str = GLOBAL.STRINGS.ASA_REPAIR
ASA_ITEMREPAIR.fn = function(act)
	act.doer.SoundEmitter:PlaySound("dontstarve/characters/wx78/levelup")
	if act.target:HasTag("asa_shield_drone") then
		act.target.components.fueled:SetPercent(act.target.components.fueled:GetPercent() + act.invobject.components.finiteuses:GetUses()/5)
		act.invobject:Remove()
	else
		act.invobject.components.finiteuses:Use(1)
		act.target.components.fueled:SetPercent(1)
	end
	return true
end
AddAction(ASA_ITEMREPAIR)

AddStategraphActionHandler("wilson",GLOBAL.ActionHandler(GLOBAL.ACTIONS.ASA_REPAIR, "dolongaction"))
AddStategraphActionHandler("wilson_client",GLOBAL.ActionHandler(GLOBAL.ACTIONS.ASA_REPAIR, "dolongaction"))

AddStategraphActionHandler("wilson",GLOBAL.ActionHandler(GLOBAL.ACTIONS.ASA_BOOST, "doshortaction"))
AddStategraphActionHandler("wilson_client",GLOBAL.ActionHandler(GLOBAL.ACTIONS.ASA_BOOST, "doshortaction"))

AddStategraphActionHandler("wilson",GLOBAL.ActionHandler(GLOBAL.ACTIONS.ASA_ITEMREPAIR, "dolongaction"))
AddStategraphActionHandler("wilson_client",GLOBAL.ActionHandler(GLOBAL.ACTIONS.ASA_ITEMREPAIR, "dolongaction"))

AddComponentAction("INVENTORY", "asa_healer", function(inst, doer, actions, right)
    if doer:HasTag("asakiri") or doer.prefab == "wx78" then
		table.insert(actions, GLOBAL.ACTIONS.ASA_REPAIR)
	end
end)

AddComponentAction("INVENTORY", "asa_booster", function(inst, doer, actions, right)
    if doer:HasTag("asakiri") then
		table.insert(actions, GLOBAL.ACTIONS.ASA_BOOST)
	end
end)

AddComponentAction("USEITEM", "asa_repairer", function(inst, doer, target, actions, right)
    if target:HasTag("asa_item") then
		table.insert(actions, GLOBAL.ACTIONS.ASA_ITEMREPAIR)
	end
end)