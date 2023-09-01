local TzRpgEmperorUpgrated = Class(function(self,inst)
    self.inst = inst 

    self.upgrated = false 

    inst:AddTag("tz_rpg_emperor_upgrate")
end) 

function TzRpgEmperorUpgrated:Enable(enable)
    if not self.upgrated and enable then 
        self.inst.components.tz_rpg_overheat.infinite_cooldown = true
        self.inst.components.tz_rpg_battery.infinite_battery = true

        self.inst.components.tz_rpg_overheat:DoDelta(-self.inst.components.tz_rpg_overheat.max)
        self.inst.components.tz_rpg_battery:DoDelta(self.inst.components.tz_rpg_battery.max)
        

        self.inst.AnimState:SetBuild("tz_rpg_emperor")
        if self.inst.components.equippable:IsEquipped() then
            local owner = self.inst.components.inventoryitem.owner 
            owner.AnimState:OverrideSymbol("swap_object", "swap_tz_rpg_emperor", "swap_object")
        end

        self.inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_rpg_emperor.xml"
        self.inst.components.inventoryitem:ChangeImageName("tz_rpg_emperor")

    elseif self.upgrated and not self.upgrated then
        self.inst.components.tz_rpg_overheat.infinite_cooldown = false
        self.inst.components.tz_rpg_battery.infinite_battery = false

        self.inst.AnimState:SetBuild("tz_rpg")
        if self.inst.components.equippable:IsEquipped() then
            local owner = self.inst.components.inventoryitem.owner 
            owner.AnimState:OverrideSymbol("swap_object", "swap_tz_rpg", "swap_object")
        end

        self.inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_rpg.xml"
        self.inst.components.inventoryitem:ChangeImageName("tz_rpg")
    end

    self.upgrated = enable 
end

function TzRpgEmperorUpgrated:IsUpgrated()
    return self.upgrated
end

function TzRpgEmperorUpgrated:OnSave()
    return {
        upgrated = self.upgrated
    }
end

function TzRpgEmperorUpgrated:OnLoad(data)
    if data ~= nil then
        if data.upgrated ~= nil then
            self:Enable(data.upgrated)
        end
    end
end

return TzRpgEmperorUpgrated