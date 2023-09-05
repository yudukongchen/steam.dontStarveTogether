local assets =
{
   Asset("ANIM", "anim/longying.zip"),
    Asset("ANIM", "anim/longying_sw.zip"),
	Asset("ANIM", "anim/longying_sw_on.zip"),
	Asset("ATLAS", "images/inventoryimages/longying.xml"),
    Asset("IMAGE", "images/inventoryimages/longying.tex"),
	Asset("ATLAS", "images/inventoryimages/longhuo.xml"),
    Asset("IMAGE", "images/inventoryimages/longhuo.tex"),
}


local function onfinished(inst)
    inst:Remove()
end

local function turnon(inst)
    if not inst.components.fueled:IsEmpty() then
        if not inst.components.machine.ison then
            if inst.components.fueled then
                inst.components.fueled:StartConsuming()        
            end
            inst.Light:Enable(true)
            inst.AnimState:PlayAnimation("longying_on")
			inst:AddTag("huo")

            if inst.components.equippable:IsEquipped() then
                inst.components.inventoryitem.owner.AnimState:OverrideSymbol("swap_object", "longying_sw_on", "longying")
				inst.components.weapon:SetDamage(136)
            end
            inst.components.machine.ison = true
			inst.components.inventoryitem.atlasname = "images/inventoryimages/longhuo.xml"
	        inst.components.inventoryitem:ChangeImageName("longhuo")
        end
    end
	if not inst.fire and inst.components.fueled.currentfuel >0  then 
	            inst.fire = SpawnPrefab( "longfire" )
	            local follower = inst.fire.entity:AddFollower()
	            follower:FollowSymbol( inst.GUID, "swap_object", 0, -250, 0 )
	        end 
end

local function turnoff(inst)
    if inst.components.fueled then
        inst.components.fueled:StopConsuming()        
    end
    inst.Light:Enable(false)
    inst.AnimState:PlayAnimation("longying_off")
	inst:RemoveTag("huo")
    if inst.components.equippable:IsEquipped() then
        inst.components.inventoryitem.owner.AnimState:OverrideSymbol("swap_object", "longying_sw", "longying")
		inst.components.weapon:SetDamage(68)
    end
    inst.components.machine.ison = false
	inst.components.inventoryitem.atlasname = "images/inventoryimages/longying.xml"
    inst.components.inventoryitem:ChangeImageName("longying")
	
	    if inst.fire then 
	        inst.fire:Remove()
	        inst.fire = nil
	    end 
end

local function OnBlocked(owner, data)
local inst = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
if inst:HasTag("huo") then 
    local pos = Vector3(inst.Transform:GetWorldPosition())
    local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 8)
    for k,v in pairs(ents) do
        if v.components.health  and  not v:HasTag("wall")  then
         local dmg = inst.components.combat.defaultdamage + 17.5
		  inst.components.combat:SetDefaultDamage(dmg)
        end
		end
    inst.components.combat:DoAreaAttack(inst, 8)
	SpawnPrefab("firering_fx").Transform:SetPosition(owner:GetPosition():Get())
	SpawnPrefab("vomitfire_fx").Transform:SetPosition(owner:GetPosition():Get())
	--SpawnPrefab("attackfire_fx").Transform:SetPosition(owner:GetPosition():Get())
	SpawnPrefab("firesplash_fx").Transform:SetPosition(owner:GetPosition():Get())
	SpawnPrefab("tauntfire_fx").Transform:SetPosition(owner:GetPosition():Get())
	inst.components.fueled.currentfuel = inst.components.fueled.currentfuel - 15
	local x, y, z = owner:GetPosition():Get()
	local genhao = 3.5355
	local zhengshu = 5
	inst:DoTaskInTime(0.2, function() 
	SpawnPrefab("firesplash_fx").Transform:SetPosition(x+zhengshu,y,z) 
	SpawnPrefab("firesplash_fx").Transform:SetPosition(x+genhao,y,z+genhao) 
	SpawnPrefab("firesplash_fx").Transform:SetPosition(x,y,z+zhengshu)
    SpawnPrefab("firesplash_fx").Transform:SetPosition(x-genhao,y,z+genhao)
    SpawnPrefab("firesplash_fx").Transform:SetPosition(x-zhengshu,y,z)
    SpawnPrefab("firesplash_fx").Transform:SetPosition(x-genhao,y,z-genhao) 
    SpawnPrefab("firesplash_fx").Transform:SetPosition(x,y,z-zhengshu) 
    SpawnPrefab("firesplash_fx").Transform:SetPosition(x+genhao,y,z-genhao)
    end)   	
	  inst:DoTaskInTime(0.5, function() 
       inst.components.combat:DoAreaAttack(inst, 8)
	   SpawnPrefab("firesplash_fx").Transform:SetPosition(owner:GetPosition():Get())
	   local x, y, z = owner:GetPosition():Get()
	inst:DoTaskInTime(0.2, function() 
	SpawnPrefab("firesplash_fx").Transform:SetPosition(x+zhengshu,y,z) 
	SpawnPrefab("firesplash_fx").Transform:SetPosition(x+genhao,y,z+genhao) 
	SpawnPrefab("firesplash_fx").Transform:SetPosition(x,y,z+zhengshu)
    SpawnPrefab("firesplash_fx").Transform:SetPosition(x-genhao,y,z+genhao)
    SpawnPrefab("firesplash_fx").Transform:SetPosition(x-zhengshu,y,z)
    SpawnPrefab("firesplash_fx").Transform:SetPosition(x-genhao,y,z-genhao) 
    SpawnPrefab("firesplash_fx").Transform:SetPosition(x,y,z-zhengshu) 
    SpawnPrefab("firesplash_fx").Transform:SetPosition(x+genhao,y,z-genhao)
    end)   	
	SpawnPrefab("firering_fx").Transform:SetPosition(owner:GetPosition():Get())
	--SpawnPrefab("attackfire_fx").Transform:SetPosition(owner:GetPosition():Get())
    end)
	 inst:DoTaskInTime(1, function() 
       inst.components.combat:DoAreaAttack(inst, 8)
	    SpawnPrefab("firesplash_fx").Transform:SetPosition(owner:GetPosition():Get())
	   local x, y, z = owner:GetPosition():Get()
	inst:DoTaskInTime(0.2, function() 
	SpawnPrefab("firesplash_fx").Transform:SetPosition(x+zhengshu,y,z) 
	SpawnPrefab("firesplash_fx").Transform:SetPosition(x+genhao,y,z+genhao) 
	SpawnPrefab("firesplash_fx").Transform:SetPosition(x,y,z+zhengshu)
    SpawnPrefab("firesplash_fx").Transform:SetPosition(x-genhao,y,z+genhao)
    SpawnPrefab("firesplash_fx").Transform:SetPosition(x-zhengshu,y,z)
    SpawnPrefab("firesplash_fx").Transform:SetPosition(x-genhao,y,z-genhao) 
    SpawnPrefab("firesplash_fx").Transform:SetPosition(x,y,z-zhengshu) 
    SpawnPrefab("firesplash_fx").Transform:SetPosition(x+genhao,y,z-genhao) 
    end)  	
	inst.components.combat:SetDefaultDamage(0)
	SpawnPrefab("firering_fx").Transform:SetPosition(owner:GetPosition():Get())
    end)
	if inst.components.fueled.currentfuel < 0 then
	inst.components.fueled.currentfuel = 0
	 turnoff(inst)
	end
	else
	inst.components.fueled.currentfuel = inst.components.fueled.currentfuel + 20
	if inst.components.fueled.currentfuel >= 540 then 
	 turnon(inst)
	end
	end
end

local function onequip(inst, owner) 
    owner.components.health.fire_damage_scale =  owner.components.health.fire_damage_scale-1
    owner.AnimState:OverrideSymbol("swap_object","longying_sw","longying")
	owner.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
	if inst.components.fueled:IsEmpty() then
        owner.AnimState:OverrideSymbol("swap_object", "longying_sw", "longying")
		inst.Light:Enable(false)
    else
        owner.AnimState:OverrideSymbol("swap_object", "longying_sw_on", "longying")
		inst.Light:Enable(true)
    end
	turnon(inst)
	 inst:ListenForEvent("attacked", OnBlocked, owner)
end



local function onunequip(inst, owner) 
    owner.components.health.fire_damage_scale =  owner.components.health.fire_damage_scale+1
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
	inst.Light:Enable(false)
	owner.AnimState:ClearOverrideSymbol("longying")
	turnoff(inst)
	inst.components.weapon:SetDamage(68)
	inst:RemoveEventCallback("attacked", OnBlocked, owner)
    end
	
	local function OnLoad(inst, data)
    if inst:HasTag("huo") then
        inst.AnimState:PlayAnimation("longying_on")
		inst.Light:Enable(true)
		inst.components.weapon:SetDamage(136)
        turnon(inst)
    else
	    inst.Light:Enable(false)
        inst.AnimState:PlayAnimation("longying_off")
		inst.components.weapon:SetDamage(68)
        turnoff(inst)
    end
end
	
	local function onattack(inst, owner, target)
	if inst.components.fueled.currentfuel < 540 then 
	if inst:HasTag("huo") then
	inst.components.fueled.currentfuel = inst.components.fueled.currentfuel - 5
	else
	inst.components.fueled.currentfuel = inst.components.fueled.currentfuel + 10
	end
	local int = inst.components.fueled.currentfuel
	if int >= 540 then
	owner.components.talker:Say("武器六段充能")
	elseif int >= 480 and int<490 then
	owner.components.talker:Say("武器五段充能")
	elseif int >= 360 and int<370 then
	owner.components.talker:Say("武器四段充能")
	elseif int >= 270 and int<280 then
	owner.components.talker:Say("武器三段充能")
	elseif int >= 180 and int<190 then
	owner.components.talker:Say("武器二段充能")
	elseif int >= 90 and int<100 then
	owner.components.talker:Say("武器一段充能")
	elseif int <=0 then
	turnoff(inst)
	end
	elseif inst.components.fueled.currentfuel >= 540 then
	 turnon(inst)
	inst.components.fueled.currentfuel = 540
	end
end

local function nofuel(inst)
    turnoff(inst)
end

local function takefuel(inst)
    if inst.components.equippable and inst.components.equippable:IsEquipped() then
        turnon(inst)
    end
end

local function ondropped(inst)
    turnoff(inst)
    turnon(inst)
end

local function onputininventory(inst)
    turnoff(inst)
end
	
local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)
    inst.entity:SetPristine()
	inst.entity:AddLight()
	inst.Light:Enable(false)
    inst.Light:SetRadius(2)
    inst.Light:SetFalloff(0.5)
    inst.Light:SetIntensity(0.75)
    inst.Light:SetColour(235/255, 121/255, 12/255)
	inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("longying.tex")
    if not TheWorld.ismastersim then
        return inst
    end

     inst.AnimState:SetBank("longying")
    inst.AnimState:SetBuild("longying")
    inst.AnimState:PlayAnimation("longying_off")

    inst:AddTag("sharp")
	
    inst:AddComponent("weapon")
	inst.components.weapon:SetOnAttack(onattack)
    inst.components.weapon:SetDamage(68)
    inst.components.weapon:SetRange(1,2)

    inst:AddComponent("inspectable")
	
    inst:AddComponent("fueled")
    inst.components.fueled:InitializeFuelLevel(540)
	inst.components.fueled.fueltype = "NIGHTMARE"
	inst.components.fueled.accepting = true
	inst.components.fueled:SetDepletedFn(nofuel)
    inst.components.fueled.ontakefuelfn = takefuel
	
	inst:AddComponent("machine")
    inst.components.machine.turnonfn = turnon
    inst.components.machine.turnofffn = turnoff
    inst.components.machine.cooldowntime = 0
	
	inst:AddComponent("waterproofer") 
    inst.components.waterproofer:SetEffectiveness(0.2)
	
    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(0)
    inst.components.combat.playerdamagepercent = 0

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(1000)
    inst.components.finiteuses:SetUses(1000)   
    inst.components.finiteuses:SetOnFinished( onfinished )
	
	inst:AddComponent("heater")
    inst.components.heater:SetThermics(false, true)
    inst.components.heater.equippedheat = 90
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/longying.xml"
	inst.components.inventoryitem:SetOnDroppedFn(ondropped)
	inst.components.inventoryitem:SetOnPutInInventoryFn(onputininventory)  
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip ) 
	
	inst.OnLoad = OnLoad
	
    return inst
end

return Prefab("longying", fn, assets, prefabs)


