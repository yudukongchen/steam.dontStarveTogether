local assets =
{
    Asset("ANIM", "anim/diting_bloom_fx.zip"),
	Asset("ANIM", "anim/Firediting_bloom_fx.zip"),
}

local function MyOnAnimOver(inst)
    if inst.AnimState:IsCurrentAnimation("ungrow_"..tostring(inst.variation)) then
        inst:Remove()
    else
        local x, y, z = inst.Transform:GetWorldPosition() --是当前物体的坐标？
        for i, v in ipairs(AllPlayers) do
		    if v.Change == true then
		    inst.AnimState:SetBuild("Firediting_bloom_fx") 
			inst.Light:SetRadius(0.5) --半径
            inst.Light:SetIntensity(0.5)  --光强
            inst.Light:SetFalloff(0.5)   --
			inst.Light:SetColour(55/255, 98/255, 184/255)
			end
            if v.myfullbloom and
                not (v.components.health:IsDead() or v:HasTag("playerghost")) and
                v.entity:IsVisible() and
                v:GetDistanceSqToPoint(x, y, z) < 4 then 
                inst.AnimState:PlayAnimation("idle_"..tostring(inst.variation))
                return
            end
        end
        inst.AnimState:PlayAnimation("ungrow_"..inst.variation)
    end
end

local function SetVariation(inst, variation)
           --采取最笨的方法，每次开花都要if一遍。QAQ
        for i, v in ipairs(AllPlayers) do
		    if v.Change == true then
		    inst.AnimState:SetBuild("Firediting_bloom_fx") 
			inst.AnimState:SetBuild("Firediting_bloom_fx") 
			inst.Light:SetRadius(0.5) --半径
            inst.Light:SetIntensity(0.5)  --光强
             inst.Light:SetFalloff(0.5)   --
			inst.Light:SetColour(55/255, 98/255, 184/255)
			   end
			end
    if inst.variation ~= variation then
        inst.variation = variation
        inst.AnimState:PlayAnimation("grow_"..tostring(variation))
    end
end
--[[local function ChangFire(inst,Change)
    if Change then 
	inst.AnimState:SetBuild("Firediting_bloom_fx")
	else 
	 inst.AnimState:SetBuild("diting_bloom_fx")
	 end
end]]


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    inst:AddTag("diting_bloom_fx")
	 
    inst.AnimState:SetBuild("diting_bloom_fx")
    inst.AnimState:SetBank("wormwood_plant_fx")
    inst.AnimState:PlayAnimation("grow_1")
	--发光的彼岸花，酷！
	inst.entity:AddLight()
	inst.Light:SetRadius(0.2) --半径
    inst.Light:SetIntensity(0.2)  --光强
    inst.Light:SetFalloff(0.5)   --衰减
    inst.Light:SetColour(255/255, 127/255, 120/255) --色表
    inst.Light:Enable(true)  --可以发光

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.variation = 1
    inst.SetVariation = SetVariation
    inst:ListenForEvent("animover", MyOnAnimOver)
    inst.persists = false

    return inst
end

return Prefab("diting_bloom_fx", fn, assets)
