local assets =
{
    Asset("ANIM", "anim/asa_items.zip"),
    Asset("ANIM", "anim/asa_drone.zip"),
    Asset( "IMAGE", "images/inventoryimages/asa_drone_off.tex" ),
    Asset( "ATLAS", "images/inventoryimages/asa_drone_off.xml" ),
}

local function fn1()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("asa_items")
    inst.AnimState:SetBuild("asa_items")
    inst.AnimState:PlayAnimation("repair")
	local s = 0.6
	inst.AnimState:SetScale(s,s,s)
	
    MakeInventoryFloatable(inst, "small", 0.05, 0.95)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -- inst:AddComponent("stackable")
    -- inst.components.stackable.maxsize = 10

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "asa_repair"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/asa_repair.xml"

    inst:AddComponent("asa_healer")
	inst:AddComponent("asa_repairer")
	
	inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(5)
    inst.components.finiteuses:SetUses(5)
    inst.components.finiteuses:SetOnFinished(inst.Remove)
	
    MakeHauntableLaunch(inst)

    return inst
end

local function fn2()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("asa_items")
    inst.AnimState:SetBuild("asa_items")
    inst.AnimState:PlayAnimation("boost")

    MakeInventoryFloatable(inst, "small", 0.05, 0.95)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "asa_boost"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/asa_boost.xml"

    inst:AddComponent("asa_booster")

    MakeHauntableLaunch(inst)

    return inst
end

local function dronepowerdown(inst)
    inst.components.inventoryitem.atlasname = "images/inventoryimages/asa_drone_off.xml"
    inst.components.inventoryitem:ChangeImageName("asa_drone_off")

    local owner = inst.components.inventoryitem.owner
    local inventory = owner and owner.components.inventory
    if owner and inventory
    and (inventory:GetEquippedItem(EQUIPSLOTS.NECK) and inventory:GetEquippedItem(EQUIPSLOTS.NECK) == inst)
    or (inventory:GetEquippedItem(EQUIPSLOTS.BODY) and inventory:GetEquippedItem(EQUIPSLOTS.BODY) == inst)
    then
        inst.components.equippable:Unequip(owner)
        owner.components.inventory:DropItem(inst)
    end
end

local function drone_equip(inst, owner)
    if not owner:HasTag("player") then
        return
    end
    if inst.components.fueled:IsEmpty() then
        inst:DoTaskInTime(0.1, function()
            owner.components.inventory:GiveItem(inst)
        end)
    else
        owner.asa_drone = SpawnPrefab("asa_drone_fx")
        owner.asa_drone.entity:SetParent(owner.entity)
        owner:AddTag("asa_shielded")
    end
end

local function drone_unequip(inst, owner)
    owner:RemoveTag("asa_shielded")
    if owner.asa_drone then
        owner.asa_drone.AnimState:PlayAnimation("idle_pst")
        owner.asa_drone:ListenForEvent("animover", owner.asa_drone.Remove)
        owner.asa_drone = nil

    end
end

local function fn3()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("asa_drone")
    inst.AnimState:SetBuild("asa_drone")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("asa_item")
    inst:AddTag("asa_shield_drone")

    MakeInventoryFloatable(inst, "small", 0.05, 0.95)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "asa_drone"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/asa_drone.xml"

    inst:AddComponent("fueled")
    inst.components.fueled.maxfuel = 525
    inst.components.fueled:InitializeFuelLevel(525)
    inst.components.fueled.accepting = true
    inst.components.fueled:SetDepletedFn(dronepowerdown)

    local oldDoDelta = inst.components.fueled.DoDelta
    inst.components.fueled.DoDelta = function(self, amount, doer)
        if amount > 0 and self:IsEmpty() then
            inst.components.inventoryitem.atlasname = "images/inventoryimages/asa_drone.xml"
            inst.components.inventoryitem:ChangeImageName("asa_drone")
        end
        oldDoDelta(self, amount, doer)
    end

    inst:AddComponent("equippable") --装备组件
    inst.components.equippable.equipslot = EQUIPSLOTS.NECK or EQUIPSLOTS.BODY
    inst.components.equippable:SetOnUnequip(drone_unequip) --解除装备
    inst.components.equippable:SetOnEquip(drone_equip)

    inst:DoTaskInTime(2,function()
        if inst.components.fueled:IsEmpty() then
            inst.components.inventoryitem.imagename = "asa_drone_off"
            inst.components.inventoryitem.atlasname = "images/inventoryimages/asa_drone_off.xml"
        end
    end)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("asa_repair", fn1, assets),
Prefab("asa_boost", fn2),
Prefab("asa_drone", fn3)