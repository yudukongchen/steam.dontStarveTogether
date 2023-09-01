local assets =
{
    Asset("ANIM", "anim/tz_sword.zip"),
    Asset("ANIM", "anim/swap_tz_firesworda.zip"),
    Asset("ANIM", "anim/swap_tz_fireswordb.zip"),
    Asset("ANIM", "anim/swap_tz_fireswordc.zip"),
	Asset("ANIM", "anim/swap_tz_fireswordd.zip"),
	Asset("ATLAS", "images/inventoryimages/tz_firesword.xml"),
	Asset("IMAGE", "images/inventoryimages/tz_firesword.tex"),
}
local prefabs=
{
	"tz_firesword_fx",
	"tauntfire_fx",
}

local function  imagechage(inst)  
 local owner = inst.components.inventoryitem.owner
 if owner~=nil and owner.components.burnable ~= nil and inst.components.equippable:IsEquipped() then
	if inst.components.tz_firelvl.current <10 then 
    owner.AnimState:OverrideSymbol("swap_object","swap_tz_firesworda", "swap_tz_firesworda")
    elseif inst.components.tz_firelvl.current >=10 and inst.components.tz_firelvl.current <20  then 
	owner.AnimState:OverrideSymbol("swap_object", "swap_tz_fireswordb", "swap_tz_fireswordb")
	elseif inst.components.tz_firelvl.current >=20 then 
		if owner.components.burnable:IsBurning() and inst.components.tz_firelvl.current ==30 then
		owner.AnimState:OverrideSymbol("swap_object", "swap_tz_fireswordd", "swap_tz_fireswordd")
		else
		owner.AnimState:OverrideSymbol("swap_object", "swap_tz_fireswordc", "swap_tz_fireswordc")
		end
	end
 end
end
local function onremovelight(light)
    light._firesword._light = nil
end
local function lighton(inst)
    if  inst.components.equippable:IsEquipped() and  inst.components.inventoryitem.owner ~= nil then
        if inst._light == nil then
            inst._light = SpawnPrefab("tz_firesword_light")
            inst._light._firesword = inst
            inst:ListenForEvent("onremove", onremovelight, inst._light)
        end
        inst._light.entity:SetParent((inst._body or inst.components.inventoryitem.owner or inst).entity)
	end

end
local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_tz_firesworda", "swap_tz_firesworda")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
	lighton(inst)
	imagechage(inst)
end



local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    if inst._light ~= nil then
        inst._light:Remove()
    end
end
local function deltalvl(inst)
	if inst.components.tz_firelvl.current < 1 then
		return
	end
	inst.components.tz_firelvl:DoDelta(-1)
end
local function SpawnfireFx2(inst, attacker, target)
                local pos = Vector3(target.Transform:GetWorldPosition())  
				for t = 1,3 do
					for i = 1, t*3, 1 do      
						local a = (i - 1)*360/(t*3) + 360/(t*3) 
						local x, y, z =  (2+(t-1)*1.5)*math.cos(2*math.pi/360*a) + pos.x, pos.y, pos.z + (2+(t-1)*1.5)*math.sin(2*math.pi/360*a) 				  
							inst:DoTaskInTime(0, function(inst) 
							local firefx1 = SpawnPrefab("tz_firesword_fx2")
							firefx1.Transform:SetPosition(x, y, z)
							end)              
					end
				end
					local x, y, z = target.Transform:GetWorldPosition()
					local ents = TheSim:FindEntities(x, y, z, 5, nil, { "INLIMBO" })
				for i, v in ipairs(ents) do
					if v ~= attacker  and not v:HasTag("player") then
						if v.components.burnable ~= nil and v.components.health ~= nil and  not v.components.health:IsDead() then
							v.components.health:DoFireDamage(15, attacker, inst)
							if not v.components.health:IsDead() then
							v.components.burnable:Ignite()
							end
						end 
					end	
				end
end

local function getspawnlocation(inst, target)
    local x1, y1, z1 = inst.Transform:GetWorldPosition()
    local x2, y2, z2 = target.Transform:GetWorldPosition()
    return x1 + .15 * (x2 - x1), 0, z1 + .15 * (z2 - z1)
end
local function spawntornado(inst, target)
    local tornado = SpawnPrefab("tz_firetornado")
	if tornado then
    tornado.WINDSTAFF_CASTER = inst.components.inventoryitem.owner
    tornado.WINDSTAFF_CASTER_ISPLAYER = tornado.WINDSTAFF_CASTER ~= nil and tornado.WINDSTAFF_CASTER:HasTag("player")
    tornado.Transform:SetPosition(getspawnlocation(inst, target))
    tornado.components.knownlocations:RememberLocation("target", target:GetPosition())

    if tornado.WINDSTAFF_CASTER_ISPLAYER then
        tornado.overridepkname = tornado.WINDSTAFF_CASTER:GetDisplayName()
        tornado.overridepkpet = true
    end
	end
end
local function onattack(inst, attacker, target)
    if not target:IsValid() then
        return
    end
	if target.components.burnable ~= nil and not target.components.burnable:IsBurning() then
        if target.components.freezable ~= nil and target.components.freezable:IsFrozen() then
            target.components.freezable:Unfreeze()
		end
	end
	inst.components.tz_firelvl:DoDelta(1) 
	if attacker and attacker.components.burnable ~= nil and attacker.components.burnable:IsBurning() then
		inst.components.weapon:SetDamage(74 + inst.components.tz_firelvl.current)
	else
		inst.components.weapon:SetDamage(37 + inst.components.tz_firelvl.current)
	end
	if math.random() <0.2 and target.components.burnable~=nil and not inst.shexian then
        target.components.burnable:Ignite()
			inst.shexian = true
			inst:DoTaskInTime(2, function() inst.shexian = false end)
	end
	if math.random() < 0.1 and not inst.shexian then
		SpawnfireFx2(inst, attacker, target)
			inst.shexian = true
			inst:DoTaskInTime(2, function() inst.shexian = false end)		
	end
end

local function fire_fx_trail(inst)
    local owner = inst.components.inventoryitem:GetGrandOwner() or inst
    if not owner.entity:IsVisible() then
        return
    end
    local x, y, z = owner.Transform:GetWorldPosition()
	SpawnPrefab("tz_firesword_fx").Transform:SetPosition(x, y, z)
	inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel")
end

local function fire_equipped(inst)
    if inst._trailtask == nil then
        inst._trailtask = inst:DoPeriodicTask(10, fire_fx_trail, 0.1)
    end

end

local function fire_unequipped(inst)
    if inst._trailtask ~= nil then
        inst._trailtask:Cancel()
        inst._trailtask = nil
    end	
end


local function ondropped(inst)
    local pos = Vector3(inst.Transform:GetWorldPosition())
	local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 6)
		for k,v in pairs(ents) do
			if v.prefab == "lava_pond" then
				local pot = Vector3(v.Transform:GetWorldPosition())
				local distance = math.sqrt(math.pow(pos.x-pot.x, 2)+math.pow(pos.y-pot.y, 2))
			    local sudu = (6-distance)*20/60
					    if inst.huifutask == nil then
							inst.huifutask = inst:DoPeriodicTask(1, function(inst)
							inst.components.finiteuses:Use(-sudu)
							if inst.components.finiteuses:GetPercent() > 1 then
								inst.components.finiteuses:SetPercent(1)
							end
						    end, 1)
						end	
				inst.erha = 1			
			end
		end
    inst.Light:Enable(true)
end

local  function checkforhuifu(inst)
		if inst.erha == 1 then
		ondropped(inst)
		end
end
local function onsave(inst,data)
	data.erha = inst.erha
end
local function onload(inst,data)
	if data and data.erha then
	inst.erha = data.erha
	end
end
local function onpickup(inst)
    if inst.huifutask ~= nil then
        inst.huifutask:Cancel()
        inst.huifutask = nil
	inst.erha = 0
    end	
end

local function OnPick(inst)
    inst.Light:Enable(false)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst.entity:AddLight()
	inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
    inst.entity:AddDynamicShadow()	
    inst.DynamicShadow:SetSize(2, .75)

    inst.AnimState:SetBank("tz_sword")
    inst.AnimState:SetBuild("tz_sword")
    inst.AnimState:PlayAnimation("idle",true)
	inst.AnimState:SetMultColour(1,1,1,0.5)
    inst:AddTag("sharp")
	inst:AddTag("shadow")
    inst.Light:SetFalloff(0.8)
    inst.Light:SetIntensity(.9)
    inst.Light:SetRadius(1.8)
	inst.Light:SetColour(197/255, 126/255, 126/255)
    inst.Light:Enable(true)
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	inst.erha = 0
	inst:AddComponent("tz_firelvl")

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(37 + inst.components.tz_firelvl.current)
    inst.components.weapon.onattack = onattack
    -------

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(1200)
    inst.components.finiteuses:SetUses(1200)
	inst.components.finiteuses:SetOnFinished(inst.Remove)
	
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_firesword.xml"
    inst.components.inventoryitem:SetOnDroppedFn(ondropped) 
	inst.components.inventoryitem:SetOnPutInInventoryFn(onpickup)
    inst.components.inventoryitem:SetOnPickupFn(OnPick)
	
	inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst:AddComponent("heater")
    inst.components.heater:SetThermics(true, false)
    inst.components.heater.equippedheat = 10

	inst:DoPeriodicTask(10, deltalvl, 10)
    inst:ListenForEvent("equipped", fire_equipped)
    inst:ListenForEvent("unequipped", fire_unequipped)
	inst:ListenForEvent("tz_firelvl", imagechage)
	MakeHauntableLaunch(inst)
	lighton(inst)
    inst.OnSave = onsave
    inst.OnLoad = onload
	inst:DoTaskInTime(3, function(inst)
	checkforhuifu(inst)
	end)
    return inst
end
local function lightfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.Light:EnableClientModulation(true)
    inst.Light:SetFalloff(0.8)
    inst.Light:SetIntensity(.9)
    inst.Light:SetRadius(1.8)
	inst.Light:SetColour(197/255, 126/255, 126/255)
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

return Prefab("tz_firesword", fn, assets, prefabs),
	Prefab("tz_firesword_light", lightfn)