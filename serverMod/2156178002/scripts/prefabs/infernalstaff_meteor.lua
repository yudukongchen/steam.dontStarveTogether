local a={Asset("ANIM","anim/lavaarena_firestaff_meteor.zip")}
local b={Asset("ANIM","anim/lavaarena_fire_fx.zip")}
local c={"infernalstaff_meteor_splash","infernalstaff_meteor_splashhit"}
local d={"infernalstaff_meteor_splashbase"}
local e=4.1;	--alt radius


------------------------------------
--Apply Poison
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

---------------------


local function f()
local g=CreateEntity()

g.entity:AddTransform()
g.entity:AddAnimState()
g.entity:AddNetwork()
g.AnimState:SetBank("lavaarena_firestaff_meteor")
g.AnimState:SetBuild("lavaarena_firestaff_meteor")
g.AnimState:PlayAnimation("crash")
--g.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
g:AddTag("FX")
g:AddTag("NOCLICK")
g:AddTag("notarget")
g.entity:SetPristine()

if not TheWorld.ismastersim then
 return g 
end;
 
--Meteor Damage
g.AttackArea=function(g,h,i,j)i.meteor=g;
g.attacker=h;
g.owner=i;
g.Transform:SetPosition(j:Get())end;
g:ListenForEvent("animover",function(g)
g:DoTaskInTime(FRAMES*3,function(g)SpawnPrefab("infernalstaff_meteor_splash"):SetPosition(g:GetPosition())
local k={}
local l,m,n=g:GetPosition():Get()

local o=TheSim:FindEntities(l,m,n,e,nil,{"player","companion"})
for p,q in ipairs(o)do 
if g.attacker~=nil and q~=g.attacker and q.entity:IsValid()and q.entity:IsVisible()and(q.components.health and not q.components.health:IsDead()or q.components.workable and q.components.workable:CanBeWorked()and q.components.workable:GetWorkAction())then 
table.insert(k,q)end 

if q and q.components.health and not q.components.health:IsDead() then
	ApplyBuff(Buffs["PoisonDebuff"], q)
end
end;

if g.owner.components.weapon and g.owner.components.weapon:HasAltAttack()then
g.owner.components.weapon:DoAltAttack(g.attacker,k,nil,"explosive")
end;
g.owner.components.finiteuses:Use(20)
g.owner.components.aoespell:OnSpellCast(g.attacker,o)
g:Remove()end)end)
g.OnLoad=g.Remove;
return g 
end;

local function r()
local g=CreateEntity()
g.entity:AddTransform()
g.entity:AddAnimState()
g.entity:AddSoundEmitter()
g.entity:AddNetwork()
g.AnimState:SetBank("lavaarena_fire_fx")
g.AnimState:SetBuild("lavaarena_fire_fx")
g.AnimState:PlayAnimation("firestaff_ult")
--g.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
g.AnimState:SetFinalOffset(1)
g:AddTag("FX")
g:AddTag("NOCLICK")
g.entity:SetPristine()

if not TheWorld.ismastersim then 
return g 
end;

g.SetPosition=function(g,j)
g.SoundEmitter:PlaySound("dontstarve/impacts/lava_arena/meteor_strike")
g.Transform:SetPosition(j:Get())SpawnPrefab("infernalstaff_meteor_splashbase"):SetPosition(j)end;
g:ListenForEvent("animover",g.Remove)g.OnLoad=g.Remove;
return g 
end;

local function s()
local g=CreateEntity()
g.entity:AddTransform()
g.entity:AddAnimState()
g.entity:AddNetwork()
g.AnimState:SetBank("lavaarena_fire_fx")
g.AnimState:SetBuild("lavaarena_fire_fx")
g.AnimState:PlayAnimation("firestaff_ult_projection")
--g.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
g.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
g.AnimState:SetLayer(LAYER_BACKGROUND)
g.AnimState:SetSortOrder(3)
g:AddTag("FX")
g:AddTag("NOCLICK")
g.entity:SetPristine()

if not TheWorld.ismastersim then 
return g 
end;

g.SetPosition=function(g,j)
g.Transform:SetPosition(j:Get())end;
g:ListenForEvent("animover",g.Remove)
g.OnLoad=g.Remove;return g end;

local function t()
local g=CreateEntity()
g.entity:AddTransform()
g.entity:AddAnimState()
g.entity:AddNetwork()
g.AnimState:SetBank("lavaarena_fire_fx")
g.AnimState:SetBuild("lavaarena_fire_fx")
g.AnimState:PlayAnimation("firestaff_ult_hit")
--g.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
g.AnimState:SetFinalOffset(1)g:AddTag("FX")
g:AddTag("NOCLICK")
g.entity:SetPristine()

if not TheWorld.ismastersim then 
return g 
end;

g.SetTarget=function(g,u)
g.Transform:SetPosition(u:GetPosition():Get())
local v=u:HasTag("minion")and.5 or(u:HasTag("largecreature")and 1.3 or.8)
g.AnimState:SetScale(v,v)end;
g:ListenForEvent("animover",g.Remove)
g.OnLoad=g.Remove;return g end;

return Prefab("infernalstaff_meteor",f,a,c),Prefab("infernalstaff_meteor_splash",r,b,d),Prefab("infernalstaff_meteor_splashbase",s,b),Prefab("infernalstaff_meteor_splashhit",t,b)