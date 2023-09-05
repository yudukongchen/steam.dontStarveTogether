local assets =
{
    Asset("ANIM", "anim/riyan_sw.zip"),
	Asset("ATLAS", "images/inventoryimages/riyan.xml"),
    Asset("IMAGE", "images/inventoryimages/riyan.tex"),
}

local function OnBlocked(owner, data) 
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_armour")
end

local fxs 

local function onequip(inst, owner) 
	owner.AnimState:OverrideSymbol("swap_body", "riyan_sw", "riyan")						
    inst:ListenForEvent("attacked", OnBlocked, owner)
	inst:AddTag("huoyan")
	inst.Light:Enable(true)
    fxs = SpawnPrefab("riyanhuo")
    fxs.entity:SetParent(owner.entity)
    fxs.Transform:SetPosition(0, 0, 0)
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst:RemoveEventCallback("attacked", OnBlocked, owner)
	inst:RemoveTag("huoyan")
	inst.Light:Enable(false)
	fxs:Remove()
end
	
local function fn()
     local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)
    inst.entity:SetPristine()
	local light = inst.entity:AddLight()
    inst.Light:Enable(true)
    inst.Light:SetRadius(2)
    inst.Light:SetFalloff(0.5)
    inst.Light:SetIntensity(.75)
    inst.Light:SetColour(235/255,121/255,12/255)
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:DoPeriodicTask(3, function()
	if inst:HasTag("huoyan") then
	local owner = inst.components.inventoryitem.owner
	local pos = Vector3(inst.Transform:GetWorldPosition())
    local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 8)
    for k,v in pairs(ents) do
        if not v:HasTag("player") and v.components.health and not v:HasTag("wall") and not v:HasTag("chester") and not v:HasTag("abigail") and not v:HasTag("glommer") and not v:HasTag("hutch") and not v:HasTag("boat") then
		v.components.health:DoDelta(-34)
        end
		end
	local fx = SpawnPrefab("riyanhuo")
        fx.entity:SetParent(owner.entity)
        fx.Transform:SetPosition(0, 0, 0)
	end
	end)

    inst.AnimState:SetBank("riyan") 
    inst.AnimState:SetBuild("riyan_sw") 
    inst.AnimState:PlayAnimation("anim")	

    inst:AddComponent("inspectable") 

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/riyan.xml"  
    
	inst:AddComponent("waterproofer") 
    inst.components.waterproofer:SetEffectiveness(0.2)
	
	inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(34)
    inst.components.combat.playerdamagepercent = 0
    
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(1350,0.9) 

    inst:AddComponent("equippable") 
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY 

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    return inst
end

return Prefab("riyan", fn, assets, prefabs)


