
local assets =
{
	Asset("ANIM", "anim/shield.zip"),
	Asset("ANIM", "anim/swap_shield.zip"),
	
    Asset("ATLAS", "images/inventoryimages/shield.xml"),
	Asset("IMAGE", "images/inventoryimages/shield.tex")
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
	end,
	function(inst)
		inst.components.combat.externaldamagetakenmultipliers:SetModifier("CoverMoveModifier", 1)
	end
)

-------


local function OnAttack(inst,owner,target)
	-- if not inst.components.weapon.isaltattacking then 
	-- else 
		-- if owner.components.health and not owner.components.health:IsDead() then
			-- ApplyBuff(Buffs["CoverMoveDebuff"], owner)
		-- end
	-- end 
end;

local function OnBlocked(owner, data)
	if data.attacker ~= nil then
		if data.attacker and data.attacker.components.health and data.attacker.components.combat then
			if not owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).components.fueled:IsEmpty() then
			
				SpawnPrefab("devourfx_armor"):SetFXOwner(owner)
				data.attacker.components.combat:GetAttacked(owner, TUNING.MAPLE_DEVOUR)
				owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).components.fueled:DoDelta(-10)
				owner.daily_shield_recharge = owner.daily_shield_recharge-0.1
			end
		end
	end
end

local function OnEquip(inst,owner)
	
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
end;

local function OnUnequip(inst,owner)

	owner.AnimState:ClearSymbolExchanges()
	
    owner.AnimState:Hide("ARM_carry") 
	inst.AnimState:Hide("swap_shield")
    owner.AnimState:Show("ARM_normal")
		
	inst:RemoveEventCallback("attacked", OnBlocked, owner)
	if TUNING.MAPLE_PROTECTION == 0 then
		inst:RemoveEventCallback("blocked", OnBlocked, owner)
	end
end;

local function reticule_target_fn()
local player=ThePlayer;
local ground=TheWorld.Map;
local area_of_effect=Vector3()
for k=5,0,-.25 do area_of_effect.x,area_of_effect.y,area_of_effect.z=player.entity:LocalToWorldSpace(k,0,0)
if ground:IsPassableAtPoint(area_of_effect:Get())and not ground:IsGroundTargetBlocked(area_of_effect)then 
return area_of_effect end end;
return area_of_effect 
end;

local function SetAOESpell_fn(inst,m,area_of_effect)
m:PushEvent("combat_superjump",{targetpos=area_of_effect,weapon=inst})
end;

local function OnLeap_Fn(inst)SpawnPrefab("superjump_fx"):SetTarget(inst)
inst.components.rechargeable_spell:StartRecharge()
end;



local function fn()

	local inst=CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	inst.entity:AddMiniMapEntity()
	inst.MiniMapEntity:SetIcon("shield.tex")

	MakeInventoryPhysics(inst)
	
	inst.nameoverride="shield"
	inst.AnimState:SetBank("shield")
	inst.AnimState:SetBuild("shield")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("theshield")	
	inst:AddTag("aoeweapon_leap")
	inst:AddTag("pointy")
	inst:AddTag("rechargeable")
	inst:AddTag("sharp")
	inst:AddTag("superjump")
	
	inst:AddComponent("aoetargeting")
	inst.components.aoetargeting:SetRange(50)--TUNING.FORGE_ITEM_PACK.SHIELD.ALT_RANGE
	inst.components.aoetargeting.reticule.reticuleprefab="reticuleaoesmall"
	inst.components.aoetargeting.reticule.pingprefab="reticuleaoesmallping"
	inst.components.aoetargeting.reticule.targetfn=reticule_target_fn;
	inst.components.aoetargeting.reticule.validcolour={1,.75,0.5,1}
	inst.components.aoetargeting.reticule.invalidcolour={.5,0,0,1}
	inst.components.aoetargeting.reticule.ease=true;
	inst.components.aoetargeting.reticule.mouseenabled=true;
	
	inst.entity:SetPristine()


	if not TheWorld.ismastersim then 
		return inst 
	end;

	inst.IsWorkableAllowed=function(self,s,t)return s==ACTIONS.CHOP or s==ACTIONS.DIG and t:HasTag("stump")or s==ACTIONS.MINE end;
	
	inst:AddComponent("aoespell")
	inst.components.aoespell:SetSpellFn(SetAOESpell_fn)
	
	inst:AddComponent("aoeweapon_leap")
	inst.components.aoeweapon_leap:SetStimuli("explosive")
	inst.components.aoeweapon_leap:SetOnLeapFn(OnLeap_Fn)
	
	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)
	inst.components.equippable.restrictedtag = "maple"
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename="shield"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/shield.xml"
	
	inst:AddComponent("multithruster")
	inst.components.multithruster.weapon=inst;
	
	inst:AddComponent("rechargeable_spell")
	inst.components.rechargeable_spell:SetRechargeTime(3)--TUNING.FORGE_ITEM_PACK.SHIELD.COOLDOWN
	
	inst:AddComponent("reticule_spawner")
	inst.components.reticule_spawner:Setup("aoehostiletarget",0.7)
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(2)
	inst.components.weapon:SetOnAttack(OnAttack)
	inst.components.weapon:SetDamageType(DAMAGETYPES.PHYSICAL)
	inst.components.weapon:SetAltAttack(0,4,nil,DAMAGETYPES.PHYSICAL)--alt damage, alt radius
	
	inst:AddComponent("fueled")	
	inst.components.fueled.fueltype = FUELTYPE.MONSTERMEAT	
	inst.components.fueled.maxfuel = (100)
	inst.components.fueled:InitializeFuelLevel(100)
	inst.components.fueled:StopConsuming()
	
	return inst 
end;

return CustomPrefab("shield",fn,assets,prefabs,nil,"images/inventoryimages.xml","shield.tex",TUNING.FORGE_ITEM_PACK.SHIELD,"swap_shield","common_hand")

