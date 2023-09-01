local assets=
{ 
    Asset("ANIM", "anim/mechacannon.zip"),
    Asset("ANIM", "anim/swap_mechacannon.zip"), 

    Asset("ATLAS", "images/inventoryimages/mechacannon.xml"),
    Asset("IMAGE", "images/inventoryimages/mechacannon.tex"),
}

local prefabs = 
{
	"mechacannon_laser",
}

local function onattack(inst, owner, target)
end

local function OnEquip(inst, owner) 

	-- This is the only way I found to move an animation object in the z axis
	-- Would have been problematic if I was using the skirt animation
	-- Note that for some reasons only one SetMultiSymbolExchange can be used at a time
	-- The shield does that too, but you can't use the two at the same time so it's ok
	owner.AnimState:ClearSymbolExchanges()
	owner.AnimState:SetMultiSymbolExchange("swap_object", "skirt")
    owner.AnimState:OverrideSymbol("swap_object", "swap_mechacannon", "mechacannon")
	
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal")
end

local function OnUnequip(inst, owner) 

	owner.AnimState:ClearSymbolExchanges()
	
    owner.AnimState:Hide("ARM_carry") 
	inst.AnimState:Hide("swap_shield")
    owner.AnimState:Show("ARM_normal")

end


-- local function fuelupdate(inst)
    -- if inst._light ~= nil then
        -- local fuelpercent = inst.components.fueled:GetPercent()
        -- inst._light.Light:SetIntensity(Lerp(.4, .6, fuelpercent))
        -- inst._light.Light:SetRadius(Lerp(3, 5, fuelpercent))
        -- inst._light.Light:SetFalloff(.9)
    -- end
-- end

-- local function nofuel(inst)
    -- if inst.components.equippable:IsEquipped() and inst.components.inventoryitem.owner ~= nil then
        -- local data =
        -- {
            -- prefab = inst.prefab,
            -- equipslot = inst.components.equippable.equipslot,
        -- }
        -- turnoff(inst)
        -- inst.components.inventoryitem.owner:PushEvent("torchranout", data)
    -- else
        -- turnoff(inst)
    -- end
-- end

local function ontakefuel(inst)
    inst.components.fueled:DoDelta(100)
	inst.components.equippable.restrictedtag = "maple"
end




local function fn()
	local inst = CreateEntity()
	
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst.entity:AddMiniMapEntity()
	
    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("mechacannon")
    inst.AnimState:SetBuild("mechacannon")
    inst.AnimState:PlayAnimation("idle")
	
    MakeInventoryFloatable(inst)	
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end

	
	inst.MiniMapEntity:SetIcon("mechacannon.tex")

	inst:AddTag("thecannon")

	inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "mechacannon"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/mechacannon.xml"
	
    inst:AddComponent("equippable")
	inst.components.equippable.equipslot = EQUIPSLOTS.HANDS
	inst.components.equippable.restrictedtag = "maple"
	

		
	MakeHauntableLaunch(inst)
   	
    inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )	
	
	
	inst:AddTag("weapon")
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(2)	--To take aggro, damage is made in maple.lua
	inst.components.weapon:SetRange(15)
	inst.components.weapon.onattack = onattack
	inst:AddTag("sharp")
    inst:AddTag("pointy")

	inst:AddComponent("fueled")	
	inst.components.fueled.fueltype = FUELTYPE.MECHACANNON_FUELTYPE
	inst.components.fueled.maxfuel = (100)
	inst.components.fueled:InitializeFuelLevel(100)
	inst.components.fueled:StopConsuming()
	
	-- inst.components.fueled:SetUpdateFn(fuelupdate)
	-- inst.components.fueled:SetDepletedFn(nofuel)
    inst.components.fueled:SetTakeFuelFn(ontakefuel)
	inst.components.fueled.accepting = true
	

	
    return inst
end

return Prefab("common/inventory/mechacannon", fn, assets, prefabs)
	
