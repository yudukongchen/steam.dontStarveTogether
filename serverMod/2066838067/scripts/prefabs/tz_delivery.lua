local assets =
{
    Asset("ANIM", "anim/tz_delivery.zip"),
	Asset( "IMAGE", "images/inventoryimages/tz_delivery.tex" ),
    Asset( "ATLAS", "images/inventoryimages/tz_delivery.xml" ),
}
local function OnDrop (inst)
    local owner = inst.components.inventoryitem.owner or inst.lastowner
    if owner and owner.components.maprevealable then
       owner.components.maprevealable:RemoveRevealSource(inst)
    end
end
local function OnPickup (inst,owner)
    inst.lastowner = owner
    if owner and owner.components.maprevealable then
        owner.components.maprevealable:AddRevealSource(inst, "player")
    end
end

STRINGS.NAMES.TZ_DELIVERY = "蜗牛的微型漩涡"
STRINGS.CHARACTERS.GENERIC.TZ_DELIVERY = [[蜗牛的微型漩涡]]
STRINGS.RECIPE_DESC.TZ_DELIVERY = [[蜗牛的微型漩涡]]
    
local function fn(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("tz_delivery.tex")
    MakeInventoryPhysics(inst)
    inst.AnimState:SetBank("tz_delivery")
    inst.AnimState:SetBuild("tz_delivery")
    inst.AnimState:PlayAnimation("idle")
	inst.Transform:SetScale(1.2, 1.2, 1.2)
    inst:AddTag("rechargeable")
    MakeInventoryFloatable(inst, "med", 0.2, {1.1, 0.5, 1.1})
    inst.entity:SetPristine()
    inst:AddComponent("talker")
    
    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddTag("taizhen_teleport_inventoryitem")
    inst:AddComponent("inspectable")
    inst:AddComponent("taizhen_teleport")
	inst.components.taizhen_teleport.dist_cost = 60
    inst.lastowner = nil
    MakeHauntableLaunch(inst)
    
    inst:AddComponent("tz_rechargeable")
    inst.components.rechargeable = inst.components.tz_rechargeable
	inst.components.rechargeable:SetRechargeTime(60)
	inst:RegisterComponentActions("rechargeable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_delivery.xml"
    inst.components.inventoryitem:SetOnDroppedFn(OnDrop)
	inst.components.inventoryitem:SetOnPickupFn(OnPickup)
    return inst
end
return Prefab("tz_delivery", fn, assets)
