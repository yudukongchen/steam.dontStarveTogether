local MakePlayerCharacter = require "prefabs/player_common"


local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
}
local prefabs = {}

local start_inv = {
	"kafei",
	"kafei",
	"kafei",
	"kafei",
	"cane",
}

local function onbecamehuman(inst)
	inst.components.locomotor:SetExternalSpeedMultiplier(inst, "veneto_speed_mod", 1)
end

local function onbecameghost(inst)
   inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "veneto_speed_mod")
end


local function onload(inst)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    inst:ListenForEvent("ms_becameghost", onbecameghost)

    if inst:HasTag("playerghost") then
        onbecameghost(inst)
    else
        onbecamehuman(inst)
    end
	inst.shon = 1
	inst.reload = 1
end

local function v_skill(inst,x,y,z,a,b,c)
	local zb = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
	if inst.components.inventory:Has("veneto_paodan", 1) then
	if zb and zb.prefab == "veneto_jz" or zb and zb.prefab == "veneto_jzyf" then
	if inst.reload and inst.reload > 0 then 
		inst.reload = 0
		inst.components.talker:Say("猜猜看...我会怎么击败你？")
		inst.sg:GoToState("gnaw")
		local pd = SpawnPrefab("veneto_paodanfz")
		local a, b, c = inst.Transform:GetWorldPosition()
		pd.Transform:SetPosition(a, 1, c)
			local mouse = Vector3(x,y,z)
			local dx = mouse.x - a
			local dz = mouse.z - c
			local l = dx * dx + dz * dz
			if l <= 0 then
				return 
			end
			l = 6.5 / math.sqrt(l)
		pd.components.projectile:RotateToTarget(Vector3(x + dx * l, 0, z + dz * l))
		pd.Physics:SetMotorVel(25, 0, 0)
		pd.components.projectile.inst:StartUpdatingComponent(pd.components.projectile)
		pd.components.projectile.OnUpdate = function()
			for i, v in pairs(TheSim:FindEntities(x, 0, z, 1)) do
				if v == pd then
					a, b, c = pd.Transform:GetWorldPosition()
					for i, h in pairs(TheSim:FindEntities(a, 0, c, 4)) do
						if h ~= inst and h.components.health ~= nil and not h.components.health:IsDead() and h.components.combat ~= nil and not h:HasTag("player") then
							h.components.combat:GetAttacked(h, 1389)
							
						    h:PushEvent("attacked", { attacker = inst, damage = 1389, damageresolved = 1389, weapon = nil })
							if h.components.combat ~= nil and h.components.combat.onhitfn ~= nil then
								h.components.combat.onhitfn(h, inst, 1389)
							end

							inst:PushEvent("onhitother", { target = h, damage = 1389, damageresolved = 1389, weapon = nil })
								if inst ~= nil and inst.onhitotherfn ~= nil then
									inst.onhitotherfn(inst, h, 1389, nil)
								end

							if h.components.health:IsDead() then
								inst:PushEvent("killed", { victim = h })

								if h.components.combat ~= nil and h.components.combat.onkilledbyother ~= nil then
									h.components.combat.onkilledbyother(h, inst)
								end
							end
						end
					end
					SpawnPrefab("explode_small").Transform:SetPosition(pd.Transform:GetWorldPosition())
					pd:Remove()
					inst:DoTaskInTime(5,function()
						if inst.reload <= 0 then
							inst.reload = 1
						end
					end)
				end
			end
		inst:DoTaskInTime(5,function()
			if pd ~= nil then
				pd:Remove()
				if inst.reload <= 0 then
					inst.reload = 1
				end
			end
		end)
		end
		inst.components.inventory:ConsumeByName("veneto_paodan", 1)
	else 
		inst.components.talker:Say("主炮装填中")
	end
	else 
		inst.components.talker:Say("这样做没有品味，应该好好穿上舰装才行")
	end
	else
		inst.components.talker:Say("没带子弹怎么和别人火拼？")	
	end
	
end
AddModRPCHandler("veneto", "v_skill", v_skill)

local common_postinit = function(inst) 
	inst.MiniMapEntity:SetIcon( "veneto.tex" )
	inst:AddComponent("zg_keyhandler_veneto")
	inst.components.zg_keyhandler_veneto:AddActionListener("veneto", KEY_V, "v_skill")
end


local master_postinit = function(inst)
	inst.soundsname = "wendy"
	inst.components.health:SetMaxHealth(300)
	inst.components.hunger:SetMax(130)
	inst.components.sanity:SetMax(150)
    inst.components.combat.damagemultiplier = 1
	inst.components.hunger.hungerrate = 1 * TUNING.WILSON_HUNGER_RATE
	
	if TUNING.AOE == 1 then
		inst.components.combat.areahitrange = 2
	end
	
	local old_GetAttacked = inst.components.combat.GetAttacked
	function inst.components.combat:GetAttacked(attacker, damage, weapon, stimuli)
		if inst.shon and inst.shon > 0 then
			inst:DoTaskInTime(0,function()
			end)
			if inst.shp == nil then
				inst.shp = SpawnPrefab("forcefieldfx")
				inst.shp.entity:SetParent(inst.entity)
				inst.shp.Transform:SetPosition(0, 0.2, 0)
			end
			inst:DoTaskInTime(1,function()
				if inst.shp then
					inst.shp:Remove()
					inst.shp = nil
					inst.shon = 0
				end
			end)
			inst:DoTaskInTime(15,function()
				if inst.shon <= 0 then
					inst.shon = 1
				end
			end)
			return
		end
		return old_GetAttacked(self, attacker, damage, weapon, stimuli)
	end
	
	inst:AddTag("VV")
	inst:AddTag("BB")
	inst.OnLoad = onload
    inst.OnNewSpawn = onload
	
end

return MakePlayerCharacter("veneto", prefabs, assets, common_postinit, master_postinit, start_inv)
