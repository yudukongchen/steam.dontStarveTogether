local STATES = {
	IDLE = 1,
	MOVING = 2,
	DEAD = 3,
}

local TzPugaliskMultibody = Class(function(self, inst)
    self.inst = inst    
    self.maxbodies = 1
	self.broken_damage_threshold = 500
    self.bodies = {}
	self.broken_bodies_id_inv = {}
	self.bodies_damage_taken = {}
    self.bodyprefab = "tz_pugalisk_body" 
    self.state = STATES.MOVING 

    self.inst:ListenForEvent("startmove", function(inst, data)
    	self:OnStartMove()
    end)
    
    self.inst:ListenForEvent("stopmove", function(inst, data)
    	self:OnStopMove()
    end)
end)

function TzPugaliskMultibody:HandleBodyTakeDamage(id_inv,damage)
	local body = self.bodies[#self.bodies - id_inv + 1]
	local break_cnt = 0
	if id_inv >= 1 and id_inv <= self.maxbodies and body and body.invulnerable then
		self.bodies_damage_taken[id_inv] = self.bodies_damage_taken[id_inv] + damage
		if self.bodies_damage_taken[id_inv] >= self.broken_damage_threshold then
			break_cnt = break_cnt + 1
			self:BreakBody(id_inv)
		end
	end

	return break_cnt
end

function TzPugaliskMultibody:BreakBody(id_inv,is_onload)
	local body = self.bodies[#self.bodies - id_inv + 1]
	if body and body.invulnerable and not table.contains(self.broken_bodies_id_inv,id_inv) then
		table.insert(self.broken_bodies_id_inv,id_inv)
		body.components.tz_pugalisk_segmented:BreakAllSegments()

		self.inst:PushEvent("tz_pugalisk_body_break",{
			body = body,
			is_onload = is_onload,
		})
	end

end

function TzPugaliskMultibody:SpawnBody(angle,percent,pos)

	assert(pos) -- where the body spawns
	assert(angle) -- the direction of the travel
	assert(percent) -- how far along the travel the body should spawn in at

	local newbody = SpawnPrefab(self.bodyprefab)
	newbody.Transform:SetPosition(pos.x,pos.y,pos.z)	
	newbody.host = self.inst
	newbody.components.tz_pugalisk_segmented:Start(angle, nil, percent)

	newbody.components.combat.externaldamagetakenmultipliers:SetModifier(self.inst,self.inst.all_damage_taken_multi, "all_damage_taken_multi")
	

	table.insert(self.bodies, newbody)


	for i,body in ipairs(self.bodies) do			
		-- if i == #self.bodies - 2 then
		-- 	body.invulnerable = false
		-- else
		-- 	body.invulnerable = true
		-- end


		
		local id_inv = #self.bodies - i + 1
		-- invulnerable: Can't take damage
		body.invulnerable = not table.contains(self.broken_bodies_id_inv,id_inv)
	end

	if #self.bodies > self.maxbodies then
		self.bodies[1].components.tz_pugalisk_segmented:SetToEnd()
	end
	
end

function TzPugaliskMultibody:RemoveBody(body)
	for i,lbody in ipairs(self.bodies)do
		if lbody == body then
			table.remove(self.bodies,i)
			break
		end
	end
end

function TzPugaliskMultibody:Setup(num,prefab)
	if prefab then
		self.bodyprefab = prefab
	end
	if num then
		self.maxbodies = num
		for i = 1,num do
			self.bodies_damage_taken[i] = 0
		end
	end
end

function TzPugaliskMultibody:OnSave()

	local refs = {}
	local data =
	{
		bodies = {},	
		broken_bodies_id_inv = self.broken_bodies_id_inv,
		bodies_damage_taken = self.bodies_damage_taken,
	}
	
	for i,body in ipairs(self.bodies)do		
		if i ~= #self.bodies then
			local x,y,z = body.Transform:GetWorldPosition() 
		
			local angle = body.angle
			table.insert(data.bodies,{angle=angle,x=x,y=y,z=z})
		end
	end

	return data, refs
end

function TzPugaliskMultibody:OnLoad(data)
	if data then
		for i, body in ipairs(data.bodies) do
			self:SpawnBody(body.angle,1,Vector3(body.x,body.y,body.z))
		end

		if data.broken_bodies_id_inv ~= nil then
			for _, id_inv in pairs(data.broken_bodies_id_inv) do
				self:BreakBody(id_inv,true)
			end
		end

		if data.bodies_damage_taken ~= nil then
			self.bodies_damage_taken = data.bodies_damage_taken
		end
	end
end

function TzPugaliskMultibody:IsMoveState()
	return self.state == STATES.MOVING
end

function TzPugaliskMultibody:OnStartMove()
	if self.state ~= STATES.MOVING and self.state ~= STATES.DEAD then
		self.state = STATES.MOVING
		-- print("START MOVE")
		for i,body in ipairs(self.bodies)do
			body.components.tz_pugalisk_segmented:StartMove()
		end

		if self.tail then
			self.tail:PushEvent("tail_should_exit")
		end
	end
end

function TzPugaliskMultibody:OnStopMove()
	if self.state ~= STATES.IDLE and self.state ~= STATES.DEAD then
		self.state = STATES.IDLE
		-- print("STOP MOVE")
		
		for i,body in ipairs(self.bodies)do
			if i==1 and #self.bodies == self.maxbodies then			
				body.components.tz_pugalisk_segmented:SetToEnd()
				body:AddTag("switchToTailProp")
			end
			body.components.tz_pugalisk_segmented:StopMove()
		end

	end
end

function TzPugaliskMultibody:Kill()
	self.state = STATES.DEAD
end


return TzPugaliskMultibody
