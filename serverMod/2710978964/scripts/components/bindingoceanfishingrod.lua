local BindingOceanFishingRod = Class(function(self, inst) 
	self.inst = inst
    --监听绑定请求
    self.inst:ListenForEvent("binding_oceanfishingrod",function(inst,child)
        if self.child ~= nil then
            self.child:PushEvent("unbound_oceanfishingrod")
            -- print("玩家解绑海钓竿")
        end
        --self:SetChild(child)
        self.child = child
        -- print("玩家绑定海钓竿")
    end)
    --监听断开绑定请求
    self.inst:ListenForEvent("unbound_oceanfishingrod",function(inst,child)
        if self.child ~= nil then
            self.child:PushEvent("unbound_oceanfishingrod")
            -- print("玩家解绑海钓竿")
        end
        self.child = nil
    end)
    -- 玩家移除时，解除绑定 变猴子时 或者 换人时掉落物品 就会执行这个
    self.inst:ListenForEvent("onremove",function(inst)
        if self.child ~= nil then
            self.child:PushEvent("unbound_oceanfishingrod")
        end
        self.child = nil        
    end)
end)

function BindingOceanFishingRod:GetChild()
	return self.child
end


return BindingOceanFishingRod
