local assets =
{

    --Asset("ANIM", "anim/mz.zip"),
	Asset("ANIM", "anim/boom.zip")
}
local function shadow_fn()
    local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	inst.entity:SetPristine()

	inst.AnimState:SetBank("boom")
	inst.AnimState:SetBuild("boom")
	inst.AnimState:PlayAnimation("shadow")
    inst.AnimState:OverrideMultColour(1, 48/255, 48/255, 1)
	
	if not TheWorld.ismastersim then
	    return inst
	end
	
    inst.persists = false
    inst:AddTag("FX")
 
	return inst
end
local function mark_fn()
    local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
	    return inst
	end
	
    inst.persists = false
    inst:AddTag("FX")
 
	return inst
end
return Prefab("shadow_boom",shadow_fn,assets),
 Prefab("mark",mark_fn)
