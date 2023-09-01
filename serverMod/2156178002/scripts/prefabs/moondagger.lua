local assets=
{
    Asset("ANIM", "anim/moondagger.zip"),
    Asset("ANIM", "anim/swap_moondagger.zip"), 

    Asset("ATLAS", "images/inventoryimages/moondagger.xml"),
    Asset("IMAGE", "images/inventoryimages/moondagger.tex")
}

local prefabs=
{
	"forge_fireball_projectile",
	"forge_fireball_hit_fx",
	--"infernalstaff_meteor",
	"hydra_meteor",
	"reticuleaoe",
	"reticuleaoeping",
	"reticuleaoehostiletarget"
}

local proj_delay=40*FRAMES;


-- Thanks to Ultroman for the buff code !
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

CreateBuff("BuffCeption", 5,
	function(inst)
		inst:AddTag("DontRemovePoison")
	end,
	function(inst)
		inst:RemoveTag("DontRemovePoison")
	end
)
local function DoPoisonDamage(inst)
    inst.components.health:DoDelta(-TUNING.MAPLE_POISON, true, "poison")
end
CreateBuff("PoisonDebuff", 5.1,
	function(inst)
		if inst.poisontask == nil then
			inst.poisontask = inst:DoPeriodicTask(1/2, DoPoisonDamage)
			inst.AnimState:SetMultColour(0.8,0.2,1,1)
		end
		ApplyBuff(Buffs["BuffCeption"], inst)
	end,
	function(inst)
		if not inst:HasTag("DontRemovePoison") then
			if inst.poisontask ~= nil then
				inst.poisontask:Cancel()
				inst.poisontask = nil
				inst.AnimState:SetMultColour(1,1,1,1)
			end
		end
	end
)





local function OnEquip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object", "swap_moondagger", "moondagger")
    owner.AnimState:Show("ARM_carry") 	
    owner.AnimState:Hide("ARM_normal")
end

local function OnUnequip(inst, owner) 
	inst.AnimState:Hide("swap_moondagger")
    owner.AnimState:Hide("ARM_carry") 	
    owner.AnimState:Show("ARM_normal")
end


local function reticule_target_fn()
	local player=ThePlayer;
	local ground=TheWorld.Map;
	local area_of_effect=Vector3()
	for l=7,0,-.25 do area_of_effect.x,area_of_effect.y,area_of_effect.z=player.entity:LocalToWorldSpace(l,0,0)
	if ground:IsPassableAtPoint(area_of_effect:Get())and not ground:IsGroundTargetBlocked(area_of_effect)then
	return area_of_effect 
	end end;
	return area_of_effect 
end;


local function SetAOESpell_fn(inst,n,area_of_effect)
	SpawnPrefab("hydra_meteor"):AttackArea(n,inst,area_of_effect)
	inst.components.rechargeable_spell:StartRecharge()
end;


local function Get_Target_fn(inst,owner,target)

	-- --Damage calculation
	-- --Deals between meteor_base_damage and (2/3)meteor_base_damage depending of the target position
	-- local meteor_position=inst.meteor:GetPosition()
	-- local meteor_base_damage=90;
	-- local meteor_center_mult_damage=1;
	-- local meteor_radius=16;
	-- local gap_meteor_target=distsq(meteor_position,target:GetPosition())
	-- local meteor_damage_modifier=math.max(0,1-gap_meteor_target/meteor_radius)
	-- local meteor_total_damage=meteor_base_damage*(1+Lerp(0,meteor_center_mult_damage,meteor_damage_modifier))
	
	-- -- rounding the damages dealt
	-- meteor_total_damage=math.ceil(meteor_total_damage/5)
	-- meteor_total_damage=5*meteor_total_damage
	
	-- return meteor_total_damage
	return 0
end;


local function OnAttack(inst,owner,target)

	if not inst.components.weapon.isaltattacking and target and target.components.health and not target.components.health:IsDead() then
		ApplyBuff(Buffs["PoisonDebuff"], target)
	end
	
	if not inst.components.weapon.isaltattacking then
		inst.components.fueled:DoDelta(-1)
		if inst.components.fueled:IsEmpty() then
			-- inst:DoTaskInTime(0.1, function() inst:Remove() end)
			--inst:DoTaskInTime(0.1, function() 
				inst.components.equippable.restrictedtag = "empty_weapon"
				owner.components.inventory:DropItem(owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS))
			--end)
		end
	end
	
	if inst.components.weapon.isaltattacking then
		SpawnPrefab("infernalstaff_meteor_splashhit"):SetTarget(target)
		inst.components.talker:Say("Hydra!")
		
		-- Moved to hydra_meteor
		-- inst.components.fueled:DoDelta(-10)
		-- if inst.components.fueled:IsEmpty() then
			-- inst:DoTaskInTime(0.1, function() inst:Remove() end)
		-- end
	end
end;

local function ontakefuel(inst)
    inst.components.fueled:DoDelta(100)
	inst.components.equippable.restrictedtag = "maple"
end

local function fn()

	local inst=CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.nameoverride="moondagger"
	inst.AnimState:SetBank("moondagger")
	inst.AnimState:SetBuild("moondagger")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("themoondagger")
	inst:AddTag("rechargeable")
	
	inst:AddComponent("aoetargeting")
	inst.components.aoetargeting.reticule.reticuleprefab="reticuleaoe"
	inst.components.aoetargeting.reticule.pingprefab="reticuleaoeping"
	inst.components.aoetargeting.reticule.targetfn=reticule_target_fn;
	inst.components.aoetargeting.reticule.validcolour={1,.75,0.5,1}
	inst.components.aoetargeting.reticule.invalidcolour={.5,0,0,1}
	inst.components.aoetargeting.reticule.ease=true;
	inst.components.aoetargeting.reticule.mouseenabled=true;
	inst.projectiledelay=proj_delay;
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then 
	return inst 
	end;

	inst.IsWorkableAllowed=function(self,D,E)

	return D==ACTIONS.CHOP or D==ACTIONS.DIG and E:HasTag("stump")or D==ACTIONS.MINE end;

	inst.castsound="dontstarve/common/lava_arena/spell/meteor"
	inst:AddComponent("aoespell")
	inst.components.aoespell:SetSpellFn(SetAOESpell_fn)

	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)
	inst.components.equippable.restrictedtag = "maple"	

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename="moondagger"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/moondagger.xml"

	inst:AddComponent("rechargeable_spell")
	inst.components.rechargeable_spell:SetRechargeTime(3)

	inst:AddComponent("reticule_spawner")
	inst.components.reticule_spawner:Setup("aoehostiletarget",0.7)

	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(20)
	inst.components.weapon:SetOnAttack(OnAttack)

	inst:AddComponent("fueled")
	inst.components.fueled.fueltype = FUELTYPE.MOONDAGGER_FUELTYPE	
	inst.components.fueled.maxfuel = (100)
	inst.components.fueled:InitializeFuelLevel(100)
	inst.components.fueled:StopConsuming()
	
	inst.components.fueled:SetTakeFuelFn(ontakefuel)
	inst.components.fueled.accepting = true
	
	inst:AddComponent("talker")

	inst.components.weapon:SetAltAttack(60,{10,20},nil,DAMAGETYPES.MAGIC,Get_Target_fn)
--	inst.components.weapon:SetAltAttack(TUNING.FORGE_ITEM_PACK.MOONDAGGER.ALT_DAMAGE.minimum,{10,20},nil,DAMAGETYPES.MAGIC,Get_Target_fn)
    return inst
end


return CustomPrefab("moondagger",fn,assets,prefabs,nil,"images/inventoryimages.xml","moondagger.tex",TUNING.FORGE_ITEM_PACK.MOONDAGGER,"swap_moondagger","common_hand")