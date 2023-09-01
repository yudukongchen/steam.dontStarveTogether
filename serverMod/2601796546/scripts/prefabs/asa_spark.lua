local assets =
{
    Asset("ANIM", "anim/asa_spark.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	inst.entity:AddLight()
	inst.entity:SetPristine()
    
	inst:AddComponent('lighttweener')
    --inst.components.lighttweener:StartTween(light, 1, .9, 0.9, { 0.1,0.5,0.9}, 0, function(inst)inst.Light:Enable(false)end)
	
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst:AddTag("asa_spark")
	--inst.Transform:SetEightFaced()
	inst.AnimState:SetBank("asa_spark")
    inst.AnimState:SetBuild("asa_spark")
	inst.AnimState:PlayAnimation("idle")
	--local ran1 = math.random(5,40)
	inst.AnimState:SetScale(3,2,3)
	-- local ran2 = math.random(-180,180)
	-- inst.Transform:SetRotation(ran2)
	inst.AnimState:SetSortOrder(1)
	inst.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/asa_parry",nil,0.4)
	--inst.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/equip")
	
    inst.Light:SetIntensity(.8)
    inst.Light:SetColour(150 / 255, 250 / 255, 255 / 255)
	--inst.components.lighttweener:StartTween(nil, 0, nil, nil, nil, 0.2, function(inst)inst.Light:Enable(false)end)
    inst.Light:SetFalloff(.3)
    inst.Light:SetRadius(1)
    inst.Light:Enable(true)
	inst.persists = false
	inst:ListenForEvent("animover", inst.Remove)
	
    return inst
end

return Prefab("asa_spark", fn, assets)
