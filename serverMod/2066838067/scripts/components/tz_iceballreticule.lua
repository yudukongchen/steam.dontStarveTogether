
local Reticule = Class(function(self, inst)
    self.inst = inst
    self.reticuleprefab = "reticule"
    self.reticule = nil
	self.owner = nil
    self._oncameraupdate = function(dt) self:OnCameraUpdate(dt) end
end)

function Reticule:CreateReticule(owner)
    if owner == nil or TheInput == nil then
		return
	end
	self.owner = owner
	if self.reticule == nil then
        self.reticule = SpawnPrefab(self.reticuleprefab)
        if self.reticule == nil then
            return
        end
    end
	self.inst:StartUpdatingComponent(self)
end

function Reticule:DestroyReticule()
    if self.reticule ~= nil then
        self.reticule:Remove()
        self.reticule = nil
    end
	self.owner = nil
	self.inst:StopUpdatingComponent(self)
end

local function RotateToTarget(inst,dest)
    local direction = (dest - inst:GetPosition()):GetNormalized()
    local angle = math.acos(direction:Dot(Vector3(1, 0, 0))) / DEGREES
    inst.Transform:SetRotation(angle)
    inst:FacePoint(dest)
end

function Reticule:OnUpdate(dt)
    if self.reticule ~= nil then
		local pos = TheInput:GetWorldPosition()
		if pos ~= nil and self.owner ~= nil then
			self.reticule.Transform:SetPosition(self.owner.Transform:GetWorldPosition())
			RotateToTarget(self.reticule,pos)
		end
	end
end

function Reticule:ShouldHide()
	return self.shouldhidefn ~= nil and self.shouldhidefn(self.inst) or false
end

Reticule.OnRemoveFromEntity = Reticule.DestroyReticule
Reticule.OnRemoveEntity = Reticule.DestroyReticule

return Reticule
