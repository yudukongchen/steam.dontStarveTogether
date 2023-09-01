local a={Asset("ANIM","anim/hydra_meteor.zip")}
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

---------------------


local function f()
local inst=CreateEntity()

inst.entity:AddTransform()
inst.entity:AddAnimState()
inst.entity:AddNetwork()
inst.AnimState:SetBank("lavaarena_firestaff_meteor")
inst.AnimState:SetBuild("hydra_meteor")
inst.AnimState:PlayAnimation("crash")
--inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
inst:AddTag("FX")
inst:AddTag("NOCLICK")
inst:AddTag("notarget")
inst.entity:SetPristine()

if not TheWorld.ismastersim then
 return inst 
end;
 
--Meteor Damage
inst.AttackArea=function(inst,h,i,j)i.meteor=inst;
inst.attacker=h;
inst.owner=i;
inst.Transform:SetPosition(j:Get())end;
inst:ListenForEvent("animover",function(inst)
inst:DoTaskInTime(FRAMES*3,function(inst)SpawnPrefab("infernalstaff_meteor_splash"):SetPosition(inst:GetPosition())
local k={}
local l,m,n=inst:GetPosition():Get()

local ents=TheSim:FindEntities(l,m,n,e,nil,{"player","companion"})
for p,validtarget in ipairs(ents)do 
if inst.attacker~=nil and validtarget~=inst.attacker and validtarget.entity:IsValid()and validtarget.entity:IsVisible()and(validtarget.components.health and not validtarget.components.health:IsDead()or validtarget.components.workable and validtarget.components.workable:CanBeWorked()and validtarget.components.workable:GetWorkAction())then 
table.insert(k,validtarget)end 

if validtarget and validtarget.components.health and not validtarget.components.health:IsDead() then
	if validtarget.components.combat and validtarget.components.combat.target then
		validtarget.components.combat:SuggestTarget(inst.attacker)
	end
	ApplyBuff(Buffs["PoisonDebuff"], validtarget)
end
if validtarget and validtarget.components.health and not validtarget.components.health:IsDead() then
	validtarget.components.health:DoDelta(-100)
end

end;

if inst.owner.components.weapon and inst.owner.components.weapon:HasAltAttack()then
inst.owner.components.weapon:DoAltAttack(inst.attacker,k,nil,"explosive")
end;


-- inst.owner.components.aoespell:OnSpellCast(inst.attacker,ents)

-- if inst.owner.components.fueled then
	-- inst.owner.components.fueled:DoDelta(-10)
	-- -- if inst.owner.components.fueled.currentfuel <= 10 then
		-- -- inst.owner:RemoveComponent("aoetargeting")
		-- -- inst.owner:RemoveComponent("aoespell")
		-- -- inst.owner:RemoveComponent("reticule_spawner")
	-- -- end

	-- if inst.owner.components.fueled:IsEmpty() then
		-- --inst.owner:Remove()
		-- --inst.owner:DoTaskInTime(0.1, function() inst.owner:Remove() end)
		
		-- inst.owner.components.equippable.restrictedtag = "empty_weapon"
		-- inst.owner.components.inventoryitem.owner.components.inventory:DropItem(inst.owner.components.inventoryitem.owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS))
	-- end
-- end




inst:Remove()end)end)
inst.OnLoad=inst.Remove;
return inst 
end;

local function r()
local inst=CreateEntity()
inst.entity:AddTransform()
inst.entity:AddAnimState()
inst.entity:AddSoundEmitter()
inst.entity:AddNetwork()
inst.AnimState:SetBank("lavaarena_fire_fx")
inst.AnimState:SetBuild("lavaarena_fire_fx")
inst.AnimState:PlayAnimation("firestaff_ult")
--inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
inst.AnimState:SetFinalOffset(1)
inst:AddTag("FX")
inst:AddTag("NOCLICK")
inst.entity:SetPristine()

if not TheWorld.ismastersim then 
return inst 
end;

inst.SetPosition=function(inst,j)
inst.SoundEmitter:PlaySound("dontstarve/impacts/lava_arena/meteor_strike")
inst.Transform:SetPosition(j:Get())SpawnPrefab("infernalstaff_meteor_splashbase"):SetPosition(j)end;
inst:ListenForEvent("animover",inst.Remove)inst.OnLoad=inst.Remove;
return inst 
end;

local function s()
local inst=CreateEntity()
inst.entity:AddTransform()
inst.entity:AddAnimState()
inst.entity:AddNetwork()
inst.AnimState:SetBank("lavaarena_fire_fx")
inst.AnimState:SetBuild("lavaarena_fire_fx")
inst.AnimState:PlayAnimation("firestaff_ult_projection")
--inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
inst.AnimState:SetLayer(LAYER_BACKGROUND)
inst.AnimState:SetSortOrder(3)
inst:AddTag("FX")
inst:AddTag("NOCLICK")
inst.entity:SetPristine()

if not TheWorld.ismastersim then 
return inst 
end;

inst.SetPosition=function(inst,j)
inst.Transform:SetPosition(j:Get())end;
inst:ListenForEvent("animover",inst.Remove)
inst.OnLoad=inst.Remove;return inst end;

local function t()
local inst=CreateEntity()
inst.entity:AddTransform()
inst.entity:AddAnimState()
inst.entity:AddNetwork()
inst.AnimState:SetBank("lavaarena_fire_fx")
inst.AnimState:SetBuild("lavaarena_fire_fx")
inst.AnimState:PlayAnimation("firestaff_ult_hit")
--inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
inst.AnimState:SetFinalOffset(1)inst:AddTag("FX")
inst:AddTag("NOCLICK")
inst.entity:SetPristine()

if not TheWorld.ismastersim then 
return inst 
end;

inst.SetTarget=function(inst,u)
inst.Transform:SetPosition(u:GetPosition():Get())
local v=u:HasTag("minion")and.5 or(u:HasTag("largecreature")and 1.3 or.8)
inst.AnimState:SetScale(v,v)end;
inst:ListenForEvent("animover",inst.Remove)
inst.OnLoad=inst.Remove;return inst end;

return Prefab("hydra_meteor",f,a,c),Prefab("infernalstaff_meteor_splash",r,b,d),Prefab("infernalstaff_meteor_splashbase",s,b),Prefab("infernalstaff_meteor_splashhit",t,b)