local assets =
{
    Asset("ANIM", "anim/tz_sword.zip"),
    Asset("ANIM", "anim/swap_tz_icesword.zip"),
	Asset("ATLAS", "images/inventoryimages/tz_icesword.xml"),
	Asset("IMAGE", "images/inventoryimages/tz_icesword.tex"),
}
local prefabs=
{
	"tz_icesword_fx",
	"tz_icesword_fx2",
}
local function onremovelight(light)
    light._icesword._light = nil
end
local function lighton(inst)
    if inst.components.equippable:IsEquipped() and  inst.components.inventoryitem.owner ~= nil then
        if inst._light == nil then
            inst._light = SpawnPrefab("tz_icesword_light")
            inst._light._icesword = inst
            inst:ListenForEvent("onremove", onremovelight, inst._light)
        end
        inst._light.entity:SetParent((inst._body or inst.components.inventoryitem.owner or inst).entity)
	end
end
local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_tz_icesword", "swap_tz_icesword")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
	lighton(inst)
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    if inst._light ~= nil then
        inst._light:Remove()
    end
end
local function SpawnIceFx(inst, target)
    if not inst or not target then return end
    local numFX = math.random(15,20)
    local pos = inst:GetPosition()
    local targetPos = target:GetPosition()
    local vec = targetPos - pos
    vec = vec:Normalize()
    local dist = pos:Dist(targetPos)
    local angle = inst:GetAngleToPoint(targetPos:Get())

    for i = 1, numFX do
        inst:DoTaskInTime(math.random() * 0.25, function(inst)
            local prefab = "icespike_fx_"..math.random(1,4)
            local fx = SpawnPrefab(prefab)
            if fx then
                local x = GetRandomWithVariance(0, 3)
                local z = GetRandomWithVariance(0, 3)
                local offset = (vec * math.random(dist * 0.25, dist)) + Vector3(x,0,z)
                fx.Transform:SetPosition((offset+pos):Get())
            end
        end)
    end
			local x3, y3, z3 = target.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(x3, y3, z3, 3, nil, { "INLIMBO","wall" })
			for i, v in ipairs(ents) do 
					if v ~= inst.WINDSTAFF_CASTER and v:IsValid() and v~= target and not v:HasTag("player")then
						if v.components.health ~= nil and
						not v.components.health:IsDead() and
						v.components.combat ~= nil and
						v.components.combat:CanBeAttacked() then
						v.components.combat:GetAttacked(inst, 42, nil, "tz_icesword")
							if v.components.freezable ~= nil and not v.components.health:IsDead()then 
								v.components.freezable:AddColdness(4)
								v.components.freezable:SpawnShatterFX()	
							end
						end
					end
			end
end


local function SpawnSpell(inst, target)
    local spell = SpawnPrefab(inst.castfx)
    spell.Transform:SetPosition(x, 0, z)
    spell:DoTaskInTime(6, spell.KillFX)
    return spell
end

local function getspawnlocation(inst, target)
    local x1, y1, z1 = inst.Transform:GetWorldPosition()
    local x2, y2, z2 = target.Transform:GetWorldPosition()
    return x1 + .15 * (x2 - x1), 0, z1 + .15 * (z2 - z1)
end

local function spawntornado(inst, target)
    local tornado = SpawnPrefab("tz_icetornado")
	if tornado then
    tornado.WINDSTAFF_CASTER = inst.components.inventoryitem.owner
    tornado.WINDSTAFF_CASTER_ISPLAYER = tornado.WINDSTAFF_CASTER ~= nil and tornado.WINDSTAFF_CASTER:HasTag("player")
    tornado.Transform:SetPosition(getspawnlocation(inst, target))
    tornado.components.knownlocations:RememberLocation("target", target:GetPosition())

    if tornado.WINDSTAFF_CASTER_ISPLAYER then
        tornado.overridepkname = tornado.WINDSTAFF_CASTER:GetDisplayName()
        tornado.overridepkpet = true
    end
	end
end

local function onattack(inst, attacker, target)
    if not target:IsValid() then
        return
    end
    if target.components.burnable ~= nil then
        if target.components.burnable:IsBurning() then
            target.components.burnable:Extinguish()
        elseif target.components.burnable:IsSmoldering() then
            target.components.burnable:SmotherSmolder()
        end
    end
	
	if math.random() < 0.15  and not inst.shexian then 
		if target.components.freezable ~= nil then
			target.components.freezable:AddColdness(1)
			target.components.freezable:SpawnShatterFX()
        end
			inst.shexian = true
			inst:DoTaskInTime(2, function() inst.shexian = false end)
	elseif math.random() < 0.25 and not inst.shexian then
			SpawnIceFx(inst, target)
			inst.shexian = true
			inst:DoTaskInTime(2, function() inst.shexian = false end)

	elseif math.random() < 0.31 and not inst.shexian  then
			spawntornado(inst, target)
			inst.shexian = true
			inst:DoTaskInTime(2, function() inst.shexian = false end)
	end
end

local function ice_fx_trail(inst)
    local owner = inst.components.inventoryitem:GetGrandOwner() or inst
    if not owner.entity:IsVisible() then
        return
    end
    local x, y, z = owner.Transform:GetWorldPosition()
	SpawnPrefab("tz_icesword_fx").Transform:SetPosition(x, y, z)
    inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/firesupressor_chuff")
	
end
local function ice_temp_trail(inst)
	local owner = inst.components.inventoryitem:GetGrandOwner()
	if owner.components.temperature then
		owner.components.temperature:DoDelta(-1)
	end
end

local function ice_equipped(inst)
    if inst._trailtask == nil then
        inst._trailtask = inst:DoPeriodicTask(10, ice_fx_trail, 0.1)
    end
end

local function ice_unequipped(inst)
    if inst._trailtask ~= nil then
        inst._trailtask:Cancel()
        inst._trailtask = nil
    end
end
local function OnDropped(inst)
    inst.Light:Enable(true)
end

local function OnPickup(inst)
    inst.Light:Enable(false)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    MakeInventoryPhysics(inst)
    inst.entity:AddDynamicShadow()	
    inst.DynamicShadow:SetSize(2, .75)

    inst.AnimState:SetBank("tz_sword")
    inst.AnimState:SetBuild("tz_sword")
    inst.AnimState:PlayAnimation("idle",true)
	inst.AnimState:SetMultColour(1,1,1,0.5)

    inst:AddTag("sharp")
    inst:AddTag("tz_icesword")
    inst.Light:SetFalloff(0.8)
    inst.Light:SetIntensity(.9)
    inst.Light:SetRadius(1.8)
    inst.Light:SetColour(0, 183 / 255, 1)
    inst.Light:Enable(true)
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(42)
    inst.components.weapon.onattack = onattack
    -------

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(800)
    inst.components.finiteuses:SetUses(800)
	inst.components.finiteuses:SetOnFinished(inst.Remove)
	
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_icesword.xml"

	inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst:AddComponent("heater")
    inst.components.heater:SetThermics(false, true)
    inst.components.heater.equippedheat = -15
	MakeHauntableLaunch(inst)
    inst:ListenForEvent("equipped", ice_equipped)
    inst:ListenForEvent("unequipped", ice_unequipped)
	lighton(inst)
    inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
    inst.components.inventoryitem:SetOnPickupFn(OnPickup)
    return inst
end
local function lightfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.Light:EnableClientModulation(true)
    inst.Light:SetFalloff(0.8)
    inst.Light:SetIntensity(.9)
    inst.Light:SetRadius(1.8)
    inst.Light:SetColour(0, 183 / 255, 1)
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

return Prefab("tz_icesword_light", lightfn),
	Prefab("tz_icesword", fn, assets, prefabs)