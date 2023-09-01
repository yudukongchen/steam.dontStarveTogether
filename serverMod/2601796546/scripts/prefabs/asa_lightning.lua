local assets =
{
    Asset("ANIM", "anim/asa_lightning.zip"),
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
	inst:AddTag("asa_lightning")
	inst.Transform:SetEightFaced()
	inst.AnimState:SetBank("asa_lightning")
    inst.AnimState:SetBuild("asa_lightning")
	inst.AnimState:PlayAnimation("idle")
	local s = 2
	inst.AnimState:SetScale(s,s,s)
	-- local ran2 = math.random(-180,180)
	-- inst.Transform:SetRotation(ran2)
	--inst.AnimState:SetSortOrder(1)
	inst.SoundEmitter:PlaySound("dontstarve/characters/wx78/spark")
	
    inst.Light:SetIntensity(.3)
    inst.Light:SetColour(150 / 255, 250 / 255, 255 / 255)
    inst.Light:SetFalloff(.8)
    inst.Light:SetRadius(1)
    inst.Light:Enable(true)
	--inst.components.lighttweener:StartTween(nil, 0, nil, nil, nil, 0.2, function(inst)inst.Light:Enable(false)end)
	inst.persists = false
	inst:ListenForEvent("animover", inst.Remove)
	
    return inst
end

return Prefab("asa_lightning", fn, assets)
