local assets=
{ 
    Asset("ANIM", "anim/haloangel.zip"),
    Asset("ANIM", "anim/haloangel_swap.zip"), 

    Asset("ATLAS", "images/inventoryimages/haloangel.xml"),
    Asset("IMAGE", "images/inventoryimages/haloangel.tex"),
}

local prefabs = 
{
    --"gold_nugget",
}

local function OnEquip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_hat", "haloangel", "swap_hat")
	
	owner.AnimState:Show("HAT")
	owner.AnimState:Show("HAT_HAIR")
	owner.AnimState:Show("HAIR_NOHAT")
	owner.AnimState:Show("HAIR")
	
	--owner:AddTag("angel")
	
	if owner:HasTag("player") then
		owner.AnimState:Show("HEAD")
		owner.AnimState:Hide("HEAD_HAT")
	end
end
 
local function OnUnequip(inst, owner)

	owner.AnimState:Hide("HAT")
	owner.AnimState:Hide("HAT_HAIR")
	owner.AnimState:Show("HAIR_NOHAT")
	owner.AnimState:Show("HAIR")
	
	--owner:RemoveTag("angel")
	
	if owner:HasTag("player") then
		owner.AnimState:Show("HEAD")
		owner.AnimState:Hide("HEAD_HAT")
	end
end

local function reload_halo(inst)
	local caster = inst.components.inventoryitem.owner
	if caster.components.health then
		if caster.components.health.currenthealth >= 21 then
			caster.components.health:DoDelta(-20)
			inst.components.perishable:ReducePercent(-0.25)
		end
	end
end
 
 local function fn(Sim) 
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeInventoryPhysics(inst)
	--MakeFeedableSmallLivestockPristine(inst)
 
    inst:AddTag("hat")
	inst:AddTag("thehalo")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.entity:SetPristine()
	
    inst.AnimState:SetBank("haloangel")
    inst.AnimState:SetBuild("haloangel")
    inst.AnimState:PlayAnimation("idle")
	
	MakeHauntableLaunch(inst)
 
    inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "haloangel"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/haloangel.xml"
	 
    inst:AddComponent("equippable")
	inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
	--inst.components.equippable.dapperness = TUNING.DAPPERNESS_HUGE
    inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )
	
	inst:AddTag("show_spoilage")
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.MAPLE_HALO*480)	-- 480 is the numer of seconds in one day(16*30s)
	inst.components.perishable:StartPerishing()
	
    --inst.components.perishable.onperishreplacement = "gold_nugget"
    inst.components.perishable:SetOnPerishFn(function(inst)
        inst:Remove()--generic_perish(inst)
    end)	
	
	-- inst:AddComponent("eater")
	-- inst.components.eater:SetAbsorptionModifiers(.0001, .0001, .0001)
    -- inst.components.eater:SetDiet({FOODTYPE.HALOANGEL_FOODTYPE})
	-- MakeFeedableSmallLivestock(inst, TUNING.TOTAL_DAY_TIME*TUNING.MAPLE_HALO)--, onpickup, ondrop)
	-- inst.components.eater:SetOnEatFn(oneat)
	
	inst.entity:AddLight()
	inst.Light:SetRadius(1.0)--18
	inst.Light:SetFalloff(0.50)--0.75
	inst.Light:SetIntensity(0.80)--0.5
	inst.Light:SetColour(255/255,255/255,20/255)
	inst.Light:Enable(true)
	
	--inst:AddComponent("insulator")
    --inst.components.insulator:SetWinter()
    --inst.components.insulator:SetInsulation(TUNING.INSULATION_HUGE)
	
	inst:AddComponent("spellcaster")
	inst.components.spellcaster.veryquickcast = true
    inst.components.spellcaster:SetSpellFn(reload_halo)
    inst.components.spellcaster.canusefrominventory = true
	
 
    return inst
end

return  Prefab("common/inventory/haloangel", fn, assets, prefabs)