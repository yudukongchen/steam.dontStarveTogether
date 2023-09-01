local assets =
{
    Asset("ANIM", "anim/swap_nanashi_mumei_dagger.zip"),
    Asset("ANIM", "anim/floating_items.zip"),

    Asset( "IMAGE", "images/inventoryimages/nanashi_mumei_dagger.tex" ),
    Asset( "ATLAS", "images/inventoryimages/nanashi_mumei_dagger.xml" ),
}

local function dagger_throw_onattack(inst, attacker, target, skipsanity)
    local missed = false
    local dagger = SpawnSaveRecord(inst._dagger)
	local instPos = inst:GetPosition()
	if instPos ~= nil then
		dagger.Transform:SetPosition(instPos:Get())
        if target.components.combat and target:IsValid() then
            dagger.projectile = true
            target.components.combat:GetAttacked(attacker, attacker.components.combat:CalcDamage(target, dagger), dagger)

            if attacker:HasTag("nanashi_mumei") then
                if not target.components.debuffable then
                    target:AddComponent("debuffable")
                end
                if target.components.debuffable
                and not (target.components.health and target.components.health:IsDead()) 
                and not target:HasTag("playerghost") 
                then
                    target.components.debuffable:AddDebuff("buff_nanashi_mumei_terror_debuff_effect", "buff_nanashi_mumei_terror_debuff_effect")
                end
            end
            
        end		
		if dagger.components.finiteuses then
			dagger.components.finiteuses:Use(TUNING.NANASHI_MUMEI_DAGGER_USAGES * TUNING.NANASHI_MUMEI_DAGGER_THROW_DURA_LOST_PER)
		end
		dagger:AddTag("scarytoprey")
		dagger:DoTaskInTime(1, function(inst) inst:RemoveTag("scarytoprey") end)
		inst:Remove()
		attacker.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
	end
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_nanashi_mumei_dagger", "swap_nanashi_mumei_dagger")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if owner.prefab == "nanashi_mumei" and owner.components.combat then
        owner:AddTag("NANASHI_MUMEI_DAGGER_EQUIP")
        owner.components.combat:SetAttackPeriod(TUNING.NANASHI_MUMEI_DAGGER_ATKSPEED_BONUS)
    end
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end
    
    if owner.prefab == "nanashi_mumei" and owner.components.combat then
        owner:RemoveTag("NANASHI_MUMEI_DAGGER_EQUIP")
        owner.components.combat:SetAttackPeriod(0.4)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("swap_nanashi_mumei_dagger")
    inst.AnimState:SetBuild("swap_nanashi_mumei_dagger")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("pointy")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.NANASHI_MUMEI_DAGGER_DAMAGE)

    -------
    if TUNING.NANASHI_MUMEI_DAGGER_USAGES < 9999 then
        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(TUNING.NANASHI_MUMEI_DAGGER_USAGES)
        inst.components.finiteuses:SetUses(TUNING.NANASHI_MUMEI_DAGGER_USAGES)
        inst.components.finiteuses:SetOnFinished(inst.Remove)
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "nanashi_mumei_dagger"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/nanashi_mumei_dagger.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent('nanashi_mumei_throwable')
	inst.components.nanashi_mumei_throwable:SetRange(8, 10)
	inst.components.nanashi_mumei_throwable:SetOnAttack(dagger_throw_onattack)
	inst.components.nanashi_mumei_throwable:SetProjectile("nanashi_mumei_dagger_projectile")

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("nanashi_mumei_dagger", fn, assets)