local assets =
{
	Asset("ANIM", "anim/lotus.zip"),
	Asset("SOUND", "sound/common.fsb"),
    --Asset("MINIMAP_IMAGE", "lotus"),    
}

local prefabs =
{
  "bill"
}    

local function onpickedfn(inst)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
    inst.AnimState:PlayAnimation("picking")
    inst.AnimState:PushAnimation("picked")
end

local function onregenfn(inst)
    inst.AnimState:PlayAnimation("grow")
    inst.AnimState:PushAnimation("idle_plant", true)
end

local function makeemptyfn(inst)
	inst.AnimState:PlayAnimation("picked",true)
end


local function OnChange(inst)
	local day = TheWorld.state.phase
	local anim = inst.AnimState	
	if day == "dusk" then 
		inst:DoTaskInTime(math.random()*10, function(inst) 
            if inst.components.pickable and inst.components.pickable.canbepicked then
                anim:PlayAnimation("close")
                anim:PushAnimation("idle_plant_close", true)
                inst.closed = true
            end
        end)
	elseif day == "day" then 
		inst:DoTaskInTime(math.random()*10, function(inst) 
            if inst.components.pickable and inst.components.pickable.canbepicked and inst.closed then
                inst.closed = nil
                anim:PlayAnimation("open")
                anim:PushAnimation("idle_plant", true)
            end
        end)
	end
end 


local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
	local minimap = inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .25)

    anim:SetBank("lotus")
    anim:SetBuild("lotus")
    anim:PlayAnimation("idle_plant",true)
    anim:SetTime(math.random()*2)
	
    local color = 0.75 + math.random() * 0.25
    anim:SetMultColour(color, color, color, 1)

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "lotus.png" )  
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end  

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable:SetUp("change_lotus_flower",480)
	inst.components.pickable.onregenfn = onregenfn
	inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makeemptyfn = makeemptyfn
    inst.components.pickable.product = "change_lotus_flower"

    --inst.components.pickable.SetRegenTime = 120

    inst:AddComponent("inspectable")

    ---------------------        
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

	MakeNoGrowInWinter(inst)    
    ---------------------   

    inst.OnLoad = function(inst)
        if TheWorld.state.isday and inst.components.pickable and inst.components.pickable.canbepicked then
            anim:PlayAnimation("idle_plant", true)
        elseif inst.components.pickable and inst.components.pickable.canbepicked  then
            anim:PlayAnimation("idle_plant_close",true)
        end
    end
	
	inst:WatchWorldState("phase",OnChange)

    return inst
end

return Prefab( "change_lotus", fn, assets, prefabs)
