local assets=
{ 
    Asset("ANIM", "anim/shield.zip"),
    Asset("ANIM", "anim/swap_shield.zip"), 

    Asset("ATLAS", "images/inventoryimages/shield.xml"),
    Asset("IMAGE", "images/inventoryimages/shield.tex"),
}

local prefabs = 
{
    "devourfx_armor",
	
	"reticuleaoesmall",
	"reticuleaoesmallping",
	"reticuleaoesmallhostiletarget",
	"weaponsparks_fx",
	"weaponsparks_thrusting",
	"forgespear_fx",
	"superjump_fx"
}



------------------------------------------------------------------------------------------------------------------------
--Cover Move functions

local function g()
	local h=ThePlayer;
	local i=TheWorld.Map;
	local j=Vector3()
		for k=5,0,-.25 do j.x,j.y,j.z=h.entity:LocalToWorldSpace(k,0,0)
			if i:IsPassableAtPoint(j:Get())and not i:IsGroundTargetBlocked(j)then 
			return j 
		end 
	end;
return j 
end;

local function l(inst,m,j)
	m:PushEvent("combat_superjump",{targetpos=j,weapon=inst})
end;

local function n(inst)
SpawnPrefab("superjump_fx"):SetTarget(inst)
inst.components.rechargeable_spell:StartRecharge()end;

local function o(inst,p,q)if not inst.components.weapon.isaltattacking then 
SpawnPrefab("weaponsparks_fx"):SetPosition(p,q)
else SpawnPrefab("forgespear_fx"):SetTarget(q)end end;

------------------------------------------------------------------------------------------------------------------------

------
--Buff code
local function ApplyBuff(buffData, instToBuff)
	local buffUniqueName = buffData.uniqueName
	
	if instToBuff[buffUniqueName.."Task"] ~= nil then
		buffData.removeFunction(instToBuff)
		instToBuff[buffUniqueName.."Task"]:Cancel()
		instToBuff[buffUniqueName.."Task"] = nil
	end
	
	local buffOnSave = function(self, inst, data)
		if inst[buffUniqueName.."Task"] ~= nil then
			buffData.removeFunction(inst)
			inst[buffUniqueName.."Task"]:Cancel()
			inst[buffUniqueName.."Task"] = nil
		end
	end
	
	if instToBuff.OnSave ~= nil then
		local oldOnSave = instToBuff.OnSave
		instToBuff.OnSave = function(self, inst, data)
			buffOnSave(self, inst, data)
			oldOnSave(self, inst, data)
		end
	else
		instToBuff.OnSave = buffOnSave
	end
	
	buffData.applyFunction(instToBuff)
	instToBuff[buffUniqueName.."Task"] = instToBuff:DoTaskInTime(buffData.duration, function(inst)
		buffData.removeFunction(inst)
		inst[buffUniqueName.."Task"] = nil
	end)
end

local Buffs = {}
local function CreateBuff(uniqueName, duration, applyFunction, removeFunction)
	local newBuff = {}
	newBuff.uniqueName = uniqueName
	newBuff.duration = duration
	newBuff.applyFunction = applyFunction
	newBuff.removeFunction = removeFunction
	Buffs[uniqueName] = newBuff
end

CreateBuff("CoverMoveDebuff", 30.0,
	function(inst)
		inst.components.combat.externaldamagetakenmultipliers:SetModifier("CoverMoveModifier", 2)
		--inst.AnimState:SetMultColour(0.4,0.4,1,1)
	end,
	function(inst)
		inst.components.combat.externaldamagetakenmultipliers:SetModifier("CoverMoveModifier", 1)
		--inst.AnimState:SetMultColour(1,1,1,1)
	end
)

-------





local function onattack(inst, owner, target)
	if inst.components.weapon.isaltattacking then
		if owner.components.health and not owner.components.health:IsDead() then
			ApplyBuff(Buffs["CoverMoveDebuff"], owner)
		end
	end
end

local function OnBlocked(owner, data) 
	if data.attacker ~= nil then
		if data.attacker and data.attacker.components.health and data.attacker.components.combat then
			if not owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).components.fueled:IsEmpty() then
			
				SpawnPrefab("devourfx_armor"):SetFXOwner(owner)
				data.attacker.components.combat:GetAttacked(owner, TUNING.MAPLE_DEVOUR)
				owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).components.fueled:DoDelta(-10)
			
			end
		end
	end
end


local function OnEquip(inst, owner) 


	-- This is the only way I found to move an animation object in the z axis
	-- Would have been problematic if I was using the SWAP_FACE animation
	-- Note that for some reasons only one SetMultiSymbolExchange can be used at a time
	-- The cannon does that too, but you can't use the two at the same time so it's ok
	owner.AnimState:ClearSymbolExchanges()
	owner.AnimState:SetMultiSymbolExchange("swap_object", "SWAP_FACE")
    owner.AnimState:OverrideSymbol("swap_object", "swap_shield", "shield")
	
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal")
		
	inst:ListenForEvent("attacked", OnBlocked, owner)
	if TUNING.MAPLE_PROTECTION == 0 then
		inst:ListenForEvent("blocked", OnBlocked, owner)
	end
end

local function OnUnequip(inst, owner) 

	owner.AnimState:ClearSymbolExchanges()
	
    owner.AnimState:Hide("ARM_carry") 
	inst.AnimState:Hide("swap_shield")
    owner.AnimState:Show("ARM_normal")
		
	inst:RemoveEventCallback("attacked", OnBlocked, owner)
	if TUNING.MAPLE_PROTECTION == 0 then
		inst:RemoveEventCallback("blocked", OnBlocked, owner)
	end
end


local function ReloadShield(inst)
	inst.components.fueled:DoDelta(100)
end


local function fn()
	local inst = CreateEntity()
	
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst.entity:AddMiniMapEntity()
	
    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("shield")
    inst.AnimState:SetBuild("shield")
    inst.AnimState:PlayAnimation("idle")
	
    MakeInventoryFloatable(inst)	
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end

	inst.MiniMapEntity:SetIcon("shield.tex")
	inst:AddTag("theshield")

	if TUNING.MAPLE_ANTI_THEFT then
		inst:AddTag("irreplaceable")
	end
	
	--inst:AddComponent("inspectable")
		
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "shield"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/shield.xml"
    
    inst:AddComponent("equippable")
	inst.components.equippable.equipslot = EQUIPSLOTS.HANDS
	inst.components.equippable.restrictedtag = "maple"
	
	--inst:AddComponent("machine")
    --inst.components.machine.turnonfn = turnon
    --inst.components.machine.turnofffn = turnoff
    --inst.components.machine.cooldowntime = 0
	
	inst:AddComponent("fueled")	
	inst.components.fueled.fueltype = FUELTYPE.MONSTERMEAT	
	inst.components.fueled.maxfuel = (100)
	inst.components.fueled:InitializeFuelLevel(100)
	inst.components.fueled:StopConsuming()

	--Prefab("monstermeat", monsterfuel)
	--inst.components.fueled.CanAcceptFuelItem = true--OkFuel
	
	
	--inst:WatchWorldState("phase",updatestats)			
	inst:WatchWorldState( "startday", function(inst) ReloadShield(inst) end )
	inst:WatchWorldState( "startcaveday", function(inst) ReloadShield(inst) end )
	ReloadShield(inst)

		
	MakeHauntableLaunch(inst)
   	
    inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )	
	
	
	inst:AddTag("weapon")
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(2)
	inst.components.weapon.onattack = onattack
	inst:AddTag("sharp")
    inst:AddTag("pointy")

	

	-- Only Maple can use it
	local oldOnPickup = inst.components.inventoryitem.OnPickup
	inst.components.inventoryitem.OnPickup = function(self, pickupguy)
		if pickupguy.prefab == "maple" then
			if not self.inst.itemowner then
				self.inst.itemowner = pickupguy
			end
			if pickupguy == self.inst.itemowner then
				oldOnPickup(self, pickupguy)
			elseif pickupguy.components.talker then
				-- pickupguy.components.talker:Say("This is not my shield.")
			end
		elseif pickupguy.components.talker then
			pickupguy.components.talker:Say("It's Maple's shield.")
		end
	end
	
	
------------------------------------------------------------------------------------------------------------------------
-- Cover Move	
	
inst:AddTag("aoeweapon_leap")
inst:AddTag("rechargeable")	
inst:AddTag("superjump")

inst:AddComponent("aoetargeting")
inst.components.aoetargeting:SetRange(TUNING.FORGE_ITEM_PACK.SHIELD.ALT_RANGE)
inst.components.aoetargeting.reticule.reticuleprefab="reticuleaoesmall"
inst.components.aoetargeting.reticule.pingprefab="reticuleaoesmallping"
inst.components.aoetargeting.reticule.targetfn=g;
inst.components.aoetargeting.reticule.validcolour={0,.75,0.5,1}
inst.components.aoetargeting.reticule.invalidcolour={.5,0,0,1}
inst.components.aoetargeting.reticule.ease=true;
inst.components.aoetargeting.reticule.mouseenabled=true;	
	
inst.IsWorkableAllowed=function(self,s,t)return s==ACTIONS.CHOP or s==ACTIONS.DIG and t:HasTag("stump")or s==ACTIONS.MINE end;
inst:AddComponent("aoespell")
inst.components.aoespell:SetAOESpell(l)
inst:AddComponent("aoeweapon_leap")
--inst.components.aoeweapon_leap:SetStimuli("explosive")
inst.components.aoeweapon_leap:SetOnLeapFn(n)	
	
inst:AddComponent("multithruster")
inst.components.multithruster.weapon=inst;
inst:AddComponent("rechargeable_spell")
inst.components.rechargeable_spell:SetRechargeTime(TUNING.FORGE_ITEM_PACK.SHIELD.COOLDOWN)
inst:AddComponent("reticule_spawner")
inst.components.reticule_spawner:Setup(unpack(TUNING.FORGE_ITEM_PACK.RET_DATA.shield))
	
inst.components.weapon:SetDamageType(DAMAGETYPES.PHYSICAL)	
	
inst.components.weapon:SetAltAttack(TUNING.FORGE_ITEM_PACK.SHIELD.ALT_DAMAGE,TUNING.FORGE_ITEM_PACK.SHIELD.ALT_RADIUS,nil,DAMAGETYPES.PHYSICAL)
	
------------------------------------------------------------------------------------------------------------------------	

	
	
    return inst
end

return Prefab("common/inventory/shield", fn, assets, prefabs,nil,nil,TUNING.FORGE_ITEM_PACK.SHIELD,nil,nil)
	


-- local assets =
-- {
	-- Asset("ANIM", "anim/shield.zip"),
	-- Asset("ANIM", "anim/swap_shield.zip"),
	
    -- Asset("ATLAS", "images/inventoryimages/shield.xml"),
	-- Asset("IMAGE", "images/inventoryimages/shield.tex")
-- }

-- local prefabs =
-- {
	-- --"devourfx_armor",

	-- "reticuleaoesmall",
	-- "reticuleaoesmallping",
	-- "reticuleaoesmallhostiletarget",
	-- "weaponsparks_fx",
	-- "weaponsparks_thrusting",
	-- "forgespear_fx",
	-- "superjump_fx"
-- }


-- ------
-- --Buff code
-- local function ApplyBuff(buffData, instToBuff)
	-- local buffUniqueName = buffData.uniqueName
	
	-- if instToBuff[buffUniqueName.."Task"] ~= nil then
		-- buffData.removeFunction(instToBuff)
		-- instToBuff[buffUniqueName.."Task"]:Cancel()
		-- instToBuff[buffUniqueName.."Task"] = nil
	-- end
	
	-- local buffOnSave = function(self, inst, data)
		-- if inst[buffUniqueName.."Task"] ~= nil then
			-- buffData.removeFunction(inst)
			-- inst[buffUniqueName.."Task"]:Cancel()
			-- inst[buffUniqueName.."Task"] = nil
		-- end
	-- end
	
	-- if instToBuff.OnSave ~= nil then
		-- local oldOnSave = instToBuff.OnSave
		-- instToBuff.OnSave = function(self, inst, data)
			-- buffOnSave(self, inst, data)
			-- oldOnSave(self, inst, data)
		-- end
	-- else
		-- instToBuff.OnSave = buffOnSave
	-- end
	
	-- buffData.applyFunction(instToBuff)
	-- instToBuff[buffUniqueName.."Task"] = instToBuff:DoTaskInTime(buffData.duration, function(inst)
		-- buffData.removeFunction(inst)
		-- inst[buffUniqueName.."Task"] = nil
	-- end)
-- end

-- local Buffs = {}
-- local function CreateBuff(uniqueName, duration, applyFunction, removeFunction)
	-- local newBuff = {}
	-- newBuff.uniqueName = uniqueName
	-- newBuff.duration = duration
	-- newBuff.applyFunction = applyFunction
	-- newBuff.removeFunction = removeFunction
	-- Buffs[uniqueName] = newBuff
-- end

-- CreateBuff("CoverMoveDebuff", 30.0,
	-- function(inst)
		-- inst.components.combat.externaldamagetakenmultipliers:SetModifier("CoverMoveModifier", 2)
	-- end,
	-- function(inst)
		-- inst.components.combat.externaldamagetakenmultipliers:SetModifier("CoverMoveModifier", 1)
	-- end
-- )

-- -------

-- local function OnEquip(inst,owner)
	
	-- -- This is the only way I found to move an animation object in the z axis
	-- -- Would have been problematic if I was using the SWAP_FACE animation
	-- -- Note that for some reasons only one SetMultiSymbolExchange can be used at a time
	-- -- The cannon does that too, but you can't use the two at the same time so it's ok
	
	-- owner.AnimState:ClearSymbolExchanges()
	-- owner.AnimState:SetMultiSymbolExchange("swap_object", "SWAP_FACE")
    -- owner.AnimState:OverrideSymbol("swap_object", "swap_shield", "shield")
	
    -- owner.AnimState:Show("ARM_carry") 
    -- owner.AnimState:Hide("ARM_normal")
		
	-- inst:ListenForEvent("attacked", OnBlocked, owner)
	-- if TUNING.MAPLE_PROTECTION == 0 then
		-- inst:ListenForEvent("blocked", OnBlocked, owner)
	-- end
	
-- end;

-- local function OnUnequip(inst,owner)

	-- owner.AnimState:ClearSymbolExchanges()
	
    -- owner.AnimState:Hide("ARM_carry") 
	-- inst.AnimState:Hide("swap_shield")
    -- owner.AnimState:Show("ARM_normal")
		
	-- inst:RemoveEventCallback("attacked", OnBlocked, owner)
	-- if TUNING.MAPLE_PROTECTION == 0 then
		-- inst:RemoveEventCallback("blocked", OnBlocked, owner)
	-- end
-- end;

-- local function ReloadShield(inst)
	-- inst.components.fueled:DoDelta(100)
-- end

-- local function reticule_target_fn()
-- local player=ThePlayer;
-- local ground=TheWorld.Map;
-- local area_of_effect=Vector3()for k=5,0,-.25 do area_of_effect.x,area_of_effect.y,area_of_effect.z=player.entity:LocalToWorldSpace(k,0,0)
-- if ground:IsPassableAtPoint(area_of_effect:Get())and not ground:IsGroundTargetBlocked(area_of_effect)then 
-- return area_of_effect end end;
-- return area_of_effect 
-- end;

-- local function SetAOESpell_fn(inst,m,area_of_effect)
-- m:PushEvent("combat_superjump",{targetpos=area_of_effect,weapon=inst})
-- end;

-- local function OnLeap_Fn(inst)SpawnPrefab("superjump_fx"):SetTarget(inst)
-- inst.components.rechargeable_spell:StartRecharge()
-- end;

-- local function OnAttack(inst,owner,target)
	-- if not inst.components.weapon.isaltattacking then 
		-- --SpawnPrefab("weaponsparks_fx"):SetPosition(owner,target)
	-- else 
		-- --SpawnPrefab("forgespear_fx"):SetTarget(target)
		
		-- if owner.components.health and not owner.components.health:IsDead() then
			-- ApplyBuff(Buffs["CoverMoveDebuff"], owner)
		-- end
	-- end 
-- end;

-- local function OnBlocked(owner, data)
	-- if data.attacker ~= nil then
		-- if data.attacker and data.attacker.components.health and data.attacker.components.combat then
			-- if not owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).components.fueled:IsEmpty() then
			
				-- SpawnPrefab("devourfx_armor"):SetFXOwner(owner)
				-- data.attacker.components.combat:GetAttacked(owner, TUNING.MAPLE_DEVOUR)
				-- owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).components.fueled:DoDelta(-10)
			
			-- end
		-- end
	-- end
-- end


-- local function fn()

	-- local inst=CreateEntity()

	-- inst.entity:AddTransform()
	-- inst.entity:AddAnimState()
	-- inst.entity:AddNetwork()
	
	-- inst.entity:AddMiniMapEntity()
	-- inst.MiniMapEntity:SetIcon("shield.tex")

	-- MakeInventoryPhysics(inst)
	
	-- inst.nameoverride="shield"
	-- inst.AnimState:SetBank("shield")
	-- inst.AnimState:SetBuild("shield")
	-- inst.AnimState:PlayAnimation("idle")
	
	-- inst:AddTag("theshield")	
	-- inst:AddTag("aoeweapon_leap")
	-- inst:AddTag("pointy")
	-- inst:AddTag("rechargeable")
	-- inst:AddTag("sharp")
	-- inst:AddTag("superjump")
	
	-- inst:AddComponent("aoetargeting")
	-- inst.components.aoetargeting:SetRange(50)--TUNING.FORGE_ITEM_PACK.SHIELD.ALT_RANGE
	-- inst.components.aoetargeting.reticule.reticuleprefab="reticuleaoesmall"
	-- inst.components.aoetargeting.reticule.pingprefab="reticuleaoesmallping"
	-- inst.components.aoetargeting.reticule.targetfn=reticule_target_fn;
	-- inst.components.aoetargeting.reticule.validcolour={1,.75,0,1}
	-- inst.components.aoetargeting.reticule.invalidcolour={.5,0,0,1}
	-- inst.components.aoetargeting.reticule.ease=true;
	-- inst.components.aoetargeting.reticule.mouseenabled=true;
	
	-- inst.entity:SetPristine()


	-- if not TheWorld.ismastersim then 
		-- return inst 
	-- end;

	-- inst.IsWorkableAllowed=function(self,s,t)return s==ACTIONS.CHOP or s==ACTIONS.DIG and t:HasTag("stump")or s==ACTIONS.MINE end;
	
	-- inst:AddComponent("aoespell")
	-- inst.components.aoespell:SetAOESpell(SetAOESpell_fn)
	
	-- inst:AddComponent("aoeweapon_leap")
	-- inst.components.aoeweapon_leap:SetStimuli("explosive")
	-- inst.components.aoeweapon_leap:SetOnLeapFn(OnLeap_Fn)
	
	-- inst:AddComponent("equippable")
	-- --inst.components.equippable.equipslot = EQUIPSLOTS.HANDS
	-- inst.components.equippable:SetOnEquip(OnEquip)
	-- inst.components.equippable:SetOnUnequip(OnUnequip)
	-- inst.components.equippable.restrictedtag = "maple"
	
	-- inst:AddComponent("inspectable")
	
	-- inst:AddComponent("inventoryitem")
	-- inst.components.inventoryitem.imagename="shield"
	-- inst.components.inventoryitem.atlasname = "images/inventoryimages/shield.xml"
	
	-- inst:AddComponent("multithruster")
	-- inst.components.multithruster.weapon=inst;
	
	-- inst:AddComponent("rechargeable_spell")
	-- inst.components.rechargeable_spell:SetRechargeTime(TUNING.FORGE_ITEM_PACK.SHIELD.COOLDOWN)--TUNING.FORGE_ITEM_PACK.SHIELD.COOLDOWN
	
	-- inst:AddComponent("reticule_spawner")
	-- inst.components.reticule_spawner:Setup(unpack(TUNING.FORGE_ITEM_PACK.RET_DATA.shield))
	
	-- inst:AddComponent("weapon")
	-- inst.components.weapon:SetDamage(TUNING.FORGE_ITEM_PACK.SHIELD.DAMAGE)
	-- inst.components.weapon:SetOnAttack(OnAttack)
	-- inst.components.weapon:SetDamageType(DAMAGETYPES.PHYSICAL)
	-- inst.components.weapon:SetAltAttack(TUNING.FORGE_ITEM_PACK.SHIELD.ALT_DAMAGE,TUNING.FORGE_ITEM_PACK.SHIELD.ALT_RADIUS,nil,DAMAGETYPES.PHYSICAL)--alt damage, alt radius
	
	-- inst:AddComponent("fueled")	
	-- inst.components.fueled.fueltype = FUELTYPE.MONSTERMEAT	
	-- inst.components.fueled.maxfuel = (100)
	-- inst.components.fueled:InitializeFuelLevel(100)
	-- inst.components.fueled:StopConsuming()
	
	-- inst:WatchWorldState( "startday", function(inst) ReloadShield(inst) end )
	-- inst:WatchWorldState( "startcaveday", function(inst) ReloadShield(inst) end )
	-- ReloadShield(inst)
	
	
	
	
	-- return inst 
-- end;


-- return CustomPrefab("shield",fn,assets,prefabs,nil,"images/inventoryimages.xml","shield.tex",TUNING.FORGE_ITEM_PACK.SHIELD,"swap_shield","common_hand")


--return Prefab("common/inventory/shield", fn, assets, prefabs,nil,nil,TUNING.FORGE_ITEM_PACK.SHIELD,nil,nil)


