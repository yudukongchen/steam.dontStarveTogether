local assets =
{
    Asset("ANIM", "anim/backpack.zip"),
    Asset("ANIM", "anim/swap_xiaoyang_sack.zip"),
    Asset("ANIM", "anim/ui_backpack_2x4.zip"),
	Asset("ATLAS", "images/inventoryimages/tz_miemieback.xml"),
	Asset("IMAGE", "images/inventoryimages/tz_miemieback.tex"),
}

local function onequip(inst, owner)

    owner.AnimState:OverrideSymbol("backpack", "swap_xiaoyang_sack", "backpack")
    owner.AnimState:OverrideSymbol("swap_body", "swap_xiaoyang_sack", "swap_body")


    if inst.components.container ~= nil then
        inst.components.container:Open(owner)
    end
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    owner.AnimState:ClearOverrideSymbol("backpack")
    if inst.components.container ~= nil then
        inst.components.container:Close(owner)
    end
end

local function onburnt(inst)
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
        inst.components.container:Close()
    end

    SpawnPrefab("ash").Transform:SetPosition(inst.Transform:GetWorldPosition())

    inst:Remove()
end


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("swap_xiaoyang_sack")
    inst.AnimState:SetBuild("swap_xiaoyang_sack")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("backpack")

    inst.MiniMapEntity:SetIcon("tz_miemieback.tex")

    inst.foleysound = "dontstarve/movement/foley/backpack"
    MakeInventoryFloatable(inst, "med", 0.2, {1.1, 0.5, 1.1})
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst) 
			inst.replica.container:WidgetSetup("piggyback") 
		end
        return inst
    end
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.cangoincontainer = false
    inst.components.inventoryitem.imagename = "tz_miemieback"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_miemieback.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.PACK or  EQUIPSLOTS.BACK or EQUIPSLOTS.BODY

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst:AddComponent("insulator")
    inst.components.insulator:SetInsulation(TUNING.INSULATION_MED)
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("piggyback")

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    inst.components.burnable:SetOnBurntFn(onburnt)

    MakeHauntableLaunchAndDropFirstItem(inst)

    return inst
end

return Prefab("tz_miemieback", fn, assets)
