local Destroyable = Class(function(self, inst)
	self.inst = inst
	self.ondestroy = nil 

	inst:AddTag("destroyable")
end)

function Destroyable:Destroy(doer)
	if self.ondestroy then 
		self.ondestroy(self.inst,doer)
	end
	self.inst:Remove()
end

return Destroyable 