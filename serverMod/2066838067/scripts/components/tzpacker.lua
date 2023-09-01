local function onname(self,name)
	self.inst._name:set(tostring(name))
end
local Tzpacker = Class(function(self, inst)
	self.inst = inst
	
	self.canpackfn = nil

	self.package = nil
end,
nil,
{
    name = onname,
})

function Tzpacker:HasPackage()
	return self.package ~= nil
end

function Tzpacker:SetCanPackFn(fn)
	self.canpackfn = fn
end


function Tzpacker.DefaultCanPackTest(target)  --目标待改
	return target
		and target:IsValid()
		and not target:IsInLimbo()
		and not (
			target:HasTag("teleportato")
			or target:HasTag("nobundling")
			or target:HasTag("xin_taizhen_wupin")
			or target:HasTag("player")
			or target:HasTag("nonpackable")
			or target:HasTag("companion")
			or target:HasTag("character") 
            or target.prefab == "wormhole"
			or target.prefab == "beequeenhivegrown"
			or target.prefab =="beequeenhive"
			or target.prefab =="cave_entrance"
			or target.prefab =="cave_entrance_ruins"
			or target.prefab =="cave_entrance_open"
			or target.prefab == "multiplayer_portal"
			or target.prefab == "tentacle_pillar_hole"
			or target.prefab == "tentacle_pillar"
		)
end

function Tzpacker:CanPack(target)
	return self.inst:IsValid()
		and not self:HasPackage()
		and self.DefaultCanPackTest(target)
		and (not self.canpackfn or self.canpackfn(target, self.inst))
end


local function get_name(target)
	local name = target:GetDisplayName() or (target.components.named and target.components.named.name)

	if not name or name == "MISSING NAME" then return end

	local adj = target:GetAdjective()
	if adj then
		name = adj.." "..name
	end

	if target.components.stackable then
		local size = target.components.stackable:StackSize()
		if size > 1 then
			name = name.." x"..tostring(size)
		end
	end

	return name
end

function Tzpacker:Pack(target)
	if not self:CanPack(target) then
		return false
	end
	self.package = {
		prefab = target.prefab,
		name = get_name(target),
		skinname  = target.skinname or nil,
		skin_id = target.skin_id or nil,
	}
	self.package.data, self.package.refs = target:GetPersistData()
	self.name = get_name(target)
	target:Remove()
	return true
end

function Tzpacker:GetName()
	return self.package and self.package.name
end

function Tzpacker:Unpack(x,y,z)
	if  self.package then 
	local target = SpawnPrefab(self.package.prefab,self.package.skinname, self.package.skin_id)
	if target then
		target.Transform:SetPosition( x,y,z )
		local fx = SpawnPrefab("tz_packbox_fx")
		fx.Transform:SetPosition( x,y,z )
		
		if target.components.childspawner ~= nil or target.components.spawner ~= nil then
		return
		end
		if target.prefab == "scarecrow" then
		return
		end		
		local newents = {}
		if self.package.refs then
			for _, guid in ipairs(self.package.refs) do
				newents[guid] = {entity = _G.Ents[guid]}
			end
		end
		target:SetPersistData(self.package.data, newents)
		target:LoadPostPass(newents, self.package.data)
		target.Transform:SetPosition(x,y,z)
		self.package = nil
		return true
	end
	end
end

function Tzpacker:Unpackbulid(pos)
	if self.package then 
	local target = SpawnPrefab(self.package.prefab,self.package.skinname, self.package.skin_id)
	if target then
		target.Transform:SetPosition(  pos:Get()  )
		local fx = SpawnPrefab("tz_packbox_fx")
		fx.Transform:SetPosition( pos:Get() )
		if target.components.childspawner ~= nil or target.components.spawner ~= nil then
		return
		end
		if target.prefab == "scarecrow" then
		return
		end
		local newents = {}
		if self.package.refs then
			for _, guid in ipairs(self.package.refs) do
				newents[guid] = {entity = _G.Ents[guid]}
			end
		end

		target:SetPersistData(self.package.data, newents)
		target:LoadPostPass(newents, self.package.data)
		target.Transform:SetPosition( pos:Get() ) 
		self.package = nil
		return true
	end
	end
end


function Tzpacker:OnSave()
	if self.package then
		return {package = self.package}, self.package.refs
	end
end

function Tzpacker:OnLoad(data)
	if data and data.package then
		self.package = data.package
		self.name = self.package.name
	end
end


return Tzpacker
