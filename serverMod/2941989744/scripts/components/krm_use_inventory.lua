
local function oncanuse(self, canuse)
	if canuse then
		self.inst:AddTag("canuseininv_krm")
	else
		self.inst:RemoveTag("canuseininv_krm")
	end
end

local function oncanusescene(self, canusescene)
	if canusescene then
		self.inst:AddTag("canuseinscene_krm")
	else
		self.inst:RemoveTag("canuseinscene_krm")
	end
end

local krm_Use_Inventory = Class(function(self, inst)
	self.inst = inst
	self.canuse = false
	self.canusescene = false
	self.onusefn = nil
end,
nil,
{
	canuse = oncanuse,
	canusescene = oncanusescene,
}
)

function krm_Use_Inventory:SetOnUseFn(fn)
	self.onusefn = fn
end

function krm_Use_Inventory:OnUse(doer)
	if self.onusefn then
		self.onusefn(self.inst,doer)
	end
end

return krm_Use_Inventory