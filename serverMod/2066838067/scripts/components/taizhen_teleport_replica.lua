local taizhen_teleport =
    Class(
    function(self, inst)
        self.inst = inst

        self._infos = net_string(inst.GUID, "taizhen_teleport._infos")

        self.screen = nil
        self.opentask = nil

        if TheWorld.ismastersim then
            self.classified = SpawnPrefab("taizhen_teleport_classified")
            self.classified.entity:SetParent(inst.entity)
        else
            if self.classified == nil and inst.taizhen_teleport_classified ~= nil then
                self.classified = inst.taizhen_teleport_classified
                inst.taizhen_teleport_classified.OnRemoveEntity = nil
                inst.taizhen_teleport_classified = nil
                self:AttachClassified(self.classified)
            end
        end
    end
)

--------------------------------------------------------------------------

function taizhen_teleport:OnRemoveFromEntity()
    if self.classified ~= nil then
        if TheWorld.ismastersim then
            self.classified:Remove()
            self.classified = nil
        else
            self.classified._parent = nil
            self.inst:RemoveEventCallback("onremove", self.ondetachclassified, self.classified)
            self:DetachClassified()
        end
    end
end

taizhen_teleport.OnRemoveEntity = taizhen_teleport.OnRemoveFromEntity

--------------------------------------------------------------------------
--Client triggers writing based on receiving access to classified data
--------------------------------------------------------------------------

local function BeginTravel(inst, self)
    self.opentask = nil
    self:BeginTravel(ThePlayer)
end

function taizhen_teleport:AttachClassified(classified)
    self.classified = classified

    self.ondetachclassified = function()
        self:DetachClassified()
    end
    self.inst:ListenForEvent("onremove", self.ondetachclassified, classified)

    self.opentask = self.inst:DoTaskInTime(0, BeginTravel, self)
end

function taizhen_teleport:DetachClassified()
    self.classified = nil
    self.ondetachclassified = nil
    self:EndTravel()
end

--------------------------------------------------------------------------
--Common interface
--------------------------------------------------------------------------

function taizhen_teleport:BeginTravel(traveller)
    if self.inst.components.taizhen_teleport ~= nil then
        if self.opentask ~= nil then
            self.opentask:Cancel()
            self.opentask = nil
        end
        self.inst.components.taizhen_teleport:BeginTravel(traveller)
    elseif self.classified ~= nil and self.opentask == nil and traveller ~= nil and traveller == ThePlayer then --  
        if traveller.HUD == nil then
            -- abort
        else -- if not busy...
            self.screen = traveller.HUD:ShowTZTeleScreen(self.inst)
        end
    end
end

function taizhen_teleport:Travel(traveller, index)
    if self.inst.components.taizhen_teleport ~= nil then
        self.inst.components.taizhen_teleport:Travel(traveller, index)
    elseif self.classified ~= nil and traveller == ThePlayer  then --and index > 0
        SendModRPCToServer(MOD_RPC.TZ.Travel, self.inst, index)
    end
end

function taizhen_teleport:EndTravel()
    if self.opentask ~= nil then
        self.opentask:Cancel()
        self.opentask = nil
    end
    if self.inst.components.taizhen_teleport ~= nil then
        self.inst.components.taizhen_teleport:EndTravel()
    elseif self.screen ~= nil then
        if ThePlayer ~= nil and ThePlayer.HUD ~= nil then
            ThePlayer.HUD:CloseTZTeleScreen()
        elseif self.screen.inst:IsValid() then
            --Should not have screen and no traveller, but just in case...
            self.screen:Kill()
        end
        self.screen = nil
    end
end

function taizhen_teleport:SetTraveller(traveller)
    self.classified.Network:SetClassifiedTarget(traveller or self.inst)
    if self.inst.components.taizhen_teleport == nil then
        --Should only reach here during travelable construction
        assert(traveller == nil)
    end
end

function taizhen_teleport:SetDestInfos(infos)
    self._infos:set(infos)
end

function taizhen_teleport:GetDestInfos()
    return self._infos:value()
end

return taizhen_teleport
