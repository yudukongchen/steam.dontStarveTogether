local assets =
{
 
}

local function OnSave(inst, data)
	       inst:Remove()
		   end
local function OnLoad(inst, data)
	       inst:Remove()
end

local function fn()
	local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()
	local light = inst.entity:AddLight()
	inst.Light:Enable(true)
    inst.Light:SetRadius(2)
    inst.Light:SetFalloff(0.5)
    inst.Light:SetIntensity(.75)
    inst.Light:SetColour(235/255,121/255,12/255)

    inst:AddTag("fx")

   
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("heater")
    inst.components.heater.heat = 70
	
    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    return inst
end

return Prefab( "longfire", fn, assets) 


