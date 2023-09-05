local assets =
{
    Asset("ANIM", "anim/landun_sw.zip"),
	Asset("ATLAS", "images/inventoryimages/landun.xml"),
    Asset("IMAGE", "images/inventoryimages/landun.tex"),
}

local function OnBlocked(owner, data) 
--[[local inst = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_armour")
	 SpawnPrefab("groundpoundring_fx").Transform:SetPosition(owner.Transform:GetWorldPosition())
	 local pos = Vector3(owner.Transform:GetWorldPosition())
    local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 12)
    for k,v in pairs(ents) do
        if v.components.locomotor and not v:HasTag("player") then
           v.components.locomotor.runspeed = v.components.locomotor.runspeed*0.25
           v.components.locomotor.walkspeed = v.components.locomotor.walkspeed*0.25
		    inst:DoTaskInTime(10, function() 
           v.components.locomotor.runspeed = v.components.locomotor.runspeed*4
           v.components.locomotor.walkspeed = v.components.locomotor.walkspeed*4		
		   end)
        end
		end]]
end

local function onequip(inst, owner) 
	owner.AnimState:OverrideSymbol("swap_body", "landun_sw", "landun")						
    inst:ListenForEvent("attacked", OnBlocked, owner)
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst:RemoveEventCallback("attacked", OnBlocked, owner)
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

     inst.AnimState:SetBank("landun") 
    inst.AnimState:SetBuild("landun_sw") 
    inst.AnimState:PlayAnimation("anim")	

    inst:AddComponent("inspectable") 

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/landun.xml"  
    
	inst:AddComponent("waterproofer") 
    inst.components.waterproofer:SetEffectiveness(0.2)
    
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(1500,0.95) 

    inst:AddComponent("equippable") 
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY 

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    return inst
end

return Prefab("landun", fn, assets, prefabs)


