 local assets=
{
	Asset("ANIM", "anim/skyshow.zip"),
	Asset("ANIM", "anim/swap_skyshow.zip"),
	Asset("ATLAS", "images/skyshow.xml"),
	Asset("IMAGE", "images/skyshow.tex"),
	Asset("ANIM", "anim/ui_backpack_2x4.zip"),
}

local SHIELD_DURATION = 10 * FRAMES
local SHIELD_VARIATIONS = 3
local MAIN_SHIELD_CD = 1.2
local prefabs = {}
local RESISTANCES =
{
    "_combat",
    "explosive",
    "quakedebris",
    "caveindebris",
    "trapdamage",
}

local function sword_do_trail(inst)
    local owner = inst.components.inventoryitem:GetGrandOwner() or inst
    if not owner.entity:IsVisible() then
        return
    end

    local x, y, z = owner.Transform:GetWorldPosition()
    if owner.sg ~= nil and owner.sg:HasStateTag("moving") then
        local theta = -owner.Transform:GetRotation() * DEGREES
        local speed = owner.components.locomotor:GetRunSpeed() * .1
        x = x + speed * math.cos(theta)
        z = z + speed * math.sin(theta)
    end
    local mounted = owner.components.rider ~= nil and owner.components.rider:IsRiding()
    local map = TheWorld.Map
    local offset = FindValidPositionByFan(
        math.random() * 2 * PI,
        (mounted and 1 or .5) + math.random() * .5,
        4,
        function(offset)
            local pt = Vector3(x + offset.x, 0, z + offset.z)
            return map:IsPassableAtPoint(pt:Get())
                and not map:IsPointNearHole(pt)
                and #TheSim:FindEntities(pt.x, 0, pt.z, .7, { "shadowtrail" }) <= 0
        end
    )

    if offset ~= nil then
        SpawnPrefab("cane_ancient_fx").Transform:SetPosition(x + offset.x, 0, z + offset.z)
    end
end

local function keep_temp(player, inst)
   if not TEMPERATURE then
      return
   end

   if player.components.temperature.current < 5 or player.components.temperature.current > 65 then
      player.components.temperature:SetTemperature(35)
      if USE > 0 then inst.components.finiteuses:Use(10) end
   end
   if inst.components.equippable:IsEquipped() then
      player:DoTaskInTime(1, keep_temp, inst)
   end
end

local function sword_equipped(inst)
    if inst._trailtask == nil then
        inst._trailtask = inst:DoPeriodicTask(6 * FRAMES, sword_do_trail, 2 * FRAMES)
    end
end

local function sword_unequipped(inst)
    if inst._trailtask ~= nil then
        inst._trailtask:Cancel()
        inst._trailtask = nil
    end
end

local function lighton(inst, owner)
    if inst._light == nil or not inst._light:IsValid() then
        inst._light = SpawnPrefab("skyshow_light")
    end
    if owner ~= nil then
        inst._light.entity:SetParent(owner.entity)
    end
	
end


local function lightoff(inst)
    if inst._light ~= nil then
            if inst._light:IsValid() then
                inst._light:Remove()
            end
            inst._light = nil
        end
end  

local function saniup(inst)
	if inst.isWeared and not inst.isDropped then
		-- inst:AddComponent("dapperness")
		inst.components.equippable.dapperness = HUISAN
	end
end




for j = 0, 3, 3 do
    for i = 1, SHIELD_VARIATIONS do
        table.insert(prefabs, "shadow_shield"..tostring(j + i))
    end
end

local function PickShield(inst)
	if HUJIA ~= 1 then
		return 
	end
    local t = GetTime()
    local flipoffset = math.random() < .5 and SHIELD_VARIATIONS or 0

    --variation 3 is the main shield
    local dt = t - inst.lastmainshield
    if dt >= MAIN_SHIELD_CD then
        inst.lastmainshield = t
        return flipoffset + 3
    end

    local rnd = math.random()
    if rnd < dt / MAIN_SHIELD_CD then
        inst.lastmainshield = t
        return flipoffset + 3
    end

    return flipoffset + (rnd < dt / (MAIN_SHIELD_CD * 2) + .5 and 2 or 1)
end

local function OnShieldOver(inst, OnResistDamage)
	if HUJIA ~= 1 then
		return 
	end
    inst.task = nil
    for i, v in ipairs(RESISTANCES) do
        inst.components.resistance:RemoveResistance(v)
    end
    inst.components.resistance:SetOnResistDamageFn(OnResistDamage)
end

local function OnResistDamage(inst)--, damage)
	if HUJIA ~= 1 then
		return 
	end
    local owner = inst.components.inventoryitem:GetGrandOwner() or inst
    local fx = SpawnPrefab("shadow_shield"..tostring(PickShield(inst)))
    fx.entity:SetParent(owner.entity)

    if inst.task ~= nil then
        inst.task:Cancel()
    end
    inst.task = inst:DoTaskInTime(SHIELD_DURATION, OnShieldOver, OnResistDamage)
    inst.components.resistance:SetOnResistDamageFn(nil)

	if USE > 0 then inst.components.finiteuses:Use(10) end
    --inst.components.fueled:DoDelta(-TUNING.MED_FUEL)
    if inst.components.cooldown.onchargedfn ~= nil then
        inst.components.cooldown:StartCharging()
    end
end

local function ShouldResistFn(inst)
	if HUJIA ~= 1 then
		return 
	end
    if not inst.components.equippable:IsEquipped() then
        return false
    end
    local owner = inst.components.inventoryitem.owner
    return owner ~= nil
        and not (owner.components.inventory ~= nil and
                owner.components.inventory:EquipHasTag("forcefield"))
end

local function OnChargedFn(inst)
	if HUJIA ~= 1 then
		return 
	end
    if inst.task ~= nil then
        inst.task:Cancel()
        inst.task = nil
        inst.components.resistance:SetOnResistDamageFn(OnResistDamage)
    end
    for i, v in ipairs(RESISTANCES) do
        inst.components.resistance:AddResistance(v)
    end
end









local function OnEquip(inst, owner)
  owner.AnimState:OverrideSymbol("swap_object", "swap_skyshow", "symbol0")
  owner.AnimState:Show("ARM_carry")
  owner.AnimState:Hide("ARM_normal")
  inst.isWeared = true
  inst.isDropped = false
  saniup(inst)
  lighton(inst, owner)
  
   if TEMPERATURE then
      owner:DoTaskInTime(1, keep_temp, inst)
   end

  
	--if BAG=="true" then
	   --inst.components.container:Open(owner)
	--end
	if "true"=="true" then
	   	if ZHANGZHANG =="cane_ancient_fx" then
			sword_equipped(inst)
		else
			if inst._vfx_fx_inst == nil then
				inst._vfx_fx_inst = SpawnPrefab("cane_victorian_fx")
				inst._vfx_fx_inst.entity:AddFollower()
			end
			inst._vfx_fx_inst.entity:SetParent(owner.entity)
			inst._vfx_fx_inst.Follower:FollowSymbol(owner.GUID, "swap_object", 0, inst.vfx_fx_offset or 0, 0)
		end
	end
	
	if HUJIA == 1 then
		inst.lastmainshield = 0
		inst.components.cooldown.onchargedfn = OnChargedFn
		inst.components.cooldown:StartCharging(math.max(TUNING.ARMOR_SKELETON_FIRST_COOLDOWN, inst.components.cooldown:GetTimeToCharged()))
	end
end
  
local function OnUnequip(inst, owner)
  owner.AnimState:Hide("ARM_carry")
  owner.AnimState:Show("ARM_normal")
  inst.isWeared = false
  inst.isDropped = false
  saniup(inst)
  lightoff(inst, owner)
  	--if BAG=="true" then
	   --inst.components.container:Close(owner)
	--end
	if "true"=="true" then
		if ZHANGZHANG == "cane_ancient_fx" then
	   	   sword_unequipped(inst)
		else
			if inst._vfx_fx_inst ~= nil then
				inst._vfx_fx_inst:Remove()
				inst._vfx_fx_inst = nil
			end
		end
	end
	
	
	if HUJIA == 1 then
		inst.components.cooldown.onchargedfn = nil
		if inst.task ~= nil then
			inst.task:Cancel()
			inst.task = nil
			inst.components.resistance:SetOnResistDamageFn(OnResistDamage)
		end
		for i, v in ipairs(RESISTANCES) do
			inst.components.resistance:RemoveResistance(v)
		end
	end
end
local function skyshow_lightfn()
    local inst = CreateEntity()	

    inst.entity:AddTransform()	
    inst.entity:AddLight()		
    inst.entity:AddNetwork()	

    inst:AddTag("FX")	

	inst.Light:SetIntensity(0.8)	
	inst.Light:SetRadius(TIDENG)		
	inst.Light:Enable(true)		
	inst.Light:SetFalloff(1)	
	inst.Light:SetColour(200/255, 200/255, 200/255)	

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
  inst.entity:AddLight()	
  inst.entity:AddNetwork()
  inst.entity:AddMiniMapEntity()
  inst.entity:AddSoundEmitter()  
  MakeInventoryPhysics(inst)
  inst.Light:SetIntensity(0.8)	
  inst.Light:SetRadius(TIDENG)		
  inst.Light:Enable(true)		
  inst.Light:SetFalloff(1)	
  inst.Light:SetColour(200/255, 200/255, 200/255)		
  inst.AnimState:SetBank("skyshow")
  inst.AnimState:SetBuild("skyshow")
  inst.AnimState:PlayAnimation("idle")
  inst.MiniMapEntity:SetIcon("skyshow.tex")
  inst:AddTag("sharp")
  inst.entity:SetPristine()
  if not TheWorld.ismastersim then
		--if BAG == "true" then
			--if inst.replica and inst.replica.container then
				--inst.replica.container:WidgetSetup("backpack")
			--end
		--end
		return inst
  end
  if FUHUO == 1 then 
	MakeHauntableLaunch(inst)
	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_INSTANT_REZ)
  end
  
  if DIAOYU == 1 then
	inst:AddComponent("fishingrod")
	inst.components.fishingrod:SetWaitTimes(4, 40)
	inst.components.fishingrod:SetStrainTimes(0, 6)	
  end
  
  inst:AddComponent("inspectable")
  inst:AddComponent("inventoryitem")
  
    if HUJIA == 1 then 
		inst:AddComponent("resistance")
		inst.components.resistance:SetShouldResistFn(ShouldResistFn)
		inst.components.resistance:SetOnResistDamageFn(OnResistDamage)
		
		inst:AddComponent("cooldown")
		inst.components.cooldown.cooldown_duration = TUNING.ARMOR_SKELETON_COOLDOWN
	end

  inst.components.inventoryitem.imagename = "skyshow"
  inst.components.inventoryitem.atlasname = "images/skyshow.xml"
  inst:AddComponent("equippable")
  inst.components.equippable:SetOnEquip( OnEquip )
  inst.components.equippable:SetOnUnequip( OnUnequip )
  --if BAG=="true" then
	  --inst:AddComponent("container")
      --inst.components.container:WidgetSetup("backpack")
  --end
  
  
  return inst
end

return  Prefab("common/inventory/skyshow", fn, assets),
		Prefab("skyshow_light", skyshow_lightfn)