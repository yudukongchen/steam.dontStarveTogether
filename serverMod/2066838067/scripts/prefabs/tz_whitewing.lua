local assets =
{
    Asset("ANIM", "anim/tz_whitewing.zip"),
	Asset("ATLAS", "images/inventoryimages/tz_whitewing.xml")
}

local prefabs =
{
    "ash",
}

local function onequip(inst, owner)
	owner.AnimState:OverrideSymbol("hairpigtails", "tz_whitewing", "hairpigtails")
    if inst.components.container ~= nil then
        inst.components.container:Open(owner)
    end
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("hairpigtails")
    if inst.components.container ~= nil then
        inst.components.container:Close(owner)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("tz_whitewing")
    inst.AnimState:SetBuild("tz_whitewing")
    inst.AnimState:PlayAnimation("idle")

    inst.foleysound = "dontstarve/movement/foley/backpack"

    MakeInventoryFloatable(inst)

	inst:AddTag("waterproofer")
	inst:AddTag("hide_percentage")
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst) 
			inst.replica.container:WidgetSetup("krampus_sack") 
		end
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.cangoincontainer = false
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_whitewing.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BACK or EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("krampus_sack")

    inst:AddComponent("armor")
    inst.components.armor:InitIndestructible(0.5)
	
    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(0)
	
    MakeHauntableLaunchAndDropFirstItem(inst)

    return inst
end

return Prefab("tz_whitewing", fn, assets, prefabs)
