GLOBAL.setmetatable(env,{__index=function(t,k) 
    return GLOBAL.rawget(GLOBAL,k) 
end})

TUNING.warghealth = GetModConfigData("warghealth")
TUNING.flyhealth = GetModConfigData("flyhealth")
TUNING.warglethealth = GetModConfigData("warglethealth")
TUNING.rehealth = GetModConfigData("rehealth")
TUNING.wolf = GetModConfigData("wolf")

local function grow(inst,data)
    if data ~= nil then
        if data.name == "grow" then
            local idle = SpawnPrefab("shadow_boom")
			local x,y,z = inst:GetPosition():Get()
            idle.Transform:SetPosition(x,y,z)
			inst.components.locomotor:Stop()
			if inst.brain then
				inst.brain:Stop()
			end
			idle.AnimState:SetAddColour(1,1,1, 1)	
			inst:DoTaskInTime(3,function()
			    inst.Transform:SetPosition(x,y,z)
			end)
			inst:DoTaskInTime(3,function()
			    local m = SpawnPrefab("statue_transition_2") 
				m.Transform:SetScale(3,3,3) 
				m.Transform:SetPosition(x,y,z)

				leader = inst.components.follower:GetLeader()
				inst:Remove()
				leader.components.petleash:SpawnPetAt(x,y,z,"_warg")

				idle:Remove()
            end)
		end
    end
end

AddPrefabPostInit("critter_puppy", function(inst)
	if not TheWorld.ismastersim then
	    return inst
	end
    inst.components.timer:StartTimer("grow", GetModConfigData("time_warg")*480)
    inst:ListenForEvent("timerdone", grow)
end)

local function grow1(inst,data)
    if data ~= nil then
        if data.name == "grow" then
            local idle = SpawnPrefab("shadow_boom")
			local x,y,z = inst:GetPosition():Get()
            idle.Transform:SetPosition(x,y,z)
			inst.components.locomotor:Stop()
			if inst.brain then
				inst.brain:Stop()
			end
			idle.AnimState:SetAddColour(1,1,1, 1)	
			inst:DoTaskInTime(3,function()
			    inst.Transform:SetPosition(x,y,z)
			end)
			inst:DoTaskInTime(3,function()
			    local m = SpawnPrefab("statue_transition_2") 
				m.Transform:SetScale(3,3,3) 
				m.Transform:SetPosition(x,y,z)

				leader = inst.components.follower:GetLeader()
				inst:Remove()
				leader.components.petleash:SpawnPetAt(x,y,z,"_dragonfly")

				idle:Remove()
            end)
		end
    end
end

AddPrefabPostInit("critter_dragonling", function(inst)
	if not TheWorld.ismastersim then
	    return inst
	end
    inst.components.timer:StartTimer("grow", GetModConfigData("time_fly")*480)
    inst:ListenForEvent("timerdone", grow1)
end)

AddPrefabPostInit("poop", function(inst)
    inst:AddComponent("tradable")
end)

AddPrefabPostInit("dragon_scales", function(inst)
    inst:AddComponent("tradable")
end)

AddPrefabPostInit("houndstooth", function(inst)
    inst:AddComponent("tradable")
end)

PrefabFiles = 
{
"shadow_boom",
"_warg",
"_dragonfly",
"_warglet"
}



local FOLLOWME = Action({ priority=100, rmb=true, distance=20})
FOLLOWME.id="FOLLOWME"
FOLLOWME.str="跟我走着 Follow me"
FOLLOWME.fn = function(act)
    local player = act.doer
	local inst = act.target
	inst:AddTag("followme")
	inst.followme = true
	inst.components.follower:SetLeader(player)
	if inst.brain then 
		inst.brain:Start()
	end
	if player.components.talker then
		player.components.talker:Say("枪在手，跟我走！ Let's go!")
	end
	
    if not TheWorld.ismastersim then
        return true
    end
	inst.stoptask = nil
	inst.starttask = inst:DoPeriodicTask(1,starttask)
	
	return true
end
AddAction(FOLLOWME)

AddComponentAction("SCENE", "followme", function(inst, doer, actions,right)
	if right and not inst:HasTag("followme") and inst:HasTag("mypet") then
		table.insert(actions, ACTIONS.FOLLOWME)
	end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.FOLLOWME,"dolongaction")) 
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.FOLLOWME,"dolongaction"))

local NOFOLLOWME = Action({ priority=100, rmb=true, distance=20})
NOFOLLOWME.id="NOFOLLOWME"
NOFOLLOWME.str="老实待着 Rest in place"
NOFOLLOWME.fn = function(act)
    local player = act.doer
	local inst = act.target
	inst:RemoveTag("followme")
	inst.followme = false
	inst.components.follower:SetLeader(nil)
	if inst.brain then 
		inst.brain:Stop()
	end
	if inst.components.locomotor then
		inst.components.locomotor:Stop()
	end
	if player.components.talker then
		player.components.talker:Say("你在此处不要动，我去给你买几个桔子去 Don't run around")
	end
	
    if not TheWorld.ismastersim then
        return true
    end
	inst.starttask = nil
	inst.stoptask = inst:DoPeriodicTask(1,stoptask)

	return true
end
AddAction(NOFOLLOWME)

AddComponentAction("SCENE", "follower", function(inst, doer, actions,right)	
	if right and inst:HasTag("followme") then
		table.insert(actions, ACTIONS.NOFOLLOWME)
	end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.NOFOLLOWME,"dolongaction")) 
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.NOFOLLOWME,"dolongaction"))