local assets = {
	Asset("ANIM", "anim/change_light.zip"),
}

local SCALE = 0.65 

local function TurnOn(inst)
	inst.on = true
	inst.Light:Enable(true)
	inst.components.fueled:StartConsuming()
	inst.AnimState:PlayAnimation("idle_on")
end 

local function TurnOff(inst)
	inst.on = false 
	inst.Light:Enable(false)
	inst.components.fueled:StopConsuming()
	 inst.AnimState:PlayAnimation("idle_off")
end 

local function CanInteract(inst)
    return not inst.components.fueled:IsEmpty()
end

local function OnChange(inst)
	local day = TheWorld.state.phase	
	if day == "night"  and not inst.components.fueled:IsEmpty()  then 
		inst.components.machine:TurnOn()
	else
		inst.components.machine:TurnOff()
	end 
end 

local function OnFuelEmpty(inst)
    --TurnOff(inst)
	inst.components.machine:TurnOff()
end

local function OnAddFuel(inst)
	inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/machine_fuel")
    if inst.on == false and TheWorld.state.phase == "night" then
        --TurnOn(inst)
		inst.components.machine:TurnOn()
    end
end

local function fuelupdate(inst)
	if inst.components.fueled:IsEmpty()  then 
		OnFuelEmpty(inst)
	end
end 

local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_big")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function onhit(inst, worker)

end

local function keepTwoDecimalPlaces(decimal)-----------------------四舍五入保留两位小数的代码
    decimal = math.floor((decimal * 100)+0.5)*0.01       
    return  decimal 
end

local function descriptionfn(inst,viewer)
	return "燃料："..tostring(keepTwoDecimalPlaces(inst.components.fueled:GetPercent()*100)).."%"
end 

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
	
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
	inst.entity:AddLight()
    inst.entity:AddNetwork()
	
	inst.Light:SetIntensity(.9)
    inst.Light:SetColour(255 / 255, 175 / 255, 0 / 255)
    inst.Light:SetFalloff(.6)
    inst.Light:SetRadius(6)
    inst.Light:Enable(false)

    -- MakeObstaclePhysics(inst, 1)

    --inst.MiniMapEntity:SetIcon("portal_dst.png")
	MakeObstaclePhysics(inst, .05)
	
	inst.AnimState:SetBank("change_light")
    inst.AnimState:SetBuild("change_light")
    inst.AnimState:PlayAnimation("idle_on")
	
	inst.Transform:SetScale(SCALE,SCALE,SCALE)
	
	inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.on = false 
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.descriptionfn = descriptionfn
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:AddComponent("machine")
    inst.components.machine.turnonfn = TurnOn
    inst.components.machine.turnofffn = TurnOff
    inst.components.machine.caninteractfn = CanInteract
    inst.components.machine.cooldowntime = 0.5
	
	inst:AddComponent("fueled")
    inst.components.fueled:SetDepletedFn(OnFuelEmpty)
	inst.components.fueled:SetUpdateFn(fuelupdate)
    inst.components.fueled:SetTakeFuelFn(OnAddFuel)
    inst.components.fueled.accepting = true
    inst.components.fueled:SetSections(10)
	inst.components.fueled:InitializeFuelLevel(TUNING.CAMPFIRE_FUEL_MAX)
	
	inst:DoTaskInTime(0,OnChange)
	inst:WatchWorldState("phase",OnChange)
	
	return inst
end 

return Prefab("change_light", fn, assets),
	MakePlacer("change_light_placer", "change_light", "change_light", "idle_on",nil,nil,nil,SCALE) 