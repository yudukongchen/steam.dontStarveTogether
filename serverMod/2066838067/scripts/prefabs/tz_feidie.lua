
local assets=
{
	--Asset("ANIM", "anim/tz_feidie.zip"),
	Asset("ANIM", "anim/taizhen_cosplay.zip"),
	Asset("IMAGE", "images/inventoryimages/tz_feidie.tex"),
	Asset("ATLAS", "images/inventoryimages/tz_feidie.xml"),
}
local lightassets=
{
	Asset("ANIM", "anim/tz_xiaoren.zip"),
}

local diassets=
{
	Asset("ANIM", "anim/tz_feidielight_di.zip"),
}
local function onremovelight(light)
    light._tzfeidie._light = nil
end
local function onequiphat(inst, owner)
        if inst._light == nil then
            inst._light = SpawnPrefab("tz_feidielight")
            inst._light._tzfeidie = inst
            inst:ListenForEvent("onremove", onremovelight, inst._light)
        end
        inst._light.entity:SetParent(owner.entity)
		inst._light.Follower:FollowSymbol(owner.GUID, "swap_hat", 0, -75, 0.5)
end

local function onunequiphat(inst, owner)
    if inst._light ~= nil then
        inst._light:Remove()
    end
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
    inst.entity:AddNetwork()
	anim:SetBank("taizhen_cosplay")
    anim:SetBuild("taizhen_cosplay")
    anim:PlayAnimation("taizhen_feidie")
    
	inst:AddTag("hat")
	inst:AddTag("tz_feidie")
    MakeInventoryFloatable(inst, "med", 0.2, {1.1, 0.5, 1.1})	
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("tradable")
    inst:AddComponent("inspectable")
		
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_feidie.xml"
	inst:AddComponent("equippable")
	inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
	inst.components.equippable:SetOnEquip( onequiphat )
	inst.components.equippable:SetOnUnequip( onunequiphat )
    return inst
end 
local function zhiliao(inst)
	inst.AnimState:PlayAnimation("attack")
	inst.AnimState:PushAnimation("idle",true)
end
local function lightfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()
	inst.entity:AddFollower()

    inst.AnimState:SetBank("tz_xiaoren")
    inst.AnimState:SetBuild("tz_xiaoren")
    inst.AnimState:PlayAnimation("idle",true)
	inst.SoundEmitter:PlaySound("dontstarve/common/staff_coldlight_LP", "staff_star_loop")
    inst:AddTag("FX")
    inst.Light:SetFalloff(4.5)
    inst.Light:SetIntensity(.8)
    inst.Light:SetRadius(8)
    inst.Light:SetColour(180 / 255, 195 / 255, 150 / 255)
        --inst.AnimState:SetLayer(LAYER_BACKGROUND)
    --inst.AnimState:SetSortOrder(3)  --这里先不要了
		
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst.persists = false
	inst:DoPeriodicTask(15, zhiliao, 15)
    return inst
end
local function lightdifn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("tz_feidielight_di")
    inst.AnimState:SetBuild("tz_feidielight_di")
    inst.AnimState:PlayAnimation("chentu")
    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst.persists = false
	inst:ListenForEvent("animover", inst.Remove)
    return inst
end
    
return Prefab( "common/inventory/tz_feidie", fn, assets),
		Prefab( "tz_feidielight", lightfn, lightassets) ,
		Prefab( "tz_feidielight_di", lightdifn, diassets)