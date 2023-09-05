local assets =
{
    Asset("ANIM", "anim/huomu_sw.zip"),
	Asset("ATLAS", "images/inventoryimages/huomu.xml"),
    Asset("IMAGE", "images/inventoryimages/huomu.tex"),
}

local function OnBlocked(owner, data) 
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_armour")
end

local function onequip(inst, owner) 
	owner.AnimState:OverrideSymbol("swap_body", "huomu_sw", "huomu")						
    inst:ListenForEvent("blocked", OnBlocked, owner)
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst:RemoveEventCallback("blocked", OnBlocked, owner)
end
	
local function fn()
     local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

     inst.AnimState:SetBank("huomu") 
    inst.AnimState:SetBuild("huomu_sw") 
    inst.AnimState:PlayAnimation("anim")	

    inst:AddTag("wood")
	
	inst:DoPeriodicTask(5, function()
	if inst.components.armor.condition  < 1350 then
	if  inst:GetIsWet() then
	 inst.components.armor.condition = inst.components.armor.condition + 15
	 else
	 inst.components.armor.condition = inst.components.armor.condition + 5
	end
	if inst.components.armor.condition  > 1350 then
	inst.components.armor.condition = 1350
	end
	elseif inst.components.armor.condition  > 1350 then
	inst.components.armor.condition = 1350
	end
	end)		

    inst:AddComponent("inspectable") 

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/huomu.xml"
    
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(1350,0.9) 

    inst:AddComponent("equippable") 
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY 

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    return inst
end

return Prefab("huomu", fn, assets, prefabs)


