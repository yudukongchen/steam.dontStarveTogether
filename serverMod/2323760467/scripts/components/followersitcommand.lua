print("Loading FollowerSitCommand component....")

local FollowerSitCommand = Class(function(self, inst)
    self.inst = inst
	self.stay = false
	self.locations = {}
	self.inst:StartUpdatingComponent(self)

    inst:AddComponent("machine")
    inst.components.machine.turnonfn  = function() self:turnon() end
    inst.components.machine.turnofffn = function() self:turnoff() end
    inst.components.machine.cooldowntime = 0
    inst.components.machine.ison = true

    inst:ListenForEvent("ondropped", self.onDropped)
    inst:ListenForEvent("onpickup", self.onPickup)
    inst:ListenForEvent("stopfollowing", self.onStopfollowing)
end)


function FollowerSitCommand.onDropped(inst)
	inst.components.followersitcommand:SetCurrentPos()
	if inst.components.machine.ison == true then
		inst.components.followersitcommand:GetNewLeader()
		inst.components.followersitcommand:SetStaying(false)
	else
		inst.components.followersitcommand:SetStaying(true)
	end
end


function FollowerSitCommand.onPickup(inst)
	inst.components.followersitcommand:RemoveLeader()
end


function FollowerSitCommand.onStopfollowing(inst)
	inst.components.followersitcommand:SetCurrentPos()
end


function FollowerSitCommand:RemoveLeader()
    self.inst:InterruptBufferedAction()
    self.inst:ClearBufferedAction()
--	self.inst.components.follower:StopFollowing()
	local leader = self.inst.components.follower.leader
	if leader then
		leader.components.leader:RemoveFollower(self.inst)
	end
end


function FollowerSitCommand:GetNewLeader()
	self:RemoveLeader()
	local player = GetClosestInstWithTag("player",self.inst,6)
	self.inst.components.follower:SetLeader(player)
end


function FollowerSitCommand:turnon()
	if self.inst.components.inventoryitem.owner == nil then
	    self.inst:RestartBrain()
		self:GetNewLeader()
	end
	self:SetStaying(false)
end


function FollowerSitCommand:turnoff()
	self:RemoveLeader()
	self.inst.sg:GoToState("talk")
	self.inst.components.talker:Say("OK, I stay here.")
	self:RememberSitPos("currentstaylocation", Point(self.inst.Transform:GetWorldPosition())) 
	self:SetStaying(true)
end


function FollowerSitCommand:CollectSceneActions(doer, actions, rightclick)
	if rightclick and self.inst.components.follower and self.inst:HasTag("companion") then--and self.inst.components.follower.leader == GetPlayer() then
		if not self.inst.components.followersitcommand:IsCurrentlyStaying() then
			--self.inst:RemoveComponent("unteleportable") 
			table.insert(actions, ACTIONS.SITCOMMAND)
		else
			--self.inst:AddComponent("unteleportable") 
			table.insert(actions, ACTIONS.SITCOMMAND_CANCEL)
		end
	end
end

function FollowerSitCommand:OnUpdate()
--	if self.inst.components.follower and self.inst.components.follower.leader == GetPlayer() then
	if self.inst.components.follower and self.inst.components.follower.leader then
		if not self.inst.components.followersitcommand:IsCurrentlyStaying() then
			if self.inst.components.unteleportable then
				self.inst:RemoveComponent("unteleportable") 
			end
		else
			if not self.inst.components.unteleportable then
				self.inst:AddComponent("unteleportable") 
			end
		end
	end
end

function FollowerSitCommand:IsCurrentlyStaying()
	return self.stay
end

function FollowerSitCommand:SetStaying(stay)
	self.stay = stay
--	self.inst.components.inventoryitem.canbepickedup = stay
    self.inst.components.machine.ison = not stay
end


function FollowerSitCommand:RememberSitPos(name, pos)
    self.locations[name] = pos
end


function FollowerSitCommand:SetCurrentPos()
	self:RememberSitPos("currentstaylocation", Point(self.inst.Transform:GetWorldPosition())) 
end


-- onsave and onload may seem cumbersome but it requires to iterate because onload doesn't accept tables as single vars
function FollowerSitCommand:OnSave()
	if self.stay == true then
		local data = 
			{ 
				stay = self.stay,
--				varx = self.locations.currentstaylocation["x"], 
--				vary = self.locations.currentstaylocation["y"], 
--				varz = self.locations.currentstaylocation["z"]
				varx = self.locations["currentstaylocation"].x, 
				vary = self.locations["currentstaylocation"].y, 
				varz = self.locations["currentstaylocation"].z
			}
		return data
	end
end   
   
function FollowerSitCommand:OnLoad(data)

	if data and data.stay then 
		self.stay = data.stay
--		self.locations.currentstaylocation = { }
--		self.locations.currentstaylocation["x"] = data.varx
--		self.locations.currentstaylocation["y"] = data.vary
--		self.locations.currentstaylocation["z"] = data.varz
		self.locations["currentstaylocation"] = Point(data.varx, data.vary, data.varz)	
	end
end
   


return FollowerSitCommand


