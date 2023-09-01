local assets =
{
    Asset("ANIM", "anim/tz_jrby.zip"),
	Asset("ATLAS", "images/inventoryimages/tz_jrby.xml")
}

local prefabs =
{
    "ash",
}

local function onequip(inst, owner)
    owner.AnimState:AddOverrideBuild("tz_jrby")
    if inst.components.container ~= nil then
        inst.components.container:Open(owner)
    end
    if owner.components.health ~= nil then
        owner.components.health.externalfiredamagemultipliers:SetModifier(inst, 1 - TUNING.ARMORDRAGONFLY_FIRE_RESIST)
    end
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideBuild("tz_jrby")
    if inst.components.container ~= nil then
        inst.components.container:Close(owner)
    end
    if owner.components.health ~= nil then
        owner.components.health.externalfiredamagemultipliers:RemoveModifier(inst)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("tz_jrby")
    inst.AnimState:SetBuild("tz_jrby")
    inst.AnimState:PlayAnimation("idle")

    inst.foleysound = "dontstarve/movement/foley/backpack"

    MakeInventoryFloatable(inst)

	inst:AddTag("waterproofer")
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
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_jrby.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BACK or EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("krampus_sack")

    inst:AddComponent("insulator")
    inst.components.insulator:SetInsulation(TUNING.INSULATION_LARGE)
    inst.components.insulator:SetSummer()
	
    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(0)
	
    MakeHauntableLaunchAndDropFirstItem(inst)

    return inst
end

return Prefab("tz_jrby", fn, assets, prefabs)
