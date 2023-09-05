local assets =
{
    Asset("ANIM", "anim/yanqiu.zip"),
    Asset("ANIM", "anim/yanqiu_sw.zip"),
	Asset("ATLAS", "images/inventoryimages/yanqiu.xml"),
    Asset("IMAGE", "images/inventoryimages/yanqiu.tex"),
}

--[[local function cancreatelight(staff, caster, target, pos)
    local fuelpercent = staff.components.fueled:GetPercent()
    if fuelpercent > 0.166 then
       return true
    else
       return false
    end
end]]
local function createlight(staff, target, pos)
    --local owner = GetWorld().Map:GetTileAtPoint(pos.x, pos.y, pos.z)
	 local fuelpercent = staff.components.fueled:GetPercent()
    if fuelpercent > 0.166 then
    local SHAKE_DIST = 12
    local player = GetClosestInstWithTag("player", staff, SHAKE_DIST)
    if player then
	   SpawnPrefab("groundpound_fx").Transform:SetPosition(pos:Get())
	  local insts = SpawnPrefab( "groundpoundring_fx" )
	  insts.Transform:SetPosition(pos:Get())
	  --insts.AnimState:SetMultColour(0/255,105/255,246/255,1)
    end
    --GetClock():DoLightningLighting()
    staff.components.fueled.currentfuel = staff.components.fueled.currentfuel - 30
	 local pos = Vector3(pos:Get())
    local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 12)
    for k,v in pairs(ents) do
        if not v:HasTag("player") and v.components.health and not v:HasTag("wall") and not v:HasTag("chester") and not v:HasTag("abigail") and not v:HasTag("glommer") and not v:HasTag("hutch") and not v:HasTag("boat")then
		v.components.health:DoDelta(-100)
		SpawnPrefab("icesword").Transform:SetPosition(v.Transform:GetWorldPosition())
		if v.components.freezable then
           v.components.freezable:AddColdness(24)
           v.components.freezable:SpawnShatterFX()
		   end
        end
    end
	staff.components.finiteuses:Use(1)
	 else
	 local caster = staff.components.inventoryitem.owner
		   caster.components.talker:Say("武器没有能量了")
	 end
end

local function onfinished(inst)
    inst:Remove()
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object","yanqiu_sw","yanqiu")
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
	if target.components.freezable then
        target.components.freezable:AddColdness(1)
        target.components.freezable:SpawnShatterFX()
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
    inst.MiniMapEntity:SetIcon("yanqiu.tex")
    if not TheWorld.ismastersim then
        return inst
    end

    inst.AnimState:SetBank("yanqiu")
    inst.AnimState:SetBuild("yanqiu")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
	
    inst:AddComponent("weapon")
	inst.components.weapon:SetOnAttack(onattack)
    inst.components.weapon:SetDamage(68)
    inst.components.weapon:SetRange(1,2)

    inst:AddComponent("inspectable")
	
	inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(100)
    inst.components.combat.playerdamagepercent = 0
	
	inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(createlight)
    inst.components.spellcaster.canuseonpoint = true
    inst.components.spellcaster.canuseonpoint_water = true

    inst:AddComponent("fueled")
    inst.components.fueled:InitializeFuelLevel(180)
	inst.components.fueled.fueltype = "NIGHTMARE"
	inst.components.fueled.accepting = true
	
	inst:AddComponent("heater")
    inst.components.heater:SetThermics(false, true)
    inst.components.heater.equippedheat = -20

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(1000)
    inst.components.finiteuses:SetUses(1000)   
    inst.components.finiteuses:SetOnFinished( onfinished )
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/yanqiu.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip ) 
    return inst
end

return Prefab("yanqiu", fn, assets, prefabs)


