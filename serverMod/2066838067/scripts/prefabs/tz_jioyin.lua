local assets =
{
    Asset("ANIM", "anim/jiaoyin.zip"),
}


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
    inst:AddTag("FX")
    inst.entity:SetCanSleep(false)

    inst.AnimState:SetBank("jiaoyin")
    inst.AnimState:SetBuild("jiaoyin")
    inst.AnimState:SetFinalOffset(-1)
	
    inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
    inst.AnimState:SetLayer( LAYER_BACKGROUND )
    inst.AnimState:SetSortOrder( 3 )
	
	inst.Transform:SetScale(1.2, 1.2, 1.2) --大小
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.persists = false

	inst:DoTaskInTime(2, ErodeAway)

    return inst
end

return Prefab("tz_jioyin", fn, assets, prefabs)

