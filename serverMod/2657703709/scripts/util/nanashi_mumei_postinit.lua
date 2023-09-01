-- NOTE CHARACTER POSTINIT

AddPlayerPostInit(function(inst)
	if inst.prefab ~= "nanashi_mumei" then
        -- DO SOMETHING ON PLAYER ACTIVATE eg: Greetings
        -- inst:ListenForEvent("playeractivated",function (inst)
        -- end)
    end
end)

AddPrefabPostInit("bushhat", function(inst)
	if not GLOBAL.TheWorld.ismastersim then return inst end
	local _onequipfn = inst.components.equippable.onequipfn
	inst.components.equippable.onequipfn = function (inst, owner)
		if owner:HasTag("nanashi_mumei") then
			inst.components.equippable.dapperness = TUNING.NANASHI_MUMEI_BUSH_HAT_DAPPERNESS
		else
			inst.components.equippable.dapperness = 0
		end
		_onequipfn(inst, owner)
	end
end)

--Anti Drown
AddComponentPostInit("drownable", function(self)
    local _oldShouldDrown = self.ShouldDrown
	function self:ShouldDrown() 
		if self.inst and self.inst:HasTag("nanashi_mumei") and self.inst._nanashi_mumei_killer:value() then
			return false
		elseif self.inst and self.inst:HasTag("nanashi_mumei") and not self.inst._nanashi_mumei_killer:value() and self.inst:HasTag("drowningSafety") then
			local fx2 = GLOBAL.SpawnPrefab("slurper_respawn")
			fx2.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
			local dest = GLOBAL.FindNearbyLand(self.inst:GetPosition(), 8)
			if not dest then
				dest = GLOBAL.Vector3(GLOBAL.FindRandomPointOnShoreFromOcean(self.inst.Transform:GetWorldPosition()))
			end
            if dest then
                if self.inst.Physics ~= nil then
                    self.inst.Physics:Teleport(dest:Get())
                elseif self.inst.Transform ~= nil then
                    self.inst.Transform:SetPosition(dest:Get())
                end
				local fx = GLOBAL.SpawnPrefab("slurper_respawn")
				fx.Transform:SetPosition(dest:Get())
            end
            self.inst:ClearBufferedAction()
			self.inst:RemoveTag("drowningSafety")
			return false
		else
			return _oldShouldDrown(self)
		end
    end
end)
