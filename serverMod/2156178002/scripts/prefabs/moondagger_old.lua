local assets=
{ 
    Asset("ANIM", "anim/moondagger.zip"),
    Asset("ANIM", "anim/swap_moondagger.zip"), 

    Asset("ATLAS", "images/inventoryimages/moondagger.xml"),
    Asset("IMAGE", "images/inventoryimages/moondagger.tex")
}

local prefabs = 
{
	"forge_fireball_projectile",
	"forge_fireball_hit_fx",
	--"infernalstaff_meteor",
	"hydra_meteor",
	"reticuleaoe",
	"reticuleaoeping",
	"reticuleaoehostiletarget"
}
local projectile_delay=4*FRAMES;


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
local i=ThePlayer;
local j=TheWorld.Map;
local k=Vector3()
	for l=7,0,-.25 do k.x,k.y,k.z=i.entity:LocalToWorldSpace(l,0,0)
	if j:IsPassableAtPoint(k:Get())and not j:IsGroundTargetBlocked(k)then
	return k 
	end 
	end;
return k 
end;

local function SetAOESpell_fn(inst,n,k)
	--SpawnPrefab("infernalstaff_meteor"):AttackArea(n,inst,k)
	SpawnPrefab("hydra_meteor"):AttackArea(n,inst,k)
	inst.components.rechargeable_spell:StartRecharge()
end;

--Damage calculation
--Deals between v and (2/3)v depending of the target position
local function Get_Target_fn(inst,owner,target)
local u=inst.meteor:GetPosition()
--local v=TUNING.FORGE_ITEM_PACK.MOONDAGGER.ALT_DAMAGE.base;
local v=90;	
--local w=TUNING.FORGE_ITEM_PACK.MOONDAGGER.ALT_DAMAGE.center_mult;
local w=1;
--local x=16;
local x=16;
local y=distsq(u,target:GetPosition())
local z=math.max(0,1-y/x)
local A=v*(1+Lerp(0,w,z))
A=math.ceil(A/5)
A=5*A
return A end;


-- Thanks to Ultroman for the buff code !
-- For comments see the Sally code
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

local function DoPoisonDamage(inst)
    inst.components.health:DoDelta(-TUNING.MAPLE_POISON, true, "poison")
end

CreateBuff("PoisonDebuff", 5.0,
	function(inst)
		inst.poisontask = inst:DoPeriodicTask(1/2, DoPoisonDamage)
		inst.AnimState:SetMultColour(0.8,0.2,1,1)
	end,
	function(inst)
		inst.poisontask:Cancel()
		inst.poisontask = nil
		inst.AnimState:SetMultColour(1,1,1,1)
	end
)

local function onattack(inst, owner, target)

	if not inst.components.weapon.isaltattacking and target and target.components.health and not target.components.health:IsDead() then
		ApplyBuff(Buffs["PoisonDebuff"], target)
	end
	
	if not inst.components.weapon.isaltattacking then
		inst.components.fueled:DoDelta(-0.5)
		-- if inst.components.fueled.currentfuel <= 10 then
			-- inst:RemoveComponent("aoetargeting")
			-- inst:RemoveComponent("aoespell")
			-- inst:RemoveComponent("reticule_spawner")
		-- end
		if inst.components.fueled:IsEmpty() then
			inst:DoTaskInTime(0.1, function() inst:Remove() end)
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
end






local function fn()
	local inst = CreateEntity()
	
	
		
	inst.entity:AddMiniMapEntity()
    MakeInventoryFloatable(inst)	   
	inst:AddTag("themoondagger")
	
	--inst:AddComponent("inspectable")
		
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "moondagger"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/moondagger.xml"
    
    inst:AddComponent("equippable")
	inst.components.equippable.equipslot = EQUIPSLOTS.HANDS
    inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )
	inst.components.equippable.restrictedtag = "maple"	
	
	
	inst:AddTag("weapon")
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(20)
    inst.components.weapon.onattack = onattack
	
	inst:AddTag("sharp")
    inst:AddTag("pointy")
	MakeHauntableLaunch(inst)
	

		
	inst:AddComponent("talker")
	

	inst:AddComponent("fueled")	
	--inst.components.fueled.fueltype = FUELTYPE.MONSTERMEAT	
	inst.components.fueled.maxfuel = (100)
	inst.components.fueled:InitializeFuelLevel(100)
	inst.components.fueled:StopConsuming()
	
	
	
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
			end
		elseif pickupguy.components.talker then
			pickupguy.components.talker:Say("It's Maple's dagger.")
		end
	end
		
		

-------------------------------------------------------------------------------------------------		
	--Forge
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	MakeInventoryPhysics(inst)
	--inst.nameoverride="moondagger"
    inst.AnimState:SetBank("moondagger")
    inst.AnimState:SetBuild("moondagger")
	inst.AnimState:PlayAnimation("idle")
		--inst:AddTag("firestaff")
		--inst:AddTag("magicweapon")
		--inst:AddTag("pyroweapon")
		--inst:AddTag("rangedweapon")
	inst:AddTag("rechargeable")
	inst:AddComponent("aoetargeting")
	inst.components.aoetargeting.reticule.reticuleprefab="reticuleaoe"
	inst.components.aoetargeting.reticule.pingprefab="reticuleaoeping"
	inst.components.aoetargeting.reticule.targetfn=reticule_target_fn;
	inst.components.aoetargeting.reticule.validcolour={1,.75,0.5,1}--{1,.75,0,1}
	inst.components.aoetargeting.reticule.invalidcolour={.5,0,0,1}
	inst.components.aoetargeting.reticule.ease=true;
	inst.components.aoetargeting.reticule.mouseenabled=true;
	inst.projectiledelay=projectile_delay;
	inst.entity:SetPristine()
	--Forge
	

	
	
	-- if not TheWorld.ismastersim then 
	-- return inst 
	-- end;
	
	--Forge
	inst.IsWorkableAllowed=function(self,D,E)
	return D==ACTIONS.CHOP or D==ACTIONS.DIG and E:HasTag("stump")or D==ACTIONS.MINE end;

	inst.castsound="dontstarve/common/lava_arena/spell/meteor"
	inst:AddComponent("aoespell")
	inst.components.aoespell:SetAOESpell(SetAOESpell_fn)
	inst.components.aoespell:SetSpellType("damage")
	inst:AddComponent("rechargeable_spell")
	inst.components.rechargeable_spell:SetRechargeTime(TUNING.FORGE_ITEM_PACK.MOONDAGGER.COOLDOWN)
	inst:AddComponent("reticule_spawner")
	inst.components.reticule_spawner:Setup(unpack(TUNING.FORGE_ITEM_PACK.RET_DATA.moondagger))
	--inst.components.weapon:SetRange(10,20)
	--inst.components.weapon:SetProjectile("forge_fireball_projectile")
	--inst.components.weapon:SetOnProjectileLaunch(o)
	--inst.components.weapon:SetDamageType(DAMAGETYPES.MAGIC)
	--inst.components.weapon:SetStimuli("fire")
	inst.components.weapon:SetAltAttack(TUNING.FORGE_ITEM_PACK.MOONDAGGER.ALT_DAMAGE.minimum,{10,20},nil,DAMAGETYPES.MAGIC,Get_Target_fn)
	--Forge
-------------------------------------------------------------------------------------------------------	
	


    return inst
end



return Prefab("common/inventory/moondagger", fn, assets, prefabs,nil,nil,TUNING.FORGE_ITEM_PACK.MOONDAGGER,nil,nil)