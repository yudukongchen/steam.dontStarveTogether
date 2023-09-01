local SourceModifierList = require("util/sourcemodifierlist")

local function ongys(self,gys) 
	self.inst.components.combat.externaldamagemultipliers:SetModifier("fh_ly_gy", 1+0.05*#gys)
	self.inst.fh_ly_gy:set(gys)
end

local  fh_ly_gy = Class(function(self, inst)
	self.inst = inst
	self.gys = {}
end,
nil,
{
	gys = ongys,
})

function fh_ly_gy:HasBlack()
	if next(self.gys) ~= nil then
		for k= #self.gys, 1,-1 do
			if self.gys[k] ~= nil and self.gys[k] == 2 then
				table.remove(self.gys,k)
				self.gys = self.gys
				return true
			end
		end
	end
	return false
end

function fh_ly_gy:HasWhite()
	if next(self.gys) ~= nil then
		for k= #self.gys, 1,-1 do
			if self.gys[k] ~= nil and self.gys[k] == 1 then
				table.remove(self.gys,k)
				self.gys = self.gys
				return true
			end
		end
	end
	return false
end

function fh_ly_gy:SpawnGouYu()
	if #self.gys < 6 then
		table.insert(self.gys,math.random() < 0.5 and 1 or 2)
		self.gys = self.gys
	end
end

function fh_ly_gy:Start()
	self.gys = {}
	if self.task then
		self.task:Cancel()
	end
	self.task = self.inst:DoPeriodicTask(5,function()
		self:SpawnGouYu()
	end)
end

function fh_ly_gy:Stop()
	self.gys = {}
	if self.task then
		self.task:Cancel()
		self.task = nil
	end
end

--[[
function fh_ly_gy:OnSave()
	return {
		gys = self.gys,
	}
end

function fh_ly_gy:OnLoad(data)
	if data then
		if data.gys then
			self.gys = data.gys
		end
	end
end]]

return fh_ly_gy
