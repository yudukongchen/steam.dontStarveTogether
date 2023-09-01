
local Projectile = Class(function(self, inst)
    self.inst = inst
end)

function Projectile:Throw(attacker, pos)
    local rotation = attacker.Transform:GetRotation()
    local beam = SpawnPrefab("tz_orb_small")
    local pt = Vector3(attacker.Transform:GetWorldPosition())
    local angle = rotation * DEGREES
    local radius = 1.5
    local offset = Vector3(radius * math.cos( angle ), 0, -radius * math.sin( angle ))
    local newpt = pt+offset
	beam.owner = attacker
    beam.Transform:SetPosition(newpt.x,1,newpt.z)
    beam.Transform:SetRotation(rotation)
	beam.Physics:SetMotorVel(15, 1, 0)
    if self.inst.components.finiteuses ~= nil then
        self.inst.components.finiteuses:Use(self.attackwear or 1)
    end
	return true
end

return Projectile
