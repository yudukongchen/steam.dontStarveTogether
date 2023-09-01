local assets =
{
	Asset("ANIM", "anim/lotus.zip"),
	Asset("SOUND", "sound/common.fsb"),
	
	Asset( "IMAGE", "images/inventoryimages/change_lotus_flower.tex" ),
	Asset( "ATLAS", "images/inventoryimages/change_lotus_flower.xml" ),
	
	Asset( "IMAGE", "images/inventoryimages/change_lotus_flower_cooked.tex" ),
	Asset( "ATLAS", "images/inventoryimages/change_lotus_flower_cooked.xml" ),
}

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
    MakeInventoryPhysics(inst)    
    
    anim:SetBank("lotus")
    anim:SetBuild("lotus")
    anim:PlayAnimation("idle")
	
	inst:AddTag("cattoy")
    inst:AddTag("billfood")
	
	inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end  
    
    -----------------
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    ---------------------        
                
    inst:AddComponent("edible")
    inst.components.edible.healthvalue = TUNING.HEALING_TINY
    inst.components.edible.hungervalue = TUNING.CALORIES_SMALL
    inst.components.edible.sanityvalue = TUNING.SANITY_TINY or 0     
	inst.components.edible.foodtype = FOODTYPE.VEGGIE

    ---------------------        
        
    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    ---------------------        
        
    inst:AddComponent("cookable")
    inst.components.cookable.product = "change_lotus_flower_cooked"


    inst:AddComponent("bait")
    
    inst:AddComponent("inspectable")
    ----------------------
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "change_lotus_flower"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/change_lotus_flower.xml"
	
	
    inst:AddComponent("tradable")

    
    return inst
end

local function fncooked(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
    MakeInventoryPhysics(inst)

    
    
    anim:SetBank("lotus")
    anim:SetBuild("lotus")
    anim:PlayAnimation("cooked")
	
	inst:AddTag("cattoy")
    inst:AddTag("billfood")
	
	inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end  
    
    -----------------
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    ---------------------        
                
    inst:AddComponent("edible")
    inst.components.edible.healthvalue = TUNING.HEALING_TINY
    inst.components.edible.hungervalue = TUNING.CALORIES_SMALL
    inst.components.edible.sanityvalue = TUNING.SANITY_MED or 0      
    inst.components.edible.foodtype = FOODTYPE.VEGGIE

    ---------------------        
        
    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    ---------------------        
    
    inst:AddComponent("inspectable")
    ----------------------

    inst:AddComponent("bait")

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "change_lotus_flower_cooked"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/change_lotus_flower_cooked.xml"
	
    inst:AddComponent("tradable")
    
    
    return inst
end

return Prefab( "common/inventory/change_lotus_flower", fn, assets), 
       Prefab( "common/inventory/change_lotus_flower_cooked", fncooked, assets) 
