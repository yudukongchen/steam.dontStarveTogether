local assets =
{
    Asset("ANIM", "anim/tz_cannedtnt.zip"),
	Asset("ATLAS", "images/inventoryimages/tz_cannedtnt.xml"),
	Asset("IMAGE", "images/inventoryimages/tz_cannedtnt.tex"),
}
local function OnIgniteFn(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_fuse_LP", "hiss")
    DefaultBurnFn(inst)
end

local function OnExtinguishFn(inst)
    inst.SoundEmitter:KillSound("hiss")
    DefaultExtinguishFn(inst)
end

local function OnExplodeFn(inst)
    inst.SoundEmitter:KillSound("hiss")
    SpawnPrefab("explode_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function OnPutInInv(inst, owner)
    if owner.prefab == "mole" then
        inst.components.explosive:OnBurnt()
    end
end


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBuild("tz_cannedtnt")
    inst.AnimState:SetBank("tz_cannedtnt")
    inst.AnimState:PlayAnimation("idle")
    inst:AddTag("explosive")
    inst:AddTag("molebait")
    inst:AddTag("tztnt")
    MakeInventoryFloatable(inst, "med", 0.2, {1.1, 0.5, 1.1})
    inst.entity:SetPristine()
    
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_cannedtnt.xml"
    inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInv)
	
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
	
    MakeSmallBurnable(inst, 3 + math.random() * 3)
    MakeSmallPropagator(inst)
    inst.components.burnable:SetOnBurntFn(nil)
    inst.components.burnable:SetOnIgniteFn(OnIgniteFn)
    inst.components.burnable:SetOnExtinguishFn(OnExtinguishFn)

    inst:AddComponent("explosive")
    inst.components.explosive:SetOnExplodeFn(OnExplodeFn)
    inst.components.explosive.explosivedamage = TUNING.GUNPOWDER_DAMAGE
    MakeHauntableLaunchAndIgnite(inst)
	
    inst:AddComponent("bait")
    return inst
end

return Prefab("tz_cannedtnt", fn, assets)
