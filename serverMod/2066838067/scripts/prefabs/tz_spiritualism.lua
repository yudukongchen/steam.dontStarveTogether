local assets = {Asset("ANIM", "anim/tz_spiritualism.zip"), Asset("ANIM", "anim/swap_tz_spiritualism.zip"),
                Asset("IMAGE", "images/inventoryimages/tz_spiritualism.tex"),
                Asset("ATLAS", "images/inventoryimages/tz_spiritualism.xml")}

local function onequip(inst, owner)
    if owner.prefab == "taizhen" then
        owner.AnimState:OverrideSymbol("swap_object", "swap_tz_spiritualism", "swap_tz_spiritualism")
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")
    else
        owner:DoTaskInTime(0, function()
            local bianbian = owner.components.inventory
            if bianbian then
                bianbian:DropItem(inst)
            end
            local talker = owner.components.talker
            if talker then
                talker:Say(STRINGS.NOYEXINGZHE)
            end
        end)
    end
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function onattack(inst, owner, target)
    if target ~= nil and target:IsValid() and (target:HasTag("shadowcreature") or target:HasTag("nightmarecreature")) and
        target.components.combat and target.components.health and not target.components.health:IsDead() then
        if target.components.lootdropper then
            target.components.lootdropper.chanceloottable = nil
        end
        target.components.combat:GetAttacked(owner, 999)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()

    MakeInventoryPhysics(inst)

    inst.MiniMapEntity:SetIcon("tz_spiritualism.tex")

    inst.AnimState:SetBank("tz_spiritualism")
    inst.AnimState:SetBuild("tz_spiritualism")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    -- inst:AddTag("pointy")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(17)
    inst.components.weapon:SetOnAttack(onattack)
    -------

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_spiritualism.xml"
    -- inst.components.inventoryitem:SetOnPutInInventoryFn(OnSound)	
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.dapperness = 5 / 300
    -- inst:AddComponent("hungermaker")   

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("tz_spiritualism", fn, assets)
