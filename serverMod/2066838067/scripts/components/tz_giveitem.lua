
local tz_giveitem = Class(function(self, inst)
    self.inst = inst
end)
function tz_giveitem:AbleToAccept(item, giver)
    if self.test then
        return self.test(self.inst,item, giver)
    end
    return false
end
function tz_giveitem:GiveItem(item ,giver)
    if not self:AbleToAccept(item, giver) then
        return false
    end
    if self.onaccept ~= nil then
        self.onaccept(self.inst, item, giver)
    end
    return true
end
return tz_giveitem
