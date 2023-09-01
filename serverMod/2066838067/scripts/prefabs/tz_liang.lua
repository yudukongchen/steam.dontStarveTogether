local assets =
{
    Asset("ANIM", "anim/tz_liang.zip"),
	Asset("ANIM", "anim/swap_tz_liang.zip"),
    Asset("SOUND", "sound/wilson.fsb"),
    Asset( "IMAGE", "images/inventoryimages/tz_liang.tex" ),
    Asset( "ATLAS", "images/inventoryimages/tz_liang.xml" ),
}

local prefabs =
{
	"tz_lianglight",
	"thurible_smoke",
}

local LIGHT_RADIUS = 3.5 
local LIGHT_COLOUR = Vector3(214 / 255, 16 / 255, 38 / 255) 
local LIGHT_INTENSITY = 0.85 
local LIGHT_FALLOFF = .33  

local function DoTurnOffSound(inst, owner)
    inst._soundtask = nil
    (owner ~= nil and owner:IsValid() and owner.SoundEmitter or inst.SoundEmitter):PlaySound("dontstarve/wilson/lantern_off")
end

local function PlayTurnOffSound(inst) 
    if inst._soundtask == nil and inst:GetTimeAlive() > 0 then
        inst._soundtask = inst:DoTaskInTime(0, DoTurnOffSound, inst.components.inventoryitem.owner)
    end
end

local function PlayTurnOnSound(inst)
    if inst._soundtask ~= nil then
        inst._soundtask:Cancel()
        inst._soundtask = nil
    elseif not POPULATING then
        inst._light.SoundEmitter:PlaySound("dontstarve/wilson/lantern_on")
    end
end

local function OnUpdateFlicker(inst, starttime) 
    local time = starttime ~= nil and (GetTime() - starttime) * 15 or 0
    local flicker = (math.sin(time) + math.sin(time + 2) + math.sin(time + 0.7777)) * .5 -- range = [-1 , 1]
    flicker = (1 + flicker) * .5 -- range = 0:1
    inst.Light:SetRadius(LIGHT_RADIUS + .1 * flicker)
    flicker = flicker * 2 / 255
    inst.Light:SetColour(LIGHT_COLOUR.x + flicker, LIGHT_COLOUR.y + flicker, LIGHT_COLOUR.z + flicker)
end

local function onremovelight(light)
    light._lantern._light = nil
end

local function stoptrackingowner(inst)
    if inst._owner ~= nil then
        inst:RemoveEventCallback("equip", inst._onownerequip, inst._owner)
        inst._owner = nil
    end
end

local function starttrackingowner(inst, owner)
    if owner ~= inst._owner then
        stoptrackingowner(inst)
        if owner ~= nil and owner.components.inventory ~= nil then
            inst._owner = owner
            inst:ListenForEvent("equip", inst._onownerequip, owner)
        end
    end
end

local function turnon(inst)  
    if not inst.components.fueled:IsEmpty() then
        inst.components.fueled:StartConsuming()

        local owner = inst.components.inventoryitem.owner

        if inst._light == nil then 
            inst._light = SpawnPrefab("tz_lianglight")
			inst._light._lantern = inst
            inst:ListenForEvent("onremove", onremovelight, inst._light)

            PlayTurnOnSound(inst)
        end
        inst._light.entity:SetParent((owner or inst).entity)
	
        inst.AnimState:PlayAnimation("idle_on")
		if owner ~= nil and inst.components.equippable:IsEquipped() then
            owner.AnimState:Show("LANTERN_OVERLAY")
		if  inst.components.heater  then
			inst.components.heater.equippedheat = 25
		end	 
        end
        inst.components.machine.ison = true
        inst:AddTag("cooker")

		if not inst:HasTag("cooker") then
        inst:AddTag("cooker")
		end
		if not inst:HasTag("HASHEATER") then
        inst:AddTag("HASHEATER")
		end
	    if not inst.components.cooker ~= nil then
		inst:AddComponent("cooker")
		end
		if inst.components.heater ~= nil then
		inst.components.heater.heat = 85
		end	
    end
end

local function turnoff(inst)
    stoptrackingowner(inst)
    inst.components.fueled:StopConsuming()
    if inst._light ~= nil then
        inst._light:Remove()
        PlayTurnOffSound(inst)
    end
    inst.AnimState:PlayAnimation("idle_off")
    if inst.components.equippable:IsEquipped() then  
        inst.components.inventoryitem.owner.AnimState:Hide("LANTERN_OVERLAY")
		if  inst.components.heater  then
			inst.components.heater.equippedheat = 0
		end
    end
    inst.components.machine.ison = false
    if  inst:HasTag("cooker") then
    inst:RemoveTag("cooker")
    end
	if inst:HasTag("HASHEATER") then
    inst:RemoveTag("HASHEATER")
    end
	if inst.components.cooker ~= nil then
	inst:RemoveComponent("cooker")
	end
	if inst.components.heater  then
		inst.components.heater.heat = 0
	end
end

local function OnRemove(inst)
    if inst._light ~= nil then
        inst._light:Remove()
    end
    if inst._soundtask ~= nil then
        inst._soundtask:Cancel()
    end
end

local function ondropped(inst)
    turnoff(inst)
    turnon(inst)
end

local function onequip(inst, owner)
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    owner.AnimState:OverrideSymbol("swap_object", "swap_tz_liang", "swap_tz_liang")
    owner.AnimState:OverrideSymbol("lantern_overlay", "swap_tz_liang", "tz_liang_overlay") 
	if inst.components.fueled:IsEmpty() then
        owner.AnimState:Hide("LANTERN_OVERLAY")
    else
        owner.AnimState:Show("LANTERN_OVERLAY")
        turnon(inst)
    end
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    owner.AnimState:ClearOverrideSymbol("lantern_overlay")
    owner.AnimState:Hide("LANTERN_OVERLAY")
    if inst.components.machine.ison then
        starttrackingowner(inst, owner)
    end
end

local function nofuel(inst)
    if inst.components.equippable:IsEquipped() and inst.components.inventoryitem.owner ~= nil then
        local data =
        {
            prefab = inst.prefab,
            equipslot = inst.components.equippable.equipslot,
        }
        turnoff(inst)
        inst.components.inventoryitem.owner:PushEvent("torchranout", data)
    else
        turnoff(inst)
    end
end

local function ontakefuel(inst)
    if inst.components.equippable:IsEquipped() then
        turnon(inst)
    end
end

--------------------------------------------------------------------------

local function OnLightWake(inst)
    if not inst.SoundEmitter:PlayingSound("loop") then
        inst.SoundEmitter:PlaySound("dontstarve/wilson/lantern_LP", "loop")
    end
end

local function OnLightSleep(inst)
    inst.SoundEmitter:KillSound("loop")
end

--------------------------------------------------------------------------

local function tz_lianglightfn()
    local inst = CreateEntity()
	inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.Light:SetIntensity(LIGHT_INTENSITY)
    inst.Light:SetFalloff(LIGHT_FALLOFF)
    inst.Light:EnableClientModulation(true)

    inst:DoPeriodicTask(.1, OnUpdateFlicker, nil, GetTime())
    OnUpdateFlicker(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("tz_liang")
    inst.AnimState:SetBuild("tz_liang")
    inst.AnimState:PlayAnimation("idle_off")
	inst.Transform:SetScale(1.1, 1.1, 1.1)
    inst:AddTag("light")
    inst:AddTag("tonglingwu")
    MakeInventoryFloatable(inst, "med", 0.2, {1.1, 0.5, 1.1})	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    
    inst.components.inventoryitem:SetOnDroppedFn(ondropped)
    inst.components.inventoryitem:SetOnPutInInventoryFn(turnoff)
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_liang.xml"
    inst:AddComponent("equippable")
    
	inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(10)
    
	inst:AddComponent("fueled")
	
    inst:AddComponent("heater")
    inst.components.heater:SetThermics(true, false)
	inst.components.heater.heat = 85
    inst.components.heater.equippedheat = 25
	
    inst:AddComponent("machine")
    inst.components.machine.turnonfn = turnon
    inst.components.machine.turnofffn = turnoff
    inst.components.machine.cooldowntime = 0

    inst.components.fueled:InitializeFuelLevel(960)
    inst.components.fueled:SetDepletedFn(nofuel)
    inst.components.fueled:SetTakeFuelFn(ontakefuel)
    inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)
	inst.components.fueled.accepting = true

    inst._light = nil

    MakeHauntableLaunch(inst)

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst.OnRemoveEntity = OnRemove

    inst._onownerequip = function(owner, data)
        if data.item ~= inst and
            (   data.eslot == EQUIPSLOTS.HANDS or
                (data.eslot == EQUIPSLOTS.BODY and data.item:HasTag("heavy"))
            ) then
            turnoff(inst)
        end
    end
    return inst
end

return Prefab("tz_liang", fn, assets, prefabs),
    Prefab("tz_lianglight", tz_lianglightfn)  				   