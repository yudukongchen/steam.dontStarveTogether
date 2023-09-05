local assets =
{
    Asset("ANIM", "anim/icesword.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("icesword")
    inst.AnimState:SetBuild("icesword")
    inst.AnimState:PlayAnimation("idle")
    inst:AddTag("fx")
    inst:ListenForEvent("animover", function() inst:Remove() end)
	if not TheWorld.ismastersim then
        return inst
    end
	
    return inst
end

return Prefab("icesword", fn, assets)


