local assets =
{
    Asset("ANIM", "anim/tz_iceball.zip"), 
    Asset("ANIM", "anim/swap_tz_iceball.zip"),
	Asset("ATLAS", "images/inventoryimages/tz_iceball.xml"),
    Asset("IMAGE", "images/inventoryimages/tz_iceball.tex"),
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_tz_iceball", "swap_body")
    owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")
	inst.zhishiqi:set(owner)
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
	inst.zhishiqi:set(nil)
end

local function OnZsq(inst)
	local owner = inst.zhishiqi:value()
	if  owner ~= nil and ThePlayer ~= nil  and ThePlayer == owner then --生成
		inst.components.tz_iceballreticule:CreateReticule(inst.zhishiqi:value()) 
	else
		inst.components.tz_iceballreticule:DestroyReticule()	
	end
end

--DebugSpawn"wilson".components.inventory:Equip(DebugSpawn"tz_iceball")

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("tz_iceball")
    inst.AnimState:SetBuild("tz_iceball")
    inst.AnimState:PlayAnimation("idle",true)
	
	inst.zhishiqi = net_entity(inst.GUID, "tz_iceball", "tz_iceball_dirty")

    inst:AddComponent("tz_iceballreticule")
	inst.components.tz_iceballreticule.reticuleprefab = "tz_reticuleline"
	
    inst:AddTag("sharp")
    inst:AddTag("pointy")
	inst:AddTag("tz_iceball")

    inst.entity:SetPristine()
	
    if not TheNet:IsDedicated() then
		inst:ListenForEvent("tz_iceball_dirty", OnZsq) 
    end
	
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
	inst.components.weapon.attackwear = 0

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(100)
    inst.components.finiteuses:SetUses(100)

    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("inspectable")
	
	inst:AddComponent("tz_iceball")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_iceball.xml"
	
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
	
    return inst
end

return Prefab("tz_iceball", fn, assets)