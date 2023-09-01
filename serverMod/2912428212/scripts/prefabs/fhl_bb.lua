local assets = { Asset("ANIM", "anim/swap_fhl_bb.zip"), Asset("ANIM", "anim/fhl_bb.zip"),

    Asset("ATLAS", "images/inventoryimages/fhl_bb.xml") }

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "swap_fhl_bb", "symbol_15220700")
    owner.AnimState:OverrideSymbol("swap_body", "swap_fhl_bb", "symbol_b6d8e12e")
    inst.components.container:Open(owner)
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    owner.AnimState:ClearOverrideSymbol("backpack")
    inst.components.container:Close(owner)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.MiniMapEntity:SetIcon("krampus_sack.png")

    inst.AnimState:SetBank("pirate_booty_bag")
    inst.AnimState:SetBuild("swap_fhl_bb")
    inst.AnimState:PlayAnimation("anim")

    -- inst.foleysound = "dontstarve/movement/foley/krampuspack"

    inst:AddTag("backpack")
    inst:AddTag("fridge")
    inst:AddTag("icebox_valid")

    -- waterproofer (from waterproofer component) added to pristine state for optimization
    inst:AddTag("waterproofer")

    inst:AddComponent("talker")
    inst.components.talker.fontsize = 20
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.colour = Vector3(0.6, 0.9, 0.9, 1)
    inst.components.talker.offset = Vector3(0, 100, 0)
    inst.components.talker.symbol = "swap_object"

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.cangoincontainer = false
    inst.components.inventoryitem.foleysound = "dontstarve/movement/foley/marblearmour"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fhl_bb.xml"

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(0)

    if TUNING.FHL_HJOPEN then
        inst:AddComponent("armor")
        inst.components.armor:InitCondition(TUNING.ARMORMARBLE * 3, 0.8)
    end

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BACK or EQUIPSLOTS.BODY

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("krampus_sack")

    MakeHauntableLaunchAndDropFirstItem(inst)

    return inst
end

return Prefab("common/inventory/fhl_bb", fn, assets)
