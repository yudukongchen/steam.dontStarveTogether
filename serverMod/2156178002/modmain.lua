PrefabFiles = {
	"maple",
	"maple_none",
	
	"shield",
	"devourfx",
	
	"haloangel",
	
	"fuel_poison",	
	"moondagger",
	"infernalstaff_meteor",
	"hydra_meteor",
	
	"fuel_laser",	
	"mechacannon",
	"mechacannon_laser",

}

Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/maple.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/maple.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/maple.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/maple.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/maple_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/maple_silho.xml" ),

    Asset( "IMAGE", "bigportraits/maple.tex" ),
    Asset( "ATLAS", "bigportraits/maple.xml" ),
	
	Asset( "IMAGE", "images/map_icons/maple.tex" ),
	Asset( "ATLAS", "images/map_icons/maple.xml" ),
	
	Asset( "IMAGE", "images/map_icons/shield.tex" ),
	Asset( "ATLAS", "images/map_icons/shield.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_maple.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_maple.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_maple.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_maple.xml" ),
	
	Asset( "IMAGE", "images/avatars/self_inspect_maple.tex" ),
    Asset( "ATLAS", "images/avatars/self_inspect_maple.xml" ),
	
	Asset( "IMAGE", "images/names_maple.tex" ),
    Asset( "ATLAS", "images/names_maple.xml" ),
	
	Asset( "IMAGE", "images/names_gold_maple.tex" ),
    Asset( "ATLAS", "images/names_gold_maple.xml" ),
	
	Asset( "IMAGE", "images/inventoryimages/shield.tex" ),
	Asset( "ATLAS", "images/inventoryimages/shield.xml" ),
	
	Asset( "IMAGE", "images/inventoryimages/haloangel.tex" ),
	Asset( "ATLAS", "images/inventoryimages/haloangel.xml" ),
	
	Asset( "IMAGE", "images/inventoryimages/moondagger.tex" ),
	Asset( "ATLAS", "images/inventoryimages/moondagger.xml" ),
	
	Asset( "IMAGE", "images/inventoryimages/mechacannon.tex" ),
	Asset( "ATLAS", "images/inventoryimages/mechacannon.xml" ),
	
	Asset( "IMAGE", "images/inventoryimages/fuel_poison.tex" ),
	Asset( "ATLAS", "images/inventoryimages/fuel_poison.xml" ),
	
	Asset( "IMAGE", "images/inventoryimages/fuel_laser.tex" ),
	Asset( "ATLAS", "images/inventoryimages/fuel_laser.xml" ),
}

AddMinimapAtlas("images/map_icons/maple.xml")
AddMinimapAtlas("images/map_icons/shield.xml")

local _G = GLOBAL
local require = _G.require
local STRINGS = _G.STRINGS
local RecipeTabs = _G.RECIPETABS
local Tech = _G.TECH
local Ingredient = _G.Ingredient
local State = _G.State
local Action = _G.Action
local ActionHandler = _G.ActionHandler
local TimeEvent = _G.TimeEvent
local EventHandler = _G.EventHandler
local ACTIONS = _G.ACTIONS
local FRAMES = _G.FRAMES

env._G=_G;
env.require=_G.require;
env.STRINGS=_G.STRINGS;
env.ACTIONS=_G.ACTIONS;
env.FUELTYPE=_G.FUELTYPE;


-------------------------------------------------------------------------------------------------------------------------------------------------
--Forge Items Pack

require("mod_prefab")

_G.TUNING.FORGE_ITEM_PACK={
MOONDAGGER={DAMAGE=20,ALT_DAMAGE={base=200,center_mult=0.25},ALT_RADIUS=4.1,COOLDOWN=3,DURABILITY={AMOUNT=0,CONSUMPTION_NORMAL=1,CONSUMPTION_SPECIAL=5},WORKABLE_DMG=0,DISABLE_RECIPE=true},

SHIELD={DAMAGE=2,ALT_DAMAGE=0,ALT_RANGE=100,ALT_RADIUS=2.05,COOLDOWN=3,DURABILITY={AMOUNT=0,CONSUMPTION_SPECIAL=0},WORKABLE_DMG=0,DISABLE_RECIPE=true},

RET_DATA={
moondagger={"aoehostiletarget",0.7},
shield={"aoehostiletarget",0.5},
}
}

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local a=_G.json;
local b=_G.FRAMES;
local c=_G.EQUIPSLOTS;
local d=_G.STRINGS;
local e=_G.EventHandler;
local f=_G.State;
local g=_G.ACTIONS;
local h=_G.net_bool;
local i=_G.net_float;
local j=_G.net_string;
local k=_G.TheNet;

AddPrefabPostInit("inventoryitem_classified",function(l)
l.isaltattacking=h(l.GUID,"weapon.isaltattacking")
l.altattackrange=i(l.GUID,"weapon.altattackrange")end)

AddPrefabPostInit("player_classified",function(l)
l.net_buffs=j(l.GUID,"forge.net_buffs","net_buffs_dirty")if not k:IsDedicated()then 
l:ListenForEvent("net_buffs_dirty",function(l)if not l._parent or not l._parent.HUD or#l.net_buffs:value()<1 then return end;
l.net_buffs:set_local("")
l.net_buffs:set("")end)end end)AddPlayerPostInit(function(l)
l:AddComponent("buffable")if not l.components.colourfader then 
l:AddComponent("colourfader")end end)

function _G.EntityScript:GetDisplayName()
local m=self:GetAdjectivedName()
if self.prefab~=nil then 
local n=d.NAME_DETAIL_EXTENTION[string.upper(self.nameoverride~=nil and self.nameoverride or self.prefab)]if n~=nil then return m.."\n"..n end end;return m end;

_G.DAMAGETYPES={PHYSICAL=1,MAGIC=2}
_G.DAMAGETYPE_IDS={}for o,p in pairs(_G.DAMAGETYPES)do _G.DAMAGETYPE_IDS[p]=o end;

AddComponentPostInit("combat",function(self)
self.damage_override=nil;
self.damagetype=nil;
self.damagebuffs={dealt={dmgtype={},stimuli={},generic={}},recieved={dmgtype={},stimuli={},generic={}}}
function self:SetDamageType(q)self.damagetype=q end;
function self:HasDamageBuff(r,s,t)local u=self.damagebuffs[r and"recieved"or"dealt"][type(t)=="number"and"dmgtype"or(type(t)=="string"and"stimuli"or"generic")]if not t then 
if u[s]then return 
true end 
else if u[t]and u[t][s]then 
return true end end end;

function self:AddDamageBuff(r,s,v)if not self:HasDamageBuff(r,s)then 
self.damagebuffs[r and"recieved"or"dealt"].generic[s]=v end end;
function self:AddDamageTypeBuff(r,w,s,v)if not self:HasDamageBuff(r,s,w)then
local u=self.damagebuffs[r and"recieved"or"dealt"].dmgtype;if not u[w]then u[w]={}end;u[w][s]=v end end;
function self:AddDamageStimuliBuff(r,x,s,v)if not self:HasDamageBuff(r,s,x)then 
local u=self.damagebuffs[r and"recieved"or"dealt"].stimuli;
if not u[x]then u[x]={}end;
u[x][s]=v end end;
function self:RemoveDamageBuff(r,s,t)if self:HasDamageBuff(r,s,t)then 
local u=self.damagebuffs[r and"recieved"or"dealt"][type(t)=="number"and"dmgtype"or(type(t)=="string"and"stimuli"or"generic")]if not t then 
u[s]=nil else u[t][s]=nil;if _G.GetTableSize(u[t])<1 then u[t]=nil end end end end;
function self:CopyBuffsTo(y)
if y and y.components.combat then 
y.components.combat.damagebuffs=self.damagebuffs end end;
function self:HasDamageBuff(r,s,t)
local u=self.damagebuffs[r and"recieved"or"dealt"][type(t)=="number"and"dmgtype"or(type(t)=="string"and"stimuli"or"generic")]if not t then
 return u[s]~=nil else return u[t]~=nil and u[t][s]~=nil end end;_oldGetAttackRange=self.GetAttackRange;function self:GetAttackRange()
 local z=self:GetWeapon()if z and z.components.weapon:CanAltAttack()then 
 return z.components.weapon.altattackrange else 
 return _oldGetAttackRange(self)end end;
 _oldGetHitRange=self.GetHitRange;
 function self:GetHitRange()
 local z=self:GetWeapon()
 if z and z.components.weapon:CanAltAttack()then 
return self.attackrange+z.components.weapon.althitrange else 
return _oldGetHitRange(self)end end;
_oldCalcDamage=self.CalcDamage;
function self:CalcDamage(A,z,B)
if A:HasTag("alwaysblock")then 
return 0 end;
local C=_oldCalcDamage(self,A,z,B)
local D=z~=nil and z.components.weapon.damage or self.defaultdamage;
if z and z.components.weapon:CanAltAttack()or not z and self.damage_override then 
local E=0;
if z then
 E=z.components.weapon.altdamagecalc~=nil and z.components.weapon.altdamagecalc(z,self.inst,A)or(z.components.weapon.altdamage or D)
else E=type(self.damage_override)=="function"and self.damage_override(self.inst,A)or self.damage_override end;
C=(C-(self.damagebonus or 0))/D;C=C*E+(self.damagebonus or 0)end;
return C end;
local function F(r,G,H,z,x)
local I=1;
local J=1;
local K={common={additive={},multiplicative={}},overrides={additive={},multiplicative={}}}for t,p in pairs(self.damagebuffs[r and"recieved"or"dealt"])do for o,v in pairs(p)do local z=z or self:GetWeapon()
local L=z~=nil and z.components.weapon or self;if t=="generic"or t=="stimuli"and x==o or t=="dmgtype"and L.damagetype and L.damagetype==_G.DAMAGETYPES[_G.DAMAGETYPE_IDS[o]]then 
if t=="generic"then if type(v)=="function"then 
local M,N,O=v(G,H,z,x)K[O and"overrides"or"common"][N and"multiplicative"or"additive"][o]=M else K.common.additive[o]=v end else for P,Q in pairs(v)do if type(Q)=="function"then 
local M,N,O=Q(G,H,z,x)K[O and"overrides"or"common"][N and"multiplicative"or"additive"][P]=M else K.common.additive[P]=Q end end end end end end;local R=false;
if _G.GetTableSize(K.overrides.additive)>0 or _G.GetTableSize(K.overrides.multiplicative)>0 then R=true end;for S,v in pairs(K[R and"overrides"or"common"].multiplicative)do if v then J=J*v end end;
for S,v in pairs(K[R and"overrides"or"common"].additive)do if v then I=I*(v+1)end end;if I==0 then I=1 end;
if J==0 then J=1 end;
return I,J end;
function self:GetBuffMults(r,G,H,z,x)
return F(r,G,H,z,x)end;
_oldDoAttack=self.DoAttack;
function self:DoAttack(T,z,U,x,V)
local I,J=F(false,self.inst,T or self.target,z,x)
local W=(V or 1)*J*I;_oldDoAttack(self,T,z,U,x,W)end;
_oldGetAttacked=self.GetAttacked;
function self:GetAttacked(G,X,z,x)
local I,J=F(true,G,self.inst,z,x)X=X*J*I;
return _oldGetAttacked(self,G,X,z,x)end;

function self:DoAreaAttack(A,Y,z,Z,x,_)local a0=0;
local a1,a2,a3=A.Transform:GetWorldPosition()
local a4=_G.TheSim:FindEntities(a1,a2,a3,Y,{"_combat"},_)
for P,y in ipairs(a4)do if y~=A and y~=self.inst and self:IsValidTarget(y)and(Z==nil or Z(y,self.inst))then 
self.inst:PushEvent("onareaattackother",{target=y,weapon=z,stimuli=x})

local J=(self.areahitdamagepercent or 1)+F(false,self.inst,y,z,x)y.components.combat:GetAttacked(self.inst,self:CalcDamage(y,z,J),z,x)a0=a0+1 end end;
return a0 end;function self:DoSpecialAttack(C,T,x,V,a5)self.damage_override=C;if a5 then self:DoAreaAttack(a5.target,a5.range,nil,a5.validfn,x,a5.excludetags)
else self:DoAttack(T,nil,nil,x,V)end;self.damage_override=nil end end)AddComponentPostInit("weapon",function(self)self.hasaltattack=false;self.isaltattacking=false;
self.altattackrange=nil;self.althitrange=nil;self.altdamage=nil;self.altdamagecalc=nil;self.altcondition=nil;self.altprojectile=nil;self._projectile=nil;self.damagetype=nil;self.altdamagetype=nil;self._damagetype=nil;function self:SetDamageType(q)self.damagetype=q;self._damagetype=q end;function self:SetStimuli(x)self.stimuli=x end;
function self:SetProjectile(U)self.projectile=U;self._projectile=U end;function self:SetAltAttack(X,Y,a6,q,a7,a8)self.hasaltattack=true;self.altdamage=X~=nil and X or self.damage;if Y~=nil then 
self.altattackrange=type(Y)=="table"and Y[1]or Y or self.attackrange;self.althitrange=type(Y)=="table"and Y[2]or self.altattackrange else self.altattackrange=20;self.althitrange=20 end;self.altprojectile=a6;self.altdamagetype=q~=nil and q or self.damagetype;self.altdamagecalc=a7;self.altcondition=a8;
if self.altdamagecalc then local a9=self.altdamagecalc;self.altdamagecalc=function(z,G,A)local C=a9(z,G,A)return C~=nil and C or self.altdamage end end;if self.inst.replica.inventoryitem then self.inst.replica.inventoryitem:SetAltAttackRange(self.altattackrange)end end;function self:SetIsAltAttacking(aa,ab)self.isaltattacking=aa;if self.inst.replica.inventoryitem then self.inst.replica.inventoryitem:SetIsAltAttacking(aa)end;if aa then self.projectile=self.altprojectile;self.damagetype=self.altdamagetype else self.projectile=self._projectile;self.damagetype=self._damagetype end end;function self:HasAltAttack()return self.hasaltattack end;function self:CanAltAttack()if self:HasAltAttack()and self.isaltattacking then return self.altcondition~=nil and self.altcondition(self.inst)or true end end;_oldCanRangedAttack=self.CanRangedAttack;function self:CanRangedAttack()return self:CanAltAttack()and self.altprojectile or _oldCanRangedAttack(self)end;function self:DoAltAttack(G,T,U,x,V)self:SetIsAltAttacking(true,true)if G and G.components.combat and self:CanAltAttack()then if T and type(T)=="table"and not T.prefab then for S,y in ipairs(T)do if y~=G and y.entity:IsValid()and y.components.workable~=nil and self.inst.IsWorkableAllowed~=nil and type(self.inst.IsWorkableAllowed)=="function"and self.inst:IsWorkableAllowed(y.components.workable:GetWorkAction(),y)then local ac=self.inst.prefab:upper()if _G.TUNING.FORGE_ITEM_PACK[ac]~=nil and _G.TUNING.FORGE_ITEM_PACK[ac].WORKABLE_DMG~=nil then y.components.workable:WorkedBy(G,_G.TUNING.FORGE_ITEM_PACK[ac].WORKABLE_DMG)end end;if y~=G and G.components.combat:IsValidTarget(y)and y.components.health and not y.components.health:IsDead()then G.components.combat:DoAttack(y,self.inst,U,x,V)end end else if G.components.combat:IsValidTarget(T)then G.components.combat:DoAttack(T,self.inst,U,x,V)end end end;G:PushEvent("alt_attack_complete",{weapon=self.inst})self:SetIsAltAttacking(false,true)end end)AddComponentPostInit("health",function(self)self.buffs={}function self:GetHealthBuff()local ad=0;for s,v in pairs(self.buffs)do ad=ad+v end;return ad end;function self:HasHealthBuff(s)return self.buffs[s]end;function self:AddHealthBuff(s,v)if not self:HasHealthBuff(s)then self.buffs[s]=v;self.maxhealth=self.maxhealth+self:GetHealthBuff()self.currenthealth=self.currenthealth+self:GetHealthBuff()end end;function self:RemoveHealthBuff(s)if self:HasHealthBuff(s)then self.currenthealth=math.max(self.minhealth,self.currenthealth-self.buffs[s])self.maxhealth=math.max(self.minhealth,self.maxhealth-self.buffs[s])self.buffs[s]=nil end end end)AddComponentPostInit("equippable",function(self)self.uniquebuffs={}self.damagebuffs={dealt={dmgtype={},stimuli={},generic={}},recieved={dmgtype={},stimuli={},generic={}}}self.healthbuffs={}function self:HasHealthBuff(s)return self.healthbuffs[s]~=nil end;function self:AddHealthBuff(s,v)if not self:HasHealthBuff(s)then local ae=self.inst.components.inventoryitem.owner;if ae.components.health then ae.components.health:AddHealthBuff(s,v)end end end;function self:RemoveHealthBuff(s)if self:HasHealthBuff(s)then self.healthbuffs[s]=nil;local ae=self.inst.components.inventoryitem.owner;if ae.components.health then ae.components.health:RemoveHealthBuff(s)end end end;function self:HasDamageBuff(r,s,t)local u=self.damagebuffs[r and"recieved"or"dealt"][type(t)=="number"and"dmgtype"or(type(t)=="string"and"stimuli"or"generic")]if not t then if u[s]then return true end else if u[t]and u[t][s]then return true end end end;function self:AddDamageBuff(r,s,v)if not self:HasDamageBuff(r,s)then self.damagebuffs[r and"recieved"or"dealt"].generic[s]=v;if self:IsEquipped()then local ae=self.inst.components.inventoryitem.owner;if ae.components.combat then ae.components.combat:AddDamageBuff(r,s,v)end end end end;function self:AddDamageTypeBuff(r,w,s,v)if not self:HasDamageBuff(r,s,w)then local u=self.damagebuffs[r and"recieved"or"dealt"].dmgtype;if not u[w]then u[w]={}end;u[w][s]=v;if self:IsEquipped()then local ae=self.inst.components.inventoryitem.owner;if ae.components.combat then ae.components.combat:AddDamageTypeBuff(r,w,s,v)end end end end;function self:AddDamageStimuliBuff(r,x,s,v)if not self:HasDamageBuff(r,s,x)then local u=self.damagebuffs[r and"recieved"or"dealt"].stimuli;if not u[x]then u[x]={}end;u[x][s]=v;if self:IsEquipped()then local ae=self.inst.components.inventoryitem.owner;if ae.components.combat then ae.components.combat:AddDamageStimuliBuff(r,x,s,v)end end end end;function self:RemoveDamageBuff(r,s,t)if self:HasDamageBuff(r,s,t)then local u=self.damagebuffs[r and"recieved"or"dealt"][type(t)=="number"and"dmgtype"or(type(t)=="string"and"stimuli"or"generic")]if not t then u[s]=nil else u[t][s]=nil;if _G.GetTableSize(u[t])<1 then u[t]=nil end end;if self:IsEquipped()then local ae=self.inst.components.inventoryitem.owner;if ae.components.combat then ae.components.combat:RemoveDamageBuff(r,s,t)end end end end;function self:AddBuffsTo(ae)if ae and ae.components.buffable then ae.components.buffable:AddBuff(self.inst.prefab,self.uniquebuffs)end end;function self:RemoveBuffsFrom(ae)if ae and ae.components.buffable then ae.components.buffable:RemoveBuff(self.inst.prefab)end end;function self:AddUniqueBuff(af)for t,v in pairs(af)do self.uniquebuffs[t]=v end;if self:IsEquipped()then local ae=self.inst.components.inventoryitem.owner;self:AddBuffsTo(ae)end end;function self:RemoveUniqueBuff(t)self.uniquebuffs[t]=nil;if self:IsEquipped()then local ae=self.inst.components.inventoryitem.owner;self:AddBuffsTo(ae)end end;local ag=self.Equip;function self:Equip(ae)if ae.components.combat then for P,af in pairs(self.damagebuffs)do for o,K in pairs(af)do for t,v in pairs(K)do if o=="generic"then ae.components.combat:AddDamageBuff(P=="recieved",t,v)else for ah,ai in pairs(v)do if o=="dmgtype"then ae.components.combat:AddDamageTypeBuff(P=="recieved",t,ah,ai)else ae.components.combat:AddDamageStimuliBuff(P=="recieved",t,ah,ai)end end end end end end end;self:AddBuffsTo(ae)ag(self,ae)end;local aj=self.Unequip;function self:Unequip(ae)if ae.components.combat then for P,af in pairs(self.damagebuffs)do for o,K in pairs(af)do for t,v in pairs(K)do if o=="generic"then ae.components.combat:RemoveDamageBuff(P=="recieved",t)else for s,S in pairs(v)do ae.components.combat:RemoveDamageBuff(P=="recieved",s,t)end end end end end end;self:RemoveBuffsFrom(ae)aj(self,ae)end end)AddClassPostConstruct("components/inventoryitem_replica",function(self)self.can_altattack_fn=function()return true end;function self:SetIsAltAttacking(aa)self.classified.isaltattacking:set(aa)end;function self:SetAltAttackRange(Y)self.classified.altattackrange:set(Y or self:AttackRange())end;function self:AltAttackRange()if self.inst.components.weapon then return self.inst.components.weapon.altattackrange elseif self.classified~=nil then return math.max(0,self.classified.altattackrange:value())else return self:AttackRange()end end;function self:SetAltAttackCheck(ak)if ak and type(ak)=="function"then self.can_altattack_fn=ak end end;function self:CanAltAttack()if self.classified.isaltattacking:value()then return self.inst.components.weapon and self.components.weapon:CanAltAttack()or self.can_altattack_fn(self.inst)end end;_oldAttackRange=self.AttackRange;function self:AttackRange()return self:CanAltAttack()and self:AltAttackRange()or _oldAttackRange(self)end end)AddClassPostConstruct("components/combat_replica",function(self)local al=self.CanBeAttacked;function self:CanBeAttacked(G)if TUNING.PREVENT_COMPAGNION_ATTACK and(self.inst:HasTag("companion")and G and G:HasTag("player"))then return false end;return al(self,G)end end)local function am(l,an)local ao={livingstaff="heal_staff",moondagger="fireball"}if ao[an.prefab]then l.sg.statemem.projectilesound="dontstarve/common/lava_arena/"..ao[an.prefab]end end;AddStategraphPostInit("wilson",function(self)local ap=self.states.attack.onenter;self.states.attack.onenter=function(l)local an=l.components.inventory:GetEquippedItem(c.HANDS)if an then am(l,an)end;ap(l)end;local aq=self.actionhandlers[g.CASTAOE].deststate;self.actionhandlers[g.CASTAOE].deststate=function(l,ar)if ar.invobject:HasTag("parry")then return"parry_pre"end;return aq(l,ar)end end)AddStategraphPostInit("wilson_client",function(self)local ap=self.states.attack.onenter;self.states.attack.onenter=function(l)local an=l.replica.inventory:GetEquippedItem(c.HANDS)if an then am(l,an)end;ap(l)end;local aq=self.actionhandlers[g.CASTAOE].deststate;self.actionhandlers[g.CASTAOE].deststate=function(l,ar)if ar.invobject:HasTag("parry")then return"parry_pre"end;return aq(l,ar)end end)AddComponentPostInit("debuffable",function(self)local as=self.AddDebuff;local at=self.RemoveDebuff;function self:AddDebuff(m,...)if self.debuffs[m]==nil and self.inst.player_classified then self.inst.player_classified.net_buffs:set(a.encode({name=m,removed=false}))end;as(self,m,...)end;function self:RemoveDebuff(m,...)if self.debuffs[m]~=nil and self.inst.player_classified then self.inst.player_classified.net_buffs:set(a.encode({name=m,removed=true}))end;at(self,m,...)end end)local au={book=25*b,castspell=53*b}

local ac=function(...)end;

for av,aw in pairs(au)do AddStategraphPostInit("wilson",function(self)
local ax,ay,az=self.states[av].onenter or ac,self.states[av].onexit or ac,self.states[av].onupdate or ac;
self.states[av].onenter=function(l)
l.sg.statemem.tm=0;
l.sg.statemem.trgt=aw;
l.sg.statemem.equip=l.components.inventory:GetEquippedItem(c.HANDS)
ax(l)end;
self.states[av].onexit=function(l)if not l.sg.statemem.equip then return end;
if l.sg.statemem.tm<l.sg.statemem.trgt and l.sg.statemem.equip.components.reticule_spawner then 
l.sg.statemem.equip.components.reticule_spawner:Interrupt()end;
ay(l)end;
self.states[av].onupdate=function(l,aA)
l.sg.statemem.tm=l.sg.statemem.tm+aA;
az(l)end end)end;

local aB={"spider","spider_warrior","tentacle","hound","firehound","icehound","krampus","knight","bishop","rook","knight_nightmare","bishop_nightmare","rook_nightmare","spider_hider","spider_spitter","spider_dropper","bat","worm","spat","eyeplant","walrus","little_walrus","monkey","slurper","tallbird","frog","mosquito","bee","killerbee","pigguard","moonpig","merm","leif","leif_sparse","spiderqueen","deerclops","minotaur","warg","birchnutdrake","deciduoustree","bearger","moose","dragonfly","lavae","beeguard","cookiecutter","mutatedhound","houndcorpse","mutated_penguin","spider_moon","beequeen","klaus","stalker","stalker_forest","stalker_atrium","malbatross","pigman","koalefant_summer","koalefant_winter","slurtle","snurtle","beefalo","penguin","bunnyman","rocky","lightninggoat","catcoon","buzzard","mossling","antlion","gestalt","gnarwail","gnarwail_attack_horn","fruitdragon","squid","player"}
for S,aC in ipairs(aB)do AddPrefabPostInit(aC,function(l)if l.components and l.components.combat then 
l.components.combat:SetDamageType(1)end 
end)
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



local FUELTYPE = GLOBAL.FUELTYPE
FUELTYPE.MOONDAGGER_FUELTYPE = "MOONDAGGER_FUELTYPE"
AddPrefabPostInit("fuel_poison", function(inst)
	if not inst.components.fuel then
		inst:AddComponent("fuel")
	end
	inst.components.fuel.fueltype = FUELTYPE.MOONDAGGER_FUELTYPE
end)

local FUELTYPE = GLOBAL.FUELTYPE
FUELTYPE.MECHACANNON_FUELTYPE = "MECHACANNON_FUELTYPE"
AddPrefabPostInit("fuel_laser", function(inst)
	if not inst.components.fuel then
		inst:AddComponent("fuel")
	end
	inst.components.fuel.fueltype = FUELTYPE.MECHACANNON_FUELTYPE
end)



-- local FOODTYPE = GLOBAL.FOODTYPE
-- FOODTYPE.HALOANGEL_FOODTYPE = "HALOANGEL_FOODTYPE"
-- function EdibleCompPostInit(comp)
	-- old_OnRemoveFromEntity = comp.OnRemoveFromEntity
	-- comp.OnRemoveFromEntity = function(self)
		-- old_OnRemoveFromEntity(self)
		-- self.inst:RemoveTag("edible_"..FOODTYPE.HALOANGEL_FOODTYPE)
	-- end
-- end
-- AddComponentPostInit("edible", EdibleCompPostInit)
-- AddPrefabPostInit("goldnugget", function(inst)
	-- inst:AddTag("edible_"..FOODTYPE.HALOANGEL_FOODTYPE)
-- end)


-- The character select screen lines
STRINGS.CHARACTER_TITLES.maple = "The Unbalanced"
STRINGS.CHARACTER_NAMES.maple = "Maple"
STRINGS.CHARACTER_DESCRIPTIONS.maple = "*Maxing Defense\n*Has a Shield that Devour Enemies\n*Can Poison Enemies\n*Can Become an Angel!\n*Can Fire Lasers?!"
STRINGS.CHARACTER_QUOTES.maple = "\"I don't want to get hurt, so i'll max out my defense.\""
STRINGS.CHARACTER_SURVIVABILITY.maple = "Slim"

TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.MAPLE = {
    "shield"
}
TUNING.STARTING_ITEM_IMAGE_OVERRIDE["shield"] = {
    atlas = "images/inventoryimages/shield.xml",
    image = "shield.tex",
}



-- Custom speech strings
STRINGS.CHARACTERS.MAPLE = require "speech_maple"

-- The character's name as appears in-game 
STRINGS.NAMES.MAPLE = "Maple"
STRINGS.SKIN_NAMES.maple_none = "Maple"

_G.STRINGS.NAMES.SHIELD = "Replica of the Dark Night"
STRINGS.RECIPE_DESC.SHIELD = "Just in case you lose it."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SHIELD = "I want a shield too."
STRINGS.CHARACTERS.MAPLE.DESCRIBE.SHIELD = "It will protect me!"

_G.STRINGS.NAMES.HALOANGEL = "Loving Sacrifice"
STRINGS.RECIPE_DESC.HALOANGEL = "Protect your friends!"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HALOANGEL = "What a weird lantern."
STRINGS.CHARACTERS.MAPLE.DESCRIBE.HALOANGEL = "I can protect them."

_G.STRINGS.NAMES.MOONDAGGER = "Crescent Moon"
STRINGS.RECIPE_DESC.MOONDAGGER = "Deals poison damage."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MOONDAGGER = "Sadistic."
STRINGS.CHARACTERS.MAPLE.DESCRIBE.MOONDAGGER = "It shines in the starry night."
	
_G.STRINGS.NAMES.MECHACANNON = "Machine God"
STRINGS.RECIPE_DESC.MECHACANNON = "Fires big lasers."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MECHACANNON = "Wait that's OP."
STRINGS.CHARACTERS.MAPLE.DESCRIBE.MECHACANNON = "It should be enought."

_G.STRINGS.NAMES.FUEL_POISON = "Poison Dose"
STRINGS.RECIPE_DESC.FUEL_POISON = "Reloads Crescent Moon."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FUEL_POISON = "Another useless item."
STRINGS.CHARACTERS.MAPLE.DESCRIBE.FUEL_POISON = "Since when do I have to craft this?"

_G.STRINGS.NAMES.FUEL_LASER = "Laser Battery"
STRINGS.RECIPE_DESC.FUEL_LASER = "Reloads Machine God."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FUEL_LASER = "Another useless item."
STRINGS.CHARACTERS.MAPLE.DESCRIBE.FUEL_LASER = "It will reload the cannon."
	
local character_ingredient = _G.CHARACTER_INGREDIENT
--AddRecipe(name, ingredients, tab, level, placer, min_spacing, nounlock, numtogive, builder_tag, atlas, image, testfn, product)

--Configuration values from modinfo.lua to constants
TUNING.MAPLE_BASE_HEALTH = GetModConfigData("MAPLE_BASE_HEALTH")
TUNING.MAPLE_BASE_HUNGER = GetModConfigData("MAPLE_BASE_HUNGER")
TUNING.MAPLE_BASE_SANITY = GetModConfigData("MAPLE_BASE_SANITY")
TUNING.MAPLE_MAXIMUM_HEALTH = GetModConfigData("MAPLE_MAXIMUM_HEALTH")
TUNING.MAPLE_LVLUP = GetModConfigData("MAPLE_LVLUP")
TUNING.MAPLE_SPEED = GetModConfigData("MAPLE_SPEED")
TUNING.MAPLE_EAT = GetModConfigData("MAPLE_EAT")
TUNING.MAPLE_DEVOUR = GetModConfigData("MAPLE_DEVOUR")
TUNING.MAPLE_PROTECTION = GetModConfigData("MAPLE_PROTECTION")
TUNING.MAPLE_HALO = GetModConfigData("MAPLE_HALO")
TUNING.MAPLE_HALO_PROTECTION = GetModConfigData("MAPLE_HALO_PROTECTION")
TUNING.MAPLE_POISON = GetModConfigData("MAPLE_POISON")
TUNING.MAPLE_LASER_DAMAGE = GetModConfigData("MAPLE_LASER_DAMAGE")
TUNING.MAPLE_LASER_AMMO = GetModConfigData("MAPLE_LASER_AMMO")

--This is the values you see in character selection
TUNING.MAPLE_HEALTH = TUNING.MAPLE_BASE_HEALTH
TUNING.MAPLE_HUNGER = TUNING.MAPLE_BASE_HUNGER
TUNING.MAPLE_SANITY = TUNING.MAPLE_BASE_SANITY


local shield = AddRecipe("shield", { Ingredient("cutstone", 2), Ingredient("charcoal", 3) }, RecipeTabs.WAR, Tech.SCIENCE_NONE, nil, nil, nil, nil, "maple")
shield.atlas = "images/inventoryimages/shield.xml"
local haloangel = AddRecipe("haloangel", { Ingredient("goldnugget", 6), Ingredient(character_ingredient.HEALTH, 40) }, RecipeTabs.WAR, Tech.SCIENCE_NONE, nil, nil, nil, nil, "maple")
haloangel.atlas = "images/inventoryimages/haloangel.xml"
local moondagger = AddRecipe("moondagger", { Ingredient("twigs", 2), Ingredient("moonrocknugget", 1), Ingredient("fuel_poison", 1, "images/inventoryimages/fuel_poison.xml") }, RecipeTabs.WAR, Tech.SCIENCE_NONE, nil, nil, nil, nil, "maple")
moondagger.atlas = "images/inventoryimages/moondagger.xml"
local fuel_poison = AddRecipe("fuel_poison", { Ingredient("spoiled_food", 1), Ingredient("red_cap", 1), Ingredient("spidergland", 1) }, RecipeTabs.REFINE, Tech.SCIENCE_NONE, nil, nil, nil, nil, "maple")
fuel_poison.atlas = "images/inventoryimages/fuel_poison.xml"
local mechacannon = AddRecipe("mechacannon", { Ingredient("marble", 4), Ingredient("gears", 1), Ingredient("fuel_laser", 1, "images/inventoryimages/fuel_laser.xml") }, RecipeTabs.WAR, Tech.SCIENCE_NONE, nil, nil, nil, nil, "maple")
mechacannon.atlas = "images/inventoryimages/mechacannon.xml"
local fuel_laser = AddRecipe("fuel_laser", { Ingredient("transistor", 1), Ingredient("redgem", 1) }, RecipeTabs.REFINE, Tech.SCIENCE_NONE, nil, nil, nil, nil, "maple")
fuel_laser.atlas = "images/inventoryimages/fuel_laser.xml"


-------------------------
--Random code gathering

--your only option is netvars, if you only need it for players, your best bet is PrefabPostInit-ing the player_classified and adding them there,
--along with the event pushing/receiving to get the data out/in, you should be able to fairly easily see how to make that work by looking at player_classified.

--RPC like ThePlayer:PushEvent("someevent", {--[[useful data]]}) and properly listening for that event inside the classified would work. 


-------------------------













-- Add mod character to mod character list. Also specify a gender. Possible genders are MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL.
AddModCharacter("maple", "FEMALE")