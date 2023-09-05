local assets =
{
    Asset("ANIM", "anim/riyanhuo_sw.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("riyanhuo")
    inst.AnimState:SetBuild("riyanhuo_sw")
    inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetFinalOffset(-1)

    inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
    inst.AnimState:SetLayer( LAYER_BACKGROUND )
    inst.AnimState:SetSortOrder( 3 )

    inst.persists = false
    inst:AddTag("fx")
    inst:ListenForEvent("animover", function() inst:Remove() end)
	if not TheWorld.ismastersim then
        return inst
    end
	
    return inst
end

return Prefab("riyanhuo", fn, assets)


