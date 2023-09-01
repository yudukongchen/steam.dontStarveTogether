local assets=
{
	Asset("ANIM", "anim/backpack.zip"),
	Asset("ANIM", "anim/swap_tz_vast_string.zip"),
	Asset( "IMAGE", "images/inventoryimages/tz_vast_string.tex" ),
    Asset( "ATLAS", "images/inventoryimages/tz_vast_string.xml" ),
	
}

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_body", "swap_tz_vast_string", "backpack")
    owner.AnimState:OverrideSymbol("swap_body", "swap_tz_vast_string", "swap_body")
    
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

local function fn(Sim)
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
	inst.entity:AddNetwork()
    
    inst.AnimState:SetBank("swap_tz_vast_string")
    inst.AnimState:SetBuild("swap_tz_vast_string")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("backpack")

	--local minimap = inst.entity:AddMiniMapEntity()
	--minimap:SetIcon("tz_vast_string.tex")
	inst.entity:SetPristine()
    
    if not TheWorld.ismastersim then
        return inst
    end

    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "tz_vast_string"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_vast_string.xml"
    inst.components.inventoryitem.cangoincontainer = false
    
    
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )

    return inst
end

return Prefab( "common/inventory/tz_vast_string", fn, assets) 
