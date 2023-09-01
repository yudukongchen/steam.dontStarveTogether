local assets =
{
    --Asset("ANIM", "anim/spear.zip"),
    Asset("ANIM", "anim/swap_change_moonsword.zip"),
	Asset("IMAGE","images/inventoryimages/change_moonsword.tex"),
	Asset("ATLAS","images/inventoryimages/change_moonsword.xml")
}

local DAMAGE = 20

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_change_moonsword", "swap_change_moonsword")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
	owner.AnimState:ClearOverrideSymbol("swap_object")
end

local function CheckDamage(inst)
	local phase = TheWorld.state.phase
	local nowdamage = DAMAGE
	if phase == "day" then 
		nowdamage = DAMAGE
	elseif phase == "dusk" then 
		nowdamage = DAMAGE * 2
	elseif phase == "night" then 
		nowdamage = DAMAGE * 3
	else
		nowdamage = DAMAGE
	end
	inst.components.weapon:SetDamage(nowdamage)
end 

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("swap_change_moonsword")
    inst.AnimState:SetBuild("swap_change_moonsword")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("pointy")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(DAMAGE)

    -------

--[[    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(250)
    inst.components.finiteuses:SetUses(250)
    inst.components.finiteuses:SetOnFinished(inst.Remove)
--]]
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "change_moonsword"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/change_moonsword.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)
	
	CheckDamage(inst)
	inst:WatchWorldState("phase",CheckDamage)
    return inst
end

return Prefab("change_moonsword", fn, assets)