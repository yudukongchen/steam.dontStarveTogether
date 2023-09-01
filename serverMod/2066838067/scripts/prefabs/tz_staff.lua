local assets =
{
    Asset("ANIM", "anim/tz_staff.zip"),
    Asset("ANIM", "anim/swap_tz_staff.zip"),
    Asset( "IMAGE", "images/inventoryimages/tz_staff.tex" ),
    Asset( "ATLAS", "images/inventoryimages/tz_staff.xml" ),
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_tz_staff", "swap_tz_staff")

    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function DoEffects(pet)
    local x, y, z = pet.Transform:GetWorldPosition()
	SpawnPrefab("statue_transition_2").Transform:SetPosition(x, y, z)
	SpawnPrefab("spawn_fx_medium").Transform:SetPosition(x, y, z)
end

local function createlight(staff, target, pos)
	local caster = staff.components.inventoryitem.owner 
    if staff.components.finiteuses.current < 25 then
		if caster and caster.components.talker then
		caster.components.talker:Say(STRINGS.TZSTAFF)
		end
	return 
	else
	local light = SpawnPrefab("tz_image")
    light.Transform:SetPosition(pos:Get())
	DoEffects(light)
    staff.components.finiteuses:Use(25)
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("tz_staff")
    inst.AnimState:SetBuild("tz_staff")
    inst.AnimState:PlayAnimation("idle")
	inst.Transform:SetScale(1.3, 1.3, 1.3)
    MakeInventoryFloatable(inst, "med", 0.2, {1.1, 0.5, 1.1})	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(17)
	
    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(createlight)
    inst.components.spellcaster.canuseonpoint = true
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(100)
    inst.components.finiteuses:SetUses(100)
	inst.components.finiteuses:SetOnFinished(inst.Remove)
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_staff.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("tz_staff", fn, assets)
