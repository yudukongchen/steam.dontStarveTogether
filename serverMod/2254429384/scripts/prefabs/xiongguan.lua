local assets =
{
    Asset("ANIM", "anim/xiongguan.zip"),
    Asset("ANIM", "anim/xiongguan_sw.zip"),
	Asset("ATLAS", "images/inventoryimages/xiongguan.xml"),
    Asset("IMAGE", "images/inventoryimages/xiongguan.tex"),
}

local function onfinished(inst)
    inst:Remove()
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object","xiongguan_sw","xiongguan")
	owner.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
    end
	
	local function onattack(inst, owner, target)
	
	if inst.components.fueled.currentfuel < 180 then 
	inst.components.fueled.currentfuel = inst.components.fueled.currentfuel + 10
	local int = inst.components.fueled.currentfuel
	if int >= 180 then
	owner.components.talker:Say("武器六段充能完毕")
	elseif int >= 150 and int<160 then
	owner.components.talker:Say("武器五段充能完毕")
	elseif int >= 120 and int<130 then
	owner.components.talker:Say("武器四段充能完毕")
	elseif int >= 90 and int<100 then
	owner.components.talker:Say("武器三段充能完毕")
	elseif int >= 60 and int<70 then
	owner.components.talker:Say("武器二段充能完毕")
	elseif int >= 30 and int<40 then
	owner.components.talker:Say("武器一段充能完毕")
	end
	elseif inst.components.fueled.currentfuel >= 180 then
	inst.components.fueled.currentfuel = 180
	end
end

local function createlight(staff, target, pos)
local fuelpercent = staff.components.fueled:GetPercent()
    if fuelpercent > 0.166 then
    local SHAKE_DIST = 10
    local player = GetClosestInstWithTag("player", staff, SHAKE_DIST)
    if player then
	   local targets = staff.components.inventoryitem.owner
	   SpawnPrefab("groundpound_fx").Transform:SetPosition(targets.Transform:GetWorldPosition())
	   SpawnPrefab("groundpoundring_fx").Transform:SetPosition(staff.Transform:GetWorldPosition())
	 local pt = Vector3(staff.Transform:GetWorldPosition())
	  for k = 1, 25 do
	  local result_offset = FindValidPositionByFan(1 * 2 * PI, 4, 10, function(offset)
                       local x,y,z = (pt + offset):Get()
                       local ents = TheSim:FindEntities(x,y,z , 1)
                       return not next(ents) 
                   end)
                   if result_offset then
                       local plant = SpawnPrefab("groundpound_fx")
                       plant.Transform:SetPosition((pt + result_offset):Get())                     
                   end
				   end
				    for k = 1, 37 do
	  local result_offset = FindValidPositionByFan(1 * 2 * PI, 6, 20, function(offset)
                       local x,y,z = (pt + offset):Get()
                       local ents = TheSim:FindEntities(x,y,z , 1)
                       return not next(ents) 
                   end)
                   if result_offset then
                       local plant = SpawnPrefab("groundpound_fx")
                       plant.Transform:SetPosition((pt + result_offset):Get())                     
                   end
				   end
				     for k = 1, 50 do
	  local result_offset = FindValidPositionByFan(1 * 2 * PI, 8, 30, function(offset)
                       local x,y,z = (pt + offset):Get()
                       local ents = TheSim:FindEntities(x,y,z , 1)
                       return not next(ents) 
                   end)
                   if result_offset then
                       local plant = SpawnPrefab("groundpound_fx")
                       plant.Transform:SetPosition((pt + result_offset):Get())                     
                   end
				   end
    end
    staff:DoTaskInTime(0, function() 
        staff.components.combat:DoAreaAttack(staff, 10)
    end)
   
    staff.components.fueled.currentfuel = staff.components.fueled.currentfuel - 30
	 local range = 12
	 local owner = staff.components.inventoryitem.owner
    local pos = Vector3(owner.Transform:GetWorldPosition())
    local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, range)
    for k,v in pairs(ents) do
        if v:HasTag("tree") and v.components.workable and v.components.workable.workleft > 0 then
           v.components.workable:Destroy(owner)
        end
		 if v.components.workable  and v.components.workable.action == ACTIONS.CHOP   and v.components.workable.workleft > 0  then
           v.components.workable:Destroy(owner)
        end
		  if v.components.workable  and v.components.workable.action == ACTIONS.MINE   and v.components.workable.workleft > 0  then
           v.components.workable:Destroy(owner)
		   v.components.workable:Destroy(owner)
		   v.components.workable:Destroy(owner)
        end
		if   v.components.workable and v.components.workable.action ==ACTIONS.HAMMER and v.components.workable.workleft > 0 then
           v.components.workable:Destroy(owner)
        end
		if v.components.workable and v.components.workable.action ==ACTIONS.DIG and v.components.workable.workleft > 0 then
           v.components.workable:Destroy(owner)
        end		
    end
		   staff.components.finiteuses:Use(1)
		   else
		  	local caster = staff.components.inventoryitem.owner
			caster.components.talker:Say("武器没有能量了") 
		   end
end
	
local function fn()
     local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)
    inst.entity:SetPristine()
	inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("xiongguan.tex")
	
	inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(createlight)
    inst.components.spellcaster.canuseonpoint = true
    inst.components.spellcaster.canusefrominventory = false
	
    if not TheWorld.ismastersim then
        return inst
    end

     inst.AnimState:SetBank("xiongguan")
    inst.AnimState:SetBuild("xiongguan")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
	
    inst:AddComponent("weapon")
	inst.components.weapon:SetOnAttack(onattack)
    inst.components.weapon:SetDamage(68)
    inst.components.weapon:SetRange(1,2)
	
	inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(200)
    inst.components.combat.playerdamagepercent = 0

    inst:AddComponent("inspectable")
	
    inst:AddComponent("fueled")
    inst.components.fueled:InitializeFuelLevel(180)
	inst.components.fueled.fueltype = "NIGHTMARE"
	inst.components.fueled.accepting = true

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(1000)
    inst.components.finiteuses:SetUses(1000)   
    inst.components.finiteuses:SetOnFinished( onfinished )
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/xiongguan.xml"
	
	inst:AddComponent("insulator")
    inst.components.insulator:SetInsulation(TUNING.INSULATION_LARGE)
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED_LARGE	
    return inst
end

return Prefab("xiongguan", fn, assets, prefabs)


