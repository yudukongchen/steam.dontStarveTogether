
local assets=
{
	Asset("ANIM", "anim/tz_yanjing.zip"),
	Asset("ATLAS", "images/inventoryimages/tz_yanjing.xml"),
}

local prefabs =
{
}
local function onequiphat(inst, owner) 
	owner.AnimState:OverrideSymbol("swap_hat", "tz_yanjing", "swap_hat")
    owner.AnimState:Show("HAT")
    owner.AnimState:Show("HAT_HAIR")
    owner.AnimState:Hide("HAIR_NOHAT")
    owner.AnimState:Hide("HAIR")
    if owner:HasTag("player") then
            owner.AnimState:Hide("HEAD")
            owner.AnimState:Show("HEAD_HAT")
        end
end

local function onunequiphat(inst, owner) 
	owner.AnimState:ClearOverrideSymbol("swap_hat")
    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAT_HAIR")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")
    
        if owner:HasTag("player") then
            owner.AnimState:Show("HEAD")
            owner.AnimState:Hide("HEAD_HAT")
        end
end

local function opentop_onequip(inst, owner) 

        owner.AnimState:OverrideSymbol("swap_hat", "tz_yanjing", "swap_hat")
        owner.AnimState:Show("HAT")
        owner.AnimState:Hide("HAT_HAIR")
        owner.AnimState:Show("HAIR_NOHAT")
        owner.AnimState:Show("HAIR")
        
        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAIR")
		if inst.components.fueled ~= nil then
            inst.components.fueled:StartConsuming()
        end
       
    end
local function finished(inst) 
        inst:Remove()		
end

local function fn(Sim)
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("tz_yanjing")
    inst.AnimState:SetBuild("tz_yanjing")
    inst.AnimState:PlayAnimation("idle")

	inst:AddTag("hat")
	inst:AddTag("hide")
    MakeInventoryFloatable(inst, "med", 0.2, {1.1, 0.5, 1.1})	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
    inst:AddComponent("insulator")
    inst.components.insulator:SetSummer()	
	inst.components.insulator:SetInsulation(60)	
    inst:AddComponent("inventoryitem") 
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_yanjing.xml"
       
	inst:AddComponent("equippable") 
	inst.components.equippable.equipslot = EQUIPSLOTS.HEAD 
	inst.components.equippable:SetOnEquip( onequiphat ) 
    inst.components.equippable:SetOnUnequip( onunequiphat ) 
    inst.components.equippable:SetOnEquip(opentop_onequip)
    
	
    inst:AddComponent("tradable") 
	
    return inst
end 
return Prefab( "tz_yanjing", fn, assets, prefabs)
--[[
local  beier = 
{	
	"01是个大笨蛋",
	"02是个大笨蛋",
	"03是个大笨蛋",
}
local a = 1
print(a)
print(beier[a])
--]]