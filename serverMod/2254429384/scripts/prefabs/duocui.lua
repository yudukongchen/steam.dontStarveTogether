local assets =
{
    Asset("ANIM", "anim/duocui.zip"),
    Asset("ANIM", "anim/duocui_sw.zip"),
	Asset("ATLAS", "images/inventoryimages/duocui.xml"),
    Asset("IMAGE", "images/inventoryimages/duocui.tex"),
}


local function onfinished(inst)
    inst:Remove()
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object","duocui_sw","duocui")
	owner.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal")
    end
	
local function onattack(inst, owner, target)
local xx
xx = owner.components.sanity.max*(1- owner.components.sanity:GetPercent())
 owner.components.sanity:DoDelta(xx*0.015)

if math.random() < 0.35 then
 owner.components.sanity:DoDelta(xx*0.03)
			inst.components.weapon:SetDamage(136)
			else
			inst.components.weapon:SetDamage(68)
		end
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
	
    inst.AnimState:SetBank("duocui")
    inst.AnimState:SetBuild("duocui")
    inst.AnimState:PlayAnimation("idle")


    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP, 1)
  
    inst:AddTag("sharp")
	inst:AddTag("scythes")
	
	inst:AddComponent("harvestablereapers")

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(68)
	inst.components.weapon.onattack = onattack
    inst.components.weapon:SetRange(1,2)

    inst:AddComponent("inspectable")

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(600)
    inst.components.finiteuses:SetUses(600)   
    inst.components.finiteuses:SetOnFinished( onfinished )
	inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 1)
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/duocui.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip ) 
	
	inst:AddComponent("inventory")
	
	function inst:HarvestTarget(targ)
		if targ == nil or (not targ:IsValid()) or targ.Transform == nil then return end
		self.Transform:SetPosition(targ.Transform:GetWorldPosition())
		if targ.components.harvestable then
			targ.components.harvestable:Harvest(self)
		elseif targ.components.pickable then
			targ.components.pickable:Pick(self)
		elseif targ.components.crop then
			targ.components.crop:Harvest(self)
		end
		for slot, item in pairs(self.components.inventory.itemslots) do
			if item.components.stackable then
				while item.components.stackable:StackSize() > 1 do
					self.components.inventory:DropItem(item, false, true, self:GetPosition())
				end
			end
		end
		self.components.inventory:DropEverything()
		self:Remove()
		 local pos = Vector3(targ.Transform:GetWorldPosition())
    local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 2)
    for k,v in pairs(ents) do
        if v.components.pickable then
           v.components.pickable:Pick(self)
        end
        if v.components.crop then
           v.components.crop:Harvest(self)
        end
    end
	self.components.inventory:DropEverything()
		self:Remove()
	end
	
    return inst
end

return Prefab("duocui", fn, assets, prefabs)


