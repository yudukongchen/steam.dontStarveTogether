local XueXiJi = Class(function(self, inst)
	self.key = nil
	self.zu = nil
	self.inst = inst
end)

function XueXiJi:IsVal()
	return self.zu and self.zu > 0 and self.zu <= 2 and self.key ~= nil
end

function XueXiJi:CanXue(doer)
	if doer and doer:IsValid() and doer:HasTag("player") and not doer:HasTag("playerghost") and doer.qmsktbl and self:IsVal() then
		local tbl = doer.qmsktbl[self.zu]
		if tbl ~= nil then
			for k,v in pairs(tbl) do
				if v == self.key then
					if doer.components.talker then
						doer.components.talker:Say('已经学习过该技能了')
					end
					return false
				end
			end
			return true
		end
	end
	return false
end

function XueXiJi:DoXue(doer)
	if self:CanXue(doer) and doer.SetQMSk then
		local tbl = doer.qmsktbl[self.zu]
		for i=1, 4 do
			if tbl[i] == nil or tbl[i] == 0 then
				doer:SetQMSk(i, self.key, self.zu == 2 and true or false )
				self.inst:Remove()
				break
			end
		end
	end
end

function XueXiJi:SetData(key, zu)
	self.key = key
	self.zu = zu
end


return XueXiJi