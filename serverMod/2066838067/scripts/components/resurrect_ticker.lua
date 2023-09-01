local ResurrectTicker = Class(function(self,inst)
	self.inst = inst
	self.task = nil 

	inst:ListenForEvent("respawnfromghost",function()
		self:Cancel()
	end)
end)

function ResurrectTicker:IsDead()
	local inst = self.inst
	return (inst.components.health and inst.components.health:IsDead()) or (inst.sg and inst.sg:HasStateTag("dead")) or inst:HasTag("playerghost")
end

function ResurrectTicker:Cancel()
	if self.task then 
		self.task:Cancel()
		self.task = nil
	end 
end

function ResurrectTicker:Resurrect(delay)
	if delay == nil or delay <= 0 then 
		if self:IsDead() then 
			self.inst:PushEvent("respawnfromghost",{ source = self.inst, user = self.inst })
			self:Cancel()
		end 
	else
		self:Cancel()
		self.task = self.inst:DoTaskInTime(delay,function()
			self:Resurrect()
		end)
	end
end

return ResurrectTicker