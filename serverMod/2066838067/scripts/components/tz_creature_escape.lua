local TzCreatureEscape = Class(function(self,inst)
    self.inst = inst
    
    self.drop_target_time = nil 

    self.escape_time = 10
    
    self.escape_check = function(inst)
        local x,y,z = inst.Transform:GetWorldPosition()
        local player = FindClosestPlayerInRange(x,y,z,50)
        return player == nil 
    end 

    self.on_escape_fn = function(inst)
        inst:Remove()
    end

    self._on_drop_target = function()
        self.drop_target_time = GetTime()
        inst:StartUpdatingComponent(self)
        -- print(self.drop_target_time,inst,"Drop target !")
    end

    self._on_new_target = function()
        inst:StopUpdatingComponent(self)
        self.drop_target_time = nil
        -- print(inst,"New target !")
    end


    inst:ListenForEvent("droppedtarget",self._on_drop_target)
    inst:ListenForEvent("newcombattarget",self._on_new_target)
end)

function TzCreatureEscape:OnUpdate(dt)
    if self.drop_target_time and 
        GetTime() - self.drop_target_time >= self.escape_time
        and (self.escape_check == nil or self.escape_check(self.inst)) then
        
        
        self.on_escape_fn(self.inst)
    end
end



return TzCreatureEscape