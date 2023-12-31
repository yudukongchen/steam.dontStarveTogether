local assets =
{
   Asset("ANIM", "anim/campfire_fire.zip"),
	Asset("SOUND", "sound/common.fsb"),
}

local function OnLoad(inst, data)
	       inst:Remove()
end

local function fn()

	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("campfire_fire")
    inst.AnimState:SetBuild("campfire_fire")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetMultColour(0, 0, 0, .6)
	inst.AnimState:SetRayTestOnBB(true)
    inst:AddTag("fx")
	
	  if not TheWorld.ismastersim then
        return inst
    end


    inst:AddComponent("firefx")
    inst.components.firefx.levels =
    {
    {anim="level1", sound="dontstarve/common/nightlight", radius=2, intensity=.8, falloff=.33, colour = {253/255,179/255,179/255}, soundintensity=.1},
    {anim="level2", sound="dontstarve/common/nightlight", radius=3, intensity=.8, falloff=.33, colour = {253/255,179/255,179/255}, soundintensity=.3},
    {anim="level3", sound="dontstarve/common/nightlight", radius=4, intensity=.8, falloff=.33, colour = {253/255,179/255,179/255}, soundintensity=.6},
    {anim="level4", sound="dontstarve/common/nightlight", radius=5, intensity=.8, falloff=.33, colour = {253/255,179/255,179/255}, soundintensity=1},
    }
    
    inst.AnimState:SetFinalOffset(-1)
    inst.components.firefx:SetLevel(2)
    inst.components.firefx.usedayparamforsound = true
	
    inst.OnLoad = OnLoad
    return inst
end

return Prefab( "heifire", fn, assets) 


