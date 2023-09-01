local assets =
{
    Asset("ANIM", "anim/littlematch.zip"),
    Asset("SOUND", "sound/common.fsb"),
}

local prefabs =
{
    "littlematchfire",
}

local function onequip(inst, owner)
    inst.components.burnable:Ignite()

    owner.AnimState:OverrideSymbol("swap_object", "littlematch", "swap_littlematch")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    owner.SoundEmitter:PlaySound("dontstarve/wilson/torch_swing")

    if inst.fires == nil then
        inst.fires = {}

        for i, fx_prefab in ipairs(inst:GetSkinName() == nil and { "littlematchfire" } or SKIN_FX_PREFAB[inst:GetSkinName()] or {}) do --没有皮肤该怎么改
            local fx = SpawnPrefab(fx_prefab)
            fx.entity:SetParent(owner.entity)
            fx.entity:AddFollower()
            fx.Follower:FollowSymbol(owner.GUID, "swap_object", fx.fx_offset_x or 0, fx.fx_offset, 0)
            fx:AttachLightTo(owner)

            table.insert(inst.fires, fx)
        end
    end
end

local function onunequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end

    if inst.fires ~= nil then
        for i, fx in ipairs(inst.fires) do
            fx:Remove()
        end
        inst.fires = nil
        owner.SoundEmitter:PlaySound("dontstarve/common/fireOut")
    end

    inst.components.burnable:Extinguish()
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function onpocket(inst, owner)
    inst.components.burnable:Extinguish()
end

local function onattack(weapon, attacker, target)
    --target may be killed or removed in combat damage phase
    if target ~= nil and target:IsValid() and target.components.burnable ~= nil and math.random() < TUNING.TORCH_ATTACK_IGNITE_PERCENT * target.components.burnable.flammability then
        target.components.burnable:Ignite(nil, attacker)
    end
end

local function onupdatefueledraining(inst)
    local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
    inst.components.fueled.rate =
        owner ~= nil and
        owner.components.sheltered ~= nil and
        owner.components.sheltered.sheltered and
        (inst._fuelratemult or 1) or
        (1 + TUNING.TORCH_RAIN_RATE * TheWorld.state.precipitationrate) * (inst._fuelratemult or 1)
end

local function onisraining(inst, israining)
    if inst.components.fueled ~= nil then
        if israining then
            inst.components.fueled:SetUpdateFn(onupdatefueledraining)
            onupdatefueledraining(inst)
        else
            inst.components.fueled:SetUpdateFn()
            inst.components.fueled.rate = inst._fuelratemult or 1
        end
    end
end

local function onfuelchange(newsection, oldsection, inst)
    if newsection <= 0 then
        --when we burn out
        if inst.components.burnable ~= nil then
            inst.components.burnable:Extinguish()
        end
        local equippable = inst.components.equippable
        if equippable ~= nil and equippable:IsEquipped() then
            local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
            if owner ~= nil then
                local data =
                {
                    prefab = inst.prefab,
                    equipslot = equippable.equipslot,
                    announce = "ANNOUNCE_MATCH_OUT",
                }
                inst:Remove()
                owner:PushEvent("itemranout", data)
                return
            end
        end
        inst:Remove()
    end
end

local function SetFuelRateMult(inst, mult)
    mult = mult ~= 1 and mult or nil
    if inst._fuelratemult ~= mult then
        inst._fuelratemult = mult
        onisraining(inst, TheWorld.state.israining)
    end
end

local function ReticuleTargetFn()   --mark
    local player = ThePlayer
    local ground = TheWorld.Map
    local pos = Vector3()
    for r = 5, 0, -.25 do
        pos.x, pos.y, pos.z = player.entity:LocalToWorldSpace(r, 0, 0)
        if ground:IsPassableAtPoint(pos:Get()) then
            return pos
        end
    end
    return pos
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("littlematch")
    inst.AnimState:SetBuild("littlematch")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("littlematch")

    inst:AddTag("wildfireprotected")

    --lighter (from lighter component) added to pristine state for optimization
    inst:AddTag("lighter")

    --waterproofer (from waterproofer component) added to pristine state for optimization
    inst:AddTag("waterproofer")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    --看看能不能搞出圈子来
    --inst:AddComponent("reticule")

	MakeInventoryFloatable(inst, "med", nil, 0.68)

    inst.entity:SetPristine()

    --动作挂名
    --看看光环吧。。。
       
    inst:AddComponent("reticule")
    inst.components.reticule.ease = true
    inst.components.reticule.mouseenabled = true       --鼠标允许？
    inst.components.reticule.targetfn = ReticuleTargetFn
    inst.components.reticuleprefab = "reticuleaoesmallhostiletarget"
    inst.components.reticule.pingprefab = "reticuleaoesmallping"       --大概是固定在原地的组件
    inst.components.reticule.mouseenabled = true

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.TORCH_DAMAGE)
    inst.components.weapon:SetOnAttack(onattack)

    -----------------------------------
    inst:AddComponent("lighter")
    -----------------------------------

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/littlematch.xml"
    -----------------------------------

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnPocket(onpocket)
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    -----------------------------------

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)

    -----------------------------------

    inst:AddComponent("inspectable")

    -----------------------------------

    inst:AddComponent("burnable")
    inst.components.burnable.canlight = false
    inst.components.burnable.fxprefab = nil

    -----------------------------------

    inst:AddComponent("fueled")
    inst.components.fueled:SetSectionCallback(onfuelchange)
    inst.components.fueled:InitializeFuelLevel(TUNING.TORCH_FUEL)
    inst.components.fueled:SetDepletedFn(inst.Remove)
    inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)

    inst:AddComponent("transmit") 

    inst:WatchWorldState("israining", onisraining)
    onisraining(inst, TheWorld.state.israining)

    inst._fuelratemult = nil
    inst.SetFuelRateMult = SetFuelRateMult

    MakeHauntableLaunch(inst)

    -----------------------------------
    
    return inst
end

return Prefab("littlematch", fn, assets, prefabs)