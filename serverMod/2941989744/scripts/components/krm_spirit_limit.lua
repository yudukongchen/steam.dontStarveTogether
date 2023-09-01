
local krm_spirit_limit = Class(function(self, inst)
    self.inst = inst
    self.candrop = true
    inst:ListenForEvent("krm_spirit_drop",function(_,data)
        if self.candrop and data and data.inst and data.inst:IsValid() and data.inst.components.lootdropper then
            data.inst.components.lootdropper:SpawnLootPrefab("krm_spirit_crystal")
            --SendModRPCToShard(SHARD_MOD_RPC["krm_shard_spirit"]["krm_shard_spirit"],nil,"我是爱学习的宝宝~~")
        end
    end)
end)

function krm_spirit_limit:SetNoDrop(fn)
    self.candrop = false
end
function krm_spirit_limit:OnSave()
    return { candrop = self.candrop }
end

function krm_spirit_limit:OnLoad(data)
    if data and data.candrop ~= nil  then
        --self.candrop = data.candrop
    end
end
return krm_spirit_limit
