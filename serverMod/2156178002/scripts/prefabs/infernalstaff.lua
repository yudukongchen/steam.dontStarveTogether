local assets={Asset("ANIM","anim/fireballstaff.zip"),
Asset("ANIM","anim/swap_fireballstaff.zip")}
local prefabs={"forge_fireball_projectile","forge_fireball_hit_fx","infernalstaff_meteor","reticuleaoe","reticuleaoeping","reticuleaoehostiletarget"}
local proj_delay=4*FRAMES;

--OnEquip
local function OnEquip(inst,owner)
owner.AnimState:OverrideSymbol("swap_object","swap_fireballstaff","swap_fireballstaff")
owner.AnimState:Show("ARM_carry")
owner.AnimState:Hide("ARM_normal")
end;

--OnUnequip
local function OnUnequip(inst,owner)
owner.AnimState:Hide("ARM_carry")
owner.AnimState:Show("ARM_normal")
end;


local function reticule_target_fn()
local player=ThePlayer;
local ground=TheWorld.Map;
local area_of_effect=Vector3()
for l=7,0,-.25 do area_of_effect.x,area_of_effect.y,area_of_effect.z=player.entity:LocalToWorldSpace(l,0,0)
if ground:IsPassableAtPoint(area_of_effect:Get())and not ground:IsGroundTargetBlocked(area_of_effect)then
return area_of_effect 
end end;
return area_of_effect end;

local function SetAOESpell_fn(inst,n,area_of_effect)
SpawnPrefab("infernalstaff_meteor"):AttackArea(n,inst,area_of_effect)
inst.components.rechargeable_spell:StartRecharge()
end;

local function Basic_Attack_fn(inst,owner,target)
local r=(target:GetPosition()-owner:GetPosition()):GetNormalized()*1.2;
local s=SpawnPrefab("forge_fireball_hit_fx")
s.Transform:SetPosition((owner:GetPosition()+r):Get())
s.AnimState:SetScale(0.8,0.8)end;

local function Get_Target_fn(inst,owner,target)
local meteor_position=inst.meteor:GetPosition()
local meteor_base_damage=TUNING.FORGE_ITEM_PACK.INFERNALSTAFF.ALT_DAMAGE.base;
local meteor_center_mult_damage=TUNING.FORGE_ITEM_PACK.INFERNALSTAFF.ALT_DAMAGE.center_mult;
local meteor_radius=16;
local gap_meteor_target=distsq(meteor_position,target:GetPosition())
local meteor_damage_modifier=math.max(0,1-gap_meteor_target/meteor_radius)
local meteor_total_damage=meteor_base_damage*(1+Lerp(0,meteor_center_mult_damage,meteor_damage_modifier))
return meteor_total_damage end;

local function OnAttack(inst,owner,target)
	if inst.components.weapon.isaltattacking then
		SpawnPrefab("infernalstaff_meteor_splashhit"):SetTarget(target)
	end
end;


local function fn()

local inst=CreateEntity()
inst.entity:AddTransform()
inst.entity:AddAnimState()
inst.entity:AddSoundEmitter()
inst.entity:AddNetwork()
MakeInventoryPhysics(inst)
inst.nameoverride="fireballstaff"
inst.AnimState:SetBank("fireballstaff")
inst.AnimState:SetBuild("fireballstaff")
inst.AnimState:PlayAnimation("idle")
inst:AddTag("firestaff")
inst:AddTag("magicweapon")
inst:AddTag("pyroweapon")
inst:AddTag("rangedweapon")
inst:AddTag("rechargeable")
inst:AddComponent("aoetargeting")
inst.components.aoetargeting.reticule.reticuleprefab="reticuleaoe"
inst.components.aoetargeting.reticule.pingprefab="reticuleaoeping"
inst.components.aoetargeting.reticule.targetfn=reticule_target_fn;
inst.components.aoetargeting.reticule.validcolour={1,.75,0,1}
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
inst:AddComponent("inspectable")
inst:AddComponent("inventoryitem")
inst.components.inventoryitem.imagename="fireballstaff"
inst:AddComponent("rechargeable_spell")
inst.components.rechargeable_spell:SetRechargeTime(TUNING.FORGE_ITEM_PACK.INFERNALSTAFF.COOLDOWN)
inst:AddComponent("reticule_spawner")
inst.components.reticule_spawner:Setup(unpack(TUNING.FORGE_ITEM_PACK.RET_DATA.infernalstaff))
inst:AddComponent("weapon")
inst.components.weapon:SetDamage(TUNING.FORGE_ITEM_PACK.INFERNALSTAFF.DAMAGE)
inst.components.weapon:SetOnAttack(OnAttack)
inst.components.weapon:SetRange(10,20)
inst.components.weapon:SetProjectile("forge_fireball_projectile")
inst.components.weapon:SetOnProjectileLaunch(Basic_Attack_fn)
inst.components.weapon:SetDamageType(DAMAGETYPES.MAGIC)
inst.components.weapon:SetStimuli("fire")
inst.components.weapon:SetAltAttack(TUNING.FORGE_ITEM_PACK.INFERNALSTAFF.ALT_DAMAGE.minimum,{10,20},nil,DAMAGETYPES.MAGIC,Get_Target_fn)return inst end;

return CustomPrefab("infernalstaff",fn,assets,prefabs,nil,"images/inventoryimages.xml","fireballstaff.tex",TUNING.FORGE_ITEM_PACK.INFERNALSTAFF,"swap_fireballstaff","common_hand")