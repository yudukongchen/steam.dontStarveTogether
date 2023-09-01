AddAction("TZ_RPG_EMPEROR_UPGRATE", "TZ_RPG_EMPEROR_UPGRATE", function(act)
	if act.target and act.target.components.tz_rpg_emperor_upgrate then
        
		if act.target.components.tz_rpg_emperor_upgrate:IsUpgrated() then
			if act.doer and act.doer.components.talker then
				act.doer.components.talker:Say("已经升级过了。")
			end
		else 
			act.target.components.tz_rpg_emperor_upgrate:Enable(true)
			act.invobject:Remove()
		end

        return true 
	end
	return false
end)

ACTIONS.TZ_RPG_EMPEROR_UPGRATE.priority = 10


STRINGS.ACTIONS.TZ_RPG_EMPEROR_UPGRATE = "融合"

AddComponentAction("USEITEM", "tz_pugalisk_crystal", function(inst, doer, target, actions, right) 
	if doer:HasTag("player") and inst:HasTag("tz_pugalisk_crystal") and target:HasTag("tz_rpg_emperor_upgrate") then
		table.insert(actions, ACTIONS.TZ_RPG_EMPEROR_UPGRATE)
	end
end)

AddStategraphActionHandler("wilson",ActionHandler(ACTIONS.TZ_RPG_EMPEROR_UPGRATE, "doshortaction"))
AddStategraphActionHandler("wilson_client",ActionHandler(ACTIONS.TZ_RPG_EMPEROR_UPGRATE, "doshortaction"))
-- 