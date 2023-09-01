local PRECISION = 10 ^ 3
local RESIST_MIN = 0
local RESIST_MAX = 7

local STIMULI = { "fire", "electric" }
for i, v in ipairs(STIMULI) do
	STIMULI[v] = i
end

local COMBAT_RANGE = 12
local COMBAT_TIMEOUT = 2
local COMBAT_MAX_ATTACKERS = 1
local COMBAT_TAGS = { "_combat", "_health" }
local COMBAT_NOTAGS = { "INLIMBO", "player" }
local COMBAT_PROJECTILE_TAGS = { "activeprojectile" }

local AllEpicTargets = {}

if not TheNet:IsDedicated() then
	require("widgets/epichealthbar").targets = AllEpicTargets
end

local function netset(netvar, value, force)
	if netvar:value() ~= value then
		netvar:set(value)
	elseif force then
		netvar:set_local(value)
		netvar:set(value)
	end
end

local function istargetedby(parent, attacker)
	return attacker ~= parent
		and (attacker.replica.combat ~= nil and attacker.replica.combat:GetTarget() == parent)
		and (attacker.replica.health ~= nil and not attacker.replica.health:IsDead())
end

local function isattackedby(parent, attacker)
	return istargetedby(parent, attacker)
		and (attacker.sg ~= nil and attacker.sg:HasStateTag("attack") or attacker:HasTag("attack"))
end

local function OnEntityWake(inst)
	AllEpicTargets[inst._parent] = true

	if ThePlayer ~= nil then
		ThePlayer:PushEvent("newepictarget", inst._parent)
	end
end

local function OnEntitySleep(inst)
	AllEpicTargets[inst._parent] = nil

	if ThePlayer ~= nil then
		ThePlayer:PushEvent("lostepictarget", inst._parent)
	end
end

local function OnCurrentHealthDirty(inst)
	inst.currenthealth = inst._currenthealth:value() / PRECISION
end

local function OnMaxHealthDirty(inst)
    inst.maxhealth = inst._maxhealth:value() / PRECISION
end

local function OnInvincibleDirty(inst)
	inst.invincible = inst._invincible:value()
end

local function OnResistDirty(inst)
	if ThePlayer ~= nil then
		ThePlayer:PushEvent("epictargetresisted", { target = inst._parent, resist = inst._resist:value() / RESIST_MAX })
	end
end

local function OnStimuliDirty(inst)
	inst.stimuli = STIMULI[inst._stimuli:value()]
end

local function OnDamaged(inst)
	inst.lastwasdamagedtime = GetTime()
end

local function OnHealthDelta(parent, data)
	if parent.components.health ~= nil then
		if data ~= nil and data.afflicter ~= nil and data.newpercent <= 0 and data.oldpercent > 0 then
			local damageresolved = data.oldpercent * parent.components.health.maxhealth + math.max(-999999, data.amount)
			netset(parent.epichealth._currenthealth, math.ceil(damageresolved * PRECISION))
		else
			netset(parent.epichealth._currenthealth, math.ceil(parent.components.health.currenthealth * PRECISION))
			netset(parent.epichealth._maxhealth, math.ceil(parent.components.health.maxhealth * PRECISION))
		end
   	end
	netset(parent.epichealth._stimuli, data ~= nil and STIMULI[data.cause] or 0)
end

local function OnInvincible(parent, data)
	if parent.components.health ~= nil then
		netset(parent.epichealth._invincible, not not parent.components.health:IsInvincible())
	end
end

local function OnFireDamage(parent)
	netset(parent.epichealth._stimuli, STIMULI.fire)
	parent.epichealth._damaged:push()
end

local function OnMinHealth(parent, data)
	if parent.components.health ~= nil and not parent.components.health:IsDead() then
		netset(parent.epichealth._resist, RESIST_MAX, true)
	end
end

local function OnExplosiveResist(parent, resist)
	netset(parent.epichealth._resist, math.ceil(Lerp(RESIST_MIN, RESIST_MAX, resist)), true)
end

local function OnAttacked(parent, data)
	if data ~= nil and data.damage ~= nil and data.damage > 0 then
		if data.damageresolved ~= nil and data.damageresolved < data.damage then
			netset(parent.epichealth._resist, math.ceil(Lerp(RESIST_MAX, RESIST_MIN, data.damageresolved / data.damage)), true)
		end

		local stimuli = data.stimuli
		if stimuli == nil and data.weapon ~= nil and data.weapon.components.weapon ~= nil then
			stimuli = data.weapon.components.weapon.stimuli
		end
		netset(parent.epichealth._stimuli, STIMULI[stimuli] or 0)
	end
	parent.epichealth._damaged:push()
end

local function WatchProjectile(parent, projectile, launchtime)
	if not projectile:IsValid()
		or projectile.components.projectile == nil
		or projectile.components.projectile.target ~= parent
		or GetTime() - launchtime > COMBAT_TIMEOUT then

		parent.epichealth.watchlist[projectile]:Cancel()
		parent.epichealth.watchlist[projectile] = nil

		if not next(parent.epichealth.watchlist) then
			parent.epichealth.watchlist = nil
			parent.epichealth:RemoveTag("hostileprojectile")
		end
	end
end

local function OnHostileProjectile(parent, data)
	local attacker = data and (data.attacker or data.thrower)
	if attacker ~= nil and attacker:HasTag("player") then
		local pos = attacker:GetPosition()
		for i, v in ipairs(TheSim:FindEntities(pos.x, 0, pos.z, 5, COMBAT_PROJECTILE_TAGS)) do
			if v.components.projectile ~= nil and v.components.projectile.target == parent then
				if parent.epichealth.watchlist == nil then
					parent.epichealth.watchlist = {}
					parent.epichealth:AddTag("hostileprojectile")
				end
				if not parent.epichealth.watchlist[v] then
					parent.epichealth.watchlist[v] = parent:DoPeriodicTask(0.1, WatchProjectile, nil, v, GetTime())
				end
			end
		end
	end
end

local function OnEntityReplicated(inst)
	inst._parent = inst.entity:GetParent()
	if inst._parent ~= nil then
		inst._parent.epichealth = inst

		if not TheNet:IsDedicated() then
			inst:ListenForEvent("entitywake", OnEntityWake)
			inst:ListenForEvent("entitysleep", OnEntitySleep)
			inst:ListenForEvent("onremove", OnEntitySleep)
			if not inst:IsAsleep() then
				OnEntityWake(inst)
			end
		end

		if TheWorld.ismastersim then
			inst:ListenForEvent("healthdelta", OnHealthDelta, inst._parent)
			inst:ListenForEvent("invincibletoggle", OnInvincible, inst._parent)
			inst:ListenForEvent("firedamage", OnFireDamage, inst._parent)
			inst:ListenForEvent("minhealth", OnMinHealth, inst._parent)
			inst:ListenForEvent("explosiveresist", OnExplosiveResist, inst._parent)
			inst:ListenForEvent("attacked", OnAttacked, inst._parent)
			inst:ListenForEvent("hostileprojectile", OnHostileProjectile, inst._parent)
			OnHealthDelta(inst._parent)
			OnInvincible(inst._parent)
		end
	end
end

local function IsPlayingMusic(inst)
	return inst._parent._playingmusic ~= nil or inst._parent._musictask ~= nil
end

local function TestForCombat(inst)
	local time = inst.lastwasdamagedtime
	if time ~= nil then
		if inst:IsPlayingMusic() then
			time = time + 1
		end
		if time >= GetTime() then
			return true
		end
	end

	local target = inst._parent.replica.combat:GetTarget()
	if inst._parent.replica.combat:IsValidTarget(target) then
		return true
	end

	for i, v in ipairs(AllPlayers) do
		if istargetedby(inst._parent, v) then
			return true
		end
	end

	local pos = inst:GetPosition()
	for i, v in ipairs(TheSim:FindEntities(pos.x, 0, pos.z, COMBAT_RANGE, COMBAT_TAGS, COMBAT_NOTAGS)) do
		if istargetedby(inst._parent, v) then
			return true
		end
	end

	return false
end

local function IsBurstSuspended(inst)
	if not inst.lastwasdamagedtime or inst.invincible then
		return false
	elseif inst:HasTag("hostileprojectile") then
		return true
	elseif GetTime() - inst.lastwasdamagedtime > COMBAT_TIMEOUT then
		return false
	end

	local num_attackers = 0

	for i, v in ipairs(AllPlayers) do
		if isattackedby(inst._parent, v) then
			num_attackers = num_attackers + 1
			if num_attackers > COMBAT_MAX_ATTACKERS then
				return false
			end
		end
	end

	return num_attackers > 0
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddNetwork()

	inst:AddTag("CLASSIFIED")

	inst:Hide()

	inst._currenthealth = net_int(inst.GUID, "epichealth.currenthealth", "currenthealthdirty")
    inst._maxhealth = net_int(inst.GUID, "epichealth.maxhealth", "maxhealthdirty")
	inst._invincible = net_bool(inst.GUID, "epichealth.invincible", "invincibledirty")
	inst._resist = net_tinybyte(inst.GUID, "epichealth.resist", "resistdirty")
	inst._stimuli = net_tinybyte(inst.GUID, "epichealth.stimuli", "stimulidirty")
	inst._damaged = net_event(inst.GUID, "damaged")

	if not TheNet:IsDedicated() then
		inst:ListenForEvent("currenthealthdirty", OnCurrentHealthDirty)
       	inst:ListenForEvent("maxhealthdirty", OnMaxHealthDirty)
		inst:ListenForEvent("invincibledirty", OnInvincibleDirty)
		inst:ListenForEvent("resistdirty", OnResistDirty)
		inst:ListenForEvent("stimulidirty", OnStimuliDirty)
		inst:ListenForEvent("damaged", OnDamaged)

		inst.IsPlayingMusic = IsPlayingMusic
		inst.IsBurstSuspended = IsBurstSuspended
		inst.TestForCombat = TestForCombat

		inst.currenthealth = 0
		inst.maxhealth = 0
		inst.invincible = false
	end

	inst.entity:SetPristine()

	Tykvesh.OnEntityReplicated(inst, OnEntityReplicated)

	if not TheWorld.ismastersim then
		return inst
	end

	inst.persists = false

	return inst
end

return Prefab("epichealth_proxy", fn)