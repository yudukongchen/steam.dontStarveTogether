local assets =
{
    Asset("ANIM", "anim/diting_bloom_fx.zip"),
}

local function MyOnAnimOver(inst)
    if inst.AnimState:IsCurrentAnimation("ungrow_"..tostring(inst.variation)) then
        inst:Remove()
    else
        if inst.tasktime <3 then
        inst.AnimState:PlayAnimation("idle_"..tostring(inst.variation)) 
        inst.tasktime = inst.tasktime+1
        else
         inst.AnimState:PlayAnimation("ungrow_"..inst.variation) 
        end
    end
end

local function SetVariation(inst, variation)
    if inst.variation ~= variation then
       inst.variation = variation
       inst.AnimState:PlayAnimation("grow_"..tostring(inst.variation))
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    --inst:AddTag("FX")
    inst:AddTag("diting_bloom_track")

    inst.entity:AddSoundEmitter()
	 
    inst.AnimState:SetBuild("diting_bloom_fx")
    inst.AnimState:SetBank("wormwood_plant_fx")
    inst.AnimState:PlayAnimation("grow_1")
    inst:AddComponent("listening") 

    --发光的彼岸花，酷！
	inst.entity:AddLight()
	inst.Light:SetRadius(0.2) --半径
    inst.Light:SetIntensity(.2)  --光强
    inst.Light:SetFalloff(.5)   --衰减
    inst.Light:SetColour(255/255, 127/255, 120/255) --色表
    inst.Light:Enable(true)  --可以发光

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    
    inst:AddComponent("inspectable")  --加这个才会被点击

    inst.variation = 1
    inst.SetVariation = SetVariation
    inst.tasktime = 0
    inst:ListenForEvent("animover", MyOnAnimOver)
    inst.persists = false
    
    return inst
end

return Prefab("diting_bloom_track", fn, assets)
