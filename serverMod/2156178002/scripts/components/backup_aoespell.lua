local aoe=Class(function(self,b)
self.inst=b;
self.spell_type=nil;
self.aoe_cast=nil end)

function aoe:SetAOESpell(c)
self.aoe_cast=c end;

function aoe:CanCast(doer,pos)
local x,y,z=pos:Get()
	if self.inst:HasTag("theshield") then
		local valide = false
		local ents = TheSim:FindEntities(x, y, z, 4, nil, {"playerghost", "INLIMBO", "maple"}, {"player", "companion"})
		for i, v in ipairs(ents) do 
			valide = true 
		end
		return (valide and (self.inst.components.aoetargeting~=nil and self.inst.components.aoetargeting.alwaysvalid or TheWorld.Map:IsPassableAtPoint(x,y,z)and not TheWorld.Map:IsGroundTargetBlocked(pos)))
	else
		return self.inst.components.aoetargeting~=nil and self.inst.components.aoetargeting.alwaysvalid or TheWorld.Map:IsPassableAtPoint(x,y,z)and not TheWorld.Map:IsGroundTargetBlocked(pos)
	end
end;

function aoe:CastSpell(doer,pos)
if self.inst.components.reticule_spawner and(self.inst.components.rechargeable_spell and self.inst.components.rechargeable_spell.isready)
then self.inst.components.reticule_spawner:Spawn(pos)end;
if self.aoe_cast~=nil then
self.aoe_cast(self.inst,doer,pos)end;
self.inst:PushEvent("aoe_casted",{caster=doer,pos=pos})end;

function aoe:SetSpellType(r)self.spell_type=r end;

function aoe:OnSpellCast(doer,j)
doer:PushEvent("spell_complete",{spell_type=self.spell_type})end;

return aoe



-- local aoe=Class(function(self,b)
-- self.inst=b;
-- self.spell_type=nil;
-- self.aoe_cast=nil end)

-- function aoe:SetAOESpell(c)
-- self.aoe_cast=c end;

-- function aoe:CanCast(doer,pos)
-- local x,y,z=pos:Get()

	-- local valide = false
	-- local ents = TheSim:FindEntities(x, y, z, 10, {"monster"}, {"playerghost", "INLIMBO"}, nil)
	-- for i, v in ipairs(ents) do 
		-- valide = true 
	-- end
-- return (valide and (self.inst.components.aoetargeting~=nil and self.inst.components.aoetargeting.alwaysvalid or TheWorld.Map:IsPassableAtPoint(x,y,z)and not TheWorld.Map:IsGroundTargetBlocked(pos)))
-- end;

-- function aoe:CastSpell(doer,pos)
-- if self.inst.components.reticule_spawner and(self.inst.components.rechargeable and self.inst.components.rechargeable.isready)
-- then self.inst.components.reticule_spawner:Spawn(pos)end;
-- if self.aoe_cast~=nil then
-- self.aoe_cast(self.inst,doer,pos)end;
-- self.inst:PushEvent("aoe_casted",{caster=doer,pos=pos})end;

-- function aoe:SetSpellType(r)self.spell_type=r end;

-- function aoe:OnSpellCast(doer,j)
-- doer:PushEvent("spell_complete",{spell_type=self.spell_type})end;

-- return aoe