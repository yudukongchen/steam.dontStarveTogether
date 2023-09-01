local assets = {Asset("ANIM", "anim/krm_pocketwatch_weapon.zip"),
                Asset("ATLAS", "images/inventoryimages/krm_pocketwatch_weapon.xml")}

local prefabs = {"pocketwatch_weapon_fx"}

RegisterInventoryItemAtlas("images/inventoryimages/krm_pocketwatch_weapon.xml", "krm_pocketwatch_weapon.tex")

STRINGS.NAMES.KRM_POCKETWATCH_WEAPON = "束缚者"
STRINGS.RECIPE_DESC.KRM_POCKETWATCH_WEAPON = "警钟promax"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.KRM_POCKETWATCH_WEAPON = "那么，另一半在哪里？"

local function TryStartFx(inst, owner)
    owner = owner or inst.components.equippable:IsEquipped() and inst.components.inventoryitem.owner or nil

    if owner == nil then
        return
    end
    if inst._vfx_fx_inst ~= nil and inst._vfx_fx_inst.entity:GetParent() ~= owner then
        inst._vfx_fx_inst:Remove()
        inst._vfx_fx_inst = nil
    end

    if inst._vfx_fx_inst == nil then
        inst._vfx_fx_inst = SpawnPrefab("pocketwatch_weapon_fx")
        inst._vfx_fx_inst.entity:AddFollower()
        inst._vfx_fx_inst.entity:SetParent(owner.entity)
        inst._vfx_fx_inst.Follower:FollowSymbol(owner.GUID, "swap_object", 15, 70, 0)
    end
end

local function StopFx(inst)
    if inst._vfx_fx_inst ~= nil then
        inst._vfx_fx_inst:Remove()
        inst._vfx_fx_inst = nil
    end
end

-------------------------------------------------------------------------------
local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "krm_pocketwatch_weapon", "swap_object")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    TryStartFx(inst, owner)
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    StopFx(inst)
end

local function onequiptomodel(inst, owner, from_ground)
    StopFx(inst)
end


local function IsNearOther(pt, newpillars)
	for i, v in ipairs(newpillars) do
		if distsq(pt.x, pt.z, v.x, v.z) < 1 then
			return true
		end
	end
	return false
end

local function DoPillarsTarget(target, caster, item, newpillars, map, x0, z0)
	target:PushEvent("dispell_shadow_pillars")

	local padding =
		(target:HasTag("epic") and 1) or
		(target:HasTag("smallcreature") and 0) or
		.75
	local radius = math.max(1, target:GetPhysicsRadius(0) + padding)
	local circ = PI2 * radius
	local num = math.floor(circ / 1.4 + .5)

	local period = 1 / num
	local delays = {}
	for i = 0, num - 1 do
		table.insert(delays, i * period)
	end

	local platform = target:GetCurrentPlatform()
	local flying = not platform and target:HasTag("flying")

	local ent = SpawnPrefab("shadow_pillar_target")
	ent.Transform:SetPosition(x0, 0, z0)
	ent:SetDelay(delays[#delays]) --this just extends lifetime, spell still takes effect right away
	ent:SetTarget(target, radius, platform ~= nil)

	local theta = math.random() * PI2
	local delta = PI2 / num
	for i = 1, num do
		local pt = Vector3(x0 + math.cos(theta) * radius, 0, z0 - math.sin(theta) * radius)
		if not IsNearOther(pt, newpillars) and
			map:IsPassableAtPoint(pt.x, 0, pt.z, true) and
			flying or (map:GetPlatformAtPoint(pt.x, pt.z) == platform) and
			not map:IsGroundTargetBlocked(pt) then
			ent = SpawnPrefab("shadow_pillar")
			ent.Transform:SetPosition(pt:Get())
			ent:SetDelay(table.remove(delays, math.random(#delays)))
			ent:SetTarget(target, platform ~= nil)
			newpillars[ent] = pt
		end
		theta = theta + delta
	end

	if not (target.sg ~= nil and target.sg:HasStateTag("noattack")) then
		target:PushEvent("attacked", { attacker = caster, damage = 0, weapon = item })
	end
end
local function onattack(inst, attacker, target)
    inst.SoundEmitter:PlaySound("wanda2/characters/wanda/watch/weapon/attack")
    if target and target.entity:IsVisible() and math.random() < 0.25 and 
        not (target.components.health ~= nil and target.components.health:IsDead()) then
        local x, y, z = target.Transform:GetWorldPosition()
        if TheWorld.Map:IsPassableAtPoint(x, y, z, true) then
            DoPillarsTarget(target, attacker, nil, {},TheWorld.Map, x, z)
        end
    end
end

local function onblink(staff, pos, caster)
    if caster then
        if caster.components.staffsanity then
            caster.components.staffsanity:DoCastingDelta(-10)
        elseif caster.components.sanity ~= nil then
            caster.components.sanity:DoDelta(-10)
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst:AddTag("pocketwatch")

    inst.AnimState:SetBank("krm_pocketwatch_weapon")
    inst.AnimState:SetBuild("krm_pocketwatch_weapon")
    inst.AnimState:PlayAnimation("idle", true)

    MakeInventoryFloatable(inst, "small", 0.05, {1.2, 0.75, 1.2})

    inst.scrapbook_specialinfo = "POCKETWATCH_WEAPON"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst:AddComponent("lootdropper")

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable:SetOnEquipToModel(onequiptomodel)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(100)
    inst.components.weapon:SetRange(TUNING.WHIP_RANGE)
    inst.components.weapon:SetOnAttack(onattack)

    inst:AddComponent("blinkstaff")
    inst.components.blinkstaff:SetFX("sand_puff_large_front", "sand_puff_large_back")
    inst.components.blinkstaff.onblinkfn = onblink
    
    MakeHauntableLaunch(inst)

    return inst
end

--------------------------------------------------------------------------------

return Prefab("krm_pocketwatch_weapon", fn, assets, prefabs)
