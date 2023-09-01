local Luobo_GroundPounder = Class(function(self, inst)
    self.inst = inst

    self.numRings = 4
    self.ringDelay = 0.2
    self.initialRadius = 1  --初始
    self.radiusStepDistance = 4
    self.pointDensity = .25
    self.damageRings = 2
    self.destructionRings = 3
	self.scale =  1
    self.noTags = { "FX", "NOCLICK", "DECOR", "INLIMBO" }
    self.destroyer = false
    self.burner = false
    self.groundpoundfx = "groundpound_fx"
    self.groundpoundringfx = "groundpoundring_fx"
    self.groundpounddamagemult = 1
    self.groundpoundFn = nil
end)

function Luobo_GroundPounder:GetPoints(pt)
    local points = {}
    local radius = self.initialRadius

    for i = 1, self.numRings do  
        local theta = 0
        local circ = 2*PI*radius  
        local numPoints = circ * self.pointDensity 
        for p = 1, numPoints do

            if not points[i] then
                points[i] = {}
            end

            local offset = Vector3(radius * math.cos(theta), 0, -radius * math.sin(theta))
            local point = pt + offset

            table.insert(points[i], point)

            theta = theta - (2*PI/numPoints)
        end
        
        radius = radius + self.radiusStepDistance

    end
    return points
end

function Luobo_GroundPounder:DestroyPoints(points, breakobjects, dodamage)
    local getEnts = breakobjects
    local map = TheWorld.Map
    for k, v in pairs(points) do
        if getEnts then
            local ents = TheSim:FindEntities(v.x, v.y, v.z, 3, nil, self.noTags)
            if #ents > 0 then
                if breakobjects then
                    for i, v2 in ipairs(ents) do
                        if v2 ~= self.inst and v2:IsValid() then
 
                            if self.destroyer and
                                v2.components.workable ~= nil and
                                v2.components.workable:CanBeWorked() and
                                v2.components.workable.action ~= ACTIONS.NET then
                                v2.components.workable:Destroy(self.inst)
                            end
                            if v2:IsValid() and 
                                not v2:IsInLimbo() and 
                                self.burner and
                                v2.components.fueled == nil and
                                v2.components.burnable ~= nil and
                                not v2.components.burnable:IsBurning() and
                                not v2:HasTag("burnt") then
                                v2.components.burnable:Ignite()
                            end
                        end
                    end
                end
            end
        end

        if map:IsPassableAtPoint(v:Get()) then
			if self.groundpoundfx then
				SpawnPrefab(self.groundpoundfx).Transform:SetPosition(v.x, 0, v.z)
			end
        end
    end
end

local function OnDestroyPoints(inst, self, points, breakobjects, dodamage)
    self:DestroyPoints(points, breakobjects, dodamage)
end

function Luobo_GroundPounder:GroundPound(pt)
    pt = pt or self.inst:GetPosition()
	SpawnPrefab(self.groundpoundringfx).Transform:SetPosition(pt:Get())
	--local groundpoundringfx = SpawnPrefab(self.groundpoundringfx)
	--if groundpoundringfx and groundpoundringfx.AnimState then 
	--	groundpoundringfx.Transform:SetPosition(pt:Get())
	--	groundpoundringfx.AnimState:SetScale(self.scale, self.scale ,self.scale)
	--	print("444")
	--end
    local points = self:GetPoints(pt)
    local delay = 0
    for i = 1, self.numRings do
        self.inst:DoTaskInTime(delay, OnDestroyPoints, self, points[i], i <= self.destructionRings, i <= self.damageRings)
        delay = delay + self.ringDelay
    end

    if self.groundpoundFn ~= nil then
        self.groundpoundFn(self.inst)
    end
end

function Luobo_GroundPounder:GroundPound_Offscreen(position)

    local breakobjectsRadius = self.initialRadius + (self.destructionRings - 1) * self.radiusStepDistance
    local dodamageRadius = self.initialRadius + (self.damageRings - 1) * self.radiusStepDistance
    local breakobjectsRadiusSQ = breakobjectsRadius * breakobjectsRadius

    local ents = TheSim:FindEntities(position.x, position.y, position.z, dodamageRadius, nil, self.noTags)
    for i, v in ipairs(ents) do
        if v ~= self.inst and v:IsValid() and not v:IsInLimbo() then
            if v:GetDistanceSqToPoint(position:Get()) < breakobjectsRadiusSQ then
                if self.destroyer and
                    v.components.workable ~= nil and
                    v.components.workable:CanBeWorked() and
                    v.components.workable.action ~= ACTIONS.NET then
                    v.components.workable:Destroy(self.inst)
                end
                if v:IsValid() and
                    not v:IsInLimbo() and
                    self.burner and
                    v.components.fueled == nil and
                    v.components.burnable ~= nil and
                    not v.components.burnable:IsBurning() and
                    not v:HasTag("burnt") then
                    v.components.burnable:Ignite()
                end
            end
        end
    end
end

function Luobo_GroundPounder:GetDebugString()
    return string.format("num rings: %d, damage rings: %d, destruction rings: %d", self.numRings, self.damageRings, self.destructionRings)
end

return Luobo_GroundPounder
