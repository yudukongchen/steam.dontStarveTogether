local TzBook = Class(function(self, inst)
    self.inst = inst
end)

function TzBook:OnRead(reader)
    if self.onread then
        return self.onread(self.inst, reader)
    end
    return true
end

return TzBook