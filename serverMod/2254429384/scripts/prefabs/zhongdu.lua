local assets =
{
    Asset("ANIM", "anim/zhongdu.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("zhongdu")
    inst.AnimState:SetBuild("zhongdu")
    inst.AnimState:PlayAnimation("idle",true)
    inst:AddTag("fx")
    --inst:ListenForEvent("animover", function() inst:Remove() end)
	if not TheWorld.ismastersim then
        return inst
    end
	
    return inst
end

return Prefab("zhongdu", fn, assets)


