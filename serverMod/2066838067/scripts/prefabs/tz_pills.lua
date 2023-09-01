local assets =
{
    Asset("ANIM", "anim/tz_pills.zip"),
	Asset("ATLAS", "images/inventoryimages/tz_pills.xml"),
	Asset("IMAGE", "images/inventoryimages/tz_pills.tex"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBuild("tz_pills")
    inst.AnimState:SetBank("tz_pills")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)
    inst.entity:SetPristine()
    
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_pills.xml"
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    inst:AddComponent("tradable")    
	inst:AddComponent("edible")
	inst.components.edible.foodtype = FOODTYPE.GOODIES
	inst.components.edible.hungervalue = 0
	inst.components.edible.sanityvalue = 0
	inst.components.edible.healthvalue = 0

	inst.components.edible.oneaten = function(inst,eater)
		if eater.components.tz_bighealth ~= nil and not (eater.components.health ~= nil and eater.components.health:IsDead()) and
			not eater:HasTag("playerghost") then
			eater.components.tz_bighealth:AddBuff()
		end
	end
	
	return inst
end

return Prefab("tz_pills", fn, assets)
