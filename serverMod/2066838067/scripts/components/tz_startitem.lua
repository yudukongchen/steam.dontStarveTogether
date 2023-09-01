
local tz_startitem = Class(function(self, inst)
    self.inst = inst
    self.owners = {}
end)

function tz_startitem:HasPlayer(doer)
	return self.owners[doer.userid] ~= nil
end

function tz_startitem:AddPlayer(doer)
	self.owners[doer.userid] = true
end

function tz_startitem:OnLoad(data)
    if data then
		if data.owners ~= nil then
        	self.owners = data.owners
		end
    end
end

function tz_startitem:OnSave()
    return { owners = self.owners }
end

return tz_startitem
