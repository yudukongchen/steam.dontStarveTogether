local function OnDropped(inst, data)
    if data.item.components.binding and data.item.components.binding.owner == inst then
    	local inventory = inst.components.inventory
    	if #inventory.itemslots < inventory.maxslots then
        	inventory:GiveItem(data.item)
        else
        	-- 丢下第一个物品
        	inventory:DropItem(inventory.itemslots[1], true, true)
        	inventory:GiveItem(data.item)
        end
    end
end

local Binding = Class(function(self, inst) 
	self.inst = inst
    --监听断开绑定玩家请求
    self.inst:ListenForEvent("unbound_oceanfishingrod",function(inst)
        if self.owner == nil then return end --防止玩家旧实体已经被移除了
        --移除监听器
        self.owner:RemoveEventCallback("dropitem",OnDropped)
        self.owner = nil
    end)
    --监听放入库存
    self.inst:ListenForEvent("onputininventory",function(inst,owner)
        if owner ~= nil and owner.components.bindingoceanfishingrod and owner.components.bindingoceanfishingrod.child == nil then
            self:SetOwner(owner)
            -- print("绑定了")
        end
    end)
    --被移除了
    self.inst:ListenForEvent("onremove", function(inst)
        if self.owner then
            self.owner:PushEvent("unbound_oceanfishingrod")
        end
    end)
end)

function Binding:SetOwner(owner)
	if owner:HasTag("Player") then
		-- if self.inst.components.burnable then self.inst:RemoveComponent("burnable") end --移除燃烧属性
		self.inst.components.inventoryitem.canonlygoinpocket = true --只能放口袋，不可以放到容器中
        self.inst:AddTag("nosteal") --不能被偷
		self.owner = owner
        --玩家绑定
        owner:PushEvent("binding_oceanfishingrod",self.inst)
		owner:ListenForEvent("dropitem",OnDropped) -- 丢下时
	end
end

function Binding:GetOwner()
	return self.owner
end

return Binding

-- 制作一个贴图是火药的定时炸弹、有冷却组件、不可以丢弃、不可以放到容器中。