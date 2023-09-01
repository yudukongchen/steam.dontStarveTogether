local assets =
{
    Asset("ANIM", "anim/pangbaixiong.zip"),
}
local qdassets =
{
    Asset("ANIM", "anim/qdpangbaixiong.zip"),
	Asset("ATLAS", "images/inventoryimages/qdpangbaixiong.xml"),
}

local function DoAreaAttack(inst)
    inst.components.combat:DoAreaAttack(inst, 2, nil, nil, nil, { "INLIMBO" })
end

local function OnDeath(inst)
    RemovePhysicsColliders(inst)
		if inst.tzrainbolight ~=nil then
		inst.tzrainbolight:Remove()
		end
    inst.AnimState:PlayAnimation("lose")
    inst.SoundEmitter:PlaySound("dontstarve/common/balloon_pop")
    inst.DynamicShadow:Enable(false)
    inst:AddTag("NOCLICK")
    inst.persists = false
    local attack_delay = .1 + math.random() * .2
    local remove_delay = math.max(attack_delay, inst.AnimState:GetCurrentAnimationLength()) + FRAMES
    inst:DoTaskInTime(attack_delay, DoAreaAttack)
    inst:DoTaskInTime(remove_delay, inst.Remove)
end
local function oncollide(inst, other)    
    if (inst:IsValid() and Vector3(inst.Physics:GetVelocity()):LengthSq() > .1) or
        (other ~= nil and other:IsValid() and other.Physics ~= nil and Vector3(other.Physics:GetVelocity()):LengthSq() > .1) then
        inst.AnimState:PushAnimation("idle", true)
    end
end

local function OnHaunt(inst)
    inst.components.health:Kill()
    return true
end

local function colour(inst)
	if inst.ispink then
		inst.ispink = false
		inst.isorange = true 
		inst.Light:SetColour(241/255, 194/255, 50/255) --橙色
	elseif inst.isorange then
		inst.isorange = false 
		inst.isyellow = true 
		inst.Light:SetColour(240/255, 245/255, 0/255) --黄色
	elseif inst.isyellow then
		inst.isgreen = true
		inst.isyellow = false
		inst.Light:SetColour(0/255, 180/255, 0/255) --绿色
	elseif inst.isgreen  then
		inst.isblue = true
		inst.isgreen = false
		inst.Light:SetColour(0/255, 5/255, 245/255) --蓝
	elseif inst.isblue  then
		inst.isblue = false
		inst.isding = true
		inst.Light:SetColour(6/255, 82/255 , 121/255) --靛
	elseif  inst.isding then
		inst.isding = false
		inst.Light:SetColour(251/255, 0/255, 251/255) --紫
	else
		inst.ispink = true
		inst.Light:SetColour(251/255, 10/255, 10/255)  --红色
	end
end
local function TurnOff(inst)
	if	inst then
    inst.Physics:SetMass(25)
	end
end

local function TurnOn(inst)
	if	inst then
    inst.Physics:SetMass(100000)
	end
end

local function tzyifu(inst)
	if inst.components.tzmachine then
		if inst.components.tzmachine.ison == true then
			TurnOn(inst)
		else
			TurnOff(inst)
		end
	end	
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()
	inst.entity:AddLight()
    MakeCharacterPhysics(inst, 25, .2)
    inst.Physics:SetFriction(.3) 
    inst.Physics:SetDamping(0)  
    inst.Physics:SetRestitution(1)

    inst.AnimState:SetBank("pangbaixiong")
    inst.AnimState:SetBuild("pangbaixiong")
    inst.AnimState:PlayAnimation("idle", true)

    inst.DynamicShadow:SetSize(1, .5)
    inst.Light:SetFalloff(0.7)
    inst.Light:SetIntensity(.8)
    inst.Light:SetRadius(2.5)
	inst.Light:SetColour(255/255 , 255/255, 192/255)
    inst.Light:Enable(true)
	inst.ispink = true
	
    inst:AddTag("companion")
    inst:AddTag("character")
    inst:AddTag("notraptrigger")
    inst:AddTag("noauradamage")
    MakeInventoryFloatable(inst, "med", 0.2, {1.1, 0.5, 1.1})
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.Physics:SetCollisionCallback(oncollide)  

    inst.AnimState:SetTime(math.random() * 2)

    inst:AddComponent("inspectable")

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(5)
    inst:ListenForEvent("death", OnDeath)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(1)
    inst.components.health.nofadeout = true
	
    inst:AddComponent("hauntable")
    inst.components.hauntable.cooldown_on_successful_haunt = false
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    inst.components.hauntable:SetOnHauntFn(OnHaunt)

    inst:AddComponent("tzmachine")
    inst.components.tzmachine.turnonfn = TurnOn
    inst.components.tzmachine.turnofffn = TurnOff
    inst.components.tzmachine.cooldowntime = 0.5
	tzyifu(inst)
	inst:DoPeriodicTask(2, colour, 2)
    return inst
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle", true)
end

local function onhammered(inst, worker)
    inst.AnimState:PlayAnimation("lose")
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end
local function qdTurnOff(inst)
	if	inst then
    inst.Physics:SetMass(150)
	end
end
local function qdtzyifu(inst)
	if inst.components.tzmachine then
		if inst.components.tzmachine.ison == true then
			TurnOn(inst)
		else
			qdTurnOff(inst)
		end
	end	
end
local function qdfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 150, .2)
    inst.Physics:SetFriction(.3) 
    inst.Physics:SetDamping(0)  
    inst.Physics:SetRestitution(1)

    inst.AnimState:SetBank("qdpangbaixiong")
    inst.AnimState:SetBuild("qdpangbaixiong")
    inst.AnimState:PlayAnimation("idle", true)
    inst:AddTag("notraptrigger")
    inst:AddTag("noauradamage")
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst.Physics:SetCollisionCallback(oncollide)  
    inst:AddComponent("inspectable")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit) 

    inst:AddComponent("tzmachine")
    inst.components.tzmachine.turnonfn = TurnOn
    inst.components.tzmachine.turnofffn = qdTurnOff
    inst.components.tzmachine.cooldowntime = 0.5
	qdtzyifu(inst)
    return inst
end

return Prefab("pangbaixiong", fn, assets)
	--Prefab("qdpangbaixiong", qdfn, qdassets),
	--MakePlacer("qdpangbaixiong_placer", "qdpangbaixiong", "qdpangbaixiong", "place")
