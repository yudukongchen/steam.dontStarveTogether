local assets={
	Asset("ANIM","anim/spear_lance.zip"),
	Asset("ANIM","anim/swap_spear_lance.zip")
}

local prefabs={"reticuleaoesmall","reticuleaoesmallping","reticuleaoesmallhostiletarget","weaponsparks_fx","weaponsparks_thrusting","forgespear_fx","superjump_fx"}

local function OnEquip(inst,owner)owner.AnimState:OverrideSymbol("swap_object","swap_spear_lance","swap_spear_lance")owner.AnimState:Show("ARM_carry")owner.AnimState:Hide("ARM_normal")end;

local function OnUnequip(inst,owner)owner.AnimState:Hide("ARM_carry")owner.AnimState:Show("ARM_normal")end;

local function reticule_target_fn()
local player=ThePlayer;
local ground=TheWorld.Map;
local area_of_effect=Vector3()for k=5,0,-.25 do area_of_effect.x,area_of_effect.y,area_of_effect.z=player.entity:LocalToWorldSpace(k,0,0)
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

local function OnAttack(inst,owner,target)
if not inst.components.weapon.isaltattacking then 
--SpawnPrefab("weaponsparks_fx"):SetPosition(owner,target)
else 
--SpawnPrefab("forgespear_fx"):SetTarget(target)
end 
end;


local function fn()
local inst=CreateEntity()
inst.entity:AddTransform()
inst.entity:AddAnimState()
inst.entity:AddNetwork()
MakeInventoryPhysics(inst)
inst.nameoverride="spear_lance"
inst.AnimState:SetBank("spear_lance")
inst.AnimState:SetBuild("spear_lance")
inst.AnimState:PlayAnimation("idle")
inst:AddTag("aoeweapon_leap")
inst:AddTag("pointy")
inst:AddTag("rechargeable")
inst:AddTag("sharp")
inst:AddTag("superjump")
inst:AddComponent("aoetargeting")
inst.components.aoetargeting:SetRange(TUNING.FORGE_ITEM_PACK.SPIRALSPEAR.ALT_RANGE)
inst.components.aoetargeting.reticule.reticuleprefab="reticuleaoesmall"
inst.components.aoetargeting.reticule.pingprefab="reticuleaoesmallping"
inst.components.aoetargeting.reticule.targetfn=reticule_target_fn;
inst.components.aoetargeting.reticule.validcolour={1,.75,0,1}
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
inst:AddComponent("inspectable")
inst:AddComponent("inventoryitem")
inst.components.inventoryitem.imagename="spear_lance"
inst:AddComponent("multithruster")
inst.components.multithruster.weapon=inst;
inst:AddComponent("rechargeable_spell")
inst.components.rechargeable_spell:SetRechargeTime(TUNING.FORGE_ITEM_PACK.SPIRALSPEAR.COOLDOWN)
inst:AddComponent("reticule_spawner")
inst.components.reticule_spawner:Setup(unpack(TUNING.FORGE_ITEM_PACK.RET_DATA.spiralspear))
inst:AddComponent("weapon")
inst.components.weapon:SetDamage(TUNING.FORGE_ITEM_PACK.SPIRALSPEAR.DAMAGE)
inst.components.weapon:SetOnAttack(OnAttack)
inst.components.weapon:SetDamageType(DAMAGETYPES.PHYSICAL)
inst.components.weapon:SetAltAttack(TUNING.FORGE_ITEM_PACK.SPIRALSPEAR.ALT_DAMAGE,TUNING.FORGE_ITEM_PACK.SPIRALSPEAR.ALT_RADIUS,nil,DAMAGETYPES.PHYSICAL)
return inst 
end;

return CustomPrefab("spiralspear",fn,assets,prefabs,nil,"images/inventoryimages.xml","spear_lance.tex",TUNING.FORGE_ITEM_PACK.SPIRALSPEAR,"swap_spear_lance","common_hand")