
local function MakeCosplay(name)
local assets =
{
    Asset("ANIM", "anim/taizhen_cosplay.zip"),
    Asset("ANIM", "anim/elongpro.zip"),
	Asset("IMAGE", "images/inventoryimages/"..name..".tex"),
	Asset("ATLAS", "images/inventoryimages/"..name..".xml"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
   
    inst.AnimState:SetBank("taizhen_cosplay")
    inst.AnimState:SetBuild("taizhen_cosplay")
    inst.AnimState:PlayAnimation(name)

    inst:AddTag("tzcoplay")
	inst:AddTag(name)
    if inst:HasTag("taizhen_cosplayyellowpro") then
        inst.AnimState:SetBank("elongpro")
        inst.AnimState:SetBuild("elongpro")
        inst.AnimState:PlayAnimation("elongpro")
    end
    MakeInventoryFloatable(inst, "med", 0.2, {1.1, 0.5, 1.1})
    inst.entity:SetPristine()
    
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"
	inst:AddComponent("tzcoplay")

    MakeHauntableLaunchAndSmash(inst)

    return inst
end

return Prefab(name, fn, assets)

end

return MakeCosplay("taizhen_cosplayblue"),
		MakeCosplay("taizhen_cosplayyellow"),
        --change 2019-05-16
        MakeCosplay("taizhen_cosplayyellowpro"),
        --change
		MakeCosplay("taizhen_cosplayblack"),
		--2020 3.20
		MakeCosplay("taizhen_cosplaypink"),
		
		MakeCosplay("taizhen_cosplaypurple")		