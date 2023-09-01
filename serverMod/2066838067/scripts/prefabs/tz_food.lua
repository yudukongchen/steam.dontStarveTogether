
local function create_light(eater, lightprefab)
    if eater.tzfoodlight ~= nil then
        if eater.tzfoodlight.prefab == lightprefab then
            eater.tzfoodlight.components.spell.lifetime = 0
            eater.tzfoodlight.components.spell:ResumeSpell()
            return
        else
            eater.tzfoodlight.components.spell:OnFinish()
        end
    end
    local light = SpawnPrefab(lightprefab)
    light.components.spell:SetTarget(eater)
    if light:IsValid() then
        if light.components.spell.target == nil then
            light:Remove()
        else
            light.components.spell:StartSpell()
        end
    end
end

local function item_oneaten(inst, eater)
    create_light(eater, "tzfoodlight_light")
end

local lightprefabs =
{
    "tzfoodlight_light_fx",
}

local function oneaten(inst, eater)
			if eater.components.hunger and eater.components.health and eater.components.sanity then
				local num1 = eater.components.hunger.max
				local num2 = eater.components.hunger.current
				local num3 = inst.components.perishable:GetPercent()
				local num4 = eater.components.health.maxhealth
				local num5 = eater.components.health.currenthealth
				local num6 = eater.components.sanity.max
				local num7 = eater.components.sanity.current				
				local num8 = num1 - num2
				local num9 = num4 - num5
				local num10 = num6 - num7
				eater.components.hunger:DoDelta( (10+num8*0.4)*num3)
				eater.components.health:DoDelta( (10+num9*0.4)*num3)
				eater.components.sanity:DoDelta( (10+num10*0.4)*num3)
			end
end
local function light_resume(inst, time)
    inst.fx:setprogress(1 - time / inst.components.spell.duration)
end

local function light_start(inst)
    inst.fx:setprogress(0)
end

local function pushbloom(inst, target)
    if target.components.bloomer ~= nil then
        target.components.bloomer:PushBloom(inst, "shaders/anim.ksh", -1)
    else
        target.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    end
end

local function popbloom(inst, target)
    if target.components.bloomer ~= nil then
        target.components.bloomer:PopBloom(inst)
    else
        target.AnimState:ClearBloomEffectHandle()
    end
end

local function light_ontarget(inst, target)
    if target == nil or target:HasTag("playerghost") or target:HasTag("overcharge") then
        inst:Remove()
        return
    end

    local function forceremove()
        inst.components.spell:OnFinish()
    end

    target.tzfoodlight = inst

    inst.Follower:FollowSymbol(target.GUID, "", 0, 0, 0)
    inst:ListenForEvent("onremove", forceremove, target)
    inst:ListenForEvent("death", function() inst.fx:setdead() end, target)

    if target:HasTag("player") then
        inst:ListenForEvent("ms_becameghost", forceremove, target)
        if target:HasTag("electricdamageimmune") then
            inst:ListenForEvent("ms_overcharge", forceremove, target)
        end
        inst.persists = false
    else
        inst.persists = not target:HasTag("critter")
    end

    pushbloom(inst, target)

    if target.components.rideable ~= nil then
        local rider = target.components.rideable:GetRider()
        if rider ~= nil then
            pushbloom(inst, rider)
            inst.fx.entity:SetParent(rider.entity)
        else
            inst.fx.entity:SetParent(target.entity)
        end

        inst:ListenForEvent("riderchanged", function(target, data)
            if data.oldrider ~= nil then
                popbloom(inst, data.oldrider)
                inst.fx.entity:SetParent(target.entity)
            end
            if data.newrider ~= nil then
                pushbloom(inst, data.newrider)
                inst.fx.entity:SetParent(data.newrider.entity)
            end
        end, target)
    else
        inst.fx.entity:SetParent(target.entity)
    end
end

local function light_onfinish(inst)
    local target = inst.components.spell.target
    if target ~= nil then
        target.tzfoodlight = nil

        popbloom(inst, target)

        if target.components.rideable ~= nil then
            local rider = target.components.rideable:GetRider()
            if rider ~= nil then
                popbloom(inst, rider)
            end
        end
    end
end

local function light_onremove(inst)
    inst.fx:Remove()
end

local function MakeFood(name,data)
	local assets=
	{
		Asset("ANIM", "anim/"..name..".zip"),
		Asset( "IMAGE", "images/inventoryimages/"..name..".tex" ),
		Asset( "ATLAS", "images/inventoryimages/"..name..".xml" ),
	}
	
	local prefabs = 
	{
		"spoiled_food",
	}
	
	local function fn()
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()
		MakeInventoryPhysics(inst)
		
		inst.AnimState:SetBuild(name)
		inst.AnimState:SetBank(name)
		inst.AnimState:PlayAnimation("idle")
	    
	    inst:AddTag("preparedfood")
		inst:AddTag("catfood")
		inst:AddTag("frozen")
        MakeInventoryFloatable(inst, "med", 0.2, {1.1, 0.5, 1.1})
		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end
		inst:AddComponent("edible")
		inst.components.edible.healthvalue = data.health
		inst.components.edible.hungervalue = data.hunger
		inst.components.edible.foodtype =  "VEGGIE"
		inst.components.edible.sanityvalue = data.sanity
		inst.components.edible:SetOnEatenFn(data.eatfn or nil)
		inst:AddComponent("inspectable")

		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"
		
		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

		inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime(data.perishtime)--TUNING.PERISH_FASTISH) 
		inst.components.perishable:StartPerishing()
		if name == "tz_waferchocolate" then
		inst.components.perishable.onperishreplacement = "spoiled_food"   
		end
	    MakeHauntableLaunch(inst)    
		return inst
	end
return Prefab(name, fn, assets, prefabs)	
end

local function light_commonfn(duration, fxprefab)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddFollower()
    inst:Hide()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    --[[Non-networked entity]]

    inst:AddComponent("spell")
    inst.components.spell.spellname = "tzfoodlight"
    inst.components.spell.duration = duration
    inst.components.spell.ontargetfn = light_ontarget
    inst.components.spell.onstartfn = light_start
    inst.components.spell.onfinishfn = light_onfinish
    inst.components.spell.resumefn = light_resume
    inst.components.spell.removeonfinish = true

    inst.persists = false 
    inst.fx = SpawnPrefab(fxprefab)
    inst.OnRemoveEntity = light_onremove

    return inst
end

local function lightfn()
    return light_commonfn(720, "tzfoodlight_light_fx")
end
local function OnUpdateLight(inst, dframes)
    local frame =
        inst._lightdead:value() and
        math.ceil(inst._lightframe:value() * .9 + inst._lightmaxframe * .1) or
        (inst._lightframe:value() + dframes)

    if frame >= inst._lightmaxframe then
        inst._lightframe:set_local(inst._lightmaxframe)
        inst._lighttask:Cancel()
        inst._lighttask = nil
    else
        inst._lightframe:set_local(frame)
    end

    inst.Light:SetRadius(7)
end

local function OnLightDirty(inst)
    if inst._lighttask == nil then
        inst._lighttask = inst:DoPeriodicTask(FRAMES, OnUpdateLight, nil, 1)
    end
    OnUpdateLight(inst, 0)
end

local function setprogress(inst, percent)
    inst._lightframe:set(math.max(0, math.min(inst._lightmaxframe, math.floor(percent * inst._lightmaxframe + .5))))
    OnLightDirty(inst)
end

local function setdead(inst)
    inst._lightdead:set(true)
    inst._lightframe:set(inst._lightframe:value())
end

-----------------

local function lightfx_commonfn(duration)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
	
    inst.Light:SetRadius(0)
    inst.Light:SetIntensity(.9)
    inst.Light:SetFalloff(.7)
    inst.Light:SetColour(169/255, 231/255, 245/255)
    inst.Light:Enable(true)
    inst.Light:EnableClientModulation(true)

    inst._lightmaxframe = math.floor(duration / FRAMES + .5)
    inst._lightframe = net_smallbyte(inst.GUID, "tzfoodlight_light_fx._lightframe", "tzlightdirty")
    inst._lightframe:set(inst._lightmaxframe)
    inst._lightdead = net_bool(inst.GUID, "tzfoodlight_light_fx._lightdead")
    inst._lighttask = nil

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst:ListenForEvent("tzlightdirty", OnLightDirty)

        return inst
    end

    inst.setprogress = setprogress
    inst.setdead = setdead
    inst.persists = false

    return inst
end

local function lightfxfn()
    return lightfx_commonfn(240)
end
return
		Prefab("tzfoodlight_light", lightfn, nil, lightprefabs),
        Prefab("tzfoodlight_light_fx", lightfxfn),
		MakeFood("tz_waferchocolate",
		{hunger= 10, 
		sanity=10 , 
		health= 10,
		eatfn = oneaten,
		perishtime=TUNING.PERISH_FASTISH,
		}),
		MakeFood("tz_icecream",
		{hunger=30 , 
		sanity=30 , 
		health=10 ,
		eatfn = item_oneaten,
		perishtime=2*TUNING.PERISH_TWO_DAY,
		})